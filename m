Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9354E7B5C6A
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 23:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjJBVRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 17:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjJBVRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 17:17:24 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1B9A4;
        Mon,  2 Oct 2023 14:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LauJpiU9vgGJKI+xHtCdZfyl14FEn4Hj7li+RFgP5pk=; b=q2WKSjduqc6gNmUy5+PKB56DmA
        sO5XkEIeo9TmA9DcELYksbTAZJdotXfki4LFStfRDdRkzaF0coOJxj8BSjKb8yCKbSO8ejbDx+KQK
        14P8x2caxCfxHcQmfpMwE7/cw/hKvHH2Z6PasExE/uuq57M1nxShgjPDTEJWYe9HhVAiN9ZOB9Ed4
        KrJuDpOmHAdwimVlF0Lmfw3QFCkH48Ucp3R+gf4aHwoAxNFKdsHKRAzNjXaEW0wxxdGB2zZYwkvy7
        gg2isWBwYhxL5v7isCEfvXu2QnRfANgtg2WCPi53fmVyfT2BmxatJu/Zp5YkYJDnwQVW7diG6HmZt
        IGQkmMww==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qnQHa-009IId-2B;
        Mon, 02 Oct 2023 21:16:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 81288300454; Mon,  2 Oct 2023 23:16:51 +0200 (CEST)
Date:   Mon, 2 Oct 2023 23:16:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
Message-ID: <20231002211651.GA3774@noisy.programming.kicks-ass.net>
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
 <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com>
 <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com>
 <a8479764-34a1-334f-3865-c01325d772d9@oracle.com>
 <ZRsJiuKdXtWos_Xh@google.com>
 <20231002210607.GD27267@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002210607.GD27267@noisy.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023 at 11:06:07PM +0200, Peter Zijlstra wrote:
> On Mon, Oct 02, 2023 at 11:18:50AM -0700, Sean Christopherson wrote:
> > +PeterZ
> > 
> > Thomas and Peter,
> > 
> > We're trying to address an issue where KVM's paravirt kvmclock drifts from the
> > host's TSC-based monotonic raw clock because of historical reasons (at least, AFAICT),
> > even when the TSC is constant.  Due to some dubious KVM behavior, KVM may sometimes
> > re-sync kvmclock against the host's monotonic raw clock, which causes non-trivial
> > jumps in time from the guest's perspective.
> > 
> > Linux-as-a-guest demotes all paravirt clock sources when the TSC is constant and
> > nonstop, and so the goofy KVM behavior isn't likely to affect the guest's clocksource,
> > but the guest's sched_clock() implementation keeps using the paravirt clock.
> > 
> > Irrespective of if/how we fix the KVM host-side mess, using a paravirt clock for
> > the scheduler when using a constant, nonstop TSC for the clocksource seems at best
> > inefficient, and at worst unnecessarily complex and risky.
> > 
> > Is there any reason not to prefer native_sched_clock() over whatever paravirt
> > clock is present when the TSC is the preferred clocksource? 
> 
> I see none, that whole pv_clock thing is horrible crap.

In fact, I don't really see a reason to ever use pv_clock, even on
non-constant TSC. The sched_clock machinery used on x86 (and ia64 at
some point) reverts to tick-based + 'TSC-with-monotonicity-filter
refinement' once it detects the TSC is crap.

And that should work in a guest too I suppose.

Also, I really should clean all that up -- it's all static_key based,
but I think I can do a saner version with static_call. But that's stuck
somewhere on the eternal todo list.
