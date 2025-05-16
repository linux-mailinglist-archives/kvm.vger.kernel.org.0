Return-Path: <kvm+bounces-46771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB167AB96A4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC08A3AF9D7
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 07:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4D8229B23;
	Fri, 16 May 2025 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPiTBkWD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FED2C9A;
	Fri, 16 May 2025 07:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747381016; cv=none; b=nGW1MBVqH8z7zZKBySq7nYVLXny4T1zydIla7xt0pS1AdhiB5Z6mJovshoUf1/A2LlatMdrg2jYlXrlXmoYKo1eQ/SB9qhFgjVB7/VpRisp9JEsinLe+HmPn8peqxUl24hxcBQF9Abtx5O+6BbUJSWOlmYqqDBwVcGUJcVbCbyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747381016; c=relaxed/simple;
	bh=ebMWSNcomhxWojXZp1ru/Hufic5cRGG/SEvw/kLxl+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GychGH/hNTbRWUQkRYVr5ykQpXXsRVPjpGUco+VekkdegeIc6mspt0eexHOdn/bSec/ku5aV86fCJTzMqzV3CxbnrqKuIwPYk2Yo4Lf1U2BBVpsOam9RAcpvWBOP6eDfjj1ADDxTOLx7O2IIPNyJAJpBLQ5QR422EPQKivjUzYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RPiTBkWD; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30e4865d949so1785163a91.0;
        Fri, 16 May 2025 00:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747381014; x=1747985814; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m9OMCtiLZCfc2YVjRFKF+JcKQO+Z+1J6zwpzAKX8QEY=;
        b=RPiTBkWDOqXXCPg97GJ3il7wNjip3iUvgx3FSZ3ZHtnShlVfecKbBFAcLUSUtzLngX
         wm/Y9rs2bfvdbYQRIZ/RzMywrM4olZLMrkjrz0BNWUfDrNjSdsC2VUGDc2Bdol+hIWC0
         wQS3gfhEdTC0FL2uZvL78hd/7OznTbSx3NA/oviXV2F+rcn2BE6ydqxeukhiViUs28vn
         jqJC5vKaSyfetZJZf2d20hWlByPLCCvEy2x220QC+QPCE0WoDeRAue+rPAouT84sohGG
         UjdQ03QJ8XcgenR+004ZjFY57eq4PtxLJ7eef802aCU31hS1inUnHCVXo3iGk/TstCm+
         +3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747381014; x=1747985814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9OMCtiLZCfc2YVjRFKF+JcKQO+Z+1J6zwpzAKX8QEY=;
        b=Kr5IixaEwcbgcY1Ov8uAps3FRieMM9SXw45ypVGDDWo/yTmjzyozXyOZBPZA/3ttH8
         +Vpn1herCZ5dJ1qiR8JKcbTI6L1ramuq+K1lstd7+WfDNwiFVm9YN5PMJBUUVlbc78eP
         TIxGBbLQrAiXT6I2i3rYOjM4nDEmegNvRyXYVyCR1KpkC6cpCCFBk+LxS9j9orIPubOB
         fOzbXo+iZjU0AuD482Aq90KFVXx0J6jtNzNK/XLVZydvT5ZPGz4xW9xzFIaod1cNUAXv
         Xr20EzIGB/FaqpEFbIhY0/D4x1hmOYWCptnUtT0Kzddx2w9jKAVrkae/zowUOU13DdGv
         gz0g==
X-Forwarded-Encrypted: i=1; AJvYcCV9yQxSgmqwGqSB6uGKqE5T4STBw8Yuis2qgP4uDZeV31lmuZxCAL2zvT/20HtJqRfpm+8=@vger.kernel.org, AJvYcCVePf0x8jNWsYtmcAqOy/7qzC2wPFHVVIafGc6Fgq+w2GLSbD7GeMpmvl455MslC0MhxznF1tiJFv64@vger.kernel.org
X-Gm-Message-State: AOJu0YwCFhSs5cq8V7rTeDZsYiCPjjS0/ogRNZDjVZPJIPme6n6YsX4A
	VEupbcH7/mPHqr18lG05UvB5zXYgboUmZtJdH6/+ZN0QT8uzF1e0Zic3
X-Gm-Gg: ASbGnctY0aQMjvQDS1SqtqmXXXdzI8cEKOIa/MAuDeOHYN74sNc5CvFemvJRaWRYBMz
	SYEe/cyclYf5t7gP+TEM15akGdvLFpNdnmOnzbz34fBiMkLl1uCDcR2cZ2NAB47KFeNhcg8lYKt
	C4AH7pS7gQKA49Ci4TTqbLb7e0TbsYPL6Z9e5FP9rwmGFjVZVuGtJcDpBtkIK/cmYdPP5CracLH
	9rMldqQ/5sDdcejt1g8y2itYCZ7Px4yDEzmStbDJ2ByFefoy4Is9dPjwa3NRlgzrgD6zVVYhnSw
	MCPhicYvaxJ76Z0Z5oHRx/VVSqm1d28iCauCxrCFl5waQ2Fy5lQ=
X-Google-Smtp-Source: AGHT+IGa8Co7Rw2A1GJhpE9BjFMOQ61U2FsxzqSQ+Qpkl1VLWQ3Iaxn4Js0s63XHdVwcuK6Xjp4ACg==
X-Received: by 2002:a17:90b:3f4c:b0:2ee:5958:828 with SMTP id 98e67ed59e1d1-30e7d522155mr3676752a91.9.1747381014411;
        Fri, 16 May 2025 00:36:54 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e7d4aa777sm977405a91.21.2025.05.16.00.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 00:36:52 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 6685242439CF; Fri, 16 May 2025 14:36:50 +0700 (WIB)
Date: Fri, 16 May 2025 14:36:50 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2] Documentation/virt/kvm: Fix TDX whitepaper footnote
 reference
Message-ID: <aCbrEqzBcN3yZKfl@archie.me>
References: <20250425015150.7228-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t5PBsglYtbDugZ88"
Content-Disposition: inline
In-Reply-To: <20250425015150.7228-1-bagasdotme@gmail.com>


--t5PBsglYtbDugZ88
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2025 at 08:51:50AM +0700, Bagas Sanjaya wrote:
> Sphinx reports unreferenced footnote warning on TDX docs:
>=20
> Documentation/virt/kvm/x86/intel-tdx.rst:255: WARNING: Footnote [1] is no=
t referenced. [ref.footnote]
>=20
> Fix footnote reference to the TDX docs on Intel website to squash away
> the warning.

Review ping...

>=20
> Fixes: 52f52ea79a4c ("Documentation/virt/kvm: Document on Trust Domain Ex=
tensions (TDX)")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20250409131356.48683f58@canb.a=
uug.org.au/
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Link: https://lore.kernel.org/r/20250410014057.14577-1-bagasdotme@gmail.c=
om
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>=20
> Changes since v1 [1]:
>   - Add Reviewed-by: tag from Binbin Wu
>=20
> [1]: https://lore.kernel.org/linux-doc/20250410014057.14577-1-bagasdotme@=
gmail.com/
>=20
>  Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/vir=
t/kvm/x86/intel-tdx.rst
> index de41d4c01e5c68..2ab90131a6402a 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -11,7 +11,7 @@ host and physical attacks.  A CPU-attested software mod=
ule called 'the TDX
>  module' runs inside a new CPU isolated range to provide the functionalit=
ies to
>  manage and run protected VMs, a.k.a, TDX guests or TDs.
> =20
> -Please refer to [1] for the whitepaper, specifications and other resourc=
es.
> +Please refer to [1]_ for the whitepaper, specifications and other resour=
ces.
> =20
>  This documentation describes TDX-specific KVM ABIs.  The TDX module need=
s to be
>  initialized before it can be used by KVM to run any TDX guests.  The host
>=20
> base-commit: 45eb29140e68ffe8e93a5471006858a018480a45

FYI: Stephen is still complaining [1].
Paolo: Would you like to take this patch through kvm tree? If there's no
response until 6.16 merge window, I'm intending to resend and route it
through docs tree as doc fixes for 6.16 after merge window.

Thanks.

[1]: https://lore.kernel.org/linux-next/20250516101604.7261c44a@canb.auug.o=
rg.au/

--=20
An old man doll... just what I always wanted! - Clara

--t5PBsglYtbDugZ88
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaCbrDQAKCRD2uYlJVVFO
o6ugAP46uvTrNN8O2FRYE0MWDP+yh69WbP5Tz2TL4dheV/mAGAEA057sY8/rt4Ww
Y5Mf0Umv+QQ083hoYx21UEW0UIRaJQc=
=5Jn3
-----END PGP SIGNATURE-----

--t5PBsglYtbDugZ88--

