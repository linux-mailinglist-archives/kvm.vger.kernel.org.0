Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250641295EE
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 13:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfLWMSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 07:18:17 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:34041 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726257AbfLWMSQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Dec 2019 07:18:16 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ijMf8-0003iS-Ut; Mon, 23 Dec 2019 13:18:14 +0100
To:     Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 15/18] perf: =?UTF-8?Q?arm=5Fspe=3A=20Handle=20gues?=  =?UTF-8?Q?t/host=20exclusion=20flags?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Dec 2019 12:18:14 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20191223121002.GB42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-16-andrew.murray@arm.com>
 <865zi8imr7.wl-maz@kernel.org>
 <20191223121002.GB42593@e119886-lin.cambridge.arm.com>
Message-ID: <0c806e4f5bb465f5b3fb54d167293706@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-12-23 12:10, Andrew Murray wrote:
> On Sun, Dec 22, 2019 at 12:10:52PM +0000, Marc Zyngier wrote:
>> On Fri, 20 Dec 2019 14:30:22 +0000,
>> Andrew Murray <andrew.murray@arm.com> wrote:
>> >
>> > A side effect of supporting the SPE in guests is that we prevent 
>> the
>> > host from collecting data whilst inside a guest thus creating a 
>> black-out
>> > window. This occurs because instead of emulating the SPE, we share 
>> it
>> > with our guests.
>> >
>> > Let's accurately describe our capabilities by using the perf 
>> exclude
>> > flags to prevent !exclude_guest and exclude_host flags from being 
>> used.
>> >
>> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>> > ---
>> >  drivers/perf/arm_spe_pmu.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/drivers/perf/arm_spe_pmu.c 
>> b/drivers/perf/arm_spe_pmu.c
>> > index 2d24af4cfcab..3703dbf459de 100644
>> > --- a/drivers/perf/arm_spe_pmu.c
>> > +++ b/drivers/perf/arm_spe_pmu.c
>> > @@ -679,6 +679,9 @@ static int arm_spe_pmu_event_init(struct 
>> perf_event *event)
>> >  	if (attr->exclude_idle)
>> >  		return -EOPNOTSUPP;
>> >
>> > +	if (!attr->exclude_guest || attr->exclude_host)
>> > +		return -EOPNOTSUPP;
>> > +
>>
>> I have the opposite approach. If the host decides to profile the
>> guest, why should that be denied? If there is a black hole, it 
>> should
>> take place in the guest. Today, the host does expect this to work, 
>> and
>> there is no way that we unconditionally allow it to regress.
>
> That seems reasonable.
>
> Upon entering the guest we'd have to detect if the host is using SPE, 
> and if
> so choose not to restore the guest registers. Instead we'd have to 
> trap them
> and let the guest read/write emulated values until the host has 
> finished with
> SPE - at which time we could restore the guest SPE registers to 
> hardware.
>
> Does that approach make sense?

Yes, this would be much better. All of this can be found out at 
vcpu_load()
time, and once you've moved most of the SPE sysreg handling there, it 
will
just follow the normal scheduling flow.

         M.
-- 
Jazz is not dead. It just smells funny...
