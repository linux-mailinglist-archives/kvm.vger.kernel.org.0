Return-Path: <kvm+bounces-10203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F01C86A72A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 04:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6308E1C23785
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB96200C0;
	Wed, 28 Feb 2024 03:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TjBdggxX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8821CD2E;
	Wed, 28 Feb 2024 03:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709090550; cv=none; b=dMKJhk6et9736kgw7jTVwBzgT/URJBhyTyDQ+O2ZznqwdGpqEiHHO3KINzAZlHFSOCyP9Mw3cW2np/qAr3eIdiZmKNJeoNoa0pgoV79QGimMr/9SGvpHiEJx+jyPbKFENPk/hquVgqBAWgFUIO/7k+SjqYzO5335+ekMz/iFj2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709090550; c=relaxed/simple;
	bh=lC4dGO0lqfEg3i+FqXpFDo1B1EpNvhu22LFaHsGBU3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U9+Llq0uFhb27ypT4Moqq40s2hF4Un3ZVZYdL3wqDXrqQZGdM9xtHyOVONb7IpUBCDxvMQCDVIrhUWCODbrbfELu1Lvno5Ddpf3iwI/ySF9L0XMF7T/IplGv0IS4hiMjGegUdY4NrlzYlE+enFO0A63mOyeJYuxnwdCS3Pxr5yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TjBdggxX; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e55bb75c9eso442143b3a.3;
        Tue, 27 Feb 2024 19:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709090548; x=1709695348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ddvZcvgDnpMDiyTtYnJ0ngv1UorhOdtz/2lx5X+JcE=;
        b=TjBdggxXJmqveOvTXDu6BUHSGBSrwbMWM/5wnX8oliDDIxB3w6RX16qoPXIJD2FmXE
         zHxY5dx/nB+H44VL+Ia8UeDEcJsarW7M0WKCBIWipNjVxXet65CBlw/yoburlPj75ZC7
         cyQLXHz3/o1x18IFpUSVeHn3xSE2UhRlqTVoiykhObBCiQzj0TKX0uCBtAsWl7mLtwWo
         YvdlfdcZHJBUSeO4GtMEnYFLUpm9v0lKliDJAg9DCKkIkisByaEm64hmLagReBtBRnAp
         mh2VvQQ3aNeUrX3LOTocgmSquhcvDXMZT+k/QIefclsjVKUQcn7znuXdX4AExMZxxKDU
         nZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709090548; x=1709695348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ddvZcvgDnpMDiyTtYnJ0ngv1UorhOdtz/2lx5X+JcE=;
        b=wmYlwcIa6U8A2qYTu7h8PTgJzPWW/wcsm9yQLaAH+lstDegiSu3kKdZmCmk6zKtlP9
         jrZ2d2CFIv4nY4tS7un/eBylWM4fP3t8uY5e0k/E2fHVMyZUJ3A4Gyd22U0XWbLvC29N
         KaB0SsfDYLwU+v2QzqfjHEQ9VsRWIByn41bchHlBi5DCzDEcm3d8sBo+8erteQTYc3XA
         qINXPYGT0Nv4t45/oFV8q5FPn11GtZoIQl72Y6yoYazkxyCf8mX1E9pd3pnbmk5l0liC
         xi1Gg4KKH7+xc5DqQuOpI7IYkwhJjPzjYACl19x0KyQxSvagE1JatCjMQCF9GIwklC6E
         1QdA==
X-Forwarded-Encrypted: i=1; AJvYcCWMA+9s6jZRWW1PtWR1qN0rot0NtVQEWugoGG4p1KVZgdms82ruUC+fV5eYA0JLehTwl05M37lNrm8fDXkgz8bLhtsnSomBxbzPymS0y4OL9V2H4b6S+TXihCJht42DY093
X-Gm-Message-State: AOJu0YzrqUlGy1RbxJDHM06UnwbgcSe0zdM/0Loxkb9X/5ls0EOywFPE
	pSRR9DBggMVTMzoMLQn9xhJdtahC1/i9urE0+BuIf+wFaIR9LZl/
X-Google-Smtp-Source: AGHT+IFU3Zl5PYBqN5IZOujD0vQBdEkf9WGdTGsrQhjzyZ+hIpnjT3eRaDpBHrQp2p7lQMqPSvj1Aw==
X-Received: by 2002:a62:f24d:0:b0:6e5:5857:6691 with SMTP id y13-20020a62f24d000000b006e558576691mr1793948pfl.17.1709090548021;
        Tue, 27 Feb 2024 19:22:28 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id g16-20020aa78750000000b006e45daf9e8bsm6699636pfo.153.2024.02.27.19.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 19:22:26 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 33F7F18479810; Wed, 28 Feb 2024 10:22:22 +0700 (WIB)
Date: Wed, 28 Feb 2024 10:22:22 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, michael.roth@amd.com, aik@amd.com
Subject: Re: [PATCH v3 00/15] KVM: SEV: allow customizing VMSA features
Message-ID: <Zd6m7pL9a7hTaYxi@archie.me>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <Zd1cDyyx65J1IVK1@archie.me>
 <Zd4gpBsmTdXEZkWS@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+vOicdcBaXFuQCSA"
Content-Disposition: inline
In-Reply-To: <Zd4gpBsmTdXEZkWS@google.com>


--+vOicdcBaXFuQCSA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 09:49:24AM -0800, Sean Christopherson wrote:
> On Tue, Feb 27, 2024, Bagas Sanjaya wrote:
> > On Mon, Feb 26, 2024 at 02:03:29PM -0500, Paolo Bonzini wrote:
> > > v2->v3:
> > > - use u64_to_user_addr()
> > > - Compile sev.c if and only if CONFIG_KVM_AMD_SEV=3Dy
> > > - remove double signoffs
> > > - rebase on top of kvm-x86/next
> >=20
> > I can't apply this series on top of current kvm-x86/next. On what exact
> > commit the series is based on?
>=20
> Note that kvm-x86/next is my tree at https://github.com/kvm-x86/linux/tre=
e/next.
> Are you pulling that, or are you based off kvm/next (Paolo's tree at
> git://git.kernel.org/pub/scm/virt/kvm/kvm.git)?

I pulled from the former.

>=20
> Because this series applies for me on all of these tags from kvm-x86.
>=20
>   kvm-x86-next-2024.02.22
>   kvm-x86-next-2024.02.23
>   kvm-x86-next-2024.02.26
>   kvm-x86-next-2024.02.26-2

Successfully applied against kvm-x86-next-2024.02.26 tag. Thanks for the
pointer!

--=20
An old man doll... just what I always wanted! - Clara

--+vOicdcBaXFuQCSA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZd6m6AAKCRD2uYlJVVFO
o/UcAQCE5bAKToi111sWA8XZQKLToVlzG58+2yRHS6RbsRX3BQEA3Q4BKhLJK/h0
Ob9eXcxWoXIo2yyvf3UUqJFGco0U3QA=
=8hhb
-----END PGP SIGNATURE-----

--+vOicdcBaXFuQCSA--

