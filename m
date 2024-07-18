Return-Path: <kvm+bounces-21886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 837A89352F7
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A737E1C2117F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F3A146D6E;
	Thu, 18 Jul 2024 21:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i6Etm7UT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D157B146A6C;
	Thu, 18 Jul 2024 21:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337168; cv=none; b=QKNNBgWDJIev+9i/NkOYC4iuRtDfdn6RbP380cfHSUUBzR/oDs1xzQxQXxg7WK70G5K//MB3UYuMvHBeL8njkREZuCH5GrUNWdxSxYWb1i4Du5FsfLgRHR4smPad1XgNeRT57wG/I9OmGNLTqX68fsjuza9cYOz+tGQ0jNUBbJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337168; c=relaxed/simple;
	bh=SMiFx6QYD9OlDR+/KvB40o6xev7EohzN1HhFk0i8bUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JMb/EzdYuAxNEWCOxiwCp4HT+/w+o1Ep6bUnY/Lyv/ELVwLa+HSrzKE2oOnrbuaMUfbr290P/xma8dIFZEBvoalh43WbyAMH42Y32pIhn3sIVAxc5P3JihWf5ZU7SUIBV/Y6ukA3m+YGq/b5wHm5Vk+HyhrZhHX3Ajd0ZIhhviA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i6Etm7UT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337167; x=1752873167;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SMiFx6QYD9OlDR+/KvB40o6xev7EohzN1HhFk0i8bUY=;
  b=i6Etm7UTx37dgwXugKIExqu9dPT4eHVPSNKPQtQph5vd7o802VgJOulc
   NyVE/ic5lqwDlD6PTXuBXxLiULfBaBboUXDRE5RFJPjLaqoTu+R9FzahT
   8yQXCn696GuHlQG9urLTASkiklx8ajCU5tXY+JvZ/iL46aub//rN9gGt6
   llPDpNS5oNq8Xol38GY0T6lIWUgoO3Q0n5+9vITIP1zvJKTiSNklhmKYt
   05AFd55ddrAckEi5khfZngIiJBLQaAl4aBMT34IMRC5RGaQ+eBqUx3RT5
   +LNNhXe9VV9YPLsei0CZnP63sXz6kCJ/OVprLV12toD+2ebyyEzzyaNrj
   Q==;
X-CSE-ConnectionGUID: RExMVyD9Q1aHgGHTz0O3pw==
X-CSE-MsgGUID: TZnhJ0GnRUe7mTlFnhS+KQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697406"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697406"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:43 -0700
X-CSE-ConnectionGUID: 6WSVDBtbRPusOPm6kV0jMQ==
X-CSE-MsgGUID: uydqjSdYQdCWXjXxnFtmkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760378"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:43 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v4 04/18] KVM: x86/mmu: Add an external pointer to struct kvm_mmu_page
Date: Thu, 18 Jul 2024 14:12:16 -0700
Message-Id: <20240718211230.1492011-5-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a external pointer to struct kvm_mmu_page for TDX's private page table
and add helper functions to allocate/initialize/free a private page table
page. TDX will only be supported with the TDP MMU. Because KVM TDP MMU
doesn't use unsync_children and write_flooding_count, pack them to have
room for a pointer and use a union to avoid memory overhead.

For private GPA, CPU refers to a private page table whose contents are
encrypted. The dedicated APIs to operate on it (e.g. updating/reading its
PTE entry) are used, and their cost is expensive.

When KVM resolves the KVM page fault, it walks the page tables. To reuse
the existing KVM MMU code and mitigate the heavy cost of directly walking
the private page table allocate two sets of page tables for the private
half of the GPA space.

For the page tables that KVM will walk, allocate them like normal and refer
to them as mirror page tables. Additionally allocate one more page for the
page tables the CPU will walk, and call them external page tables. Resolve
the KVM page fault with the existing code, and do additional operations
necessary for modifying the external page table in future patches.

The relationship of the types of page tables in this scheme is depicted
below:

              KVM page fault                     |
                     |                           |
                     V                           |
        -------------+----------                 |
        |                      |                 |
        V                      V                 |
     shared GPA           private GPA            |
        |                      |                 |
        V                      V                 |
    shared PT root      mirror PT root           |    private PT root
        |                      |                 |           |
        V                      V                 |           V
     shared PT           mirror PT        --propagate--> external PT
        |                      |                 |           |
        |                      \-----------------+------\    |
        |                                        |      |    |
        V                                        |      V    V
  shared guest page                              |    private guest page
                                                 |
                           non-encrypted memory  |    encrypted memory
                                                 |
PT          - Page table
Shared PT   - Visible to KVM, and the CPU uses it for shared mappings.
External PT - The CPU uses it, but it is invisible to KVM. TDX module
              updates this table to map private guest pages.
Mirror PT   - It is visible to KVM, but the CPU doesn't use it. KVM uses
              it to propagate PT change to the actual private PT.

Add a helper kvm_has_mirrored_tdp() to trigger this behavior and wire it
to the TDX vm type.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v4:
 - private->external comment fixes (Yan)

v3:
 - mirrored->external rename (Paolo)
 - Remove accidentally included kvm_mmu_alloc_private_spt() (Paolo)
 - Those -> These (Paolo)
 - Change log updates to make external/mirrored naming more clear

v2:
 - Rename private->mirror
 - Don't trigger off of shared mask

v1:
- Rename terminology, dummy PT => mirror PT. and updated the commit message
  By Rick and Kai.
- Added a comment on union of private_spt by Rick.
- Don't handle the root case in kvm_mmu_alloc_private_spt(), it will not
  be needed in future patches. (Rick)
- Update comments (Yan)
- Remove kvm_mmu_init_private_spt(), open code it in later patches (Yan)
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/mmu.h              |  5 +++++
 arch/x86/kvm/mmu/mmu.c          |  7 +++++++
 arch/x86/kvm/mmu/mmu_internal.h | 31 +++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
 5 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bb2e164c523..09aa2c56bab6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -817,6 +817,11 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	/*
+	 * This cache is to allocate external page table. E.g. private EPT used
+	 * by the TDX module.
+	 */
+	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index dc80e72e4848..0c3bf89cf7db 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -318,4 +318,9 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
 		return gpa;
 	return translate_nested_gpa(vcpu, gpa, access, exception);
 }
+
+static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e184e524e97..50ba7f63a067 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -688,6 +688,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
+	if (kvm_has_mirrored_tdp(vcpu->kvm)) {
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_external_spt_cache,
+					       PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
 				       PT64_ROOT_MAX_LEVEL);
 	if (r)
@@ -707,6 +713,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..68f99d9d6e7c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -101,7 +101,22 @@ struct kvm_mmu_page {
 		int root_count;
 		refcount_t tdp_mmu_root_count;
 	};
-	unsigned int unsync_children;
+	union {
+		/* These two members aren't used for TDP MMU */
+		struct {
+			unsigned int unsync_children;
+			/*
+			 * Number of writes since the last time traversal
+			 * visited this page.
+			 */
+			atomic_t write_flooding_count;
+		};
+		/*
+		 * Page table page of external PT.
+		 * Passed to TDX module, not accessed by KVM.
+		 */
+		void *external_spt;
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
@@ -145,6 +157,17 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	/*
+	 * external_spt is allocated for TDX module to hold private EPT mappings,
+	 * TDX module will initialize the page by itself.
+	 * Therefore, KVM does not need to initialize or access external_spt.
+	 * KVM only interacts with sp->spt for private EPT operations.
+	 */
+	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b92dcd5b266f..2d09c353e4bc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -53,6 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
+	free_page((unsigned long)sp->external_spt);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
-- 
2.34.1


