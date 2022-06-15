Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FCA54D2B0
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348631AbiFOUeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346906AbiFOUda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:33:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBBC31DD7;
        Wed, 15 Jun 2022 13:33:29 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FJkKcl023055;
        Wed, 15 Jun 2022 20:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Dudzy4G990uznrPqWLhzBG10xTXSUjrkv+jp+RxM6lo=;
 b=FZomiNnXkqAAxnZDWrrCz02XUJlpQg8tv6Mno7iOfi0M+SmaNGw/cFc8Is2bGxAoJjvL
 dHxo/X3pkhI3ysUXHu41dC/MspGdqjZ7CpCrs5VPf4ZZCMXU2akqiS1nT+P8axUjKOix
 gWa1ggAT5v/nJbVTiQA9AOmiqSwBpHPCJCnoTgj3hbjhenGbDyTiJfk7vTVHx5JXRZ4s
 XjgCS9ofAkf4zbI94PZo8GNLCZG82BQkXL9Q7SuXhAjT8MkktUhkjt0cTn2hlclkiGeD
 tufPnts5zDn3TlyXDpQnbANT6zeNAy7Ybu4KnaTQr2j4YhLhsdc6IRZQFiX+hHsXEbfs 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqfvj37k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:26 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25FK8Sit000718;
        Wed, 15 Jun 2022 20:33:26 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gqfvj37j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:26 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25FKLVjq015732;
        Wed, 15 Jun 2022 20:33:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3gmjp8vwqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 20:33:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25FKXKr614614906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 20:33:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81E04A405B;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F5E6A4054;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 15 Jun 2022 20:33:20 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 14D48E008F; Wed, 15 Jun 2022 22:33:20 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 06/10] vfio/ccw: Flatten MDEV device (un)register
Date:   Wed, 15 Jun 2022 22:33:14 +0200
Message-Id: <20220615203318.3830778-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615203318.3830778-1-farman@linux.ibm.com>
References: <20220615203318.3830778-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IYq9nu4w3HLqzBQ-sB7C_QfyqUmfyIjv
X-Proofpoint-ORIG-GUID: pHiaUAoPHQwCOLEEZKohNmmGRX4eX00N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_16,2022-06-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 adultscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206150074
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
index 5c128eec596b..4cfdd5fc0961 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -117,9 +117,6 @@ struct vfio_ccw_private {
 	struct work_struct	crw_work;
 } __aligned(8);
 
-extern int vfio_ccw_mdev_reg(struct subchannel *sch);
-extern void vfio_ccw_mdev_unreg(struct subchannel *sch);
-
 extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
 
 extern struct mdev_driver vfio_ccw_mdev_driver;
-- 
2.32.0

