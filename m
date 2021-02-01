Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FC130A185
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhBAFlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:41:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:49638 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhBAFjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:39:11 -0500
IronPort-SDR: rlRxVM9ViubdJ737z12W5DPK7fDfKHkoQrfw0FI7nCehlIrC88TjGruIDhqZAggoegfFiwJPZC
 1gYilH1GZYgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="167740574"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="167740574"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:38:29 -0800
IronPort-SDR: GZ3ZRxcb6RaN0Yhe+da82mltfqCEwGthb9d8uryyzSUYmhi6PchBKQJ4UWSePK2SjBQgUuf+t1
 1lGdnYzZOPig==
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="412141280"
Received: from jaramosm-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.53])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:38:24 -0800
Date:   Mon, 1 Feb 2021 18:38:22 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-Id: <20210201183822.d30fe56535de72087584c116@intel.com>
In-Reply-To: <YBVwcJ0KrWmXkcjL@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
        <YBVwcJ0KrWmXkcjL@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 16:42:56 +0200 Jarkko Sakkinen wrote:
> On Tue, Jan 26, 2021 at 10:30:54PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > The kernel will currently disable all SGX support if the hardware does
> > not support launch control.  Make it more permissive to allow SGX
> > virtualization on systems without Launch Control support.  This will
> > allow KVM to expose SGX to guests that have less-strict requirements on
> > the availability of flexible launch control.
> > 
> > Improve error message to distinguish between three cases.  There are two
> > cases where SGX support is completely disabled:
> > 1) SGX has been disabled completely by the BIOS
> > 2) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
> >    of LC unavailability.  SGX virtualization is unavailable (because of
> >    Kconfig).
> > One where it is partially available:
> > 3) SGX LC is locked by the BIOS.  Bare-metal support is disabled because
> >    of LC unavailability.  SGX virtualization is supported.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> > v2->v3:
> > 
> >  - Added to use 'enable_sgx_any', per Dave.
> >  - Changed to call clear_cpu_cap() directly, rather than using clear_sgx_caps()
> >    and clear_sgx_lc().
> >  - Changed to use CONFIG_X86_SGX_KVM, instead of CONFIG_X86_SGX_VIRTUALIZATION.
> > 
> > v1->v2:
> > 
> >  - Refined commit message per Dave's comments.
> >  - Added check to only enable SGX virtualization when VMX is supported, per
> >    Dave's comment.
> >  - Refined error msg print to explicitly call out SGX virtualization will be
> >    supported when LC is locked by BIOS, per Dave's comment.
> > 
> > ---
> >  arch/x86/kernel/cpu/feat_ctl.c | 58 ++++++++++++++++++++++++++--------
> >  1 file changed, 45 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> > index 27533a6e04fa..0fc202550fcc 100644
> > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
> >  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  {
> >  	bool tboot = tboot_enabled();
> > -	bool enable_sgx;
> > +	bool enable_vmx;
> > +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
> 
> Move the declaration first (reverse christmas tree).

Will do. Thanks.

> 
> >  	u64 msr;
> >  
> >  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> > @@ -114,13 +115,22 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  		return;
> >  	}
> >  
> > +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> > +		     IS_ENABLED(CONFIG_KVM_INTEL);
> > +
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
> > +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> > +			 cpu_has(c, X86_FEATURE_SGX1) &&
> > +			 IS_ENABLED(CONFIG_X86_SGX);
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
> > +
> > +	/*
> > +	 * VMX feature bit may be cleared due to being disabled in BIOS,
> > +	 * in which case SGX virtualization cannot be supported either.
> > +	 */
> > +	if (!cpu_has(c, X86_FEATURE_VMX) && enable_sgx_kvm) {
> > +		pr_err_once("SGX virtualization disabled due to lack of VMX.\n");
> > +		enable_sgx_kvm = 0;
> > +	}
> > +
> > +	if (!(msr & FEAT_CTL_SGX_LC_ENABLED) && enable_sgx_driver) {
> > +		if (!enable_sgx_kvm) {
> > +			pr_err_once("SGX Launch Control is locked. Disable SGX.\n");
> > +			clear_cpu_cap(c, X86_FEATURE_SGX);
> > +		} else {
> > +			pr_err_once("SGX Launch Control is locked. Support SGX virtualization only.\n");
> > +			clear_cpu_cap(c, X86_FEATURE_SGX_LC);
> > +		}
> >  	}
> >  }
> > -- 
> > 2.29.2
> > 
> > 
> 
> /Jarkko
