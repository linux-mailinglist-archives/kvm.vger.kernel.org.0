Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B736D5B4C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 10:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbjDDIzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 04:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbjDDIzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 04:55:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC04B1FDB;
        Tue,  4 Apr 2023 01:55:18 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3348HiBR003141;
        Tue, 4 Apr 2023 08:55:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H8sMvmcyZ17R25BVQtUzEbJWfVhOdi8FL5ddcLjTBls=;
 b=BuO3I+MMD6aj2RecaepPhONZAG84Tj9Ir9lR2kh6KUXGII7FCJ0yxRcwRXje647zMc8N
 adSAv5C2+b7jkRgckGaYuQSXyvyoNi18R9tzoZUj3KAx3kk/5LSjWAUv/lrCFoF/oVqs
 Zy45iQ2o2NKcvWwmMNs6GDTi6k2UeAt5YV09nQenQu/hbQ0PmFZuZRYc9BxS2qsrGXRZ
 kdPZoRgkAQvp0LhBg7HNzo1tk8jk5DKSuoBK5v6buJMb58XZWa5KVmyG6QWSoDZasDjE
 HEPNhnVi3q7640pjk48RR2VTg8PXsHaV8+SfugTew0Z4W1PNieZw5UG41JoGYGk5fWAk YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prg8b8qb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:18 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3348tIX8025422;
        Tue, 4 Apr 2023 08:55:18 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prg8b8qa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:17 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3331blCW008038;
        Tue, 4 Apr 2023 08:55:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ppc86sstn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:15 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3348tBjf14025412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 08:55:11 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6882E2004F;
        Tue,  4 Apr 2023 08:55:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FCE12004B;
        Tue,  4 Apr 2023 08:55:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 08:55:11 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 3/3] s390x/spec_ex: Add test of EXECUTE with odd target address
Date:   Tue,  4 Apr 2023 10:54:53 +0200
Message-Id: <20230404085454.2709061-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230404085454.2709061-1-nsg@linux.ibm.com>
References: <20230404085454.2709061-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rhXAuPNljL4htpiu0ukyWNt_ip5CGekL
X-Proofpoint-GUID: VSHDUuCMMh4U24kM2BALINxq834Ho1_E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304040079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The EXECUTE instruction executes the instruction at the given target
address. This address must be halfword aligned, otherwise a
specification exception occurs.
Add a test for this.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/spec_ex.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 494d94cc..e5f7b12f 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -177,6 +177,30 @@ static int short_psw_bit_12_is_0(void)
 	return 0;
 }
 
+static int odd_ex_target(void)
+{
+	uint64_t pre_target_addr;
+	int to = 0, from = 0x0dd;
+
+	asm volatile ( ".pushsection .text.ex_odd\n"
+		"	.balign	2\n"
+		"pre_odd_ex_target%=:\n"
+		"	. = . + 1\n"
+		"	lr	%[to],%[from]\n"
+		"	.popsection\n"
+
+		"	larl	%[pre_target_addr],pre_odd_ex_target%=\n"
+		"	ex	0,1(%[pre_target_addr])\n"
+		: [pre_target_addr] "=&a" (pre_target_addr),
+		  [to] "+d" (to)
+		: [from] "d" (from)
+	);
+
+	assert((pre_target_addr + 1) & 1);
+	report(to != from, "did not perform ex with odd target");
+	return 0;
+}
+
 static int bad_alignment(void)
 {
 	uint32_t words[5] __attribute__((aligned(16)));
@@ -218,6 +242,7 @@ static const struct spec_ex_trigger spec_ex_triggers[] = {
 	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
 	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
 	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
+	{ "odd_ex_target", &odd_ex_target, true, NULL },
 	{ "bad_alignment", &bad_alignment, true, NULL },
 	{ "not_even", &not_even, true, NULL },
 	{ NULL, NULL, false, NULL },
-- 
2.37.2

