Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7E86D5F2F
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbjDDLhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbjDDLhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6A72D6A
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:36:59 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334B7QN8010351;
        Tue, 4 Apr 2023 11:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=DyLaT5b/+GlO0ikmCQ3sWB5KNGOdam2qcWkiaZiHA8A=;
 b=tEZb0JuhPLA72TeCOvOVKv+HN2YB18J6YqkHinQUZVzr+0/DZYADnn3w3+Azn3EpBHLe
 PBVHyc3WHppmHXZ44VvMZNHNnRXbjeNGbtAUWHgcYobF4L1vBykdpGsy0+bmWaQxH3oG
 oJXxHArl4hN4foptNfdWiem4uCC4t21OTotPJbpe04Ihl6VxJ5HDtKOyiqedrc2J6mC/
 mwWIHL5EZ25GRePdxKHpQwaDBnLmYO51Cqxqzqht6bRDon4dmgwgoGIGU/GsK9jTxm+d
 oYonOlL8Uy/Xn4Ajw0v2Yx0bFoFWGBkA+nFxkzZSUIdqRsbrxl2m3ncvuahrYRE9IqH5 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr2mcc6ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:57 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BFaTD020422;
        Tue, 4 Apr 2023 11:36:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr2mcc6ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:56 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341lcst023645;
        Tue, 4 Apr 2023 11:36:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2fs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BanL024904438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D9682004B;
        Tue,  4 Apr 2023 11:36:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6C3020043;
        Tue,  4 Apr 2023 11:36:48 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:48 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v2 09/14] s390x/spec_ex: Add test introducing odd address into PSW
Date:   Tue,  4 Apr 2023 13:36:34 +0200
Message-Id: <20230404113639.37544-10-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nz22zNsaw_tTOfdM9TZkI1H2-9onr0-_
X-Proofpoint-ORIG-GUID: UTzAC069Qc_RF9S6R8Kok0mfzPLLg2_-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Instructions on s390 must be halfword aligned.
Introducing an odd instruction address into the PSW leads to a
specification exception when attempting to execute the instruction at
the odd address.
Add a test for this.

Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230404085454.2709061-3-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 2adc599..494d94c 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -88,12 +88,23 @@ static void expect_invalid_psw(struct psw psw)
 	invalid_psw_expected = true;
 }
 
+static void clear_invalid_psw(void)
+{
+	expected_psw = PSW(0, 0);
+	invalid_psw_expected = false;
+}
+
 static int check_invalid_psw(void)
 {
 	/* Since the fixup sets this to false we check for false here. */
 	if (!invalid_psw_expected) {
+		/*
+		 * Early exception recognition: pgm_int_id == 0.
+		 * Late exception recognition: psw address has been
+		 *	incremented by pgm_int_id (unpredictable value)
+		 */
 		if (expected_psw.mask == invalid_psw.mask &&
-		    expected_psw.addr == invalid_psw.addr)
+		    expected_psw.addr == invalid_psw.addr - lowcore.pgm_int_id)
 			return 0;
 		report_fail("Wrong invalid PSW");
 	} else {
@@ -112,6 +123,42 @@ static int psw_bit_12_is_1(void)
 	return check_invalid_psw();
 }
 
+extern char misaligned_code_pre[];
+asm (  ".balign	2\n"
+"misaligned_code_pre:\n"
+"	. = . + 1\n"
+"	larl	%r0,0\n"
+"	br	%r1\n"
+);
+
+static int psw_odd_address(void)
+{
+	struct psw odd = PSW_WITH_CUR_MASK(((uint64_t)&misaligned_code_pre) + 1);
+	uint64_t executed_addr;
+
+	expect_invalid_psw(odd);
+	fixup_psw.mask = extract_psw_mask();
+	asm volatile ( "xgr	%%r0,%%r0\n"
+		"	larl	%%r1,0f\n"
+		"	stg	%%r1,%[fixup_addr]\n"
+		"	lpswe	%[odd_psw]\n"
+		"0:	lr	%[executed_addr],%%r0\n"
+	: [fixup_addr] "=&T" (fixup_psw.addr),
+	  [executed_addr] "=d" (executed_addr)
+	: [odd_psw] "Q" (odd)
+	: "cc", "%r0", "%r1", "memory" /* Compiler barrier like in load_psw */
+	);
+
+	if (!executed_addr) {
+		return check_invalid_psw();
+	} else {
+		assert(executed_addr == odd.addr);
+		clear_invalid_psw();
+		report_fail("did not execute unaligned instructions");
+		return 1;
+	}
+}
+
 /* A short PSW needs to have bit 12 set to be valid. */
 static int short_psw_bit_12_is_0(void)
 {
@@ -170,6 +217,7 @@ struct spec_ex_trigger {
 static const struct spec_ex_trigger spec_ex_triggers[] = {
 	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
 	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
+	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
 	{ "bad_alignment", &bad_alignment, true, NULL },
 	{ "not_even", &not_even, true, NULL },
 	{ NULL, NULL, false, NULL },
-- 
2.39.2

