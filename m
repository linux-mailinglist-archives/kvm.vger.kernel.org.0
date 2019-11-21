Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A57105B96
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 22:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKUVHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 16:07:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:28328 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUVHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 16:07:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 13:07:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,227,1571727600"; 
   d="scan'208";a="238343412"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2019 13:07:14 -0800
Date:   Thu, 21 Nov 2019 13:07:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-edac@vger.kernel.org,
        "linux-kselftest@vger.kernel.org, Jarkko Sakkinen" 
        <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 09/19] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
Message-ID: <20191121210714.GB16617@linux.intel.com>
References: <20191119031240.7779-1-sean.j.christopherson@intel.com>
 <20191119031240.7779-10-sean.j.christopherson@intel.com>
 <20191121162452.GJ6540@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121162452.GJ6540@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 05:24:52PM +0100, Borislav Petkov wrote:
> On Mon, Nov 18, 2019 at 07:12:30PM -0800, Sean Christopherson wrote:
> > Now that the IA32_FEATURE_CONTROL MSR is guaranteed to be configured and
> > locked, clear the VMX capability flag if the IA32_FEATURE_CONTROL MSR is
> > not supported or if BIOS disabled VMX, i.e. locked IA32_FEATURE_CONTROL
> > and did not set the appropriate VMX enable bit.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/feature_control.c | 28 ++++++++++++++++++++++++---
> >  1 file changed, 25 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/feature_control.c b/arch/x86/kernel/cpu/feature_control.c
> > index 33c9444dda52..2bd1a9e6021a 100644
> > --- a/arch/x86/kernel/cpu/feature_control.c
> > +++ b/arch/x86/kernel/cpu/feature_control.c
> > @@ -5,15 +5,26 @@
> >  #include <asm/msr-index.h>
> >  #include <asm/processor.h>
> >  
> > +#undef pr_fmt
> > +#define pr_fmt(fmt)	"x86/cpu: " fmt
> > +
> > +#define FEAT_CTL_UNSUPPORTED_MSG "IA32_FEATURE_CONTROL MSR unsupported on VMX capable CPU, suspected hardware or hypervisor issue.\n"
> > +
> >  void init_feature_control_msr(struct cpuinfo_x86 *c)
> >  {
> > +	bool tboot = tboot_enabled();
> >  	u64 msr;
> >  
> > -	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr))
> > +	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr)) {
> > +		if (cpu_has(c, X86_FEATURE_VMX)) {
> > +			pr_err_once(FEAT_CTL_UNSUPPORTED_MSG);
> > +			clear_cpu_cap(c, X86_FEATURE_VMX);
> > +		}
> >  		return;
> > +	}
> 
> Right, so this test: is this something that could happen on some
> configurations - i.e., the MSR is not there but VMX bit is set - or are
> you being too cautious here?

Probably being overly cautious.

> IOW, do you have any concrete use cases in mind (cloud provider can f*ck
> it up this way) or?

Yes, VMM somehow managing to break things.  Admittedly extremely unlikely
given how long IA32_FEATURE_CONTROL has been around.

> My angle is that if this is never going to happen, why even bother to
> print anything...

My thought was to add an equivalent of the WARN that fires when an MSR
access unexpectedly faults.  That's effectively what'd be happening, except
I used the safe variant to reduce the maintenance cost, e.g. so that the
RDMSR doesn't have to be conditioned on every possible feature.

What about a WARN_ON cpu_has?  That'd be more aligned with the unexpected
#GP on RDMSR behavior.

	if (rdmsrl_safe(...)) {
		if (WARN_ON_ONCE(cpu_has(c, X86_FEATURE_VMX)))
			clear_cpu_cap(c, X86_FEATURE_VMX);
		return;
	}

I'm also ok dropping it altogether, though from a KVM developer
perspective I wouldn't mind the extra sanity check :-)
