Return-Path: <kvm+bounces-23109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2145594636D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94BF3B2252B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85769166F00;
	Fri,  2 Aug 2024 18:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pVtV5P5j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C52A165EF0
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722624923; cv=none; b=GmYbhSbqZwegFWRsligGoGjXERTnPnippxcmPYoUn3mcxksoSffrF+8MCirnG04k6GcwFq+0MK1DhoktFztMZkAAL5VF2xgJwv7gtA94YczhOER54Fk3O5236u8AIWax++xBYQebeQdaBEuwfttZyAQ835OrOh6tlKj54FHL4v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722624923; c=relaxed/simple;
	bh=0EUjKhOb/qAcXw2TJAojZ2e/rlWYWY/bDSh0AscjqPg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VY8DOhvQhe1r3qZSJx76rsLKZgYhncShOwapE8ZI3VP54yn8YJgckeu+XNLMcDmBQUr+NuQ+uN0ejNb402LkQGHLaggZOrALE6hwREIc2/cP0Go+QzwRltnksMasin1FlDGqto8CxUNGAoVtInya8nxOAzVBiWiI5d7syanccxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pVtV5P5j; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc5652f7d4so86369865ad.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722624922; x=1723229722; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeKhc7uJU0ly0EH4yS5FJhheQ+g3afko+j38ACvpc04=;
        b=pVtV5P5jIJJgACKsA+mr+YDhlaoJ8S1Fznd63CUIG/tpNJCdt7BYFEhJQP4Ut9cnHR
         Cy6H++53/E7TYGKpFX83RRy+/aaGSJNB+kIhOwKq4A5Amz+IxdggSKvTQgEEuVaQNUIs
         GSmoU+0yTFw5atM6EtiT+9zE4uwM648DGNwLGBmfA7b6avNt3wPe9b4XKyV6PNJLQdVS
         jgQ65tG+BlsgVwbqWXNs4bpER4p0kKBG/h7FOy3l7hId4WCuRlwlRZ7W/TS+5WyGXNNi
         JVcsmqJ7/HWkzrx9gQ1BuF6hUcobZbAC9YaAuTWDid+qbVt/ugSbq6eeLcRsGGFfRG8v
         Ik9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722624922; x=1723229722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZeKhc7uJU0ly0EH4yS5FJhheQ+g3afko+j38ACvpc04=;
        b=t6xNrnxmimF+XYVe/whY3GbZ3N4Ql+Qb5W0OZ9/oChqL++61hv2RG9bs6+May7PD5H
         SA30mrZeVMjuotkGBG0EDQzx2C/y0YiSTerSKAoyGbfB8fzK8bL2+xT2azDaUqWNxbLT
         Zjd1630KtTVnAVlWNdwAyUlFi5kHIjqdKYF+xVE/YeZsz8YUjWNg7sT6HdrRpq0jzRV4
         q7wPTXtFbSo4IBi7r2UYhzUrFuA+WVgfTW/2Z+HA6JtohqR5RzYxPVM8mj5RmO+0dj/o
         W2iLDobTMhkUGQbzkk6D1cl7SQaZ+VPdJ+DIIqcvIwRtef+xBtdU2craPtylEs5dADT6
         4JKQ==
X-Gm-Message-State: AOJu0Yw3701kDsRrYNqLcsOv8k63CrUkva+9KDJuRXz3ngvClINTYyVt
	PfmG5omianCj3Tcw0DK8naaVDC5QDVMFMMHlGVXPAYzJjrnLlqfLcMm74D3LQgR9BxoAmaGDKAG
	Hmw==
X-Google-Smtp-Source: AGHT+IGbXJaDAT9nvHVWKusCP/1z3KHkzJApomQZ+AuPhnH1DVFIUTEo4MrCd9FFNveRJe0aD3eYnnY268E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac4:b0:1fd:d6d8:134e with SMTP id
 d9443c01a7336-1ff573a358bmr2214785ad.8.1722624921634; Fri, 02 Aug 2024
 11:55:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:55:05 -0700
In-Reply-To: <20240802185511.305849-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802185511.305849-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802185511.305849-4-seanjc@google.com>
Subject: [PATCH 3/9] KVM: x86: Quirk initialization of feature MSRs to KVM's
 max configuration
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a quirk to control KVM's misguided initialization of select feature
MSRs to KVM's max configuration, as enabling features by default violates
KVM's approach of letting userspace own the vCPU model, and is actively
problematic for MSRs that are conditionally supported, as the vCPU will
end up with an MSR value that userspace can't restore.  E.g. if the vCPU
is configured with PDCM=0, userspace will save and attempt to restore a
non-zero PERF_CAPABILITIES, thanks to KVM's meddling.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  | 22 ++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/svm.c          |  4 +++-
 arch/x86/kvm/vmx/vmx.c          |  9 ++++++---
 arch/x86/kvm/x86.c              |  8 +++++---
 6 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8e5dad80b337..d85480848e4e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8073,6 +8073,28 @@ KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS By default, KVM emulates MONITOR/MWAIT (if
                                     guest CPUID on writes to MISC_ENABLE if
                                     KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT is
                                     disabled.
+
+KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
+                                    vCPU's MSR_IA32_PERF_CAPABILITIES (0x345),
+                                    MSR_IA32_ARCH_CAPABILITIES (0x10a),
+                                    MSR_PLATFORM_INFO (0xce), and all VMX MSRs
+                                    (0x480..0x492) to the maximal capabilities
+                                    supported by KVM.  KVM also sets
+                                    MSR_IA32_UCODE_REV (0x8b) to an arbitrary
+                                    value (which is different for Intel vs.
+                                    AMD).  Lastly, when guest CPUID is set (by
+                                    userspace), KVM modifies select VMX MSR
+                                    fields to force consistency between guest
+                                    CPUID and L2's effective ISA.  When this
+                                    quirk is disabled, KVM zeroes the vCPU's MSR
+                                    values (with two exceptions, see below),
+                                    i.e. treats the feature MSRs like CPUID
+                                    leaves and gives userspace full control of
+                                    the vCPU model definition.  This quirk does
+                                    not affect VMX MSRs CR0/CR4_FIXED1 (0x487
+                                    and 0x489), as KVM does now allow them to
+                                    be set by userspace (KVM sets them based on
+                                    guest CPUID, for safety purposes).
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b9d784abafdf..2fee988a6a44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2342,7 +2342,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
 	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
-	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
+	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
+	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS)
 
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf57a824f722..f768902a73d4 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -439,6 +439,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
 #define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
+#define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 7)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f6980e0d2941..e21c3a622764 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1390,7 +1390,9 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 
 	svm_init_osvw(vcpu);
-	vcpu->arch.microcode_version = 0x01000065;
+
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
+		vcpu->arch.microcode_version = 0x01000065;
 	svm->tsc_ratio_msr = kvm_caps.default_tsc_scaling_ratio;
 
 	svm->nmi_masked = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf85f8d50ccb..c1d06f800b8e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4556,7 +4556,8 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
 	 * Update the nested MSR settings so that a nested VMM can/can't set
 	 * controls for features that are/aren't exposed to the guest.
 	 */
-	if (nested) {
+	if (nested &&
+	    kvm_check_has_quirk(vmx->vcpu.kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS)) {
 		/*
 		 * All features that can be added or removed to VMX MSRs must
 		 * be supported in the first place for nested virtualization.
@@ -4846,7 +4847,8 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	init_vmcs(vmx);
 
-	if (nested)
+	if (nested &&
+	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
 		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
 
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
@@ -4859,7 +4861,8 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 #endif
 
-	vcpu->arch.microcode_version = 0x100000000ULL;
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
+		vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a9566c035857..9b52d8f3304f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12260,9 +12260,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_async_pf_hash_reset(vcpu);
 
-	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
-	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
-	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS)) {
+		vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
+		vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
+		vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
+	}
 	kvm_pmu_init(vcpu);
 
 	vcpu->arch.pending_external_vector = -1;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


