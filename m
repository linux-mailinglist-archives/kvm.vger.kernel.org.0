Return-Path: <kvm+bounces-30848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F209BDE55
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 06:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3ED21F23F10
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 05:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15DD1917E8;
	Wed,  6 Nov 2024 05:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gkxY0evp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37113189902
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 05:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730871570; cv=none; b=bq48kr7OOgxVwNEenCb3VCyRvObrVnlYhgBWhqVnYaeKB2HerqGfP0GKDFHIsiTZ5wrzx9V8HVRGpP082ncU4ghHKiiD2nS7qJrItpVY5X4eEgxHYlk2iFNAXNV7IdFHbzs+cCpUbgQqxbhrkBsswjvQiM8AP3hGqNQeo/brb2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730871570; c=relaxed/simple;
	bh=3qBDiqpY9XDqbY2Y9odYYAPqOm9MdhCQLElgiaodrH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y2vIu+HtZYJq/rJuEmTsVgw1orJteAu6RXpVKAs44BcNBpxodlBXFEnkJ2u9Mak4SZ90NLcR/dlAwR2+tJPPNldlzAF3DtWL+9wnZdss/A6pnWIMEFHlI1T9CEgONtyYIe2hmYAgESbx9VNeSqfZF+IhaHLvOhs3ptnWNdZ1bmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gkxY0evp; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-539e4b7409fso540546e87.0
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 21:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730871565; x=1731476365; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AN4uQlg4JmmnskoZUbD9ajWs6/v+l9dkVw03I1zm8cw=;
        b=gkxY0evpc78lyNkTILVk409H9nFTRzkmUYLkkxqIXf9UU6lmHGyKrEFkeynN+XO6WG
         /Q9Tm8PR3aYI1fwbAtPXk2pus0+f4b8dgy22oH7m87l/yy3N6YUz4T1LB2DCfDi/L9CS
         pJWvrrXJIqtam7RlqNMhIyC2s53syrMYWv6k7/GOpKntprws5X7vLWHi+wIAHn0/NKED
         pjKlAOCNBMpENcEdrDYvuk5sObDjpoHESmLHh1HpQRgXBTE5Rs7EgdO03GvFzSqUFtJj
         IQRf0mFOQGC9v+vPWaepd/nBs8s+SrNibqV2+EAmcfGdth+kaLRJ6zxQ+eczbIeKwNe+
         pRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730871565; x=1731476365;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AN4uQlg4JmmnskoZUbD9ajWs6/v+l9dkVw03I1zm8cw=;
        b=Ebm04XYSRiO3CrcZI0+GQadjOTwO91TOo2yzF+vHJ/26ixwCUBk0jBkRXHABDE2qQs
         vrGE6ZuNUXjqyBbx4SLdKGpgAlKswLWq2MVn1qAxXQnSsHyZxIB3jnVmz/Sf3DDg6B09
         wDk8s3vjwH0ad1GzpKutuI1YxTeDx0X693PYgAyhum2JgtjbRBhYQ3pkFGzV9gZtS2rI
         hWiUk4VlNQf2jWqua+22H10+d9ar98HWrIIn2nqKEMX0dpLn9MhXPH1QD2vN9moDIZqM
         pryKC46Wsc1hqcbgexAKRTPutM0Ebyc61YEV3sC/Qw6YYmYdhutyvqHh0J5PuCjaTqSD
         SDbw==
X-Forwarded-Encrypted: i=1; AJvYcCWT/Ljpo2gbfM0xe6SQWwGYV+d3YG0LfPAcFGwoQPhsQh1r9qIfA7v6fFHP3YAIA4p4o4A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3JQ2BapMb8hp81dt60LTQffslIrYEeD/HeFwZY7H6sNONkD3a
	Gj8W+r5GPK5plHxCgxqO1lDVfEqWGf7dhfmTlk9R6AGRjcmDvfDmgrWpgLa3aA+DT3m8jmDte8/
	hGw4KkyhAAOBk6emxFjK1/6lJdnxoj5sNBACviw==
X-Google-Smtp-Source: AGHT+IHkFZmS15Yat+yA6wTIjddaBPNP6Qu4/1YXgkU7r7C/EE/mZc+JCaJP3gRrzyZ+p7mBuvSg1qn/MJDQimjHDOk=
X-Received: by 2002:a05:6512:4803:b0:53b:1ede:9174 with SMTP id
 2adb3069b0e04-53d7cff7502mr316569e87.28.1730871564937; Tue, 05 Nov 2024
 21:39:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <9-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com> <CABQgh9HoGFGDTEqziQt6WrJ7Bm9d-0c259PYsms3nOVEidn5BA@mail.gmail.com>
 <20241104171931.GB10193@nvidia.com>
In-Reply-To: <20241104171931.GB10193@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 6 Nov 2024 05:39:13 +0000
Message-ID: <CABQgh9HSAhat3_P43F_z07oqDaJ9h_YrZ-+SdHZ=ijzrZD1CVw@mail.gmail.com>
Subject: Re: [PATCH v4 09/12] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Donald Dutile <ddutile@redhat.com>, 
	Eric Auger <eric.auger@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Jerry Snitselaar <jsnitsel@redhat.com>, 
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, 
	patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 4 Nov 2024 at 17:19, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Oct 31, 2024 at 02:21:11PM +0800, Zhangfei Gao wrote:
>
> > > +static struct iommu_domain *
> > > +arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
> > > +                             const struct iommu_user_data *user_data)
> > > +{
> > > +       struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
> > > +       struct arm_smmu_nested_domain *nested_domain;
> > > +       struct iommu_hwpt_arm_smmuv3 arg;
> > > +       int ret;
> > > +
> > > +       if (flags)
> > > +               return ERR_PTR(-EOPNOTSUPP);
> >
> > This check fails when using user page fault, with flags =
> > IOMMU_HWPT_FAULT_ID_VALID (4)
> > Strange, the check is not exist in last version?
> >
> > iommufd_viommu_alloc_hwpt_nested ->
> > viommu->ops->alloc_domain_nested(viommu, flags, user_data) ->
> > arm_vsmmu_alloc_domain_nested
>
> It should permit IOMMU_HWPT_FAULT_ID_VALID, I'll add this hunk:
>
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> @@ -178,12 +178,18 @@ arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
>                               const struct iommu_user_data *user_data)
>  {
>         struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
> +       const u32 SUPPORTED_FLAGS = IOMMU_HWPT_FAULT_ID_VALID;
>         struct arm_smmu_nested_domain *nested_domain;
>         struct iommu_hwpt_arm_smmuv3 arg;
>         bool enable_ats = false;
>         int ret;
>
> -       if (flags)
> +       /*
> +        * Faults delivered to the nested domain are faults that originated by
> +        * the S1 in the domain. The core code will match all PASIDs when
> +        * delivering the fault due to user_pasid_table
> +        */
> +       if (flags & ~SUPPORTED_FLAGS)
>                 return ERR_PTR(-EOPNOTSUPP);

Thanks Jason, this works

