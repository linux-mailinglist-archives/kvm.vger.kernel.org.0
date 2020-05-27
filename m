Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42781E3C92
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 10:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388268AbgE0ItM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 04:49:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:18700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388173AbgE0ItM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 04:49:12 -0400
IronPort-SDR: ppc5c+AhmTRp5NuQ514pzNnoKc2bNMN2mGH5pee3UTsOzxXYJ5ksHTLJbcnJrdVHOJ6ke7LlEM
 EyBMDOJfImuA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 01:49:11 -0700
IronPort-SDR: OPrgdhhPN+h5HL5PvgzCH//opLERqRbC79bQCFH6zzeXmEejHv6+cdk4yzhFg2TqPI7Fz7UJ2B
 QAJM/FhgrYmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="255414431"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 27 May 2020 01:49:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Set mmio_value to '0' if reserved #PF can't be generated
Date:   Wed, 27 May 2020 01:49:09 -0700
Message-Id: <20200527084909.23492-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the mmio_value to '0' instead of simply clearing the present bit to
squash a benign warning in kvm_mmu_set_mmio_spte_mask() that complains
about the mmio_value overlapping the lower GFN mask on systems with 52
bits of PA space.

Opportunistically clean up the code and comments.

Fixes: 608831174100 ("KVM: x86: only do L1TF workaround on affected processors")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Thanks for the excuse to clean up kvm_set_mmio_spte_mask(), been wanting a
reason to fix that mess for a few months now :-).

 arch/x86/kvm/mmu/mmu.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2df0f347655a4..aab90f4079ea9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6136,25 +6136,16 @@ static void kvm_set_mmio_spte_mask(void)
 	u64 mask;
 
 	/*
-	 * Set the reserved bits and the present bit of an paging-structure
-	 * entry to generate page fault with PFER.RSV = 1.
+	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
+	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
+	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
+	 * 52-bit physical addresses then there are no reserved PA bits in the
+	 * PTEs and so the reserved PA approach must be disabled.
 	 */
-
-	/*
-	 * Mask the uppermost physical address bit, which would be reserved as
-	 * long as the supported physical address width is less than 52.
-	 */
-	mask = 1ull << 51;
-
-	/* Set the present bit. */
-	mask |= 1ull;
-
-	/*
-	 * If reserved bit is not supported, clear the present bit to disable
-	 * mmio page fault.
-	 */
-	if (shadow_phys_bits == 52)
-		mask &= ~1ull;
+	if (shadow_phys_bits < 52)
+		mask = BIT_ULL(51) | PT_PRESENT_MASK;
+	else
+		mask = 0;
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
 }
-- 
2.26.0

