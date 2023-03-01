Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6056A6D04
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 14:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCAN05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 08:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCAN04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 08:26:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDB938019;
        Wed,  1 Mar 2023 05:26:54 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321D9Exl017512;
        Wed, 1 Mar 2023 13:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ygEbg6+QXd/JW3NTLYoZNny9TW7rbfhYuzZyxnt98XM=;
 b=qqudG7cL4agB4ujOQkU936iOePompoFDROTatqIO4aCbE1bNzJHS8NE0FHiEQuq4mfCX
 Q3zkw99kRTdSDA0hsDG+RpUfXCisl09VogQfIoNnoMdKKkP6/NjMQS1dRKtlD8a/rywF
 Hr5zJ1/EH5Neo6HxTSNg2WzHxkEMmIeIOixpvn1PEaZavMzYOJ3bppzpfrWtG5bCQK3y
 4iAquc2kYjOIQ+rCtd/54oHCj7pIX/fi1MJDWeLec59g0XHMTpbKY3I9ocXqmfNbCYDg
 IOwKAHvDSqfYpQ0lhEdT6Ggg2CisGlQ6KszbpiL68/YAWyTjqQA++HIAKE4fe5ux2wdP sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p25ehkp5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 13:26:53 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 321DBoxN003919;
        Wed, 1 Mar 2023 13:26:53 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p25ehkp4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 13:26:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 321C28Kn026642;
        Wed, 1 Mar 2023 13:26:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nybb4mgpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 13:26:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 321DQl6v65405266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Mar 2023 13:26:47 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE3642004F;
        Wed,  1 Mar 2023 13:26:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 816FE2004B;
        Wed,  1 Mar 2023 13:26:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Mar 2023 13:26:47 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: spec_ex: Add test for misaligned load
Date:   Wed,  1 Mar 2023 14:26:38 +0100
Message-Id: <20230301132638.3336040-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mD-C7yoSQmbm_61rSEgsxycu77yOSf_Z
X-Proofpoint-GUID: gFW6Ps1FSEdL48FhFkuoTjqNq7N7CNDr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_08,2023-03-01_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303010105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The operand of LOAD RELATIVE LONG must be word aligned, otherwise a
specification exception occurs. Test that this exception occurs.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---


Noticed while writing another test that TCG fails this requirement,
so thought it best do document this in the form of a test.


 s390x/spec_ex.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 42ecaed3..42e86070 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -136,7 +136,7 @@ static int short_psw_bit_12_is_0(void)
 	return 0;
 }
 
-static int bad_alignment(void)
+static int bad_alignment_lqp(void)
 {
 	uint32_t words[5] __attribute__((aligned(16)));
 	uint32_t (*bad_aligned)[4] = (uint32_t (*)[4])&words[1];
@@ -149,6 +149,22 @@ static int bad_alignment(void)
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
@@ -176,7 +192,8 @@ struct spec_ex_trigger {
 static const struct spec_ex_trigger spec_ex_triggers[] = {
 	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
 	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_invalid_psw },
-	{ "bad_alignment", &bad_alignment, true, NULL },
+	{ "bad_alignment_lqp", &bad_alignment_lqp, true, NULL },
+	{ "bad_alignment_lrl", &bad_alignment_lrl, true, NULL },
 	{ "not_even", &not_even, true, NULL },
 	{ NULL, NULL, false, NULL },
 };

base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
-- 
2.36.1

