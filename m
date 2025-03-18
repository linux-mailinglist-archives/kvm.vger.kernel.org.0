Return-Path: <kvm+bounces-41435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8231A67BDD
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62D1C17B058
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730E9212D63;
	Tue, 18 Mar 2025 18:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O7aCy8xn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166A41917FB
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742322224; cv=none; b=uppfSXmJEtTXFdkDSLne83TSUvjY2z8H9ZAgmTQFS1D+xNH9m5xdp6OZTfrjESSMXAj+HSJOtOJAL2tfEgBhbZpzHG716sPTlS/fcyN7m6UcqGT8znZG1dY2J7oy81NjibyQdGAVSHjODAcu+fmrI97kea43woOaMkhZgDvhgCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742322224; c=relaxed/simple;
	bh=zhdlHNWmjY0/U0RTVbqd1beK1I5dVapYlQeofi/XGMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E96h7ycCUtyXMFAsP6UTNAzAQEUZ8NkQZnerwDgAwBZW2PhgYBFhFm6Y2L1AM728uwXTSND65uWeATd2O9hFHobhgfABAPE+tkqOi++mKpNXpFIlkXVCm3Da0nLZ4N+9PsrlXwvTqVwURsz5MGmhCEP6ASVSV+x9J9wODOWQc8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O7aCy8xn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22548a28d0cso12287055ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742322222; x=1742927022; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zhdlHNWmjY0/U0RTVbqd1beK1I5dVapYlQeofi/XGMw=;
        b=O7aCy8xngsJAHjTnevuBNJUyv6nSQlmpqzczj8YRP/FJXh1UBoQbq6L6OZlhHhwUSD
         n3zcQGRiEoZMHvRcvBXXKc1LEyN2amcD8BlcdkeAkVA/dLfWEJzQawqvYCxYFU7Dr+De
         NGrOteRuhAKk8GsAaNuSn01Ksbddh96CS9zWD/VPcOQu1NfYq6RnQFa+eU8ROEfEY+vL
         Edp9qXNVWkgXH8sJ3QVh8RSuVYBauTOQd1Ua1ooNx01YsY3+A9W6xB3j2WSMqnVVCS2S
         Dh2pUOD4ozdmG1DHhMmldxzopkKXHftoIDJnxJrWkZALUl+YB4hmie0AcwI0X/UeeRcH
         p8aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742322222; x=1742927022;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zhdlHNWmjY0/U0RTVbqd1beK1I5dVapYlQeofi/XGMw=;
        b=rUoPnKLqOZfkvD1r48OSL0AcSemSjQF2gFYbuKzUfcVx5CKocK2bXlRI8AbPY71oN/
         mJpijC63JWspNP5E4S0JYCD3sblNKCpoZejemu2owEjm0AqDGxT/ZPE3M+RQsLIF6TGe
         5insW1iTEPaNeSM7Gouyl2RQsOX7AGlop7b8nKCfnRrgakbrjnMJgPII42/Nm9XzUqnR
         C0E4fQ/I5R8SW+t8Xv+LWp3wMHDrl5fgCIvIOG8AfDVffWa9vNTLnyhv9vB8NpnyOf4I
         AUip0UfOivcSQh8FJC0HNEJpBMHStAGzKw96epaFwrzaoMnA2hzLBFqgErjJAaRobC0D
         srvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3s0SzoIJZuoKhZ4PZNebRiR03VDs7StELmwRnsfzN5R98ULz3/k1DG9SC46Ol+kTCPAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxZoIEgBAoMbxV6W8t/WOpPMXJxqod9d/r7+GTgTyVJwg6OsXX
	+8KXFshbbFosMKvyo8y+WAke1+oBc6Sugh18z7e6Ii3NijTTFIkmKzRbooM/PT4=
X-Gm-Gg: ASbGncviNgXIk59ylNPUwk2ywd2Q0nxOTu9diQgCRISb+6P7UVUADGevhVxWLWIfzrG
	lqXtFRBOFp+txKNk7OS4DygdCxjT5niir8SnvRWmO5dgLZxuC1dzEas8gEBJ4vyDlu++Ucsn8Dt
	ngGr0SC4pEz2TcgNdS6Z9K1WBtVuXijifiIkWI1Hin/6D6YgZ0ry9eLEfopglzDzazjbBXzjG3Z
	tEhv60nUeY7SK/I9r9nquPqQT8vYD3fQJW9bg3SSmylwXggGSbuMmPUQMcUUxZlDBX8OHfmQTQZ
	lLK53lgVIh0F+TLxr6cSvkyImSv0ktX8EUV+vhhyiNSW6DeVzJjxIJ9WAg==
X-Google-Smtp-Source: AGHT+IF2LvaZ3PEnsxaSBKWmFbnLT1gdeU7gnXTv95cW5ygVp8xR52qeX2fRpo9WNGk6os/wtQpMKA==
X-Received: by 2002:aa7:888a:0:b0:736:baa0:2acd with SMTP id d2e1a72fcca58-73722460be6mr24957668b3a.20.1742322222270;
        Tue, 18 Mar 2025 11:23:42 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371157369bsm9893539b3a.75.2025.03.18.11.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 11:23:41 -0700 (PDT)
Message-ID: <ab9b15c1-4f59-4fce-88fd-028fd21875c3@linaro.org>
Date: Tue, 18 Mar 2025 11:23:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] target/arm/cpu: always define kvm related registers
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-8-pierrick.bouvier@linaro.org>
 <fa3c4676-f78c-42af-b572-559640c0e4f7@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <fa3c4676-f78c-42af-b572-559640c0e4f7@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOC8yNSAxMToxNCwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDE4LzMvMjUgMDU6NTEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBUaGlzIGRvZXMg
bm90IGh1cnQsIGV2ZW4gaWYgdGhleSBhcmUgbm90IHVzZWQuDQo+IA0KPiBJJ20gbm90IGNv
bnZpbmNlZCBieSB0aGUgcmF0aW9uYWxlLg0KPiANCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBQ
aWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo+PiAtLS0N
Cj4+ICAgIHRhcmdldC9hcm0vY3B1LmggfCAyIC0tDQo+PiAgICAxIGZpbGUgY2hhbmdlZCwg
MiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9jcHUuaCBi
L3RhcmdldC9hcm0vY3B1LmgNCj4+IGluZGV4IDIzYzIyOTNmN2QxLi45NmY3ODAxYTIzOSAx
MDA2NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0vY3B1LmgNCj4+ICsrKyBiL3RhcmdldC9hcm0v
Y3B1LmgNCj4+IEBAIC05NzEsNyArOTcxLDYgQEAgc3RydWN0IEFyY2hDUFUgew0KPj4gICAg
ICAgICAqLw0KPj4gICAgICAgIHVpbnQzMl90IGt2bV90YXJnZXQ7DQo+PiAgICANCj4+IC0j
aWZkZWYgQ09ORklHX0tWTQ0KPj4gICAgICAgIC8qIEtWTSBpbml0IGZlYXR1cmVzIGZvciB0
aGlzIENQVSAqLw0KPj4gICAgICAgIHVpbnQzMl90IGt2bV9pbml0X2ZlYXR1cmVzWzddOw0K
Pj4gICAgDQo+PiBAQCAtOTg0LDcgKzk4Myw2IEBAIHN0cnVjdCBBcmNoQ1BVIHsNCj4+ICAg
IA0KPj4gICAgICAgIC8qIEtWTSBzdGVhbCB0aW1lICovDQo+PiAgICAgICAgT25PZmZBdXRv
IGt2bV9zdGVhbF90aW1lOw0KPj4gLSNlbmRpZiAvKiBDT05GSUdfS1ZNICovDQo+IA0KPiBN
YXliZSB3ZSBuZWVkIGFuIG9wYXF1ZSBBcmNoQWNjZWxDcHVTdGF0ZSBzdHJ1Y3R1cmUuLi4N
Cj4gDQoNCkl0J3Mgc2ltaWxhciB0byB0aGUgaW50ZXJlc3RpbmcgcXVlc3Rpb24gb2YgaG93
IHRvIGV4cG9zZSBzb21lIHJlZ2lzdGVycyANCmNvbmRpdGlvbm5hbGx5Lg0KDQpXZSBjb3Vs
ZCBwdXQgdGhpcyBpbiBhbm90aGVyIHN0cnVjdCwgYWxsb2NhdGUgaWYgb25seSBpZiBuZWVk
ZWQgDQooa3ZtX2VuYWJsZWQoKSksIG9yIGp1c3QgbGV0IGl0IGJlIHByZXNlbnQgYW55dGlt
ZSBsaWtlIGl0IGlzIGRvbmUgd2l0aCANCnRoaXMgcGF0Y2guDQoNCkkgZG9uJ3QgaGF2ZSBh
IHN0cm9uZyBvcGluaW9uLCBidXQgaGF2aW5nIGNvbmRpdGlvbmFsIHByZXNlbmNlIGhlcmUg
aXMgDQpqdXN0IG1ha2luZyB0aGluZ3MgY29tcGxpY2F0ZWQgd2l0aG91dCBpbnRyb2R1Y2lu
ZyBhbnkgYmVuZWZpdC4gSXQgZG9lcyANCm5vdCBwcmV2ZW50ICJ1bmF1dGhvcml6ZWQiIGFj
Y2VzcyB0byBpdC4NCg0KTm93LCBpZiB3ZSBzdGFydCB0byBoYXZlIHNvbWV0aGluZyBtb3Jl
IGNsZWFuLCBpbXBsZW1lbnRlZCBpbiBhbm90aGVyIA0KY29tcGlsYXRpb24gdW5pdHMsIG9u
bHkgcmVsYXRlZCB0byBrdm0sIHdlbGwsIHRoYXQgY291bGQgYmUgdXNlZnVsLiBCdXQgDQp3
ZSBoYXZlIHRvIGRlZmluZSB0aGUgaW50ZXJmYWNlIGZvciB0aGF0LCBhZGQgaXQgdG8gb3Ro
ZXIgYXJjaGl0ZWN0dXJlcywgDQphbmQgcHJvYmFibHkgc3BlbmQgYSBmZXcgbW9udGhzIGlu
IHRoZSBtaWRkbGUgd2hlcmUgdGhpbmdzIGFyZSBzdHVjayBoZXJlLg0KDQo+PiAgICANCj4+
ICAgICAgICAvKiBVbmlwcm9jZXNzb3Igc3lzdGVtIHdpdGggTVAgZXh0ZW5zaW9ucyAqLw0K
Pj4gICAgICAgIGJvb2wgbXBfaXNfdXA7DQo+IA0KDQo=

