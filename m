Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9712647A27
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiLHXgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiLHXgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:36:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82BE70B81;
        Thu,  8 Dec 2022 15:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542562; x=1702078562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OruNx6JSRjFi416SwFgD4HRIwqgwPkuEngRvcyMCZnU=;
  b=hsMgtmVxyBGqayhCC/kDtWG5WGiiLYX1BXgftIOLtfswYYcHn8LhXX4C
   FcKuFDnVWWH8zMysPD6HjUpcOFsU37to9skkhsxjMs7uKB0bn6xAiTRJu
   nE7S7zXiRPxJGmRDRj+28ROgoK3xCCNNOhsZntsJUICbRBC5BC4IeAKi2
   pKsWMPAEMWV91uDrU3HpqOjXHJeZ7jXG8z9ymsR8QyW16DfVmMoxnpAnE
   1guA5OmHTHvWBn5GpJH4PNcSio6tbGhSUK5cfw7BmljwMef0UrBoaaW1L
   3YTZpNBkdXF2CYXzxfkqAKjIoeI9Q/6RnSfvB6Ju3ekCy9EEmiBxf+hKF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586567"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586567"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:36:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677951038"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677951038"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:36:01 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 14/15] KVM: x86/mmu: Make kvm fault handelr aware of large page of private memslot
Date:   Thu,  8 Dec 2022 15:35:49 -0800
Message-Id: <96c1c1e2281e9172244c838ccccc4c32bc150b34.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

struct kvm_page_fault.req_level is the page level which takes care of the
faulted-in page size.  For now its calculation is only for the conventional
kvm memslot by host_pfn_mapping_level() that traverses page table.

However, host_pfn_mapping_level() cannot be used for private kvm memslot
because pages of private kvm memlost aren't mapped into user virtual
address space.  Instead page order is given when getting pfn.  Remember it
in struct kvm_page_fault and use it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 36 +++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |  8 ++++++++
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7f56b1dd76fa..c011ea0b6444 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3132,12 +3132,12 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return level;
 }
 
-int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      int max_level, bool is_private)
+static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot,
+				       gfn_t gfn, int max_level, int host_level,
+				       bool faultin_private)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3146,16 +3146,24 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
-	if (is_private)
-		return max_level;
-
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
+	if (!faultin_private) {
+		WARN_ON_ONCE(host_level != PG_LEVEL_NONE);
+		host_level = host_pfn_mapping_level(kvm, gfn, slot);
+	}
+	WARN_ON_ONCE(host_level == PG_LEVEL_NONE);
 	return min(host_level, max_level);
 }
 
+int kvm_mmu_max_mapping_level(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot, gfn_t gfn,
+			      int max_level, bool faultin_private)
+{
+	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level, PG_LEVEL_NONE, faultin_private);
+}
+
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
@@ -3176,9 +3184,10 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * Enforce the iTLB multihit workaround after capturing the requested
 	 * level, which will be used to do precise, accurate accounting.
 	 */
-	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						     fault->gfn, fault->max_level,
-						     fault->is_private);
+	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
+						       fault->gfn, fault->max_level,
+						       fault->host_level,
+						       kvm_is_faultin_private(fault));
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4311,7 +4320,8 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	if (kvm_restricted_mem_get_pfn(slot, fault->gfn, &fault->pfn, &order))
 		return RET_PF_RETRY;
 
-	fault->max_level = min(order_to_level(order), fault->max_level);
+	fault->host_level = order_to_level(order);
+	fault->max_level = min((u8)fault->host_level, fault->max_level);
 	fault->map_writable = !(slot->flags & KVM_MEM_READONLY);
 	return RET_PF_CONTINUE;
 }
@@ -4355,7 +4365,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
 		return kvm_do_memory_fault_exit(vcpu, fault);
 
-	if (fault->is_private && kvm_slot_can_be_private(slot))
+	if (kvm_is_faultin_private(fault))
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 2b7c16dfdf5e..f7ff39b90ba4 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -333,6 +333,7 @@ struct kvm_page_fault {
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
+	enum pg_level host_level; /* valid only for private memslot && private gfn */
 };
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
@@ -446,4 +447,11 @@ static inline int kvm_restricted_mem_get_pfn(struct kvm_memory_slot *slot,
 }
 #endif /* CONFIG_HAVE_KVM_RESTRICTED_MEM */
 
+static inline bool kvm_is_faultin_private(const struct kvm_page_fault *fault)
+{
+	if (IS_ENABLED(CONFIG_HAVE_KVM_RESTRICTED_MEM))
+		return fault->is_private && kvm_slot_can_be_private(fault->slot);
+	return false;
+}
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
-- 
2.25.1

