Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E241B3335
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDUXd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:33:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:32224 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgDUXdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:33:55 -0400
IronPort-SDR: EZkGBLwiwN1TodTlXcb1ilP1GrDtgkbErHzB/1/t3SncGMrpScyD/LKPi5wUrzSKp5r4IuPQQf
 mGA9et/JtiUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:33:54 -0700
IronPort-SDR: R7c0g+JEGIqbU/dPIxUbI3KDjWZuI6JTjFuXKPTVsw8RrX18rXu7PT5me5fZxDPwH5iy2UyJol
 S3ll20lx7V/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="279818664"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004.fm.intel.com with ESMTP; 21 Apr 2020 16:33:53 -0700
Subject: [PATCH RFC 01/15] drivers/base: Introduce platform_msi_ops
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
Date:   Tue, 21 Apr 2020 16:33:53 -0700
Message-ID: <158751203294.36773.11436842117908325764.stgit@djiang5-desk3.ch.intel.com>
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

This is a preparatory patch to introduce Interrupt Message Store (IMS).

Until now, platform-msi.c provided a generic way to handle non-PCI MSI
interrupts. Platform-msi uses its parent chip's mask/unmask routines
and only provides a way to write the message in the generating device.

Newly creeping non-PCI complaint MSI-like interrupts (Intel's IMS for
instance) might need to provide a device specific mask and unmask callback
as well, apart from the write function.

Hence, introduce a new structure platform_msi_ops, which would provide
device specific write function as well as other device specific callbacks
(mask/unmask).

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 drivers/base/platform-msi.c          |   27 ++++++++++++++-------------
 drivers/dma/mv_xor_v2.c              |    6 +++++-
 drivers/dma/qcom/hidma.c             |    6 +++++-
 drivers/iommu/arm-smmu-v3.c          |    6 +++++-
 drivers/irqchip/irq-mbigen.c         |    8 ++++++--
 drivers/irqchip/irq-mvebu-icu.c      |    6 +++++-
 drivers/mailbox/bcm-flexrm-mailbox.c |    6 +++++-
 drivers/perf/arm_smmuv3_pmu.c        |    6 +++++-
 include/linux/msi.h                  |   24 ++++++++++++++++++------
 9 files changed, 68 insertions(+), 27 deletions(-)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 8da314b81eab..1a3af5f33802 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -21,11 +21,11 @@
  * and the callback to write the MSI message.
  */
 struct platform_msi_priv_data {
-	struct device		*dev;
-	void 			*host_data;
-	msi_alloc_info_t	arg;
-	irq_write_msi_msg_t	write_msg;
-	int			devid;
+	struct device			*dev;
+	void				*host_data;
+	msi_alloc_info_t		arg;
+	const struct platform_msi_ops	*ops;
+	int				devid;
 };
 
 /* The devid allocator */
@@ -83,7 +83,7 @@ static void platform_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 
 	priv_data = desc->platform.msi_priv_data;
 
-	priv_data->write_msg(desc, msg);
+	priv_data->ops->write_msg(desc, msg);
 }
 
 static void platform_msi_update_chip_ops(struct msi_domain_info *info)
@@ -194,7 +194,7 @@ struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
 
 static struct platform_msi_priv_data *
 platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
-			     irq_write_msi_msg_t write_msi_msg)
+			     const struct platform_msi_ops *platform_ops)
 {
 	struct platform_msi_priv_data *datap;
 	/*
@@ -203,7 +203,8 @@ platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
 	 * accordingly (which would impact the max number of MSI
 	 * capable devices).
 	 */
-	if (!dev->msi_domain || !write_msi_msg || !nvec || nvec > MAX_DEV_MSIS)
+	if (!dev->msi_domain || !platform_ops->write_msg || !nvec ||
+	    nvec > MAX_DEV_MSIS)
 		return ERR_PTR(-EINVAL);
 
 	if (dev->msi_domain->bus_token != DOMAIN_BUS_PLATFORM_MSI) {
@@ -227,7 +228,7 @@ platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
 		return ERR_PTR(err);
 	}
 
-	datap->write_msg = write_msi_msg;
+	datap->ops = platform_ops;
 	datap->dev = dev;
 
 	return datap;
@@ -249,12 +250,12 @@ static void platform_msi_free_priv_data(struct platform_msi_priv_data *data)
  * Zero for success, or an error code in case of failure
  */
 int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
-				   irq_write_msi_msg_t write_msi_msg)
+				   const struct platform_msi_ops *platform_ops)
 {
 	struct platform_msi_priv_data *priv_data;
 	int err;
 
-	priv_data = platform_msi_alloc_priv_data(dev, nvec, write_msi_msg);
+	priv_data = platform_msi_alloc_priv_data(dev, nvec, platform_ops);
 	if (IS_ERR(priv_data))
 		return PTR_ERR(priv_data);
 
@@ -324,7 +325,7 @@ struct irq_domain *
 __platform_msi_create_device_domain(struct device *dev,
 				    unsigned int nvec,
 				    bool is_tree,
-				    irq_write_msi_msg_t write_msi_msg,
+				    const struct platform_msi_ops *platform_ops,
 				    const struct irq_domain_ops *ops,
 				    void *host_data)
 {
@@ -332,7 +333,7 @@ __platform_msi_create_device_domain(struct device *dev,
 	struct irq_domain *domain;
 	int err;
 
-	data = platform_msi_alloc_priv_data(dev, nvec, write_msi_msg);
+	data = platform_msi_alloc_priv_data(dev, nvec, platform_ops);
 	if (IS_ERR(data))
 		return NULL;
 
diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index 157c959311ea..426f520f3765 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -706,6 +706,10 @@ static int mv_xor_v2_resume(struct platform_device *dev)
 	return 0;
 }
 
+static const struct platform_msi_ops mv_xor_v2_msi_ops = {
+	.write_msg	= mv_xor_v2_set_msi_msg,
+};
+
 static int mv_xor_v2_probe(struct platform_device *pdev)
 {
 	struct mv_xor_v2_device *xor_dev;
@@ -761,7 +765,7 @@ static int mv_xor_v2_probe(struct platform_device *pdev)
 	}
 
 	ret = platform_msi_domain_alloc_irqs(&pdev->dev, 1,
-					     mv_xor_v2_set_msi_msg);
+					     &mv_xor_v2_msi_ops);
 	if (ret)
 		goto disable_clk;
 
diff --git a/drivers/dma/qcom/hidma.c b/drivers/dma/qcom/hidma.c
index 411f91fde734..65371535ba26 100644
--- a/drivers/dma/qcom/hidma.c
+++ b/drivers/dma/qcom/hidma.c
@@ -678,6 +678,10 @@ static void hidma_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 		writel(msg->data, dmadev->dev_evca + 0x120);
 	}
 }
+
+static const struct platform_msi_ops hidma_msi_ops = {
+	.write_msg	= hidma_write_msi_msg,
+};
 #endif
 
 static void hidma_free_msis(struct hidma_dev *dmadev)
@@ -703,7 +707,7 @@ static int hidma_request_msi(struct hidma_dev *dmadev,
 	struct msi_desc *failed_desc = NULL;
 
 	rc = platform_msi_domain_alloc_irqs(&pdev->dev, HIDMA_MSI_INTS,
-					    hidma_write_msi_msg);
+					    &hidma_msi_ops);
 	if (rc)
 		return rc;
 
diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 82508730feb7..764e284202f1 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3425,6 +3425,10 @@ static void arm_smmu_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 	writel_relaxed(ARM_SMMU_MEMATTR_DEVICE_nGnRE, smmu->base + cfg[2]);
 }
 
+static const struct platform_msi_ops arm_smmu_msi_ops = {
+	.write_msg	= arm_smmu_write_msi_msg,
+};
+
 static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 {
 	struct msi_desc *desc;
@@ -3449,7 +3453,7 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 	}
 
 	/* Allocate MSIs for evtq, gerror and priq. Ignore cmdq */
-	ret = platform_msi_domain_alloc_irqs(dev, nvec, arm_smmu_write_msi_msg);
+	ret = platform_msi_domain_alloc_irqs(dev, nvec, &arm_smmu_msi_ops);
 	if (ret) {
 		dev_warn(dev, "failed to allocate MSIs - falling back to wired irqs\n");
 		return;
diff --git a/drivers/irqchip/irq-mbigen.c b/drivers/irqchip/irq-mbigen.c
index 6b566bba263b..ff5b75751974 100644
--- a/drivers/irqchip/irq-mbigen.c
+++ b/drivers/irqchip/irq-mbigen.c
@@ -226,6 +226,10 @@ static const struct irq_domain_ops mbigen_domain_ops = {
 	.free		= irq_domain_free_irqs_common,
 };
 
+static const struct platform_msi_ops mbigen_msi_ops = {
+	.write_msg	= mbigen_write_msg,
+};
+
 static int mbigen_of_create_domain(struct platform_device *pdev,
 				   struct mbigen_device *mgn_chip)
 {
@@ -254,7 +258,7 @@ static int mbigen_of_create_domain(struct platform_device *pdev,
 		}
 
 		domain = platform_msi_create_device_domain(&child->dev, num_pins,
-							   mbigen_write_msg,
+							   &mbigen_msi_ops,
 							   &mbigen_domain_ops,
 							   mgn_chip);
 		if (!domain) {
@@ -302,7 +306,7 @@ static int mbigen_acpi_create_domain(struct platform_device *pdev,
 		return -EINVAL;
 
 	domain = platform_msi_create_device_domain(&pdev->dev, num_pins,
-						   mbigen_write_msg,
+						   &mbigen_msi_ops,
 						   &mbigen_domain_ops,
 						   mgn_chip);
 	if (!domain)
diff --git a/drivers/irqchip/irq-mvebu-icu.c b/drivers/irqchip/irq-mvebu-icu.c
index 547045d89c4b..49b6390470bb 100644
--- a/drivers/irqchip/irq-mvebu-icu.c
+++ b/drivers/irqchip/irq-mvebu-icu.c
@@ -295,6 +295,10 @@ static const struct of_device_id mvebu_icu_subset_of_match[] = {
 	{},
 };
 
+static const struct platform_msi_ops mvebu_icu_msi_ops = {
+	.write_msg	= mvebu_icu_write_msg,
+};
+
 static int mvebu_icu_subset_probe(struct platform_device *pdev)
 {
 	struct mvebu_icu_msi_data *msi_data;
@@ -324,7 +328,7 @@ static int mvebu_icu_subset_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	irq_domain = platform_msi_create_device_tree_domain(dev, ICU_MAX_IRQS,
-							    mvebu_icu_write_msg,
+							    &mvebu_icu_msi_ops,
 							    &mvebu_icu_domain_ops,
 							    msi_data);
 	if (!irq_domain) {
diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
index bee33abb5308..0268337e08e3 100644
--- a/drivers/mailbox/bcm-flexrm-mailbox.c
+++ b/drivers/mailbox/bcm-flexrm-mailbox.c
@@ -1492,6 +1492,10 @@ static void flexrm_mbox_msi_write(struct msi_desc *desc, struct msi_msg *msg)
 	writel_relaxed(msg->data, ring->regs + RING_MSI_DATA_VALUE);
 }
 
+static const struct platform_msi_ops flexrm_mbox_msi_ops = {
+	.write_msg	= flexrm_mbox_msi_write,
+};
+
 static int flexrm_mbox_probe(struct platform_device *pdev)
 {
 	int index, ret = 0;
@@ -1604,7 +1608,7 @@ static int flexrm_mbox_probe(struct platform_device *pdev)
 
 	/* Allocate platform MSIs for each ring */
 	ret = platform_msi_domain_alloc_irqs(dev, mbox->num_rings,
-						flexrm_mbox_msi_write);
+						&flexrm_mbox_msi_ops);
 	if (ret)
 		goto fail_destroy_cmpl_pool;
 
diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index f01a57e5a5f3..bcbd7f5e3d0f 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -652,6 +652,10 @@ static void smmu_pmu_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 		       pmu->reg_base + SMMU_PMCG_IRQ_CFG2);
 }
 
+static const struct platform_msi_ops smmu_pmu_msi_ops = {
+	.write_msg	= smmu_pmu_write_msi_msg,
+};
+
 static void smmu_pmu_setup_msi(struct smmu_pmu *pmu)
 {
 	struct msi_desc *desc;
@@ -665,7 +669,7 @@ static void smmu_pmu_setup_msi(struct smmu_pmu *pmu)
 	if (!(readl(pmu->reg_base + SMMU_PMCG_CFGR) & SMMU_PMCG_CFGR_MSI))
 		return;
 
-	ret = platform_msi_domain_alloc_irqs(dev, 1, smmu_pmu_write_msi_msg);
+	ret = platform_msi_domain_alloc_irqs(dev, 1, &smmu_pmu_msi_ops);
 	if (ret) {
 		dev_warn(dev, "failed to allocate MSIs\n");
 		return;
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8ad679e9d9c0..8e08907d70cb 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -321,6 +321,18 @@ enum {
 	MSI_FLAG_LEVEL_CAPABLE		= (1 << 6),
 };
 
+/*
+ * platform_msi_ops - Callbacks for platform MSI ops
+ * @irq_mask:   mask an interrupt source
+ * @irq_unmask: unmask an interrupt source
+ * @irq_write_msi_msg: write message content
+ */
+struct platform_msi_ops {
+	unsigned int		(*irq_mask)(struct msi_desc *desc);
+	unsigned int		(*irq_unmask)(struct msi_desc *desc);
+	irq_write_msi_msg_t	write_msg;
+};
+
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
 
@@ -336,7 +348,7 @@ struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
 						  struct msi_domain_info *info,
 						  struct irq_domain *parent);
 int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
-				   irq_write_msi_msg_t write_msi_msg);
+				   const struct platform_msi_ops *platform_ops);
 void platform_msi_domain_free_irqs(struct device *dev);
 
 /* When an MSI domain is used as an intermediate domain */
@@ -348,14 +360,14 @@ struct irq_domain *
 __platform_msi_create_device_domain(struct device *dev,
 				    unsigned int nvec,
 				    bool is_tree,
-				    irq_write_msi_msg_t write_msi_msg,
+				    const struct platform_msi_ops *platform_ops,
 				    const struct irq_domain_ops *ops,
 				    void *host_data);
 
-#define platform_msi_create_device_domain(dev, nvec, write, ops, data)	\
-	__platform_msi_create_device_domain(dev, nvec, false, write, ops, data)
-#define platform_msi_create_device_tree_domain(dev, nvec, write, ops, data) \
-	__platform_msi_create_device_domain(dev, nvec, true, write, ops, data)
+#define platform_msi_create_device_domain(dev, nvec, p_ops, ops, data)	\
+	__platform_msi_create_device_domain(dev, nvec, false, p_ops, ops, data)
+#define platform_msi_create_device_tree_domain(dev, nvec, p_ops, ops, data) \
+	__platform_msi_create_device_domain(dev, nvec, true, p_ops, ops, data)
 
 int platform_msi_domain_alloc(struct irq_domain *domain, unsigned int virq,
 			      unsigned int nr_irqs);

