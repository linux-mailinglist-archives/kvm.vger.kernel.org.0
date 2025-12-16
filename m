Return-Path: <kvm+bounces-66070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C17CC4071
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 16:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8FAEE300ADB0
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 15:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53AF38CC6D;
	Tue, 16 Dec 2025 13:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GD0uazDa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE96B346AFA
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 13:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765893359; cv=none; b=LrBrffRpGAs1/c0lXn37zI7bpU92NV2e0K7aHYLvBphyQ4+EFrWs8ezu3DIYjSWVFRZ33kSMo59yw5cKz2oHtp0gsZPodSNtYtMCoEoxhrcACyeCM76JJ7eSG5DJixfXBc82ERNddz7eSDTYM2snwjBZri1Pz2xJzN2ORpBrfh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765893359; c=relaxed/simple;
	bh=MZJ3FETBXD9TS3o6//ymZAuDIhX6kGuwiVGP8SgrP7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GZQmMVvJQJMVh+dEYPEogo1CxTStpLr9jsyCChsAFtc8VZjqwNurLCVLodeBk4wfe+R6kBEWoHf3vrIYnr9J2H2kQ6PWcHlRxzwh9yEzksD5sEudRbTQtmTj+CieAfpABRCdHhu80B3xv4q03LZKm9Upnm7M3XMVt4G1wuiydc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GD0uazDa; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b76b5afdf04so792201766b.1
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 05:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765893356; x=1766498156; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MZJ3FETBXD9TS3o6//ymZAuDIhX6kGuwiVGP8SgrP7s=;
        b=GD0uazDa9GPHfs1hiqQ33M7P0/TjkluG13nJ++HIoTqOe14m5NMOJ3WmvmKlfriJXr
         nqseMqkMUVu/2O2tKWzKQsCVh9tX16cFZYG9BaM2DUfbpOHnoXOyx79AlhbhlabWsdKR
         kYzlrDfGUiIiLd0N+gmv5D1BMjRHYQ3hMcrEqTfqp/Ezi+D9LF/78ojGNfOQ+euuw9ku
         sIwmztkuZXKHn3Rq9LaSHTy6YN5JTAmlM/L4tp0RHtcCKzoqgE0VvPzeKK7ZJXHK5hqe
         vtzeaMXcBsKNIm6z47URmA+CxHTsJsxfg398u6wVHGV5CwwVw59+nU71NI4+QM+AGPgX
         Q90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765893356; x=1766498156;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MZJ3FETBXD9TS3o6//ymZAuDIhX6kGuwiVGP8SgrP7s=;
        b=wJhQo9OrTVo/IWCOb+dNq+h0jft8TmLijDdFCjocRDLYE6VFBYwJCrXR0cY/Aat0R1
         8OoSIm7oPGA1M47/qQLOKMb3B74bZonlMZV6fYTVKfNX5b6mHPxDfrmki5kO+dngZRey
         URyq/mILSKa2Roa8M4b6Du1WA+8xW0gyFyEIdNmRUOYbpz8LoLkOqC9XGoPQKbong5+q
         8YhdiaJSxlyGRJkXEXIujSnDyMrvHuPbe/ZeFko3IvDKj5xvro63p3CX+X4da7ZeGsyP
         ePwpZH0Uxqpb6JGwbiLEvxriwUKSiHcdjPp9ZQidrwIjAcXuwrdIPN6gDSyCx46dNjiZ
         OT2A==
X-Forwarded-Encrypted: i=1; AJvYcCX+xRU4tgX8cTC8GiuKZGJRxXla8ug1tC7CJaTHMyRqQuQ4GJ/pClXUfw0Cw+ffc2DlPaw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZj8kO1YYTkIwxG27TAAxD/QupSEOBqFQGVLiQsnCQJgsI+43I
	/uwmlnRQiWOMCCKl/YJM/UdC5dtbx24vU7YgdJNnvSLD+tFZRp84eULtokvYCJveB7U=
X-Gm-Gg: AY/fxX4YFgP8BsQG97bfeX3OWIIthxzw8ICD7vKIGd6VMXkPLV8+1aZl/uNCYuUBh/v
	DbZabjQRxKo9+CSsr8Yn8MiuBSrRutdRigUTUCK7KASg6ODsaaizfV2rIYhg07W++yjhjI9OgxM
	PPB0cZ4fiQer3cVJaesAzgthTleTMW0ucgR7JGokZHWWuMZ5YZKvTi0RKInh4ZYdP2k6i1vzhZJ
	aNSlFAH6IgwvjjPAKoVW90FXJsXpvbouGZNSkLudJ1Y3n7RrhTmm9crbztOBRM6rhQsYvzY18o1
	w2fl+bL65WdGJzDhy6fmCIGnfVF8QMJKf2j2qFpKlJPaydha64VTZYT3WuBQpdyw0/bJs1pt7ZP
	bOG0RP8zu9BFd47wxJEdKGycavAci07CiD39oe7zucG8qQ4YU48nRnehiguI71MFsO+Qlj70Sr9
	8Mv50vrdl4cFVDYmlYXNJ9TDxZWzt3eP35rcFW7YDoXah0dbd2xMEHMK7LHDWPrF/LiygcSOOzW
	p6LtfBKn5YyEs0xQaWtMZzClGkRK5Xh4Fr7rdrxqmZrhDyKGA==
X-Google-Smtp-Source: AGHT+IHzZQ3OEAigaywtzQ9r+hHh1OJDEQW4HOx/O5epDoa3HSt7OtaAwfQ43xfhubj1spEkYKExSg==
X-Received: by 2002:a17:906:9fc8:b0:b79:f4e4:b55d with SMTP id a640c23a62f3a-b7d23a64a76mr1505380966b.51.1765893356035;
        Tue, 16 Dec 2025 05:55:56 -0800 (PST)
Received: from ?IPV6:2003:e5:8704:4800:66fd:131f:60bd:bc29? (p200300e58704480066fd131f60bdbc29.dip0.t-ipconnect.de. [2003:e5:8704:4800:66fd:131f:60bd:bc29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa56a7f9sm1664639666b.51.2025.12.16.05.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 05:55:55 -0800 (PST)
Message-ID: <b969cff5-be11-4fd3-8356-95185ea5de4c@suse.com>
Date: Tue, 16 Dec 2025 14:55:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] x86: Cleanups around slow_down_io()
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-block@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Jean Delvare <jdelvare@suse.com>,
 Guenter Roeck <linux@roeck-us.net>, Denis Efremov <efremov@linux.com>,
 Jens Axboe <axboe@kernel.dk>
References: <20251126162018.5676-1-jgross@suse.com>
 <aT5vtaefuHwLVsqy@gmail.com> <bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com>
 <aUFjRDqbfWMsXvvS@gmail.com>
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
In-Reply-To: <aUFjRDqbfWMsXvvS@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------hG03P9e82QtHWkQdCpdPIljK"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------hG03P9e82QtHWkQdCpdPIljK
Content-Type: multipart/mixed; boundary="------------FRi08TqW3WbnvLOkdi4sn1XX";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-block@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Jean Delvare <jdelvare@suse.com>,
 Guenter Roeck <linux@roeck-us.net>, Denis Efremov <efremov@linux.com>,
 Jens Axboe <axboe@kernel.dk>
Message-ID: <b969cff5-be11-4fd3-8356-95185ea5de4c@suse.com>
Subject: Re: [PATCH 0/5] x86: Cleanups around slow_down_io()
References: <20251126162018.5676-1-jgross@suse.com>
 <aT5vtaefuHwLVsqy@gmail.com> <bff8626d-161e-4470-9cbd-7bbda6852ec3@suse.com>
 <aUFjRDqbfWMsXvvS@gmail.com>
In-Reply-To: <aUFjRDqbfWMsXvvS@gmail.com>

--------------FRi08TqW3WbnvLOkdi4sn1XX
Content-Type: multipart/mixed; boundary="------------yS0Z00x0XwA0tB4BnEYEOAIQ"

--------------yS0Z00x0XwA0tB4BnEYEOAIQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTYuMTIuMjUgMTQ6NDgsIEluZ28gTW9sbmFyIHdyb3RlOg0KPiANCj4gKiBKw7xyZ2Vu
IEdyb8OfIDxqZ3Jvc3NAc3VzZS5jb20+IHdyb3RlOg0KPiANCj4+PiBDUFVzIGFueW1vcmUu
IFNob3VsZCBpdCBjYXVzZSBhbnkgcmVncmVzc2lvbnMsIGl0J3MgZWFzeSB0byBiaXNlY3Qg
dG8uDQo+Pj4gVGhlcmUncyBiZWVuIGVub3VnaCBjaGFuZ2VzIGFyb3VuZCBhbGwgdGhlc2Ug
ZmFjaWxpdGllcyB0aGF0IHRoZQ0KPj4+IG9yaWdpbmFsIHRpbWluZ3MgYXJlIHByb2JhYmx5
IHdheSBvZmYgYWxyZWFkeSwgc28gd2UndmUganVzdCBiZWVuDQo+Pj4gY2FyZ28tY3VsdCBw
b3J0aW5nIHRoZXNlIHRvIG5ld2VyIGtlcm5lbHMgZXNzZW50aWFsbHkuDQo+Pg0KPj4gRmlu
ZSB3aXRoIG1lLg0KPj4NCj4+IFdoaWNoIHBhdGggdG8gcmVtb3ZhbCBvZiBpb19kZWxheSB3
b3VsZCB5b3UgKGFuZCBvdGhlcnMpIHByZWZlcj8NCj4+DQo+PiAxLiBSaXBwaW5nIGl0IG91
dCBpbW1lZGlhdGVseS4NCj4gDQo+IEknZCBqdXN0IHJpcCBpdCBvdXQgaW1tZWRpYXRlbHks
IGFuZCBzZWUgd2hvIGNvbXBsYWlucy4gOi0pDQoNCkkgZmlndXJlZCB0aGlzIG1pZ2h0IGJl
IGEgbGl0dGxlIGJpdCB0b28gZXZpbC4gOi0pDQoNCkkndmUganVzdCBzZW50IFYyIGRlZmF1
bHRpbmcgdG8gaGF2ZSBubyBkZWxheSwgc28gYW55b25lIGhpdCBieSB0aGF0DQpjYW4gc3Rp
bGwgZml4IGl0IGJ5IGFwcGx5aW5nIHRoZSAiaW9fZGVsYXkiIGJvb3QgcGFyYW1ldGVyLg0K
DQpJJ2xsIGRvIHRoZSByaXBwaW5nIG91dCBmb3Iga2VybmVsIDYuMjEgKG9yIHdoYXRldmVy
IGl0IHdpbGwgYmUgY2FsbGVkKS4NCg0KDQpKdWVyZ2VuDQo=
--------------yS0Z00x0XwA0tB4BnEYEOAIQ
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------yS0Z00x0XwA0tB4BnEYEOAIQ--

--------------FRi08TqW3WbnvLOkdi4sn1XX--

--------------hG03P9e82QtHWkQdCpdPIljK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmlBZOoFAwAAAAAACgkQsN6d1ii/Ey+V
iAf9FVH0m3WXq4l8yruW3PIrj/mjEvEM0IMwcDdtj9CEaAkBhowu/FSHdVIyNNCmcOIhub1YYs58
8e0wwRGHAZxOjVI7ZUIP5hNH+RB6Ik5O9yIXDAPxEHK37EzMNPO738A0hnpG2OkugrM7UyfNxUW1
4otNpUsQ++CCamX/83gfOtKTuYymcyuj2gkrzfk+cth1IGIAvMhATN/sNlyllO5SKBnPaA9ER5HZ
sT3BHMoYq2FX2moh+Jgd0CFRwLE1R77KuxuUJIzYXv/MN8KQEiCekVCFrMD248e2p1696V47/OAQ
g2SQKlCrh1VZssHgMaSBE7Jx4c4xoejF5eVgLw+oww==
=CbB/
-----END PGP SIGNATURE-----

--------------hG03P9e82QtHWkQdCpdPIljK--

