Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A26169E649
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 18:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbjBURsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 12:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjBURse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 12:48:34 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D526279AB;
        Tue, 21 Feb 2023 09:48:31 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmCe9009555;
        Tue, 21 Feb 2023 17:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=T8Cz2usH+rAU9GdefuPD0V6bA1YUsPYfRvJmDeOlBa0=;
 b=NZo2fmWRQbVxeRVTitB98ukRrtQhPAe3jcA0XFtRq14agaLQBNB+vY/a98kCRz52L1EK
 jsoCoKTpq4+1uYdQwYVw+DlDVVpoSdh/+Q7Bb4/zvqZR5bbvg+5nTAtwkecZf7pbrmKo
 IUDLWSqhuF/od1W33ok8cHmQFqwwNCb7KbaDqoD+S3W+fp/1H7glCnfuCbeq9/k75s+w
 3I/EDuVI6LYAHXsPH8YynVIhuP19VL/3eB5DorZUNUz6kunAv+wmJCcpxvqBC42+H5zj
 CaM6ZkE/HGaK2icS41RUeL0QPW0jIycSZ7V6kvYA9n0WEr2z79/JbIuTMjIhmIkg/5nY JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw2dwrchw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:31 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31LHmEU5009984;
        Tue, 21 Feb 2023 17:48:30 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw2dwrche-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:30 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31L8O191016665;
        Tue, 21 Feb 2023 17:48:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6cay3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LHmPYD48431450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 17:48:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 325302004D;
        Tue, 21 Feb 2023 17:48:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0E1620040;
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
Subject: [kvm-unit-tests PATCH v2 3/3] s390x/spec_ex: Add test of EXECUTE with odd target address
Date:   Tue, 21 Feb 2023 18:48:22 +0100
Message-Id: <20230221174822.1378667-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230221174822.1378667-1-nsg@linux.ibm.com>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EL3ND9kfkddk34AQeIfTRDreSZEYZ0D2
X-Proofpoint-GUID: HceD8S6V6SgTIeuXAgP8vUw9HL4DrmKs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_10,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index a26c56aa..dd097f9b 100644
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
+	asm volatile ( ".pushsection .rodata\n"
+		"pre_odd_ex_target:\n"
+		"	.balign	2\n"
+		"	. = . + 1\n"
+		"	lr	%[to],%[from]\n"
+		"	.popsection\n"
+
+		"	larl	%[pre_target_addr],pre_odd_ex_target\n"
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
2.36.1

