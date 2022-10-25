Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8988160D18C
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 18:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiJYQWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 12:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbiJYQWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 12:22:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C91A193751;
        Tue, 25 Oct 2022 09:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666714929; x=1698250929;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Dbm8TH1f5AC5jnqntf0hv4IibtNi4xyHulj2ALOzwog=;
  b=HAqLp5BjrbbFvjvq9RIDX58J1L63/06szdvqb/5Gv2/pmYnyoIfYRJof
   jD695C49vfxJCMK7efGOzR3Kc1dlux5mq9/BLeq3TilQcbO8yNVjx7/F2
   YPh8Q6wE+F4YmpDG5v2+JMRHOanQD6V8wQCIbLkq+KHwYmIcQy97Mq7Ev
   ETSOokPPus2TExAhBCzeP0bbhxZwbdk9Cl0nhYb4cBeaR3weGV0+SduDh
   oeNFeptl6HwwSgBSCj6AyLtWnvsEQq10tsKKdPGP4CvDmK+5A+9+wvh3A
   2VxVNFGTGiI50rFTlimXtBPRNcKmBA6e7UQGEY4ECTzcSY+qSa1I85CCR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="291026577"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="291026577"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 09:22:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="806723583"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="806723583"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 09:22:08 -0700
Date:   Tue, 25 Oct 2022 09:22:07 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix the initial value of mcg_cap
Message-ID: <Y1gNL+vowev2zEG6@agluck-desk3.sc.intel.com>
References: <20221020031615.890400-1-xiaoyao.li@intel.com>
 <Y1FatU6Yf9n5pWB+@google.com>
 <092dc961-76f6-331a-6f91-a77a58f6732d@intel.com>
 <Y1F4AoeOhNFQnHnJ@google.com>
 <b40fd338-cb3b-b602-0059-39f775e77ad6@intel.com>
 <Y1LmWAyG7S4bgzBs@google.com>
 <70ea1214-38aa-3b51-9c1d-6661b3b45144@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70ea1214-38aa-3b51-9c1d-6661b3b45144@intel.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022 at 09:37:59AM +0800, Xiaoyao Li wrote:
> On 10/22/2022 2:35 AM, Sean Christopherson wrote:
> > On Fri, Oct 21, 2022, Xiaoyao Li wrote:
> > > On 10/21/2022 12:32 AM, Sean Christopherson wrote:
> > > > If we really want to clean up this code, I think the correct approach would be to
> > > > inject #GP on all relevant MSRs if CPUID.MCA==0, e.g.
> > > 
> > > It's what I thought of as well. But I didn't find any statement in SDM of
> > > "Accessing Machine Check MSRs gets #GP if no CPUID.MCA"
> > 
> > Ugh, stupid SDM.  Really old SDMs, e.g. circa 1997, explicity state in the
> > CPUID.MCA entry that:
> > 
> >    Processor supports the MCG_CAP MSR.
> > 
> > But, when Intel introduced the "Architectural MSRs" section (2001 or so), the
> > wording was changed to be less explicit:
> > 
> >    The Machine Check Architecture, which provides a compatible mechanism for error
> >    reporting in P6 family, Pentium 4, and Intel Xeon processors, and future processors,
> >    is supported. The MCG_CAP MSR contains feature bits describing how many banks of
> >    error reporting MSRs are supported.
> > 
> > and the entry in the MSR index just lists P6 as the dependency:
> > 
> >    IA32_MCG_CAP (MCG_CAP) Global Machine Check Capability (R/O) 06_01H
> > 
> > So I think it's technically true that MCG_CAP is supposed to exist iff CPUID.MCA=1,
> > but we'd probably need an SDM change to really be able to enforce that :-(
> 
> I'll talk to Intel architects for this. :)

[I'm not a h/w architect ... but I do write/support the Linux machine
check code]

Current edition of the SDM describes the MCA bit in CPUID(EAX=1).EDX in
volume 2, Table 3-11:

   Machine Check Architecture. A value of 1 indicates the Machine Check
   Architecture of reporting machine errors is supported. The MCG_CAP MSR
   contains feature bits describing how many banks of error reporting MSRs
   are supported

So a value of 0 would mean Machine check architecture is NOT supported.

The only rationale meaning for "Machine check architecture is supported"
is you get everything in Vol3B chapter 15 if MCA is supported, and you
don't get it if it isn't. The unsupported behaviour is not explicitly
defined ... so if you want the do something other than #GP, you could do
so ... but that sounds like s silly choice.

Ditto for accessing a machine check bank with number greater than that
specified in IA32_MCG_CAP.count. SDM doesn't say that this must #GP,
but #GP would be a sane and reasonble response. You could also read as
all zero and drop writes.

-Tony
