Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2EC1F01EC
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgFEVjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:39:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:55947 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgFEVjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:16 -0400
IronPort-SDR: dwQxs+qbzUVC75L80NAvSCuDI5kWiYeYlxYxzdXY/pUJZRtHOZqfTt7nmrmZvDI2drEBmdHOHq
 /I0pklyLXdyA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:08 -0700
IronPort-SDR: j7Wc2uJYO1nS60vi1HPczs7gXFA7HoPA+i9Y3yXEGgSIHvuwj1L1as4jdw7VkhXY0JW6DL68E1
 GDo+WnXbv7cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860901"
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
Subject: [PATCH 12/21] KVM: x86/mmu: Skip filling the gfn cache for guaranteed direct MMU topups
Date:   Fri,  5 Jun 2020 14:38:44 -0700
Message-Id: <20200605213853.14959-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't bother filling the gfn array cache when the caller is a fully
direct MMU, i.e. won't need a gfn array for shadow pages.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 18 ++++++++++--------
 arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8f8eebf67df..8d66cf558f1b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1101,7 +1101,7 @@ static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 	}
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
+static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
 
@@ -1114,10 +1114,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 				   PT64_ROOT_MAX_LEVEL);
 	if (r)
 		return r;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
-				   PT64_ROOT_MAX_LEVEL);
-	if (r)
-		return r;
+	if (maybe_indirect) {
+		r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
+					   PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
 	return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
 				      PT64_ROOT_MAX_LEVEL);
 }
@@ -4107,7 +4109,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (fast_page_fault(vcpu, gpa, error_code))
 		return RET_PF_RETRY;
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
 		return r;
 
@@ -5147,7 +5149,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
 	if (r)
 		goto out;
 	r = mmu_alloc_roots(vcpu);
@@ -5341,7 +5343,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 * or not since pte prefetch is skiped if it does not have
 	 * enough objects in the cache.
 	 */
-	mmu_topup_memory_caches(vcpu);
+	mmu_topup_memory_caches(vcpu, true);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 3de32122f601..ac39710d0594 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -818,7 +818,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 		return RET_PF_EMULATE;
 	}
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = mmu_topup_memory_caches(vcpu, true);
 	if (r)
 		return r;
 
@@ -905,7 +905,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 	 * No need to check return value here, rmap_can_add() can
 	 * help us to skip pte prefetch later.
 	 */
-	mmu_topup_memory_caches(vcpu);
+	mmu_topup_memory_caches(vcpu, true);
 
 	if (!VALID_PAGE(root_hpa)) {
 		WARN_ON(1);
-- 
2.26.0

