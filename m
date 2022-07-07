Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C190656A4B1
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbiGGN6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiGGN5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:57:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17727BDE;
        Thu,  7 Jul 2022 06:57:47 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267DatSe029570;
        Thu, 7 Jul 2022 13:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LltDqOy6LWqjPExt9uTJfW8vXeIDoAnqKNQQ+FHadSU=;
 b=I+C8HXBbaIUjZ574qAefSZBZKXCYza6w4qRz/Oy1P3s9RLLN9uZGVj6S4D59MlXNHab+
 b9VXkCKjz0+l72GAKTIsVK78v5jAH7KxMauSsKD8pSgeuvzwGbzD9CxrEF15MQ3Tay1p
 gL6NACbp/4Wa+k/F0DsUCfNmMWiqVOtPor9dSJ8pAZJW3ZrYbN6t9YQdY7JOZthSNVNr
 WeUtWl1ei2+HzW1+1b0ObYRMQGqABHQ6CizTqCOPYj6a25KR/uG/RkQpIc+notPT7wSM
 G2ye9BE/JXA0VpTR06AjMwmONYpcHy9LG2ryjaexXSJsWFYFZKcZJPe1yTEMliTk9trZ 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5yxv9tp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:45 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267DckI7007988;
        Thu, 7 Jul 2022 13:57:44 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5yxv9tnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:44 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267DtbUG019284;
        Thu, 7 Jul 2022 13:57:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3h4ucy9yd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:57:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267Dvd0u18481612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 13:57:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A85EFA4065;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96116A405F;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 Jul 2022 13:57:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 22931E028C; Thu,  7 Jul 2022 15:57:39 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v4 06/11] vfio/ccw: Flatten MDEV device (un)register
Date:   Thu,  7 Jul 2022 15:57:32 +0200
Message-Id: <20220707135737.720765-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707135737.720765-1-farman@linux.ibm.com>
References: <20220707135737.720765-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f5-JJdDoxVFo9PfZl4EMy3z3qel9gYq5
X-Proofpoint-ORIG-GUID: tQRa-AnrTOpsG3yWI2tlZwJNZW7iD6U8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_ccw_mdev_(un)reg routines are merely vfio-ccw routines that
pass control to mdev_(un)register_device. Since there's only one
caller of each, let's just call the mdev routines directly.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     |  4 ++--
 drivers/s390/cio/vfio_ccw_ops.c     | 10 ----------
 drivers/s390/cio/vfio_ccw_private.h |  3 ---
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 279ad2161f17..fe87a2652a22 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -240,7 +240,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 
 	private->state = VFIO_CCW_STATE_STANDBY;
 
-	ret = vfio_ccw_mdev_reg(sch);
+	ret = mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
 	if (ret)
 		goto out_disable;
 
@@ -262,7 +262,7 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 
 	vfio_ccw_sch_quiesce(sch);
-	vfio_ccw_mdev_unreg(sch);
+	mdev_unregister_device(&sch->dev);
 
 	dev_set_drvdata(&sch->dev, NULL);
 
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 81377270d4a7..a7ea9358e461 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -654,13 +654,3 @@ struct mdev_driver vfio_ccw_mdev_driver = {
 	.remove = vfio_ccw_mdev_remove,
 	.supported_type_groups  = mdev_type_groups,
 };
-
-int vfio_ccw_mdev_reg(struct subchannel *sch)
-{
-	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_driver);
-}
-
-void vfio_ccw_mdev_unreg(struct subchannel *sch)
-{
-	mdev_unregister_device(&sch->dev);
-}
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index 5891bea8ce41..a2584c130e79 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -117,9 +117,6 @@ struct vfio_ccw_private {
 	struct work_struct	crw_work;
 } __aligned(8);
 
-int vfio_ccw_mdev_reg(struct subchannel *sch);
-void vfio_ccw_mdev_unreg(struct subchannel *sch);
-
 int vfio_ccw_sch_quiesce(struct subchannel *sch);
 
 extern struct mdev_driver vfio_ccw_mdev_driver;
-- 
2.34.1

