Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FF279ED65
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjIMPk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjIMPkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B03271C;
        Wed, 13 Sep 2023 08:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619612; x=1726155612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2RPFZu0puCXZiwQwlgREWFGSb+eCNj6qUfNCInw598U=;
  b=fR6oTrHMB1CUTOuAiOXs9+sWgNY1kKZ4MUQTJ07YQeG0z2NYg0WSko7W
   NxdC1jh2+tQr9fhCGtJ4stLrHOeQpQsRp88YJGGksqR9wJUkDV3cBuFKU
   4k0uLnY5QvMVMqXxPgJT3Z9+x+TzPVOuwSDqxMrUgMjmB/GkpzLrMvFTa
   p2Lox8VIOay57Tfu2QOqA770snczx5b4yabszn49OfaoRsaS+2J/PFdQr
   B4X7MKFy2txt5BRmbB4xKVogFKw3jPyBxKuuEPcNnzdY+n2XZUE8yf8XM
   ySZEIlh5UWfq256HqRWyMuIhELV6imz8MDvU0S/9t9tuqLmDvnpiVULCv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030254"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030254"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852216"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852216"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:09 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 11/16] KVM: x86: Virtualize LAM for user pointer
Date:   Wed, 13 Sep 2023 20:42:22 +0800
Message-Id: <20230913124227.12574-12-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Add support to allow guests to set the new CR3 control bits for LAM and add
implementation to get untagged address for user pointers.

LAM modifies the checking that is applied to 64-bit linear addresses, allowing
software to use of the untranslated address bits for metadata and masks the
metadata bits before using them as linear addresses to access memory. LAM uses
two new CR3 non-address bits LAM_U48 (bit 62) and LAM_U57 (bit 61) to configure
LAM for user pointers. LAM also changes VMENTER to allow both bits to be set in
VMCS's HOST_CR3 and GUEST_CR3 for virtualization.

When EPT is on, CR3 is not trapped by KVM and it's up to the guest to set any of
the two LAM control bits. However, when EPT is off, the actual CR3 used by the
guest is generated from the shadow MMU root which is different from the CR3 that
is *set* by the guest, and KVM needs to manually apply any active control bits
to VMCS's GUEST_CR3 based on the cached CR3 *seen* by the guest.

KVM manually checks guest's CR3 to make sure it points to a valid guest physical
address (i.e. to support smaller MAXPHYSADDR in the guest). Extend this check
to allow the two LAM control bits to be set. After check, LAM bits of guest CR3
will be stripped off to extract guest physical address.

In case of nested, for a guest which supports LAM, both VMCS12's HOST_CR3 and
GUEST_CR3 are allowed to have the new LAM control bits set, i.e. when L0 enters
L1 to emulate a VMEXIT from L2 to L1 or when L0 enters L2 directly. KVM also
manually checks VMCS12's HOST_CR3 and GUEST_CR3 being valid physical address.
Extend such check to allow the new LAM control bits too.

Note, LAM doesn't have a global control bit to turn on/off LAM completely, but
purely depends on hardware's CPUID to determine it can be enabled or not. That
means, when EPT is on, even when KVM doesn't expose LAM to guest, the guest can
still set LAM control bits in CR3 w/o causing problem. This is an unfortunate
virtualization hole. KVM could choose to intercept CR3 in this case and inject
fault but this would hurt performance when running a normal VM w/o LAM support.
This is undesirable. Just choose to let the guest do such illegal thing as the
worst case is guest being killed when KVM eventually find out such illegal
behaviour and that is the guest to blame.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.h   |  4 ++++
 arch/x86/kvm/mmu.h     |  9 +++++++++
 arch/x86/kvm/vmx/vmx.c | 12 +++++++++---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 31b7def60282..3c579ce2f60f 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -275,6 +275,10 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
 
 static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
+	if (kvm_cpu_cap_has(X86_FEATURE_LAM) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+
 	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
 }
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 253fb2093d5d..e700f1f854ae 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -146,6 +146,15 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
 }
 
+static inline unsigned long kvm_get_active_cr3_lam_bits(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_cpu_cap_has(X86_FEATURE_LAM) ||
+	    !guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+		return 0;
+
+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+}
+
 static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 {
 	u64 root_hpa = vcpu->arch.mmu->root.hpa;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ee35a91aa584..23eac6bb4fac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3400,7 +3400,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
+		            kvm_get_active_cr3_lam_bits(vcpu);
 	}
 
 	if (update_guest_cr3)
@@ -8222,6 +8223,7 @@ static void vmx_vm_destroy(struct kvm *kvm)
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags)
 {
 	int lam_bit;
+	unsigned long cr3_bits;
 
 	if (flags & (X86EMUL_F_FETCH | X86EMUL_F_BRANCH | X86EMUL_F_IMPLICIT |
 	             X86EMUL_F_INVLPG))
@@ -8235,8 +8237,12 @@ gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags
 	 * or a supervisor address.
 	 */
 	if (!(gva & BIT_ULL(63))) {
-		/* KVM doesn't yet virtualize LAM_U{48,57}. */
-		return gva;
+		cr3_bits = kvm_get_active_cr3_lam_bits(vcpu);
+		if (!(cr3_bits & (X86_CR3_LAM_U57 | X86_CR3_LAM_U48)))
+			return gva;
+
+		/* LAM_U48 is ignored if LAM_U57 is set. */
+		lam_bit = cr3_bits & X86_CR3_LAM_U57 ? 56 : 47;
 	} else {
 		if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LAM_SUP))
 			return gva;
-- 
2.25.1

