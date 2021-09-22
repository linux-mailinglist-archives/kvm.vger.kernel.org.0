Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4672413E4C
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhIVAHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhIVAHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:07:32 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EA8C06175F
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:05:59 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id w17-20020ae9e511000000b00431497430b7so5678952qkf.12
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=sNDCyCpfsN1q6fRIAZGHe8t08fZK9DQU77lycxeDgvE=;
        b=VfPFQTi2H68Pv6JmEb/KQ6WY/Mh3+l2kbL2XaDfVNNRWtfkT0wPW7iSQgW51WR5Ixu
         QaVgL8eDvDPLryj3vrQdNZbcnETMB9dGrhIzgmphuyjNlSU7aoy32NJ7ZHdZp0tssaUn
         WmTaDF7tt5GMvqHs/f51AneClTfDU4/Qx1Y7bh13Y1mJ7NTIjpZczmD07Ifh3YHzj8to
         lJYiaCZYA+JZO1GYoyMeT2BFWYalqIN+pUd4yUi7DujNd/X/ujswoWs0DebayZIqAv/y
         Meqb7X4l8tyF48vYwj84msbYaRs7+6wgTa49v9X0jrHAK7tmUtVCOQiRYMjdbLlI0bf9
         COSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=sNDCyCpfsN1q6fRIAZGHe8t08fZK9DQU77lycxeDgvE=;
        b=r9ffim8t2zHpG8TZvKEAsYwve+/MXGpUHz/MtWlN0/WWh2r2WT7Xc0KG+68HLuQVd5
         Hw0KnXwLgVHmb8jmG3OkyeSS4/74qpgwD2+gcw8N5jvUis775Tns3Wk2aslNe7+6uYc1
         dKHapOCFlzSKwlE4koYRv8dU9emDh2kLtRuoq4iE8hxOAIb1l09gVPHSXAJUkJvqUYEc
         UArkR1A/VlSZitw7KhTsYaRDl/SQbqMlAUmm+5TLxG9yrCul+WWxdBO7wlYVw//fid0r
         tY0npipH0fLtmmXHPjB8rYNeE6Vt9IRV5yzIY3Gzwk4/GY2D442Udk/0A+dNk3ftVtoJ
         I8ig==
X-Gm-Message-State: AOAM532wVEyawE7Q4Zr/RyWh220rVU2+13RvG4Ihl9yn3OXhtaqplzs3
        xGduZQlfzdC2Q92nBxttPuh87OgZHNE=
X-Google-Smtp-Source: ABdhPJzkQ+TPTNghaiyjopK2Q9UXHXirkFCk7bz7Y2wHOEucRILtEQweuapuUXRwLMTZlbJ4rzpjCo5gfvs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a25:1884:: with SMTP id 126mr25006798yby.114.1632269158936;
 Tue, 21 Sep 2021 17:05:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Sep 2021 17:05:24 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 07/16] perf: Add wrappers for invoking guest callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
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
index 3a7630fdd340..d20e4f8d1aef 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2761,11 +2761,10 @@ static bool perf_hw_regs(struct pt_regs *regs)
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
@@ -2865,11 +2864,10 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry_ctx *ent
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
@@ -2946,18 +2944,15 @@ static unsigned long code_segment_base(struct pt_regs *regs)
 
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
index 524ad1f747bd..f5b02017ba16 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2786,7 +2786,6 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-	struct perf_guest_info_callbacks *guest_cbs;
 	int bit;
 	int handled = 0;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
@@ -2853,9 +2852,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
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
index f9be88a47434..c0a6eaf55fb1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1247,6 +1247,30 @@ static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
 	/* Prevent reloading between a !NULL check and dereferences. */
 	return READ_ONCE(perf_guest_cbs);
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
2.33.0.464.g1972c5931b-goog

