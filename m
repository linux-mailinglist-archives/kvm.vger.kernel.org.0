Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441D3371606
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 15:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhECNgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 09:36:23 -0400
Received: from sibelius.xs4all.nl ([83.163.83.176]:53160 "EHLO
        sibelius.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhECNgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 09:36:22 -0400
Received: from localhost (bloch.sibelius.xs4all.nl [local])
        by bloch.sibelius.xs4all.nl (OpenSMTPD) with ESMTPA id 06eed435;
        Mon, 3 May 2021 15:35:25 +0200 (CEST)
Date:   Mon, 3 May 2021 15:35:25 +0200 (CEST)
From:   Mark Kettenis <mark.kettenis@xs4all.nl>
To:     Marc Zyngier <maz@kernel.org>
Cc:     vsethi@nvidia.com, sdonthineni@nvidia.com,
        alex.williamson@redhat.com, will@kernel.org,
        catalin.marinas@arm.com, christoffer.dall@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jsequeira@nvidia.com
In-Reply-To: <87bl9sunnw.wl-maz@kernel.org> (message from Marc Zyngier on Mon,
        03 May 2021 11:17:23 +0100)
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
References: <20210429162906.32742-1-sdonthineni@nvidia.com>
 <20210429162906.32742-2-sdonthineni@nvidia.com>
 <20210429122840.4f98f78e@redhat.com>
 <470360a7-0242-9ae5-816f-13608f957bf6@nvidia.com>
 <20210429134659.321a5c3c@redhat.com>
 <e3d7fda8-5263-211c-3686-f699765ab715@nvidia.com>
 <87czucngdc.wl-maz@kernel.org>
 <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com> <87bl9sunnw.wl-maz@kernel.org>
Message-ID: <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Date: Mon, 03 May 2021 11:17:23 +0100
> From: Marc Zyngier <maz@kernel.org>
> 
> Hi Vikram,
> 
> On Sun, 02 May 2021 18:56:31 +0100,
> Vikram Sethi <vsethi@nvidia.com> wrote:
> > 
> > Hi Marc, 
> > 
> > > From: Marc Zyngier <maz@kernel.org>
> > > Hi Vikram,
> > > 
> >  
> > > The problem I see is that we have VM and userspace being written in terms
> > > of Write-Combine, which is:
> > > 
> > > - loosely defined even on x86
> > > 
> > > - subject to interpretations in the way it maps to PCI
> > > 
> > > - has no direct equivalent in the ARMv8 collection of memory
> > >   attributes (and Normal_NC comes with speculation capabilities which
> > >   strikes me as extremely undesirable on arbitrary devices)
> > 
> > If speculation with Normal NC to prefetchable BARs in devices was a
> > problem, those devices would already be broken in baremetal with
> > ioremap_wc on arm64, and we would need quirks there to not do Normal
> > NC for them but Device GRE, and if such a quirk was needed on
> > baremetal, it could be picked up by vfio/KVM as well. But we haven't
> > seen any broken devices doing wc on baremetal on ARM64, have we?

I think the SC2A11 SoC used in the Socionext developerbox counts as
"broken":

https://www.96boards.org/documentation/enterprise/developerbox/support/known-issues.html

I'm not sure my understanding of the issue is 100% correct, but I
believe the firmware workaround described there uses the stage 2
translation tables to map "Normal NC" onto "Device nGRE" or something
even more restricted.  Now this hardware may be classified as simply
broken.  However...

On hardware based on the NXP LX2160A SoC we're seeing some weird
behaviour when using "Normal NC" mappings with an AMD GPU that
disappear by using "Device nGnRnE" mappings on OpenBSD.  No such issue
was observed with hardware based on an Ampere eMAG SoC.  I don't fully
understand this issue yet, and it may very well be a bug in OpenBSD
code, but it does show there are potential pitfalls with using "Normal
NC" for mapping prefetchable BARs of PCIe devices.

> The lack of evidence does not equate to a proof, and your devices not
> misbehaving doesn't mean it is the right thing, specially when we have
> such a wide range of CPU and interconnect implementation. Which is why
> I really want an answer at the architecture level. Not a "it works for
> me" type of answer.
> 
> Furthermore, as I replied to Shanker in a separate email, what
> Linux/arm64 does is pretty much irrelevant. KVM/arm64 implements the
> ARMv8 architecture, and it is at that level that we need to solve the
> problem.
> 
> If, by enumerating the properties of Prefetchable, you can show that
> they are a strict superset of Normal_NC, I'm on board. I haven't seen
> such an enumeration so far.
> 
> > I know we have tested NICs write combining on arm64 in baremetal, as
> > well as GPU and NVMe CMB without issues.
> > 
> > Further, I don't see why speculation to non cacheble would be an
> > issue if prefetch without side effects is allowed by the device,
> > which is what a prefetchable BAR is.
> > If it is an issue for a device I would consider that a bug already needing a quirk in
> > Baremetal/host kernel already. 
> > From PCI spec " A prefetchable address range may have write side effects, 
> > but it may not have read side effects."
> 
> Right, so we have made a small step in the direction of mapping
> "prefetchable" onto "Normal_NC", thanks for that. What about all the
> other properties (unaligned accesses, ordering, gathering)?

On x86 WC:

1. Is not cached (but stores are buffered).

2. Allows unaligned access just like normal memory.

3. Allows speculative reads.

4. Has weaker ordering than normal memory; [lsm]fence instructions are
   needed to guarantee a particular ordering of writes with respect to
   other writes and reads.

5. Stores are buffered.  This buffer isn't snooped so it has to be
   flushed before changes are globally visible.  The [sm]fence
   instructions flush the store buffer.

6. The store buffer may combine multiple writes into a single write.

Now whether the fact the unaligned access is allowed is really part of
the semantics of WC mappings is debatable as x86 always allows
unaligned access, even for areas mapped with ioremap().

However, this is where userland comes in.  The userland graphics stack
does assume that graphics memory mapped throug a prefetchable PCIe BAR
allows unaligned access if the architecture allows unaligned access
for cacheable memory.  On arm64 this means that such memory needs to
be "Normal NC".  And since kernel drivers tend to map such memory
using ioremap_wc() that pretty much implies ioremap_wc() shoul use
"Normal NC" as well isn't it?

> > > How do we translate this into something consistent? I'd like to
> > > see an actual description of what we *really* expect from WC on
> > > prefetchable PCI regions, turn that into a documented definition
> > > agreed across architectures, and then we can look at
> > > implementing it with one memory type or another on arm64.
> > > 
> > > Because once we expose that memory type at S2 for KVM guests, it
> > > becomes ABI and there is no turning back. So I want to get it
> > > right once and for all.
> > > 
> > I agree that we need a precise definition for the Linux ioremap_wc
> > API wrt what drivers (kernel and userspace) can expect and whether
> > memset/memcpy is expected to work or not and whether aligned
> > accesses are a requirement.
> > To the extent ABI is set, I would think that the ABI is also already
> > set in the host kernel for arm64 WC = Normal NC, so why should that
> > not also be the ABI for same driver in VMs.
> 
> KVM is an implementation of the ARM architecture, and doesn't really
> care about what WC is. If we come to the conclusion that Normal_NC is
> the natural match for Prefetchable attributes, than we're good and we
> can have Normal_NC being set by userspace, or even VFIO. But I don't
> want to set it only because "it works when bare-metal Linux uses it".
> Remember KVM doesn't only run Linux as guests.
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
