Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F344B73AD10
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjFVXRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjFVXRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:17:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EAA26A8;
        Thu, 22 Jun 2023 16:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687475842; x=1719011842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6833orrJKCdah5qJfCTEMu2QxzIt4doif9bOKIutL50=;
  b=Gy/8YXd4OVKVBV5WE9bq6JzOzMfMC1bCpT6rvEcUTWA6C+3S4YWBjqDS
   W6S23sEwoiG41la3UWCsSqcVDQhdJO4QyKIo7VhG+H/jMoC2GwERUIYVK
   Wrxg5XhzNZFKv+CN+mPEaSPixYOGhT4BHE8Dvt0xQsqzOBAaNOg2J09Gx
   Ek7eEOJ/7REJyPGQYmOhKFeAyA8BFoGtIQhmCc0gqjd8OHrx7tyivrqu6
   aNCfUYkerBAnebES6K5VxuEJZ5R7KQZv4hiyX9ie2BSvud5Ejim0SLICy
   Kbq2xDx6IqTlvnyjP/rDxNuHsyNbFELrKO1DYqaEibaaieySbr2s1fa5e
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358129737"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="358129737"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718285983"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="718285983"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:12 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [RFC PATCH v2 4/6] KVM: x86: Introduce fault type to indicate kvm page fault is private
Date:   Thu, 22 Jun 2023 16:16:28 -0700
Message-Id: <a3a19de92c7ac6e607ac3e663d84a4312876084b.1687474039.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687474039.git.isaku.yamahata@intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce kvm fault type to indicate how to handle kvm page fault.

It is unfortunate and inflexible for kvm_mmu_do_page_fault() to call
kvm_mem_is_private(), eventually looking up memory attributes.  Later
__kvm_faultin_pfn() looks up memory attributes again.  There is a race
condition that other threads can change memory attributes due to not
gaining the mmu lock.  SNP-SEV and TDX define theri way to indicate that
the page fault is private.

Add KVM fault type, add mmu_private_fault_mask to struct kvm_arch for SNP
to determine the fault is private, add gfn_shared_mask to struct kvm_arch
for TDX to determine the fault is private. KVM_FAULT_SHARED_ALWAYS is added
for the conventional guest to avoid over head to lookup memory attributes.

Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes v1 -> v2:
- Introduced fault type and replaced is_private with fault_type.
- Add kvm_get_fault_type() to encapsulate the difference.
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/mmu/mmu.c          | 26 ++++++++++++++++++++------
 arch/x86/kvm/mmu/mmu_internal.h | 33 +++++++++++++++++++++++++++++++--
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8ae131dc645d..5afeefc7a516 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1445,6 +1445,12 @@ struct kvm_arch {
 	 */
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
+
+#ifdef CONFIG_KVM_PROTECTED_VM
+	/* To make the patch compile. */
+	u64 mmu_private_fault_mask;
+	gfn_t gfn_shared_mask;
+#endif
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b8ba7f11c3cb..feec75515f39 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3174,10 +3174,12 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 
 static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+				       gfn_t gfn, int max_level,
+				       enum kvm_fault_type fault_type)
 {
 	struct kvm_lpage_info *linfo;
 	int host_level;
+	bool is_private = fault_type == KVM_FAULT_PRIVATE;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3228,7 +3230,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
 						       fault->gfn, fault->max_level,
-						       fault->is_private);
+						       fault->fault_type);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4328,7 +4330,7 @@ static int kvm_do_memory_fault_exit(struct kvm_vcpu *vcpu,
 				    struct kvm_page_fault *fault)
 {
 	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
-	if (fault->is_private)
+	if (fault->fault_type == KVM_FAULT_PRIVATE)
 		vcpu->run->memory.flags = KVM_MEMORY_EXIT_FLAG_PRIVATE;
 	else
 		vcpu->run->memory.flags = 0;
@@ -4386,10 +4388,22 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
-		return kvm_do_memory_fault_exit(vcpu, fault);
+	if (fault->fault_type == KVM_FAULT_SHARED_ALWAYS) {
+		/*
+		 * The conventional case. Don't lookup memory attributes to
+		 * avoid overhead
+		 */
+		fault->fault_type = KVM_FAULT_SHARED;
+	} else if (fault->fault_type == KVM_FAULT_MEM_ATTR) {
+		fault->fault_type = kvm_mem_is_private(vcpu->kvm, fault->gfn) ?
+			KVM_FAULT_PRIVATE : KVM_FAULT_SHARED;
+	} else {
+		if ((fault->fault_type == KVM_FAULT_PRIVATE) !=
+		    kvm_mem_is_private(vcpu->kvm, fault->gfn))
+			return kvm_do_memory_fault_exit(vcpu, fault);
+	}
 
-	if (fault->is_private)
+	if (fault->fault_type == KVM_FAULT_PRIVATE)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 7f9ec1e5b136..0ec0b927a391 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -188,6 +188,13 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 	return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
 }
 
+enum kvm_fault_type {
+	KVM_FAULT_MEM_ATTR,
+	KVM_FAULT_SHARED,
+	KVM_FAULT_SHARED_ALWAYS,
+	KVM_FAULT_PRIVATE,
+};
+
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
@@ -203,9 +210,10 @@ struct kvm_page_fault {
 
 	/* Derived from mmu and global state.  */
 	const bool is_tdp;
-	const bool is_private;
 	const bool nx_huge_page_workaround_enabled;
 
+	enum kvm_fault_type fault_type;
+
 	/*
 	 * Whether a >4KB mapping can be created or is forbidden due to NX
 	 * hugepages.
@@ -282,6 +290,27 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+static inline enum kvm_fault_type kvm_get_fault_type(struct kvm *kvm,
+						     gpa_t gpa, u64 err)
+{
+
+#ifdef CONFIG_KVM_PROTECTED_VM
+	/* SEV-SNP handling */
+	if (kvm->arch.mmu_private_fault_mask)
+		return (err & kvm->arch.mmu_private_fault_mask) ?
+			KVM_FAULT_PRIVATE : KVM_FAULT_SHARED;
+
+	/* TDX handling */
+	if (kvm->arch.gfn_shared_mask)
+		return (gpa_to_gfn(gpa) & kvm->arch.gfn_shared_mask) ?
+			KVM_FAULT_SHARED : KVM_FAULT_PRIVATE;
+#endif
+	if (kvm->arch.vm_type == KVM_X86_PROTECTED_VM)
+		return KVM_FAULT_MEM_ATTR;
+	/* Don't query memory attributes. */
+	return KVM_FAULT_SHARED_ALWAYS;
+}
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u64 err, bool prefetch, int *emulation_type)
 {
@@ -301,7 +330,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.fault_type = kvm_get_fault_type(vcpu->kvm, cr2_or_gpa, err),
 	};
 	int r;
 
-- 
2.25.1

