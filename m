Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC187E4E95
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 16:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394886AbfJYOJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 10:09:35 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52284 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391324AbfJYOJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 10:09:35 -0400
Received: from zn.tnic (p200300EC2F0D3C00E44239D1C9BE3FA7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:3c00:e442:39d1:c9be:3fa7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 484A21EC0CE1;
        Fri, 25 Oct 2019 16:09:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1572012573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+C6mKmZZ5S3DdVeKlW6aKNXT1yyWYechglTTa0VWFrE=;
        b=HKK/h3mMGg3QNwZ9YDV2429PzQliZrC7bRjcq1Gy+mDq3QfNXh0fQo7r085epDrKzWBOJc
        6EGveb8bVq7XhqDDLWqZrEebciQwfUoc3sYpwzAvwclSjlJ+m+QMyoil85/ViuPcl0jal7
        qrM2EzR2ODqGz1SGbuWzNi85qU8/Lz4=
Date:   Fri, 25 Oct 2019 16:09:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 01/16] x86/intel: Initialize IA32_FEATURE_CONTROL MSR
 at boot
Message-ID: <20191025140927.GC6483@zn.tnic>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191021235423.32733-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191021235423.32733-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

s/enable/enabled/

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

Why the separate compilation unit and the Kconfig variable? This can
live in ...cpu/intel.c just fine, right?

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

Any chance you can do s/FEATURE_CONTROL_/FT_CTL_/ or FEAT_CTL or so, to
those bit defines and maybe the MSR define too? They're a mouthful now.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
