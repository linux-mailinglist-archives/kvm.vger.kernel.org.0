Return-Path: <kvm+bounces-27675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5BF098A25C
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 14:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7800D281DDB
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 12:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B518018E047;
	Mon, 30 Sep 2024 12:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MXwF7pwr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371281714C0
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 12:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727699225; cv=none; b=luJVk3xwL/xKr1vEPk35aNwpk+Il16UlDHGuPfa3XLNN1fdSdoz5CNWYAgnaNdnfWYnn4qPrsD+dgtS/ErVMX58YG9/yHPtAh5ptxc69iYOuyEh5MPp5tFV6LiDTIf/I6tjpt2xRaTVYWWEBE0OoXGU1LZa5djrscaaJixYjmxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727699225; c=relaxed/simple;
	bh=VCKt0535H/iWdjXW60FMbqfftTGog7/qBtA6opzPV9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOZrGKVblp1xDMEmHrTkb7uIQeuaCyrpYBgFI/VQRdP4m48uk8EbSgnz0HfkZx/RVbLO1t/hZ0/fdoo9PODv+voLJFPVyat69XjXTOkki1Dz7FhMwgzXAaXiKtjnomeTs21+M41BlW4sAG8upOiAIVbVvSzwxthMb0cAPLAT1ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MXwF7pwr; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42cae4ead5bso203375e9.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 05:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727699222; x=1728304022; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1IjSRUAtTDtw2SGctv/5ydlstMiEmxSV2M7xlf1TUGA=;
        b=MXwF7pwrGo02o5IPK9P+TjQvQuZ408E3a7s6IuICnZ/xaRImzMRWmaZhRgFAd3HF0r
         VWLQfXC5/ARW1XBupbHknpTbwxJjN4v3MrFeQsPpbajG3Z+Tay741GyYc145gPp9NAij
         2nFVU3bxAIG0DRKbg6vf9YoLu7X5JYlBCUi+ekgGXZW19go79+aKpuewcA5C+7MH+tjI
         EIBPb5176TnXBUG7dSgkJKIlFLOTZTwSgh4VjWW8mfYHZah4emvvtTKbzTJ+5OD895Ds
         HiGIpY43onbO1xzmqAPyzzpGG45nZmkvsolq/EugKKU/DHV266A3R6hc0Za1pYKi2lDG
         BWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727699222; x=1728304022;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1IjSRUAtTDtw2SGctv/5ydlstMiEmxSV2M7xlf1TUGA=;
        b=NLzgESJR1JAIV+z+un25Z3TOmzzB5F0wF6e0cC3NEgRNcUo/bDcjFBqrgut/vi2CTq
         xnjNh7xlK4rOxsLMpquFmWLMSAB/DxkJHEtRDjjyoO4S9tc0vBWT1S552sBsqodM8Xaw
         ooHSy6dMpaYSGsy764xRH/XnrHXraJHde9Idh/TeZh5YwShLRPi0h0BjYFioKYIbNuXO
         5Wh89GJ0ViyAzlmn9cmrUInjH5IkbmT9YAVQ/AjkM/936gn9atMEWdBasKmghlggyuH2
         Jqgo3OUi1YfmR9XyFdzpdUyewI0bfnfV0XneHQrTfbL2cxfs4lqHJkD4halFSYXlK6cp
         VHgQ==
X-Gm-Message-State: AOJu0YwMNH4HYhHYF+Oo0xWWidlhLxdkaMJI59yLV2LbnsNjNoKt7yy6
	VLbvorP78Cz5e6DFJ60xAd7q9PCLV7IvNcwslYtVPeF+arXHjBeKy3llHa3O3w==
X-Google-Smtp-Source: AGHT+IHgJFuT9e8DkPTpiSpg/nrd/94uflEZL4okr6gBL1sZLvKqEg789WKj1/ePMHv1kjPGo1UirA==
X-Received: by 2002:a05:600c:1e15:b0:426:66a0:6df6 with SMTP id 5b1f17b1804b1-42f5e86ebbdmr5613975e9.0.1727699222269;
        Mon, 30 Sep 2024 05:27:02 -0700 (PDT)
Received: from google.com (105.93.155.104.bc.googleusercontent.com. [104.155.93.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f57e13524sm101738295e9.37.2024.09.30.05.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 05:27:01 -0700 (PDT)
Date: Mon, 30 Sep 2024 12:26:57 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: Re: [RFC] Simple device assignment with VFIO platform
Message-ID: <ZvqZEUFUlpAqhYkV@google.com>
References: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
 <BN9PR11MB52768B9199FAEAF8B9CC378E8C762@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52768B9199FAEAF8B9CC378E8C762@BN9PR11MB5276.namprd11.prod.outlook.com>

Hi Tian,

On Mon, Sep 30, 2024 at 08:19:45AM +0000, Tian, Kevin wrote:
> > From: Mostafa Saleh <smostafa@google.com>
> > Sent: Saturday, September 28, 2024 12:17 AM
> > 
> > Hi All,
> > 
> > Background
> > ==========
> > I have been looking into assigning simple devices which are not DMA
> > capable to VMs on Android using VFIO platform.
> > 
> > I have been mainly looking with respect to Protected KVM (pKVM), which
> > would need some extra modifications mostly to KVM-VFIO, that is quite
> > early under prototyping at the moment, which have core pending pKVM
> > dependencies upstream as guest memfd[1] and IOMMUs support[2].
> > 
> > However, this problem is not pKVM(or KVM) specific, and about the
> > design of VFIO.
> > 
> > [1] https://lore.kernel.org/kvm/20240801090117.3841080-1-
> > tabba@google.com/
> > [2] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-
> > philippe@linaro.org/
> > 
> > Problem
> > =======
> > At the moment, VFIO platform will deny a device from probing (through
> > vfio_group_find_or_alloc()), if it’s not part of an IOMMU group,
> > unless (CONFIG_VFIO_NOIOMMU is configured)
> > 
> > As far as I understand the current solutions to pass through platform
> > devices that are not DMA capable are:
> > - Use VFIO platform + (CONFIG_VFIO_NOIOMMU): The problem with that, it
> > taints the kernel and this doesn’t actually fit the device description
> > as the device doesn’t only have an IOMMU, but it’s not DMA capable at
> > all, so the kernel should be safe with assigning the device without
> > DMA isolation.
> > 
> > - Use VFIO mdev with an emulated IOMMU, this seems it could work. But
> > many of the code would be duplicate with the VFIO platform code as the
> > device is a platform device.
> 
> emulated IOMMU is not tied to mdev:

Makes sense, I see it’s used by a couple of other drivers also, so in
that case it can be just a driver and not an mdev.

> 
>         /*
>          * Virtual device without IOMMU backing. The VFIO core fakes up an
>          * iommu_group as the iommu_group sysfs interface is part of the
>          * userspace ABI.  The user of these devices must not be able to
>          * directly trigger unmediated DMA.
>          */
>         VFIO_EMULATED_IOMMU,
> 
> Except it's not a virtual device, it does match the last sentence that
> such device cannot trigger unmediated DMA.
> 
> > 
> > - Use UIO: Can map MMIO to userspace which seems to be focused for
> > userspace drivers rather than VM passthrough and I can’t find its
> > support in Qemu.
> > 
> > One other benefit from supporting this in VFIO platform, that we can
> > use the existing UAPI for platform devices (and support in VMMs)
> > 
> > Proposal
> > ========
> > Extend VFIO platform to allow assigning devices without an IOMMU, this
> > can be possibly done by
> > - Checking device capability from the platform bus (would be something
> > ACPI/OF specific similar to how it configures DMA from
> > platform_dma_configure(), we can add a new function something like
> > platfrom_dma_capable())
> > 
> > - Using emulated IOMMU for such devices
> > (vfio_register_emulated_iommu_dev()), instead of having intrusive
> > changes about IOMMUs existence.
> > 
> > If that makes sense I can work on RFC(I don’t have any code at the moment)
> 
> This sounds the best option out of my head now...

Thanks a lot for the feedback, I will work on RFC patches unless someone
strongly disagrees with the approach.

Thanks,
Mostafa

