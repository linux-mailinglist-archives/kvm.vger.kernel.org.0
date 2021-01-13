Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DA52F40F5
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 02:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbhAMBFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 20:05:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:36064 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbhAMBFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 20:05:42 -0500
IronPort-SDR: wISDsGJqmWUk5AVS3D2V6+AqID0k5w8t/+/61/CuGJayFYpLhrXfy5ZtCCju1qnLO1IBlj5E+X
 0GgCmh5uOkvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="178223852"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="178223852"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 17:05:26 -0800
IronPort-SDR: zlYFCBooSV5H33Fhkz+INxA6oIgtaTgN5ybMwE2yeOQ5Y/0e6J57yyTBO0r/HnOw5vbamYdn4Y
 pjSHTn3HwpjA==
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="381647053"
Received: from rjchin-mobl.amr.corp.intel.com ([10.251.18.242])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 17:05:23 -0800
Message-ID: <728ebce2384e15e9a376bd9dd08648794e2a0d36.camel@intel.com>
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Wed, 13 Jan 2021 14:05:21 +1300
In-Reply-To: <X/4t+6JcyTGVEG2e@google.com>
References: <20210108071722.GA4042@zn.tnic> <X/jxCOLG+HUO4QlZ@google.com>
         <20210109011939.GL4042@zn.tnic> <X/yQyUx4+veuSO0e@google.com>
         <20210111190901.GG25645@zn.tnic> <X/yk6zcJTLXJwIrJ@google.com>
         <20210112121359.GC13086@zn.tnic> <X/3ZSKDWoPcCsV/w@google.com>
         <20210112175102.GJ13086@zn.tnic>
         <dea875ea60cdef68fa8fe5b8f8cf3e8ed6a5df2e.camel@intel.com>
         <X/4t+6JcyTGVEG2e@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-12 at 15:17 -0800, Sean Christopherson wrote:
> On Wed, Jan 13, 2021, Kai Huang wrote:
> > On Tue, 2021-01-12 at 18:51 +0100, Borislav Petkov wrote:
> > > On Tue, Jan 12, 2021 at 09:15:52AM -0800, Sean Christopherson wrote:
> > > > We want the boot_cpu_data.x86_capability memcpy() so that KVM doesn't advertise
> > > > support for features that are intentionally disabled in the kernel, e.g. via
> > > > kernel params.  Except for a few special cases, e.g. LA57, KVM doesn't enable
> > > > features in the guest if they're disabled in the host, even if the features are
> > > > supported in hardware.
> > > > 
> > > > For some features, e.g. SMEP and SMAP, honoring boot_cpu_data is mostly about
> > > > respecting the kernel's wishes, i.e. barring hardware bugs, enabling such
> > > > features in the guest won't break anything.  But for other features, e.g. XSAVE
> > > > based features, enabling them in the guest without proper support in the host
> > > > will corrupt guest and/or host state.
> > > 
> > > Ah ok, that is an important point.
> > > 
> > > > So it's really the CPUID read that is (mostly) superfluous.
> > > 
> > > Yeah, but that is cheap, as we established.
> > > 
> > > Ok then, I don't see anything that might be a problem and I guess we can
> > > try that handling of scattered bits in kvm and see how far we'll get.
> > 
> > Hi Sean, Boris,
> > 
> > Thanks for all  your feedback.
> > 
> > Sean,
> > 
> > Do you want to send me your patch (so that with your SoB), or do you want me to copy
> > & paste the code you posted in this series, plus Suggested-by you? Or how do you want
> > to proceed?
> > 
> > Also to me it is better to separate X86_FEATURE_SGX1/2 with rest of KVM changes?
> 
> Hmm, I'll split the changes into two proper patches and send them to you off list.

Thanks.

> 
> > And do you think adding a dedicated, i.e. kvm_scattered_cpu_caps[], instead of using
> > existing kvm_cpu_cap[NCAPINTS] would be helpful to solve the problem caused by adding
> > new leaf to x86 core (see my another reply in this thread)?
> 
> Probably not, because then we'd have to add new helpers to deal with the new
> array, or change all the helpers to take the array as a pointer.  Blasting past
> NCAPINTS is a little evil, but it does slot in nicely to the existing code.

Sure. Thanks.


