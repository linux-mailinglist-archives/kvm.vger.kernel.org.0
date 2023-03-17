Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B656BEA1E
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 14:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCQNdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 09:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjCQNdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 09:33:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD8343908;
        Fri, 17 Mar 2023 06:33:09 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HCElSL013133;
        Fri, 17 Mar 2023 13:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=v8Ncaw6gbmtkRbbIH3vLCG3yYHSOWqVuBNvFc4cFkGo=;
 b=BVVQv4ZSYAkuJz3SKSbB8CfR9OE7mdRukCYOyT06FYxSG+om0R3dbTJIl2iFmVxdYKXJ
 mKzuIvwxtA77f+3uE7IQnuWvzsYsIUEsqXUbsQLFUT37e5zFvY60xWsG3aHLp2MDz6i5
 1vIYz8cSqgonY/rz0pv7i795Gu6F78DHyC5qO+oKLVuBCExV4MNxljJxdsjZmf53xAqS
 4nPo+vxm5jsckZZ/gndUnFkSBO29g4/KrSLl7gxIM+SwacUobKWCe2IGeKEU6kdw6kHs
 +za+Cs0jqd2pH9WYC1He2aOdi9Yjy2NMD4HuhRCmR4QV11hI0zwQvebUsge9cXZzrKZD Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcr1st4cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:09 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32HD6jO2015635;
        Fri, 17 Mar 2023 13:33:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcr1st4b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32H6WuAf015005;
        Fri, 17 Mar 2023 13:33:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pbsf3j82c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 13:33:06 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HDX32Z25100914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 13:33:03 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CF9120043;
        Fri, 17 Mar 2023 13:33:03 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C803820040;
        Fri, 17 Mar 2023 13:33:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 13:33:02 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 2/3] s390x/spec_ex: Add test introducing odd address into PSW
Date:   Fri, 17 Mar 2023 14:32:52 +0100
Message-Id: <20230317133253.965010-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317133253.965010-1-nsg@linux.ibm.com>
References: <20230317133253.965010-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 76zEg8lV3YGoMa8WsBhp5pstx67WpNxm
X-Proofpoint-GUID: QpCNnFibCPwf5CJD_5bShnDvJO4IftZ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_08,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 impostorscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170092
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

Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/spec_ex.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 2adc5996..ab023347 100644
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
 
+extern char misaligned_code[];
+asm (  ".balign	2\n"
+"	. = . + 1\n"
+"misaligned_code:\n"
+"	larl	%r0,0\n"
+"	br	%r1\n"
+);
+
+static int psw_odd_address(void)
+{
+	struct psw odd = PSW_WITH_CUR_MASK((uint64_t)&misaligned_code);
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
+	: "cc", "%r0", "%r1"
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
2.39.1

