Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AD437897
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 15:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhJVOBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 10:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhJVOBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 10:01:51 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9482CC061764;
        Fri, 22 Oct 2021 06:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BR6uDgd4EQWygbQFY7F2sfj4ZCUokL+ukMCfSOOPYV8=; b=kEoNugZ1yNlPbNSl50sN+TR1UB
        uHNC1LaF7I2zS04wHiJBkwmhyldxRNtb3zj+1xDe5/DQd1aJpBVAutnUDpmeFUkwPEpavNf6WzS7t
        RO9sQwrEOB5fyM6FUl8QzseY0Yzm4Ie/LraGTtVJwYvGX3TpVHtMbbePlIeMXMWmleAL3w2dLEBoC
        hKEa3kfwerSGQgd3e9Z6QhrDNhV2GcgbU8FkyrdWh4j3ZRrHlABMlVo2AvqnPU4PI3UG2htGk7NLa
        hF5CzWjWTUxTGs3Tv3xxnMf2teOIrasc75t4WSnk2xfSWcHAhq8MZLUARrBCyclcGMB9qx/lIyQ0X
        sEU16JOA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mdv4g-00BacO-VL; Fri, 22 Oct 2021 13:59:11 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 07F69981F9D; Fri, 22 Oct 2021 15:59:10 +0200 (CEST)
Date:   Fri, 22 Oct 2021 15:59:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH] rcuwait: do not enter RCU protection unless a wakeup is
 needed
Message-ID: <20211022135909.GB174703@worktop.programming.kicks-ass.net>
References: <20211020110638.797389-1-pbonzini@redhat.com>
 <YW/61zpycsD8/z4g@hirez.programming.kicks-ass.net>
 <98a72081-6a2b-b644-d029-edd03da84135@redhat.com>
 <CANRm+CyX+ZZh+LbLPBXEfMoExkx78qHpP-=yFCop9gX+LQeWDQ@mail.gmail.com>
 <bd4e3b80-fefd-43e8-e96b-ea81f21569bd@redhat.com>
 <CANRm+Cxpav5FqCBZoQv5BLnC160_RA3YDJc_CFabW7oMBFQ_5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cxpav5FqCBZoQv5BLnC160_RA3YDJc_CFabW7oMBFQ_5g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 08:08:41PM +0800, Wanpeng Li wrote:
> On Wed, 20 Oct 2021 at 20:04, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 20/10/21 14:01, Wanpeng Li wrote:
> > > Yes, in the attachment.
> > >
> > >      Wanpeng
> >
> > This one does not have CONFIG_PREEMPT=y, let alone CONFIG_PREEMPT_RCU.
> > It's completely impossible that this patch has an effect without those
> > options.
> 
> Sorry, should be this one in the attachment.

Uhhmmm.. you have lockdep enabled. You know you shouldn't be doing
performance measurements with lockdep on, right?
