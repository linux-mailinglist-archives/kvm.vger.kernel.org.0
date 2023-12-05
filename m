Return-Path: <kvm+bounces-3591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 773528059E5
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15D1AB2124A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 16:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E887B67E62;
	Tue,  5 Dec 2023 16:22:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2082963DFF;
	Tue,  5 Dec 2023 16:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9E8C433C7;
	Tue,  5 Dec 2023 16:22:35 +0000 (UTC)
Date: Tue, 5 Dec 2023 16:22:33 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, lpieralisi@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZW9OSe8Z9gAmM7My@arm.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205130517.GD2692119@nvidia.com>

On Tue, Dec 05, 2023 at 09:05:17AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 11:40:47AM +0000, Catalin Marinas wrote:
> > > - Will had unanswered questions in another part of the thread:
> > > 
> > >   https://lore.kernel.org/all/20231013092954.GB13524@willie-the-truck/
> > > 
> > >   Can someone please help concluding it?
> > 
> > Is this about reclaiming the device? I think we concluded that we can't
> > generalise this beyond PCIe, though not sure there was any formal
> > statement to that thread. The other point Will had was around stating
> > in the commit message why we only relax this to Normal NC. I haven't
> > checked the commit message yet, it needs careful reading ;).
> 
> Not quite, we said reclaiming is VFIO's problem and if VFIO can't
> reliably reclaim a device it shouldn't create it in the first place.
> 
> Again, I think alot of this is trying to take VFIO problems into KVM.
> 
> VFIO devices should not exist if they pose a harm to the system. If
> VFIO decided to create the devices anyhow (eg admin override or
> something) then it is not KVM's job to do any further enforcement.

Yeah, I made this argument in the past. But it's a fair question to ask
since the Arm world is different from x86. Just reusing an existing
driver in a different context may break its expectations. Does Normal NC
access complete by the time a TLBI (for Stage 2) and DSB (DVMsync) is
completed? It does reach some point of serialisation with subsequent
accesses to the same address but not sure how it is ordered with an
access to a different location like the config space used for reset.
Maybe it's not a problem at all or it is safe only for PCIe but it would
be good to get to the bottom of this.

Device-nGnRnE has some stronger rules around end-point completion and
that's what the vfio-pci uses. KVM, however, went for the slightly more
relaxed nGnRE variant which, at least per the Arm ARM, doesn't have
these guarantees.

> Remember, the feedback we got from the CPU architects was that even
> DEVICE_* will experience an uncontained failure if the device tiggers
> an error response in shipping ARM IP.
> 
> The reason PCIe is safe is because the PCI bridge does not generate
> errors in the first place!

That's an argument to restrict this feature to PCIe. It's really about
fewer arguments on the behaviour of other devices. Marc did raise
another issue with the GIC VCPU interface (does this even have a vma in
the host VMM?). That's a class of devices where the mapping is
context-switched, so the TLBI+DSB rules don't help.

> Thus, the way a platform device can actually be safe is if it too
> never generates errors in the first place! Obviously this approach
> works just as well with NORMAL_NC.
> 
> If a platform device does generate errors then we shouldn't expect
> containment at all, and the memory type has no bearing on the
> safety. The correct answer is to block these platform devices from
> VFIO/KVM/etc because they can trigger uncontained failures.

Assuming the error containment is sorted, there are two other issues
with other types of devices:

1. Ordering guarantees on reclaim or context switch

2. Unaligned accesses

On (2), I think PCIe is fairly clear on how the TLPs are generated, so I
wouldn't expect additional errors here. But I have no idea what AMBA/AXI
does here in general. Perhaps it's fine, I don't think we looked into it
as the focus was mostly on PCIe.

So, I think it would be easier to get this patch upstream if we limit
the change to PCIe devices for now. We may relax this further in the
future. Do you actually have a need for non-PCIe devices to support WC
in the guest or it's more about the complexity of the logic to detect
whether it's actually a PCIe BAR we are mapping into the guest? (I can
see some Arm GPU folk asking for this but those devices are not easily
virtualisable).

-- 
Catalin

