Return-Path: <kvm+bounces-59274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85CC6BAFD54
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 11:15:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47FAE7A667C
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 09:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DD82D949E;
	Wed,  1 Oct 2025 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GtNWybiZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1120A2D8DD4
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 09:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759310082; cv=none; b=lt1R9pzjloHsu++Oj54rZck0SgIl+8TfbonIG/v72aA1caV3oozTUuJvgfkO01jXDV3qSOKx+F2oNpEmD2z+IN5qeVOJVO7zkxewbfmz94g2kLv0PUTelDQY06RcIIA8XFTIJ2lURHemGMixMZ31z5XnnHxdDjL6s+fr7E+QHkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759310082; c=relaxed/simple;
	bh=U5/mWF2eT719ERlEO+VsG/7r+9lp2+vAGBmIyIfsoA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lkm4jQWi/0VH86xCTw6zR8ObTOcgMzGLCRrYcRllw350XTWHTHUUE+/UcLlb9MWtaVD0fHtp54047RTfOWzoJOEkkNJNWQaxE6fOgKZkbSkRlFa+mCQBbpl5/UZjpdVV2wnl4Ny35Q+Jui6jf9t4FINIwiVJxQhGvz1iIrFuhF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GtNWybiZ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e4f2696bdso47783395e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 02:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759310078; x=1759914878; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U5/mWF2eT719ERlEO+VsG/7r+9lp2+vAGBmIyIfsoA0=;
        b=GtNWybiZ1KalovDccxG0v4CYAZFQ9JS8mgs2utN9hZ0Wxu21sbxYmSOdtCLsvttN08
         WLOHPBBdYyfDAVxxku2jvsKKl6r97gUBbFW+OV/E+sLeHf33XIpV7RiwmJAuT+EjT2NN
         fK9fqCebx0NsqAqFL+XFD6LFA7X5kG7x3FLfjgFBbTlCTrvoSX6jFOvS3j/37BcukJxR
         WAtQ6s8WIcNVvH5tSNzJcD+Qze0KiLqX9GIBpmXqQ4fe+pIU/Hcy5xvLhdIQhZ98Aa9Y
         7LgquwNEDm8FU1YhwoCRcaeZ58sWbGFEHYAA0YYYp6iNbMX9BK1AxSTFClSdXDuKnFuQ
         yOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759310078; x=1759914878;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U5/mWF2eT719ERlEO+VsG/7r+9lp2+vAGBmIyIfsoA0=;
        b=OWIBe0E5KtNBU34LBrA5dXhxvSsDhEU9cJ6iRtG8tIHzAzUbBsTgdKssDQUpzWJX4i
         Mg9NMnacqCuGNN+vjDvDrtHHBIH3RB/RclH+1+RzbGGgFMwJ9NNvMoXLvFjl6tXqLhG8
         tGhRjbdoDq/OOpTsF5JV3WIhWoItF7ffUUbNVh/yGJarwB+IJQmH6/uTyDonbMJGz5pV
         REhmJ93A2Cb2P8K9U+BZMgY3xX82HmAMFrmhSSb1CFGjL91ZvKywIHv8NcE6UCkdAsov
         jWEgTNWQtW2Kc4HCtH+3HF7IPx4melcbyeGY5FVzUriXn6pqf2G3wzsqFQ1NW3edbx+l
         xBtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaWl3l8YWslItDkQBbIRm/8ABTKDgXY60gTWwMfj1uCu4NKMhqD2if5iN2p0u3oVqRDLs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw5m5Xh5fCSRc7lQJwB3EGZeg7ISAq6SGJ6MqYcVnnbufDkIDV
	m31+jCsgbA5Rh6CvJePpyBTaKBI1RcF4aAttsXp+Nzn04O7sBTUnXxaPh4embb/JPYk=
X-Gm-Gg: ASbGncsI1rMyiQIxy3YSMw1xNRiCSjpfu0XVnyXhpgI6funQTJQAs2cJgs6qmkcYfZS
	DSplFdICCId4pbjg71497u+RV5JmdB3pnVWYw1r9BxrfeOFOQ3ZKM5yTVWA1Id4bhsoG9TyGpgJ
	ffBiB8DhIMDo5+zhMXFw6dnPN/gXLIPxhk7RD8XNLPIgojbPohstU4xQFt9xnwD61QWxpb22WGm
	+tLxKofJbWU1XnPClx6t+QEeAayo3BbxSZVpj30zpBgAyv1qXloqvxViZuNYveq6UtI8SatjudQ
	qUlCP1h/kd2Qjt2gfCIWeNLLM9lr3+NvdYd6G+I9kWZbIHwCF7ZBVMYjkqaQtzEdr8PMbD0qdro
	rhEk0RAWlsE6yAOz+kMp9czuDiPdZA8szDKx2YL0aUL/vZYBup4vIiDa3wRBu3dC7YlQpY7DxdE
	gG2XsatO9GYLEVITsbuSQ7XY9crYToZWYmoIyM33ciWDeKRlF588yvBXYWRYr9TtmnIfaL
X-Google-Smtp-Source: AGHT+IHdQhbSAex+R6vWQfJv25cLINdEYUVtsCdbJWv9HhYGgpyniumEcBLkuGXKEPs7b/1Yg8YwnA==
X-Received: by 2002:a05:600c:3543:b0:45d:d68c:2a36 with SMTP id 5b1f17b1804b1-46e61281448mr22040615e9.27.1759310078422;
        Wed, 01 Oct 2025 02:14:38 -0700 (PDT)
Received: from ?IPV6:2003:e5:873f:400:7b4f:e512:a417:5a86? (p200300e5873f04007b4fe512a4175a86.dip0.t-ipconnect.de. [2003:e5:873f:400:7b4f:e512:a417:5a86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b8507sm30583175e9.3.2025.10.01.02.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 02:14:38 -0700 (PDT)
Message-ID: <281800ab-30bb-4939-8f20-0993a1e6b0f3@suse.com>
Date: Wed, 1 Oct 2025 11:14:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/12] x86/kvm: Remove the KVM private read_msr()
 function
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 xin@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20250930070356.30695-1-jgross@suse.com>
 <20250930070356.30695-4-jgross@suse.com> <aNv_lWzVqycCUZIi@google.com>
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
In-Reply-To: <aNv_lWzVqycCUZIi@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TrUtvkp0TauRyjp2nwWIKfjg"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------TrUtvkp0TauRyjp2nwWIKfjg
Content-Type: multipart/mixed; boundary="------------qfX8g3Ov94hVZdf0FX8oINEy";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 xin@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <281800ab-30bb-4939-8f20-0993a1e6b0f3@suse.com>
Subject: Re: [PATCH v2 03/12] x86/kvm: Remove the KVM private read_msr()
 function
References: <20250930070356.30695-1-jgross@suse.com>
 <20250930070356.30695-4-jgross@suse.com> <aNv_lWzVqycCUZIi@google.com>
In-Reply-To: <aNv_lWzVqycCUZIi@google.com>

--------------qfX8g3Ov94hVZdf0FX8oINEy
Content-Type: multipart/mixed; boundary="------------oOMO04Esfdn5Zk7quz0HiTts"

--------------oOMO04Esfdn5Zk7quz0HiTts
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMzAuMDkuMjUgMTg6MDQsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+IEZvciB0
aGUgc2NvcGU6DQo+IA0KPiAgICBLVk06IHg4NjoNCj4gDQo+IGJlY2F1c2UgeDg2L2t2bSBp
cyBzcGVjaWZpY2FsbHkgdXNlZCBmb3IgZ3Vlc3Qtc2lkZSBjb2RlLg0KDQpPa2F5LCB3aWxs
IGNoYW5nZSB0aGF0Lg0KDQo+IA0KPiBPbiBUdWUsIFNlcCAzMCwgMjAyNSwgSnVlcmdlbiBH
cm9zcyB3cm90ZToNCj4+IEluc3RlYWQgb2YgaGF2aW5nIGEgS1ZNIHByaXZhdGUgcmVhZF9t
c3IoKSBmdW5jdGlvbiwganVzdCB1c2UgcmRtc3JxKCkuDQo+Pg0KPj4gU2lnbmVkLW9mZi1i
eTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KPj4gLS0tDQo+PiBWMjoNCj4+
IC0gcmVtb3ZlIHRoZSBoZWxwZXIgYW5kIHVzZSByZG1zcnEoKSBkaXJlY3RseSAoU2VhbiBD
aHJpc3RvcGhlcnNvbikNCj4+IC0tLQ0KPj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1f
aG9zdC5oIHwgMTAgLS0tLS0tLS0tLQ0KPj4gICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jICAg
ICAgICAgIHwgIDQgKystLQ0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMTIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2t2bV9ob3N0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+
PiBpbmRleCBmMTlhNzZkM2NhMGUuLmFlZDc1NGRkYTFhMyAxMDA2NDQNCj4+IC0tLSBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4+ICsrKyBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2t2bV9ob3N0LmgNCj4+IEBAIC0yMjk2LDE2ICsyMjk2LDYgQEAgc3RhdGljIGlu
bGluZSB2b2lkIGt2bV9sb2FkX2xkdCh1MTYgc2VsKQ0KPj4gICAJYXNtKCJsbGR0ICUwIiA6
IDogInJtIihzZWwpKTsNCj4+ICAgfQ0KPj4gICANCj4+IC0jaWZkZWYgQ09ORklHX1g4Nl82
NA0KPj4gLXN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyByZWFkX21zcih1bnNpZ25lZCBs
b25nIG1zcikNCj4+IC17DQo+PiAtCXU2NCB2YWx1ZTsNCj4+IC0NCj4+IC0JcmRtc3JxKG1z
ciwgdmFsdWUpOw0KPj4gLQlyZXR1cm4gdmFsdWU7DQo+PiAtfQ0KPj4gLSNlbmRpZg0KPiAN
Cj4gR2FoLCB0aGUgc2FtZSBjb21taXRbKl0gdGhhdCBhZGRlZCBhIHdybXNybnMoKSB1c2Ug
YWxzbyBhZGRlZCBhIHJlYWRfbXNyKCkuICBTb3JyeSA6LSgNCj4gDQo+IFsqXSA2NTM5MWZl
YjA0MmIgKCJLVk06IFZNWDogQWRkIGhvc3QgTVNSIHJlYWQvd3JpdGUgaGVscGVycyB0byBj
b25zb2xpZGF0ZSBwcmVlbXB0aW9uIGhhbmRsaW5nIikNCg0KQWdhaW4sIHRoYW5rcyBmb3Ig
dGhlIGhlYWRzIHVwLg0KDQoNCkp1ZXJnZW4NCg==
--------------oOMO04Esfdn5Zk7quz0HiTts
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------oOMO04Esfdn5Zk7quz0HiTts--

--------------qfX8g3Ov94hVZdf0FX8oINEy--

--------------TrUtvkp0TauRyjp2nwWIKfjg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmjc8P0FAwAAAAAACgkQsN6d1ii/Ey8m
uggAgMFiEuofh6mpXYOvpBCTInppEkws0ZCHxV5tIYOkaeXRlYs0hZauElcjqpQethAPJAw9rjFM
Z3KhEnAlqYaTrZ8ofgQiASpo4E9AtGjqs+/FtlRl+7ugd9egygGjgw1T/JihQ4sF8xZTdJDe+uxN
UDeAmFAOhFB6JlN1M2kKJkFeyAtGidhCgQ8Wxak+5BbxArFDkEJPYiELsrzNNAmWjxr0ay5tSj8C
n8b5ybOzUveHMVzAKUutcrkGiD2WyiBafaPq3Owhyv04BIRH0V3zuaTjv1FiClj5ACGzqXtVeVzg
ABO/94npxzO/UElfRDDj4pHX79FxVQYEEg2VvMN9wg==
=tyPf
-----END PGP SIGNATURE-----

--------------TrUtvkp0TauRyjp2nwWIKfjg--

