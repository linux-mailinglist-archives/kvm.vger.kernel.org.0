Return-Path: <kvm+bounces-31348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A67B19C2B5F
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 10:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9BDF1C20F10
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 09:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F601474A2;
	Sat,  9 Nov 2024 09:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G8tV9fV7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F796145B27
	for <kvm@vger.kernel.org>; Sat,  9 Nov 2024 09:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731144581; cv=none; b=YFe/4+IcH/gfqxLwSWdx0hWWYsYYSzfIYc8hxzqW35fJgEE5lJMV+y5nJxwTl7htBjy/VOj/IEOrVm5d9+3fUfb6lt+2Wppmw49Z8HXnKblXewLzmRCHWGhstZJdoa2uFTpLX/je5avJSrDyPDMOptWZzYY9/kCdX+3qH6bKFec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731144581; c=relaxed/simple;
	bh=UqeJqRGsZ91rpkvtpak1cJ6dnroW0iyh6rQsJH7dty0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rp1UDPHxBeoweoq4zsoD3uuc+NuFtBdHnTczL+dmSSWT/Ry1ss61beykfH6BoZhTLgKuntDlhnw3v1k1+1wZUmRuE35wODlOilGUWziaUvZr5gie05ewIQM9zQKatp/8Rvd+pUb5oft8nGRLFoyajTkWIupgOjAPrFf901wMumQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G8tV9fV7; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9ed7d8d4e0so439741266b.1
        for <kvm@vger.kernel.org>; Sat, 09 Nov 2024 01:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731144578; x=1731749378; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UqeJqRGsZ91rpkvtpak1cJ6dnroW0iyh6rQsJH7dty0=;
        b=G8tV9fV78GDtmiFnu3F4d8SGz5O9QmMH48MbPUWeaJi0QK+/brvOA0PARlqWXTfbQy
         +rXx5T0LuBqmvX4bHvnrPOUL+UZ9hb5GCCOd/K8MbyFZddKnGViXVHRELEp/a35I6/Ko
         w/ajZlDboWdAxBuMyH+OIZWzjdg52cMH58Y9PgRnIP3Yz7G172Rr37m/2f96qYYpulE6
         kl0Pt+JXCo4ZqGfScie1wRkzhO7FhX+Jg5QaG4FPB3VCan9BwN8nB80MWGWzIuXka9CS
         YEgbA8ptnLXbpOk4xzoD849l3G2t+xAOLTcVuSCSEt24DU7gfOnVDfXyaWzBRv+3NVio
         gGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731144578; x=1731749378;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UqeJqRGsZ91rpkvtpak1cJ6dnroW0iyh6rQsJH7dty0=;
        b=Aaj5ArjFcYrrZBBnAWpyb4sPQvefasaptbZv8z5mniEy/zFCJrC1UMevlnGonnXGb7
         /Bu+WrSJb6L9ntmZvrWUHlhv9jO5jLMcB40E3y4cQcTVuJdAoxjVBs0BpmP6KozOXO4z
         mmOF8rH1lA5oTV7krsL1i3yGfDbHLmFJOjVMuLMC6UwZn5/+eHQG91tpkTeNdOaAt7nG
         thExSJzUlStMsD1sClWnejdsJV8hsnfo+QKnn0iHxftpxWG6PdpRlEfjPkV3sz2f4Z0b
         /fFmgdibhW11P4U5W2cyjFBbsf1TP0UOS5luLDHik16bflB9NBbPXShaDqfGUJddOICF
         od4w==
X-Forwarded-Encrypted: i=1; AJvYcCXBuAWNiBH50/jUt50+56DXwBfityOJ1aYKNcynTwsmLuk3m0T/49lSqfNvZZE2KJLRU+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdnSq817cs8lXz1m5T6nXC83nrZUPDhwv0XNy9xjy3Afh7MQfb
	+yq2hqn7C4DzbojO0aBi2j7N+n0RpnRZ1O72+xgk3zj6OPkZTmpXHahc5jtdHcU=
X-Google-Smtp-Source: AGHT+IFZ8xMxEspwFRZ5KmMHgYMuGxIG5mdHExaVuIJCOp6nOGZ8RzBp8LlFB/nkBE4xDv5O2MJlyw==
X-Received: by 2002:a17:907:9816:b0:a99:5773:3612 with SMTP id a640c23a62f3a-a9eeff3a9b5mr518659566b.36.1731144577584;
        Sat, 09 Nov 2024 01:29:37 -0800 (PST)
Received: from ?IPV6:2003:e5:872e:b100:d3c7:e0c0:5e3b:aa1c? (p200300e5872eb100d3c7e0c05e3baa1c.dip0.t-ipconnect.de. [2003:e5:872e:b100:d3c7:e0c0:5e3b:aa1c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a188d0sm338628166b.37.2024.11.09.01.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Nov 2024 01:29:37 -0800 (PST)
Message-ID: <c6f47bcf-d75d-4e00-b693-7df97599973c@suse.com>
Date: Sat, 9 Nov 2024 10:29:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>
References: <20241108161312.28365-1-jgross@suse.com>
 <20241108171304.377047-1-pbonzini@redhat.com> <Zy5b06JNYZFi871K@google.com>
 <54f44f6a-f504-4b56-a70f-cf96720ff1b8@redhat.com>
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
In-Reply-To: <54f44f6a-f504-4b56-a70f-cf96720ff1b8@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------08XkMQYCJ2Y2PZ7eWeab4P4j"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------08XkMQYCJ2Y2PZ7eWeab4P4j
Content-Type: multipart/mixed; boundary="------------xlshWiW9ZsqYMq3QT8PmTcyF";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>
Message-ID: <c6f47bcf-d75d-4e00-b693-7df97599973c@suse.com>
Subject: Re: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
References: <20241108161312.28365-1-jgross@suse.com>
 <20241108171304.377047-1-pbonzini@redhat.com> <Zy5b06JNYZFi871K@google.com>
 <54f44f6a-f504-4b56-a70f-cf96720ff1b8@redhat.com>
In-Reply-To: <54f44f6a-f504-4b56-a70f-cf96720ff1b8@redhat.com>

--------------xlshWiW9ZsqYMq3QT8PmTcyF
Content-Type: multipart/mixed; boundary="------------qf407JsnCtBHNsROutPMFClW"

--------------qf407JsnCtBHNsROutPMFClW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDkuMTEuMjQgMDk6MDMsIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+IE9uIDExLzgvMjQg
MTk6NDQsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+PiBPbiBGcmksIE5vdiAwOCwg
MjAyNCwgUGFvbG8gQm9uemluaSB3cm90ZToNCj4+PiBRdWV1ZWQsIHRoYW5rcy4NCj4+DQo+
PiBOb29vbyHCoCBDYW4geW91IHVuLXF1ZXVlPw0KPiANCj4gWWVzLCBJIGhhZG4ndCBldmVu
IHB1c2hlZCBpdCB0byBrdm0vcXVldWUuwqAgSSBhcHBsaWVkIGl0IG91dCBvZiBhIHdoaW0g
YnV0IHRoZW4gDQo+IHJlYWxpemVkIHRoYXQgaXQgd2Fzbid0IHJlYWxseSAtcmM3IG1hdGVy
aWFsLg0KPiANCj4+IFRoZSByZXR1cm4gZnJvbSBrdm1fbW11X3BhZ2VfZmF1bHQoKSBpcyBO
T1QgUkVUX1BGX3h4eCwgaXQncyBLVk0gb3V0ZXIgMC8xLy0gDQo+PiBlcnJuby4NCj4+IEku
ZS4gJzEnIGlzIHNheWluZyAicmVzdW1lIHRoZSBndWVzdCIsIGl0IGhhcyAqbm90aGluZyog
dG8gZG8gd2l0aCBSRVRfUEZfUkVUUlkuDQo+PiBFLmcuIHRoYXQgcGF0aCBhbHNvIGhhbmRs
ZXMgUkVUX1BGX0ZJWEVELCBSRVRfUEZfU1BVUklPVVMsIGV0Yy4NCj4gDQo+IEdhaCwgSSBl
dmVuIGNoZWNrZWQgdGhlIGZ1bmN0aW9uIGFuZCB3YXMgbWVzc2VkIHVwIGJ5IHRoZSBvdGhl
ciAicmV0dXJuIA0KPiBSRVRfUEZfUkVUUlkiLg0KPiANCj4gSWYgeW91IGFkZCBYODZFTVVM
XyogdG8gdGhlIG1peCwgaXQncyBldmVuIHdvcnNlLsKgIEkgaGFkIHRvIHJlYWQgdGhpcyB0
aHJlZSANCj4gdGltZXMgdG8gdW5kZXJzdGFuZCB0aGF0IGl0IHdhcyAqbm90KiByZXR1cm5p
bmcgWDg2RU1VTF9DT05USU5VRSBieSBtaXN0YWtlLiAgDQo+IENhbiBJIGhheiBzdHJvbmds
eS10eXBlZCBlbnVtcyBsaWtlIGluIEMrKz8uLi4NCj4gDQo+ICDCoMKgwqDCoMKgwqDCoCBy
ID0ga3ZtX2NoZWNrX2VtdWxhdGVfaW5zbih2Y3B1LCBlbXVsYXRpb25fdHlwZSwgaW5zbiwg
aW5zbl9sZW4pOw0KPiAgwqDCoMKgwqDCoMKgwqAgaWYgKHIgIT0gWDg2RU1VTF9DT05USU5V
RSkgew0KPiAgwqDCoMKgwqDCoMKgwqAgLi4uDQo+ICDCoMKgwqDCoMKgwqDCoCB9DQo+IA0K
PiAgwqDCoMKgwqDCoMKgwqAgaWYgKCEoZW11bGF0aW9uX3R5cGUgJiBFTVVMVFlQRV9OT19E
RUNPREUpKSB7DQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX2NsZWFy
X2V4Y2VwdGlvbl9xdWV1ZSh2Y3B1KTsNCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAoa3ZtX3ZjcHVfY2hlY2tfY29kZV9icmVha3BvaW50KHZjcHUsIGVtdWxhdGlv
bl90eXBlLCAmcikpDQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJldHVybiByOw0KPiAgwqDCoMKgwqDCoMKgwqAgLi4uDQo+ICDCoMKgwqDC
oH0NCj4gDQo+IFNvIHllYWggdGhpcyByZWFsbHkgaGFzIHRvIGJlIGZpeGVkIHRoZSByaWdo
dCB3YXksIGFmdGVyIGFsbCBldmVuIFJFVF9QRl8qIA0KPiBzdGFydGVkIG91dCBhcyBhIGNv
bnZlcnNpb24gZnJvbSAwLzEuDQo+IA0KPiBPYmxpZ2F0b3J5IGJpa2VzaGVkZGluZywgaG93
IGRvIEtWTV9SRVRfVVNFUiBhbmQgS1ZNX1JFVF9HVUVTVCBzb3VuZCBsaWtlPw0KDQorMQ0K
DQoNCkp1ZXJnZW4NCg==
--------------qf407JsnCtBHNsROutPMFClW
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------qf407JsnCtBHNsROutPMFClW--

--------------xlshWiW9ZsqYMq3QT8PmTcyF--

--------------08XkMQYCJ2Y2PZ7eWeab4P4j
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmcvK4AFAwAAAAAACgkQsN6d1ii/Ey+I
9Af/bKKCXjTcKUUSe9vrghhhoc7xIwFwOWLG436yhORDK1t6YYqGvK6GxuFk1puZABFgzNReNaNJ
hOzLVfKWa5pNKH3NF7BVlTga/BXhsL0tXPSj7HPFdRn84H/s30Jcp9GARJlN3Q+B2cuABWEWFyTa
dtW3W/sc2D8YPR/f/DsA9Sswe+Sk4M7K5dxRVhfF1JHmt8//jwF5LAbkFxWseHHtkcmz0GixYDHl
nYsS/eFgiODxE3aK3y5Wrw3MLSEt48pxHMAcQu6TyKn3cM4xYtLavGZkV6ew2hNXzhFSWeyhexox
N6U1QIfatJX1Cv06FpJwLiXU1Uo3ho4c0Ex8BqQRWg==
=MwIV
-----END PGP SIGNATURE-----

--------------08XkMQYCJ2Y2PZ7eWeab4P4j--

