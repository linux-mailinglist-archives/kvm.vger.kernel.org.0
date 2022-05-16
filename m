Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF6C52874A
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 16:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbiEPOnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 10:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiEPOno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 10:43:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274AA2DD57;
        Mon, 16 May 2022 07:43:43 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GEVRxZ028164;
        Mon, 16 May 2022 14:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=G/QMDt6PmelKuw3h1/wn6fFs6tgijcz8HBSIWhry2EI=;
 b=RTeic89YeUss6dzUxWi8VtwYT8O6pF86YbNd19MKMU1rJax1gpXGtGavO1l/8h5vspug
 04Sk+ePffA3z15b1OK9m9mrTfqLUTQ25S+zxJiUPmzjcgu6XYwv0boXwqRAk04imAfkA
 0KRv0eBx6IjzJkLqMpBz30AhoV2uuONQuGUdJIeTdx6W+doSvNrpdHw1kOTrkLrOvOXw
 t3PvHljwoeuEtbAzKOM+A4hffXViwFm4PyhASiDL3JR4ZPx2Cb+QdIL30Gnn/vDr2/dh
 wE4WYN1PJqHf9sWEX0hpy8bSx+whotltx6cLhnAi0Bw9/LjFQleuA9VMyk9MSxwiC/6p TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3rey09ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:43:42 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GEg2r1009019;
        Mon, 16 May 2022 14:43:42 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3rey09rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:43:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GEepfJ019819;
        Mon, 16 May 2022 14:43:39 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428t7jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 14:43:39 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GEhaxg54067678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 14:43:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CC22A405C;
        Mon, 16 May 2022 14:43:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D1D6A4054;
        Mon, 16 May 2022 14:43:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 14:43:36 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH] s390x: Ignore gcc 12 warnings for low addresses
Date:   Mon, 16 May 2022 16:43:32 +0200
Message-Id: <20220516144332.3785876-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5xHPq3QUwbDBzohJgpI23Mz2KNtcHeKf
X-Proofpoint-ORIG-GUID: uGLNVgTQzEJkdiR3Eh9IAmd3MRpHpQry
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_14,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gcc 12 warns if a memory operand to inline asm points to memory in the
first 4k bytes. However, in our case, these operands are fine, either
because we actually want to use that memory, or expect and handle the
resulting exception.
Therefore, silence the warning.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---

Alternatives:
 * Use memory clobber instead of memory output
   Use address in register input instead of memory input
       (may require WRITE_ONCE)
 * Disable the warning globally
 * Don't use gcc 12.0, with newer versions --param=min-pagesize=0 might
   avoid the problem

 lib/s390x/asm/cpacf.h | 7 +++++++
 s390x/skey.c          | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
index 685262b0..02e603c8 100644
--- a/lib/s390x/asm/cpacf.h
+++ b/lib/s390x/asm/cpacf.h
@@ -152,6 +152,12 @@ static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mas
 	register unsigned long r0 asm("0") = 0;	/* query function */
 	register unsigned long r1 asm("1") = (unsigned long) mask;
 
+/*
+ * gcc 12.0.1 warns if mask is < 4k.
+ * We use such addresses to test invalid or protected mask arguments.
+ */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Warray-bounds"
 	asm volatile(
 		"	spm 0\n" /* pckmo doesn't change the cc */
 		/* Parameter regs are ignored, but must be nonzero and unique */
@@ -160,6 +166,7 @@ static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mas
 		: "=m" (*mask)
 		: [fc] "d" (r0), [pba] "a" (r1), [opc] "i" (opcode)
 		: "cc");
+#pragma GCC diagnostic pop
 }
 
 static inline int __cpacf_check_opcode(unsigned int opcode)
diff --git a/s390x/skey.c b/s390x/skey.c
index 32bf1070..7aa91d19 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -242,12 +242,19 @@ static void test_store_cpu_address(void)
  */
 static void set_prefix_key_1(uint32_t *prefix_ptr)
 {
+/*
+ * gcc 12.0.1 warns if prefix_ptr is < 4k.
+ * We need such addresses to test fetch protection override.
+ */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Warray-bounds"
 	asm volatile (
 		"spka	0x10\n\t"
 		"spx	%0\n\t"
 		"spka	0\n"
 	     :: "Q" (*prefix_ptr)
 	);
+#pragma GCC diagnostic pop
 }
 
 /*

base-commit: c315f52b88b967cfb4cd58f3b4e1987378c47f3b
-- 
2.33.1

