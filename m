Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35915248FFA
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHRVQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgHRVQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA96C061345
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e3so12893664pgs.3
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R19BzMYRSuEHKthyTS8FM+rGStUvcHVWJOUP9Um9CJE=;
        b=tZG0SL3JJnaA4NvwDLBZKss6hBNxA+VE9puZHmiyvYdkRcmtz/DHX6vuAEoUqxnPGR
         73aF1S5bvgvmk2MxIaoOt/u82q/jILY+QZg+TMdQmkS/qkIaNcGNlbeFOJXbijDBIqKo
         x8VOHRrhreUuNukMm39aGj/aJeUfxLtNT8/c5QwxBPCrM/ffLyNa7B8i0TkOtdzhR3Oj
         133aNMXQ0GTqDtY5sk6GPRTySJoptWy4A3S4ISdXhIwHQ1eQURzg+CIqx7kOvcpXJ0X6
         c4SP6+abpiesv/G6vZp1rKc0ETIG8cF3PQ7fe3Psr98KlsoJM7yy/1iTXuw3Kdu6Yvhf
         D07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R19BzMYRSuEHKthyTS8FM+rGStUvcHVWJOUP9Um9CJE=;
        b=pMQdOn5owOUiVlpjATGzXK8zSvoMZSEL+ygnt08KEr4wbAtlEp/73j8+eR3myin6p5
         hpKqMasZ1mqqgBrlceZkP76sp3nVhsNyWmkuQPHzaeq0RcBNLLYqzAfWlFKGGYEa28sC
         mIa3pvKORH1rqwWhF8gjbjH4icxLIqlI/uD2t7qqOKiGh+CdBcxR3EZv5R5yoWzfhP8s
         FsWQXwxr/rS4k9IzDgIXfHNEghUyQW/CeTqTxUGyg6Z2N7b3uwjiIG9xX1FRoNAHS76L
         YKtWLnI5yH2KknFRaMKwLZAZ87L1ws0ub1SqU18o03Q5JQWTPuWDyGTWKrMkDSn8DmhP
         PtTw==
X-Gm-Message-State: AOAM531HTEycEhJxHcbQCohp8moGY+OtbG1MoT4HDc2UoODBHERdSmZ8
        J9AE2VpMd36L3IvF7g6lp8bMqJZx0tzxOwcq
X-Google-Smtp-Source: ABdhPJxr3iGoREDhtThNIQNedwZLH6ABfxOmgljqhtf9d0n6q8Z+eCf/oDbbR3IYif7REhz5Gt4keGupU+NU7YID
X-Received: by 2002:a63:920e:: with SMTP id o14mr11973285pgd.367.1597785388333;
 Tue, 18 Aug 2020 14:16:28 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:27 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 05/12] KVM: x86: Add support for exiting to userspace on
 rdmsr or wrmsr
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for exiting to userspace on a rdmsr or wrmsr instruction if
the MSR being read from or written to is in the user_exit_msrs list.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

v2 -> v3

  - Refactored commit based on Alexander Graf's changes in the first commit
    in this series.  Changes made were:
      - Updated member 'inject_gp' to 'error' based on struct msr in kvm_run.
      - Move flag 'vcpu->kvm->arch.user_space_msr_enabled' out of
        kvm_msr_user_space() to allow it to work with both methods that bounce
        to userspace (msr list and #GP fallback).  Updated caller functions
        to account for this change.
      - trace_kvm_msr has been moved up and combine with a previous call in
        complete_emulated_msr() based on the suggestion made by Alexander
        Graf <graf@amazon.com>.

---
 arch/x86/kvm/trace.h | 24 ++++++++++++++
 arch/x86/kvm/x86.c   | 76 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 90 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b66432b015d2..755610befbb5 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -367,6 +367,30 @@ TRACE_EVENT(kvm_msr,
 #define trace_kvm_msr_read_ex(ecx)         trace_kvm_msr(0, ecx, 0, true)
 #define trace_kvm_msr_write_ex(ecx, data)  trace_kvm_msr(1, ecx, data, true)
 
+TRACE_EVENT(kvm_userspace_msr,
+	TP_PROTO(bool is_write, u8 error, u32 index, u64 data),
+	TP_ARGS(is_write, error, index, data),
+
+	TP_STRUCT__entry(
+		__field(bool,	is_write)
+		__field(u8,	error)
+		__field(u32,	index)
+		__field(u64,	data)
+	),
+
+	TP_fast_assign(
+		__entry->is_write	= is_write;
+		__entry->error	= error;
+		__entry->index		= index;
+		__entry->data		= data;
+	),
+
+	TP_printk("userspace %s %x = 0x%llx, %s",
+		  __entry->is_write ? "wrmsr" : "rdmsr",
+		  __entry->index, __entry->data,
+		  __entry->error ? "error" : "no_error")
+);
+
 /*
  * Tracepoint for guest CR access.
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e349d51d5d65..b370b3f4b4f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -109,6 +109,8 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
 
+bool kvm_msr_user_exit(struct kvm *kvm, u32 index);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
@@ -1629,11 +1631,19 @@ EXPORT_SYMBOL_GPL(kvm_set_msr);
 
 static int complete_emulated_msr(struct kvm_vcpu *vcpu, bool is_read)
 {
-	if (vcpu->run->msr.error) {
+	u32 ecx = vcpu->run->msr.index;
+	u64 data = vcpu->run->msr.data;
+	u8 error = vcpu->run->msr.error;
+
+	trace_kvm_userspace_msr(!is_read, error, ecx, data);
+	trace_kvm_msr(!is_read, ecx, data, !!error);
+
+	if (error) {
 		kvm_inject_gp(vcpu, 0);
+		return 1;
 	} else if (is_read) {
-		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
-		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
+		kvm_rax_write(vcpu, (u32)data);
+		kvm_rdx_write(vcpu, data >> 32);
 	}
 
 	return kvm_skip_emulated_instruction(vcpu);
@@ -1653,9 +1663,6 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
 			      u32 exit_reason, u64 data,
 			      int (*completion)(struct kvm_vcpu *vcpu))
 {
-	if (!vcpu->kvm->arch.user_space_msr_enabled)
-		return 0;
-
 	vcpu->run->exit_reason = exit_reason;
 	vcpu->run->msr.error = 0;
 	vcpu->run->msr.pad[0] = 0;
@@ -1686,10 +1693,18 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 	u64 data;
 	int r;
 
+	if (kvm_msr_user_exit(vcpu->kvm, ecx)) {
+		kvm_get_msr_user_space(vcpu, ecx);
+		/* Bounce to user space */
+		return 0;
+	}
+
+
 	r = kvm_get_msr(vcpu, ecx, &data);
 
 	/* MSR read failed? See if we should ask user space */
-	if (r && kvm_get_msr_user_space(vcpu, ecx)) {
+	if (r && vcpu->kvm->arch.user_space_msr_enabled) {
+		kvm_get_msr_user_space(vcpu, ecx);
 		/* Bounce to user space */
 		return 0;
 	}
@@ -1715,10 +1730,17 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	u64 data = kvm_read_edx_eax(vcpu);
 	int r;
 
+	if (kvm_msr_user_exit(vcpu->kvm, ecx)) {
+		kvm_set_msr_user_space(vcpu, ecx, data);
+		/* Bounce to user space */
+		return 0;
+	}
+
 	r = kvm_set_msr(vcpu, ecx, data);
 
 	/* MSR write failed? See if we should ask user space */
-	if (r && kvm_set_msr_user_space(vcpu, ecx, data)) {
+	if (r && vcpu->kvm->arch.user_space_msr_enabled) {
+		kvm_set_msr_user_space(vcpu, ecx, data);
 		/* Bounce to user space */
 		return 0;
 	}
@@ -3606,6 +3628,25 @@ static int kvm_vm_ioctl_set_exit_msrs(struct kvm *kvm,
 	return 0;
 }
 
+bool kvm_msr_user_exit(struct kvm *kvm, u32 index)
+{
+	struct kvm_msr_list *exit_msrs;
+	int i;
+
+	exit_msrs = kvm->arch.user_exit_msrs;
+
+	if (!exit_msrs)
+		return false;
+
+	for (i = 0; i < exit_msrs->nmsrs; ++i) {
+		if (exit_msrs->indices[i] == index)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(kvm_msr_user_exit);
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
@@ -6640,9 +6681,16 @@ static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r;
 
+	if (kvm_msr_user_exit(vcpu->kvm, msr_index)) {
+		kvm_get_msr_user_space(vcpu, msr_index);
+		/* Bounce to user space */
+		return X86EMUL_IO_NEEDED;
+	}
+
 	r = kvm_get_msr(vcpu, msr_index, pdata);
 
-	if (r && kvm_get_msr_user_space(vcpu, msr_index)) {
+	if (r && vcpu->kvm->arch.user_space_msr_enabled) {
+		kvm_get_msr_user_space(vcpu, msr_index);
 		/* Bounce to user space */
 		return X86EMUL_IO_NEEDED;
 	}
@@ -6656,9 +6704,16 @@ static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r;
 
+	if (kvm_msr_user_exit(vcpu->kvm, msr_index)) {
+		kvm_set_msr_user_space(vcpu, msr_index, data);
+		/* Bounce to user space */
+		return X86EMUL_IO_NEEDED;
+	}
+
 	r = kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
 
-	if (r && kvm_set_msr_user_space(vcpu, msr_index, data)) {
+	if (r && vcpu->kvm->arch.user_space_msr_enabled) {
+		kvm_set_msr_user_space(vcpu, msr_index, data);
 		/* Bounce to user space */
 		return X86EMUL_IO_NEEDED;
 	}
@@ -11090,3 +11145,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_userspace_msr);
-- 
2.28.0.220.ged08abb693-goog

