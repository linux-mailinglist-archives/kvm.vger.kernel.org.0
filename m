Return-Path: <kvm+bounces-33768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B119F16EF
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44E60160F48
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427041F12E2;
	Fri, 13 Dec 2024 19:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfWwHX/X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0001E8839
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119847; cv=none; b=ph8i3j9aXV0trhOmpFcCklrz0tENjO4EXA9kwqknLuZXdXncJL48kQ5ky1MvpD1914xKpiaScJCQXne0nEx4vT12XuUuLTaBohq//gSgOjrgDE95rhIPtc0rpFHfgCNUMAMgO8INUWCuNm25j6NYZQjma93YJoT1v9g1tkVWrCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119847; c=relaxed/simple;
	bh=/IwTpj+UAyxrOOLurzt+l1sLLKRzY1gIFHEoxNQPQPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hxZMMQwsrgavDn0k301e7JxZH99fwr8urKxV6oMVEuyEwZ3XmtGKgksAnFyzU5rqAIoaEY4Gugkee66G5sK4zUkhydva0nvohZgUNz/vPUDz5ehGcWlQxL89NMA84FWHej/SgHuqqkdiBs9nLyzqr/lvF2/Tl9CMYB82FNGFVqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MfWwHX/X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hje4JKHr4ghgBal4NU6uwLrFHCTJ6qK8Xyxe/U8+Vs4=;
	b=MfWwHX/X28t0ydS8PvgZbDJU5lxPiS7S/D6mWl3ke7IuLYXNTF1vzmYlXzJDK34xScw2wb
	xhKn56OT3Z4T9Q5HD73HBjIyk0D6AQpdI5pf498E/wbmXwTblilB7Q+kbo2soVdffdch+u
	5Tstw88K7BxY7/MLg6hlNjqhWoOYFCo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-OFS6tqJXO_ysJLokL05ogA-1; Fri,
 13 Dec 2024 14:57:20 -0500
X-MC-Unique: OFS6tqJXO_ysJLokL05ogA-1
X-Mimecast-MFC-AGG-ID: OFS6tqJXO_ysJLokL05ogA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3A3519560B3;
	Fri, 13 Dec 2024 19:57:18 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B848A195605A;
	Fri, 13 Dec 2024 19:57:17 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 04/18] KVM: x86/mmu: Add an external pointer to struct kvm_mmu_page
Date: Fri, 13 Dec 2024 14:56:57 -0500
Message-ID: <20241213195711.316050-5-pbonzini@redhat.com>
In-Reply-To: <20241213195711.316050-1-pbonzini@redhat.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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
Message-ID: <20240718211230.1492011-5-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/mmu.h              |  5 +++++
 arch/x86/kvm/mmu/mmu.c          |  7 +++++++
 arch/x86/kvm/mmu/mmu_internal.h | 31 +++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
 5 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c1251b371421..5f020b097922 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -813,6 +813,11 @@ struct kvm_vcpu_arch {
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
index e9322358678b..538eb3156f09 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -287,4 +287,9 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
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
index e87f22e8dd44..b2a6cddde643 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -599,6 +599,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
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
@@ -618,6 +624,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b00abbe3f6cf..d9425064ecc5 100644
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
index b0bddcb2f781..633c07c63fa6 100644
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
2.43.5



