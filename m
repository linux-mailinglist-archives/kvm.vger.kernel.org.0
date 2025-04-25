Return-Path: <kvm+bounces-44249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B0CA9BF18
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9173D9A0798
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65D822F17A;
	Fri, 25 Apr 2025 07:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LKgco7Jl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF3B22D7A1
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 07:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745564495; cv=none; b=qJu1Tf5BM65+yyOYd3WGrEV7B16kmM08ms+vm6klaBc8VXxCgzQ8PbSqxxDWviOdFTgQpeUZeBl95clDbwtFTk5HwNsTUevn+VN9H4NSRoPvn2XPVRW3wKGorzbsq+jQc5LsYE7HoGRo18n9GctLhf7XOYvOdTOVLhvXZepJk7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745564495; c=relaxed/simple;
	bh=+z35d4FnwaxKfrAKqUcE083ocCvqkf07d+2qYyUy+9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nCntj5JvusI4/l+lGrWhMOl+V3xNVIqEmEDLc4IeLzObxBYWpEyM877iZgUG02VPev4hNhMyBlqMvpq5XKTD5TcOf3Y2SlsP/05l1MmhN4HfBbw6DmJFWxQ9UJzJaS2R9wJQkjoufQDDhtU8vsU3TUI3kryQVKLWossOmwT3RQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LKgco7Jl; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cf680d351so17728195e9.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 00:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745564492; x=1746169292; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+z35d4FnwaxKfrAKqUcE083ocCvqkf07d+2qYyUy+9c=;
        b=LKgco7Jliup6rSBD0hQ8P5WUxhuQjAt7rJ1EXGnJ0d0KLsAnWovsVlzVmKNEX6VSYW
         bmWoauIsfZb5gJtCLRgc29UPJFWK7+KBqQIJLzh9DymnYGGALOtr7AtsI0/7NWTYwldx
         eDZNiOPPLRF4o1FBPlXVqat60AFGawe2PAZ6eTLmJLYSD1RL8nyx3EO9frTCJaKhIFC2
         eSwg1YikmJdbdE/QxONwMuq3j+PIXvL3mWqYCXKjH1KwLd7Y3J2tjON8zawK0m8ldaAR
         P4wR1OVurddhyW+x0p3QAgqz3I59Y7FHCRbkpiZUcFe71Ig0tcC+vFuGoUta9lIUNisD
         uoew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745564492; x=1746169292;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+z35d4FnwaxKfrAKqUcE083ocCvqkf07d+2qYyUy+9c=;
        b=sXtNAIlHhQYRw8apIU/F/7FWQ6UdeAwvZkWxFCbACFlnUgg8ixH8EER/QsBXypS9kl
         i6UMscZCpcENe2D+TIvgHbmXwoXeSfd0aVsx+/QaTaDvaeyPX1SkEGlMTyi989+SN3sX
         tIkkw8t2dcDEEUhXb9YuEQ1jdtlE24XUDVbg68cJBInQEa8xewKKUlao3lUVDP9x9CII
         Q3ucHONW37dXXTsAQBhK7BvgW5MD8XCe7hSUclnT5SvvLDtUrDujR0A7HV4RjJBZ/qnc
         EuorQn4TO5lVMBPdO1zTXGEYEeeARhbSYh3OyAoiPJ+veaDGbGaok3aa3ynmHv6XKnOs
         hHRA==
X-Forwarded-Encrypted: i=1; AJvYcCWr0BKVWMPsavZkTdgAgxCu+i+32uT/nzz9ENP5jfBZwkdrTprb25+gnWsuvF1W3N22ptg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm6kG/2wo8hT7ZCnZeY6b3XPA7POREHeoGcGMNXqErL+Yd+F4P
	H+/TCyP03ldsflWNWEq8Fn6UvkXy0io+V1UFQcfagRfOkPv0xvoQQpJobHUiOh8=
X-Gm-Gg: ASbGncuetUm15bAo3JBMsNrEHY5KNfOYanQkZVvemrMadp8LoY0LGJKcVqAqODiCONh
	QoDRYVRE7ARvyQG8ghid08PG0oJW2Mpie9B1x+hEFr27cpPJGjH8cVoaY0eqAzydMOhU1W7tVRO
	q2fdB/62AbNcKNKSs3DqK5T13N6aUI9CMmovm1f2EJymx3CmFPkgH1Cf9q80/h1taaAFsVqmRbB
	5PuruTwT6ukDrrGtb7TJOT1EefVMqDOjIiYdO8t3WU0MONRUUb+M2XjPIRwuvxYgqHF/kh0QudM
	UU4QkfyOHNoFl0Q96INBGI8Q1awmIO+9ZitpTvDM2qdZ4yQGxRI2EZW/68Jd5StV4qMNI+CEnBf
	qc42XuyOPU6ah7q43S+w90zzDbl5Jtm6CVQUaiVl/JI+u6jPMXwTIwJyd4cX7MQya7Q==
X-Google-Smtp-Source: AGHT+IGufufLyZ6Eu5vID2+YO2Cr3jWI7A87kyc7N9C1LqbP68Kf/K1914Qn5HAlZea3Ybx+tzciEw==
X-Received: by 2002:a5d:47cc:0:b0:39f:bf3:6f21 with SMTP id ffacd0b85a97d-3a06d64cab2mr4129155f8f.11.1745564491511;
        Fri, 25 Apr 2025 00:01:31 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e47307sm1410893f8f.65.2025.04.25.00.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 00:01:31 -0700 (PDT)
Message-ID: <6ef898f7-c8a3-4326-96ab-42aa90c48e1c@suse.com>
Date: Fri, 25 Apr 2025 09:01:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
To: "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin@zytor.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
 linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
 <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
 <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>
 <0cdc6e9d-88eb-4ead-8d55-985474257d53@suse.com>
 <483eb20c-7302-4733-a15f-21d140396919@zytor.com>
 <72516271-5b28-434a-838b-d8532e1b4fc1@zytor.com>
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
In-Reply-To: <72516271-5b28-434a-838b-d8532e1b4fc1@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------70AsB5RmvESA2s8FjOW8qybs"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------70AsB5RmvESA2s8FjOW8qybs
Content-Type: multipart/mixed; boundary="------------GJ9OF40vHIucWp0hwDufMOKu";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin@zytor.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
 linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
Message-ID: <6ef898f7-c8a3-4326-96ab-42aa90c48e1c@suse.com>
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
 <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
 <bb8f6b85-4e7d-440a-a8c3-0e0da45864b8@zytor.com>
 <0cdc6e9d-88eb-4ead-8d55-985474257d53@suse.com>
 <483eb20c-7302-4733-a15f-21d140396919@zytor.com>
 <72516271-5b28-434a-838b-d8532e1b4fc1@zytor.com>
In-Reply-To: <72516271-5b28-434a-838b-d8532e1b4fc1@zytor.com>

--------------GJ9OF40vHIucWp0hwDufMOKu
Content-Type: multipart/mixed; boundary="------------OqD5G79twKp4xp6ASPK6yqSb"

--------------OqD5G79twKp4xp6ASPK6yqSb
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDQuMjUgMDU6NDQsIEguIFBldGVyIEFudmluIHdyb3RlOg0KPiBPbiA0LzI0LzI1
IDE4OjE1LCBILiBQZXRlciBBbnZpbiB3cm90ZToNCj4+IE9uIDQvMjQvMjUgMDE6MTQsIErD
vHJnZW4gR3Jvw58gd3JvdGU6DQo+Pj4+DQo+Pj4+IEFjdHVhbGx5LCB0aGF0IGlzIGhvdyB3
ZSBnZXQgdGhpcyBwYXRjaCB3aXRoIHRoZSBleGlzdGluZyBhbHRlcm5hdGl2ZXMNCj4+Pj4g
aW5mcmFzdHJ1Y3R1cmUuwqAgQW5kIHdlIHRvb2sgYSBzdGVwIGZ1cnRoZXIgdG8gYWxzbyBy
ZW1vdmUgdGhlIHB2X29wcw0KPj4+PiBNU1IgQVBJcy4uLg0KPj4+DQo+Pj4gQW5kIHRoaXMg
aXMgd2hhdCBJJ20gcXVlc3Rpb25pbmcuIElNSE8gdGhpcyBhcHByb2FjaCBpcyBhZGRpbmcg
bW9yZQ0KPj4+IGNvZGUgYnkgcmVtb3ZpbmcgdGhlIHB2X29wcyBNU1JfQVBJcyBqdXN0IGJl
Y2F1c2UgInB2X29wcyBpcyBiYWQiLiBBbmQNCj4+PiBJIGJlbGlldmUgbW9zdCByZWZ1c2Fs
IG9mIHB2X29wcyBpcyBiYXNlZCBvbiBubyBsb25nZXIgdmFsaWQgcmVhc29uaW5nLg0KPj4+
DQo+Pg0KPj4gcHZvcHMgYXJlIGEgaGVhZGFjaGUgYmVjYXVzZSBpdCBpcyBlZmZlY3RpdmVs
eSBhIHNlY29uZGFyeSBhbHRlcm5hdGl2ZXMgDQo+PiBpbmZyYXN0cnVjdHVyZSB0aGF0IGlz
IGluY29tcGF0aWJsZSB3aXRoIHRoZSBhbHRlcm5hdGl2ZXMgb25lLi4uDQo+Pg0KPj4+PiBJ
dCBsb29rcyB0byBtZSB0aGF0IHlvdSB3YW50IHRvIGFkZCBhIG5ldyBmYWNpbGl0eSB0byB0
aGUgYWx0ZXJuYXRpdmVzDQo+Pj4+IGluZnJhc3RydWN0dXJlIGZpcnN0Pw0KPj4+DQo+Pj4g
V2h5IHdvdWxkIHdlIG5lZWQgYSBuZXcgZmFjaWxpdHkgaW4gdGhlIGFsdGVybmF0aXZlcyBp
bmZyYXN0cnVjdHVyZT8NCj4+DQo+PiBJJ20gbm90IHN1cmUgd2hhdCBYaW4gbWVhbnMgd2l0
aCAiZmFjaWxpdHkiLCBidXQgYSBrZXkgbW90aXZhdGlvbiBmb3IgdGhpcyBpcyB0bzoNCj4+
DQo+PiBhLiBBdm9pZCB1c2luZyB0aGUgcHZvcHMgZm9yIE1TUnMgd2hlbiBvbiB0aGUgb25s
eSByZW1haW5pbmcgdXNlciB0aGVyZW9mIA0KPj4gKFhlbikgaXMgb25seSB1c2luZyBpdCBm
b3IgYSB2ZXJ5IHNtYWxsIHN1YnNldCBvZiBNU1JzIGFuZCBmb3IgdGhlIHJlc3QgaXQgaXMg
DQo+PiBqdXN0IG92ZXJoZWFkLCBldmVuIGZvciBYZW47DQo+Pg0KPj4gYi4gQmVpbmcgYWJs
ZSB0byBkbyB3cm1zcm5zIGltbWVkaWF0ZS93cm1zcm5zL3dybXNyIGFuZCByZG1zciBpbW1l
ZGlhdGUvIHJkbXNyIA0KPj4gYWx0ZXJuYXRpdmVzLg0KPj4NCj4+IE9mIHRoZXNlLCAoYikg
aXMgYnkgZmFyIHRoZSBiaWdnZXN0IG1vdGl2YXRpb24uIFRoZSBhcmNoaXRlY3R1cmFsIGRp
cmVjdGlvbiANCj4+IGZvciBzdXBlcnZpc29yIHN0YXRlcyBpcyB0byBhdm9pZCBhZCBob2Mg
YW5kIFhTQVZFUyBJU0EgYW5kIGluc3RlYWQgdXNlIE1TUnMuIA0KPj4gVGhlIGltbWVkaWF0
ZSBmb3JtcyBhcmUgZXhwZWN0ZWQgdG8gYmUgc2lnbmlmaWNhbnRseSBmYXN0ZXIsIGJlY2F1
c2UgdGhleSBtYWtlIA0KPj4gdGhlIE1TUiBpbmRleCBhdmFpbGFibGUgYXQgdGhlIHZlcnkg
YmVnaW5uaW5nIG9mIHRoZSBwaXBlbGluZSBpbnN0ZWFkIG9mIGF0IGEgDQo+PiByZWxhdGl2
ZWx5IGxhdGUgc3RhZ2UuDQo+Pg0KPiANCj4gTm90ZSB0aGF0IHRvIHN1cHBvcnQgdGhlIGlt
bWVkaWF0ZSBmb3Jtcywgd2UgKm11c3QqIGRvIHRoZXNlIGlubGluZSwgb3IgdGhlIA0KPiBj
b25zdC1uZXNzIG9mIHRoZSBNU1IgaW5kZXggLS0gd2hpY2ggYXBwbGllcyB0byBieSBmYXIg
dGhlIHZhc3QgbWFqb3JpdHkgb2YgTVNSIA0KPiByZWZlcmVuY2VzIC0tIGdldHMgbG9zdC4g
cHZvcHMgZG9lcyBleGFjdGx5IHRoYXQuDQo+IA0KPiBGdXJ0aGVybW9yZSwgdGhlIE1TUiBp
bW1lZGlhdGUgaW5zdHJ1Y3Rpb25zIHRha2UgYSA2NC1iaXQgbnVtYmVyIGluIGEgc2luZ2xl
IA0KPiByZWdpc3RlcjsgYXMgdGhlc2UgaW5zdHJ1Y3Rpb25zIGFyZSBieSBuZWNlc3NpdHkg
cmVsYXRpdmVseSBsb25nLCBpdCBtYWtlcyBzZW5zZSANCj4gZm9yIHRoZSBhbHRlcm5hdGl2
ZSBzZXF1ZW5jZSB0byBhY2NlcHQgYSA2NC1iaXQgaW5wdXQgcmVnaXN0ZXIgYW5kIGRvIHRo
ZSAlZWF4LyANCj4gJWVkeCBzaHVmZmxlIGluIHRoZSBsZWdhY3kgZmFsbGJhY2sgY29kZS4u
LiB3ZSBkaWQgYSBidW5jaCBvZiBleHBlcmltZW50cyB0byBzZWUgDQo+IHdoYXQgbWFkZSBt
b3N0IHNlbnNlLg0KDQpZZXMsIEkgdW5kZXJzdGFuZCB0aGF0Lg0KDQpBbmQgSSdtIHRvdGFs
bHkgaW4gZmF2b3Igb2YgWGluJ3MgcmV3b3JrIG9mIHRoZSBNU1IgbG93IGxldmVsIGZ1bmN0
aW9ucy4NCg0KSW5saW5pbmcgdGhlIE1TUiBhY2Nlc3MgaW5zdHJ1Y3Rpb25zIHdpdGggcHZf
b3BzIHNob3VsZCBub3QgYmUgdmVyeQ0KY29tcGxpY2F0ZWQuIFdlIGRvIHRoYXQgd2l0aCBv
dGhlciBpbnN0cnVjdGlvbnMgKFNUSS9DTEksIFBURSBhY2Nlc3NlcykNCnRvZGF5LCBzbyB0
aGlzIGlzIG5vIG5ldyBraW5kIG9mIGZ1bmN0aW9uYWxpdHkuDQoNCkkgY291bGQgaGF2ZSBh
IHRyeSB3cml0aW5nIGEgcGF0Y2ggYWNoaWV2aW5nIHRoYXQsIGJ1dCBJIHdvdWxkIG9ubHkg
c3RhcnQNCnRoYXQgd29yayBpbiBjYXNlIHlvdSBtaWdodCBjb25zaWRlciB0YWtpbmcgaXQg
aW5zdGVhZCBvZiBYaW4ncyBwYXRjaA0KcmVtb3ZpbmcgdGhlIHB2X29wcyB1c2FnZSBmb3Ig
cmRtc3Ivd3Jtc3IuIEluIGNhc2UgaXQgdHVybnMgb3V0IHRoYXQgbXkNCnZlcnNpb24gcmVz
dWx0cyBpbiBtb3JlIGNvZGUgY2hhbmdlcyB0aGFuIFhpbidzIHBhdGNoLCBJJ2QgYmUgZmlu
ZSB0byBkcm9wDQpteSBwYXRjaCwgb2YgY291cnNlLg0KDQoNCkp1ZXJnZW4NCg==
--------------OqD5G79twKp4xp6ASPK6yqSb
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------OqD5G79twKp4xp6ASPK6yqSb--

--------------GJ9OF40vHIucWp0hwDufMOKu--

--------------70AsB5RmvESA2s8FjOW8qybs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgLM0kFAwAAAAAACgkQsN6d1ii/Ey9J
ewgAleneoGof9FfwPyKjEeafKKF9GL+4Sam+p2GRBaUaEVHL9jEK/zI63WD1/raK2NasxlmJYHVZ
s2qZ+J/M8gr4P/UNqf467Np0nZ79OmtqtPh0Q77SUOsMP4psy2YPuJA7divtrxd2PMOmXFcYdbya
id9OTcpk5o0wCYzeKaWD9FzxVnBQW3lPfGk0AYEVvYxfolzuygFQ+vjCEjLjzTy71lVX9kj5oa0B
Xo5fqnC9Tih5mo68HAKsbmyT2b6K6RE0iWTqgXAx7T8BHgQBHHKgC6yiAj+0r5tvaOYT3nupCvZF
v1+aoIdfjelYRqb6tHKba9qJzgzzn0kei4XfjMQ87A==
=uKZw
-----END PGP SIGNATURE-----

--------------70AsB5RmvESA2s8FjOW8qybs--

