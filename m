Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F3232DFCE
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 03:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEC5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 21:57:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:45036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhCEC5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 21:57:11 -0500
IronPort-SDR: oiHZ1NRm8YLjBLpLhbMmqkb9LPXxMt8aZkGowG1pJ5dYIS3cKJDwXCgE/lDbosS9gi2G6LbOfs
 suBKgWVU6oAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="187661418"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="187661418"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 18:57:10 -0800
IronPort-SDR: 6FIjyMdCIQvChNHVmNPv7mGl1/6toRLn0YhGofCH+GsVdnd/XPwfb8pgBVA6JP9Rdr3uJHojNO
 9YymqerobBEA==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="401103565"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 18:57:07 -0800
Subject: Re: [PATCH v3 9/9] KVM: x86: Add XSAVE Support for Architectural LBRs
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-10-like.xu@linux.intel.com>
 <YD/PYp0DtZaw2HYh@google.com>
 <b6b3476b-3278-9a40-33a9-0014fed9bbfb@linux.intel.com>
 <YEELZUP3BjStSvHq@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <860c429d-c0d8-fae6-955d-dd8560f2f9c5@intel.com>
Date:   Fri, 5 Mar 2021 10:57:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YEELZUP3BjStSvHq@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/5 0:31, Sean Christopherson wrote:
> Paolo, any thoughts on how to keep supported_xss aligned with support_xcr0,
> without spreading the logic around too much?

 From 58be4152ced441395dfc439f446c5ad53bd48576 Mon Sep 17 00:00:00 2001
From: Like Xu <like.xu@linux.intel.com>
Date: Thu, 4 Mar 2021 13:21:38 +0800
Subject: [PATCH] KVM: x86: Refine the matching and clearing logic for 
supported_xss

"The existing clearing of supported_xss here is pointless".
Let's refine the code path in this way: initialize the supported_xss
with the filter of KVM_SUPPORTED_XSS mask and update its value in
a bit clear manner (rather than bit setting).

Before:
(1) kvm_arch_hardware_setup
     if (boot_cpu_has(X86_FEATURE_XSAVES))
         rdmsrl(MSR_IA32_XSS, host_xss);
     if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
         supported_xss = 0;
     else supported_xss &= host_xss;
(2) vmx_set_cpu_caps
     supported_xss = 0;
     if (!cpu_has_vmx_xsaves())
         kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
     else set available bits to supported_xss

After:
(1) kvm_arch_init
     if (boot_cpu_has(X86_FEATURE_XSAVES))
         rdmsrl(MSR_IA32_XSS, host_xss);
         supported_xss = host_xss & KVM_SUPPORTED_XSS;
(2) vmx_set_cpu_caps
     if (!cpu_has_vmx_xsaves())
         kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
         supported_xss = 0;
     else clear un-available bits for supported_xss

Suggested-by: Sean Christopherson <seanjc@google.com>
Original-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
  arch/x86/kvm/vmx/vmx.c |  5 +++--
  arch/x86/kvm/x86.c     | 13 +++++++------
  2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bc4bb49aaa9..8706323547c4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7288,9 +7288,10 @@ static __init void vmx_set_cpu_caps(void)
          kvm_cpu_cap_set(X86_FEATURE_UMIP);

      /* CPUID 0xD.1 */
-    supported_xss = 0;
-    if (!cpu_has_vmx_xsaves())
+    if (!cpu_has_vmx_xsaves()) {
          kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+        supported_xss = 0;
+    }

      /* CPUID 0x80000001 */
      if (!cpu_has_vmx_rdtscp())
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d773836ceb7a..99cb62035bb2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -205,6 +205,8 @@ static struct kvm_user_return_msrs __percpu 
*user_return_msrs;
                  | XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
                  | XFEATURE_MASK_PKRU)

+#define KVM_SUPPORTED_XSS     0
+
  u64 __read_mostly host_efer;
  EXPORT_SYMBOL_GPL(host_efer);

@@ -8046,6 +8048,11 @@ int kvm_arch_init(void *opaque)
          supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
      }

+    if (boot_cpu_has(X86_FEATURE_XSAVES)) {
+        rdmsrl(MSR_IA32_XSS, host_xss);
+        supported_xss = host_xss & KVM_SUPPORTED_XSS;
+    }
+
      if (pi_inject_timer == -1)
          pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);
  #ifdef CONFIG_X86_64
@@ -10421,9 +10428,6 @@ int kvm_arch_hardware_setup(void *opaque)

      rdmsrl_safe(MSR_EFER, &host_efer);

-    if (boot_cpu_has(X86_FEATURE_XSAVES))
-        rdmsrl(MSR_IA32_XSS, host_xss);
-
      r = ops->hardware_setup();
      if (r != 0)
          return r;
@@ -10431,9 +10435,6 @@ int kvm_arch_hardware_setup(void *opaque)
      memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
      kvm_ops_static_call_update();

-    if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-        supported_xss = 0;
-
  #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
      cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
  #undef __kvm_cpu_cap_has
-- 
2.29.2


