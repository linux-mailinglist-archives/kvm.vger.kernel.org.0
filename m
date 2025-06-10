Return-Path: <kvm+bounces-48904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E16AD464D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42C3E1886CD7
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E15A2E3374;
	Tue, 10 Jun 2025 22:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BAMuzYbg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275CE2DFA3C
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596296; cv=none; b=kU12w9CF6qjRAhG5YI+V+FV50RZqWxIQyQC1UzXd/f2lxV0ZceO7AwsRam2dkQlAM+S6NQe4Vb2ekphjcjlpWeUuj7rzR/GtGK169qp3yXA1vxC4lvEZuWnX8gtDzQpk5SEFA1+dS/DdDPPb56sT0YobFvWgyS261XL+V1KYPpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596296; c=relaxed/simple;
	bh=F1FCxA6Fmfycf87sm7Fnlumr/JZJilN6wmcgrzRL8Uc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kT4ep56gfFNCdegU3iL9jDXkIpLKhtBzuGPcjZe36M+lVUoU+VdY7Ul68c9QIBh6Ha4Pf9IntA4nEYZoYUQF01MoOqfx2IpdoHR57E3zAOE0/fAWoCPyXFdDH/WyRsV/br/bRtviDlO8B0gHXgZlAbtAhbk+fF+T9vDeoom01zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BAMuzYbg; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2358ddcb1e3so89630085ad.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596294; x=1750201094; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FaEfE2/QvzirXwC0gtWq1LyfGrvWT+i42kXYYAECDHg=;
        b=BAMuzYbg7MlWh8P+nhgfHvQjfqhiPf3DiLtNijLgtk97Ee+7bTP990RcRiaauv9dKa
         fjiEZIAXtGVwoASiSTAh51wfgTamzkH4yb94sRAL4u/9uzqOnCbMz2D+r1sj1LLcU2SB
         uklFR2996IOvaSIazZUK2Io8HsCediUKL3Z2q9g5LJLBES/0ulANsPDiD/qzk015XxMu
         ESltmRWvYvmmNObd+98nlWRiPLfhBfWeNgA6XxM95CrqRRx8vcXUvf6DlOsXpmCsDKpi
         iWLAN9c48jfZXzJPzw/VTLR8kNI9AIFvXLCsckCecpYmxWyOm2uXep6+B4AYRJiW/9wc
         y1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596294; x=1750201094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FaEfE2/QvzirXwC0gtWq1LyfGrvWT+i42kXYYAECDHg=;
        b=YKSce4abuKpuX2fllAXuDp87HfikJgOzIz/tnwrMhQrEk9ckhU08xJOvbRImd2+crl
         NXVismWl1sjmlQ9LNf3FDEzTU1hDL9DMS78bmDV3YPFmF+uQ2PHm3L5kHqbUXDCvkhI8
         VAqAyO2m512nK6L17Ris7uMkslK2SsWLeWIWeGg0nI1Wa1ooap8Ak/SXUmqKutswbwsG
         7NVOY0cpPB+5/wqfSZWNiHHs/9uOtXqkX3WQ0rep5xe5HL/ivmkBE+wpD20yqylCytrk
         015jb8Pi25ymLUeTPTMzvljX68zRRurMkkN5Qfmp4SOiTF6d0NC6p87ufesTty9a8+sj
         QkzA==
X-Gm-Message-State: AOJu0YzTPs1DvrC9Xg51kQJCeTLvnNqULdwctkyq2vLhlRbOxap45922
	0UuKrsfwntnp0CYzZqxrXMD+AxmFLmM0+LllJpiMAf8703W8sWzDf8oB+ECMVvlTjW2hZ8PrD9c
	WRsr3Cg==
X-Google-Smtp-Source: AGHT+IGvLjIOPk/iwEA2IyYT/UJ3dmbJ5ebXkhSDXZ8vMZLoG14BPZbaaTS3vZ80RE1HOv23dnW3r07AQ/s=
X-Received: from plbkk7.prod.google.com ([2002:a17:903:707:b0:234:e3a2:5b21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b26:b0:235:ea29:28da
 with SMTP id d9443c01a7336-236426208bbmr6439855ad.17.1749596294579; Tue, 10
 Jun 2025 15:58:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:25 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-21-seanjc@google.com>
Subject: [PATCH v2 20/32] KVM: x86: Rename msr_filter_changed() => recalc_msr_intercepts()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Rename msr_filter_changed() to recalc_msr_intercepts() and drop the
trampoline wrapper now that both SVM and VMX use a filter-agnostic recalc
helper to react to the new userspace filter.

No functional change intended.

Reviewed-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/svm/svm.c             | 8 +-------
 arch/x86/kvm/vmx/main.c            | 6 +++---
 arch/x86/kvm/vmx/vmx.c             | 7 +------
 arch/x86/kvm/vmx/x86_ops.h         | 2 +-
 arch/x86/kvm/x86.c                 | 8 +++++++-
 7 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8d50e3e0a19b..19a6735d6dd8 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -139,7 +139,7 @@ KVM_X86_OP(check_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
 KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
 KVM_X86_OP_OPTIONAL(migrate_timers)
-KVM_X86_OP(msr_filter_changed)
+KVM_X86_OP(recalc_msr_intercepts)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 330cdcbed1a6..89a626e5b80f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1885,7 +1885,7 @@ struct kvm_x86_ops {
 	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
-	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+	void (*recalc_msr_intercepts)(struct kvm_vcpu *vcpu);
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index de3d59c71229..710bc5f965dc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -896,11 +896,6 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	 */
 }
 
-static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
-{
-	svm_recalc_msr_intercepts(vcpu);
-}
-
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 {
 	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
@@ -929,7 +924,6 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
-
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
 	svm_recalc_lbr_msr_intercepts(vcpu);
 
@@ -5227,7 +5221,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
-	.msr_filter_changed = svm_msr_filter_changed,
+	.recalc_msr_intercepts = svm_recalc_msr_intercepts,
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..b3c58731a2f5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -220,7 +220,7 @@ static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return vmx_get_msr(vcpu, msr_info);
 }
 
-static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
+static void vt_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * TDX doesn't allow VMM to configure interception of MSR accesses.
@@ -231,7 +231,7 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
 	if (is_td_vcpu(vcpu))
 		return;
 
-	vmx_msr_filter_changed(vcpu);
+	vmx_recalc_msr_intercepts(vcpu);
 }
 
 static int vt_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
@@ -1034,7 +1034,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.apic_init_signal_blocked = vt_op(apic_init_signal_blocked),
 	.migrate_timers = vmx_migrate_timers,
 
-	.msr_filter_changed = vt_op(msr_filter_changed),
+	.recalc_msr_intercepts = vt_op(recalc_msr_intercepts),
 	.complete_emulated_msr = vt_op(complete_emulated_msr),
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ce7a1c07e402..bdff81f8288d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4074,7 +4074,7 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
+void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -4123,11 +4123,6 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	 */
 }
 
-void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
-{
-	vmx_recalc_msr_intercepts(vcpu);
-}
-
 static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 						int vector)
 {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b4596f651232..34c6e683e321 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -52,7 +52,7 @@ void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
 void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 bool vmx_has_emulated_msr(struct kvm *kvm, u32 index);
-void vmx_msr_filter_changed(struct kvm_vcpu *vcpu);
+void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 int vmx_get_feature_msr(u32 msr, u64 *data);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd34a2ec854c..cc9a01b6dbc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10926,8 +10926,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+
+		/*
+		 * Recalc MSR intercepts as userspace may want to intercept
+		 * accesses to MSRs that KVM would otherwise pass through to
+		 * the guest.
+		 */
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
-			kvm_x86_call(msr_filter_changed)(vcpu);
+			kvm_x86_call(recalc_msr_intercepts)(vcpu);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			kvm_x86_call(update_cpu_dirty_logging)(vcpu);
-- 
2.50.0.rc0.642.g800a2b2222-goog


