Return-Path: <kvm+bounces-45672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E148AAAD206
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 02:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B35F01C0621E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 00:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6588C0E;
	Wed,  7 May 2025 00:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cZdPoVQk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E056710E9
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 00:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746576793; cv=none; b=KK4jYr4jLk6ybBf/gTZfYxS8e4Cbp11+rh6M2gFPPruEhzCBXqyInR1jNnup0QAoIdBIsswGNzD4a8vrwVDmNZkoeoYd81lAsZqW4rYZUHmUPBfcT/da9rGoCDJCbcn4GmLJV/OHJjpIS57KjVzBOKxj547PcxFsZMfhI7IXemg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746576793; c=relaxed/simple;
	bh=qKvqEbwtRbi9wHZGmWXWOl5YudfnKg2LzHt0BcdaEMI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g2fQlyFKLgALYlrHU2PnzL0b/yG7LX7Er8w1853tFPtcU1ehD6tvy2ACi5ygduIyMGmTr9mJhomtg3K457d/QSt2eVeyD66qUz7DtxneQTgIzkG22s6a+YFFoFPkQV3r5xHvDaGz1KavuEHH5LF0VU6PebSrMTj824h1rPfnscQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cZdPoVQk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff798e8c3bso5514043a91.2
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 17:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746576789; x=1747181589; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8AEXHyrkAExWXLqI9q43DyKxswKZwwkPBKKs2VsIHls=;
        b=cZdPoVQkyn5HyoNWpuG3w3IWnwZT/66+bHNzxwbQ+lKo2ugzlN7XuCypKt3HWB5qyw
         SfxQlEp0SbAu+FQI6ryGxCXGb2O+nQ6tLhknyOwOu7oi0CL/fpcyG+VRebEsg+oCTsqv
         /YVprecPcDfdhc6LR+lE/OawJELNfgAZP3249vVq9ZbDUNUDY6ONgIA9TQPYGfSRSJNx
         SbQ5an9nC/D78jYvVTpl8BFBadXhC06ojowip34lX7iXxz8vNCfjFYrIfZxk9CRiWdBo
         d67a/DY2+lmPPMoAw6ZK6QPn/lKove34S/GTrARlA6mpBlZ+YS+li6unb3xhDD44YPJW
         nghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746576789; x=1747181589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8AEXHyrkAExWXLqI9q43DyKxswKZwwkPBKKs2VsIHls=;
        b=dvBzvJdrFLBN3BFtH/vXJgGJoEVXhEp4ew7Jd5macJTqjGMeNZqXAHiiGOo2gC7/Y2
         BA1lF3Skq5lZCj5+l87/FIQ6i4/b6Gtz8XhlqeoEy2azl48m30Zpp7azraMhdFOY+WmE
         1BhEVOfnFpEEyzYV0Vvfgr6z/blktu7MG134AvPKr5J9OGoTQvX/038beXZJi6aJZJu1
         4+LgPvA28WcOK0QkvLwZjpag5ZuwDZivq+5d7thrUVNSatmTD/lFEDZeQbCdilLvDiEr
         XwCVds36llpDAWW90TNiRr4YNwDts6EudlnRgVk/JJf8MRyXqOkuKLaumjonlNpf3e4I
         X3tQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0Euy0EzrRyVsWiA/AU15+3t+Z78s4mZG5re73MoVAFOa3d3gXhIzESY9JuNPUsLrYyGE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8OHM34YIbzXaqRgJ3hWtVlOUgYNAJUsvfVFrjtBaikG6H0/+z
	ghoTG1mUPqrweEQpy4vVIP5lDUbOaWQTm6aWhzrj0FcESl9bjjcJC0VStrl74N/C6GEsIz0s8ld
	M4A==
X-Google-Smtp-Source: AGHT+IEOUQQdmLw906gZKGxSBTt5PLtPd2DWzmnQ5Wt08DegeJwBCJW/x3cIhR6jYsbHM8SGLMc2AwyKBp0=
X-Received: from pjbdb5.prod.google.com ([2002:a17:90a:d645:b0:2fa:1803:2f9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d607:b0:305:2d68:8d55
 with SMTP id 98e67ed59e1d1-30aac16e23fmr2146161a91.8.1746576789182; Tue, 06
 May 2025 17:13:09 -0700 (PDT)
Date: Tue, 6 May 2025 17:13:07 -0700
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
Message-ID: <aBqlkz1bqhu-9toV@google.com>
Subject: Re: [PATCH v2 00/13] KVM: Introduce KVM Userfault
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: multipart/mixed; charset="UTF-8"; boundary="Viq7rgPFWdewsyKO"


--Viq7rgPFWdewsyKO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2025, James Houghton wrote:
>   KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
>   KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
>   KVM: Allow late setting of KVM_MEM_USERFAULT on guest_memfd memslot
>   KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
>   KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
>   KVM: arm64: Add support for KVM_MEM_USERFAULT
>   KVM: selftests: Fix vm_mem_region_set_flags docstring
>   KVM: selftests: Fix prefault_mem logic
>   KVM: selftests: Add va_start/end into uffd_desc
>   KVM: selftests: Add KVM Userfault mode to demand_paging_test
>   KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
>   KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd toggle tests
>   KVM: Documentation: Add KVM_CAP_USERFAULT and KVM_MEM_USERFAULT
>     details
> 
>  Documentation/virt/kvm/api.rst                |  33 +++-
>  arch/arm64/kvm/Kconfig                        |   1 +
>  arch/arm64/kvm/mmu.c                          |  26 +++-
>  arch/x86/kvm/Kconfig                          |   1 +
>  arch/x86/kvm/mmu/mmu.c                        |  27 +++-
>  arch/x86/kvm/mmu/mmu_internal.h               |  20 ++-
>  arch/x86/kvm/x86.c                            |  36 +++--
>  include/linux/kvm_host.h                      |  19 ++-
>  include/uapi/linux/kvm.h                      |   6 +-
>  .../selftests/kvm/demand_paging_test.c        | 145 ++++++++++++++++--
>  .../testing/selftests/kvm/include/kvm_util.h  |   5 +
>  .../selftests/kvm/include/userfaultfd_util.h  |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  42 ++++-
>  .../selftests/kvm/lib/userfaultfd_util.c      |   2 +
>  .../selftests/kvm/set_memory_region_test.c    |  33 ++++
>  virt/kvm/Kconfig                              |   3 +
>  virt/kvm/kvm_main.c                           |  54 ++++++-
>  17 files changed, 419 insertions(+), 36 deletions(-)

I didn't look at the selftests changes, but nothing in this series scares me.  We
bikeshedded most of this death this in the "exit on missing" series, so for me at
least, the only real question is whether or not we want to add the uAPI.  AFAIK,
this is best proposal for post-copy guest_memfd support (and not just because it's
the only proposal :-D).

So... yes?

Attached are a variation on the series using the common "struct kvm_page_fault"
idea.  The documentation change could be squashed with the final enablement patch.

Compile tested only.  I would not be the least bit surprised if I completely
butchered something.

--Viq7rgPFWdewsyKO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Move-struct-kvm_page_fault-definition-to.patch"

From 763674ca414c8d54f914b21b9d86ba6bb304d294 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 6 May 2025 14:40:54 -0700
Subject: [PATCH 1/7] KVM: x86/mmu: Move "struct kvm_page_fault" definition to
 asm/kvm_host.h

Make "struct kvm_page_fault" globally visible via asm/kvm_host.h so that
the structure can be referenced by common KVM.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 68 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h | 67 --------------------------------
 2 files changed, 67 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c27f213ea55..ae61a4687d38 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -443,7 +443,73 @@ struct kvm_mmu_root_info {
 #define KVM_HAVE_MMU_RWLOCK
 
 struct kvm_mmu_page;
-struct kvm_page_fault;
+
+struct kvm_page_fault {
+	/* arguments to kvm_mmu_do_page_fault.  */
+	const gpa_t addr;
+	const u64 error_code;
+	const bool prefetch;
+
+	/* Derived from error_code.  */
+	const bool exec;
+	const bool write;
+	const bool present;
+	const bool rsvd;
+	const bool user;
+
+	/* Derived from mmu and global state.  */
+	const bool is_tdp;
+	const bool is_private;
+	const bool nx_huge_page_workaround_enabled;
+
+	/*
+	 * Whether a >4KB mapping can be created or is forbidden due to NX
+	 * hugepages.
+	 */
+	bool huge_page_disallowed;
+
+	/*
+	 * Maximum page size that can be created for this fault; input to
+	 * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
+	 */
+	u8 max_level;
+
+	/*
+	 * Page size that can be created based on the max_level and the
+	 * page size used by the host mapping.
+	 */
+	u8 req_level;
+
+	/*
+	 * Page size that will be created based on the req_level and
+	 * huge_page_disallowed.
+	 */
+	u8 goal_level;
+
+	/*
+	 * Shifted addr, or result of guest page table walk if addr is a gva. In
+	 * the case of VM where memslot's can be mapped at multiple GPA aliases
+	 * (i.e. TDX), the gfn field does not contain the bit that selects between
+	 * the aliases (i.e. the shared bit for TDX).
+	 */
+	gfn_t gfn;
+
+	/* The memslot containing gfn. May be NULL. */
+	struct kvm_memory_slot *slot;
+
+	/* Outputs of kvm_mmu_faultin_pfn().  */
+	unsigned long mmu_seq;
+	kvm_pfn_t pfn;
+	struct page *refcounted_page;
+	bool map_writable;
+
+	/*
+	 * Indicates the guest is trying to write a gfn that contains one or
+	 * more of the PTEs used to translate the write itself, i.e. the access
+	 * is changing its own translation in the guest page tables.
+	 */
+	bool write_fault_to_shadow_pgtable;
+};
 
 /*
  * x86 supports 4 paging modes (5-level 64-bit, 4-level 64-bit, 3-level 32-bit,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de62..384fc4d0bfec 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -230,73 +230,6 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
 }
 
-struct kvm_page_fault {
-	/* arguments to kvm_mmu_do_page_fault.  */
-	const gpa_t addr;
-	const u64 error_code;
-	const bool prefetch;
-
-	/* Derived from error_code.  */
-	const bool exec;
-	const bool write;
-	const bool present;
-	const bool rsvd;
-	const bool user;
-
-	/* Derived from mmu and global state.  */
-	const bool is_tdp;
-	const bool is_private;
-	const bool nx_huge_page_workaround_enabled;
-
-	/*
-	 * Whether a >4KB mapping can be created or is forbidden due to NX
-	 * hugepages.
-	 */
-	bool huge_page_disallowed;
-
-	/*
-	 * Maximum page size that can be created for this fault; input to
-	 * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
-	 */
-	u8 max_level;
-
-	/*
-	 * Page size that can be created based on the max_level and the
-	 * page size used by the host mapping.
-	 */
-	u8 req_level;
-
-	/*
-	 * Page size that will be created based on the req_level and
-	 * huge_page_disallowed.
-	 */
-	u8 goal_level;
-
-	/*
-	 * Shifted addr, or result of guest page table walk if addr is a gva. In
-	 * the case of VM where memslot's can be mapped at multiple GPA aliases
-	 * (i.e. TDX), the gfn field does not contain the bit that selects between
-	 * the aliases (i.e. the shared bit for TDX).
-	 */
-	gfn_t gfn;
-
-	/* The memslot containing gfn. May be NULL. */
-	struct kvm_memory_slot *slot;
-
-	/* Outputs of kvm_mmu_faultin_pfn().  */
-	unsigned long mmu_seq;
-	kvm_pfn_t pfn;
-	struct page *refcounted_page;
-	bool map_writable;
-
-	/*
-	 * Indicates the guest is trying to write a gfn that contains one or
-	 * more of the PTEs used to translate the write itself, i.e. the access
-	 * is changing its own translation in the guest page tables.
-	 */
-	bool write_fault_to_shadow_pgtable;
-};
-
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 /*

base-commit: 94da2b969670d100730b5537f20523e49e989920
-- 
2.49.0.967.g6a0df3ecc3-goog


--Viq7rgPFWdewsyKO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-arm64-Add-struct-kvm_page_fault-to-gather-common.patch"

From 20b0bb4681a05d36c52fce90c932cd239b604d42 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 6 May 2025 14:43:11 -0700
Subject: [PATCH 2/7] KVM: arm64: Add "struct kvm_page_fault" to gather common
 fault variables

Introduce "struct kvm_page_fault" and use it in user_mem_abort() in lieu
of a collection of local variables.  Providing "struct kvm_page_fault"
will allow common KVM to provide APIs to take in said structure, e.g. when
preparing memory fault exits.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  9 +++++++++
 arch/arm64/kvm/mmu.c              | 32 +++++++++++++++++--------------
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 08ba91e6fb03..50a04b86baaa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -403,6 +403,15 @@ struct kvm_vcpu_fault_info {
 	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
+struct kvm_page_fault {
+	const bool exec;
+	const bool write;
+	const bool is_private;
+
+	gfn_t gfn;
+	struct kvm_memory_slot *slot;
+};
+
 /*
  * VNCR() just places the VNCR_capable registers in the enum after
  * __VNCR_START__, and the value (after correction) to be an 8-byte offset
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 754f2fe0cc67..c5d21bcfa3ed 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1472,8 +1472,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  bool fault_is_perm)
 {
 	int ret = 0;
-	bool write_fault, writable, force_pte = false;
-	bool exec_fault, mte_allowed;
+	bool writable, force_pte = false;
+	bool mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
@@ -1481,7 +1481,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct vm_area_struct *vma;
 	short vma_shift;
 	void *memcache;
-	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	long vma_pagesize, fault_granule;
@@ -1490,13 +1489,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct page *page;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 
+	struct kvm_page_fault fault = {
+		.write = kvm_is_write_fault(vcpu),
+		.exec = kvm_vcpu_trap_is_exec_fault(vcpu),
+
+		.slot = memslot,
+	};
+
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
-	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
-	VM_BUG_ON(write_fault && exec_fault);
+	VM_BUG_ON(fault.write && fault.exec);
 
-	if (fault_is_perm && !write_fault && !exec_fault) {
+	if (fault_is_perm && !fault.write && !fault.exec) {
 		kvm_err("Unexpected L2 read permission error\n");
 		return -EFAULT;
 	}
@@ -1507,7 +1511,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	if (!fault_is_perm || (logging_active && write_fault)) {
+	if (!fault_is_perm || (logging_active && fault.write)) {
 		int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
 
 		if (!is_protected_kvm_enabled()) {
@@ -1607,7 +1611,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		ipa &= ~(vma_pagesize - 1);
 	}
 
-	gfn = ipa >> PAGE_SHIFT;
+	fault.gfn = ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
@@ -1626,7 +1630,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
-	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+	pfn = __kvm_faultin_pfn(memslot, fault.gfn, fault.write ? FOLL_WRITE : 0,
 				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
@@ -1647,7 +1651,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * change things at the last minute.
 		 */
 		device = true;
-	} else if (logging_active && !write_fault) {
+	} else if (logging_active && !fault.write) {
 		/*
 		 * Only actually map the page as writable if this was a write
 		 * fault.
@@ -1655,7 +1659,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		writable = false;
 	}
 
-	if (exec_fault && device)
+	if (fault.exec && device)
 		return -ENOEXEC;
 
 	/*
@@ -1715,7 +1719,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
-	if (exec_fault)
+	if (fault.exec)
 		prot |= KVM_PGTABLE_PROT_X;
 
 	if (device) {
@@ -1752,7 +1756,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret)
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+		mark_page_dirty_in_slot(kvm, memslot, fault.gfn);
 
 	return ret != -EAGAIN ? ret : 0;
 }
-- 
2.49.0.967.g6a0df3ecc3-goog


--Viq7rgPFWdewsyKO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-arm64-x86-Require-struct-kvm_page_fault-for-memo.patch"

From 44ec300f1e47fce3ac3893d5fbd8834705db8d58 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 6 May 2025 14:49:12 -0700
Subject: [PATCH 3/7] KVM: arm64: x86: Require "struct kvm_page_fault" for
 memory fault exits

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
---
 arch/arm64/kvm/Kconfig          |  1 +
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          |  8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h | 10 +---------
 include/linux/kvm_host.h        | 26 ++++++++++++++++++++------
 virt/kvm/Kconfig                |  3 +++
 6 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 096e45acadb2..35b18f77afc4 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ menuconfig KVM
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select KVM_GENERIC_PAGE_FAULT
 	help
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2eeffcec5382..2d5966f15738 100644
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
index cbc84c6abc2e..a4439e9e0726 100644
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
index 384fc4d0bfec..c15060ed6e8b 100644
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
index c685fb417e92..adece3cbfb02 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2493,20 +2493,34 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
+
+#define KVM_ASSERT_TYPE_IS(type_t, x)					\
+do {									\
+	type_t __maybe_unused tmp;					\
+									\
+	BUILD_BUG_ON(!__types_ok(tmp, x) || !__typecheck(tmp, x));	\
+}while (0)
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
index 727b542074e7..28ed6b241578 100644
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
2.49.0.967.g6a0df3ecc3-goog


--Viq7rgPFWdewsyKO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-KVM-Add-common-infrastructure-for-KVM-Userfaults.patch"

From 3fe5acc137b6b3ec7b87dcd266084f0072db934a Mon Sep 17 00:00:00 2001
From: James Houghton <jthoughton@google.com>
Date: Tue, 6 May 2025 15:35:24 -0700
Subject: [PATCH 4/7] KVM: Add common infrastructure for KVM Userfaults

<to be written by James>

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  9 +++++++
 include/uapi/linux/kvm.h |  5 +++-
 virt/kvm/kvm_main.c      | 52 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index adece3cbfb02..73e6ec4eae78 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -597,6 +597,7 @@ struct kvm_memory_slot {
 	unsigned long *dirty_bitmap;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
+	unsigned long __user *userfault_bitmap;
 	u32 flags;
 	short id;
 	u16 as_id;
@@ -2520,6 +2521,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 	if (fault->is_private)
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
+
+bool kvm_do_userfault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+
+static inline bool kvm_is_userfault_memslot(struct kvm_memory_slot *memslot)
+{
+	return memslot && memslot->flags & KVM_MEM_USERFAULT;
+}
+
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c6988e2c68d5..af1fc86ddbe0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -40,7 +40,8 @@ struct kvm_userspace_memory_region2 {
 	__u64 guest_memfd_offset;
 	__u32 guest_memfd;
 	__u32 pad1;
-	__u64 pad2[14];
+	__u64 userfault_bitmap;
+	__u64 pad2[13];
 };
 
 /*
@@ -51,6 +52,7 @@ struct kvm_userspace_memory_region2 {
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
 #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
+#define KVM_MEM_USERFAULT	(1UL << 3)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -443,6 +445,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_USERFAULT	(1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 16fe54cf2808..ca08075a9b7b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1688,6 +1688,15 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		if (old->dirty_bitmap && !new->dirty_bitmap)
 			kvm_destroy_dirty_bitmap(old);
 
+		/*
+		 * If userfault is being enabled for the slot, assume userspace
+		 * wants to intercept the majority of accesses, and simply drop
+		 * all stage-2 mappings for the slot.
+		 */
+		if (!(old_flags & KVM_MEM_USERFAULT) &&
+		    (new_flags & KVM_MEM_USERFAULT))
+			kvm_arch_flush_shadow_memslot(kvm, old);
+
 		/*
 		 * The final quirk.  Free the detached, old slot, but only its
 		 * memory, not any metadata.  Metadata, including arch specific
@@ -1980,6 +1989,12 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	if (id < KVM_USER_MEM_SLOTS &&
 	    (mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
+	if (mem->flags & KVM_MEM_USERFAULT &&
+	    ((mem->userfault_bitmap != untagged_addr(mem->userfault_bitmap)) ||
+	     !access_ok((void __user *)(unsigned long)mem->userfault_bitmap,
+			DIV_ROUND_UP(mem->memory_size >> PAGE_SHIFT, BITS_PER_LONG)
+			 * sizeof(long))))
+		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
 
@@ -2012,14 +2027,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		/* Private memslots are immutable, they can only be deleted. */
-		if (mem->flags & KVM_MEM_GUEST_MEMFD)
-			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
 		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
 			return -EINVAL;
 
+		/* Moving a guest_memfd memslot isn't supported. */
+		if (base_gfn != old->base_gfn && mem->flags & KVM_MEM_GUEST_MEMFD)
+			return -EINVAL;
+
 		if (base_gfn != old->base_gfn)
 			change = KVM_MR_MOVE;
 		else if (mem->flags != old->flags)
@@ -2043,11 +2059,13 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
-	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+	if (mem->flags & KVM_MEM_GUEST_MEMFD && change == KVM_MR_CREATE) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
 			goto out;
 	}
+	if (mem->flags & KVM_MEM_USERFAULT)
+		new->userfault_bitmap = u64_to_user_ptr(mem->userfault_bitmap);
 
 	r = kvm_set_memslot(kvm, old, new, change);
 	if (r)
@@ -4921,6 +4939,32 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
 	return cleared;
 }
 
+#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
+bool kvm_do_userfault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	struct kvm_memory_slot *slot = fault->slot;
+	unsigned long __user *user_chunk;
+	unsigned long chunk;
+	gfn_t offset;
+
+	if (!kvm_is_userfault_memslot(slot))
+		return false;
+
+	offset = fault->gfn - slot->base_gfn;
+	user_chunk = slot->userfault_bitmap + (offset / BITS_PER_LONG);
+
+	if (__get_user(chunk, user_chunk))
+		return true;
+
+	if (!test_bit(offset % BITS_PER_LONG, &chunk))
+		return false;
+
+	kvm_prepare_memory_fault_exit(vcpu, fault);
+	vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_USERFAULT;
+	return true;
+}
+#endif
+
 int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 						  struct kvm_enable_cap *cap)
 {
-- 
2.49.0.967.g6a0df3ecc3-goog


--Viq7rgPFWdewsyKO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0005-KVM-x86-Add-support-for-KVM-userfault-exits.patch"

From e8cf843428aadfcec342f5e84ba4fd6ad7f16aa1 Mon Sep 17 00:00:00 2001
From: James Houghton <jthoughton@google.com>
Date: Tue, 6 May 2025 15:37:14 -0700
Subject: [PATCH 5/7] KVM: x86: Add support for KVM userfault exits

<to be written by James>

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c |  5 ++++-
 arch/x86/kvm/x86.c     | 27 +++++++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a4439e9e0726..49eb6b9b268c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3304,7 +3304,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_error_noslot_pfn(fault->pfn))
 		return;
 
-	if (kvm_slot_dirty_track_enabled(slot))
+	if (kvm_slot_dirty_track_enabled(slot) || kvm_is_userfault_memslot(slot))
 		return;
 
 	/*
@@ -4522,6 +4522,9 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
+	if (kvm_do_userfault(vcpu, fault))
+		return -EFAULT;
+
 	if (fault->is_private)
 		return kvm_mmu_faultin_pfn_private(vcpu, fault);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75c0a934556d..4f9edda47782 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13150,12 +13150,27 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	u32 new_flags = new ? new->flags : 0;
 	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
+	/*
+	 * Recover hugepages when userfault is toggled off, as KVM forces 4KiB
+	 * mappings when userfault is enabled.  See below for why CREATE, MOVE,
+	 * and DELETE don't need special handling.  Note, common KVM handles
+	 * zapping SPTEs when userfault is toggled on.
+	 */
+	if (change == KVM_MR_FLAGS_ONLY && (old_flags & KVM_MEM_USERFAULT) &&
+	    !(new_flags & KVM_MEM_USERFAULT))
+		kvm_mmu_recover_huge_pages(kvm, new);
+
+	/*
+	 * Nothing more to do if dirty logging isn't being toggled.
+	 */
+	if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
+
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
 	 */
-	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)
-		kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
+	kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
 
 	/*
 	 * Nothing more to do for RO slots (which can't be dirtied and can't be
@@ -13175,14 +13190,6 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	if ((change != KVM_MR_FLAGS_ONLY) || (new_flags & KVM_MEM_READONLY))
 		return;
 
-	/*
-	 * READONLY and non-flags changes were filtered out above, and the only
-	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
-	 * logging isn't being toggled on or off.
-	 */
-	if (WARN_ON_ONCE(!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)))
-		return;
-
 	if (!log_dirty_pages) {
 		/*
 		 * Recover huge page mappings in the slot now that dirty logging
-- 
2.49.0.967.g6a0df3ecc3-goog


--Viq7rgPFWdewsyKO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0006-KVM-arm64-Add-support-for-KVM-userfault-exits.patch"

From b9300a363d5517098bde6c97b8292a71092aa455 Mon Sep 17 00:00:00 2001
From: James Houghton <jthoughton@google.com>
Date: Tue, 6 May 2025 15:38:31 -0700
Subject: [PATCH 6/7] KVM: arm64: Add support for KVM userfault exits

<to be written by James>

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c5d21bcfa3ed..5e2ccde66f43 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1541,7 +1541,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active || is_protected_kvm_enabled()) {
+	if (logging_active || is_protected_kvm_enabled() ||
+	    kvm_is_userfault_memslot(memslot)) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1630,6 +1631,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	if (kvm_do_userfault(vcpu, &fault))
+		return -EFAULT;
+
 	pfn = __kvm_faultin_pfn(memslot, fault.gfn, fault.write ? FOLL_WRITE : 0,
 				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
@@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 old_flags = old ? old->flags : 0;
+	u32 new_flags = new ? new->flags : 0;
+
+	/* Nothing to do if not toggling dirty logging. */
+	if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
 
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (log_dirty_pages) {
+	if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
 
 		if (change == KVM_MR_DELETE)
 			return;
-- 
2.49.0.967.g6a0df3ecc3-goog


--Viq7rgPFWdewsyKO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0007-KVM-Enable-and-advertise-support-for-KVM-userfault-e.patch"

From 81b07458648d57cb532b64178dcfd2aeba81db95 Mon Sep 17 00:00:00 2001
From: James Houghton <jthoughton@google.com>
Date: Tue, 6 May 2025 15:40:57 -0700
Subject: [PATCH 7/7] KVM: Enable and advertise support for KVM userfault exits

Now that all architectures (arm64 and x86) that utilize "generic" page
faults also support userfault exits, advertise support for
KVM_CAP_USERFAULT and let userspace set KVM_MEM_USERFAULT in memslots.

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 virt/kvm/kvm_main.c      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index af1fc86ddbe0..262e2bde9b3b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -934,6 +934,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_USERFAULT 240
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ca08075a9b7b..c3384847dd5b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1545,6 +1545,9 @@ static int check_memory_region_flags(struct kvm *kvm,
 	    !(mem->flags & KVM_MEM_GUEST_MEMFD))
 		valid_flags |= KVM_MEM_READONLY;
 
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PAGE_FAULT))
+		valid_flags |= KVM_MEM_USERFAULT;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -4823,6 +4826,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
 	case KVM_CAP_HALT_POLL:
+#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
+	case KVM_CAP_USERFAULT:
+#endif
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
-- 
2.49.0.967.g6a0df3ecc3-goog


--Viq7rgPFWdewsyKO--

