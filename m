Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3EE652555
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiLTRMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiLTRL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:11:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D48A388D;
        Tue, 20 Dec 2022 09:11:24 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKH8YMb021707;
        Tue, 20 Dec 2022 17:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lPBwHGZ1hT700GoLCnuhbGD08X1xhcEyH8DjYISbd2s=;
 b=ckVNvfWtOWo+JVC7h2bISVicTG7b5AyuBrn8ZFg54Sf8BzlE7zUZ7H9bzFpyfn7AGb19
 vI/bfUQPCOvdufhJ+wZCa+q+unOuRvonKWmnr7X45h9kJhzB0kowivEDudcFdnNOI/JD
 eNL+gU8epTAR3/pd0l/CJyO7jCz30HqXoSSz/OQcY0iAjJEbkPagHFQj6kXv25PzhWid
 XfAqxkpuNmkYEli5EYnNvc5gsA17xLMktEVVLkPUlrCu/B9sXwggGHdpBx70R0mKdHvd
 EjuGFOfq6MSyGmtoWCyZ5j47AisY5uPqO23Iwg1xahRRRmnsYtffCc/4mPG9bdT/Yp5k 3A== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgbw9x14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:11:22 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKE9UCB031366;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mh6yxk4uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHA98731129894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD7972005A;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC7112004F;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 85965E0895; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 04/16] vfio/ccw: move where IDA flag is set in ORB
Date:   Tue, 20 Dec 2022 18:09:56 +0100
Message-Id: <20221220171008.1362680-5-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yO213h_G7L9s9c0-IP_zcnJoJeOSf3Db
X-Proofpoint-ORIG-GUID: yO213h_G7L9s9c0-IP_zcnJoJeOSf3Db
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The output of vfio_ccw is always a Format-2 IDAL, but the code that
explicitly sets this is buried in cp_init().

In fact the input is often already a Format-2 IDAL, and would be
rejected (via the check in ccwchain_calc_length()) if it weren't,
so explicitly setting it doesn't do much. Setting it way down here
only makes it impossible to make decisions in support of other
IDAL formats.

Let's move that to where the rest of the ORB is set up, so that the
CCW processing in cp_prefetch() is performed according to the
contents of the unmodified guest ORB.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 268a90252521..3a11132b1685 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -707,15 +707,9 @@ int cp_init(struct channel_program *cp, union orb *orb)
 	/* Build a ccwchain for the first CCW segment */
 	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
 
-	if (!ret) {
+	if (!ret)
 		cp->initialized = true;
 
-		/* It is safe to force: if it was not set but idals used
-		 * ccwchain_calc_length would have returned an error.
-		 */
-		cp->orb.cmd.c64 = 1;
-	}
-
 	return ret;
 }
 
@@ -837,6 +831,11 @@ union orb *cp_get_orb(struct channel_program *cp, struct subchannel *sch)
 	orb->cmd.intparm = (u32)virt_to_phys(sch);
 	orb->cmd.fmt = 1;
 
+	/*
+	 * Everything built by vfio-ccw is a Format-2 IDAL.
+	 */
+	orb->cmd.c64 = 1;
+
 	if (orb->cmd.lpm == 0)
 		orb->cmd.lpm = sch->lpm;
 
-- 
2.34.1

