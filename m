Return-Path: <kvm+bounces-55614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56462B3425A
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:58:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 166343AA88C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 13:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3EE62F1FD9;
	Mon, 25 Aug 2025 13:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xI18C57R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BC12F28F4
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 13:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756129747; cv=none; b=a+xGoOBE3eTPMfJVOrJRvdq7s6CDc2Mobv/9wnAqiMhZE+CZykq7BIpGCxOkgcg+6YjetHaSJeIWN7cuSMhQvLUv06PhjTaJV92JyngaxeOwUwOMp2eNBrWz7PvQl9jVCamDf/5gPqbKoXqWKgO7uo7ttB7pBsbhcvVEsnR0eB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756129747; c=relaxed/simple;
	bh=M+3aLG5O1Iyt0A5EfM0+G7YSFPkj1Z+V9I8upPF+K+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDJpOsrImdCzYo2VgPkghYNw15Bu3T/dEtvRhS+OFKJ9hnoz93N6xPOcb4Q9KXcWcgkyOV4yrHK7gkfIR9wz8fXzxwAIxEYu1XP8eoo/R72e1Lc3H19XwHR46TjBNmuXzTCRxGM52p8Gq/yCRh2/yOtORV41nfW4WS+gc34JHwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xI18C57R; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-246257e49c8so316315ad.0
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 06:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756129745; x=1756734545; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EPr98kGx2moAT0RVFoQtEyPZgoeJKLmMTUQO/3/PhCw=;
        b=xI18C57RcBFTc4MuHQ1rdQJnQdUNbUGzYSPoxgNvg1SfeSaVfRvi5nLI/kSLfP4QZL
         nYVXIeRVz/lPftPx5jGGSZCuYkJbfTTnDO1GDgb2ZLSZ03atI39YLI49SR4ZFI85ozq3
         086oGoA4IaP+nznNrEcE/l1Mjl4zRJ3p3oiki0W2+2HCPSO/oDB/H8gUzOSEgmrz6GjL
         3xtvipBIM/WL1/hN6AwO9EqZ7dIhkjzvnolvuJLlZDR3LR0fbicObWRCT/QYynhGJGLZ
         sez80JZGB+POaxfdKK597AoYKR0HjQ9vatgTczfrutaF9Al1oBGK5vzLF6zwmKk/XRQg
         m1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756129745; x=1756734545;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EPr98kGx2moAT0RVFoQtEyPZgoeJKLmMTUQO/3/PhCw=;
        b=r8MzMCggVfHCOtWwLISz0RKH4Vjx2HA7ZUWauLxs0HKERlP9xjnb/L5ZPf4d5RQiHc
         cDOWn6ueu62TsBiVwWwoX7A7hGEzpp5ChMv9X9pTC6dB/hga2LuQK5PhiZ+8dMt3fAAX
         2sPQWTXywDQCR6PAqjAMM34E32LB2DHl/6asToThUs59CwOZAWNu0bqQS1ZhY9ki40Oc
         FWkK3jiZdHfbLLMVf2DqN12dQy2loO4WaB11UM5DsCoydDLT0OZk/kXLjzjPFkZmyQF/
         hOwIEjFZkGDcxjObcp0wxSTrYUpXDw8T491Ujfannoxo0FRASk9gLVAvqoCRP+c67igC
         9ssw==
X-Forwarded-Encrypted: i=1; AJvYcCU4HXj7F1d8Asez20F+YMN4PltNjUYyphcpUPFZUS7NwLZAgJWTjKWFoOgY+kAVK91CLxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbt7SnZ6fMWRj3PhAHgz4DeMW9pySMXxWqfx6L1TegFjfDF7nB
	C9g6P5sHI0mNTMJvQfKLqsR7bB/aggWPNEffJk/yXJP3KGaoFDhL74Lsrx5TZbjKboKQo1hg7Vk
	iweuKYQ==
X-Gm-Gg: ASbGnctaCqfY7uQr1ayi6EhIIgNqgIGUV5aFS5fa0k7OMuhweRWzzVvemlYuD933Jm+
	OV92cB3Kpjfx6teGJXhqg7mF4shQAKWxEP3uwq9AtQDIrBHwKmvt9HgADl+zaj8B4FEE9S7Ff41
	/v3P2G0AcBw94C3FAeFQ6xGb2uSzhAwJJpt8lcTY0i7s1kFQldGorFk7Deg1sJu5hzJxqYf4YsF
	onwAyhrAnBGTKB6R0nmMfA0lWDTm+AQhF8FN1j+CzylXDbp75mnvWDsZ75wEdMVbo7ua6+D1H9Z
	MhyEXSEU0h8EkCGMY7awk0nd/W7MSoyKQEwERXCYY7d4b+8d1IkuWPAA+wVRTvkL6sHHVWExiBz
	CTTkI5joUwney6vhP5ZJUC14QwUXj5fvW6vsCl7CAVyW9X8/y27RUkeu4PLsdDtl6uKViosP/LH
	y2
X-Google-Smtp-Source: AGHT+IFztbDXKXjAyRb5SxPdh+Iq/NxAzHcFUzomLyrk9sUfwujvvdLN8bMYYRRWXraeewthphphRw==
X-Received: by 2002:a17:902:e5c4:b0:246:1f3e:4973 with SMTP id d9443c01a7336-2466f9ec151mr6423705ad.6.1756129744951;
        Mon, 25 Aug 2025 06:49:04 -0700 (PDT)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771ecfd76f3sm1397728b3a.63.2025.08.25.06.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 06:49:04 -0700 (PDT)
Date: Mon, 25 Aug 2025 13:48:59 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, clg@redhat.com
Subject: Re: [PATCH 2/2] vfio/platform: Mark for removal
Message-ID: <aKxpyyKvYcd84Ayi@google.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
 <20250806170314.3768750-3-alex.williamson@redhat.com>
 <aJ9neYocl8sSjpOG@google.com>
 <20250818105242.4e6b96ed.alex.williamson@redhat.com>
 <aKNj4EUgHYCZ9Q4f@google.com>
 <00001486-b43d-4c2b-a41c-35ab5e823f21@redhat.com>
 <aKXnzqmz-_eR_bHF@google.com>
 <43f198b5-60f8-40f5-a2cd-ff21b31a91d4@redhat.com>
 <aKYvS3qgV_dW1woo@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aKYvS3qgV_dW1woo@google.com>

On Wed, Aug 20, 2025 at 08:25:47PM +0000, Mostafa Saleh wrote:
> Hi Eric,
> 
> On Wed, Aug 20, 2025 at 06:29:27PM +0200, Eric Auger wrote:
> > Hi Mostafa,
> > 
> > On 8/20/25 5:20 PM, Mostafa Saleh wrote:
> > > Hi Eric,
> > >
> > > On Tue, Aug 19, 2025 at 11:58:32AM +0200, Eric Auger wrote:
> > >> Hi Mostafa,
> > >>
> > >> On 8/18/25 7:33 PM, Mostafa Saleh wrote:
> > >>> On Mon, Aug 18, 2025 at 10:52:42AM -0600, Alex Williamson wrote:
> > >>>> On Fri, 15 Aug 2025 16:59:37 +0000
> > >>>> Mostafa Saleh <smostafa@google.com> wrote:
> > >>>>
> > >>>>> Hi Alex,
> > >>>>>
> > >>>>> On Wed, Aug 06, 2025 at 11:03:12AM -0600, Alex Williamson wrote:
> > >>>>>> vfio-platform hasn't had a meaningful contribution in years.  In-tree
> > >>>>>> hardware support is predominantly only for devices which are long since
> > >>>>>> e-waste.  QEMU support for platform devices is slated for removal in
> > >>>>>> QEMU-10.2.  Eric Auger presented on the future of the vfio-platform
> > >>>>>> driver and difficulties supporting new devices at KVM Forum 2024,
> > >>>>>> gaining some support for removal, some disagreement, but garnering no
> > >>>>>> new hardware support, leaving the driver in a state where it cannot
> > >>>>>> be tested.
> > >>>>>>
> > >>>>>> Mark as obsolete and subject to removal.  
> > >>>>> Recently(this year) in Android, we enabled VFIO-platform for protected KVM,
> > >>>>> and it’s supported in our VMM (CrosVM) [1].
> > >>>>> CrosVM support is different from Qemu, as it doesn't require any device
> > >>>>> specific logic in the VMM, however, it relies on loading a device tree
> > >>>>> template in runtime (with “compatiable” string...) and it will just
> > >>>>> override regs, irqs.. So it doesn’t need device knowledge (at least for now)
> > >>>>> Similarly, the kernel doesn’t need reset drivers as the hypervisor handles that.
> > >>>> I think what we attempt to achieve in vfio is repeatability and data
> > >>>> integrity independent of the hypervisor.  IOW, if we 'kill -9' the
> > >>>> hypervisor process, the kernel can bring the device back to a default
> > >>>> state where the device isn't wedged or leaking information through the
> > >>>> device to the next use case.  If the hypervisor wants to support
> > >>>> enhanced resets on top of that, that's great, but I think it becomes
> > >>>> difficult to argue that vfio-platform itself holds up its end of the
> > >>>> bargain if we're really trusting the hypervisor to handle these aspects.
> > >>> Sorry I was not clear, we only use that in Android for ARM64 and pKVM,
> > >>> where the hypervisor in this context means the code running in EL2 which
> > >>> is more privileged than the kernel, so it should be trusted.
> > >>> However, as I mentioned that code is not upstream yet, so it's a valid
> > >>> concern that the kernel still needs a reset driver.
> > >>>
> > >>>>> Unfortunately, there is no upstream support at the moment, we are making
> > >>>>> some -slow- progress on that [2][3]
> > >>>>>
> > >>>>> If it helps, I have access to HW that can run that and I can review/test
> > >>>>> changes, until upstream support lands; if you are open to keeping VFIO-platform.
> > >>>>> Or I can look into adding support for existing upstream HW(with platforms I am
> > >>>>> familiar with as Pixel-6)
> > >>>> Ultimately I'll lean on Eric to make the call.  I know he's concerned
> > >>>> about testing, but he raised that and various other concerns whether
> > >>>> platform device really have a future with vfio nearly a year ago and
> > >>>> nothing has changed.  Currently it requires a module option opt-in to
> > >>>> enable devices that the kernel doesn't know how to reset.  Is that
> > >>>> sufficient or should use of such a device taint the kernel?  If any
> > >>>> device beyond the few e-waste devices that we know how to reset taint
> > >>>> the kernel, should this support really even be in the kernel?  Thanks,
> > >>> I think with the way it’s supported at the moment we need the kernel
> > >>> to ensure that reset happens.
> > >> Effectively my main concern is I cannot test vfio-platform anymore. We
> > >> had some CVEs also impacting the vfio platform code base and it is a
> > >> major issue not being able to test. That's why I was obliged, last year,
> > >> to resume the integration of a new device (the tegra234 mgbe), nobody
> > >> seemed to be really interested in and this work could not be upstreamed
> > >> due to lack of traction and its hacky nature.
> > >>
> > >> You did not really comment on which kind of devices were currently
> > >> integrated. Are they within the original scope of vfio (with DMA
> > >> capabilities and protected by an IOMMU)? Last discussion we had in
> > >> https://lore.kernel.org/all/ZvvLpLUZnj-Z_tEs@google.com/ led to the
> > >> conclusion that maybe VFIO was not the best suited framework.
> > > At the moment, Android device assignement only supports DMA capable
> > > devices which are behind an IOMMU, and we use VFIO-platform for that,
> > > most of our use cases are accelerators.
> > >
> > > In that thread, I was looking into adding support for simpler devices
> > > (such as sensors) but as discussed that won’t be done through
> > > VFIO-platform.
> > >
> > > Ignoring Android, as I mentioned, I can work on adding support for
> > > existing upstream platforms (preferably ARM64, that I can get access to)
> > > such as Pixel-6, which should make it easier to test.
> > >
> > > Also, we have some interest on adding new features such as run-time
> > > power management.
> > 
> > OK fair enough. If Alex agrees then we can wait for those efforts. Also
> > I think it would make sense to formalize the way you reset the devices
> > (I understand the hyp does that under the hood).
> 
> I think currently - with some help from the platform bus- we can rely on
> the existing shutdown method, instead of specific hooks.
> As the hypervisor logic will only be for ARM64 (at least for now), I can
> look more into this.
> 
> But I think the top priority would be to establish a decent platform to
> test with, I will start looking into Pixel-6 (although that would need
> to land IOMMU support for it upstream first). I also have a morello
> board with SMMUv3, but I think it's all PCI.
> 
> > >
> > >> In case we keep the driver in, I think we need to get a garantee that
> > >> you or someone else at Google commits to review and test potential
> > >> changes with a perspective to take over its maintenance.
> > > I can’t make guarantees on behalf of Google, but I can contribute in
> > > reviewing/testing/maintenance of the driver as far as I am able to.
> > > If you want, you can add me as reviewer to the driver.
> > 
> > I understand. I think the usual way then is for you to send a patch to
> > update the Maintainers file.
> 
> I see, I will send one shortly.
> 

I could contribute time to help with the maintenance effort here, if
needed. Please let me know if you'd like that.

> Thanks,
> Mostafa
> 

Thanks,
Praan

> > 
> > Thanks
> > 
> > Eric
> > >
> > > Thanks,
> > > Mostafa
> > >
> > >
> > >> Thanks
> > >>
> > >> Eric
> > >>
> > >>> But maybe instead of having that specific reset handler for VFIO, we
> > >>> can rely on the “shutdown” method already existing in "platform_driver"?
> > >>> I believe that should put the device in a state where it can be re-probed
> > >>> safely. Although not all devices implement that but it seems more generic
> > >>> and scalable.
> > >>>
> > >>> Thanks,
> > >>> Mostafa
> > >>>
> > >>>> Alex
> > >>>>
> > 
> 

