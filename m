Return-Path: <kvm+bounces-22828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F579441D2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 645AAB24FA9
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 03:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2785F13D62A;
	Thu,  1 Aug 2024 03:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7XUjjhr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E45C8814
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 03:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722482474; cv=none; b=kdcvAWgkLtPjs8gaFCN6FmaoLrTYwh8ZBCbjwVq9J7jhUY4lbQoqmjwe2DDs+PgUqtT1dnBbV7Lk3dCn1/o3SrtHRL0cgQm+Uau0sl5XPbhfr37+PnxhhqlB4/YyO7thrpOtNQ/5yl2LnUB6/t226S2pBV9D8qpLCxqAKxScgKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722482474; c=relaxed/simple;
	bh=HgRzhcLYZlultJ5AkxaGKhW/7ZlaMQSNjE7EJhc+psM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kkG8stckECt30Rl9BJiVC1Oh+CH+2ZjgP/fpknbi6oTCE5KbSWxgiUmJHMbi+RTYO5YYQbbDKNVqjRT6JDbGkeXeSAKk0PaqrYh1ygbmyaeafPxYBqHJs6q4zdRLa2j9euoFLo+AVashqPTqgHPgAGvMXPnMBwbzdIYvkgDi93M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7XUjjhr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722482471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3L2qM8ejm2ahCeHxHfhlaEvmc2geAFoV8VAb1fNK9SI=;
	b=Z7XUjjhrhfLWuNutt1+4hr48v71+VNYyg6qh0QzegFAsEsnNWca5oAWFMlixymLD7MqzAl
	UJ+7RKNbNYkdNYXflYV5Ncls/oktdXHcvYK1XAx68eh6RKYQw4FGX17ZTZjK/i2wG8VQIx
	W9/7vIsumdWvk8QwSZ1J/Asyp1r9BjM=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-KkNcN57UPVeVwvmEmzqTlQ-1; Wed, 31 Jul 2024 23:21:09 -0400
X-MC-Unique: KkNcN57UPVeVwvmEmzqTlQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6648363b329so98892897b3.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 20:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722482468; x=1723087268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3L2qM8ejm2ahCeHxHfhlaEvmc2geAFoV8VAb1fNK9SI=;
        b=E/TVE6pHGpudw+ALTXmgLMAQGhuRLeRRdIQRKeKa+CftmUEUvcCXxjRT+Z9VhWIthj
         M2gTCAfUibdntVp/TpEteuj83vkuVdJEBa4TIygClQy+QqIc8JOxYeHQQnnFJ6lUrr3f
         iS6aGuSiAkhBXI1IPaY3jINCc2F6spCOFUgwiTiDQSPdRiAfuXg9MNgTK/PtcFX9SCNe
         +3NrfmoyfEXTicc2PrJ9rdl2WzMOaYnQGhoD0RdtopoYpK3HR9TbvhkgMoHWUOOnTnMJ
         qfrvk4zCX4rjCceTKS5DTQ3PsNZ0+uWOmTugOw4Qen4Vgejqe2ywkqFc1PBgZuyFSKxD
         Uy1A==
X-Forwarded-Encrypted: i=1; AJvYcCUmGC471SVuiW9k3mS9J55uX5Wd2UhDPYWk/v3NkrrJ9q3nIrjdGWJWqfADt5v6ZSmtxum+pnHyAqTEftvOhKEO7qy1
X-Gm-Message-State: AOJu0Yydf8o2kMlyPZaW3hEdg0VGKAfgFvdAF47K76NAkLLWXKamzSCG
	oODSoYRuh/xlodjCqdpzLdBexfJdM35j3gvI4JmgM+IZL6EvVQQln+Xb+7Iiwd3YU3cE7Q7MVzs
	Icy3oQjk5lFStSnsYcecnHxLDizf0aR1Hy96+xXbeeOqV16RyuTa2dcGV1r2L+km/vDqA3kv60z
	ANkIqxmpeElaL2tVyMMofDGsbZ2C0Eq40z653UMA==
X-Received: by 2002:a81:9e0b:0:b0:65f:9796:2bdf with SMTP id 00721157ae682-6874e3a353bmr11944507b3.27.1722482468404;
        Wed, 31 Jul 2024 20:21:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/B7vKknlSLIpX/PzKYimkunlNYGAGba4CoCVx15nKCeW8j5fj5eTdje1OP15fs0TyI/8uKynT9Wdinr8oj8E=
X-Received: by 2002:a81:9e0b:0:b0:65f:9796:2bdf with SMTP id
 00721157ae682-6874e3a353bmr11944157b3.27.1722482468074; Wed, 31 Jul 2024
 20:21:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726134438.14720-1-crosa@redhat.com> <20240726134438.14720-7-crosa@redhat.com>
 <ZqdzqnpKja7Xo-Yc@redhat.com> <6dbc898d-be8a-497c-87bb-d13d956cd279@linaro.org>
In-Reply-To: <6dbc898d-be8a-497c-87bb-d13d956cd279@linaro.org>
From: Cleber Rosa <crosa@redhat.com>
Date: Wed, 31 Jul 2024 23:20:57 -0400
Message-ID: <CA+bd_6LFDwv+y7c8gu89bCcgX3QXHXsyvCrCiAidP40ptdKExw@mail.gmail.com>
Subject: Re: [PATCH 06/13] tests/avocado: use more distinct names for assets
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>, 
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, David Woodhouse <dwmw2@infradead.org>, 
	Leif Lindholm <quic_llindhol@quicinc.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org, 
	Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 7:54=E2=80=AFAM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> On 29/7/24 12:49, Daniel P. Berrang=C3=A9 wrote:
> > On Fri, Jul 26, 2024 at 09:44:31AM -0400, Cleber Rosa wrote:
> >> Avocado's asset system will deposit files in a cache organized either
> >> by their original location (the URI) or by their names.  Because the
> >> cache (and the "by_name" sub directory) is common across tests, it's a
> >> good idea to make these names as distinct as possible.
> >>
> >> This avoid name clashes, which makes future Avocado runs to attempt to
> >> redownload the assets with the same name, but from the different
> >> locations they actually are from.  This causes cache misses, extra
> >> downloads, and possibly canceled tests.
> >>
> >> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> >> ---
> >>   tests/avocado/kvm_xen_guest.py  | 3 ++-
> >>   tests/avocado/netdev-ethtool.py | 3 ++-
> >>   2 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_gu=
est.py
> >> index f8cb458d5d..318fadebc3 100644
> >> --- a/tests/avocado/kvm_xen_guest.py
> >> +++ b/tests/avocado/kvm_xen_guest.py
> >> @@ -40,7 +40,8 @@ def get_asset(self, name, sha1):
> >>           url =3D base_url + name
> >>           # use explicit name rather than failing to neatly parse the
> >>           # URL into a unique one
> >> -        return self.fetch_asset(name=3Dname, locations=3D(url), asset=
_hash=3Dsha1)
> >> +        return self.fetch_asset(name=3Df"qemu-kvm-xen-guest-{name}",
> >> +                                locations=3D(url), asset_hash=3Dsha1)
> >
> > Why do we need to pass a name here at all ? I see the comment here
> > but it isn't very clear about what the problem is. It just feels
> > wrong to be creating ourselves uniqueness naming problems, when we
> > have a nicely unique URL, and that cached URL can be shared across
> > tests, where as the custom names added by this patch are forcing
> > no-caching of the same URL between tests.
>
> I thought $name was purely for debugging; the file was downloaded
> in a temporary location, and if the hash matched, it was renamed
> in the cache as $asset_hash which is unique. This was suggested
> in order to avoid dealing with URL updates for the same asset.
> Isn't it the case?
>

Hi Phillipe,

I've replied to Daniel's question, but let me repeat the relevant
parts of the $name behavior here.

---

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

---

Now, an update: instead of dropping the patch, it could be simplified
by keeping just the "name" parameter (with the URL) and dropping the
"locations" parameter (that has a single location).

Let me know if this makes sense and what you take on it.

Regards,
- Cleber.


