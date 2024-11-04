Return-Path: <kvm+bounces-30501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 728C69BB3CD
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 12:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A9B11C2187F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DF41B395E;
	Mon,  4 Nov 2024 11:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6Mb8pBY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07271B2199;
	Mon,  4 Nov 2024 11:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730720852; cv=none; b=GSBfKQjRIML4L9NnJ6LnSdzK230Srr2/ANN+5rB33dcns/lE4rx+5D65+B9qOiojfaCVdJHTXfkcqmZFrPNAUJdHSvGLcv7rU0+gqnkYYvM4qRZiOn6rY+r97CkSZ5a5ZQFZtD/YKYnBoE1OF7+Rtmut2H7HqKQZslXUNts6ggM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730720852; c=relaxed/simple;
	bh=YrBkBW416lpDyjoa3v17d3AWN56gLB1Iew1HdUSXMQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g/HQ46tfW24OBie4uXmxyHctin2X3jYfHkasedkLxo37VSgnMcbNpjrTPzrLFA3sdQryZSqDJ+HdJpF/zdf3y0gLrU5W2nAA3aXWlN+e/MaJ0HAByWPtJsmb0wYWv1r8lUa3MCtnBgXuuWeTn6pmM3WwEiUGn+JfMvtxjtBZkec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6Mb8pBY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE59FC4CECE;
	Mon,  4 Nov 2024 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730720852;
	bh=YrBkBW416lpDyjoa3v17d3AWN56gLB1Iew1HdUSXMQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J6Mb8pBYnu5iaGLA4V3tZYV5eSMnr/XQ2i98fhHzsNVHsgFRUPHP+4iy33vy7otHF
	 SYZm903IjYWYnRn/UsuLTl+EWAski+HVZbIzfthuTDK4GjPn1aRaMC0I85LTkJH/+W
	 rzNlNPEep5itEHFRU586JMeXTp71VoLdm+uvE0YBudRzch1/5/Zogu0W6m7FVSm+yX
	 1IOwOnvitenBXc7Szlsq0+q9775HnLPRaUAept+DZl3u0v5DCmEo664L6yTAnqqFc1
	 f8HXWCYTDWd65Eux6GdM6a+wSdXuEbf57AjXA2IfqFOMQeW8dyA43RH/HyIgJo+Zua
	 9Kk5tpB4z1OjQ==
Date: Mon, 4 Nov 2024 11:47:24 +0000
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
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO
 via struct arm_smmu_hw_info
Message-ID: <20241104114723.GA11511@willie-the-truck>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Oct 30, 2024 at 09:20:49PM -0300, Jason Gunthorpe wrote:
> From: Nicolin Chen <nicolinc@nvidia.com>
> 
> For virtualization cases the IDR/IIDR/AIDR values of the actual SMMU
> instance need to be available to the VMM so it can construct an
> appropriate vSMMUv3 that reflects the correct HW capabilities.
> 
> For userspace page tables these values are required to constrain the valid
> values within the CD table and the IOPTEs.
> 
> The kernel does not sanitize these values. If building a VMM then
> userspace is required to only forward bits into a VM that it knows it can
> implement. Some bits will also require a VMM to detect if appropriate
> kernel support is available such as for ATS and BTM.
> 
> Start a new file and kconfig for the advanced iommufd support. This lets
> it be compiled out for kernels that are not intended to support
> virtualization, and allows distros to leave it disabled until they are
> shipping a matching qemu too.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Reviewed-by: Donald Dutile <ddutile@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

--->8

> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index e266dfa6a38d9d..b227ac16333fe1 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -488,15 +488,50 @@ struct iommu_hw_info_vtd {
>  	__aligned_u64 ecap_reg;
>  };
>  
> +/**
> + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
> + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> + *
> + * @flags: Must be set to 0
> + * @__reserved: Must be 0
> + * @idr: Implemented features for ARM SMMU Non-secure programming interface
> + * @iidr: Information about the implementation and implementer of ARM SMMU,
> + *        and architecture version supported
> + * @aidr: ARM SMMU architecture version
> + *
> + * For the details of @idr, @iidr and @aidr, please refer to the chapters
> + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> + *
> + * User space should read the underlying ARM SMMUv3 hardware information for
> + * the list of supported features.
> + *
> + * Note that these values reflect the raw HW capability, without any insight if
> + * any required kernel driver support is present. Bits may be set indicating the
> + * HW has functionality that is lacking kernel software support, such as BTM. If
> + * a VMM is using this information to construct emulated copies of these
> + * registers it should only forward bits that it knows it can support.
> + *
> + * In future, presence of required kernel support will be indicated in flags.

What about the case where we _know_ that some functionality is broken in
the hardware? For example, we nobble BTM support on MMU 700 thanks to
erratum #2812531 yet we'll still cheerfully advertise it in IDR0 here.
Similarly, HTTU can be overridden by IORT, so should we update the view
that we advertise for that as well?

Will

