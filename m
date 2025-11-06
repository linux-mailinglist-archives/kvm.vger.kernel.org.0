Return-Path: <kvm+bounces-62226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D5A7C3C8E3
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D30BF188D8E2
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDC7303C88;
	Thu,  6 Nov 2025 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hl7064yz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654192494FF
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447413; cv=none; b=mOtVpNQ0okiahsthlQ654nrhSigThIwJMNkq5vUnf6ufwyX6yxt2ne+W4VpWZa8jWVYJWmUq6Ie1OB5IfQuK7s5sMcknn1GgQHGNuwqgHtFoCQ8Y1WYk8zs5Inj8kpOnU2k0ZfWBJ7DXHVC1yourFzzLwzeyCMb4wIehQGuclHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447413; c=relaxed/simple;
	bh=23KhdHrGNqhSoczMRBVuAoklJQ3W5i54MPFbE3H6OhU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mik9WUEaJAujLX86c52cjpM2rkYIrXpl8iGAR/3D8mpkGCcphMnvOPmesbbS7Df+Jn85QY44mfb3fkvHmFn0u+Tiqhr9pwOY1SkLRfnW08X8sU8YXCrrGzU+wLpLAF1iETu/XgF9652kT1LmlEv9JFimLn5eBAL/+BFVS4BQU+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hl7064yz; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ed67a143c5so397031cf.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 08:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762447411; x=1763052211; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23KhdHrGNqhSoczMRBVuAoklJQ3W5i54MPFbE3H6OhU=;
        b=hl7064yztkQzRpmThdGygVZywIdETCmrZbQ20VPWfKvAEM9fKqqtZy4pmXCka+b5pb
         1A5p1MdV7Z7Fv4LZl7+/anD+niGZ3m85cJXDsZCcdaI8z1Dj3DiETSSU92CNCluXzxFL
         FfUnDa9rvkm5vTL2X7LxYo6lw7aS6FAMoAu3PeE0cLvejOuerhvOyDZp/ADZtTHZofel
         7cNgY2+i9j+Rq/2+49tz1nTVZQAGiR3yIrtl09rLTI4T89O+bj/ie/LMd3HxMNfQ9PuW
         Ywis0WHEAtmucRSCOnVICod/AX1/9FJbGYt5wIBJ4K8gfI1z+hNJQYATEVkqgneCPd6G
         aMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447411; x=1763052211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=23KhdHrGNqhSoczMRBVuAoklJQ3W5i54MPFbE3H6OhU=;
        b=Dc48DM5op5DtIFZd6Vmm3eVNv+O761XRUQkg/DfEByU9dt3JnVtmFqwzBMq/a9YoIB
         Q3P5VG2pQWUQr2Xebt3MfldPdyg1GuCajAb9mhtxJ1nWh8vLYNPsTfCam2ePWXOkCTvL
         3y7m2jeDLOhAMK1Z0L5QSsAEl2kPrj8fZlAhr19vsy5TbUraXWC1Zc6TD/ECEAz1XHhN
         h0+wHN7PBeuLFRQA9CTODZq3PBJ9vQlSTvwLGeT0PXohF2Y/9RjMLyLCi1AWRewhjL0D
         O01fhQ0MLFAK4yUItTkFZF6O7vu7U94NKfBOTouch39mJR1cZLUwSUiBjMcTe4bTczRg
         Vx7A==
X-Forwarded-Encrypted: i=1; AJvYcCW73XprQMC8pKYVttNYUFYeerBVVyR0rPyWjj0nzkCakE6S27j1cEc552qPQ3dlgwv34Bw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yynk/gdc/O3zVe97rU1O5zXUOHIpwIHcFyB5akymdZ198iCpCdM
	OEsPHw17XSO1pkW9tKzxmhsKqcQtwyaSGix2qOpUHeOK5s33YB+wCh1tuixTmMwrwRyIDaev8Nd
	JSzFE9iHziEZsyydOWPthN1IC93iAzq1VkFSvULve
X-Gm-Gg: ASbGncvHbPGuDYaK17F0ppF78L00Cbylp3LXUBpDvW/d+g3+tuCTXftyY5/hYdCl5QI
	LBsGOoM8cwlm8NM6oZGDY0DMiF6v7TpHvMjla7Ocbs3PXZcbPOWeqAHx91DJPRZej/eKUK3s1Ya
	W/nMk2WRp4Gh+O26ueFZGyfJHwM47jzx4BCTCSjLPSB665Zf3hXHt12x1nqg9ZYXsfpJotDQXVq
	TBB0KlNhBDbzBpKUVG7uEyWzWzUOb2B/JWiF+rJ34iV6A5vTcZsEb9J2Q3TpyquemdZMUs=
X-Google-Smtp-Source: AGHT+IHFNLGTMhkyLgALgSkUpZLbDK3FpgsatbT6pzX6mKoR91iR99UbhzJfyxnc3EJI3tbpMq2dKzN5z2548rdYrpY=
X-Received: by 2002:ac8:7f15:0:b0:4e4:f2b9:55aa with SMTP id
 d75a77b69052e-4ed82be2324mr7226371cf.17.1762447411075; Thu, 06 Nov 2025
 08:43:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com> <20251104003536.3601931-3-rananta@google.com>
 <aQvu1c8Hb8i-JxXd@google.com>
In-Reply-To: <aQvu1c8Hb8i-JxXd@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 6 Nov 2025 22:13:18 +0530
X-Gm-Features: AWmQ_bm7AruMQuRGa1cc38uouBoYuXGFOfqLovOg7UmBpX2k74LmnZs47QpcMlI
Message-ID: <CAJHc60ztBSSm4SUxxeJ-YULhdYuCHSprtns0xt_WVJPvgmtsBA@mail.gmail.com>
Subject: Re: [PATCH 2/4] vfio: selftests: Export vfio_pci_device functions
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 6:12=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> > Refactor and make the functions called under device initialization
> > public. A later patch adds a test that calls these functions to validat=
e
> > the UAPI of SR-IOV devices. Opportunistically, to test the success
> > and failure cases of the UAPI, split the functions dealing with
> > VFIO_GROUP_GET_DEVICE_FD and VFIO_DEVICE_BIND_IOMMUFD into a core
> > function and another one that asserts the ioctl. The former will be
> > used for testing the SR-IOV UAPI, hence only export these.
>
> I have a series that separates the IOMMU initialization and fields from
> struct vfio_pci_device. I suspect that will make what you are trying to
> do a lot easier.
>
> https://lore.kernel.org/kvm/20251008232531.1152035-1-dmatlack@google.com/
>
Nice! I'll take a look at it. By the way, how do we normally deal with
dependencies among series? Do we simply mention it in the
cover-letter?

> Can you take a look at it and see if it would simplifying things for
> you? Reviews would be very appreciated if so :)
Absolutely! Sorry, I have it on my TODO list to review the changes,
but didn't get a chance. I'll get to it soon. Thanks for the reminder
:)

