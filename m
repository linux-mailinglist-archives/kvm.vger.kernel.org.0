Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5991F0270
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgFEVnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:43:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:22537 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbgFEVjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:11 -0400
IronPort-SDR: JLPADZsqGB2gJEIFyNflVS8xRCa2BUnV4efUHdMbKbCb1D0N03WZe7pCPhAFtxqtSBugKNLcJs
 kixO9jt3ljUg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:09 -0700
IronPort-SDR: drkA71YNAIoK52TQI0JTaHbh7xNi+AMngxAAIFufzVrtFGyLsEpQm9nwP0i0YUnJE70U07WeKt
 3iT2kn7Z9Pjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860914"
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
Subject: [PATCH 16/21] KVM: arm64: Drop @max param from mmu_topup_memory_cache()
Date:   Fri,  5 Jun 2020 14:38:48 -0700
Message-Id: <20200605213853.14959-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the @max param in mmu_topup_memory_cache() and instead use
ARRAY_SIZE() to terminate the loop to fill the cache.  This removes a
BUG_ON() and sets the stage for moving arm64 to the common memory cache
implementation.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/arm64/kvm/mmu.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a1f6bc70c4e4..9398b66f8a87 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -124,15 +124,13 @@ static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
 	put_page(virt_to_page(pudp));
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  int min, int max)
+static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
 {
 	void *page;
 
-	BUG_ON(max > KVM_NR_MEM_OBJS);
 	if (cache->nobjs >= min)
 		return 0;
-	while (cache->nobjs < max) {
+	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
 		page = (void *)__get_free_page(GFP_PGTABLE_USER);
 		if (!page)
 			return -ENOMEM;
@@ -1356,8 +1354,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			pte = kvm_s2pte_mkwrite(pte);
 
 		ret = mmu_topup_memory_cache(&cache,
-					     kvm_mmu_cache_min_pages(kvm),
-					     KVM_NR_MEM_OBJS);
+					     kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
@@ -1737,8 +1734,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	up_read(&current->mm->mmap_sem);
 
 	/* We need minimum second+third level pages */
-	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
-				     KVM_NR_MEM_OBJS);
+	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm));
 	if (ret)
 		return ret;
 
-- 
2.26.0

