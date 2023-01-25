Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6C667AE1C
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 10:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbjAYJhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 04:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjAYJhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 04:37:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FEE3AAB;
        Wed, 25 Jan 2023 01:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZUwU0WfkKuo04fSMmIA984hyf8mGmOMaibahgi/MR9o=; b=VjGhy5k2GGPJtyEAcXhtVe1y86
        YWkKQl2Dj9L5P8Bop7IG+5350+plG+8Yt9TqP4lJ/9AfCFbWi7xMhyicDB1SQHl5gRoQ0QKz6XO0s
        Ui98kZYYu090lV1JgqytIPzdA4qH+PdegoNvxmwB/Wi8MKeJ8rJmwKgh/E6kaMTyryv+Ete23mmCW
        lZmY1xIdXKXVwGhdRpOSVuzfNMWoTqc2PporOHz67C2dvoKVcNodvHZjpBgImidwaiMvFbEqXvOy1
        boagX1cr+WFtT34yyhHqvTZ2mQ2WF7yOM+/gRoZFispOjoh7wYvJWQFfpqCbOEavg0/xtYpe5KcxV
        GZV7RTAA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKcDF-005odN-75; Wed, 25 Jan 2023 09:37:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A8C37300137;
        Wed, 25 Jan 2023 10:37:00 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 91F8820774388; Wed, 25 Jan 2023 10:37:00 +0100 (CET)
Date:   Wed, 25 Jan 2023 10:37:00 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, mingo@kernel.org,
        will@kernel.org, boqun.feng@gmail.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        jgross@suse.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, mhiramat@kernel.org, wanpengli@tencent.com,
        vkuznets@redhat.com, boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/6] ftrace/x86: Warn and ignore graph tracing when RCU
 is disabled
Message-ID: <Y9D4PIZacXgWapWX@hirez.programming.kicks-ass.net>
References: <20230123205009.790550642@infradead.org>
 <20230123205515.059999893@infradead.org>
 <20230123165304.370121e7@gandalf.local.home>
 <20230123170753.7ac9419e@gandalf.local.home>
 <Y8/u00WHGElMDjoo@hirez.programming.kicks-ass.net>
 <Y9ARbgtYhxSuOIlZ@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9ARbgtYhxSuOIlZ@FVFF77S0Q05N>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 05:12:14PM +0000, Mark Rutland wrote:
> On Tue, Jan 24, 2023 at 03:44:35PM +0100, Peter Zijlstra wrote:
> > On Mon, Jan 23, 2023 at 05:07:53PM -0500, Steven Rostedt wrote:
> > 
> > > Actually, perhaps we can just add this, and all you need to do is create
> > > and set CONFIG_NO_RCU_TRACING (or some other name).
> > 
> > Elsewhere I've used CONFIG_ARCH_WANTS_NO_INSTR for this.
> 
> Yes please; if we use CONFIG_ARCH_WANTS_NO_INSTR then arm64 will get this "for
> free" once we add the missing checks (which I assume we need) in our ftrace_prepare_return().

Aye.

> > Anyway, I took it for a spin and it .... doesn't seems to do the job.
> > 
> > With my patch the first splat is
> > 
> >   "RCU not on for: cpuidle_poll_time+0x0/0x70"
> > 
> > While with yours I seems to get the endless:
> > 
> >   "WARNING: suspicious RCU usage"
> > 
> > thing. Let me see if I can figure out where it goes side-ways.
> 
> Hmmm... for WARN_ONCE() don't we need to wake RCU first also? I thought we
> needed that at least for the printk machinery?

Yeah, I'm currently running with a hacked up printk that redirects
everything into early_printk() but it still trips up lots.

I was just about to go stick on RCU magic into WARN itself, this isn't
going to be the only site triggering this fail-cascade.
