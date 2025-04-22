Return-Path: <kvm+bounces-43800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D8EA9639A
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AE60189EE4D
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B18E250C1C;
	Tue, 22 Apr 2025 08:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="feJcY1Nn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B109D9476
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745312397; cv=none; b=rWAXgd+gXJlJAcMCETmq7v958Bf/mpNXfpGo/pmDu8FSzDfkH6mPnJjAzslBbz2BPkKC/UEz7sjlITWG1YrMeh+SJ8tOgffT2HNZCjXScRxmpTiRgjPU5Cx1lSGDjlkkLiVGCuTfH5rEM8b1a6OFMA7ZSrkZE/qLMuRVwZiqDrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745312397; c=relaxed/simple;
	bh=ujyn0VKVe/xF+dYczM9VnE6xq8ijmCm9Y16p78vYay4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4uIfdrgmExqAE6+A3clDDHAsoGS8j4pqu8rxoliU+3ow/ddWtFGde9SkEb5D3kkjneh7G1xaizF9dGdxFJNFU2GQlcWf9G2NtYWy8qPEz/LG/WAXX1ywTR58COEeRXJEw5vtfoULMPNYOy9JyIiNLp8KOloIgAZiBqv9fnz6bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=feJcY1Nn; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39c13fa05ebso3451222f8f.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 01:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745312393; x=1745917193; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ujyn0VKVe/xF+dYczM9VnE6xq8ijmCm9Y16p78vYay4=;
        b=feJcY1NnT8hoAuwyW0fLxln9HsqfZtEwjJnEOUogn5zSJUZWVV8ng8kkOThcK1KwsD
         TWMgDbL7rkvT9hnUSZ7UayfZJOAe9F1fA2o/fkdc3m4Jeib4BbGWL0waxnkNONTxtfUq
         1fRHyeNuhPTFIlBaZxZodECXg/v9NrHgKIcDwevnnRyPfLHMK9JumbvJQ3yyRagFHAht
         pN+oL0GMyDo7fynC7soLvurC8JoKeO/BUU9UCLl0nV0DqA90JilMDye57+kiR2IDQNhk
         80HYFoBtpSwTE5wGxjCJcac5QYrMsBJlSs89JKj0t2GGOHw/I3ABWyY4zSsDhFz0szst
         OSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745312393; x=1745917193;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ujyn0VKVe/xF+dYczM9VnE6xq8ijmCm9Y16p78vYay4=;
        b=Wevs0m95DydexDNcPzqDK8LqmRWAadyugxV8RnpC+dkbtj1SahkF+51yaBIQjV3g6C
         e0BxMyCgxVLm71sC2O1+5yl34IMN0VHS2pmjn3QeQY6wIEA6N83T/v0JsHXxqq/NLYuu
         U3kkwvTnLD5YXDUzA2hrQUbbYAwl6SQVYX7DURkvkuyscliKPFbFo0Di+ispinn/OUio
         tDeSL3OoXZYV0Ht0tHLGtCqEIXMcNSS93f706ntkw4Cztb4jhlS/R/YC2UJi60WWUsIi
         ztKotGJy+Db3mqovXrMemaDiEz3c7r4kDU78RsWMKMeFiqSrkspRn2Kb6rifqx/4M6fC
         bMXg==
X-Forwarded-Encrypted: i=1; AJvYcCUhMT81e4cK7kn24UPMKkEp31+wHtWZrwTV7wHR6u1zDSnVAhDWgbOa/kTY02yH0sCE4r4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp+mqLvtvr3t14cIs9Ry/YkASBvWhsOUCNl5c9+4GhNmL4DBP4
	F0Wijy3jNrpgBbsRlmurai50kMeqftNoBKF/MaSfO239X4NY4qa8xRlmgnrvjmI=
X-Gm-Gg: ASbGnctYPnX5GLB7hNShoHZ7VT7XUwGgExV5mZ0qZ8BJeKr/VOtheNXyNEKGQZUIXH+
	+UkYH7/2EwZnP7ShriUPZm6myyAOrBTRgRHydU9hfA1jlG7sAii99vqoPDaySkQ2D2yy25YubLw
	VEUJlHKitoQ6LBeRyBz3YUKxJCYdKOTWqGUgUuukHhoggN3RhEW87j8eqa6zt3bowahcbqBRtL6
	mQ7MFL8PSpA2Q7ysUz0a5DFd+fCekUN524+WMTLqeWPqR3MpWYegAxShdbLT+y0hKHwp1KwWQhI
	OIcU/Hzcj7+rAr4it+E6WHawj2tqxfUMHR12msc4SmFJn5YPh1ckR84sf/lhs2AqvAYI3Zv2eXD
	4UUnSqbBhV3IoNH8QAZBO0aps99zw1ug3mR/m8PysOEOdu3wTAI315U8UK2Fs9IDUBQ==
X-Google-Smtp-Source: AGHT+IHhAxs5QMTZ7btt0BxV1tkAgF4gAnB1ObDDlK+iQMS14fyL4RdcPyHNPw8fbHs/dOwMDpgnkQ==
X-Received: by 2002:a05:6000:1887:b0:39a:c9d9:877b with SMTP id ffacd0b85a97d-39efba5eae1mr10977975f8f.27.1745312392891;
        Tue, 22 Apr 2025 01:59:52 -0700 (PDT)
Received: from ?IPV6:2003:e5:873d:1a00:8e99:ce06:aa4a:2e7b? (p200300e5873d1a008e99ce06aa4a2e7b.dip0.t-ipconnect.de. [2003:e5:873d:1a00:8e99:ce06:aa4a:2e7b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5acccdsm163039815e9.11.2025.04.22.01.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 01:59:52 -0700 (PDT)
Message-ID: <91f9217a-cc2d-4a6e-bada-290312f73d82@suse.com>
Date: Tue, 22 Apr 2025 10:59:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 22/34] x86/msr: Utilize the alternatives mechanism
 to read MSR
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-23-xin@zytor.com>
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
In-Reply-To: <20250422082216.1954310-23-xin@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------un2AYJFRoeghgHfedleEX9ZN"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------un2AYJFRoeghgHfedleEX9ZN
Content-Type: multipart/mixed; boundary="------------j8Mm72KUaJS15LtVM5GZpzd8";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
Message-ID: <91f9217a-cc2d-4a6e-bada-290312f73d82@suse.com>
Subject: Re: [RFC PATCH v2 22/34] x86/msr: Utilize the alternatives mechanism
 to read MSR
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-23-xin@zytor.com>
In-Reply-To: <20250422082216.1954310-23-xin@zytor.com>

--------------j8Mm72KUaJS15LtVM5GZpzd8
Content-Type: multipart/mixed; boundary="------------nQ9cpx1ohBCDhUhDRNjrikdZ"

--------------nQ9cpx1ohBCDhUhDRNjrikdZ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDQuMjUgMTA6MjIsIFhpbiBMaSAoSW50ZWwpIHdyb3RlOg0KPiBUbyBlbGltaW5h
dGUgdGhlIGluZGlyZWN0IGNhbGwgb3ZlcmhlYWQgaW50cm9kdWNlZCBieSB0aGUgcHZfb3Bz
IEFQSSwNCj4gdXRpbGl6ZSB0aGUgYWx0ZXJuYXRpdmVzIG1lY2hhbmlzbSB0byByZWFkIE1T
UjoNCj4gDQo+ICAgICAgMSkgV2hlbiBidWlsdCB3aXRoICFDT05GSUdfWEVOX1BWLCBYODZf
RkVBVFVSRV9YRU5QViBiZWNvbWVzIGENCj4gICAgICAgICBkaXNhYmxlZCBmZWF0dXJlLCBw
cmV2ZW50aW5nIHRoZSBYZW4gY29kZSBmcm9tIGJlaW5nIGJ1aWx0DQo+ICAgICAgICAgYW5k
IGVuc3VyaW5nIHRoZSBuYXRpdmUgY29kZSBpcyBleGVjdXRlZCB1bmNvbmRpdGlvbmFsbHku
DQo+IA0KPiAgICAgIDIpIFdoZW4gYnVpbHQgd2l0aCBDT05GSUdfWEVOX1BWOg0KPiANCj4g
ICAgICAgICAyLjEpIElmIG5vdCBydW5uaW5nIG9uIHRoZSBYZW4gaHlwZXJ2aXNvciAoIVg4
Nl9GRUFUVVJFX1hFTlBWKSwNCj4gICAgICAgICAgICAgIHRoZSBrZXJuZWwgcnVudGltZSBi
aW5hcnkgaXMgcGF0Y2hlZCB0byB1bmNvbmRpdGlvbmFsbHkNCj4gICAgICAgICAgICAgIGp1
bXAgdG8gdGhlIG5hdGl2ZSBNU1IgcmVhZCBjb2RlLg0KPiANCj4gICAgICAgICAyLjIpIElm
IHJ1bm5pbmcgb24gdGhlIFhlbiBoeXBlcnZpc29yIChYODZfRkVBVFVSRV9YRU5QViksIHRo
ZQ0KPiAgICAgICAgICAgICAga2VybmVsIHJ1bnRpbWUgYmluYXJ5IGlzIHBhdGNoZWQgdG8g
dW5jb25kaXRpb25hbGx5IGp1bXANCj4gICAgICAgICAgICAgIHRvIHRoZSBYZW4gTVNSIHJl
YWQgY29kZS4NCj4gDQo+IFRoZSBhbHRlcm5hdGl2ZXMgbWVjaGFuaXNtIGlzIGFsc28gdXNl
ZCB0byBjaG9vc2UgdGhlIG5ldyBpbW1lZGlhdGUNCj4gZm9ybSBNU1IgcmVhZCBpbnN0cnVj
dGlvbiB3aGVuIGl0J3MgYXZhaWxhYmxlLg0KPiANCj4gQ29uc2VxdWVudGx5LCByZW1vdmUg
dGhlIHB2X29wcyBNU1IgcmVhZCBBUElzIGFuZCB0aGUgWGVuIGNhbGxiYWNrcy4NCg0KU2Ft
ZSBhcyB0aGUgY29tbWVudCB0byBwYXRjaCA1OiB0aGVyZSBpcyBubyBpbmRpcmVjdCBjYWxs
IG92ZXJoZWFkIGFmdGVyDQp0aGUgc3lzdGVtIGhhcyBjb21lIHVwLg0KDQoNCkp1ZXJnZW4N
Cg==
--------------nQ9cpx1ohBCDhUhDRNjrikdZ
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------nQ9cpx1ohBCDhUhDRNjrikdZ--

--------------j8Mm72KUaJS15LtVM5GZpzd8--

--------------un2AYJFRoeghgHfedleEX9ZN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgHWoYFAwAAAAAACgkQsN6d1ii/Ey8D
BQf+OA19Vpg0eUa4ERij9S9MXvQgixkI0nFzR7la2M7mGDzjkkOaQEkFSUweGf7z1sWPEFz2Rcur
2jPu4DTZw1n2NfYf2nwEVrOyAXJPCWled0ZzTbfLlwXAg4fSvz1po/QW2sin5kuNqFUKuq3lUIXs
QBnKaTx2+pzCnVp2E+E6cKb05IPjd46gZn5Vzgc1XF0Q0RSkM4J74f+mD+GKJMEL8PqfgzTH9Gb6
uNQjjbf1nLrKiauc2xpYec2q6IndTJhHBZKvMzBVAM45WeTDAiZQFUGYtFg10xQ7N1ZKfi1z8j1+
E70SrF18uNYtrFViiyjvuYSE3PLZwksXAkLqtLb8gQ==
=hDW8
-----END PGP SIGNATURE-----

--------------un2AYJFRoeghgHfedleEX9ZN--

