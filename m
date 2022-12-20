Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D863D65254D
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiLTRLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiLTRLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:11:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D0B186FF;
        Tue, 20 Dec 2022 09:11:05 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrnIr011917;
        Tue, 20 Dec 2022 17:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cBXBqsKkNl3QP6/x5NxJpFWjziLHqPROPp2lKlz3huc=;
 b=e0asM+Yp2FUJSCBwGRRJbIHWP5oTfXxvUcXAXAUj4MI/MQ7ANLnzbol+zAcZysUCp3Bv
 VhHG/nw47/GMfjNQQK553DvkGtdZHpFxRhyTRGNtIKDedx/IidPUUMENvFU5mRXpmvRs
 oK7I4eLWJYXDmwQrvdXBMM3WFxIQtoDcU0+GwLLQtHKaLiKZ52CxrP6wIMlFwZJDd2Il
 UqkS+dTt2x6+WaBJkjT1HpjlAVYMAXEQ4kZYs+QNLI+x2Qt0Rh0gO1bIAPfx7oxGbYOs
 iVS57rbwdygQ2dPOdp/NpVL1YAeEbSewyu6zjbBxK+/zbYlxevt4QeoImY5X2FVO+IEw eQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp170r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:11:02 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKFDUaC032249;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3mh6yxb4nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAaI39977460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BC9620040;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B6E520049;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 9C390E08ED; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 12/16] vfio/ccw: calculate number of IDAWs regardless of format
Date:   Tue, 20 Dec 2022 18:10:04 +0100
Message-Id: <20221220171008.1362680-13-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YM0jXYdm1wZ2ILjjEmsriHTq8k0DCnRY
X-Proofpoint-ORIG-GUID: YM0jXYdm1wZ2ILjjEmsriHTq8k0DCnRY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=902
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

The idal_nr_words() routine works well for 4K IDAWs, but lost its
ability to handle the old 2K formats with the removal of 31-bit
builds in commit 5a79859ae0f3 ("s390: remove 31 bit support").

Since there's nothing preventing a guest from generating this IDAW
format, let's re-introduce the math for them and use both when
calculating the number of IDAWs based on the bits specified in
the ORB.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/idals.h  | 12 ++++++++++++
 drivers/s390/cio/vfio_ccw_cp.c | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
index 40eae2c08d61..59fcc3c72edf 100644
--- a/arch/s390/include/asm/idals.h
+++ b/arch/s390/include/asm/idals.h
@@ -23,6 +23,9 @@
 #define IDA_SIZE_LOG 12 /* 11 for 2k , 12 for 4k */
 #define IDA_BLOCK_SIZE (1L<<IDA_SIZE_LOG)
 
+#define IDA_2K_SIZE_LOG 11
+#define IDA_2K_BLOCK_SIZE (1L << IDA_2K_SIZE_LOG)
+
 /*
  * Test if an address/length pair needs an idal list.
  */
@@ -42,6 +45,15 @@ static inline unsigned int idal_nr_words(void *vaddr, unsigned int length)
 		(IDA_BLOCK_SIZE-1)) >> IDA_SIZE_LOG;
 }
 
+/*
+ * Return the number of 2K IDA words needed for an address/length pair.
+ */
+static inline unsigned int idal_2k_nr_words(void *vaddr, unsigned int length)
+{
+	return ((__pa(vaddr) & (IDA_2K_BLOCK_SIZE - 1)) + length +
+		(IDA_2K_BLOCK_SIZE - 1)) >> IDA_2K_SIZE_LOG;
+}
+
 /*
  * Create the list of idal words for an address/length pair.
  */
diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 29d1e418b2e2..62a013a631d8 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -502,6 +502,13 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
  *
  * @ccw: The Channel Command Word being translated
  * @cp: Channel Program being processed
+ *
+ * The ORB is examined, since it specifies what IDAWs could actually be
+ * used by any CCW in the channel program, regardless of whether or not
+ * the CCW actually does. An ORB that does not specify Format-2-IDAW
+ * Control could still contain a CCW with an IDAL, which would be
+ * Format-1 and thus only move 2K with each IDAW. Thus all CCWs within
+ * the channel program must follow the same size requirements.
  */
 static int ccw_count_idaws(struct ccw1 *ccw,
 			   struct channel_program *cp)
@@ -530,6 +537,15 @@ static int ccw_count_idaws(struct ccw1 *ccw,
 		iova = ccw->cda;
 	}
 
+	/* Format-1 IDAWs operate on 2K each */
+	if (!cp->orb.cmd.c64)
+		return idal_2k_nr_words((void *)iova, bytes);
+
+	/* Using the 2K variant of Format-2 IDAWs? */
+	if (cp->orb.cmd.i2k)
+		return idal_2k_nr_words((void *)iova, bytes);
+
+	/* The 'usual' case is 4K Format-2 IDAWs */
 	return idal_nr_words((void *)iova, bytes);
 }
 
-- 
2.34.1

