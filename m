Return-Path: <kvm+bounces-24583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3159580CD
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 809201F24119
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 08:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE8018B46E;
	Tue, 20 Aug 2024 08:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cB1B0E0H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E364318B462
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 08:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142041; cv=none; b=ZIkgshrlDD+4m8ZBzjYZyUvg2xpG+yUASPDKNhQKRNk6uIbZedKrp3Khcn5tsAHzIq62A7aH3CK8BkNBDH5SDrAAC2hcM12BLxyj0pfp3H+K+lEvQ16bXmySSXBIHb6WV0lcWPL/QLD6wIQMDJ8B7sqRE5Qa9tg+/qcfmgolr4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142041; c=relaxed/simple;
	bh=U2fujsx9Rc4n0rHEX/kn6T7aFQIMaoi7z30UTc1xBT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWjaBg3qY6up1FzTC9QNPqu+7EbGbkaAdLcRVWDoTUdlJwO0lAL3zvIU7dgeMElW5lgDpY/Mze2pz5KcutIn2Z8dUDnx1MrZeYJLC0OIceDpyJlik1PevvVl4ATcBjoCrnnDQPZSzxtw3eMxB9xsIu3vBl1BptkeMZXpTQOHNdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cB1B0E0H; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-428e12f6e56so23755e9.0
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 01:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724142038; x=1724746838; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hSwrIo6MlWvOQ+mcUv6uS1wZ25LrFB1ewOcC/h8kM+Q=;
        b=cB1B0E0HDINAV4QlIST4084cMK23ljnRmK9UHqmEGmj4uq+TxG9rsyfm9UNvPxLXN/
         YqCDelr7SQa1UBWuHeHn3g1KEKcSwTSrkXmhH9umqOkWyYmY844AkoAKoxuc6e65Y3zN
         KxCK55OSX2BA9HthAe4GcIDpymCedtin+TxBjkW6JBUfY9OHXKXFSyRRb1fRBC7macTn
         m9KuviXsQZdXVQa2PFxsZ8viV5w9gV+HR9eibP/32tcy6CRNgeO6Ypkn+LbDME+6uMK8
         B/lAuRlT3OQi8/sNXBSFNTb+i7hbl6P3yGq7v+Gzm/wSktROI3dH4nTxaxYlvxtrGJK3
         CsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724142038; x=1724746838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSwrIo6MlWvOQ+mcUv6uS1wZ25LrFB1ewOcC/h8kM+Q=;
        b=Xihc/Qes9uybOAwAp2HZMoy9HYoDQaxXKgu/NsBkQX3/Jm5EoryVsS1Ox1EvcXhM6g
         wwlgHqOcLGjmmv63iATz8iYqmAC3L7/YHKSh9GIxTO+uCWPOH36wKDBi/e40IOxv2W53
         2l85xW1HBKZedtwJc/4Y95teOznn3dzFKbLbqseXJ5elsMfSXWrTmp7pnTElNQoFNey9
         6ZUrXGsMe6ftg8KBw9Lcjs0L/Kz7Nq7kGd45ev4LsLlRfOb2/M+kcz0A/x68hT65bl/8
         HWK5mVDg3vPHqVtSYQFBXu6GiRAaIFysxj5w8xAd7poNzFJ+FCcAWJUYRTzY/KPXodTF
         XaQw==
X-Forwarded-Encrypted: i=1; AJvYcCVEBUEyY3gQJUiXniT5nd4dSE1daGLWIWxHOzwBS//c8rA4IDIU3ymKGQCtwvY5vDhdybgnj66TWtF/WQmQitdcUlxM
X-Gm-Message-State: AOJu0YxyLq8tWsavuvGqFVLA2r+BMm1EkIOI/ghIEIE3yIRx6nlIXWaJ
	XqMjwJEMIXVyNlo+9ImCJHmZbYbWNlD2s6Ym80fzT2z9cWxp1VyuDAGDwOoUrQ==
X-Google-Smtp-Source: AGHT+IFkxwYbutMYvAck6HWY9AZnwzgvx67PU4bYEmqMtnbNvH7bwgVYyvbPkbuBgiiDj1GbnYCL7w==
X-Received: by 2002:a05:600c:a0e:b0:426:66a0:6df6 with SMTP id 5b1f17b1804b1-42ab5bee335mr461955e9.0.1724142037758;
        Tue, 20 Aug 2024 01:20:37 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ab87ef024sm10121515e9.1.2024.08.20.01.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 01:20:37 -0700 (PDT)
Date: Tue, 20 Aug 2024 08:20:32 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 0/8] Initial support for SMMUv3 nested translation
Message-ID: <ZsRR0MUHPz23zxu3@google.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Tue, Aug 06, 2024 at 08:41:13PM -0300, Jason Gunthorpe wrote:
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
> eventually move towards the VIOMMU owning the VMID.
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
>  - VIOMMU object support to allow ATS invalidations
>  - vCMDQ hypervisor support for direct invalidation queue assignment
>  - KVM pinned VMID using VIOMMU for vBTM
>  - Cross instance S2 sharing
>  - Virtual Machine Structure using VIOMMU (for vMPAM?)
>  - Fault forwarding support through IOMMUFD's fault fd for vSVA
> 
> It is enough to allow significant amounts of qemu work to progress.
> 
Are there any qemu patches to tests this?
As I am confused with some of the user space bits and that would help.

Thanks,
Mostafa

> This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> 
> Jason Gunthorpe (5):
>   vfio: Remove VFIO_TYPE1_NESTING_IOMMU
>   iommu/arm-smmu-v3: Use S2FWB when available
>   iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
>   iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
>   iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
> 
> Nicolin Chen (3):
>   ACPI/IORT: Support CANWBS memory access flag
>   iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct
>     arm_smmu_hw_info
>   iommu/arm-smmu-v3: Add arm_smmu_cache_invalidate_user
> 
>  drivers/acpi/arm64/iort.c                   |  13 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 398 ++++++++++++++++++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  27 ++
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |  16 -
>  drivers/iommu/io-pgtable-arm.c              |  24 +-
>  drivers/iommu/iommu.c                       |  10 -
>  drivers/iommu/iommufd/vfio_compat.c         |   7 +-
>  drivers/vfio/vfio_iommu_type1.c             |  12 +-
>  include/acpi/actbl2.h                       |   1 +
>  include/linux/io-pgtable.h                  |   2 +
>  include/linux/iommu.h                       |  54 ++-
>  include/uapi/linux/iommufd.h                |  79 ++++
>  include/uapi/linux/vfio.h                   |   2 +-
>  13 files changed, 572 insertions(+), 73 deletions(-)
> 
> 
> base-commit: e5e288d94186b266b062b3e44c82c285dfe68712
> -- 
> 2.46.0
> 

