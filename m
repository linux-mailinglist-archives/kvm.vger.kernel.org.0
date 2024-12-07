Return-Path: <kvm+bounces-33239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8319E7DC2
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 02:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 039F528662B
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 01:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154B517758;
	Sat,  7 Dec 2024 01:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3HkUm55"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF40724B34;
	Sat,  7 Dec 2024 01:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733535490; cv=none; b=bLncnz05CNjJGd1nyqJ9gSGBO7ipYW4cPsU/vKDzapFN6BfZhzinD3LvIQOLylD1DqHRSbaowhz8BapwFRTI28wvL3Qo79lJgM5bxemQ3J/NS6AdxbSJf7spAgf2Z2T7KlQUynGoWs93SglK678LinV4mSk6MDjTBRbMnH2pWX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733535490; c=relaxed/simple;
	bh=nZTOGp1r7hkR99Iod6P2AZ3fuJ0kLpzFWImMNOngyTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FMUnO5XybdvB87cn7YNpfZnKmz5vErZeqmR81sytz1fWmS77eqNZXm0j0oqBuEcgcXzGAP9Lu74CFOKK3Y60pFYyBsOpSJT/5GFIdcRcwFXsaxuq/n9PBgk/TU0VNsoTd+KFmay/8sAcD3r7pqFs1LoZN1jCoJ9dJ8TC/CmlyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C3HkUm55; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee989553c1so2321144a91.3;
        Fri, 06 Dec 2024 17:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733535488; x=1734140288; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZTOGp1r7hkR99Iod6P2AZ3fuJ0kLpzFWImMNOngyTU=;
        b=C3HkUm554SC/pFPrQ+wDv9P/LXOunY+AjlQ1BmI5qrO2hPzHxewCtogYlBDKkj7fRa
         Urdii+WrbXJYT5GtvpN0AVu+lHTQPpBfXLl/Of9VbO1cMGl1eTRuMMFE/fkbnTKoO4oY
         YnQGaxmUa/61k3ONPrW6haRSQjbCkDup+LXR1t/8vxiOQoD3iCJuwyE7d+9OpNPReTtd
         1ZpG6TLBcQrXP2Eco243GRRn6yEEq2dVWbClHRPjAnjcNd1WGmj5wRWvrRrC/OkUHmRN
         Z6rIWZEVe5BiNKAfG0az+CuFovljRQKiVwhNuzfYxshAh0qT04CsDDtQhwtOR+4wGr0c
         uEsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733535488; x=1734140288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZTOGp1r7hkR99Iod6P2AZ3fuJ0kLpzFWImMNOngyTU=;
        b=tmi9pYRFj2dLrtGKLvV6uSaUaNzE7SdVTwn3UbljLiaWetkXxLZ9j61eTy5d6TyvQv
         D2LZxET2f1rakYTFRDibjW4Sym8djBCzJdeCZRW7AfJRfv+nvZfn8wg27BiL4EpKCOZ0
         /HlT5E0ZZFrZmbCvZWU0vTkINcu7lxqtn8/z4w88hXERIq7JE6WTdHgtXAWznmwW/AvK
         YXpv0RfshqqyD8H6httZs5KZRuYdI1miLdDfkygCT4TZaJORP9llhLMAaDUynq49y1q3
         tPpinZqvUsW/wtsFFYpjtkkmhkNUhI9B+6wE8bSeWFIuLCeGmTueAVi8qXipa+YZOH4T
         y28A==
X-Forwarded-Encrypted: i=1; AJvYcCVDJd8UdXkAC5TjW5Rj/o4gFOwysB3r+y2FTZRzA8NlaMsNa0Z/9mIF5AdV8qvC/Y2xEuo=@vger.kernel.org, AJvYcCW/us+y5WtLSPHHivB2jdm4x9q1Vh64TmOzV3UPXkLsTwbagI3e5rC9OD9cE84qukmz9iM7QzecT/zz1r+g@vger.kernel.org, AJvYcCXJ20NpVJNYYYrotRZ2OdoEdjLoLC8mW3qNDxBvdV86VGpfq80RBkVv7RABIdNX/jHqNKWNf9Oo5gAD@vger.kernel.org
X-Gm-Message-State: AOJu0YwPrtUBNHmEO8vmyOTq2PjvMvMWefgoRAHvVk3gKMDVJDkX1NJK
	yu8DjVM5HId4XVhqSWf/6buzBwN3auQb2EOJ3T9qNs9SvOWrnn8U
X-Gm-Gg: ASbGnctGTZdwgM4ZT1sN5SamRh6y20ccysxh19MBooV3Zi+6zKHwVzdaR9bBodakI8y
	DcGW0nL6cCpNV7lM70K1ppqnOc/BUEtiTUmO5U9Z/drVtxKVMuDkPBKlGv0Fh+If8RJiZp983Ff
	XVwsF3n3fXXJnHY/BlFbFNpDFNF4FS4uUtFhZ31KNLigvQNQfRuh+nr+brtGDLM6RILKecP/gxJ
	923Wp9aMnu0j76ufrAqPEwnMU0phhjcmgt7RQU0l16R7kUMMA==
X-Google-Smtp-Source: AGHT+IGVziXDCgJ7WWittmXyPHVbsnVEcC4rwZTr2Vz2SiCLVRLP7xZj3DgIfwKgkAxvqmJSueqbZw==
X-Received: by 2002:a17:90b:1fc7:b0:2ee:d96a:5831 with SMTP id 98e67ed59e1d1-2ef6ab104admr8543489a91.30.1733535488087;
        Fri, 06 Dec 2024 17:38:08 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef2701df43sm6227823a91.30.2024.12.06.17.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 17:38:07 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 96C2D4209E76; Sat, 07 Dec 2024 08:38:03 +0700 (WIB)
Date: Sat, 7 Dec 2024 08:38:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, Wang@google.com,
	Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 13/13] KVM: Documentation: Add KVM_CAP_USERFAULT and
 KVM_MEM_USERFAULT details
Message-ID: <Z1Om-1D2g3bFW4U2@archie.me>
References: <20241204191349.1730936-1-jthoughton@google.com>
 <20241204191349.1730936-14-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="THWs/xiN6GnbQcla"
Content-Disposition: inline
In-Reply-To: <20241204191349.1730936-14-jthoughton@google.com>


--THWs/xiN6GnbQcla
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04, 2024 at 07:13:48PM +0000, James Houghton wrote:
> Include the note about memory ordering when clearing bits in
> userfault_bitmap, as it may not be obvious for users.

The doc LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--THWs/xiN6GnbQcla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ1Om9wAKCRD2uYlJVVFO
o/pqAQDAcgOLkBs2QwTaz5H8Cms3BiufYbNEbuR2f2WwKNQOTwD/W/ANv/jXoqg7
C+d5nAhBL0GZGybXynXplppXnFrcDQY=
=04BY
-----END PGP SIGNATURE-----

--THWs/xiN6GnbQcla--

