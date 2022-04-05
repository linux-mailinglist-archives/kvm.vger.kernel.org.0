Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6329F4F2763
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 10:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiDEIEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 04:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbiDEH7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 03:59:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD5141302;
        Tue,  5 Apr 2022 00:55:46 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23554OqD017501;
        Tue, 5 Apr 2022 07:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jUgNqGIEjj4JmOLp601RmPF6yRQQNNFC9aNq9Z9Ltxk=;
 b=D5o8m9g1nH/F0Bbv1D88doEp4rD0txXlCmLtoeVLMmcD2j2gFTDuHJljcoDqQjp9OcaK
 NfnXgXBx0rVJokwoZoCMX7EL+2Rs3xVHcf5nfm6F/t1ZVCaDAEiPdb7sJPetL34Iumm3
 fQeYGEyM2g1ZT3rPzJqVXQ+ob1rjrhW2tmfxz88h7EeOcEfrv69O0DZ8x3HJHmWb65kj
 dF7sIfr2qpD4lxNDv6E6P0Le4bwutxmzMow+QS9MUN7EzSGAQEfXcmzd27ssJaaJ4hKn
 uBDMJWkJo60h6Yt9XnJW8YYCbQAs2E2bMQ/ofJvUWic5V82NvcwOdRc7ad8n5BNlZmTM FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f80yt1wrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:46 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2357ex22031431;
        Tue, 5 Apr 2022 07:55:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f80yt1wqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2357h7XD024163;
        Tue, 5 Apr 2022 07:55:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3f6e48v9g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2357teCR48365890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 07:55:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A7FD42042;
        Tue,  5 Apr 2022 07:55:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58AAA4203F;
        Tue,  5 Apr 2022 07:55:39 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 07:55:39 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/8] s390x: pfmf: Initialize pfmf_r1 union on declaration
Date:   Tue,  5 Apr 2022 07:52:20 +0000
Message-Id: <20220405075225.15903-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220405075225.15903-1-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NtgX6XaUURZrb251QeTeKPETUWERckrR
X-Proofpoint-GUID: AGdY-ywtVttQitNnEXpxh8tf64QQXa8M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=990 clxscore=1015 phishscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make this test look a bit nicer.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.32.0

