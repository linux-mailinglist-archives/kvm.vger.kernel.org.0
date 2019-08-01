Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8987E458
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 22:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbfHAUf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 16:35:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:47474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730391AbfHAUfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 16:35:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 13:35:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="191701856"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 01 Aug 2019 13:35:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86/mmu: Add explicit access mask for MMIO SPTEs
Date:   Thu,  1 Aug 2019 13:35:22 -0700
Message-Id: <20190801203523.5536-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190801203523.5536-1-sean.j.christopherson@intel.com>
References: <20190801203523.5536-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When shadow paging is enabled, KVM tracks the allowed access type for
MMIO SPTEs so that it can do a permission check on a MMIO GVA cache hit
without having to walk the guest's page tables.  The tracking is done
by retaining the WRITE and USER bits of the access when inserting the
MMIO SPTE (read access is implicitly allowed), which allows the MMIO
page fault handler to retrieve and cache the WRITE/USER bits from the
SPTE.

Unfortunately for EPT, the mask used to retain the WRITE/USER bits is
hardcoded using the x86 paging versions of the bits.  This funkiness
happens to work because KVM uses a completely different mask/value for
MMIO SPTEs when EPT is enabled, and the EPT mask/value just happens to
overlap exactly with the x86 WRITE/USER bits[*].

Explicitly define the access mask for MMIO SPTEs to accurately reflect
that EPT does not want to incorporate any access bits into the SPTE, and
so that KVM isn't subtly relying on EPT's WX bits always being set in
MMIO SPTEs, e.g. attempting to use other bits for experimentation breaks
horribly.

Note, vcpu_match_mmio_gva() explicits prevents matching GVA==0, and all
TDP flows explicit set mmio_gva to 0, i.e. zeroing vcpu->arch.access for
EPT has no (known) functional impact.

[*] Using WX to generate EPT misconfigurations (equivalent to reserved
    bit page fault) ensures KVM can employ its MMIO page fault tricks
    even platforms without reserved address bits.

Fixes: ce88decffd17 ("KVM: MMU: mmio page fault support")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Even though KVM tracks the access permissions with an unsigned, I went
with a u64 for shadow_mmio_access_mask to match the existing masks and
because I really dislike "unsigned" :-)

 arch/x86/kvm/mmu.c     | 15 +++++++++------
 arch/x86/kvm/mmu.h     |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8f72526e2f68..9ab6ff9e491b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -214,6 +214,7 @@ static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
 static u64 __read_mostly shadow_mmio_mask;
 static u64 __read_mostly shadow_mmio_value;
+static u64 __read_mostly shadow_mmio_access_mask;
 static u64 __read_mostly shadow_present_mask;
 static u64 __read_mostly shadow_me_mask;
 
@@ -299,11 +300,13 @@ static void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value)
+void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask)
 {
+	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	BUG_ON((mmio_mask & mmio_value) != mmio_value);
 	shadow_mmio_value = mmio_value | SPTE_SPECIAL_MASK;
 	shadow_mmio_mask = mmio_mask | SPTE_SPECIAL_MASK;
+	shadow_mmio_access_mask = access_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
@@ -389,7 +392,7 @@ static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
 	u64 mask = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	access &= ACC_WRITE_MASK | ACC_USER_MASK;
+	access &= shadow_mmio_access_mask;
 	mask |= shadow_mmio_value | access;
 	mask |= gpa | shadow_nonpresent_or_rsvd_mask;
 	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
@@ -418,8 +421,7 @@ static gfn_t get_mmio_spte_gfn(u64 spte)
 
 static unsigned get_mmio_spte_access(u64 spte)
 {
-	u64 mask = generation_mmio_spte_mask(MMIO_SPTE_GEN_MASK) | shadow_mmio_mask;
-	return (spte & ~mask) & ~PAGE_MASK;
+	return spte & shadow_mmio_access_mask;
 }
 
 static bool set_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
@@ -3290,7 +3292,8 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	}
 
 	if (unlikely(is_noslot_pfn(pfn)))
-		vcpu_cache_mmio_info(vcpu, gva, gfn, access);
+		vcpu_cache_mmio_info(vcpu, gva, gfn,
+				     access & shadow_mmio_access_mask);
 
 	return false;
 }
@@ -6028,7 +6031,7 @@ static void kvm_set_mmio_spte_mask(void)
 	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
 		mask &= ~1ull;
 
-	kvm_mmu_set_mmio_spte_mask(mask, mask);
+	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
 }
 
 int kvm_mmu_module_init(void)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 54c2a377795b..11f8ec89433b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -51,7 +51,7 @@ static inline u64 rsvd_bits(int s, int e)
 	return ((1ULL << (e - s + 1)) - 1) << s;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value);
+void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 074385c86c09..10faf5c91f4e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4026,7 +4026,7 @@ static void ept_set_mmio_spte_mask(void)
 	 * of an EPT paging-structure entry is 110b (write/execute).
 	 */
 	kvm_mmu_set_mmio_spte_mask(VMX_EPT_RWX_MASK,
-				   VMX_EPT_MISCONFIG_WX_VALUE);
+				   VMX_EPT_MISCONFIG_WX_VALUE, 0);
 }
 
 #define VMX_XSS_EXIT_BITMAP 0
-- 
2.22.0

