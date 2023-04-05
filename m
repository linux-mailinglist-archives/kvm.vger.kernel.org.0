Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB7A6D773A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbjDEIp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbjDEIpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:45:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29BF4EFD
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:45:45 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3358VmRj011325;
        Wed, 5 Apr 2023 08:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=YO5vLxDtMTr2UchCfOgJkBy6P80UFwqn8LwQTwOT8VY=;
 b=evBMnjMscJERgE74pi5sj332hYbG25Vha3BH7Oj0TioiiIcaPuQQ653ROSMyybmeBKwE
 VKHScKsyX+gmiF1IXV3Teks8GKqbJuoFY1ALuC405RgytxBCUBQHMGNNJIMqarwF76fI
 rGDhsKE4d/edpZa+VCzGI3kgeON6A0EFwnWAwTOOI7R+OQHzku6ozy+t4WdfnapKP6ht
 2b0gg8cQ5qEFkQIN5GSKY1xxcpY+pRqfGFws4JY22Yr9Ny0B2XdT6aCWaT58tV1NMu5R
 x8N4lHW9T7EzlEaUSiBKBjYBTGuzMDI59/JfzrwCeg6k6uHH7kGifpNYcRfHbXh3ROn5 lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5jcgcqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:43 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3358Wsh8018569;
        Wed, 5 Apr 2023 08:45:42 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5jcgcq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:42 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3353pmWa020082;
        Wed, 5 Apr 2023 08:45:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ppc86td26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3358jaEN43975352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 08:45:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C43E120043;
        Wed,  5 Apr 2023 08:45:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5848E20040;
        Wed,  5 Apr 2023 08:45:36 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.30.226])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 08:45:36 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v3 10/14] s390x/spec_ex: Add test of EXECUTE with odd target address
Date:   Wed,  5 Apr 2023 10:45:24 +0200
Message-Id: <20230405084528.16027-11-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405084528.16027-1-nrb@linux.ibm.com>
References: <20230405084528.16027-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6HAdMhT5JQgJUEPDudjYb1E9HLg-sYED
X-Proofpoint-GUID: Tx9PC8srxQK-68POKGbpG13akzpaLNgU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_04,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

The EXECUTE instruction executes the instruction at the given target
address. This address must be halfword aligned, otherwise a
specification exception occurs.
Add a test for this.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230404085454.2709061-4-nsg@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 494d94c..e5f7b12 100644
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
2.39.2

