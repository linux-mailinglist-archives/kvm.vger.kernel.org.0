Return-Path: <kvm+bounces-55753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43100B36C1B
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 16:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 928161C45C67
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 14:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B3E35A2B2;
	Tue, 26 Aug 2025 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hY5gv1km"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE702135B8;
	Tue, 26 Aug 2025 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218706; cv=none; b=O6LJedk38soCBgYXi8mIkdPxSJOepbzec1GtNY0u7GwU9I0meujFBWO6TcyOO+WW/5t5ceQu7J4OU71UOFIZc56gUCoq0NKNfYLdN2YRNvLwYMcGFtmMy9nhQ6YGQfT5sunspkSAa9bbkhdaXBv2L11W0zAqx3/eYRzG+UX2IKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218706; c=relaxed/simple;
	bh=/2HsZ/XIzddkUHUH0J5f1YF3GAgt4K2I1EuGaK5+mTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HaqvgIebC6l09C2UyYbMZvwDWKZFyrjqrHbS+h8VrqWLZAmmTgysAtgifyrItTLNoaPFS2Pa55YGb8/pVWTACPkZrxZLQLa7/hdDP9UH5M10hqFnIWoa1dEF9RtzGd9rcYQmZZeUJN4F0E8aIK+jRlO+ih0atxL0xTbtc0NRbVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hY5gv1km; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e39ec6f30so5480500b3a.2;
        Tue, 26 Aug 2025 07:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756218704; x=1756823504; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/2HsZ/XIzddkUHUH0J5f1YF3GAgt4K2I1EuGaK5+mTM=;
        b=hY5gv1kmjgdKTxlYLJn4A03RAEl8yDBA8AopKwMkPGDcC8G9LRLSHfh7mBotg3st0P
         hzVhY5t/fRp3ErzbsRaSYbUsY2/ctBZrYhxPYjhPn/VS/M6Rkc9v9ATLJPwZsiDLpJdo
         Vmg1k6TZJby7gRiO5hRC/ztKEBkxjxUIyKofVSZgn2kRhn/59diMfRYmdDVfI0HsLwLe
         Te28cQHJrrhGOLItohGQJVbogJlZ/BhQiRjXEGunXB3nkc/MavIvvHneP0k59TF3B0me
         io5c45nQd3Ju7K1GXYoML9nZEo/+zY/xV3e5xYUm8hBXBV/f86mbnxyRQDSeD6OJy/6g
         5mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756218704; x=1756823504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2HsZ/XIzddkUHUH0J5f1YF3GAgt4K2I1EuGaK5+mTM=;
        b=iy2cCDbHff0qswa30YDe9GogA12P3hCz7n6XTfuK1INIfbkpZqZlMbrgMksTRg4akK
         5lSEgCG0dVeDtinkw2ZXsj3TstFBQLbdzo1vq+hXj1cUiAi3eS51gw3v/tnHUbzNcfbq
         qBC153foau/olTnqTI9CRFYh/wFdkyXOHDdpRWsctSfx6XwNbT7cexDrwTs9Y4ycmd2D
         xL/mcl63++KzkgPAyyrPkOMgqgXzaKa1T5UlTPnnUmF4hD9oYKwg9l2x1c7fCq/5cV1x
         67GqyIWMTPGX3QweYG6BGf+hVsHGXEK3J1ZLEBkbUMNeT8/ON9/Wafw7zDEgC7FXI28E
         Md1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6MOtpGE2wf91ApxxJqdU4WYBRQc7Ze6f+M1NEbUEf8TpnXu9ZGEdZICQF4T1CShH0THE=@vger.kernel.org, AJvYcCXVzkX8PQMsviUdRwkRMI+2+xwwtaOQEwUHUUfDyzEW8XyTInII6kQH4X8TU88fhTAfVt9VUiTg0IH4@vger.kernel.org
X-Gm-Message-State: AOJu0YxsC9ehBqiYj2SX7ls5pXUT8w7cTjnRsXYchNnqOfpdWhLHP7il
	9CVS2IpcRv+MkeVgYqkkAKd2hKB9OGfvC4oFcgN8K9nnQ2Apj36ku1ue
X-Gm-Gg: ASbGncuM3WS9xkbxikZuSJKofq+8GpXGZTIMqHyhbKw/HH8S9X/a3FVNaP1mj5BWxnD
	xO8wC/MNjYzLcgItYo6DnSi7vvxucyqjozjWMK+7IDqSyTOnihfSRpkNjBm2jD0ATHym8mq3nGp
	mqcexieqvtVpkKNlFC/Qqn5GXpnwrI/Y0x4H19eCsFjMbqQXbwvpM7jp1WeYX/cBlYWttqXBffF
	s4Bp97vLY/hoCKd1OFYPLb67aG4TgMhH0MZwWklBlAiww5qslX249NPNax3ES0ztx+QX0/peI28
	lNyun3vqRArFIoU/NlqI+MKRP8CAbXsO+0dw5SBK9M1cGem23JoiLbib2kkrpPDTxVupReq2I3V
	YxPGt4OaVg8objkiBZzqU2A==
X-Google-Smtp-Source: AGHT+IFm+XrOlSim9C8ckicCEIkpgvafeXXcgdVuWrC98u30twNdBGpbSt44emTPsPlVfiBYYAcZ0w==
X-Received: by 2002:a17:903:2f4e:b0:246:b463:cabf with SMTP id d9443c01a7336-246b463dcdemr91050425ad.8.1756218703821;
        Tue, 26 Aug 2025 07:31:43 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb9ce58sm9278046a12.40.2025.08.26.07.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 07:31:42 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id AB512420BAAE; Tue, 26 Aug 2025 21:31:38 +0700 (WIB)
Date: Tue, 26 Aug 2025 21:31:38 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Alok Tiwari <alok.a.tiwari@oracle.com>, pbonzini@redhat.com,
	corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	rdunlap@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: KVM: fix reference for kvm_ppc_resize_hpt
 and various typos
Message-ID: <aK3FSpONL01-Dexa@archie.me>
References: <20250824075455.602185-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DLPwMqCHcj94pYC/"
Content-Disposition: inline
In-Reply-To: <20250824075455.602185-1-alok.a.tiwari@oracle.com>


--DLPwMqCHcj94pYC/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 24, 2025 at 12:54:48AM -0700, Alok Tiwari wrote:
> Fix the incorrect reference to struct kvm_reinject_control and replace
> it with the correct struct kvm_ppc_resize_hpt in the documentation of
> the HPT resize ioctl.
>=20

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--DLPwMqCHcj94pYC/
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaK3FQAAKCRD2uYlJVVFO
o1lkAQDMiJWsc4VcsMe3oMv646Tp9Hd4gu42IXlJNeyvZAmzywD8C5IOiJx3Vzuw
R3bu3JNtZyydzXM6eTuqyYiGqy/RoAs=
=jthh
-----END PGP SIGNATURE-----

--DLPwMqCHcj94pYC/--

