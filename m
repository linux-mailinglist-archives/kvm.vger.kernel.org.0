Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928B435C74E
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbhDLNOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:14:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:29917 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241101AbhDLNOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 09:14:19 -0400
IronPort-SDR: UxlR4zUjgf+rSliUWqRMIq0zrX22fyqclb53IGh2P4cjsu+Wg0lbzSIII7SOOE8Jz6vlxo0KEv
 VFIRBEpgz8oQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9952"; a="279486727"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="279486727"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 06:13:33 -0700
IronPort-SDR: kFhsr/qPtNDuI/5nmHJbXbftuixI/WLpD7HAG0u7ChzYnzqTZX4dKTpmVJXGA50ywlFn2MTwhJ
 6wbHgT9MGEnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="521178063"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 12 Apr 2021 06:13:31 -0700
Date:   Mon, 12 Apr 2021 21:25:51 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] [kvm-unit-tests PATCH] x86/access: Fix intermittent test
 failure
Message-ID: <20210412132551.GA20077@local-michael-cet-test.sh.intel.com>
References: <20210409075518.32065-1-weijiang.yang@intel.com>
 <1c641daa-c11d-69b6-e63b-ff7d0576c093@redhat.com>
 <YHCkIRvXAFmS/hUn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHCkIRvXAFmS/hUn@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021 at 06:59:45PM +0000, Sean Christopherson wrote:
> On Fri, Apr 09, 2021, Paolo Bonzini wrote:
> > On 09/04/21 09:55, Yang Weijiang wrote:
> > > During kvm-unit-test, below failure pattern is observed, this is due to testing thread
> > > migration + cache "lazy" flush during test, so forcely flush the cache to avoid the issue.
> > > Pin the test app to certain physical CPU can fix the issue as well. The error report is
> > > misleading, pke is the victim of the issue.
> > > 
> > > test user cr4.pke: FAIL: error code 5 expected 4
> > > Dump mapping: address: 0x123400000000
> > > ------L4: 21ea007
> > > ------L3: 21eb007
> > > ------L2: 21ec000
> > > ------L1: 2000000
> > > 
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >   x86/access.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/x86/access.c b/x86/access.c
> > > index 7dc9eb6..379d533 100644
> > > --- a/x86/access.c
> > > +++ b/x86/access.c
> > > @@ -211,6 +211,8 @@ static unsigned set_cr4_smep(int smep)
> > >           ptl2[2] |= PT_USER_MASK;
> > >       if (!r)
> > >           shadow_cr4 = cr4;
> > > +
> > > +    invlpg((void *)(ptl2[2] & ~PAGE_SIZE));
> > >       return r;
> > >   }
> > > 
> > 
> > Applied, thanks.
> 
> Egad, I can't keep up with this new Paolo :-D
> 
> 
> Would it also work to move the existing invlpg() into ac_test_do_access()?
>
Hi, Sean,
You patch works for the app on my side, but one thing makes my confused, my patch
invalidates the mapping for test code(ac_test_do_access), but your patch invlidates
at->virt, they're not mapped to the same page. Why it works?

I simplified the test by only executing two patterns as below:

printf("\n############# start test ############\n\n");
at.flags = 0x8000000;
ac_test_exec(&at, &pool);
at.flags = 0x200000; /* or 0x10200000 */
ac_test_exec(&at, &pool);
printf("############# end test ############\n\n");

with your patch I still got error code 5 while getting  error code 4 with my patch.
What makes it different?

> diff --git a/x86/access.c b/x86/access.c
> index 7dc9eb6..5f335dd 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -451,8 +451,6 @@ fault:
> 
>  static void ac_set_expected_status(ac_test_t *at)
>  {
> -    invlpg(at->virt);
> -
>      if (at->ptep)
>         at->expected_pte = *at->ptep;
>      at->expected_pde = *at->pdep;
> @@ -658,6 +656,9 @@ static int ac_test_do_access(ac_test_t *at)
> 
>      set_cr4_smep(F(AC_CPU_CR4_SMEP));
> 
> +    /* Flush after _all_ setup is done, toggling SMEP may also modify PMDs. */
> +    invlpg(at->virt);
> +
>      if (F(AC_ACCESS_TWICE)) {
>         asm volatile (
>             "mov $fixed2, %%rsi \n\t
