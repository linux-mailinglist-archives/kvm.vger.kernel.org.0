Return-Path: <kvm+bounces-29753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A6AA9B1ABA
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 22:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DCFD1F21C69
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 20:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93221187850;
	Sat, 26 Oct 2024 20:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0EwPZa0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417C718E37D
	for <kvm@vger.kernel.org>; Sat, 26 Oct 2024 20:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729974368; cv=none; b=gt1tFtk5eP0c5rtAqADaL171wH0Xmz1rNeURt5Sy9eugE+EgySw5u8jtv0e2TlZ15k/G+p9uo4X8dGJn56JqvFmSlYJn9i+QdTSjCBr8NCcSReM0Ztzv7754b2TZobHLG6N0h/u4zStSbzQ/3PVcF9P8ny3Q+iJn6m9XxZTzku0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729974368; c=relaxed/simple;
	bh=tUAUvQ737sodN9yK5aQGONrT7W7Or4tB2oyzGkwlZQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPJ13yFzWV35643fLd+TYptxS469eQOwYFLh7zxpTDjbg5/ucgjUoaNjHZmehpfqNpftlQOJ4/rvHSXaSFlP5FUyquECVjzxJrcLuzfNhzWq5mXyHGMa0u/+FcCXvdAid2rK1F77y31YUPy8DMkRL9OeoWC25+oc765VdZgZ1Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0EwPZa0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729974365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ILgF2ANT9OZDmDrUe3BvutpFI6Z0i+T3Y7sxTWoDZw=;
	b=W0EwPZa0PllVW4W0lMoRw4uGuPynigAo4CW8mf1jEafXGaj4L559N2UPyzCSCaWtmfC4Db
	d/WtXIWckZIqh22w3RMJu5cBwi3hLwEGpqd+lCTjodDoPjbwc3oCTZlyLBchTcmYYRBPzT
	7oIdCKlWgunPNALnHJAiV5x84/AM5V8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-dHZdroCwM-G5jBzqAix_xA-1; Sat, 26 Oct 2024 16:26:03 -0400
X-MC-Unique: dHZdroCwM-G5jBzqAix_xA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-71e4ece7221so3094464b3a.0
        for <kvm@vger.kernel.org>; Sat, 26 Oct 2024 13:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729974363; x=1730579163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ILgF2ANT9OZDmDrUe3BvutpFI6Z0i+T3Y7sxTWoDZw=;
        b=AhC7XWUZ/3/MyjB94XSzVDpZqk6LFFygFFlRlnjJYuoRep90EG9Py4Gff5JRHotGWL
         6YcjsAjnGmdjnJSg+m0QbMwhcFNTI0jKq/NFZJNJ2ER6dC3DqWTThGOYiBCNhdclgkM6
         J1YzD2HhzEvEimtPuAFnHwspdEhg8qUtAF1us+ZsMEr5V5YjccevfZBJ7GjqTeAwH53w
         758JfjsHLRoxCz71NkWf8gvVW99X4Ig7+kmcP1vz7Svl4pyqT4rlnrv02+NJsp34sPZg
         RyKKZpPg05jO5cTIFQXYrLI9KXETBzeAzFJ3c1BpmKcw/r+RE+GF1cimj/035qodqe/M
         4utw==
X-Forwarded-Encrypted: i=1; AJvYcCW7gDfcDeXc3oNRJeEndNhrrN6W/AsnAvc6woZ4DwaOoUsh5CNOlC2syn6dDbNZQsNoh0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyENotWW/hlRflcQFHO6xwYvGLX5s2knQ36CQvYkxA95cbWrvWu
	M+RCqSSlImkwr5rvn5xUVjny3ZQvLtsKn2fxvgfUDTFqhztJqC1y19YWg83dP+cf7CTeuIJ4wsW
	vaYr1U7fsLMeHQh41d+nvbOmghJH8dsYBDrV/QiSTSzgWomooNA==
X-Received: by 2002:a05:6a21:394b:b0:1d9:3acf:8bdd with SMTP id adf61e73a8af0-1d9a767bdfamr5925529637.22.1729974362654;
        Sat, 26 Oct 2024 13:26:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwP/m05oeFk9b8sbVzI0tK+++7zBHiaxMX3MviGhXhL+kZBBndL9iS5Tpoq327xlI5FsMfmw==
X-Received: by 2002:a05:6a21:394b:b0:1d9:3acf:8bdd with SMTP id adf61e73a8af0-1d9a767bdfamr5925511637.22.1729974362246;
        Sat, 26 Oct 2024 13:26:02 -0700 (PDT)
Received: from localhost (ip98-179-76-110.ph.ph.cox.net. [98.179.76.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7205791dda2sm3081517b3a.42.2024.10.26.13.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 13:26:01 -0700 (PDT)
Date: Sat, 26 Oct 2024 13:26:00 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>, 
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, Len Brown <lenb@kernel.org>, 
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 0/9] Initial support for SMMUv3 nested translation
Message-ID: <7uv6kandebgqyw64im2kfwmiqahsikpsb6yp2tkd6qol3li3r3@fxsra3soryma>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>

On Wed, Oct 09, 2024 at 01:23:06PM -0300, Jason Gunthorpe wrote:
> This brings support for the IOMMFD ioctls:
> 
>  - IOMMU_GET_HW_INFO
>  - IOMMU_HWPT_ALLOC_NEST_PARENT
>  - IOMMU_DOMAIN_NESTED
>  - ops->enforce_cache_coherency()
> 
> This is quite straightforward as the nested STE can just be built in the
> special NESTED domain op and fed through the generic update machinery.
> 
> The design allows the user provided STE fragment to control several
> aspects of the translation, including putting the STE into a "virtual
> bypass" or a aborting state. This duplicates functionality available by
> other means, but it allows trivially preserving the VMID in the STE as we
> eventually move towards the vIOMMU owning the VMID.
> 
> Nesting support requires the system to either support S2FWB or the
> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> cache and view incoherent data, currently VFIO lacks any cache flushing
> that would make this safe.
> 
> Yan has a series to add some of the needed infrastructure for VFIO cache
> flushing here:
> 
>  https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/
> 
> Which may someday allow relaxing this further.
> 
> Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
> this.
> 
> This is the first series in what will be several to complete nesting
> support. At least:
>  - IOMMU_RESV_SW_MSI related fixups
>     https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
>  - vIOMMU object support to allow ATS and CD invalidations
>     https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
>  - vCMDQ hypervisor support for direct invalidation queue assignment
>     https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
>  - KVM pinned VMID using vIOMMU for vBTM
>     https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
>  - Cross instance S2 sharing
>  - Virtual Machine Structure using vIOMMU (for vMPAM?)
>  - Fault forwarding support through IOMMUFD's fault fd for vSVA
> 
> The vIOMMU series is essential to allow the invalidations to be processed
> for the CD as well.
> 
> It is enough to allow qemu work to progress.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> 
> v3:
>  - Rebase on v6.12-rc2
>  - Revise commit messages
>  - Consolidate CANWB checks into arm_smmu_master_canwbs()
>  - Add CONFIG_ARM_SMMU_V3_IOMMUFD to compile out iommufd only features
>    like nesting
>  - Shift code into arm-smmu-v3-iommufd.c
>  - Add missed IS_ERR check
>  - Add S2FWB to arm_smmu_get_ste_used()
>  - Fixup quirks checks
>  - Drop ARM_SMMU_FEAT_COHERENCY checks for S2FWB
>  - Limit S2FWB to S2 Nesting Parent domains "just in case"
> v2: https://patch.msgid.link/r/0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com
>  - Revise commit messages
>  - Guard S2FWB support with ARM_SMMU_FEAT_COHERENCY, since it doesn't make
>    sense to use S2FWB to enforce coherency on inherently non-coherent hardware.
>  - Add missing IO_PGTABLE_QUIRK_ARM_S2FWB validation
>  - Include formal ACPIA commit for IORT built using
>    generate/linux/gen-patch.sh
>  - Use FEAT_NESTING to block creating a NESTING_PARENT
>  - Use an abort STE instead of non-valid if the user requests a non-valid
>    vSTE
>  - Consistently use 'nest_parent' for naming variables
>  - Use the right domain for arm_smmu_remove_master_domain() when it
>    removes the master
>  - Join bitfields together
>  - Drop arm_smmu_cache_invalidate_user patch, invalidation will
>    exclusively go via viommu
> v1: https://patch.msgid.link/r/0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com
> 
> Jason Gunthorpe (6):
>   vfio: Remove VFIO_TYPE1_NESTING_IOMMU
>   iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
>   iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
>   iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
>   iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
>   iommu/arm-smmu-v3: Use S2FWB for NESTED domains
> 
> Nicolin Chen (3):
>   ACPICA: IORT: Update for revision E.f
>   ACPI/IORT: Support CANWBS memory access flag
>   iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct
>     arm_smmu_hw_info
> 
>  drivers/acpi/arm64/iort.c                     |  13 ++
>  drivers/iommu/Kconfig                         |   9 +
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 204 ++++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 114 ++++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  83 ++++++-
>  drivers/iommu/arm/arm-smmu/arm-smmu.c         |  16 --
>  drivers/iommu/io-pgtable-arm.c                |  27 ++-
>  drivers/iommu/iommu.c                         |  10 -
>  drivers/iommu/iommufd/vfio_compat.c           |   7 +-
>  drivers/vfio/vfio_iommu_type1.c               |  12 +-
>  include/acpi/actbl2.h                         |   3 +-
>  include/linux/io-pgtable.h                    |   2 +
>  include/linux/iommu.h                         |   5 +-
>  include/uapi/linux/iommufd.h                  |  55 +++++
>  include/uapi/linux/vfio.h                     |   2 +-
>  16 files changed, 465 insertions(+), 98 deletions(-)
>  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> 
> 
> base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
> -- 
> 2.46.2
> 

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>


