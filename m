Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D5C6E96C2
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjDTOQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjDTOQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:16:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070D64217;
        Thu, 20 Apr 2023 07:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682000175; x=1713536175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=X5UoG8xozByeuHc7S3vpOJzvxFI1farY3KuVu17e7rI=;
  b=i1G+nSwSA3A/rIQhPBT0v/OzlJBcAwumWOj9gIYVd3wNc8/8p6TRMtWx
   iev1XfOCWlYOvonefpGvtKruF9q1IYjr1hWTMtugs3P0gH/nrCrRfXih/
   9bS38O/3ySWmIoN396nteyaq3sTvxapc4xrPPL2YsxSfAaXksUC70+Lw+
   Fn5GoqtkP2ZDeoLkbY6/9Qs+d2GVZZIKxRjf+t92nNziyU5DVeqM4+FzX
   GWYgJ48RCWH6nY5xCFN07D1U2cpORw5kAWZrekH2JFKYkZdQgT97m9/Kn
   V2qZiD9nJvLH8yPqfZ4O1Z9uCfwIUBYMAOR7ZUlFYCSZtLMee2Q+cd3cs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343217782"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="343217782"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="816028815"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="816028815"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.53])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:00 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH 1/6] KVM: x86: Virtualize CR4.LASS
Date:   Thu, 20 Apr 2023 21:37:19 +0800
Message-Id: <20230420133724.11398-2-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230420133724.11398-1-guang.zeng@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
as CR4.LASS generally set once for each vCPU at boot time and won't be
toggled at runtime. Besides, only if VM has LASS capability enumerated with
CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
to set CR4.LASS. By design CR4.LASS can be manipulated by nested guest as
well.

Notes: Setting CR4.LASS to 1 enable LASS in IA-32e mode. It doesn't take
effect in legacy mode even if CR4.LASS is set.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 3 +++
 arch/x86/kvm/x86.h              | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6aaae18f1854..8ff89a52ef66 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -125,7 +125,7 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP | X86_CR4_LASS))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 43ff3276918b..c923d7599d71 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7569,6 +7569,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
+	cr4_fixed1_update(X86_CR4_LASS,       eax, feature_bit(LASS));
+
 #undef cr4_fixed1_update
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 7c8a30d44c29..218f4c73789a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -475,6 +475,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LASS))          \
+		__reserved_bits |= X86_CR4_LASS;        \
 	__reserved_bits;                                \
 })
 
-- 
2.27.0

