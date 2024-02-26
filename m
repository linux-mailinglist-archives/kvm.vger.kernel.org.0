Return-Path: <kvm+bounces-9895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8048678FD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 322191C22212
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4EC61369AB;
	Mon, 26 Feb 2024 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBkD0NRP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C709136679;
	Mon, 26 Feb 2024 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958185; cv=none; b=oZiREmpsrTYm5+0lJBNgx9N/vizmDntzhk4+YzuwHFqnl9DtyKWycgtW7gyYCgN60OG/YlgYeAu+X0DdddHlPgesRjX/93vKbZyN3WFbraunfuEOqUkJse6xTzVMVPyZS6r+7w8IzdkOCxeQxLQF/GEju8qhmAeRxlweKKa7NZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958185; c=relaxed/simple;
	bh=FSCeMybtjLkWOcvn1/oPwqYyDuFS9jfLHr/iI3/35J4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cibUgOoHSHa3jwbuXLcocq8MCclDZ67GUZsIClOkd3kZ6EhdaTf9LsmzisOOaWc9iwrC0mBwsM6cdtvzJkrMHIUfTc12pQkpKcge+HCmUOXzCxAfS+RdQIw04Gjr7fY5jco1tZRIqquT90NvLHbkxGMjVeF3zPvj5UsMa6ib+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fBkD0NRP; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29ab78237d2so549898a91.1;
        Mon, 26 Feb 2024 06:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958182; x=1709562982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7bwJTFGuFIC+k+OLuNRGTvG01rlJOsBv/cJ09NssQo=;
        b=fBkD0NRPw4AGY3YXrHNWWtI42PIFEEkn5wKbwArZSgYMkBVvYVd7om/top6bbFAgz4
         5F/b17qDkquMppAwXit4mXEh4YxrNo7lzE162Yf8kKmiGpE5lmhYbxa/T184OQwjNu8d
         xZ9eLaaGSsjlZTehGE9UxJxt1Aam02S9hivlsQFV/AAwVba0InMQcbc+wezckpYV/emF
         Y5PtGyItg+QEblMS+xxV+PtdW/LByiG5C+M6K9IAvDG0LNrCIIt2gVLLWXFDvnJF5TgD
         c9nSCtMKOL6+JCIn3tcZxCll6ybsexTN9FB4BLIAbfSTL2ySCqfwRYyFvT2pgcd7sajP
         Dj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958182; x=1709562982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y7bwJTFGuFIC+k+OLuNRGTvG01rlJOsBv/cJ09NssQo=;
        b=Kvcebnit4V0I81TxrkGG3PjDSULGVcCDoM8dvusHBOrvbmSKImWhjIDxpaP0Lp3kSF
         me17vdL23OUnL73ETi/cw0ndTB0OgMhP8rXX5D9CFM2dXUzAmeU+8eqShh+jdT37RWe0
         6sDHlhiyQpd9iMxtMlNn3Euu88v4rzZM+fxsiIAoE0uameoWZ7piZxXO3T5n55KJoHKx
         Qvu3KJrsJBEfnkXg9cGkobQX08PEyiJvX+IYWooRiEKpKfoidv0iVAfWKaS79I+tL4PE
         jx4nfx/KFA/tlpSZpLQcEFl5r2grNlpDcEOu5NqOP30Ahkb1tyzffAlecidqS6RorHJk
         1lLQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3ofhI5ahyvp8i1MH6ErFjEmyNpvqXNm7QrWsdV7F5/4l4TzPo6kTS1FnbNKE4ZFxyv7ShiJ9A1/q1hq3wDc7Za9Au
X-Gm-Message-State: AOJu0YwEiYOrpaj/UND34JIsSJfwMbx4+OPZN2E/KiP7pe6FgEPq4Xox
	7bhnP62BH6BD8/IF7KJ1fzR4+h9lvl5oDGkjoDen5wy/OTEN+c0o3d7H0+nk
X-Google-Smtp-Source: AGHT+IG3z1woxkp3HjHcu/cKR62RacPqwF1XKXl10J4SM9h9SBQY/rrOhEnQy0WWaLka6uM1LzHAOg==
X-Received: by 2002:a17:90a:bd09:b0:29a:8b1b:1f61 with SMTP id y9-20020a17090abd0900b0029a8b1b1f61mr3842116pjr.17.1708958182556;
        Mon, 26 Feb 2024 06:36:22 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id n15-20020a17090ade8f00b002995e9aca72sm4579874pjv.29.2024.02.26.06.36.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:22 -0800 (PST)
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
Subject: [RFC PATCH 32/73] KVM: x86/PVM: Enable guest debugging functions
Date: Mon, 26 Feb 2024 22:35:49 +0800
Message-Id: <20240226143630.33643-33-jiangshanlai@gmail.com>
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

The guest DR7 is loaded before VM enter to enable debugging functions
for the guest. If guest debugging is not enabled, the #DB and #BP
exceptions are reinjected into the guest directly; otherwise, they are
handled by the hypervisor.

However, DR7_GD is cleared since debug register read/write is a
privileged instruction, which always leads to a VM exit for #GP. The
address of breakpoints is limited to the allowed address range, similar
to the check in the #PF path.  Guest DR7 is loaded before VM enter to
enable debug function for guest.  If guest debug is not enabled, the #DB
and #BP are reinjected into guest directly, otherwise, they are handled
by hypervisor similar to VMX.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 96 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |  3 ++
 2 files changed, 99 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 4ec8c2c514ca..299305903005 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -383,6 +383,8 @@ static void pvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 
+	pvm->host_debugctlmsr = get_debugctlmsr();
+
 	if (__this_cpu_read(active_pvm_vcpu) == pvm && vcpu->cpu == cpu)
 		return;
 
@@ -533,6 +535,9 @@ static int pvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SYSENTER_ESP:
 		msr_info->data = pvm->unused_MSR_IA32_SYSENTER_ESP;
 		break;
+	case MSR_IA32_DEBUGCTLMSR:
+		msr_info->data = 0;
+		break;
 	case MSR_PVM_VCPU_STRUCT:
 		msr_info->data = pvm->msr_vcpu_struct;
 		break;
@@ -619,6 +624,9 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SYSENTER_ESP:
 		pvm->unused_MSR_IA32_SYSENTER_ESP = data;
 		break;
+	case MSR_IA32_DEBUGCTLMSR:
+		/* It is ignored now. */
+		break;
 	case MSR_PVM_VCPU_STRUCT:
 		if (!PAGE_ALIGNED(data))
 			return 1;
@@ -810,6 +818,10 @@ static bool pvm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static void update_exception_bitmap(struct kvm_vcpu *vcpu)
+{
+}
+
 static struct pvm_vcpu_struct *pvm_get_vcpu_struct(struct vcpu_pvm *pvm)
 {
 	struct gfn_to_pfn_cache *gpc = &pvm->pvcs_gpc;
@@ -1235,6 +1247,72 @@ static int pvm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static void pvm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
+{
+	WARN_ONCE(1, "pvm never sets KVM_DEBUGREG_WONT_EXIT\n");
+}
+
+static void pvm_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	to_pvm(vcpu)->guest_dr7 = val;
+}
+
+static __always_inline unsigned long __dr7_enable_mask(int drnum)
+{
+	unsigned long bp_mask = 0;
+
+	bp_mask |= (DR_LOCAL_ENABLE << (drnum * DR_ENABLE_SIZE));
+	bp_mask |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE));
+
+	return bp_mask;
+}
+
+static __always_inline unsigned long __dr7_mask(int drnum)
+{
+	unsigned long bp_mask = 0xf;
+
+	bp_mask <<= (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
+	bp_mask |= __dr7_enable_mask(drnum);
+
+	return bp_mask;
+}
+
+/*
+ * Calculate the correct dr7 for the hardware to avoid the host
+ * being watched.
+ *
+ * It only needs to be calculated each time when vcpu->arch.eff_db or
+ * pvm->guest_dr7 is changed.  But now it is calculated each time on
+ * VM-enter since there is no proper callback for vcpu->arch.eff_db and
+ * it is slow path.
+ */
+static __always_inline unsigned long pvm_eff_dr7(struct kvm_vcpu *vcpu)
+{
+	unsigned long eff_dr7 = to_pvm(vcpu)->guest_dr7;
+	int i;
+
+	/*
+	 * DR7_GD should not be set to hardware. And it doesn't need to be
+	 * set to hardware since PVM guest is running on hardware ring3.
+	 * All access to debug registers will be trapped and the emulation
+	 * code can handle DR7_GD correctly for PVM.
+	 */
+	eff_dr7 &= ~DR7_GD;
+
+	/*
+	 * Disallow addresses that are not for the guest, especially addresses
+	 * on the host entry code.
+	 */
+	for (i = 0; i < KVM_NR_DB_REGS; i++) {
+		if (!pvm_guest_allowed_va(vcpu, vcpu->arch.eff_db[i]))
+			eff_dr7 &= ~__dr7_mask(i);
+		if (!pvm_guest_allowed_va(vcpu, vcpu->arch.eff_db[i] + 7))
+			eff_dr7 &= ~__dr7_mask(i);
+	}
+
+	return eff_dr7;
+}
+
 // Save guest registers from host sp0 or IST stack.
 static __always_inline void save_regs(struct kvm_vcpu *vcpu, struct pt_regs *guest)
 {
@@ -1301,6 +1379,9 @@ static noinstr void pvm_vcpu_run_noinstr(struct kvm_vcpu *vcpu)
 	// Load guest registers into the host sp0 stack for switcher.
 	load_regs(vcpu, sp0_regs);
 
+	if (unlikely(pvm->guest_dr7 & DR7_BP_EN_MASK))
+		set_debugreg(pvm_eff_dr7(vcpu), 7);
+
 	// Call into switcher and enter guest.
 	ret_regs = switcher_enter_guest();
 
@@ -1309,6 +1390,11 @@ static noinstr void pvm_vcpu_run_noinstr(struct kvm_vcpu *vcpu)
 	pvm->exit_vector = (ret_regs->orig_ax >> 32);
 	pvm->exit_error_code = (u32)ret_regs->orig_ax;
 
+	// dr7 requires to be zero when the controling of debug registers
+	// passes back to the host.
+	if (unlikely(pvm->guest_dr7 & DR7_BP_EN_MASK))
+		set_debugreg(0, 7);
+
 	// handle noinstr vmexits reasons.
 	switch (pvm->exit_vector) {
 	case PF_VECTOR:
@@ -1387,8 +1473,15 @@ static fastpath_t pvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pvm_set_host_cr3(pvm);
 
+	if (pvm->host_debugctlmsr)
+		update_debugctlmsr(0);
+
 	pvm_vcpu_run_noinstr(vcpu);
 
+	/* MSR_IA32_DEBUGCTLMSR is zeroed before vmenter. Restore it if needed */
+	if (pvm->host_debugctlmsr)
+		update_debugctlmsr(pvm->host_debugctlmsr);
+
 	if (is_smod(pvm)) {
 		struct pvm_vcpu_struct *pvcs = pvm->pvcs_gpc.khva;
 
@@ -1696,6 +1789,7 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.vcpu_load = pvm_vcpu_load,
 	.vcpu_put = pvm_vcpu_put,
 
+	.update_exception_bitmap = update_exception_bitmap,
 	.get_msr_feature = pvm_get_msr_feature,
 	.get_msr = pvm_get_msr,
 	.set_msr = pvm_set_msr,
@@ -1709,6 +1803,8 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.set_gdt = pvm_set_gdt,
 	.get_idt = pvm_get_idt,
 	.set_idt = pvm_set_idt,
+	.set_dr7 = pvm_set_dr7,
+	.sync_dirty_debug_regs = pvm_sync_dirty_debug_regs,
 	.get_rflags = pvm_get_rflags,
 	.set_rflags = pvm_set_rflags,
 	.get_if_flag = pvm_get_if_flag,
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index bf3a6a1837c0..4cdcbed1c813 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -37,6 +37,7 @@ struct vcpu_pvm {
 	unsigned long switch_flags;
 
 	u16 host_ds_sel, host_es_sel;
+	u64 host_debugctlmsr;
 
 	union {
 		unsigned long exit_extra;
@@ -52,6 +53,8 @@ struct vcpu_pvm {
 	int int_shadow;
 	bool nmi_mask;
 
+	unsigned long guest_dr7;
+
 	struct gfn_to_pfn_cache pvcs_gpc;
 
 	// emulated x86 msrs
-- 
2.19.1.6.gb485710b


