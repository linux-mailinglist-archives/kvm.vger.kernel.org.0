Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673F026B4EA
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 01:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgIOXeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 19:34:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:49245 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727384AbgIOXdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 19:33:53 -0400
IronPort-SDR: VgODABpb8S4k8shmihF3PkVC1Twr7k0L1EwKZMHVSZEZ6NzmTnF3bOIy5YR1AcVyzaggpQ9Sql
 LoiGlSYAE+Qg==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="156755448"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="156755448"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:29:07 -0700
IronPort-SDR: Y7PK3s13NhBfmBJ+aALMybqzoVdKYxWv79Priv4kBofwVhB/TfhIAoa+AyXQvb/g1zMMdvkk2c
 1hk1f9mXVKaA==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="331439472"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 16:29:05 -0700
Subject: [PATCH v3 13/18] dmaengine: idxd: add dedicated wq mdev type
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
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 15 Sep 2020 16:29:04 -0700
Message-ID: <160021254470.67751.9829487993127571356.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
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
 drivers/dma/idxd/mdev.c |  142 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 133 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
index 6b91abd4d8d9..2d3ff1a50d39 100644
--- a/drivers/dma/idxd/mdev.c
+++ b/drivers/dma/idxd/mdev.c
@@ -99,21 +99,58 @@ static void idxd_vdcm_release(struct mdev_device *mdev)
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
-	int i;
-
-	/* PLACEHOLDER, wq matching comes later */
+	int i, rc;
 
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
@@ -127,14 +164,23 @@ static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev
 		vidxd->ims_index[i] = -1;
 
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
@@ -910,7 +956,85 @@ static long idxd_vdcm_ioctl(struct mdev_device *mdev, unsigned int cmd,
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

