Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7705D652537
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiLTRKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiLTRKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854FD60F5;
        Tue, 20 Dec 2022 09:10:37 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrlde011841;
        Tue, 20 Dec 2022 17:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=85qsS3n2ZzYKkr3My/SxofR3yQv+a1zgR+pibE4T25c=;
 b=jzLsPgUtF/4IvTbhntgU9y409WDI2P4sO7qcyAr5UXfmbb3gHAo+ifMeS7anDOwweEgN
 vYAg3k/PLv3OzgSX5HDBLGvth9HqJ5oXh1Lykwz7fWNy6gs38VCE8HjbfhGpoIIIjAs2
 tHeRe3uACOzitVsJJ+TgCsTY2P+4nP3i33KGHcLaIEEjpL7Br5ZOAy/+sC4MADWIxcbN
 fqhYcXbmVGAeurfhLz/xZXFSoIMmmucNIu/3Ffj54/6F7Nppmo+/iZxbcoYn7PjHyMVh
 qPF+FbpwuuFzYw0xS/9uU3FpsZRHvZSE1MgMKUD59Oy2x1W4R0JHqEIJS30kBojKEIuK kA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp170b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6GDJ0024576;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mh6ywmacn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHA9sb8585694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC41B2004B;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA3DC2004E;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7FDFCE07B5; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 02/16] vfio/ccw: simplify the cp_get_orb interface
Date:   Tue, 20 Dec 2022 18:09:54 +0100
Message-Id: <20221220171008.1362680-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hg_9tLh3ClI9OV75QV5aTH7VeneEyvuq
X-Proofpoint-ORIG-GUID: hg_9tLh3ClI9OV75QV5aTH7VeneEyvuq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=886
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's no need to send in both the address of the subchannel
struct, and an element within it, to populate the ORB.

Pass the whole pointer and let cp_get_orb() take the pieces
that are needed.

Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c  | 9 ++++-----
 drivers/s390/cio/vfio_ccw_cp.h  | 2 +-
 drivers/s390/cio/vfio_ccw_fsm.c | 2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 9e6df1f2fbee..a0060ef1119e 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -816,14 +816,13 @@ int cp_prefetch(struct channel_program *cp)
 /**
  * cp_get_orb() - get the orb of the channel program
  * @cp: channel_program on which to perform the operation
- * @intparm: new intparm for the returned orb
- * @lpm: candidate value of the logical-path mask for the returned orb
+ * @sch: subchannel the operation will be performed against
  *
  * This function returns the address of the updated orb of the channel
  * program. Channel I/O device drivers could use this orb to issue a
  * ssch.
  */
-union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm)
+union orb *cp_get_orb(struct channel_program *cp, struct subchannel *sch)
 {
 	union orb *orb;
 	struct ccwchain *chain;
@@ -835,12 +834,12 @@ union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm)
 
 	orb = &cp->orb;
 
-	orb->cmd.intparm = intparm;
+	orb->cmd.intparm = (u32)virt_to_phys(sch);
 	orb->cmd.fmt = 1;
 	orb->cmd.key = PAGE_DEFAULT_KEY >> 4;
 
 	if (orb->cmd.lpm == 0)
-		orb->cmd.lpm = lpm;
+		orb->cmd.lpm = sch->lpm;
 
 	chain = list_first_entry(&cp->ccwchain_list, struct ccwchain, next);
 	cpa = chain->ch_ccw;
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
index 16138a654fdd..fc31eb699807 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -43,7 +43,7 @@ struct channel_program {
 int cp_init(struct channel_program *cp, union orb *orb);
 void cp_free(struct channel_program *cp);
 int cp_prefetch(struct channel_program *cp);
-union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
+union orb *cp_get_orb(struct channel_program *cp, struct subchannel *sch);
 void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
 bool cp_iova_pinned(struct channel_program *cp, u64 iova, u64 length);
 
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index 2784a4e4d2be..757b73141246 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -27,7 +27,7 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
 
 	spin_lock_irqsave(sch->lock, flags);
 
-	orb = cp_get_orb(&private->cp, (u32)virt_to_phys(sch), sch->lpm);
+	orb = cp_get_orb(&private->cp, sch);
 	if (!orb) {
 		ret = -EIO;
 		goto out;
-- 
2.34.1

