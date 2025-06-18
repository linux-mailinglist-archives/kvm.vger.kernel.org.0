Return-Path: <kvm+bounces-49794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC76ADE266
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F38217C1DE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3092E1E572F;
	Wed, 18 Jun 2025 04:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vVAiBVq4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D04E1FBE80
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220674; cv=none; b=P7hF/YjfgYAvEBYNUljBBGN1nWrtJMks56yS5VkLNo2c2lngELGP+kqm7IcXXr8jNrBYKL6XUhA0kegNaDTT7BAb67/L0svehNxQ56JgSM1S70nQjFkvxL/ZEgx+f1h9FErJv/XTGJczp6Mtmii/WHdBzqYyCGdmabpwGNwGjcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220674; c=relaxed/simple;
	bh=gpLnCbZ2QT66InCL+IQSfKdjaE0VlJUfUrY2ZyIBHpg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KDbX2FxgoR9G8+XhLNOA+/kEbQbU3yok1JHyMPtx1bF2U277jFBZ12OGa4UbUp0L1WvV/qXZDCU4JmLILxIoKDHkgPnaejeiy0KDyUGtGU6+OHxIw9wI6SMDuKsWymr1gFLeKGB4+ttM07mnMZehC+Lmnh/58WC5jakNMpwlb3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vVAiBVq4; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74858256d38so4784755b3a.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220672; x=1750825472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lAANK9EatRgM8qlVuTkHcUTTaZtpLq75H6hzaPLeuxs=;
        b=vVAiBVq4vJGNSUub2iHTye3iyJpCCkYUDRUkhWRuiWXy0btu+g7EMixIKESLACZ5qC
         iS1vAZGtXmylB+1CpuIqnDseU53cC/dzzQwdWIwHvlNi8b9WNjH562+Ox07JHzrQR4v9
         3ZtN+y6gddn4BFb85Rr+ir0fC4jcIVQGQq/xhoF4NkpMBphZRxNroSo4bSLZQt1hvVrk
         ss0s0QGFv+m6Okg+8oIc8kGYypBocc+JP8YP6QOpY+kDz4ELxUDGsS0gHSv+xZe/o63y
         wOLXQftXA5pyLnTjA0GA1JXFBdNs45PYHLAr/0noFJjMI+45NGySFYcniyxwCip3a6P+
         YXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220672; x=1750825472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAANK9EatRgM8qlVuTkHcUTTaZtpLq75H6hzaPLeuxs=;
        b=iFI/Mh5LReDhXFV5sKtsWCzToOqrt8mbae9syRcwoioz4e23sIfzzs4QfR1aV/trdr
         TCXXMMMUaAxIVYWJ2DC1WmKe9+1WSe5g59x+GYG5pVaEHSF2apPj8BOzu/2YHny+YgV0
         LSByc6mgrc4JJ3ndsOCbxm0squpHtJSfu6DvFokcBnrs378J9gQngYH8nB/+to/2QdIE
         sCHhxI3KHmDqXsHxYGO4cjgCrM6kvRV1fJjP7sMP/0RwOEiRe/7TXTl6AvdtP/UzleD/
         io9395Me/jUwhZT3Ytx4soguUtIF/PDzkdWLddQR0ezbkrV9ea3xW2peKTie0ABowWul
         1gNA==
X-Forwarded-Encrypted: i=1; AJvYcCVEz2zs4ci5dz4KUuEN1tX2mvN/h7MuLgKqk2qEPbSltkjYiRoX4zka28hVv6b8/QynpDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrGrYNplpS3aaqTqd3gnMuncsR7gjSNXzEP0uB1YWBEnEHaokX
	TtdLk45qANPEly5UGMmYPKos5CWtxdvAx/dIb0ddggyU/CP+2Axu7OOQyCDigFkWhTuR4sDvEAz
	7noW2gYX6v/ltAFo4iT6ktg==
X-Google-Smtp-Source: AGHT+IGfw/fuYp0YvoE+rn33nARlIYiN3aa5M590yzdjQSAaiecYqF5p0spxRmCeRQgOGDvJLrq4ZeRSCV3QEL3v
X-Received: from pfjw27.prod.google.com ([2002:aa7:9a1b:0:b0:748:de42:3b4])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a86:b0:732:2923:b70f with SMTP id d2e1a72fcca58-7489d00631fmr17847993b3a.11.1750220671791;
 Tue, 17 Jun 2025 21:24:31 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:12 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-4-jthoughton@google.com>
Subject: [PATCH v3 03/15] KVM: arm64: x86: Require "struct kvm_page_fault" for
 memory fault exits
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Now that both arm64 and x86 define "struct kvm_page_fault" with a base set
of fields, rework kvm_prepare_memory_fault_exit() to take a kvm_page_fault
structure instead of passing in a pile of parameters.  Guard the related
code with CONFIG_KVM_GENERIC_PAGE_FAULT to play nice with architectures
that don't yet support kvm_page_fault.

Rather than define a common kvm_page_fault and kvm_arch_page_fault child,
simply assert that the handful of required fields are provided by the
arch-defined structure.  Unlike vCPU and VMs, the number of common fields
is expected to be small, and letting arch code fully define the structure
allows for maximum flexibility with respect to const, layout, etc.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/Kconfig          |  1 +
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          |  8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h | 10 +---------
 include/linux/kvm_host.h        | 26 ++++++++++++++++++++------
 virt/kvm/Kconfig                |  3 +++
 6 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 713248f240e03..3c299735b1668 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GENERIC_PAGE_FAULT
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2eeffcec53828..2d5966f15738d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -48,6 +48,7 @@ config KVM_X86
 	select KVM_GENERIC_PRE_FAULT_MEMORY
 	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
 	select KVM_WERROR if WERROR
+	select KVM_GENERIC_PAGE_FAULT
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e3..a4439e9e07268 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3429,7 +3429,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
 	if (fault->is_private) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		kvm_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
 
@@ -4499,14 +4499,14 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	int max_order, r;
 
 	if (!kvm_slot_can_be_private(fault->slot)) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		kvm_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
 			     &fault->refcounted_page, &max_order);
 	if (r) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		kvm_prepare_memory_fault_exit(vcpu, fault);
 		return r;
 	}
 
@@ -4586,7 +4586,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * private vs. shared mismatch.
 	 */
 	if (fault->is_private != kvm_mem_is_private(kvm, fault->gfn)) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		kvm_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 384fc4d0bfec0..c15060ed6e8be 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -269,14 +269,6 @@ enum {
  */
 static_assert(RET_PF_CONTINUE == 0);
 
-static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
-						     struct kvm_page_fault *fault)
-{
-	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
-				      PAGE_SIZE, fault->write, fault->exec,
-				      fault->is_private);
-}
-
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u64 err, bool prefetch,
 					int *emulation_type, u8 *level)
@@ -329,7 +321,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 */
 	if (r == RET_PF_EMULATE && fault.is_private) {
 		pr_warn_ratelimited("kvm: unexpected emulation request on private memory\n");
-		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
+		kvm_prepare_memory_fault_exit(vcpu, &fault);
 		return -EFAULT;
 	}
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bde4fb5c6aa4..9a85500cd5c50 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2497,20 +2497,34 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
+
+#define KVM_ASSERT_TYPE_IS(type_t, x)					\
+do {									\
+	type_t __maybe_unused tmp;					\
+									\
+	BUILD_BUG_ON(!__types_ok(tmp, x) || !__typecheck(tmp, x));	\
+} while (0)
+
 static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
-						 gpa_t gpa, gpa_t size,
-						 bool is_write, bool is_exec,
-						 bool is_private)
+						 struct kvm_page_fault *fault)
 {
+	KVM_ASSERT_TYPE_IS(gfn_t, fault->gfn);
+	KVM_ASSERT_TYPE_IS(bool, fault->exec);
+	KVM_ASSERT_TYPE_IS(bool, fault->write);
+	KVM_ASSERT_TYPE_IS(bool, fault->is_private);
+	KVM_ASSERT_TYPE_IS(struct kvm_memory_slot *, fault->slot);
+
 	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
-	vcpu->run->memory_fault.gpa = gpa;
-	vcpu->run->memory_fault.size = size;
+	vcpu->run->memory_fault.gpa = fault->gfn << PAGE_SHIFT;
+	vcpu->run->memory_fault.size = PAGE_SIZE;
 
 	/* RWX flags are not (yet) defined or communicated to userspace. */
 	vcpu->run->memory_fault.flags = 0;
-	if (is_private)
+	if (fault->is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
+#endif
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 727b542074e7e..28ed6b241578b 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -128,3 +128,6 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config KVM_GENERIC_PAGE_FAULT
+       bool
-- 
2.50.0.rc2.692.g299adb8693-goog


