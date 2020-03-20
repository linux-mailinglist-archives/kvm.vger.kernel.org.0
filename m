Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFC918C5FB
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 04:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgCTDlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 23:41:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:27908 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgCTDlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 23:41:00 -0400
IronPort-SDR: WO4nwzeyq+4PvF7Rza97GKV/TbRalAAGy3xeSb7CZRGTOhD2Ce14y52345UGJkOlfz7oGuwalw
 IaMvB8F9HPHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 20:40:59 -0700
IronPort-SDR: A0suKYNLrI9mEJUhorY+5BRwYs46z+GHZJ1e3nAGsh46rBqP+zVHMtT8TPwQ0FPtKc8sDadN04
 ZyWh8m4VyBww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="263945626"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 19 Mar 2020 20:40:57 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 8/8] KVM: X86: Set CET feature bits for CPUID enumeration
Date:   Fri, 20 Mar 2020 11:43:41 +0800
Message-Id: <20200320034342.26610-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200320034342.26610-1-weijiang.yang@intel.com>
References: <20200320034342.26610-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the feature bits so that CET capabilities can be see
in guest via CPUID enumeration. Add CR4.CET bit support
in order to allow guest set CET master control bit.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/cpuid.c            | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 24c90ea5ddbd..3b6dba7e610e 100644
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
index 71703d9277ee..9e19775c4105 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -363,6 +363,10 @@ void kvm_set_cpu_caps(void)
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

