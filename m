Return-Path: <kvm+bounces-55204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45512B2E688
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 22:26:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C869D3B7CA6
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 20:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6998329A300;
	Wed, 20 Aug 2025 20:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kvogJW8t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35EB19007D
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 20:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755721555; cv=none; b=G4hCRz+TG6wVHV/jXLoofwo0umELXMFpLpV8PzF9nLD4ph4pzKVgvC6hWhKUP4390lOVexXgo55Q6Pj7yWeNoISGZWgjuhPdckNuj/SSwTY62Zj9fCEbYlR47ui7iSRBKM8V66YGkDBO7AKYJMvIYOK1vORrzsVjHtZ0cZMxmSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755721555; c=relaxed/simple;
	bh=Je29UIiG35r5CgCpWzYgXbipcStSALrF+0Yc5klDPHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/PpTaY/VVBjQIYdCEItCKk8Or1+d93w2cy8HKJUVce0aBGPB1CfkWp4M0gjIdUdMg8xMAPQ8UFnI2rW8EDCtp9sLbiDaG+Jj2jMVGJNJGzWpy9aSpk00fYvaMvGh8g+m5cA4Xj4mI6eNCIV72VjXBhkQtFdx/s1sWqE3YKT814=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kvogJW8t; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-459fc675d11so4855e9.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 13:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755721552; x=1756326352; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=The20L3qbajWPukZqiGrXj0iJ8704WP/BsqGQ0mZpME=;
        b=kvogJW8tnjqLWiCx9eBQfxXImohj23ncnSRsDnoSGpsP6DgdngzyWhPx+rWEN8MagZ
         KzIIN7raw+OgV2iTcqcT6QWD92aK7XUHJWHHTsNnxarjQ8xN75MvHs0wgnsY1cz2Gi+R
         XIAlE3CIthrA+6zBqmkwcQGZXZfWPMY8NiRewqeketuapLIdsbcNqlPqPOSV9DNEi0AR
         sUW/DABsoFxl6q0bFRJTx2gkCpq6ikcTcZ7Fi4W+ltSVfwzw3Umehwz2qrz6fmq9lSzJ
         /uLCSmD2tdmW9VKCirGexn/WSe0k4dms4QqxORFW/epWzFdcCUGADURl5Ec7LJPJfRbH
         CP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755721552; x=1756326352;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=The20L3qbajWPukZqiGrXj0iJ8704WP/BsqGQ0mZpME=;
        b=FLWgEl7EeiTDrXZ/KLFsmLGUU3nBfcUUzrzcodzSuLZgaHo1fFgzSJSPe949di9ucf
         9mfpc9PgkEVWhDhRZC9vPhhykShp68LF6OnZIrRJEWDktlkJYgrDyqgixkZSm0bdpT87
         xScK0ehB3UYgIGxStQV/GHglWEgyns/9Xycymq4IvvnzkFr2tZpnbH/HewSbZ1wSLxQr
         TZy/u596HtivLhLWyjFkPV76AN8YY+HHfR24vsZFE10rh9MI33+dnjS4zVS8x1Mwi0Bq
         eqNzpt5uVo0rLoM+nmWT3mgFI5Pxc02Tvbc1BWEgUkTf2oQ1XLQ7JgybwQB+KO1JpjMd
         yPew==
X-Forwarded-Encrypted: i=1; AJvYcCXgRKwzHIT54Osxn99EyPvD6njDYfruPaAEN+fFVwtn2yW6C2wy08/+leDaU3KP9BuTlcw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSfKt2331YoZ9mUkphzkmoC3MZmv+DRiIfpY9yW+ONzkx3B77r
	TJ0fiFGSCNyG9DS1QhqAMc6ufuhBVmsDwMfBS2WvjOtv7gzhpy67L4g3kZD2DIo0RBuJ7vJhZMK
	pTln90A==
X-Gm-Gg: ASbGnctBR87nZbH9DnQBd8JuIucKDP1GpRU4b3Id2i17DV27pW74P931TVsj7uPp/nB
	LD4kMPP0vhXWLt2T6dgXON5Q0MU0OnmwjqbXDY+gOXjh5GH1rlu8Jbm4oRX6vaOcageRN700gWb
	DKSo5KPYLy9v3CCh9Z5KAASNyw+YzZwan26XxKb/WnQY22/QJTnYRkk3vkQ76LWWwEhdA5wvdsw
	W7JAvbXnpubkTMswQPgxWxqY1FR3hL/g26YKt2BxMaRN3pWpshKO+2OeMOW9kWqrqNhaCIgfrX9
	FeCq2L7xjFrvCzwhT27o75OCeb/1WctJtP2NgUdhqDOTq6eOeoVR5eZkaudKqu1pXKJ1+FPKG4L
	Rf0E719NGTIDt/E3GZUTQitEk+KhjxYY/7xJsU3AlALtl7+UWTeNSvY8aXnuk/CRJzegdatN2iv
	N2p4nBIpk=
X-Google-Smtp-Source: AGHT+IEKTVVIF37bPkIThQflNdgspCKnr5NA11SiL/638zwKfmjFx69vsxi9nj2xKEonYUSVnn3lCw==
X-Received: by 2002:a05:600d:8:b0:453:65f4:f4c8 with SMTP id 5b1f17b1804b1-45b4d448136mr66735e9.3.1755721551776;
        Wed, 20 Aug 2025 13:25:51 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0748798aasm8992009f8f.14.2025.08.20.13.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 13:25:51 -0700 (PDT)
Date: Wed, 20 Aug 2025 20:25:47 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, clg@redhat.com
Subject: Re: [PATCH 2/2] vfio/platform: Mark for removal
Message-ID: <aKYvS3qgV_dW1woo@google.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
 <20250806170314.3768750-3-alex.williamson@redhat.com>
 <aJ9neYocl8sSjpOG@google.com>
 <20250818105242.4e6b96ed.alex.williamson@redhat.com>
 <aKNj4EUgHYCZ9Q4f@google.com>
 <00001486-b43d-4c2b-a41c-35ab5e823f21@redhat.com>
 <aKXnzqmz-_eR_bHF@google.com>
 <43f198b5-60f8-40f5-a2cd-ff21b31a91d4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43f198b5-60f8-40f5-a2cd-ff21b31a91d4@redhat.com>

Hi Eric,

On Wed, Aug 20, 2025 at 06:29:27PM +0200, Eric Auger wrote:
> Hi Mostafa,
> 
> On 8/20/25 5:20 PM, Mostafa Saleh wrote:
> > Hi Eric,
> >
> > On Tue, Aug 19, 2025 at 11:58:32AM +0200, Eric Auger wrote:
> >> Hi Mostafa,
> >>
> >> On 8/18/25 7:33 PM, Mostafa Saleh wrote:
> >>> On Mon, Aug 18, 2025 at 10:52:42AM -0600, Alex Williamson wrote:
> >>>> On Fri, 15 Aug 2025 16:59:37 +0000
> >>>> Mostafa Saleh <smostafa@google.com> wrote:
> >>>>
> >>>>> Hi Alex,
> >>>>>
> >>>>> On Wed, Aug 06, 2025 at 11:03:12AM -0600, Alex Williamson wrote:
> >>>>>> vfio-platform hasn't had a meaningful contribution in years.  In-tree
> >>>>>> hardware support is predominantly only for devices which are long since
> >>>>>> e-waste.  QEMU support for platform devices is slated for removal in
> >>>>>> QEMU-10.2.  Eric Auger presented on the future of the vfio-platform
> >>>>>> driver and difficulties supporting new devices at KVM Forum 2024,
> >>>>>> gaining some support for removal, some disagreement, but garnering no
> >>>>>> new hardware support, leaving the driver in a state where it cannot
> >>>>>> be tested.
> >>>>>>
> >>>>>> Mark as obsolete and subject to removal.  
> >>>>> Recently(this year) in Android, we enabled VFIO-platform for protected KVM,
> >>>>> and it’s supported in our VMM (CrosVM) [1].
> >>>>> CrosVM support is different from Qemu, as it doesn't require any device
> >>>>> specific logic in the VMM, however, it relies on loading a device tree
> >>>>> template in runtime (with “compatiable” string...) and it will just
> >>>>> override regs, irqs.. So it doesn’t need device knowledge (at least for now)
> >>>>> Similarly, the kernel doesn’t need reset drivers as the hypervisor handles that.
> >>>> I think what we attempt to achieve in vfio is repeatability and data
> >>>> integrity independent of the hypervisor.  IOW, if we 'kill -9' the
> >>>> hypervisor process, the kernel can bring the device back to a default
> >>>> state where the device isn't wedged or leaking information through the
> >>>> device to the next use case.  If the hypervisor wants to support
> >>>> enhanced resets on top of that, that's great, but I think it becomes
> >>>> difficult to argue that vfio-platform itself holds up its end of the
> >>>> bargain if we're really trusting the hypervisor to handle these aspects.
> >>> Sorry I was not clear, we only use that in Android for ARM64 and pKVM,
> >>> where the hypervisor in this context means the code running in EL2 which
> >>> is more privileged than the kernel, so it should be trusted.
> >>> However, as I mentioned that code is not upstream yet, so it's a valid
> >>> concern that the kernel still needs a reset driver.
> >>>
> >>>>> Unfortunately, there is no upstream support at the moment, we are making
> >>>>> some -slow- progress on that [2][3]
> >>>>>
> >>>>> If it helps, I have access to HW that can run that and I can review/test
> >>>>> changes, until upstream support lands; if you are open to keeping VFIO-platform.
> >>>>> Or I can look into adding support for existing upstream HW(with platforms I am
> >>>>> familiar with as Pixel-6)
> >>>> Ultimately I'll lean on Eric to make the call.  I know he's concerned
> >>>> about testing, but he raised that and various other concerns whether
> >>>> platform device really have a future with vfio nearly a year ago and
> >>>> nothing has changed.  Currently it requires a module option opt-in to
> >>>> enable devices that the kernel doesn't know how to reset.  Is that
> >>>> sufficient or should use of such a device taint the kernel?  If any
> >>>> device beyond the few e-waste devices that we know how to reset taint
> >>>> the kernel, should this support really even be in the kernel?  Thanks,
> >>> I think with the way it’s supported at the moment we need the kernel
> >>> to ensure that reset happens.
> >> Effectively my main concern is I cannot test vfio-platform anymore. We
> >> had some CVEs also impacting the vfio platform code base and it is a
> >> major issue not being able to test. That's why I was obliged, last year,
> >> to resume the integration of a new device (the tegra234 mgbe), nobody
> >> seemed to be really interested in and this work could not be upstreamed
> >> due to lack of traction and its hacky nature.
> >>
> >> You did not really comment on which kind of devices were currently
> >> integrated. Are they within the original scope of vfio (with DMA
> >> capabilities and protected by an IOMMU)? Last discussion we had in
> >> https://lore.kernel.org/all/ZvvLpLUZnj-Z_tEs@google.com/ led to the
> >> conclusion that maybe VFIO was not the best suited framework.
> > At the moment, Android device assignement only supports DMA capable
> > devices which are behind an IOMMU, and we use VFIO-platform for that,
> > most of our use cases are accelerators.
> >
> > In that thread, I was looking into adding support for simpler devices
> > (such as sensors) but as discussed that won’t be done through
> > VFIO-platform.
> >
> > Ignoring Android, as I mentioned, I can work on adding support for
> > existing upstream platforms (preferably ARM64, that I can get access to)
> > such as Pixel-6, which should make it easier to test.
> >
> > Also, we have some interest on adding new features such as run-time
> > power management.
> 
> OK fair enough. If Alex agrees then we can wait for those efforts. Also
> I think it would make sense to formalize the way you reset the devices
> (I understand the hyp does that under the hood).

I think currently - with some help from the platform bus- we can rely on
the existing shutdown method, instead of specific hooks.
As the hypervisor logic will only be for ARM64 (at least for now), I can
look more into this.

But I think the top priority would be to establish a decent platform to
test with, I will start looking into Pixel-6 (although that would need
to land IOMMU support for it upstream first). I also have a morello
board with SMMUv3, but I think it's all PCI.

> >
> >> In case we keep the driver in, I think we need to get a garantee that
> >> you or someone else at Google commits to review and test potential
> >> changes with a perspective to take over its maintenance.
> > I can’t make guarantees on behalf of Google, but I can contribute in
> > reviewing/testing/maintenance of the driver as far as I am able to.
> > If you want, you can add me as reviewer to the driver.
> 
> I understand. I think the usual way then is for you to send a patch to
> update the Maintainers file.

I see, I will send one shortly.

Thanks,
Mostafa

> 
> Thanks
> 
> Eric
> >
> > Thanks,
> > Mostafa
> >
> >
> >> Thanks
> >>
> >> Eric
> >>
> >>> But maybe instead of having that specific reset handler for VFIO, we
> >>> can rely on the “shutdown” method already existing in "platform_driver"?
> >>> I believe that should put the device in a state where it can be re-probed
> >>> safely. Although not all devices implement that but it seems more generic
> >>> and scalable.
> >>>
> >>> Thanks,
> >>> Mostafa
> >>>
> >>>> Alex
> >>>>
> 

