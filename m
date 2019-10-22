Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E346EDF956
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbfJVAI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:08:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:14976 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730379AbfJVAIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:08:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 17:08:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="281121009"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 21 Oct 2019 17:08:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 10/16] x86/cpu: Detect VMX features on Intel, Centaur and Zhaoxin CPUs
Date:   Mon, 21 Oct 2019 17:08:53 -0700
Message-Id: <20191022000853.2225-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191021234632.32363-1-sean.j.christopherson@intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an entry in struct cpuinfo_x86 to track VMX capabilities and fill
the capabilities during IA32_FEATURE_CONTROL MSR initialization.

Make the VMX capabilities dependent on X86_FEATURE_CONTROL_MSR and
X86_FEATURE_NAMES so as to avoid unnecessary overhead on CPUs that can't
possibly support VMX, or when /proc/cpuinfo is not available.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/Kconfig.cpu                  |  4 ++
 arch/x86/include/asm/processor.h      |  3 ++
 arch/x86/include/asm/vmxfeatures.h    |  5 ++
 arch/x86/kernel/cpu/common.c          |  3 ++
 arch/x86/kernel/cpu/feature_control.c | 70 +++++++++++++++++++++++++++
 5 files changed, 85 insertions(+)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index e78f39adae7b..e7571bd0f515 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -391,6 +391,10 @@ config X86_FEATURE_CONTROL_MSR
 	def_bool y
 	depends on CPU_SUP_INTEL || CPU_SUP_CENTAUR || CPU_SUP_ZHAOXIN
 
+config X86_VMX_FEATURE_NAMES
+	def_bool y
+	depends on X86_FEATURE_CONTROL_MSR && X86_FEATURE_NAMES
+
 menuconfig PROCESSOR_SELECT
 	bool "Supported processor vendors" if EXPERT
 	---help---
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4c3f41d7be5f..3b5dc9b1e7c4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -84,6 +84,9 @@ struct cpuinfo_x86 {
 #ifdef CONFIG_X86_64
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			x86_tlbsize;
+#endif
+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
+	__u32			vmx_capability[NVMXINTS];
 #endif
 	__u8			x86_virt_bits;
 	__u8			x86_phys_bits;
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index aea39b9f1587..bfc96d4049a7 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -2,6 +2,11 @@
 #ifndef _ASM_X86_VMXFEATURES_H
 #define _ASM_X86_VMXFEATURES_H
 
+/*
+ * Defines VMX CPU feature bits
+ */
+#define NVMXINTS			3 /* N 32-bit words worth of info */
+
 /*
  * Note: If the comment begins with a quoted string, that string is used
  * in /proc/cpuinfo instead of the macro name.  If the string is "",
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9ae7d1bcd4f4..33537556dac6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1421,6 +1421,9 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 #endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
+	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
+#endif
 
 	generic_identify(c);
 
diff --git a/arch/x86/kernel/cpu/feature_control.c b/arch/x86/kernel/cpu/feature_control.c
index 74c76159a046..5fee84eaa130 100644
--- a/arch/x86/kernel/cpu/feature_control.c
+++ b/arch/x86/kernel/cpu/feature_control.c
@@ -4,6 +4,72 @@
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
 #include <asm/processor.h>
+#include <asm/vmx.h>
+
+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
+enum vmx_feature_leafs {
+	MISC_FEATURES = 0,
+	PRIMARY_PROC_CTLS,
+	SECONDARY_PROC_CTLS,
+	NR_VMX_FEATURE_WORDS,
+};
+
+#define F(x) BIT(VMX_FEATURE_##x & 0x1f)
+
+static void init_vmx_capabilities(struct cpuinfo_x86 *c)
+{
+	u32 supported, funcs, ept, vpid, ign;
+
+	BUILD_BUG_ON(NVMXINTS != NR_VMX_FEATURE_WORDS);
+
+	/*
+	 * The high bits contain the allowed-1 settings, i.e. features that can
+	 * be turned on.  The low bits contain the allowed-0 settings, i.e.
+	 * features that can be turned off.  Ignore the allowed-0 settings,
+	 * if a feature can be turned on then it's supported.
+	 */
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, ign, supported);
+	c->vmx_capability[PRIMARY_PROC_CTLS] = supported;
+
+	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
+	c->vmx_capability[SECONDARY_PROC_CTLS] = supported;
+
+	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
+	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
+
+	/*
+	 * Except for EPT+VPID, which enumerates support for both in a single
+	 * MSR, low for EPT, high for VPID.
+	 */
+	rdmsr_safe(MSR_IA32_VMX_EPT_VPID_CAP, &ept, &vpid);
+
+	/* Pin, EPT, VPID and VM-Func are merged into a single word. */
+	WARN_ON_ONCE(supported >> 16);
+	WARN_ON_ONCE(funcs >> 4);
+	c->vmx_capability[MISC_FEATURES] = (supported & 0xffff) |
+					   ((vpid & 0x1) << 16) |
+					   ((funcs & 0xf) << 28);
+
+	/* EPT bits are full on scattered and must be manually handled. */
+	if (ept & VMX_EPT_EXECUTE_ONLY_BIT)
+		c->vmx_capability[MISC_FEATURES] |= F(EPT_EXECUTE_ONLY);
+	if (ept & VMX_EPT_AD_BIT)
+		c->vmx_capability[MISC_FEATURES] |= F(EPT_AD);
+	if (ept & VMX_EPT_1GB_PAGE_BIT)
+		c->vmx_capability[MISC_FEATURES] |= F(EPT_1GB);
+
+	/* Synthetic APIC features that are aggregates of multiple features. */
+	if ((c->vmx_capability[PRIMARY_PROC_CTLS] & F(VIRTUAL_TPR)) &&
+	    (c->vmx_capability[SECONDARY_PROC_CTLS] & F(VIRT_APIC_ACCESSES)))
+		c->vmx_capability[MISC_FEATURES] |= F(FLEXPRIORITY);
+
+	if ((c->vmx_capability[PRIMARY_PROC_CTLS] & F(VIRTUAL_TPR)) &&
+	    (c->vmx_capability[SECONDARY_PROC_CTLS] & F(APIC_REGISTER_VIRT)) &&
+	    (c->vmx_capability[SECONDARY_PROC_CTLS] & F(VIRT_INTR_DELIVERY)) &&
+	    (c->vmx_capability[MISC_FEATURES] & F(POSTED_INTR)))
+		c->vmx_capability[MISC_FEATURES] |= F(APICV);
+}
+#endif /* CONFIG_X86_VMX_FEATURE_NAMES */
 
 void init_feature_control_msr(struct cpuinfo_x86 *c)
 {
@@ -43,5 +109,9 @@ void init_feature_control_msr(struct cpuinfo_x86 *c)
 		pr_err_once("x86/cpu: VMX disabled by BIOS (TXT %s)\n",
 			    tboot ? "enabled" : "disabled");
 		clear_cpu_cap(c, X86_FEATURE_VMX);
+	} else {
+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
+		init_vmx_capabilities(c);
+#endif
 	}
 }
-- 
2.22.0

