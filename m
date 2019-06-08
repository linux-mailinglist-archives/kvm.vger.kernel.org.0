Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F3F3A601
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2019 15:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfFINiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jun 2019 09:38:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:25056 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbfFINiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jun 2019 09:38:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jun 2019 06:38:08 -0700
X-ExtLoop1: 1
Received: from yiliu-dev.bj.intel.com ([10.238.156.125])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2019 06:38:06 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v1 8/9] vfio/pci: protect cap/ecap_perm bits alloc/free with atomic op
Date:   Sat,  8 Jun 2019 21:21:10 +0800
Message-Id: <1560000071-3543-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
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
index 52963a9..2f44d8f 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -995,11 +995,17 @@ static int __init init_pci_ext_cap_pwr_perm(struct perm_bits *perm)
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
@@ -1016,6 +1022,9 @@ int __init vfio_pci_init_perm_bits(void)
 {
 	int ret;
 
+	if (atomic_inc_return(&vfio_pci_perm_bits_users) != 1)
+		return 0;
+
 	/* Basic config space */
 	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
 
-- 
2.7.4

