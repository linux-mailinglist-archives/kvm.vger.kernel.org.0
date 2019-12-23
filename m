Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F89D1295DB
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 13:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLWMKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 07:10:05 -0500
Received: from foss.arm.com ([217.140.110.172]:44080 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfLWMKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 07:10:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C11BA1FB;
        Mon, 23 Dec 2019 04:10:04 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36A063F68F;
        Mon, 23 Dec 2019 04:10:04 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:10:02 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 15/18] perf: arm_spe: Handle guest/host exclusion flags
Message-ID: <20191223121002.GB42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-16-andrew.murray@arm.com>
 <865zi8imr7.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865zi8imr7.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 22, 2019 at 12:10:52PM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:22 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > A side effect of supporting the SPE in guests is that we prevent the
> > host from collecting data whilst inside a guest thus creating a black-out
> > window. This occurs because instead of emulating the SPE, we share it
> > with our guests.
> > 
> > Let's accurately describe our capabilities by using the perf exclude
> > flags to prevent !exclude_guest and exclude_host flags from being used.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  drivers/perf/arm_spe_pmu.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > index 2d24af4cfcab..3703dbf459de 100644
> > --- a/drivers/perf/arm_spe_pmu.c
> > +++ b/drivers/perf/arm_spe_pmu.c
> > @@ -679,6 +679,9 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
> >  	if (attr->exclude_idle)
> >  		return -EOPNOTSUPP;
> >  
> > +	if (!attr->exclude_guest || attr->exclude_host)
> > +		return -EOPNOTSUPP;
> > +
> 
> I have the opposite approach. If the host decides to profile the
> guest, why should that be denied? If there is a black hole, it should
> take place in the guest. Today, the host does expect this to work, and
> there is no way that we unconditionally allow it to regress.

That seems reasonable.

Upon entering the guest we'd have to detect if the host is using SPE, and if
so choose not to restore the guest registers. Instead we'd have to trap them
and let the guest read/write emulated values until the host has finished with
SPE - at which time we could restore the guest SPE registers to hardware.

Does that approach make sense?

Thanks,

Andrew Murray

> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
