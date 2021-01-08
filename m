Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABD12EEDAD
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 08:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbhAHHEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 02:04:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:50391 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726241AbhAHHEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 02:04:38 -0500
IronPort-SDR: GP8BGT3NOjHRRrqSJouORacMpitCgVZ+jBf4hpkNSN0z37NLXbXW7H0bIom/gveiryBmSJx+Ed
 15I/mj7TYKNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="262324582"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="262324582"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 23:03:57 -0800
IronPort-SDR: OtVZ5Bz5Tu7K22QbxPJWPnMmXAYnkvMiiksCBtqe5SoFfNODGBzUyo0M6nFecpjtvMndwULxIq
 tSdUEfBh87bg==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="422859610"
Received: from sspraker-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.3.60])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 23:03:53 -0800
Date:   Fri, 8 Jan 2021 20:03:50 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, <linux-sgx@vger.kernel.org>,
        <kvm@vger.kernel.org>, <x86@kernel.org>, <seanjc@google.com>,
        <jarkko@kernel.org>, <luto@kernel.org>, <haitao.huang@intel.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
In-Reply-To: <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
        <20210106221527.GB24607@zn.tnic>
        <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
        <20210107064125.GB14697@zn.tnic>
        <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
        <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 21:10:29 -0800 Dave Hansen wrote:
> On 1/7/21 6:00 PM, Kai Huang wrote:
> > On Thu, 7 Jan 2021 07:41:25 +0100 Borislav Petkov wrote:
> >> On Thu, Jan 07, 2021 at 12:09:46PM +1300, Kai Huang wrote:
> >>> There's no urgent request to support them for now (and given basic SGX
> >>> virtualization is not in upstream), but I don't know whether they need to be
> >>> supported in the future.
> >>
> >> If that is the case, then wasting a whole leaf for two bits doesn't make
> >> too much sense. And it looks like the kvm reverse lookup can be taught
> >> to deal with composing that leaf dynamically when needed instead.
> > 
> > I am not sure changing reverse lookup to handle dynamic would be acceptable. To
> > me it is ugly, and I don't have a first glance on how to do it. KVM can query
> > host CPUID when dealing with SGX w/o X86_FEATURE_SGX1/2, but it is not as
> > straightforward as having X86_FEATURE_SGX1/2.
> 
> So, Boris was pretty direct here.  Could you please go spend a bit of
> time to see what it would take to make these dynamic?  You can check
> what our (Intel) plans are for this leaf, but if it's going to remain
> sparsely-used, we need to look into making the leaves a bit more dynamic.

I don't think reverse lookup can be made dyanmic, but like I said if we don't
have X86_FEATURE_SGX1/2, KVM needs to query raw CPUID when dealing with SGX.

The purpose of reverse lookup is to simplify KVM to have one common helper to
check whether guest's CPUID has particular hardware feature bit or not. For
instance, it changes guest_cpuid_has_xxx(cpuid) to guest_cpuid_has(cpuid,
X86_FEATURE_xxx), so KVM can get rid of bunch of dedicated
guest_cpuid_has_xxx() for each feature, but just use X86_FEATURE_xxx with one
function. W/o X86_FEATURE_SGX1/2, when dealing with them, KVM needs to have
dedicated functions but cannot use common one. That is a drawback for KVM.

Btw, one thing I forgot to say is with X86_FEATURE_SGX1/2, "sgx1" and "sgx2"
will be in /proc/cpuinfo auatomatically. I think showing "sgx2" (and other
future SGX features) in /proc/cpuinfo is helpful. W/o X86_FEATURE_SGX1/2, we
need specific handling, if we want to show them in /proc/cpuinfo.

That being said, if all those doesn't convince Boris and you guys, and Sean has
no say here, I'll remove X86_FEATURE_SGX1/2 in next version.

	
> 
> > And regarding to other bits of this leaf, to me: 1) we cannot rule out
> > possibility that bit 5 and bit 6 will be supported in the future; 2) I cannot
> > talk more but we cannot rule out the possibility that there will be other bits
> > introduced in the future.
> 
> From the Intel side, let's go look at the features that are coming.  We
> have a list of CPUID bits that have been dedicated to future CPU
> features.  Let's look if 1 of these bits or 30 is coming.  I don't think
> it's exactly a state secret approximately how many CPUID bits we *think*
> will get used in this leaf.
> 
> We can't exactly put together a roadmap of bits, microarchitectures and
> chip release dates.  But, we can at least say, "we have immediate plans
> for most of the leaf" or "we don't plan to fill up the leaf any time soon."
