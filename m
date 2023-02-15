Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85376981C5
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBORTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBORTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:19:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF77C1A64D;
        Wed, 15 Feb 2023 09:19:01 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FHCUmY029721;
        Wed, 15 Feb 2023 17:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MorAWcHECOh6pGDli3990M3HLQ83xdXrLCka1DQQYIQ=;
 b=F5fSpXT2yTd4iIRjd8wrhXDADwSE0Iv3PbYo6aKATmCy2P9QgQwhsI/RYOwhBkwgfHYu
 jZgy30ju/OJZ0DzSQvNhXGpWByBeIeePjeUP3Iny1FxvldZeJ1EGtMu2Rlq1MJnzfNEo
 Ab2dvMCC5/AcJFgd0db74qhyxy/bBDGMZREbjqqucrHtkjnbAM2V3jfSG0fRJRRqYiq+
 J3Xxl1TmDCJh6dNEmucvwYRsy3WREOJLY8+9zImbmX1CMCaVf5hfL6WjqKzXaHj+eqO+
 FJUFQFNwN08Qdki0cLoHQ4pU5hK8Q9VMvEOb0D2weg+qPoC3e2oVb8l3xVWSO2vQbYw0 TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns3kb05a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:19:01 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31FHCwh6031506;
        Wed, 15 Feb 2023 17:19:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns3kb0597-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:19:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31FBHS0q029878;
        Wed, 15 Feb 2023 17:18:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3np29fnnv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:18:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FHIs0I46858506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 17:18:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD8CA20040;
        Wed, 15 Feb 2023 17:18:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82B5B20043;
        Wed, 15 Feb 2023 17:18:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 17:18:54 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 1/2] s390x/spec_ex: Add test introducing odd address into PSW
Date:   Wed, 15 Feb 2023 18:18:51 +0100
Message-Id: <20230215171852.1935156-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230215171852.1935156-1-nsg@linux.ibm.com>
References: <20230215171852.1935156-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6qVD_1cYzNx7WLILeYzQ9a7-9gqx7mYs
X-Proofpoint-GUID: 3UH4vGsV5u5uVUr4LqLyxoFcw5plcvLh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_07,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150154
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instructions on s390 must be halfword aligned.
Introducing an odd instruction address into the PSW leads to a
specification exception when attempting to execute the instruction at
the odd address.
Add a test for this.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/spec_ex.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 69 insertions(+), 4 deletions(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 42ecaed3..b6764677 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -44,9 +44,10 @@ static void fixup_invalid_psw(struct stack_frame_int *stack)
 /*
  * Load possibly invalid psw, but setup fixup_psw before,
  * so that fixup_invalid_psw() can bring us back onto the right track.
+ * The provided argument is loaded into register 1.
  * Also acts as compiler barrier, -> none required in expect/check_invalid_psw
  */
-static void load_psw(struct psw psw)
+static void load_psw_with_arg(struct psw psw, uint64_t arg)
 {
 	uint64_t scratch;
 
@@ -57,15 +58,22 @@ static void load_psw(struct psw psw)
 	fixup_psw.mask = extract_psw_mask();
 	asm volatile ( "larl	%[scratch],0f\n"
 		"	stg	%[scratch],%[fixup_addr]\n"
+		"	lgr	%%r1,%[arg]\n"
 		"	lpswe	%[psw]\n"
 		"0:	nop\n"
 		: [scratch] "=&d" (scratch),
 		  [fixup_addr] "=&T" (fixup_psw.addr)
-		: [psw] "Q" (psw)
-		: "cc", "memory"
+		: [psw] "Q" (psw),
+		  [arg] "d" (arg)
+		: "cc", "memory", "%r1"
 	);
 }
 
+static void load_psw(struct psw psw)
+{
+	load_psw_with_arg(psw, 0);
+}
+
 static void load_short_psw(struct short_psw psw)
 {
 	uint64_t scratch;
@@ -88,12 +96,18 @@ static void expect_invalid_psw(struct psw psw)
 	invalid_psw_expected = true;
 }
 
+static void clear_invalid_psw(void)
+{
+	expected_psw = (struct psw){0};
+	invalid_psw_expected = false;
+}
+
 static int check_invalid_psw(void)
 {
 	/* Since the fixup sets this to false we check for false here. */
 	if (!invalid_psw_expected) {
 		if (expected_psw.mask == invalid_psw.mask &&
-		    expected_psw.addr == invalid_psw.addr)
+		    expected_psw.addr == invalid_psw.addr - lowcore.pgm_int_id)
 			return 0;
 		report_fail("Wrong invalid PSW");
 	} else {
@@ -115,6 +129,56 @@ static int psw_bit_12_is_1(void)
 	return check_invalid_psw();
 }
 
+static int psw_odd_address(void)
+{
+	struct psw odd = {
+		.mask = extract_psw_mask(),
+	};
+	uint64_t regs[16];
+	int r;
+
+	/*
+	 * This asm is reentered at an odd address, which should cause a specification
+	 * exception before the first unaligned instruction is executed.
+	 * In this case, the interrupt handler fixes the address and the test succeeds.
+	 * If, however, unaligned instructions *are* executed, they are jumped to
+	 * from somewhere, with unknown registers, so save and restore those before.
+	 */
+	asm volatile ( "stmg	%%r0,%%r15,%[regs]\n"
+		//can only offset by even number when using larl -> increment by one
+		"	larl	%[r],0f\n"
+		"	aghi	%[r],1\n"
+		"	stg	%[r],%[addr]\n"
+		"	xr	%[r],%[r]\n"
+		"	brc	0xf,1f\n"
+		"0:	. = . + 1\n"
+		"	lmg	%%r0,%%r15,0(%%r1)\n"
+		//address of the instruction itself, should be odd, store for assert
+		"	larl	%[r],0\n"
+		"	stg	%[r],%[addr]\n"
+		"	larl	%[r],0f\n"
+		"	aghi	%[r],1\n"
+		"	bcr	0xf,%[r]\n"
+		"0:	. = . + 1\n"
+		"1:\n"
+	: [addr] "=T" (odd.addr),
+	  [regs] "=Q" (regs),
+	  [r] "=d" (r)
+	: : "cc", "memory"
+	);
+
+	if (!r) {
+		expect_invalid_psw(odd);
+		load_psw_with_arg(odd, (uint64_t)&regs);
+		return check_invalid_psw();
+	} else {
+		assert(odd.addr & 1);
+		clear_invalid_psw();
+		report_fail("executed unaligned instructions");
+		return 1;
+	}
+}
+
 /* A short PSW needs to have bit 12 set to be valid. */
 static int short_psw_bit_12_is_0(void)
 {
@@ -176,6 +240,7 @@ struct spec_ex_trigger {
 static const struct spec_ex_trigger spec_ex_triggers[] = {
 	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
 	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
+	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
 	{ "bad_alignment", &bad_alignment, true, NULL },
 	{ "not_even", &not_even, true, NULL },
 	{ NULL, NULL, false, NULL },
-- 
2.36.1

