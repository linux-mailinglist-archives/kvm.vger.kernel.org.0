Return-Path: <kvm+bounces-17404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE608C5E90
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 187CBB22370
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73F5376EB;
	Wed, 15 May 2024 01:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TnRe3VTF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9801EEE3;
	Wed, 15 May 2024 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734812; cv=none; b=VHcGs0Vfh7PKv1cekngrzuYVEjPr2qXlk5TeFjQeUY5EaRqNWwpuNfJRZpyAnEIjNkTWgj3PQKBAogqKW4Oyum3UCLdA1L/PllAQCbwaB4gpbjfQLMqMXaSOipJrktgD3icBUx08XuYh4w5M6J5BVr1o2gfUwPIedH4tgGbkL3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734812; c=relaxed/simple;
	bh=ZhLlZRSc1N8HWBGh0Hwv4AHosc/nMbevb/CrbuiWxcc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XkTOpelE2FXTVl+QWHOX+gibbz3I0xXcUeBaa/YIqeVaFl2FA3ahUHhvanrOX+3ml8Os1RlY0klOv5bD6BTfpEYthfrVQQGUdZNSl5D2NvxfB4z6X7G92FA5PyfeRHBSSsNwc8w1H7HGB73llZ/kIK595v9AQth4fdNFb3UeH5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TnRe3VTF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734809; x=1747270809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZhLlZRSc1N8HWBGh0Hwv4AHosc/nMbevb/CrbuiWxcc=;
  b=TnRe3VTF/zs7alAOsZK9NV7y9HuQk5Z011VFxNlPpjD4hTcIHRGbK7m5
   w1GpO7dJKKFj3HYX1zDL4sUvtUIoh2UAcm0ZjkquZZ4J3P+NhZLwqTe+F
   roNNP6sp+Y8+B9o7OUkpGMnz9jKeMXU89ZsTeKfSG6JdyxuF+GEN6g3/A
   7lkvJ+5E3fpkoFcsntzBK9ytLMmMOR8cIRlQl3j1HleUf9YCYMCucsRdf
   cnGA2gwjUQvzht5N/RIxRMz1ZBTMtXnEjFweYZtYhnzXFtNEbtuP5pP7a
   NO7PjZfqtq4eGtAD3dJTXcUW+z4DeuA3rN9SPbF00PvnpZEIOTK2+dxtp
   w==;
X-CSE-ConnectionGUID: 4g2iXPXRR7it1SjX3qdpGg==
X-CSE-MsgGUID: 80cxgbCfQP+fU8k+eIMuJQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613959"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613959"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:05 -0700
X-CSE-ConnectionGUID: cY4EQ/NfSsqzZ1SkRhSwGg==
X-CSE-MsgGUID: Dii6f8PhTQi6/zFUhC+cPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942754"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:04 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 07/16] KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
Date: Tue, 14 May 2024 17:59:43 -0700
Message-Id: <20240515005952.3410568-8-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a private pointer to struct kvm_mmu_page for the private page table and
add helper functions to allocate/initialize/free a private page table page.
Because KVM TDP MMU doesn't use unsync_children and write_flooding_count,
pack them to have room for a pointer and use a union to avoid memory
overhead.

For private GPA, CPU refers to a private page table whose contents are
encrypted.  The dedicated APIs to operate on it (e.g. updating/reading its
PTE entry) are used, and their cost is expensive.

When KVM resolves the KVM page fault, it walks the page tables.  To reuse
the existing KVM MMU code and mitigate the heavy cost of directly walking
the private page table, allocate one more page for the mirrored page table
for the KVM MMU code to directly walk.  Resolve the KVM page fault with
the existing code, and do additional operations necessary for the private
page table.  To distinguish such cases, the existing KVM page table is
called a shared page table (i.e., not associated with a private page
table), and the page table with a private page table is called a mirrored
page table.  The relationship is depicted below.

              KVM page fault                     |
                     |                           |
                     V                           |
        -------------+----------                 |
        |                      |                 |
        V                      V                 |
     shared GPA           private GPA            |
        |                      |                 |
        V                      V                 |
    shared PT root      mirrored PT root         |    private PT root
        |                      |                 |           |
        V                      V                 |           V
     shared PT           mirrored PT ----propagate---->  private PT
        |                      |                 |           |
        |                      \-----------------+------\    |
        |                                        |      |    |
        V                                        |      V    V
  shared guest page                              |    private guest page
                                                 |
                           non-encrypted memory  |    encrypted memory
                                                 |
PT: Page table
Shared PT: visible to KVM, and the CPU uses it for shared mappings.
Private PT: the CPU uses it, but it is invisible to KVM.  TDX module
            updates this table to map private guest pages.
Mirrored PT: It is visible to KVM, but the CPU doesn't use it.  KVM uses it
             to propagate PT change to the actual private PT.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX MMU Part 1:
- Rename terminology, dummy PT => mirror PT. and updated the commit message
  By Rick and Kai.
- Added a comment on union of private_spt by Rick.
- Don't handle the root case in kvm_mmu_alloc_private_spt(), it will not
  be needed in future patches. (Rick)
- Update comments (Yan)
- Remove kvm_mmu_init_private_spt(), open code it in later patches (Yan)

v19:
- typo in the comment in kvm_mmu_alloc_private_spt()
- drop CONFIG_KVM_MMU_PRIVATE
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/mmu/mmu.c          |  7 +++++++
 arch/x86/kvm/mmu/mmu_internal.h | 36 +++++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
 4 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 13119d4e44e5..d010ca5c7f44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -828,6 +828,11 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	/*
+	 * This cache is to allocate private page table. E.g. private EPT used
+	 * by the TDX module.
+	 */
+	struct kvm_mmu_memory_cache mmu_private_spt_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1998267a330e..d5cf5b15a10e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -685,6 +685,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
+	if (kvm_gfn_shared_mask(vcpu->kvm)) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_spt_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
 				       PT64_ROOT_MAX_LEVEL);
 	if (r)
@@ -704,6 +710,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b114589a595a..0f1a9d733d9e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -101,7 +101,22 @@ struct kvm_mmu_page {
 		int root_count;
 		refcount_t tdp_mmu_root_count;
 	};
-	unsigned int unsync_children;
+	union {
+		/* Those two members aren't used for TDP MMU */
+		struct {
+			unsigned int unsync_children;
+			/*
+			 * Number of writes since the last time traversal
+			 * visited this page.
+			 */
+			atomic_t write_flooding_count;
+		};
+		/*
+		 * Page table page of private PT.
+		 * Passed to TDX module, not accessed by KVM.
+		 */
+		void *private_spt;
+	};
 	union {
 		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 		tdp_ptep_t ptep;
@@ -124,9 +139,6 @@ struct kvm_mmu_page {
 	int clear_spte_count;
 #endif
 
-	/* Number of writes since the last time traversal visited this page.  */
-	atomic_t write_flooding_count;
-
 #ifdef CONFIG_X86_64
 	/* Used for freeing the page asynchronously if it is a TDP MMU page. */
 	struct rcu_head rcu_head;
@@ -150,6 +162,22 @@ static inline bool is_private_sp(const struct kvm_mmu_page *sp)
 	return kvm_mmu_page_role_is_private(sp->role);
 }
 
+static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
+{
+	return sp->private_spt;
+}
+
+static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	/*
+	 * private_spt is allocated for TDX module to hold private EPT mappings,
+	 * TDX module will initialize the page by itself.
+	 * Therefore, KVM does not need to initialize or access private_spt.
+	 * KVM only interacts with sp->spt for mirrored EPT operations.
+	 */
+	sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_spt_cache);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1086e3b2aa5c..6fa910b017d1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -53,6 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	free_page((unsigned long)sp->private_spt);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
-- 
2.34.1


