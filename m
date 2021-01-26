Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F25A3054D2
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 08:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhA0HjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 02:39:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:37893 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317384AbhAZX76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 18:59:58 -0500
IronPort-SDR: mQvcZ4r29FeaOj7aToW8MoO2A/nlK0XvicuIgtkVWLC3B9ulDEcuj72S5D1/f0xAd2fSXIfXfw
 vZRtsPvfclOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="180071064"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="180071064"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 15:55:03 -0800
IronPort-SDR: OGQ3px4z+Lp+l2VONCJKkEt4rXbcHI+0pFyFLseqK8WEKnS4RBQBUELGlFAMmWAQ/f0aiOIUjt
 Z6Iagu/Zh/RA==
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="369281410"
Received: from rsperry-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.187])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 15:54:59 -0800
Date:   Wed, 27 Jan 2021 12:54:55 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-Id: <20210127125455.799277017f90fd0f7de3f04f@intel.com>
In-Reply-To: <YBBKvecRXYclMnpH@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
        <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
        <YBBKvecRXYclMnpH@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jan 2021 09:00:45 -0800 Sean Christopherson wrote:
> On Tue, Jan 26, 2021, Dave Hansen wrote:
> > > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > > -		     IS_ENABLED(CONFIG_X86_SGX);
> > > +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> > > +			 cpu_has(c, X86_FEATURE_SGX1) &&
> > > +			 IS_ENABLED(CONFIG_X86_SGX);
> > 
> > The X86_FEATURE_SGX1 check seems to have snuck in here.  Why?
> 
> It's a best effort check to handle the scenario where SGX is enabled by BIOS,
> but was disabled by hardware in response to a machine check bank being disabled.
> Adding a check on SGX1 should be in a different patch.  I thought we had a
> dicscussion about why the check was omitted in the merge of bare metal support,
> but I can't find any such thread.

Hi Dave,

This is the link we discussed when in RFC v1. This should provide some info of
why using SGX1 here. 

https://www.spinics.net/lists/linux-sgx/msg03990.html

And Dave, Sean,

If we want another separate patch for fixing SGX1 bit here, I'd like to let
Sean or Jarkko to do that, since it is not quite related to KVM SGX
virtualization here. I can remove SGX1  check here if you all agree.

Comment? 

> 
> > > +	enable_sgx_driver = enable_sgx_any &&
> > > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > > +	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
> > > +			  IS_ENABLED(CONFIG_X86_SGX_KVM);
> > >  
> > >  	if (msr & FEAT_CTL_LOCKED)
> > >  		goto update_caps;
> > > @@ -136,15 +146,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> > >  	 * i.e. KVM is enabled, to avoid unnecessarily adding an attack vector
> > >  	 * for the kernel, e.g. using VMX to hide malicious code.
> > >  	 */
> > > -	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL)) {
> > > +	if (enable_vmx) {
> > >  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> > >  
> > >  		if (tboot)
> > >  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
> > >  	}
> > >  
> > > -	if (enable_sgx)
> > > -		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
> > > +	if (enable_sgx_kvm || enable_sgx_driver) {
> > > +		msr |= FEAT_CTL_SGX_ENABLED;
> > > +		if (enable_sgx_driver)
> > > +			msr |= FEAT_CTL_SGX_LC_ENABLED;
> > > +	}
> > >  
> > >  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
> > >  
> > > @@ -167,10 +180,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> > >  	}
> > >  
> > >  update_sgx:
> > > -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> > > -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> > > -		if (enable_sgx)
> > > -			pr_err_once("SGX disabled by BIOS\n");
> > > +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> > > +		if (enable_sgx_kvm || enable_sgx_driver)
> > > +			pr_err_once("SGX disabled by BIOS.\n");
> > >  		clear_cpu_cap(c, X86_FEATURE_SGX);
> > > +		return;
> > > +	}
> > 
> > 
> > Isn't there a pr_fmt here already?  Won't these just look like:
> > 
> > 	sgx: SGX disabled by BIOS.
> > 
> > That seems a bit silly.
> 
> Eh, I like the explicit "SGX" to clarify that the hardware feature was disabled.

Hi Dave,

The pr_fmt is:

#undef pr_fmt
#define pr_fmt(fmt)     "x86/cpu: " fmt

So, it will have x86/cpu: SGX disabled by BIOS.
