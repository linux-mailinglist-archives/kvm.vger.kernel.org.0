Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DD4414283
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhIVHVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:21:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233221AbhIVHUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:35 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M60VpE032422;
        Wed, 22 Sep 2021 03:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TrnPyV9k3gr7Ee6H2rFPWgw53Btp5MjKLeNoF1BcKIo=;
 b=Zcfob25fze4HYU85LJHl36I6gY5nErMCbsfVq3Uqkm9O9sw4HH7HnrbxLBCBYvK5Ca8O
 vq2u2YlxmFS74Dcr9UYTFBeSMuQrnOu3P8IrJ5ZnhmlmPU720l2o5EPvjAar0LbjZ/l/
 V00ZG/eElrO/FBRQ79sxDrMeFfMpos5Upj6BmMPWyUL2ssBMkrPrEuWmXV253OAY4Xql
 b4KQSDwOjvOXWM5oWB2wbb3jaCLNx1hce1wtfkzXz5V0MXUrzC6spQv1u5Bh2b3IFX/c
 YFv3Onu1j8Lp9x57R6hdAL7EgeNJF6MCmoHP4QFgGsTyjhZuMSaZIRVitErDVyCMPGVn pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7tkwe1hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:01 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M6xGXZ010297;
        Wed, 22 Sep 2021 03:19:01 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7tkwe1gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:19:01 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M77xRb030153;
        Wed, 22 Sep 2021 07:18:58 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3b7q6qugpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:18:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7Itw158589658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:18:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03D52A4059;
        Wed, 22 Sep 2021 07:18:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BEE2A4057;
        Wed, 22 Sep 2021 07:18:54 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:54 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/9] s390x: pfmf: Fix 1MB handling
Date:   Wed, 22 Sep 2021 07:18:04 +0000
Message-Id: <20210922071811.1913-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922071811.1913-1-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: t4d1mlIfhpFTpDayey3cjF2Tul6oF2kH
X-Proofpoint-GUID: elbZYQ8g5Ld9hN307iHNm3NfVXT5W6FM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxlogscore=888 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2109200000
 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On everything larger than 4k pfmf will update the address in GR2 when
it's interrupted so we should loop on pfmf and not trust that it
doesn't get interrupted.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/pfmf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index 2f3cb110..b0095bd7 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -54,6 +54,7 @@ static void test_1m_key(void)
 	bool rp = true;
 	union pfmf_r1 r1;
 	union skey skey;
+	void *addr = pagebuf;
 
 	report_prefix_push("1M");
 	if (test_facility(169)) {
@@ -64,7 +65,9 @@ static void test_1m_key(void)
 	r1.reg.sk = 1;
 	r1.reg.fsc = PFMF_FSC_1M;
 	r1.reg.key = 0x30;
-	pfmf(r1.val, pagebuf);
+	do {
+		addr = pfmf(r1.val, addr);
+	} while ((uintptr_t)addr != (uintptr_t)pagebuf + HPAGE_SIZE);
 	for (i = 0; i < 256; i++) {
 		skey.val = get_storage_key(pagebuf + i * PAGE_SIZE);
 		skey.val &= SKEY_ACC | SKEY_FP;
@@ -99,6 +102,7 @@ static void test_1m_clear(void)
 	int i;
 	union pfmf_r1 r1;
 	unsigned long sum = 0;
+	void *addr = pagebuf;
 
 	r1.val = 0;
 	r1.reg.cf = 1;
@@ -106,7 +110,9 @@ static void test_1m_clear(void)
 
 	report_prefix_push("1M");
 	memset(pagebuf, 42, PAGE_SIZE * 256);
-	pfmf(r1.val, pagebuf);
+	do {
+		addr = pfmf(r1.val, addr);
+	} while ((uintptr_t)addr != (uintptr_t)pagebuf + HPAGE_SIZE);
 	for (i = 0; i < PAGE_SIZE * 256; i++)
 		sum |= pagebuf[i];
 	report(!sum, "clear memory");
-- 
2.30.2

