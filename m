Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9374C179D61
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 02:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgCEBen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 20:34:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:31855 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgCEBel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 20:34:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 17:34:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,516,1574150400"; 
   d="scan'208";a="234301750"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2020 17:34:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
Subject: [PATCH v2 3/7] KVM x86: Extend AMD specific guest behavior to Hygon virtual CPUs
Date:   Wed,  4 Mar 2020 17:34:33 -0800
Message-Id: <20200305013437.8578-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305013437.8578-1-sean.j.christopherson@intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend guest_cpuid_is_amd() to cover Hygon virtual CPUs and rename it
accordingly.  Hygon CPUs use an AMD-based core and so have the same
basic behavior as AMD CPUs.

Fixes: b8f4abb652146 ("x86/kvm: Add Hygon Dhyana support to KVM")
Cc: Pu Wen <puwen@hygon.cn>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 2 +-
 arch/x86/kvm/cpuid.h   | 6 ++++--
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 arch/x86/kvm/x86.c     | 2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b4beb3707d1b..5a9891cb2bc6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1013,7 +1013,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	 * requested. AMD CPUID semantics returns all zeroes for any
 	 * undefined leaf, whether or not the leaf is in range.
 	 */
-	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
+	if (!entry && check_limit && !guest_cpuid_is_amd_or_hygon(vcpu) &&
 	    !cpuid_function_in_range(vcpu, function)) {
 		max = kvm_find_cpuid_entry(vcpu, 0, 0);
 		if (max) {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 13eb3e92c6a9..332068db0fc2 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -140,12 +140,14 @@ static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x8
 		*reg &= ~__feature_bit(x86_feature);
 }
 
-static inline bool guest_cpuid_is_amd(struct kvm_vcpu *vcpu)
+static inline bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
 	best = kvm_find_cpuid_entry(vcpu, 0, 0);
-	return best && is_guest_vendor_amd(best->ebx, best->ecx, best->edx);
+	return best &&
+	       (is_guest_vendor_amd(best->ebx, best->ecx, best->edx) ||
+		is_guest_vendor_hygon(best->ebx, best->ecx, best->edx));
 }
 
 static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a1f4e325420e..c7ef2745a4e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4507,7 +4507,8 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				cpuid_maxphyaddr(vcpu), context->root_level,
 				context->nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
-				is_pse(vcpu), guest_cpuid_is_amd(vcpu));
+				is_pse(vcpu),
+				guest_cpuid_is_amd_or_hygon(vcpu));
 }
 
 static void
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa03f31ab33c..1a4836ed1230 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2524,7 +2524,7 @@ static void kvmclock_sync_fn(struct work_struct *work)
 static bool can_set_mci_status(struct kvm_vcpu *vcpu)
 {
 	/* McStatusWrEn enabled? */
-	if (guest_cpuid_is_amd(vcpu))
+	if (guest_cpuid_is_amd_or_hygon(vcpu))
 		return !!(vcpu->arch.msr_hwcr & BIT_ULL(18));
 
 	return false;
-- 
2.24.1

