Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F65220FCD1
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 21:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgF3Tfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 15:35:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:60496 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgF3Tfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 15:35:41 -0400
IronPort-SDR: ZOJF+aLkFEpwJNP5Iz+/2Bki/OVwdNWpBnaFVd9aml5iHWUZaJzP7YFoJ91KjtZvkSlUOZDtd4
 7bnzqBI8XXXA==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="231232347"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="231232347"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 12:35:41 -0700
IronPort-SDR: elbEF66KLsqgAltHscLNUbIrO614kmKeO9ANNqNxowpTqxofml1+JQC7FYMP2gbu3Ke22j3lmR
 a1ViNNSipw2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="321019680"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Jun 2020 12:35:40 -0700
Date:   Tue, 30 Jun 2020 12:35:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Print more (accurate) info if
 RDTSC diff test fails
Message-ID: <20200630193540.GH7733@linux.intel.com>
References: <20200124234608.10754-1-sean.j.christopherson@intel.com>
 <705151e0-6a8b-1e15-934d-dd96f419dcd8@oracle.com>
 <CAAAPnDEA4u0YRLtW7OsWtL-Uy=5paDmrxx7EScDFsH5aqG6QJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDEA4u0YRLtW7OsWtL-Uy=5paDmrxx7EScDFsH5aqG6QJA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.

On Mon, Jan 27, 2020 at 06:30:11AM -0800, Aaron Lewis wrote:
> On Sat, Jan 25, 2020 at 11:16 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> >
> >
> > On 1/24/20 3:46 PM, Sean Christopherson wrote:
> > > Snapshot the delta of the last run and display it in the report if the
> > > test fails.  Abort the run loop as soon as the threshold is reached so
> > > that the displayed delta is guaranteed to a failed delta.  Displaying
> > > the delta helps triage failures, e.g. is my system completely broken or
> > > did I get unlucky, and aborting the loop early saves 99900 runs when
> > > the system is indeed broken.
> > >
> > > Cc: Nadav Amit <nadav.amit@gmail.com>
> > > Cc: Aaron Lewis <aaronlewis@google.com>
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >   x86/vmx_tests.c | 11 ++++++-----
> > >   1 file changed, 6 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > > index b31c360..4049dec 100644
> > > --- a/x86/vmx_tests.c
> > > +++ b/x86/vmx_tests.c
> > > @@ -9204,6 +9204,7 @@ static unsigned long long rdtsc_vmexit_diff_test_iteration(void)
> > >
> > >   static void rdtsc_vmexit_diff_test(void)
> > >   {
> > > +     unsigned long long delta;
> > >       int fail = 0;
> > >       int i;
> > >
> > > @@ -9226,17 +9227,17 @@ static void rdtsc_vmexit_diff_test(void)
> > >       vmcs_write(EXI_MSR_ST_CNT, 1);
> > >       vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
> > >
> > > -     for (i = 0; i < RDTSC_DIFF_ITERS; i++) {
> > > -             if (rdtsc_vmexit_diff_test_iteration() >=
> > > -                 HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
> > > +     for (i = 0; i < RDTSC_DIFF_ITERS && fail < RDTSC_DIFF_FAILS; i++) {
> > > +             delta = rdtsc_vmexit_diff_test_iteration();
> > > +             if (delta >= HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
> > >                       fail++;
> > >       }
> > >
> > >       enter_guest();
> > >
> > >       report(fail < RDTSC_DIFF_FAILS,
> > > -            "RDTSC to VM-exit delta too high in %d of %d iterations",
> > > -            fail, RDTSC_DIFF_ITERS);
> > > +            "RDTSC to VM-exit delta too high in %d of %d iterations, last = %llu",
> > > +            fail, i, delta);
> > >   }
> > >
> > >   static int invalid_msr_init(struct vmcs *vmcs)
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> 
> Reviewed-by: Aaron Lewis <aaronlewis@google.com>
