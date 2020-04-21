Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA22A1B3343
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgDUXeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:48536 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgDUXeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:20 -0400
IronPort-SDR: 3/rtuIF31oM0OaVEbKUi3KRsrafnF7Z4rjs0j2KcO80VIWnO4OFucTqNf+DjuJUWYnJ0IW80l5
 QZAxJ2Wq17RA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:19 -0700
IronPort-SDR: qNc57k773vsWijzuXENpuH2d5vSs9y4rvinSUip2tAmwqhi78IwDN9RiECbY2+K4Mqr/brXoBe
 oJHkeYg+ZLlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="290640817"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2020 16:34:18 -0700
Subject: [PATCH RFC 05/15] ims-msi: Add mask/unmask routines
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:34:17 -0700
Message-ID: <158751205785.36773.16321096654677399376.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

Introduce the mask/unmask functions which would be used as callbacks
to the IRQ chip associated with the IMS domain.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 drivers/base/ims-msi.c      |   47 +++++++++++++++++++++++++++++++++++++++++++
 drivers/base/platform-msi.c |   12 -----------
 include/linux/msi.h         |   14 +++++++++++++
 3 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
index 738f6d153155..896a5a1b2252 100644
--- a/drivers/base/ims-msi.c
+++ b/drivers/base/ims-msi.c
@@ -7,11 +7,56 @@
  * Author: Megha Dey <megha.dey@intel.com>
  */
 
+#include <linux/device.h>
 #include <linux/dmar.h>
+#include <linux/export.h>
 #include <linux/irq.h>
 #include <linux/mdev.h>
+#include <linux/msi.h>
 #include <linux/pci.h>
 
+static u32 __dev_ims_desc_mask_irq(struct msi_desc *desc, u32 flag)
+{
+	u32 mask_bits = desc->platform.masked;
+	const struct platform_msi_ops *ops;
+
+	ops = desc->platform.msi_priv_data->ops;
+	if (!ops)
+		return 0;
+
+	if (flag) {
+		if (ops->irq_mask)
+			mask_bits = ops->irq_mask(desc);
+	} else {
+		if (ops->irq_unmask)
+			mask_bits = ops->irq_unmask(desc);
+	}
+
+	return mask_bits;
+}
+
+/**
+ * dev_ims_mask_irq - Generic irq chip callback to mask IMS interrupts
+ * @data: pointer to irqdata associated to that interrupt
+ */
+static void dev_ims_mask_irq(struct irq_data *data)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+
+	desc->platform.masked = __dev_ims_desc_mask_irq(desc, 1);
+}
+
+/**
+ * dev_msi_unmask_irq - Generic irq chip callback to unmask IMS interrupts
+ * @data: pointer to irqdata associated to that interrupt
+ */
+void dev_ims_unmask_irq(struct irq_data *data)
+{
+	struct msi_desc *desc = irq_data_get_msi_desc(data);
+
+	desc->platform.masked = __dev_ims_desc_mask_irq(desc, 0);
+}
+
 /*
  * Determine if a dev is mdev or not. Return NULL if not mdev device.
  * Return mdev's parent dev if success.
@@ -69,6 +114,8 @@ static struct irq_chip dev_ims_ir_controller = {
 	.irq_set_vcpu_affinity	= irq_chip_set_vcpu_affinity_parent,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 	.irq_write_msi_msg	= platform_msi_write_msg,
+	.irq_unmask             = dev_ims_unmask_irq,
+	.irq_mask               = dev_ims_mask_irq,
 };
 
 static struct msi_domain_info ims_ir_domain_info = {
diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 59160e8cbfb1..6d8840db4a85 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -16,18 +16,6 @@
 #define DEV_ID_SHIFT	21
 #define MAX_DEV_MSIS	(1 << (32 - DEV_ID_SHIFT))
 
-/*
- * Internal data structure containing a (made up, but unique) devid
- * and the callback to write the MSI message.
- */
-struct platform_msi_priv_data {
-	struct device			*dev;
-	void				*host_data;
-	msi_alloc_info_t		arg;
-	const struct platform_msi_ops	*ops;
-	int				devid;
-};
-
 /* The devid allocator */
 static DEFINE_IDA(platform_msi_devid_ida);
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 80386468a7bc..8b5f24bf3c47 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -33,10 +33,12 @@ typedef void (*irq_write_msi_msg_t)(struct msi_desc *desc,
  * platform_msi_desc - Platform device specific msi descriptor data
  * @msi_priv_data:	Pointer to platform private data
  * @msi_index:		The index of the MSI descriptor for multi MSI
+ * @masked:		mask bits
  */
 struct platform_msi_desc {
 	struct platform_msi_priv_data	*msi_priv_data;
 	u16				msi_index;
+	u32				masked;
 };
 
 /**
@@ -370,6 +372,18 @@ struct platform_msi_ops {
 	irq_write_msi_msg_t	write_msg;
 };
 
+/*
+ * Internal data structure containing a (made up, but unique) devid
+ * and the callback to write the MSI message.
+ */
+struct platform_msi_priv_data {
+	struct device			*dev;
+	void				*host_data;
+	msi_alloc_info_t		arg;
+	const struct platform_msi_ops	*ops;
+	int				devid;
+};
+
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
 

