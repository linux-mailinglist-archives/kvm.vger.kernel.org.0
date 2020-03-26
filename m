Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDA5193A90
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 09:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgCZIQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 04:16:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:27555 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgCZIQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 04:16:09 -0400
IronPort-SDR: SUHJuVZnkewVjVtgDECCzPAd2H2+obD4XH8blCfMTfykGitYWHzGdi+TlXXfi4sgGsUIY/tGau
 L2x/IsRS1hFA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 01:16:09 -0700
IronPort-SDR: ia4rKTyL1XPXha9coEV6tdHxOPuGJ/SUuOuF5UBwK9yvEoUOtJHGCUc9Ko8++ZkoTo/yq1pEMI
 mSBzZaRpt0FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393898902"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 01:16:06 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 5/9] KVM: X86: Refresh CPUID once guest XSS MSR changes
Date:   Thu, 26 Mar 2020 16:18:42 +0800
Message-Id: <20200326081847.5870-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200326081847.5870-1-weijiang.yang@intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID(0xd, 1) reports the current required storage size of
XCR0 | XSS, when guest updates the XSS, it's necessary to update
the CPUID leaf, otherwise guest will fetch old state size, and
results to some WARN traces during guest running.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 21 ++++++++++++++++++---
 arch/x86/kvm/x86.c              |  9 +++++++--
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 24c90ea5ddbd..2c944ad99692 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -650,6 +650,7 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
 	u32 guest_xstate_size;
 
 	struct kvm_pio_request pio;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 78d461be2102..25e9a11291b3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -95,9 +95,24 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
-		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+	if (best) {
+		if (best->eax & (F(XSAVES) | F(XSAVEC))) {
+			u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
+
+			best->ebx = xstate_required_size(xstate, true);
+		}
+
+		if (best->eax & F(XSAVES)) {
+			vcpu->arch.guest_supported_xss =
+			(best->ecx | ((u64)best->edx << 32)) & supported_xss;
+		} else {
+			best->ecx = 0;
+			best->edx = 0;
+			vcpu->arch.guest_supported_xss = 0;
+		}
+	} else {
+		vcpu->arch.guest_supported_xss = 0;
+	}
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 90acdbbb8a5a..51ecb496d47d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2836,9 +2836,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
 		 * XSAVES/XRSTORS to save/restore PT MSRs.
 		 */
-		if (data & ~supported_xss)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
-		vcpu->arch.ia32_xss = data;
+		if (vcpu->arch.ia32_xss != data) {
+			vcpu->arch.ia32_xss = data;
+			kvm_update_cpuid(vcpu);
+		}
 		break;
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
@@ -9635,6 +9638,8 @@ int kvm_arch_hardware_setup(void)
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
+	else
+		supported_xss = host_xss & KVM_SUPPORTED_XSS;
 
 	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
 
-- 
2.17.2

