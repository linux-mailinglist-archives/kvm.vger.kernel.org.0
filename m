Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FE7B62B7
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfIRMEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730569AbfIRMEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:04:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 02A3910576C5;
        Wed, 18 Sep 2019 12:04:48 +0000 (UTC)
Received: from thuth.com (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 859C86012C;
        Wed, 18 Sep 2019 12:04:46 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 7/9] s390x: Storage key library functions now take void ptr addresses
Date:   Wed, 18 Sep 2019 14:04:24 +0200
Message-Id: <20190918120426.20832-8-thuth@redhat.com>
In-Reply-To: <20190918120426.20832-1-thuth@redhat.com>
References: <20190918120426.20832-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Wed, 18 Sep 2019 12:04:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Now all mem.h functions are consistent in how they take a memory
address. Also we have less casting in the future.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190828113615.4769-3-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
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
2.18.1

