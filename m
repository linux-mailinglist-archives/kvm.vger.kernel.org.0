Return-Path: <kvm+bounces-26615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 946AC9762BC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE3FFB21191
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B3E18C921;
	Thu, 12 Sep 2024 07:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mDstQUWS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FFA18858F
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126376; cv=none; b=rKCTK01zxUIJ1FqRrGW3LtYa5qQgqRYN9cnKJqFs8FUldAujqxKLJn7/mXK6A5SCv9aTBxAEQ8sc3cILev/6pY8ZG/z7HutWR+TUIe9407Y+dYYQ3j+QgPNBu8rpUJNz+upMn6pabIql93rBuP+2TuRjpN6jAMtEoEhNm77PPxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126376; c=relaxed/simple;
	bh=FzBKh+AU40CN9oHzR3BSVFgBams1zQxhZ8kcZSCD9k0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILVUseFPbnDoYftcNqNw91ktTSs9X1zAsdDwD6qzkqCOA2Se1i9guDTzR2wuBMqAL75p86gp6TISg9Y2WuU2YKtMoj5EyJpBquCAblSQ2cD+8Bv5QkqUKBMfLy7rQhXvcBweESz+s6Xgxc3FmJtnquZ+p6U1dlmrn6MNVy6jrvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mDstQUWS; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5356ab89665so701404e87.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126373; x=1726731173; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mORgeThFItSKRVvwL2eU52STgrT61e2xyY47HCtu0j0=;
        b=mDstQUWSJRX8uSlNgce//qZYi6Hwex4k0yIuHiYiZruBEiYmJwgBWHlQThm+qf4Th0
         xJEclNObmybulIGEAi58NDZDBzsazgnmIBjXNwpPZgfp4/d/uHFUnXX+X5No7rmDHYVM
         bM4/twqLZRveYGWhK4eDq15mmJ6kDJxG29p4UNyTKj8qnA0fXGd62A2iElMXWdsVSanY
         Z2vcLikEg/Hn0f8WsJ8cfF7LZJQkVKhW6vsF6Evkzu8K9p56Hi0vYe4KDh24KtUH+rHD
         HnDiYDTYO0SDaxF6yFCls5CDbtbuo7s2sKLMl9A51CNvXNYHXMehPONPdOa2NE/0b0eY
         vyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126373; x=1726731173;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mORgeThFItSKRVvwL2eU52STgrT61e2xyY47HCtu0j0=;
        b=bvBU/sQ29eR3mg7S0RJUPI3Q2Rim9igV64HaFAGaPiq/PvMcpIsobAAzKGjKewoIYA
         rmR/KkNVsvsahLpZa0eRIySaPTL93SnhWG9hFy8BbgSoGjMngwcvTCdm6Bp0yXA84MRC
         IDLlFcsU2+1cPJhZW9ndd5tIK0TQT1/MvpFBoAZIP9vT71JZbTkyK4zrNhu9ODw45OQL
         SKrNU0voFgmTin42Tm7QuxmKkNmbMJYVHKtrmFSzkHS2tLBYsy/xljK/HMLOLLwIeoqB
         HoxTi5TCncdiVvlg3FDdwuqxsoSTMi5m8mo7YBbNVxhL3l9+CfE1PxqCOUhpIuJcMa/H
         MGng==
X-Forwarded-Encrypted: i=1; AJvYcCX/Rq+huYgRRwCYKWEvuENJVedJkzD0XqY16UJEaKjbMzB3tlPo4RXs1g5fVaArYMy/htI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSAjLy9s0CSjj6ifoRqREjflXDR0J8LjDfpP3ycdeDdqBI8Zfi
	kUFvzJeqd+wD/cIWKas4nG3BlVMEq3UgyAtjXMpofryoO+VrV1fbbPZP6inptQdiIRhevN3Umes
	wBMykwAXXLg3PJRMFCPaXHwu7fQpEQmpSigbp7T9Qq7RUVONBGCnCrY6Kf2WS9Q==
X-Google-Smtp-Source: AGHT+IE2qH+DDo5DbegofrZD/Jk3qp04GIJFuzg8g/g2YGLkO7heSfzNnSID+VNatE+0Yyh1SXo2NwGwNJsgxGu/4kI=
X-Received: by 2002:a05:6512:ac9:b0:535:d4e9:28bb with SMTP id
 2adb3069b0e04-53678feb448mr861902e87.46.1726126371795; Thu, 12 Sep 2024
 00:32:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia> <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
 <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
In-Reply-To: <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 12 Sep 2024 15:32:40 +0800
Message-ID: <CABQgh9H2+uTgsQxgLSuua7h0kxSwfYZE1=GM1TA4H30jNsM9OQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev, 
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Sept 2024 at 12:29, Baolu Lu <baolu.lu@linux.intel.com> wrote:
>
> On 9/12/24 11:42 AM, Zhangfei Gao wrote:
> > On Wed, 28 Aug 2024 at 05:32, Nicolin Chen<nicolinc@nvidia.com>  wrote:
> >> On Tue, Aug 27, 2024 at 12:51:30PM -0300, Jason Gunthorpe wrote:
> >>> This brings support for the IOMMFD ioctls:
> >>>
> >>>   - IOMMU_GET_HW_INFO
> >>>   - IOMMU_HWPT_ALLOC_NEST_PARENT
> >>>   - IOMMU_DOMAIN_NESTED
> >>>   - ops->enforce_cache_coherency()
> >>>
> >>> This is quite straightforward as the nested STE can just be built in the
> >>> special NESTED domain op and fed through the generic update machinery.
> >>>
> >>> The design allows the user provided STE fragment to control several
> >>> aspects of the translation, including putting the STE into a "virtual
> >>> bypass" or a aborting state. This duplicates functionality available by
> >>> other means, but it allows trivially preserving the VMID in the STE as we
> >>> eventually move towards the VIOMMU owning the VMID.
> >>>
> >>> Nesting support requires the system to either support S2FWB or the
> >>> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> >>> cache and view incoherent data, currently VFIO lacks any cache flushing
> >>> that would make this safe.
> >>>
> >>> Yan has a series to add some of the needed infrastructure for VFIO cache
> >>> flushing here:
> >>>
> >>>   https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/
> >>>
> >>> Which may someday allow relaxing this further.
> >>>
> >>> Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
> >>> this.
> >>>
> >>> This is the first series in what will be several to complete nesting
> >>> support. At least:
> >>>   - IOMMU_RESV_SW_MSI related fixups
> >>>      https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
> >>>   - VIOMMU object support to allow ATS and CD invalidations
> >>>      https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
> >>>   - vCMDQ hypervisor support for direct invalidation queue assignment
> >>>      https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
> >>>   - KVM pinned VMID using VIOMMU for vBTM
> >>>      https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
> >>>   - Cross instance S2 sharing
> >>>   - Virtual Machine Structure using VIOMMU (for vMPAM?)
> >>>   - Fault forwarding support through IOMMUFD's fault fd for vSVA
> >>>
> >>> The VIOMMU series is essential to allow the invalidations to be processed
> >>> for the CD as well.
> >>>
> >>> It is enough to allow qemu work to progress.
> >>>
> >>> This is on github:https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> >>>
> >>> v2:
> >> As mentioned above, the VIOMMU series would be required to test
> >> the entire nesting feature, which now has a v2 rebasing on this
> >> series. I tested it with a paring QEMU branch. Please refer to:
> >> https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com/
> >> Also, there is another new VIRQ series on top of the VIOMMU one
> >> and this nesting series. And I tested it too. Please refer to:
> >> https://lore.kernel.org/linux-iommu/cover.1724777091.git.nicolinc@nvidia.com/
> >>
> >> With that,
> >>
> >> Tested-by: Nicolin Chen<nicolinc@nvidia.com>
> >>
> > Have you tested the user page fault?
> >
> > I got an issue, when a user page fault happens,
> >   group->attach_handle = iommu_attach_handle_get(pasid)
> > return NULL.
> >
> > A bit confused here, only find IOMMU_NO_PASID is used when attaching
> >
> >   __fault_domain_replace_dev
> > ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> > &handle->handle);
> > curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> >
> > not find where the code attach user pasid with the attach_handle.
>
> Have you set iommu_ops::user_pasid_table for SMMUv3 driver?

Thanks Baolu, Nico

Yes, after arm_smmu_ops = {
+       .user_pasid_table       = 1,

find_fault_handler can go inside attach_handle =
iommu_attach_handle_get(IOMMU_NO_PASID);
qemu handler also gets called.

But hardware reports errors and needs reset, still in check.
[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0

Thanks

