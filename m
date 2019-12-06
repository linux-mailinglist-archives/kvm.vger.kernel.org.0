Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512351159D8
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfLFX5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:57:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:55586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbfLFX5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530368"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] KVM: x86/mmu: Move root_hpa validity checks to top of page fault handler
Date:   Fri,  6 Dec 2019 15:57:27 -0800
Message-Id: <20191206235729.29263-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a check on root_hpa at the beginning of the page fault handler to
consolidate several checks on root_hpa that are scattered throughout the
page fault code.  This is a preparatory step towards eventually removing
such checks altogether, or at the very least WARNing if an invalid root
is encountered.  Remove only the checks that can be easily audited to
confirm that root_hpa cannot be invalidated between their current
location and the new check in kvm_mmu_page_fault(), and aren't currently
protected by mmu_lock, i.e. keep the checks in __direct_map() and
FNAME(fetch) for the time being.

The root_hpa checks that are consolidate were all added by commit

  37f6a4e237303 ("KVM: x86: handle invalid root_hpa everywhere")

which was a follow up to a bug fix for __direct_map(), commit

  989c6b34f6a94 ("KVM: MMU: handle invalid root_hpa at __direct_map")

At the time, nested VMX had, in hindsight, crazy handling of nested
interrupts and would trigger a nested VM-Exit in ->interrupt_allowed(),
and thus unexpectedly reset the MMU in flows such as can_do_async_pf().

Now that the wonky nested VM-Exit behavior is gone, the root_hpa checks
are bogus and confusing, e.g. it's not at all obvious what they actually
protect against, and at first glance they appear to be broken since many
of them run without holding mmu_lock.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 904fb466dd24..5e8666d25053 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3561,9 +3561,6 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, int level,
 	u64 spte = 0ull;
 	uint retry_count = 0;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
-		return false;
-
 	if (!page_fault_can_be_fast(error_code))
 		return false;
 
@@ -4007,9 +4004,6 @@ walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	int root, leaf;
 	bool reserved = false;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
-		goto exit;
-
 	walk_shadow_page_lockless_begin(vcpu);
 
 	for (shadow_walk_init(&iterator, vcpu, addr),
@@ -4039,7 +4033,7 @@ walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 			root--;
 		}
 	}
-exit:
+
 	*sptep = spte;
 	return reserved;
 }
@@ -4103,9 +4097,6 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 	struct kvm_shadow_walk_iterator iterator;
 	u64 spte;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
-		return;
-
 	walk_shadow_page_lockless_begin(vcpu);
 	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
 		clear_sp_write_flooding_count(iterator.sptep);
@@ -5468,6 +5459,9 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	int r, emulation_type = 0;
 	bool direct = vcpu->arch.mmu->direct_map;
 
+	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
+		return RET_PF_RETRY;
+
 	/* With shadow page tables, fault_address contains a GVA or nGPA.  */
 	if (vcpu->arch.mmu->direct_map) {
 		vcpu->arch.gpa_available = true;
-- 
2.24.0

