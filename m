Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49890134D76
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgAHU1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:57134 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgAHU1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658356"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:05 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barret Rhoden <brho@google.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: [PATCH 01/14] KVM: x86/mmu: Enforce max_level on HugeTLB mappings
Date:   Wed,  8 Jan 2020 12:24:35 -0800
Message-Id: <20200108202448.9669-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Limit KVM's mapping level for HugeTLB based on its calculated max_level.
The max_level check prior to invoking host_mapping_level() only filters
out the case where KVM cannot create a 2mb mapping, it doesn't handle
the scenario where KVM can create a 2mb but not 1gb mapping, and the
host is using a 1gb HugeTLB mapping.

Fixes: ad163aa8903d ("KVM: x86/mmu: Persist gfn_lpage_is_disallowed() to max_level")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7269130ea5e2..8e822c09170d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1330,7 +1330,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 			 int *max_levelp)
 {
-	int max_level = *max_levelp;
+	int host_level, max_level = *max_levelp;
 	struct kvm_memory_slot *slot;
 
 	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
@@ -1362,7 +1362,8 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 	 * So, do not propagate host_mapping_level() to max_level as KVM can
 	 * still promote the guest mapping to a huge page in the THP case.
 	 */
-	return host_mapping_level(vcpu->kvm, large_gfn);
+	host_level = host_mapping_level(vcpu->kvm, large_gfn);
+	return min(host_level, max_level);
 }
 
 /*
-- 
2.24.1

