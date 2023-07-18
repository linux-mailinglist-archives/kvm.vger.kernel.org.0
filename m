Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51460757EE0
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbjGROBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbjGROAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:00:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0131BC3;
        Tue, 18 Jul 2023 07:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688837; x=1721224837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Zge9RC4suOhS4WSxzkRjdvntcW7BQ3V/JThuasqgeWI=;
  b=kS1aGROFRzzHFqLIS4HE7RkA3kUHg8k4PPGBGorq1wveatdflDN1uklC
   n3xUAeob+JZ4nBvMp9xSzZg1oZr9hTdu6SY5V9juJIJkyqurVfkgwVdYe
   YhJ5IiJpr1KCA/uKyTdMlqCKhk6G/tikc9+AUFatbJeOIVM/vvSY9f2hU
   QZjS3/ddawd32y5mkzc7za3LdFhn5qtZRVE/5iMALDrrgEeZq2+7kG8Xz
   RZmMVLQuYGUTP1b/p8mqedyVx0ffwV4VUkw+oLYyDnzyU2aslgrkUQrk1
   1ZXTi6c9C9EZRcHB01wadXPZCPfO9oJO0DvYKl/pUMhhlWdUdcs7qU7qu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363676199"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="363676199"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:59:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="1054291194"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="1054291194"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:59 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v2 7/8] KVM: x86: Virtualize CR4.LASS
Date:   Tue, 18 Jul 2023 21:18:43 +0800
Message-Id: <20230718131844.5706-8-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230718131844.5706-1-guang.zeng@intel.com>
References: <20230718131844.5706-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
as CR4.LASS generally set once for each vCPU at boot time and won't be
toggled at runtime. Besides, only if VM has LASS capability enumerated with
CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
to set CR4.LASS.

Updating cr4_fixed1 to set CR4.LASS bit in the emulated IA32_VMX_CR4_FIXED1
MSR for guests and allow guests to enable LASS in nested VMX operation as
well.

Notes: Setting CR4.LASS to 1 enable LASS in IA-32e mode. It doesn't take
effect in legacy mode even if CR4.LASS is set.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 3 +++
 arch/x86/kvm/x86.h              | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 791f0dd48cd9..a881b0518a18 100644
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
index 15a7c6e7a25d..e74991bed362 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7603,6 +7603,9 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x7, 1);
+	cr4_fixed1_update(X86_CR4_LASS,       eax, feature_bit(LASS));
+
 #undef cr4_fixed1_update
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c544602d07a3..e1295f490308 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -529,6 +529,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LASS))          \
+		__reserved_bits |= X86_CR4_LASS;        \
 	__reserved_bits;                                \
 })
 
-- 
2.27.0

