Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E6D2EC643
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 23:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbhAFWfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 17:35:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:28105 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbhAFWfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 17:35:22 -0500
IronPort-SDR: R4UvppqM/9DX3cP3e4vFHtOt+lA2UAbzzQQqGlSj4oZTfDaBkMSHvBEMT8Mf6XQihX84JsZ2/e
 v3sh6E46CJUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="177445088"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="177445088"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 14:34:41 -0800
IronPort-SDR: JiynHXGwcimhJUO72MqwLBAkY/s447btcuNs5+kOOjDATnuvhGQtGatPKo+Q+QJ4kA6sL/tBai
 jIx2OU8UUXag==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="351025344"
Received: from vastrong-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.243])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 14:34:37 -0800
Date:   Thu, 7 Jan 2021 11:34:35 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <jethro@fortanix.com>, <b.thiel@posteo.de>
Subject: Re: [RFC PATCH 05/23] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-Id: <20210107113435.e5ef60a9c9d84da540682225@intel.com>
In-Reply-To: <8d573e91-55a9-3595-dcbb-499e368a515d@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <2f8a5cb73d9032e5c7ee32f0676e3786ebbc92f3.1609890536.git.kai.huang@intel.com>
        <8d573e91-55a9-3595-dcbb-499e368a515d@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 11:54:52 -0800 Dave Hansen wrote:
> On 1/5/21 5:55 PM, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Allow SGX virtualization on systems without Launch Control support, i.e.
> > allow KVM to expose SGX to guests that support non-LC configurations.
> 
> Context, please.
> 
> The kernel will currently disable all SGX support if the hardware does
> not support launch control.  Make it more permissive to allow SGX
> virtualization on systems without Launch Control support.  This will
> allow KVM to expose SGX to guests that have less-strict requirements on
> the availability of flexible launch control.

OK. I'll add this.

> 
> > Introduce clear_sgx_lc() to clear SGX_LC feature bit only if SGX Launch
> > Control is locked by BIOS when SGX virtualization is enabled, to prevent
> > SGX driver being enabled.
> 
> This is another run-on, and it makes it really hard to figure out what
> it is trying to say.

How about just removing this paragraph? It is a little bit detail anyway. We
can add some comment in the code.

> 
> > Improve error message to distinguish three cases: 1) SGX disabled
> > completely by BIOS; 2) SGX disabled completely due to SGX LC is locked
> > by BIOS, and SGX virtualization is also disabled; 3) Only SGX driver is
> > disabled due to SGX LC is locked by BIOS, but SGX virtualization is
> > enabled.
> 
> Editing for grammar and clarity again...
> 
> Improve error message to distinguish between three cases.  There are two
> cases where SGX support is completely disabled:
> 1) SGX has been disabled completely by the BIOS
> 2) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
>    of LC unavailability.  SGX virtualization is unavailable (because of
>    Kconfig).
> One where it is partially available:
> 3) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
>    of LC unavailability.  SGX virtualization is supported.

OK. Thanks for help here.

> 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/feat_ctl.c | 48 +++++++++++++++++++++++++---------
> >  1 file changed, 36 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> > index 4fcd57fdc682..b07452b68538 100644
> > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > @@ -101,6 +101,11 @@ static void clear_sgx_caps(void)
> >  	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> >  }
> >  
> > +static void clear_sgx_lc(void)
> > +{
> > +	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> > +}
> > +
> >  static int __init nosgx(char *str)
> >  {
> >  	clear_sgx_caps();
> > @@ -113,7 +118,7 @@ early_param("nosgx", nosgx);
> >  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  {
> >  	bool tboot = tboot_enabled();
> > -	bool enable_sgx;
> > +	bool enable_sgx_virt, enable_sgx_driver;
> >  	u64 msr;
> >  
> >  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> > @@ -123,12 +128,19 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	}
> >  
> >  	/*
> > -	 * Enable SGX if and only if the kernel supports SGX and Launch Control
> > -	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
> > +	 * Enable SGX if and only if the kernel supports SGX.  Require Launch
> > +	 * Control support if SGX virtualization is *not* supported, i.e.
> > +	 * disable SGX if the LE hash MSRs can't be written and SGX can't be
> > +	 * exposed to a KVM guest (which might support non-LC configurations).
> >  	 */
> > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > -		     IS_ENABLED(CONFIG_X86_SGX);
> > +	enable_sgx_driver = cpu_has(c, X86_FEATURE_SGX) &&
> > +			    cpu_has(c, X86_FEATURE_SGX1) &&
> > +			    IS_ENABLED(CONFIG_X86_SGX) &&
> > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > +	enable_sgx_virt = cpu_has(c, X86_FEATURE_SGX) &&
> > +			  cpu_has(c, X86_FEATURE_SGX1) &&
> > +			  IS_ENABLED(CONFIG_X86_SGX) &&
> > +			  IS_ENABLED(CONFIG_X86_SGX_VIRTUALIZATION);
> 
> Don't we also need some runtime checks here?  What if we boot on
> hardware that doesn't support KVM?

Yeah I kinda agree here. KVM will be available if X86_FEATURE_VMX is
available. I am OK to add additional check right after 'update_sgx' label:

update_sgx:
	if (!cpu_has(c, X86_FEATURE_VMX))
		enable_sgx_driver = 0;

The rest logic should just work. If necessary, we can also add some message to
say SGX virtualization is disabled due to VMX is not available.

Sean, what is your opinion?

> 
> >  	if (msr & FEAT_CTL_LOCKED)
> >  		goto update_caps;
> > @@ -151,8 +163,11 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
> >  	}
> >  
> > -	if (enable_sgx)
> > -		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
> > +	if (enable_sgx_driver || enable_sgx_virt) {
> > +		msr |= FEAT_CTL_SGX_ENABLED;
> > +		if (enable_sgx_driver)
> > +			msr |= FEAT_CTL_SGX_LC_ENABLED;
> > +	}
> >  
> >  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
> >  
> > @@ -175,10 +190,19 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	}
> >  
> >  update_sgx:
> > -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> > -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> > -		if (enable_sgx)
> > -			pr_err_once("SGX disabled by BIOS\n");
> > +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> > +		if (enable_sgx_driver || enable_sgx_virt)
> > +			pr_err_once("SGX disabled by BIOS.\n");
> >  		clear_sgx_caps();
> >  	}
> > +	if (!(msr & FEAT_CTL_SGX_LC_ENABLED) &&
> > +	    (enable_sgx_driver || enable_sgx_virt)) {
> > +		if (!enable_sgx_virt) {
> > +			pr_err_once("SGX Launch Control is locked. Disable SGX.\n");
> > +			clear_sgx_caps();
> > +		} else if (enable_sgx_driver) {
> > +			pr_err_once("SGX Launch Control is locked. Disable SGX driver.\n");
> 
> Should we have an explicit message for enabling virtualization?  I'm not
> sure how many people will understand that "SGX driver" actually doesn't
> mean /dev/sgx_epc_virt.

OK. I'll add an explicit message for that. Let me see how I can refine this.

Thanks for comments.

> 
> > +			clear_sgx_lc();
> > +		}
> > +	}
> >  }
> > 
> 
