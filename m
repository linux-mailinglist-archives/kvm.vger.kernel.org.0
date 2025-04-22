Return-Path: <kvm+bounces-43812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A071CA96547
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5889B3BB97F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0827320C023;
	Tue, 22 Apr 2025 09:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cHLsoNRU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EDB2046A6
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745315884; cv=none; b=jpAGnY5gQfuc3WDvVSt8g8NtbphNi0VIXVuO3mV8yBwGjIMsUDq6EraU8LOY/GMyldqNI1edzCwdf76N9hcrP1fLBH1dWe3EMF09TNlKmgYZ2igeb7MfnSVVgyCHDWVZ5pc2PVJPTP2zskgmGg5Maz6P/rcybXebChydkZraGH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745315884; c=relaxed/simple;
	bh=tO6B4uusGXWb6S1d5vB39Y8e5rVhKy79xlXkhC2hD/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CFCTz1Qx4TXlBrEG9bN8jo3FUvkpoj2aDslCwIjSLFnzpq8MzHCxH18fgwFiIEwZ+k74qLkUQ2wOgzyG3AzLPAn0I0Q45P8rdUZe9xkAcw58jDzOXCUWotHb/+hqSmbntRWHFjkC6PbdFiyYs6uxbu25eCyrBk1j4cpgj3n3jjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cHLsoNRU; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39c266c1389so3622510f8f.1
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 02:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745315880; x=1745920680; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tO6B4uusGXWb6S1d5vB39Y8e5rVhKy79xlXkhC2hD/8=;
        b=cHLsoNRUSrRFPsnxYTqdRoHuPRcHFk4bLYqf0exWuh8lozisJ35yit1T+TKlczWFHh
         IUNN9jxzf11zubnS2xVRGAx0DSO77MjU9MnzfBc7UR41YiW6HHg5hX0M3yX5JeStHM9P
         L4BaimxAt66DNfxkV62hl3NPBY7RVwOXu0QQ+BTHfCKFcDX4WpkzS1xc2DfaS1ldHoGb
         QhHvThj9s1tgeehIosM4J8oWdrbBN8RmMgVYWMWAYzvN/QZUxt0qA1T5Oayq57yLKuQ/
         1Df4QSJ7b7P57lCoheSjkW/dOQHbE8S/XSdYIoYqoXkEV0Z11hPNEibbNgZq1V4nUkjL
         tmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745315880; x=1745920680;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tO6B4uusGXWb6S1d5vB39Y8e5rVhKy79xlXkhC2hD/8=;
        b=fk57YcRd0FwjhaSzIobCcupWDevkv/8cHoDJa2TIj4osOtZ+fvlnpyKSeV7YSQT5VB
         GGo91FN/7Pvw5Bj1ODr9t3pIuNtLVXl9eik5f2dhhpoX4JwEttkZTwaulSa+W1F8E3j5
         Dq+ISzk8zwd17t2NNWe6mhIKHdavlGaeGJ1ZJEM6/jVAkh1gPXIxsdBoUWWWSxaJsh07
         5BFnKF2jBkIfejJDVL2mCUqia5QA8h8pss5qHZ7TBCgQ6FvnfvFloEWeehkCFVJAQemg
         Xhy2ZmJZL0E1JBgKBxHCHX6sKGiLBWZa/9vz60WBbZx4sgfjR91zJKybeC+CVOctgJbU
         zcDw==
X-Forwarded-Encrypted: i=1; AJvYcCX205DI23F8Oq5Ah3T8KBDoCL05TjKfY4kbPUA9IuVlENBDMIeC7xtMzM6wtuFTewfJVQA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl9mRl1KMNok/w9zd63V2kMwEcuIkWaIrvQG4SVqsWMDKyo0ii
	73vzhwKVCS7nbwaq9xNc5SylEzIUYMAm+wbqjTV1E3SWdY2kaaSw3INWqBejwtw=
X-Gm-Gg: ASbGncv9vHmA/BxXkxla1Ygd43OOiCGEwiIC7lKUjdcRzzME42tt9uOTSYAmk7xMQhS
	2S5gosxCaquUF0RrAscJhphW+C+hOlhtUbavAn15XaXIrBj2PYJhjxKuvPfzWmQesY3jdywPP6f
	c9Ez0DxLTQctfAEZ6pcFL898KsFmVtaqPjUL22fYpcefRl1YuqVzBd7lmK32sot53AJn/CqsVU1
	4mnxygVZg8nNSNGCNxm3yVNMcODIU6eNRPNaa9RRdxPj0VG45G+dBPWfFVLQBnmZBKoSPXOAinE
	mLM5W8kWLSeIxJly82DatMEF/u+d11ky5zmfrMTaLDkDOnvO5YF3FZh5s7ur5NWQ0ub7/jB7mK/
	Rg20PfxbH7fZOH9OHYXL1T0r9bIZwFNyfu7h/taGr90R4St84J/uNbcuwm51MPxx/8Q==
X-Google-Smtp-Source: AGHT+IGwOEvoLsyGlKbLK2I7EO3CV112zbLo9AuOo2VfG3qa8/zautum4TxS9/Et7Lbmpeas2d4LEQ==
X-Received: by 2002:a5d:584e:0:b0:39c:2264:43ea with SMTP id ffacd0b85a97d-39efba2a69bmr12519153f8f.3.1745315879983;
        Tue, 22 Apr 2025 02:57:59 -0700 (PDT)
Received: from ?IPV6:2003:e5:873d:1a00:8e99:ce06:aa4a:2e7b? (p200300e5873d1a008e99ce06aa4a2e7b.dip0.t-ipconnect.de. [2003:e5:873d:1a00:8e99:ce06:aa4a:2e7b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4207afsm14838749f8f.12.2025.04.22.02.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 02:57:59 -0700 (PDT)
Message-ID: <6046a6d0-bae3-41bb-9960-82c403f62476@suse.com>
Date: Tue, 22 Apr 2025 11:57:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 22/34] x86/msr: Utilize the alternatives mechanism
 to read MSR
To: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
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
 <91f9217a-cc2d-4a6e-bada-290312f73d82@suse.com>
 <7fea6158-9b7d-4bfb-b709-729266803c32@zytor.com>
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
In-Reply-To: <7fea6158-9b7d-4bfb-b709-729266803c32@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------LRC1NKAgjBDvH3dBaZRyJS4G"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------LRC1NKAgjBDvH3dBaZRyJS4G
Content-Type: multipart/mixed; boundary="------------2vrbMGF8pPaZHLnA82JDRyos";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <6046a6d0-bae3-41bb-9960-82c403f62476@suse.com>
Subject: Re: [RFC PATCH v2 22/34] x86/msr: Utilize the alternatives mechanism
 to read MSR
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-23-xin@zytor.com>
 <91f9217a-cc2d-4a6e-bada-290312f73d82@suse.com>
 <7fea6158-9b7d-4bfb-b709-729266803c32@zytor.com>
In-Reply-To: <7fea6158-9b7d-4bfb-b709-729266803c32@zytor.com>

--------------2vrbMGF8pPaZHLnA82JDRyos
Content-Type: multipart/mixed; boundary="------------0gah4xKFvsHE00D3flXrnkz1"

--------------0gah4xKFvsHE00D3flXrnkz1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDQuMjUgMTE6MjAsIFhpbiBMaSB3cm90ZToNCj4gT24gNC8yMi8yMDI1IDE6NTkg
QU0sIErDvHJnZW4gR3Jvw58gd3JvdGU6DQo+PiBPbiAyMi4wNC4yNSAxMDoyMiwgWGluIExp
IChJbnRlbCkgd3JvdGU6DQo+Pj4gVG8gZWxpbWluYXRlIHRoZSBpbmRpcmVjdCBjYWxsIG92
ZXJoZWFkIGludHJvZHVjZWQgYnkgdGhlIHB2X29wcyBBUEksDQo+Pj4gdXRpbGl6ZSB0aGUg
YWx0ZXJuYXRpdmVzIG1lY2hhbmlzbSB0byByZWFkIE1TUjoNCj4+Pg0KPj4+IMKgwqDCoMKg
IDEpIFdoZW4gYnVpbHQgd2l0aCAhQ09ORklHX1hFTl9QViwgWDg2X0ZFQVRVUkVfWEVOUFYg
YmVjb21lcyBhDQo+Pj4gwqDCoMKgwqDCoMKgwqAgZGlzYWJsZWQgZmVhdHVyZSwgcHJldmVu
dGluZyB0aGUgWGVuIGNvZGUgZnJvbSBiZWluZyBidWlsdA0KPj4+IMKgwqDCoMKgwqDCoMKg
IGFuZCBlbnN1cmluZyB0aGUgbmF0aXZlIGNvZGUgaXMgZXhlY3V0ZWQgdW5jb25kaXRpb25h
bGx5Lg0KPj4+DQo+Pj4gwqDCoMKgwqAgMikgV2hlbiBidWlsdCB3aXRoIENPTkZJR19YRU5f
UFY6DQo+Pj4NCj4+PiDCoMKgwqDCoMKgwqDCoCAyLjEpIElmIG5vdCBydW5uaW5nIG9uIHRo
ZSBYZW4gaHlwZXJ2aXNvciAoIVg4Nl9GRUFUVVJFX1hFTlBWKSwNCj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdGhlIGtlcm5lbCBydW50aW1lIGJpbmFyeSBpcyBwYXRjaGVkIHRv
IHVuY29uZGl0aW9uYWxseQ0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBqdW1wIHRv
IHRoZSBuYXRpdmUgTVNSIHJlYWQgY29kZS4NCj4+Pg0KPj4+IMKgwqDCoMKgwqDCoMKgIDIu
MikgSWYgcnVubmluZyBvbiB0aGUgWGVuIGh5cGVydmlzb3IgKFg4Nl9GRUFUVVJFX1hFTlBW
KSwgdGhlDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGtlcm5lbCBydW50aW1lIGJp
bmFyeSBpcyBwYXRjaGVkIHRvIHVuY29uZGl0aW9uYWxseSBqdW1wDQo+Pj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHRvIHRoZSBYZW4gTVNSIHJlYWQgY29kZS4NCj4+Pg0KPj4+IFRo
ZSBhbHRlcm5hdGl2ZXMgbWVjaGFuaXNtIGlzIGFsc28gdXNlZCB0byBjaG9vc2UgdGhlIG5l
dyBpbW1lZGlhdGUNCj4+PiBmb3JtIE1TUiByZWFkIGluc3RydWN0aW9uIHdoZW4gaXQncyBh
dmFpbGFibGUuDQo+Pj4NCj4+PiBDb25zZXF1ZW50bHksIHJlbW92ZSB0aGUgcHZfb3BzIE1T
UiByZWFkIEFQSXMgYW5kIHRoZSBYZW4gY2FsbGJhY2tzLg0KPj4NCj4+IFNhbWUgYXMgdGhl
IGNvbW1lbnQgdG8gcGF0Y2ggNTogdGhlcmUgaXMgbm8gaW5kaXJlY3QgY2FsbCBvdmVyaGVh
ZCBhZnRlcg0KPj4gdGhlIHN5c3RlbSBoYXMgY29tZSB1cC4NCj4+DQo+IA0KPiBQbGVhc2Ug
Y2hlY2sgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC84N3kxaDgxaHQ0LmZmc0B0Z2x4
Ly4NCj4gDQo+IEFuZCBpdCdzIHdhcyBhbHNvIG1lbnRpb25lZCBpbiB0aGUgcHJldmlvdXMg
cGF0Y2g6DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjUwNDIyMDgy
MjE2LjE5NTQzMTAtMjIteGluQHp5dG9yLmNvbS8NCj4gDQo+IFBsZWFzZSBsZXQgbWUga25v
dyB3aGF0IEkgaGF2ZSBtaXNzZWQuDQoNClBsZWFzZSBzZWUgbXkgcmVzcG9uc2UgdG8gdGhl
IHByZXZpb3VzIHBhdGNoLg0KDQoNCkp1ZXJnZW4NCg==
--------------0gah4xKFvsHE00D3flXrnkz1
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

--------------0gah4xKFvsHE00D3flXrnkz1--

--------------2vrbMGF8pPaZHLnA82JDRyos--

--------------LRC1NKAgjBDvH3dBaZRyJS4G
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgHaCYFAwAAAAAACgkQsN6d1ii/Ey88
2gf9G2X7seedpgkuVi3Kr8ramS2kAPeIhTmk5YzYNI/baO7kJni9Bz3A8CJrjqPBQos1/m+ZHUnL
HHqgoLhq+2kdhHVUY+nPYIPdebmYLTHvd3gC+R7swUzJf55bQGENKLO6WtuH5sksovruObmjap7C
sbHKsWYiAx51NvcRCMZPJAmT8N/+KqAAPfqutdEhiGIfuSkyH9cA34H3Dg/y2hLs4SMppXznwBe7
TXOOblqw8TxiQKwP05dQo56KdIc6ap06wnELQWlmjSZUSIkSyD4RvmANZE0jAxiFKQr00dtaGUxz
eaA239uDGL6mfOq/W/cBOw0vspmUeBL6fc4RZErgyw==
=mYH8
-----END PGP SIGNATURE-----

--------------LRC1NKAgjBDvH3dBaZRyJS4G--

