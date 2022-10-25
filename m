Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79E960CB1B
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiJYLn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiJYLnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1889173FD3
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:52 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8Swa028272
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2M5Sulwh3/JdTkj8TvueB9mkIUtcuxJOI8wBiXyqpac=;
 b=FDTa95MP/fvkZ59/G4KJobEm8yjrwp2JNPLib0PQ+BvxJz4PckUUcP6aiHRcey0uN3c2
 PF/H74NUcDcUUI8x2wYDPt2xryJ+5V/+jzVUQxx5d51wKYSgZ7mVtnUTs+fqcxe0E3ky
 V1r602ttLeC8QunlaLWcG163lwqmiYBf4fC2eALLtU6cD2JGeirQt6jAIK0+e/Zoumam
 ZAZI2LWI/W+LW1AX9sacQ9x3ppCU2h7KYPJDkfsj6xeoA72bL3DTHeHAfKfZaxJDOtap
 yI31eaJkj8ItjcFL+IuWZMCosfTUOIbfYNOLGE+RwzRsFNxW3uDGSBPJ8O/KEMoAkGzz 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kebjt8a8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:52 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBB3Fi006521
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:51 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kebjt8a86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:51 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBd2xK024232;
        Tue, 25 Oct 2022 11:43:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugat576-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhkKL34931190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EC6FAE045;
        Tue, 25 Oct 2022 11:43:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CC84AE051;
        Tue, 25 Oct 2022 11:43:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:46 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 03/22] lib/s390x: move TOD clock related functions to library
Date:   Tue, 25 Oct 2022 13:43:26 +0200
Message-Id: <20221025114345.28003-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FP8w6hsPm9flP7bNl0iOCLBk31k1pZRc
X-Proofpoint-ORIG-GUID: H_6eaR_fWJyeEpYYY1DJBA2XeswrGvcD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 mlxscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=975 priorityscore=1501 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

The TOD-clock related functions can be useful for other tests beside the
sck test, hence move them to the library.

While at it, add a wrapper for stckf, express get_clock_us() with
stck() and remove an unneeded memory clobber.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221011170024.972135-2-nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/time.h | 50 +++++++++++++++++++++++++++++++++++++++++++-
 s390x/sck.c          | 32 ----------------------------
 2 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index d8d91d68..ad689b09 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -18,11 +18,59 @@
 
 #define CPU_TIMER_SHIFT_US	S390_CLOCK_SHIFT_US
 
+static inline int sck(uint64_t *time)
+{
+	int cc;
+
+	asm volatile(
+		"	sck %[time]\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=d"(cc)
+		: [time] "Q"(*time)
+		: "cc"
+	);
+
+	return cc;
+}
+
+static inline int stck(uint64_t *time)
+{
+	int cc;
+
+	asm volatile(
+		"	stck %[time]\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=d" (cc), [time] "=Q" (*time)
+		:
+		: "cc"
+	);
+
+	return cc;
+}
+
+static inline int stckf(uint64_t *time)
+{
+	int cc;
+
+	asm volatile(
+		"	stckf %[time]\n"
+		"	ipm %[cc]\n"
+		"	srl %[cc],28\n"
+		: [cc] "=d" (cc), [time] "=Q" (*time)
+		:
+		: "cc"
+	);
+
+	return cc;
+}
+
 static inline uint64_t get_clock_us(void)
 {
 	uint64_t clk;
 
-	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
+	stck(&clk);
 
 	return clk >> STCK_SHIFT_US;
 }
diff --git a/s390x/sck.c b/s390x/sck.c
index 88d52b74..dff49618 100644
--- a/s390x/sck.c
+++ b/s390x/sck.c
@@ -12,38 +12,6 @@
 #include <asm/interrupt.h>
 #include <asm/time.h>
 
-static inline int sck(uint64_t *time)
-{
-	int cc;
-
-	asm volatile(
-		"	sck %[time]\n"
-		"	ipm %[cc]\n"
-		"	srl %[cc],28\n"
-		: [cc] "=d"(cc)
-		: [time] "Q"(*time)
-		: "cc"
-	);
-
-	return cc;
-}
-
-static inline int stck(uint64_t *time)
-{
-	int cc;
-
-	asm volatile(
-		"	stck %[time]\n"
-		"	ipm %[cc]\n"
-		"	srl %[cc],28\n"
-		: [cc] "=d" (cc), [time] "=Q" (*time)
-		:
-		: "cc", "memory"
-	);
-
-	return cc;
-}
-
 static void test_priv(void)
 {
 	uint64_t time_to_set_privileged = 0xfacef00dcafe0000,
-- 
2.37.3

