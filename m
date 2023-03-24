Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67966C7F2C
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 14:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjCXN5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 09:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjCXN5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 09:57:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89C913DC6;
        Fri, 24 Mar 2023 06:57:15 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679666234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+bCDnKyHBfH5uaHBerUDgkfOFS79H0YqmcZygZ+KPUM=;
        b=AWOi3eKo9uXJG0SFpvXBnN2WYWwX4FNTIG/wg8Vuu9o/wXtgJ2TKdWQPvR2lPJK/pNGqUA
        tvsoeCiSGH1ekHfZc/jSCK63/RjFAdvpVFZXcifwB310gMMbXzxg7erN5xj9XQbtNLDEoW
        iACz2oyclzw2kTZFhZykELkZJ210W8VXzyeGYGzoUWlUXmDGVUdcHjNk+KrySSe/ATY8lJ
        427OWG3p9Ct1G02F2mkDIXFrmtyDCHeCfi1hBBiAWMCZ5ddFHJ4BqfvaNp3v8c7zRIfF4H
        eoJd9Vcrlq08i3jQYv7kkWG+iUF3eayAvNp9m1W7nsfJ+SDpvY9kiwGv4mFCww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679666234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+bCDnKyHBfH5uaHBerUDgkfOFS79H0YqmcZygZ+KPUM=;
        b=LcKwElBt4eA0itX1DQMxtokViIfHroeNNSZ8/0EHCixCMcHjEV2iohM1OYqOCy1Y9iE3nK
        jTkD9fibk5WVE0BA==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com
Subject: Re: [PATCH v16 3/8] cpu/hotplug: Add dynamic parallel bringup
 states before CPUHP_BRINGUP_CPU
In-Reply-To: <115b39e0226915b8f69ea0cce2487588f6010995.camel@infradead.org>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-4-usama.arif@bytedance.com> <874jqb8588.ffs@tglx>
 <871qlf83wj.ffs@tglx>
 <8dff6ae5ffaebfbcc55a01c04420fd478070b830.camel@infradead.org>
 <87v8ir6j96.ffs@tglx>
 <115b39e0226915b8f69ea0cce2487588f6010995.camel@infradead.org>
Date:   Fri, 24 Mar 2023 14:57:13 +0100
Message-ID: <87pm8y6yme.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24 2023 at 09:31, David Woodhouse wrote:
> On Fri, 2023-03-24 at 02:16 +0100, Thomas Gleixner wrote:
>> So the proper thing is to split CPUHP_BRINGUP_CPU, which is the bridging
>> state between AP and BP today, into a set of synchronization points
>> between BP and AP.
>
> I feel we're talking past each other a little bit. Because I'd have
> said that's *exactly* what this patch set is doing.
>
> The existing x86 CPUHP_BRINGUP_CPU step in native_cpu_up() has a bunch
> of back-and-forth between BP and AP, which you've enumerated below and
> which I cleaned up and commented in the 'Split up native_cpu_up into
> separate phases and document them' patch.
>
> This patch set literally introduces the new PARALLEL_DYN states to be
> "a set of synchronization points between BP and AP", and then makes the
> x86 code utilise that for the *first* of its back-and-forth exchanges
> between BP and AP.

It provides a dynamic space which is absolutely unspecified and just
opens the door for tinkering.

This first step does not even contain a synchronization point. All it
does is to kick the AP into gear. Not more, not less. Naming this
obscurely as PARALLEL_DYN is a tasteless bandaid.

If you go and look at all __cpu_up() implementations, then you'll notice
that these are very similar. All of them do

   1) Kick AP
   2) Synchronize at least once between BP and AP

There is nothing x86 specific about this. So instead of hiding this
behind a misnomed dynamic space, the obviously correct solution is to
make this an explicit mechanism in the core code and convert _all_
architectures over to this scheme. That's in the first place completely
independent of parallel bringup.

It has a value on it's own as it consolidates the zoo of synchronization
mechanisms (cpumasks, completions, random variables) into one shared
mechanism in the core code.

That's very much different from what your patch is doing. And there is a
very good reason aside of consolidation to do so:

This prepares to handle the parallelism requirements in the core code
instead of letting each architecture come up with its own set of
magic. Which in turn is a prerequisite for allowing the STARTING
callbacks or later the threaded AP states to execute in parallel.

Why? Simply because of this:

  BP			AP              state
  kick()                                BRINGUP_CPU
                        startup()                      
  sync()                sync() 
                        starting()      advances to AP_ONLINE
  sync()                sync()
  TSC_sync()            TSC_sync()
  wait_for_online()     set_online()
                        cpu_startup_entry() AP_ONLINE_IDLE
  wait_for_completion() complete()

This works correctly today because bringup_cpu() does not modify state
and excpects the state to be advanced by the AP once the completion is
done.

So you _cannot_ just throw some magic dynamic states before BRINGUP_CPU
and then expect that the state machine is consistent when the AP is
allowed to run the starting callbacks in parallel.

The sync point after the starting callbacks simply cannot be in that
dynamic state space. It has to be _after_ the AP starting states.

That needs a fundamental change in the way how the state management
at this point works and this needs to be done upfront. Aside of the
general serialization aspects this needs some deep thought whether the
BP control can stay single threaded or if it's required to spawn a
control thread per AP.

The kick CPU into life state is completely independent of the above and
can be moved just before BRINGUP_CPU without violating anything. But
that's where the easy to solve part stops hard.

You might find my wording offensive, but I perceive your "let's use a
few dynamic states and see what sticks" approach offensive too.

The analysis of all this is not rocket science and could have been done
long ago by yourself.

Thanks,

        tglx
