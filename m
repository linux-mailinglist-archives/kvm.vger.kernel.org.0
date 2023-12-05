Return-Path: <kvm+bounces-3625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75577805E97
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2033B1F215D4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 19:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13E56D1DD;
	Tue,  5 Dec 2023 19:24:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F50F6D1A1;
	Tue,  5 Dec 2023 19:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B199C433C7;
	Tue,  5 Dec 2023 19:24:39 +0000 (UTC)
Date: Tue, 5 Dec 2023 19:24:37 +0000
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
Message-ID: <ZW949Tl3VmQfPk0L@arm.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205164318.GG2692119@nvidia.com>
X-TUID: nsHFPCYE/dW9

On Tue, Dec 05, 2023 at 12:43:18PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 04:22:33PM +0000, Catalin Marinas wrote:
> > Yeah, I made this argument in the past. But it's a fair question to ask
> > since the Arm world is different from x86. Just reusing an existing
> > driver in a different context may break its expectations. Does Normal NC
> > access complete by the time a TLBI (for Stage 2) and DSB (DVMsync) is
> > completed? It does reach some point of serialisation with subsequent
> > accesses to the same address but not sure how it is ordered with an
> > access to a different location like the config space used for reset.
> > Maybe it's not a problem at all or it is safe only for PCIe but it would
> > be good to get to the bottom of this.
> 
> IMHO, the answer is you can't know architecturally. The specific
> vfio-platform driver must do an analysis of it's specific SOC and
> determine what exactly is required to order the reset. The primary
> purpose of the vfio-platform drivers is to provide this reset!
> 
> In most cases I would expect some reads from the device to be required
> before the reset.

I can see in the vfio_platform_common.c code that the reset is either
handled by an ACPI _RST method or some custom function in case of DT.
Let's consider the ACPI method for now, I assume the AML code pokes some
device registers but we can't say much about the ordering it expects
without knowing the details. The AML may assume that the ioaddr mapped
as Device-nRnRE (ioremap()) in the kernel has the same attributes
wherever else is mapped in user or guests. Note that currently the
vfio_platform and vfio_pci drivers only allow pgprot_noncached() in
user, so they wouldn't worry about other mismatched aliases.

I think PCIe is slightly better documented but even here we'll have to
rely on the TLBI+DSB to clear any prior writes on different CPUs.

It can be argued that it's the responsibility of whoever grants device
access to know the details. However, it would help if we give some
guidance, any expectations broken if an alias is Normal-NC? It's easier
to start with PCIe first until we get some concrete request for other
types of devices.

> > So, I think it would be easier to get this patch upstream if we limit
> > the change to PCIe devices for now. We may relax this further in the
> > future. Do you actually have a need for non-PCIe devices to support WC
> > in the guest or it's more about the complexity of the logic to detect
> > whether it's actually a PCIe BAR we are mapping into the guest? (I can
> > see some Arm GPU folk asking for this but those devices are not easily
> > virtualisable).
> 
> The complexity is my concern, and the disruption to the ecosystem with
> some of the ideas given.
> 
> If there was a trivial way to convey in the VMA that it is safe then
> sure, no objection from me.

I suggested a new VM_* flag or some way to probe the iomem_resources for
PCIe ranges (if they are described in there, not sure). We can invent
other tree searching for ranges that get registers from the vfio driver,
I don't think it's that difficult.

Question is, do we need to do this for other types of devices or it's
mostly theoretical at this point (what's theoretical goes both ways
really).

A more complex way is to change vfio to allow Normal mappings and KVM
would mimic them. You were actually planning to do this for Cacheable
anyway.

> I would turn it around and ask we find a way to restrict platform
> devices when someone comes with a platform device that wants to use
> secure kvm and has a single well defined HW problem that is solved by
> this work.

We end up with similar search/validation mechanism, so not sure we gain
much.

> What if we change vfio-pci to use pgprot_device() like it already
> really should and say the pgprot_noncached() is enforced as
> DEVICE_nGnRnE and pgprot_device() may be DEVICE_nGnRE or NORMAL_NC?
> Would that be acceptable?

pgprot_device() needs to stay as Device, otherwise you'd get speculative
reads with potential side-effects.

-- 
Catalin

