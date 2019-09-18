Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2E8B62B6
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbfIRMEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:04:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbfIRMEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:04:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 273BC300CB2B;
        Wed, 18 Sep 2019 12:04:46 +0000 (UTC)
Received: from thuth.com (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C528C600C8;
        Wed, 18 Sep 2019 12:04:44 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 6/9] s390x: Move pfmf to lib and make address void
Date:   Wed, 18 Sep 2019 14:04:23 +0200
Message-Id: <20190918120426.20832-7-thuth@redhat.com>
In-Reply-To: <20190918120426.20832-1-thuth@redhat.com>
References: <20190918120426.20832-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 18 Sep 2019 12:04:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

It's needed by other tests soon.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190828113615.4769-2-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/mem.h | 31 ++++++++++++++++++++++++
 s390x/pfmf.c        | 57 +++++++++++----------------------------------
 2 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 75bd778..9b8fd70 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -54,4 +54,35 @@ static inline unsigned char get_storage_key(unsigned long addr)
 	asm volatile("iske %0,%1" : "=d" (skey) : "a" (addr));
 	return skey;
 }
+
+#define PFMF_FSC_4K 0
+#define PFMF_FSC_1M 1
+#define PFMF_FSC_2G 2
+
+union pfmf_r1 {
+	struct {
+		unsigned long pad0 : 32;
+		unsigned long pad1 : 12;
+		unsigned long pad_fmfi : 2;
+		unsigned long sk : 1; /* set key*/
+		unsigned long cf : 1; /* clear frame */
+		unsigned long ui : 1; /* usage indication */
+		unsigned long fsc : 3;
+		unsigned long pad2 : 1;
+		unsigned long mr : 1;
+		unsigned long mc : 1;
+		unsigned long pad3 : 1;
+		unsigned long key : 8; /* storage keys */
+	} reg;
+	unsigned long val;
+};
+
+static inline void *pfmf(unsigned long r1, void *paddr)
+{
+	register void * addr asm("1") = paddr;
+
+	asm volatile(".insn rre,0xb9af0000,%[r1],%[addr]"
+		     : [addr] "+a" (addr) : [r1] "d" (r1) : "memory");
+	return addr;
+}
 #endif
diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index 9bf434a..9986624 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -16,60 +16,29 @@
 #include <asm/facility.h>
 #include <asm/mem.h>
 
-#define FSC_4K 0
-#define FSC_1M 1
-#define FSC_2G 2
-
-union r1 {
-	struct {
-		unsigned long pad0 : 32;
-		unsigned long pad1 : 12;
-		unsigned long pad_fmfi : 2;
-		unsigned long sk : 1; /* set key*/
-		unsigned long cf : 1; /* clear frame */
-		unsigned long ui : 1; /* usage indication */
-		unsigned long fsc : 3;
-		unsigned long pad2 : 1;
-		unsigned long mr : 1;
-		unsigned long mc : 1;
-		unsigned long pad3 : 1;
-		unsigned long key : 8; /* storage keys */
-	} reg;
-	unsigned long val;
-};
-
 static uint8_t pagebuf[PAGE_SIZE * 256] __attribute__((aligned(PAGE_SIZE * 256)));
 
-static inline unsigned long pfmf(unsigned long r1, unsigned long paddr)
-{
-	register uint64_t addr asm("1") = paddr;
-
-	asm volatile(".insn rre,0xb9af0000,%[r1],%[addr]"
-		     : [addr] "+a" (addr) : [r1] "d" (r1) : "memory");
-	return addr;
-}
-
 static void test_priv(void)
 {
 	report_prefix_push("privileged");
 	expect_pgm_int();
 	enter_pstate();
-	pfmf(0, (unsigned long) pagebuf);
+	pfmf(0, pagebuf);
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 }
 
 static void test_4k_key(void)
 {
-	union r1 r1;
+	union pfmf_r1 r1;
 	union skey skey;
 
 	report_prefix_push("4K");
 	r1.val = 0;
 	r1.reg.sk = 1;
-	r1.reg.fsc = FSC_4K;
+	r1.reg.fsc = PFMF_FSC_4K;
 	r1.reg.key = 0x30;
-	pfmf(r1.val, (unsigned long) pagebuf);
+	pfmf(r1.val, pagebuf);
 	skey.val = get_storage_key((unsigned long) pagebuf);
 	skey.val &= SKEY_ACC | SKEY_FP;
 	report("set storage keys", skey.val == 0x30);
@@ -80,15 +49,15 @@ static void test_1m_key(void)
 {
 	int i;
 	bool rp = true;
-	union r1 r1;
+	union pfmf_r1 r1;
 	union skey skey;
 
 	report_prefix_push("1M");
 	r1.val = 0;
 	r1.reg.sk = 1;
-	r1.reg.fsc = FSC_1M;
+	r1.reg.fsc = PFMF_FSC_1M;
 	r1.reg.key = 0x30;
-	pfmf(r1.val, (unsigned long) pagebuf);
+	pfmf(r1.val, pagebuf);
 	for (i = 0; i < 256; i++) {
 		skey.val = get_storage_key((unsigned long) pagebuf + i * PAGE_SIZE);
 		skey.val &= SKEY_ACC | SKEY_FP;
@@ -103,15 +72,15 @@ static void test_1m_key(void)
 
 static void test_4k_clear(void)
 {
-	union r1 r1;
+	union pfmf_r1 r1;
 
 	r1.val = 0;
 	r1.reg.cf = 1;
-	r1.reg.fsc = FSC_4K;
+	r1.reg.fsc = PFMF_FSC_4K;
 
 	report_prefix_push("4K");
 	memset(pagebuf, 42, PAGE_SIZE);
-	pfmf(r1.val, (unsigned long) pagebuf);
+	pfmf(r1.val, pagebuf);
 	report("clear memory", !memcmp(pagebuf, pagebuf + PAGE_SIZE, PAGE_SIZE));
 	report_prefix_pop();
 }
@@ -119,16 +88,16 @@ static void test_4k_clear(void)
 static void test_1m_clear(void)
 {
 	int i;
-	union r1 r1;
+	union pfmf_r1 r1;
 	unsigned long sum = 0;
 
 	r1.val = 0;
 	r1.reg.cf = 1;
-	r1.reg.fsc = FSC_1M;
+	r1.reg.fsc = PFMF_FSC_1M;
 
 	report_prefix_push("1M");
 	memset(pagebuf, 42, PAGE_SIZE * 256);
-	pfmf(r1.val, (unsigned long) pagebuf);
+	pfmf(r1.val, pagebuf);
 	for (i = 0; i < PAGE_SIZE * 256; i++)
 		sum |= pagebuf[i];
 	report("clear memory", !sum);
-- 
2.18.1

