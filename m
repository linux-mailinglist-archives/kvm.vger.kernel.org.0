Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44746632F18
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKUVmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiKUVlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8E9DB84F;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALKvM38019106;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9Yo9Wb+Bh1VTFY/32N+EVHu3Tfjlja6KFhgrETl5x/w=;
 b=ObVl4fJd56+1U2VddxQvEm5EM2rQBgw1bf+IDlBMCIdvS8eCBLlCcEadKIT86kPU+0NT
 6k7cIcmTh9HXwpiFU39u05dipTUvTEDb/3hJGet3un4eLGc9+Cx7TlH7+7Wkw3kR0W7b
 c1TJd5sMFg2cAFsjrOXRTwc+sSVBttUmN9ylO/BzWyAANEIMP3zisEwf3VhsPrIC7Eu7
 TZuL/EBSfOrreUkZbtfgI/knZMzfxpctweHdw5evQMPUmRcBGiMNhd8iu5uup5yMLlau
 ZNn01n9A+YdNCwkz8m64WsfUnU3UpvymywgGTEjpFd9DsD8+Gc2ahjZZfXL7D/aKobMQ Mg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0gtus6qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLbG0W023812;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdhu80h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf2Kt60686740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E9BE42047;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F129E42042;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 88444E08BB; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 12/16] vfio/ccw: calculate number of IDAWs regardless of format
Date:   Mon, 21 Nov 2022 22:40:52 +0100
Message-Id: <20221121214056.1187700-13-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1uTsEK_IvFsYUbvfLlZtohoCrHKk0vHI
X-Proofpoint-GUID: 1uTsEK_IvFsYUbvfLlZtohoCrHKk0vHI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_16,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 mlxlogscore=747 bulkscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210158
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
---
 arch/s390/include/asm/idals.h  | 12 ++++++++++++
 drivers/s390/cio/vfio_ccw_cp.c | 17 ++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
index 40eae2c08d61..0a05a893aedb 100644
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
+	return ((__pa(vaddr) & (IDA_2K_BLOCK_SIZE-1)) + length +
+		(IDA_2K_BLOCK_SIZE-1)) >> IDA_2K_SIZE_LOG;
+}
+
 /*
  * Create the list of idal words for an address/length pair.
  */
diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 53246f4f95f7..6839e7195182 100644
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
@@ -529,7 +536,15 @@ static int ccw_count_idaws(struct ccw1 *ccw,
 		iova = ccw->cda;
 	}
 
-	return idal_nr_words((void *)iova, bytes);
+	/* Format-1 IDAWs operate on 2K each */
+	if (!cp->orb.cmd.c64)
+		return idal_2k_nr_words((void *)iova, bytes);
+
+	/* Format-2 IDAWs operate on either 2K or 4K */
+	if (cp->orb.cmd.i2k)
+		return idal_2k_nr_words((void *)iova, bytes);
+	else
+		return idal_nr_words((void *)iova, bytes);
 }
 
 static int ccwchain_fetch_ccw(struct ccw1 *ccw,
-- 
2.34.1

