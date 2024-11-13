Return-Path: <kvm+bounces-31715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52AE29C6943
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 07:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 043821F2383E
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 06:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E905C185939;
	Wed, 13 Nov 2024 06:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WQtqY1j5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F7B17837A
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 06:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731479353; cv=none; b=V1O+pI9q8h8NFZmVg8I/cShqhv/OV5GyXWNp6FwKrHocqpdMVpFKoiUPSPh1nmQJLAQ1u0ihwceVtT6bIfBbhFI4X+KLgWdcyjV5gPdxiQMmUg3bmzE1iEdS4aF4bZpXdV5EgHlns0IxBjcoQoS9xCBDImJT8LZ3uP30Bi61xQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731479353; c=relaxed/simple;
	bh=ryKZ3ZF7sN+kjlkdznbBZ1GozgBjmJSrP4P2jIodaXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YlsMU1LksAWAxkD1DzgA3SVWIKzdZba7slGUgcCUUu3Mg7cIIHim56Phrv6bpbKmRNku4yaHGpUvhT+8QT4jsEcH65QiqERu6JObAyiUnNwDSqaoutw4dL0o6lZOObLE28Esm+dfXAnBER3paz4uvmuf+4pf3IJ/4OC6kOS6J5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WQtqY1j5; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53d9ff8f1e4so575495e87.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 22:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731479348; x=1732084148; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9QCU/JLa948seWzRrNmkByaOgxKmnVBehQKimS55YRs=;
        b=WQtqY1j5mGUp6K+OS8i21t023WgFcGnaPntb4Obk23sKqdmFCVqIEJ0Cm7yaZEanMV
         gUOXp/4VV96oUyHB/rN22VI82czJAUNuFWPMUqL5GS8bFruFqO/+nlf6vgQ/iqU7JkJ+
         xxdA5cpHOwmFJqb1xeCCJ8mJB3a9aPBwUcBYgitplO7IKEl1vDaALu81C5g+DbnWnZkP
         BWC8+t0bp0bbM7VXEpAyIdNG6tf/H96kzWUcBeaR+WiDNNsZU1CMYCJWOBa0fhim/5NC
         FcuPfwzGgBuEwuFEroqNB4vVJSQ7hkiwE/JQiV8S2ZxVWV/5WU89zm4f5j0Ql3NyA6KU
         yjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731479348; x=1732084148;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9QCU/JLa948seWzRrNmkByaOgxKmnVBehQKimS55YRs=;
        b=xIO2NvkdMt4TJiS0CGV3W7awKk7QoOoMy1Unbko7Nf857MtyxT/tg2GemZ2TMGd1CK
         LBYoVpciwXfS5ZPlpfPDDJ11lL8TwutSdD2iFL7ZRl+F5p0/93eARgRWBj4ysBtfWMPw
         vb/7kr0Gmg1B8su5flhXXblqEbqpvZG4X7Uv3U3oh7AwGjfQZCugUMkcYhc/Q3yHh44L
         jzWsi7zfEJTM4cyWDvJDfK8+5FSU9OrieT2tTRohttcg1vM0lLctqEaMdnEkmR4LobCY
         3dLSRjqcSd08Qc4URF+0GHEf/fgBRKq5CK7ur51LEq5a6lho8iW9mZNqFDgvh8IriEgY
         KJKw==
X-Forwarded-Encrypted: i=1; AJvYcCU9aqrYNMeG/EpwQU9tEe0mWm/wvRjKr30TJFTzgJq8MvfujHkdIPbEAOHFGG34nTc8teY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFI4eK+5da+WMP18BvmzWHHGQPZwufl3KC7covTnHNJKKBtJaN
	ZcPqBgz9P8IJFykJ0qaIQd19C0yzPL1IU4n9xvwDrbkGpDXyNP3OQgXUuWAs/7xAVSDzCw5e7La
	rxxddOzja9Lo/AONMFywt3slSCjUEGMEIRmoT8w==
X-Google-Smtp-Source: AGHT+IEEpcf7Vups7lw1NP9O1FTEPXG1XjljcLFymoWHBWMOkn9tB109/qtbls5Dq+XYyRVJ67vPr0ofrW4PZLq41wk=
X-Received: by 2002:a05:6512:281b:b0:536:54fd:275b with SMTP id
 2adb3069b0e04-53d86303095mr9309340e87.54.1731479348058; Tue, 12 Nov 2024
 22:29:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com> <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com> <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
In-Reply-To: <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 13 Nov 2024 14:28:56 +0800
Message-ID: <CABQgh9F+K67YDYeg4==0dhdjya1YuX6uUttQA8zadWEZyRhNKw@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev, iommu@lists.linux.dev, 
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

Hi, Baolu

On Wed, 13 Nov 2024 at 10:56, Baolu Lu <baolu.lu@linux.intel.com> wrote:
>
> On 11/13/24 09:23, Jason Gunthorpe wrote:
> >> https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
> >> https://github.com/Linaro/qemu/tree/6.12-wip
> >>
> >> Still need this hack
> >> https://github.com/Linaro/linux-kernel-uadk/commit/
> >> eaa194d954112cad4da7852e29343e546baf8683
> >>
> >> One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
> >> which you have patchset before.
> > Yes, I have a more complete version of that here someplace. Need some
> > help on vt-d but hope to get that done next cycle.
>
> Can you please elaborate this a bit more? Are you talking about below
> change
>
> +       ret = iommu_dev_enable_feature(idev->dev, IOMMU_DEV_FEAT_SVA);
> +       if (ret)
> +               return ret;
>
> in iommufd_fault_iopf_enable()?
>
> I have no idea about why SVA is affected when enabling iopf.

In drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c,
iommu_dev_enable_feature(IOMMU_DEV_FEAT_SVA) will real call
iopf_queue_add_device,
while iommu_dev_enable_feature(IOPF)  only set flag.

arm_smmu_dev_enable_feature
case IOMMU_DEV_FEAT_SVA:
arm_smmu_master_enable_sva(master)
iopf_queue_add_device(master->smmu->evtq.iopf, dev);

Thanks

