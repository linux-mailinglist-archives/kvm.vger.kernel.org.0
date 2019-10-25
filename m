Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B10FE4FDA
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502853AbfJYPLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 11:11:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:61358 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502015AbfJYPLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 11:11:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 08:11:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="210385776"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 25 Oct 2019 08:11:14 -0700
Date:   Fri, 25 Oct 2019 08:11:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 01/16] x86/intel: Initialize IA32_FEATURE_CONTROL MSR
 at boot
Message-ID: <20191025151114.GC17290@linux.intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191021235423.32733-1-sean.j.christopherson@intel.com>
 <20191025140927.GC6483@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025140927.GC6483@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 04:09:27PM +0200, Borislav Petkov wrote:
> On Mon, Oct 21, 2019 at 04:54:23PM -0700, Sean Christopherson wrote:
> > --- a/arch/x86/kernel/cpu/Makefile
> > +++ b/arch/x86/kernel/cpu/Makefile
> > @@ -29,6 +29,7 @@ obj-y			+= umwait.o
> >  obj-$(CONFIG_PROC_FS)	+= proc.o
> >  obj-$(CONFIG_X86_FEATURE_NAMES) += capflags.o powerflags.o
> >  
> > +obj-$(CONFIG_X86_FEATURE_CONTROL_MSR) += feature_control.o
> >  ifdef CONFIG_CPU_SUP_INTEL
> >  obj-y			+= intel.o intel_pconfig.o
> >  obj-$(CONFIG_PM)	+= intel_epb.o
> > diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
> > index c0e2407abdd6..d2750f53a0cb 100644
> > --- a/arch/x86/kernel/cpu/cpu.h
> > +++ b/arch/x86/kernel/cpu/cpu.h
> > @@ -62,4 +62,8 @@ unsigned int aperfmperf_get_khz(int cpu);
> >  
> >  extern void x86_spec_ctrl_setup_ap(void);
> >  
> > +#ifdef CONFIG_X86_FEATURE_CONTROL_MSR
> > +void init_feature_control_msr(struct cpuinfo_x86 *c);
> > +#endif
> > +
> >  #endif /* ARCH_X86_CPU_H */
> > diff --git a/arch/x86/kernel/cpu/feature_control.c b/arch/x86/kernel/cpu/feature_control.c
> > new file mode 100644
> > index 000000000000..57b928e64cf5
> > --- /dev/null
> > +++ b/arch/x86/kernel/cpu/feature_control.c
> 
> Why the separate compilation unit and the Kconfig variable? This can
> live in ...cpu/intel.c just fine, right?

Patches 03/14 and 04/14 enable CONFIG_X86_FEATURE_CONTROL_MSR for Centaur
and Zhaoxin CPUs, putting this in intel.c would make those CPUs depend on
CONFIG_CPU_SUP_INTEL.

The common code and Kconfig is used in patch 10/16 to consolidate the VMX
feature flag code that is copy-pasted from Intel -> Centaur/Zhaoxin.

CONFIG_X86_FEATURE_CONTROL_MSR is also used by KVM in patch 16/16 to
gatekeep CONFIG_KVM_INTEL, i.e. VMX support, instead of requiring
CONFIG_CPU_SUP_INTEL.  In other words, allow building KVM for Cenatur or
Zhaoxin without having to build in support for Intel.

> > @@ -0,0 +1,30 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/tboot.h>
> > +
> > +#include <asm/cpufeature.h>
> > +#include <asm/msr-index.h>
> > +#include <asm/processor.h>
> > +
> > +void init_feature_control_msr(struct cpuinfo_x86 *c)
> > +{
> > +	u64 msr;
> > +
> > +	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr))
> > +		return;
> > +
> > +	if (msr & FEATURE_CONTROL_LOCKED)
> > +		return;
> > +
> > +	/*
> > +	 * Ignore whatever value BIOS left in the MSR to avoid enabling random
> > +	 * features or faulting on the WRMSR.
> > +	 */
> > +	msr = FEATURE_CONTROL_LOCKED;
> > +
> > +	if (cpu_has(c, X86_FEATURE_VMX)) {
> > +		msr |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> > +		if (tboot_enabled())
> > +			msr |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
> 
> Any chance you can do s/FEATURE_CONTROL_/FT_CTL_/ or FEAT_CTL or so, to
> those bit defines and maybe the MSR define too? They're a mouthful now.

FEAT_CTL Works for me.  I'd also like to do s/VMXON/VMX to match the SDM.
My vote is to leave the name of the MSR itself as is.

Paolo, any opinion on tweaking the MSR bits/name?

