Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7413F10719F
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 12:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfKVLmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 06:42:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:15289 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbfKVLmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 06:42:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 03:42:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,229,1571727600"; 
   d="scan'208";a="358110518"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by orsmga004.jf.intel.com with ESMTP; 22 Nov 2019 03:42:28 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, jean-philippe.brucker@arm.com,
        peterx@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits alloc/free
Date:   Thu, 21 Nov 2019 19:23:45 +0800
Message-Id: <1574335427-3763-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch add a user numer track for the shared cap/ecap_perms bits,
and the alloc/free will hold a semaphore to protect the operations.
With the changes, first caller of vfio_pci_init_perm_bits() will
initialize the bits. While the last caller of vfio_pci_uninit_perm_bits()
will free the bits. This is a preparation to have multiple cap/ecap_perms
bits users.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index f0891bd..274c993 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -36,6 +36,13 @@
 	 (offset >= PCI_ROM_ADDRESS && offset < PCI_ROM_ADDRESS + 4))
 
 /*
+ * vfio_perm_bits_sem: prorects the shared perm_bits alloc/free
+ * vfio_pci_perm_bits_users: tracks the user of the shared perm_bits
+ */
+static DEFINE_SEMAPHORE(vfio_perm_bits_sem);
+static int vfio_pci_perm_bits_users;
+
+/*
  * Lengths of PCI Config Capabilities
  *   0: Removed from the user visible capability list
  *   FF: Variable length
@@ -995,7 +1002,7 @@ static int __init init_pci_ext_cap_pwr_perm(struct perm_bits *perm)
 /*
  * Initialize the shared permission tables
  */
-void vfio_pci_uninit_perm_bits(void)
+static void vfio_pci_uninit_perm_bits_internal(void)
 {
 	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
 
@@ -1009,10 +1016,30 @@ void vfio_pci_uninit_perm_bits(void)
 	free_perm_bits(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
 }
 
+void vfio_pci_uninit_perm_bits(void)
+{
+	down(&vfio_perm_bits_sem);
+
+	if (--vfio_pci_perm_bits_users > 0)
+		goto out;
+
+	vfio_pci_uninit_perm_bits_internal();
+
+out:
+	up(&vfio_perm_bits_sem);
+}
+
 int __init vfio_pci_init_perm_bits(void)
 {
 	int ret;
 
+	down(&vfio_perm_bits_sem);
+
+	if (++vfio_pci_perm_bits_users > 1) {
+		ret = 0;
+		goto out;
+	}
+
 	/* Basic config space */
 	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
 
@@ -1030,8 +1057,10 @@ int __init vfio_pci_init_perm_bits(void)
 	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
 
 	if (ret)
-		vfio_pci_uninit_perm_bits();
+		vfio_pci_uninit_perm_bits_internal();
 
+out:
+	up(&vfio_perm_bits_sem);
 	return ret;
 }
 
-- 
2.7.4

