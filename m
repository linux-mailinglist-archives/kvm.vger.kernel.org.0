Return-Path: <kvm+bounces-33469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4CC9EC18E
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E844E28580F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B95F1D63CA;
	Wed, 11 Dec 2024 01:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yNnm3B7U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085931AA1C8
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 01:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880796; cv=none; b=sEpIe0h11NYd3E+y5IIVrCMypd3E3ehqDBJWE2HktvYE0d00Tko8PrEiro5S+lldLPGLG/AR/aCwQN37ypMEuMTdrnde+ZLfQVAcmD2CPjCw7Jedq6tEuJ8TBMJibhdCkYyNWlEy0yUb252QYKd51cpviVEFIquvxRzNsppMCbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880796; c=relaxed/simple;
	bh=GeZjefPzaSzlW9P5U7c5cbWNrl4gdZzPq5kjW0P6E6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lSo56z7B3vwIMDdVH7dSP4ZRKOMkJmfOXD+ope/TDD6Y5gC3/LltkgLd2VMRCJdcCEzSQUIQxRYBISzz/6jUisthu9jNHDceX0LxwTm9/ppGbian5yfNdTJgGQ3qYNIqVUrQDXOzhGX1DcPoXWX8r2f+DZoOrcaeaVHufUZ4ZUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yNnm3B7U; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7f3e30a441aso4145397a12.2
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 17:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733880793; x=1734485593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HZ5sJeak2EiI3SOZqjSO6VGW0fiyRkqJf4P1SWT3nKE=;
        b=yNnm3B7U0Pe2E/brk7morvl0klLgROn/AX6dOmZQbzNK4jh30Hd3ExCRK2e0s/AeJx
         ypYUvnLeptFMPb9JLthYWIX2h1WcgUQEIrrBm235Qwv1pD3IxblPX+Hf2JPYDb7/jZ9z
         D3HBHaBlvk3LE4jVMsduiH2J/knmGSJZ/iPl3nUJUp+l0aZXoT9lmEwQsFjtTzJxEOAX
         7CbefCcmiBBUHVN0WAX7imoPZFiOOtgz9PiQlRiV5RfuIZq+7PYcUp7uwHnGe5T/FaYd
         domPbhfHpkioPKINvAraAdz9nfMapccvK4O7sHqqxzvqTCv1lKfJZKS9k8nbwwd4Fgvl
         kb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733880793; x=1734485593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HZ5sJeak2EiI3SOZqjSO6VGW0fiyRkqJf4P1SWT3nKE=;
        b=kAVujZ+pLBZRle9g/6W/4stCLIUW6fuPnNB9CPH7JEzOROyWKwtr/XdEqTFXBcDSxh
         yXWf86yUXu/IYpwewunojUWs9byvku1LhLcxMaAdplLiwHK1kUgIpHkBUylWK7Po8VUx
         jCyKfbtogdQKkTGgRETxqqLlE2dy5uF1ZJosBxRl9us6dgtZtb+cp9j2iIjWTakZCc9v
         J6Q3xYqqPBQAIw8gNG9foKzVdNkLbfoEW/cHrgraV690RYAcnXXai6PgCqz6dSdshkNx
         suOyFxeSdYIrS/6LWFBgbn36ifzX6jNylo9xgQQQykYSz/cfuR4Kuhfvk9Z8FFdYJIav
         qxSw==
X-Gm-Message-State: AOJu0Yw27ni1H6Jiww6UXW08xeF9LZ9d/3F7rdcVJFLRYE/6GFjy2wdn
	iajOAup99CqeUgzG374VLQOe79ighhstEiWN/erEs0CeOItbQNF6SruxudFiZ0fLdU53AHvLPlS
	rBQ==
X-Google-Smtp-Source: AGHT+IF9gRHWUxSXw+ed16y1ZE/J0WJZZNP87qlPzDNpWKIFFMyqHS+ld7Ia5f+mFIBaDw0CKeEge/S/ndY=
X-Received: from pjbsh15.prod.google.com ([2002:a17:90b:524f:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:180f:b0:2ee:cd83:8fc3
 with SMTP id 98e67ed59e1d1-2f12804c61cmr1774285a91.37.1733880793368; Tue, 10
 Dec 2024 17:33:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Dec 2024 17:33:02 -0800
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241211013302.1347853-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: x86: Defer runtime updates of dynamic CPUID bits
 until CPUID emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Defer runtime CPUID updates until the next non-faulting CPUID emulation
or KVM_GET_CPUID2, which are the only paths in KVM that consume the
dynamic entries.  Deferring the updates is especially beneficial to
nested VM-Enter/VM-Exit, as KVM will almost always detect multiple state
changes, not to mention the updates don't need to be realized while L2 is
active, as CPUID is a mandatory intercept on both Intel and AMD.

Deferring CPUID updates shaves several hundred cycles from nested VMX
roundtrips, as measured from L2 executing CPUID in a tight loop:

  SKX 6850 => 6450
  ICX 9000 => 8800
  EMR 7900 => 7700

Alternatively, KVM could update only the CPUID leaves that are affected
by the state change, e.g. update XSAVE info only if XCR0 or XSS changes,
but that adds non-trivial complexity and doesn't solve the underlying
problem of nested transitions potentially changing both XCR0 and XSS, on
both nested VM-Enter and VM-Exit.

KVM could also skip updates entirely while L2 is active, because again
CPUID is a mandatory intercept.  However, simply skipping updates if L2
is active is *very* subtly dangerous and complex.  Most KVM updates are
triggered by changes to the current vCPU state, which may be L2 state
whereas performing updates only for L1 would requiring detecting changes
to L1 state.  KVM would need to either track relevant L1 state, or defer
runtime CPUID updates until the next nested VM-Exit.  The former is ugly
and complex, while the latter comes with similar dangers to deferring all
CPUID updates, and would only address the nested VM-Enter path.

To guard against using stale data, disallow querying dynamic CPUID feature
bits, i.e. features that KVM updates at runtime, via a compile-time
assertion in guest_cpu_cap_has().  Exempt MWAIT from the rule, as the
MISC_ENABLE_NO_MWAIT means that MWAIT is _conditionally_ a dynamic CPUID
feature.

Note, the rule could be enforced for MWAIT as well, e.g. by querying guest
CPUID in kvm_emulate_monitor_mwait, but there's no obvious advtantage to
doing so, and allowing MWAIT for guest_cpuid_has() opens up a different can
of worms.  MONITOR/MWAIT can't be virtualized (for a reasonable definition),
and the nature of the MWAIT_NEVER_UD_FAULTS and MISC_ENABLE_NO_MWAIT quirks
means checking X86_FEATURE_MWAIT outside of kvm_emulate_monitor_mwait() is
wrong for other reasons.

Beyond the aforementioned feature bits, the only other dynamic CPUID
(sub)leaves are the XSAVE sizes, and similar to MWAIT, consuming those
CPUID entries in KVM is all but guaranteed to be a bug.  The layout for an
actual XSAVE buffer depends on the format (compacted or not) and
potentially the features that are actually enabled.  E.g. see the logic in
fpstate_clear_xstate_component() needed to poke into the guest's effective
XSAVE state to clear MPX state on INIT.  KVM does consume
CPUID.0xD.0.{EAX,EDX} in kvm_check_cpuid() and cpuid_get_supported_xcr0(),
but not EBX, which is the only dynamic output register in the leaf.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 12 ++++++++++--
 arch/x86/kvm/cpuid.h            |  9 ++++++++-
 arch/x86/kvm/lapic.c            |  2 +-
 arch/x86/kvm/smm.c              |  2 +-
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              |  6 +++---
 9 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 81ce8cd5814a..23cc5c10060e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -871,6 +871,7 @@ struct kvm_vcpu_arch {
 
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
+	bool cpuid_dynamic_bits_dirty;
 	bool is_amd_compatible;
 
 	/*
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7f5fa6665969..54ba1a75b779 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -195,6 +195,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 }
 
 static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu);
+static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
 static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
@@ -299,10 +300,12 @@ static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
 	guest_cpu_cap_change(vcpu, x86_feature, has_feature);
 }
 
-void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
+	vcpu->arch.cpuid_dynamic_bits_dirty = false;
+
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best) {
 		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSXSAVE,
@@ -332,7 +335,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 }
-EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
 {
@@ -645,6 +647,9 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	if (cpuid->nent < vcpu->arch.cpuid_nent)
 		return -E2BIG;
 
+	if (vcpu->arch.cpuid_dynamic_bits_dirty)
+		kvm_update_cpuid_runtime(vcpu);
+
 	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
 			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
 		return -EFAULT;
@@ -1983,6 +1988,9 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	struct kvm_cpuid_entry2 *entry;
 	bool exact, used_max_basic = false;
 
+	if (vcpu->arch.cpuid_dynamic_bits_dirty)
+		kvm_update_cpuid_runtime(vcpu);
+
 	entry = kvm_find_cpuid_entry_index(vcpu, function, index);
 	exact = !!entry;
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 67d80aa72d50..d2884162a46a 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -11,7 +11,6 @@ extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
-void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
@@ -232,6 +231,14 @@ static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
+	/*
+	 * Except for MWAIT, querying dynamic feature bits is disallowed, so
+	 * that KVM can defer runtime updates until the next CPUID emulation.
+	 */
+	BUILD_BUG_ON(x86_feature == X86_FEATURE_APIC ||
+		     x86_feature == X86_FEATURE_OSXSAVE ||
+		     x86_feature == X86_FEATURE_OSPKE);
+
 	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ae81ae27d534..cf74c87b8b3f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2585,7 +2585,7 @@ static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
-		kvm_update_cpuid_runtime(vcpu);
+		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 
 	if (!apic)
 		return;
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index e0ab7df27b66..699e551ec93b 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -358,7 +358,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
 			goto error;
 #endif
 
-	kvm_update_cpuid_runtime(vcpu);
+	vcpu->arch.cpuid_dynamic_bits_dirty = true;
 	kvm_mmu_reset_context(vcpu);
 	return;
 error:
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 09be12a44288..5e4581ed0ef1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3274,7 +3274,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 
 	if (kvm_ghcb_xcr0_is_valid(svm)) {
 		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
-		kvm_update_cpuid_runtime(vcpu);
+		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 	}
 
 	/* Copy the GHCB exit information into the VMCB fields */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 07911ddf1efe..6a350cee2f6c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1936,7 +1936,7 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
 
 	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-		kvm_update_cpuid_runtime(vcpu);
+		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf872d8691b5..b5f3c5628bfd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3516,7 +3516,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	vmcs_writel(GUEST_CR4, hw_cr4);
 
 	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-		kvm_update_cpuid_runtime(vcpu);
+		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 }
 
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc8829712edd..10b7d8c01e4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1264,7 +1264,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	vcpu->arch.xcr0 = xcr0;
 
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
-		kvm_update_cpuid_runtime(vcpu);
+		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 	return 0;
 }
 
@@ -3899,7 +3899,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
 			vcpu->arch.ia32_misc_enable_msr = data;
-			kvm_update_cpuid_runtime(vcpu);
+			vcpu->arch.cpuid_dynamic_bits_dirty = true;
 		} else {
 			vcpu->arch.ia32_misc_enable_msr = data;
 		}
@@ -3934,7 +3934,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~kvm_caps.supported_xss)
 			return 1;
 		vcpu->arch.ia32_xss = data;
-		kvm_update_cpuid_runtime(vcpu);
+		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
-- 
2.47.0.338.g60cca15819-goog


