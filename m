Return-Path: <kvm+bounces-29622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E449AE2BD
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89A351F219A3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E721C4A1F;
	Thu, 24 Oct 2024 10:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f6CtQX3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CAD1BD4FD
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 10:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729766252; cv=none; b=CWMMVZFa5POJOXvW7xX5za2bFJLU7OeTO/1IkE25fU8dEBOB5UKkeM5uRc0kyeXC2JPjqgLUlgAb4jOmywGSKnWZVpTHYrjZmg7+TDri3IXzamyayTVhcEvJSDht4nQ41LeEPQlaxpP9aw3TkFHM06DOfarxXf3qojLinNIZ+58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729766252; c=relaxed/simple;
	bh=bldPCYPiJpaAa2X0lnjjCRk9wrOiE+UF6MZbPBV2he4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WA98Ly/ZkuqsYpFsJOAzEkcwWIACTYu4b9in3efasXFigOVfkZgazHaUNmkUYwHJ0oGo4TFgTeEksIeLBrc434jyyInMg10lwH6wAlDB7gj8vVRtu9Z9E8QUlcPq5aMln8fwi/s4R8RPL3yA6QZlx1z2L7YNBZHUc5NQ62J8vEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f6CtQX3Y; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d41894a32so540061f8f.1
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 03:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1729766249; x=1730371049; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bldPCYPiJpaAa2X0lnjjCRk9wrOiE+UF6MZbPBV2he4=;
        b=f6CtQX3YwC9EuQ2qgYlEDYP4K/DNA3QUHoRfUfdeMKQ2uKAY0pjTYVie15hCZw7GcU
         9gv+vxeEjFBEYtXvZ2ZVp3o7m+JO28+fVVedq/JxFGlmO1WcjaYn4pFR7iv925nTVpZW
         ONdTx+459ftj6JXQOcR5m2Zz1qFR9DJ+mZfuqk4iW1yhyjh+mlDQYCoXMCgwakfH2o5B
         irP273wxd9Ki8yw/pLLDAYwOFgMoTg3guM7C/5BKhKHeuQUTDDpiNCxBBI9CH0SnuVgo
         7EU9fanA0DWNr38wlTAhf9T04RM2CY9NLVDpBWXrY5dERGNdY63MCuIs+B2X/y8zKx7E
         kgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729766249; x=1730371049;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bldPCYPiJpaAa2X0lnjjCRk9wrOiE+UF6MZbPBV2he4=;
        b=U5LwYTzgYTsRENaoZpU0IUNF/wwUu4ic/aNfl8fKhdq86FsM+mV3Ykj6iYRMx833Qz
         7XaQdK69hiHN5Hb4oIRBgBbaAgaJ9lH9ev5aMQbXG4aqaFuZFZGJmxVUYXa7HLFNlH8U
         hjNuT3RE9eJ3vcyusajplvCBrm1exk0i6yZGqcItizIFLZA/DyUNSrDkaXPgamuYeEQe
         sR3QNVysmcGhfBmcFTxX87SR3NIaWQ+sUtUIWqPW7BIKbmjzLgtp9pTsmfhWWvDofYoi
         8N4wdHQEzAlMHFRSzt5MtUsrkyZ6Ed8CTWrCPoH4R3GRgb9Q2d7Ssq+neHJbEK71xC90
         eNgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFoJK8/9RFUt4qFZzrVB8SBnjXROGDwgmv39A9X2nY9tPYkLzLSfAdOSjhNsAeNVUgqcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfFwUEv4yU5pbhbBuzGdz8Pegeq9DIdBpC8uVrmCd1BRQkmHa9
	Ui0WHAmfB4jgO5HZU1NXdJWQlbr9XOjIjh87s7p89yXhi25nBC3ddSuK18WItUo=
X-Google-Smtp-Source: AGHT+IFQxXUZRRnIfj/huMeQtkmfP6roIz9bX6PHch4SqeRq8+aVT/bpsAt4tB+QbzuwccWo/I7sHw==
X-Received: by 2002:a5d:5266:0:b0:37c:f997:5b94 with SMTP id ffacd0b85a97d-3803ac2951emr942090f8f.12.1729766248635;
        Thu, 24 Oct 2024 03:37:28 -0700 (PDT)
Received: from ?IPV6:2003:e5:8714:8700:db3b:60ed:e8b9:cd28? (p200300e587148700db3b60ede8b9cd28.dip0.t-ipconnect.de. [2003:e5:8714:8700:db3b:60ed:e8b9:cd28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186bfb2f5sm42252425e9.21.2024.10.24.03.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 03:37:28 -0700 (PDT)
Message-ID: <bdb08cdf-11d1-464c-950e-07d39136a15a@suse.com>
Date: Thu, 24 Oct 2024 12:37:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm/x86: simplify kvm_mmu_do_page_fault() a little bit
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
References: <20241022100812.4955-1-jgross@suse.com>
 <ZxfaU9cCS6556AKg@google.com>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <ZxfaU9cCS6556AKg@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------dyw9h1bi5H0nviXabhJ3ltFX"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------dyw9h1bi5H0nviXabhJ3ltFX
Content-Type: multipart/mixed; boundary="------------wySzuRItW6TIPKtEVQa4uu3W";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <bdb08cdf-11d1-464c-950e-07d39136a15a@suse.com>
Subject: Re: [PATCH] kvm/x86: simplify kvm_mmu_do_page_fault() a little bit
References: <20241022100812.4955-1-jgross@suse.com>
 <ZxfaU9cCS6556AKg@google.com>
In-Reply-To: <ZxfaU9cCS6556AKg@google.com>

--------------wySzuRItW6TIPKtEVQa4uu3W
Content-Type: multipart/mixed; boundary="------------imQuVRZiVyxrOVSSgPLoJpv8"

--------------imQuVRZiVyxrOVSSgPLoJpv8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMTAuMjQgMTk6MDEsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE9uIFR1
ZSwgT2N0IDIyLCAyMDI0LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gVGVzdGluZyB3aGV0
aGVyIHRvIGNhbGwga3ZtX3RkcF9wYWdlX2ZhdWx0KCkgb3INCj4+IHZjcHUtPmFyY2gubW11
LT5wYWdlX2ZhdWx0KCkgZG9lc24ndCBtYWtlIHNlbnNlLCBhcyBrdm1fdGRwX3BhZ2VfZmF1
bHQoKQ0KPj4gaXMgc2VsZWN0ZWQgb25seSBpZiB2Y3B1LT5hcmNoLm1tdS0+cGFnZV9mYXVs
dCA9PSBrdm1fdGRwX3BhZ2VfZmF1bHQuDQo+IA0KPiBJdCBkb2VzIHdoZW4gcmV0cG9saW5l
cyBhcmUgZW5hYmxlZCBhbmQgc2lnbmlmaWNhbnRseSBpbmZsYXRlIHRoZSBjb3N0IG9mIHRo
ZQ0KPiBpbmRpcmVjdCBjYWxsLiAgVGhpcyBpcyBhIGhvdCBwYXRoIGluIHZhcmlvdXMgc2Nl
bmFyaW9zLCBidXQgS1ZNIGNhbid0IHVzZQ0KPiBzdGF0aWNfY2FsbCgpIHRvIGF2b2lkIHRo
ZSByZXRwb2xpbmUgZHVlIHRvIG1tdS0+cGFnZV9mYXVsdCBiZWluZyBhIHByb3BlcnR5IG9m
DQo+IHRoZSBjdXJyZW50IHZDUFUuICBPbmx5IGt2bV90ZHBfcGFnZV9mYXVsdCgpIGlzIHNw
ZWNpYWwgY2FzZWQgYmVjYXVzZSBhbGwgb3RoZXINCj4gbW11LT5wYWdlX2ZhdWx0IHRhcmdl
dHMgYXJlIHNsb3ctaXNoIGFuZC9vciB3ZSBkb24ndCBjYXJlIHRlcnJpYmx5IGFib3V0IHRo
ZWlyDQo+IHBlcmZvcm1hbmNlLg0KDQpGYWlyIGVub3VnaC4gOi0pDQoNCkknbGwgbW9kaWZ5
IHRoZSBwYXRjaCB0byBhZGQgYSBjb21tZW50IGluIHRoaXMgcmVnYXJkIGluIG9yZGVyIHRv
IGF2b2lkDQpzaW1pbGFyIHNpbXBsaWZpY2F0aW9uIGF0dGVtcHRzIGluIHRoZSBmdXR1cmUu
DQoNCg0KSnVlcmdlbg0K
--------------imQuVRZiVyxrOVSSgPLoJpv8
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------imQuVRZiVyxrOVSSgPLoJpv8--

--------------wySzuRItW6TIPKtEVQa4uu3W--

--------------dyw9h1bi5H0nviXabhJ3ltFX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmcaI2cFAwAAAAAACgkQsN6d1ii/Ey84
Kwf/e9NYpFsJGTjB0NgUfPWxP5oBktb4P1kwteNWjtyEHHYyW1b6zlskHIJxGhLfkHnF4AjeCRy8
iJ+2etdbqcjPZiGNpDcvAPoTqJ4J5tVMMB3JhDtGXY69CeA2NqyDms5yE41uutSN8F8P5RFaINu1
gjHt+lns/ynuG/CYYihv0asQ4zAOX6fY8ld/Eih3bt6kfu4gS8EFH5I8P+cKeIrvkoCTsFsViix8
JnJ9LyTeofAWKV83vpXfEP1r1Cy+65c7PzJ2BDebCKag61YCwzVTq30D/OfdTQcfIPBJqqR/Gqe0
Ej9WZZxZ2rMEHYXp6JWbCPuAonexPHPN/6I9+rIqNg==
=iXMj
-----END PGP SIGNATURE-----

--------------dyw9h1bi5H0nviXabhJ3ltFX--

