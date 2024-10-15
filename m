Return-Path: <kvm+bounces-28887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A04FF99E9FA
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 14:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1851CB22792
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 12:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5771620C476;
	Tue, 15 Oct 2024 12:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UhukWYWD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44819204927
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 12:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728995845; cv=none; b=uSsCOZ9dONhQtyBo7qZV1EZ7GX6ojMAbkMJ78LimTCjOghQIYSHdkHoEsI37oP7IjQ6s0UjYwJqWjwnUOlyh+9vUjKMnoUTAoD9CE+bJuhards9TB4KVGhWhNJAziA+5A1eW0nIkTuDiALolv4MZZAjrcIXzVvad6zM/74CSEdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728995845; c=relaxed/simple;
	bh=VMlRsLhNi/xzZTK25pAkjrvplvZU+psK3WhEuJRmbxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ONDGGM8PsfzLD+0d4mztVpHMv1eINfmYR12M02i8ZqUzYnMuNUY3Zfa7DsQwJEnIsdcEwKd2ZTlY2W6lWWOc6v7SyH4t3h8rMTmaZVhv6ro3qd9Z0sVn+v8oE0qJVCM/LE8QGhBFM7ZEhpbKwaeGkDLjitnhkHFRtHqyN5sIqXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UhukWYWD; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-430ee5c9570so62671665e9.3
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 05:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728995840; x=1729600640; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VMlRsLhNi/xzZTK25pAkjrvplvZU+psK3WhEuJRmbxc=;
        b=UhukWYWDZqt9TKWN04BDiSRJvILGdhXoxnlYrW2Zox2qve2hKGNymThdZuexEIAtpi
         ZsnUZq1LtD9N9/6lgCtaFnoye6oKk9azlqG8IHGEeRlP5hu8BpNxxctTjS6LwWUV4Jzw
         N9jyh12FjeAPkndprLzGbO0g/sE7dd3D5gRuta3a4Mah64FkP/Dlme6bTDsQzxfg4BBK
         5AsJRT54yHanbjrUAhMil+2t9HM1LOg4SWQcayyjCxXGxJ017SlquFwA4H/XKglV0bgA
         K3ECFJJhTUnlnjRUcyTqapWBILcOI6+sjDL8APLgc+9fwuOa7B8E+GbY5JX2xILixlV7
         g26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728995840; x=1729600640;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VMlRsLhNi/xzZTK25pAkjrvplvZU+psK3WhEuJRmbxc=;
        b=JA5DfQ9akLnpG67nqf1cYvncEJCYYv6ajxvtuOhYFF0qstmGFN0KXJQQHzmnxvBKJs
         wxBtbH9k+Z/Dmnq8rkLn0fmj2rcX7G+c4W22H3XTdyU/sHdIVR0VkKVUDY9EukZX/I15
         zmQEFH6ZDUgLdNRz7A6hXKdZ1B2P6Ch9KM1I/Tcxv0X21hIyYQMSGN5G4qLsZcYBiDW9
         pYbfooBsD0EXRryBHLSMZYgIdQlovrB87rA0gw6LJjfRIlr059po6D3ou+3HnVhVuWj5
         Xmt4OH7vfAQYG7HT5V/OgEbqCIF8fSKl/WBfXCdof/j4v+v+uaFxY+L5uqjgwTeVaZs6
         Tg2g==
X-Forwarded-Encrypted: i=1; AJvYcCWhPLS1AaaiulSXNbxN2scZtGXh6+zlT0uLmUL1BEVBvCX1xDNFuONvS+7Vo36pc5FLS3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLe0wKg8WdDcrKdeEEw5ytZVgdnYB2F3YgC4d8UTxcPi1aF+Kj
	vi02Rb6L+pif3LVZ33fx+XTTAs/kpgCS+h0LCAG3rSFE639SGA9XoFP8cpGyFp4=
X-Google-Smtp-Source: AGHT+IFG5S23q0RIgaM4flUIdqcejjiVwTdzfiUfoa/EKAdQSlH62c8FACP1eQgB6u5L6FFORAegaA==
X-Received: by 2002:a05:600c:314c:b0:431:4847:47c0 with SMTP id 5b1f17b1804b1-43148474899mr9119605e9.7.1728995840383;
        Tue, 15 Oct 2024 05:37:20 -0700 (PDT)
Received: from ?IPV6:2003:e5:8714:8700:db3b:60ed:e8b9:cd28? (p200300e587148700db3b60ede8b9cd28.dip0.t-ipconnect.de. [2003:e5:8714:8700:db3b:60ed:e8b9:cd28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4314a6fbb77sm2193095e9.14.2024.10.15.05.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 05:37:20 -0700 (PDT)
Message-ID: <2263013c-4cfe-4ed8-ab24-f01f15bb41ca@suse.com>
Date: Tue, 15 Oct 2024 14:37:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and
 TDX
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
 <294ce9a5-09b8-4248-85ad-18bdea479c73@suse.com>
 <w2jymc2d37lzcdgppyeokmcifnrxlto2om4alopfivbmfhaxpq@lxlez6fsjo7f>
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
In-Reply-To: <w2jymc2d37lzcdgppyeokmcifnrxlto2om4alopfivbmfhaxpq@lxlez6fsjo7f>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------DORzppefhH00FQD0xEyn9qIp"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------DORzppefhH00FQD0xEyn9qIp
Content-Type: multipart/mixed; boundary="------------A9B5iOf1ikxPGJIpxZF8ZVk9";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2263013c-4cfe-4ed8-ab24-f01f15bb41ca@suse.com>
Subject: Re: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and
 TDX
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
 <294ce9a5-09b8-4248-85ad-18bdea479c73@suse.com>
 <w2jymc2d37lzcdgppyeokmcifnrxlto2om4alopfivbmfhaxpq@lxlez6fsjo7f>
In-Reply-To: <w2jymc2d37lzcdgppyeokmcifnrxlto2om4alopfivbmfhaxpq@lxlez6fsjo7f>

--------------A9B5iOf1ikxPGJIpxZF8ZVk9
Content-Type: multipart/mixed; boundary="------------Xq510FrbXpeksUEyB08Kdepz"

--------------Xq510FrbXpeksUEyB08Kdepz
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTUuMTAuMjQgMTQ6MzEsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gT24gVHVl
LCBPY3QgMTUsIDIwMjQgYXQgMTI6MTI6NTFQTSArMDIwMCwgSsO8cmdlbiBHcm/DnyB3cm90
ZToNCj4+IE9uIDE1LjEwLjI0IDExOjU4LCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3JvdGU6DQo+
Pj4gQU1EIFNFVi1TTlAgYW5kIEludGVsIFREWCBoYXZlIGxpbWl0ZWQgYWNjZXNzIHRvIE1U
UlI6IGVpdGhlciBpdCBpcyBub3QNCj4+PiBhZHZlcnRpc2VkIGluIENQVUlEIG9yIGl0IGNh
bm5vdCBiZSBwcm9ncmFtbWVkIChvbiBURFgsIGR1ZSB0byAjVkUgb24NCj4+PiBDUjAuQ0Qg
Y2xlYXIpLg0KPj4+DQo+Pj4gVGhpcyByZXN1bHRzIGluIGd1ZXN0cyB1c2luZyB1bmNhY2hl
ZCBtYXBwaW5ncyB3aGVyZSBpdCBzaG91bGRuJ3QgYW5kDQo+Pj4gcG1kL3B1ZF9zZXRfaHVn
ZSgpIGZhaWx1cmVzIGR1ZSB0byBub24tdW5pZm9ybSBtZW1vcnkgdHlwZSByZXBvcnRlZCBi
eQ0KPj4+IG10cnJfdHlwZV9sb29rdXAoKS4NCj4+Pg0KPj4+IE92ZXJyaWRlIE1UUlIgc3Rh
dGUsIG1ha2luZyBpdCBXQiBieSBkZWZhdWx0IGFzIHRoZSBrZXJuZWwgZG9lcyBmb3INCj4+
PiBIeXBlci1WIGd1ZXN0cy4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IEtpcmlsbCBBLiBT
aHV0ZW1vdiA8a2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbT4NCj4+PiBTdWdnZXN0
ZWQtYnk6IEJpbmJpbiBXdSA8YmluYmluLnd1QGludGVsLmNvbT4NCj4+PiBDYzogSnVlcmdl
biBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KPj4+IENjOiBUb20gTGVuZGFja3kgPHRob21h
cy5sZW5kYWNreUBhbWQuY29tPg0KPj4+IC0tLQ0KPj4+ICAgIGFyY2gveDg2L2tlcm5lbC9r
dm0uYyB8IDQgKysrKw0KPj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykN
Cj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMgYi9hcmNoL3g4
Ni9rZXJuZWwva3ZtLmMNCj4+PiBpbmRleCAyNjNmOGFlZDRlMmMuLjIxZTllNDg0NTM1NCAx
MDA2NDQNCj4+PiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMNCj4+PiArKysgYi9hcmNo
L3g4Ni9rZXJuZWwva3ZtLmMNCj4+PiBAQCAtMzcsNiArMzcsNyBAQA0KPj4+ICAgICNpbmNs
dWRlIDxhc20vYXBpYy5oPg0KPj4+ICAgICNpbmNsdWRlIDxhc20vYXBpY2RlZi5oPg0KPj4+
ICAgICNpbmNsdWRlIDxhc20vaHlwZXJ2aXNvci5oPg0KPj4+ICsjaW5jbHVkZSA8YXNtL210
cnIuaD4NCj4+PiAgICAjaW5jbHVkZSA8YXNtL3RsYi5oPg0KPj4+ICAgICNpbmNsdWRlIDxh
c20vY3B1aWRsZV9oYWx0cG9sbC5oPg0KPj4+ICAgICNpbmNsdWRlIDxhc20vcHRyYWNlLmg+
DQo+Pj4gQEAgLTk4MCw2ICs5ODEsOSBAQCBzdGF0aWMgdm9pZCBfX2luaXQga3ZtX2luaXRf
cGxhdGZvcm0odm9pZCkNCj4+PiAgICAJfQ0KPj4+ICAgIAlrdm1jbG9ja19pbml0KCk7DQo+
Pj4gICAgCXg4Nl9wbGF0Zm9ybS5hcGljX3Bvc3RfaW5pdCA9IGt2bV9hcGljX2luaXQ7DQo+
Pj4gKw0KPj4+ICsJLyogU2V0IFdCIGFzIHRoZSBkZWZhdWx0IGNhY2hlIG1vZGUgZm9yIFNF
Vi1TTlAgYW5kIFREWCAqLw0KPj4+ICsJbXRycl9vdmVyd3JpdGVfc3RhdGUoTlVMTCwgMCwg
TVRSUl9UWVBFX1dSQkFDSyk7DQo+Pg0KPj4gRG8geW91IHJlYWxseSB3YW50IHRvIGRvIHRo
aXMgZm9yIF9hbGxfIEtWTSBndWVzdHM/DQo+Pg0KPj4gSSdkIGV4cGVjdCB0aGlzIGNhbGwg
dG8gYmUgY29uZGl0aW9uYWwgb24gVERYIG9yIFNFVi1TTlAuDQo+IA0KPiBtdHJyX292ZXJ3
cml0ZV9zdGF0ZSgpIGNoZWNrcyBpdCBpbnRlcm5hbGx5Lg0KDQpBaCwgcmlnaHQsIEkgZm9y
Z290IEkgYWRkZWQgdGhhdCBjaGVjayBvbiByZXF1ZXN0IGJ5IEJvcmlzLiA6LSkNCg0KUmV2
aWV3ZWQtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCg0KDQpKdWVyZ2Vu
DQoNCg==
--------------Xq510FrbXpeksUEyB08Kdepz
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------Xq510FrbXpeksUEyB08Kdepz--

--------------A9B5iOf1ikxPGJIpxZF8ZVk9--

--------------DORzppefhH00FQD0xEyn9qIp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmcOYf8FAwAAAAAACgkQsN6d1ii/Ey8Y
zwgAjVrSZQMWJnOvxAVoJXQ/i+b/KQpBQs5hWbtBpfwb7G62fKhIr1efb325efsQ0kriGwjvHM01
IcR7wnH2Ddl9Ql8QwSzD3Dcy7FRtaONUevNSYLtYQetxhRPSXYaEJM+l4ZR9jej/RLV5LmIvqzEK
V47T0Z7EmYj8HnYEYfYbqXORlwx9J0icmtqF0t9Z6JCx5wqUKqWwYXZocMcN4b3D0n4Yrj69j1gw
uAFwgGqN5k+k5hSRr0o+IFP7eSspWWlRqh3n0SZIuDQxdXr6wOoN39/THXBr/DvGbRsjQCzjpSFT
s/WIRWHCtXGohxciTGGXZl6PFzNuENIjG9v93TON/g==
=k+zu
-----END PGP SIGNATURE-----

--------------DORzppefhH00FQD0xEyn9qIp--

