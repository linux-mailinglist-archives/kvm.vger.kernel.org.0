Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9264537A581
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhEKLOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:14:32 -0400
Received: from foss.arm.com ([217.140.110.172]:45412 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhEKLOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 07:14:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A638169E;
        Tue, 11 May 2021 04:13:14 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.29.91])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E11043F719;
        Tue, 11 May 2021 04:13:06 -0700 (PDT)
Date:   Tue, 11 May 2021 12:13:03 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>, kernel-team@android.com
Subject: Re: [PATCH v3 3/9] KVM: arm64: vgic: Be tolerant to the lack of
 maintenance interrupt
Message-ID: <20210511111303.GE6152@C02TD0UTHF1T.local>
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-4-maz@kernel.org>
 <20210510161907.GD92897@C02TD0UTHF1T.local>
 <87sg2uo54e.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sg2uo54e.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 06:44:49PM +0100, Marc Zyngier wrote:
> On Mon, 10 May 2021 17:19:07 +0100,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > On Mon, May 10, 2021 at 02:48:18PM +0100, Marc Zyngier wrote:
> > > As it turns out, not all the interrupt controllers are able to
> > > expose a vGIC maintenance interrupt as a distrete signal.
> > > And to be fair, it doesn't really matter as all we require is
> > > for *something* to kick us out of guest mode out way or another.
> > > 
> > > On systems that do not expose a maintenance interrupt as such,
> > > there are two outcomes:
> > > 
> > > - either the virtual CPUIF does generate an interrupt, and
> > >   by the time we are back to the host the interrupt will have long
> > >   been disabled (as we set ICH_HCR_EL2.EN to 0 on exit). In this case,
> > >   interrupt latency is as good as it gets.
> > > 
> > > - or some other event (physical timer) will take us out of the guest
> > >   anyway, and the only drawback is a bad interrupt latency.
> > 
> > IIRC we won't have a a guaranteed schedular tick for NO_HZ_FULL, so in
> > that case we'll either need to set a period software maintenance
> > interrupt, or reject this combination at runtime (either when trying to
> > isolate the dynticks CPUs, or when trying to create a VM).
> 
> That's a good point.
> 
> On sensible systems, the maintenance interrupt is a standard GIC PPI
> that requires enabling, and that is all that KVM requires (the
> maintenance interrupt is only used as an exit mechanism and will be
> disabled before reaching the handler).
> 
> On the M1, owing to the lack of a per-CPU interrupt controller, there
> is nothing to enable. The virtual CPU interface will fire at will and
> take us out of the guest in a timely manner.

Ah, so the M1 does have a maintenance interrupt, but you can't silence
it at the irqchip level.

> So maybe instead of relaxing the requirement for a maintenance
> interrupt, we should only bypass the checks if the root interrupt
> controller advertises that it is safe to do so, making it a
> M1-specific hack.

That certainly sounds safer than permitting running without any
maintenance interrupt at all.

Thanks,
Mark.
