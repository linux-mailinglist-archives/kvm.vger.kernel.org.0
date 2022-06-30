Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475C456242E
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 22:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbiF3UhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 16:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiF3Ug6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 16:36:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEE1393FB;
        Thu, 30 Jun 2022 13:36:57 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25UKHwo0008143;
        Thu, 30 Jun 2022 20:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Dudzy4G990uznrPqWLhzBG10xTXSUjrkv+jp+RxM6lo=;
 b=ka36qycFoQ88PaoZ/YY+jssnNexVWuXm/WQMCf63Bk2zUZJsVShw+ZHx8SHf1S9ug0nF
 jEOFpwGywQTWmL7z3bG1NrdNyEmPvPBsCw6lDTmizHxKI/qKl2fi9D/Hx9vAFyjN6tUQ
 v5JymQV6ON+ufLIGHgZlhkFtDiM0zz8DXcyPobe1gVUH70S1KnOAfJslOhED6VLJbf2K
 HD/9BO2ALmtdWtzXzywsdoNca65npTfzaHQLL5L6hKvMTNoIDLPbf0gysKBf0PaasBIL
 W6TPzdPyUdzebaRXn96OkB61JtiVikNMK2Kh18aF7p7g42JIM5b00fObbbtONxj0lj/6 xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jr30f40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:55 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25UKIGeT008533;
        Thu, 30 Jun 2022 20:36:54 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1jr30f33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:54 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25UKL32U020971;
        Thu, 30 Jun 2022 20:36:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3gwt090nt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jun 2022 20:36:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25UKanmV22020510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 20:36:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 539E3A405C;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 415C9A4054;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 20:36:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 048A6E029F; Thu, 30 Jun 2022 22:36:49 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 06/11] vfio/ccw: Flatten MDEV device (un)register
Date:   Thu, 30 Jun 2022 22:36:42 +0200
Message-Id: <20220630203647.2529815-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220630203647.2529815-1-farman@linux.ibm.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EMjOQHieHPVpxsN-58qgMtaGFQuwg1mb
X-Proofpoint-ORIG-GUID: bUAOGFggKVLVGtIJO3QAnM328LHwTcMC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_14,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300077
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

