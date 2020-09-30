Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966B327DF3D
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgI3ERE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:17:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:60793 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgI3ERD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:17:03 -0400
IronPort-SDR: FV5nYk0pSJJ8603KtG/+8XQoa2jRbEEoWiNH9AgkWgQlDM4arb/uKTfFLzGSL/Q9/3UblAU/eV
 b3Pdszz9c8Xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="150137445"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="150137445"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:17:02 -0700
IronPort-SDR: v7GyGQOzf5xPyj4LjDmgOEAsMxM9+TuvPVj1Sj5MQSFcHY+Ay2ss/CHEooLdISE1GBGGZ1Lq9Q
 QsPgCTrdmG7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="415607862"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 29 Sep 2020 21:17:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 2/5] KVM: x86: Invoke vendor's vcpu_after_set_cpuid() after all common updates
Date:   Tue, 29 Sep 2020 21:16:56 -0700
Message-Id: <20200930041659.28181-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930041659.28181-1-sean.j.christopherson@intel.com>
References: <20200930041659.28181-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the call to kvm_x86_ops.vcpu_after_set_cpuid() to the very end of
kvm_vcpu_after_set_cpuid() to allow the vendor implementation to react
to changes made by the common code.  In the near future, this will be
used by VMX to update its CR4 guest/host masks to account for reserved
bits.  In the long term, SGX support will update the allowed XCR0 mask
for enclaves based on the vCPU's allowed XCR0.

vcpu_after_set_cpuid() (nee kvm_update_cpuid()) was originally added by
commit 2acf923e38fb ("KVM: VMX: Enable XSAVE/XRSTOR for guest"), and was
called separately after kvm_x86_ops.vcpu_after_set_cpuid() (nee
kvm_x86_ops->cpuid_update()).  There is no indication that the placement
of the common code updates after the vendor updates was anything more
than a "new function at the end" decision.

Inspection of the current code reveals no dependency on kvm_x86_ops'
vcpu_after_set_cpuid() in kvm_vcpu_after_set_cpuid() or any of its
helpers.  The bulk of the common code depends only on the guest's CPUID
configuration, kvm_mmu_reset_context() does not consume dynamic vendor
state, and there are no collisions between kvm_pmu_refresh() and VMX's
update of PT state.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 37c3668a774f..963bad7bc0ff 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -121,8 +121,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_cpuid_entry2 *best;
 
-	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
-
 	best = kvm_find_cpuid_entry(vcpu, 1, 0);
 	if (best && apic) {
 		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
@@ -146,6 +144,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
+
+	/* Invoke the vendor callback only after the above state is updated. */
+	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 	kvm_x86_ops.update_exception_bitmap(vcpu);
 }
 
-- 
2.28.0

