Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DF92EC66D
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 23:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbhAFW5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 17:57:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:27781 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbhAFW5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 17:57:23 -0500
IronPort-SDR: q8It7YVX0totSyyB1J/PoatfPOMeVilX9rGvhpY3koPOhKPGZrCZ2hI4xCLFEJQ/K6HM8TsPiH
 p1OO+QMARsSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="156534795"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="156534795"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 14:56:42 -0800
IronPort-SDR: GUO7qR4BmgRFYvQ9i8+yVbkFV3Uim74fHpQ6zaJB/OFTbThvtCBlfg0fDZweg3PGPOOucmC1li
 v/xpPuRqFMUw==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="361748184"
Received: from vastrong-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.243])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 14:56:39 -0800
Date:   Thu, 7 Jan 2021 11:56:37 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210107115637.c1e0bf2c823f933943ee813b@intel.com>
In-Reply-To: <b3e11134-cd8e-2b51-1363-58898832ba38@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
        <6d28e858-a5c0-6ce8-8c0d-2fdfbea3734b@intel.com>
        <20210107111206.c8207e64540a8361c04259b7@intel.com>
        <b3e11134-cd8e-2b51-1363-58898832ba38@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 14:21:39 -0800 Dave Hansen wrote:
> On 1/6/21 2:12 PM, Kai Huang wrote:
> > On Wed, 6 Jan 2021 11:39:46 -0800 Dave Hansen wrote:
> >> On 1/5/21 5:55 PM, Kai Huang wrote:
> >>> --- a/arch/x86/kernel/cpu/feat_ctl.c
> >>> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> >>> @@ -97,6 +97,8 @@ static void clear_sgx_caps(void)
> >>>  {
> >>>  	setup_clear_cpu_cap(X86_FEATURE_SGX);
> >>>  	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> >>> +	setup_clear_cpu_cap(X86_FEATURE_SGX1);
> >>> +	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> >>>  }
> >> Logically, I think you want this *after* the "Allow SGX virtualization
> >> without Launch Control support" patch.  As it stands, this will totally
> >> disable SGX (including virtualization) if launch control is unavailable.
> > To me it is better to be here, since clear_sgx_caps(), which disables SGX
> > totally, should logically clear all SGX feature bits, no matter later patch's
> > behavior. So when new SGX bits are introduced, clear_sgx_caps() should clear
> > them too. Otherwise the logic of this patch (adding new SGX feature bits) is
> > not complete IMHO.
> > 
> > And actually in later patch "Allow SGX virtualization without Launch Control
> > support", a new clear_sgx_lc() is added, and is called when LC is not
> > available but SGX virtualization is enabled, to make sure only SGX_LC bit is
> > cleared in this case. I don't quite understand why we need to clear SGX1 and
> > SGX2 in clear_sgx_caps() after the later patch.
> 
> I was talking about patch ordering.  It could be argued that this goes
> after the content of patch 05/23.  Please _consider_ changing the ordering.
> 
> If that doesn't work for some reason, please at least call out in the
> changelog that it leaves a temporarily funky situation.
> 

The later patch currently uses SGX1 bit, which is the reason that this patch
needs be before later patch.

Sean,

I think it is OK to remove SGX1 bit check in later patch, since I have
never seen a machine with SGX bit in CPUID, but w/o SGX1. If we remove SGX1 bit
check in later, we can put this patch after the later patch.

Do you have comment here? If you are OK, I'll remove SGX1 bit check in later
patch and reorder the patch.







