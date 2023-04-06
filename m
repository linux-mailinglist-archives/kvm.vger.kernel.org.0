Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1D46D9759
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 14:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbjDFMxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 08:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbjDFMxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 08:53:00 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E276C7EC9
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 05:52:56 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id qb20so1128287ejc.6
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 05:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680785575; x=1683377575;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IJscOEPUxerIocq5ivhaFnZ1SHI0paGFj+4RY7CI49c=;
        b=mmi2ytKq+NaQhoDUPRHBUEjRhCCPgZiy7rLgIJXfMFck1daXezUDFfW+f8Ya9qW8Nu
         77o8Nv8mCPZJVOJ/Mw5IkzQ/lVA8K8pLYcnCheg3aUT4rIjJIAXX7Utgjw5MQqmXLhtW
         435VTHVUt6RP3++nMGoeLtublMXBqOmF5FEHQb6o99n31lb7S6WZxLIvcTevt83tl6fV
         cKM/LYDc4weOyCwuDkg3btNjWsl6SyXFBeMGeyFU1GWXKNRtgmCulev2zmpW5HSdx9TQ
         WDUIoKFjlt3z2DEYShN6woFM3WBqXviuTCQLf58p6eWApFbTnPJA8N2vEAKJbmcOE3wx
         8r5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680785575; x=1683377575;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IJscOEPUxerIocq5ivhaFnZ1SHI0paGFj+4RY7CI49c=;
        b=2QfIBdJWal6zWHM10G9zNFhh3SWxQASFZhtIt9cMsKe2MFFDUSYZYdhuH6Mb5sz8Ov
         3N5iGy/XpzqCk7ypeYtyBBTXDeXJnrbz9l76c2VrpjPxGS9ovycYWnBR4Msa7apR3o00
         0+Gzqozv2SnwVvp1JhFBjMmCaPU+f7BhwocMmscgSOK0KGlKBRq1nuplgmf5pY7Fx2vZ
         4O6/7TQa77xNdv/eir9pRnXRuxiWjBL4bI8EgqjSmRWtoa/5lYdgEPYTH+RlwRbDKrB7
         7zkEt7I4FCL7EvZgfqFJVZb8nB/SWDoKR8JFuViMveqaLDchpswF8cGAJu49eZte98CV
         9Jew==
X-Gm-Message-State: AAQBX9duIoVyi1af2ZS9dvCEJ43LfP4OcE7N8WnSQpQwfktNfYn3p772
        JNFL31kyMpT1ilTxbWnb4Qaurw==
X-Google-Smtp-Source: AKy350ZjSeUi5W/FMFj8cFd3FZ8IBUmJZCdwJjwrxRaSX9z1B2tETRyepfqtj3cs2LAQGBpYvDx5aA==
X-Received: by 2002:a17:906:9be2:b0:931:624b:680c with SMTP id de34-20020a1709069be200b00931624b680cmr6404112ejc.29.1680785575139;
        Thu, 06 Apr 2023 05:52:55 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id rj13-20020a1709076c8d00b00947ccb6150bsm657067ejc.102.2023.04.06.05.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 05:52:54 -0700 (PDT)
Date:   Thu, 6 Apr 2023 12:52:51 +0000
From:   Quentin Perret <qperret@google.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, David Dai <davidai@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
Message-ID: <ZC7Ao1qoNGYXQ9h4@google.com>
References: <20230330224348.1006691-1-davidai@google.com>
 <ZCx97IKjsBibjdGc@linux.dev>
 <86sfdfv0e1.wl-maz@kernel.org>
 <ZC0n0HRsmNJeJZps@google.com>
 <CAGETcx_9SdyCQ5UHhjsnV5+X8arhXoZS2NN-mewtPM3oHuZrkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGETcx_9SdyCQ5UHhjsnV5+X8arhXoZS2NN-mewtPM3oHuZrkw@mail.gmail.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday 05 Apr 2023 at 14:07:18 (-0700), Saravana Kannan wrote:
> On Wed, Apr 5, 2023 at 12:48 AM 'Quentin Perret' via kernel-team
> > And I concur with all the above as well. Putting this in the kernel is
> > not an obvious fit at all as that requires a number of assumptions about
> > the VMM.
> >
> > As Oliver pointed out, the guest topology, and how it maps to the host
> > topology (vcpu pinning etc) is very much a VMM policy decision and will
> > be particularly important to handle guest frequency requests correctly.
> >
> > In addition to that, the VMM's software architecture may have an impact.
> > Crosvm for example does device emulation in separate processes for
> > security reasons, so it is likely that adjusting the scheduling
> > parameters ('util_guest', uclamp, or else) only for the vCPU thread that
> > issues frequency requests will be sub-optimal for performance, we may
> > want to adjust those parameters for all the tasks that are on the
> > critical path.
> >
> > And at an even higher level, assuming in the kernel a certain mapping of
> > vCPU threads to host threads feels kinda wrong, this too is a host
> > userspace policy decision I believe. Not that anybody in their right
> > mind would want to do this, but I _think_ it would technically be
> > feasible to serialize the execution of multiple vCPUs on the same host
> > thread, at which point the util_guest thingy becomes entirely bogus. (I
> > obviously don't want to conflate this use-case, it's just an example
> > that shows the proposed abstraction in the series is not a perfect fit
> > for the KVM userspace delegation model.)
> 
> See my reply to Oliver and Marc. To me it looks like we are converging
> towards having shared memory between guest, host kernel and VMM and
> that should address all our concerns.

Hmm, that is not at all my understanding of what has been the most
important part of the feedback so far: this whole thing belongs to
userspace.

> The guest will see a MMIO device, writing to it will trigger the host
> kernel to do the basic "set util_guest/uclamp for the vCPU thread that
> corresponds to the vCPU" and then the VMM can do more on top as/if
> needed (because it has access to the shared memory too). Does that
> make sense?

Not really no. I've given examples of why this doesn't make sense for
the kernel to do this, which still seems to be the case with what you're
suggesting here.

> Even in the extreme example, the stuff the kernel would do would still
> be helpful, but not sufficient. You can aggregate the
> util_guest/uclamp and do whatever from the VMM.
> Technically in the extreme example, you don't need any of this. The
> normal util tracking of the vCPU thread on the host side would be
> sufficient.
>
> Actually any time we have only 1 vCPU host thread per VM, we shouldn't
> be using anything in this patch series and not instantiate the guest
> device at all.

> > So +1 from me to move this as a virtual device of some kind. And if the
> > extra cost of exiting all the way back to userspace is prohibitive (is
> > it btw?),
> 
> I think the "13% increase in battery consumption for games" makes it
> pretty clear that going to userspace is prohibitive. And that's just
> one example.

I beg to differ. We need to understand where these 13% come from in more
details. Is it really the actual cost of the userspace exit? Or is it
just that from userspace the only knob you can play with is uclamp and
that didn't reach the expected level of performance?

If that is the userspace exit, then we can work to optimize that -- it's
a fairly common problem in the virt world, nothing special here.

And if the issue is the lack of expressiveness in uclamp, then that too
is something we should work on, but clearly giving vCPU threads more
'power' than normal host threads is a bit of a red flag IMO. vCPU
threads must be constrained in the same way that userspace threads are,
because they _are_ userspace threads.

> > then we can try to work on that. Maybe something a la vhost
> > can be done to optimize, I'll have a think.
> >
> > > The one thing I'd like to understand that the comment seems to imply
> > > that there is a significant difference in overhead between a hypercall
> > > and an MMIO. In my experience, both are pretty similar in cost for a
> > > handling location (both in userspace or both in the kernel). MMIO
> > > handling is a tiny bit more expensive due to a guaranteed TLB miss
> > > followed by a walk of the in-kernel device ranges, but that's all. It
> > > should hardly register.
> > >
> > > And if you really want some super-low latency, low overhead
> > > signalling, maybe an exception is the wrong tool for the job. Shared
> > > memory communication could be more appropriate.
> >
> > I presume some kind of signalling mechanism will be necessary to
> > synchronously update host scheduling parameters in response to guest
> > frequency requests, but if the volume of data requires it then a shared
> > buffer + doorbell type of approach should do.
> 
> Part of the communication doesn't need synchronous handling by the
> host. So, what I said above.

I've also replied to another message about the scale invariance issue,
and I'm not convinced the frequency based interface proposed here really
makes sense. An AMU-like interface is very likely to be superior.

> > Thinking about it, using SCMI over virtio would implement exactly that.
> > Linux-as-a-guest already supports it IIRC, so possibly the problem
> > being addressed in this series could be 'simply' solved using an SCMI
> > backend in the VMM...
> 
> This will be worse than all the options we've tried so far because it
> has the userspace overhead AND uclamp overhead.

But it doesn't violate the whole KVM userspace delegation model, so we
should start from there and then optimize further if need be.

Thanks,
Quentin
