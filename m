Return-Path: <kvm+bounces-28869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2362C99E388
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C812B284217
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA4F1E3764;
	Tue, 15 Oct 2024 10:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gumd+TRH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C5219F132
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 10:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728987176; cv=none; b=s5+CPmBXUjdo56GBGe1r4c0Vmh6UpGpQwrtEJwVh2zlVCqwxw4vMekU1idQ6YN9mQkL9rUHhm090FkXQXhwc/Ypx0KOc+Bd7NTveB4VGZhoycwzYu59+IEDCgUr5D3xWRNO2VuqbGgb+P/fN+GbDE3YQPR2ykz+PKVg3G7/LKak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728987176; c=relaxed/simple;
	bh=vSoaaYOQeqRc9GqEagiiWlLRBOAehSpAjIQyfG5lSfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=afOsRLm7h2ixGdqEZlmnblUhX8q9BHYcIfzSeJJyIQ8MvKkTbVvvTAFTPeFNIxaL3awtTEH0w1xfNSBbLVI5FaV93cF+D5/R7864tzE9NakeHaNZ0uXJ6ia7ctBLIqsSclIY0JY0Fi8U+xbPrGMRn4iuBdLZSrQcNc42woAyntc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Gumd+TRH; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c94b0b466cso4683859a12.0
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 03:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728987173; x=1729591973; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vSoaaYOQeqRc9GqEagiiWlLRBOAehSpAjIQyfG5lSfo=;
        b=Gumd+TRHir2oqXaMH/+xXrylc+jHyVbuBKAgl34u8DC9Ma/dDKh+XXhtwbK+YODA8C
         t/8zRsy5Y7Ib5eI0CnmeSZNd6FCd5dwLFmZmOg3X7kYrzZbyTXTm+3Jau4n5fna+0W/D
         o+sjQnPqF4UtaV2hOLtgWDxVEe71OCCjK3GrCOlHPc0Qj0xSCCxRd7Bdvom+4o0BSDYe
         eeGIr7x2sC9kaCYGxDIsddG6bgGnHG8MwMDHA+43tb7SVhXWBM9ZRi4SE3/O7YbCj2s7
         j9pRR2brNEJ/UtihNJFsXAhPgevEp/DDxMKQ3kA1a/+I4q88XxmewrbyyTYm8gVSzz0j
         KHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728987173; x=1729591973;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vSoaaYOQeqRc9GqEagiiWlLRBOAehSpAjIQyfG5lSfo=;
        b=ZWwUMzpvAGh1GKrpYMShoNwqRryooqODgNnz1afS+E3zs8TIo4NPU5XeHpAl+qXngn
         rRHz89Ti4kgKuevAZRFuWqGhHbAB9yUDHcLHcAAUzqh1FMSnJMtbA/a/sMhvOc/zImk5
         uaSkrNckMOnikTsS/P7hqtad8AnbeLCDaoGl/O2Tb6h2dGxo0dpCQTvNoq5hnMh1c7O7
         u/UoPqQV2cpkR6C6ShHNV09fkAXTH0F11dnct1nqiYJ/+Id1Yh6NofaHo5Q0YuD/+br3
         JmD5auKXp2iRmmBP3wig60rdkKRWj+N8/Cj7aCsEDvh81Kj56gRfkan1djqpgxP8mqQ+
         MALA==
X-Gm-Message-State: AOJu0YxIYT6lgfMJ96Ac/qHb1nXBO2aig7ngkot0AN8lahngiAJlh2Ds
	WnFhTxCik1cOXUsPwatPZfqui/vOMRSajXS0BuJAdvwrjyJi8uKI3hjkKDzCuVo=
X-Google-Smtp-Source: AGHT+IF7gPlaGPGrKbyznT0DJWJR7IsbzOmuooVLMz0uXnBsVrA+PSZ0AM8c68cOLjOigYZP3KI39Q==
X-Received: by 2002:a05:6402:2347:b0:5c9:4e43:3fb6 with SMTP id 4fb4d7f45d1cf-5c94e4347ecmr11689742a12.20.1728987172791;
        Tue, 15 Oct 2024 03:12:52 -0700 (PDT)
Received: from ?IPV6:2003:e5:8714:8700:db3b:60ed:e8b9:cd28? (p200300e587148700db3b60ede8b9cd28.dip0.t-ipconnect.de. [2003:e5:8714:8700:db3b:60ed:e8b9:cd28])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c98d508160sm521899a12.50.2024.10.15.03.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 03:12:52 -0700 (PDT)
Message-ID: <294ce9a5-09b8-4248-85ad-18bdea479c73@suse.com>
Date: Tue, 15 Oct 2024 12:12:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and
 TDX
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
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
In-Reply-To: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------P041BYEdFXUB66mgRDm95MPw"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------P041BYEdFXUB66mgRDm95MPw
Content-Type: multipart/mixed; boundary="------------O7ZaOy5hTsyAXAyJ8jKncxrp";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <294ce9a5-09b8-4248-85ad-18bdea479c73@suse.com>
Subject: Re: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and
 TDX
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
In-Reply-To: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>

--------------O7ZaOy5hTsyAXAyJ8jKncxrp
Content-Type: multipart/mixed; boundary="------------N8Hp0k8ba4MRBTFf2o00PcTK"

--------------N8Hp0k8ba4MRBTFf2o00PcTK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTUuMTAuMjQgMTE6NTgsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gQU1EIFNF
Vi1TTlAgYW5kIEludGVsIFREWCBoYXZlIGxpbWl0ZWQgYWNjZXNzIHRvIE1UUlI6IGVpdGhl
ciBpdCBpcyBub3QNCj4gYWR2ZXJ0aXNlZCBpbiBDUFVJRCBvciBpdCBjYW5ub3QgYmUgcHJv
Z3JhbW1lZCAob24gVERYLCBkdWUgdG8gI1ZFIG9uDQo+IENSMC5DRCBjbGVhcikuDQo+IA0K
PiBUaGlzIHJlc3VsdHMgaW4gZ3Vlc3RzIHVzaW5nIHVuY2FjaGVkIG1hcHBpbmdzIHdoZXJl
IGl0IHNob3VsZG4ndCBhbmQNCj4gcG1kL3B1ZF9zZXRfaHVnZSgpIGZhaWx1cmVzIGR1ZSB0
byBub24tdW5pZm9ybSBtZW1vcnkgdHlwZSByZXBvcnRlZCBieQ0KPiBtdHJyX3R5cGVfbG9v
a3VwKCkuDQo+IA0KPiBPdmVycmlkZSBNVFJSIHN0YXRlLCBtYWtpbmcgaXQgV0IgYnkgZGVm
YXVsdCBhcyB0aGUga2VybmVsIGRvZXMgZm9yDQo+IEh5cGVyLVYgZ3Vlc3RzLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogS2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZAbGlu
dXguaW50ZWwuY29tPg0KPiBTdWdnZXN0ZWQtYnk6IEJpbmJpbiBXdSA8YmluYmluLnd1QGlu
dGVsLmNvbT4NCj4gQ2M6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4gQ2M6
IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+DQo+IC0tLQ0KPiAgIGFy
Y2gveDg2L2tlcm5lbC9rdm0uYyB8IDQgKysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMg
Yi9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMNCj4gaW5kZXggMjYzZjhhZWQ0ZTJjLi4yMWU5ZTQ4
NDUzNTQgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9rdm0uYw0KPiArKysgYi9h
cmNoL3g4Ni9rZXJuZWwva3ZtLmMNCj4gQEAgLTM3LDYgKzM3LDcgQEANCj4gICAjaW5jbHVk
ZSA8YXNtL2FwaWMuaD4NCj4gICAjaW5jbHVkZSA8YXNtL2FwaWNkZWYuaD4NCj4gICAjaW5j
bHVkZSA8YXNtL2h5cGVydmlzb3IuaD4NCj4gKyNpbmNsdWRlIDxhc20vbXRyci5oPg0KPiAg
ICNpbmNsdWRlIDxhc20vdGxiLmg+DQo+ICAgI2luY2x1ZGUgPGFzbS9jcHVpZGxlX2hhbHRw
b2xsLmg+DQo+ICAgI2luY2x1ZGUgPGFzbS9wdHJhY2UuaD4NCj4gQEAgLTk4MCw2ICs5ODEs
OSBAQCBzdGF0aWMgdm9pZCBfX2luaXQga3ZtX2luaXRfcGxhdGZvcm0odm9pZCkNCj4gICAJ
fQ0KPiAgIAlrdm1jbG9ja19pbml0KCk7DQo+ICAgCXg4Nl9wbGF0Zm9ybS5hcGljX3Bvc3Rf
aW5pdCA9IGt2bV9hcGljX2luaXQ7DQo+ICsNCj4gKwkvKiBTZXQgV0IgYXMgdGhlIGRlZmF1
bHQgY2FjaGUgbW9kZSBmb3IgU0VWLVNOUCBhbmQgVERYICovDQo+ICsJbXRycl9vdmVyd3Jp
dGVfc3RhdGUoTlVMTCwgMCwgTVRSUl9UWVBFX1dSQkFDSyk7DQoNCkRvIHlvdSByZWFsbHkg
d2FudCB0byBkbyB0aGlzIGZvciBfYWxsXyBLVk0gZ3Vlc3RzPw0KDQpJJ2QgZXhwZWN0IHRo
aXMgY2FsbCB0byBiZSBjb25kaXRpb25hbCBvbiBURFggb3IgU0VWLVNOUC4NCg0KDQpKdWVy
Z2VuDQo=
--------------N8Hp0k8ba4MRBTFf2o00PcTK
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------N8Hp0k8ba4MRBTFf2o00PcTK--

--------------O7ZaOy5hTsyAXAyJ8jKncxrp--

--------------P041BYEdFXUB66mgRDm95MPw
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmcOQCMFAwAAAAAACgkQsN6d1ii/Ey8C
Ugf/ZXf0vHtGTa0EL5eZKwyVw0OcsmooJxSfnLryhPKC/TN/lGe1v40b5oApQL8zSf6faghhgTD5
Rpr3fWVsa5howxwHT/45ow7GBapHGR4VknccJw9HmeNjDqWl1UVgFJiULF9siKuq52WimzwU3AdO
CMQTAMJ2TwNles8Li9qyUyP2Czd5pUCjZ1GBLhEd6GDFafeYb6pUSg8LOgeiA+9y8gs4u7xqOBzn
28oC6616YAGjXUdfMnApePEppg6zjXH/epmJGTBY4J9lbd8zhy26KLdCuTv8R7B6GvfyP7P0fRTB
ALpV1KQRaq1wITLDzAMEJR9U7J+Ghe5JRVTFbVMz/w==
=d/jv
-----END PGP SIGNATURE-----

--------------P041BYEdFXUB66mgRDm95MPw--

