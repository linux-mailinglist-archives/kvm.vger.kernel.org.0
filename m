Return-Path: <kvm+bounces-31318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C9FD29C2572
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E71ABB24014
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2985D1AA1D9;
	Fri,  8 Nov 2024 19:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TAm/Ib45"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9C6193081
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 19:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731093503; cv=none; b=APip7ESbCPz4BTLbZll+XyQdCpH7eGvaTHorsv26P3XHYK6Ta1KdEfKjr6rpsrkp26OgwEnZLHSuPBCIEBf6vYZIcV09/NeD4tSUpkACTBbkQiSojqyAt7Da5OR7qxjJ7K406Xl7z5Sn+07qpzww25gGD9Qk5TkNCwZIvfoiW+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731093503; c=relaxed/simple;
	bh=ot+Fjf9w5PbxlfmHUpu/rFHYB+FUYawfSLxcz+0z9B8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hTeplsiMzh/mwH/QIs1x5b6MrOaVCuHdTPUZF3fXKFnKFlZVMB/YdRDv0yWziePiOy+RWh+IKMD5syMtM1R9A5lefUsX8zfv7ZluFUqjN9xBDKFmAaH2p8lyvW40IeoFZi9manWHLvqgZZLpLRmlWaLTP/qyAX8QxS4NrwBkzUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TAm/Ib45; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5cedf5fe237so2955963a12.3
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 11:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731093500; x=1731698300; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ot+Fjf9w5PbxlfmHUpu/rFHYB+FUYawfSLxcz+0z9B8=;
        b=TAm/Ib45ToGSvogltnEDHTc1B5JlPF2RWSTQQ89gyWDCxPoffufNnCUBJvj3Au/kyi
         8hrhTLwZxF6SOWFPVoi+QjIn7r0lNDxsjF3PXCu8fr9aXNGyF6Fqu85YUxdQncbpxhb2
         Hh2vqDx8ghpjPrIjEkySL78yCup21RNSrA4nZMT1fq/tiMMTFKyuXkBevpP8x/Up/0Uh
         440ExFiuiJtDTVefbO0nkbr31HenO5zOwX8wnShkGsdEyGe87JGKf2LnmUTsEFnmF91J
         j55RkoE+7trMoFNAwd2W0LkRSjLHPzdSzaDwGEFNuh8SBechqacvaSyeagsfOlvwqhg/
         tadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731093500; x=1731698300;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ot+Fjf9w5PbxlfmHUpu/rFHYB+FUYawfSLxcz+0z9B8=;
        b=GFyAwdVDq58vfYnz4MjMmYUR/2GL1khVcjPTbqjblc4YLaauQ7x4tkmCGKONqjVjB2
         M+0qqeYT5zV91olhYZ8k0pGY9FDSt9rSzCCZIKbpyG5UP6V7p2uVBOjQ4uMf4rPoaHlz
         7EjPcOZtyigW6gt5xdoLLgRHuwwGAhsX+RG+dUbIZMXkLhiau3LV40HXW6RWMlcGemJP
         iRv7j5tKk8s3chNnZQaSN01vvsI9WMI4kARIqTPBz0FwVnrexS0LqjRklRvre2Zimx0F
         4gYqnvG0sIsmMEO4+dxUNc+l3pD2zj4lkzdQC945zkuFSJ6tgznKmPkm6ziiAPRBRTPE
         8EYQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6EUqnuXrHuTJkZayirkY2n6A/NhJj+gX8wQ+3eNaj7vsnXmIGgUg+yxyl8qyowL+MTcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVX/OWthtqKRRVMRYWvSirdzg6LiS7m68bfMFF+Ieb8oSqIx5J
	8R9pdVgPz4B4Kd+rAalAJCj8/OucxWcvBfAiU1AuqR4FKbht97i5SrPQlpNIaII=
X-Google-Smtp-Source: AGHT+IEWBjfr70TAovsyZ7L0doihlWnwN4UzhmfaZseQMl+fZwAQK3nFquDaxqI7jyjADKsj4yDIdQ==
X-Received: by 2002:a05:6402:4305:b0:5cf:568:292b with SMTP id 4fb4d7f45d1cf-5cf0a4725d8mr3375954a12.30.1731093499705;
        Fri, 08 Nov 2024 11:18:19 -0800 (PST)
Received: from ?IPV6:2003:e5:872e:b100:d3c7:e0c0:5e3b:aa1c? (p200300e5872eb100d3c7e0c05e3baa1c.dip0.t-ipconnect.de. [2003:e5:872e:b100:d3c7:e0c0:5e3b:aa1c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03b7e7f8sm2253407a12.23.2024.11.08.11.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 11:18:19 -0800 (PST)
Message-ID: <854e43f7-0eed-4a1b-8ede-37c538791396@suse.com>
Date: Fri, 8 Nov 2024 20:18:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>
References: <20241108161312.28365-1-jgross@suse.com>
 <20241108171304.377047-1-pbonzini@redhat.com> <Zy5b06JNYZFi871K@google.com>
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
In-Reply-To: <Zy5b06JNYZFi871K@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------l6YuToJJ8GXce1eoTyclTU0k"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------l6YuToJJ8GXce1eoTyclTU0k
Content-Type: multipart/mixed; boundary="------------1oQVASFcitAoUu0ZzxOuNN0S";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>
Message-ID: <854e43f7-0eed-4a1b-8ede-37c538791396@suse.com>
Subject: Re: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
References: <20241108161312.28365-1-jgross@suse.com>
 <20241108171304.377047-1-pbonzini@redhat.com> <Zy5b06JNYZFi871K@google.com>
In-Reply-To: <Zy5b06JNYZFi871K@google.com>

--------------1oQVASFcitAoUu0ZzxOuNN0S
Content-Type: multipart/mixed; boundary="------------JAGsZAKj5c394KgHaQWcgnw9"

--------------JAGsZAKj5c394KgHaQWcgnw9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDguMTEuMjQgMTk6NDQsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IE9uIEZy
aSwgTm92IDA4LCAyMDI0LCBQYW9sbyBCb256aW5pIHdyb3RlOg0KPj4gUXVldWVkLCB0aGFu
a3MuDQo+IA0KPiBOb29vbyEgIENhbiB5b3UgdW4tcXVldWU/DQo+IA0KPiBUaGUgcmV0dXJu
IGZyb20ga3ZtX21tdV9wYWdlX2ZhdWx0KCkgaXMgTk9UIFJFVF9QRl94eHgsIGl0J3MgS1ZN
IG91dGVyIDAvMS8tZXJybm8uDQo+IEkuZS4gJzEnIGlzIHNheWluZyAicmVzdW1lIHRoZSBn
dWVzdCIsIGl0IGhhcyAqbm90aGluZyogdG8gZG8gd2l0aCBSRVRfUEZfUkVUUlkuDQo+IEUu
Zy4gdGhhdCBwYXRoIGFsc28gaGFuZGxlcyBSRVRfUEZfRklYRUQsIFJFVF9QRl9TUFVSSU9V
UywgZXRjLg0KDQpBbmQgd2hhdCBhYm91dCB0aGUgZXhpc3RpbmcgInJldHVybiBSRVRfUEZf
UkVUUlkiIGZ1cnRoZXIgdXA/DQoNCg0KSnVlcmdlbg0K
--------------JAGsZAKj5c394KgHaQWcgnw9
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------JAGsZAKj5c394KgHaQWcgnw9--

--------------1oQVASFcitAoUu0ZzxOuNN0S--

--------------l6YuToJJ8GXce1eoTyclTU0k
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmcuY/oFAwAAAAAACgkQsN6d1ii/Ey+l
Wgf+PuhmUS0NzKt32z6wY1PUAO7RjZO7LC6vuFAWESZP+1DE3Kw1bHa/TpF4Liy9QVQxIuaD7qVn
mXoMccokAuEdAdskOcSpOsSTv5HPVKKjdwbs5IQZaPd71bcZIzaDeX5HxS1AhctAQd3DOLfYGeWi
biF2UZrhm1qGS8n43lZ/cUcjUYttXh0E7t4xmWioCEXLHmfPxMKBhnCwo0Sz7U2NJhG+JoUZSR7X
Tg1KGROpoF4w7yCKkmeNXSxsoAJb3x1eHZuAMWR9P/seByLw9YNMkdq5DZDe+9lG4Xn9cMSiqxLB
X243UwgsVxZ+oM65m4WEDJX8eWQH4JsZA3d9GgIRFA==
=vCy9
-----END PGP SIGNATURE-----

--------------l6YuToJJ8GXce1eoTyclTU0k--

