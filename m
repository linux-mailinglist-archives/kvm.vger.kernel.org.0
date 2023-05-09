Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B2F6FBF72
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 08:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbjEIGnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 02:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbjEIGnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 02:43:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C54144BC;
        Mon,  8 May 2023 23:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wv7LrPlxWTrZ14rkME2VRRQZSVOQ7wE/+VS+80j6MWc=; b=XcKBtk/zB7EKluL3QCHMkIHg1L
        FRyFBoIxzUPSmPGR49L0FShoMMEuUXInLYKLMDtkZe020PTEIsJ+xmhApEuZrrROlqBqx1+T/6VTL
        eSH5dMiMSPBMO+6IX2KK4ybVnENgJi2emZ7dTiW5ir2Pk+1MKekBFJ0cmhipyVLRJrxhUMQzd64yd
        RyGljbAyDofd+E8+SJkFDGv2QFdrmZYKgTbjis4G+rNumyanlw88RqgCXZg5OwYjSpRzpleiAIMvd
        t0P7f/h/yj/cCbEXd7s7HSKwUrEYeL25K0kjvErZ4E8pM3vLhLoU0SlnmtH83/1Ztjba9/ohE/7yw
        p/5KCCGQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pwH3L-00EybA-HS; Tue, 09 May 2023 06:42:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 54E3630026A;
        Tue,  9 May 2023 08:42:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 313FC2B0DE80D; Tue,  9 May 2023 08:42:22 +0200 (CEST)
Date:   Tue, 9 May 2023 08:42:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        pmladek@suse.com, senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH 6/9] s390/time: Provide sched_clock_noinstr()
Message-ID: <20230509064222.GA2065796@hirez.programming.kicks-ass.net>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.786238095@infradead.org>
 <ZFnkp6dlOuJqm2II@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFnkp6dlOuJqm2II@osiris>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 09, 2023 at 08:13:59AM +0200, Heiko Carstens wrote:
> 
> 1;115;0cOn Mon, May 08, 2023 at 11:19:57PM +0200, Peter Zijlstra wrote:
> > With the intent to provide local_clock_noinstr(), a variant of
> > local_clock() that's safe to be called from noinstr code (with the
> > assumption that any such code will already be non-preemptible),
> > prepare for things by providing a noinstr sched_clock_noinstr()
> > function.
> > 
> > Specifically, preempt_enable_*() calls out to schedule(), which upsets
> > noinstr validation efforts.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/s390/include/asm/timex.h |   13 +++++++++----
> >  arch/s390/kernel/time.c       |   11 ++++++++++-
> >  2 files changed, 19 insertions(+), 5 deletions(-)
> ...
> > +static __always_inline unsigned long __get_tod_clock_monotonic(void)
> > +{
> > +	return get_tod_clock() - tod_clock_base.tod;
> > +}
> > +
> >  /**
> >   * get_clock_monotonic - returns current time in clock rate units
> >   *
> > @@ -216,7 +221,7 @@ static inline unsigned long get_tod_cloc
> >  	unsigned long tod;
> >  
> >  	preempt_disable_notrace();
> > -	tod = get_tod_clock() - tod_clock_base.tod;
> > +	tod = __get_tod_clock_monotonic();
> >  	preempt_enable_notrace();
> >  	return tod;
> >  }
> ...
> > +unsigned long long noinstr sched_clock_noinstr(void)
> > +{
> > +	return tod_to_ns(__get_tod_clock_monotonic());
> > +}
> > +
> >  /*
> >   * Scheduler clock - returns current time in nanosec units.
> >   */
> >  unsigned long long notrace sched_clock(void)
> >  {
> > -	return tod_to_ns(get_tod_clock_monotonic());
> > +	unsigned long long ns;
> > +	preempt_disable_notrace();
> > +	ns = tod_to_ns(get_tod_clock_monotonic());
> > +	preempt_enable_notrace();
> > +	return ns;
> >  }
> >  NOKPROBE_SYMBOL(sched_clock);
> 
> This disables preemption twice within sched_clock(). So this should either
> call __get_tod_clock_monotonic() instead, or the function could stay as it
> is, which I would prefer.

Duh. Will fix.
