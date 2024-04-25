Return-Path: <kvm+bounces-15960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36D338B27FC
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E23B12829C2
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BBD153BFF;
	Thu, 25 Apr 2024 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QVTCfVvG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08631534E3
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068876; cv=none; b=cCOHV37mS5PKatweBvyJgTLMQUVfg+xPIk/Xd+fPUMrzcStIQLuADMsnDB9HiC0AOaZrAEuUV7hPcL/urbIFK415CFRwGtPx0+YQfkrXnYPC5nnsiDuYeyJ0MwEko0ezAscJZSHO9Lrd2Yr87FeqkbtI2EzkW3vxIrp2Z4zdZjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068876; c=relaxed/simple;
	bh=DB6Jd2NjWz9pOSph2qkilj87Mzk/nYMpk36QDZDFgt8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eP1Z1VXXzU4MLIT3WG4i8Sa+a5eqgctM0n0gCVyE5NFcOgtzLnGLXYxE4M7O0rfoHthZ6FBlbuElO20TG5/ZtnmEkLXSNR69FdLX4M/HKYpVvH85L1IUXGQ59qncOBK1nvijhnldyRf+7GiMkQ+8PNADPMs3lSdWH8nUNp2nIAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QVTCfVvG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2acf6bce4cfso1230691a91.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 11:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714068874; x=1714673674; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TM/ux6sNDcuTFLWtKCdREtCzy9peSbD7s84cr1LzYAg=;
        b=QVTCfVvGwZ8lMlHnUHs3kA0JQpUXrpX6OOS3v9QiNZEIugTrAFpVfNXEncIbwxWR8b
         uLTmNIcNwpKwKfghe7+EU+TVOJCgJR0nK3r2n2+hAKxMZB4vrTEN56/W0UCfNe7UguZF
         9Ku046w1bWWCV6IjbNF4rOvsVR0ALe79pd2dv46+lhy877s+5XR/Aob9xrUpCWJtrtwo
         km1ckHhx+lJf/i27QCwQex8ERMNjQW+48DwMY75mUTAQmhgfLMaKBMKOr4bEFKkyC27t
         Y6cIZQ4Jb2XB4KvPnwPZm7PPSGm8jWd56fHeKpGhi0S5MKMDv+c+27Pz8hChl7jZumTA
         emmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068874; x=1714673674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TM/ux6sNDcuTFLWtKCdREtCzy9peSbD7s84cr1LzYAg=;
        b=fDWx64qjas9tmjb2JSbV/ucZz1HKttkNLpi4oQp0J0bqLGVJhdxX3ouH0YhpT2+2N/
         WRo8scObJZ+9Rk8agH/bND3hws0GIPPpmF8yS5HIUWoK360F7KQEWVf3WPcculKmlzc9
         K2J2GzphfRRRytgyyeh76nlPZeT+cPIpr/TOdCS3dhgPwCQ2PBm+DG1HrPWPGPNAruyB
         pPag/+t6ZHC0F0qc87jRQpxAkd/ESj51XYFze/saV5Pf1GsikEUCIMID4131hJbcmSZ0
         O9mi7K6lIeWjDp5tU3A25to67spF1ugEUlM5ls5UAhzuTwyqdyiCHoT8XuBteXodhxXS
         GP1A==
X-Gm-Message-State: AOJu0Yz2W1B9FDnyuAw97aVnkbzvIOcX3xVi0urPLl74x5Qry6J14PT+
	6xPpNjc/AeI+hXvoJ5dp0F/ABBKa2VvU8tgiNnPUv91Q4oBbkH9DUzV3vH0Ak0DaLSYa95B93xv
	Pzw==
X-Google-Smtp-Source: AGHT+IFjcGcs2XNvvQqSdiEyKjpfUTGo9LUj5jTc0SVxdhv4fkQg8q3VSLriRIuKTK/itzvw9AvHu7Z+2D8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:68c2:b0:2a2:bcae:83c1 with SMTP id
 q2-20020a17090a68c200b002a2bcae83c1mr46654pjj.3.1714068873926; Thu, 25 Apr
 2024 11:14:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 11:14:16 -0700
In-Reply-To: <20240425181422.3250947-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425181422.3250947-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425181422.3250947-5-seanjc@google.com>
Subject: [PATCH 04/10] KVM: x86: Refactor kvm_x86_ops.get_msr_feature() to
 avoid kvm_msr_entry
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Refactor get_msr_feature() to take the index and data pointer as distinct
parameters in anticipation of eliminating "struct kvm_msr_entry" usage
further up the primary callchain.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/svm.c          | 16 +++++++---------
 arch/x86/kvm/vmx/vmx.c          |  6 +++---
 arch/x86/kvm/vmx/x86_ops.h      |  2 +-
 arch/x86/kvm/x86.c              |  2 +-
 5 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d13e3cd1dc5..7d56e5a52ae3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1785,7 +1785,7 @@ struct kvm_x86_ops {
 	int (*vm_move_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 	void (*guest_memory_reclaimed)(struct kvm *kvm);
 
-	int (*get_msr_feature)(struct kvm_msr_entry *entry);
+	int (*get_msr_feature)(u32 msr, u64 *data);
 
 	int (*check_emulate_instruction)(struct kvm_vcpu *vcpu, int emul_type,
 					 void *insn, int insn_len);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6e518edbd2aa..15422b7d9149 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2796,14 +2796,14 @@ static int efer_trap(struct kvm_vcpu *vcpu)
 	return kvm_complete_insn_gp(vcpu, ret);
 }
 
-static int svm_get_msr_feature(struct kvm_msr_entry *msr)
+static int svm_get_msr_feature(u32 msr, u64 *data)
 {
-	msr->data = 0;
+	*data = 0;
 
-	switch (msr->index) {
+	switch (msr) {
 	case MSR_AMD64_DE_CFG:
 		if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
-			msr->data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
+			*data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
 		break;
 	default:
 		return KVM_MSR_RET_UNSUPPORTED;
@@ -3132,14 +3132,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
 		break;
 	case MSR_AMD64_DE_CFG: {
-		struct kvm_msr_entry msr_entry;
+		u64 supported_de_cfg;
 
-		msr_entry.index = msr->index;
-		if (svm_get_msr_feature(&msr_entry))
+		if (svm_get_msr_feature(ecx, &supported_de_cfg))
 			return 1;
 
-		/* Check the supported bits */
-		if (data & ~msr_entry.data)
+		if (data & ~supported_de_cfg)
 			return 1;
 
 		/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ad2e7545de3..25b0a838abd6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1955,13 +1955,13 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 	return !(msr->data & ~valid_bits);
 }
 
-int vmx_get_msr_feature(struct kvm_msr_entry *msr)
+int vmx_get_msr_feature(u32 msr, u64 *data)
 {
-	switch (msr->index) {
+	switch (msr) {
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!nested)
 			return 1;
-		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
+		return vmx_get_vmx_msr(&vmcs_config.nested, msr, data);
 	default:
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 502704596c83..504d56d6837d 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -58,7 +58,7 @@ bool vmx_has_emulated_msr(struct kvm *kvm, u32 index);
 void vmx_msr_filter_changed(struct kvm_vcpu *vcpu);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
-int vmx_get_msr_feature(struct kvm_msr_entry *msr);
+int vmx_get_msr_feature(u32 msr, u64 *data);
 int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b07f0f11aeb..03e50812ab33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1695,7 +1695,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
 	default:
-		return static_call(kvm_x86_get_msr_feature)(msr);
+		return static_call(kvm_x86_get_msr_feature)(msr->index, &msr->data);
 	}
 	return 0;
 }
-- 
2.44.0.769.g3c40516874-goog


