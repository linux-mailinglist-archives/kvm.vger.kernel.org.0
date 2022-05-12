Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92098524915
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352153AbiELJgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352045AbiELJfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:35:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBC669B74
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 02:35:37 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9Q1Sl003575
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i1WW5GhsZLzjZFOF3JAsrTKYm9wHeMUcvAeTidZn+zQ=;
 b=Nl2aM2a8HgQoQopz9fIJzBSvffJX89rwl1RIsit8CPKoA4VloJVNAKskAUxIY+w7M0Cr
 jpXobk1AWXwXzJ7V/D732YrJEehOR7rDHaCWG3GyhaaNExgZBgsgUNnlRnEB/nJH6qve
 thj+D5cMCfLGYOt3OdbyH+w1VqBPVitlsp0uYRypFVGq26cfE+ArROw5Rkj6yEblZOBd
 Fj7WHLL0K5p1+5q2pATlgV/5nxnoIRBsc8DrW8rSXyoIniPA2fhKSLGKxLlnLml0wXJ0
 Kt4LIgWznsnnN2Oo7k5MrqBAhPq3k7zQ3YNyAGvbv6wIp2mb9u6sDZWpkPrdcbZ8nHEz MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yksg4ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9Za31003820
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 09:35:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yksg4t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9XbsJ023831;
        Thu, 12 May 2022 09:35:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8xrxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:35:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9ZWxb44630408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:35:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2239A11C04A;
        Thu, 12 May 2022 09:35:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4F3711C04C;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.10.145])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:35:31 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 09/28] s390x: pfmf: Initialize pfmf_r1 union on declaration
Date:   Thu, 12 May 2022 11:35:04 +0200
Message-Id: <20220512093523.36132-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220512093523.36132-1-imbrenda@linux.ibm.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hxoSsPbsK-d_bEglvuotcYYVlikzek54
X-Proofpoint-GUID: njI6lMFvEkvTPcTYzpDG7y4XXMLoAUgU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's make this test look a bit nicer.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/pfmf.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index aa130529..178abb5a 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -28,7 +28,11 @@ static void test_priv(void)
 
 static void test_4k_key(void)
 {
-	union pfmf_r1 r1;
+	union pfmf_r1 r1 = {
+		.reg.sk = 1,
+		.reg.fsc = PFMF_FSC_4K,
+		.reg.key = 0x30,
+	};
 	union skey skey;
 
 	report_prefix_push("4K");
@@ -36,10 +40,6 @@ static void test_4k_key(void)
 		report_skip("storage key removal facility is active");
 		goto out;
 	}
-	r1.val = 0;
-	r1.reg.sk = 1;
-	r1.reg.fsc = PFMF_FSC_4K;
-	r1.reg.key = 0x30;
 	pfmf(r1.val, pagebuf);
 	skey.val = get_storage_key(pagebuf);
 	skey.val &= SKEY_ACC | SKEY_FP;
@@ -52,18 +52,19 @@ static void test_1m_key(void)
 {
 	int i;
 	bool rp = true;
-	union pfmf_r1 r1;
 	union skey skey;
+	union pfmf_r1 r1 = {
+		.reg.fsc = PFMF_FSC_1M,
+		.reg.key = 0x30,
+		.reg.sk = 1,
+	};
 
 	report_prefix_push("1M");
 	if (test_facility(169)) {
 		report_skip("storage key removal facility is active");
 		goto out;
 	}
-	r1.val = 0;
-	r1.reg.sk = 1;
-	r1.reg.fsc = PFMF_FSC_1M;
-	r1.reg.key = 0x30;
+
 	pfmf(r1.val, pagebuf);
 	for (i = 0; i < 256; i++) {
 		skey.val = get_storage_key(pagebuf + i * PAGE_SIZE);
@@ -80,11 +81,10 @@ out:
 
 static void test_4k_clear(void)
 {
-	union pfmf_r1 r1;
-
-	r1.val = 0;
-	r1.reg.cf = 1;
-	r1.reg.fsc = PFMF_FSC_4K;
+	union pfmf_r1 r1 = {
+		.reg.cf = 1,
+		.reg.fsc = PFMF_FSC_4K,
+	};
 
 	report_prefix_push("4K");
 	memset(pagebuf, 42, PAGE_SIZE);
@@ -97,13 +97,12 @@ static void test_4k_clear(void)
 static void test_1m_clear(void)
 {
 	int i;
-	union pfmf_r1 r1;
+	union pfmf_r1 r1 = {
+		.reg.cf = 1,
+		.reg.fsc = PFMF_FSC_1M,
+	};
 	unsigned long sum = 0;
 
-	r1.val = 0;
-	r1.reg.cf = 1;
-	r1.reg.fsc = PFMF_FSC_1M;
-
 	report_prefix_push("1M");
 	memset(pagebuf, 42, PAGE_SIZE * 256);
 	pfmf(r1.val, pagebuf);
-- 
2.36.1

