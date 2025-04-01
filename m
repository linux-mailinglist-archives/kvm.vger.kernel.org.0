Return-Path: <kvm+bounces-42417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A47A78470
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE7BF3AF114
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC870214A8B;
	Tue,  1 Apr 2025 22:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LLYX5rHt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ED81F03C4
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545473; cv=none; b=F55haJjPr/jfYbO86Xz6BFPBKJB7QP5Fi2FgTK2NFEHQNj4zeuiNudAjSo/cd/q5Ayzzmgu6mhLhQIUa6noAB/RdoaxssNYfIZM3PixLXhi1jC1JfeuqcrMDwAfS4d4fjvjocWedC5NQF0WWNCLMTR7M240VEE3KLYRWRpcLuD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545473; c=relaxed/simple;
	bh=O9cxl7MogAW+TDdp2n1RhRv/hxuT4dOmf1cRN9ozKWw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EqiM2/1srHE2Iv2z4oCupRJ855VI6AJIKB0nxYkxUd8cI5zGnyWDgso7pYjNZDldR9XDtjbbL4bm6LQP8WFDRGQAFuG+54zd6xZHKBXI+0kVHRw05B+du2PXFqhNJP4OtEUtBxLgD8R+Rs8P16iZMgdd1yra7cIdXrKTuz9pKIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LLYX5rHt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff52e1c56fso14852248a91.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 15:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743545470; x=1744150270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eDSAJd8fSRw5F1CjR2zVAxHH1lRxDOHrOK6aIGt6W5w=;
        b=LLYX5rHtG3oPXECn0bGN5BP4vtK39V8ksmzL4wXoEAek1nzlO6fq0ZD5/kWSPhg8s+
         f4PIi6cr0WJRNZC0v/4MPfVe0y14odp5/dn9bWAW4w/vvsin8B+2cUSFxzqPTF7jSAG5
         PVPWJjKYSbhKfFoI5kUDjR2zAG2GSh/pCF1Bgy1Xg9YXFg1vPXy+i/LthZ5pDzwhbqjr
         smsu4V0WhF7Xy756bIObPTLNfozVVfkJzobQM08l75Xei8IOaKGteb9AmyKeX5XHrEuR
         QkxEiqjRf087kW93nOo+xW1vAH8bIEaT1B734J/TbKV9nGaXprmA1WbvqWlVXubgFKS0
         Nq2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743545470; x=1744150270;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eDSAJd8fSRw5F1CjR2zVAxHH1lRxDOHrOK6aIGt6W5w=;
        b=BTCgSAaXqNFJwP6lWn1wStUwKnFU6YWRKk7IcxWJwGXttwDF72dVQMLP1hHGoAXvQa
         2ghbYfFPUtRiLOgcdAf05xbdqfQewXEFrz8kiktbPhAVp6+vIDlvhc/6YryRICYVSzzF
         fCb2dbyLDW52S+edXo9Gan7I/MpUdPY31MRFCMu9wtzN+ADlQ3VrVFDbn3D/vCRju+EF
         Ur2tkqqhUnKva2MgGqnR9ue7fg3oFv1iu9X1Nd0zCYTDP3n79Ej2aE6nxLU5DEtdTymu
         Xny8Z1esXg1VYrxm6C8HSSqGP+8CPkQHxzMXoWl30ajJj7jjuaLPZflcSYjf6JaiDrVd
         w+BA==
X-Gm-Message-State: AOJu0Yw3OJNj3KilRJ7n1EtlYKJJTKjNQutQdCMJq7kRopDHkyyadj2B
	m+iBArq70Slh14TeaxN/ODnOWi+vcFlroRw+kqJd+aQ64mhYSUVSoYAcnSw7Mzyk/qi0tyO434b
	lng==
X-Google-Smtp-Source: AGHT+IGOkn5QTPSjtGUXTYqZiSpWW2DDQAcX+/So+HMf5/FkOY6Z4LzaNLDhSLWJeK6fXRXyfvkiHmeJn1I=
X-Received: from pjbso14.prod.google.com ([2002:a17:90b:1f8e:b0:2ff:84e6:b2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56cf:b0:2f9:c56b:6ec8
 with SMTP id 98e67ed59e1d1-3056ee3608dmr487140a91.10.1743545470641; Tue, 01
 Apr 2025 15:11:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 15:11:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401221107.921677-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Add a quirk to (not) honor guest PAT on CPUs that
 support self-snoop
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add back support for honoring guest PAT on Intel CPUs that support self-
snoop (and don't have errata), but guarded by a quirk so as not to break
existing setups that subtly relied on KVM forcing WB for synthetic
devices.

This effectively reverts commit 9d70f3fec14421e793ffbc0ec2f739b24e534900
and reapplies 377b2f359d1f71c75f8cc352b5c81f2210312d83, but with a quirk.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

AFAIK, we don't have an answer as to whether the slow UC behavior on CLX+
is working as intended or a CPU flaw, which Paolo was hoping we would get
before adding a quirk.  But I don't want to lose sight of honoring guest
PAT, nor am I particularly inclined to force end users to wait for a
definitive answer on hardware they may not even care about.

 Documentation/virt/kvm/api.rst  | 25 +++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 17 +++++++++++++----
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++----
 arch/x86/kvm/x86.c              |  2 +-
 7 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1f8625b7646a..2a1444d99c37 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8158,6 +8158,31 @@ KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
                                     and 0x489), as KVM does now allow them to
                                     be set by userspace (KVM sets them based on
                                     guest CPUID, for safety purposes).
+
+KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT  By default, on Intel CPUs with TDP (EPT)
+                                    enabled, KVM ignores guest PAT unless the
+                                    VM has an assigned non-coherent device,
+                                    even if it is entirely safe/correct for KVM
+                                    to honor guest PAT.  When this quirk is
+                                    disabled, and the host CPU fully supports
+                                    selfsnoop (isn't affected by errata), KVM
+                                    honors guest PAT for all VMs.
+
+                                    The only _known_ issue with honoring guest
+                                    PAT is when QEMU's Bochs VGA is exposed to
+                                    a VM on Cascade Lake and later Intel server
+                                    CPUs, and the guest kernel is running an
+                                    outdated driver that maps video RAM as UC.
+                                    Accessing UC memory on the affected Intel
+                                    CPUs is an order of magnitude slower than
+                                    previous generations, to the point where
+                                    the access latency prevents the guest from
+                                    booting.  This quirk can likely be disabled
+                                    if the above do not hold true.
+
+                                    Note, KVM always honors guest PAT on AMD
+                                    CPUs when TDP (NPT) is enabled.  KVM never
+                                    honors guest PAT when TDP is disabled.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a884ab544335..427b906da5cc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2409,7 +2409,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
 	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
 	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
-	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS)
+	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS |	\
+	 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT)
 
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 460306b35a4b..074e2b74e68c 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -441,6 +441,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
+#define KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT	(1 << 9)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 050a0e229a4d..639264635a1a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -231,7 +231,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-bool kvm_mmu_may_ignore_guest_pat(void);
+bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63bb77ee1bb1..16c64e80d946 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4835,18 +4835,27 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 }
 #endif
 
-bool kvm_mmu_may_ignore_guest_pat(void)
+bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)
 {
 	/*
-	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
+	 * When EPT is enabled (shadow_memtype_mask is non-zero), the CPU does
+	 * not support self-snoop (or is affected by an erratum), and the VM
 	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
 	 * honor the memtype from the guest's PAT so that guest accesses to
 	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
 	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
-	 * KVM _always_ ignores guest PAT (when EPT is enabled).
+	 * KVM _always_ ignores or honors guest PAT, i.e. doesn't toggle SPTE
+	 * bits in response to non-coherent device (un)registration.
+	 *
+	 * Due to an unfortunate confluence of slow hardware, suboptimal guest
+	 * drivers, and historical use cases, honoring self-snoop and guest PAT
+	 * is also buried behind a quirk.
 	 */
-	return shadow_memtype_mask;
+	return (!static_cpu_has(X86_FEATURE_SELFSNOOP) ||
+		kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT)) &&
+	       shadow_memtype_mask;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_may_ignore_guest_pat);
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b70ed72c1783..734db162cab3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7730,11 +7730,14 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 	/*
 	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
-	 * device attached.  Letting the guest control memory types on Intel
-	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
-	 * the guest to behave only as a last resort.
+	 * device attached, and either the CPU doesn't support self-snoop or
+	 * KVM's quirk to ignore guest PAT is enabled.  Letting the guest
+	 * control memory types on Intel CPUs without self-snoop may result in
+	 * unexpected behavior, and so KVM's (historical) ABI is to trust the
+	 * guest to behave only as a last resort.
 	 */
-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+	if (kvm_mmu_may_ignore_guest_pat(vcpu->kvm) &&
+	    !kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
 	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c841817a914a..4a94eb974f0d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13528,7 +13528,7 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
 	 * (or last) non-coherent device is (un)registered to so that new SPTEs
 	 * with the correct "ignore guest PAT" setting are created.
 	 */
-	if (kvm_mmu_may_ignore_guest_pat())
+	if (kvm_mmu_may_ignore_guest_pat(kvm))
 		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 

base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.504.g3bcea36a83-goog


