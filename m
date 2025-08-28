Return-Path: <kvm+bounces-56196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C129B3ADA5
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08239A01F39
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 22:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B843D2980A8;
	Thu, 28 Aug 2025 22:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJSrBhHo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFE617A2E1;
	Thu, 28 Aug 2025 22:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756421169; cv=none; b=LI/cFQd8nHLvnWhIdbyfKXV5XBtrkfMqvfSQOXmvewaITl1nLUFPTr6uQJhg9FkoJ9aW3VhOG0DFoxgodaH5VWngGcPmnKrCtZ6moK/H4cBRStEoZjEq+FvEpGDh4HEIeb7Mbjij5C1nXuKLtH/1mEYspIyzD2WPXJOnCnHfDnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756421169; c=relaxed/simple;
	bh=Qr8/FR5KPHlzDVyo6eCSpSu87/KxMAJeKfDwPGsLi3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMR+eNLJMLrIpqRiizCvOHFdX/EZRgvIPhedvPqjMnElgW2kxHrdHqnbaDzD/iEBkVcHKByiBGfz+CC5xqgxG0BDgxyVEkv2Ezi3Dl6AmOIAo18TPwfXh59RZKYZ/eTLG3hjVEYRWSCs/5F2Cj79rH0dXUqRuh0iOMILHgKDvdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJSrBhHo; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-323267bc2eeso1143970a91.1;
        Thu, 28 Aug 2025 15:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756421168; x=1757025968; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aS/0Cix96kEk5XJxrbXutEo0qjbvqEvH7fwzYKgoL/Q=;
        b=XJSrBhHoLh+agK/k+/ZqVsI9AnI+LszVzEnpJyfG1FR03wlKH0Zi5gtZOIiqE+r9EN
         /3SrS0ZD3aU3IuC2RPDIgX2AKOpjJSr/aH7BNfCLr35S8skA+T9HzGNIEqvCEWwqiYk+
         xiaQWjOcM7h0x4N/fchwgh8rFfSV3GI3RTRwL6ALOxfkEM8qAkhDf2vnoX4HxXjnn8Cg
         +6RMWtxDApBy//n30pAZXVUBVID1yw4t5PARe7JYxxN3Xhq4Js+1jgxUMD5CC5ncokdB
         Q3fQY2aI91nfIcwhgqPwwf1UKds/o5bLoIOm2Eibj8jSIJsqyBiieMiU/Crl5cCrc/f6
         u7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756421168; x=1757025968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aS/0Cix96kEk5XJxrbXutEo0qjbvqEvH7fwzYKgoL/Q=;
        b=g6sapJPFK59BRRS9IEhKvi/gehwq0iqWmPYxM6bItr9bFaxGTy84rmYoeoUyOurIAc
         fGaUBhiDNtMVRxYn2j/6oq+V/WdpvgbQVCfUp28bvOa4aoqYgD6rMmeYw3nUylCfjlUI
         cuTabbTLPrvS3C9V4kCRVvMJuhyUzsTPtszXq/TiO8iNytutWXR5BewVvoCvgre20iwI
         MhSDAwP5fLwr96jWmYDnf+61vDbhdp0flk+RJFViHrrQvUZpARfadhEbtwFcrUqiDcHl
         xMvNMskwKAObMJ8KpozP4b/OBijZC5KK8Bt1YR5y7f9UEL8354Bz3biK++2ynvBTfjBC
         lLzA==
X-Forwarded-Encrypted: i=1; AJvYcCUrYVZIgIOllinmYiEBRhz3rbaBZnrMaISBtnA3dUbNH0DZQtDT968Zo2L4jewIx2xfcNgzaVrsiZk=@vger.kernel.org, AJvYcCVB6uMPI+z/fYRc3t59awdl3fntgGdTRqCJdoJfWWTMjfWVerrUMCSNpsPHZ0Ybk/5vbRgpfOFno0cX4wlf@vger.kernel.org
X-Gm-Message-State: AOJu0YzbH9bi4QoSWl5weEwzlAUkS2XfVD8eh8L6ODm8G9/g4mbqbC6p
	qoc6h6DBVhtjYM5++DvMPbJUVMnBh56v+XXzjltupY8q+3e/P0s3rT85
X-Gm-Gg: ASbGnctA0qBJmmX+B5JaC+OSs8bm97ZKL8Af9O9ZNJ/RZ/GVoNABHRwJo75mXv/jpDu
	dg73ELfSV5EQP8cXnKzJPUMrWxVTsF2JAZPhoF30H15IUunPv1Z6aeojYOOrmXwlnpABdZtWyC+
	zcbzlzTTIUCHRNhk9BLEC+8zj8Dqn/mYhTtc4du6pCDpUvG+QfTToE5X/coN+BU8U26f4NABNX2
	3+D16jncxCPjFlH5l2i6oAkeCuE0IEfl/JneDTXxgeewdr746XnWrzyABBoL43cTt6HBXeQsgdg
	h82l1HFu11pK0HgmUS+Rzt5jD5R/56SyhUNL4Nt3QR8SJC8XQHGxjk++MIoN38OLB9twa0dClAA
	4MoXlNS/5yL9zP1b97+eW0QWD/w==
X-Google-Smtp-Source: AGHT+IG1ctgwpX1Npsw1kXK0ngDkt+ZDQ53MMtLINOhIbpTbS8X4O87nA4gCU0BXoThFM3YxVu6Tzg==
X-Received: by 2002:a17:90b:3e89:b0:327:aaeb:e80d with SMTP id 98e67ed59e1d1-327aaebeff2mr5818227a91.7.1756421167394;
        Thu, 28 Aug 2025 15:46:07 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da90d4e1sm714770a91.19.2025.08.28.15.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 15:46:06 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 3EFDC4027828; Fri, 29 Aug 2025 05:46:04 +0700 (WIB)
Date: Fri, 29 Aug 2025 05:46:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] docs: proc.rst: Fix VFIO Device title formatting
Message-ID: <aLDcKyz5WgPXxIlR@archie.me>
References: <20250828203629.283418-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dGIwHQsScgAK7CU/"
Content-Disposition: inline
In-Reply-To: <20250828203629.283418-1-alex.williamson@redhat.com>


--dGIwHQsScgAK7CU/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 02:36:24PM -0600, Alex Williamson wrote:
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesyste=
ms/proc.rst
> index ed8d23b677ca..ff09f668cdeb 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -2167,7 +2167,7 @@ where 'size' is the size of the DMA buffer in bytes=
=2E 'count' is the file count o
>  the DMA buffer file. 'exp_name' is the name of the DMA buffer exporter.
> =20
>  VFIO Device files
> -~~~~~~~~~~~~~~~~
> +~~~~~~~~~~~~~~~~~
> =20
>  ::
> =20

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--dGIwHQsScgAK7CU/
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaLDcJAAKCRD2uYlJVVFO
o3+iAP0Vi/FvcSLwtXfFdVWz4Rt+AVSAYJ6tO6rtIipiowfRjAEAw+5olwOrwm/a
RjFoOOL0n6GbIr2bvzqkrE4QkbcuRAs=
=N4cS
-----END PGP SIGNATURE-----

--dGIwHQsScgAK7CU/--

