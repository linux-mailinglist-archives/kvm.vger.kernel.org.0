Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6741F0268
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgFEVnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:43:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:55951 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbgFEVjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:11 -0400
IronPort-SDR: MIhXie+luem6AQuWYsAfnMf4XCzAq5WZKQdmf9vl7I0BQ7MKpSQd3oUn4wZHxW9h9vIhSoei1C
 y16XtmQduBHA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:08 -0700
IronPort-SDR: K5xNZ3oXYp+oVBI7V1zZKjiJSJR0lMy065Lb/QLuNuIN9eZhnavo+VVKzrYDCA/IblpQWSVCl4
 30GwmqIJk2qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860889"
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
Subject: [PATCH 08/21] KVM: x86/mmu: Clean up the gorilla math in mmu_topup_memory_caches()
Date:   Fri,  5 Jun 2020 14:38:40 -0700
Message-Id: <20200605213853.14959-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up the minimums in mmu_topup_memory_caches() to document the
driving mechanisms behind the minimums.  Now that encountering an empty
cache is unlikely to trigger BUG_ON(), it is less dangerous to be more
precise when defining the minimums.

For rmaps, the logic is 1 parent PTE per level, plus a single rmap, and
prefetched rmaps.  The extra objects in the current '8 + PREFETCH'
minimum came about due to an abundance of paranoia in commit
c41ef344de212 ("KVM: MMU: increase per-vcpu rmap cache alloc size"),
i.e. it could have increased the minimum to 2 rmaps.  Furthermore, the
unexpected extra rmap case was killed off entirely by commits
f759e2b4c728c ("KVM: MMU: avoid pte_list_desc running out in
kvm_mmu_pte_write") and f5a1e9f89504f ("KVM: MMU: remove call to
kvm_mmu_pte_write from walk_addr").

For the so called page cache, replace '8' with 2*PT64_ROOT_MAX_LEVEL.
The 2x multiplier is needed because the cache is used for both shadow
pages and gfn arrays for indirect MMUs.

And finally, for page headers, replace '4' with PT64_ROOT_MAX_LEVEL.

Note, KVM now supports 5-level paging, i.e. the old minimums that used a
baseline derived from 4-level paging were technically wrong.  But, KVM
always allocates roots in a separate flow, e.g. it's impossible in the
current implementation to actually need 5 new shadow pages in a single
flow.  Use PT64_ROOT_MAX_LEVEL unmodified instead of subtracting 1, as
the direct usage is likely more intuitive to uninformed readers, and the
inflated minimum is unlikely to affect functionality in practice.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4b4c3234d623..451e0365e5dd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1103,14 +1103,17 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
+	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				   8 + PTE_PREFETCH_NUM);
+				   1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache, 8);
+	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
+				   2 * PT64_ROOT_MAX_LEVEL);
 	if (r)
 		return r;
-	return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
+	return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+				      PT64_ROOT_MAX_LEVEL);
 }
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
-- 
2.26.0

