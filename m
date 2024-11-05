Return-Path: <kvm+bounces-30754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DBD9BD2C6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 17:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 011861F2331F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569F41DBB36;
	Tue,  5 Nov 2024 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rmtn0Fc+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FD91D516F;
	Tue,  5 Nov 2024 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730825318; cv=none; b=ERDNomZcxnjETe4XdItTbw78dAvZWd3Bq+bY7IPkF9A6sLP5tzmKp18po/agIhN4U6aCmVPMgK3xCKfuiVAsDCzl2CI9KRyerfzzUlMG4VspV+oRvR9QFoGGtPy1zlJxhSiuDTsI9YwE4m1U1cLR5uyWv0uJRFb1AwtIwH1yPgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730825318; c=relaxed/simple;
	bh=C6Hk6/eHmDS2AcJbkrwiislpkRQ+Eud/EQoVHtBaVi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jav1RawW/cg6gfohV/NDvzLMoSp9qrSLsp6i3a2VN14LaZouhcBIg/TXIsTI6qH8C6rO/qdQKT+ZltvLKDalLtXjQ8TAyPOWTwU2v9Z7ebRNA9AxVZahbM1Jl7emPZQfdJ0W5kB0OCyoVWP1nGFtujNad/hq4qpn4+8rXGhE0oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rmtn0Fc+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75888C4CECF;
	Tue,  5 Nov 2024 16:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730825318;
	bh=C6Hk6/eHmDS2AcJbkrwiislpkRQ+Eud/EQoVHtBaVi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rmtn0Fc+AfgQDPMBkouiMKC3eMbKISVCgolNAoUN/NA08NJsrDiDA9CHq+EyGxYSX
	 x2ht6NAKiLYE7I83LKoVjs7jg+WAKplOum+cjLQwPnx6QE9f02LK28NYh1DXSPoCIc
	 V2jJkCSywBTrXd5witeNe/+Mem8bo9sJiXuA6P+kvoMMIBSHTeozVamDGGbscZz8rq
	 PsqlL2kps4ABTYU7rNalIhA4+bFroEHsgrPpcKIHDt4XA+9J0K5MhGl6Jy0ZFq24yK
	 YPX0YKXKx4Bnece0a0viT+b8tEQ2HwOFXJfdcO2IFpDmtcJjlCjHkk1rJw7Zj2OCDK
	 qwTGI0NNtQgBw==
Date: Tue, 5 Nov 2024 16:48:29 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20241105164829.GA12923@willie-the-truck>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241101121849.GD8518@willie-the-truck>
 <20241101132503.GU10193@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241101132503.GU10193@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

On Fri, Nov 01, 2024 at 10:25:03AM -0300, Jason Gunthorpe wrote:
> On Fri, Nov 01, 2024 at 12:18:50PM +0000, Will Deacon wrote:
> > On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> > > [This is now based on Nicolin's iommufd patches for vIOMMU and will need
> > > to go through the iommufd tree, please ack]
> > 
> > Can't we separate out the SMMUv3 driver changes? They shouldn't depend on
> > Nicolin's work afaict.
> 
> We can put everything before "iommu/arm-smmu-v3: Support
> IOMMU_VIOMMU_ALLOC" directly on a rc and share a branch with your tree.
> 
> That patch and following all depend on Nicolin's work, as they rely on
> the VIOMMU due to how different ARM is from Intel.
> 
> How about you take these patches:
> 
>  [PATCH v4 01/12] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
>  [PATCH v4 02/12] ACPICA: IORT: Update for revision E.f
>  [PATCH v4 03/12] ACPI/IORT: Support CANWBS memory access flag
>  [PATCH v4 04/12] iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
>  [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
>  [PATCH v4 06/12] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
>  [PATCH v4 07/12] iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
> 
> Onto a branch.

I've pushed these onto a new branch in the IOMMU tree:

	iommufd/arm-smmuv3-nested

However, please can you give it a day or two to get some exposure in
-next before you merge that into iommufd? I'll ping back here later in
the week.

Cheers,

Will

