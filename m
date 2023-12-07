Return-Path: <kvm+bounces-3836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 01C2C808543
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 11:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69646B21E2D
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD21B36B07;
	Thu,  7 Dec 2023 10:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhHuuJeq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA851947A;
	Thu,  7 Dec 2023 10:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0C4C433C8;
	Thu,  7 Dec 2023 10:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701944040;
	bh=imy4ugx4p592rTLtYsew6LM8Qw7swHAvvWpZOmSRbzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hhHuuJeqjenrJzluJ4waW5koAwpWLKrwzA15G7CY8Utv6hjNfvFBFFodpJSyTaKaF
	 7EN4QZkZ0wMz69gziLzI+1qWic/TNJhzwqb92SOYzocWHNq5gIwurKXze1emnQSkUu
	 5EaDIvOuY5Q9MPaZqjdoMnnNo9cbueXBY7gfxZidJC/YhLIrrDuLczNiynyULhIAXI
	 +Ntbu8iq1JUNgGpTswSapQAtiLCQP87puO1UsFeWiY02poI233eYyilYZXLK6DrKQE
	 vQEMmx2GQCZtFgFbx6pK6MBsP4SP7Y5Bg73JfNkZU6HgGJdvjt7ZSA9LYt+cuYd/lJ
	 E6mNvF9PiP9pg==
Date: Thu, 7 Dec 2023 11:13:52 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <ZXGa4A6rfxLtkTB2@lpieralisi>
References: <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
 <ZXCJ3pVbKuHJ3LTz@arm.com>
 <20231206150556.GQ2692119@nvidia.com>
 <ZXCQrTbf6q0BIhSw@lpieralisi>
 <20231206153809.GS2692119@nvidia.com>
 <ZXCf_e-ACqrj6VrV@arm.com>
 <20231206164802.GT2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206164802.GT2692119@nvidia.com>

On Wed, Dec 06, 2023 at 12:48:02PM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 06, 2023 at 04:23:25PM +0000, Catalin Marinas wrote:
> > On Wed, Dec 06, 2023 at 11:38:09AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Dec 06, 2023 at 04:18:05PM +0100, Lorenzo Pieralisi wrote:
> > > > On Wed, Dec 06, 2023 at 11:05:56AM -0400, Jason Gunthorpe wrote:
> > > > > On Wed, Dec 06, 2023 at 02:49:02PM +0000, Catalin Marinas wrote:
> > > > > > BTW, on those Mellanox devices that require different attributes within
> > > > > > a BAR, do they have a problem with speculative reads causing
> > > > > > side-effects? 
> > > > > 
> > > > > Yes. We definitely have had that problem in the past on older
> > > > > devices. VFIO must map the BAR using pgprot_device/noncached() into
> > > > > the VMM, no other choice is functionally OK.
> > > > 
> > > > Were those BARs tagged as prefetchable or non-prefetchable ? I assume the
> > > > latter but please let me know if I am guessing wrong.
> > > 
> > > I don't know it was quite old HW. Probably.
> > > 
> > > Just because a BAR is not marked as prefetchable doesn't mean that the
> > > device can't use NORMAL_NC on subsets of it.
> > 
> > What about the other way around - would we have a prefetchable BAR that
> > has portions which are unprefetchable?
> 
> I would say possibly.
> 
> Prefetch is a dead concept in PCIe, it was obsoleted in PCI-X about 20
> years ago. No PCIe system has ever done prefetch.
> 
> There is a strong incentive to mark BAR's as prefetchable because it
> allows 64 bit addressing in configurations with bridges.

If by strong incentive you mean the "Additional guidance on the
Prefetchable Bit in Memory Space BARs" in the PCI express specifications,
I think it has been removed from the spec and the criteria that had to be
met to implement it were basically impossible to fulfill on ARM systems,
it did not make any sense in the first place.

I agree on your statement related to the prefetchable concept but I
believe that a prefetchable BAR containing regions that have
read side-effects is essentially a borked design unless at system level
speculative reads are prevented (as far as I understand the
implementation note this could only be an endpoint integrated in a
system where read speculation can't just happen (?)).

Long story short: a PCIe card/device that can be plugged on any PCIe
compliant system (x86, ARM or whatever) should not mark a
BAR region with memory read side-effects as prefetchable, either
that or I don't understand what the implementation note above
was all about.

AFAIK the prefetchable concept in PCIe is likely to be scrapped
altogether in the not too distant future.

Anyway, that was just for completeness (and to shed light
on the BAR prefetchable bit usage).

Lorenzo

