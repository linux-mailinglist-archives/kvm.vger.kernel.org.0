Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23AAD2220
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 09:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733041AbfJJHvX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Oct 2019 03:51:23 -0400
Received: from ZXSHCAS2.zhaoxin.com ([203.148.12.82]:23553 "EHLO
        ZXSHCAS2.zhaoxin.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726923AbfJJHvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 03:51:23 -0400
X-Greylist: delayed 1025 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Oct 2019 03:51:22 EDT
Received: from zxbjmbx3.zhaoxin.com (10.29.252.165) by ZXSHCAS2.zhaoxin.com
 (10.28.252.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Thu, 10 Oct
 2019 15:34:12 +0800
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by zxbjmbx3.zhaoxin.com
 (10.29.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1261.35; Thu, 10 Oct
 2019 15:34:11 +0800
Received: from zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d]) by
 zxbjmbx1.zhaoxin.com ([fe80::b41a:737:a784:b70d%16]) with mapi id
 15.01.1261.035; Thu, 10 Oct 2019 15:34:10 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Tony Luck <tony.luck@intel.com>
CC:     "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 10/16] x86/cpu: Detect VMX features on Intel, Centaur and
 Zhaoxin CPUs
Thread-Topic: [PATCH 10/16] x86/cpu: Detect VMX features on Intel, Centaur and
 Zhaoxin CPUs
Thread-Index: AdV/N2CFO6695ALbQceRWx1UpfjT2Q==
Date:   Thu, 10 Oct 2019 07:34:10 +0000
Message-ID: <96b40a7defd942799f50481c4c5292a4@zhaoxin.com>
Accept-Language: en-US, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.64.2]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 5, 2019, Sean Christopherson wrote:
>Add an entry in struct cpuinfo_x86 to track VMX capabilities and fill
>the capabilities during IA32_FEATURE_CONTROL MSR initialization.
>
>Make the VMX capabilities dependent on X86_INTEL_FEATURE_CONTROL and
>X86_FEATURE_NAMES so as to avoid unnecessary overhead on CPUs that
>can't
>possibly support VMX, or when /proc/cpuinfo is not available.
>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>---
> arch/x86/Kconfig.cpu                  |  4 ++
> arch/x86/include/asm/processor.h      |  3 ++
> arch/x86/include/asm/vmxfeatures.h    |  5 +++
> arch/x86/kernel/cpu/common.c          |  3 ++
> arch/x86/kernel/cpu/feature_control.c | 59
>+++++++++++++++++++++++++++
> 5 files changed, 74 insertions(+)
>
>diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
>index e78f39adae7b..e7571bd0f515 100644
>--- a/arch/x86/Kconfig.cpu
>+++ b/arch/x86/Kconfig.cpu
>@@ -391,6 +391,10 @@ config X86_FEATURE_CONTROL_MSR
> 	def_bool y
> 	depends on CPU_SUP_INTEL || CPU_SUP_CENTAUR ||
>CPU_SUP_ZHAOXIN
>
>+config X86_VMX_FEATURE_NAMES
>+	def_bool y
>+	depends on X86_FEATURE_CONTROL_MSR &&
>X86_FEATURE_NAMES
>+
> menuconfig PROCESSOR_SELECT
> 	bool "Supported processor vendors" if EXPERT
> 	---help---
>diff --git a/arch/x86/include/asm/processor.h
>b/arch/x86/include/asm/processor.h
>index 4c3f41d7be5f..3b5dc9b1e7c4 100644
>--- a/arch/x86/include/asm/processor.h
>+++ b/arch/x86/include/asm/processor.h
>@@ -84,6 +84,9 @@ struct cpuinfo_x86 {
> #ifdef CONFIG_X86_64
> 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
> 	int			x86_tlbsize;
>+#endif
>+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
>+	__u32			vmx_capability[NVMXINTS];
> #endif
> 	__u8			x86_virt_bits;
> 	__u8			x86_phys_bits;
>diff --git a/arch/x86/include/asm/vmxfeatures.h
>b/arch/x86/include/asm/vmxfeatures.h
>index ab82e3643d0c..d33ea1c165fd 100644
>--- a/arch/x86/include/asm/vmxfeatures.h
>+++ b/arch/x86/include/asm/vmxfeatures.h
>@@ -2,6 +2,11 @@
> #ifndef _ASM_X86_VMXFEATURES_H
> #define _ASM_X86_VMXFEATURES_H
>
>+/*
>+ * Defines VMX CPU feature bits
>+ */
>+#define NVMXINTS			3 /* N 32-bit words worth of info */
>+
> /*
>  * Note: If the comment begins with a quoted string, that string is used
>  * in /proc/cpuinfo instead of the macro name.  If the string is "",
>diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>index 9ae7d1bcd4f4..33537556dac6 100644
>--- a/arch/x86/kernel/cpu/common.c
>+++ b/arch/x86/kernel/cpu/common.c
>@@ -1421,6 +1421,9 @@ static void identify_cpu(struct cpuinfo_x86 *c)
> #endif
> 	c->x86_cache_alignment = c->x86_clflush_size;
> 	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
>+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
>+	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
>+#endif
>
> 	generic_identify(c);
>
>diff --git a/arch/x86/kernel/cpu/feature_control.c
>b/arch/x86/kernel/cpu/feature_control.c
>index 74c76159a046..43eb65e8cd18 100644
>--- a/arch/x86/kernel/cpu/feature_control.c
>+++ b/arch/x86/kernel/cpu/feature_control.c
>@@ -4,6 +4,61 @@
> #include <asm/cpufeature.h>
> #include <asm/msr-index.h>
> #include <asm/processor.h>
>+#include <asm/vmx.h>
>+
>+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
>+enum vmx_feature_leafs {
>+	MISC_FEATURES = 0,
>+	PRIMARY_PROC_CONTROLS,
>+	SECONDARY_PROC_CONTROLS,
>+	NR_VMX_FEATURE_WORDS,
>+};
>+
>+#define EPT_BIT(x) BIT(VMX_FEATURE_##x & 0x1f)
>+
>+static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>+{
>+	u32 supported, funcs, ept, vpid, ign;
>+
>+	BUILD_BUG_ON(NVMXINTS != NR_VMX_FEATURE_WORDS);
>+
>+	/*
>+	 * The high bits contain the allowed-1 settings, i.e. features that can
>+	 * be turned on.  The low bits contain the allowed-0 settings, i.e.
>+	 * features that can be turned off.  Ignore the allowed-0 settings,
>+	 * if a feature can be turned on then it's supported.
>+	 */
>+	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
>+	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
>+
>+	/*
>+	 * Except for EPT+VPID, which enumerates support for both in a single
>+	 * MSR, low for EPT, high for VPID.
>+	 */
>+	rdmsr_safe(MSR_IA32_VMX_EPT_VPID_CAP, &ept, &vpid);
>+
>+	/* Pin, EPT, VPID and VM-Func are merged into a single word. */
>+	WARN_ON_ONCE(supported >> 16);
>+	WARN_ON_ONCE(funcs >> 4);
>+	c->vmx_capability[MISC_FEATURES] = (supported & 0xffff) |
>+					   ((vpid & 0x1) << 24) |
>+					   ((funcs & 0xf) << 28);
>+
>+	/* EPT bits are scattered and must be manually handled. */
>+	if (ept & VMX_EPT_EXECUTE_ONLY_BIT)
>+		c->vmx_capability[MISC_FEATURES] |=
>EPT_BIT(EPT_EXECUTE_ONLY);
>+	if (ept & VMX_EPT_1GB_PAGE_BIT)

Typo? Should be: if (ept & VMX_EPT_AD_BIT)

TonyWWang-oc

>+		c->vmx_capability[MISC_FEATURES] |= EPT_BIT(EPT_AD);
>+	if (ept & VMX_EPT_1GB_PAGE_BIT)
>+		c->vmx_capability[MISC_FEATURES] |= EPT_BIT(EPT_1GB);
>+
>+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, ign, supported);
>+	c->vmx_capability[PRIMARY_PROC_CONTROLS] = supported;
>+
>+	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
>+	c->vmx_capability[SECONDARY_PROC_CONTROLS] = supported;
>+}
>+#endif /* CONFIG_X86_VMX_FEATURE_NAMES */
>
> void init_feature_control_msr(struct cpuinfo_x86 *c)
> {
>@@ -43,5 +98,9 @@ void init_feature_control_msr(struct cpuinfo_x86 *c)
> 		pr_err_once("x86/cpu: VMX disabled by BIOS (TXT %s)\n",
> 			    tboot ? "enabled" : "disabled");
> 		clear_cpu_cap(c, X86_FEATURE_VMX);
>+	} else {
>+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
>+		init_vmx_capabilities(c);
>+#endif
> 	}
> }
>--
>2.22.0

