Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47664944A7
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357807AbiATA3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357836AbiATA3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:29:36 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F63C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:36 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 135-20020a62198d000000b004bf3fe65e1fso2587239pfz.2
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1kUXIxqc6t4dkTULTtsGkWzcoZoN+peYLXOdlnkF5rQ=;
        b=gWtkeLIO7bD2WsnoKa3pUqWAExS0zAuqbZ8CKZyWHLxSV4bzq5EOQm0Hn5RgY2n+uG
         nUg2ihYXvl5m8J5TODvq86LhpJB8zfNeaoDVoLD3wD8kiVFMom18yZZ/DJaBJLG0ajg0
         kNjHFLt7M+YtNzhxFf3QVJoAKXb6sPO05Ed1lekqEsFup1V/68GSob3zoj3ENCyXa7+S
         +xXGxU1RA9UXCI/oUhWaaT1Dge8cilqSavb92GlU7yfIbd9kJVUE9Ng2XcICtG+CQKJA
         IfqOBc1CBD/+eUlHbiPWHl5/hUza/z/UFc+PhuxHysFyBUyQtQZ6beaETSDGmrEEI819
         D3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1kUXIxqc6t4dkTULTtsGkWzcoZoN+peYLXOdlnkF5rQ=;
        b=33VdASYenq0khUeGborhMEipKSgo8HyaBhGdhnAvip4EUzNfA8BF1SORCjYtbaq7ei
         IEWXG30NlUmo+swYA4nE/EW28QWsSCKQI2KqpASHnibZEF81iynDacjjkVM0fVtC+4uA
         OwfiZno0tZLrT/OleEH2Tp4hCoiPPdvEpGjckY0aD9enQNRBYkk+S7fIlQAW5owwUhmR
         re6l9Wf91ANVt2ideya3e88/C2LYZpvbe1vt4iy/tLHerQury3/ukfpUlhO47VCBPADt
         Um/YqZyNC8Cqf6+DJBqTpaZy0Ex7u3MMZvFCfghravYoCy/spKuKNsbewYL8kVOk3r8z
         2ukQ==
X-Gm-Message-State: AOAM533LJVu/DDbommC/1/i6VWvNLfBJiZq5EaV8hZsIYiks44dVOKi8
        rvf1WkP0S8jL1e+LqAxZTJrPG6XW5Zg=
X-Google-Smtp-Source: ABdhPJyZQ+0Uom1fa3IbOlAE6Ud0n4LVz675Ifg/wFsyhvdu3S15p4d9bybtjyed88MjfKvPzDEDoStIsZo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:380f:: with SMTP id
 mq15mr7345233pjb.38.1642638575849; Wed, 19 Jan 2022 16:29:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 00:29:22 +0000
In-Reply-To: <20220120002923.668708-1-seanjc@google.com>
Message-Id: <20220120002923.668708-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220120002923.668708-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH 6/7] x86/debug: Add single-step #DB + STI/MOVSS
 blocking tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a variety of test cases to verify single-step #DB interaction with
STI and MOVSS blocking.  Of particular note are STI blocking and MOVSS
blocking with DR7.GD=1, both of which require manual intervention from
the hypervisor to set vmcs.GUEST_PENDING_DBG_EXCEPTION.BS when
re-injecting an intercepted #DB with STI/MOVSS blocking active.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alexander Graf <graf@amazon.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/debug.c | 176 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/x86/debug.c b/x86/debug.c
index 5835a064..0165dc68 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -51,6 +51,11 @@ static inline bool is_single_step_db(unsigned long dr6_val)
 	return dr6_val == (DR6_ACTIVE_LOW | DR6_BS);
 }
 
+static inline bool is_general_detect_db(unsigned long dr6_val)
+{
+	return dr6_val == (DR6_ACTIVE_LOW | DR6_BD);
+}
+
 static inline bool is_icebp_db(unsigned long dr6_val)
 {
 	return dr6_val == DR6_ACTIVE_LOW;
@@ -79,6 +84,8 @@ static void handle_ud(struct ex_regs *regs)
 typedef unsigned long (*db_test_fn)(void);
 typedef void (*db_report_fn)(unsigned long, const char *);
 
+static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void);
+
 static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
 {
 	unsigned long start;
@@ -90,8 +97,13 @@ static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
 	start = test();
 	report_fn(start, "");
 
+	/* MOV DR #GPs at CPL>0, don't try to run the DR7.GD test in usermode. */
+	if (test == singlestep_with_movss_blocking_and_dr7_gd)
+		return;
+
 	n = 0;
 	write_dr6(0);
+
 	/*
 	 * Run the test in usermode.  Use the expected start RIP from the first
 	 * run, the usermode framework doesn't make it easy to get the expected
@@ -178,6 +190,166 @@ static unsigned long singlestep_emulated_instructions(void)
 	return start;
 }
 
+static void report_singlestep_with_sti_blocking(unsigned long start,
+						const char *usermode)
+{
+	report(n == 4 &&
+	       is_single_step_db(dr6[0]) && db_addr[0] == start &&
+	       is_single_step_db(dr6[1]) && db_addr[1] == start + 6 &&
+	       is_single_step_db(dr6[2]) && db_addr[2] == start + 6 + 1 &&
+	       is_single_step_db(dr6[3]) && db_addr[3] == start + 6 + 1 + 1,
+	       "%sSingle-step #DB w/ STI blocking", usermode);
+}
+
+
+static unsigned long singlestep_with_sti_blocking(void)
+{
+	unsigned long start_rip;
+
+	/*
+	 * STI blocking doesn't suppress #DBs, thus the first single-step #DB
+	 * should arrive after the standard one instruction delay.
+	 */
+	asm volatile(
+		"cli\n\t"
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"sti\n\t"
+		"1:and $~(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"lea 1b,%0\n\t"
+		: "=r" (start_rip) : : "rax"
+	);
+	return start_rip;
+}
+
+static void report_singlestep_with_movss_blocking(unsigned long start,
+						  const char *usermode)
+{
+	report(n == 3 &&
+	       is_single_step_db(dr6[0]) && db_addr[0] == start &&
+	       is_single_step_db(dr6[1]) && db_addr[1] == start + 1 &&
+	       is_single_step_db(dr6[2]) && db_addr[2] == start + 1 + 1,
+	       "%sSingle-step #DB w/ MOVSS blocking", usermode);
+}
+
+static unsigned long singlestep_with_movss_blocking(void)
+{
+	unsigned long start_rip;
+
+	/*
+	 * MOVSS blocking suppresses single-step #DBs (and select other #DBs),
+	 * thus the first single-step #DB should occur after MOVSS blocking
+	 * expires, i.e. two instructions after #DBs are enabled in this case.
+	 */ 
+	asm volatile(
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"mov %%ss, %%ax\n\t"
+		"popf\n\t"
+		"mov %%ax, %%ss\n\t"
+		"and $~(1<<8),%%rax\n\t"
+		"1: push %%rax\n\t"
+		"popf\n\t"
+		"lea 1b,%0\n\t"
+		: "=r" (start_rip) : : "rax"
+	);
+	return start_rip;
+}
+
+
+static void report_singlestep_with_movss_blocking_and_icebp(unsigned long start,
+							    const char *usermode)
+{
+	report(n == 4 &&
+	       is_icebp_db(dr6[0]) && db_addr[0] == start &&
+	       is_single_step_db(dr6[1]) && db_addr[1] == start + 6 &&
+	       is_single_step_db(dr6[2]) && db_addr[2] == start + 6 + 1 &&
+	       is_single_step_db(dr6[3]) && db_addr[3] == start + 6 + 1 + 1,
+	       "%sSingle-Step + ICEBP #DB w/ MOVSS blocking", usermode);
+}
+
+static unsigned long singlestep_with_movss_blocking_and_icebp(void)
+{
+	unsigned long start;
+
+	/*
+	 * ICEBP, a.k.a. INT1 or int1icebrk, is an oddball.  It generates a
+	 * trap-like #DB, is intercepted if #DBs are intercepted, and manifests
+	 * as a #DB VM-Exit, but the VM-Exit occurs on the ICEBP itself, i.e.
+	 * it's treated as an instruction intercept.  Verify that ICEBP is
+	 * correctly emulated as a trap-like #DB when intercepted, and that
+	 * MOVSS blocking is handled correctly with respect to single-step
+	 * breakpoints being enabled.
+	 */
+	asm volatile(
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"mov %%ss, %%ax\n\t"
+		"popf\n\t"
+		"mov %%ax, %%ss\n\t"
+		".byte 0xf1;"
+		"1:and $~(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"lea 1b,%0\n\t"
+		: "=r" (start) : : "rax"
+	);
+	return start;
+}
+
+static void report_singlestep_with_movss_blocking_and_dr7_gd(unsigned long start,
+							     const char *ign)
+{
+	report(n == 5 &&
+	       is_general_detect_db(dr6[0]) && db_addr[0] == start &&
+	       is_single_step_db(dr6[1]) && db_addr[1] == start + 3 &&
+	       is_single_step_db(dr6[2]) && db_addr[2] == start + 3 + 6 &&
+	       is_single_step_db(dr6[3]) && db_addr[3] == start + 3 + 6 + 1 &&
+	       is_single_step_db(dr6[4]) && db_addr[4] == start + 3 + 6 + 1 + 1,
+	       "Single-step #DB w/ MOVSS blocking and DR7.GD=1");
+}
+
+static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
+{
+	unsigned long start_rip;
+
+	write_dr7(DR7_GD);
+
+	/*
+	 * MOVSS blocking does NOT suppress General Detect #DBs, which have
+	 * fault-like behavior.  Note, DR7.GD is cleared by the CPU upon
+	 * successful delivery of the #DB.  DR6.BD is NOT cleared by the CPU,
+	 * but the MOV DR6 below will be re-executed after handling the
+	 * General Detect #DB.
+	 */
+	asm volatile(
+		"xor %0, %0\n\t"
+		"pushf\n\t"
+		"pop %%rax\n\t"
+		"or $(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"mov %%ss, %%ax\n\t"
+		"popf\n\t"
+		"mov %%ax, %%ss\n\t"
+		"1: mov %0, %%dr6\n\t"
+		"and $~(1<<8),%%rax\n\t"
+		"push %%rax\n\t"
+		"popf\n\t"
+		"lea 1b,%0\n\t"
+		: "=r" (start_rip) : : "rax"
+	);
+	return start_rip;
+}
+
 int main(int ac, char **av)
 {
 	unsigned long cr4;
@@ -238,6 +410,10 @@ int main(int ac, char **av)
 
 	run_ss_db_test(singlestep_basic);
 	run_ss_db_test(singlestep_emulated_instructions);
+	run_ss_db_test(singlestep_with_sti_blocking);
+	run_ss_db_test(singlestep_with_movss_blocking);
+	run_ss_db_test(singlestep_with_movss_blocking_and_icebp);
+	run_ss_db_test(singlestep_with_movss_blocking_and_dr7_gd);
 
 	n = 0;
 	write_dr1((void *)&value);
-- 
2.34.1.703.g22d0c6ccf7-goog

