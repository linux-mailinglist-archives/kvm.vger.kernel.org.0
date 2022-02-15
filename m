Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4DE4B5F60
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 01:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiBOAvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 19:51:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiBOAu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 19:50:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5914E13C390;
        Mon, 14 Feb 2022 16:50:51 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EMBSog010788;
        Tue, 15 Feb 2022 00:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=e0kCJ6KeccdXkDQy5is2/UWgfwmDMMR92dwhfklbB44=;
 b=aTubYoCpnI+y2F0UVOx1aTxPozR50vm4BFK49n3bwYz5unF+Qxl8BtI7ptIt50A/TksX
 papAJr2v0HU45loT1CPL1PnDbfvNMo8ZGpI7UTnITb4um1juSITs6ilGYFwapjISqm7W
 Ugvqalzyv7P+l1Ar38tw3WSY5pvZKj8Bz2cymupB9V2upyHWcsQAQ4K5Up04Ckw7rXx5
 K1d3mmu4i4LV18QZsgeaDoayu9WUMLUilc105L7uHNnpnmXhh7az5JhfU0DUdmO0RRXe
 V5L1XLjs2Xqh1HT9M6Ym6IvNa0c4RbjVup54F76dmf4SKfgH/QcMkmZHyaHEwc1/dLYV Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7avfe477-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:48 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21F0kReA026295;
        Tue, 15 Feb 2022 00:50:48 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7avfe471-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:47 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21F0g7DV009247;
        Tue, 15 Feb 2022 00:50:47 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03wdc.us.ibm.com with ESMTP id 3e64hacn7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 00:50:47 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21F0okGt40632606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 00:50:46 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B4BC124055;
        Tue, 15 Feb 2022 00:50:46 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C10D5124052;
        Tue, 15 Feb 2022 00:50:45 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.92.58])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 00:50:45 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v18 03/18] s390/vfio-ap: use new AP bus interface to search for queue devices
Date:   Mon, 14 Feb 2022 19:50:25 -0500
Message-Id: <20220215005040.52697-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kH1ctBNdfHoXPYZleXMzM3iLT5aEuevU
X-Proofpoint-ORIG-GUID: ikAdRn1qnKhfue63KSNL9xpqlxhYUKWm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150001
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch refactors the vfio_ap device driver to use the AP bus's
ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
information about a queue that is bound to the vfio_ap device driver.
The bus's ap_get_qdev() function retrieves the queue device from a
hashtable keyed by APQN. This is much more efficient than looping over
the list of devices attached to the AP bus by several orders of
magnitude.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index abc0b9b88386..2b6b61719cce 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -28,13 +28,6 @@ static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
 
-static int match_apqn(struct device *dev, const void *data)
-{
-	struct vfio_ap_queue *q = dev_get_drvdata(dev);
-
-	return (q->apqn == *(int *)(data)) ? 1 : 0;
-}
-
 /**
  * vfio_ap_get_queue - retrieve a queue with a specific APQN from a list
  * @matrix_mdev: the associated mediated matrix
@@ -1193,15 +1186,17 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 {
-	struct device *dev;
+	struct ap_queue *queue;
 	struct vfio_ap_queue *q = NULL;
 
-	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
-				 &apqn, match_apqn);
-	if (dev) {
-		q = dev_get_drvdata(dev);
-		put_device(dev);
-	}
+	queue = ap_get_qdev(apqn);
+	if (!queue)
+		return NULL;
+
+	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver)
+		q = dev_get_drvdata(&queue->ap_dev.device);
+
+	put_device(&queue->ap_dev.device);
 
 	return q;
 }
-- 
2.31.1

