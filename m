Return-Path: <kvm+bounces-22962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D37E0945010
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02E9F1C25B2D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 16:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FAF1B3F05;
	Thu,  1 Aug 2024 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kcfX3WJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9914F1B3746
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 16:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722528306; cv=none; b=anxORZDuxUay96tJtpx8Yoi2EDD7BaoygJ7RMXxXQyosgKE+8nLjW7tqQHnF2gnq7IgKep5GGCR7euzPntH7dAm4ZsIjBmEvNAGDEmluTZztHg9P+0eeujDpFf3/hBs/h6qhK46tUSMpWmHj3x0D3tHneczhl8GYb7kibgt3ars=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722528306; c=relaxed/simple;
	bh=jxO76APjkaVOyCuBvkQNexapyYJLTmyCs55bVSIM1fI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kgc93/Y0Sy2EEApPj94ocN6ECNGfZUSlY+I92WxvXcwnByZBCZa1q2ZQQilzMBPARzlEEz0SzkWo0C4FFjtqQaTQURtWUCfwCQi6GT3J/f1WmRS6W3DiYeE2ds6J/3YV0MCe8hq4Y223/i3I90NBt2iLCH61a6MrBA/GIJoq5aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kcfX3WJ3; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a20de39cfbso9387048a12.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 09:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722528303; x=1723133103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UraJEAGUMpzljakCtRMmTiDbLKttts3ShtT7iKqW2eQ=;
        b=kcfX3WJ3c/3TAeH+VWzKRG2IDzTCE5IGcjONBs4PgSbkL258hgLuSIxuE4f6mic+vt
         bz48n/P5ngqwtaaZlilWrNuwuctjqoW5/OlsrYuv6w4SHc4PSSVl0buoswZ81nlBG783
         Zg+88kz9AEmTaKYuUU12HT0WUOzfkt5rn6m9ORinsQASpy3jKZBhM2M7r/YQoYy6AY10
         gA0FHAnIYqbvT8IxPa1uTy8pjxuE8fioXoinuCqfvbmXbzPdF55ZMg9y1+KGDmJ3GZQ8
         Gv0CMg89Gnaq+ExCzxa9I3pxBhClr7gQJyutc0/3EmAuwLl9otA+UpWhBgXQSMJCKGu5
         0cQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722528303; x=1723133103;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UraJEAGUMpzljakCtRMmTiDbLKttts3ShtT7iKqW2eQ=;
        b=RfdJztlcVvcUtJ/WbX5u67xvKxlQpBP96au/56ukIBNFxT+7IfA63yLS9CnZsaQOUT
         5zwNPlmc8bYWf5rP8wXR3qblOhl705YxGl/hR3WM9EEHnx2rPOMynUlsnDgqI3x/qvRr
         ZXA8R9ATCWx0inraHV3rkc5AXu+UnWVhhib2cnKLt6uyMjhQGPez0HxKQ+s5UrpqmtEt
         DwvgfXoyCvSvlree8UR4s6GHyFZgzaK8eqWrnOQT08IX/kXlDmV6Op7tYWDrzROgz9HV
         /HB+OSz9xoHW5Ypcqa27t65VR87Wip4Db1M/Y4fippkSjDdvwtitEMafaAm0BP8M4uOl
         /oxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSbka6va2qU2RKlNZ1fgdEzankSd8SLREMU1GduED8K/g6GAHTcnRZBqT58e+wpx3yjKY0UHNn9tKFCpWSuAjiuzOS
X-Gm-Message-State: AOJu0Yx9zTnd+ZNRmrZ9DyACFqdBySbGRdft152Mk06HOdop3AojyHyB
	9rZvxPJuHTnmXgJf1wkrtWHMDdpvNODyT/TLCi7KkMWny1dZAMRktWADbpvzR3g=
X-Google-Smtp-Source: AGHT+IGQheyAl83OGQCgDvJX1Qq8gYqzJ54QT7zQyOcPCVmA/8NmGImxlX4P5CkAk0dPsdGHHNmHrQ==
X-Received: by 2002:a17:906:c10a:b0:a6e:f7bc:dcab with SMTP id a640c23a62f3a-a7dc50a47cemr50816366b.65.1722528302383;
        Thu, 01 Aug 2024 09:05:02 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acadbb910sm919959766b.225.2024.08.01.09.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 09:05:01 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id AF1225F7AD;
	Thu,  1 Aug 2024 17:05:00 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Cleber Rosa <crosa@redhat.com>
Cc: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,
  qemu-devel@nongnu.org,  Peter
 Maydell <peter.maydell@linaro.org>,  Thomas Huth <thuth@redhat.com>,
  Beraldo Leal <bleal@redhat.com>,  Sriram Yagnaraman
 <sriram.yagnaraman@ericsson.com>,  David Woodhouse <dwmw2@infradead.org>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Leif
 Lindholm
 <quic_llindhol@quicinc.com>,  Jiaxun Yang <jiaxun.yang@flygoat.com>,
  kvm@vger.kernel.org,  Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
  Wainer dos Santos Moschetta <wainersm@redhat.com>,  qemu-arm@nongnu.org,
  Radoslaw Biernacki <rad@semihalf.com>,  Paul Durrant <paul@xen.org>,
  Paolo Bonzini <pbonzini@redhat.com>,  Akihiko Odaki
 <akihiko.odaki@daynix.com>
Subject: Re: [PATCH 06/13] tests/avocado: use more distinct names for assets
In-Reply-To: <CA+bd_6JjpHe=DJZMJb7x-bu_-i8X2Z4LCuk-Mz-2_LbqtUKYNQ@mail.gmail.com>
	(Cleber Rosa's message of "Wed, 31 Jul 2024 23:12:34 -0400")
References: <20240726134438.14720-1-crosa@redhat.com>
	<20240726134438.14720-7-crosa@redhat.com>
	<ZqdzqnpKja7Xo-Yc@redhat.com>
	<CA+bd_6JjpHe=DJZMJb7x-bu_-i8X2Z4LCuk-Mz-2_LbqtUKYNQ@mail.gmail.com>
Date: Thu, 01 Aug 2024 17:05:00 +0100
Message-ID: <87sevocjpv.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Cleber Rosa <crosa@redhat.com> writes:

> On Mon, Jul 29, 2024 at 6:49=E2=80=AFAM Daniel P. Berrang=C3=A9 <berrange=
@redhat.com> wrote:
>>
>> On Fri, Jul 26, 2024 at 09:44:31AM -0400, Cleber Rosa wrote:
>> > Avocado's asset system will deposit files in a cache organized either
>> > by their original location (the URI) or by their names.  Because the
>> > cache (and the "by_name" sub directory) is common across tests, it's a
>> > good idea to make these names as distinct as possible.
>> >
>> > This avoid name clashes, which makes future Avocado runs to attempt to
>> > redownload the assets with the same name, but from the different
>> > locations they actually are from.  This causes cache misses, extra
>> > downloads, and possibly canceled tests.
>> >
>> > Signed-off-by: Cleber Rosa <crosa@redhat.com>
>> > ---
>> >  tests/avocado/kvm_xen_guest.py  | 3 ++-
>> >  tests/avocado/netdev-ethtool.py | 3 ++-
>> >  2 files changed, 4 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_gu=
est.py
>> > index f8cb458d5d..318fadebc3 100644
>> > --- a/tests/avocado/kvm_xen_guest.py
>> > +++ b/tests/avocado/kvm_xen_guest.py
>> > @@ -40,7 +40,8 @@ def get_asset(self, name, sha1):
>> >          url =3D base_url + name
>> >          # use explicit name rather than failing to neatly parse the
>> >          # URL into a unique one
>> > -        return self.fetch_asset(name=3Dname, locations=3D(url), asset=
_hash=3Dsha1)
>> > +        return self.fetch_asset(name=3Df"qemu-kvm-xen-guest-{name}",
>> > +                                locations=3D(url), asset_hash=3Dsha1)
>>
>> Why do we need to pass a name here at all ? I see the comment here
>> but it isn't very clear about what the problem is. It just feels
>> wrong to be creating ourselves uniqueness naming problems, when we
>> have a nicely unique URL, and that cached URL can be shared across
>> tests, where as the custom names added by this patch are forcing
>> no-caching of the same URL between tests.
>>
>
> Now with your comment, I do agree that this adds some unneeded
> maintenance burden indeed.  Also, this was part of my pre-avocado bump
> patches that would work around issues present in < 103.0.  But let me
> give the complete answer.
>
> Under 88.1 the "uniqueness" of the URL did not consider the query
> parameters in the URL.  So, under 88.1:
>
>    avocado.utils.asset.Asset(name=3D'bzImage',
> locations=3D['https://fileserver.linaro.org/s/kE4nCFLdQcoBF9t/download?pa=
th=3D%2Fkvm-xen-guest&files=3DbzImage',
> ...)
>    avocado.utils.asset.Asset(name=3D'bzImage',
> locations=3D['https://fileserver.linaro.org/s/kE4nCFLdQcoBF9t/download?pa=
th=3D%2Fnetdev-ethtool&files=3DbzImage',
> ...)

This is mostly a hack to avoid having to tell NextCloud to generate a
unique sharing URL for every file.

>
> Would save content to the same location:
> /tmp/cache_old/by_location/2a8ecd750eb952504ad96b89576207afe1be6a8f/downl=
oad.
>
> This is no longer the case on 103.0 (actually since 92.0), the
> contents of those exact assets would be saved to
> '/by_location/415c998a0061347e5115da53d57ea92c908a2e7f/path=3D%2Fkvm-xen-=
guest&files=3DbzImage'
> and /by_location/415c998a0061347e5115da53d57ea92c908a2e7f/path=3D%2Fnetde=
v-ethtool&files=3DbzImage'.
>
> I personally don't like having the files named, although uniquely,
> after the query parameters.  But, If this doesn't bother others more
> than the maintenance burden, and Avocado version bump is applied, this
> patch can be dropped.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

