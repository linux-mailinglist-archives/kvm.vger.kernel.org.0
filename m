Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0B8330548
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 01:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhCHATt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Mar 2021 19:19:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:24347 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233140AbhCHATs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Mar 2021 19:19:48 -0500
IronPort-SDR: a/M46oz+X+wyWfD+ZWC7Bup7D8ye69tnBy3yJyUd6zT4m972BCH+qxufcDmbq58HhvwZLvZ0Ni
 4LXiJE6fVN6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="188050462"
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="188050462"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 16:19:47 -0800
IronPort-SDR: UtVXiISl8EFaf9+qhQXIn/32pNp9zHSWSlUG76nsU+B2jJrKNXBfUs5ddH62ZfxOMcKsedkr16
 kim8wm8e3Yew==
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="402615283"
Received: from ggkanher-mobl4.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.177])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 16:19:43 -0800
Date:   Mon, 8 Mar 2021 13:19:41 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <linux-sgx@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <seanjc@google.com>,
        <jarkko@kernel.org>, <luto@kernel.org>, <dave.hansen@intel.com>,
        <rick.p.edgecombe@intel.com>, <haitao.huang@intel.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <jethro@fortanix.com>, <b.thiel@posteo.de>
Subject: Re: [PATCH 06/25] x86/cpu/intel: Allow SGX virtualization without
 Launch Control support
Message-Id: <20210308131941.56eacf7b318c7e1ae96f295a@intel.com>
In-Reply-To: <20210308125026.08ece7c1f99406a14812715e@intel.com>
References: <cover.1614590788.git.kai.huang@intel.com>
        <12541888ae9ac7f517582aa64d9153feede7aed4.1614590788.git.kai.huang@intel.com>
        <20210305172957.GE2685@zn.tnic>
        <20210308125026.08ece7c1f99406a14812715e@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 Mar 2021 12:50:26 +1300 Kai Huang wrote:
> On Fri, 5 Mar 2021 18:29:57 +0100 Borislav Petkov wrote:
> > On Mon, Mar 01, 2021 at 10:45:02PM +1300, Kai Huang wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > The kernel will currently disable all SGX support if the hardware does
> > > not support launch control.  Make it more permissive to allow SGX
> > > virtualization on systems without Launch Control support.  This will
> > > allow KVM to expose SGX to guests that have less-strict requirements on
> > > the availability of flexible launch control.
> > > 
> > > Improve error message to distinguish between three cases.  There are two
> > > cases where SGX support is completely disabled:
> > > 1) SGX has been disabled completely by the BIOS
> > > 2) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
> > >    of LC unavailability.  SGX virtualization is unavailable (because of
> > >    Kconfig).
> > > One where it is partially available:
> > > 3) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
> > >    of LC unavailability.  SGX virtualization is supported.
> > > 
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/feat_ctl.c | 57 ++++++++++++++++++++++++++--------
> > >  1 file changed, 44 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> > > index 27533a6e04fa..96c370284913 100644
> > > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > > @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
> > >  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> > >  {
> > >  	bool tboot = tboot_enabled();
> > > -	bool enable_sgx;
> > > +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
> > > +	bool enable_vmx;
> > >  	u64 msr;
> > 
> > The preferred ordering of variable declarations at the beginning of a
> > function is reverse fir tree order::
> > 
> > 	struct long_struct_name *descriptive_name;
> > 	unsigned long foo, bar;
> > 	unsigned int tmp;
> > 	int ret;
> > 
> 
> Will do.
> 
> Since as you suggested, enable_sgx_any will be removed, and initializing
> enable_sgx_driver/kvm will be moved into the if () statement, I think we should
> explicitly initialize them here. How about below?
> 
> 	bool enable_sgx_kvm = enable_sgx_driver = false;

Sorry my bad, should be:

	bool enable_sgx_kvm = false, enable_sgx_driver = false;

> 	bool tboot = tboot_enabled();
> 	bool enable_vmx;
> 	...
> 
> > 
> > >  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> > > @@ -114,13 +115,21 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> > >  		return;
> > >  	}
> > >  
> > > +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> > > +		     IS_ENABLED(CONFIG_KVM_INTEL);
> > > +
> > >  	/*
> > > -	 * Enable SGX if and only if the kernel supports SGX and Launch Control
> > > -	 * is supported, i.e. disable SGX if the LE hash MSRs can't be written.
> > > +	 * Separate out SGX driver enabling from KVM.  This allows KVM
> > > +	 * guests to use SGX even if the kernel SGX driver refuses to
> > > +	 * use it.  This happens if flexible Faunch Control is not
> > > +	 * available.
> > >  	 */
> > > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > > -		     IS_ENABLED(CONFIG_X86_SGX);
> > > +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> > > +			 IS_ENABLED(CONFIG_X86_SGX);
> > > +	enable_sgx_driver = enable_sgx_any &&
> > > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > > +	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
> > > +			  IS_ENABLED(CONFIG_X86_SGX_KVM);
> > 
> > That enable_sgx_any use looks weird. You can get rid of it:
> > 
> > 	if (cpu_has(c, X86_FEATURE_SGX) && IS_ENABLED(CONFIG_X86_SGX)) {
> > 		enable_sgx_driver = cpu_has(c, X86_FEATURE_SGX_LC);
> > 		enable_sgx_kvm    = enable_vmx && IS_ENABLED(CONFIG_X86_SGX_KVM);
> > 	}
> > 
> > and yap, let longer lines stick out.
> 
> Thanks. Will do.
> 
> > 
> > Thx.
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > https://people.kernel.org/tglx/notes-about-netiquette
