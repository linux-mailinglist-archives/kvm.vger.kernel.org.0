Return-Path: <kvm+bounces-31275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 226C99C1FC2
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:56:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D6591C20FE8
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 14:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08C31F4701;
	Fri,  8 Nov 2024 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9hZFeNV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0494A1D0400;
	Fri,  8 Nov 2024 14:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731077783; cv=none; b=OX4BaZqt5kaoiJ7Pt1bq9SGPQZ1o0fGPzxYZK6Llu3H4NoTsRI3OZC4vJ0I8wKlXF/FWGEhRueZRTXZKspJcA/uyn7N959GCetHhvAOqt1SucIWBRFYcCkwIzR4escosbDrRjhPI4g1lEnfYDQocV4JPVr98KWNtzPM0V7/DXV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731077783; c=relaxed/simple;
	bh=6FAwEz1aNs6pjulAvH3wCg9nOjDsVb0l9FuLjHXGFtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFT8T8n/qxI2wegeuxpqGc8aE9s50Bgt7U5dDtHycLK/nX9ddxyBGASzP+xe0wvPdbWfE/1hY9bGVZkeaNL0fz9r5ps15yFYTqEgvC7L5kl1pNejPDqpR6eMG2NiFXi3j2tVR71aHeTYtFpjWr1WCPb04V3ECLScgHf1T1/Uxis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b9hZFeNV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CD3C4CECD;
	Fri,  8 Nov 2024 14:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731077782;
	bh=6FAwEz1aNs6pjulAvH3wCg9nOjDsVb0l9FuLjHXGFtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b9hZFeNVj8VpGUF0f27FLcnlwN8hRdEybVmw28VptgICFG1V13MnGp3yEMYfBMgLF
	 qX/rFwNSfcv6bGXMcrHN8aqlcZJLH8/ebuueRx4DuApb7umf0a73hsVDq9dTwb3u5+
	 6sLvOCk4DKWF4jlO7DvWI9Agl3/36SYxws1x7QNr/FKjeAnR21CHXWHKToEKVvIyTN
	 IDVZ+ob4t2u0QPax7OJ8MG5Wr8LNPlnwXdoAKe4KRH6mWxcge8Ftmj7JhkBp7kbI86
	 C6EM6SEYAebI18+wacEEL8/H9ag8KIaqO8kbE/S3KvBuIE/bSahpBE4+XVgADcl5FV
	 yBC9lwPvpCnwg==
Date: Fri, 8 Nov 2024 14:56:14 +0000
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
Message-ID: <20241108145611.GB17325@willie-the-truck>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241101121849.GD8518@willie-the-truck>
 <20241101132503.GU10193@nvidia.com>
 <20241105164829.GA12923@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105164829.GA12923@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 05, 2024 at 04:48:29PM +0000, Will Deacon wrote:
> On Fri, Nov 01, 2024 at 10:25:03AM -0300, Jason Gunthorpe wrote:
> > On Fri, Nov 01, 2024 at 12:18:50PM +0000, Will Deacon wrote:
> > > On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> > > > [This is now based on Nicolin's iommufd patches for vIOMMU and will need
> > > > to go through the iommufd tree, please ack]
> > > 
> > > Can't we separate out the SMMUv3 driver changes? They shouldn't depend on
> > > Nicolin's work afaict.
> > 
> > We can put everything before "iommu/arm-smmu-v3: Support
> > IOMMU_VIOMMU_ALLOC" directly on a rc and share a branch with your tree.
> > 
> > That patch and following all depend on Nicolin's work, as they rely on
> > the VIOMMU due to how different ARM is from Intel.
> > 
> > How about you take these patches:
> > 
> >  [PATCH v4 01/12] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
> >  [PATCH v4 02/12] ACPICA: IORT: Update for revision E.f
> >  [PATCH v4 03/12] ACPI/IORT: Support CANWBS memory access flag
> >  [PATCH v4 04/12] iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
> >  [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
> >  [PATCH v4 06/12] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
> >  [PATCH v4 07/12] iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
> > 
> > Onto a branch.
> 
> I've pushed these onto a new branch in the IOMMU tree:
> 
> 	iommufd/arm-smmuv3-nested
> 
> However, please can you give it a day or two to get some exposure in
> -next before you merge that into iommufd? I'll ping back here later in
> the week.

Not seen anything go bang in -next, so I think we can consider this
branch stable now.

Will

