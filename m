Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339FC38D287
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhEVAYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:24:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:39679 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhEVAXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:23:32 -0400
IronPort-SDR: /n64bcs1jHRBhQk2SS0Dd3/pBiXb5xSscxWGETK7t0llWqXWKRcNLisjQkL/bA3nUgcw6iaCJQ
 l8c9257w/KaA==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="201312184"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="201312184"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:33 -0700
IronPort-SDR: oX7Y5oO9ui9QqSKITyIQ1u4G0dXw/VfdMfhzvqETytAUDwK0GUMxZ0aAgecUKAFlsyhKR2HHuc
 epTbZWM793Mg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="544268896"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:32 -0700
Subject: [PATCH v6 14/20] vfio/mdev: idxd: add 1dwq-v1 mdev type
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:31 -0700
Message-ID: <162164283194.261970.12689960276759011457.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/vfio/mdev/idxd/mdev.c |  173 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 166 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index e484095baeea..9f6c4997ec24 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -22,6 +22,13 @@
 #include "idxd.h"
 #include "mdev.h"
 
+static const char idxd_dsa_1dwq_name[] = "dsa-1dwq-v1";
+static const char idxd_iax_1dwq_name[] = "iax-1dwq-v1";
+
+static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
+			      unsigned int index, unsigned int start,
+			      unsigned int count, void *data);
+
 int idxd_mdev_get_pasid(struct mdev_device *mdev, struct vfio_device *vdev, u32 *pasid)
 {
 	struct vfio_group *vfio_group = vdev->group;
@@ -41,10 +48,6 @@ int idxd_mdev_get_pasid(struct mdev_device *mdev, struct vfio_device *vdev, u32
 	return 0;
 }
 
-static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
-			      unsigned int index, unsigned int start,
-			      unsigned int count, void *data);
-
 static int idxd_vdcm_get_irq_count(struct vfio_device *vdev, int type)
 {
 	if (type == VFIO_PCI_MSIX_IRQ_INDEX)
@@ -53,18 +56,73 @@ static int idxd_vdcm_get_irq_count(struct vfio_device *vdev, int type)
 	return 0;
 }
 
+static struct idxd_wq *find_any_dwq(struct idxd_device *idxd, struct vdcm_idxd_type *type)
+{
+	int i;
+	struct idxd_wq *wq;
+	unsigned long flags;
+
+	switch (type->type) {
+	case IDXD_MDEV_TYPE_DSA_1_DWQ:
+		if (idxd->data->type != IDXD_TYPE_DSA)
+			return NULL;
+		break;
+	case IDXD_MDEV_TYPE_IAX_1_DWQ:
+		if (idxd->data->type != IDXD_TYPE_IAX)
+			return NULL;
+		break;
+	default:
+		return NULL;
+	}
+
+	spin_lock_irqsave(&idxd->dev_lock, flags);
+	for (i = 0; i < idxd->max_wqs; i++) {
+		wq = idxd->wqs[i];
+
+		if (wq->state != IDXD_WQ_ENABLED)
+			continue;
+
+		if (!wq_dedicated(wq))
+			continue;
+
+		if (!is_idxd_wq_mdev(wq))
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
+	int rc;
 
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
@@ -80,9 +138,24 @@ static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev
 	vidxd_init(vidxd);
 
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
 
 static struct vdcm_idxd_type *idxd_vdcm_get_type(struct mdev_device *mdev)
 {
@@ -677,6 +750,91 @@ static const struct vfio_device_ops idxd_mdev_ops = {
 	.ioctl = idxd_vdcm_ioctl,
 };
 
+static ssize_t name_show(struct mdev_type *mtype, struct mdev_type_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n", idxd_mdev_types[mtype_get_type_group_id(mtype)].name);
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
+		if (idxd->data->type != IDXD_TYPE_DSA)
+			return 0;
+		break;
+	case IDXD_MDEV_TYPE_IAX_1_DWQ:
+		if (idxd->data->type != IDXD_TYPE_IAX)
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
+		wq = idxd->wqs[i];
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
+static ssize_t available_instances_show(struct mdev_type *mtype,
+					struct mdev_type_attribute *attr,
+					char *buf)
+{
+	struct device *dev = mtype_get_parent_dev(mtype);
+	struct idxd_device *idxd = dev_get_drvdata(dev);
+	int count;
+	struct vdcm_idxd_type *type;
+
+	type = &idxd_mdev_types[mtype_get_type_group_id(mtype)];
+	count = find_available_mdev_instances(idxd, type);
+
+	return sysfs_emit(buf, "%d\n", count);
+}
+static MDEV_TYPE_ATTR_RO(available_instances);
+
+static ssize_t device_api_show(struct mdev_type *mtype, struct mdev_type_attribute *attr,
+			       char *buf)
+{
+	return sysfs_emit(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
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
+static struct attribute_group *idxd_mdev_type_groups[] = {
+	&idxd_mdev_type_dsa_group0,
+	&idxd_mdev_type_iax_group0,
+	NULL,
+};
+
 static struct mdev_driver idxd_vdcm_driver = {
 	.driver = {
 		.name = "idxd-mdev",
@@ -685,6 +843,7 @@ static struct mdev_driver idxd_vdcm_driver = {
 	},
 	.probe = idxd_vdcm_probe,
 	.remove = idxd_vdcm_remove,
+	.supported_type_groups = idxd_mdev_type_groups,
 };
 
 static int idxd_mdev_drv_probe(struct device *dev)


