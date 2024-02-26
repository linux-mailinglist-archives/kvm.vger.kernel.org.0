Return-Path: <kvm+bounces-9906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C7F867914
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A08E294382
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FCB13A879;
	Mon, 26 Feb 2024 14:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bt25SjoV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F8D13AA33;
	Mon, 26 Feb 2024 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958220; cv=none; b=CUrTDHyQPZ+LR01kJwDyblFPR2RvlSTScdKzS38wfXSv07nObiy26GMwAXgy2N/lnuoYJjKcBJlTxrfDuvXkAREDO5LXWnwbJoMHhF2A4hagDYrFtyB1ak12RwnWPaPjY7iZZ0xXlxyTQqPK5dja8AXchoNNUABcGdFm8Y6WGWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958220; c=relaxed/simple;
	bh=VFpQkf0DwaMmnSB2prKBrCNuNiYKSSA7i3bHq/5WTHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kcbo/votl7IOUP3ReU0V4I1af8f2yCHnXeNP0qLXGHAhJApi9Fi1iAa6k6gLzKuQbG0IYk8CRIrd9O1BaIPssxW941RknyPLWfHo8TaGG2U8Fxi2Npqr7kZiws1iwJLlzctof4iSpEoBFlLKAHP1zDNNufvDv+KA3vcvhOhzw98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bt25SjoV; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e53f3f1f82so216233b3a.2;
        Mon, 26 Feb 2024 06:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958218; x=1709563018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BcAOo2JYDa9YbLmrgou0VrWmz7Zj4ViKVXNN4Wof/Rw=;
        b=bt25SjoViGK+IvJiU9EifeZog6vpvDggZnoCDOoSBhkGIXkCVmpGgSU9m27XNqaRX0
         461rotuEdCbU6x1VGm20mpGo7++FeEa20w5Scq24ajj4rBGtfyLmLi21wu6nk7yfbjl9
         LS9dk7bzFVD+3kd3xrWOkBiK2F5shpe9ZhtZkHasS04G8yzJ6y01an9UCuDWGItq05sR
         2i/AtgiLZrATgZc0LPfkQs8lpNSQ4HK1ellZLVz7PfCrtq2XGisi2LmyuR6lgUHN4ibX
         DdbLoHU/pgDdBspiJP5U9lhGbOV4st+OBcbZ4wJLdDtxZQurA0VCp5G00u9ZPjwI3stD
         6oeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958218; x=1709563018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BcAOo2JYDa9YbLmrgou0VrWmz7Zj4ViKVXNN4Wof/Rw=;
        b=IeliWwrJp9dtiHTCQ+Cc4bQQUXsXdyrfr6Dp39ZProTdV+F+0l24Cj9KVvjtCHFIEp
         KmzHcZnAa988hV11TYbJ8gx8usiUgq3W4BK6nkbcnZ2aP1Rw4jU8nmSwR92Wt8AKkG41
         90bY70GQenmrluljmwIIi4sANIwm48MDRGxp8pkYtsWBtsC04ANZlTMHXhJz+AHA4Ku2
         9rqAu3DlDhn5Ix8Zn48qbW0FeseizmKVu1FVkx0S1bMP5LYjZc8qxs4NC+K15Va/33ez
         q8WYqkKCOUUCxpIFXeP2uZIOCa/4JXg6mxK5ylCv5eZyPaGX83UPNF6KoVYDkVDh9fME
         XL0g==
X-Forwarded-Encrypted: i=1; AJvYcCW/MIJQL2d+PnQ0vYBuuKx++FTkxMP0zXH/SyvFdV2h3yf7PcYMMshlfmNdfdHp+6Q3fEeBZZHvzOc+9ZxPPFeeAE8P
X-Gm-Message-State: AOJu0YwuJxaByjhWUzM+UNHkqLUhctCL+OW5Ps55NtUOLMIN8Db4+9oA
	Q9+6NBP5zok7wMKCtHRkpr1kMdqMjgeF6IOlNsQJZUBu2WqsKZpKmm+pbGuM
X-Google-Smtp-Source: AGHT+IGqZOMLFmNX0VMVhFOqOC3rTr2ifATiXER7sN1I6LWQ9jctmC5a0wu07Wfb4xHqxl9VB/CzYQ==
X-Received: by 2002:a05:6a20:2c92:b0:1a0:817d:80d with SMTP id g18-20020a056a202c9200b001a0817d080dmr4230103pzj.45.1708958218030;
        Mon, 26 Feb 2024 06:36:58 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id r23-20020a17090a941700b0029942a73eaesm4505516pjo.9.2024.02.26.06.36.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:57 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 43/73] KVM: x86/PVM: Enable direct switching
Date: Mon, 26 Feb 2024 22:36:00 +0800
Message-Id: <20240226143630.33643-44-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

To enable direct switching, certain necessary information needs to be
prepared in TSS for the switcher. Since only syscall and RETU hypercalls
are allowed for now, CPL switching-related information is needed before
VM enters. Additionally, after VM exit, the states in the hypervisor
should be updated if direct switching has occurred.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 87 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/pvm/pvm.h | 15 ++++++++
 2 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 6ac599587567..138d0c255cb8 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -559,23 +559,70 @@ static void pvm_flush_hwtlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 	put_cpu();
 }
 
+static bool check_switch_cr3(struct vcpu_pvm *pvm, u64 switch_host_cr3)
+{
+	u64 root = pvm->vcpu.arch.mmu->prev_roots[0].hpa;
+
+	if (pvm->vcpu.arch.mmu->prev_roots[0].pgd != pvm->msr_switch_cr3)
+		return false;
+	if (!VALID_PAGE(root))
+		return false;
+	if (host_pcid_owner(switch_host_cr3 & X86_CR3_PCID_MASK) != pvm)
+		return false;
+	if (host_pcid_root(switch_host_cr3 & X86_CR3_PCID_MASK) != root)
+		return false;
+	if (root != (switch_host_cr3 & CR3_ADDR_MASK))
+		return false;
+
+	return true;
+}
+
 static void pvm_set_host_cr3_for_guest_with_host_pcid(struct vcpu_pvm *pvm)
 {
 	u64 root_hpa = pvm->vcpu.arch.mmu->root.hpa;
 	bool flush = false;
 	u32 host_pcid = host_pcid_get(pvm, root_hpa, &flush);
 	u64 hw_cr3 = root_hpa | host_pcid;
+	u64 switch_host_cr3;
 
 	if (!flush)
 		hw_cr3 |= CR3_NOFLUSH;
 	this_cpu_write(cpu_tss_rw.tss_ex.enter_cr3, hw_cr3);
+
+	if (is_smod(pvm)) {
+		this_cpu_write(cpu_tss_rw.tss_ex.smod_cr3, hw_cr3 | CR3_NOFLUSH);
+		switch_host_cr3 = this_cpu_read(cpu_tss_rw.tss_ex.umod_cr3);
+	} else {
+		this_cpu_write(cpu_tss_rw.tss_ex.umod_cr3, hw_cr3 | CR3_NOFLUSH);
+		switch_host_cr3 = this_cpu_read(cpu_tss_rw.tss_ex.smod_cr3);
+	}
+
+	if (check_switch_cr3(pvm, switch_host_cr3))
+		pvm->switch_flags &= ~SWITCH_FLAGS_NO_DS_CR3;
+	else
+		pvm->switch_flags |= SWITCH_FLAGS_NO_DS_CR3;
 }
 
 static void pvm_set_host_cr3_for_guest_without_host_pcid(struct vcpu_pvm *pvm)
 {
 	u64 root_hpa = pvm->vcpu.arch.mmu->root.hpa;
+	u64 switch_root = 0;
+
+	if (pvm->vcpu.arch.mmu->prev_roots[0].pgd == pvm->msr_switch_cr3) {
+		switch_root = pvm->vcpu.arch.mmu->prev_roots[0].hpa;
+		pvm->switch_flags &= ~SWITCH_FLAGS_NO_DS_CR3;
+	} else {
+		pvm->switch_flags |= SWITCH_FLAGS_NO_DS_CR3;
+	}
 
 	this_cpu_write(cpu_tss_rw.tss_ex.enter_cr3, root_hpa);
+	if (is_smod(pvm)) {
+		this_cpu_write(cpu_tss_rw.tss_ex.smod_cr3, root_hpa);
+		this_cpu_write(cpu_tss_rw.tss_ex.umod_cr3, switch_root);
+	} else {
+		this_cpu_write(cpu_tss_rw.tss_ex.umod_cr3, root_hpa);
+		this_cpu_write(cpu_tss_rw.tss_ex.smod_cr3, switch_root);
+	}
 }
 
 static void pvm_set_host_cr3_for_hypervisor(struct vcpu_pvm *pvm)
@@ -591,6 +638,8 @@ static void pvm_set_host_cr3_for_hypervisor(struct vcpu_pvm *pvm)
 
 // Set tss_ex.host_cr3 for VMExit.
 // Set tss_ex.enter_cr3 for VMEnter.
+// Set tss_ex.smod_cr3 and tss_ex.umod_cr3 and set or clear
+// SWITCH_FLAGS_NO_DS_CR3 for direct switching.
 static void pvm_set_host_cr3(struct vcpu_pvm *pvm)
 {
 	pvm_set_host_cr3_for_hypervisor(pvm);
@@ -1058,6 +1107,11 @@ static bool pvm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 
 static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
+	/* disable direct switch when single step debugging */
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		to_pvm(vcpu)->switch_flags |= SWITCH_FLAGS_SINGLE_STEP;
+	else
+		to_pvm(vcpu)->switch_flags &= ~SWITCH_FLAGS_SINGLE_STEP;
 }
 
 static struct pvm_vcpu_struct *pvm_get_vcpu_struct(struct vcpu_pvm *pvm)
@@ -1288,10 +1342,12 @@ static void pvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	if (!need_update || !is_smod(pvm))
 		return;
 
-	if (rflags & X86_EFLAGS_IF)
+	if (rflags & X86_EFLAGS_IF) {
+		pvm->switch_flags &= ~SWITCH_FLAGS_IRQ_WIN;
 		pvm_event_flags_update(vcpu, X86_EFLAGS_IF, PVM_EVENT_FLAGS_IP);
-	else
+	} else {
 		pvm_event_flags_update(vcpu, 0, X86_EFLAGS_IF);
+	}
 }
 
 static bool pvm_get_if_flag(struct kvm_vcpu *vcpu)
@@ -1311,6 +1367,7 @@ static void pvm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
+	to_pvm(vcpu)->switch_flags |= SWITCH_FLAGS_IRQ_WIN;
 	pvm_event_flags_update(vcpu, PVM_EVENT_FLAGS_IP, 0);
 }
 
@@ -1332,6 +1389,7 @@ static void pvm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
 static void enable_nmi_window(struct kvm_vcpu *vcpu)
 {
+	to_pvm(vcpu)->switch_flags |= SWITCH_FLAGS_NMI_WIN;
 }
 
 static int pvm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
@@ -1361,6 +1419,8 @@ static void pvm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 
 	trace_kvm_inj_virq(irq, vcpu->arch.interrupt.soft, false);
 
+	to_pvm(vcpu)->switch_flags &= ~SWITCH_FLAGS_IRQ_WIN;
+
 	if (do_pvm_event(vcpu, irq, false, 0))
 		kvm_clear_interrupt_queue(vcpu);
 
@@ -1397,6 +1457,7 @@ static int handle_synthetic_instruction_return_user(struct kvm_vcpu *vcpu)
 
 	// instruction to return user means nmi allowed.
 	pvm->nmi_mask = false;
+	pvm->switch_flags &= ~(SWITCH_FLAGS_IRQ_WIN | SWITCH_FLAGS_NMI_WIN);
 
 	/*
 	 * switch to user mode before kvm_set_rflags() to avoid PVM_EVENT_FLAGS_IF
@@ -1448,6 +1509,7 @@ static int handle_synthetic_instruction_return_supervisor(struct kvm_vcpu *vcpu)
 
 	// instruction to return supervisor means nmi allowed.
 	pvm->nmi_mask = false;
+	pvm->switch_flags &= ~SWITCH_FLAGS_NMI_WIN;
 
 	kvm_set_rflags(vcpu, frame.rflags);
 	kvm_rip_write(vcpu, frame.rip);
@@ -1461,6 +1523,7 @@ static int handle_synthetic_instruction_return_supervisor(struct kvm_vcpu *vcpu)
 static int handle_hc_interrupt_window(struct kvm_vcpu *vcpu)
 {
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
+	to_pvm(vcpu)->switch_flags &= ~SWITCH_FLAGS_IRQ_WIN;
 	pvm_event_flags_update(vcpu, 0, PVM_EVENT_FLAGS_IP);
 
 	++vcpu->stat.irq_window_exits;
@@ -2199,6 +2262,7 @@ static __always_inline void load_regs(struct kvm_vcpu *vcpu, struct pt_regs *gue
 
 static noinstr void pvm_vcpu_run_noinstr(struct kvm_vcpu *vcpu)
 {
+	struct tss_extra *tss_ex = this_cpu_ptr(&cpu_tss_rw.tss_ex);
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 	struct pt_regs *sp0_regs = (struct pt_regs *)this_cpu_read(cpu_tss_rw.x86_tss.sp0) - 1;
 	struct pt_regs *ret_regs;
@@ -2208,12 +2272,25 @@ static noinstr void pvm_vcpu_run_noinstr(struct kvm_vcpu *vcpu)
 	// Load guest registers into the host sp0 stack for switcher.
 	load_regs(vcpu, sp0_regs);
 
+	// Prepare context for direct switching.
+	tss_ex->switch_flags = pvm->switch_flags;
+	tss_ex->pvcs = pvm->pvcs_gpc.khva;
+	tss_ex->retu_rip = pvm->msr_retu_rip_plus2;
+	tss_ex->smod_entry = pvm->msr_lstar;
+	tss_ex->smod_gsbase = pvm->msr_kernel_gs_base;
+	tss_ex->smod_rsp = pvm->msr_supervisor_rsp;
+
 	if (unlikely(pvm->guest_dr7 & DR7_BP_EN_MASK))
 		set_debugreg(pvm_eff_dr7(vcpu), 7);
 
 	// Call into switcher and enter guest.
 	ret_regs = switcher_enter_guest();
 
+	// Get the resulted mode and PVM MSRs which might be changed
+	// when direct switching.
+	pvm->switch_flags = tss_ex->switch_flags;
+	pvm->msr_supervisor_rsp = tss_ex->smod_rsp;
+
 	// Get the guest registers from the host sp0 stack.
 	save_regs(vcpu, ret_regs);
 	pvm->exit_vector = (ret_regs->orig_ax >> 32);
@@ -2293,6 +2370,7 @@ static inline void pvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 static fastpath_t pvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	bool is_smod_befor_run = is_smod(pvm);
 
 	trace_kvm_entry(vcpu);
 
@@ -2307,6 +2385,11 @@ static fastpath_t pvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pvm_vcpu_run_noinstr(vcpu);
 
+	if (is_smod_befor_run != is_smod(pvm)) {
+		swap(pvm->vcpu.arch.mmu->root, pvm->vcpu.arch.mmu->prev_roots[0]);
+		swap(pvm->msr_switch_cr3, pvm->vcpu.arch.cr3);
+	}
+
 	/* MSR_IA32_DEBUGCTLMSR is zeroed before vmenter. Restore it if needed */
 	if (pvm->host_debugctlmsr)
 		update_debugctlmsr(pvm->host_debugctlmsr);
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 2f8fdb0ae3df..e49d9dc70a94 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -5,6 +5,21 @@
 #include <linux/kvm_host.h>
 #include <asm/switcher.h>
 
+/*
+ * Extra switch flags:
+ *
+ * IRQ_WIN:
+ *	There is an irq window request, and the vcpu should not directly
+ *	switch to context with IRQ enabled, e.g. user mode.
+ * NMI_WIN:
+ *	There is an NMI window request.
+ * SINGLE_STEP:
+ *	KVM_GUESTDBG_SINGLESTEP is set.
+ */
+#define SWITCH_FLAGS_IRQ_WIN				_BITULL(8)
+#define SWITCH_FLAGS_NMI_WIN				_BITULL(9)
+#define SWITCH_FLAGS_SINGLE_STEP			_BITULL(10)
+
 #define SWITCH_FLAGS_INIT	(SWITCH_FLAGS_SMOD)
 
 #define PVM_SYSCALL_VECTOR		SWITCH_EXIT_REASONS_SYSCALL
-- 
2.19.1.6.gb485710b


