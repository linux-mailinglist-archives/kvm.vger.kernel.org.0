Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841152A9AA4
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 18:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgKFRSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 12:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgKFRSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 12:18:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C538BC0613CF;
        Fri,  6 Nov 2020 09:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=h4CuqOgdybc1Oxj7qGtVKsDi0lWPsCMPHf40kTBBqlA=; b=aCf9ja6H2zuGi8/BiMx9zFLxM2
        nzXbAnkJOOEL64Oby3ja7A3ld5bEOFxLoXZLWyM0FzqGj1Pkp60KY5pb8uqmmexuA+LS+ujiROhCz
        dqIQes/pkumuHqXrprxobo9t6bGNS3Tfx6wo9tb+c1e0mLpLCVPmm/qXx6YT68GQj71F5zsZC/YAL
        bOnxPGLf3pdsyp6bvVeodVgU8isyp6zB9dx8LfLqIfZuNJsd6jUVkrzb9RVY91hoJSKX+/sT+hj7P
        DrV31h2hCUvVt6BNg7YIXPVKWJz1Yb6fjY05JqGqrJ/nZ1c8VjrJexYS0xZHtWRXQQS4SwsqH0rRS
        uYE+9z9g==;
Received: from host86-187-225-174.range86-187.btcentralplus.com ([86.187.225.174] helo=[10.220.150.94])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kb5NM-0001H2-3R; Fri, 06 Nov 2020 17:18:12 +0000
Date:   Fri, 06 Nov 2020 17:18:08 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <20201106093200.6d8975ae@w520.home>
References: <20201026175325.585623-1-dwmw2@infradead.org> <20201027143944.648769-1-dwmw2@infradead.org> <20201027143944.648769-2-dwmw2@infradead.org> <20201028143509.GA2628@hirez.programming.kicks-ass.net> <ef4660dba8135ca5a1dc7e854babcf65d8cef46f.camel@infradead.org> <f0901be7-1526-5b6a-90cb-6489e53cb92f@redhat.com> <20201106093200.6d8975ae@w520.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
To:     Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        kvm@vger.kernel.org
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <F67D16D9-A5F0-4B40-8E1F-E713174D997B@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6 November 2020 16:32:00 GMT, Alex Williamson <alex=2Ewilliamson@redhat=
=2Ecom> wrote:
>On Fri, 6 Nov 2020 11:17:21 +0100
>Paolo Bonzini <pbonzini@redhat=2Ecom> wrote:
>
>> On 04/11/20 10:35, David Woodhouse wrote:
>> > On Wed, 2020-10-28 at 15:35 +0100, Peter Zijlstra wrote: =20
>> >> On Tue, Oct 27, 2020 at 02:39:43PM +0000, David Woodhouse wrote: =20
>> >>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>> >>>
>> >>> This allows an exclusive wait_queue_entry to be added at the head
>of the
>> >>> queue, instead of the tail as normal=2E Thus, it gets to consume
>events
>> >>> first without allowing non-exclusive waiters to be woken at all=2E
>> >>>
>> >>> The (first) intended use is for KVM IRQFD, which currently has
>> >>> inconsistent behaviour depending on whether posted interrupts are
>> >>> available or not=2E If they are, KVM will bypass the eventfd
>completely
>> >>> and deliver interrupts directly to the appropriate vCPU=2E If not,
>events
>> >>> are delivered through the eventfd and userspace will receive them
>when
>> >>> polling on the eventfd=2E
>> >>>
>> >>> By using add_wait_queue_priority(), KVM will be able to
>consistently
>> >>> consume events within the kernel without accidentally exposing
>them
>> >>> to userspace when they're supposed to be bypassed=2E This, in turn,
>means
>> >>> that userspace doesn't have to jump through hoops to avoid
>listening
>> >>> on the erroneously noisy eventfd and injecting duplicate
>interrupts=2E
>> >>>
>> >>> Signed-off-by: David Woodhouse <dwmw@amazon=2Eco=2Euk> =20
>> >>
>> >> Acked-by: Peter Zijlstra (Intel) <peterz@infradead=2Eorg> =20
>> >=20
>> > Thanks=2E Paolo, the conclusion was that you were going to take this
>set
>> > through the KVM tree, wasn't it?
>> >  =20
>>=20
>> Queued, except for patch 2/3 in the eventfd series which Alex hasn't=20
>> reviewed/acked yet=2E
>
>There was no vfio patch here, nor mention why it got dropped in v2
>afaict=2E  Thanks,

That was a different (but related) series=2E The VFIO one is https://patch=
work=2Ekernel=2Eorg/project/kvm/patch/20201027135523=2E646811-3-dwmw2@infra=
dead=2Eorg/

Thanks=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
