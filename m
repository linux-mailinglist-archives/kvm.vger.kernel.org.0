Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54272B57CF
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 04:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgKQDVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 22:21:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726720AbgKQDVr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 22:21:47 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH31e00183798;
        Mon, 16 Nov 2020 22:21:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=XcBiRreBaGFkfI7D4gyVDbcAR8xB6zGEopZ1oZjLe2U=;
 b=Ns2+xsHRRx9NjUU/IyoBnuLjNrziRmtMufWuC9y2I4BMEATP/qCQ3HaLKdtZeEthHOm1
 QgBY3KJ50PJovhfxHX8C2lRSnB9QewmYf48sGQhGvfMMovo0u/AHKYlelvTwr1r5vyL3
 mJ1wahad754Yl1BWgZEE6GEkjsCBo96D9mYDKMysELnlk16gnf2ajLFAazQeqLipLmZG
 pu/WO6yyxqS4NY9sLnCtoM/DjOKiA+lVNrb/du5LzCJnytRRUmwgSQc14oUTo/Wl4ahb
 DETMeep1JmSAYCDze48HhGuyNlQbD8Bu4E6/epoF0JnX7UOtvwuBjXxc40VBXLqkFQy9 Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34v6348knh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 22:21:46 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AH3D5pC024133;
        Mon, 16 Nov 2020 22:21:46 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34v6348kn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 22:21:46 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AH39WOB014271;
        Tue, 17 Nov 2020 03:21:44 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 34t6v89c8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 03:21:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AH3Le5j48169432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:21:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0DA4A4055;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAA16A404D;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Nov 2020 03:21:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 6786CE14DC; Tue, 17 Nov 2020 04:21:40 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH 2/2] vfio-ccw: Wire in the request callback
Date:   Tue, 17 Nov 2020 04:21:39 +0100
Message-Id: <20201117032139.50988-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117032139.50988-1-farman@linux.ibm.com>
References: <20201117032139.50988-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=2 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170020
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The device is being unplugged, so pass the request to userspace to
ask for a graceful cleanup. This should free up the thread that
would otherwise loop waiting for the device to be fully released.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_ops.c     | 26 ++++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |  4 ++++
 include/uapi/linux/vfio.h           |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 8b3ed5b45277..68106be4ba7a 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -394,6 +394,7 @@ static int vfio_ccw_mdev_get_irq_info(struct vfio_irq_info *info)
 	switch (info->index) {
 	case VFIO_CCW_IO_IRQ_INDEX:
 	case VFIO_CCW_CRW_IRQ_INDEX:
+	case VFIO_CCW_REQ_IRQ_INDEX:
 		info->count = 1;
 		info->flags = VFIO_IRQ_INFO_EVENTFD;
 		break;
@@ -424,6 +425,9 @@ static int vfio_ccw_mdev_set_irqs(struct mdev_device *mdev,
 	case VFIO_CCW_CRW_IRQ_INDEX:
 		ctx = &private->crw_trigger;
 		break;
+	case VFIO_CCW_REQ_IRQ_INDEX:
+		ctx = &private->req_trigger;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -607,6 +611,27 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 	}
 }
 
+/* Request removal of the device*/
+static void vfio_ccw_mdev_request(struct mdev_device *mdev, unsigned int count)
+{
+	struct vfio_ccw_private *private = dev_get_drvdata(mdev_parent_dev(mdev));
+
+	if (!private)
+		return;
+
+	if (private->req_trigger) {
+		if (!(count % 10))
+			dev_notice_ratelimited(mdev_dev(private->mdev),
+					       "Relaying device request to user (#%u)\n",
+					       count);
+
+		eventfd_signal(private->req_trigger, 1);
+	} else if (count == 0) {
+		dev_notice(mdev_dev(private->mdev),
+			   "No device request channel registered, blocked until released by user\n");
+	}
+}
+
 static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
 	.owner			= THIS_MODULE,
 	.supported_type_groups  = mdev_type_groups,
@@ -617,6 +642,7 @@ static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
 	.read			= vfio_ccw_mdev_read,
 	.write			= vfio_ccw_mdev_write,
 	.ioctl			= vfio_ccw_mdev_ioctl,
+	.request		= vfio_ccw_mdev_request,
 };
 
 int vfio_ccw_mdev_reg(struct subchannel *sch)
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 8723156b29ea..b2c762eb42b9 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -84,7 +84,10 @@ struct vfio_ccw_crw {
  * @irb: irb info received from interrupt
  * @scsw: scsw info
  * @io_trigger: eventfd ctx for signaling userspace I/O results
+ * @crw_trigger: eventfd ctx for signaling userspace CRW information
+ * @req_trigger: eventfd ctx for signaling userspace to return device
  * @io_work: work for deferral process of I/O handling
+ * @crw_work: work for deferral process of CRW handling
  */
 struct vfio_ccw_private {
 	struct subchannel	*sch;
@@ -108,6 +111,7 @@ struct vfio_ccw_private {
 
 	struct eventfd_ctx	*io_trigger;
 	struct eventfd_ctx	*crw_trigger;
+	struct eventfd_ctx	*req_trigger;
 	struct work_struct	io_work;
 	struct work_struct	crw_work;
 } __aligned(8);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2f313a238a8f..d1812777139f 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -820,6 +820,7 @@ enum {
 enum {
 	VFIO_CCW_IO_IRQ_INDEX,
 	VFIO_CCW_CRW_IRQ_INDEX,
+	VFIO_CCW_REQ_IRQ_INDEX,
 	VFIO_CCW_NUM_IRQS
 };
 
-- 
2.17.1

