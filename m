Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC71C305348
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 07:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhA0Gd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 01:33:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:6957 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233614AbhA0DK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 22:10:27 -0500
IronPort-SDR: fPYk/Ct1umolsjf4vtl+mUsKFaC+ogN4DRlyeDSqiVXkwwXhpUFoO3fZANhtD1lWnkFYWF4x9i
 2X30R+qNDoPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="180083803"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="180083803"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 18:02:30 -0800
IronPort-SDR: Aoqab5o+VkATEpVElHDNTHuaTXAYLVzqX3jZTio3EYD6Oml4gTT8AhISN4lrEid5q/A/wmFi/e
 nu7XNwH6QvdQ==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388100988"
Received: from rsperry-desk.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.187])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 18:02:27 -0800
Date:   Wed, 27 Jan 2021 15:02:24 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <jethro@fortanix.com>, <b.thiel@posteo.de>
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-Id: <20210127150224.5d7de004fb6b3fb72a969f07@intel.com>
In-Reply-To: <ecb0595b-76e9-9298-438d-80de28156371@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
        <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
        <20210127125607.52795a882ace894b19f41d68@intel.com>
        <ecb0595b-76e9-9298-438d-80de28156371@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Jan 2021 16:18:31 -0800 Dave Hansen wrote:
> On 1/26/21 3:56 PM, Kai Huang wrote:
> > On Tue, 26 Jan 2021 08:26:21 -0800 Dave Hansen wrote:
> >> On 1/26/21 1:30 AM, Kai Huang wrote:
> >>> --- a/arch/x86/kernel/cpu/feat_ctl.c
> >>> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> >>> @@ -105,7 +105,8 @@ early_param("nosgx", nosgx);
> >>>  void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >>>  {
> >>>  	bool tboot = tboot_enabled();
> >>> -	bool enable_sgx;
> >>> +	bool enable_vmx;
> >>> +	bool enable_sgx_any, enable_sgx_kvm, enable_sgx_driver;
> >>>  	u64 msr;
> >>>  
> >>>  	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
> >>> @@ -114,13 +115,22 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >>>  		return;
> >>>  	}
> >>>  
> >>> +	enable_vmx = cpu_has(c, X86_FEATURE_VMX) &&
> >>> +		     IS_ENABLED(CONFIG_KVM_INTEL);
> >>
> >> The reason it's called 'enable_sgx' below is because this code is
> >> actually going to "enable sgx".  This code does not "enable vmx".  That
> >> makes this a badly-named variable.  "vmx_enabled" or "vmx_available"
> >> would be better.
> > 
> > It will also try to enable VMX if feature control MSR is not locked by BIOS.
> > Please see below code:
> 
> Ahh, I forgot this is non-SGX code.  It's mucking with all kinds of
> other stuff in the same MSR.  Oh, well, I guess that's what you get for
> dumping a bunch of refactoring in the same patch as the new code.
> 
> 
> >>> -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> >>> -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> >>> -		     IS_ENABLED(CONFIG_X86_SGX);
> >>> +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> >>> +			 cpu_has(c, X86_FEATURE_SGX1) &&
> >>> +			 IS_ENABLED(CONFIG_X86_SGX);
> >>
> >> The X86_FEATURE_SGX1 check seems to have snuck in here.  Why?
> > 
> > Please see my reply to Sean's reply.
> 
> ... yes, so you're breaking out the fix into a separate patch,.

For the separate patch to fix SGX1 check, if I understand correctly, SGX driver
should be changed too. I feel I am not the best person to do it. Jarkko or Sean
is. 

So I'll remove SGX1 here in the next version, but I won't include another
patch to fix the SGX1 logic. If Jarkko or Sean sent out that patch, and it is
merged quickly, I can rebase on top of that.

Does this make sense?
