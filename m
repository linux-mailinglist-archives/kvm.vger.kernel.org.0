Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF824311319
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 22:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhBEVIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 16:08:05 -0500
Received: from mga07.intel.com ([134.134.136.100]:56062 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233481AbhBETMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:12:09 -0500
IronPort-SDR: ZvdZ+pGO4vRzHu/NU1/oNMRyH9qTnoSNOoSXZKS4jWV2R6e02+tsAUpMN3HCMY6QuTQTh0l22c
 VmgScOyRQuUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="245557951"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="245557951"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:54:12 -0800
IronPort-SDR: I49WTfDurRmURM/DTk/92r5bCOpZaF9j0yeGrW5dXKsWGtCIlkkYgSySBFhQAdk+CRAoJ9K80w
 43uPmeMeL6tQ==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="508666130"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:54:11 -0800
Subject: [PATCH v5 12/14] vfio/mdev: idxd: add irq bypass for IMS vectors
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        jgg@mellanox.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 05 Feb 2021 13:54:10 -0700
Message-ID: <161255845083.339900.12339149209312159722.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support to bypass host for IMS interrupts configured for the guest.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/vfio/mdev/Kconfig     |    1 +
 drivers/vfio/mdev/idxd/mdev.c |   17 +++++++++++++++--
 drivers/vfio/mdev/idxd/mdev.h |    1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index e9540e43d1f1..ab0a6f0930bc 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -22,6 +22,7 @@ config VFIO_MDEV_IDXD
 	depends on VFIO && VFIO_MDEV && X86_64
 	select AUXILIARY_BUS
 	select IMS_MSI_ARRAY
+	select IRQ_BYPASS_MANAGER
 	default n
 	help
 	  VFIO based mediated device driver for Intel Accelerator Devices driver.
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 8a4af882a47f..d59920f78109 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -616,9 +616,13 @@ static int msix_trigger_unregister(struct vdcm_idxd *vidxd, int index)
 
 	dev_dbg(dev, "disable MSIX trigger %d\n", index);
 	if (index) {
+		struct irq_bypass_producer *producer;
 		u32 auxval;
 
+		producer = &vidxd->vdev.producer[index];
+		irq_bypass_unregister_producer(producer);
 		irq_entry = &vidxd->irq_entries[index];
+
 		if (irq_entry->irq_set) {
 			free_irq(irq_entry->irq, irq_entry);
 			irq_entry->irq_set = false;
@@ -654,9 +658,10 @@ static int msix_trigger_register(struct vdcm_idxd *vidxd, u32 fd, int index)
 	}
 
 	if (index) {
-		u32 pasid;
-		u32 auxval;
+		struct irq_bypass_producer *producer;
+		u32 pasid, auxval;
 
+		producer = &vidxd->vdev.producer[index];
 		irq_entry = &vidxd->irq_entries[index];
 		rc = idxd_mdev_get_pasid(mdev, &pasid);
 		if (rc < 0)
@@ -682,6 +687,14 @@ static int msix_trigger_register(struct vdcm_idxd *vidxd, u32 fd, int index)
 			irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
 			return rc;
 		}
+
+		producer->token = trigger;
+		producer->irq = irq_entry->irq;
+		rc = irq_bypass_register_producer(producer);
+		if (unlikely(rc))
+			dev_info(dev, "irq bypass producer (token %p) registration failed: %d\n",
+				 producer->token, rc);
+
 		irq_entry->irq_set = true;
 	}
 
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
index 8421b4962ac7..1f867de416e7 100644
--- a/drivers/vfio/mdev/idxd/mdev.h
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -45,6 +45,7 @@ struct idxd_vdev {
 	struct mdev_device *mdev;
 	struct vfio_group *vfio_group;
 	struct eventfd_ctx *msix_trigger[VIDXD_MAX_MSIX_ENTRIES];
+	struct irq_bypass_producer producer[VIDXD_MAX_MSIX_ENTRIES];
 };
 
 struct vdcm_idxd {


