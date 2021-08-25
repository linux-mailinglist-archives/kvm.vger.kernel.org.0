Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575A23F7D0D
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 22:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbhHYUOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 16:14:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232315AbhHYUOb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 16:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629922425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TD0gcJwpeALt28x1quGfed89sGXPxECqUw4n7hpehPA=;
        b=J78AbwRutjCVItXKFKkK05G8oAP4Miqvv0Rap9A30uZc4iqs88ZJ9S54WsDr/3oexeAhit
        H2PkrmjLmGwZW8jUVrdh3cn664I5ucfzzLGA1YsFqtqlVxpUg4nL4NYzJ67McxIV0B4F3+
        3KmbpkBOWNFNpaVRizkSi4r7mRJHmAg=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-4S8Wd5gAOu-fyTSnH3bEow-1; Wed, 25 Aug 2021 16:13:44 -0400
X-MC-Unique: 4S8Wd5gAOu-fyTSnH3bEow-1
Received: by mail-ot1-f72.google.com with SMTP id 65-20020a9d0ec70000b02904d36d33dcf7so187579otj.4
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 13:13:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TD0gcJwpeALt28x1quGfed89sGXPxECqUw4n7hpehPA=;
        b=uDc+bOA1mJ+rsx6rBWeSv1JXN+EkAB10MsDGXj5qbRLXQ093vEpLX7HSODnCIHify9
         fFXRsbZ8tgmWNEkNJT0bNxhp9Q7xJRjuqT4Q8dEfIwVlQoLkEcCVqPfZ70lTuQBn3Umo
         aROplp853XeOFi42V0vYok/I9qhkmYKqd4/Ql2ULeqQ1I/WG2KsKHPO5bY9lQ/Y4SOuw
         6N6ObLQLu2M2LJQepL+77E3WCinbN2vJDs8Y1HuHpnSIheqEoZ7/+jvEekyfQ/ewPG4q
         IoGG9tJ8iu9dDs35jYCpGGoM7HYvQZDD3DtUidaA62WKTryQ1sjCAzANeMbqQ774g/Qd
         06jA==
X-Gm-Message-State: AOAM530DKYvyG18kUV1Kn65/ujyt57wmfqSYoGuXGxCyuYZ0JHZKLZ4p
        fDX9WZh0Hy01QoRg2rmSyOKP7DuqboNzr6s60PsncT7EpI4e4/3MXiKgs8PHgMV9YF4i/T/meJ1
        ltoOOMjSerQB4
X-Received: by 2002:a05:6830:4489:: with SMTP id r9mr205356otv.348.1629922423083;
        Wed, 25 Aug 2021 13:13:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwqoOjKZuCf/8sHhqNXmLr/JN92bDlHaUcKEZdFSwX6Lf6E5CUbp9XjevrBlCf+VV+AIVf8w==
X-Received: by 2002:a05:6830:4489:: with SMTP id r9mr205334otv.348.1629922422859;
        Wed, 25 Aug 2021 13:13:42 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id f33sm168912otf.0.2021.08.25.13.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 13:13:42 -0700 (PDT)
Date:   Wed, 25 Aug 2021 14:13:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v4] vfio/ap_ops: Convert to use
 vfio_register_group_dev()
Message-ID: <20210825141341.59b0efb4.alex.williamson@redhat.com>
In-Reply-To: <20210825004226.GC1721383@nvidia.com>
References: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
        <20210824143001.37d01a77.alex.williamson@redhat.com>
        <20210825004226.GC1721383@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Aug 2021 21:42:26 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Aug 24, 2021 at 02:30:01PM -0600, Alex Williamson wrote:
> > On Mon, 23 Aug 2021 11:42:04 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > This is straightforward conversion, the ap_matrix_mdev is actually serving
> > > as the vfio_device and we can replace all the mdev_get_drvdata()'s with a
> > > simple container_of() or a dev_get_drvdata() for sysfs paths.
> > > 
> > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > Cc: kvm@vger.kernel.org
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
> > >  drivers/s390/crypto/vfio_ap_private.h |   2 +
> > >  2 files changed, 91 insertions(+), 66 deletions(-)  
> > 
> > Jason & Tony,
> > 
> > Would one of you please rebase on the other's series?  The merge
> > conflict between this and 20210823212047.1476436-1-akrowiak@linux.ibm.com
> > is more than I'd like to bury into a merge commit and I can't test beyond
> > a cross compile.  Thanks,  
> 
> Tony, as you have the Hw to test it is probably best if you do it, all
> I can do is the same as Alex.

Maybe we can do it this way, it seems easier to port Jason's single
patch on top of Tony's series than vice versa.  The below is my attempt
at that.  If Jason and Tony can give this a thumbs up, I'll run with it.

Thanks,
Alex

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index c46937de5758..2347808fa3e4 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -24,8 +24,9 @@
 #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
 #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
 
-static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
+static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
+static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 
 static int match_apqn(struct device *dev, const void *data)
 {
@@ -326,43 +327,57 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
-static int vfio_ap_mdev_create(struct mdev_device *mdev)
+static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev;
+	int ret;
 
 	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
 		return -EPERM;
 
 	matrix_mdev = kzalloc(sizeof(*matrix_mdev), GFP_KERNEL);
 	if (!matrix_mdev) {
-		atomic_inc(&matrix_dev->available_instances);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_dec_available;
 	}
+	vfio_init_group_dev(&matrix_mdev->vdev, &mdev->dev,
+			    &vfio_ap_matrix_dev_ops);
 
 	matrix_mdev->mdev = mdev;
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
-	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook = handle_pqap;
 	mutex_lock(&matrix_dev->lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
 	mutex_unlock(&matrix_dev->lock);
 
+	ret = vfio_register_group_dev(&matrix_mdev->vdev);
+	if (ret)
+		goto err_list;
+	dev_set_drvdata(&mdev->dev, matrix_mdev);
 	return 0;
+
+err_list:
+	mutex_lock(&matrix_dev->lock);
+	list_del(&matrix_mdev->node);
+	mutex_unlock(&matrix_dev->lock);
+	kfree(matrix_mdev);
+err_dec_available:
+	atomic_inc(&matrix_dev->available_instances);
+	return ret;
 }
 
-static int vfio_ap_mdev_remove(struct mdev_device *mdev)
+static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 {
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(&mdev->dev);
+
+	vfio_unregister_group_dev(&matrix_mdev->vdev);
 
 	mutex_lock(&matrix_dev->lock);
-	vfio_ap_mdev_reset_queues(mdev);
+	vfio_ap_mdev_reset_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
 	kfree(matrix_mdev);
-	mdev_set_drvdata(mdev, NULL);
 	atomic_inc(&matrix_dev->available_instances);
 	mutex_unlock(&matrix_dev->lock);
-
-	return 0;
 }
 
 static ssize_t name_show(struct mdev_type *mtype,
@@ -604,8 +619,7 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
 
@@ -674,8 +688,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
 
@@ -760,8 +773,7 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
 	mutex_lock(&matrix_dev->lock);
@@ -826,8 +838,7 @@ static ssize_t unassign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
 
@@ -877,8 +888,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long id;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&matrix_dev->lock);
 
@@ -932,8 +942,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long domid;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
 	mutex_lock(&matrix_dev->lock);
@@ -968,8 +977,7 @@ static ssize_t control_domains_show(struct device *dev,
 	int nchars = 0;
 	int n;
 	char *bufpos = buf;
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	unsigned long max_domid = matrix_mdev->matrix.adm_max;
 
 	mutex_lock(&matrix_dev->lock);
@@ -987,8 +995,7 @@ static DEVICE_ATTR_RO(control_domains);
 static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 	char *bufpos = buf;
 	unsigned long apid;
 	unsigned long apqi;
@@ -1165,7 +1172,7 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev,
 		mutex_lock(&matrix_dev->lock);
 
 		kvm_arch_crypto_clear_masks(kvm);
-		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
+		vfio_ap_mdev_reset_queues(matrix_mdev);
 		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
 
@@ -1259,13 +1266,12 @@ int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 	return ret;
 }
 
-static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
+static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev)
 {
 	int ret;
 	int rc = 0;
 	unsigned long apid, apqi;
 	struct vfio_ap_queue *q;
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
 			     matrix_mdev->matrix.apm_max + 1) {
@@ -1286,49 +1292,45 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 	return rc;
 }
 
-static int vfio_ap_mdev_open_device(struct mdev_device *mdev)
+static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
 {
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev =
+		container_of(vdev, struct ap_matrix_mdev, vdev);
 	unsigned long events;
 	int ret;
 
-
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
 	matrix_mdev->group_notifier.notifier_call = vfio_ap_mdev_group_notifier;
 	events = VFIO_GROUP_NOTIFY_SET_KVM;
 
-	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+	ret = vfio_register_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
 				     &events, &matrix_mdev->group_notifier);
-	if (ret) {
-		module_put(THIS_MODULE);
+	if (ret)
 		return ret;
-	}
 
 	matrix_mdev->iommu_notifier.notifier_call = vfio_ap_mdev_iommu_notifier;
 	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
-	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
 				     &events, &matrix_mdev->iommu_notifier);
-	if (!ret)
-		return ret;
+	if (ret)
+		goto out_unregister_group;
+	return 0;
 
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+out_unregister_group:
+	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
-	module_put(THIS_MODULE);
 	return ret;
 }
 
-static void vfio_ap_mdev_close_device(struct mdev_device *mdev)
+static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
 {
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	struct ap_matrix_mdev *matrix_mdev =
+		container_of(vdev, struct ap_matrix_mdev, vdev);
 
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
 				 &matrix_mdev->iommu_notifier);
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
+	vfio_unregister_notifier(vdev->dev, VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
 	vfio_ap_mdev_unset_kvm(matrix_mdev, matrix_mdev->kvm);
-	module_put(THIS_MODULE);
 }
 
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
@@ -1351,11 +1353,12 @@ static int vfio_ap_mdev_get_device_info(unsigned long arg)
 	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
 
-static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
+static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 				    unsigned int cmd, unsigned long arg)
 {
+	struct ap_matrix_mdev *matrix_mdev =
+		container_of(vdev, struct ap_matrix_mdev, vdev);
 	int ret;
-	struct ap_matrix_mdev *matrix_mdev;
 
 	mutex_lock(&matrix_dev->lock);
 	switch (cmd) {
@@ -1363,13 +1366,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 		ret = vfio_ap_mdev_get_device_info(arg);
 		break;
 	case VFIO_DEVICE_RESET:
-		matrix_mdev = mdev_get_drvdata(mdev);
-		if (WARN(!matrix_mdev, "Driver data missing from mdev!!")) {
-			ret = -EINVAL;
-			break;
-		}
-
-		ret = vfio_ap_mdev_reset_queues(mdev);
+		ret = vfio_ap_mdev_reset_queues(matrix_mdev);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
@@ -1380,25 +1377,51 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
 	return ret;
 }
 
+static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
+	.open_device = vfio_ap_mdev_open_device,
+	.close_device = vfio_ap_mdev_close_device,
+	.ioctl = vfio_ap_mdev_ioctl,
+};
+
+static struct mdev_driver vfio_ap_matrix_driver = {
+	.driver = {
+		.name = "vfio_ap_mdev",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = vfio_ap_mdev_attr_groups,
+	},
+	.probe = vfio_ap_mdev_probe,
+	.remove = vfio_ap_mdev_remove,
+};
+
 static const struct mdev_parent_ops vfio_ap_matrix_ops = {
 	.owner			= THIS_MODULE,
+	.device_driver		= &vfio_ap_matrix_driver,
 	.supported_type_groups	= vfio_ap_mdev_type_groups,
-	.mdev_attr_groups	= vfio_ap_mdev_attr_groups,
-	.create			= vfio_ap_mdev_create,
-	.remove			= vfio_ap_mdev_remove,
-	.open_device		= vfio_ap_mdev_open_device,
-	.close_device		= vfio_ap_mdev_close_device,
-	.ioctl			= vfio_ap_mdev_ioctl,
 };
 
 int vfio_ap_mdev_register(void)
 {
+	int ret;
+
 	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
 
-	return mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_ops);
+	ret = mdev_register_driver(&vfio_ap_matrix_driver);
+	if (ret)
+		return ret;
+
+	ret = mdev_register_device(&matrix_dev->device, &vfio_ap_matrix_ops);
+	if (ret)
+		goto err_driver;
+	return 0;
+
+err_driver:
+	mdev_unregister_driver(&vfio_ap_matrix_driver);
+	return ret;
 }
 
 void vfio_ap_mdev_unregister(void)
 {
 	mdev_unregister_device(&matrix_dev->device);
+	mdev_unregister_driver(&vfio_ap_matrix_driver);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 22d2e0ca3ae5..77760e2b546f 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
+#include <linux/vfio.h>
 
 #include "ap_bus.h"
 
@@ -79,6 +80,7 @@ struct ap_matrix {
  * @kvm:	the struct holding guest's state
  */
 struct ap_matrix_mdev {
+	struct vfio_device vdev;
 	struct list_head node;
 	struct ap_matrix matrix;
 	struct notifier_block group_notifier;

