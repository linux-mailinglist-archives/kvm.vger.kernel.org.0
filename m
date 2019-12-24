Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DBF12A179
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 13:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfLXM4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 07:56:54 -0500
Received: from foss.arm.com ([217.140.110.172]:51938 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfLXM4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 07:56:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC4991FB;
        Tue, 24 Dec 2019 04:56:53 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 446093F534;
        Tue, 24 Dec 2019 04:56:53 -0800 (PST)
Date:   Tue, 24 Dec 2019 12:56:51 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        will@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 00/18] arm64: KVM: add SPE profiling support
Message-ID: <20191224125651.GM42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <f023f5529361cc1e2d799daa70f196c2@www.loen.fr>
 <864kxsim8d.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864kxsim8d.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 22, 2019 at 12:22:10PM +0000, Marc Zyngier wrote:
> On Sat, 21 Dec 2019 10:48:16 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > [fixing email addresses]
> > 
> > Hi Andrew,
> > 
> > On 2019-12-20 14:30, Andrew Murray wrote:
> > > This series implements support for allowing KVM guests to use the Arm
> > > Statistical Profiling Extension (SPE).
> > 
> > Thanks for this. In future, please Cc me and Will on email addresses
> > we can actually read.
> > 
> > > It has been tested on a model to ensure that both host and guest can
> > > simultaneously use SPE with valid data. E.g.
> > > 
> > > $ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
> > >         dd if=/dev/zero of=/dev/null count=1000
> > > $ perf report --dump-raw-trace > spe_buf.txt
> > > 
> > > As we save and restore the SPE context, the guest can access the SPE
> > > registers directly, thus in this version of the series we remove the
> > > trapping and emulation.
> > > 
> > > In the previous series of this support, when KVM SPE isn't
> > > supported (e.g. via CONFIG_KVM_ARM_SPE) we were able to return a
> > > value of 0 to all reads of the SPE registers - as we can no longer
> > > do this there isn't a mechanism to prevent the guest from using
> > > SPE - thus I'm keen for feedback on the best way of resolving
> > > this.
> > 
> > Surely there is a way to conditionally trap SPE registers, right? You
> > should still be able to do this if SPE is not configured for a given
> > guest (as we do for other feature such as PtrAuth).
> > 
> > > It appears necessary to pin the entire guest memory in order to
> > > provide guest SPE access - otherwise it is possible for the guest
> > > to receive Stage-2 faults.
> > 
> > Really? How can the guest receive a stage-2 fault? This doesn't fit
> > what I understand of the ARMv8 exception model. Or do you mean a SPE
> > interrupt describing a S2 fault?

Yes the latter.


> > 
> > And this is not just pinning the memory either. You have to ensure that
> > all S2 page tables are created ahead of SPE being able to DMA to guest
> > memory. This may have some impacts on the THP code...
> > 
> > I'll have a look at the actual series ASAP (but that's not very soon).
> 
> I found some time to go through the series, and there is clearly a lot
> of work left to do:
> 
> - There so nothing here to handle memory pinning whatsoever. If it
>   works, it is only thanks to some side effect.
> 
> - The missing trapping is deeply worrying. Given that this is an
>   optional feature, you cannot just let the guest do whatever it wants
>   in an uncontrolled manner.

Yes I'll add this.


> 
> - The interrupt handling is busted. You mix concepts picked from both
>   the PMU and the timer code, while the SPE device doesn't behave like
>   any of these two (it is neither a fully emulated device, nor a
>   device that is exclusively owned by a guest at any given time).
> 
> I expect some level of discussion on the list including at least Will
> and myself before you respin this.

Thanks for the quick feedback.

Andrew Murray

> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
