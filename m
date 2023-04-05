Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FE36D7647
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbjDEIGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbjDEIGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:06:36 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AF395;
        Wed,  5 Apr 2023 01:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X4PVQdadl6ZTLGeoTeEp0Dd4gWHDvdr8s3g3jGogpgM=; b=DKg+iwJwTae61N3oz8ZS/lSVqH
        kXviuaxC6aMQnQA5NKnoAYS+qajbWl5RIS05vx4JjXnA/1uY+a6/soU4CazZazeHQav2ueMfPrrCw
        EQUtTTogq4y06UUHDaVZhomah8Ld7DY4BLc4PlF02mk+6H6VMn5G2AarBSTEbEfXR7zxMLhc8ipKq
        fl5YJeELcKAFBG/bLUYgII+mWcmdo/VpMksm9FsNLpasKzi1IS7cA+k2ezf09uaGVGwNlxhm01sFE
        KDYfuKdYv5cDPGcxNWj9Txx2BEhobQP6E+J5LNv2LY9KNdhtAkeSaFEL95RFldfCXBGTcR+AwDIHi
        WB1uHuRg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pjy9S-009pS6-2w;
        Wed, 05 Apr 2023 08:05:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9A0B2300274;
        Wed,  5 Apr 2023 10:05:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6D9C5262312B5; Wed,  5 Apr 2023 10:05:48 +0200 (CEST)
Date:   Wed, 5 Apr 2023 10:05:48 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Dai <davidai@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
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
Message-ID: <20230405080548.GW4253@hirez.programming.kicks-ass.net>
References: <20230330224348.1006691-1-davidai@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330224348.1006691-1-davidai@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> Hi,
> 
> This patch series is a continuation of the talk Saravana gave at LPC 2022
> titled "CPUfreq/sched and VM guest workload problems" [1][2][3]. The gist
> of the talk is that workloads running in a guest VM get terrible task
> placement and DVFS behavior when compared to running the same workload in
> the host. Effectively, no EAS for threads inside VMs. This would make power
> and performance terrible just by running the workload in a VM even if we
> assume there is zero virtualization overhead.
> 
> We have been iterating over different options for communicating between
> guest and host, ways of applying the information coming from the
> guest/host, etc to figure out the best performance and power improvements
> we could get.
> 
> The patch series in its current state is NOT meant for landing in the
> upstream kernel. We are sending this patch series to share the current
> progress and data we have so far. The patch series is meant to be easy to
> cherry-pick and test on various devices to see what performance and power
> benefits this might give for others.
> 
> With this series, a workload running in a VM gets the same task placement
> and DVFS treatment as it would when running in the host.
> 
> As expected, we see significant performance improvement and better
> performance/power ratio. If anyone else wants to try this out for your VM
> workloads and report findings, that'd be very much appreciated.
> 
> The idea is to improve VM CPUfreq/sched behavior by:
> - Having guest kernel to do accurate load tracking by taking host CPU
>   arch/type and frequency into account.
> - Sharing vCPU run queue utilization information with the host so that the
>   host can do proper frequency scaling and task placement on the host side.

So, not having actually been send many of the patches I've no idea what
you've done... Please, eradicate this ridiculous idea of sending random
people a random subset of a patch series. Either send all of it or none,
this is a bloody nuisance.

Having said that; my biggest worry is that you're making scheduler
internals into an ABI. I would hate for this paravirt interface to tie
us down.
