Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815693CB30D
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 09:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbhGPHQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 03:16:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:40483 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhGPHQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 03:16:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="274512958"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="274512958"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 00:13:25 -0700
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="506374962"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.1])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 00:13:20 -0700
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
Subject: [PATCH 1/6] x86/feat_ctl: Add new VMX feature, Tertiary VM-Execution control
Date:   Fri, 16 Jul 2021 14:48:03 +0800
Message-Id: <20210716064808.14757-2-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716064808.14757-1-guang.zeng@intel.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

New VMX capability MSR IA32_VMX_PROCBASED_CTLS3 conresponse to this new
VM-Execution control field. And it is 64bit allow-1 semantics, not like
previous capability MSRs 32bit allow-0 and 32bit allow-1. So with Tertiary
VM-Execution control field introduced, 2 vmx_feature leaves are introduced,
TERTIARY_CTLS_LOW and TERTIARY_CTLS_HIGH.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/msr-index.h   | 1 +
 arch/x86/include/asm/vmxfeatures.h | 3 ++-
 arch/x86/kernel/cpu/feat_ctl.c     | 9 +++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a7c413432b33..3df26e27b554 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -919,6 +919,7 @@
 #define MSR_IA32_VMX_TRUE_EXIT_CTLS      0x0000048f
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
+#define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
 
 /* VMX_BASIC bits and bitmasks */
 #define VMX_BASIC_VMCS_SIZE_SHIFT	32
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index d9a74681a77d..27e76eeca05b 100644
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
+#define VMX_FEATURE_TER_CONTROLS	(1*32 + 17) /* "" Enable Tertiary VM-Execution Controls */
 #define VMX_FEATURE_CR8_LOAD_EXITING	( 1*32+ 19) /* "" VM-Exit on writes to CR8 */
 #define VMX_FEATURE_CR8_STORE_EXITING	( 1*32+ 20) /* "" VM-Exit on reads from CR8 */
 #define VMX_FEATURE_VIRTUAL_TPR		( 1*32+ 21) /* "vtpr" TPR virtualization, a.k.a. TPR shadow */
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index da696eb4821a..2e0272d127e4 100644
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
 
@@ -42,6 +44,13 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
 	c->vmx_capability[SECONDARY_CTLS] = supported;
 
+	/*
+	 * For tertiary execution controls MSR, it's actually a 64bit allowed-1.
+	 */
+	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &ign, &supported);
+	c->vmx_capability[TERTIARY_CTLS_LOW] = ign;
+	c->vmx_capability[TERTIARY_CTLS_HIGH] = supported;
+
 	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
 	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
 
-- 
2.25.1

