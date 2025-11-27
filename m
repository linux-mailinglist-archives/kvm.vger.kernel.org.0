Return-Path: <kvm+bounces-64799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A79C8C803
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 975FE4E6210
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2449298CC0;
	Thu, 27 Nov 2025 01:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HqmSXjv8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XltgVrtV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1666C13B284
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764205752; cv=none; b=Bnp8I/kLYV3QmSlPFC44eag5Q7e1qPvRtT2lT95VuuiDYgZJCNaO+J9kqAL3Q7DCKBoa+1GPt5A1fB/WO5Ruo71GDrE0adTUTxHah2RZbNFg1hyARnLztVP4bv5DikE/+K8FwBTM7h3AvZYojJ9F8ZX/FI2Qlh+aKE/cEtVw1dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764205752; c=relaxed/simple;
	bh=Ctofiznd8z5aUzVJ+ihEmSEYUQiQu3/ESxLKKSwVAT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aU96ZP7wZsdGRL4qoxzw28GfmZRBFCgZMjzopi9lp9HRWFaGDQ7Pp9njM0B3eVkUXoIGoorj3yuGn6HvI3BI9KaBJcWeIbTp3WVmIE56CrcXht2+E7k/wtYO/fc/Am2eAPsxWJ27ueE8Hb003C923DyCvQaQtoYnHokiLKTtNpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HqmSXjv8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XltgVrtV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764205749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+fIuq3Wp4BeebjpNpG0wUv9Qzy/8IqNgZEzWKyUeiT4=;
	b=HqmSXjv82AggGUw6Y7B2VU1v4g0HL2vaMCjFTvzQLReFR44LQXxrT4iBWGAaiKOyz7oZt9
	D7AW8AIe1hRMh1w19E5MyFQR48+3bOCYPBIIZCpRUbmoznRAF/8vmDOjmUmTnLVA6K4/bU
	yzo8voqH9FInCk5qkJaHlgnFRhiEaIQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-_SHfVF8pN5ONl8JraXO4TQ-1; Wed, 26 Nov 2025 20:09:08 -0500
X-MC-Unique: _SHfVF8pN5ONl8JraXO4TQ-1
X-Mimecast-MFC-AGG-ID: _SHfVF8pN5ONl8JraXO4TQ_1764205747
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-bcecfea0e8aso799387a12.0
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 17:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764205747; x=1764810547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fIuq3Wp4BeebjpNpG0wUv9Qzy/8IqNgZEzWKyUeiT4=;
        b=XltgVrtVIghdIp/epNCVKNNkU0mk7wOnxG6pcuhymb8WwZrbgcrwfVY3D6W/o7efin
         ob2RaqTmnlIfZRGzlJkpu+H5P+nFitRmPAcUqG9oSOcnl414+cvgHyu3R3PHMUzXo+At
         peRH9SYs4zd/FOY4LkMtcsS7VGj5fZvhTtIh5JsFJ5jyDrxIJf5GXhF1PyyNE1wgOURB
         lwNyIJF7DsWLKVBQbkOFtXYZEZROjUPQf6XZ/uh0/pKCKWSYI+9suZYbG/nruUxR/e28
         gWQwjP5tTlKdLdJimnIwZJMQJwUgmQiK/bQLkh6k5ERhjTD2cV10fxluQi9WPypVx4yP
         BJwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764205747; x=1764810547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+fIuq3Wp4BeebjpNpG0wUv9Qzy/8IqNgZEzWKyUeiT4=;
        b=vddg8qrpDPOV57FOxdQJc8RRCe3Vwx7YZWOyKDurDevbV8uM1PN8lTG4iXzZ/Fo7ln
         VMkNqQB54D0FVzc8U5mmNNjF1BixhfZXqQlpsOPxt5N/if6oDhyLDy121LZJD81KbjMG
         m/yyUQQ3QxppKIv05Drs+ktNAY5cKEtRcnh09Gq7j0Z1QO92OJju4Kkyz/gjGD66R9Pn
         blh+7daoCi0B08EE2ktvEausnGmoxqL2LCWOvciu+Ewz8YAd2aOV3fU0nKLbJJ0uAaRj
         /ASk1ESxB3YH/gSlJ0gbifoftPXqE4iQeeMvjdmYOg818NilLK+ZNKmB9ViRI4VQkvaF
         oQOw==
X-Forwarded-Encrypted: i=1; AJvYcCWAsBhxVs+vi+AIJ9jUk6YcXLJVUMpNcVQSrsl+z52tdMms+Jfxizfia8lHcGm8aQh3/mo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhgtkfxf1rUBCiUjB/YOepgrkAgvNQ8FCbO0BC4oDwlIDN3ehC
	EINIGxa0KrwhuZ73kEjBkJSTXuodisoWb0IyLnsZDXg2FiEZHtGpyfPVXuBhgxaHgG7hwrUPSxO
	V332otHLHgOXv7QtH4MCmJxSYRAC+dEYkXSG6QD8B/6wwfAgS5FHQ8Ga6wjA3ok4XWLviKl6C73
	2TIFyug9SjYB1OY9aRMQ8+mLiBcFL+
X-Gm-Gg: ASbGncubsL/SZPXRsgYAukjvV1YGV87UVvwvrhL4EiF2ct+wisRRAzC9n9GaoGGegyM
	EKxNin4sTFpgQj9fELaBMXxkKN6Ls6HDKCJrDlzpaH3BJYEM/3Z9FL6Ya/fB+f/GzMgtgxEw0Se
	qwKEWTzzXfoqFP2xVzL4O/TGBwK7taI9nfuzErK3JTVclMekAslHeqaTzRGbC2i4wR
X-Received: by 2002:a17:902:dacb:b0:269:b2e5:900d with SMTP id d9443c01a7336-29b6beebec7mr257541875ad.5.1764205747415;
        Wed, 26 Nov 2025 17:09:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPDNamYNduzNpXyT/xW1ZQEyOB0Lis20nwGLU/hQvR/oP+MQrKzzm7g4m+9/51XsOAa525fC5RiOVpei7R5uk=
X-Received: by 2002:a17:902:dacb:b0:269:b2e5:900d with SMTP id
 d9443c01a7336-29b6beebec7mr257541495ad.5.1764205746933; Wed, 26 Nov 2025
 17:09:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113005529.2494066-1-jon@nutanix.com> <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com> <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com> <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com> <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
 <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com> <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
In-Reply-To: <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 27 Nov 2025 09:08:55 +0800
X-Gm-Features: AWmQ_bnsXM38rarXUDstecHvEAw99LfY0bJMCpF_57ywtegttUxJS9KRjDg4vNQ
Message-ID: <CACGkMEshKS84YBuqyEzYuuWJqUwGML4N+5Ev6owbiPHvogO=3Q@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and put_user()
To: Jon Kohler <jon@nutanix.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, Netdev <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Drew Fustini <fustini@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 3:48=E2=80=AFAM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On Nov 26, 2025, at 5:25=E2=80=AFAM, Arnd Bergmann <arnd@arndb.de> wrot=
e:
> >
> > On Wed, Nov 26, 2025, at 07:04, Jason Wang wrote:
> >> On Wed, Nov 26, 2025 at 3:45=E2=80=AFAM Jon Kohler <jon@nutanix.com> w=
rote:
> >>>> On Nov 19, 2025, at 8:57=E2=80=AFPM, Jason Wang <jasowang@redhat.com=
> wrote:
> >>>> On Tue, Nov 18, 2025 at 1:35=E2=80=AFAM Jon Kohler <jon@nutanix.com>=
 wrote:
> >>> Same deal goes for __put_user() vs put_user by way of commit
> >>> e3aa6243434f ("ARM: 8795/1: spectre-v1.1: use put_user() for __put_us=
er()=E2=80=9D)
> >>>
> >>> Looking at arch/arm/mm/Kconfig, there are a variety of scenarios
> >>> where CONFIG_CPU_SPECTRE will be enabled automagically. Looking at
> >>> commit 252309adc81f ("ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 i=
mplementations")
> >>> it says that "ARMv8 is a superset of ARMv7", so I=E2=80=99d guess tha=
t just
> >>> about everything ARM would include this by default?
> >
> > I think the more relevant commit is for 64-bit Arm here, but this does
> > the same thing, see 84624087dd7e ("arm64: uaccess: Don't bother
> > eliding access_ok checks in __{get, put}_user").
>
> Ah! Right, this is definitely the important bit, as it makes it
> crystal clear that these are exactly the same thing. The current
> code is:
> #define get_user        __get_user
> #define put_user        __put_user
>
> So, this patch changing from __* to regular versions is a no-op
> on arm side of the house, yea?
>
> > I would think that if we change the __get_user() to get_user()
> > in this driver, the same should be done for the
> > __copy_{from,to}_user(), which similarly skips the access_ok()
> > check but not the PAN/SMAP handling.
>
> Perhaps, thats a good call out. I=E2=80=99d file that under one battle
> at a time. Let=E2=80=99s get get/put user dusted first, then go down
> that road?
>
> > In general, the access_ok()/__get_user()/__copy_from_user()
> > pattern isn't really helpful any more, as Linus already
> > explained. I can't tell from the vhost driver code whether
> > we can just drop the access_ok() here and use the plain
> > get_user()/copy_from_user(), or if it makes sense to move
> > to the newer user_access_begin()/unsafe_get_user()/
> > unsafe_copy_from_user()/user_access_end() and try optimize
> > out a few PAN/SMAP flips in the process.

Right, according to my testing in the past, PAN/SMAP is a killer for
small packet performance (PPS).

>
> In general, I think there are a few spots where we might be
> able to optimize (vhost_get_vq_desc perhaps?) as that gets
> called quite a bit and IIRC there are at least two flips
> in there that perhaps we could elide to one? An investigation
> for another day I think.

Did you mean trying to read descriptors in a batch, that would be
better and with IN_ORDER it would be even faster as a single (at most
two) copy_from_user() might work (without the need to use
user_access_begin()/user_access_end().

>
> Anyhow, with this info - Jason - is there anything else you
> can think of that we want to double click on?

Nope.

Thanks

>
> Jon


