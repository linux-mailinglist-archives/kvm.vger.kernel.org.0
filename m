Return-Path: <kvm+bounces-22827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F3F944190
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 860DF1F2305D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 03:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA1E13D285;
	Thu,  1 Aug 2024 03:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fTzcKIPu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF95738DD4
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 03:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722481970; cv=none; b=tSpc+f2NE87+WnS7TIioHojInVIaiw0W2cwaSBDN7KsZGrRCKqLRLidp37kK4SnAaIRU2MrIYDCTa/2mSjR1AnAewKVS2MBPZ65r9smYmueYsEy495Ah6NyxYbLgaxPQ3AoFDjhyBuI7Di5fZL9vWhPxJPyYJIzzKKE7tYjIbQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722481970; c=relaxed/simple;
	bh=UoiXa5CdaQqtRaCt5vz2VQF3lT2uIKSNz4Lex2X0l0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RPTLpnkGCJOPuy2pNrFz25g8WmuYkTVFrR5UKvOpegfbS5t/4K/6+v6QRNbjLmnzwFZXgwKtuLcRPa5+h87J5W32+KnW8heF1iyAQcTrHpFpAkxfaBMqGGNGl0kh69Jj+iENRsQHbx5SVmKpkL2oh+69c5xr9cYaH1nFGEg9biw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fTzcKIPu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722481967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D7AlDUN6nl/SKMwnnn5iGJ6hY5cYu+29jn1yx4r42g4=;
	b=fTzcKIPufdVSwZRl+rtH0WBwKnXCphnM2M2r5exn1TrvIXUd5Yf/QguzYIp8rFOVu77dV1
	6mlVDdjxeS4+TuhMyrV9SLjX8qMeduCi63IDB1arokgQkbhLlXvQGovyRJNq1X0PYHgySp
	WkjBwMOXJg3QTms3ZY7nqQswdD/XEds=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-UwznlgijPfuvpV1r3xobPw-1; Wed, 31 Jul 2024 23:12:46 -0400
X-MC-Unique: UwznlgijPfuvpV1r3xobPw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-664fc7c4e51so121879017b3.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 20:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722481965; x=1723086765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D7AlDUN6nl/SKMwnnn5iGJ6hY5cYu+29jn1yx4r42g4=;
        b=madnt5zVxudyoa3G0ef6PFWM2h0/OOFuv45ubdxBK8U/46CDcsUJQWHgv38bjaGAXp
         YCMfPKHvaYUD0WgYNzkKgFbjXOapvmqYrbMqJVkwDVJFo9sRu5jxKFqlSTsqFeVxUNxb
         ooNeXI0XUt2mPsP7HMP2uzf77A31QJIcQm1gyOTNOgIs1xw4gh5hfTrrOJC+EurWHm/N
         hFdh4dP5cN7Mix+qntpHy0y7aXXRhT0vNidwb0qxjf90irDuFoEWd/aAC37mL9PmDyf+
         M/ufGz2nd3To6RzyHWg9FW0DXyKetAEsBKswmOw1MNiDs18o9V5aA2hkzaXqsDaXzb+a
         LRqA==
X-Forwarded-Encrypted: i=1; AJvYcCXxM2kHRLS04si2OEXGlvrTgNpqkuYmd5V2isavnAbrKdd/EjWBtt6gF4GnO3SyNJxo5rZp0s6Hbuatx6yOJ7BrqKn3
X-Gm-Message-State: AOJu0YzYEzbWU4qjQvNRruLDrTWqlz8gMtqndQ17rceztgzX9HyktHlW
	rmCxRTPvUo3xKcyppEtWvrNzJg3GXjp3aAWKPX7SrkrTBUO3Pszr818+rJphC7cW+my5FEmvwO/
	4VMWXU1Yt7zk/PLlHJXBlXh+BSNwcRArCacTzfbkETH78gEm6+Z2kqVi1ZUttvEGGCsd4hfFSZ5
	P2NJaK23N7VgNKYT2bHljnq+jCJgQl6Le4zQoQ4w==
X-Received: by 2002:a0d:f585:0:b0:64a:7d9b:934 with SMTP id 00721157ae682-6874d2e3abamr4444097b3.16.1722481965503;
        Wed, 31 Jul 2024 20:12:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEAtv7kCWV3oVHIdQcaCXNmd2TKjKkFdRj11szEZCl3bJFmCFQcKkRHN7vjCjvo+95JppXOHh/yFFds3bIY3LA=
X-Received: by 2002:a0d:f585:0:b0:64a:7d9b:934 with SMTP id
 00721157ae682-6874d2e3abamr4443887b3.16.1722481965238; Wed, 31 Jul 2024
 20:12:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726134438.14720-1-crosa@redhat.com> <20240726134438.14720-7-crosa@redhat.com>
 <ZqdzqnpKja7Xo-Yc@redhat.com>
In-Reply-To: <ZqdzqnpKja7Xo-Yc@redhat.com>
From: Cleber Rosa <crosa@redhat.com>
Date: Wed, 31 Jul 2024 23:12:34 -0400
Message-ID: <CA+bd_6JjpHe=DJZMJb7x-bu_-i8X2Z4LCuk-Mz-2_LbqtUKYNQ@mail.gmail.com>
Subject: Re: [PATCH 06/13] tests/avocado: use more distinct names for assets
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, David Woodhouse <dwmw2@infradead.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, 
	Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 6:49=E2=80=AFAM Daniel P. Berrang=C3=A9 <berrange@r=
edhat.com> wrote:
>
> On Fri, Jul 26, 2024 at 09:44:31AM -0400, Cleber Rosa wrote:
> > Avocado's asset system will deposit files in a cache organized either
> > by their original location (the URI) or by their names.  Because the
> > cache (and the "by_name" sub directory) is common across tests, it's a
> > good idea to make these names as distinct as possible.
> >
> > This avoid name clashes, which makes future Avocado runs to attempt to
> > redownload the assets with the same name, but from the different
> > locations they actually are from.  This causes cache misses, extra
> > downloads, and possibly canceled tests.
> >
> > Signed-off-by: Cleber Rosa <crosa@redhat.com>
> > ---
> >  tests/avocado/kvm_xen_guest.py  | 3 ++-
> >  tests/avocado/netdev-ethtool.py | 3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_gue=
st.py
> > index f8cb458d5d..318fadebc3 100644
> > --- a/tests/avocado/kvm_xen_guest.py
> > +++ b/tests/avocado/kvm_xen_guest.py
> > @@ -40,7 +40,8 @@ def get_asset(self, name, sha1):
> >          url =3D base_url + name
> >          # use explicit name rather than failing to neatly parse the
> >          # URL into a unique one
> > -        return self.fetch_asset(name=3Dname, locations=3D(url), asset_=
hash=3Dsha1)
> > +        return self.fetch_asset(name=3Df"qemu-kvm-xen-guest-{name}",
> > +                                locations=3D(url), asset_hash=3Dsha1)
>
> Why do we need to pass a name here at all ? I see the comment here
> but it isn't very clear about what the problem is. It just feels
> wrong to be creating ourselves uniqueness naming problems, when we
> have a nicely unique URL, and that cached URL can be shared across
> tests, where as the custom names added by this patch are forcing
> no-caching of the same URL between tests.
>

Now with your comment, I do agree that this adds some unneeded
maintenance burden indeed.  Also, this was part of my pre-avocado bump
patches that would work around issues present in < 103.0.  But let me
give the complete answer.

Under 88.1 the "uniqueness" of the URL did not consider the query
parameters in the URL.  So, under 88.1:

   avocado.utils.asset.Asset(name=3D'bzImage',
locations=3D['https://fileserver.linaro.org/s/kE4nCFLdQcoBF9t/download?path=
=3D%2Fkvm-xen-guest&files=3DbzImage',
...)
   avocado.utils.asset.Asset(name=3D'bzImage',
locations=3D['https://fileserver.linaro.org/s/kE4nCFLdQcoBF9t/download?path=
=3D%2Fnetdev-ethtool&files=3DbzImage',
...)

Would save content to the same location:
/tmp/cache_old/by_location/2a8ecd750eb952504ad96b89576207afe1be6a8f/downloa=
d.

This is no longer the case on 103.0 (actually since 92.0), the
contents of those exact assets would be saved to
'/by_location/415c998a0061347e5115da53d57ea92c908a2e7f/path=3D%2Fkvm-xen-gu=
est&files=3DbzImage'
and /by_location/415c998a0061347e5115da53d57ea92c908a2e7f/path=3D%2Fnetdev-=
ethtool&files=3DbzImage'.

I personally don't like having the files named, although uniquely,
after the query parameters.  But, If this doesn't bother others more
than the maintenance burden, and Avocado version bump is applied, this
patch can be dropped.


