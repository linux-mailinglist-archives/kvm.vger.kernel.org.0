Return-Path: <kvm+bounces-29045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E409A1823
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 03:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1BF71C24DE3
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 01:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0945928E0F;
	Thu, 17 Oct 2024 01:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u4r7fRY9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA381C695
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729130019; cv=none; b=g3nJOKKR0f7yTVt1VorjZ5zAS6bQP56E7f6zotZ5QCPJ3XUlpGvmiAi/UAJfI8gSCtm7XIoEw8Lf7t2ET2dJWJlWu9mE0QkzPmNdckX97zOWOsQQbJKsBUujb2uuTPXQUd36kaHbsdj5qrYnDBRFeBzr0tsmseAd68P/rKhGqzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729130019; c=relaxed/simple;
	bh=T8K6e1vE2wCLDVf7N8pVhUM3BmOSL3JyhQ3sMTdPLa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WVN0zqDWbwbzlwC/+Hvm4X9NYRFAxAOUxSHCrFcgGk/Y3H9pKcv5Yx3ZhEakgRM/9j0x4aHRrrnOFrU3daKIIPxNT2J9mf+TYf6+/92nt3YucTnW9hFwpVOw7ljKi4qy5TZ1xbe02hN7j3DsCChPyMeRIuem68pDubmP5CdSfw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u4r7fRY9; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539fb49c64aso591486e87.0
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 18:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729130014; x=1729734814; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PLiuItL1UL/0YbxnoapkbJfbI3ajFc+JHUChCko5gAM=;
        b=u4r7fRY9ol+/OW/UNw8BI+3176Mb3ct4qTu4I4Ar2OaFHakwEE5vSGYQm6Oy0ZVjZF
         AQnTzeXmNO55QdxOP+PRN3QT4sCWp589YN6h+ngSG74AABZfZrA+Z79pDdx7QBZ7+HBm
         qpzZ1oFtgFgjngx6Fw+wU+p6R+yXmYUYnrFBp4zCk8aax3yr8NeA1k+X9yfnLwNPwBKI
         Xgt0D0z1WJ5v8jyKUDSW3LF+/if4BDzn60c++uhsmkt6mfTcQqfCTyZTgcrVY5iNF3An
         EvHRryFWeE6emCB7QKQyX30U6NmjPD9TbKtgXW3+TVfMqhcLbENlesX6p9HKVI9tCgxA
         +AjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729130014; x=1729734814;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PLiuItL1UL/0YbxnoapkbJfbI3ajFc+JHUChCko5gAM=;
        b=HV/lwLU1aZ2L4HDUtgqCjI5gypF3HGdVh6ppuVkBinrfHbKe7Sa0BKs8ppAIS5hw0H
         Q83j1YCBBk6gyL4aZQajOTzHsm5JM2lnQGvjLS+Eq/JTR7FQr+JS6jC+HKHPWhYA4A6L
         fEbsSisZ9de3ue+xRhisVpu3K7XOrE20nLmjNR2WUF47NlBjcIJXZcP8tbc3goqB1bQW
         rgu338uH8Y7Gi3cyjgohgiBpcKFvVFrAtAqJRl9sZ4jQbknxPORDOJ9mvX8vx6QdnnwD
         w3ou1ehk55w1Kn10a28pjwKyJmqaRMvBNY+drnwRw4MDEEYMLqgnmvv7rviOWSCuzPw/
         9WCw==
X-Forwarded-Encrypted: i=1; AJvYcCXceczaf37hllG/NdELn9poI6SED5lrgjtPAMCQa7U3+VHZ882whfR1oP5KcGYEQevLQ28=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6TaCvASPx/volkKJXe2UU6FI4QXlGxPkdopF3JANpSZGnfjlN
	cDtkAjYKiTGWUVxuW2gDbZU6FXV3+R9DH0+iIlx3sWJIWPmFTpuwK+/ySz9Dh2Zxzclr5H31wrJ
	QBS3CN+Of+aVLmA0QxAueL7Kx5bjZF6m/wGbtPQ==
X-Google-Smtp-Source: AGHT+IHmRyfMbHywLHUFamzust4bs2j0uBfSYysgkZSLZifh1MxXQEHcbM8EVQlN/EZKeVoV9osv3HRdY3nD8AfzzMA=
X-Received: by 2002:a05:6512:1252:b0:539:e0e6:cf42 with SMTP id
 2adb3069b0e04-539e571ce19mr12017134e87.43.1729130013488; Wed, 16 Oct 2024
 18:53:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia> <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
 <ee50c648-3fb5-4cb4-bc59-2283489be10e@linux.intel.com> <CABQgh9ESU51ReMa1JXRanPr4AugKM6gJDGDPz9=2TfQ3BaAUyw@mail.gmail.com>
 <20241015130936.GM3394334@nvidia.com>
In-Reply-To: <20241015130936.GM3394334@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 17 Oct 2024 09:53:22 +0800
Message-ID: <CABQgh9GF9vm=9Yv2AWe5wbN-mfr6Grn9=+c5zTgOvaMU+3bNSQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Nicolin Chen <nicolinc@nvidia.com>, 
	acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev, 
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

On Tue, 15 Oct 2024 at 21:09, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Oct 15, 2024 at 11:21:54AM +0800, Zhangfei Gao wrote:
> > On Thu, 12 Sept 2024 at 12:29, Baolu Lu <baolu.lu@linux.intel.com> wrote:
> >
> > > > Have you tested the user page fault?
> > > >
> > > > I got an issue, when a user page fault happens,
> > > >   group->attach_handle = iommu_attach_handle_get(pasid)
> > > > return NULL.
> > > >
> > > > A bit confused here, only find IOMMU_NO_PASID is used when attaching
> > > >
> > > >   __fault_domain_replace_dev
> > > > ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> > > > &handle->handle);
> > > > curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> > > >
> > > > not find where the code attach user pasid with the attach_handle.
> > >
> > > Have you set iommu_ops::user_pasid_table for SMMUv3 driver?
> >
> > Thanks Baolu
> >
> > Can we send a patch to make it as default?
> >
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -3570,6 +3570,7 @@ static struct iommu_ops arm_smmu_ops = {
> >         .viommu_alloc           = arm_vsmmu_alloc,
> >         .pgsize_bitmap          = -1UL, /* Restricted during device attach */
> >         .owner                  = THIS_MODULE,
> > +       .user_pasid_table       = 1,
>
> You shouldn't need this right now as smmu3 doesn't support nesting
> domains yet.

I am testing with  .user_pasid_table = 1 and IOMMU_NO_PASID
It works for user page faults.

>
>                         if (!ops->user_pasid_table)
>                                 return NULL;
>                         /*
>                          * The iommu driver for this device supports user-
>                          * managed PASID table. Therefore page faults for
>                          * any PASID should go through the NESTING domain
>                          * attached to the device RID.
>                          */
>                         attach_handle = iommu_attach_handle_get(
>                                         dev->iommu_group, IOMMU_NO_PASID,
>                                         IOMMU_DOMAIN_NESTED);
>                         if (IS_ERR(attach_handle))
>                         ^^^^^^^^^^^^^^^^^^^^^ Will always fail
>
>
> But I will add it to the patch that adds IOMMU_DOMAIN_NESTED

OK, cool.

Thanks

