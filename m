Return-Path: <kvm+bounces-9884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA578678DD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44C85295935
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2F4132C1A;
	Mon, 26 Feb 2024 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYel0VYC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADFA132C04;
	Mon, 26 Feb 2024 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958149; cv=none; b=IwO2Pr2iLi7KiUD4WLOZJ5Vs4p8rhOuVldAnMKdQrSyMdNu6ZJ0vTyFsrabe1ubpoO/eRRgXtXBdkbwmQdIjCaP595QDy+HoBFq/TYmSeW0MbcMX1S/2ItgSoRE/5uxYfOeGDlSdOch+9vklx48lGLUpjJ4GV7JFg5MCNybCDmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958149; c=relaxed/simple;
	bh=/iStsMPT4BDfLBz8g+O9phpKKibaGHh4l64BGMMKED0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AYxxhOnmrG1LfM/eQPmpp6M/NjPjPEzxpq+Q4r5v5OYGsbF5K1s48BbnSMM+jVTTsqBmjWxAsXn9iHP112FUa7KO+XewQEHBfNihjtMSOa5ODBqsRVzE7eh71QsT6gQCPYCF/Et/RgAClE7j5wG5e4XDAC59sx0L26XRt6R6Z4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VYel0VYC; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dcab44747bso5025345ad.1;
        Mon, 26 Feb 2024 06:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958147; x=1709562947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSD5Tv+fh0uCAiCRBZiaWK9rSl9cDRTDnFCz1andQQ0=;
        b=VYel0VYCTnyZqsmF/Dq6MJ2p4BQNRST4gusUrpfILuC3zjMwge3YMMlSpEyToJiS8J
         LzIZPq9qo6e+xz+43RV0APkoAsa1+dDDwYznYV4/s+WBktF6y/qgX++1iyTrrzzf92mO
         pbQz5+xhxOB7nePFKyhQtj6v5q31DKJfd7BZ3qck3nMcw39+CcudajIU4DbKKyWsLe2g
         KHQmiMq70F6uxFk1U+13PEYdhkmj7myu/4ogEgX1vzGBU79TcaEAHA32SNtTa7rG7NpC
         dOQ3KreDKYQDxdaJ0uX5DgfHYBD7WKwLzDRQurvlUb7GmvLvv2K38ogBn5/78ytj6GRn
         zQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958147; x=1709562947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSD5Tv+fh0uCAiCRBZiaWK9rSl9cDRTDnFCz1andQQ0=;
        b=TrrzPi/enwXI7w9FV6S/2ldXZO5etqPidhXmKKwCb+uDw3ZSuB396T8TpN7IjRjXOk
         d5nk79e/MXi2tFrSyiBsD4efKkZfEbSa1lmaVLnODXVhTY3CVntZJQ3bXwJZTJqrOAyM
         rSsofA0M2SmSA5GzxlduGFgl5jXGakZjH1WWmZmAOqKrabwUMKjf5kxUvMvun9TGlXp6
         WdTkWy8CmtiVgUOdIyh+5Skr3rBZpRgQccXvxGcYjvHAK4wceiKL56APwNoLrB0iqMiM
         Jn6UPPXjL4cKUrv6Uup5d4I6XfNfbLTj+qMxhuA5B2zMg4gMXWMe7BHve/LPayX3knrY
         MsmA==
X-Forwarded-Encrypted: i=1; AJvYcCWKYWUTLIpBY849Huw8ka2ks85Fze3YAmRqylC2X50yleXpVCxa8k+BBlkJZbyA6Ce8FIxNE9Zlqh7fZhRMPyoLgf2R
X-Gm-Message-State: AOJu0YxXyt+m6eXs/lW2LCkyba0KSWVnVrK7PtrKxde8bRDq7cqpYsz8
	BOq73oZHcmonZcxiCSMuzrIFhj6FTFDb3QoI/YqgdWszVAa6rRqiB2d3rl+d
X-Google-Smtp-Source: AGHT+IFnewZt5yMH7itPjcpNv8Fc95fBWDAtqKcOadkb4c2kyLSm/1eqDZ70yzfd19RUKJP1Pr9OYA==
X-Received: by 2002:a17:902:6504:b0:1dc:4a8b:2e21 with SMTP id b4-20020a170902650400b001dc4a8b2e21mr6190269plk.19.1708958147051;
        Mon, 26 Feb 2024 06:35:47 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id v9-20020a1709029a0900b001db594c9d17sm3981266plp.254.2024.02.26.06.35.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:46 -0800 (PST)
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
Subject: [RFC PATCH 21/73] KVM: x86/PVM: Implement vcpu_run() callbacks
Date: Mon, 26 Feb 2024 22:35:38 +0800
Message-Id: <20240226143630.33643-22-jiangshanlai@gmail.com>
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

In the vcpu_run() callback, the hypervisor needs to prepare for VM enter
in the switcher and record exit reasons after VM exit. The guest
registers are prepared on the host SP0 stack, and the guest/host
hardware CR3 is saved in the TSS for the switcher before VM enter.
Additionally, the guest xsave state is loaded into hardware before VM
enter. After VM exit, the guest registers are saved from the entry
stack, and host xsave states are restored.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 163 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |   5 ++
 2 files changed, 168 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 52b3b47ffe42..00a50ed0c118 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -16,8 +16,11 @@
 #include <asm/gsseg.h>
 #include <asm/io_bitmap.h>
 #include <asm/pvm_para.h>
+#include <asm/mmu_context.h>
 
 #include "cpuid.h"
+#include "lapic.h"
+#include "trace.h"
 #include "x86.h"
 #include "pvm.h"
 
@@ -204,6 +207,31 @@ static void pvm_switch_to_host(struct vcpu_pvm *pvm)
 	preempt_enable();
 }
 
+static void pvm_set_host_cr3_for_hypervisor(struct vcpu_pvm *pvm)
+{
+	unsigned long cr3;
+
+	if (static_cpu_has(X86_FEATURE_PCID))
+		cr3 = __get_current_cr3_fast() | X86_CR3_PCID_NOFLUSH;
+	else
+		cr3 = __get_current_cr3_fast();
+	this_cpu_write(cpu_tss_rw.tss_ex.host_cr3, cr3);
+}
+
+// Set tss_ex.host_cr3 for VMExit.
+// Set tss_ex.enter_cr3 for VMEnter.
+static void pvm_set_host_cr3(struct vcpu_pvm *pvm)
+{
+	pvm_set_host_cr3_for_hypervisor(pvm);
+	this_cpu_write(cpu_tss_rw.tss_ex.enter_cr3, pvm->vcpu.arch.mmu->root.hpa);
+}
+
+static void pvm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			     int root_level)
+{
+	/* Nothing to do. Guest cr3 will be prepared in pvm_set_host_cr3(). */
+}
+
 DEFINE_PER_CPU(struct vcpu_pvm *, active_pvm_vcpu);
 
 /*
@@ -262,6 +290,136 @@ static bool cpu_has_pvm_wbinvd_exit(void)
 	return true;
 }
 
+static int pvm_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	return 1;
+}
+
+// Save guest registers from host sp0 or IST stack.
+static __always_inline void save_regs(struct kvm_vcpu *vcpu, struct pt_regs *guest)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	vcpu->arch.regs[VCPU_REGS_RAX] = guest->ax;
+	vcpu->arch.regs[VCPU_REGS_RCX] = guest->cx;
+	vcpu->arch.regs[VCPU_REGS_RDX] = guest->dx;
+	vcpu->arch.regs[VCPU_REGS_RBX] = guest->bx;
+	vcpu->arch.regs[VCPU_REGS_RSP] = guest->sp;
+	vcpu->arch.regs[VCPU_REGS_RBP] = guest->bp;
+	vcpu->arch.regs[VCPU_REGS_RSI] = guest->si;
+	vcpu->arch.regs[VCPU_REGS_RDI] = guest->di;
+	vcpu->arch.regs[VCPU_REGS_R8] = guest->r8;
+	vcpu->arch.regs[VCPU_REGS_R9] = guest->r9;
+	vcpu->arch.regs[VCPU_REGS_R10] = guest->r10;
+	vcpu->arch.regs[VCPU_REGS_R11] = guest->r11;
+	vcpu->arch.regs[VCPU_REGS_R12] = guest->r12;
+	vcpu->arch.regs[VCPU_REGS_R13] = guest->r13;
+	vcpu->arch.regs[VCPU_REGS_R14] = guest->r14;
+	vcpu->arch.regs[VCPU_REGS_R15] = guest->r15;
+	vcpu->arch.regs[VCPU_REGS_RIP] = guest->ip;
+	pvm->rflags = guest->flags;
+	pvm->hw_cs = guest->cs;
+	pvm->hw_ss = guest->ss;
+}
+
+// load guest registers to host sp0 stack.
+static __always_inline void load_regs(struct kvm_vcpu *vcpu, struct pt_regs *guest)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	guest->ss = pvm->hw_ss;
+	guest->sp = vcpu->arch.regs[VCPU_REGS_RSP];
+	guest->flags = (pvm->rflags & SWITCH_ENTER_EFLAGS_ALLOWED) | SWITCH_ENTER_EFLAGS_FIXED;
+	guest->cs = pvm->hw_cs;
+	guest->ip = vcpu->arch.regs[VCPU_REGS_RIP];
+	guest->orig_ax = -1;
+	guest->di = vcpu->arch.regs[VCPU_REGS_RDI];
+	guest->si = vcpu->arch.regs[VCPU_REGS_RSI];
+	guest->dx = vcpu->arch.regs[VCPU_REGS_RDX];
+	guest->cx = vcpu->arch.regs[VCPU_REGS_RCX];
+	guest->ax = vcpu->arch.regs[VCPU_REGS_RAX];
+	guest->r8 = vcpu->arch.regs[VCPU_REGS_R8];
+	guest->r9 = vcpu->arch.regs[VCPU_REGS_R9];
+	guest->r10 = vcpu->arch.regs[VCPU_REGS_R10];
+	guest->r11 = vcpu->arch.regs[VCPU_REGS_R11];
+	guest->bx = vcpu->arch.regs[VCPU_REGS_RBX];
+	guest->bp = vcpu->arch.regs[VCPU_REGS_RBP];
+	guest->r12 = vcpu->arch.regs[VCPU_REGS_R12];
+	guest->r13 = vcpu->arch.regs[VCPU_REGS_R13];
+	guest->r14 = vcpu->arch.regs[VCPU_REGS_R14];
+	guest->r15 = vcpu->arch.regs[VCPU_REGS_R15];
+}
+
+static noinstr void pvm_vcpu_run_noinstr(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	struct pt_regs *sp0_regs = (struct pt_regs *)this_cpu_read(cpu_tss_rw.x86_tss.sp0) - 1;
+	struct pt_regs *ret_regs;
+
+	guest_state_enter_irqoff();
+
+	// Load guest registers into the host sp0 stack for switcher.
+	load_regs(vcpu, sp0_regs);
+
+	// Call into switcher and enter guest.
+	ret_regs = switcher_enter_guest();
+
+	// Get the guest registers from the host sp0 stack.
+	save_regs(vcpu, ret_regs);
+	pvm->exit_vector = (ret_regs->orig_ax >> 32);
+	pvm->exit_error_code = (u32)ret_regs->orig_ax;
+
+	guest_state_exit_irqoff();
+}
+
+/*
+ * PVM wrappers for kvm_load_{guest|host}_xsave_state().
+ *
+ * Currently PKU is disabled for shadowpaging and to avoid overhead,
+ * host CR4.PKE is unchanged for entering/exiting guest even when
+ * host CR4.PKE is enabled.
+ *
+ * These wrappers fix pkru when host CR4.PKE is enabled.
+ */
+static inline void pvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
+{
+	kvm_load_guest_xsave_state(vcpu);
+
+	if (cpu_feature_enabled(X86_FEATURE_PKU)) {
+		if (vcpu->arch.host_pkru)
+			write_pkru(0);
+	}
+}
+
+static inline void pvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
+{
+	kvm_load_host_xsave_state(vcpu);
+
+	if (cpu_feature_enabled(X86_FEATURE_PKU)) {
+		if (rdpkru() != vcpu->arch.host_pkru)
+			write_pkru(vcpu->arch.host_pkru);
+	}
+}
+
+static fastpath_t pvm_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	trace_kvm_entry(vcpu);
+
+	pvm_load_guest_xsave_state(vcpu);
+
+	kvm_wait_lapic_expire(vcpu);
+
+	pvm_set_host_cr3(pvm);
+
+	pvm_vcpu_run_noinstr(vcpu);
+
+	pvm_load_host_xsave_state(vcpu);
+
+	return EXIT_FASTPATH_NONE;
+}
+
 static void reset_segment(struct kvm_segment *var, int seg)
 {
 	memset(var, 0, sizeof(*var));
@@ -520,6 +678,11 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.vcpu_load = pvm_vcpu_load,
 	.vcpu_put = pvm_vcpu_put,
 
+	.load_mmu_pgd = pvm_load_mmu_pgd,
+
+	.vcpu_pre_run = pvm_vcpu_pre_run,
+	.vcpu_run = pvm_vcpu_run,
+
 	.vcpu_after_set_cpuid = pvm_vcpu_after_set_cpuid,
 
 	.sched_in = pvm_sched_in,
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 6584314487bc..349f4eac98ec 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -28,10 +28,15 @@ int host_mmu_init(void);
 struct vcpu_pvm {
 	struct kvm_vcpu vcpu;
 
+	// guest rflags, turned into hw rflags when in switcher
+	unsigned long rflags;
+
 	unsigned long switch_flags;
 
 	u16 host_ds_sel, host_es_sel;
 
+	u32 exit_vector;
+	u32 exit_error_code;
 	u32 hw_cs, hw_ss;
 
 	int loaded_cpu_state;
-- 
2.19.1.6.gb485710b


