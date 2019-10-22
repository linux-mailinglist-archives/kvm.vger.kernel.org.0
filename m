Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DDBDF969
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 02:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbfJVAPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 20:15:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:27394 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730065AbfJVAPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 20:15:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 17:15:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="191289660"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 21 Oct 2019 17:15:44 -0700
Date:   Mon, 21 Oct 2019 17:15:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 01/16] x86/intel: Initialize IA32_FEATURE_CONTROL MSR
 at boot
Message-ID: <20191022001544.GA32518@linux.intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191021235423.32733-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021235423.32733-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Cc Paolo and Radim, who occasionally work on KVM...

On Mon, Oct 21, 2019 at 04:54:23PM -0700, Sean Christopherson wrote:
> Opportunistically initialize IA32_FEATURE_CONTROL MSR to enable VMX when
> the MSR is left unlocked by BIOS.  Configuring IA32_FEATURE_CONTROL at
> boot time paves the way for similar enabling of other features, e.g.
> Software Guard Extensions (SGX).
> 
> Temporarily leave equivalent KVM code in place in order to avoid
> introducing a regression on Centaur and Zhaoxin CPUs, e.g. removing
> KVM's code would leave the MSR unlocked on those CPUs and would break
> existing functionality if people are loading kvm_intel on Centaur and/or
> Zhaoxin.  Defer enablement of the boot-time configuration on Centaur and
> Zhaoxin to future patches to aid bisection.
> 
> Note, Local Machine Check Exceptions (LMCE) are also supported by the
> kernel and enabled via IA32_FEATURE_CONTROL, but the kernel currently
> uses LMCE if and and only if the feature is explicitly enable by BIOS.
> Keep the current behavior to avoid introducing bugs, future patches can
> opt in to opportunistic enabling if it's deemed desirable to do so.
> 
> Always lock IA32_FEATURE_CONTROL if it exists, even if the CPU doesn't
> support VMX, so that other existing and future kernel code that queries
> IA32_FEATURE_CONTROL can assume it's locked.
> 
> Start from a clean slate when constructing the value to write to
> IA32_FEATURE_CONTROL, i.e. ignore whatever value BIOS left in the MSR so
> as not to enable random features or fault on the WRMSR.
> 
> Suggested-by: Borislav Petkov <bp@suse.de>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,

Fat fingered a comma when manually editing the patch files :-/

> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/Kconfig.cpu                  |  4 ++++
>  arch/x86/kernel/cpu/Makefile          |  1 +
>  arch/x86/kernel/cpu/cpu.h             |  4 ++++
>  arch/x86/kernel/cpu/feature_control.c | 30 +++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/intel.c           |  2 ++
>  5 files changed, 41 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/feature_control.c
> 
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index af9c967782f6..aafc14a0abf7 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -387,6 +387,10 @@ config X86_DEBUGCTLMSR
>  	def_bool y
>  	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486SX || M486) && !UML
>  
> +config X86_FEATURE_CONTROL_MSR
> +	def_bool y
> +	depends on CPU_SUP_INTEL
> +
>  menuconfig PROCESSOR_SELECT
>  	bool "Supported processor vendors" if EXPERT
>  	---help---
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index d7a1e5a9331c..df5ad0cfe3e9 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -29,6 +29,7 @@ obj-y			+= umwait.o
>  obj-$(CONFIG_PROC_FS)	+= proc.o
>  obj-$(CONFIG_X86_FEATURE_NAMES) += capflags.o powerflags.o
>  
> +obj-$(CONFIG_X86_FEATURE_CONTROL_MSR) += feature_control.o
>  ifdef CONFIG_CPU_SUP_INTEL
>  obj-y			+= intel.o intel_pconfig.o
>  obj-$(CONFIG_PM)	+= intel_epb.o
> diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
> index c0e2407abdd6..d2750f53a0cb 100644
> --- a/arch/x86/kernel/cpu/cpu.h
> +++ b/arch/x86/kernel/cpu/cpu.h
> @@ -62,4 +62,8 @@ unsigned int aperfmperf_get_khz(int cpu);
>  
>  extern void x86_spec_ctrl_setup_ap(void);
>  
> +#ifdef CONFIG_X86_FEATURE_CONTROL_MSR
> +void init_feature_control_msr(struct cpuinfo_x86 *c);
> +#endif
> +
>  #endif /* ARCH_X86_CPU_H */
> diff --git a/arch/x86/kernel/cpu/feature_control.c b/arch/x86/kernel/cpu/feature_control.c
> new file mode 100644
> index 000000000000..57b928e64cf5
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/feature_control.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/tboot.h>
> +
> +#include <asm/cpufeature.h>
> +#include <asm/msr-index.h>
> +#include <asm/processor.h>
> +
> +void init_feature_control_msr(struct cpuinfo_x86 *c)
> +{
> +	u64 msr;
> +
> +	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr))
> +		return;
> +
> +	if (msr & FEATURE_CONTROL_LOCKED)
> +		return;
> +
> +	/*
> +	 * Ignore whatever value BIOS left in the MSR to avoid enabling random
> +	 * features or faulting on the WRMSR.
> +	 */
> +	msr = FEATURE_CONTROL_LOCKED;
> +
> +	if (cpu_has(c, X86_FEATURE_VMX)) {
> +		msr |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> +		if (tboot_enabled())
> +			msr |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
> +	}
> +	wrmsrl(MSR_IA32_FEATURE_CONTROL, msr);
> +}
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index c2fdc00df163..15d59224e2f8 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -755,6 +755,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  	/* Work around errata */
>  	srat_detect_node(c);
>  
> +	init_feature_control_msr(c);
> +
>  	if (cpu_has(c, X86_FEATURE_VMX))
>  		detect_vmx_virtcap(c);
>  
> -- 
> 2.22.0
> 
