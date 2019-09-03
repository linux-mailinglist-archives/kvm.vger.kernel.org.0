Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF79A779D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 01:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfICXgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 19:36:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:50861 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfICXgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 19:36:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 16:36:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,464,1559545200"; 
   d="scan'208";a="357911314"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 03 Sep 2019 16:36:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Doug Reiland <doug.reiland@intel.com>
Subject: [PATCH] KVM: x86: Manually calculate reserved bits when loading PDPTRS
Date:   Tue,  3 Sep 2019 16:36:45 -0700
Message-Id: <20190903233645.21125-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Manually generate the PDPTR reserved bit mask when explicitly loading
PDPTRs.  The reserved bits that are being tracked by the MMU reflect the
current paging mode, which is unlikely to be PAE paging in the vast
majority of flows that use load_pdptrs(), e.g. CR0 and CR4 emulation,
__set_sregs(), etc...  This can cause KVM to incorrectly signal a bad
PDPTR, or more likely, miss a reserved bit check and subsequently fail
a VM-Enter due to a bad VMCS.GUEST_PDPTR.

Add a one off helper to generate the reserved bits instead of sharing
code across the MMU's calculations and the PDPTR emulation.  The PDPTR
reserved bits are basically set in stone, and pushing a helper into
the MMU's calculation adds unnecessary complexity without improving
readability.

Oppurtunistically fix/update the comment for load_pdptrs().

Note, the buggy commit also introduced a deliberate functional change,
"Also remove bit 5-6 from rsvd_bits_mask per latest SDM.", which was
effectively (and correctly) reverted by commit cd9ae5fe47df ("KVM: x86:
Fix page-tables reserved bits").  A bit of SDM archaeology shows that
the SDM from late 2008 had a bug (likely a copy+paste error) where it
listed bits 6:5 as AVL and A for PDPTEs used for 4k entries but reserved
for 2mb entries.  I.e. the SDM contradicted itself, and bits 6:5 are and
always have been reserved.

Fixes: 20c466b56168d ("KVM: Use rsvd_bits_mask in load_pdptrs()")
Cc: stable@vger.kernel.org
Cc: Nadav Amit <nadav.amit@gmail.com>
Reported-by: Doug Reiland <doug.reiland@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 290c3c3efb87..548cc6ef5408 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -674,8 +674,14 @@ static int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 				       data, offset, len, access);
 }
 
+static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
+{
+	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63) | rsvd_bits(5, 8) |
+	       rsvd_bits(1, 2);
+}
+
 /*
- * Load the pae pdptrs.  Return true is they are all valid.
+ * Load the pae pdptrs.  Return 1 if they are all valid, 0 otherwise.
  */
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 {
@@ -694,8 +700,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 	}
 	for (i = 0; i < ARRAY_SIZE(pdpte); ++i) {
 		if ((pdpte[i] & PT_PRESENT_MASK) &&
-		    (pdpte[i] &
-		     vcpu->arch.mmu->guest_rsvd_check.rsvd_bits_mask[0][2])) {
+		    (pdpte[i] & pdptr_rsvd_bits(vcpu))) {
 			ret = 0;
 			goto out;
 		}
-- 
2.22.0

