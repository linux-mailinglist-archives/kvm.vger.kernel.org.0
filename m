Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E4E1AB379
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 23:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgDOVoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 17:44:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:2388 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730240AbgDOVoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 17:44:19 -0400
IronPort-SDR: 2nvRmVKouYFi0Vwga/l5WBtikvGWcuDg4V3XZkKg61IROV3FIgvl2OWOOR+55+DOTm+AkFZ29u
 T2PgrXWtw+wg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 14:44:15 -0700
IronPort-SDR: pVVdUUVLwq3NR9hrkR2k/UHGdivr/jKKmfOCSuV+gJO6vYTdRNRntKRn16DA02KtwD8H+HD+zJ
 Qyoswa+NtH5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="427584257"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 15 Apr 2020 14:44:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 2/2] KVM: x86/mmu: Avoid an extra memslot lookup in try_async_pf() for L2
Date:   Wed, 15 Apr 2020 14:44:14 -0700
Message-Id: <20200415214414.10194-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415214414.10194-1-sean.j.christopherson@intel.com>
References: <20200415214414.10194-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tweak the L2 vs. private memslot handling in try_async_pf() to avoid an
added memslot lookup and more precisely single out private memslots,
i.e. defer to the common code to handle nonexistent or invalid memslots
to make it clear L2 doesn't require special handling for those cases.

Opportunstically squish a multi-line comment into a single-line comment.

Note, the end result, KVM_PFN_NOSLOT, is unchanged.

Cc: Jim Mattson <jmattson@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d6cb9416179..06d0150ce53b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4082,19 +4082,16 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
 			 bool *writable)
 {
-	struct kvm_memory_slot *slot;
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	bool async;
 
-	/*
-	 * Don't expose private memslots to L2.
-	 */
-	if (is_guest_mode(vcpu) && !kvm_is_visible_gfn(vcpu->kvm, gfn)) {
+	/* Don't expose private memslots to L2. */
+	if (is_guest_mode(vcpu) && slot && slot->id >= KVM_USER_MEM_SLOTS) {
 		*pfn = KVM_PFN_NOSLOT;
 		*writable = false;
 		return false;
 	}
 
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	async = false;
 	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async, write, writable);
 	if (!async)
-- 
2.26.0

