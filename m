Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6564CD038
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 09:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiCDIkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 03:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbiCDIjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 03:39:51 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078E01A1C43;
        Fri,  4 Mar 2022 00:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646383113; x=1677919113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=2JwYCUkWRBQO1GrsiLTxp1cOwxh2KJnv2QZle05c0d0=;
  b=F57CBDbZKrkwjlRu94FLsnlHbqM0qsbA/nHwiTFiiASg3rijXUErfv0B
   duERhcbE/jBiYd+abk4D6EbLfDV3Px3UoqbSr7D0RG4JXN6lMYzaEH0VV
   nVWAwgkJpXIGN/bi+HwFZAILHFI1sV87GFXKkEc2qPsmDQXXamjaJj71H
   qvnxR7t0WjcYXf6drh5nqPTn+q7fN+MFIU7QLaLqZancq+ywa48F3VZ0y
   2383FA0n/pi96Fm80UvDnHHuY2WAhqJjrU/I/32Em9AIU+bDcG/OAH0c3
   BjuzDkhA5zq+LxdSCfWOQSkuEA1cxJbKDDnSLee90b2RicGY562tDlcQ4
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="317156381"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="317156381"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:11 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="552141430"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:06 -0800
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
Subject: [PATCH v7 1/8] x86/cpu: Add new VMX feature, Tertiary VM-Execution control
Date:   Fri,  4 Mar 2022 16:07:18 +0800
Message-Id: <20220304080725.18135-2-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304080725.18135-1-guang.zeng@intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/msr-index.h   | 1 +
 arch/x86/include/asm/vmxfeatures.h | 3 ++-
 arch/x86/kernel/cpu/feat_ctl.c     | 9 ++++++++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3faf0f97edb1..1d180f883c32 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -938,6 +938,7 @@
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

