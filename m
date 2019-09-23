Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34E1BBA92
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 19:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440152AbfIWReZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 13:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389167AbfIWReZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 13:34:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A26483082E6E;
        Mon, 23 Sep 2019 17:34:24 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 12D4960852;
        Mon, 23 Sep 2019 17:34:22 +0000 (UTC)
Date:   Mon, 23 Sep 2019 13:34:21 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] x86: spec_ctrl: fix SPEC_CTRL initialization after
 kexec
Message-ID: <20190923173421.GA13551@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-2-aarcange@redhat.com>
 <c56d8911-5323-ac40-97b3-fa8920725197@redhat.com>
 <20190923153057.GA18195@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923153057.GA18195@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 23 Sep 2019 17:34:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Mon, Sep 23, 2019 at 08:30:57AM -0700, Sean Christopherson wrote:
> On Mon, Sep 23, 2019 at 12:22:23PM +0200, Paolo Bonzini wrote:
> > On 20/09/19 23:24, Andrea Arcangeli wrote:
> > > We can't assume the SPEC_CTRL msr is zero at boot because it could be
> > > left enabled by a previous kernel booted with
> > > spec_store_bypass_disable=on.
> > > 
> > > Without this fix a boot with spec_store_bypass_disable=on followed by
> > > a kexec boot with spec_store_bypass_disable=off would erroneously and
> > > unexpectedly leave bit 2 set in SPEC_CTRL.
> > > 
> > > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > Can you send this out separately, so that Thomas et al. can pick it up
> > as a bug fix?

As specified in the cover letter 1/17 was already intended to be
merged separately. I just keep this included in case people had the
idea of using kexec to benchmark this work, because I was bitten by
that bug myself and it wasted a few days worth of benchmarks.

> Can all off the patches that are not directly related to the monolithic
> conversion be sent separately?  AFAICT, patches 01, 03, 07, 08, 14, 15, 16
> and 17 are not required or dependent on the conversion to a monolithic
> module.  That's almost half the series...

03 07 08 are directly related to the monolithic conversion as the
subject of the patch clarifies. In fact I should try to reorder 7/8 in
front to make things more bisectable under all config options.

Per subject of the patch, 14 is also an optimization that while not a
strict requirement, is somewhat related to the monolithic conversion
because in fact it may naturally disappear if I rename the vmx/svm
functions directly.

15 16 17 don't have the monolithic tag in the subject of the patch and
they're obviously unrelated to the monolithic conversion, but when I
did the first research on this idea of dropping kvm.ko a couple of
months ago, things didn't really work well until I got rid of those
few last retpolines too. If felt as if the large retpoline regression
wasn't linear with the number of retpolines executed for each vmexit,
and that it was more linear with the percentage of vmexits that hit on
any number of retpolines. So while they're not part of the monolithic
conversion I assumed they're required to run any meaningful benchmark.

I can drop 15 16 17 from further submits of course, after clarifying
benchmark should be only run on the v1 full set I posted earlier, or
they wouldn't be meaningful.

Thanks,
Andrea
