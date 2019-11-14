Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702E5FCD9A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 19:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKNSck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 13:32:40 -0500
Received: from mga06.intel.com ([134.134.136.31]:51485 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfKNSck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 13:32:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 10:32:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="216836229"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 14 Nov 2019 10:32:39 -0800
Date:   Thu, 14 Nov 2019 10:32:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 06/16] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
Message-ID: <20191114183238.GH24045@linux.intel.com>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000836.1907-1-sean.j.christopherson@intel.com>
 <20191025163858.GF6483@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191025163858.GF6483@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 06:38:58PM +0200, Borislav Petkov wrote:
> On Mon, Oct 21, 2019 at 05:08:36PM -0700, Sean Christopherson wrote:
> > Now that the IA32_FEATURE_CONTROL MSR is guaranteed to be configured and
> > locked, clear the VMX capability flag if the IA32_FEATURE_CONTROL MSR is
> > not supported or if BIOS disabled VMX, i.e. locked IA32_FEATURE_CONTROL
> > and did not set the appropriate VMX enable bit.
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Krčmář <rkrcmar@redhat.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: Wanpeng Li <wanpengli@tencent.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/feature_control.c | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/feature_control.c b/arch/x86/kernel/cpu/feature_control.c
> > index 57b928e64cf5..74c76159a046 100644
> > --- a/arch/x86/kernel/cpu/feature_control.c
> > +++ b/arch/x86/kernel/cpu/feature_control.c
> > @@ -7,13 +7,19 @@
> >  
> >  void init_feature_control_msr(struct cpuinfo_x86 *c)
> >  {
> > +	bool tboot = tboot_enabled();
> >  	u64 msr;
> >  
> > -	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr))
> > +	if (rdmsrl_safe(MSR_IA32_FEATURE_CONTROL, &msr)) {
> > +		if (cpu_has(c, X86_FEATURE_VMX)) {
> > +			pr_err_once("x86/cpu: VMX disabled, IA32_FEATURE_CONTROL MSR unsupported\n");
> 				     ^^^^^^^^
> 
> pr_fmt
> 
> But, before that: do we really wanna know about this or there's nothing
> the user can do? If she can reenable VMX in the BIOS, or otherwise do
> something about it, maybe we should say that above... Otherwise, this
> message is useless.

My thought for having the print was to alert the user that something is
royally borked with their system.  There's nothing the user can do to fix
it per se, but it does indicate that either their hardware or the VMM
hosting their virtual machine is broken.  So maybe be more explicit about
it being a likely hardware/VMM issue?

> > +			clear_cpu_cap(c, X86_FEATURE_VMX);
> > +		}
> >  		return;
> > +	}
> >  
> >  	if (msr & FEATURE_CONTROL_LOCKED)
> > -		return;
> > +		goto update_caps;
> >  
> >  	/*
> >  	 * Ignore whatever value BIOS left in the MSR to avoid enabling random
> > @@ -23,8 +29,19 @@ void init_feature_control_msr(struct cpuinfo_x86 *c)
> >  
> >  	if (cpu_has(c, X86_FEATURE_VMX)) {
> >  		msr |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> > -		if (tboot_enabled())
> > +		if (tboot)
> >  			msr |= FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX;
> >  	}
> >  	wrmsrl(MSR_IA32_FEATURE_CONTROL, msr);
> > +
> > +update_caps:
> > +	if (!cpu_has(c, X86_FEATURE_VMX))
> > +		return;
> 
> If this test is just so we can save us the below code, I'd say remove it
> for the sake of having less code in that function. The test is cheap and
> not on a fast path so who cares if we clear an alrady cleared bit. But
> maybe this evolves in the later patches...

I didn't want to print the "VMX disabled by BIOS..." message if VMX isn't
supported in the first place.  Later patches also add more code in this
flow, but avoiding the print message is the main motiviation.
 
> > +
> > +	if ((tboot && !(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX)) ||
> > +	    (!tboot && !(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX))) {
> > +		pr_err_once("x86/cpu: VMX disabled by BIOS (TXT %s)\n",
> > +			    tboot ? "enabled" : "disabled");
> > +		clear_cpu_cap(c, X86_FEATURE_VMX);
> > +	}
> >  }
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
