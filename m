Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D2B69E647
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 18:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjBURsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 12:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjBURse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 12:48:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F96127D5C;
        Tue, 21 Feb 2023 09:48:31 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LHmDWO025718;
        Tue, 21 Feb 2023 17:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=omcxWFtmKthVHFkM9imywS8w+Cq/VOcYU0g4gOpeJDc=;
 b=SYwR5fLYmX96d7P7UOR+/ILxWR3P1TxYvT/FFtJyoIHeFUDPSG2j4HNNr7gWslMoqTOC
 zR7DF0znZEXitcfDelwyyvUXyUQ0kVJ5QePhJdYCKXl6gPpklGj9yO9+0h6Q8IeOV7sk
 Vevx14ZjzwjZYxMWIM8KhtUSw46sCC9bRctd0DyCxQr6/EizgXKq6KgsON7hWO2PfY96
 m3gmi7+eBl8UsjhyNAvRKVcaxq4XdQ+/WgYsO4/CJIckVXtKUIWCx9uLoVcgTQWfhfdb
 dqIWuZCcMJzXZCHASdShaV8p/9scgryJWBDgcT1LqWhss9zszjZMTwvUIsvM0GGRCmZW jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw27n0q6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:30 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31LHmUKT030607;
        Tue, 21 Feb 2023 17:48:30 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nw27n0q60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:30 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LCrb5w031403;
        Tue, 21 Feb 2023 17:48:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6b93b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Feb 2023 17:48:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31LHmOAV53477674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 17:48:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C0552004D;
        Tue, 21 Feb 2023 17:48:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4600720043;
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
Subject: [kvm-unit-tests PATCH v2 1/3] s390x/spec_ex: Use PSW macro
Date:   Tue, 21 Feb 2023 18:48:20 +0100
Message-Id: <20230221174822.1378667-2-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230221174822.1378667-1-nsg@linux.ibm.com>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wqzcMjA4jkJvJhPbpY-djtjaA1BEM4C2
X-Proofpoint-GUID: -ddbTFHndAsYdlhal0D6OiOcaZjDvF9B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_10,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302210148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace explicit psw definition by PSW macro.
No functional change intended.

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
2.36.1

