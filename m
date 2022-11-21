Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16E0632F07
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiKUVlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiKUVlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39386D5A35;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJ0ECV011617;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YP5zhVK/f9Fgv0BrODvspLgv9+3ZpMhoT7irZX6yhkE=;
 b=Ng/1dbo4zafD+bsg15i9IUvvWyufKIO9Y0UeFWdfH3mq9pusiwTWR3hcOnaTlo260F0a
 mFfRY0mo1kHGxbfavqFBBLYZwPwybLi+f3nJ9vzeTPkJc4Lxj73InmwvKAnm9/qqFLcY
 kvi94u0FnIJG2EFLyUsZYnI8cXZK+sR1xoVlXudDuXmfwQ4pjUEhSEaJOYSj75l8cUQ/
 WrRhA9mTwfO65R2tS1dtYXI94oodlABYZVOKFeLy7sem7GwTv3HsrJZzmhR9jrzSLHWL
 g5vpOO4nZWfxQjeWMUd2lGAVvrzXDKyx/VxtigRh7GtP6jB9G0AiVUnbiOEL1SgqeZs0 WA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0d3g6mtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLdQpf009739;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8tcy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf1TS48234790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4B51A405F;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B195FA405B;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 705B3E0718; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 04/16] vfio/ccw: move where IDA flag is set in ORB
Date:   Mon, 21 Nov 2022 22:40:44 +0100
Message-Id: <20221121214056.1187700-5-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bokNcAD2IbmlF8EftSkf99KY7Ng96WMK
X-Proofpoint-GUID: bokNcAD2IbmlF8EftSkf99KY7Ng96WMK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210162
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

