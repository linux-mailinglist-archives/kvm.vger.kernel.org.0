Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BCD4944A3
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357793AbiATA3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344860AbiATA3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:29:30 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100C4C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:30 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id j28-20020a637a5c000000b00344d66c3c56so2591853pgn.21
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=El/quCzeSGh8/qkvaNqWRy0AcE59nBWFTdtwXpWBjlM=;
        b=DWrzh3SxDrY9l8WLLJbwjkeY6YC//x2KSl9uVfZ7NukjFknVNxi0dtzc7kSIWcBHXP
         K2Y9aKDsxrgXQV7LFRsAcpRUDT2JK9gX+KhUPr9KocrHOrvn+1OvHatb2vE5AMFaocf0
         81I9eB+SkE8P1nZYR1/Cl9XaQBnYqKcZBfL3UudhmxKlYqC7ZwG+/ZvqvXBQIICpvylU
         lCXpvU4v2N17cb5aXGH82F9REPcY2jupC6P295bYuVNIitRf3ClaMQ/x8A461NF/LQ/8
         HaYhanhTIDQvR/2S1I0olEbmG1ZRrcO+tsd9p1H+SzY93NSYagmQARU26v7EgsjXC2xr
         4uqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=El/quCzeSGh8/qkvaNqWRy0AcE59nBWFTdtwXpWBjlM=;
        b=OzpLTRZkijbC+EL7ZQL50ASo8tZonmoU9GUQP+y013aq9QibI3FT/QyjQ3Gpo3Uj/u
         tCIw80IBt7uR6PcTCb1Aw/sv0crViQNsSBRvMucYfBOeErhWK1Q5CN5VhAfgKm9760KD
         UuFRKDyj8VgaOvqGmDGKt//X9vBEi9rVkPFGrDpQY09vk4+bDAA8RbPTbZyThpq0Eh8o
         qp58aiHTFBnTO9UMU9bnBA2+HDVs7pzg3pUcqViI3Zui9bsVg5Oxyd0mg8jxQ+gMBVWK
         HCzgvjiWIi8g1DofbeO7sY/YZtACrjscrvRUzfhga3cgckYr5cp/bQdw5JhH9Jw2+qGb
         8SRQ==
X-Gm-Message-State: AOAM532IdKejxMPMdsprpK8mAADYqI3OsRgC/pYxPS/Pd5az1UGU9zq0
        zZSM0MDiZ754mSJ12KLaudOjF4TdOCQ=
X-Google-Smtp-Source: ABdhPJygqksaCOFoJRLLUPJZv/SFUZmYqKL9KNUZUqRc/i+IClXC29qdpEaWLfGFS3sunOHov0FJEiWVlio=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9305:b0:14a:db23:eb5d with SMTP id
 bc5-20020a170902930500b0014adb23eb5dmr10438886plb.73.1642638569583; Wed, 19
 Jan 2022 16:29:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:29:18 +0000
In-Reply-To: <20220120002923.668708-1-seanjc@google.com>
Message-Id: <20220120002923.668708-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220120002923.668708-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH 2/7] x86/debug: Add framework for single-step
 #DB tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a framework to the "debug" test for running single-step #DB tests,
future commits will extend the single-step tests to run in usermode and
to verify interaction with STI and MOVSS blocking.

Opportunistically add comments and stop open coding RFLAGS stuff.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/debug.c | 168 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 115 insertions(+), 53 deletions(-)

diff --git a/x86/debug.c b/x86/debug.c
index 0019ebd5..98bdfe36 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -36,14 +36,24 @@ static void handle_db(struct ex_regs *regs)
 	dr6[n] = read_dr6();
 
 	if (dr6[n] & 0x1)
-		regs->rflags |= (1 << 16);
+		regs->rflags |= X86_EFLAGS_RF;
 
 	if (++n >= 10) {
-		regs->rflags &= ~(1 << 8);
+		regs->rflags &= ~X86_EFLAGS_TF;
 		write_dr7(0x00000400);
 	}
 }
 
+static inline bool is_single_step_db(unsigned long dr6_val)
+{
+	return dr6_val == 0xffff4ff0;
+}
+
+static inline bool is_icebp_db(unsigned long dr6_val)
+{
+	return dr6_val == 0xffff0ff0;
+}
+
 extern unsigned char handle_db_save_rip;
 asm("handle_db_save_rip:\n"
    "stc\n"
@@ -64,15 +74,106 @@ static void handle_ud(struct ex_regs *regs)
 	got_ud = 1;
 }
 
+typedef unsigned long (*db_test_fn)(void);
+typedef void (*db_report_fn)(unsigned long);
+
+static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
+{
+	unsigned long start;
+
+	n = 0;
+	write_dr6(0);
+
+	start = test();
+	report_fn(start);
+}
+
+#define run_ss_db_test(name) __run_single_step_db_test(name, report_##name)
+
+static void report_singlestep_basic(unsigned long start)
+{
+	report(n == 3 &&
+	       is_single_step_db(dr6[0]) && db_addr[0] == start &&
+	       is_single_step_db(dr6[1]) && db_addr[1] == start + 1 &&
+	       is_single_step_db(dr6[2]) && db_addr[2] == start + 1 + 1,
+	       "Single-step #DB basic test");
+}
+
+static unsigned long singlestep_basic(void)
+{
+	unsigned long start;
+
+	/*
+	 * After being enabled, single-step breakpoints have a one instruction
+	 * delay before the first #DB is generated.
+	 */
+	asm volatile (
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"and $~(1<<8),%%rax\n\t"
+		"1:push %%rax\n\t"
+		"popf\n\t"
+		"lea 1b, %0\n\t"
+		: "=r" (start) : : "rax"
+	);
+	return start;
+}
+
+static void report_singlestep_emulated_instructions(unsigned long start)
+{
+	report(n == 7 &&
+	       is_single_step_db(dr6[0]) && db_addr[0] == start &&
+	       is_single_step_db(dr6[1]) && db_addr[1] == start + 1 &&
+	       is_single_step_db(dr6[2]) && db_addr[2] == start + 1 + 3 &&
+	       is_single_step_db(dr6[3]) && db_addr[3] == start + 1 + 3 + 2 &&
+	       is_single_step_db(dr6[4]) && db_addr[4] == start + 1 + 3 + 2 + 5 &&
+	       is_single_step_db(dr6[5]) && db_addr[5] == start + 1 + 3 + 2 + 5 + 2 &&
+	       is_single_step_db(dr6[6]) && db_addr[6] == start + 1 + 3 + 2 + 5 + 2 + 1,
+	       "Single-step #DB on emulated instructions");
+}
+
+static unsigned long singlestep_emulated_instructions(void)
+{
+	unsigned long start;
+
+	/*
+	 * Verify single-step #DB are generated correctly on emulated
+	 * instructions, e.g. CPUID and RDMSR.
+	 */
+	asm volatile (
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"and $~(1<<8),%%rax\n\t"
+		"1:push %%rax\n\t"
+		"xor %%rax,%%rax\n\t"
+		"cpuid\n\t"
+		"movl $0x1a0,%%ecx\n\t"
+		"rdmsr\n\t"
+		"popf\n\t"
+		"lea 1b,%0\n\t"
+		: "=r" (start) : : "rax", "ebx", "ecx", "edx"
+	);
+	return start;
+}
+
 int main(int ac, char **av)
 {
-	unsigned long start;
 	unsigned long cr4;
 
 	handle_exception(DB_VECTOR, handle_db);
 	handle_exception(BP_VECTOR, handle_bp);
 	handle_exception(UD_VECTOR, handle_ud);
 
+	/*
+	 * DR4 is an alias for DR6 (and DR5 aliases DR7) if CR4.DE is NOT set,
+	 * and is reserved if CR4.DE=1 (Debug Extensions enabled).
+	 */
 	got_ud = 0;
 	cr4 = read_cr4();
 	write_cr4(cr4 & ~X86_CR4_DE);
@@ -83,13 +184,21 @@ int main(int ac, char **av)
 	cr4 = read_cr4();
 	write_cr4(cr4 | X86_CR4_DE);
 	read_dr4();
-	report(got_ud, "reading DR4 with CR4.DE == 1");
+	report(got_ud, "DR4 read got #UD with CR4.DE == 1");
 	write_dr6(0);
 
 	extern unsigned char sw_bp;
 	asm volatile("int3; sw_bp:");
 	report(bp_addr == (unsigned long)&sw_bp, "#BP");
 
+	/*
+	 * The CPU sets/clears bits 0-3 (trap bits for DR0-3) on #DB based on
+	 * whether or not the corresponding DR0-3 got a match.  All other bits
+	 * in DR6 are set if and only if their associated breakpoint condition
+	 * is active, and are never cleared by the CPU.  Verify a match on DR0
+	 * is reported correctly, and that DR6.BS is not set when single-step
+	 * breakpoints are disabled, but is left set (if set by software).
+	 */
 	n = 0;
 	extern unsigned char hw_bp1;
 	write_dr0(&hw_bp1);
@@ -108,55 +217,8 @@ int main(int ac, char **av)
 	       db_addr[0] == ((unsigned long)&hw_bp2) && dr6[0] == 0xffff4ff1,
 	       "hw breakpoint (test that dr6.BS is not cleared)");
 
-	n = 0;
-	write_dr6(0);
-	asm volatile(
-		"pushf\n\t"
-		"pop %%rax\n\t"
-		"or $(1<<8),%%rax\n\t"
-		"push %%rax\n\t"
-		"lea (%%rip),%0\n\t"
-		"popf\n\t"
-		"and $~(1<<8),%%rax\n\t"
-		"push %%rax\n\t"
-		"popf\n\t"
-		: "=r" (start) : : "rax");
-	report(n == 3 &&
-	       db_addr[0] == start + 1 + 6 && dr6[0] == 0xffff4ff0 &&
-	       db_addr[1] == start + 1 + 6 + 1 && dr6[1] == 0xffff4ff0 &&
-	       db_addr[2] == start + 1 + 6 + 1 + 1 && dr6[2] == 0xffff4ff0,
-	       "single step");
-
-	/*
-	 * cpuid and rdmsr (among others) trigger VM exits and are then
-	 * emulated. Test that single stepping works on emulated instructions.
-	 */
-	n = 0;
-	write_dr6(0);
-	asm volatile(
-		"pushf\n\t"
-		"pop %%rax\n\t"
-		"or $(1<<8),%%rax\n\t"
-		"push %%rax\n\t"
-		"lea (%%rip),%0\n\t"
-		"popf\n\t"
-		"and $~(1<<8),%%rax\n\t"
-		"push %%rax\n\t"
-		"xor %%rax,%%rax\n\t"
-		"cpuid\n\t"
-		"movl $0x1a0,%%ecx\n\t"
-		"rdmsr\n\t"
-		"popf\n\t"
-		: "=r" (start) : : "rax", "ebx", "ecx", "edx");
-	report(n == 7 &&
-	       db_addr[0] == start + 1 + 6 && dr6[0] == 0xffff4ff0 &&
-	       db_addr[1] == start + 1 + 6 + 1 && dr6[1] == 0xffff4ff0 &&
-	       db_addr[2] == start + 1 + 6 + 1 + 3 && dr6[2] == 0xffff4ff0 &&
-	       db_addr[3] == start + 1 + 6 + 1 + 3 + 2 && dr6[3] == 0xffff4ff0 &&
-	       db_addr[4] == start + 1 + 6 + 1 + 3 + 2 + 5 && dr6[4] == 0xffff4ff0 &&
-	       db_addr[5] == start + 1 + 6 + 1 + 3 + 2 + 5 + 2 && dr6[5] == 0xffff4ff0 &&
-	       db_addr[6] == start + 1 + 6 + 1 + 3 + 2 + 5 + 2 + 1 && dr6[6] == 0xffff4ff0,
-	       "single step emulated instructions");
+	run_ss_db_test(singlestep_basic);
+	run_ss_db_test(singlestep_emulated_instructions);
 
 	n = 0;
 	write_dr1((void *)&value);
-- 
2.34.1.703.g22d0c6ccf7-goog

