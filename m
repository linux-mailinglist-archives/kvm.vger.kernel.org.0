Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A4A31131C
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 22:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhBEVIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 16:08:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:37605 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhBETLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:11:54 -0500
IronPort-SDR: ZEkPSrGNuHFQMhZI7fKRbJg/+Jsqkz+dbvthuR3XXkx9Yjc2JIsKa1Td6+ADDOtlOt178zmBBf
 PyHN40eTo0Tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="181551551"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="181551551"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:39 -0800
IronPort-SDR: ciJu/jukbZ2x70DZn4RggD5Af3iy+htFDTKKOgykpck1Gs5e0d3UI8KVZSQH3ER/BHZXZKX+5J
 t0IcmRCVOPKw==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="373680486"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:38 -0800
Subject: [PATCH v5 07/14] vfio/mdev: idxd: add 1dwq-v1 mdev type
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
Date:   Fri, 05 Feb 2021 13:53:37 -0700
Message-ID: <161255841792.339900.13314425685185083794.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add mdev device type "1dwq-v1" support code. 1dwq-v1 is defined as a
single DSA gen1 dedicated WQ. This WQ cannot be shared between guests. The
guest also cannot change any WQ configuration.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/sysfs.c      |    1 
 drivers/vfio/mdev/idxd/mdev.c |  216 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 207 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 13d20cbd4cf6..d985a0ac23d9 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -84,6 +84,7 @@ inline bool is_idxd_wq_mdev(struct idxd_wq *wq)
 {
 	return wq->type == IDXD_WQT_MDEV ? true : false;
 }
+EXPORT_SYMBOL_GPL(is_idxd_wq_mdev);
 
 static int idxd_config_bus_match(struct device *dev,
 				 struct device_driver *drv)
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 384ba5d6bc2b..7529396f3812 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -46,6 +46,9 @@ static u64 idxd_pci_config[] = {
 	0x0000000000000000ULL,
 };
 
+static char idxd_dsa_1dwq_name[IDXD_MDEV_NAME_LEN];
+static char idxd_iax_1dwq_name[IDXD_MDEV_NAME_LEN];
+
 static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags, unsigned int index,
 			      unsigned int start, unsigned int count, void *data);
 
@@ -144,21 +147,70 @@ static void idxd_vdcm_release(struct mdev_device *mdev)
 	mutex_unlock(&vidxd->dev_lock);
 }
 
+static struct idxd_wq *find_any_dwq(struct idxd_device *idxd, struct vdcm_idxd_type *type)
+{
+	int i;
+	struct idxd_wq *wq;
+	unsigned long flags;
+
+	switch (type->type) {
+	case IDXD_MDEV_TYPE_DSA_1_DWQ:
+		if (idxd->type != IDXD_TYPE_DSA)
+			return NULL;
+		break;
+	case IDXD_MDEV_TYPE_IAX_1_DWQ:
+		if (idxd->type != IDXD_TYPE_IAX)
+			return NULL;
+		break;
+	default:
+		return NULL;
+	}
+
+	spin_lock_irqsave(&idxd->dev_lock, flags);
+	for (i = 0; i < idxd->max_wqs; i++) {
+		wq = &idxd->wqs[i];
+
+		if (wq->state != IDXD_WQ_ENABLED)
+			continue;
+
+		if (!wq_dedicated(wq))
+			continue;
+
+		if (idxd_wq_refcount(wq) != 0)
+			continue;
+
+		spin_unlock_irqrestore(&idxd->dev_lock, flags);
+		mutex_lock(&wq->wq_lock);
+		if (idxd_wq_refcount(wq)) {
+			spin_lock_irqsave(&idxd->dev_lock, flags);
+			continue;
+		}
+
+		idxd_wq_get(wq);
+		mutex_unlock(&wq->wq_lock);
+		return wq;
+	}
+
+	spin_unlock_irqrestore(&idxd->dev_lock, flags);
+	return NULL;
+}
+
 static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev_device *mdev,
 					   struct vdcm_idxd_type *type)
 {
 	struct vdcm_idxd *vidxd;
 	struct idxd_wq *wq = NULL;
-	int i;
-
-	/* PLACEHOLDER, wq matching comes later */
+	int i, rc;
 
+	wq = find_any_dwq(idxd, type);
 	if (!wq)
 		return ERR_PTR(-ENODEV);
 
 	vidxd = kzalloc(sizeof(*vidxd), GFP_KERNEL);
-	if (!vidxd)
-		return ERR_PTR(-ENOMEM);
+	if (!vidxd) {
+		rc = -ENOMEM;
+		goto err;
+	}
 
 	mutex_init(&vidxd->dev_lock);
 	vidxd->idxd = idxd;
@@ -169,9 +221,6 @@ static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev
 	vidxd->num_wqs = VIDXD_MAX_WQS;
 
 	idxd_vdcm_init(vidxd);
-	mutex_lock(&wq->wq_lock);
-	idxd_wq_get(wq);
-	mutex_unlock(&wq->wq_lock);
 
 	for (i = 0; i < VIDXD_MAX_MSIX_ENTRIES; i++) {
 		vidxd->irq_entries[i].vidxd = vidxd;
@@ -179,9 +228,24 @@ static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev
 	}
 
 	return vidxd;
+
+ err:
+	mutex_lock(&wq->wq_lock);
+	idxd_wq_put(wq);
+	mutex_unlock(&wq->wq_lock);
+	return ERR_PTR(rc);
 }
 
-static struct vdcm_idxd_type idxd_mdev_types[IDXD_MDEV_TYPES];
+static struct vdcm_idxd_type idxd_mdev_types[IDXD_MDEV_TYPES] = {
+	{
+		.name = idxd_dsa_1dwq_name,
+		.type = IDXD_MDEV_TYPE_DSA_1_DWQ,
+	},
+	{
+		.name = idxd_iax_1dwq_name,
+		.type = IDXD_MDEV_TYPE_IAX_1_DWQ,
+	},
+};
 
 static struct vdcm_idxd_type *idxd_vdcm_find_vidxd_type(struct device *dev,
 							const char *name)
@@ -965,7 +1029,94 @@ static long idxd_vdcm_ioctl(struct mdev_device *mdev, unsigned int cmd,
 	return rc;
 }
 
-static const struct mdev_parent_ops idxd_vdcm_ops = {
+static ssize_t name_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct vdcm_idxd_type *type;
+
+	type = idxd_vdcm_find_vidxd_type(dev, kobject_name(kobj));
+
+	if (type)
+		return sprintf(buf, "%s\n", type->name);
+
+	return -EINVAL;
+}
+static MDEV_TYPE_ATTR_RO(name);
+
+static int find_available_mdev_instances(struct idxd_device *idxd, struct vdcm_idxd_type *type)
+{
+	int count = 0, i;
+	unsigned long flags;
+
+	switch (type->type) {
+	case IDXD_MDEV_TYPE_DSA_1_DWQ:
+		if (idxd->type != IDXD_TYPE_DSA)
+			return 0;
+		break;
+	case IDXD_MDEV_TYPE_IAX_1_DWQ:
+		if (idxd->type != IDXD_TYPE_IAX)
+			return 0;
+		break;
+	default:
+		return 0;
+	}
+
+	spin_lock_irqsave(&idxd->dev_lock, flags);
+	for (i = 0; i < idxd->max_wqs; i++) {
+		struct idxd_wq *wq;
+
+		wq = &idxd->wqs[i];
+		if (!is_idxd_wq_mdev(wq) || !wq_dedicated(wq) || idxd_wq_refcount(wq))
+			continue;
+
+		count++;
+	}
+	spin_unlock_irqrestore(&idxd->dev_lock, flags);
+
+	return count;
+}
+
+static ssize_t available_instances_show(struct kobject *kobj,
+					struct device *dev, char *buf)
+{
+	int count;
+	struct idxd_device *idxd = dev_get_drvdata(dev);
+	struct vdcm_idxd_type *type;
+
+	type = idxd_vdcm_find_vidxd_type(dev, kobject_name(kobj));
+	if (!type)
+		return -EINVAL;
+
+	count = find_available_mdev_instances(idxd, type);
+
+	return sprintf(buf, "%d\n", count);
+}
+static MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
+			       char *buf)
+{
+	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
+}
+static MDEV_TYPE_ATTR_RO(device_api);
+
+static struct attribute *idxd_mdev_types_attrs[] = {
+	&mdev_type_attr_name.attr,
+	&mdev_type_attr_device_api.attr,
+	&mdev_type_attr_available_instances.attr,
+	NULL,
+};
+
+static struct attribute_group idxd_mdev_type_dsa_group0 = {
+	.name = idxd_dsa_1dwq_name,
+	.attrs = idxd_mdev_types_attrs,
+};
+
+static struct attribute_group idxd_mdev_type_iax_group0 = {
+	.name = idxd_iax_1dwq_name,
+	.attrs = idxd_mdev_types_attrs,
+};
+
+static struct mdev_parent_ops idxd_vdcm_ops = {
 	.create			= idxd_vdcm_create,
 	.remove			= idxd_vdcm_remove,
 	.open			= idxd_vdcm_open,
@@ -976,6 +1127,43 @@ static const struct mdev_parent_ops idxd_vdcm_ops = {
 	.ioctl			= idxd_vdcm_ioctl,
 };
 
+/* Set the mdev type version to the hardware version supported */
+static void init_mdev_1dwq_name(struct idxd_device *idxd)
+{
+	unsigned int version;
+
+	version = (idxd->hw.version & GENMASK(15, 8)) >> 8;
+	if (idxd->type == IDXD_TYPE_DSA && strlen(idxd_dsa_1dwq_name) == 0)
+		sprintf(idxd_dsa_1dwq_name, "dsa-1dwq-v%u", version);
+	else if (idxd->type == IDXD_TYPE_IAX && strlen(idxd_iax_1dwq_name) == 0)
+		sprintf(idxd_iax_1dwq_name, "iax-1dwq-v%u", version);
+}
+
+static int alloc_supported_types(struct idxd_device *idxd)
+{
+	struct attribute_group **idxd_mdev_type_groups;
+
+	idxd_mdev_type_groups = kcalloc(2, sizeof(struct attribute_group *), GFP_KERNEL);
+	if (!idxd_mdev_type_groups)
+		return -ENOMEM;
+
+	switch (idxd->type) {
+	case IDXD_TYPE_DSA:
+		idxd_mdev_type_groups[0] = &idxd_mdev_type_dsa_group0;
+		break;
+	case IDXD_TYPE_IAX:
+		idxd_mdev_type_groups[0] = &idxd_mdev_type_iax_group0;
+		break;
+	case IDXD_TYPE_UNKNOWN:
+	default:
+		return -ENODEV;
+	}
+
+	idxd_vdcm_ops.supported_type_groups = idxd_mdev_type_groups;
+
+	return 0;
+}
+
 int idxd_mdev_host_init(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -984,6 +1172,11 @@ int idxd_mdev_host_init(struct idxd_device *idxd)
 	if (!test_bit(IDXD_FLAG_IMS_SUPPORTED, &idxd->flags))
 		return -EOPNOTSUPP;
 
+	init_mdev_1dwq_name(idxd);
+	rc = alloc_supported_types(idxd);
+	if (rc < 0)
+		return rc;
+
 	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
 		rc = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_AUX);
 		if (rc < 0) {
@@ -1010,6 +1203,9 @@ void idxd_mdev_host_release(struct idxd_device *idxd)
 			dev_warn(dev, "Failed to disable aux-domain: %d\n",
 				 rc);
 	}
+
+	kfree(idxd_vdcm_ops.supported_type_groups);
+	idxd_vdcm_ops.supported_type_groups = NULL;
 }
 
 static int idxd_mdev_aux_probe(struct auxiliary_device *auxdev,


