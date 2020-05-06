Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957921C6B70
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgEFITl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:19:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:35417 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728709AbgEFITk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:19:40 -0400
IronPort-SDR: yRR3HhBbyagAAukZAfp+wwXattUmfxqvxhX9C+r4xVtWOcre+c1tv6WMoZ6wXytYCwqrPCorit
 A0gZmmHJDskQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 01:19:40 -0700
IronPort-SDR: eh7QzM/Fgzi9yaY27HXDkB9uv1VZc2B0Rc0WwSAgOaRwgjID41eMzyTlOOj+P7wm61TvNjtoLO
 sPxqkdMqRyIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="260030094"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 01:19:38 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 04/10] KVM: x86: Refresh CPUID once guest changes XSS bits
Date:   Wed,  6 May 2020 16:21:03 +0800
Message-Id: <20200506082110.25441-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID(0xd, 1) reports the current required storage size of XCR0 | XSS,
when guest updates the XSS, it's necessary to update the CPUID leaf, otherwise
guest will fetch old state size, and results to some WARN traces during guest
running.

supported_xss is initialized to host_xss & KVM_SUPPORTED_XSS to indicate current
MSR_IA32_XSS bits supported in KVM, but actual XSS bits seen in guest depends
on the setting of CPUID(0xd,1).{ECX, EDX} for guest.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 23 +++++++++++++++++++----
 arch/x86/kvm/x86.c              | 12 ++++++++----
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..f68c825e94ad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -649,6 +649,7 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
 	u32 guest_xstate_size;
 
 	struct kvm_pio_request pio;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..984ab2b395b3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -89,15 +89,30 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
 	} else {
 		vcpu->arch.guest_supported_xcr0 =
-			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+			(((u64)best->edx << 32) | best->eax) & supported_xcr0;
 		vcpu->arch.guest_xstate_size = best->ebx =
 			xstate_required_size(vcpu->arch.xcr0, false);
 	}
 
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
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b63727318da1..c866087ed0ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2843,9 +2843,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -9678,8 +9681,9 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 
-	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-		supported_xss = 0;
+	supported_xss = 0;
+	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
+		supported_xss = host_xss & KVM_SUPPORTED_XSS;
 
 	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
 
-- 
2.17.2

