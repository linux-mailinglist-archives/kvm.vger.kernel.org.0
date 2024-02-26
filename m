Return-Path: <kvm+bounces-9889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB998678E5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:46:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9CF129741A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8CA134758;
	Mon, 26 Feb 2024 14:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6p4Q+mZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B0813473A;
	Mon, 26 Feb 2024 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958165; cv=none; b=lzn4umsIadNO7aKnPcRd0+cQP+DF0vBVBwDS/OEBCo8gLfE01FFWbdxR6h3vjv3XOKj0XKzJOVqcJUVO7s0rrZLGnW6tKjNbSxFrDMZQ49HUtJU/VV4wAPfEj1LgG84zXm70mOv0e2WFE6N1KEHmfFsoD2vkybOamJ+nLq383no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958165; c=relaxed/simple;
	bh=GvKuyzIXR8Z+/z01d0kpMrMpoQCTeikvWweEMnbCC3c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hEuzCz+7djtYFkCaATzr4v8dOYQXhTfXARburo09nIhyYFLwZ17z2zpuNM4R6hJpnuY1unVSaUnkYoKTA+1wDkg318DqxlxZk1dH/96Bo4WdtI+y4REZmK/NZVSDAKzBsOjkQT5U2keMczRsCn5kno2G0rDbKzlhTxnZlrkH8bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6p4Q+mZ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso827300b3a.2;
        Mon, 26 Feb 2024 06:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958163; x=1709562963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJusf0G+J7FIR2mDyw6helWrSCNLVt7nNkO4Npqtj9I=;
        b=C6p4Q+mZKJux803GwexgBYojTakuXgdvK1fHukRcBxJO6fjpphXLZhMk5IZ8d1HMGz
         dzlyw4oQq9i6cxHbiRhwFgR8Z2tbtU8KD1SJL1TqB2NCQcgjx2wxnvnIyLEje+/RdOTx
         ysZ0yJmA8HIhb8G/jVKgHRzTc0gkMOJ8ZRjEvSNmfqM5O9OUr9bitkZDgJ27AhfGgHHA
         mBJBBHEDdt6LkjcD7kezA/Cb+tfDSQ2cr+LOimiUQFzl+Or36O+X4ne9POnyL+ROsY8i
         oV/81zirOqSfxrqU54XRhtr0Hp+EG4MBXjKWQ2uILvGHyoodvm0AWaTd84/Cv+0R0AA6
         GDmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958163; x=1709562963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vJusf0G+J7FIR2mDyw6helWrSCNLVt7nNkO4Npqtj9I=;
        b=YGUavYt3oZ1b84KhZDG7h7BihDsFxKjqudgcTgCERqHXw6cSvLyO13Sg8Bdcg71gnF
         /r9lbrarcssPJwT/ahop/OzoHsBKgk137H6rMzIawKmDW+opFuZmaqNcXFp+7OSYhZ7u
         1fY3t4NRw7JHRzn7qAVfvLFmUJ6wT/0g3Inb2vrwNvzkPfZxlcNQPmotxl92pB6uxEtp
         U20sl1rwiNAcANHRU7uwWon13EqAxxzx5cM5IYHyAsZUdIwC3T0m1JPrvdhWYdxN12m+
         L0ZpF3ofiqw0fqR9Tp4f2vD0hufolXEA2euxi8zAfaj+jjtCEC5d0C6s3VtSI6scYBIg
         1ucg==
X-Forwarded-Encrypted: i=1; AJvYcCU3YHIQV5qyCGdz03jGU0N0yYzqWKZUR1LXckzRcKmMjKDm2nMULbY3EYlB5yYWnA/SKa36ljL/FWtvjD9KwfJ/th4d
X-Gm-Message-State: AOJu0YxIZwL/BZTD3eBVKQUXOmQnXxTuAnsdYVWqGg/dpSe3CHQFAVyB
	TlMO7nzEU/fGLd0UwvadBXDAaQEoVQRbMFo4AUOJnV7spHUgWiHRbpmdav4o
X-Google-Smtp-Source: AGHT+IFeyLPYxLRIy1QEiRGWhhp6uPa9NhvEDD1L7H4AyNsB2/niLfYoI2fl6kZLiyl21iMCZldL0Q==
X-Received: by 2002:a17:902:f709:b0:1dc:a8aa:3c80 with SMTP id h9-20020a170902f70900b001dca8aa3c80mr2062639plo.43.1708958162915;
        Mon, 26 Feb 2024 06:36:02 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902d3c500b001dc2d1bd4d6sm4055885plb.77.2024.02.26.06.36.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:02 -0800 (PST)
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
Subject: [RFC PATCH 26/73] KVM: x86/PVM: Implement event delivery flags related callbacks
Date: Mon, 26 Feb 2024 22:35:43 +0800
Message-Id: <20240226143630.33643-27-jiangshanlai@gmail.com>
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

To reduce the number of VM exits for modifying the X86_EFLAGS_IF bit in
guest suprvisor mode, a shared structure is used between the guest and
hypervisor in PVM. This structure is stored in the guest memory. In this
way, the guest supervisor can change its X86_EFLAGS_IF bit without
causing a VM exit, as long as there is no IRQ window request. After a VM
exit occurs, the hypervisor updates the guest's X86_EFLAGS_IF bit from
the shared structure.

Since the SRET/URET synthetic instruction always induces a VM exit,
there is nothing to do in the enable_nmi_window() callback.
Additionally, SMM mode is not supported now.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 194 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 194 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index ce047d211657..3d2a3c472664 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -585,6 +585,143 @@ static bool pvm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static struct pvm_vcpu_struct *pvm_get_vcpu_struct(struct vcpu_pvm *pvm)
+{
+	struct gfn_to_pfn_cache *gpc = &pvm->pvcs_gpc;
+
+	read_lock_irq(&gpc->lock);
+	while (!kvm_gpc_check(gpc, PAGE_SIZE)) {
+		read_unlock_irq(&gpc->lock);
+
+		if (kvm_gpc_refresh(gpc, PAGE_SIZE))
+			return NULL;
+
+		read_lock_irq(&gpc->lock);
+	}
+
+	return (struct pvm_vcpu_struct *)(gpc->khva);
+}
+
+static void pvm_put_vcpu_struct(struct vcpu_pvm *pvm, bool dirty)
+{
+	struct gfn_to_pfn_cache *gpc = &pvm->pvcs_gpc;
+
+	read_unlock_irq(&gpc->lock);
+	if (dirty)
+		mark_page_dirty_in_slot(pvm->vcpu.kvm, gpc->memslot,
+					gpc->gpa >> PAGE_SHIFT);
+}
+
+static void pvm_vcpu_gpc_refresh(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	struct gfn_to_pfn_cache *gpc = &pvm->pvcs_gpc;
+
+	if (!gpc->active)
+		return;
+
+	if (pvm_get_vcpu_struct(pvm))
+		pvm_put_vcpu_struct(pvm, false);
+	else
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+}
+
+static void pvm_event_flags_update(struct kvm_vcpu *vcpu, unsigned long set,
+				   unsigned long clear)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	static struct pvm_vcpu_struct *pvcs;
+	unsigned long old_flags, new_flags;
+
+	if (!pvm->msr_vcpu_struct)
+		return;
+
+	pvcs = pvm_get_vcpu_struct(pvm);
+	if (!pvcs)
+		return;
+
+	old_flags = pvcs->event_flags;
+	new_flags = (old_flags | set) & ~clear;
+	if (new_flags != old_flags)
+		pvcs->event_flags = new_flags;
+
+	pvm_put_vcpu_struct(pvm, new_flags != old_flags);
+}
+
+static unsigned long pvm_get_rflags(struct kvm_vcpu *vcpu)
+{
+	return to_pvm(vcpu)->rflags;
+}
+
+static void pvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	int need_update = !!((pvm->rflags ^ rflags) & X86_EFLAGS_IF);
+
+	pvm->rflags = rflags;
+
+	/*
+	 * The IF bit of 'pvcs->event_flags' should not be changed in user
+	 * mode. It is recommended for this bit to be cleared when switching to
+	 * user mode, so that when the guest switches back to supervisor mode,
+	 * the X86_EFLAGS_IF is already cleared.
+	 */
+	if (!need_update || !is_smod(pvm))
+		return;
+
+	if (rflags & X86_EFLAGS_IF)
+		pvm_event_flags_update(vcpu, X86_EFLAGS_IF, PVM_EVENT_FLAGS_IP);
+	else
+		pvm_event_flags_update(vcpu, 0, X86_EFLAGS_IF);
+}
+
+static bool pvm_get_if_flag(struct kvm_vcpu *vcpu)
+{
+	return pvm_get_rflags(vcpu) & X86_EFLAGS_IF;
+}
+
+static u32 pvm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
+	return to_pvm(vcpu)->int_shadow;
+}
+
+static void pvm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	/* PVM spec: ignore interrupt shadow when in PVM mode. */
+}
+
+static void enable_irq_window(struct kvm_vcpu *vcpu)
+{
+	pvm_event_flags_update(vcpu, PVM_EVENT_FLAGS_IP, 0);
+}
+
+static int pvm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	return (pvm_get_rflags(vcpu) & X86_EFLAGS_IF) &&
+		!to_pvm(vcpu)->int_shadow;
+}
+
+static bool pvm_get_nmi_mask(struct kvm_vcpu *vcpu)
+{
+	return to_pvm(vcpu)->nmi_mask;
+}
+
+static void pvm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
+{
+	to_pvm(vcpu)->nmi_mask = masked;
+}
+
+static void enable_nmi_window(struct kvm_vcpu *vcpu)
+{
+}
+
+static int pvm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	return !pvm->nmi_mask && !pvm->int_shadow;
+}
+
 static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
@@ -826,12 +963,29 @@ static fastpath_t pvm_vcpu_run(struct kvm_vcpu *vcpu)
 	pvm_vcpu_run_noinstr(vcpu);
 
 	if (is_smod(pvm)) {
+		struct pvm_vcpu_struct *pvcs = pvm->pvcs_gpc.khva;
+
+		/*
+		 * Load the X86_EFLAGS_IF bit from PVCS. In user mode, the
+		 * Interrupt Flag is considered to be set and cannot be
+		 * changed. Since it is already set in 'pvm->rflags', so
+		 * nothing to do. In supervisor mode, the Interrupt Flag is
+		 * reflected in 'pvcs->event_flags' and can be changed
+		 * directly without triggering a VM exit.
+		 */
+		pvm->rflags &= ~X86_EFLAGS_IF;
+		if (likely(pvm->msr_vcpu_struct))
+			pvm->rflags |= X86_EFLAGS_IF & pvcs->event_flags;
+
 		if (pvm->hw_cs != __USER_CS || pvm->hw_ss != __USER_DS)
 			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}
 
 	pvm_load_host_xsave_state(vcpu);
 
+	mark_page_dirty_in_slot(vcpu->kvm, pvm->pvcs_gpc.memslot,
+				pvm->pvcs_gpc.gpa >> PAGE_SHIFT);
+
 	return EXIT_FASTPATH_NONE;
 }
 
@@ -965,6 +1119,27 @@ static int pvm_check_processor_compat(void)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_SMM
+static int pvm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	return 0;
+}
+
+static int pvm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
+{
+	return 0;
+}
+
+static int pvm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
+{
+	return 0;
+}
+
+static void enable_smi_window(struct kvm_vcpu *vcpu)
+{
+}
+#endif
+
 /*
  * When in PVM mode, the hardware MSR_LSTAR is set to the entry point
  * provided by the host entry code (switcher), and the
@@ -1098,10 +1273,21 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.set_msr = pvm_set_msr,
 	.get_cpl = pvm_get_cpl,
 	.load_mmu_pgd = pvm_load_mmu_pgd,
+	.get_rflags = pvm_get_rflags,
+	.set_rflags = pvm_set_rflags,
+	.get_if_flag = pvm_get_if_flag,
 
 	.vcpu_pre_run = pvm_vcpu_pre_run,
 	.vcpu_run = pvm_vcpu_run,
 	.handle_exit = pvm_handle_exit,
+	.set_interrupt_shadow = pvm_set_interrupt_shadow,
+	.get_interrupt_shadow = pvm_get_interrupt_shadow,
+	.interrupt_allowed = pvm_interrupt_allowed,
+	.nmi_allowed = pvm_nmi_allowed,
+	.get_nmi_mask = pvm_get_nmi_mask,
+	.set_nmi_mask = pvm_set_nmi_mask,
+	.enable_nmi_window = enable_nmi_window,
+	.enable_irq_window = enable_irq_window,
 	.refresh_apicv_exec_ctrl = pvm_refresh_apicv_exec_ctrl,
 	.deliver_interrupt = pvm_deliver_interrupt,
 
@@ -1117,10 +1303,18 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 
 	.setup_mce = pvm_setup_mce,
 
+#ifdef CONFIG_KVM_SMM
+	.smi_allowed = pvm_smi_allowed,
+	.enter_smm = pvm_enter_smm,
+	.leave_smm = pvm_leave_smm,
+	.enable_smi_window = enable_smi_window,
+#endif
+
 	.apic_init_signal_blocked = pvm_apic_init_signal_blocked,
 	.msr_filter_changed = pvm_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+	.vcpu_gpc_refresh = pvm_vcpu_gpc_refresh,
 };
 
 static struct kvm_x86_init_ops pvm_init_ops __initdata = {
-- 
2.19.1.6.gb485710b


