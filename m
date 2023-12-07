Return-Path: <kvm+bounces-3864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A28A4808B07
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2122BB209A5
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 14:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B58344368;
	Thu,  7 Dec 2023 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqx8dsk+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A134185B;
	Thu,  7 Dec 2023 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE229C433C7;
	Thu,  7 Dec 2023 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701960618;
	bh=ROv4DFKKEEpLSUSHwElpbfywORQ7vxKS7FhooWQWgrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bqx8dsk+Za2R5f1hFZYmCEE/Sr6KkS6eFsETYaOgAs8HGf8d4qq0Db067rEyGEyhs
	 oBhIWAEOUkPpkMYxba0uDwXDsBqalS3CV0N0bMyvX+9yLhvnmeqlbrj8HK7AK00xjU
	 J06J/tliIegHCiPwoyM/37M/haAxsZg5BfKgfpJkLku6PDZOcSIeVs2yMGerEpGy2D
	 Afyghp+yZNbYb1q/itNfMTs13tWtBoFyYOeVHYpWe34GFO4w+ChTNfpEHeDcqgf5mG
	 qCTiHuyaQbJEtAhT2mD0YT5DtG/hKn56Nt7WlSXRter5DFhQEhUE8sp5Svvkj81rcT
	 9vsdOFnxtKoDw==
Date: Thu, 7 Dec 2023 15:50:09 +0100
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
Message-ID: <ZXHbocMSiAtrFdyr@lpieralisi>
References: <ZW949Tl3VmQfPk0L@arm.com>
 <20231205194822.GL2692119@nvidia.com>
 <ZXCJ3pVbKuHJ3LTz@arm.com>
 <20231206150556.GQ2692119@nvidia.com>
 <ZXCQrTbf6q0BIhSw@lpieralisi>
 <20231206153809.GS2692119@nvidia.com>
 <ZXCf_e-ACqrj6VrV@arm.com>
 <20231206164802.GT2692119@nvidia.com>
 <ZXGa4A6rfxLtkTB2@lpieralisi>
 <20231207133825.GI2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207133825.GI2692119@nvidia.com>

On Thu, Dec 07, 2023 at 09:38:25AM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 07, 2023 at 11:13:52AM +0100, Lorenzo Pieralisi wrote:
> > > > What about the other way around - would we have a prefetchable BAR that
> > > > has portions which are unprefetchable?
> > > 
> > > I would say possibly.
> > > 
> > > Prefetch is a dead concept in PCIe, it was obsoleted in PCI-X about 20
> > > years ago. No PCIe system has ever done prefetch.
> > > 
> > > There is a strong incentive to mark BAR's as prefetchable because it
> > > allows 64 bit addressing in configurations with bridges.
> > 
> > If by strong incentive you mean the "Additional guidance on the
> > Prefetchable Bit in Memory Space BARs" in the PCI express specifications,
> > I think it has been removed from the spec and the criteria that had to be
> > met to implement it were basically impossible to fulfill on ARM systems,
> > it did not make any sense in the first place.
> 
> No, I mean many systems don't have room to accommodate large 32 bit
> BARs and the only real way to make stuff work is to have a 64 bit BAR
> by setting prefetchable.

That's what the implementation note I mentioned referred to ;)

> Given mis-marking a read-side-effect region as prefetchable has no
> actual consequence on PCI-E I would not be surprised to learn people
> have done this.

PCIe specs 6.1, 7.5.1.2.1 "Base Address Registers"

"A function is permitted to mark a range as prefetchable if there are
no side effects on reads..."

I don't think that an OS should use the prefetchable flag to infer
anything (even though we do at the moment -> sysfs mappings, I know that
the prefetchable concept is being scrapped from the PCI specs altogether
for a reason), I don't see though how we can say that's a SW bug at
present given what I quoted above.

I'd agree that it is best not to use that flag for new code we are adding
(because it will be deprecated soon).

Thanks,
Lorenzo

