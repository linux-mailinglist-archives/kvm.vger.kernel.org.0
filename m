Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CF76D6D5B
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 21:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbjDDTny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 15:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbjDDTnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 15:43:52 -0400
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BA44697
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 12:43:50 -0700 (PDT)
Date:   Tue, 4 Apr 2023 19:43:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680637429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oo72y+C9GAk4TX3Xexbl8ChW3WJT6jJtrsPurmSXTHs=;
        b=NSRjnW/TZah/qkXgQrr9JHQ/FWR4wEvSnoja35+kwW5MrctQfwh4GlnwcLCiuPZkkCkcaA
        /HzuZo/X+5T0jWLdwJHz4UF+6eNEPzg2jYp6klJeWrNAZvA1GLPKsZQRKcVMDTY5FNTZga
        KodSImPt6+c6nNgwQaVEU6F24QCrwtY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     David Dai <davidai@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
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
Message-ID: <ZCx97IKjsBibjdGc@linux.dev>
References: <20230330224348.1006691-1-davidai@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330224348.1006691-1-davidai@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_PHOTO_EDITING_DIRECT autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Folks,

On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:

<snip>

> PCMark
> Higher is better
> +-------------------+----------+------------+--------+-------+--------+
> | Test Case (score) | Baseline |  Hypercall | %delta |  MMIO | %delta |
> +-------------------+----------+------------+--------+-------+--------+
> | Weighted Total    |     6136 |       7274 |   +19% |  6867 |   +12% |
> +-------------------+----------+------------+--------+-------+--------+
> | Web Browsing      |     5558 |       6273 |   +13% |  6035 |    +9% |
> +-------------------+----------+------------+--------+-------+--------+
> | Video Editing     |     4921 |       5221 |    +6% |  5167 |    +5% |
> +-------------------+----------+------------+--------+-------+--------+
> | Writing           |     6864 |       8825 |   +29% |  8529 |   +24% |
> +-------------------+----------+------------+--------+-------+--------+
> | Photo Editing     |     7983 |      11593 |   +45% | 10812 |   +35% |
> +-------------------+----------+------------+--------+-------+--------+
> | Data Manipulation |     5814 |       6081 |    +5% |  5327 |    -8% |
> +-------------------+----------+------------+--------+-------+--------+
> 
> PCMark Performance/mAh
> Higher is better
> +-----------+----------+-----------+--------+------+--------+
> |           | Baseline | Hypercall | %delta | MMIO | %delta |
> +-----------+----------+-----------+--------+------+--------+
> | Score/mAh |       79 |        88 |   +11% |   83 |    +7% |
> +-----------+----------+-----------+--------+------+--------+
> 
> Roblox
> Higher is better
> +-----+----------+------------+--------+-------+--------+
> |     | Baseline |  Hypercall | %delta |  MMIO | %delta |
> +-----+----------+------------+--------+-------+--------+
> | FPS |    18.25 |      28.66 |   +57% | 24.06 |   +32% |
> +-----+----------+------------+--------+-------+--------+
> 
> Roblox Frames/mAh
> Higher is better
> +------------+----------+------------+--------+--------+--------+
> |            | Baseline |  Hypercall | %delta |   MMIO | %delta |
> +------------+----------+------------+--------+--------+--------+
> | Frames/mAh |    91.25 |     114.64 |   +26% | 103.11 |   +13% |
> +------------+----------+------------+--------+--------+--------+

</snip>

> Next steps:
> ===========
> We are continuing to look into communication mechanisms other than
> hypercalls that are just as/more efficient and avoid switching into the VMM
> userspace. Any inputs in this regard are greatly appreciated.

We're highly unlikely to entertain such an interface in KVM.

The entire feature is dependent on pinning vCPUs to physical cores, for which
userspace is in the driver's seat. That is a well established and documented
policy which can be seen in the way we handle heterogeneous systems and
vPMU.

Additionally, this bloats the KVM PV ABI with highly VMM-dependent interfaces
that I would not expect to benefit the typical user of KVM.

Based on the data above, it would appear that the userspace implementation is
in the same neighborhood as a KVM-based implementation, which only further
weakens the case for moving this into the kernel.

I certainly can appreciate the motivation for the series, but this feature
should be in userspace as some form of a virtual device.

-- 
Thanks,
Oliver
