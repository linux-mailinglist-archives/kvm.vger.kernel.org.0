Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86B433243E
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 12:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCILkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 06:40:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhCILkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 06:40:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED6365256;
        Tue,  9 Mar 2021 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615290037;
        bh=Nzz2M6AplgH6sqJ1uLdq6POaRuNHG79f8esG/LsBO9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hwbDJ2WeE/PHt7yIerwSzElvCp50W3J8vS2zCZtNk15TNQvVP0ZDtJJnJ5oWXWhW2
         JtGfriFDyGa/xtB62mO3JJzb4xYt11oifKHWKIuDqKwhR5WQoIJJnjvi/P945aFGR6
         etxXfxuHYUMRiua/Uuo9n5C2fg1zrQXqGrirgx8us8DI6cPmWBOwsWTHFCaSssNyYK
         7DuRwnIOgLOgAfJ0JOJUhdK5/oJwpU2LuKC4mBNzrSlYDfpQEAR7tbLVWndIdFalol
         TtpVZPiSeF3YlgOD4TkAplAup7ifA/q/3VueGfo6vfBwawW9lXxSDlmFPTwh96QmGb
         1VTVO67ksG89g==
Date:   Tue, 9 Mar 2021 11:40:32 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Cap default IPA size to the host's own size
Message-ID: <20210309114031.GA28091@willie-the-truck>
References: <20210308174643.761100-1-maz@kernel.org>
 <20210309112658.GA28025@willie-the-truck>
 <87o8fsy2xx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8fsy2xx.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 11:35:54AM +0000, Marc Zyngier wrote:
> On Tue, 09 Mar 2021 11:26:59 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Mon, Mar 08, 2021 at 05:46:43PM +0000, Marc Zyngier wrote:
> > > KVM/arm64 has forever used a 40bit default IPA space, partially
> > > due to its 32bit heritage (where the only choice is 40bit).
> > > 
> > > However, there are implementations in the wild that have a *cough*
> > > much smaller *cough* IPA space, which leads to a misprogramming of
> > > VTCR_EL2, and a guest that is stuck on its first memory access
> > > if userspace dares to ask for the default IPA setting (which most
> > > VMMs do).
> > > 
> > > Instead, cap the default IPA size to what the host can actually
> > > do, and spit out a one-off message on the console. The boot warning
> > > is turned into a more meaningfull message, and the new behaviour
> > > is also documented.
> > > 
> > > Although this is a userspace ABI change, it doesn't really change
> > > much for userspace:
> > > 
> > > - the guest couldn't run before this change, while it now has
> > >   a chance to if the memory range fits the reduced IPA space
> > > 
> > > - a memory slot that was accepted because it did fit the default
> > >   IPA space but didn't fit the HW constraints is now properly
> > >   rejected
> > > 
> > > The other thing that's left doing is to convince userspace to
> > > actually use the IPA space setting instead of relying on the
> > > antiquated default.
> > 
> > Is there a way for userspace to discover the default IPA size, or does
> > it have to try setting values until it finds one that sticks?
> 
> Yes, since 233a7cb23531 ("kvm: arm64: Allow tuning the physical
> address size for VM").
> 
> The VMM can issue a KVM_CAP_ARM_VM_IPA_SIZE ioctl(), and get in return
> the maximum IPA size (I have a patch for kvmtool that does this).

Great, thanks -- that's exactly what I was thinking about when I asked the
question!

Will
