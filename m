Return-Path: <kvm+bounces-63252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3110FC5F3F2
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFAC33A9E1D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2489134AAFB;
	Fri, 14 Nov 2025 20:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EF66oFoZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5E2335547
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763152364; cv=none; b=S6RNrjt0RY6da8cm9xAIDbKZMExx6b0lkJMJ8JgIrq6y/65QJvtnMk80n+r7n0x5mGhyX3Ovy310wURfiubQJsYGRIixWcxqxmX0Y5577tUarIcxeET9x6gPEJh/E0Ftpl4emH3idgIDcT764LTslYXm6Jyk4cVY80Hw2VokxgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763152364; c=relaxed/simple;
	bh=qMVXn0/pBxfD94D7ztw7lMcKOUUwJxhPmOMbkqfJm7c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cW3oFCq7WbT5vX+CwoqsNuPGMloe+fV7UW89qKk3wr6rKVgLK1UH5pHQ/hkaAtM3HtPb00pV15Rv8dJjK6FKj8tip9vH4VFtU0qtXat8i7uTzctcUyOq7iG/9mjmcDQJfzdDuwi1yoDWuzXXKkxQcejfUre3B1cPjxlXnMI77og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EF66oFoZ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47790b080e4so5100965e9.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763152361; x=1763757161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wB/JsODbft6bUwFY61gbtF9VSesiLo/SIsj+xEcELmM=;
        b=EF66oFoZLxzphJYbIXAS/TUYZLEBAJyvXKCd4PIFvC90eHOkT2LxM0EPtRpytP4XYE
         HobF4I2ubvWDYPKcY5sO/K7nhwcPWziHkr9qhmWt1e67EM354/od+kal8thtf9S1dNxn
         FmynrsR6Cb3UcCf+7ziEe6z+HHfLTV/a//XHRwiQwBMP8/G3SlHGwCNaUHp1Ba6YGA8p
         58RFe5vFdhpCZHBrEbiStQSR/FTzl6c+a4dzJ5ksKfNmHvrvp/ii16Lao74zepqIswoH
         l5W60Dr+0z97DyCeV29UfaaxK21g9jTnx7vUes7uAqw/Krz4Sw1XszXkskRW8bfcrc2i
         mPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763152361; x=1763757161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wB/JsODbft6bUwFY61gbtF9VSesiLo/SIsj+xEcELmM=;
        b=SgbkcexZ3ki2o0YHvfTgdCUi7NpR4Qg4ITSKKQwVAZjY5gAZwKjMXlEZ6x1obv9KUw
         BjW2dEFwtZeToz8ZPkL+I2otQ0OzGbQUbcqmsjr6BDnEveJJS7XIsretQoMXQJJKlJRk
         m8c2jqjU0KrrKFXuhNuzaUOc4Skt901CWRM5vkvJB6YFPEom9WnO7KSpBNouKAcnBaf3
         93rDn+Sb1cYZ2a3zJKS7Eh4KksAbppEp4pK/QhVePxwyCebD+YA5ExTgjWN61WQ5mrZ7
         nA7c853n1XmUbudWg75Tra3oL5Hv2EnZibf4Y7vKRzyBIe25PdfNeuhx79LQ3JPbhZXp
         5OAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeIodRIGWz3lUpgiFvsoKydE59z3HMoVSXy4LPiWM9zHi81zCIcQ9VYOmBIM/LmL3vPMk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMVMdpHuhQK3RcXgvoz68exGdouCFGQEiL6OkXbjv+AZETCGWy
	uLz1VYfmy5+ob4q7ho5NPqOPiUaWGDm24yUhgZdiTm+8OXBKlLksAgFN
X-Gm-Gg: ASbGncs1kFk0o276LyvA0QhV8FZ/TxPNFmJ2tVWZ/eBNvVhaA+i4rVJ9sPL2OXg5idj
	amJsm2fxO9bKr4+bAL1hcEvKVv0tMDSu4ufY5yHiP7swkgiv9RzYuBf7xsppmiBmjnGyrq25vlG
	h0TnRX2MecCV6MoWc8qc4SapEEt31DejppWqkvqWcQkZNT/L1i4Ya8jhVYFyLs3r2WiYcR6yyn3
	THmvZMOmOgro27FNiarAzj1KAn4+PUKRYwoD9x4wdlUW3tWVYRmwY1l9DEuNwZ/JQDry8YK4xEx
	j/Gu+p3RzxMen4b3aPwlINeNc0od+70Ol3B3+7qeBGmYTSIVygBqBS6CvkDLP2unN52KnzdKgqz
	i17fuBvc+KPGamjLbFa2mUgIzKgdUy6n64Ybnen0aRvmH2TH9Ym91jS1EtAEHkX4g/mOqMZOidx
	So5KEM/RSJdIHlbZzUxsbycZmzWK2gVd2ixKqeIxcf3jReka/XaQRx
X-Google-Smtp-Source: AGHT+IGJLwKUUv/e7XeLeB5KiDfpWDJD0SeEvFpkKuz3Fu0ygR96nzPtknGu6NvJHta64Jve5dWi4Q==
X-Received: by 2002:a05:600c:35c1:b0:477:54f9:6ac2 with SMTP id 5b1f17b1804b1-4778fe1170fmr49088345e9.0.1763152360456;
        Fri, 14 Nov 2025 12:32:40 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4778bb2f9c8sm54699595e9.1.2025.11.14.12.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 12:32:40 -0800 (PST)
Date: Fri, 14 Nov 2025 20:32:38 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jon Kohler <jon@nutanix.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "virtualization@lists.linux.dev"
 <virtualization@lists.linux.dev>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Sean
 Christopherson <seanjc@google.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user()
 and put_user()
Message-ID: <20251114203238.51123933@pumpkin>
In-Reply-To: <2CD22CA1-FAFA-493A-8F41-A5798C33D103@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
	<20251114185424.354133ae@pumpkin>
	<2CD22CA1-FAFA-493A-8F41-A5798C33D103@nutanix.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Nov 2025 19:30:32 +0000
Jon Kohler <jon@nutanix.com> wrote:

> > On Nov 14, 2025, at 1:54=E2=80=AFPM, David Laight <david.laight.linux@g=
mail.com> wrote:
> >=20
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> >=20
> > |-------------------------------------------------------------------!
> >=20
> > On Wed, 12 Nov 2025 17:55:28 -0700
> > Jon Kohler <jon@nutanix.com> wrote:
> >  =20
> >> vhost_get_user and vhost_put_user leverage __get_user and __put_user,
> >> respectively, which were both added in 2016 by commit 6b1e6cc7855b
> >> ("vhost: new device IOTLB API"). In a heavy UDP transmit workload on a
> >> vhost-net backed tap device, these functions showed up as ~11.6% of
> >> samples in a flamegraph of the underlying vhost worker thread.
> >>=20
> >> Quoting Linus from [1]:
> >>    Anyway, every single __get_user() call I looked at looked like
> >>    historical garbage. [...] End result: I get the feeling that we
> >>    should just do a global search-and-replace of the __get_user/
> >>    __put_user users, replace them with plain get_user/put_user instead,
> >>    and then fix up any fallout (eg the coco code).
> >>=20
> >> Switch to plain get_user/put_user in vhost, which results in a slight
> >> throughput speedup. get_user now about ~8.4% of samples in flamegraph.
> >>=20
> >> Basic iperf3 test on a Intel 5416S CPU with Ubuntu 25.10 guest:
> >> TX: taskset -c 2 iperf3 -c <rx_ip> -t 60 -p 5200 -b 0 -u -i 5
> >> RX: taskset -c 2 iperf3 -s -p 5200 -D
> >> Before: 6.08 Gbits/sec
> >> After:  6.32 Gbits/sec
> >>=20
> >> As to what drives the speedup, Sean's patch [2] explains:
> >> Use the normal, checked versions for get_user() and put_user() instead=
 of
> >> the double-underscore versions that omit range checks, as the checked
> >> versions are actually measurably faster on modern CPUs (12%+ on Intel,
> >> 25%+ on AMD). =20
> >=20
> > Is there an associated access_ok() that can also be removed?
> >=20
> > David =20
>=20
> Hey David - IIUC, the access_ok() for non-iotlb setups is done at
> initial setup time, not per event, see vhost_vring_set_addr and
> for the vhost net side see vhost_net_set_backend ->=20
> vhost_vq_access_ok.

This is a long way away from the actual access....

The early 'sanity check' might be worth keeping, but the code has to
allow for the user access faulting (the application might unmap it).
But, in some sense, that early check is optimising for the user passing
in an invalid buffer - so not actually worth while,

> Will lean on MST/Jason to help sanity check my understanding.
>=20
> In the iotlb case, that=E2=80=99s handled differently (Jason can speak to
> that side), but I dont think there is something we=E2=80=99d remove there?

Isn't the application side much the same?
(But I don't know what the code is doing...)

	David


