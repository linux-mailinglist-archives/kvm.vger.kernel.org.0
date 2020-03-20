Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4C018C5FD
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 04:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgCTDkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 23:40:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:27908 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbgCTDkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 23:40:51 -0400
IronPort-SDR: tJHduf5hFrMiOf0apiid2CyYJsY8nhsvCeSwf1kgN59Yl1L4KJgeBbvoy2zAjMEzkCKElwdplg
 DQbZqU2nhoHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 20:40:50 -0700
IronPort-SDR: Y7bEvzzjGFuBXS4T7AazVxPvEeOlusBWvwbhI/OmD10zfDDNsPoeYKCx83AKtUndG0hYg9I9Qz
 ozlWA/n7VMRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="263945594"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 19 Mar 2020 20:40:48 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 4/8] KVM: X86: Refresh CPUID on guest XSS change
Date:   Fri, 20 Mar 2020 11:43:37 +0800
Message-Id: <20200320034342.26610-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200320034342.26610-1-weijiang.yang@intel.com>
References: <20200320034342.26610-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID(0xd, 1) reports the current required storage size of
XCR0 | XSS, when guest updates the XSS, it's necessary to update
the CPUID leaf, otherwise guest will fetch stale state, this
result into some WARNs during guest running.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c | 18 +++++++++++++++---
 arch/x86/kvm/x86.c   |  7 ++++++-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 78d461be2102..71703d9277ee 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -95,9 +95,21 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
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
+			supported_xss &= best->ecx | ((u64)best->edx << 32);
+		} else {
+			best->ecx = 0;
+			best->edx = 0;
+			supported_xss = 0;
+		}
+	}
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 90acdbbb8a5a..5be6fad6e08d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2838,7 +2838,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		if (data & ~supported_xss)
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

