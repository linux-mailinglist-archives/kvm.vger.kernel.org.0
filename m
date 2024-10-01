Return-Path: <kvm+bounces-27762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6DA298B90D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 12:15:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 537A6281887
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 10:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB24F19D08C;
	Tue,  1 Oct 2024 10:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MY7hBdoz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F3D1A0739
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 10:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727777709; cv=none; b=LeN1IVv8EfXPRUEN/CZaN18xRCVHbgt562hKAYydrisy4jp0CqWCNv9jFCrkOnbhBOLT4Ab6zxZ1zqnKi8VgpqENbVBW+OfPOEapMCZbPzzFdf0r2AWBF7AY9Z506vuFbgKcN9Gpwgaf7o+yV/N+hAil0L2Pdh+sqDbYIXCnMoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727777709; c=relaxed/simple;
	bh=BlF641vZ2yHSZ1q5BReVx1GayMf544SZaUFnHZHcaKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHRqiZtQMtczHIJK3Qfhn5/rVPAZpCklT0tObt56CVyYJ3rqughiXLtFLwQWY/MqcmbwoG80V2WKisU74D05O1hk/rh6AXyk2bAvKO52F2gTtxKtASeqvCyjusapmhw+9hH8KSrKXBc4HIYgJ8Sg4GE/kkjM0fWRHmbTwb6kjrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MY7hBdoz; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5398c2e4118so18714e87.0
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 03:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727777705; x=1728382505; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X/DzEw6nRKo67c9nKVdXwn2fa471umYn51WpELIFZPk=;
        b=MY7hBdozqzcOK+RMb4mz+uI//sRi4CxHi8rety9WtPreobRnVKnXDkrlwwI5h92dIa
         cbvsEzuRQBO9ajKj3EIt6WLYdfrxXpVp5rU1V6xSAIplCqnrFuxfq035N/HIjiJqFEOX
         sEaeEjbAo8a2rCCK6ttpgTiigjn897hXWhH42lEif+NDkQ6Bi8qlWO0HQSaIOQQc210r
         2mFajfyQzHSK/eX9wvQxa78AHkzhyYYbyid7eUG2zV13qOOWqRy3fGwaGIkcMLk+nQek
         lvEmwkIzNF8N9Nr/8YIR3FxhYgBPeNgad3vS0PXCOQNlDp3Jt9pZWJ7JwNBuIzliGniv
         D3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727777705; x=1728382505;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/DzEw6nRKo67c9nKVdXwn2fa471umYn51WpELIFZPk=;
        b=AwOcOuqsxYNnbhxQIXJOKWmTM8IPWGIF9T3e2Ia6/lx0qAWsnevmHMqAkGDG7BXg1j
         /JxWBTTs9a0IosDobPsIbk3cEPXyd1bCZEFEfv6KGyc8wXHytRW2dTtRn+izeqY9kB1+
         wbDGYXYdZn0coYYZHonXTOjJRndkpgiseWunGE2qOzk3VVBf3kM6aDYbayFgmTktCncR
         xIj9SHQ3dYlOZ1j03bqDCZvQGaaYRgzxlv/zdrs0z5LfgqilO9mUNGK+UfTbUyXRasxn
         NOKIofvOgez3U6GbgR7lrdtCLw9JDpTEpOLaD4PH7BHFSfoy6PLreOn9WLUP4AAgrZ1R
         rTTQ==
X-Gm-Message-State: AOJu0Yx8xLJjWnNZOMeUo5Q7a3Xwid9cxpRLOWW7EuaHa18xWCckuAUc
	bxWMhfQb4w6stjHIKPd0tNz7PsRwZrXwB7zNIDYQPt5iXeWyA661UppXlZSpdg==
X-Google-Smtp-Source: AGHT+IFo3i9ZtO8BZhfJmbOqYKVBbitf3wMZNo/QgLBp0OPRQ/pkOwLGH7IUnBfOx4C6IgGk1aqZNA==
X-Received: by 2002:a05:6512:3c9d:b0:533:8dc:1c20 with SMTP id 2adb3069b0e04-5399ae2c326mr489029e87.4.1727777705056;
        Tue, 01 Oct 2024 03:15:05 -0700 (PDT)
Received: from google.com (105.93.155.104.bc.googleusercontent.com. [104.155.93.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e96a361c3sm176765435e9.34.2024.10.01.03.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 03:15:04 -0700 (PDT)
Date: Tue, 1 Oct 2024 10:15:00 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
	Eric Auger <eric.auger@redhat.com>, kwankhede@nvidia.com,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: Re: [RFC] Simple device assignment with VFIO platform
Message-ID: <ZvvLpLUZnj-Z_tEs@google.com>
References: <CAFgf54rCCWjHLsLUxrMspNHaKAa1o8n3Md2_ZNGVtj0cU_dOPg@mail.gmail.com>
 <20240930111013.2478261c.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240930111013.2478261c.alex.williamson@redhat.com>

Hi Alex,

On Mon, Sep 30, 2024 at 11:10:13AM -0600, Alex Williamson wrote:
> On Fri, 27 Sep 2024 17:17:02 +0100
> Mostafa Saleh <smostafa@google.com> wrote:
> 
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
> > 
> > As far as I understand the current solutions to pass through platform
> > devices that are not DMA capable are:
> > - Use VFIO platform + (CONFIG_VFIO_NOIOMMU): The problem with that, it
> > taints the kernel and this doesn’t actually fit the device description
> > as the device doesn’t only have an IOMMU, but it’s not DMA capable at
> > all, so the kernel should be safe with assigning the device without
> > DMA isolation.
> 
> If the device is not capable of DMA, then what do you get from using
> vfio?  Essentially the device is reduced to some MMIO ranges and
> something to configure line level interrupt notification.
> Traditionally this is the realm of UIO.

My simplistic understanding was that VFIO mainly deals with device passthrough
to VMs while UIO deals with userspace drivers.

Also, it seems that UIO lacks support of eventfd for irqs, which makes it
inefficient to use with KVM.

>  
> > - Use VFIO mdev with an emulated IOMMU, this seems it could work. But
> > many of the code would be duplicate with the VFIO platform code as the
> > device is a platform device.
> 
> Per Eric's talk recently at KVM Forum[1] we're already at an inflection
> point for vfio-platform.  We're suffering from lack of contributions
> for any current devices, agreement in the community to end it as a
> failed experiment, while at the same time vendors quietly indicate they
> depend on it.  It seems that at a minimum, we can't support
> vfio-platform like we do vfio-pci, where a meta driver pretends it can
> support exposing any platform device.  There's not enough definition to
> a platform device.  Therefore if vfio-platform is to survive, it's
> probably going to need to do so through device specific drivers which
> understands how a specific device operates, and potentially whether it
> can or cannot perform DMA.  That might mean that vfio-platform needs to
> take the mdev or vfio-pci variant driver approach, and the code
> duplication you're concerned about should instead be refactoring in
> order to re-use the existing code from more device specific drivers.

I see, that makes sense, but I guess that won't progress much without
vendor contributing drivers :/

> > - Use UIO: Can map MMIO to userspace which seems to be focused for
> > userspace drivers rather than VM passthrough and I can’t find its
> > support in Qemu.
> 
> This would need to be device specific code on the QEMU side, so there's
> probably not much to share here.
> 
> > One other benefit from supporting this in VFIO platform, that we can
> > use the existing UAPI for platform devices (and support in VMMs)
> 
> But it's not like there's ubiquitous support for vfio-platform devices
> in QEMU either.  Each platform device needs hooks to at least setup
> device tree entries to describe the device to the VM.  AIUI, QEMU needs
> to understand the device and how to describe it to the VM whether the
> approach is vfio-platform or UIO.

Makes sense, although it's sad there is no upstream support for any
device.

>  
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
> As noted in the thread referenced by Eric, I don't think we want to add
> any sort of vfio no-iommu into QEMU.  vfio-platform in particular is in
> no position drive such a feature.  If you want to use vfio for this,
> the most viable approach would seem to be one of using an emulated
> IOMMU in a device specific context which can understand the device is
> not capable of DMA.  We likely need to let vfio-platform die as generic
> means to expose arbitrary platform devices.  Thanks,

I see, thanks a lot for the feedback, it seems vfio-platform is not the
right place for this, and it'd be better to have separate drivers that
register vfio devices, and maybe we can have more common code for platform
devices as this progresses.

Thanks,
Mostafa

> 
> Alex
> 
> [1]https://www.youtube.com/watch?v=Q5BOSbtwRr8
> 

