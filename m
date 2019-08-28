Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9AFA00C3
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 13:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfH1Lgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 07:36:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726259AbfH1Lga (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Aug 2019 07:36:30 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7SBX72X071257
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 07:36:29 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2unpue563q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 07:36:28 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 28 Aug 2019 12:36:27 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 28 Aug 2019 12:36:25 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7SBaOqP40501464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 11:36:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 373D5A4064;
        Wed, 28 Aug 2019 11:36:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75423A405C;
        Wed, 28 Aug 2019 11:36:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Aug 2019 11:36:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/4] s390x: Storage key library functions now take void ptr addresses
Date:   Wed, 28 Aug 2019 13:36:13 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190828113615.4769-1-frankja@linux.ibm.com>
References: <20190828113615.4769-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082811-4275-0000-0000-0000035E47AA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082811-4276-0000-0000-000038707B84
Message-Id: <20190828113615.4769-3-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-28_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908280124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now all mem.h functions are consistent in how they take a memory
address. Also we have less casting in the future.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/mem.h |  9 +++------
 s390x/pfmf.c        |  4 ++--
 s390x/skey.c        | 24 +++++++++++-------------
 3 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 9b8fd70..c78bfa2 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -26,9 +26,7 @@ union skey {
 	uint8_t val;
 };
 
-static inline void set_storage_key(unsigned long addr,
-				   unsigned char skey,
-				   int nq)
+static inline void set_storage_key(void *addr, unsigned char skey, int nq)
 {
 	if (nq)
 		asm volatile(".insn rrf,0xb22b0000,%0,%1,8,0"
@@ -37,8 +35,7 @@ static inline void set_storage_key(unsigned long addr,
 		asm volatile("sske %0,%1" : : "d" (skey), "a" (addr));
 }
 
-static inline unsigned long set_storage_key_mb(unsigned long addr,
-					       unsigned char skey)
+static inline void *set_storage_key_mb(void *addr, unsigned char skey)
 {
 	assert(test_facility(8));
 
@@ -47,7 +44,7 @@ static inline unsigned long set_storage_key_mb(unsigned long addr,
 	return addr;
 }
 
-static inline unsigned char get_storage_key(unsigned long addr)
+static inline unsigned char get_storage_key(void *addr)
 {
 	unsigned char skey;
 
diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index 9986624..0b3e70b 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -39,7 +39,7 @@ static void test_4k_key(void)
 	r1.reg.fsc = PFMF_FSC_4K;
 	r1.reg.key = 0x30;
 	pfmf(r1.val, pagebuf);
-	skey.val = get_storage_key((unsigned long) pagebuf);
+	skey.val = get_storage_key(pagebuf);
 	skey.val &= SKEY_ACC | SKEY_FP;
 	report("set storage keys", skey.val == 0x30);
 	report_prefix_pop();
@@ -59,7 +59,7 @@ static void test_1m_key(void)
 	r1.reg.key = 0x30;
 	pfmf(r1.val, pagebuf);
 	for (i = 0; i < 256; i++) {
-		skey.val = get_storage_key((unsigned long) pagebuf + i * PAGE_SIZE);
+		skey.val = get_storage_key(pagebuf + i * PAGE_SIZE);
 		skey.val &= SKEY_ACC | SKEY_FP;
 		if (skey.val != 0x30) {
 			rp = false;
diff --git a/s390x/skey.c b/s390x/skey.c
index fd4fcc7..efc4eca 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -18,14 +18,12 @@
 
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
-const unsigned long page0 = (unsigned long)pagebuf;
-const unsigned long page1 = (unsigned long)(pagebuf + PAGE_SIZE);
 
 static void test_set_mb(void)
 {
 	union skey skey, ret1, ret2;
-	unsigned long addr = 0x10000 - 2 * PAGE_SIZE;
-	unsigned long end = 0x10000;
+	void *addr = (void *)0x10000 - 2 * PAGE_SIZE;
+	void *end = (void *)0x10000;
 
 	/* Multi block support came with EDAT 1 */
 	if (!test_facility(8))
@@ -46,10 +44,10 @@ static void test_chg(void)
 	union skey skey1, skey2;
 
 	skey1.val = 0x30;
-	set_storage_key(page0, skey1.val, 0);
-	skey1.val = get_storage_key(page0);
+	set_storage_key(pagebuf, skey1.val, 0);
+	skey1.val = get_storage_key(pagebuf);
 	pagebuf[0] = 3;
-	skey2.val = get_storage_key(page0);
+	skey2.val = get_storage_key(pagebuf);
 	report("chg bit test", !skey1.str.ch && skey2.str.ch);
 }
 
@@ -58,9 +56,9 @@ static void test_set(void)
 	union skey skey, ret;
 
 	skey.val = 0x30;
-	ret.val = get_storage_key(page0);
-	set_storage_key(page0, skey.val, 0);
-	ret.val = get_storage_key(page0);
+	ret.val = get_storage_key(pagebuf);
+	set_storage_key(pagebuf, skey.val, 0);
+	ret.val = get_storage_key(pagebuf);
 	/*
 	 * For all set tests we only test the ACC and FP bits. RF and
 	 * CH are set by the machine for memory references and changes
@@ -103,11 +101,11 @@ static void test_priv(void)
 	report_prefix_push("sske");
 	expect_pgm_int();
 	enter_pstate();
-	set_storage_key(page0, 0x30, 0);
+	set_storage_key(pagebuf, 0x30, 0);
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 
-	skey.val = get_storage_key(page0);
+	skey.val = get_storage_key(pagebuf);
 	report("skey did not change on exception", skey.str.acc != 3);
 
 	report_prefix_push("iske");
@@ -117,7 +115,7 @@ static void test_priv(void)
 	} else {
 		expect_pgm_int();
 		enter_pstate();
-		get_storage_key(page0);
+		get_storage_key(pagebuf);
 		check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	}
 	report_prefix_pop();
-- 
2.17.0

