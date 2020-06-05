Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5371F026E
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgFEVnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:43:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:55947 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgFEVjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:11 -0400
IronPort-SDR: 31qIKB3GfjvrTsWtZFSNi0LqCcGZiXk1i4E48PoHZ8nd44W8b5XQCnTfAL6VwObDN2mxqeHeId
 cXzDTmWRoKnQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:08 -0700
IronPort-SDR: ZZaZ6F/6BihmuvqApCfYZnPy0xhRSZJVb+TdFXwVrCd9yEoEPD+XPiqtGxrIPcIEmkPWmu+182
 4NUl5HJGXo4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860898"
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
Subject: [PATCH 11/21] KVM: x86/mmu: Zero allocate shadow pages (outside of mmu_lock)
Date:   Fri,  5 Jun 2020 14:38:43 -0700
Message-Id: <20200605213853.14959-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set __GFP_ZERO for the shadow page memory cache and drop the explicit
clear_page() from kvm_mmu_get_page().  This moves the cost of zeroing a
page to the allocation time of the physical page, i.e. when topping up
the memory caches, and thus avoids having to zero out an entire page
while holding mmu_lock.

Cc: Peter Feiner <pfeiner@google.com>
Cc: Peter Shier <pshier@google.com>
Cc: Junaid Shahid <junaids@google.com>
Cc: Jim Mattson <jmattson@google.com>
Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b0ec9060786..a8f8eebf67df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2545,7 +2545,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PG_LEVEL_4K && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
-	clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
@@ -5687,6 +5686,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
+	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
-- 
2.26.0

