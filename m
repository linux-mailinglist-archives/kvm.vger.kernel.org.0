Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B66D5B46
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbjDDIzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 04:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjDDIzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 04:55:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3481730;
        Tue,  4 Apr 2023 01:55:13 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3347NTgO011339;
        Tue, 4 Apr 2023 08:55:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+KRhRj3Sf0IeMsoYxjoXOXih8OoqoZjBEBwA9jzvfjQ=;
 b=lyl+QSSk1eh9gYL8EBaMhujRMwdry/GQEJkd7zBKOxZ2uckG96SLazqxBdvXm/g8ST4a
 oASLTVr8M07sgmyyX1qU7s2mxNWXazhYZqsAKK0ck/j0qOJfsGHYvlIJw/EhrRcPgAIX
 ghkWLZI7yDJJ5BkjW++WGp5WhyzmZlMBYBz+gB/44J8UMvMVQ1TTJ7/tsI46llh7qX92
 2q/Si6rKeiVpwAgClm/aS0gzTxQtJXkWLf3Gjze1WFNr5vvHD+22ifUXIL85TVV7EPv9
 UencIWAYktTOLigJPfMrwv83yzHuyNDvwDBXzsEYITVWxu8FsQ2eSeBzOzUnnJV1Y66B HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr4m58bb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:12 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3348sATq018385;
        Tue, 4 Apr 2023 08:55:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr4m58baj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 333MejcM004036;
        Tue, 4 Apr 2023 08:55:10 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2cnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 08:55:10 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3348t63m42861148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 08:55:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6B532004B;
        Tue,  4 Apr 2023 08:55:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5420420043;
        Tue,  4 Apr 2023 08:55:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 08:55:06 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 1/3] s390x/spec_ex: Use PSW macro
Date:   Tue,  4 Apr 2023 10:54:51 +0200
Message-Id: <20230404085454.2709061-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230404085454.2709061-1-nsg@linux.ibm.com>
References: <20230404085454.2709061-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z_YtdxmG_E9XgucR4BHdudR-bwFmr35j
X-Proofpoint-ORIG-GUID: pz9adOIJza_x8H6coqBF0KP5vHDRLl7l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace explicit psw definition by PSW macro.
No functional change intended.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/spec_ex.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index 42ecaed3..2adc5996 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -105,10 +105,7 @@ static int check_invalid_psw(void)
 /* For normal PSWs bit 12 has to be 0 to be a valid PSW*/
 static int psw_bit_12_is_1(void)
 {
-	struct psw invalid = {
-		.mask = BIT(63 - 12),
-		.addr = 0x00000000deadbeee
-	};
+	struct psw invalid = PSW(BIT(63 - 12), 0x00000000deadbeee);
 
 	expect_invalid_psw(invalid);
 	load_psw(invalid);
@@ -118,10 +115,7 @@ static int psw_bit_12_is_1(void)
 /* A short PSW needs to have bit 12 set to be valid. */
 static int short_psw_bit_12_is_0(void)
 {
-	struct psw invalid = {
-		.mask = BIT(63 - 12),
-		.addr = 0x00000000deadbeee
-	};
+	struct psw invalid = PSW(BIT(63 - 12), 0x00000000deadbeee);
 	struct short_psw short_invalid = {
 		.mask = 0x0,
 		.addr = 0xdeadbeee
-- 
2.37.2

