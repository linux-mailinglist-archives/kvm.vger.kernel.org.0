Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A9022847C
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgGUQCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:02:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:47301 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgGUQCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:02:24 -0400
IronPort-SDR: QWAXBytFfS23jUq3AZPabo7CCHI3HCBNcPGKgtVIwAfuSV8kp1OUuYgKJXSK9ghFrjd383Zq3l
 JAh59aoRU11Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="168306135"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="168306135"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:02:23 -0700
IronPort-SDR: oGDRW/XIcPpgjsIGuxrTgLnNDsN8b7K6pe/VoyFKNQGDe+1KJvKAGLUV3GkHwdmbNnj/KadSMi
 h1OWazEl1d7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="488133813"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jul 2020 09:02:21 -0700
Subject: [PATCH RFC v2 01/18] platform-msi: Introduce platform_msi_ops
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, jgg@mellanox.com,
        rafael@kernel.org, dave.hansen@intel.com, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Jul 2020 09:02:21 -0700
Message-ID: <159534734176.28840.13007887237870414700.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@intel.com>

platform-msi.c provides a generic way to handle non-PCI message
signaled interrupts. However, it assumes that only the message
needs to be customized. Given that an MSI is just a write
transaction, some devices may need custom callbacks to
mask/unmask their interrupts.

Hence, introduce a new structure platform_msi_ops, which would
provide device specific write function for now and introduce device
device specific callbacks (mask/unmask), in subsequent patches.

Devices may find more efficient ways to store addr/data pairs
than what is recommended by the PCI sig. (For e.g. the storage of
the vector might not be resident on the device. Consider GPGPU
for instance, where the vector could be part of the execution
context instead of being stored on the device.)

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/base/platform-msi.c          |   29 +++++++++++++++--------------
 drivers/dma/mv_xor_v2.c              |    6 +++++-
 drivers/dma/qcom/hidma.c             |    6 +++++-
 drivers/iommu/arm-smmu-v3.c          |    6 +++++-
 drivers/irqchip/irq-mbigen.c         |    8 ++++++--
 drivers/irqchip/irq-mvebu-icu.c      |    6 +++++-
 drivers/mailbox/bcm-flexrm-mailbox.c |    6 +++++-
 drivers/perf/arm_smmuv3_pmu.c        |    6 +++++-
 include/linux/msi.h                  |   20 ++++++++++++++------
 9 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index c4a17e5edf8b..9d94cd699468 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -18,14 +18,14 @@
 
 /*
  * Internal data structure containing a (made up, but unique) devid
- * and the callback to write the MSI message.
+ * and the platform-msi ops
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
@@ -194,16 +194,17 @@ struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
 
 static struct platform_msi_priv_data *
 platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
-			     irq_write_msi_msg_t write_msi_msg)
+			     const struct platform_msi_ops *platform_ops)
 {
 	struct platform_msi_priv_data *datap;
+
 	/*
 	 * Limit the number of interrupts to 2048 per device. Should we
 	 * need to bump this up, DEV_ID_SHIFT should be adjusted
 	 * accordingly (which would impact the max number of MSI
 	 * capable devices).
 	 */
-	if (!dev->msi_domain || !write_msi_msg || !nvec || nvec > MAX_DEV_MSIS)
+	if (!dev->msi_domain || !platform_ops->write_msg || !nvec || nvec > MAX_DEV_MSIS)
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
index 9225f08dfee9..c0033c4f8ee5 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -710,6 +710,10 @@ static int mv_xor_v2_resume(struct platform_device *dev)
 	return 0;
 }
 
+static const struct platform_msi_ops mv_xor_v2_msi_ops = {
+	.write_msg	= mv_xor_v2_set_msi_msg,
+};
+
 static int mv_xor_v2_probe(struct platform_device *pdev)
 {
 	struct mv_xor_v2_device *xor_dev;
@@ -765,7 +769,7 @@ static int mv_xor_v2_probe(struct platform_device *pdev)
 	}
 
 	ret = platform_msi_domain_alloc_irqs(&pdev->dev, 1,
-					     mv_xor_v2_set_msi_msg);
+					     &mv_xor_v2_msi_ops);
 	if (ret)
 		goto disable_clk;
 
diff --git a/drivers/dma/qcom/hidma.c b/drivers/dma/qcom/hidma.c
index 0a6d3ea08c78..c3ee63159ff8 100644
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
index f578677a5c41..655e7987d8af 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3410,6 +3410,10 @@ static void arm_smmu_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 	writel_relaxed(ARM_SMMU_MEMATTR_DEVICE_nGnRE, smmu->base + cfg[2]);
 }
 
+static const struct platform_msi_ops arm_smmu_msi_ops = {
+	.write_msg	= arm_smmu_write_msi_msg,
+};
+
 static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 {
 	struct msi_desc *desc;
@@ -3434,7 +3438,7 @@ static void arm_smmu_setup_msis(struct arm_smmu_device *smmu)
 	}
 
 	/* Allocate MSIs for evtq, gerror and priq. Ignore cmdq */
-	ret = platform_msi_domain_alloc_irqs(dev, nvec, arm_smmu_write_msi_msg);
+	ret = platform_msi_domain_alloc_irqs(dev, nvec, &arm_smmu_msi_ops);
 	if (ret) {
 		dev_warn(dev, "failed to allocate MSIs - falling back to wired irqs\n");
 		return;
diff --git a/drivers/irqchip/irq-mbigen.c b/drivers/irqchip/irq-mbigen.c
index ff7627b57772..6619e2eadbce 100644
--- a/drivers/irqchip/irq-mbigen.c
+++ b/drivers/irqchip/irq-mbigen.c
@@ -232,6 +232,10 @@ static const struct irq_domain_ops mbigen_domain_ops = {
 	.free		= mbigen_irq_domain_free,
 };
 
+static const struct platform_msi_ops mbigen_msi_ops = {
+	.write_msg	= mbigen_write_msg,
+};
+
 static int mbigen_of_create_domain(struct platform_device *pdev,
 				   struct mbigen_device *mgn_chip)
 {
@@ -260,7 +264,7 @@ static int mbigen_of_create_domain(struct platform_device *pdev,
 		}
 
 		domain = platform_msi_create_device_domain(&child->dev, num_pins,
-							   mbigen_write_msg,
+							   &mbigen_msi_ops,
 							   &mbigen_domain_ops,
 							   mgn_chip);
 		if (!domain) {
@@ -308,7 +312,7 @@ static int mbigen_acpi_create_domain(struct platform_device *pdev,
 		return -EINVAL;
 
 	domain = platform_msi_create_device_domain(&pdev->dev, num_pins,
-						   mbigen_write_msg,
+						   &mbigen_msi_ops,
 						   &mbigen_domain_ops,
 						   mgn_chip);
 	if (!domain)
diff --git a/drivers/irqchip/irq-mvebu-icu.c b/drivers/irqchip/irq-mvebu-icu.c
index 91adf771f185..927d8ebc68cb 100644
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
index 48e28ef93a70..f1dec2bcd2a1 100644
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
index 8ad679e9d9c0..7f6a8eb51aca 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -321,6 +321,14 @@ enum {
 	MSI_FLAG_LEVEL_CAPABLE		= (1 << 6),
 };
 
+/*
+ * platform_msi_ops - Callbacks for platform MSI ops
+ * @write_msg:	write message content
+ */
+struct platform_msi_ops {
+	irq_write_msi_msg_t	write_msg;
+};
+
 int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force);
 
@@ -336,7 +344,7 @@ struct irq_domain *platform_msi_create_irq_domain(struct fwnode_handle *fwnode,
 						  struct msi_domain_info *info,
 						  struct irq_domain *parent);
 int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
-				   irq_write_msi_msg_t write_msi_msg);
+				   const struct platform_msi_ops *platform_ops);
 void platform_msi_domain_free_irqs(struct device *dev);
 
 /* When an MSI domain is used as an intermediate domain */
@@ -348,14 +356,14 @@ struct irq_domain *
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

