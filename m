Return-Path: <kvm+bounces-55186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 365D8B2E145
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A4C5AA0D1D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DADC36CDFA;
	Wed, 20 Aug 2025 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SgoHmM9h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F284C79
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755703254; cv=none; b=LBA6z2cV6WpCiytSGdC105cUR8+WZeMf1ddqVxJ5iHv8MR2rwHREdxph6biyPVgycb/Rc+wFRaGrH6uyxTk5Yx+9z196NjIICxLVs14zZ5Udgxy118EOtOVF5OSgTOgfPshcHXjaDf08NfeCIDDvPJ8d2VssW/hnn95k61O5PAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755703254; c=relaxed/simple;
	bh=0bZvZYS9s2jX6y1GAKLoPjJDjeA0CTDi70lq2ZGXSPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyxcEGsbm9tAkmuZg9P1SkYABQ6fb2Je40UpJ3er6T33W29nA/5YLdZpwN9oY6nMQ9UHIPXwOiFQZLeFO7xSt6HTC6kPusuiON4PIzKdzSMdMhuEXFH5SohJDoc4jEkQyi/bRPwE0ovoeBtMZgasQ8wwBRQR15SiZZJP9cn5Aaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SgoHmM9h; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-459fbca0c95so83755e9.0
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 08:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755703251; x=1756308051; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+YDKy9i3ncAbaTgT7u8xeWeVkpVkjWYasBtQm8LcTCc=;
        b=SgoHmM9h5HCx7mMEICb8H3cyeaxcWWeg6g1ffUjY/4FWfiX9tNQ6rB9IalvrknvRS2
         o+OUfHXAR3AqKkegaDycgRY/pciLjUDNTBLqor8I0lJlcs9NZuwge52AP9UqV/3uysMT
         j2DYZ4TZLU4gZTVH1fNUk29m7MmOjR51JRl9qlQm9JD2BaQLN7UAeB9WuHNxrTpvp/JO
         auhBeToDc+7MdSdZr5/h062LBAlfUj+whPCFGNq9Fde76OE34ETGCrGt3HBDlgolFWoB
         sfpPqTzCrGyt4pN7G5EzBkPVdBbOZMcomyWA4s3ebnp85d6kMgOr/sBEcnWDlA00fbg3
         COng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755703251; x=1756308051;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+YDKy9i3ncAbaTgT7u8xeWeVkpVkjWYasBtQm8LcTCc=;
        b=EyEI+Nl+qvEA/leX1vlS7JlqIcW7d/oJhUbDDj4I9/r6J1z1HeNu7sQa4fuV59Ghux
         M4j8zT3wacoLLyDoUmUytL2N65IKgVeabVmubCaEGrQOmEIYGb/raFr3CzNDro6KStxb
         Se4sCsyX2u/QfBroiGoYmjuijGZmCxhZDJnZHVntpbsTJ0sOKoT4QRzQWqlYUvpHmFFq
         rr2NALffWfXQhdSEe//3gTZoOQxLArZYSaLvQMZcQbpXtMNI3cYf8w0g9SBHSdev3SGi
         M1fcg180j9sW170lk6GMHH6YVR/zLYIbSmsTAXpaDiSrX998s4uVMI7BiMyv1Mgwphyj
         sUFg==
X-Forwarded-Encrypted: i=1; AJvYcCU2/ntBzQpkzQ/N5i09iT5qvNNV8NMHku+x9RvRhnm0B8kxeqal2Q0QAjqWYWUnRdnJHUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkproidYKYResapxAh3UThkiw5yIXxnZVwbMLZ5KMk2ati/BR3
	r2E6oowUhrsacHA8U9xOgv6kUhqQ6+x+oLesq3bL3M4z89VO+GcRfFFpOV6mLRm1+g==
X-Gm-Gg: ASbGnctM5LjNbOzwBHdDS7gdjeu2Wp5Czc8ZQz8qITijHEMGzmzj+aBuyhO+b1wh30a
	jqly/FfZoUs50O4m0YKMQUoWo65bdRBBLSBRa8OHMgMKuwcOfqAKcB1c58h5gNFlz3G0UH21YcP
	DQko40q42s0vTtt+nKBm1WWfoqGPkd1x/SXLIM1dpccrO+0ue25A2qP25YqAnHHfzA5lvq5/dDl
	h00q+LfhBN+XEjqhqAjzRwlYBD+/qZfoyhJ4HshisKsxoFTC0mowRywUqqZxqSiKP8kc0bbqb4d
	TVi9bUE7U44po+Nx8/8DO7krpBIQ7QXlCK2l6YgBwYXjHqHz2fFEWEywFIRyjRuhlPmZiEN+yLV
	zF/nT+TYYSx6K9ljkD2u8aRZpidJRnC+gsYuEqPixbnZR96g8j+ZxAdZ1qSsu5HaNJRILuUVVma
	iJZ2EZu2A=
X-Google-Smtp-Source: AGHT+IHiVUmKWmbeGVe4wLPGpXZ8FAgvxdhW8nnAp+Y57PnzSAc9NGmVxe3RHH4iM/BLWgj4HeE6zw==
X-Received: by 2002:a05:600c:c04b:10b0:458:92d5:3070 with SMTP id 5b1f17b1804b1-45b4777c1d5mr1323255e9.6.1755703250819;
        Wed, 20 Aug 2025 08:20:50 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c1a6asm8297183f8f.44.2025.08.20.08.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 08:20:50 -0700 (PDT)
Date: Wed, 20 Aug 2025 15:20:46 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, clg@redhat.com
Subject: Re: [PATCH 2/2] vfio/platform: Mark for removal
Message-ID: <aKXnzqmz-_eR_bHF@google.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
 <20250806170314.3768750-3-alex.williamson@redhat.com>
 <aJ9neYocl8sSjpOG@google.com>
 <20250818105242.4e6b96ed.alex.williamson@redhat.com>
 <aKNj4EUgHYCZ9Q4f@google.com>
 <00001486-b43d-4c2b-a41c-35ab5e823f21@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00001486-b43d-4c2b-a41c-35ab5e823f21@redhat.com>

Hi Eric,

On Tue, Aug 19, 2025 at 11:58:32AM +0200, Eric Auger wrote:
> Hi Mostafa,
> 
> On 8/18/25 7:33 PM, Mostafa Saleh wrote:
> > On Mon, Aug 18, 2025 at 10:52:42AM -0600, Alex Williamson wrote:
> >> On Fri, 15 Aug 2025 16:59:37 +0000
> >> Mostafa Saleh <smostafa@google.com> wrote:
> >>
> >>> Hi Alex,
> >>>
> >>> On Wed, Aug 06, 2025 at 11:03:12AM -0600, Alex Williamson wrote:
> >>>> vfio-platform hasn't had a meaningful contribution in years.  In-tree
> >>>> hardware support is predominantly only for devices which are long since
> >>>> e-waste.  QEMU support for platform devices is slated for removal in
> >>>> QEMU-10.2.  Eric Auger presented on the future of the vfio-platform
> >>>> driver and difficulties supporting new devices at KVM Forum 2024,
> >>>> gaining some support for removal, some disagreement, but garnering no
> >>>> new hardware support, leaving the driver in a state where it cannot
> >>>> be tested.
> >>>>
> >>>> Mark as obsolete and subject to removal.  
> >>> Recently(this year) in Android, we enabled VFIO-platform for protected KVM,
> >>> and it’s supported in our VMM (CrosVM) [1].
> >>> CrosVM support is different from Qemu, as it doesn't require any device
> >>> specific logic in the VMM, however, it relies on loading a device tree
> >>> template in runtime (with “compatiable” string...) and it will just
> >>> override regs, irqs.. So it doesn’t need device knowledge (at least for now)
> >>> Similarly, the kernel doesn’t need reset drivers as the hypervisor handles that.
> >> I think what we attempt to achieve in vfio is repeatability and data
> >> integrity independent of the hypervisor.  IOW, if we 'kill -9' the
> >> hypervisor process, the kernel can bring the device back to a default
> >> state where the device isn't wedged or leaking information through the
> >> device to the next use case.  If the hypervisor wants to support
> >> enhanced resets on top of that, that's great, but I think it becomes
> >> difficult to argue that vfio-platform itself holds up its end of the
> >> bargain if we're really trusting the hypervisor to handle these aspects.
> > Sorry I was not clear, we only use that in Android for ARM64 and pKVM,
> > where the hypervisor in this context means the code running in EL2 which
> > is more privileged than the kernel, so it should be trusted.
> > However, as I mentioned that code is not upstream yet, so it's a valid
> > concern that the kernel still needs a reset driver.
> >
> >>> Unfortunately, there is no upstream support at the moment, we are making
> >>> some -slow- progress on that [2][3]
> >>>
> >>> If it helps, I have access to HW that can run that and I can review/test
> >>> changes, until upstream support lands; if you are open to keeping VFIO-platform.
> >>> Or I can look into adding support for existing upstream HW(with platforms I am
> >>> familiar with as Pixel-6)
> >> Ultimately I'll lean on Eric to make the call.  I know he's concerned
> >> about testing, but he raised that and various other concerns whether
> >> platform device really have a future with vfio nearly a year ago and
> >> nothing has changed.  Currently it requires a module option opt-in to
> >> enable devices that the kernel doesn't know how to reset.  Is that
> >> sufficient or should use of such a device taint the kernel?  If any
> >> device beyond the few e-waste devices that we know how to reset taint
> >> the kernel, should this support really even be in the kernel?  Thanks,
> > I think with the way it’s supported at the moment we need the kernel
> > to ensure that reset happens.
> 
> Effectively my main concern is I cannot test vfio-platform anymore. We
> had some CVEs also impacting the vfio platform code base and it is a
> major issue not being able to test. That's why I was obliged, last year,
> to resume the integration of a new device (the tegra234 mgbe), nobody
> seemed to be really interested in and this work could not be upstreamed
> due to lack of traction and its hacky nature.
> 
> You did not really comment on which kind of devices were currently
> integrated. Are they within the original scope of vfio (with DMA
> capabilities and protected by an IOMMU)? Last discussion we had in
> https://lore.kernel.org/all/ZvvLpLUZnj-Z_tEs@google.com/ led to the
> conclusion that maybe VFIO was not the best suited framework.

At the moment, Android device assignement only supports DMA capable
devices which are behind an IOMMU, and we use VFIO-platform for that,
most of our use cases are accelerators.

In that thread, I was looking into adding support for simpler devices
(such as sensors) but as discussed that won’t be done through
VFIO-platform.

Ignoring Android, as I mentioned, I can work on adding support for
existing upstream platforms (preferably ARM64, that I can get access to)
such as Pixel-6, which should make it easier to test.

Also, we have some interest on adding new features such as run-time
power management.

>
> In case we keep the driver in, I think we need to get a garantee that
> you or someone else at Google commits to review and test potential
> changes with a perspective to take over its maintenance.

I can’t make guarantees on behalf of Google, but I can contribute in
reviewing/testing/maintenance of the driver as far as I am able to.
If you want, you can add me as reviewer to the driver.

Thanks,
Mostafa


> 
> Thanks
> 
> Eric
> 
> >
> > But maybe instead of having that specific reset handler for VFIO, we
> > can rely on the “shutdown” method already existing in "platform_driver"?
> > I believe that should put the device in a state where it can be re-probed
> > safely. Although not all devices implement that but it seems more generic
> > and scalable.
> >
> > Thanks,
> > Mostafa
> >
> >> Alex
> >>
> 

