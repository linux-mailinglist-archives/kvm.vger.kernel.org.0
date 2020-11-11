Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7662AE8F3
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 07:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKKGbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 01:31:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:43536 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKKGb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 01:31:29 -0500
IronPort-SDR: FwRQxj3aLhrMBH9p74VKhzi/aIGUdu91bnwYqoait+6ifu/YxQc7gIlNp0Lp3fMEQCC+Y3XW5y
 Sj0NuoMO8NkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149951503"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="149951503"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 22:31:29 -0800
IronPort-SDR: XwxaufYff6QaFgYcu6D4VTB0cn1Z8L5O9lUmTyi1Jx44J58FxiCHTC08uhx/rAJTkFieR39bjm
 MW1Maihd4brQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="323167589"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2020 22:31:27 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 2/3] KVM: x86: Refresh CPUID when guest modifies MSR_IA32_XSS
Date:   Wed, 11 Nov 2020 14:41:50 +0800
Message-Id: <20201111064151.1090-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201111064151.1090-1-weijiang.yang@intel.com>
References: <20201111064151.1090-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updated CPUID.0xD.0x1, which reports the current required storage size
of all features enabled via XCR0 | XSS, when the guest's XSS is modified.

Note, KVM does not yet support any XSS based features, i.e. supported_xss
is guaranteed to be zero at this time.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 21 ++++++++++++++++++---
 arch/x86/kvm/x86.c              |  7 +++++--
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d44858b69353..1620a2cca781 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -611,6 +611,7 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 06a278b3701d..2c737337f466 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -115,9 +115,24 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
-		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+	if (best) {
+		if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
+		    cpuid_entry_has(best, X86_FEATURE_XSAVEC))  {
+			u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
+
+			best->ebx = xstate_required_size(xstate, true);
+		}
+
+		if (!cpuid_entry_has(best, X86_FEATURE_XSAVES)) {
+			best->ecx = 0;
+			best->edx = 0;
+		}
+		vcpu->arch.guest_supported_xss =
+			(((u64)best->edx << 32) | best->ecx) & supported_xss;
+
+	} else {
+		vcpu->arch.guest_supported_xss = 0;
+	}
 
 	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 528eba526c9c..f0557d47c75e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3124,9 +3124,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
 		 * XSAVES/XRSTORS to save/restore PT MSRs.
 		 */
-		if (data & ~supported_xss)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
-		vcpu->arch.ia32_xss = data;
+		if (vcpu->arch.ia32_xss != data) {
+			vcpu->arch.ia32_xss = data;
+			kvm_update_cpuid_runtime(vcpu);
+		}
 		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
-- 
2.17.2

