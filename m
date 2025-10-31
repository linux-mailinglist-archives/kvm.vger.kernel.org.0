Return-Path: <kvm+bounces-61621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 92114C22C6A
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:19:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D909C34B5C4
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042971A9F88;
	Fri, 31 Oct 2025 00:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="WR8lxUAx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B7113E02A
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761869975; cv=none; b=WgcLq3C1Jh9TBMsYC6WQ08JeR0Oimyp1/wjGQUT/fTdEgc8SZmBlWjDObuvxd0O+25DCraqDaoaKosDGclgIVhnnJH0ZB2umeFI4h4TPL94QyBxXTodkRp3hn2z+iDcNG11rZB4+Gv1SZ6e871+Mhfkq/fPXMCm0cCKqgPQ5kuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761869975; c=relaxed/simple;
	bh=8rHUYkXKPL5IW43a+4rQNutLuyHqHIoW5Z0VxJSm0u4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jWhUqKagdy26shUWFT4BKrkUowsAec/m+HPnD+LxPOJbmkVY/hBymIPee1T69xWPNbzHb+U/aFz65XApz0KnWqmxGn82vSn6li1q/HPwjzcA1HoV2I0tXGdXP+BuTLWLSTAo8SUOUQTEf8DQigqpn7lWsY50gwt//dj1grIMFw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=WR8lxUAx; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64071184811so1892503a12.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761869971; x=1762474771; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cv3Ljvf1heM/ChX+5Kbnk959i79o/ym9ON91SVXdVic=;
        b=WR8lxUAxQmD+DWLD1tgzmINQnPnyk6Vm976ZZpfc/IITPpAPs+kxbXZbaybX0nFwbv
         NP62A1PqWLovWAkXh9DGcUrXuzEEQQpxKJ3JorgCVpURG+3TKFcJ9nQy3vy+SWPmR3NS
         X8PTqprIfWt1r8qoyEIY8+qr8MTuKr8btlRjGZ2k1dZ7zM41eNj7VKyWMl1RNHRk6Zav
         0IxobgQB8mmDp07zCyQVT5Jn4zr7J1GWVIvCUjPxfK9x782d6AEE0y2XdGOLZJ5OPbNx
         xq4vRUKVwBDN8go1aAmpL3GcFErz41o/O7lOstO8c67Lob+4CzOstfEduiGJ6TAwzc5Q
         O/DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761869971; x=1762474771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cv3Ljvf1heM/ChX+5Kbnk959i79o/ym9ON91SVXdVic=;
        b=sE3FtowT+tRSukasR8VjsFlsSuIbYVsi8XPnMMJ3CEBj1fKBYJ2ei+uU+WhtYLc5i7
         ayoM7rIXzSMdZme96ivbeG8hVoamui6673pa9OrycppiBocAGK6VhRxL829QlHNUw+IP
         jOed7GCnXD2xX6QgpEdRC0aME+I/pktcjX8qNjdlhkHuLbvjDhpwGreug63mGvuH3ki2
         mGSb78xo3T1R+YCoDiC0+J9XtZeiVUfxJJlYmNqoV4C2pfJcJeG9tTJzi918l5S81AXR
         2ypedsIFu953YhseVk4lZVrgG2j9SEo0AERgOo0FyTBKD3WkuJIjHA3shrd8CcE77ezf
         wCcg==
X-Forwarded-Encrypted: i=1; AJvYcCVwvmUvRvOf/R3CwWgA6rDoNnPBlF3Tz4/MFO/4wzH83FA/TFRxYpFqzcjmVKLkPM65/+w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk5sTsRp9359wxFewZNruxBeWW4QSGDCwoUiN4AyAMlK/+bfoS
	FobugWu9z0vbg4dgkPKantgFgLz19h24eeCLooKWsmxvN4s0JDFzY/6EMDFE9m5x26NUVqsU/tx
	nDzYLUs4CsrDELQfRdriAvSgCGrtrTClSRhbqPrLVhw==
X-Gm-Gg: ASbGncsE8uzboCBDKnRNMgGgpQnAP+Rm0Cv7xqsuAuGzNlhxmavQuHXQuLUDsYJyNDG
	iiZqkb3A7zSON/GKoAyH106NjhyA0eb6nlPrJZ2ievuwNMI6DFaSkeBxqzGtYRGIqQ3FUvCoVTt
	hBRuq7+Ch3SoAFkhG6yagkbuTvmXkhzVyRG01dDu3JQO5PHEw5RyD7gUf3UBfiX2ZCSikNrEsQ8
	ZeYrpyZFa5orj7cTf/MuN9p/nvrfn2vMPh3WgmnzptN9PGOLE7ybT4utPnt/uilSSF9
X-Google-Smtp-Source: AGHT+IHAmJ5aHdM6JoD2TOJsB7BThxEoT5eo1YrDOCS0gC6NmplAKbJLD+yZsTcgPKK2dj5Dhi5gMIE8RdzNHN72sus=
X-Received: by 2002:a05:6402:13cb:b0:640:6a18:2931 with SMTP id
 4fb4d7f45d1cf-6407702dcd1mr1160377a12.29.1761869971150; Thu, 30 Oct 2025
 17:19:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251018000713.677779-1-vipinsh@google.com> <20251018000713.677779-7-vipinsh@google.com>
 <20251027134430.00007e46@linux.microsoft.com> <aQPwSltoH7rRsnV9@google.com>
In-Reply-To: <aQPwSltoH7rRsnV9@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 30 Oct 2025 20:18:54 -0400
X-Gm-Features: AWmQ_bmaQn5U2r87lGmHMokOwG7--caG9FTwwPKr2aHRFfrExiLwJYx42aUNdvg
Message-ID: <CA+CK2bD-E0HKsuE0SPpZqEoJyEK4=KJCBw-h1WFP7O1KEoKuNQ@mail.gmail.com>
Subject: Re: [RFC PATCH 06/21] vfio/pci: Accept live update preservation
 request for VFIO cdev
To: David Matlack <dmatlack@google.com>
Cc: Jacob Pan <jacob.pan@linux.microsoft.com>, Vipin Sharma <vipinsh@google.com>, 
	bhelgaas@google.com, alex.williamson@redhat.com, jgg@ziepe.ca, 
	graf@amazon.com, pratyush@kernel.org, gregkh@linuxfoundation.org, 
	chrisl@kernel.org, rppt@kernel.org, skhawaja@google.com, parav@nvidia.com, 
	saeedm@nvidia.com, kevin.tian@intel.com, jrhilke@google.com, david@redhat.com, 
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de, 
	junaids@google.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 7:10=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2025-10-27 01:44 PM, Jacob Pan wrote:
> > On Fri, 17 Oct 2025 17:06:58 -0700 Vipin Sharma <vipinsh@google.com> wr=
ote:
> > >  static int vfio_pci_liveupdate_retrieve(struct
> > > liveupdate_file_handler *handler, u64 data, struct file **file)
> > >  {
> > > @@ -21,10 +28,17 @@ static int vfio_pci_liveupdate_retrieve(struct
> > > liveupdate_file_handler *handler, static bool
> > > vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler
> > > *handler, struct file *file) {
> > > -   return -EOPNOTSUPP;
> > > +   struct vfio_device *device =3D vfio_device_from_file(file);
> > > +
> > > +   if (!device)
> > > +           return false;
> > > +
> > > +   guard(mutex)(&device->dev_set->lock);
> > > +   return vfio_device_cdev_opened(device);
> >
> > IIUC, vfio_device_cdev_opened(device) will only return true after
> > vfio_df_ioctl_bind_iommufd(). Where it does:
> >       device->cdev_opened =3D true;
> >
> > Does this imply that devices not bound to an iommufd cannot be
> > preserved?
>
> Event if being bound to an iommufd is required, it seems wrong to check
> it in can_preserve(), as the device can just be unbound from the iommufd
> before preserve().
>
> I think can_preserve() just needs to check if this is a VFIO cdev file,
> i.e. vfio_device_from_file() returns non-NULL.

+1, can_preserve() must be fast, as it might be called on every single
FD that is being preserved, to check if type is correct.
So, simply check if "struct file" is cdev via ops check perhaps via
and thats it. It should be a very simple operation

>
> >
> > If so, I am confused about your cover letter step #15
> > > 15. It makes usual bind iommufd and attach page table calls.
> >
> > Does it mean after restoration, we have to bind iommufd again?
>
> This is still being discussed. These are the two options currently:
>
>  - When userspace retrieves the iommufd from LUO after kexec, the kernel
>    will internally restore all VFIO cdevs and bind them to the iommufd
>    in a single step.
>
>  - Userspace will retrieve the iommufd and cdevs from LUO separately,
>    and then bind each cdev to the iommufd like they were before kexec.

