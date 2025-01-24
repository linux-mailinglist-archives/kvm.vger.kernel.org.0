Return-Path: <kvm+bounces-36478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8C1BA1B5D0
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:25:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6DEA188CF2A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 12:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B644221B1A7;
	Fri, 24 Jan 2025 12:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eIdSo+Gm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534752B9BC;
	Fri, 24 Jan 2025 12:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737721534; cv=none; b=pf6DNoQHfuE1/q2Ot2OdGHV5UX4acnVb3hwHMoOWBavt4otk/rmdgI11aZLQJFkNDj0C+39qwICaoI7mBwr6QZ9j+L7DOh8lsAqXcKVpIPuyH+iI0zZpk/ElshaoAApzsNLM+d/D1e8hU2GHlQP3GlIbV6gUdl1RLBVrVFsS55A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737721534; c=relaxed/simple;
	bh=tnlk09m2NBR4uXtk0Dqcj4sR941L4PenpRJcVzCfWKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9hlWo1Iw8yxBDIWSOVZsclioh0k+oVwO3pWw59HpjyeyCuGNXg0+9dNiLVVJgMNWDTT2jl1MRqGwD2mHyfgCHMZ8XsCFP4nhmBDhe8o3SMM46OOhhbyS6Olu/nbIT+s4c1Jbpuot4VrpQbvxk4T8zOpk3kgLhV/BwBhsSKtx3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eIdSo+Gm; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21628b3fe7dso34659835ad.3;
        Fri, 24 Jan 2025 04:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737721532; x=1738326332; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=55WCFRWqtOQgvKOXjNcufQxZKA0z5u3iLymUeHT3mPE=;
        b=eIdSo+GmlKYmVIvZgfy1W5Bu4R4fVycscYAkWhle9IzMGvGSZYci8L08z0FzK8TOtQ
         f3PnIpwgftZf1NMMydfrMlWC65IxDTBVY5PNsPP7Fke8bp0Rh3AWPORL/Qe616nAkJNL
         iH+lvZJ5IwqHwY7qbr9Xv8YdcLu2U4hXwrFhTYDekF908hLXIBAl51IyM4DLhJpXlhWF
         jAnmEZo4mRcYl1gbubSTuF+jlmRMFGTvL6nCljXmsjmIK/4J7d4u4oiHBG3uvQBL2N28
         QS+TsDKm5J1wL+xGVn4nWt5agDDaKU31mOTh3uqFU5t4ZyR6ThJqMUc7MFepoxdJcVLU
         l0EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737721532; x=1738326332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55WCFRWqtOQgvKOXjNcufQxZKA0z5u3iLymUeHT3mPE=;
        b=J019k4+Aak5+4ViZ/pUOaKnb2O9YNNeAeEVpsikUg4U26O6qYCo8H40ykd1XHwt6DV
         NKgbZ7mnnAMzpiJgt17g3qyhJ84U+jTHqc6Ib97tbw08k5ZQgZkXqzGiyQhTwDzghhFs
         S9zxvQQTCgWAxKPsWgUVVFQYTWRt3uVsy+s+pfxyWPF1iGSwf27XfIr+h1BWPODdvR4m
         ZiHDnOVsBOdgENcTO68irIP4k30xKAr59Eh0dhZLfIJ2xoWTjAUyN/y613RcOU04d5yJ
         r4JkAfojglc7rH24tQNTpR+Lrtg69TwnQkJurKRBGhZ09n1Jswx+paemsTGeRIgaS6co
         Oszw==
X-Forwarded-Encrypted: i=1; AJvYcCUa3bDfOo5OE84BffooMvvmI4gfAeQT2Xl54pnHkkTzuI8ozIe3XS9oP8x/By+/4KAwJqGATlFv@vger.kernel.org, AJvYcCVDI57/yZ45jg2ECzZNj8Igzy68J5H+QomVgegrkQV1F8hZtSV5uf8Iwp/OQl4Ya1+4olQ+@vger.kernel.org, AJvYcCWRseFSBBgVbj8DtMgXI+v7L7Ymnnkk/8illAxgsdky/j90UMoOwu6jNirdyeOnr3fk4LNy23fQg5cQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yzgp5qTuH8siRQKmfzM/OZdF74SRPaTPvXymvsNXeIguxsG47QE
	HeHCPwlzzMkAUmGXGL0fbJJfQbkdIK7OpRbDJwgQvxWe6P35QoOM
X-Gm-Gg: ASbGncteyYClCrT6SvdPRdyjlidiEiFMausExb8Spjm7Gv75H2UmjGXwajyzOJ7F5vP
	O64BnCLrjJbBNgmI0x2s3TnHG2K96r3FVo2XhJEWrxGyKjSjrIV8fqEbFBqjINaE1h7RWDUXhLP
	5XH1/hTRubkgL+UN8Nbr/1GRsX5DsOkq7RQtqcslAoj0GnqtD0KBy0yPWRrjAqilMIHoGMJ8vRO
	VHGAeeJG+2++AvmBouWxFigJZAGyOuexjmzB/0IgqaN2H59F5lhgNOgNyIRPSoF/5uwYZcv9tWT
	8Vx7
X-Google-Smtp-Source: AGHT+IETJBFXpUqamvBLU8grXxKZQ+AY2R3EQGkw24VF2qKGHMZ9H+XRVksfh9jlL0WFu+e288uaAA==
X-Received: by 2002:a17:902:cecd:b0:216:6f1a:1c77 with SMTP id d9443c01a7336-21c355e8942mr497666785ad.43.1737721532424;
        Fri, 24 Jan 2025 04:25:32 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424f17esm14909795ad.255.2025.01.24.04.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 04:25:31 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id C948B4208FB6; Fri, 24 Jan 2025 19:25:27 +0700 (WIB)
Date: Fri, 24 Jan 2025 19:25:27 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
	amachhiw@linux.ibm.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/6] powerpc: Document APIv2 KVM hcall spec for
 Hostwide counters
Message-ID: <Z5OGt7AnKZaH-Zu-@archie.me>
References: <20250123120749.90505-1-vaibhav@linux.ibm.com>
 <20250123120749.90505-2-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XzZLEL+AGxInZNaN"
Content-Disposition: inline
In-Reply-To: <20250123120749.90505-2-vaibhav@linux.ibm.com>


--XzZLEL+AGxInZNaN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2025 at 05:37:43PM +0530, Vaibhav Jain wrote:
> diff --git a/Documentation/arch/powerpc/kvm-nested.rst b/Documentation/ar=
ch/powerpc/kvm-nested.rst
> index 5defd13cc6c1..574592505604 100644
> --- a/Documentation/arch/powerpc/kvm-nested.rst
> +++ b/Documentation/arch/powerpc/kvm-nested.rst
> @@ -208,13 +208,9 @@ associated values for each ID in the GSB::
>        flags:
>           Bit 0: getGuestWideState: Request state of the Guest instead
>             of an individual VCPU.
> -         Bit 1: takeOwnershipOfVcpuState Indicate the L1 is taking
> -           over ownership of the VCPU state and that the L0 can free
> -           the storage holding the state. The VCPU state will need to
> -           be returned to the Hypervisor via H_GUEST_SET_STATE prior
> -           to H_GUEST_RUN_VCPU being called for this VCPU. The data
> -           returned in the dataBuffer is in a Hypervisor internal
> -           format.
> +         Bit 1: getHostWideState: Request stats of the Host. This causes
> +           the guestId and vcpuId parameters to be ignored and attempting
> +           to get the VCPU/Guest state will cause an error.
>           Bits 2-63: Reserved
>        guestId: ID obtained from H_GUEST_CREATE
>        vcpuId: ID of the vCPU pass to H_GUEST_CREATE_VCPU
> @@ -406,9 +402,10 @@ the partition like the timebase offset and partition=
 scoped page
>  table information.
> =20
>  +--------+-------+----+--------+----------------------------------+
> -|   ID   | Size  | RW | Thread | Details                          |
> -|        | Bytes |    | Guest  |                                  |
> -|        |       |    | Scope  |                                  |
> +|   ID   | Size  | RW |(H)ost  | Details                          |
> +|        | Bytes |    |(G)uest |                                  |
> +|        |       |    |(T)hread|                                  |
> +|        |       |    |Scope   |                                  |
>  +=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
>  | 0x0000 |       | RW |   TG   | NOP element                      |
>  +--------+-------+----+--------+----------------------------------+
> @@ -434,6 +431,29 @@ table information.
>  |        |       |    |        |- 0x8 Table size.                 |
>  +--------+-------+----+--------+----------------------------------+
>  | 0x0007-|       |    |        | Reserved                         |
> +| 0x07FF |       |    |        |                                  |
> ++--------+-------+----+--------+----------------------------------+
> +| 0x0800 | 0x08  | R  |   H    | Current usage in bytes of the    |
> +|        |       |    |        | L0's Guest Management Space      |
> +|        |       |    |        | for an L1-Lpar.                  |
> ++--------+-------+----+--------+----------------------------------+
> +| 0x0801 | 0x08  | R  |   H    | Max bytes available in the       |
> +|        |       |    |        | L0's Guest Management Space for  |
> +|        |       |    |        | an L1-Lpar                       |
> ++--------+-------+----+--------+----------------------------------+
> +| 0x0802 | 0x08  | R  |   H    | Current usage in bytes of the    |
> +|        |       |    |        | L0's Guest Page Table Management |
> +|        |       |    |        | Space for an L1-Lpar             |
> ++--------+-------+----+--------+----------------------------------+
> +| 0x0803 | 0x08  | R  |   H    | Max bytes available in the L0's  |
> +|        |       |    |        | Guest Page Table Management      |
> +|        |       |    |        | Space for an L1-Lpar             |
> ++--------+-------+----+--------+----------------------------------+
> +| 0x0804 | 0x08  | R  |   H    | Cumulative Reclaimed bytes from  |
> +|        |       |    |        | L0 Guest's Page Table Management |
> +|        |       |    |        | Space due to overcommit          |
> ++--------+-------+----+--------+----------------------------------+
> +| 0x0805-|       |    |        | Reserved                         |
>  | 0x0BFF |       |    |        |                                  |
>  +--------+-------+----+--------+----------------------------------+
>  | 0x0C00 | 0x10  | RW |   T    |Run vCPU Input Buffer:            |

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--XzZLEL+AGxInZNaN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ5OGsAAKCRD2uYlJVVFO
o7OeAP9tEH+A4dQ48bRCel39A2tQlrbj3I/kc+cVpBTmLv0LTQD7Bo8tR95ewgW0
PGPhuxL/z3ZBbGPd1ZWZmy3IGQYkrAE=
=CFqD
-----END PGP SIGNATURE-----

--XzZLEL+AGxInZNaN--

