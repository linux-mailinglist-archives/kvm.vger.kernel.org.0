Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CA453BD45
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 19:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiFBRU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 13:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbiFBRUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 13:20:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0F620E53C;
        Thu,  2 Jun 2022 10:20:01 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252H1oQv020459;
        Thu, 2 Jun 2022 17:19:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eWqpPV4EFDCplHDkkkw2s6RIp8CyLImQ48Rw6gV24Bw=;
 b=c5sEk/uvtDpaCO452U4dSfcNrBX4JNX64Roxxn+hqGJ5MwmUpCkmxN4cQlRG/Mmu+BAU
 Vg4yidorR+PWhEFc95FoBQ68wZxtL59vVm83+ZZVsOUHLgJYMgHy7zeHisVfSWTmQ+in
 YkcXqgWnbDKIs+26REvYUJdevtB03EPQzYjm347cfMxtO2HuWqTUMqqJAywCWEaCNBPN
 F1nT5Af9LB34MwO6xFszpWwpmiBR7FUvcqLcZz9iK0y5RViAbMPJbQ0m75TuWkB8CKNo
 3Yf2keyV3KNiTj5gzWPcGpY7d5Kd4MJvcywf/1CiSDxpvNrWjD8iwQs6Q1HdmdNSS4Hb gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gew2c5trb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:57 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252Gh2Km025635;
        Thu, 2 Jun 2022 17:19:57 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gew2c5tqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252H54G7023335;
        Thu, 2 Jun 2022 17:19:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h7by1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 17:19:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252HJp1U54526346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 17:19:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85D5211C054;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72B2311C05B;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jun 2022 17:19:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id D4667E136C; Thu,  2 Jun 2022 19:19:50 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 16/18] vfio/ccw: Create a get_private routine
Date:   Thu,  2 Jun 2022 19:19:46 +0200
Message-Id: <20220602171948.2790690-17-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602171948.2790690-1-farman@linux.ibm.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ETSODnqvstbbMHR4QY5f7ttvOrtjF1NS
X-Proofpoint-ORIG-GUID: -t8QIeNL8q8OWv7Y9PJ379PLwXYChbbh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_05,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor out the logic of getting the vfio_ccw_private struct from
the subchannel, so that it can be synchronized with vfio better.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     | 10 +++++-----
 drivers/s390/cio/vfio_ccw_private.h | 14 ++++++++++++++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 5928460854ec..c8cbbad6e1c5 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -37,7 +37,7 @@ debug_info_t *vfio_ccw_debug_trace_id;
  */
 int vfio_ccw_sch_quiesce(struct subchannel *sch)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+	struct vfio_ccw_private *private = vfio_ccw_get_private(sch);
 	DECLARE_COMPLETION_ONSTACK(completion);
 	int iretry, ret = 0;
 
@@ -124,7 +124,7 @@ static void vfio_ccw_crw_todo(struct work_struct *work)
  */
 static void vfio_ccw_sch_irq(struct subchannel *sch)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+	struct vfio_ccw_private *private = vfio_ccw_get_private(sch);
 
 	if (WARN_ON(!private))
 		return;
@@ -245,7 +245,7 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
 
 static void vfio_ccw_sch_shutdown(struct subchannel *sch)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+	struct vfio_ccw_private *private = vfio_ccw_get_private(sch);
 
 	if (!private)
 		return;
@@ -266,7 +266,7 @@ static void vfio_ccw_sch_shutdown(struct subchannel *sch)
  */
 static int vfio_ccw_sch_event(struct subchannel *sch, int process)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+	struct vfio_ccw_private *private = vfio_ccw_get_private(sch);
 	unsigned long flags;
 	int rc = -EAGAIN;
 
@@ -321,7 +321,7 @@ static void vfio_ccw_queue_crw(struct vfio_ccw_private *private,
 static int vfio_ccw_chp_event(struct subchannel *sch,
 			      struct chp_link *link, int event)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
+	struct vfio_ccw_private *private = vfio_ccw_get_private(sch);
 	int mask = chp_ssd_get_mask(&sch->ssd_info, link);
 	int retry = 255;
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index bf11ebd0d32a..3833204bd388 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -24,6 +24,8 @@
 #include "css.h"
 #include "vfio_ccw_cp.h"
 
+struct mdev_device;
+
 #define VFIO_CCW_OFFSET_SHIFT   10
 #define VFIO_CCW_OFFSET_TO_INDEX(off)	(off >> VFIO_CCW_OFFSET_SHIFT)
 #define VFIO_CCW_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_CCW_OFFSET_SHIFT)
@@ -125,6 +127,18 @@ extern struct mdev_driver vfio_ccw_mdev_driver;
 extern const struct mdev_parent_ops vfio_ccw_mdev_ops;
 extern const struct vfio_device_ops vfio_ccw_dev_ops;
 
+static inline struct vfio_ccw_private *vfio_ccw_get_private(struct subchannel *sch)
+{
+	struct vfio_ccw_private *private;
+
+	if (!sch)
+		return NULL;
+
+	private = dev_get_drvdata(&sch->dev);
+
+	return private;
+}
+
 /*
  * States of the device statemachine.
  */
-- 
2.32.0

