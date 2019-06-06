Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE0237367
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 13:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfFFLvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 07:51:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728496AbfFFLvu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 07:51:50 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56BmYp5136413
        for <kvm@vger.kernel.org>; Thu, 6 Jun 2019 07:51:48 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sy20ugxsd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 07:51:47 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 6 Jun 2019 12:51:46 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 12:51:43 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56BpfUJ14287322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 11:51:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 169B7AE056;
        Thu,  6 Jun 2019 11:51:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 573ACAE04D;
        Thu,  6 Jun 2019 11:51:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Jun 2019 11:51:40 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: [PATCH v4 7/8] virtio/s390: use DMA memory for ccw I/O and classic notifiers
Date:   Thu,  6 Jun 2019 13:51:26 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606115127.55519-1-pasic@linux.ibm.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060611-0016-0000-0000-000002864895
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060611-0017-0000-0000-000032E3638D
Message-Id: <20190606115127.55519-8-pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before virtio-ccw could get away with not using DMA API for the pieces of
memory it does ccw I/O with. With protected virtualization this has to
change, since the hypervisor needs to read and sometimes also write these
pieces of memory.

The hypervisor is supposed to poke the classic notifiers, if these are
used, out of band with regards to ccw I/O. So these need to be allocated
as DMA memory (which is shared memory for protected virtualization
guests).

Let us factor out everything from struct virtio_ccw_device that needs to
be DMA memory in a satellite that is allocated as such.

Note: The control blocks of I/O instructions do not need to be shared.
These are marshalled by the ultravisor.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/s390/virtio/virtio_ccw.c | 171 ++++++++++++++++---------------
 1 file changed, 90 insertions(+), 81 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index e96a8cc56ec2..e5e10aa54aa1 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -46,9 +46,15 @@ struct vq_config_block {
 #define VIRTIO_CCW_CONFIG_SIZE 0x100
 /* same as PCI config space size, should be enough for all drivers */
 
+struct vcdev_dma_area {
+	unsigned long indicators;
+	unsigned long indicators2;
+	struct vq_config_block config_block;
+	__u8 status;
+};
+
 struct virtio_ccw_device {
 	struct virtio_device vdev;
-	__u8 *status;
 	__u8 config[VIRTIO_CCW_CONFIG_SIZE];
 	struct ccw_device *cdev;
 	__u32 curr_io;
@@ -58,24 +64,22 @@ struct virtio_ccw_device {
 	spinlock_t lock;
 	struct mutex io_lock; /* Serializes I/O requests */
 	struct list_head virtqueues;
-	unsigned long indicators;
-	unsigned long indicators2;
-	struct vq_config_block *config_block;
 	bool is_thinint;
 	bool going_away;
 	bool device_lost;
 	unsigned int config_ready;
 	void *airq_info;
+	struct vcdev_dma_area *dma_area;
 };
 
 static inline unsigned long *indicators(struct virtio_ccw_device *vcdev)
 {
-	return &vcdev->indicators;
+	return &vcdev->dma_area->indicators;
 }
 
 static inline unsigned long *indicators2(struct virtio_ccw_device *vcdev)
 {
-	return &vcdev->indicators2;
+	return &vcdev->dma_area->indicators2;
 }
 
 struct vq_info_block_legacy {
@@ -336,8 +340,8 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 	struct airq_info *airq_info = vcdev->airq_info;
 
 	if (vcdev->is_thinint) {
-		thinint_area = kzalloc(sizeof(*thinint_area),
-				       GFP_DMA | GFP_KERNEL);
+		thinint_area = ccw_device_dma_zalloc(vcdev->cdev,
+						     sizeof(*thinint_area));
 		if (!thinint_area)
 			return;
 		thinint_area->summary_indicator =
@@ -348,8 +352,8 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		ccw->cda = (__u32)(unsigned long) thinint_area;
 	} else {
 		/* payload is the address of the indicators */
-		indicatorp = kmalloc(sizeof(indicators(vcdev)),
-				     GFP_DMA | GFP_KERNEL);
+		indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
+						   sizeof(indicators(vcdev)));
 		if (!indicatorp)
 			return;
 		*indicatorp = 0;
@@ -369,8 +373,8 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 			 "Failed to deregister indicators (%d)\n", ret);
 	else if (vcdev->is_thinint)
 		virtio_ccw_drop_indicators(vcdev);
-	kfree(indicatorp);
-	kfree(thinint_area);
+	ccw_device_dma_free(vcdev->cdev, indicatorp, sizeof(indicators(vcdev)));
+	ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_area));
 }
 
 static inline long __do_kvm_notify(struct subchannel_id schid,
@@ -417,15 +421,15 @@ static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
 {
 	int ret;
 
-	vcdev->config_block->index = index;
+	vcdev->dma_area->config_block.index = index;
 	ccw->cmd_code = CCW_CMD_READ_VQ_CONF;
 	ccw->flags = 0;
 	ccw->count = sizeof(struct vq_config_block);
-	ccw->cda = (__u32)(unsigned long)(vcdev->config_block);
+	ccw->cda = (__u32)(unsigned long)(&vcdev->dma_area->config_block);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_VQ_CONF);
 	if (ret)
 		return ret;
-	return vcdev->config_block->num ?: -ENOENT;
+	return vcdev->dma_area->config_block.num ?: -ENOENT;
 }
 
 static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
@@ -470,7 +474,8 @@ static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
 			 ret, index);
 
 	vring_del_virtqueue(vq);
-	kfree(info->info_block);
+	ccw_device_dma_free(vcdev->cdev, info->info_block,
+			    sizeof(*info->info_block));
 	kfree(info);
 }
 
@@ -480,7 +485,7 @@ static void virtio_ccw_del_vqs(struct virtio_device *vdev)
 	struct ccw1 *ccw;
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return;
 
@@ -489,7 +494,7 @@ static void virtio_ccw_del_vqs(struct virtio_device *vdev)
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
 		virtio_ccw_del_vq(vq, ccw);
 
-	kfree(ccw);
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 }
 
 static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
@@ -512,8 +517,8 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 		err = -ENOMEM;
 		goto out_err;
 	}
-	info->info_block = kzalloc(sizeof(*info->info_block),
-				   GFP_DMA | GFP_KERNEL);
+	info->info_block = ccw_device_dma_zalloc(vcdev->cdev,
+						 sizeof(*info->info_block));
 	if (!info->info_block) {
 		dev_warn(&vcdev->cdev->dev, "no info block\n");
 		err = -ENOMEM;
@@ -577,7 +582,8 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	if (vq)
 		vring_del_virtqueue(vq);
 	if (info) {
-		kfree(info->info_block);
+		ccw_device_dma_free(vcdev->cdev, info->info_block,
+				    sizeof(*info->info_block));
 	}
 	kfree(info);
 	return ERR_PTR(err);
@@ -591,7 +597,8 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 	struct virtio_thinint_area *thinint_area = NULL;
 	struct airq_info *info;
 
-	thinint_area = kzalloc(sizeof(*thinint_area), GFP_DMA | GFP_KERNEL);
+	thinint_area = ccw_device_dma_zalloc(vcdev->cdev,
+					     sizeof(*thinint_area));
 	if (!thinint_area) {
 		ret = -ENOMEM;
 		goto out;
@@ -627,7 +634,7 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 		virtio_ccw_drop_indicators(vcdev);
 	}
 out:
-	kfree(thinint_area);
+	ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_area));
 	return ret;
 }
 
@@ -643,7 +650,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	int ret, i, queue_idx = 0;
 	struct ccw1 *ccw;
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return -ENOMEM;
 
@@ -667,7 +674,8 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	 * We need a data area under 2G to communicate. Our payload is
 	 * the address of the indicators.
 	*/
-	indicatorp = kmalloc(sizeof(indicators(vcdev)), GFP_DMA | GFP_KERNEL);
+	indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
+					   sizeof(indicators(vcdev)));
 	if (!indicatorp)
 		goto out;
 	*indicatorp = (unsigned long) indicators(vcdev);
@@ -699,12 +707,16 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	if (ret)
 		goto out;
 
-	kfree(indicatorp);
-	kfree(ccw);
+	if (indicatorp)
+		ccw_device_dma_free(vcdev->cdev, indicatorp,
+				    sizeof(indicators(vcdev)));
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 	return 0;
 out:
-	kfree(indicatorp);
-	kfree(ccw);
+	if (indicatorp)
+		ccw_device_dma_free(vcdev->cdev, indicatorp,
+				    sizeof(indicators(vcdev)));
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 	virtio_ccw_del_vqs(vdev);
 	return ret;
 }
@@ -714,12 +726,12 @@ static void virtio_ccw_reset(struct virtio_device *vdev)
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct ccw1 *ccw;
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return;
 
 	/* Zero status bits. */
-	*vcdev->status = 0;
+	vcdev->dma_area->status = 0;
 
 	/* Send a reset ccw on device. */
 	ccw->cmd_code = CCW_CMD_VDEV_RESET;
@@ -727,22 +739,22 @@ static void virtio_ccw_reset(struct virtio_device *vdev)
 	ccw->count = 0;
 	ccw->cda = 0;
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
-	kfree(ccw);
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 }
 
 static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct virtio_feature_desc *features;
+	struct ccw1 *ccw;
 	int ret;
 	u64 rc;
-	struct ccw1 *ccw;
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return 0;
 
-	features = kzalloc(sizeof(*features), GFP_DMA | GFP_KERNEL);
+	features = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*features));
 	if (!features) {
 		rc = 0;
 		goto out_free;
@@ -775,8 +787,8 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 		rc |= (u64)le32_to_cpu(features->features) << 32;
 
 out_free:
-	kfree(features);
-	kfree(ccw);
+	ccw_device_dma_free(vcdev->cdev, features, sizeof(*features));
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 	return rc;
 }
 
@@ -801,11 +813,11 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 		return -EINVAL;
 	}
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return -ENOMEM;
 
-	features = kzalloc(sizeof(*features), GFP_DMA | GFP_KERNEL);
+	features = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*features));
 	if (!features) {
 		ret = -ENOMEM;
 		goto out_free;
@@ -840,8 +852,8 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 
 out_free:
-	kfree(features);
-	kfree(ccw);
+	ccw_device_dma_free(vcdev->cdev, features, sizeof(*features));
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 
 	return ret;
 }
@@ -855,11 +867,12 @@ static void virtio_ccw_get_config(struct virtio_device *vdev,
 	void *config_area;
 	unsigned long flags;
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return;
 
-	config_area = kzalloc(VIRTIO_CCW_CONFIG_SIZE, GFP_DMA | GFP_KERNEL);
+	config_area = ccw_device_dma_zalloc(vcdev->cdev,
+					    VIRTIO_CCW_CONFIG_SIZE);
 	if (!config_area)
 		goto out_free;
 
@@ -881,8 +894,8 @@ static void virtio_ccw_get_config(struct virtio_device *vdev,
 		memcpy(buf, config_area + offset, len);
 
 out_free:
-	kfree(config_area);
-	kfree(ccw);
+	ccw_device_dma_free(vcdev->cdev, config_area, VIRTIO_CCW_CONFIG_SIZE);
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 }
 
 static void virtio_ccw_set_config(struct virtio_device *vdev,
@@ -894,11 +907,12 @@ static void virtio_ccw_set_config(struct virtio_device *vdev,
 	void *config_area;
 	unsigned long flags;
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return;
 
-	config_area = kzalloc(VIRTIO_CCW_CONFIG_SIZE, GFP_DMA | GFP_KERNEL);
+	config_area = ccw_device_dma_zalloc(vcdev->cdev,
+					    VIRTIO_CCW_CONFIG_SIZE);
 	if (!config_area)
 		goto out_free;
 
@@ -917,61 +931,61 @@ static void virtio_ccw_set_config(struct virtio_device *vdev,
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_CONFIG);
 
 out_free:
-	kfree(config_area);
-	kfree(ccw);
+	ccw_device_dma_free(vcdev->cdev, config_area, VIRTIO_CCW_CONFIG_SIZE);
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 }
 
 static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
-	u8 old_status = *vcdev->status;
+	u8 old_status = vcdev->dma_area->status;
 	struct ccw1 *ccw;
 
 	if (vcdev->revision < 1)
-		return *vcdev->status;
+		return vcdev->dma_area->status;
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return old_status;
 
 	ccw->cmd_code = CCW_CMD_READ_STATUS;
 	ccw->flags = 0;
-	ccw->count = sizeof(*vcdev->status);
-	ccw->cda = (__u32)(unsigned long)vcdev->status;
+	ccw->count = sizeof(vcdev->dma_area->status);
+	ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_STATUS);
 /*
  * If the channel program failed (should only happen if the device
  * was hotunplugged, and then we clean up via the machine check
- * handler anyway), vcdev->status was not overwritten and we just
+ * handler anyway), vcdev->dma_area->status was not overwritten and we just
  * return the old status, which is fine.
 */
-	kfree(ccw);
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 
-	return *vcdev->status;
+	return vcdev->dma_area->status;
 }
 
 static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
-	u8 old_status = *vcdev->status;
+	u8 old_status = vcdev->dma_area->status;
 	struct ccw1 *ccw;
 	int ret;
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return;
 
 	/* Write the status to the host. */
-	*vcdev->status = status;
+	vcdev->dma_area->status = status;
 	ccw->cmd_code = CCW_CMD_WRITE_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(status);
-	ccw->cda = (__u32)(unsigned long)vcdev->status;
+	ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_STATUS);
 	/* Write failed? We assume status is unchanged. */
 	if (ret)
-		*vcdev->status = old_status;
-	kfree(ccw);
+		vcdev->dma_area->status = old_status;
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 }
 
 static const char *virtio_ccw_bus_name(struct virtio_device *vdev)
@@ -1004,8 +1018,8 @@ static void virtio_ccw_release_dev(struct device *_d)
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_ccw_device *vcdev = to_vc_device(dev);
 
-	kfree(vcdev->status);
-	kfree(vcdev->config_block);
+	ccw_device_dma_free(vcdev->cdev, vcdev->dma_area,
+			    sizeof(*vcdev->dma_area));
 	kfree(vcdev);
 }
 
@@ -1213,12 +1227,12 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 	struct ccw1 *ccw;
 	int ret;
 
-	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
 		return -ENOMEM;
-	rev = kzalloc(sizeof(*rev), GFP_DMA | GFP_KERNEL);
+	rev = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*rev));
 	if (!rev) {
-		kfree(ccw);
+		ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
 		return -ENOMEM;
 	}
 
@@ -1248,8 +1262,8 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 		}
 	} while (ret == -EOPNOTSUPP);
 
-	kfree(ccw);
-	kfree(rev);
+	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
+	ccw_device_dma_free(vcdev->cdev, rev, sizeof(*rev));
 	return ret;
 }
 
@@ -1266,14 +1280,10 @@ static int virtio_ccw_online(struct ccw_device *cdev)
 		goto out_free;
 	}
 	vcdev->vdev.dev.parent = &cdev->dev;
-	vcdev->config_block = kzalloc(sizeof(*vcdev->config_block),
-				   GFP_DMA | GFP_KERNEL);
-	if (!vcdev->config_block) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-	vcdev->status = kzalloc(sizeof(*vcdev->status), GFP_DMA | GFP_KERNEL);
-	if (!vcdev->status) {
+	vcdev->cdev = cdev;
+	vcdev->dma_area = ccw_device_dma_zalloc(vcdev->cdev,
+						sizeof(*vcdev->dma_area));
+	if (!vcdev->dma_area) {
 		ret = -ENOMEM;
 		goto out_free;
 	}
@@ -1282,7 +1292,6 @@ static int virtio_ccw_online(struct ccw_device *cdev)
 
 	vcdev->vdev.dev.release = virtio_ccw_release_dev;
 	vcdev->vdev.config = &virtio_ccw_config_ops;
-	vcdev->cdev = cdev;
 	init_waitqueue_head(&vcdev->wait_q);
 	INIT_LIST_HEAD(&vcdev->virtqueues);
 	spin_lock_init(&vcdev->lock);
@@ -1313,8 +1322,8 @@ static int virtio_ccw_online(struct ccw_device *cdev)
 	return ret;
 out_free:
 	if (vcdev) {
-		kfree(vcdev->status);
-		kfree(vcdev->config_block);
+		ccw_device_dma_free(vcdev->cdev, vcdev->dma_area,
+				    sizeof(*vcdev->dma_area));
 	}
 	kfree(vcdev);
 	return ret;
-- 
2.17.1

