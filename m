Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8882F1AB376
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 23:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgDOVoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 17:44:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:2384 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgDOVoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 17:44:16 -0400
IronPort-SDR: 0lqUjT+DyiL+wFhzy3nN5S0EBfcpRPuJixEy+8dY/2e1SOgVwgBmQIvFz+b2CN19PiKZ3n7hFF
 hZQsHb4h8q+Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 14:44:15 -0700
IronPort-SDR: yeKwic9N8U6AnBAd+/yrXJjyKqEm4GeAUcuTcCxW3sjUiDgZWI3mSbul7ednoPy89yhVrHeCVg
 HpwD+NLgRynQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="427584255"
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
Subject: [PATCH 1/2] KVM: x86/mmu: Set @writable to false for non-visible accesses by L2
Date:   Wed, 15 Apr 2020 14:44:13 -0700
Message-Id: <20200415214414.10194-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415214414.10194-1-sean.j.christopherson@intel.com>
References: <20200415214414.10194-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly set @writable to false in try_async_pf() if the GFN->PFN
translation is short-circuited due to the requested GFN not being
visible to L2.

Leaving @writable ('map_writable' in the callers) uninitialized is ok
in that it's never actually consumed, but one has to track it all the
way through set_spte() being short-circuited by set_mmio_spte() to
understand that the uninitialized variable is benign, and relying on
@writable being ignored is an unnecessary risk.  Explicitly setting
@writable also aligns try_async_pf() with __gfn_to_pfn_memslot().

Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ea6032c222..6d6cb9416179 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4090,6 +4090,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	 */
 	if (is_guest_mode(vcpu) && !kvm_is_visible_gfn(vcpu->kvm, gfn)) {
 		*pfn = KVM_PFN_NOSLOT;
+		*writable = false;
 		return false;
 	}
 
-- 
2.26.0

