Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08AA7170C6
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 00:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbjE3Wft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 18:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjE3Wfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 18:35:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56ECEC;
        Tue, 30 May 2023 15:35:45 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UL8tDK030200;
        Tue, 30 May 2023 22:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qFHvjpf8FinpkJS7BIiB/qHfdH9ZaKPztAdXX2vhTSc=;
 b=NwXlvmAoURrmfnloIjGj31P3S7iwNu733n3hJyHXG86GFTbvXDd8GTHqLgqlWw1QVCZw
 h0eRsB4VHqvjVqohwZStixPOMiNPbCLfspA9tunge+6Pjyq7XnONHfcqNFlHN7jJNBKU
 W0zhqFdQ6+ZhagpubeukgPgBNYQilm4uGa9sc7Ktfio2/w69s2Fbpnd6OEpj3/QpkfVV
 qQupnR/MJrkivnvF5i51WFar+J3unWLPB5Bdt9Z5s+11RpY8ZKS8cHGzlo1tp78xRVgW
 32piT5rCP5cdl/Tl0eBn4XozlZgowLLumXpipz4rjm5H3h0bcLQVtKwOah5ukceh8RCz mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwr252bh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:45 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UMZiTf012600;
        Tue, 30 May 2023 22:35:44 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwr252bg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:44 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34UM1jLx013963;
        Tue, 30 May 2023 22:35:43 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3qu9g5rv2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:43 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UMZglI2360056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 22:35:42 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8122A58108;
        Tue, 30 May 2023 22:35:42 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C59B65810A;
        Tue, 30 May 2023 22:35:41 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.88.233])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 22:35:41 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com
Subject: [PATCH 2/3] vfio: ap: realize the VFIO_DEVICE_SET_IRQS ioctl
Date:   Tue, 30 May 2023 18:35:37 -0400
Message-Id: <20230530223538.279198-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230530223538.279198-1-akrowiak@linux.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VNTzSPA9MFQdDVTVX6EMt7hmjBT2EQ5L
X-Proofpoint-ORIG-GUID: f6G9eLheyFC72ocKg3eltD4eQaAmLeO_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_16,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300184
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Realize the VFIO_DEVICE_SET_IRQS ioctl to set an eventfd file descriptor
to be used by the vfio_ap device driver to signal a device request to
userspace.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c     | 83 +++++++++++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  3 +
 2 files changed, 86 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 35cd90eee937..44f159136891 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -716,6 +716,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
 		goto err_put_vdev;
+	matrix_mdev->req_trigger = NULL;
 	dev_set_drvdata(&mdev->dev, matrix_mdev);
 	mutex_lock(&matrix_dev->mdevs_lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
@@ -1780,6 +1781,85 @@ static ssize_t vfio_ap_get_irq_info(unsigned long arg)
 	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
 
+static int vfio_ap_irq_set_init(struct vfio_irq_set *irq_set, unsigned long arg)
+{
+	int ret;
+	size_t data_size;
+	unsigned long minsz;
+
+	minsz = offsetofend(struct vfio_irq_set, count);
+
+	if (copy_from_user(irq_set, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	ret = vfio_set_irqs_validate_and_prepare(irq_set, 1, VFIO_AP_NUM_IRQS,
+						 &data_size);
+	if (ret)
+		return ret;
+
+	if (!(irq_set->flags & VFIO_IRQ_SET_ACTION_TRIGGER))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vfio_ap_set_request_irq(struct ap_matrix_mdev *matrix_mdev,
+				   unsigned long arg)
+{
+	s32 fd;
+	void __user *data;
+	unsigned long minsz;
+	struct eventfd_ctx *req_trigger;
+
+	minsz = offsetofend(struct vfio_irq_set, count);
+	data = (void __user *)(arg + minsz);
+
+	if (get_user(fd, (s32 __user *)data))
+		return -EFAULT;
+
+	if (fd == -1) {
+		if (matrix_mdev->req_trigger)
+			eventfd_ctx_put(matrix_mdev->req_trigger);
+		matrix_mdev->req_trigger = NULL;
+	} else if (fd >= 0) {
+		req_trigger = eventfd_ctx_fdget(fd);
+		if (IS_ERR(req_trigger))
+			return PTR_ERR(req_trigger);
+
+		if (matrix_mdev->req_trigger)
+			eventfd_ctx_put(matrix_mdev->req_trigger);
+
+		matrix_mdev->req_trigger = req_trigger;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vfio_ap_set_irqs(struct ap_matrix_mdev *matrix_mdev,
+			    unsigned long arg)
+{
+	int ret;
+	struct vfio_irq_set irq_set;
+
+	ret = vfio_ap_irq_set_init(&irq_set, arg);
+	if (ret)
+		return ret;
+
+	switch (irq_set.flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
+	case VFIO_IRQ_SET_DATA_EVENTFD:
+		switch (irq_set.index) {
+		case VFIO_AP_REQ_IRQ_INDEX:
+			return vfio_ap_set_request_irq(matrix_mdev, arg);
+		default:
+			return -EINVAL;
+		}
+	default:
+		return -EINVAL;
+	}
+}
+
 static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 				    unsigned int cmd, unsigned long arg)
 {
@@ -1798,6 +1878,9 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 	case VFIO_DEVICE_GET_IRQ_INFO:
 			ret = vfio_ap_get_irq_info(arg);
 			break;
+	case VFIO_DEVICE_SET_IRQS:
+		ret = vfio_ap_set_irqs(matrix_mdev, arg);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 976a65f32e7d..4642bbdbd1b2 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/mdev.h>
 #include <linux/delay.h>
+#include <linux/eventfd.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
 #include <linux/vfio.h>
@@ -103,6 +104,7 @@ struct ap_queue_table {
  *		PQAP(AQIC) instruction.
  * @mdev:	the mediated device
  * @qtable:	table of queues (struct vfio_ap_queue) assigned to the mdev
+ * @req_trigger eventfd ctx for signaling userspace to return a device
  * @apm_add:	bitmap of APIDs added to the host's AP configuration
  * @aqm_add:	bitmap of APQIs added to the host's AP configuration
  * @adm_add:	bitmap of control domain numbers added to the host's AP
@@ -117,6 +119,7 @@ struct ap_matrix_mdev {
 	crypto_hook pqap_hook;
 	struct mdev_device *mdev;
 	struct ap_queue_table qtable;
+	struct eventfd_ctx *req_trigger;
 	DECLARE_BITMAP(apm_add, AP_DEVICES);
 	DECLARE_BITMAP(aqm_add, AP_DOMAINS);
 	DECLARE_BITMAP(adm_add, AP_DOMAINS);
-- 
2.31.1

