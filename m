Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967093F91C2
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 03:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243970AbhH0BAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 21:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244138AbhH0A7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150C8C061149
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:58:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z6-20020a257e06000000b0059bad6decfbso4888601ybc.16
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5wQJhGi+ZyGOAOMPxE71g3TXDJHEcKM3NH5k2IjIokU=;
        b=OW6tj0qrfqLnmyAG7bwsLD1ivWUlSQB5/rmjy7WLw347oAMVCG3/Qk7isJlZCVSFFV
         W7vIlgUdwAlJx2kpTZ9A55Gu92o/DT6okHoyWj++aIqZDyTZVtHibehQi7O2j3MjMThX
         Eos5GY/kAJpzkfPs9z5NTcHHEpUm/XVAQpx4rHw8kLZUkO7HNuZJLNnlhhsXFJlEJkCy
         p6hhGZMhQP2aZtmOVXw5yZNFRx/aQuH9Vj4YrQddHKnPUiY2qaww7D6c/XyLTUmGdHj3
         smqjImdUUuenQzBvxAy/5tpxtN+1AQqndlIihp99we7A59b3jtdrbJnHyTatubIFGc7+
         +UOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5wQJhGi+ZyGOAOMPxE71g3TXDJHEcKM3NH5k2IjIokU=;
        b=nBLD9TCJEP+4+y3RK7q8Pd0KaHegoyIvXHVEDOJx7eMlOKW446xsmEUgcAU5P+AnoH
         K/pqLuMiKrXCq5aWO/abZgAmDsrvs3xkkXzuRGc9UREdhEwxJRWN1tVktN2AmtXVlaQO
         bwcgi9uAxBXP01KnKEwrhOOyULwaUn0dPAXzU8L02JjaDB+n6dYsFhQipSVBMoueybZ5
         VdTyFfj0eM5Nbn7ZtmgLTBmAyaX+ii4EYIvsAHl9JI65Lb06UniKTybgFxk2h1jRDh39
         ohpfcqlTVHHsQD5TnNBnqMzS9IcbYaqnMpZBhQOgfsjsYNxSL6cPCa3Io6HM2/6Tsl7N
         y2kQ==
X-Gm-Message-State: AOAM530mB1NrsLuOz29KzbK3HTQrLzWSQ+X0zAPqoen32z7T5regRUFw
        woPkdB1sVIyRE5YASVLZSFOA6sdyf34=
X-Google-Smtp-Source: ABdhPJxNS9FKdHggEYyf3FZBaeUKCfIfMsPYcyI+FugrK+/XdFcM7Qj6lsB8B0S5DygYRKG5HNpbYwSWz/0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:ea51:: with SMTP id o17mr1969948ybe.253.1630025883284;
 Thu, 26 Aug 2021 17:58:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 Aug 2021 17:57:18 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 15/15] perf: KVM: Indicate "in guest" via NULL ->is_in_guest callback
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
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
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interpret a null ->is_in_guest callback as meaning "in guest" and use
the new semantics in KVM, which currently returns 'true' unconditionally
in its implementation of ->is_in_guest().  This avoids a retpoline on
the indirect call for PMIs that arrive in a KVM guest, and also provides
a handy excuse for a wrapper around retrieval of perf_get_guest_cbs,
e.g. to reduce the probability of an errant direct read of perf_guest_cbs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/core.c       | 16 ++++++++--------
 arch/x86/events/intel/core.c |  5 ++---
 include/linux/perf_event.h   | 17 +++++++++++++++++
 virt/kvm/kvm_main.c          |  9 ++-------
 4 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 34155a52e498..b60c339ae06b 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2761,11 +2761,11 @@ static bool perf_hw_regs(struct pt_regs *regs)
 void
 perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct unwind_state state;
 	unsigned long addr;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2865,11 +2865,11 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry_ctx *ent
 void
 perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	struct stack_frame frame;
 	const struct stack_frame __user *fp;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs) {
 		/* TODO: We don't support guest os callchain now */
 		return;
 	}
@@ -2946,9 +2946,9 @@ static unsigned long code_segment_base(struct pt_regs *regs)
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 
-	if (guest_cbs && guest_cbs->is_in_guest())
+	if (guest_cbs)
 		return guest_cbs->get_guest_ip();
 
 	return regs->ip + code_segment_base(regs);
@@ -2956,10 +2956,10 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
-	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
+	struct perf_guest_info_callbacks *guest_cbs = perf_get_guest_cbs();
 	int misc = 0;
 
-	if (guest_cbs && guest_cbs->is_in_guest()) {
+	if (guest_cbs) {
 		if (guest_cbs->is_user_mode())
 			misc |= PERF_RECORD_MISC_GUEST_USER;
 		else
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 96001962c24d..9a8c18b51a96 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2853,9 +2853,8 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 */
 	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
 		handled++;
-		guest_cbs = this_cpu_read(perf_guest_cbs);
-		if (unlikely(guest_cbs && guest_cbs->is_in_guest() &&
-			     guest_cbs->handle_intel_pt_intr))
+		guest_cbs = perf_get_guest_cbs();
+		if (unlikely(guest_cbs && guest_cbs->handle_intel_pt_intr))
 			guest_cbs->handle_intel_pt_intr();
 		else
 			intel_pt_interrupt();
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index db701409a62f..6e3a10784d24 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1241,6 +1241,23 @@ DECLARE_PER_CPU(struct perf_guest_info_callbacks *, perf_guest_cbs);
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
 extern void perf_unregister_guest_info_callbacks(void);
 extern void perf_register_guest_info_callbacks_all_cpus(struct perf_guest_info_callbacks *cbs);
+/*
+ * Returns guest callbacks for the current CPU if callbacks are registered and
+ * the PMI fired while a guest was running, otherwise returns NULL.
+ */
+static inline struct perf_guest_info_callbacks *perf_get_guest_cbs(void)
+{
+	struct perf_guest_info_callbacks *guest_cbs = this_cpu_read(perf_guest_cbs);
+
+	/*
+	 * Implementing is_in_guest is optional if the callbacks are registered
+	 * only when "in guest".
+	 */
+	if (guest_cbs && (!guest_cbs->is_in_guest || guest_cbs->is_in_guest()))
+		return guest_cbs;
+
+	return NULL;
+}
 #endif /* CONFIG_HAVE_GUEST_PERF_EVENTS */
 
 extern void perf_event_exec(void);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1bcc3eab510b..fa83d3846785 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5461,12 +5461,6 @@ struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
 }
 
 #ifdef __KVM_WANT_PERF_CALLBACKS
-static int kvm_is_in_guest(void)
-{
-	/* Registration of KVM's callback signifies "in guest". */
-	return true;
-}
-
 static int kvm_is_user_mode(void)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
@@ -5488,7 +5482,8 @@ static unsigned long kvm_get_guest_ip(void)
 }
 
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
-	.is_in_guest		= kvm_is_in_guest,
+	/* Registration of KVM's callback signifies "in guest". */
+	.is_in_guest		= NULL,
 	.is_user_mode		= kvm_is_user_mode,
 	.get_guest_ip		= kvm_get_guest_ip,
 	.handle_intel_pt_intr	= NULL,
-- 
2.33.0.259.gc128427fd7-goog

