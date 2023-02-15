Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6A86981C3
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBORTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBORTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:19:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC077298F1;
        Wed, 15 Feb 2023 09:19:01 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FH7aiA029037;
        Wed, 15 Feb 2023 17:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sx+DnNM/PAs0L9A2sEqUdMbZ9Sg8LZN5YzGYqXCGT98=;
 b=CuRb5e2WnKHC8PJ0Db1w8sN1doFWmVBpFqT9bPWk8+B+RvehfUVRbMSpkfrHkfkCAlTI
 rOXL39qZxmuXF1wKoFWVXHw0BeRVAtd5iFi8zUlpnFw/CQ9Zc+/n9H+zw1JaEEazh30O
 yhhbJxKMF/mZjhR9wg0oJIhdf+CKYE9McTa1z1eoSe7+th5yyje8Zn/uISXN+XNhN2OQ
 B/qZUO5bxacDggpev51/DwWOVIU9TRgGEMktQwjdqv1/i5/GtGPE1RMo8i/Xx8otFGRf
 UTtHY3KiVqWIZtAQ8AJbdeV33/kDkQ+49fme4iEDD6C9lJiRo3buPQtfNsHm9oHEfChi rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns0grfyre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:19:01 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31FG08QJ023217;
        Wed, 15 Feb 2023 17:19:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns0grfyqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:19:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31FBOgYT032710;
        Wed, 15 Feb 2023 17:18:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3np29fnnv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:18:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FHItpF36307268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 17:18:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F27A320040;
        Wed, 15 Feb 2023 17:18:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7A1920043;
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
Subject: [kvm-unit-tests PATCH v1 2/2] s390x/spec_ex: Add test of EXECUTE with odd target address
Date:   Wed, 15 Feb 2023 18:18:52 +0100
Message-Id: <20230215171852.1935156-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230215171852.1935156-1-nsg@linux.ibm.com>
References: <20230215171852.1935156-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9KxGM0itLBhzsj6nJb2RimnXQhWU9k2b
X-Proofpoint-ORIG-GUID: AUuWf_dftBWTSMaDLUwaJ98lll3MUga8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_07,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 clxscore=1011 lowpriorityscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150154
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/spec_ex.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index b6764677..0cd3174f 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -200,6 +200,30 @@ static int short_psw_bit_12_is_0(void)
 	return 0;
 }
 
+static int odd_ex_target(void)
+{
+	uint64_t target_addr_pre;
+	int to = 0, from = 0x0dd;
+
+	asm volatile ( ".pushsection .rodata\n"
+		"odd_ex_target_pre_insn:\n"
+		"	.balign 2\n"
+		"	. = . + 1\n"
+		"	lr	%[to],%[from]\n"
+		"	.popsection\n"
+
+		"	larl	%[target_addr_pre],odd_ex_target_pre_insn\n"
+		"	ex	0,1(%[target_addr_pre])\n"
+		: [target_addr_pre] "=&a" (target_addr_pre),
+		  [to] "+d" (to)
+		: [from] "d" (from)
+	);
+
+	assert((target_addr_pre + 1) & 1);
+	report(to != from, "did not perform ex with odd target");
+	return 0;
+}
+
 static int bad_alignment(void)
 {
 	uint32_t words[5] __attribute__((aligned(16)));
@@ -241,6 +265,7 @@ static const struct spec_ex_trigger spec_ex_triggers[] = {
 	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
 	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
 	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
+	{ "odd_ex_target", &odd_ex_target, true, NULL },
 	{ "bad_alignment", &bad_alignment, true, NULL },
 	{ "not_even", &not_even, true, NULL },
 	{ NULL, NULL, false, NULL },
-- 
2.36.1

