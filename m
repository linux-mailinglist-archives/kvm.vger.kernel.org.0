Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10635193A94
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 09:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgCZIQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 04:16:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:27564 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbgCZIQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 04:16:18 -0400
IronPort-SDR: B/rmdGlZCnWPdkaPP91mM52EKaMjxmWF751KIkxqA/Y/FprEe5BamcJQ3IWAVi6kEcuQ5Q2k7M
 yHxonq1GrOcg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 01:16:18 -0700
IronPort-SDR: Sek5WpgEkEEvLjv9+ommwoM4eH/3WZppY0gqYdFIsJUdH4dUBbH5BkS+bVs7OjaaWEQHrFQNUJ
 +XuyV6wF5c5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393899012"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 01:16:16 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 9/9] KVM: X86: Set CET feature bits for CPUID enumeration
Date:   Thu, 26 Mar 2020 16:18:46 +0800
Message-Id: <20200326081847.5870-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200326081847.5870-1-weijiang.yang@intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the feature bits so that CET capabilities can be seen
in guest via CPUID enumeration. Add CR4.CET bit support
in order to allow guest set CET master control bit(CR4.CET).

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/cpuid.c            | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c944ad99692..5109c43c6981 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -95,7 +95,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 25e9a11291b3..26ab959df92f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -366,6 +366,10 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
+	if (boot_cpu_has(X86_FEATURE_IBT))
+		kvm_cpu_cap_set(X86_FEATURE_IBT);
+	if (boot_cpu_has(X86_FEATURE_SHSTK))
+		kvm_cpu_cap_set(X86_FEATURE_SHSTK);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX512_BF16)
-- 
2.17.2

