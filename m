Return-Path: <kvm+bounces-9637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9F3866C4E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D21E21C214C5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0187524B2;
	Mon, 26 Feb 2024 08:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eAoVIEZx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9B34D5AC;
	Mon, 26 Feb 2024 08:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936067; cv=none; b=TZGovrxgZOPpOv6kVgjPiLzyxBESOY+c9k33t96o16g7e9eNXR94JPVR3c+4HYBXvi6xFI8PzQJXuwB/RkeTOwbqccobs2llSK6oYvXw1McWvNrDYttEdIuFmaO6+GbpG2nBJ/b2oqlhC9lj5nUPPaIPxa2hhLIqFYic8UE3qUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936067; c=relaxed/simple;
	bh=Awuik1MUAYsAnCDFjrgL7JE4Wn0+9r53tlCToVb0+AQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lGwLZK92Q6brMjmv9i4DlwaOc6f0Gu0vdYkgdU+SsHdVoNiY/wg4Da9exw0BRvCdI7vkXwCj1LnayJ5vTF6SzTR0QAyWNJxZWTyH/upjynFQhgEJ508cnjF+8nNNUZDTPpDVQxW54tBTCRcfOqHMaStdHmPRnGg+TGyFYY26Bfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eAoVIEZx; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936065; x=1740472065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Awuik1MUAYsAnCDFjrgL7JE4Wn0+9r53tlCToVb0+AQ=;
  b=eAoVIEZxkRvjJIiWiAjOYqVVD3dbQan1SyYsXU/oayX73Q7UkJCaqowq
   w+MQh7ugGL7JQrCjHlNDxa4K7pUDD1IRKvx1AySEi2MxHLKF9IsLcSv7r
   bDPNbjaOJoWJjpuzcTDHgmqUQuCFYNxA5rGQKIdwCHaQrm82tr6ndXGA/
   Ypc9pWeRcOm8EGtoNW7zj+s5/KYWMeHWYG4HNaRc7MXFyNaphDSqBk458
   /3eWQsZNXh2iZ9XBacwmX3c9KGIycHiigo/hh+CGjnQ5NDhhNvLplFGEv
   Sde9fvbECUJAwNksMpp2gYCmnSJOw3BBIEqySnsq+Dcc/Lu12ooDxLdrI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631479"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631479"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474333"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:42 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 013/130] KVM: x86: Use PFERR_GUEST_ENC_MASK to indicate fault is private
Date: Mon, 26 Feb 2024 00:25:15 -0800
Message-Id: <c560cdadb7d0dc88b831cf1a5382cf6f166ff022.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

SEV-SNP defines PFERR_GUEST_ENC_MASK (bit 32) in page-fault error bits to
represent the guest page is encrypted.  Use the bit to designate that the
page fault is private and that it requires looking up memory attributes.
The vendor kvm page fault handler should set PFERR_GUEST_ENC_MASK bit based
on their fault information.  It may or may not use the hardware value
directly or parse the hardware value to set the bit.

For KVM_X86_SW_PROTECTED_VM, ask memory attributes for the fault
privateness.  For async page fault, carry the bit and use it for kvm page
fault handler.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v4 -> v5:
- Eliminate kvm_is_fault_private() by open code the function
- Make async page fault handler to carry is_private bit

Changes v3 -> v4:
- rename back struct kvm_page_fault::private => is_private
- catch up rename: KVM_X86_PROTECTED_VM => KVM_X86_SW_PROTECTED_VM

Changes v2 -> v3:
- Revive PFERR_GUEST_ENC_MASK
- rename struct kvm_page_fault::is_private => private
- Add check KVM_X86_PROTECTED_VM

Changes v1 -> v2:
- Introduced fault type and replaced is_private with fault_type.
- Add kvm_get_fault_type() to encapsulate the difference.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 57ce89fc2740..28314e7d546c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -264,6 +264,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_BIT 15
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_GUEST_ENC_BIT 34
 #define PFERR_IMPLICIT_ACCESS_BIT 48
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
@@ -275,6 +276,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
@@ -1836,6 +1838,7 @@ struct kvm_arch_async_pf {
 	gfn_t gfn;
 	unsigned long cr3;
 	bool direct_map;
+	u64 error_code;
 };
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ccdbff3d85ec..61674d6b17aa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4246,18 +4246,19 @@ static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 }
 
-static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-				    gfn_t gfn)
+static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	struct kvm_arch_async_pf arch;
 
 	arch.token = alloc_apf_token(vcpu);
-	arch.gfn = gfn;
+	arch.gfn = fault->gfn;
 	arch.direct_map = vcpu->arch.mmu->root_role.direct;
 	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
+	arch.error_code = fault->error_code & PFERR_GUEST_ENC_MASK;
 
-	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
-				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
+	return kvm_setup_async_pf(vcpu, fault->addr,
+				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
 }
 
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
@@ -4276,7 +4277,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
+	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,
+			      true, NULL);
 }
 
 static inline u8 kvm_max_level_for_order(int order)
@@ -4390,7 +4392,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			trace_kvm_async_pf_repeated_fault(fault->addr, fault->gfn);
 			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
 			return RET_PF_RETRY;
-		} else if (kvm_arch_setup_async_pf(vcpu, fault->addr, fault->gfn)) {
+		} else if (kvm_arch_setup_async_pf(vcpu, fault)) {
 			return RET_PF_RETRY;
 		}
 	}
@@ -5814,6 +5816,14 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
+	/*
+	 * This is racy with updating memory attributes with mmu_seq.  If we
+	 * hit a race, it would result in retrying page fault.
+	 */
+	if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
+	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
+		error_code |= PFERR_GUEST_ENC_MASK;
+
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 21f55e8b4dc6..0443bfcf5d9c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -292,13 +292,13 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+		.is_private = err & PFERR_GUEST_ENC_MASK,
 		.nx_huge_page_workaround_enabled =
 			is_nx_huge_page_enabled(vcpu->kvm),
 
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
 	};
 	int r;
 
-- 
2.25.1


