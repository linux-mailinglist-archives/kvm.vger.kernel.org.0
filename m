Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833A3AB3E3
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391688AbfIFIRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:17:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:23720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391410AbfIFIRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:17:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 01:17:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,472,1559545200"; 
   d="scan'208";a="383186173"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Sep 2019 01:17:40 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yan.y.zhao@intel.com, shaopeng.he@intel.com,
        chenbo.xia@intel.com, jun.j.tian@intel.com
Subject: [PATCH v2 08/13] vfio/pci: protect cap/ecap_perm bits alloc/free with atomic op
Date:   Thu,  5 Sep 2019 15:59:25 +0800
Message-Id: <1567670370-4484-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a case in which cap_perms and ecap_perms can be reallocated
by different modules. e.g. the vfio-mdev-pci sample driver. To secure
the initialization of cap_perms and ecap_perms, this patch adds an
atomic variable to track the user of cap/ecap_perms bits. First caller
of vfio_pci_init_perm_bits() will initialize the bits. While the last
caller of vfio_pci_uninit_perm_bits() will free the bits.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index f0891bd..1b3e6e5 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -992,11 +992,17 @@ static int __init init_pci_ext_cap_pwr_perm(struct perm_bits *perm)
 	return 0;
 }
 
+/* Track the user number of the cap/ecap perm_bits */
+atomic_t vfio_pci_perm_bits_users = ATOMIC_INIT(0);
+
 /*
  * Initialize the shared permission tables
  */
 void vfio_pci_uninit_perm_bits(void)
 {
+	if (atomic_dec_return(&vfio_pci_perm_bits_users))
+		return;
+
 	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
 
 	free_perm_bits(&cap_perms[PCI_CAP_ID_PM]);
@@ -1013,6 +1019,9 @@ int __init vfio_pci_init_perm_bits(void)
 {
 	int ret;
 
+	if (atomic_inc_return(&vfio_pci_perm_bits_users) != 1)
+		return 0;
+
 	/* Basic config space */
 	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
 
-- 
2.7.4

