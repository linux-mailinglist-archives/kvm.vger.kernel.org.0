Return-Path: <kvm+bounces-31274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB9E9C1FB5
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C85B71C211E5
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 14:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A561F4730;
	Fri,  8 Nov 2024 14:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rZh606o7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CFD1803A;
	Fri,  8 Nov 2024 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731077611; cv=none; b=jRcplzXzObUN9sMHzAFf6I1+STtiICq46rfn3mZjCLDfO/j7ag7v+2UrtASkDt07igXcPEcodHGMVK3d7L6WUXpv0CuVL6rboE6/N52Gsr8h0tIn+Qgh2fSrqP1BO+9miertVdBOzFfMhl+T/MadCAtKUx109Et13EINfnvhb3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731077611; c=relaxed/simple;
	bh=kZbPfuZ0ikYZXriOFOyM/wtjpbX2/SuwojvsPEaqSLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPcNgYSDeZg/EglCRPD406jjMej4FNk5RUDZIJN2rNoRCTw+bXUkF1Mo9Y/Batxxg0LgbRV7GLJhAipjFY71AgH8u4ac2l6ci+8xnUZlayq0Xl2Iqm992mkHRD/5xopsHj/rDvUdjq/ZhsdBGHTN2NRn6AVU684VFFB1PwUajTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rZh606o7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1CCC4CED5;
	Fri,  8 Nov 2024 14:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731077611;
	bh=kZbPfuZ0ikYZXriOFOyM/wtjpbX2/SuwojvsPEaqSLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rZh606o7uJMo6Rkf6Lz4RxQEyMr7vA756y0kFoEQhrTmohzr9Rp23gAVJj0gPMiLJ
	 fiXqcWwVsoZGUl2E1KYIZdbZGgQgoAxcy2j0yAULt+/HhwCWGPl7QQ10YIxm/N7GGE
	 7HwCs+UTOIW82PdunYNwSqmiCw/688dnKn1I9smPqqH4dK5e4pkg6bUKnLWUeFXz1D
	 jmlU9f6QgL0uLbtdWuN195GnRy/Q3rTRqlJHzsOyTbQUklcr9SF0nNwXgiyMyMbdaM
	 uXxVGrW0J8Um2aCgd+5douR6vdS7u6p21BHrCfHKPj2T6ojdtMqDWvKmv2J3OKSwTA
	 uQV4/Bd+cHtMA==
Date: Fri, 8 Nov 2024 14:53:22 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>, acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO
 via struct arm_smmu_hw_info
Message-ID: <20241108145320.GA17325@willie-the-truck>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241104114723.GA11511@willie-the-truck>
 <20241104124102.GX10193@nvidia.com>
 <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
 <20241106180531.GA520535@nvidia.com>
 <2a0e69e3-63ba-475b-a5a9-0863ad0f2bf8@arm.com>
 <20241107023506.GC520535@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107023506.GC520535@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi guys,

On Wed, Nov 06, 2024 at 10:35:06PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 06, 2024 at 09:05:26PM +0000, Robin Murphy wrote:
> > You should take "We discussed this already"
> > as more of a clue to yourself than to me - if 4 different people have all
> > said the exact same thing in so many words, perhaps there's something in
> > it...
> 
> And all seemed to agree it was not a big deal after the discussion.
> 
> I think Mostafa was driving in a direction that we break up the IDR
> into explicit fields and thus be explicit about what information the
> VMM is able to access. This would effectively document and enforce
> what the baseline is.

As one of the four people mentioned above, I figured I'd chime in with
my rationale for queuing this in case it's of any help or interest.

Initially, I was reasonably sure that we should be sanitising the ID
registers and being selective about what we advertise to userspace.
However, after Jason's reply to my comments, mulling it over in my head
and having lively conversations with Mostafa at lunchtime, I've come
full circle. Is it a great interface? Not at all. It's 8 register values
copied from the hardware to userspace. But is it good enough? I think it
is. It's also extremely simple (i.e. easy to explain what it does and
trivial to implement), which I think is a huge benefit given that the
IOMMUFD work around it is still evolving.

I'm firmly of the opinion that the VMM is going to need a tonne of help
from other sources to expose a virtual IOMMU successfully. For example,
anything relating to policy or configuration choices should be driven
from userspace rather than the kernel. If we start to expose policy in
the id registers for the cases where it happens to fit nicely, I fear
that this will backfire and the VMM will end up second-guessing the
kernel in cases where it decides it knows best. I'm not sold on the
analogy with CPU ID registers as (a) we don't have big/little idiocy to
deal with in the SMMU and (b) I don't think SMMU features always need
support code in the host, which is quite unlike many CPU features that
cannot be exposed safely without hypervisor context-switching support.

On top of all that, this interface can be extended if we change our
minds. If we decide we need to mask out fields, I think we could add
that after the fact. Hell, if we all decide that it's a disaster in a
few releases time, we can try something else. Ultimately, Jason is the
one maintaining IOMMUFD and he gets to deal with the problems if his
UAPI doesn't work out :)

So, given where we are in the cycle, I think the pragmatic thing to do
is to land this change now and enable the ongoing IOMMUFD work to
continue. We still have over two months to resolve any major problems
with the interface (and even unplug it entirely from the driver if we
really get stuck) but for now I think it's "fine".

Will

