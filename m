Return-Path: <kvm+bounces-26608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17406975FD4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 05:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE545285C79
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 03:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3E317966F;
	Thu, 12 Sep 2024 03:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dqM5/Sg/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9809637703
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 03:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726112578; cv=none; b=AWyoas7a7CuetUXwT4p9QmiLsQoqpZxZbUas/QnoEXO+WyQp4aPOH3P3WGxNkT8wxB5wVuN8ypcSwZCwng7JxkUTsg8AooHb+4VN+BN8fZedcZPJQKcYF5AMoskB5CPQ6mmIy23zTc0gogAfYy6n0En4mJX3VAqjvjL7q6PbTAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726112578; c=relaxed/simple;
	bh=t6JnvDXxrgwOrK5nBcux6FhvZ+GkBB34CxYyuKHR8Og=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cyXsyBL0w3ffsBcNnrwq+mSag+k7KaYFQO8k6J70dBCQdb2AdGrOp/tUTX9bq1BeOFDPo3pr8YTGDNu2CH6NqxD0jkQiNwCakI/BdC+21ZZZAqnnYrBn+au6A0XXBdnI2ZjDpw0iWthaLkeIrnMR8lQUnXOqRboGN11CX61weDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dqM5/Sg/; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53661a131b4so629731e87.1
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726112575; x=1726717375; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eSnD+feNmIpyGFy3ANq+mJH1L6h4C/913e1dH/900aI=;
        b=dqM5/Sg/c/O6v8xZSHRcreEMRMiaysMbWdCQwx6NA89cmkI4iyb3n9Uy+6XrIzR/u9
         WIo8fAVJaeyENz2cg8+wL2FCIu7Vx3VN39Zj0E3oNC6Dokav5Yc9nPI8X3Bvcs+8WBlW
         iQEx1aqvxl9Szh2hdeTK3NH1HLvj0RPkoP7n7ZiNhIVQtIpWBfYdn2Vn1H4EOBrjZYEc
         csvtWWoxojIOrnyDenGx4rd6ywQfhZ9HPZHiLtsNSYUM1teZ4x93rpYhuEdS5D+2e1u7
         WE8fkujqDGcaJnZSR5Vffbu3B9WJvAgDFfINvQePRutGJwdyY5DtQG/b4MF2iNGMrCxO
         M7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726112575; x=1726717375;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eSnD+feNmIpyGFy3ANq+mJH1L6h4C/913e1dH/900aI=;
        b=uIBhFpAwfJaG29rYUgXRjSGIAJQUjXwJAxxIL8WhnbJgkh4Ku+/wb49soPTrV3np1i
         8zPcaSHHbcP1YALrpiyi6udCxq6G+xsCIaaDi35kt/EeBRAwjU4LNAqXsAotsiTy7jIp
         fESKs+JllxmVIslQ732130wX8LRCKfesN8T6XmHhZ1XggHQQtE49C29SIrwXE9vhtGu0
         dM3KW3LwU0r75gYOo2UzPcXnDs2WL3iXko35us7unedrTb0ayA0NVV7HUFpk7jcrwYdW
         6rpE5QzhU4oDo4HBwJVuTdB7R6MqgI7etCCFHH0LFbmTGgI/FIdG7nIx+tPZoJW7u3cP
         uE0A==
X-Forwarded-Encrypted: i=1; AJvYcCVqahuPca/Nqsm1xJhKzXILmAtgnePAjmCA56I6556ZkZC/sdK36dSRTCSJC0oPmacq2RA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAeLo89FWfbyFVG0kMEGrEm391Gx0mQQyPInCF/PHdSjsgKFUA
	T21zv8yj+S8nrjPumjyiLspr66/Rt3N3oIkAs6N/C1oQSf9wXQw7SZ6xCdKL3MDvkRP8hJluL5m
	WjALhKBmxdBcX1iKXTGQP9ls6z3P72SI1KNl3aw==
X-Google-Smtp-Source: AGHT+IF/twF5W8Bc/XAVPwIWjGNxUotXfhHItAqIP12ejgLEJX//QlUL7Us8R8DK5swfOMnD63WUr2nXvsVv9uZStxM=
X-Received: by 2002:a05:6512:3d8b:b0:530:ae99:c7fa with SMTP id
 2adb3069b0e04-53678fa9f26mr723400e87.10.1726112574109; Wed, 11 Sep 2024
 20:42:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com> <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
In-Reply-To: <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 12 Sep 2024 11:42:43 +0800
Message-ID: <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev, 
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

Hi, Nico

On Wed, 28 Aug 2024 at 05:32, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> On Tue, Aug 27, 2024 at 12:51:30PM -0300, Jason Gunthorpe wrote:
> > This brings support for the IOMMFD ioctls:
> >
> >  - IOMMU_GET_HW_INFO
> >  - IOMMU_HWPT_ALLOC_NEST_PARENT
> >  - IOMMU_DOMAIN_NESTED
> >  - ops->enforce_cache_coherency()
> >
> > This is quite straightforward as the nested STE can just be built in the
> > special NESTED domain op and fed through the generic update machinery.
> >
> > The design allows the user provided STE fragment to control several
> > aspects of the translation, including putting the STE into a "virtual
> > bypass" or a aborting state. This duplicates functionality available by
> > other means, but it allows trivially preserving the VMID in the STE as we
> > eventually move towards the VIOMMU owning the VMID.
> >
> > Nesting support requires the system to either support S2FWB or the
> > stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> > cache and view incoherent data, currently VFIO lacks any cache flushing
> > that would make this safe.
> >
> > Yan has a series to add some of the needed infrastructure for VFIO cache
> > flushing here:
> >
> >  https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/
> >
> > Which may someday allow relaxing this further.
> >
> > Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
> > this.
> >
> > This is the first series in what will be several to complete nesting
> > support. At least:
> >  - IOMMU_RESV_SW_MSI related fixups
> >     https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
> >  - VIOMMU object support to allow ATS and CD invalidations
> >     https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
> >  - vCMDQ hypervisor support for direct invalidation queue assignment
> >     https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
> >  - KVM pinned VMID using VIOMMU for vBTM
> >     https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
> >  - Cross instance S2 sharing
> >  - Virtual Machine Structure using VIOMMU (for vMPAM?)
> >  - Fault forwarding support through IOMMUFD's fault fd for vSVA
> >
> > The VIOMMU series is essential to allow the invalidations to be processed
> > for the CD as well.
> >
> > It is enough to allow qemu work to progress.
> >
> > This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> >
> > v2:
>
> As mentioned above, the VIOMMU series would be required to test
> the entire nesting feature, which now has a v2 rebasing on this
> series. I tested it with a paring QEMU branch. Please refer to:
> https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com/
> Also, there is another new VIRQ series on top of the VIOMMU one
> and this nesting series. And I tested it too. Please refer to:
> https://lore.kernel.org/linux-iommu/cover.1724777091.git.nicolinc@nvidia.com/
>
> With that,
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
>
Have you tested the user page fault?

I got an issue, when a user page fault happens,
 group->attach_handle = iommu_attach_handle_get(pasid)
return NULL.

A bit confused here, only find IOMMU_NO_PASID is used when attaching

 __fault_domain_replace_dev
ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
&handle->handle);
curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);

not find where the code attach user pasid with the attach_handle.

Thanks

