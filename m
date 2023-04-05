Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593186D75D0
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 09:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbjDEHsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 03:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbjDEHsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 03:48:45 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9261C3C03
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 00:48:37 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eg48so138785115edb.13
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 00:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680680916; x=1683272916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p8w6UmRm5BD0nU8eoGMSUY3i4YMySq+vccxjuBrdrGk=;
        b=Er4az+SUwSsypZMrqUPkmi0/nctg+5jtBJGX3n0itJa0VtzZQo1BvCHiFbGupUN3Vj
         AHZVkrQl62hYk3iS59Pl/ZlCqcg8pMQLr53FnGQhXp5D/YEjkkTZoFMvzOcwIqK3nAYn
         yyxf/+Pgp2dioV/6Q27rXufr5omEBU+UH3cPX1l3tOSGuNgEj3H1sVv/Irk1bmGD8suF
         AjqoWpzzNPUHwjPUgPZNI2NewN/ytIQ1LWMZ4lNR2zK+vrnTYNuL+Q+3znkzs3LRj7ia
         B7EYjfnmcdc80z22X6LKXzpMdjdF7PMtbII66DhdPksnvV3kLxXq5urPDETxKMC2JNKD
         ussg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680680916; x=1683272916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8w6UmRm5BD0nU8eoGMSUY3i4YMySq+vccxjuBrdrGk=;
        b=HyaLzHrAaGVwtgWkGQA/GAMdIpMP/6bCcmlS9Yny9aZRL5AYlt6wKroUcmsTlZ5ioF
         gBlo/aAQzALAjsPwCqXPHOfxByeYXT0ZvaVTTQBMbmMzAGPSSQdEabTG3/QWDjLALTzq
         RfLzFWunT9FFGjcLKoUOpLaRiPxcde/8COVsZDbgYd8fiXbq8Dh7EcGJKf35l+Ug78Hz
         nSO7TBzLsqQd012GJLVS0pbP266p7Ol3QHQhvT0EybY6XoHE5QliXNvTo8+PCIyd4DMz
         8Jp78qC00D25hSIV7v/kIvQFuitlWjrWepFDEQ5Swb99KuGPcJsglQoQlsbpNE6TiVIr
         nEOg==
X-Gm-Message-State: AAQBX9fVJuVcUYLAJLqxJiNPhX7mkSVa3KtCVpKOJpAznpWakzyl/vRf
        qXkc3D0WiirvNpk9iCRFEYwklQ==
X-Google-Smtp-Source: AKy350agh4y8u6yqcvybPxa7k4bIoL0RiJQx9kT+gtSHfJM3UtSKuXTj5TsxcO5eYQ19NZXovee1uw==
X-Received: by 2002:a17:907:6e25:b0:931:b34:4172 with SMTP id sd37-20020a1709076e2500b009310b344172mr2776628ejc.3.1680680915886;
        Wed, 05 Apr 2023 00:48:35 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id l15-20020a17090612cf00b009222a7192b4sm6969397ejb.30.2023.04.05.00.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:48:35 -0700 (PDT)
Date:   Wed, 5 Apr 2023 07:48:32 +0000
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     David Dai <davidai@google.com>,
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
Message-ID: <ZC0n0HRsmNJeJZps@google.com>
References: <20230330224348.1006691-1-davidai@google.com>
 <ZCx97IKjsBibjdGc@linux.dev>
 <86sfdfv0e1.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sfdfv0e1.wl-maz@kernel.org>
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

On Tuesday 04 Apr 2023 at 21:49:10 (+0100), Marc Zyngier wrote:
> On Tue, 04 Apr 2023 20:43:40 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Folks,
> > 
> > On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> > 
> > <snip>
> > 
> > > PCMark
> > > Higher is better
> > > +-------------------+----------+------------+--------+-------+--------+
> > > | Test Case (score) | Baseline |  Hypercall | %delta |  MMIO | %delta |
> > > +-------------------+----------+------------+--------+-------+--------+
> > > | Weighted Total    |     6136 |       7274 |   +19% |  6867 |   +12% |
> > > +-------------------+----------+------------+--------+-------+--------+
> > > | Web Browsing      |     5558 |       6273 |   +13% |  6035 |    +9% |
> > > +-------------------+----------+------------+--------+-------+--------+
> > > | Video Editing     |     4921 |       5221 |    +6% |  5167 |    +5% |
> > > +-------------------+----------+------------+--------+-------+--------+
> > > | Writing           |     6864 |       8825 |   +29% |  8529 |   +24% |
> > > +-------------------+----------+------------+--------+-------+--------+
> > > | Photo Editing     |     7983 |      11593 |   +45% | 10812 |   +35% |
> > > +-------------------+----------+------------+--------+-------+--------+
> > > | Data Manipulation |     5814 |       6081 |    +5% |  5327 |    -8% |
> > > +-------------------+----------+------------+--------+-------+--------+
> > > 
> > > PCMark Performance/mAh
> > > Higher is better
> > > +-----------+----------+-----------+--------+------+--------+
> > > |           | Baseline | Hypercall | %delta | MMIO | %delta |
> > > +-----------+----------+-----------+--------+------+--------+
> > > | Score/mAh |       79 |        88 |   +11% |   83 |    +7% |
> > > +-----------+----------+-----------+--------+------+--------+
> > > 
> > > Roblox
> > > Higher is better
> > > +-----+----------+------------+--------+-------+--------+
> > > |     | Baseline |  Hypercall | %delta |  MMIO | %delta |
> > > +-----+----------+------------+--------+-------+--------+
> > > | FPS |    18.25 |      28.66 |   +57% | 24.06 |   +32% |
> > > +-----+----------+------------+--------+-------+--------+
> > > 
> > > Roblox Frames/mAh
> > > Higher is better
> > > +------------+----------+------------+--------+--------+--------+
> > > |            | Baseline |  Hypercall | %delta |   MMIO | %delta |
> > > +------------+----------+------------+--------+--------+--------+
> > > | Frames/mAh |    91.25 |     114.64 |   +26% | 103.11 |   +13% |
> > > +------------+----------+------------+--------+--------+--------+
> > 
> > </snip>
> > 
> > > Next steps:
> > > ===========
> > > We are continuing to look into communication mechanisms other than
> > > hypercalls that are just as/more efficient and avoid switching into the VMM
> > > userspace. Any inputs in this regard are greatly appreciated.
> > 
> > We're highly unlikely to entertain such an interface in KVM.
> > 
> > The entire feature is dependent on pinning vCPUs to physical cores, for which
> > userspace is in the driver's seat. That is a well established and documented
> > policy which can be seen in the way we handle heterogeneous systems and
> > vPMU.
> > 
> > Additionally, this bloats the KVM PV ABI with highly VMM-dependent interfaces
> > that I would not expect to benefit the typical user of KVM.
> > 
> > Based on the data above, it would appear that the userspace implementation is
> > in the same neighborhood as a KVM-based implementation, which only further
> > weakens the case for moving this into the kernel.
> > 
> > I certainly can appreciate the motivation for the series, but this feature
> > should be in userspace as some form of a virtual device.
> 
> +1 on all of the above.

And I concur with all the above as well. Putting this in the kernel is
not an obvious fit at all as that requires a number of assumptions about
the VMM.

As Oliver pointed out, the guest topology, and how it maps to the host
topology (vcpu pinning etc) is very much a VMM policy decision and will
be particularly important to handle guest frequency requests correctly.

In addition to that, the VMM's software architecture may have an impact.
Crosvm for example does device emulation in separate processes for
security reasons, so it is likely that adjusting the scheduling
parameters ('util_guest', uclamp, or else) only for the vCPU thread that
issues frequency requests will be sub-optimal for performance, we may
want to adjust those parameters for all the tasks that are on the
critical path.

And at an even higher level, assuming in the kernel a certain mapping of
vCPU threads to host threads feels kinda wrong, this too is a host
userspace policy decision I believe. Not that anybody in their right
mind would want to do this, but I _think_ it would technically be
feasible to serialize the execution of multiple vCPUs on the same host
thread, at which point the util_guest thingy becomes entirely bogus. (I
obviously don't want to conflate this use-case, it's just an example
that shows the proposed abstraction in the series is not a perfect fit
for the KVM userspace delegation model.)

So +1 from me to move this as a virtual device of some kind. And if the
extra cost of exiting all the way back to userspace is prohibitive (is
it btw?), then we can try to work on that. Maybe something a la vhost
can be done to optimize, I'll have a think.

> The one thing I'd like to understand that the comment seems to imply
> that there is a significant difference in overhead between a hypercall
> and an MMIO. In my experience, both are pretty similar in cost for a
> handling location (both in userspace or both in the kernel). MMIO
> handling is a tiny bit more expensive due to a guaranteed TLB miss
> followed by a walk of the in-kernel device ranges, but that's all. It
> should hardly register.
> 
> And if you really want some super-low latency, low overhead
> signalling, maybe an exception is the wrong tool for the job. Shared
> memory communication could be more appropriate.

I presume some kind of signalling mechanism will be necessary to
synchronously update host scheduling parameters in response to guest
frequency requests, but if the volume of data requires it then a shared
buffer + doorbell type of approach should do.

Thinking about it, using SCMI over virtio would implement exactly that.
Linux-as-a-guest already supports it IIRC, so possibly the problem
being addressed in this series could be 'simply' solved using an SCMI
backend in the VMM...

Thanks,
Quentin
