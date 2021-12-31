Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B790482474
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 15:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhLaO66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Dec 2021 09:58:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:14076 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhLaO65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Dec 2021 09:58:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640962737; x=1672498737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=3pU68yOPBfgSPZj6Jckk7INJBpH2nTc4/p8+Eo8w+R8=;
  b=njF/81ZraWYfnTuSbfv7zHXFDP2IMi5/RXy66TqV0aDB1xvxT2s1OwNX
   9Q+s6FhsyzUEB/9EhZZZmGg24+j7EcByGotGr4GUulaO9LYodRQjBh4gJ
   kpzKCnIDF++MOtZnyh7XuuHFTpe4nCJ2p8X4cjQiotOnw0QZgetDrqGiE
   MW+A7o7eD60MknnXvr+9qRz4I2riCFKRy2jyb7OgBqzyoLtG6LJluR6vI
   KoAWjmvGcZxIN5uXhdBART/mDPAtqu9NQ/P2qHeocuPzMCONuiNCg9T6d
   awb1qrEW33ewCb0i0rpe9zVn84jq01OQkV/xia0e+vn737NLRodke5Qnc
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="229132977"
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="229132977"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:58:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="524758399"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:58:51 -0800
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v5 1/8] x86/cpu: Add new VMX feature, Tertiary VM-Execution control
Date:   Fri, 31 Dec 2021 22:28:42 +0800
Message-Id: <20211231142849.611-2-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211231142849.611-1-guang.zeng@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

A new 64-bit control field "tertiary processor-based VM-execution
controls", is defined [1]. It's controlled by bit 17 of the primary
processor-based VM-execution controls.

Different from its brother VM-execution fields, this tertiary VM-
execution controls field is 64 bit. So it occupies 2 vmx_feature_leafs,
TERTIARY_CTLS_LOW and TERTIARY_CTLS_HIGH.

Its companion VMX capability reporting MSR,MSR_IA32_VMX_PROCBASED_CTLS3
(0x492), is also semantically different from its brothers, whose 64 bits
consist of all allow-1, rather than 32-bit allow-0 and 32-bit allow-1 [1][2].
Therefore, its init_vmx_capabilities() is a little different from others.

[1] ISE 6.2 "VMCS Changes"
https://www.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

[2] SDM Vol3. Appendix A.3

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h   | 1 +
 arch/x86/include/asm/vmxfeatures.h | 3 ++-
 arch/x86/kernel/cpu/feat_ctl.c     | 9 ++++++++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 01e2650b9585..4914de76ea51 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -921,6 +921,7 @@
 #define MSR_IA32_VMX_TRUE_EXIT_CTLS      0x0000048f
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
+#define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
 
 /* VMX_BASIC bits and bitmasks */
 #define VMX_BASIC_VMCS_SIZE_SHIFT	32
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index d9a74681a77d..ff20776dc83b 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -5,7 +5,7 @@
 /*
  * Defines VMX CPU feature bits
  */
-#define NVMXINTS			3 /* N 32-bit words worth of info */
+#define NVMXINTS			5 /* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -43,6 +43,7 @@
 #define VMX_FEATURE_RDTSC_EXITING	( 1*32+ 12) /* "" VM-Exit on RDTSC */
 #define VMX_FEATURE_CR3_LOAD_EXITING	( 1*32+ 15) /* "" VM-Exit on writes to CR3 */
 #define VMX_FEATURE_CR3_STORE_EXITING	( 1*32+ 16) /* "" VM-Exit on reads from CR3 */
+#define VMX_FEATURE_TERTIARY_CONTROLS	( 1*32+ 17) /* "" Enable Tertiary VM-Execution Controls */
 #define VMX_FEATURE_CR8_LOAD_EXITING	( 1*32+ 19) /* "" VM-Exit on writes to CR8 */
 #define VMX_FEATURE_CR8_STORE_EXITING	( 1*32+ 20) /* "" VM-Exit on reads from CR8 */
 #define VMX_FEATURE_VIRTUAL_TPR		( 1*32+ 21) /* "vtpr" TPR virtualization, a.k.a. TPR shadow */
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index da696eb4821a..993697e71854 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -15,6 +15,8 @@ enum vmx_feature_leafs {
 	MISC_FEATURES = 0,
 	PRIMARY_CTLS,
 	SECONDARY_CTLS,
+	TERTIARY_CTLS_LOW,
+	TERTIARY_CTLS_HIGH,
 	NR_VMX_FEATURE_WORDS,
 };
 
@@ -22,7 +24,7 @@ enum vmx_feature_leafs {
 
 static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 {
-	u32 supported, funcs, ept, vpid, ign;
+	u32 supported, funcs, ept, vpid, ign, low, high;
 
 	BUILD_BUG_ON(NVMXINTS != NR_VMX_FEATURE_WORDS);
 
@@ -42,6 +44,11 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
 	c->vmx_capability[SECONDARY_CTLS] = supported;
 
+	/* All 64 bits of tertiary controls MSR are allowed-1 settings. */
+	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &low, &high);
+	c->vmx_capability[TERTIARY_CTLS_LOW] = low;
+	c->vmx_capability[TERTIARY_CTLS_HIGH] = high;
+
 	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
 	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
 
-- 
2.27.0

