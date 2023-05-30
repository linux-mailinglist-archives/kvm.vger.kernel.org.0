Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375D77170C7
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 00:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbjE3Wfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 18:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbjE3Wfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 18:35:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0F393;
        Tue, 30 May 2023 15:35:46 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UKehde029395;
        Tue, 30 May 2023 22:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vyK0SFfPtxGTegWHGbHIf/of/w0CUmEM1+FAEBe90To=;
 b=ULbZQCyVxDg07PJ1+qIZsNdb1k93vVclmYUR9AdeFjnfOjP3L+OREBke6bMt7qyKVX7n
 iZYdXILJaiDMu6rWvpNTGNDJCYzfpsPe2L018iowDFG3ouc75V3YSdXW1jFevOlBZ6Ra
 d5TfrVrtzyqMORqJN0mdVJiQdm5XxlGy0tLwLEs4N5McqnGsq9HsqvHgjfB9AIihnCms
 ozy0/CvRnAg9S/SeHaXPqv22ctxkKwRdXBfirje40VnryAojaoP1cahAft9/joUU35Pe
 QHW8yV57iuS8glHP3w3V52hsLZa7UX8tJ8oiLLFsFmmvN4NbRMKyGdNNvGhXvbBskGyH DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwm1pgrqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:45 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UMQS2H024001;
        Tue, 30 May 2023 22:35:45 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwm1pgrq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:45 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34UFPYm9017360;
        Tue, 30 May 2023 22:35:44 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3qu9g55tqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 22:35:44 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UMZhZf22216984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 22:35:43 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59AF55810B;
        Tue, 30 May 2023 22:35:43 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E8A95810A;
        Tue, 30 May 2023 22:35:42 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.88.233])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 22:35:42 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com
Subject: [PATCH 3/3] s390/vfio-ap: Wire in the vfio_device_ops request callback
Date:   Tue, 30 May 2023 18:35:38 -0400
Message-Id: <20230530223538.279198-4-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230530223538.279198-1-akrowiak@linux.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xX-B1izHkR6zFY2YYoIuutFE6MDxWm5u
X-Proofpoint-GUID: UKrVQEiqSptqVbE2baZZz3J5cSThbSWt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_16,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
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

The mdev device is being removed, so pass the request to userspace to
ask for a graceful cleanup. This should free up the thread that
would otherwise loop waiting for the device to be fully released.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 44f159136891..a8f58e133e6e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1736,6 +1736,26 @@ static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
 	vfio_ap_mdev_unset_kvm(matrix_mdev);
 }
 
+static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
+{
+	struct device *dev = vdev->dev;
+	struct ap_matrix_mdev *matrix_mdev;
+
+	matrix_mdev = container_of(vdev, struct ap_matrix_mdev, vdev);
+
+	if (matrix_mdev->req_trigger) {
+		if (!(count % 10))
+			dev_notice_ratelimited(dev,
+					       "Relaying device request to user (#%u)\n",
+					       count);
+
+		eventfd_signal(matrix_mdev->req_trigger, 1);
+	} else if (count == 0) {
+		dev_notice(dev,
+			   "No device request registered, blocked until released by user\n");
+	}
+}
+
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
 {
 	unsigned long minsz;
@@ -1955,6 +1975,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
 	.bind_iommufd = vfio_iommufd_emulated_bind,
 	.unbind_iommufd = vfio_iommufd_emulated_unbind,
 	.attach_ioas = vfio_iommufd_emulated_attach_ioas,
+	.request = vfio_ap_mdev_request
 };
 
 static struct mdev_driver vfio_ap_matrix_driver = {
-- 
2.31.1

