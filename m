Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CB9679FD8
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 18:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbjAXRMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 12:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbjAXRMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 12:12:23 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 996E42D72;
        Tue, 24 Jan 2023 09:12:22 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 122154B3;
        Tue, 24 Jan 2023 09:13:04 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.11.85])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 119773F64C;
        Tue, 24 Jan 2023 09:12:16 -0800 (PST)
Date:   Tue, 24 Jan 2023 17:12:14 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <Y9ARbgtYhxSuOIlZ@FVFF77S0Q05N>
References: <20230123205009.790550642@infradead.org>
 <20230123205515.059999893@infradead.org>
 <20230123165304.370121e7@gandalf.local.home>
 <20230123170753.7ac9419e@gandalf.local.home>
 <Y8/u00WHGElMDjoo@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8/u00WHGElMDjoo@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 03:44:35PM +0100, Peter Zijlstra wrote:
> On Mon, Jan 23, 2023 at 05:07:53PM -0500, Steven Rostedt wrote:
> 
> > Actually, perhaps we can just add this, and all you need to do is create
> > and set CONFIG_NO_RCU_TRACING (or some other name).
> 
> Elsewhere I've used CONFIG_ARCH_WANTS_NO_INSTR for this.

Yes please; if we use CONFIG_ARCH_WANTS_NO_INSTR then arm64 will get this "for
free" once we add the missing checks (which I assume we need) in our ftrace_prepare_return().

> Anyway, I took it for a spin and it .... doesn't seems to do the job.
> 
> With my patch the first splat is
> 
>   "RCU not on for: cpuidle_poll_time+0x0/0x70"
> 
> While with yours I seems to get the endless:
> 
>   "WARNING: suspicious RCU usage"
> 
> thing. Let me see if I can figure out where it goes side-ways.

Hmmm... for WARN_ONCE() don't we need to wake RCU first also? I thought we
needed that at least for the printk machinery?

Thanks,
Mark.
