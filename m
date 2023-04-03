Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02726D41C9
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 12:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjDCKTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 06:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjDCKTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 06:19:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAB3113D1;
        Mon,  3 Apr 2023 03:18:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 383F41FD68;
        Mon,  3 Apr 2023 10:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680517137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a4MoXhe1RG60yL55LAJJODjxOGik5d8SFY4UggIUu04=;
        b=f3reNnGyU64PHa5HNUCrDzAbyKc0nC6m7ILE6UJTMTjHxkElPrk4lgSIqv7oS3Q9xgY/Hg
        /VLrUeBAlu9b5NDr4LMcDfNld4Xb149VSq55RLcflhBtwMCJmuHvrN81AYVDRygS4QQW72
        FO40CbIW+81IA5MAmWtsjVsYWLwADM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680517137;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a4MoXhe1RG60yL55LAJJODjxOGik5d8SFY4UggIUu04=;
        b=0j++IB0zvsDolT331j6Xki/sJRKexThn9M0PtBAqAqWQMgBfj6f+XjhvIKrb32XwASwr06
        xT1cWwJyenOtBJCQ==
Received: from suse.de (unknown [10.163.43.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 077E02C161;
        Mon,  3 Apr 2023 10:18:51 +0000 (UTC)
Date:   Mon, 3 Apr 2023 11:18:49 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Dai <davidai@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
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
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
Message-ID: <20230403101849.z6wengqxkchvpf75@suse.de>
References: <20230330224348.1006691-1-davidai@google.com>
 <ZCYuLPlEFUnxPm4A@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <ZCYuLPlEFUnxPm4A@casper.infradead.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023 at 01:49:48AM +0100, Matthew Wilcox wrote:
> On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> > Hi,
> > 
> > This patch series is a continuation of the talk Saravana gave at LPC 2022
> > titled "CPUfreq/sched and VM guest workload problems" [1][2][3]. The gist
> > of the talk is that workloads running in a guest VM get terrible task
> > placement and DVFS behavior when compared to running the same workload in
> 
> DVFS?  Some new filesystem, perhaps?
> 

Dynamic Voltage and Frequency Scaling (DVFS) -- it's a well known term in
cpufreq/cpuidle/schedutil land.

> > the host. Effectively, no EAS for threads inside VMs. This would make power
> 
> EAS?
> 

Energy Aware Scheduling (EAS) is mostly a kernel/sched thing that has
an impact on cpufreq and my recollection is that it was discussed at
conferences long before kernel/sched had any EAS awareness. I don't have
the full series in my inbox and didn't dig further but patch 1 at least is
providing additional information to schedutil which impacts CPU frequency
selection on systems to varying degrees. The full impact would depend on
what cpufreq driver is in use and the specific hardware so even if the
series benefits one set of hardware, it's not necessarily a guaranteed win.

> Two unfamiliar and undefined acronyms in your opening paragraph.
> You're not making me want to read the rest of your opus.

It depends on the audience and mm/ is not the audience.  VM in the title
refers to Virtual Machine, not Virtual Memory although I confess I originally
read it as mm/ and wondered initially how mm/ affects DVFS to the extent it
triggered a "wtf happened in mm/ recently that I completely missed?". This
series is mostly of concern to scheduler, cpufreq or KVM depending on your
perspective. For example, on KVM, I'd immediately wonder if the hypercall
overhead exceeds any benefit from better task placement although the leader
suggests the answer is "no".  However, it didn't comment (or I didn't read
carefully enough) on whether MMIO overhead or alternative communication
methods have constant cost across different hardware or, much more likely,
depend on the hardware that could potentially opt-in. Various cpufreq
hardware has very different costs when measuring or alterating CPU frequency
stuff, even within different generations of chips from the same vendor.
While the data also shows performance improvements, it doesn't indicate how
close to bare metal the improvement is. Even if it's 50% faster within a
VM, how much slower than bare metal is it? In terms of data presentation,
it might be better to assign bare metal a score of 1 at the best possible
score and show the VM performance as a relative ratio (1.00 for bare metal,
0.5 for VM with a vanilla kernel, 0.75 using improved task placement).
It would also be preferred to have x86-64 data as the hazards the series
details with impacts arm64 and x86-64 has the additional challenge that
cpufreq is often managed by the hardware so it should be demonstrated the
the series "does no harm" on x86-64 for recent generation Intel and AMD
chips if possible.  The lack of that data doesn't kill the series as a large
improvement is still very interesting even if it's not perfect and possible
specific to arm64. If this *was* my area or I happened to be paying close
attention to it at the time, I would likely favour using hypercalls only at
the start because it can be used universally and suggest adding alternative
communication methods later using the same metric "is an alternative method
of Guest<->Host communication worse, neutral or better at getting close to
bare metal performance?" I'd also push for the ratio tables as it's easier
to see at a glance how close to bare metal performance the series achieves.
Finally, I would look for x86-64 data just in case it causes harm due to
hypercall overhead on chips that management frequency in firmware.

So while I haven't read the series and only patches 2+6 reached by inbox,
I understand the point in principle. The scheduler on wakeup paths for bare
metal also tries to favour recently used CPUs and spurious CPU migration
even though it is only tangentially related to EAS.  For example, a recently
used CPUs may still be polling (drivers/cpuidle/poll_state.c:poll_idle)
or at least not entered a deep C-state so the wakeup penalty is lower.

So whatever critism the series deserves, it's not due to using obscure
terms that no one in kernel/sched/, drivers/cpuidle of drivers/cpufreq
would recognise.

-- 
Mel Gorman
SUSE Labs
