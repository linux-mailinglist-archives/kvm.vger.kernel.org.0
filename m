Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A3BAF0C7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 19:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfIJR70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 13:59:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:2258 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfIJR7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 13:59:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 10:59:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="191886592"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Sep 2019 10:59:25 -0700
Date:   Tue, 10 Sep 2019 10:59:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Bill Wendling <morbo@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] x86: setjmp: ignore clang's
 "-Wsomtimes-uninitialized" flag
Message-ID: <20190910175924.GA11151@linux.intel.com>
References: <CAGG=3QWNQKejpwhbgDy-WSV1C2sw9Ms0TUGwVk8fgEbg9n0ryg@mail.gmail.com>
 <CALMp9eSWpCWDSCgownxsMVTmJNjMvYMiH0K2ybD6yzGqJNiZrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSWpCWDSCgownxsMVTmJNjMvYMiH0K2ybD6yzGqJNiZrg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 10, 2019 at 09:46:36AM -0700, Jim Mattson wrote:
> On Mon, Sep 9, 2019 at 2:10 PM Bill Wendling <morbo@google.com> wrote:
> >
> > Clang complains that "i" might be uninitialized in the "printf"
> > statement. This is a false negative, because it's set in the "if"
> > statement and then incremented in the loop created by the "longjmp".
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> >  x86/setjmp.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/x86/setjmp.c b/x86/setjmp.c
> > index 976a632..cf9adcb 100644
> > --- a/x86/setjmp.c
> > +++ b/x86/setjmp.c
> > @@ -1,6 +1,10 @@
> >  #include "libcflat.h"
> >  #include "setjmp.h"
> >
> > +#ifdef __clang__
> > +#pragma clang diagnostic ignored "-Wsometimes-uninitialized"
> > +#endif
> > +
> >  int main(void)
> >  {
> >      volatile int i;
> 
> Can we just add an initializer here instead?

Doing so would also be a good opportunity to actually report on the
expected vs. actual value of 'i' instead of printing numbers that are
meaningless without diving into the code.
