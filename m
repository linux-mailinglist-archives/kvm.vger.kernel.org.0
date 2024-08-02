Return-Path: <kvm+bounces-23092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4014E9462F2
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:21:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6378D1C20EBB
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFBF1A34B0;
	Fri,  2 Aug 2024 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OkpdkXmP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F73C16BE3A
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722622789; cv=none; b=sL7rcJZ5s3DnIoG+690ch2QGlRM/Sge7BqyhWAPS8vyZMilS79hX6L/ONPVYbWP/PSPLtRR4AzeFKNYwaZ1Uz67SgaUsOYO2096Pr0NfFKf0WH95R+vB7JAoW8fFdzbOkUMsJdgIMw9+bWLLb2Gh+vd+RBp+NcCt3H5PkcUyx4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722622789; c=relaxed/simple;
	bh=BA66R9Ebk8eXc5BH6WLPIwNH02pf5d0FxWZLPIRPGQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZtH//RfQNk7FqFqSlvwrwv1uWXUwT8IAGqToL+a4qAyWu4fEnbvB6QUXgrb2I3eYqNXPhTobO4IlZsVlSSLAryLAmt3hd5sozCtOyXkJEe5HW4leWSAu4qZY4Q8iUMiC6huuoWX4UwuLpHyx4S9mC0NMZ/AXy91nehCY6aahVu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OkpdkXmP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-672bea19bedso185203637b3.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722622787; x=1723227587; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6CcQw+sZl9HHBbK/x6F/462tx1D0J2Pp0TQp6+Gv7TY=;
        b=OkpdkXmPe/9lOtMyj5ISasmWkw9e/tuCIfyxXCxxnihcAPMG1RTEmhXpQpAw2iuW2j
         8mI/8dyNQHyxLq4dVK3XIJT6WfzxvUCbYXuEq1ROGl0LZzYBdvHpZTRBXQ9w0p5E8j+1
         R1o58UhTObtH0Yt/MGGR37s7baYk4MvyQuUsrhu7EEIwwp6F+rQkHWXQ2LH5I0a24vtA
         ddV8S4ZXt4HMABExGn6QGZFx0LpKiyW33mjRfA6ZCIIwBoCeVN0AGuHn31Q1aZUyLrYC
         MVoNcmZbIRFyo9MmQIm6J6OOwfzOoHHHmTCJ65B6rSb88khzX9itRbYFbDucOEak3S7l
         082Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722622787; x=1723227587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6CcQw+sZl9HHBbK/x6F/462tx1D0J2Pp0TQp6+Gv7TY=;
        b=hstSml5QdM8h/DioQGUiTARx5uyuHUoO384xk0LsppXbX5rSXCb998UCzslOyTQO/9
         6PsBz3ujqiOFnhOykZ1XiOy+RJI5mkA+4R8woeMaSW7nGEJzeNQAKle/icn+yXo6yDGa
         dr5S7NAfduMdO8VNlPuTkgOwj2HLBxPuA90qD+q+QgN9Jmd7hbTflLOf+X0OiRcfbegX
         THiUXdRFzZzfZGT2g/Zn3c1N1DwF2/GR8j7ntu6IZ4t86RbSAwwqG6t6ko3nCTYTbQFm
         M4itN/dAPsoe4ZrARmQ59TvxWgnlzd+BrXPIliliQDl4BzMobYBNS25nBCstAaUEOjWn
         wSlw==
X-Gm-Message-State: AOJu0Yz78jUv9gt4Q+AAfQwvbTGppUeAzcpRoDV52uNoJqcW0SH91KgW
	Oz0FD+fu/lfRamMEsT2Gfnkt6danxsoOWTDxhOqYSMhY1QruDoy+VgU6Fc/px5imGYAptRb4ORj
	isQ==
X-Google-Smtp-Source: AGHT+IGw4ZhGgrmIy6+WxThtXS+JJCwlzxwXpHkLAHzBUXLadkseKLJaMvAPHEo3QNqDVXWlCta56cGr+go=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f8c:b0:64b:6aaa:2593 with SMTP id
 00721157ae682-68963bd9077mr2368087b3.6.1722622787234; Fri, 02 Aug 2024
 11:19:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:19:30 -0700
In-Reply-To: <20240802181935.292540-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802181935.292540-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802181935.292540-6-seanjc@google.com>
Subject: [PATCH v2 05/10] KVM: x86: Rename get_msr_feature() APIs to get_feature_msr()
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
index 68ad4f923664..9afbf8bcb521 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -125,7 +125,7 @@ KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
 KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
 KVM_X86_OP_OPTIONAL(guest_memory_reclaimed)
-KVM_X86_OP(get_msr_feature)
+KVM_X86_OP(get_feature_msr)
 KVM_X86_OP(check_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
 KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ac7a1387a9a0..b9d784abafdf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1805,7 +1805,7 @@ struct kvm_x86_ops {
 	int (*vm_move_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 	void (*guest_memory_reclaimed)(struct kvm *kvm);
 
-	int (*get_msr_feature)(u32 msr, u64 *data);
+	int (*get_feature_msr)(u32 msr, u64 *data);
 
 	int (*check_emulate_instruction)(struct kvm_vcpu *vcpu, int emul_type,
 					 void *insn, int insn_len);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c22e2b235882..f6980e0d2941 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2825,7 +2825,7 @@ static int efer_trap(struct kvm_vcpu *vcpu)
 	return kvm_complete_insn_gp(vcpu, ret);
 }
 
-static int svm_get_msr_feature(u32 msr, u64 *data)
+static int svm_get_feature_msr(u32 msr, u64 *data)
 {
 	*data = 0;
 
@@ -3181,7 +3181,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	case MSR_AMD64_DE_CFG: {
 		u64 supported_de_cfg;
 
-		if (svm_get_msr_feature(ecx, &supported_de_cfg))
+		if (svm_get_feature_msr(ecx, &supported_de_cfg))
 			return 1;
 
 		if (data & ~supported_de_cfg)
@@ -5001,7 +5001,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_unblocking = avic_vcpu_unblocking,
 
 	.update_exception_bitmap = svm_update_exception_bitmap,
-	.get_msr_feature = svm_get_msr_feature,
+	.get_feature_msr = svm_get_feature_msr,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
 	.get_segment_base = svm_get_segment_base,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0bf35ebe8a1b..4f6023a0deb3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -41,7 +41,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_put = vmx_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
-	.get_msr_feature = vmx_get_msr_feature,
+	.get_feature_msr = vmx_get_feature_msr,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
 	.get_segment_base = vmx_get_segment_base,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3d24eb4aeca2..cf85f8d50ccb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1998,7 +1998,7 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	return !(msr->data & ~valid_bits);
 }
 
-int vmx_get_msr_feature(u32 msr, u64 *data)
+int vmx_get_feature_msr(u32 msr, u64 *data)
 {
 	switch (msr) {
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9a0304eb847b..eeafd121fb08 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -56,7 +56,7 @@ bool vmx_has_emulated_msr(struct kvm *kvm, u32 index);
 void vmx_msr_filter_changed(struct kvm_vcpu *vcpu);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
-int vmx_get_msr_feature(u32 msr, u64 *data);
+int vmx_get_feature_msr(u32 msr, u64 *data);
 int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e64aba978380..660ff8795d92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1662,7 +1662,7 @@ static u64 kvm_get_arch_capabilities(void)
 	return data;
 }
 
-static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
+static int kvm_get_feature_msr(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
 	case MSR_IA32_ARCH_CAPABILITIES:
@@ -1675,12 +1675,12 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
 	default:
-		return kvm_x86_call(get_msr_feature)(msr->index, &msr->data);
+		return kvm_x86_call(get_feature_msr)(msr->index, &msr->data);
 	}
 	return 0;
 }
 
-static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
+static int do_get_feature_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 {
 	struct kvm_msr_entry msr;
 	int r;
@@ -1688,7 +1688,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	/* Unconditionally clear the output for simplicity */
 	msr.data = 0;
 	msr.index = index;
-	r = kvm_get_msr_feature(&msr);
+	r = kvm_get_feature_msr(&msr);
 
 	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
 		r = 0;
@@ -4946,7 +4946,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_GET_MSRS:
-		r = msr_io(NULL, argp, do_get_msr_feature, 1);
+		r = msr_io(NULL, argp, do_get_feature_msr, 1);
 		break;
 #ifdef CONFIG_KVM_HYPERV
 	case KVM_GET_SUPPORTED_HV_CPUID:
@@ -7385,7 +7385,7 @@ static void kvm_probe_feature_msr(u32 msr_index)
 		.index = msr_index,
 	};
 
-	if (kvm_get_msr_feature(&msr))
+	if (kvm_get_feature_msr(&msr))
 		return;
 
 	msr_based_features[num_msr_based_features++] = msr_index;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


