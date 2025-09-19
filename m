Return-Path: <kvm+bounces-58234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0AD4B8B7BA
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CDB41761D1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF552DE6EE;
	Fri, 19 Sep 2025 22:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QHy6EdgX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1907B2DA771
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321195; cv=none; b=LDoq7Uddv8wL6aHbY4OmcVlHBYHPJx9yjcvpkk6vK6A1cG1+E2xz5ZsL1Xkc7IXGS2peOoj9V8v/8wbh65M0O7Ba2qZwqTjfJPvu40+uFy5rY2pcp+pmDH9gRRaLwrcny5CutjbzZc9zDJhUJBdlvg66Sa3AAwafX66Av1tgaLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321195; c=relaxed/simple;
	bh=jfGM7wnBghMUHDjlWPZeTxsMZ4TuIPSbh4OJ4877SKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t9vXxN0V9YFPnJhai66JO2i5TzPM4uOtvs+xwnfFByEaf/saCGltsiJKqt7TbDWCapD+y9D9WDWkVuluw0iRjMzZED4r09GS2qmTVa2GUCR1Vy4W2g/DTjDE/Y7+igeiokoI/kE5Z9FU+G1D/79RZUCDqAPofG0EBy4Q7zB8hf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QHy6EdgX; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-244582bc5e4so28923845ad.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321193; x=1758925993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5RFaqBNYsacXxOfISRfTRH70w0K5ILYhOxRUNM9RFhg=;
        b=QHy6EdgX5T0QKozMYLUk8rvzyowRczHkhtrlYPbFMBK/QTen86DGV4LcDeN2TRphvT
         1XPHqKHp3zoD5vcPoR8/h9XSaaB0TRPMM5c1fm0IFy+IBGMZFFuS4rZXGGQsNRdiHYw1
         5FK/UCfCI9MCCrvrbBqeTM8C52b1bfXerFxeONpBtVofte6EXHlm48huMCU2evH3gIh7
         b/JElVeM82n9FvtwgEI8XuuUIfTQIPeG1atYuukAwqWYqwbhpyh5D8hefYm5GJzGLGBy
         h/mAgIkJ+NSD4d/A9gGJ/z2DWYzT0dB6j8Iknj8sk8tfojw6ZiUFDg4fnod4Sw8rEgdr
         y/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321193; x=1758925993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5RFaqBNYsacXxOfISRfTRH70w0K5ILYhOxRUNM9RFhg=;
        b=cswkwAQS7REbmGygFOT4yDLJocs81JzWLaQNVe8GqqFSU5Ei0pLLDLhrTvcBdVnKA5
         u+iwtsFzYohpnm1RfGTkffQrSaboZLKukhJzbtln6Kn5C3A984ellvb/9LEDOksn3K3D
         8tLfpM6mOz3fkGy60XYHyys9ERSeUb5ZjPiGMNXaBD2WzZHaHKblVTmEXeegfSNUiYfh
         //Xit+dQizU2kpHGOML20UN/8/7nwv2r/jWO59svZsq+pUJ/6uzHuKJWb0UlmVu3LP5l
         Ttx5eb53+iOsrsw993rjUrcgI4brco2FlKHuxGJXfecD99OdDu0vgWgAFBTyh0+ER5Qy
         eErA==
X-Gm-Message-State: AOJu0Yy3CWnxd4o3Ljoxf5aujPyv1qWl7cA1hwN5v0nybGLb4Zk1whL6
	FFK56h7h4wG0FOH+bX9psFgzdvzFa2EoreS0XWdauRFanDcG6kYARGNarptx5PXhZO9La0cWkl/
	4oag/1A==
X-Google-Smtp-Source: AGHT+IFrIb3fr2s0qtkeK56mPEY5NS7nbXqbWpySC13gAxRV2LfepKkyhFqcJVi5Ognn5W5Agd2I0Y29i9E=
X-Received: from pjm8.prod.google.com ([2002:a17:90b:2fc8:b0:32d:df7e:6696])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b10:b0:24d:64bc:1495
 with SMTP id d9443c01a7336-269ba528961mr55393775ad.41.1758321193262; Fri, 19
 Sep 2025 15:33:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:13 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-7-seanjc@google.com>
Subject: [PATCH v16 06/51] KVM: x86: Check XSS validity against guest CPUIDs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
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
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  7 +++----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8695967b7a31..7a7e6356a8dd 100644
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
index efee08fad72e..6b8b5d8b13cc 100644
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
index d202d9532eb2..d4c192f4c06f 100644
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
2.51.0.470.ga7dc726c21-goog


