Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3624A4FB745
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344339AbiDKJYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiDKJYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:24:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A00C3337C;
        Mon, 11 Apr 2022 02:21:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649668908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=/ol4+bGrNb+QqTb72FmI1L958kV08K37LurxqmrD6Yo=;
        b=DmpkuI4pHY1D6VU6y+UA9OgCACafnECWy3Sc2pKXtOW0YohcuS3IHkhxqAmrKLPgPaEr5Z
        rbc1HN/+jNY4Zw9cSTd6Qv5m7s8gMJzjz02wkpgXZDQKfU6euGm28cEN4Txkf83sQFjg/3
        7GgvF2DgV4BBz2rYzCbww8k0jpW27hx1Bs1LWeaYgN6+VxtK6OQ56J/wG/CmTIGYqAAc4+
        DuTnZV6uPyWRUl6Cb/+7JlauS0JJf1p0//3GjtwaFs56DLXn+lccFvDLLwMs/sR6e8U13+
        vyg6edSBNiqQzZ9/5u4gu92TBxIZuOpjSdsr1R/MdTfojPNc5xyed1B+pAI6sg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649668908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=/ol4+bGrNb+QqTb72FmI1L958kV08K37LurxqmrD6Yo=;
        b=kMv4rAmeaYGAenvlqVXEiiwJgYg9wybGLF5ejSeezyLKEeRBqo2tAHnROmSIVFpgADNUFl
        jBYt3+NZ3z00NCDA==
To:     Pete Swain <swine@google.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Johan Hovold <johan@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Pete Swain <swine@google.com>
Subject: Re: [PATCH 2/2] timers: retpoline mitigation for time funcs
In-Reply-To: <87r165gmoz.ffs@tglx>
Date:   Mon, 11 Apr 2022 11:21:47 +0200
Message-ID: <87pmlof00k.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pete,

On Sun, Apr 10 2022 at 14:14, Thomas Gleixner wrote:
> On Fri, Feb 18 2022 at 14:18, Pete Swain wrote:
>> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
>> index 003ccf338d20..ac15412e87c4 100644
>> --- a/kernel/time/clockevents.c
>> +++ b/kernel/time/clockevents.c
>> @@ -245,7 +245,8 @@ static int clockevents_program_min_delta(struct clock_event_device *dev)
>>  
>>  		dev->retries++;
>>  		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
>> -		if (dev->set_next_event((unsigned long) clc, dev) == 0)
>> +		if (INDIRECT_CALL_1(dev->set_next_event, lapic_next_deadline,
>> +				  (unsigned long) clc, dev) == 0)
>
> No. We are not sprinkling x86'isms into generic code.
>
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -190,7 +190,7 @@ static inline u64 tk_clock_read(const struct tk_read_base *tkr)
>>  {
>>  	struct clocksource *clock = READ_ONCE(tkr->clock);
>>  
>> -	return clock->read(clock);
>> +	return INDIRECT_CALL_1(clock->read, read_tsc, clock);
>
> Again. No X86 muck here.

Just for clarification. I have absolutely no interest in opening this
can of worms. The indirect call is in general more expensive on some
architectures, so when we grant this for x86, then the next architecture
comes around the corner and wants the same treatment. Guess how well
that works and how maintainable this is.

And no, you can't just go there and have a

 #define arch_read_favourite_clocksource		read_foo

because we have multiplatform kernels where the clocksource is selected
at runtime which means every platform wants to be the one defining this.

You can do that in your own frankenkernels, but for mainline this is not
going to fly. You have to come up with something smarter than just
taking your profiling results and slapping INDIRECT_CALL_*() all over
the place. INDIRECT_CALL is a hack as it leaves the conditional around
even if retpoline gets patched out.

The kernel has mechanisms to do better than that.

Let's look at tk_clock_read(). tkr->clock changes usually once maybe
twice during boot. Until shutdown it might change when e.g. TSC becomes
unstable and there are a few other cases like suspend/resume. But none
of these events are hotpath.

While we have several instances of tk_read_base, all of them have the
same clock pointer, except for the rare case of suspend/resume. It's
redundant storage for various reasons.

So with some thought this can be implemented with static_call() which is
currently supported by x86 and powerpc32, but there is no reason why
it can't be supported by other architectures. INDIRECT_CALL is a x86'ism
with a dependency on RETPOLINE, which will never gain traction outside
of x86.

Thanks,

        tglx

