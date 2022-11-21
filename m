Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD61632F01
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiKUVlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiKUVlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:21 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9326D48E2;
        Mon, 21 Nov 2022 13:41:07 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJS3c8038645;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GDjHS/K3Z+SJD4wIe0+OC40o7dp3d5xRTKCLxnRWZzk=;
 b=PrFcgpUIG7eYy8SbisfUjikdbTbkNtOZb92Xr1olVCAQCectbkp3JUFXJOeRijgAg3+G
 +QRO5G8czq4f8SddecvkNzK/EOezP+t+ZrhYUfcaDzm7jTLhB3vuBfYw17bAlNjdTX8k
 LTSibxpw+3bA4g8ahS6OSHYj2svkKk2Jx+Vs/MswR1VBgbmul2WqkDzvZZY4+KyAqzrl
 6HqxhHoqoZFvgDsd9ZWF1lgyCXZOkR/N3Ap47BdpE9nwcGUIpVFEqQ/8VQ9HbowX3arm
 6fs5Q1+Bqjb31ChLfzE6ssW4kQzdm7xMAiTArlF6RG+o7DtUoyrKzauDrEll/gVamiWU ag== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0fguav31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:06 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLbNmQ025154;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps92d0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLYo8e50725288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:34:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB4C4A404D;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A984CA4040;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 6A5CCE033F; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 02/16] vfio/ccw: simplify the cp_get_orb interface
Date:   Mon, 21 Nov 2022 22:40:42 +0100
Message-Id: <20221121214056.1187700-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CYl9QnTY8NQLsaQ-RvaPCd8h4ejoo85w
X-Proofpoint-ORIG-GUID: CYl9QnTY8NQLsaQ-RvaPCd8h4ejoo85w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_17,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=752 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210158
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

