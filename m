Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753DC3054C2
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 08:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhA0Hfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 02:35:50 -0500
Received: from mga04.intel.com ([192.55.52.120]:64820 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317066AbhA0AAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:00:37 -0500
IronPort-SDR: WbW/+aNjHGPL4L2kUbP4dIiuzqqFVllSaT8Z9ebB9YZbm+Zkaqo00laFAjg5yOLyAGPq+8ELwP
 138fJlHmY5Pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="177421237"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="177421237"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 15:56:14 -0800
IronPort-SDR: NUlTIy/0++tX6J+DIDLGK6/Xfuh7JLf1CD+ewnoR4UvnSGHm4FNWo9AQ2fzAEjfs21uHrU0G1V
 gC//VGhPGB/A==
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="472932673"
Received: from rsperry-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.187])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 15:56:10 -0800
Date:   Wed, 27 Jan 2021 12:56:07 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <jethro@fortanix.com>, <b.thiel@posteo.de>
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-Id: <20210127125607.52795a882ace894b19f41d68@intel.com>
In-Reply-To: <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
        <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jan 2021 08:26:21 -0800 Dave Hansen wrote:
> On 1/26/21 1:30 AM, Kai Huang wrote:
> > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
> >  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  {
> >  	bool tboot = tboot_enabled();
> > -	bool enable_sgx;
> > +	bool enable_vmx;
> > +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
> >  	u64 msr;
> >  
> >  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> > @@ -114,13 +115,22 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  		return;
> >  	}
> >  
> > +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> > +		     IS_ENABLED(CONFIG_KVM_INTEL);
> 
> The reason it's called 'enable_sgx' below is because this code is
> actually going to "enable sgx".  This code does not "enable vmx".  That
> makes this a badly-named variable.  "vmx_enabled" or "vmx_available"
> would be better.

It will also try to enable VMX if feature control MSR is not locked by BIOS.
Please see below code:

"
> > -	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL)) {
> > +	if (enable_vmx) {
> >  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> >  
> >  		if (tboot)
> >  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
> >  	}
"

And if feature control MSR is locked, kernel cannot truly enable anything, but
can only print out msg in case BIOS disabled either VMX, or SGX, or SGX_LC, and
kernel wants to support that.

Does this make sense to you?

> 
> >  	/*
> > -	 * Enable SGX if and only if the kernel supports SGX and Launch Control
> > -	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
> > +	 * Enable SGX if and only if the kernel supports SGX.  Require Launch
> > +	 * Control support if SGX virtualization is *not* supported, i.e.
> > +	 * disable SGX if the LE hash MSRs can't be written and SGX can't be
> > +	 * exposed to a KVM guest (which might support non-LC configurations).
> >  	 */
> 
> I hate this comment.
> 
> 	/*
> 	 * Separate out bare-metal SGX enabling from KVM.  This allows
> 	 * KVM guests to use SGX even if the kernel refuses to use it on
> 	 * bare-metal.  This happens if flexible Faunch Control is not
> 	 * available.
> 	 *

Thanks.

> 
> > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > -		     IS_ENABLED(CONFIG_X86_SGX);
> > +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> > +			 cpu_has(c, X86_FEATURE_SGX1) &&
> > +			 IS_ENABLED(CONFIG_X86_SGX);
> 
> The X86_FEATURE_SGX1 check seems to have snuck in here.  Why?

Please see my reply to Sean's reply.

> 
> > +	enable_sgx_driver = enable_sgx_any &&
> > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > +	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
> > +			  IS_ENABLED(CONFIG_X86_SGX_KVM);
> >  
> >  	if (msr & FEAT_CTL_LOCKED)
> >  		goto update_caps;
> > @@ -136,15 +146,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	 * i.e. KVM is enabled, to avoid unnecessarily adding an attack vector
> >  	 * for the kernel, e.g. using VMX to hide malicious code.
> >  	 */
> > -	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL)) {
> > +	if (enable_vmx) {
> >  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> >  
> >  		if (tboot)
> >  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
> >  	}
> >  
> > -	if (enable_sgx)
> > -		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
> > +	if (enable_sgx_kvm || enable_sgx_driver) {
> > +		msr |= FEAT_CTL_SGX_ENABLED;
> > +		if (enable_sgx_driver)
> > +			msr |= FEAT_CTL_SGX_LC_ENABLED;
> > +	}
> >  
> >  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
> >  
> > @@ -167,10 +180,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	}
> >  
> >  update_sgx:
> > -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> > -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> > -		if (enable_sgx)
> > -			pr_err_once("SGX disabled by BIOS\n");
> > +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> > +		if (enable_sgx_kvm || enable_sgx_driver)
> > +			pr_err_once("SGX disabled by BIOS.\n");
> >  		clear_cpu_cap(c, X86_FEATURE_SGX);
> > +		return;
> > +	}
> 
> 
> Isn't there a pr_fmt here already?  Won't these just look like:
> 
> 	sgx: SGX disabled by BIOS.
> 
> That seems a bit silly.

Please see my reply to Sean's reply.
