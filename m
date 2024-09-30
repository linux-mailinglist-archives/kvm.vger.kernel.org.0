Return-Path: <kvm+bounces-27674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D8E98A22F
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 14:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E929F284659
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 12:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3130418E346;
	Mon, 30 Sep 2024 12:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jYNUBsH2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F7618FDDA
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 12:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727698701; cv=none; b=TImKyC4plU4cqCrpp/DWs53gT00L44XchcKUbC6lMs4i9vJhK/T9/j4DXKLXZWFI5WYgQ8vKmdDD2hlQTFzepY8Gs1jBy8u1C0Zqw3VH4mkEGFAENooDaTCDvjE9cHE+1XmbVfN5sDVb2sL9/cl1A57RgegA5bKrFK5mJlulcm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727698701; c=relaxed/simple;
	bh=Sfw0mdEMDh/K3VhBFy3s8i5VHolr+g/Xq0J0N41drMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ow0+cbqq0uxD6HCWKDXZWDucI6FzovRQm88hgZ/AdFFbPUX1aMevY2emHo/6hWw1MD5bBcNd91fC/o2hFStlzw4eKaoejPRI5eyGDoCCiIC5OWblPz43mKrF3wt4ktemYf/2QXLMPzpYP1RQ3tWzJjgiJrIDmP9XEkBl1DYfONQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jYNUBsH2; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42cae4ead5bso201525e9.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 05:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727698698; x=1728303498; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ep8QUlUnrds1SGucXi/YgAp2nqtwi1+G8zbAJEqKkms=;
        b=jYNUBsH2+D6AwBTcF9MZyJVUlB3DJfOlxljIPTnpEgUUxuXMJbElREFKhkFQV5rEbI
         9ZJV8xmon6JdBe0VGJVvQdhWlvHA9LBzl7gkIA0y1i4IFmJRPfclyg0/gFCOY4mU+aSc
         MySspSr0EOgMd43BTnYaVeT2pOGQCvQhXnDKxdkM+7fo4xAr5LrTEHd5DLJ2Z55z5UrG
         mV+f15dTYuDvK2vWLcIGGrv9HCjV+cILDnsAYrSZV2jRIopPzyapfDbjdLCPP++dT4U8
         3ZQ0nZvByldlkCV28RE64SQott+i1V8iBEU8WxhL7+tEabYkQyXw4Fue2hAS6Fx2/KAN
         E3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727698698; x=1728303498;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ep8QUlUnrds1SGucXi/YgAp2nqtwi1+G8zbAJEqKkms=;
        b=KkacQ+NTtdCeq6jhTpG8jUilGXI0zPd97fWuGbQsEabPG2jrHPBCXSWqOBT+sI5AAt
         9hVzfLU2LnAezka7Bv+jNOnE4yFU8TPWcKC0lFCI2ZzaTr1v/u+RnlBK4mUGSqV7bUDB
         z92oWa8EBlRYjQgnnTCrTkDPQ7cB8fs55ZfOhm0FH230WDmzqNaD9Bs7gxrfatbcrQTT
         yCKYLyTk1wDUUvL/c+o29Bskhoqvej3pH5OYEhdZNqr/poO8D/P6xTDUKDk2UDrr8TQX
         cuYk596RoDr8IqX+rrm6j3xgKFMDxxffpDKWXBoApeZQHnvgii5qldq8hR2BuqVr13OZ
         rfAg==
X-Gm-Message-State: AOJu0YxhDsQp3iYl8an6UE1neUqBlFTQae74BaCgkk7xeUQL5hBvQlgM
	hdxMwJPl3lSJn8UZ+pmNu7f33qKMMaeGI8MHaP2Z9jUDY9Kkvmu3PY5HuCzXUg==
X-Google-Smtp-Source: AGHT+IH+eizAu2CnZGC3hefAOZi6cXpOLeMx7dOz1tK0DzkSpIg3YK9bWw+nq6Fd1qcBeFmDAlYILQ==
X-Received: by 2002:a05:600c:1e15:b0:426:66a0:6df6 with SMTP id 5b1f17b1804b1-42f5e86ebbdmr5573495e9.0.1727698697581;
        Mon, 30 Sep 2024 05:18:17 -0700 (PDT)
Received: from google.com (105.93.155.104.bc.googleusercontent.com. [104.155.93.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd56e645fsm8861945f8f.59.2024.09.30.05.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 05:18:17 -0700 (PDT)
Date: Mon, 30 Sep 2024 12:18:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: kvm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>, kwankhede@nvidia.com,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: Re: [RFC] Simple device assignment with VFIO platform
Message-ID: <ZvqXBY12_53HLV9k@google.com>
References: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
 <27b1055b-aee3-4d00-a4f8-d7d026cfbdd6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27b1055b-aee3-4d00-a4f8-d7d026cfbdd6@intel.com>

Hi Yi,

Thanks a lot for the feedback.

On Mon, Sep 30, 2024 at 03:19:05PM +0800, Yi Liu wrote:
> On 2024/9/28 00:17, Mostafa Saleh wrote:
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
> > [1] https://lore.kernel.org/kvm/20240801090117.3841080-1-tabba@google.com/
> > [2] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linaro.org/
> > 
> > Problem
> > =======
> > At the moment, VFIO platform will deny a device from probing (through
> > vfio_group_find_or_alloc()), if it’s not part of an IOMMU group,
> > unless (CONFIG_VFIO_NOIOMMU is configured)
> 
> so your device does not have an IOMMU and also it does not do DMA at all?

Exactly.

> 
> > As far as I understand the current solutions to pass through platform
> > devices that are not DMA capable are:
> > - Use VFIO platform + (CONFIG_VFIO_NOIOMMU): The problem with that, it
> > taints the kernel and this doesn’t actually fit the device description
> > as the device doesn’t only have an IOMMU, but it’s not DMA capable at
> > all, so the kernel should be safe with assigning the device without
> > DMA isolation.
> 
> you need to set the vfio_noiommu parameter as well. yes, this would give
> your device a fake iommu group. But the kernel would say this taints it.

Yes, that would be the main problem with this approach.

> 
> > 
> > - Use VFIO mdev with an emulated IOMMU, this seems it could work. But
> > many of the code would be duplicate with the VFIO platform code as the
> > device is a platform device.
> > 
> > - Use UIO: Can map MMIO to userspace which seems to be focused for
> > userspace drivers rather than VM passthrough and I can’t find its
> > support in Qemu.
> 
> QEMU is for device passthrough, it makes sense it needs to use the VFIO
> without noiommu instead of UIO. The below link has more explanations.
> 

I agree, the reason I considered UIO, is that it allows mmap of the device
MMIO, so in theory those can be passed to KVM, but that might be abuse of
the UAPI? Specially I can’t find any VMM support for that.

> https://wiki.qemu.org/Features/VT-d
> 
> As the introduction of vfio cdev, you may compile the vfio group out
> by CONFIG_VFIO_GROUP==n. Supposedly, you will not be blocked by the
> vfio_group_find_or_alloc(). But you might be blocked due to no present
> iommu. You may have a try though.

That fails at probe also, because of the device has no IOMMU as
vfio_platform_probe() ends up calling device_iommu_capable().

Also, AFAIU, using cdev must be tied with IOMMUFD, which assumes
existence of IOMMU and would failt at bind.

> 
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
> 
> is it the mdev approach listed in the above?

No, I meant to extended VFIO-platform to understand that, so in case the
device has no IOMMU group, it can check with the platform bus if the
device is DMA capable or not and it can allow those devices (maybe
gated behind a command line) to be probed with emulated group.

Having an new mdev just for platform devices with no DMA capabilities might
be good if we don’t want to change VFIO platform, but my main concern is that
might need more code + duplication with VFIO-platform.

Thanks,
Mostafa

> -- 
> Regards,
> Yi Liu

