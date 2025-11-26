Return-Path: <kvm+bounces-64753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E42C8C149
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:46:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 85B344E71AF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 21:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFEF2FB0B9;
	Wed, 26 Nov 2025 21:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gg81uigJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9862D8393
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 21:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764193569; cv=none; b=bGfHhZYs4aiDT8kIhV0GxULnx2H0YKiwglggJn12J18AQo9dJogqpvLle4iTXNfoR+rcPgRmYNeO2E6QLYO6KJFnyq2QE0/x/j2zy5kR90ATFFDDX65Gvn2T0YsW+H0/Ef1BAwtMoO/CFWUa9NnwHWDXbo3u1S4KqveKZk4wXcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764193569; c=relaxed/simple;
	bh=eHQD5ZWYTKJ5pBQ2l+KQFGoT1AEPijvyxf4X4cwZ+8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TDRIgFaQIKgyO0/4uq/dP66r4vHN8rn2GApnRJgdLV23OqJIEgCtYgpDE5D1cRPPsZ0BmC8HZ3mJrPOh1ScQham4Hkd4N9qIVtqjEYSRhcuyJ5H/zoZdufVgbdsjmtqIWj8pCZgo+5ADbLtDI9olNpVP8Ub6fEwVt11eBNRFD/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gg81uigJ; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b737502f77bso37998766b.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 13:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764193565; x=1764798365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DR4A76Dv8qf/+6WmZVEh6koqxlO2WxAmz56oNgGMFDY=;
        b=gg81uigJukUZgFx4FvmiB0bv6phOBtZXCOc1OZOI1Sw0Kyh17cNG6dSYyM4q9oexY3
         jb5DUOq1AuaiPZCkee2vJIKTQqW9bS1sTI1T0eVshE87LRyjmyKR1yLFvP3ESy2pFnTe
         tCnKqBnmXCSj3OqG75M1AGnWdkLsBIkhg3EIU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764193565; x=1764798365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DR4A76Dv8qf/+6WmZVEh6koqxlO2WxAmz56oNgGMFDY=;
        b=fbehLCBD868GAKWelVXXtJiwc9mlEGm0qTpgoEq5IvzwY7Oq+6Ea8QEpl2+Pntqg69
         cLXG2+ADlWVZbxCzVHvYhH5pGOnYSqKEku9ifbPd4SHEavyUDFqeuRfFO1rzR/OFFUUu
         Ye7iaN58MrpHtQhvuD2ryp3Sq7+0UzXszupbENg+wpFyQfTsi77loGMDXrR0BSDmaEw7
         Yn92xH4hhiTGsQfM9zcnYfKBSGKy3LOFJOziEAFdZMU8MTKyPdfdxxhIXWNw0xVKG+vd
         pfIJnnS8hKoNMi2Te0Nrw1EHzfmqEAfw2gBPz80bxNhZC+maogz0gxXMkpNiLgEnVu6g
         HpKA==
X-Forwarded-Encrypted: i=1; AJvYcCUnKbCLqBfHus3HCKfryj7Vi53hnyOAaKCeJwcCZDxl9wgWyrB95tXMKxHtskujkgVvOcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNZ1AKBc7iybxvmUxj4UHgmh16S8o9U85XDx+A45gLaObAGN+G
	xfM6adV9k4kOICdToRe1GkVSkVPuAwQuc2sHTZLfyuI9oqZryg0wao1urThfRCVBRY0YYlsx8Yi
	TWgbiYIpAcA==
X-Gm-Gg: ASbGnctR7ccQTRbKWnCtUDwgLnG7iVJv7otj+UaQFJjk048231uSFCTosmsrqJZ/zzN
	NMYkQVoqnIt3a3FXlTRq0058PibyB3QWy3y8iRjQdcSXszbvxeyxoFBe4bzqUXy7ZIYMVwl6Vpg
	rx1Q8b4M5ava9qp7Aj2C3Qucm1CiUyhlx06pGr1Ncj1kYG47wtAa5hEV5/u8P3116veTaZtcn11
	hYAOfTCley6bfDUlLPP2CchcNoKVEpgZ8vyktg5naJdE4lhWGqWgbyvQw6oIE1E0p1mLG2JcT3k
	exCS/GbndfKTiyFXS6trZ1XVSY9FuIYP2OdgjwfkBkRFq7AEQzAUl/OwpXTLPhovJYpoIanv6mO
	NMp06rjfBAt4mnvVLq+TJ9ao6EBMJhvXkK2ytEEh6KGyUKJFx4T/iCC9ZNmhEJj7E+pMSK5+Q6R
	Lctv5FoVLp+PogLOB/CEOAdjsHWfFZI2cr3f3JlNS1NaP/3c5X8kWNODar+s3j
X-Google-Smtp-Source: AGHT+IHW7xuKelLdvj6qoSni3E0TzjQ5qNryQTM95xBtLbSJ5fSztXFkRB2L6gCGUUzw1AG/8m5tBQ==
X-Received: by 2002:a17:907:6d12:b0:b6d:7288:973d with SMTP id a640c23a62f3a-b76c558fdb6mr896235766b.56.1764193565187;
        Wed, 26 Nov 2025 13:46:05 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cf0435sm1976227166b.4.2025.11.26.13.46.02
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 13:46:02 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso412793a12.3
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 13:46:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVIZg6gqxAxHG8toYICnBzWKXfkBpAHz3r1ozH91K44qHgD6+qTNph+VdGiHvviemBJbmc=@vger.kernel.org
X-Received: by 2002:a05:6402:13cb:b0:640:c454:e8 with SMTP id
 4fb4d7f45d1cf-645eb2b7f7emr8102794a12.30.1764193562184; Wed, 26 Nov 2025
 13:46:02 -0800 (PST)
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
 <32530984-cbaa-49e8-9c1e-34f04271538d@app.fastmail.com> <0D4EA459-C3E5-4557-97EB-17ABB4F817E5@nutanix.com>
In-Reply-To: <0D4EA459-C3E5-4557-97EB-17ABB4F817E5@nutanix.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Nov 2025 13:45:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiEg3yO5znyPD+soCkVi_emP=wHrRZk2sv4VS768S3a2g@mail.gmail.com>
X-Gm-Features: AWmQ_bkSLlyCoqZg3bYaZu1P_V2VILWs6lgJjJBJnYgDxxhAqc51xHDCsThFNYo
Message-ID: <CAHk-=wiEg3yO5znyPD+soCkVi_emP=wHrRZk2sv4VS768S3a2g@mail.gmail.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and put_user()
To: Jon Kohler <jon@nutanix.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jason Wang <jasowang@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, Netdev <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Drew Fustini <fustini@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2025 at 13:43, Jon Kohler <jon@nutanix.com> wrote:
>
> Linus mentioned he might get into the mix and do a bulk
> change and kill the whole thing once and for all, so I=E2=80=99m
> simply trying to help knock an incremental amount of work
> off the pile in advance of that (and reap some performance
> benefits at the same time, at least on the x86 side).

So I'm definitely going to do some bulk conversion at some point, but
honestly, I'll be a lot happier if most users already self-converted
before that, and I only end up doing a "convert unmaintained old code
that nobody really cares about".

                  Linus

