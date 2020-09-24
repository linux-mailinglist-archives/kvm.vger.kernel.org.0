Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4B27798C
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgIXTnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 15:43:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:31798 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXTm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 15:42:56 -0400
IronPort-SDR: PulKmsZSSvf/DAaeKcak2196070ZyGWCwXh92yOS+UocRmIAkfdRkV+AW9dGTtmSLAZpW80CXc
 3bPfLvj3Iikw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="149076394"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="149076394"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:42:53 -0700
IronPort-SDR: 4Q/JJEFaULhUtBA1BdlVSaephwv82tNSNACOQDBe9OCy1TlfKZsk7Xr2Z7ijxh5G674SFKVKDw
 UUdk8boe/VAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="347953056"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Sep 2020 12:42:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] KVM: x86: Move illegal GPA helper out of the MMU code
Date:   Thu, 24 Sep 2020 12:42:49 -0700
Message-Id: <20200924194250.19137-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924194250.19137-1-sean.j.christopherson@intel.com>
References: <20200924194250.19137-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename kvm_mmu_is_illegal_gpa() to kvm_vcpu_is_illegal_gpa() and move it
to cpuid.h so that's it's colocated with cpuid_maxphyaddr().  The helper
is not MMU specific and will gain a user that is completely unrelated to
the MMU in a future patch.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h   | 5 +++++
 arch/x86/kvm/mmu.h     | 5 -----
 arch/x86/kvm/mmu/mmu.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 3a923ae15f2f..1d2c4f2e4bb6 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -34,6 +34,11 @@ static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 	return vcpu->arch.maxphyaddr;
 }
 
+static inline bool kvm_vcpu_is_illegal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	return (gpa >= BIT_ULL(cpuid_maxphyaddr(vcpu)));
+}
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 5efc6081ca13..9c4a9c8e43d9 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -155,11 +155,6 @@ static inline bool is_write_protection(struct kvm_vcpu *vcpu)
 	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
 }
 
-static inline bool kvm_mmu_is_illegal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
-{
-        return (gpa >= BIT_ULL(cpuid_maxphyaddr(vcpu)));
-}
-
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76c5826e29a2..2e7251eec1f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -521,7 +521,7 @@ static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
                                   struct x86_exception *exception)
 {
 	/* Check if guest physical address doesn't exceed guest maximum */
-	if (kvm_mmu_is_illegal_gpa(vcpu, gpa)) {
+	if (kvm_vcpu_is_illegal_gpa(vcpu, gpa)) {
 		exception->error_code |= PFERR_RSVD_MASK;
 		return UNMAPPED_GVA;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0d41faf63b57..7987de212057 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5307,7 +5307,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * would also use advanced VM-exit information for EPT violations to
 	 * reconstruct the page fault error code.
 	 */
-	if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
+	if (unlikely(kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
-- 
2.28.0

