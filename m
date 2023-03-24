Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB6F6C74F1
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 02:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjCXBQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 21:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCXBQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 21:16:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353E512051;
        Thu, 23 Mar 2023 18:16:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679620613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AI8etHPrIx3jNkAoUDUVMeNijSPSKzEAm2IfFhSlIbE=;
        b=fIFHx9yH4O/aC/t1AkkNkpjVHdQIt60hJsQu8ylHND7K0tq1kfKoXAcVqd++UX0SRSZXjt
        5xp37iwlL4Qi4FHMXWo4q7EJzHCuLlG9Nio8MBsxIPNAWUOggysRRF5XqPMZ+nLScHLHal
        W051YPgip373z9q9fD6MTjdn2lzswQPRf3eDQxZNLuka8CR3azfUyYR2IxCE8HKTV0ZoPA
        +2mX0nL/+nOkBNBOlQNrbreMxezl7yp7qu3fTb6yVsLyloakmyCHosIpUvjC5LcAjSqQ0E
        2l9CpLq2HlfV1/1PkQAed2Rpqf/sZARg8NN/9V+Kth8CdWux4e+TspKDO0UCIg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679620613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AI8etHPrIx3jNkAoUDUVMeNijSPSKzEAm2IfFhSlIbE=;
        b=F6o/tiXXGWoGBRzOeewpITW3gHudiy7QzOC1tZDoe5XNrho6enQKB5rjHXJtfQmSmlhgeF
        lWyDJKJ6ZpLtq7BA==
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
In-Reply-To: <8dff6ae5ffaebfbcc55a01c04420fd478070b830.camel@infradead.org>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-4-usama.arif@bytedance.com> <874jqb8588.ffs@tglx>
 <871qlf83wj.ffs@tglx>
 <8dff6ae5ffaebfbcc55a01c04420fd478070b830.camel@infradead.org>
Date:   Fri, 24 Mar 2023 02:16:53 +0100
Message-ID: <87v8ir6j96.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23 2023 at 23:12, David Woodhouse wrote:
> On Fri, 2023-03-24 at 00:05 +0100, Thomas Gleixner wrote:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (re=
t && can_rollback_cpu(st))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WARN_ON(cpuhp_invoke_callback_ran=
ge(false, cpu, st, CPUHP_OFFLINE));
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0}
>
> And I'll take doing this bit unconditionally (it's basically a no-op if
> they already got rolled all the way back to CPUHP_OFFLINE, right?).
>
> But the additional complexity of having multiple steps is fairly
> minimal, and I'm already planning to *use* another one even in x86, as
> discussed.

It's not about the "complexity". That's a general design question and
I'm not agreeing with your approach of putting AP specifics into the BP
state space.

The BP only phase ends at the point where the AP is woken up via
SIPI/INIT/whatever. Period.

And no, we are not making this special just because it's the easiest way
to get it done. I have _zero_ interest in this kind of hackery which
just slaps stuff into the code where its conveniant without even
thinking about proper separations

We went a great length to separate things clearly and it takes more than
"oh let's reserve a few special states" to keep this separation
intact. That's a matter of correctness, maintainability and taste.

That microcode thing on X86 has absolutely no business in the pre
bringup DYN states. It's an AP problem and it can be solved completely
without BP interaction.

And before you start drooling over further great parallelism, can you
please take a step back and come up with a sensible design for the
actual real world requirments?

The point is that after an AP comes out of lala land and starts
executing there are mandatory synchronization points which need to be
handled by design. The number of synchronization points is architecture
and platform specific and might be 0, but thats a detail.

So the proper thing is to split CPUHP_BRINGUP_CPU, which is the bridging
state between AP and BP today, into a set of synchronization points
between BP and AP.

But that's non-trivial because if you look at bringup_cpu() then you'll
notice that this state has an implicit protection against interrupt
allocation/free and quite some architectures rely on this for their
early bringup code and possibly their STARTING state callbacks.

That aside. Let's just look at x86 as of today from the BP side:

    1) Wakeup AP
    2) Wait until there is sign of life
    3) Let AP proceed
    5) Wait until AP is done with init
    6) TSC synchronization
    7) Wait until it is online

and on the AP side:

    1) Do low level init
    2) Report life
    3) Wait until BP allows to proceed
    4) Do init
    5) Report done
    6) TSC synchronization
    7) Report online

So surely you could claim that up to #6 (TSC sync) nothing needs to
synchronize.

But that's simply not true because topology information is implicitely
serialized by CPU hotplug and your attempt to serialize that in patch
7/8 is not cutting it at all because AP #4 (STARTING) callbacks rely
implicitely on the immutability of the topology information and so do
some of the later (threaded) AP callbacks too.

As I said before 5 out of 10 callbacks I looked at are not ready for
this.

Just because it did not explode in your face yet, does not make any of
your wet dreams more correct.

Again: I'm not interested in this kind of "works for me" nonsense at
all. I wasted enough time already to make CPU hotplug reliable and
understandable. I have no intention to waste more time on it just
because.

Thanks,

        tglx
