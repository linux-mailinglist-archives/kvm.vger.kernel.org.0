Return-Path: <kvm+bounces-50431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF22AE5800
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D4DD3ACAD9
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 23:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB6B22FF2E;
	Mon, 23 Jun 2025 23:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYNGAoRv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A4A22D4DC;
	Mon, 23 Jun 2025 23:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750721095; cv=none; b=uuhKYuB5h+SNwUI69CCp/2UL6MwYSw5aQN6B4pwfL1havqGctyRkKj9aVFNKL+afGcW3D1b3/xUVhw5yKbKb27yfAeRFBotr7xYRHkbBo51GgpNAM4SNe9Be/Cq66V+eLR9564nsBd9nqIQL8Q/OxDVBIHXE5lAJ6+kWlFTmAt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750721095; c=relaxed/simple;
	bh=8qgbLQ7qTvAb/GTxYPRBx94Z3b+S9plKbOpM4rzHMf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5HT1N9BF3z8Yebnsr6/uW88aEq24daeXCg6QA4PXwqiW5rApW19atFDycxcEG8RGa4kOTcaMKtKUXUn104aaSxAJ+dECIyZ0aMBy3QMb93NG3Kbyn4KzMg4K6aCyaKG5PvEp2irVzNRFQ4Qj4ZWiGNSkxrQH1lapsoNCvSEhfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYNGAoRv; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7481600130eso5946074b3a.3;
        Mon, 23 Jun 2025 16:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750721094; x=1751325894; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5UhlJRkcy1fQgV/xmNfPka5yd3k5ils4rtbj0nHi1h0=;
        b=nYNGAoRvjdv4ENPULqDFNKDkQd/w9shq9zY+XsNkzo1EeOUjaKDY+oNXmLL6CqdhDW
         55D5y5BkvQ4M2aawxI2c8yZQr4SPOZEVQOkpS4CgHNDr1hbPQKaRIRwdyzZu/BUbtS9T
         NxnTgmXYFxjGk2PROarw8kWC3N83GXbz3/H7PUUUuSOf7oEhMlWvtJY8NvYyucKL4SJ3
         px9CLeJQm8tO58E2y1UTd0wsrEgx4PD2qN4R/0nGjGJMIjSrvkQNPjQSz0MqL6DaKSnA
         bFjlFVe/bD/tdV5FB5UFifsBKagifJwN0wFXYrGerk2nsiWyhxpPJcYfooBuMJNjfcy5
         vF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750721094; x=1751325894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UhlJRkcy1fQgV/xmNfPka5yd3k5ils4rtbj0nHi1h0=;
        b=eZK3aHPLDuempig+UTizBhyxf2Urwa2RYsbPHMGoHNVy96KwE8xgG8NbeE9ywG/tlB
         bfCbRlyQLuwvUOIbwMT//s8CbWqBKe8KUK5a0KvIQ/HhONSNsjSrW8I4ZKqJZwq6+nFI
         luEFn+3XIhD9EWWtjqoiUGvZ15D6KwGn/uoc3Xw8HBU51mYY/lPV3RQ57ylrb94oiC9r
         EbENIGhQJBkSsjCrzJkVUIvaWucTfZ6/MSfOnOXIYDwnmI7CmDprMEegFTJimc93TYIT
         zv6GM2USmJyT7uApfMkrnTeVDgHg0fYodhQR8mh5nIjOjyZ83IKQGzwmEGMOoCxTj0Be
         GzSA==
X-Forwarded-Encrypted: i=1; AJvYcCUfaV/wbH7pzBxEVwBzUUaJG56Mk47o17npDJ3jHxW/CCkIIJdug+MMiGNCvbOlArm+GFgOp+i7yXQ8@vger.kernel.org, AJvYcCWHqsP61X8ASKBM848RVrl8V8RfYXlhSjeqXExOyAQekoJTv6Nl/R/EwQegG1YebfasGpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBUCU7nPHP4sRiZa7FX/oZzi4yuMj8yAENslpve/X82aa7BR4T
	4PfAxtii0mkCBXTGWzKWSq2LrTXXFy6Sz4iu79m9Rf9rrr4nJV77w0HM
X-Gm-Gg: ASbGncupVo37cuV+k39gwNmM8a7Kl7XpR1jpoOwa2jp7bdhYrd6glLCQZrps6e14sbR
	8H5/8yF9T9FNF7fpZmCB2HU3+5UezM3hvDu7Pc0fWaoq+75n1r54YHCO+CEXv1ek9fDppx/mpeN
	eUTOY04cSB9BDdQ/xNFnCycB7DSi9TwxW08zPnMhhDRk8ik4cvkz+ga/AniNa6jq1DwpymL1tFZ
	/fWKEKaBAbi0gh1uUwrcYbHul5wqqxBCyrWzXCQ3/GBGvQ87G+srQY29MprFTMm1EuTCmGv6/tS
	hAAkR8CDMvBROk0Hk6e9u5+SfWXZo0EJsY3JsQZVtWDfxXuXZXpOY7kvg8UtqQ==
X-Google-Smtp-Source: AGHT+IF0UlsKhZrI6D4LpGFSuxUWm1FaOQcOFePtbW4nu3FgN8WvHCSVaL83gjJNjdEIzStaNgN0sQ==
X-Received: by 2002:a05:6a00:198e:b0:748:2ff7:5e22 with SMTP id d2e1a72fcca58-7490d6bc974mr16621539b3a.10.1750721093469;
        Mon, 23 Jun 2025 16:24:53 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c8859b2esm237493b3a.136.2025.06.23.16.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 16:24:52 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 33E5F4208F51; Tue, 24 Jun 2025 06:24:50 +0700 (WIB)
Date: Tue, 24 Jun 2025 06:24:49 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Alok Tiwari <alok.a.tiwari@oracle.com>, pbonzini@redhat.com,
	corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] Documentation: KVM: fix reference for
 kvm_ppc_resize_hpt and various typos
Message-ID: <aFniQYHCyi4BKVcs@archie.me>
References: <20250623191152.44118-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XtjlFmCOPnxas8r7"
Content-Disposition: inline
In-Reply-To: <20250623191152.44118-1-alok.a.tiwari@oracle.com>


--XtjlFmCOPnxas8r7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2025 at 12:11:47PM -0700, Alok Tiwari wrote:
>  If this ioctl is called when a hash table has already been allocated,
>  with a different order from the existing hash table, the existing hash
> -table will be freed and a new one allocated.  If this is ioctl is
> -called when a hash table has already been allocated of the same order
> +table will be freed and a new one allocated. If this ioctl is called
> +when a hash table has already been allocated of the same order

Two spaces between sentences (just to be consistent), please.

> -This capability indicates that KVM supports that accesses to user define=
d MSRs
> +This capability indicates that KVM supports accesses to user defined MSRs
>  may be rejected. With this capability exposed, KVM exports new VM ioctl
>  KVM_X86_SET_MSR_FILTER which user space can call to specify bitmaps of M=
SR
>  ranges that KVM should deny access to.

Do you mean accesses to user defined MSRs *that* may be rejected?

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--XtjlFmCOPnxas8r7
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaFniPQAKCRD2uYlJVVFO
o6syAP9bLREJNiTUEKAB3y4rpACbB8WjTQAlFiFDer9s6MHmlgD/SaMBEIuHG//c
TKwApe/fvRN549jI2BMy4jVryOyhzAQ=
=bKgb
-----END PGP SIGNATURE-----

--XtjlFmCOPnxas8r7--

