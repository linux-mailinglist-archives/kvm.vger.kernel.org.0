Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E8044CFA2
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 03:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhKKCLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 21:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbhKKCKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 21:10:44 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28415C061226
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 18:07:54 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z187-20020a6233c4000000b0047c2090f1abso2998578pfz.23
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 18:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cLIsvkhrGBYnUpSNCNJBNYz6Cxw5ol9DR3GtAyee4XM=;
        b=UWY+I67x4udh62C37NhqjaJRirQ82H+O8Bapb8N9xQXR1hTzdZo/K1xEJqAq9rNDj8
         /CEXnNB19mzJdGDaFjKWaLdtvzi33ZGiaWh3BQRjYo8B5CDiTZRBGviZpr9x+UfVIAkb
         sjbJ+B7yuNB9hFQXxpGBYeTQX2mmrHCcHAZg/4OVsnXBQaBdxMTg813r2Ch/7TjbpqY0
         z8EX0rkQUlsj71pyKJ/d7eA5S4lz3YcnQAl7M8ewTb9Ej6PUeF4YEby2nGyPc1sOivTc
         CcHqA8McmQsBqqjCAzz1GDv/VgvIqfIMFjVh/1Y17Uc0kgMdlXYJzuPodkBR/eP+VOOR
         EOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cLIsvkhrGBYnUpSNCNJBNYz6Cxw5ol9DR3GtAyee4XM=;
        b=5FPFQQW/VR+PftURSJ+B6f4fVqgxwQ3R6JXdVfCI3SOj9zC28XehloqZg2tZiDBGjF
         jDqsFhlwQOvZ182LMkTLNJGJBPgoJxoDMYjQMaQ4t01LZbyxqes1Urq2i0kvzRG15DbH
         TR1gX+x0Vuy5v74LmwtDBSpWUH3JlSO9lHNxHk6QH/mSuWfI1RYmkG9mKUWB60pgolnX
         YQBi6Xz9DUJtlsBCwSKX2A5Or88IzO5xuo9u/8pC4FBXBFT9qyRC2xjSBKrvT7P9H2zF
         vE9wpES7LOiHtLqWcYW8EZTg4KUooKjmNsDfENPI0xsVBIxm0mKjPQqHUxPVPAVr9pqg
         VlCQ==
X-Gm-Message-State: AOAM532cwhAOcjy5fyDEdFcduFLZJf1rChL4Novu1uFtIjaSeidLMfI6
        51/4EmAHzb2bKidoCdfZIzsUHgDkqUA=
X-Google-Smtp-Source: ABdhPJyA+FPl1GrpuJCEY1SbbkGaO/jmn8V2FSIoEOOofvc+yyStyKbXUIFhESdIZSXyIeRcJnfvlG5Y2FI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr145050pjf.1.1636596472324; Wed, 10 Nov 2021 18:07:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Nov 2021 02:07:28 +0000
In-Reply-To: <20211111020738.2512932-1-seanjc@google.com>
Message-Id: <20211111020738.2512932-8-seanjc@google.com>
Mime-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 07/17] perf: Add wrappers for invoking guest callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers for the guest callbacks to prepare for burying the callbacks
behind a Kconfig (it's a lot easier to provide a few stubs than to #ifdef
piles of code), and also to prepare for converting the callbacks to
static_call().  perf_instruction_pointer() in particular will have subtle
semantics with static_call(), as the "no callbacks" case will return 0 if
the callbacks are unregistered between querying guest state and getting
the IP.  Implement the change now to avoid a functional change when adding
static_call() support, and because the new helper needs to return
_something_ in this case.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kernel/perf_callchain.c | 16 +++++-----------
 arch/x86/events/core.c             | 15 +++++----------
 arch/x86/events/intel/core.c       |  5 +----
 include/linux/perf_event.h         | 24 ++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 274dc3e11b6d..db04a55cee7e 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -102,9 +102,7 @@ compat_user_backtrace(struct compat_frame_tail __user *tail,
 void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
 			 struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	if (guest_cbs && guest_cbs->state()) {
+	if (perf_guest_state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -149,10 +147,9 @@ static bool callchain_trace(void *data, unsigned long pc)
 void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stackframe frame;
 
-	if (guest_cbs && guest_cbs->state()) {
+	if (perf_guest_state()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
@@ -163,18 +160,15 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	if (guest_cbs && guest_cbs->state())
-		return guest_cbs->get_ip();
+	if (perf_guest_state())
+		return perf_guest_get_ip();
 
 	return instruction_pointer(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
+	unsigned int guest_state = perf_guest_state();
 	int misc = 0;
 
 	if (guest_state) {
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index e29312a1003a..620347398027 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2768,11 +2768,10 @@ static bool perf_hw_regs(struct pt_regs *regs)
 void
 perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct unwind_state state;
 	unsigned long addr;
 
-	if (guest_cbs && guest_cbs->state()) {
+	if (perf_guest_state()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2872,11 +2871,10 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry_ctx *ent
 void
 perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stack_frame frame;
 	const struct stack_frame __user *fp;
 
-	if (guest_cbs && guest_cbs->state()) {
+	if (perf_guest_state()) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2953,18 +2951,15 @@ static unsigned long code_segment_base(struct pt_regs *regs)
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-
-	if (guest_cbs && guest_cbs->state())
-		return guest_cbs->get_ip();
+	if (perf_guest_state())
+		return perf_guest_get_ip();
 
 	return regs->ip + code_segment_base(regs);
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
-	unsigned int guest_state = guest_cbs ? guest_cbs->state() : 0;
+	unsigned int guest_state = perf_guest_state();
 	int misc = 0;
 
 	if (guest_state) {
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 24adbd6282d4..a5fb247a6a27 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2837,7 +2837,6 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-	struct perf_guest_info_callbacks *guest_cbs;
 	int bit;
 	int handled = 0;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
@@ -2904,9 +2903,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 */
 	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
 		handled++;
-
-		guest_cbs = perf_get_guest_cbs();
-		if (likely(!guest_cbs || !guest_cbs->handle_intel_pt_intr()))
+		if (!perf_guest_handle_intel_pt_intr())
 			intel_pt_interrupt();
 	}
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5e6b346d62a7..346d5aff5804 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1254,6 +1254,30 @@ static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
 	 */
 	return rcu_dereference(perf_guest_cbs);
 }
+static inline unsigned int perf_guest_state(void)
+{
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+
+	return guest_cbs ? guest_cbs->state() : 0;
+}
+static inline unsigned long perf_guest_get_ip(void)
+{
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+
+	/*
+	 * Arbitrarily return '0' in the unlikely scenario that the callbacks
+	 * are unregistered between checking guest state and getting the IP.
+	 */
+	return guest_cbs ? guest_cbs->get_ip() : 0;
+}
+static inline unsigned int perf_guest_handle_intel_pt_intr(void)
+{
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
+
+	if (guest_cbs && guest_cbs->handle_intel_pt_intr)
+		return guest_cbs->handle_intel_pt_intr();
+	return 0;
+}
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 
-- 
2.34.0.rc0.344.g81b53c2807-goog

