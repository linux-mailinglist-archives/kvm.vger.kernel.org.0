Return-Path: <kvm+bounces-43978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B31A994FA
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 861F3926357
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8D2281363;
	Wed, 23 Apr 2025 16:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EjLC2RYZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73F525CC73
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424326; cv=none; b=ke7edJygphDJhcf0DT9BsjQSUPUIUdaEuRy/2O7jMwUa58L3dpjOpTl/A61TfSFuxDo6DiuUlP2bmAzKf8IWcnU3EabS86U9AYbpOg92aGPtcLgIqF/yvNA1rVOdB0H8gHfdrqdAEMobw2NWwsDqD/mNuLikUGTwCJP+OZuTTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424326; c=relaxed/simple;
	bh=kQkZKKUoLjzT2xrPRr6XCtcs79ipi8g7W+BTVNWHk/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mm9A44Y8aXLlVI/FM3SHMhOmCupWegasBzWZ78uiZnrJCqAMa5gm5gxQHfAUVa7g0ZEIo4r3X+M7yuOtAZEHng1az4PgIIKbUx0qMIReUfIKJ/Obw7lzsh5Lst0zsxnbvPa+QFUy5KeHhUE6bzntRQ8brvV8mDrddwUvk9zEAoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EjLC2RYZ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e61d91a087so9800326a12.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 09:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745424322; x=1746029122; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kQkZKKUoLjzT2xrPRr6XCtcs79ipi8g7W+BTVNWHk/0=;
        b=EjLC2RYZ17u9GqafUwaGO/rIBWpBFLbZIeotGhPwx6M43C63DYKPT8tKrzvqBB1GLt
         CKpQxQRgiygV3y+s4iE9g2CselP1SjzDE5Z/tmG84Wooo4N2B++RMJ+J9k1SjbOI+6d4
         WHglqQFIHOL0jlqe+xTObmoYFRXTYLzvm2CTXj84qPaA+GC5LrdHLWM95ByvgXn97W0A
         mI7aBt0CGXTk2B77BYC8xSMDA4cjcKNIqtSWPfTB8gEE9PtlpmiqjCPUuu1p6VrdnQP+
         i5ksDJDy3hfeEx1JpCSaGUaCx0iNN0CgrjnYWFQ+Dsw/9P96Akq50e4hrN74vm7oytLv
         BTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745424322; x=1746029122;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQkZKKUoLjzT2xrPRr6XCtcs79ipi8g7W+BTVNWHk/0=;
        b=uwHfv6D1VXqckBk1/XUafl3BgvcnFSuIU7s5CfhujQ8EqVU9qkrhX0n0QacMXr8lsj
         F7BLYYA/n9+Z3oDO5gua4AAJbVFcno/sANOSMaJ34OWtf12sv1P9J+ibAOzhXOzWTFZs
         llIYdpGnNQah26PeaYtLeSdGzqsz0CXoCt5o0Ht+U4YiaG4KxA5WJHdDBX4Kqe+2/wPV
         Sm7geFKJITU2c0C7qYCvAUPQ3o+OyKTBuSPknoVNqMxK0UdEKVpJMsYDh7+F0/8CQSqg
         Lw89bc+Ik3QoVqd4nYYCorAP3t1HAeF08ouUIlRe6Nw6EV0h5OaRs09E0bvf/64yk8re
         ZdlA==
X-Forwarded-Encrypted: i=1; AJvYcCUv6ARGbvnCNWcj7ZZYKvbInPUBWj/9qHWXC8+t6F/TmRRQuG/f/8M6aErKLLcNeS6qnVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD4+eDde8mTi/Bv263SPCCC0QVOJLvr0v57tlq1VhOHyeDEblh
	NhDDz63Tpf0fnNDNnNM9A2p9tg6c9FivPvHuq0j96kJZYkBeo58nOzjvM3ZwhbA=
X-Gm-Gg: ASbGncuR5th0mpbKr56EJo9JOQm01NqYwhKCaWoIJYK0pMmnucIva/cnG8jPWopKQiF
	wlZx0AUQL1gDxvzuwkY/Kg7IYREI3Xw4GXtd9E5xoONzPyEthv6oeDp5tqch6i/WgtxvQi+rx/k
	o+NkDBi7JQjW3SsganGmzg6CWxQWFxNVqMvBqBKwFqyZk8nxiCE5AMurHiZOg4O0GcieBg82SHm
	9jSNJHEVcHo3GcD5i+6dfUGKLA+9AKkWLuRBKMAE+pJPRNvZeQE3k24We74rtxNGKSUNfidGiWd
	4/gzI3s6o4giz5zbsWrx+OXMuBRAmwSzlXyeQcd8JOkHJSMXR3T3SZfU2pyA5bqOWGGe3tIpeYB
	SM/MEOuz4pHBmQ897CLuzotF3nUs0Rl0XLjQaRSbR3bPIXbAzpDRViwUj/FC2XR5orNX7ZrtwDw
	/4
X-Google-Smtp-Source: AGHT+IEo0PNu11JzN98XoSJk9AR1wF50xyco8ZxIf2P6MaamPRtmGrdjToXBNtChaO7f9hobNby3vQ==
X-Received: by 2002:a17:907:9815:b0:abf:6ebf:5500 with SMTP id a640c23a62f3a-acb74b18d6dmr1757155266b.16.1745424321705;
        Wed, 23 Apr 2025 09:05:21 -0700 (PDT)
Received: from ?IPV6:2003:e5:870f:e000:6c64:75fd:2c51:3fef? (p200300e5870fe0006c6475fd2c513fef.dip0.t-ipconnect.de. [2003:e5:870f:e000:6c64:75fd:2c51:3fef])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef45784sm802312966b.129.2025.04.23.09.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 09:05:21 -0700 (PDT)
Message-ID: <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
Date: Wed, 23 Apr 2025 18:05:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
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
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
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
In-Reply-To: <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------398yZoWCv7yp9PXp1RKEeUfd"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------398yZoWCv7yp9PXp1RKEeUfd
Content-Type: multipart/mixed; boundary="------------FLAnSz0SzY3c5JmVJHJBKSu5";
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
Message-ID: <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com>
Subject: Re: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism
 to write MSR
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-22-xin@zytor.com>
 <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com>
 <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>
In-Reply-To: <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com>

--------------FLAnSz0SzY3c5JmVJHJBKSu5
Content-Type: multipart/mixed; boundary="------------0DTyIjBeblppipV7B0zRSAr0"

--------------0DTyIjBeblppipV7B0zRSAr0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjMuMDQuMjUgMTA6NTEsIFhpbiBMaSB3cm90ZToNCj4gT24gNC8yMi8yMDI1IDI6NTcg
QU0sIErDvHJnZW4gR3Jvw58gd3JvdGU6DQo+PiBPbiAyMi4wNC4yNSAxMDoyMiwgWGluIExp
IChJbnRlbCkgd3JvdGU6DQo+Pj4gVGhlIHN0b3J5IHN0YXJ0ZWQgZnJvbSB0Z2x4J3MgcmVw
bHkgaW4gWzFdOg0KPj4+DQo+Pj4gwqDCoCBGb3IgYWN0dWFsIHBlcmZvcm1hbmNlIHJlbGV2
YW50IGNvZGUgdGhlIGN1cnJlbnQgUFYgb3BzIG1lY2hhbmljcw0KPj4+IMKgwqAgYXJlIGEg
aG9ycm9yc2hvdyB3aGVuIHRoZSBvcCBkZWZhdWx0cyB0byB0aGUgbmF0aXZlIGluc3RydWN0
aW9uLg0KPj4+DQo+Pj4gwqDCoCBsb29rIGF0IHdybXNybCgpOg0KPj4+DQo+Pj4gwqDCoCB3
cm1zcmwobXNyLCB2YWwNCj4+PiDCoMKgwqAgd3Jtc3IobXNyLCAodTMyKXZhbCwgKHUzMil2
YWwgPj4gMzIpKQ0KPj4+IMKgwqDCoMKgIHBhcmF2aXJ0X3dyaXRlX21zcihtc3IsIGxvdywg
aGlnaCkNCj4+PiDCoMKgwqDCoMKgwqAgUFZPUF9WQ0FMTDMoY3B1LndyaXRlX21zciwgbXNy
LCBsb3csIGhpZ2gpDQo+Pj4NCj4+PiDCoMKgIFdoaWNoIHJlc3VsdHMgaW4NCj4+Pg0KPj4+
IMKgwqDCoMKgbW92wqDCoMKgICRtc3IsICVlZGkNCj4+PiDCoMKgwqDCoG1vdsKgwqDCoCAk
dmFsLCAlcmR4DQo+Pj4gwqDCoMKgwqBtb3bCoMKgwqAgJWVkeCwgJWVzaQ0KPj4+IMKgwqDC
oMKgc2hywqDCoMKgICQweDIwLCAlcmR4DQo+Pj4gwqDCoMKgwqBjYWxswqDCoMKgIG5hdGl2
ZV93cml0ZV9tc3INCj4+Pg0KPj4+IMKgwqAgYW5kIG5hdGl2ZV93cml0ZV9tc3IoKSBkb2Vz
IGF0IG1pbmltdW06DQo+Pj4NCj4+PiDCoMKgwqDCoG1vdsKgwqDCoCAlZWRpLCVlY3gNCj4+
PiDCoMKgwqDCoG1vdsKgwqDCoCAlZXNpLCVlYXgNCj4+PiDCoMKgwqDCoHdybXNyDQo+Pj4g
wqDCoMKgwqByZXQNCj4+Pg0KPj4+IMKgwqAgSW4gdGhlIHdvcnN0IGNhc2UgJ3JldCcgaXMg
Z29pbmcgdGhyb3VnaCB0aGUgcmV0dXJuIHRodW5rLiBOb3QgdG8NCj4+PiDCoMKgIHRhbGsg
YWJvdXQgZnVuY3Rpb24gcHJvbG9ndWVzIGFuZCB3aGF0ZXZlci4NCj4+Pg0KPj4+IMKgwqAg
VGhpcyBiZWNvbWVzIGV2ZW4gbW9yZSBzaWxseSBmb3IgdHJpdmlhbCBpbnN0cnVjdGlvbnMg
bGlrZSBTVEkvQ0xJDQo+Pj4gwqDCoCBvciBpbiB0aGUgd29yc3QgY2FzZSBwYXJhdmlydF9u
b3AoKS4NCj4+DQo+PiBUaGlzIGlzIG5vbnNlbnNlLg0KPj4NCj4+IEluIHRoZSBub24tWGVu
IGNhc2UgdGhlIGluaXRpYWwgaW5kaXJlY3QgY2FsbCBpcyBkaXJlY3RseSByZXBsYWNlZCB3
aXRoDQo+PiBTVEkvQ0xJIHZpYSBhbHRlcm5hdGl2ZSBwYXRjaGluZywgd2hpbGUgZm9yIFhl
biBpdCBpcyByZXBsYWNlZCBieSBhIGRpcmVjdA0KPj4gY2FsbC4NCj4+DQo+PiBUaGUgcGFy
YXZpcnRfbm9wKCkgY2FzZSBpcyBoYW5kbGVkIGluIGFsdF9yZXBsYWNlX2NhbGwoKSBieSBy
ZXBsYWNpbmcgdGhlDQo+PiBpbmRpcmVjdCBjYWxsIHdpdGggYSBub3AgaW4gY2FzZSB0aGUg
dGFyZ2V0IG9mIHRoZSBjYWxsIHdhcyBwYXJhdmlydF9ub3AoKQ0KPj4gKHdoaWNoIGlzIGlu
IGZhY3Qgbm9fZnVuYygpKS4NCj4+DQo+Pj4NCj4+PiDCoMKgIFRoZSBjYWxsIG1ha2VzIG9u
bHkgc2Vuc2UsIHdoZW4gdGhlIG5hdGl2ZSBkZWZhdWx0IGlzIGFuIGFjdHVhbA0KPj4+IMKg
wqAgZnVuY3Rpb24sIGJ1dCBmb3IgdGhlIHRyaXZpYWwgY2FzZXMgaXQncyBhIGJsYXRhbnQg
ZW5naW5lZXJpbmcNCj4+PiDCoMKgIHRyYWlud3JlY2suDQo+Pg0KPj4gVGhlIHRyaXZpYWwg
Y2FzZXMgYXJlIGFsbCBoYW5kbGVkIGFzIHN0YXRlZCBhYm92ZTogYSBkaXJlY3QgcmVwbGFj
ZW1lbnQNCj4+IGluc3RydWN0aW9uIGlzIHBsYWNlZCBhdCB0aGUgaW5kaXJlY3QgY2FsbCBw
b3NpdGlvbi4NCj4gDQo+IFRoZSBhYm92ZSBjb21tZW50IHdhcyBnaXZlbiBpbiAyMDIzIElJ
UkMsIGFuZCB5b3UgaGF2ZSBhZGRyZXNzZWQgaXQuDQo+IA0KPj4NCj4+PiBMYXRlciBhIGNv
bnNlbnN1cyB3YXMgcmVhY2hlZCB0byB1dGlsaXplIHRoZSBhbHRlcm5hdGl2ZXMgbWVjaGFu
aXNtIHRvDQo+Pj4gZWxpbWluYXRlIHRoZSBpbmRpcmVjdCBjYWxsIG92ZXJoZWFkIGludHJv
ZHVjZWQgYnkgdGhlIHB2X29wcyBBUElzOg0KPj4+DQo+Pj4gwqDCoMKgwqAgMSkgV2hlbiBi
dWlsdCB3aXRoICFDT05GSUdfWEVOX1BWLCBYODZfRkVBVFVSRV9YRU5QViBiZWNvbWVzIGEN
Cj4+PiDCoMKgwqDCoMKgwqDCoCBkaXNhYmxlZCBmZWF0dXJlLCBwcmV2ZW50aW5nIHRoZSBY
ZW4gY29kZSBmcm9tIGJlaW5nIGJ1aWx0DQo+Pj4gwqDCoMKgwqDCoMKgwqAgYW5kIGVuc3Vy
aW5nIHRoZSBuYXRpdmUgY29kZSBpcyBleGVjdXRlZCB1bmNvbmRpdGlvbmFsbHkuDQo+Pg0K
Pj4gVGhpcyBpcyB0aGUgY2FzZSB0b2RheSBhbHJlYWR5LiBUaGVyZSBpcyBubyBuZWVkIGZv
ciBhbnkgY2hhbmdlIHRvIGhhdmUNCj4+IHRoaXMgaW4gcGxhY2UuDQo+Pg0KPj4+DQo+Pj4g
wqDCoMKgwqAgMikgV2hlbiBidWlsdCB3aXRoIENPTkZJR19YRU5fUFY6DQo+Pj4NCj4+PiDC
oMKgwqDCoMKgwqDCoCAyLjEpIElmIG5vdCBydW5uaW5nIG9uIHRoZSBYZW4gaHlwZXJ2aXNv
ciAoIVg4Nl9GRUFUVVJFX1hFTlBWKSwNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
dGhlIGtlcm5lbCBydW50aW1lIGJpbmFyeSBpcyBwYXRjaGVkIHRvIHVuY29uZGl0aW9uYWxs
eQ0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBqdW1wIHRvIHRoZSBuYXRpdmUgTVNS
IHdyaXRlIGNvZGUuDQo+Pj4NCj4+PiDCoMKgwqDCoMKgwqDCoCAyLjIpIElmIHJ1bm5pbmcg
b24gdGhlIFhlbiBoeXBlcnZpc29yIChYODZfRkVBVFVSRV9YRU5QViksIHRoZQ0KPj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrZXJuZWwgcnVudGltZSBiaW5hcnkgaXMgcGF0Y2hl
ZCB0byB1bmNvbmRpdGlvbmFsbHkganVtcA0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB0byB0aGUgWGVuIE1TUiB3cml0ZSBjb2RlLg0KPj4NCj4+IEkgY2FuJ3Qgc2VlIHdoYXQg
aXMgZGlmZmVyZW50IGhlcmUgY29tcGFyZWQgdG8gdG9kYXkncyBzdGF0ZS4NCj4+DQo+Pj4N
Cj4+PiBUaGUgYWx0ZXJuYXRpdmVzIG1lY2hhbmlzbSBpcyBhbHNvIHVzZWQgdG8gY2hvb3Nl
IHRoZSBuZXcgaW1tZWRpYXRlDQo+Pj4gZm9ybSBNU1Igd3JpdGUgaW5zdHJ1Y3Rpb24gd2hl
biBpdCdzIGF2YWlsYWJsZS4NCj4+DQo+PiBZZXMsIHRoaXMgbmVlZHMgdG8gYmUgYWRkZWQu
DQo+Pg0KPj4+IENvbnNlcXVlbnRseSwgcmVtb3ZlIHRoZSBwdl9vcHMgTVNSIHdyaXRlIEFQ
SXMgYW5kIHRoZSBYZW4gY2FsbGJhY2tzLg0KPj4NCj4+IEkgc3RpbGwgZG9uJ3Qgc2VlIGEg
bWFqb3IgZGlmZmVyZW5jZSB0byB0b2RheSdzIHNvbHV0aW9uLg0KPiANCj4gVGhlIGV4aXN0
aW5nIGNvZGUgZ2VuZXJhdGVzOg0KPiANCj4gIMKgwqDCoCAuLi4NCj4gIMKgwqDCoCBiZiBl
MCAwNiAwMCAwMMKgwqDCoMKgwqDCoMKgwqDCoCBtb3bCoMKgwqAgJDB4NmUwLCVlZGkNCj4g
IMKgwqDCoCA4OSBkNsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtb3bC
oMKgwqAgJWVkeCwlZXNpDQo+ICDCoMKgwqAgNDggYzEgZWEgMjDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgc2hywqDCoMKgICQweDIwLCVyZHgNCj4gIMKgwqDCoCBmZiAxNSAwNyA0OCA4
YyAwMcKgwqDCoMKgwqDCoCBjYWxswqDCoCAqMHgxOGM0ODA3KCVyaXApwqAgIyA8cHZfb3Bz
KzB4Yjg+DQo+ICDCoMKgwqAgMzEgYzDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgeG9ywqDCoMKgICVlYXgsJWVheA0KPiAgwqDCoMKgIC4uLg0KPiANCj4gQW5kIG9u
IG5hdGl2ZSwgdGhlIGluZGlyZWN0IGNhbGwgaW5zdHJ1Y3Rpb24gaXMgcGF0Y2hlZCB0byBh
IGRpcmVjdCBjYWxsDQo+IGFzIHlvdSBtZW50aW9uZWQ6DQo+IA0KPiAgwqDCoMKgIC4uLg0K
PiAgwqDCoMKgIGJmIGUwIDA2IDAwIDAwwqDCoMKgwqDCoMKgwqDCoMKgIG1vdsKgwqDCoCAk
MHg2ZTAsJWVkaQ0KPiAgwqDCoMKgIDg5IGQ2wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIG1vdsKgwqDCoCAlZWR4LCVlc2kNCj4gIMKgwqDCoCA0OCBjMSBlYSAyMMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzaHLCoMKgwqAgJDB4MjAsJXJkeA0KPiAgwqDCoMKg
IGU4IDYwIDNlIDAxIDAwwqDCoMKgwqDCoMKgwqDCoMKgIGNhbGzCoMKgIDx7bmF0aXZlLHhl
bn1fd3JpdGVfbXNyPiAjIGRpcmVjdA0KPiAgwqDCoMKgIDkwwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5vcA0KPiAgwqDCoMKgIDMxIGMwwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHhvcsKgwqDCoCAlZWF4LCVlYXgNCj4gIMKg
wqDCoCAuLi4NCj4gDQo+IA0KPiBUaGlzIHBhdGNoIHNldCBnZW5lcmF0ZXMgYXNzZW1ibHkg
dy9vIENBTEwgb24gbmF0aXZlOg0KPiANCj4gIMKgwqDCoCAuLi4NCj4gIMKgwqDCoCBlOSBl
NiAyMiBjNiAwMcKgwqDCoMKgwqDCoMKgwqDCoCBqbXDCoMKgwqAgMWbCoMKgICMgb24gbmF0
aXZlIG9yIG5vcCBvbiBYZW4NCj4gIMKgwqDCoCBiOSBlMCAwNiAwMCAwMMKgwqDCoMKgwqDC
oMKgwqDCoCBtb3bCoMKgwqAgJDB4NmUwLCVlY3gNCj4gIMKgwqDCoCBlOCA5MSBkNCBmYSBm
ZsKgwqDCoMKgwqDCoMKgwqDCoCBjYWxswqDCoCBmZmZmZmZmZjgxMzRlZTgwIDxhc21feGVu
X3dyaXRlX21zcj4NCj4gIMKgwqDCoCBlOSBhNCA5ZiBlYiAwMMKgwqDCoMKgwqDCoMKgwqDC
oCBqbXDCoMKgwqAgZmZmZmZmZmY4MjI1YjlhMCA8X194ODZfcmV0dXJuX3RodW5rPg0KPiAg
wqDCoMKgwqDCoMKgwqAgLi4uDQo+IDE6wqAgYjkgZTAgMDYgMDAgMDDCoMKgwqDCoMKgwqDC
oMKgwqAgbW92wqDCoMKgICQweDZlMCwlZWN4wqDCoCAjIGltbWVkaWF0ZSBmb3JtIGhlcmUN
Cj4gIMKgwqDCoCA0OCA4OSBjMsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtb3bC
oMKgwqAgJXJheCwlcmR4DQo+ICDCoMKgwqAgNDggYzEgZWEgMjDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgc2hywqDCoMKgICQweDIwLCVyZHgNCj4gIMKgwqDCoCAzZSAwZiAzMMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkcyB3cm1zcg0KPiAgwqDCoMKgIC4uLg0KPiAN
Cj4gSXQncyBub3QgYSBtYWpvciBjaGFuZ2UsIGJ1dCB3aGVuIGl0IGlzIHBhdGNoZWQgdG8g
dXNlIHRoZSBpbW1lZGlhdGUgZm9ybSBNU1IgDQo+IHdyaXRlIGluc3RydWN0aW9uLCBpdCdz
IHN0cmFpZ2h0Zm9yd2FyZGx5IHN0cmVhbWxpbmVkLg0KDQpJdCBzaG91bGQgYmUgcmF0aGVy
IGVhc3kgdG8gc3dpdGNoIHRoZSBjdXJyZW50IHdybXNyL3JkbXNyIHBhcmF2aXJ0IHBhdGNo
aW5nDQpsb2NhdGlvbnMgdG8gdXNlIHRoZSByZG1zci93cm1zciBpbnN0cnVjdGlvbnMgaW5z
dGVhZCBvZiBkb2luZyBhIGNhbGwgdG8NCm5hdGl2ZV8qbXNyKCkuDQoNClRoZSBjYXNlIG9m
IHRoZSBuZXcgaW1tZWRpYXRlIGZvcm0gY291bGQgYmUgaGFuZGxlZCB0aGUgc2FtZSB3YXku
DQoNCj4gDQo+Pg0KPj4gT25seSB0aGUgInBhcmF2aXJ0IiB0ZXJtIGhhcyBiZWVuIGVsaW1p
bmF0ZWQuDQo+IA0KPiBZZXMuDQo+IA0KPiBCdXQgYSBQViBndWVzdCBkb2Vzbid0IG9wZXJh
dGUgYXQgdGhlIGhpZ2hlc3QgcHJpdmlsZWdlIGxldmVsLCB3aGljaA0KPiBtZWFucyBNU1Ig
aW5zdHJ1Y3Rpb25zIHR5cGljYWxseSByZXN1bHQgaW4gYSAjR1AgZmF1bHQuwqAgSSBhY3R1
YWxseSB0aGluayB0aGUgDQo+IHB2X29wcyBNU1IgQVBJcyBhcmUgdW5uZWNlc3NhcnkgYmVj
YXVzZSBvZiB0aGlzIGluaGVyZW50DQo+IGxpbWl0YXRpb24uDQo+IA0KPiBMb29raW5nIGF0
IHRoZSBYZW4gTVNSIGNvZGUsIGV4Y2VwdCBQTVUgYW5kIGp1c3QgYSBmZXcgTVNScywgaXQg
ZmFsbHMNCj4gYmFjayB0byBleGVjdXRlcyBuYXRpdmUgTVNSIGluc3RydWN0aW9ucy7CoCBB
cyBNU1IgaW5zdHJ1Y3Rpb25zIHRyaWdnZXINCj4gI0dQLCBYZW4gdGFrZXMgY29udHJvbCBh
bmQgaGFuZGxlcyB0aGVtIGluIDIgd2F5czoNCj4gDQo+ICDCoCAxKSBlbXVsYXRlIChvciBp
Z25vcmUpIGEgTVNSIG9wZXJhdGlvbiBhbmQgc2tpcCB0aGUgZ3Vlc3QgaW5zdHJ1Y3Rpb24u
DQo+IA0KPiAgwqAgMikgaW5qZWN0IHRoZSAjR1AgYmFjayB0byBndWVzdCBPUyBhbmQgbGV0
IGl0cyAjR1AgaGFuZGxlciBoYW5kbGUgaXQuDQo+ICDCoMKgwqDCoCBCdXQgTGludXggTVNS
IGV4Y2VwdGlvbiBoYW5kbGVyIGp1c3QgaWdub3JlcyB0aGUgTVNSIGluc3RydWN0aW9uDQo+
ICDCoMKgwqDCoCAoTUNFIE1TUiBleGNlcHRpb24gd2lsbCBwYW5pYykuDQo+IA0KPiBTbyB3
aHkgbm90IGxldCBYZW4gaGFuZGxlIGFsbCB0aGUgZGV0YWlscyB3aGljaCBpdCBhbHJlYWR5
IHRyaWVzIHRvIGRvPw0KDQpTb21lIE1TUnMgYXJlIG5vdCBoYW5kbGVkIHRoYXQgd2F5LCBi
dXQgdmlhIGEga2VybmVsIGludGVybmFsIGVtdWxhdGlvbi4NCkFuZCB0aG9zZSBhcmUgaGFu
ZGxlZCB0aGF0IHdheSBtb3N0bHkgZHVlIHRvIHBlcmZvcm1hbmNlIHJlYXNvbnMuIEFuZCBz
b21lDQpuZWVkIHNwZWNpYWwgdHJlYXRtZW50Lg0KDQo+IChMaW51eCB3LyBzdWNoIGEgY2hh
bmdlIG1heSBub3QgYmUgYWJsZSB0byBydW4gb24gb2xkIFhlbiBoeXBlcnZpc29ycy4pDQoN
ClllcywgYW5kIHRoaXMgaXMgc29tZXRoaW5nIHRvIGF2b2lkLg0KDQpBbmQgcmVtZW1iZXIg
dGhhdCBMaW51eCBpc24ndCB0aGUgb25seSBQVi1tb2RlIGd1ZXN0IGV4aXN0aW5nLg0KDQo+
IEJUVywgaWYgcGVyZm9ybWFuY2UgaXMgYSBjb25jZXJuLCB3cml0ZXMgdG8gTVNSX0tFUk5F
TF9HU19CQVNFIGFuZA0KPiBNU1JfR1NfQkFTRSBhbnl3YXkgYXJlIGhweWVyY2FsbHMgaW50
byBYZW4uDQoNClllcywgYW5kIHNvbWUgb3RoZXIgTVNSIHdyaXRlcyBhcmUganVzdCBOT1Bz
IHdpdGggWGVuLVBWLg0KDQoNCkp1ZXJnZW4NCg==
--------------0DTyIjBeblppipV7B0zRSAr0
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------0DTyIjBeblppipV7B0zRSAr0--

--------------FLAnSz0SzY3c5JmVJHJBKSu5--

--------------398yZoWCv7yp9PXp1RKEeUfd
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgJD8AFAwAAAAAACgkQsN6d1ii/Ey8y
6Qf+J/9aBCAtkvUKlIHFrXLzuNq1p6I3Y1PLOrAvj55laq4pjmVC/ErEafqyCtitWRcEw9XU260I
55Cv2AWrv2pHnsepuTfAOfENQX7k6B1UT7IxYgtnRFXlL2Ue0amb0bKtdPX26M4N/5E9Z62mbfW6
l8N/70GzVKp7LwMs7tRNjfXDdUj1KEznRKMJs89Q2BLnLq8m0XwyOW9VhrhODQABXTePrLFPVip1
5FaEfn5Yk8GCAma/60ZVMUnFaPpC+pcpn/y/hVW4gmTuDzyHsgnM7mCjPuRyokY/WkrrL/CFgbEO
3bT8iJg5C7gPtZVVpbSkW+NbdzYKF7v0vD78ZSBCwA==
=p2ZE
-----END PGP SIGNATURE-----

--------------398yZoWCv7yp9PXp1RKEeUfd--

