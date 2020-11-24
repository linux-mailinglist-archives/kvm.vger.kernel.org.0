Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974F32C335B
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733021AbgKXVki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:40:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732900AbgKXVkg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 16:40:36 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLVPvd117190;
        Tue, 24 Nov 2020 16:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gvlYq2bLMjNw8Ll4cnS7sihp6+NIekUApV8CIvZYbkg=;
 b=cQcfISI51dAgo2TqN0OT6mMYpohwH8qxJbIPuQq44QMZH3vc7f+GmqReTgvy1npRPGZA
 wlNdwcMmnSPz7fNwMjZkYlexcD0+oLC04Fvr+MYEpVD6aUKLvGHvf2YLfoywzfAH9yrr
 gZeY4XIEZ8RMaFJZi8/blf9THQoqcKZtFuJVmsnTnuS5g7sVKyCjNlGTtrDv/22HhhTg
 0KQyTVIgTMALgM06+kVjvuXxripnj+KQ7arzJNXBDcWGdPsGbdi0oHKNYaKURBJ3A93+
 heHBfvWH224/MiErDwpdhx4+394DB54Y8JaJnAYyGskpRL927rNUFlo12WaQFkGh6VsC Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3513uwn0r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:33 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOLVtQN119504;
        Tue, 24 Nov 2020 16:40:33 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3513uwn0qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:40:33 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOLchrv009176;
        Tue, 24 Nov 2020 21:40:32 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 34xth92m8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 21:40:32 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOLeV6u64291176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 21:40:31 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04D4FAE05C;
        Tue, 24 Nov 2020 21:40:31 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE76FAE05F;
        Tue, 24 Nov 2020 21:40:29 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.195.249])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 21:40:29 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v12 04/17] s390/vfio-ap: No need to disable IRQ after queue reset
Date:   Tue, 24 Nov 2020 16:40:03 -0500
Message-Id: <20201124214016.3013-5-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20201124214016.3013-1-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_08:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=11
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The queues assigned to a matrix mediated device are currently reset when:

* The VFIO_DEVICE_RESET ioctl is invoked
* The mdev fd is closed by userspace (QEMU)
* The mdev is removed from sysfs.

Immediately after the reset of a queue, a call is made to disable
interrupts for the queue. This is entirely unnecessary because the reset of
a queue disables interrupts, so this will be removed.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 8e6972495daa..dc699fd54505 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -26,14 +26,6 @@
 
 static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
 
-static int match_apqn(struct device *dev, const void *data)
-{
-	struct vfio_ap_queue *q = dev_get_drvdata(dev);
-
-	return (q->apqn == *(int *)(data)) ? 1 : 0;
-}
-
-
 /**
  * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
  * @matrix_mdev: the associated mediated matrix
@@ -1121,20 +1113,6 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static void vfio_ap_irq_disable_apqn(int apqn)
-{
-	struct device *dev;
-	struct vfio_ap_queue *q;
-
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (dev) {
-		q = dev_get_drvdata(dev);
-		vfio_ap_irq_disable(q);
-		put_device(dev);
-	}
-}
-
 static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
 				    unsigned int retry)
 {
@@ -1169,6 +1147,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 {
 	int ret;
 	int rc = 0;
+	struct vfio_ap_queue *q;
 	unsigned long apid, apqi;
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
@@ -1184,7 +1163,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 			 */
 			if (ret)
 				rc = ret;
-			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
+
+			q = vfio_ap_get_queue(matrix_mdev, AP_MKQID(apid, apqi);
+			if (q)
+				vfio_ap_free_aqic_resources(q);
 		}
 	}
 
-- 
2.21.1

