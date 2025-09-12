Return-Path: <kvm+bounces-57449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3E1B55A04
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36257AE0E64
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8B22C08AC;
	Fri, 12 Sep 2025 23:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FH5Z/FNO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1896A29BDBC
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719417; cv=none; b=n5hboerkoynrlIpC/UClFcLpRCNewzGVLB1JfLCbeMvAWLSemoP/IwryKqsYHCCy7KYRjwlaJ8PAEzKesGvNN2iesPS1czL4hTku1OhWYc435OmMf82PYjHxuET3sdc+/ehODuYybeBMj7GPPKBhqV7VKss2XHqvUVBbRos5IWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719417; c=relaxed/simple;
	bh=Ts2O3iIiauNKice8KQ4rNc4sfJ/k4xkmItHEORp/rEs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qV8yUMkXWWMC3c4XBQF+FRDGb0+ZgfJDDpdz1UWAxSmDCA5RL4Fb7J9LjLegqb2eSk7H4cQUaddRJUQbYwYKruTIp3F3A6TEEcJqHFChbK4RsRH+smqFiLU4Q6s7VoplwBvrKkSTUD/gctdCtTxRDGzDEt7zMBnPliYj91zo57M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FH5Z/FNO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77615e6ee47so1168354b3a.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719415; x=1758324215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VPSKTOmJ0MbU5RRp5+PoAEPU2M2YZuhj8feB+e76lMo=;
        b=FH5Z/FNO94uHd5lIT301PJfE8seFRa/gVn1Us2E7YaxKGEvheNAHCr+s4LzAFbs7iF
         To6sdgO572XCDzTgpFiewtl1RGt/UC7Tcm77nt/wG5FELm8juPW503PK8wPS2CPgd7P5
         uM9CxqO3jlD5SQfPUGrGaeC0v3NVUOsWNLUiaw61iOMbqP9d6aK3Fg5NQfM65UKy7GMD
         LgQhg6kjJdKEOvI46okSZc7zybTy/vMS8ewSH3ZccYpkZcGa+g+NMIv+A4WT09yPSyLW
         UzDmlcx9Rj775DOzuYvqxd4F0qqmBeUqaJ+F1z6h25pwusvhWExWDNqSuBESSY/b+6mk
         fNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719415; x=1758324215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VPSKTOmJ0MbU5RRp5+PoAEPU2M2YZuhj8feB+e76lMo=;
        b=R87Kxrl0oKo5sF0cANK4sMo7KIH3nmEygaAgnAy3EkhnuF1DV8DaTQtE5SmudhHohv
         D8adDdFdHlUn8BREh53ajexU+HAw46o9+CTlz+vghLMpN9jIutWqovugOxoPbNMlaSj+
         Yf0Yi+Hqq8GldkMU0UABu3AM4/dN9rEN7nMEXMOLo66ZfhO9Ed5JPB6enNGWDFXVkVy8
         8ilnS9370sYuJgwj264GVNik57OYZhkpnnqiUR/XTc3vPRbT+88D2WZPR+RB0ZmgByyg
         S8EdNQB21LgKHsYucYQY1qbCJyDNRvyEhTVFVH95b7IQvZH/VFchhrHcbcZf0AV9oP1I
         JSYg==
X-Gm-Message-State: AOJu0YwKJ7w2dJHQq3sEG8MkF+cDG2rncqiw36H7KpWnBFm8EIRtpYyU
	fnSrN2eoR4+xXVbAV3rOA2XpGpatt4DpLObx4hbejLrfG+n9MBfABDi/L8+BExWCUOZYvQlzO4e
	3P3OAIA==
X-Google-Smtp-Source: AGHT+IHx0w8+O1I8ii10DeBVFbxahEaUgIPv8NQFb0AWUVXy/yMPk+G17BdAeITayGtjMl9yPUybw4g3gVA=
X-Received: from pfoo15.prod.google.com ([2002:a05:6a00:1a0f:b0:775:fbac:d698])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1ad4:b0:772:871c:1e49
 with SMTP id d2e1a72fcca58-7761219836dmr5226705b3a.29.1757719415203; Fri, 12
 Sep 2025 16:23:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:44 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-7-seanjc@google.com>
Subject: [PATCH v15 06/41] KVM: x86: Check XSS validity against guest CPUIDs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Maintain per-guest valid XSS bits and check XSS validity against them
rather than against KVM capabilities. This is to prevent bits that are
supported by KVM but not supported for a guest from being set.

Opportunistically return KVM_MSR_RET_UNSUPPORTED on IA32_XSS MSR accesses
if guest CPUID doesn't enumerate X86_FEATURE_XSAVES. Since
KVM_MSR_RET_UNSUPPORTED takes care of host_initiated cases, drop the
host_initiated check.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  7 +++----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2762554cbb7b..d931d72d23c9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -815,7 +815,6 @@ struct kvm_vcpu_arch {
 	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xfd_no_write_intercept;
-	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
 	u64 perf_capabilities;
@@ -876,6 +875,8 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 ia32_xss;
+	u64 guest_supported_xss;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ad6cadf09930..46cf616663e6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -263,6 +263,17 @@ static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }
 
+static u64 cpuid_get_supported_xss(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
+	if (!best)
+		return 0;
+
+	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
+}
+
 static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
 						       struct kvm_cpuid_entry2 *entry,
 						       unsigned int x86_feature,
@@ -424,6 +435,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
+	vcpu->arch.guest_supported_xss = cpuid_get_supported_xss(vcpu);
 
 	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b4258b38ad8..5a5af40c06a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3984,15 +3984,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_XSS:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
-			return 1;
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+			return KVM_MSR_RET_UNSUPPORTED;
 		/*
 		 * KVM supports exposing PT to the guest, but does not support
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
 		 * XSAVES/XRSTORS to save/restore PT MSRs.
 		 */
-		if (data & ~kvm_caps.supported_xss)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
 		vcpu->arch.ia32_xss = data;
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
-- 
2.51.0.384.g4c02a37b29-goog


