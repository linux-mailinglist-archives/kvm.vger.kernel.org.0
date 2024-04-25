Return-Path: <kvm+bounces-15961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5609C8B27FE
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D5D22842B8
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B89F1534E1;
	Thu, 25 Apr 2024 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tR1pcMVR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3280D15530E
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068879; cv=none; b=arxtl8CiRwNT+COK0+gZxW0lFZHh0JXqMfa1CrZmW3D1X9hyBVZVn3tPiPtZowrv81U0P3Hol6/9TIwrxpmNY3Ed4bl61NjiMX/fkbquL3VXJt08p222GWcQerfRY97uk27cY7aRa9jXbZJpbNol+oiaju5Gg++rH33T9Mn9H7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068879; c=relaxed/simple;
	bh=StvXIkZ3US0m9kMQ9Q9JfdVme37W4KFKyCQZH7rfLnI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PWOrbMKHsfdYueUnmpm+Ek/U1QYX9zHmf59qmQQjFr4lthVuBBXYrwXaWwNMJkUTXmk8z18Feb2Kk2TX8OLTBbNRfd1tr4g7+wgrHwMXzYYiIIDm4ZXgM7Yyad25yClnSdoHhokFqD+tzOS+PSDRPpu8SGAJ+EMTVYU+OSBT8nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tR1pcMVR; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61aecbcb990so22570937b3.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 11:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714068877; x=1714673677; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tixZAupWcHJk0+Ih8AFgTTyczfrfxCg1OkitEmBkTm8=;
        b=tR1pcMVRF5RQPt7Ok2wl3Q6jnpVwa+q60tszFQtjusRR3CYs2XCvWZHb+1Qvrg8LAg
         USJii9a1H5/xFdrXeWM4G00bo81iRu7sVtngls9TnjUBMeXu/xKvwSs1mAPIUfyqWP+1
         89GLveFtKmVJ2DvKzfZNiBSlVpP5T1d6H4/GTJW4eDgJzDO98Ern4fQkIwElLItZzbIS
         5RtweVpkkc8QC1UIdLCMR0IKKgU+jmNYk/kov5GRT+Zyrg0jtGPiXCQL4gUS0Jedkb/6
         p1LHRusLsdGc5IQGO7rnBq1uK7fdiNn3V21b5Pym+YJtQ8319+bz3Thxx7B7KDaAWBPv
         Z3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068877; x=1714673677;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tixZAupWcHJk0+Ih8AFgTTyczfrfxCg1OkitEmBkTm8=;
        b=ZwiTSYjwiUcsAaS4b7DfBV19QgnXPiyFRZIIaYRKWeWro9fmMZ8jsyVtrw319+JyaS
         6NR465WNrRQjrFwUgQL6d5cD3Sns43iGeEujf939JOy4mIddQBEZHWcF++zgwQXbEwKl
         RW7lDMg1siLRSgVQTTNHmIdKsAJcpJVyIk1jSAQT5QAeLmei0q1OuHxa2U8njCpYCAx5
         ZU2hw4qB2MRcffLvrvwl0WlV0HIbIn1bKD+6CgBv465efkwqK9aftHcpMYYlYmZZJamd
         Ig2JmzhihrjMHxI2mk91lfpH4E4/qvAfP/mPuUbRRASE3Ie4U1GgRnzdTl6o7j647OSW
         dKRw==
X-Gm-Message-State: AOJu0YwlcQAyKD0N6UV41JrQArswOtssdttRblTq6g3Mxe2mvMa7SEc7
	tnqxwcPXLBGxbFW0TKTIz4GKA2tXGI/omMLpw634BC44twOyQ+QbnnISpAU/yDaNcP+wJzVs/Ez
	fqA==
X-Google-Smtp-Source: AGHT+IGitSnpLRruha2mGLEVNnW3UwIoXpPe8MsEM+FZOOpjpgq9++sJJlL2SPUFErP7kldSMaVP1xeihoE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cacc:0:b0:615:130a:2503 with SMTP id
 m195-20020a0dcacc000000b00615130a2503mr50202ywd.8.1714068877189; Thu, 25 Apr
 2024 11:14:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 11:14:17 -0700
In-Reply-To: <20240425181422.3250947-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425181422.3250947-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425181422.3250947-6-seanjc@google.com>
Subject: [PATCH 05/10] KVM: x86: Rename get_msr_feature() APIs to get_feature_msr()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename all APIs related to feature MSRs from get_feature_msr() to
get_feature_msr().  The APIs get "feature MSRs", not "MSR features".
And unlike kvm_{g,s}et_msr_common(), the "feature" adjective doesn't
describe the helper itself.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/svm.c             |  6 +++---
 arch/x86/kvm/vmx/main.c            |  2 +-
 arch/x86/kvm/vmx/vmx.c             |  2 +-
 arch/x86/kvm/vmx/x86_ops.h         |  2 +-
 arch/x86/kvm/x86.c                 | 12 ++++++------
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5187fcf4b610..9f25b4a49d6b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -128,7 +128,7 @@ KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
 KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
 KVM_X86_OP_OPTIONAL(guest_memory_reclaimed)
-KVM_X86_OP(get_msr_feature)
+KVM_X86_OP(get_feature_msr)
 KVM_X86_OP(check_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
 KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7d56e5a52ae3..cc04ab0c234e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1785,7 +1785,7 @@ struct kvm_x86_ops {
 	int (*vm_move_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 	void (*guest_memory_reclaimed)(struct kvm *kvm);
 
-	int (*get_msr_feature)(u32 msr, u64 *data);
+	int (*get_feature_msr)(u32 msr, u64 *data);
 
 	int (*check_emulate_instruction)(struct kvm_vcpu *vcpu, int emul_type,
 					 void *insn, int insn_len);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 15422b7d9149..d95cd230540d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2796,7 +2796,7 @@ static int efer_trap(struct kvm_vcpu *vcpu)
 	return kvm_complete_insn_gp(vcpu, ret);
 }
 
-static int svm_get_msr_feature(u32 msr, u64 *data)
+static int svm_get_feature_msr(u32 msr, u64 *data)
 {
 	*data = 0;
 
@@ -3134,7 +3134,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_AMD64_DE_CFG: {
 		u64 supported_de_cfg;
 
-		if (svm_get_msr_feature(ecx, &supported_de_cfg))
+		if (svm_get_feature_msr(ecx, &supported_de_cfg))
 			return 1;
 
 		if (data & ~supported_de_cfg)
@@ -4944,7 +4944,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_unblocking = avic_vcpu_unblocking,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
-	.get_msr_feature = svm_get_msr_feature,
+	.get_feature_msr = svm_get_feature_msr,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
 	.get_segment_base = svm_get_segment_base,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7c546ad3e4c9..c670f4cf6d94 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -40,7 +40,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_put = vmx_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
-	.get_msr_feature = vmx_get_msr_feature,
+	.get_feature_msr = vmx_get_feature_msr,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
 	.get_segment_base = vmx_get_segment_base,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 25b0a838abd6..fe2bf8f31d7c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1955,7 +1955,7 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	return !(msr->data & ~valid_bits);
 }
 
-int vmx_get_msr_feature(u32 msr, u64 *data)
+int vmx_get_feature_msr(u32 msr, u64 *data)
 {
 	switch (msr) {
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 504d56d6837d..4b81c85e9357 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -58,7 +58,7 @@ bool vmx_has_emulated_msr(struct kvm *kvm, u32 index);
 void vmx_msr_filter_changed(struct kvm_vcpu *vcpu);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
-int vmx_get_msr_feature(u32 msr, u64 *data);
+int vmx_get_feature_msr(u32 msr, u64 *data);
 int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03e50812ab33..8f58181f2b6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1682,7 +1682,7 @@ static u64 kvm_get_arch_capabilities(void)
 	return data;
 }
 
-static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
+static int kvm_get_feature_msr(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
 	case MSR_IA32_ARCH_CAPABILITIES:
@@ -1695,12 +1695,12 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
 	default:
-		return static_call(kvm_x86_get_msr_feature)(msr->index, &msr->data);
+		return static_call(kvm_x86_get_feature_msr)(msr->index, &msr->data);
 	}
 	return 0;
 }
 
-static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
+static int do_get_feature_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
 	struct kvm_msr_entry msr;
 	int r;
@@ -1708,7 +1708,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	/* Unconditionally clear the output for simplicity */
 	msr.data = 0;
 	msr.index = index;
-	r = kvm_get_msr_feature(&msr);
+	r = kvm_get_feature_msr(&msr);
 
 	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
 		r = 0;
@@ -4962,7 +4962,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_GET_MSRS:
-		r = msr_io(NULL, argp, do_get_msr_feature, 1);
+		r = msr_io(NULL, argp, do_get_feature_msr, 1);
 		break;
 #ifdef CONFIG_KVM_HYPERV
 	case KVM_GET_SUPPORTED_HV_CPUID:
@@ -7367,7 +7367,7 @@ static void kvm_probe_feature_msr(u32 msr_index)
 		.index = msr_index,
 	};
 
-	if (kvm_get_msr_feature(&msr))
+	if (kvm_get_feature_msr(&msr))
 		return;
 
 	msr_based_features[num_msr_based_features++] = msr_index;
-- 
2.44.0.769.g3c40516874-goog


