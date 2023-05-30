Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0977170D8
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 00:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjE3WkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 18:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjE3WkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 18:40:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDB2F9;
        Tue, 30 May 2023 15:40:06 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ULYYJw032377;
        Tue, 30 May 2023 22:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TPJzW9kl4kqBslNqhKvbULixVDHXrrKhic5x5/KhBUQ=;
 b=A5d/1YJx7YYr7DBKtkuy9z1U28L3u69kygA0F4fRAL6Ehy/vq+jkWrNG6UosRg77oQrY
 ThNs23CzgX07AaNf5nJ0l8kme3VxbSuJu3/zXgspwAntnQZy2rE5hYwOEDJpWWJo7otG
 EXmkEKjKj3F5RZXjmldPrp2cS9jh+49rBk8FjI7hIa98RJe2sTBjhJ32Mnq8ORWXIKch
 7DYwJV8RiHYXN/gPHAEcGrs7X5jceVOHgUDihH7u3zxNJB76OORESocmg9NEe+Y8TWbR
 L5HG0E3ybYM5Fs1UHbYDrxdbnKmMfrQHV2czl0/0AI7f3P44BSvA9BDLmRr8Anu9G8kC 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwrpva08f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:40:05 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34ULt6BX031763;
        Tue, 30 May 2023 22:40:05 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwrpva07q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:40:05 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34UM4s76003118;
        Tue, 30 May 2023 22:40:04 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3qu9g5ruy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:40:03 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UMe2gQ36045080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 22:40:02 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8CBE58109;
        Tue, 30 May 2023 22:35:41 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E58CB58100;
        Tue, 30 May 2023 22:35:40 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.88.233])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 22:35:40 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com
Subject: [PATCH 1/3] vfio: ap: realize the VFIO_DEVICE_GET_IRQ_INFO ioctl
Date:   Tue, 30 May 2023 18:35:36 -0400
Message-Id: <20230530223538.279198-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230530223538.279198-1-akrowiak@linux.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rIMfy_bbGWeBYY_t41P_H0jvHp--ZmLh
X-Proofpoint-ORIG-GUID: ecmzekmDYqMNta-qbEwc4nS3joNV4vKt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_16,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300184
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Realize the VFIO_DEVICE_GET_IRQ_INFO ioctl to retrieve the information for
the VFIO device request IRQ.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 30 +++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h         |  9 +++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index cfbcb864ab63..35cd90eee937 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1750,7 +1750,32 @@ static int vfio_ap_mdev_get_device_info(unsigned long arg)
 
 	info.flags = VFIO_DEVICE_FLAGS_AP | VFIO_DEVICE_FLAGS_RESET;
 	info.num_regions = 0;
-	info.num_irqs = 0;
+	info.num_irqs = VFIO_AP_NUM_IRQS;
+
+	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+}
+
+static ssize_t vfio_ap_get_irq_info(unsigned long arg)
+{
+	unsigned long minsz;
+	struct vfio_irq_info info;
+
+	minsz = offsetofend(struct vfio_irq_info, count);
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz || info.index >= VFIO_AP_NUM_IRQS)
+		return -EINVAL;
+
+	switch (info.index) {
+	case VFIO_AP_REQ_IRQ_INDEX:
+		info.count = 1;
+		info.flags = VFIO_IRQ_INFO_EVENTFD;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
@@ -1770,6 +1795,9 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 	case VFIO_DEVICE_RESET:
 		ret = vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
 		break;
+	case VFIO_DEVICE_GET_IRQ_INFO:
+			ret = vfio_ap_get_irq_info(arg);
+			break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..b71276bd7f91 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -646,6 +646,15 @@ enum {
 	VFIO_CCW_NUM_IRQS
 };
 
+/*
+ * The vfio-ap bus driver makes use of the following IRQ index mapping.
+ * Unimplemented IRQ types return a count of zero.
+ */
+enum {
+	VFIO_AP_REQ_IRQ_INDEX,
+	VFIO_AP_NUM_IRQS
+};
+
 /**
  * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
  *					      struct vfio_pci_hot_reset_info)
-- 
2.31.1

