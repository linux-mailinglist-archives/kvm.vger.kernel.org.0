Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401872A0E08
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgJ3Sxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:53:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:20400 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbgJ3Swf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:35 -0400
IronPort-SDR: Yqxli0gOw28aQKPmHKXBGe4JdYWgrtWGpBLMIayffV1R5dxvxUEe8eS+PVavjnhfmpy1F9myI2
 8omB7DJ3HGZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="253357974"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="253357974"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:34 -0700
IronPort-SDR: 8apaJQkCdj7Ru9nFrYM5dDS8Q7Ah7+wG255Tv3/sTBnYZgALfpj3NZGEO0Td5Y9WRUiE2hG90F
 /DX8kCgySRuw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="351960852"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:33 -0700
Subject: [PATCH v4 15/17] dmaengine: idxd: add dedicated wq mdev type
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:52:32 -0700
Message-ID: <160408395282.912050.4836928882705571237.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the support code for "1dwq" mdev type. This mdev type follows the
standard VFIO mdev flow. The "1dwq" type will export a single dedicated wq
to the mdev. The dwq will have read-only configuration that is configured
by the host. The mdev type does not support PASID and SVA and will match
the stage 1 driver in functional support. For backward compatibility, the
mdev will maintain the DSA spec definition of this mdev type once the
commit goes upstream.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/mdev.c |  141 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 133 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
index ed79c85e692e..16b56f8f7fc1 100644
--- a/drivers/dma/idxd/mdev.c
+++ b/drivers/dma/idxd/mdev.c
@@ -111,20 +111,58 @@ static void idxd_vdcm_release(struct mdev_device *mdev)
 	mutex_unlock(&vidxd->dev_lock);
 }
 
+static struct idxd_wq *find_any_dwq(struct idxd_device *idxd)
+{
+	int i;
+	struct idxd_wq *wq;
+	unsigned long flags;
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
+	int rc;
 
-	/* PLACEHOLDER, wq matching comes later */
-
+	if (type->type == IDXD_MDEV_TYPE_1_DWQ)
+		wq = find_any_dwq(idxd);
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
@@ -135,14 +173,23 @@ static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev
 	vidxd->num_wqs = VIDXD_MAX_WQS;
 
 	idxd_vdcm_init(vidxd);
-	mutex_lock(&wq->wq_lock);
-	idxd_wq_get(wq);
-	mutex_unlock(&wq->wq_lock);
 
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
+		.name = "1dwq-v1",
+		.description = "IDXD MDEV with 1 dedicated workqueue",
+		.type = IDXD_MDEV_TYPE_1_DWQ,
+	},
+};
 
 static struct vdcm_idxd_type *idxd_vdcm_find_vidxd_type(struct device *dev,
 							const char *name)
@@ -934,7 +981,85 @@ static long idxd_vdcm_ioctl(struct mdev_device *mdev, unsigned int cmd,
 	return rc;
 }
 
+static ssize_t name_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct vdcm_idxd_type *type;
+
+	type = idxd_vdcm_find_vidxd_type(dev, kobject_name(kobj));
+
+	if (type)
+		return sprintf(buf, "%s\n", type->description);
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
+	if (type->type != IDXD_MDEV_TYPE_1_DWQ)
+		return 0;
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
+static struct attribute_group idxd_mdev_type_group0 = {
+	.name = "1dwq-v1",
+	.attrs = idxd_mdev_types_attrs,
+};
+
+static struct attribute_group *idxd_mdev_type_groups[] = {
+	&idxd_mdev_type_group0,
+	NULL,
+};
+
 static const struct mdev_parent_ops idxd_vdcm_ops = {
+	.supported_type_groups	= idxd_mdev_type_groups,
 	.create			= idxd_vdcm_create,
 	.remove			= idxd_vdcm_remove,
 	.open			= idxd_vdcm_open,


