Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7CB62B5
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfIRMEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:04:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbfIRMEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:04:44 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 738E18A1C80;
        Wed, 18 Sep 2019 12:04:44 +0000 (UTC)
Received: from thuth.com (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FFB9600C8;
        Wed, 18 Sep 2019 12:04:42 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 5/9] s390x: Add diag308 subcode 0 testing
Date:   Wed, 18 Sep 2019 14:04:22 +0200
Message-Id: <20190918120426.20832-6-thuth@redhat.com>
In-Reply-To: <20190918120426.20832-1-thuth@redhat.com>
References: <20190918120426.20832-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 18 Sep 2019 12:04:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

By adding a load reset routine to cstart.S we can also test the clear
reset done by subcode 0, as we now can restore our registers again.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190826163502.1298-6-frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/cstart64.S | 27 +++++++++++++++++++++++++++
 s390x/diag308.c  | 31 ++++++++++---------------------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index dedfe80..36f7cab 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -145,6 +145,33 @@ memsetxc:
 	.endm
 
 .section .text
+/*
+ * load_reset calling convention:
+ * %r2 subcode (0 or 1)
+ */
+.globl diag308_load_reset
+diag308_load_reset:
+	SAVE_REGS
+	/* Save the first PSW word to the IPL PSW */
+	epsw	%r0, %r1
+	st	%r0, 0
+	/* Store the address and the bit for 31 bit addressing */
+	larl    %r0, 0f
+	oilh    %r0, 0x8000
+	st      %r0, 0x4
+	/* Do the reset */
+	diag    %r0,%r2,0x308
+	/* Failure path */
+	xgr	%r2, %r2
+	br	%r14
+	/* Success path */
+	/* We lost cr0 due to the reset */
+0:	larl	%r1, initial_cr0
+	lctlg	%c0, %c0, 0(%r1)
+	RESTORE_REGS
+	lhi	%r2, 1
+	br	%r14
+
 pgm_int:
 	SAVE_REGS
 	brasl	%r14, handle_pgm_int
diff --git a/s390x/diag308.c b/s390x/diag308.c
index f085b1a..6b4ffa6 100644
--- a/s390x/diag308.c
+++ b/s390x/diag308.c
@@ -21,32 +21,20 @@ static void test_priv(void)
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 }
 
+
 /*
- * Check that diag308 with subcode 1 loads the PSW at address 0, i.e.
+ * Check that diag308 with subcode 0 and 1 loads the PSW at address 0, i.e.
  * that we can put a pointer into address 4 which then gets executed.
  */
+extern int diag308_load_reset(u64);
+static void test_subcode0(void)
+{
+	report("load modified clear done", diag308_load_reset(0));
+}
+
 static void test_subcode1(void)
 {
-	uint64_t saved_psw = *(uint64_t *)0;
-	long subcode = 1;
-	long ret, tmp;
-
-	asm volatile (
-		"	epsw	%0,%1\n"
-		"	st	%0,0\n"
-		"	larl	%0,0f\n"
-		"	oilh	%0,0x8000\n"
-		"	st	%0,4\n"
-		"	diag	0,%2,0x308\n"
-		"	lghi	%0,0\n"
-		"	j	1f\n"
-		"0:	lghi	%0,1\n"
-		"1:"
-		: "=&d"(ret), "=&d"(tmp) : "d"(subcode) : "memory");
-
-	*(uint64_t *)0 = saved_psw;
-
-	report("load normal reset done", ret == 1);
+	report("load normal reset done", diag308_load_reset(1));
 }
 
 /* Expect a specification exception when using an uneven register */
@@ -107,6 +95,7 @@ static struct {
 	void (*func)(void);
 } tests[] = {
 	{ "privileged", test_priv },
+	{ "subcode 0", test_subcode0 },
 	{ "subcode 1", test_subcode1 },
 	{ "subcode 5", test_subcode5 },
 	{ "subcode 6", test_subcode6 },
-- 
2.18.1

