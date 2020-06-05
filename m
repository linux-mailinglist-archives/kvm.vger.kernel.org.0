Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE1A1F0263
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgFEVmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:42:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:55951 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgFEVjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:15 -0400
IronPort-SDR: NbhwCXlxLn7mpPeCwoPt6LhYhWFhvDDjmeD4NiA+ocY210lN13OMCq27xdU9XBUynrXgbyOqdB
 oImrlrMAHBJA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:08 -0700
IronPort-SDR: +madCm+KmloElv9osFmV7Ja+xOkWJWCKaF5zKJaSRuKF0tASBAfaEK85fyzJDgo8vmm/thWRB7
 8Etr/rL0peCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860905"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 13/21] KVM: x86/mmu: Prepend "kvm_" to memory cache helpers that will be global
Date:   Fri,  5 Jun 2020 14:38:45 -0700
Message-Id: <20200605213853.14959-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the memory helpers that will soon be moved to common code and be
made globaly available via linux/kvm_host.h.  "mmu" alone is not a
sufficient namespace for globally available KVM symbols.

Opportunistically add "nr_" in mmu_memory_cache_free_objects() to make
it clear the function returns the number of free objects, as opposed to
freeing existing objects.

Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d66cf558f1b..b85d3e8e8403 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1071,7 +1071,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 		return (void *)__get_free_page(gfp_flags);
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+static int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 {
 	void *obj;
 
@@ -1086,12 +1086,12 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	return 0;
 }
 
-static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *mc)
+static int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
 	return mc->nobjs;
 }
 
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+static void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 {
 	while (mc->nobjs) {
 		if (mc->kmem_cache)
@@ -1106,33 +1106,33 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	int r;
 
 	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				   1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
+	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				   PT64_ROOT_MAX_LEVEL);
+	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
+				       PT64_ROOT_MAX_LEVEL);
 	if (r)
 		return r;
 	if (maybe_indirect) {
-		r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
-					   PT64_ROOT_MAX_LEVEL);
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
+					       PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
 	}
-	return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
-				      PT64_ROOT_MAX_LEVEL);
+	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+					  PT64_ROOT_MAX_LEVEL);
 }
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
+static void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 {
 	void *p;
 
@@ -1146,7 +1146,7 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -1417,7 +1417,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_memory_cache *mc;
 
 	mc = &vcpu->arch.mmu_pte_list_desc_cache;
-	return mmu_memory_cache_free_objects(mc);
+	return kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
@@ -2104,10 +2104,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 {
 	struct kvm_mmu_page *sp;
 
-	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	if (!direct)
-		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	/*
-- 
2.26.0

