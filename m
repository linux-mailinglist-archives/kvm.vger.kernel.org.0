Return-Path: <kvm+bounces-50615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CBACAE76F9
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 08:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66F5117A4E1
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 06:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6421E22E9;
	Wed, 25 Jun 2025 06:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNkVBHV7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9624018A6C4;
	Wed, 25 Jun 2025 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750833072; cv=none; b=eSJ4ucWVzTxnmXCuYZR7IjTZ3suPDX2xxf7xxNITMIqtQzXhkVITHaGzIlkngrScy8hRAysxQ0KxhBYFVwQzwIQbip8QMbA+x/YDuH7u1FdpalyNpWTXPKT/RHQAqikX9c1vxq9GEL1d9Tm/7bHUt6mArAl4AFzHkHtuiAInmQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750833072; c=relaxed/simple;
	bh=VWMmEK86o9waci3EB3HNOVJe90ev8J87isxmtuJcslU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ui6Ujfpgx9qEpNK9s3avh8lkgTreXASePLc2eShZb4RLRbUh+c13VPM5yKxDQmNyEjPKS/eCeAPoW7MdHo/nVsbHNlWnilW0YVrDFgLzxcdgJqmFdKMjlE93l9v0Je/Unqx/Vy8kl78EovrxhEsaxt41TkrDMOPBlyXgwMZ3gQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNkVBHV7; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2352400344aso16349825ad.2;
        Tue, 24 Jun 2025 23:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750833070; x=1751437870; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/z9ngd8zFRAIK74RWBIMljq6rrIA5Qki7ArcxDVjgg=;
        b=kNkVBHV73Kt3/IUIgGGbo7HOexZW9d2U2hLWENFAVSUcYudsKwk8Oeb2odW0ueai3J
         IBPHKnewwiFmEstSWLPNlY+ULF/PDFoP/qzB9FOaJEAKjWgJGG+b4hzRdEp51+E1uf30
         cRgEt5C4S3FT+UMjy3eR4tRhcoEKEKV0LwlI4tjPB4jMIM3srgR8hw2v115D5DeyZ+5u
         JOj3ypfKWInp2QKoJHnQiJaw9/YcrXKKMo/y6C4gPkd+tX0a7e5vu4i+auD1WkX4uis2
         V5vhhdoKVz117edtQF7HSz+LtLwNnjm5T/xSO/OFGx2P+4LmPyiMtJqqIJrFmvwExL6I
         4zRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750833070; x=1751437870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/z9ngd8zFRAIK74RWBIMljq6rrIA5Qki7ArcxDVjgg=;
        b=ZovHEgsqnqzPHfKdKLjX6oUOeGV8gDS8rsz/VF2Y81Fjpax5jNyjW7LhgR31N+ntEs
         lJpAb/sk4FKeqvQLgV5880Au7vhy/umauSglMHOigf+7tb47Vegwn60jMmTn1Q9VTb00
         V0+21oNMJ9dHA1Nmpqjb6ackmmnSIcZVz2R72DjLw8FcofxtYDJlIX56d5rBd05s9iKL
         4+98MEu0ytwHn8n9UUHvuiIsnEVcpIrA7PDSXQ/rtiPzWQ0E/wik26akNsFAbTLRfVEZ
         sA9FWb/AkmoIecAaTZgJd4Cz/ufVE/mS/sWfifw4mOWNNe3Anh9maRZJNzb3Ty20D0KS
         h48g==
X-Forwarded-Encrypted: i=1; AJvYcCUd0KLWPvXBhszuVLDYlYdRxRGVw7zxBAcRq7DM8ZXp2UVcTZuUp45WlxpJWNkP4HYiIFI=@vger.kernel.org, AJvYcCWq5zvKqMs7eSPmOWamNLSFddN5JsBqpgr4EkoRJDiQt/1r7QdcysWJ4u4wJggtvbZh+DkN+KznvhCpNRHy@vger.kernel.org
X-Gm-Message-State: AOJu0YwL5CzuOZH0zKzZwnNufwBLG5e2yvU4qKZlaxS172ctOhH7/ASj
	usUImKQYN2MvV8Q1+r9hSNOKWCTvaWE1nKwEdVeGMKGeCpzHYMYnjT7II04vSQ==
X-Gm-Gg: ASbGncuJkBgGKEC7gJib0CXr5PH2/mSTpM+IDybBuqAqahv4hicNfmDjInlwUJoqZaL
	cmMOQnnBFFX73uTZZECUV0WUgZbOrSQ677a7aQfo9drNMhhrigFEowO/OQAknKOM2F1VzL2uhzn
	YJoaIUTMHcf4VjaQw+YVCvBHgS1TUDSSiNjSvHgJOdK7aJ7LCvZwWv4LOLrDBsp8PSvnHBB3Ter
	DB7LtbpBFMLrPlEsjJObKI7BKjDPxs0uJxzZBMgNCSk4lxCeHoJhHKTFtTsjhDSKj2NBOioKXvx
	/AFaKOqmnrKMJaEOdBbWuys2BJtSgTVfSvf6H1RGFSMUvlpVenMJfNWBt4B+vg==
X-Google-Smtp-Source: AGHT+IG244W/fN34/CD8bjiYs1J85Uc0mGYhzQ6XAiQJSMUMCZ12AC0ZO1+fbYsH+GVD3vutgE3G+w==
X-Received: by 2002:a17:902:ec90:b0:235:e8da:8d6 with SMTP id d9443c01a7336-2382454566fmr34479815ad.2.1750833068214;
        Tue, 24 Jun 2025 23:31:08 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d86d563fsm126520685ad.207.2025.06.24.23.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 23:31:07 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 7C7DF4207D12; Wed, 25 Jun 2025 13:31:02 +0700 (WIB)
Date: Wed, 25 Jun 2025 13:31:02 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
	seanjc@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: sfr@canb.auug.org.au, rick.p.edgecombe@intel.com, kai.huang@intel.com,
	adrian.hunter@intel.com, reinette.chatre@intel.com,
	xiaoyao.li@intel.com, tony.lindgren@intel.com,
	isaku.yamahata@intel.com, yan.y.zhao@intel.com
Subject: Re: [PATCH] Documentation: KVM: Fix unexpected unindent warnings
Message-ID: <aFuXpoxMLa2Qj_S9@archie.me>
References: <20250625014829.82289-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KyriZ8LMcR1w2jqJ"
Content-Disposition: inline
In-Reply-To: <20250625014829.82289-1-binbin.wu@linux.intel.com>


--KyriZ8LMcR1w2jqJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2025 at 09:48:29AM +0800, Binbin Wu wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 9abf93ee5f65..a7dbe08dc376 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7210,21 +7210,21 @@ number from register R11.  The remaining field of=
 the union provide the
>  inputs and outputs of the TDVMCALL.  Currently the following values of
>  ``nr`` are defined:
> =20
> -* ``TDVMCALL_GET_QUOTE``: the guest has requested to generate a TD-Quote
> -signed by a service hosting TD-Quoting Enclave operating on the host.
> -Parameters and return value are in the ``get_quote`` field of the union.
> -The ``gpa`` field and ``size`` specify the guest physical address
> -(without the shared bit set) and the size of a shared-memory buffer, in
> -which the TDX guest passes a TD Report.  The ``ret`` field represents
> -the return value of the GetQuote request.  When the request has been
> -queued successfully, the TDX guest can poll the status field in the
> -shared-memory area to check whether the Quote generation is completed or
> -not. When completed, the generated Quote is returned via the same buffer.
> -
> -* ``TDVMCALL_GET_TD_VM_CALL_INFO``: the guest has requested the support
> -status of TDVMCALLs.  The output values for the given leaf should be
> -placed in fields from ``r11`` to ``r14`` of the ``get_tdvmcall_info``
> -field of the union.
> + * ``TDVMCALL_GET_QUOTE``: the guest has requested to generate a TD-Quote
> +   signed by a service hosting TD-Quoting Enclave operating on the host.
> +   Parameters and return value are in the ``get_quote`` field of the uni=
on.
> +   The ``gpa`` field and ``size`` specify the guest physical address
> +   (without the shared bit set) and the size of a shared-memory buffer, =
in
> +   which the TDX guest passes a TD Report.  The ``ret`` field represents
> +   the return value of the GetQuote request.  When the request has been
> +   queued successfully, the TDX guest can poll the status field in the
> +   shared-memory area to check whether the Quote generation is completed=
 or
> +   not. When completed, the generated Quote is returned via the same buf=
fer.
> +
> + * ``TDVMCALL_GET_TD_VM_CALL_INFO``: the guest has requested the support
> +   status of TDVMCALLs.  The output values for the given leaf should be
> +   placed in fields from ``r11`` to ``r14`` of the ``get_tdvmcall_info``
> +   field of the union.
> =20
>  KVM may add support for more values in the future that may cause a users=
pace
>  exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,
>=20

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--KyriZ8LMcR1w2jqJ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaFuXnwAKCRD2uYlJVVFO
o/ZcAQDEmscUf690FtG11NjUGtksSU/l4/aDjLtqVkkjrjdEIwEAtPaKvUZIB0N0
HiF6q3sjcMH9qCYR7TsgaW2yKKT1UQ4=
=+B1+
-----END PGP SIGNATURE-----

--KyriZ8LMcR1w2jqJ--

