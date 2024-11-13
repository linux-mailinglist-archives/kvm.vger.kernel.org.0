Return-Path: <kvm+bounces-31692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FD39C666B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 02:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FDAA1F2510B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604D31BC5C;
	Wed, 13 Nov 2024 01:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pfEGiEBH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF2229405
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 01:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731459716; cv=none; b=Kwsb30fr1OFlONhatvYJJjgE+BLwQWpviAt7Wcl46S0Cl6AGnxx26tOOdHC6GpaHUxY8qUHK8MS73CSHtK9rkA6+aaD1Kq4yFp+MhRuQyx2mGtD90/GvkgGhVpoicCkQDTOuoALCWVRhx2wylpX1FpbxvxaSKsg++rPfsKhOiew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731459716; c=relaxed/simple;
	bh=5v0Pumd1wdfkWfYkDyIym/XT5Jsmn2z22aIpke3ZD48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwcHocURC/4pMmgYLU9pFNDdjcFQIbX9alfc0GsV5zlAA0e5xe0N09Ca8nTechyueDGBtQcPUREM7UoRbMYYZrys3gw9jFHmo+4NI4v9zt8ZVBXsIxgDWVJD43liZpPM1dA3ICQi/XeSRiEMd9EbIpG60S3yPbaou5kc2bNgegc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pfEGiEBH; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53d9ff8f1e4so372435e87.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 17:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731459713; x=1732064513; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X/yyOuGNVIzT+zYvh4v3hplD3RNbNSCQhrz/FBYBpRw=;
        b=pfEGiEBHjjWhr390kchqE8sKFazOC66AAW8ruPbLb3K39ostOaXd3xLFpFdwyr7Os1
         kdi3WQtTYsbIRAN6tj1LxNpvLIRNEAzN6Ii3p5vy3MIXeLohMK8Wc0or7tc0g2mETkIz
         NrrupDB3y1lFdaEjFP2+js3M0r0ff+wUMinUUkwOyP85VGm1SPL80Pj9uDuqOsZQHGyY
         4Y0wXQA++M447tcoLAOhUJpjwARNC6/M10Y5qCPxOFZjLvCKikf6UxWKKs44m5eWugTo
         WRaxC3xcTeYxS4v8p9I5OMI3DjAu9Ykngghp8rpgGIkFfuzdF32puQPiXFsipJ0qsBEp
         9gRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731459713; x=1732064513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/yyOuGNVIzT+zYvh4v3hplD3RNbNSCQhrz/FBYBpRw=;
        b=Zvn54VOBnccDju9ENTtMiv862FZbp5y41iCCkok6X3v5idGzivhFhG1WeS1niISmFd
         4WM4DXYIDx5bo646kkT7oOtYf9UTRlPDRZqZJNFoSxq9NiAUJoZ/+o613Re3ynq0JYR6
         x6vSBD+kuwaD/lhO74JMa2gLSIrugqqjumXAdfxo3xz5YshyzuMkzBGAqSDV1aUFxgOT
         5YcQuK5r7YYndFr683dBtvY75Lrn64AMDtEcepKTfZLgQsrdIKbS33o+sj/5YXeZpq9v
         N4brq1jvszVDFSyEKkBRQpsQ9F5tHCMGEx9jbrTabLBEj42gsoKkS3Q7+R851DL0x2kU
         3l6g==
X-Forwarded-Encrypted: i=1; AJvYcCUr3c8147txoD2ANHA5dEQhvmTeEqDI+ACKHLqyE/zka0EKm7mpVn/4n76wQTDWwjIBtU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiSG8ZFwk0gWJ2dr/ApCqfLGp0th8oCygH5xfT0PvOB87WLkmu
	aKLpUV99K8nUfhfMTItbUUJYrxY2kZUutAIBGmiGM5IuBF22cJ1hJ5ciRtS/UpVxqIpOoY7ZSd5
	DvKVN47iisweJ3/qmF49kYZ1XrdPFaiUMorK88w==
X-Google-Smtp-Source: AGHT+IGrTpBP4XZN2inszS5LiWIDhaTOAjWYv1IN45jLudjPrpRKEn2OnUUglHnQBM+zZuWyWdAuDjaQVoneTf1/DNk=
X-Received: by 2002:a05:6512:ba0:b0:539:e436:f1cd with SMTP id
 2adb3069b0e04-53d862d38c5mr9315032e87.16.1731459712927; Tue, 12 Nov 2024
 17:01:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com> <20241112182938.GA172989@nvidia.com>
In-Reply-To: <20241112182938.GA172989@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 13 Nov 2024 09:01:41 +0800
Message-ID: <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
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

On Wed, 13 Nov 2024 at 02:29, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> > Jason Gunthorpe (7):
> >   iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
> >   iommu/arm-smmu-v3: Use S2FWB for NESTED domains
> >   iommu/arm-smmu-v3: Allow ATS for IOMMU_DOMAIN_NESTED
> >
> > Nicolin Chen (5):
> >   iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
> >   iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE using a VIOMMU object
>
> Applied to iommufd for-next along with all the dependencies and the
> additional hunk Zhangfei pointed out.

Thanks Jason, I have verified on aarch64 based on your
jason/smmuv3_nesting branch

https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
https://github.com/Linaro/qemu/tree/6.12-wip

Still need this hack
https://github.com/Linaro/linux-kernel-uadk/commit/eaa194d954112cad4da7852e29343e546baf8683

One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
which you have patchset before.
The other is to temporarily ignore S2FWB or CANWBS.

Thanks

