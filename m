Return-Path: <kvm+bounces-9883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8644D867982
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAD64B2B997
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D2613249B;
	Mon, 26 Feb 2024 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bg/DjkPS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2526132489;
	Mon, 26 Feb 2024 14:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958146; cv=none; b=H5znE4WbrTxGD7OfMsR+saT9iaXyFBNnRNlm0K68V7GTMx9Iimx8hQLi8lj6XvCKZdxDt9+4cHVomRkKIuZIbfhhIolNeBIbnVa8OxyfpH4zEuIDnxjN5cdnnlaxjyKYouba24udrja603EgABF7XksCJ2OrWhyDADPfCKtM6OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958146; c=relaxed/simple;
	bh=8SekTiXNHrHLsNEUj45LpjNSY2VTIm3w7VgqsWwXACc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F3bAvni9pmDEJp/tdoIQVUfw8DD5dhKa1m4EtwSNiEhx4iiawhXHrPpJAVuhP0JRbN1T7KgPMQrl5HQKNZgOOiW4zU/3ormljC6FQfQpkc0fB61dkWRM6mbwnd3tP+pjMCFbGYIWo05saADQr66BUOkyPWfBdoU0nfy+QW83r+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bg/DjkPS; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e53f3f1f82so214840b3a.2;
        Mon, 26 Feb 2024 06:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958144; x=1709562944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GlT8Oy8jepWXAfHbDfNjdqLeUT8NKyYg0Ors9fKJfGM=;
        b=Bg/DjkPSuasxBhfHr0aYkXRRiATzQFMJVyMcYH2rEwlo+FHaYs6Qoq3NGc3TxsNo5p
         J9GndacRAQgiYkv41ySkiqhYZ/TCN0BvxjUAS4mH7zEoQcxltDxhFWRK+tKZCChkuzgn
         boGKo/vSfx9pCMR2gPXuqLMpzGyCEu4BRd5jlywu5tXofr6etmM8zj8PI9gyySzOUBRo
         ZXCmuVgqaC4zDwk7VRweSN8cajdOervWU7s9gfOwVCPHx1NXABHan29JNQKL7+5+f1BH
         t7aPSnOHHU3KaB/p+gLey0NynAkxQeHFOs+v3aVDYYwHn8wGxqTD6xFbUWtWfvTcjKbD
         0EIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958144; x=1709562944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GlT8Oy8jepWXAfHbDfNjdqLeUT8NKyYg0Ors9fKJfGM=;
        b=fir/mv314JTadVJ/ujR+w+zZocOlMh1mdpYu1cm41Cicz2PNKAU+MZM5su5Ei8Nvxg
         9SSoRGHCYOJnyF8mTLyZufwfVFm+WYtijwP3fgC6PxaEPIuEQ6QObGjgVGybTdSTAzbX
         WYbGEcYmIwhx5KcSMn0YusEQCMXWRKfK8uFtfCFn7YxUZtRGeYcrDGzBoa2T7WLEaVjt
         EtoZi0ts99PTgPLBJoIOJ4N8Rjikr+wdWeWZa5ircbWH1XGMtjWW90RaV+mk6nUesLww
         uxwgzvFc49fmZB0WmWg+2VDXxe/a6rsmaK/XoEXv0KYEnnR83mv4UnxDnkxm3GXOnate
         MzIw==
X-Forwarded-Encrypted: i=1; AJvYcCUKK7d/Q3O43c8lUaomVzOAnLDg/YW5duVgyya6rnzNM/xuNw9RZmwz72dTR/hS70+RllHLKJTMzMsbBFQiCvUhg/Xd
X-Gm-Message-State: AOJu0YzHAgEJD6hakadqOjKJdiYqMbgfH3u3sVrEzn3NYtgYIX+PEzvB
	D2U/v0XX60cIrMs82giUlFfbdYRppu2iNy3CK+vCzMMlrfnBDScJFTE6u7gz
X-Google-Smtp-Source: AGHT+IF8TJ6xNK89quEEVBVGExFNiUnrqDL3Or/nJo10zBYwCLB2W+1oUA5ZsXrst2Z2JzN340jXxg==
X-Received: by 2002:aa7:8449:0:b0:6e4:74ba:d907 with SMTP id r9-20020aa78449000000b006e474bad907mr5396962pfn.27.1708958143772;
        Mon, 26 Feb 2024 06:35:43 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id k4-20020aa79d04000000b006e0651ec05csm4066820pfp.43.2024.02.26.06.35.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:43 -0800 (PST)
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
Subject: [RFC PATCH 20/73] KVM: x86/PVM: Implement vcpu_load()/vcpu_put() related callbacks
Date: Mon, 26 Feb 2024 22:35:37 +0800
Message-Id: <20240226143630.33643-21-jiangshanlai@gmail.com>
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

When preparing to switch to the guest, some guest states that only
matter to userspace can be loaded ahead before VM enter. In PVM, guest
segment registers and user return MSRs are loaded into hardware at that
time. Since LDT and IO bitmap are not supported in PVM guests, they are
cleared as well. When preparing to switch to the host in vcpu_put(),
host states are restored.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 235 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |   5 +
 2 files changed, 240 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index d4cc52bf6b3f..52b3b47ffe42 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -13,6 +13,8 @@
 
 #include <linux/module.h>
 
+#include <asm/gsseg.h>
+#include <asm/io_bitmap.h>
 #include <asm/pvm_para.h>
 
 #include "cpuid.h"
@@ -26,6 +28,211 @@ static bool __read_mostly is_intel;
 
 static unsigned long host_idt_base;
 
+static inline void __save_gs_base(struct vcpu_pvm *pvm)
+{
+	// switcher will do a real hw swapgs, so use hw MSR_KERNEL_GS_BASE
+	rdmsrl(MSR_KERNEL_GS_BASE, pvm->segments[VCPU_SREG_GS].base);
+}
+
+static inline void __load_gs_base(struct vcpu_pvm *pvm)
+{
+	// switcher will do a real hw swapgs, so use hw MSR_KERNEL_GS_BASE
+	wrmsrl(MSR_KERNEL_GS_BASE, pvm->segments[VCPU_SREG_GS].base);
+}
+
+static inline void __save_fs_base(struct vcpu_pvm *pvm)
+{
+	rdmsrl(MSR_FS_BASE, pvm->segments[VCPU_SREG_FS].base);
+}
+
+static inline void __load_fs_base(struct vcpu_pvm *pvm)
+{
+	wrmsrl(MSR_FS_BASE, pvm->segments[VCPU_SREG_FS].base);
+}
+
+/*
+ * Test whether DS, ES, FS and GS need to be reloaded.
+ *
+ * Reading them only returns the selectors, but writing them (if
+ * nonzero) loads the full descriptor from the GDT or LDT.
+ *
+ * We therefore need to write new values to the segment registers
+ * on every host-guest state switch unless both the new and old
+ * values are zero.
+ */
+static inline bool need_reload_sel(u16 sel1, u16 sel2)
+{
+	return unlikely(sel1 | sel2);
+}
+
+/*
+ * Save host DS/ES/FS/GS selector, FS base, and inactive GS base.
+ * And load guest DS/ES/FS/GS selector, FS base, and GS base.
+ *
+ * Note, when the guest state is loaded and it is in hypervisor, the guest
+ * GS base is loaded in the hardware MSR_KERNEL_GS_BASE which is loaded
+ * with host inactive GS base when the guest state is NOT loaded.
+ */
+static void segments_save_host_and_switch_to_guest(struct vcpu_pvm *pvm)
+{
+	u16 pvm_ds_sel, pvm_es_sel, pvm_fs_sel, pvm_gs_sel;
+
+	/* Save host segments */
+	savesegment(ds, pvm->host_ds_sel);
+	savesegment(es, pvm->host_es_sel);
+	current_save_fsgs();
+
+	/* Load guest segments */
+	pvm_ds_sel = pvm->segments[VCPU_SREG_DS].selector;
+	pvm_es_sel = pvm->segments[VCPU_SREG_ES].selector;
+	pvm_fs_sel = pvm->segments[VCPU_SREG_FS].selector;
+	pvm_gs_sel = pvm->segments[VCPU_SREG_GS].selector;
+
+	if (need_reload_sel(pvm_ds_sel, pvm->host_ds_sel))
+		loadsegment(ds, pvm_ds_sel);
+	if (need_reload_sel(pvm_es_sel, pvm->host_es_sel))
+		loadsegment(es, pvm_es_sel);
+	if (need_reload_sel(pvm_fs_sel, current->thread.fsindex))
+		loadsegment(fs, pvm_fs_sel);
+	if (need_reload_sel(pvm_gs_sel, current->thread.gsindex))
+		load_gs_index(pvm_gs_sel);
+
+	__load_gs_base(pvm);
+	__load_fs_base(pvm);
+}
+
+/*
+ * Save guest DS/ES/FS/GS selector, FS base, and GS base.
+ * And load host DS/ES/FS/GS selector, FS base, and inactive GS base.
+ */
+static void segments_save_guest_and_switch_to_host(struct vcpu_pvm *pvm)
+{
+	u16 pvm_ds_sel, pvm_es_sel, pvm_fs_sel, pvm_gs_sel;
+
+	/* Save guest segments */
+	savesegment(ds, pvm_ds_sel);
+	savesegment(es, pvm_es_sel);
+	savesegment(fs, pvm_fs_sel);
+	savesegment(gs, pvm_gs_sel);
+	pvm->segments[VCPU_SREG_DS].selector = pvm_ds_sel;
+	pvm->segments[VCPU_SREG_ES].selector = pvm_es_sel;
+	pvm->segments[VCPU_SREG_FS].selector = pvm_fs_sel;
+	pvm->segments[VCPU_SREG_GS].selector = pvm_gs_sel;
+
+	__save_fs_base(pvm);
+	__save_gs_base(pvm);
+
+	/* Load host segments */
+	if (need_reload_sel(pvm_ds_sel, pvm->host_ds_sel))
+		loadsegment(ds, pvm->host_ds_sel);
+	if (need_reload_sel(pvm_es_sel, pvm->host_es_sel))
+		loadsegment(es, pvm->host_es_sel);
+	if (need_reload_sel(pvm_fs_sel, current->thread.fsindex))
+		loadsegment(fs, current->thread.fsindex);
+	if (need_reload_sel(pvm_gs_sel, current->thread.gsindex))
+		load_gs_index(current->thread.gsindex);
+
+	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gsbase);
+	wrmsrl(MSR_FS_BASE, current->thread.fsbase);
+}
+
+static void pvm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	if (pvm->loaded_cpu_state)
+		return;
+
+	pvm->loaded_cpu_state = 1;
+
+#ifdef CONFIG_X86_IOPL_IOPERM
+	/*
+	 * PVM doesn't load guest I/O bitmap into hardware.  Invalidate I/O
+	 * bitmap if the current task is using it.  This prevents any possible
+	 * leakage of an active I/O bitmap to the guest and forces I/O
+	 * instructions in guest to be trapped and emulated.
+	 *
+	 * The I/O bitmap will be restored when the current task exits to
+	 * user mode in arch_exit_to_user_mode_prepare().
+	 */
+	if (test_thread_flag(TIF_IO_BITMAP))
+		native_tss_invalidate_io_bitmap();
+#endif
+
+#ifdef CONFIG_MODIFY_LDT_SYSCALL
+	/* PVM doesn't support LDT. */
+	if (unlikely(current->mm->context.ldt))
+		clear_LDT();
+#endif
+
+	segments_save_host_and_switch_to_guest(pvm);
+
+	kvm_set_user_return_msr(0, (u64)entry_SYSCALL_64_switcher, -1ull);
+	kvm_set_user_return_msr(1, pvm->msr_tsc_aux, -1ull);
+	if (ia32_enabled()) {
+		if (is_intel)
+			kvm_set_user_return_msr(2, GDT_ENTRY_INVALID_SEG, -1ull);
+		else
+			kvm_set_user_return_msr(2, (u64)entry_SYSCALL32_ignore, -1ull);
+	}
+}
+
+static void pvm_prepare_switch_to_host(struct vcpu_pvm *pvm)
+{
+	if (!pvm->loaded_cpu_state)
+		return;
+
+	++pvm->vcpu.stat.host_state_reload;
+
+#ifdef CONFIG_MODIFY_LDT_SYSCALL
+	if (unlikely(current->mm->context.ldt))
+		kvm_load_ldt(GDT_ENTRY_LDT*8);
+#endif
+
+	segments_save_guest_and_switch_to_host(pvm);
+	pvm->loaded_cpu_state = 0;
+}
+
+/*
+ * Set all hardware states back to host.
+ * Except user return MSRs.
+ */
+static void pvm_switch_to_host(struct vcpu_pvm *pvm)
+{
+	preempt_disable();
+	pvm_prepare_switch_to_host(pvm);
+	preempt_enable();
+}
+
+DEFINE_PER_CPU(struct vcpu_pvm *, active_pvm_vcpu);
+
+/*
+ * Switches to specified vcpu, until a matching vcpu_put(), but assumes
+ * vcpu mutex is already taken.
+ */
+static void pvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	if (__this_cpu_read(active_pvm_vcpu) == pvm && vcpu->cpu == cpu)
+		return;
+
+	__this_cpu_write(active_pvm_vcpu, pvm);
+
+	indirect_branch_prediction_barrier();
+}
+
+static void pvm_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	pvm_prepare_switch_to_host(pvm);
+}
+
+static void pvm_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
 static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
@@ -100,6 +307,8 @@ static void pvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 	int i;
 
+	pvm_switch_to_host(pvm);
+
 	kvm_gpc_deactivate(&pvm->pvcs_gpc);
 
 	if (!init_event)
@@ -183,6 +392,24 @@ static int pvm_check_processor_compat(void)
 	return 0;
 }
 
+/*
+ * When in PVM mode, the hardware MSR_LSTAR is set to the entry point
+ * provided by the host entry code (switcher), and the
+ * hypervisor can also change the hardware MSR_TSC_AUX to emulate
+ * the guest MSR_TSC_AUX.
+ */
+static __init void pvm_setup_user_return_msrs(void)
+{
+	kvm_add_user_return_msr(MSR_LSTAR);
+	kvm_add_user_return_msr(MSR_TSC_AUX);
+	if (ia32_enabled()) {
+		if (is_intel)
+			kvm_add_user_return_msr(MSR_IA32_SYSENTER_CS);
+		else
+			kvm_add_user_return_msr(MSR_CSTAR);
+	}
+}
+
 static __init void pvm_set_cpu_caps(void)
 {
 	if (boot_cpu_has(X86_FEATURE_NX))
@@ -253,6 +480,8 @@ static __init int hardware_setup(void)
 	store_idt(&dt);
 	host_idt_base = dt.address;
 
+	pvm_setup_user_return_msrs();
+
 	pvm_set_cpu_caps();
 
 	kvm_configure_mmu(false, 0, 0, 0);
@@ -287,8 +516,14 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.vcpu_free = pvm_vcpu_free,
 	.vcpu_reset = pvm_vcpu_reset,
 
+	.prepare_switch_to_guest = pvm_prepare_switch_to_guest,
+	.vcpu_load = pvm_vcpu_load,
+	.vcpu_put = pvm_vcpu_put,
+
 	.vcpu_after_set_cpuid = pvm_vcpu_after_set_cpuid,
 
+	.sched_in = pvm_sched_in,
+
 	.nested_ops = &pvm_nested_ops,
 
 	.setup_mce = pvm_setup_mce,
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 599bbbb284dc..6584314487bc 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -30,13 +30,18 @@ struct vcpu_pvm {
 
 	unsigned long switch_flags;
 
+	u16 host_ds_sel, host_es_sel;
+
 	u32 hw_cs, hw_ss;
 
+	int loaded_cpu_state;
 	int int_shadow;
 	bool nmi_mask;
 
 	struct gfn_to_pfn_cache pvcs_gpc;
 
+	// emulated x86 msrs
+	u64 msr_tsc_aux;
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
 	 * msr_ia32_feature_control. FEAT_CTL_LOCKED is always included
-- 
2.19.1.6.gb485710b


