Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C7A6D1F17
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 13:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjCaLcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 07:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjCaLcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 07:32:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117561DFBE
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 04:31:40 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V9Btaj014167;
        Fri, 31 Mar 2023 11:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=0r7aBIDkLQ7TqVUppeuunGn1Rk70pTEuFzrmABzY4fQ=;
 b=qXqteSt8QLh0CBtX0cv63VMohunw3uOUz569XCFlnS051f7AOZnl8+klez8Ik4/Nkm7D
 6buKVWl+ZxitZj9FQ82ysaDXjn0006A4SY0gSlfwHgY0gdhulDFp3qM0qTtXgogJ0tFN
 YGMzdGcnkgmn38Ne1d72Tuv6ehjIZpxzAeiEmSMmooTaYNgkdoQMAFu7aNhbES4CTmb4
 h6tq4G21vBJ3wbBFzLN+SY/uSbd1KNLWqH/oOWxdV1y8JPeFvjacdRwXF40L0UrN2eT7
 HtV+w09b9komF+pUQsIRmqccjLbMa8Ecq07L6Sm/RIILPwV/ufy0314x8iT1/+Qpe/MS +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnvnyb8w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:31:21 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VBGAxi006381;
        Fri, 31 Mar 2023 11:31:19 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnvnyb8qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:31:19 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32V1S9Rd008501;
        Fri, 31 Mar 2023 11:31:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3phr7fpq9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:31:03 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32VBUx5Z30016222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 11:30:59 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFD8E2004B;
        Fri, 31 Mar 2023 11:30:58 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C980B20040;
        Fri, 31 Mar 2023 11:30:57 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.9.190])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 11:30:57 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 13/14] s390x: spec_ex: Add test for misaligned load
Date:   Fri, 31 Mar 2023 13:30:27 +0200
Message-Id: <20230331113028.621828-14-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331113028.621828-1-nrb@linux.ibm.com>
References: <20230331113028.621828-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4GkG0iqaSBdjosD1GwLfHFRXc7e_5snA
X-Proofpoint-GUID: ikIx9bh6t82tnxrITWZS0VS2VK3dcjHx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_06,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310094
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

The operand of LOAD RELATIVE LONG must be word aligned, otherwise a
specification exception occurs. Test that this exception occurs.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230301132638.3336040-1-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index b4b9095..20bd502 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -201,7 +201,7 @@ static int odd_ex_target(void)
 	return 0;
 }
 
-static int bad_alignment(void)
+static int bad_alignment_lqp(void)
 {
 	uint32_t words[5] __attribute__((aligned(16)));
 	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
@@ -214,6 +214,22 @@ static int bad_alignment(void)
 	return 0;
 }
 
+static int bad_alignment_lrl(void)
+{
+	uint64_t r;
+
+	asm volatile ( ".pushsection .rodata\n"
+		"	.balign	4\n"
+		"	. = . + 2\n"
+		"0:	.fill	4\n"
+		"	.popsection\n"
+
+		"	lrl	%0,0b\n"
+		: "=d" (r)
+	);
+	return 0;
+}
+
 static int not_even(void)
 {
 	uint64_t quad[2] __attribute__((aligned(16))) = {0};
@@ -243,7 +259,8 @@ static const struct spec_ex_trigger spec_ex_triggers[] = {
 	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
 	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
 	{ "odd_ex_target", &odd_ex_target, true, NULL },
-	{ "bad_alignment", &bad_alignment, true, NULL },
+	{ "bad_alignment_lqp", &bad_alignment_lqp, true, NULL },
+	{ "bad_alignment_lrl", &bad_alignment_lrl, true, NULL },
 	{ "not_even", &not_even, true, NULL },
 	{ NULL, NULL, false, NULL },
 };
-- 
2.39.2

