Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770EC69E64A
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 18:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbjBURsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 12:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbjBURsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 12:48:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6EA21A16;
        Tue, 21 Feb 2023 09:48:32 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmCZD016276;
        Tue, 21 Feb 2023 17:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fFrqYHzq1jqlYL2wqzi9iVF+/7oh9AAFKQ0ScJXi6/I=;
 b=OuR+tkC5Gfuf6X4/kAjjMnNrf5jEaMPdG5jMi3dOclG8p+eSmgUyOndXH1p5r5wd+4np
 BEQuIlL1obDSKdnTG9gMPC1Fds0uxc0gcTwNwheANnRPf5esftbdXjEFUe43eg9F5UDd
 uBFqJJm4Vy5V6ccG9X6afSurCqjyB+7qqS6zJpYH37HPvnhOHVq4R/c3ihTp7HOtgBgj
 0YFZhxrvSGGRZVzj1Af3AezEqZZNexHmkTjf2umoIZ81DnQaqNr1lcFSzRy1Uf/4yJPy
 zJ1EAmBy1SreM94f/wIvbhSBVuiWI1gkSh3wPfxXlmulAqDzWM1PG+mH5VbdsxyoMA8U sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw0tuk7g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:31 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31LHmFVF016927;
        Tue, 21 Feb 2023 17:48:31 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw0tuk7ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:31 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LDD2n7019863;
        Tue, 21 Feb 2023 17:48:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3ntpa638eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LHmO1L54657318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 17:48:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D698120043;
        Tue, 21 Feb 2023 17:48:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0A8420040;
        Tue, 21 Feb 2023 17:48:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Feb 2023 17:48:24 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/3] s390x/spec_ex: Add test introducing odd address into PSW
Date:   Tue, 21 Feb 2023 18:48:21 +0100
Message-Id: <20230221174822.1378667-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230221174822.1378667-1-nsg@linux.ibm.com>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kTmJUmS2ReDOYqjtd3UKzeFH9lc64ZC3
X-Proofpoint-ORIG-GUID: TrfwZut46L74zY6tx14DgqhDlrmAjwbM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_10,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 suspectscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302210148
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
 s390x/spec_ex.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 2adc5996..a26c56aa 100644
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
+"	bcr	0xf,%r1\n"
+);
+
+static int psw_odd_address(void)
+{
+	struct psw odd = PSW_WITH_CUR_MASK((uint64_t)&misaligned_code);
+	uint64_t executed_addr;
+
+	expect_invalid_psw(odd);
+	fixup_psw.mask = extract_psw_mask();
+	asm volatile ( "xr	%%r0,%%r0\n"
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
2.36.1

