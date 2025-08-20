Return-Path: <kvm+bounces-55133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E22B2DF23
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1AF31C81695
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 14:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C383B26E6F0;
	Wed, 20 Aug 2025 14:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HERg6kbQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B457F1DDC2A
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 14:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755699592; cv=none; b=dpl0cWROumyR3k6rqf6DvkyG2k/MuXzSAZ2y4xs6g/GXEXI3o1790vpHL2Va3oR3ajUb6thdKekeJ/L53ZAAPtpcVGjwQX8vnyEkVZndFEpRIbj4EkTN7ZXZr7BOJsbVLM34/Q2a9G2pr3bfX3GMxA4K0V+jvEJ/B606tHU5nTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755699592; c=relaxed/simple;
	bh=U8CLmQjFv17xSyOkkQmDv+I7JHm8GHm/cO67keF3q5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s4Yelw0zuu3FMQGNYbwXrwfrFQBq3APfxpCAq8pEzQ5arUMCyv9M43pceL3zliEpxU/uz2dCQ3gWCi87TJ7QoiUFH22jYwE0FfLGL9tb8zh2h4mIDE4G3SQRpRbBGu9KInLrvKpOC5YEDCmWqzAPlE5YgcD13fVhKdDSXyjOCNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HERg6kbQ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61a99d32a84so1542895a12.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 07:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755699589; x=1756304389; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U8CLmQjFv17xSyOkkQmDv+I7JHm8GHm/cO67keF3q5A=;
        b=HERg6kbQ5v6SXAXKIHEJEk0Y/Q/PKnRXzA8OsQQ4hH0+cf63LlQ4UZCWQWfMnlVuG7
         JC8/lP78z5bmntI5ccb+ykPoD3gR9mzglf1xAqa+a7hfEmHakSeow+q4AjaUYtad7smV
         dqTZYxLRhjOz/VFF5naTnzo3SEfdYfyHWq2of5zsCWcC4yUZtl0ingC9OxyAtcK/8+o8
         fl+yNp21b7SGUJZkZlmMX8HK0PtZTS8io2tbUvjpphGpGB81zUOju6PvmkQC0KFPJv3J
         4sJb6Pn+2D9rJHfPamEKQzJJWA2Jd7HdKuku+z2OfSao2Zbvbkg89V6vQp3AxzlLxNKo
         jzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755699589; x=1756304389;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U8CLmQjFv17xSyOkkQmDv+I7JHm8GHm/cO67keF3q5A=;
        b=LnjjqpgEZDn/2tQ2LUUq/AWwjAbbXkicoT2Gju99cwQ9GMK+Qswo3x9M00a2U3eBDq
         3gDJqcySDAYyGRKu6nIkskIG9wADMc6lWtXJE2dNR70gZmwW1stDp/QV41za2ta4ya2F
         RclVQpqojepVWuRCwM4mxQ0JB1IIiH7yKPJCyAWkIZ/LUyt6mkWdzhua22vj5b6xZXxV
         A3LZ4r+PlwYOdcszcOTD5E39HX6UYfzck5jgOMqJzY3A+lXrVyNcFCxYJW52TB4klgUt
         Ay1WoEHIbR10hytRZlK0c+EJiMXmJEuWs97KNhT/HCH4BLh6We0Qok8jT2dz1HZla9SP
         p1mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUt2yyMPXgEdxXwToB4LFQM5Q5xWkcyCrKTr5KjDM/ghstSpY1XHNSjixfjRw+W75Gceyk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhkywsd/oleeUWnVzUKEzhmZk4D0Ra1ilbEOcvuYbIobkOpkC0
	jTMWSilXxa+euVyfDI76p2p9+EVcaKubxmp3KFaLw6nkBISvRpwvkp9305LHaZHzKjU=
X-Gm-Gg: ASbGncvyeBtX6ZRiqqtncfmtzJ+QJ9aM+2phtlIoqORAZc5pZUid2nPQ7J0xwz0GXA5
	6ADMMLvyVzL/U0SfYsOId/LQV6xyazGgyN6Ghx4WvQxUGhIAGK3uwtYmpQYZijLL7IQyG+n74M9
	1LI/t4c9dbWKYMGnKHJ0W60mVgd+T9FncZsnw61RGNZuFaO9fb4JJ3vavpkLLIK9kDX6wU2abvK
	hZquxK9h/0JQxc4A2DS3TYx4T1E/dDxwHZaF0C/mv0h9kS4bacft9L6m5COm3P5V8J1A5OpEW+8
	lq3vnJpq+7ohElQ3aBTcTDWpEMzeuWSU9ZppySFmtjTYWDhRGfHejMxDPoQkto67b6DU1TKKmNl
	aDnod7ZEPI71NjXUWZu8HVrvSWbxN3kXXkmP7tCZd6kXbCTCQvzAgG0kdvU936LxUQ2/Vo+yqlT
	jHBwPbkgS2UkBgCsRJFbU9J6y9IiPH6S7ZBeuOWxVWQC84JZg6ygvTngyhWw==
X-Google-Smtp-Source: AGHT+IEa+hyLHVCkOJIm32/8G6Ws0NavHQ5o0PNcr7wnugzm1A9dAGfLN1LutRoR13h5jMaHaTV+YQ==
X-Received: by 2002:a05:6402:35c7:b0:613:5257:6cad with SMTP id 4fb4d7f45d1cf-61a9761c775mr2643569a12.11.1755699588939;
        Wed, 20 Aug 2025 07:19:48 -0700 (PDT)
Received: from ?IPV6:2003:e5:872d:6400:8c05:37ee:9cf6:6840? (p200300e5872d64008c0537ee9cf66840.dip0.t-ipconnect.de. [2003:e5:872d:6400:8c05:37ee:9cf6:6840])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61a75794d3asm3593389a12.44.2025.08.20.07.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 07:19:48 -0700 (PDT)
Message-ID: <e2fc8158-6f73-48a9-85ad-b636fe01d0fb@suse.com>
Date: Wed, 20 Aug 2025 16:19:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm: x86: simplify kvm_vector_to_index()
To: Yury Norov <yury.norov@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250720015846.433956-1-yury.norov@gmail.com>
 <175564479298.3067605.13013988646799363997.b4-ty@google.com>
 <aKXQ0Z4T0RzVnjI8@yury> <2927ccc7-07f2-47c9-a902-e66114ea8020@suse.com>
 <aKXX1ITCwcVPrKNM@yury>
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
In-Reply-To: <aKXX1ITCwcVPrKNM@yury>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------OASHDLTx3DBsfkboJ6ttwajS"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------OASHDLTx3DBsfkboJ6ttwajS
Content-Type: multipart/mixed; boundary="------------DMQfAFRKnsLyMrl0PuE9Jcqm";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Yury Norov <yury.norov@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <e2fc8158-6f73-48a9-85ad-b636fe01d0fb@suse.com>
Subject: Re: [PATCH] kvm: x86: simplify kvm_vector_to_index()
References: <20250720015846.433956-1-yury.norov@gmail.com>
 <175564479298.3067605.13013988646799363997.b4-ty@google.com>
 <aKXQ0Z4T0RzVnjI8@yury> <2927ccc7-07f2-47c9-a902-e66114ea8020@suse.com>
 <aKXX1ITCwcVPrKNM@yury>
In-Reply-To: <aKXX1ITCwcVPrKNM@yury>

--------------DMQfAFRKnsLyMrl0PuE9Jcqm
Content-Type: multipart/mixed; boundary="------------GE8jrbaChHaprJwF72H11dT6"

--------------GE8jrbaChHaprJwF72H11dT6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjAuMDguMjUgMTY6MTIsIFl1cnkgTm9yb3Ygd3JvdGU6DQo+IE9uIFdlZCwgQXVnIDIw
LCAyMDI1IGF0IDA0OjAxOjIyUE0gKzAyMDAsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+PiBP
biAyMC4wOC4yNSAxNTo0MiwgWXVyeSBOb3JvdiB3cm90ZToNCj4+PiBPbiBUdWUsIEF1ZyAx
OSwgMjAyNSBhdCAwNDoxMjoxMVBNIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3Rl
Og0KPj4+PiBPbiBTYXQsIDE5IEp1bCAyMDI1IDIxOjU4OjQ1IC0wNDAwLCBZdXJ5IE5vcm92
IHdyb3RlOg0KPj4+Pj4gVXNlIGZpbmRfbnRoX2JpdCgpIGFuZCBtYWtlIHRoZSBmdW5jdGlv
biBhbG1vc3QgYSBvbmUtbGluZXIuDQo+Pj4+DQo+Pj4+IEFwcGxpZWQgdG8ga3ZtLXg4NiBt
aXNjLCB0aGFua3MhDQo+Pj4+DQo+Pj4+IFAuUy4gSSdtIGFtYXplZCB5b3UgY291bGQgZGVj
aXBoZXIgdGhlIGludGVudCBvZiB0aGUgY29kZS4gIEV2ZW4gd2l0aCB5b3VyDQo+Pj4+ICAg
ICAgICBwYXRjaCwgaXQgdG9vayBtZSAxMCsgbWludXRlcyB0byB1bmRlcnN0YW5kIHRoZSAi
bG9naWMiLg0KPj4+DQo+Pj4gVGhhbmtzIFNlYW4uIDopDQo+Pj4NCj4+Pj4gWzEvMV0ga3Zt
OiB4ODY6IHNpbXBsaWZ5IGt2bV92ZWN0b3JfdG9faW5kZXgoKQ0KPj4+PiAgICAgICAgIGh0
dHBzOi8vZ2l0aHViLmNvbS9rdm0teDg2L2xpbnV4L2NvbW1pdC9jYzYzZjkxOGEyMTUNCj4+
DQo+PiBJcyB0aGlzIHJlYWxseSBjb3JyZWN0Pw0KPj4NCj4+IFRoZSBvcmlnaW5hbCBjb2Rl
IGhhczoNCj4+DQo+PiAJZm9yIChpID0gMDsgaSA8PSBtb2Q7IGkrKykNCj4+DQo+PiAobm90
ZSB0aGUgIjw9IikuDQo+Pg0KPj4gU28gaXQgd2lsbCBmaW5kIHRoZSAobW9kICsgMSl0aCBi
aXQgc2V0LCBzbyBzaG91bGRuJ3QgaXQgdXNlDQo+Pg0KPj4gCWlkeCA9IGZpbmRfbnRoX2Jp
dChiaXRtYXAsIGJpdG1hcF9zaXplLCAodmVjdG9yICUgZGVzdF92Y3B1cykgKyAxKTsNCj4+
DQo+PiBpbnN0ZWFkPw0KPj4NCj4+IE15IHJlbWFyayBhc3N1bWVzIHRoYXQgZmluZF9udGhf
Yml0KGJpdG1hcCwgYml0bWFwX3NpemUsIDEpIHdpbGwgcmV0dXJuIHRoZQ0KPj4gc2FtZSB2
YWx1ZSBhcyBmaW5kX2ZpcnN0X2JpdChiaXRtYXAsIGJpdG1hcF9zaXplKS4NCj4gDQo+IGZp
bmRfbnRoX2JpdCBpbmRleGVzIHRob3NlIGJpdHMgc3RhcnRpbmcgZnJvbSAwLCBzbw0KQWgs
IG9rYXkuIFRoYXQgd2FzIHRoZSBwYXJ0IEkgd2Fzbid0IHN1cmUgYWJvdXQsIGhlbmNlIHRo
ZSBhZGRpdGlvbiBvZg0KbXkgYXNzdW1wdGlvbiByZWdhcmRpbmcgdGhlIHNlbWFudGljcyBv
ZiBmaW5kX250aF9iaXQoKSAobG9va2luZyBpbnRvIHRoZQ0KX19maW5kX250aF9iaXQoKSBj
b2RlIGRpZG4ndCBtYWtlIHRoYXQgb2J2aW91cyBhdCBvbmNlKS4NCg0KVGhhbmtzIGZvciB0
aGUgY2xhcmlmaWNhdGlvbi4NCg0KDQpKdWVyZ2VuDQo=
--------------GE8jrbaChHaprJwF72H11dT6
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjri
oyspZKOBycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2
kaV2KL9650I1SJvedYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i
1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/B
BLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xqG7/377qptDmrk42GlSK
N4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR3Jvc3Mg
PGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsE
FgIDAQIeAQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4F
UGNQH2lvWAUy+dnyThpwdtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3Tye
vpB0CA3dbBQp0OW0fgCetToGIQrg0MbD1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u
+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbvoPHZ8SlM4KWm8rG+lIkGurq
qu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v5QL+qHI3EIP
tyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVy
Z2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJ
CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4
RF7HoZhPVPogNVbC4YA6lW7DrWf0teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz7
8X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC/nuAFVGy+67q2DH8As3KPu0344T
BDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0LhITTd9jLzdDad1pQ
SToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLmXBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkM
nQfvUewRz80hSnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMB
AgAjBQJTjHDXAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/
Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJnFOXgMLdBQgBlVPO3/D9R8LtF9DBAFPN
hlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1jnDkfJZr6jrbjgyoZHi
w/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0N51N5Jf
VRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwP
OoE+lotufe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK
/1xMI3/+8jbO0tsn1tqSEUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuZGU+wsB5BBMBAgAjBQJTjHDrAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgEC
F4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3g3OZUEBmDHVVbqMtzwlmNC4
k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5dM7wRqzgJpJ
wK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu
5D+jLRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzB
TNh30FVKK1EvmV2xAKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37Io
N1EblHI//x/e2AaIHpzK5h88NEawQsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6
AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpWnHIs98ndPUDpnoxWQugJ6MpMncr
0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZRwgnBC5mVM6JjQ5x
Dk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNVbVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mm
we0icXKLkpEdIXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0I
v3OOImwTEe4co3c1mwARAQABwsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMv
Q/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEwTbe8YFsw2V/Buv6Z4Mysln3nQK5ZadD
534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1vJzQ1fOU8lYFpZXTXIH
b+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8VGiwXvT
yJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqc
suylWsviuGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5B
jR/i1DG86lem3iBDXzXsZDn8R3/CwO0EGAEIACAWIQSFEmdy6PYElKXQl/ew3p3W
KL8TLwUCWt3w0AIbAgCBCRCw3p3WKL8TL3YgBBkWCAAdFiEEUy2wekH2OPMeOLge
gFxhu0/YY74FAlrd8NAACgkQgFxhu0/YY75NiwD/fQf/RXpyv9ZX4n8UJrKDq422
bcwkujisT6jix2mOOwYBAKiip9+mAD6W5NPXdhk1XraECcIspcf2ff5kCAlG0DIN
aTUH/RIwNWzXDG58yQoLdD/UPcFgi8GWtNUp0Fhc/GeBxGipXYnvuWxwS+Qs1Qay
7/Nbal/v4/eZZaWs8wl2VtrHTS96/IF6q2o0qMey0dq2AxnZbQIULiEndgR625EF
RFg+IbO4ldSkB3trsF2ypYLij4ZObm2casLIP7iB8NKmQ5PndL8Y07TtiQ+Sb/wn
g4GgV+BJoKdDWLPCAlCMilwbZ88Ijb+HF/aipc9hsqvW/hnXC2GajJSAY3Qs9Mib
4Hm91jzbAjmp7243pQ4bJMfYHemFFBRaoLC7ayqQjcsttN2ufINlqLFPZPR/i3IX
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------GE8jrbaChHaprJwF72H11dT6--

--------------DMQfAFRKnsLyMrl0PuE9Jcqm--

--------------OASHDLTx3DBsfkboJ6ttwajS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmil2YMFAwAAAAAACgkQsN6d1ii/Ey89
jQf/Wk9Ij3YC00pLCDYAGQz/fknin8ZSzyHHSmtkW79s+LH+N+ldGVozGEjToypcKL7ExhvIIEPz
lKxuM2av+9iSAe+SJtxfB1rT9rcF7qBaKdxdv+z0PdiAv/3XE1WztorCvsmQIB87lY78boeQqKcK
aeyKZTxxseCDVWB3wgjKMrDHYTTSEsHIaNsHlOYs5kXPgCzeiatoFx3iXic4flXhxwihHFPmymCU
PwlMA2IQPBWuRWzD1M0MZkgJoWaVwVAzdh7J8N6DlSDDHKhCWV+Ar5285Wvd0L1/syXlmIKvzt4r
V997P31hgva2SO2rnJDpJCU7JU/jcN5uA01D1/4y2w==
=4FAF
-----END PGP SIGNATURE-----

--------------OASHDLTx3DBsfkboJ6ttwajS--

