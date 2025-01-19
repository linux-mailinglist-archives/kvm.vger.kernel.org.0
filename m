Return-Path: <kvm+bounces-35926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA5CA1648E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 00:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EA02188524D
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2025 23:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC8C1E0B67;
	Sun, 19 Jan 2025 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zvn/mWwh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997921DA3D;
	Sun, 19 Jan 2025 23:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737330946; cv=none; b=pF2+XpRSLaBwwaG+6aNIseouvPRQ8scbEIyUSHvqCKPINc9X+2+op4CyyWsC5gn+MCkuMs/zarPlZbuBg/D9i6WYKaV6XzfMsNFq4ll0H8cqrycit7cN7VKIY0SfeOngdwt+tmqsA4gt4eR+p4rVj/1cDWrHbh8NfxC71Emq4jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737330946; c=relaxed/simple;
	bh=bQXpGVepSY9XdcnDxQo3Am6gt1NpTZUKbJRTtrAZfAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KFVl22PXUHDBYZMjrUQE6S/BM6pdeo5Vi7bIkS8kDawtIjoaUgME1NCRm6fJv3FYOoKW3rdy0T/sD1v/koP2WubtuvE0K2vboe5g+w7srS4l0wa0o1VkhfxcZdHfGY5bW0Rl8BFuWv3Nnip3ap9B3Buf16im9pD1c6gTAQ755tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zvn/mWwh; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21c2f1b610dso61925645ad.0;
        Sun, 19 Jan 2025 15:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737330943; x=1737935743; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2XVN5sGwZEZd9OemkxZCpLaBh1+XBAUoUQLOEGHa48=;
        b=Zvn/mWwhWQmTlo+1r2f9desO7d92VLC/j6e8698mvTIMb601I4TC/qmrgjESUVDwiN
         5e/Ib9DhCzr+78R91jcccFqyAX/vLr2RqreiArNLGOIA1Jh+rV4uGgAoJQvMkG8xHpb+
         5tx0swdHJUUOUAwfJXbCnjsjIrORONo4IkbpJ1JGKoYl7EruXqYqImzoDhxKWvgyL5jO
         DiwDi2fvCPmgAH/kg7BHO3CMBIHR2GfhEDwCtijBrhFD2FCYeOQjbCEBzgCzs77kO6bd
         C9P1OHoAsIcGKalvo6+vxBQ3QJJr+Gl/GoKt2UM4YrTn0Oepif4mP/E02s+f6DOnMKML
         G7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737330943; x=1737935743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2XVN5sGwZEZd9OemkxZCpLaBh1+XBAUoUQLOEGHa48=;
        b=tFALb2jnD68vDmeyEcW2JOobgRwja9qU6WaEHX4XYn6IsOSpYOaBbkTOowzSdTYGH/
         I0E06b0UB7TBydfnyq1vldvXKLPpJn3DZL201jiQmaFs6bbpQfVZB6bsxE7pf8MkQHmb
         vQNm9qc6RkHX3gmFVMA/3qKXWbXX8Pfbfu7BgcHCMWBc/wS6V3ugNpf6cOgJd8ObYr3p
         EuKttB/f9NZ3oqiGEgwWLZFOYtmhcbDria7xgRlGtdo2dMhxOZHTMoj7zvWGnI3IhI0G
         ZUhEtOPhFUkz0l1B3B9Ygwfm7eNoof0V9dHcdCwnYpzpCz+g1QvZe+HZ16g3Dj+VSp4i
         ceUA==
X-Forwarded-Encrypted: i=1; AJvYcCVXejwjfDCN4V6VR431dZy89QgsslmJDTEJP1nBkL3eya9gIxNNGD7PTTokxcrDVHsQq24=@vger.kernel.org, AJvYcCWOvu4UI5jo0A+3Eiuo+uwKcMLm2k0iXkBjF8UMCM1tcbr662r14IDn4EIiXQReOHh3no9BtRUDJ8vHfzhl@vger.kernel.org
X-Gm-Message-State: AOJu0YwuGuP/jL1lkQTJemvvaag1KpJbfm74bYqbzkrIzBhPjfIBvf7J
	24MGYoo0RvyxZMnLVyIqCyfx8WyUHBr2IsC0Sk+Gav/2TuWSkTn4
X-Gm-Gg: ASbGncvosmrjJ2jks4SxflMi4ul7+iMCcQSxvJTwG7PRFqbRi83vT09keVFQhIKnJ4t
	nKEAvPAMQtFg4DaFdwJ/QBJz0WHxN5gI/b3i8A1CUrg0G4RvlDSpn4WFwTQ5ywEdwThxv3LtQIn
	QYy3R/w7kUts7bgSmirIoSRVId/a6+7u5fn3cIuU4qnyafCGslZ4NXFCZp1DzjHO7Q0Lb9+RQtD
	4ryigBYC1Er6lmwTuiyUyKPNn6vzaTjB2kCVQ4vN0DuIil6zgrFCXHz8I85zN5ECa4NlA==
X-Google-Smtp-Source: AGHT+IHWy2tn0ROsIC+XdDJbMemUHnV9qx9ROIXRviCRgGQ8MEqTqrc5MXa6OElcpKZqJPMFTXWKiQ==
X-Received: by 2002:a05:6a20:a10d:b0:1e0:ca95:3cb2 with SMTP id adf61e73a8af0-1eb2147dd74mr16777728637.8.1737330942467;
        Sun, 19 Jan 2025 15:55:42 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bdd309d91sm5611791a12.48.2025.01.19.15.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 15:55:41 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id E0868418B9B0; Mon, 20 Jan 2025 06:55:38 +0700 (WIB)
Date: Mon, 20 Jan 2025 06:55:38 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kconfig does not accept a lower value for KVM_MAX_NR_VCPUS
Message-ID: <Z42Q-sbPMA9zZMIC@archie.me>
References: <03a04e86-c629-44df-9022-05c42b4c736f@gmx.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8BgJX5zGcP5XDR3U"
Content-Disposition: inline
In-Reply-To: <03a04e86-c629-44df-9022-05c42b4c736f@gmx.de>


--8BgJX5zGcP5XDR3U
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 19, 2025 at 12:04:04PM +0100, Toralf F=C3=B6rster wrote:
> I was wondering why I cannot put a lower value here during make oldconfig:
>=20
>=20
>   Maximum number of vCPUs per KVM guest (KVM_MAX_NR_VCPUS) [1024] (NEW) 16
>   Maximum number of vCPUs per KVM guest (KVM_MAX_NR_VCPUS) [1024] (NEW) 8
>   Maximum number of vCPUs per KVM guest (KVM_MAX_NR_VCPUS) [1024] (NEW)
>=20

Hi Toralf,

=46rom arch/x86/kvm/Kconfig:

>config KVM_MAX_NR_VCPUS
>	int "Maximum number of vCPUs per KVM guest"
>	depends on KVM
>	range 1024 4096
>	default 4096 if MAXSMP
>	default 1024
>	help
>	  Set the maximum number of vCPUs per KVM guest. Larger values will incre=
ase
>	  the memory footprint of each KVM guest, regardless of how many vCPUs are
>	  created for a given VM.

I don't know your use case, but you can safely choose the default (1024).

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--8BgJX5zGcP5XDR3U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ42Q+gAKCRD2uYlJVVFO
o4+YAQCXy4KWvcbnFObWnVXjInsKyXUHAJRPteJnuJ6u1DlL5gEA3X39TPhmwNMq
BW6VSoiw50OHIg6ZimjFJUpnG9UdmQk=
=pcnc
-----END PGP SIGNATURE-----

--8BgJX5zGcP5XDR3U--

