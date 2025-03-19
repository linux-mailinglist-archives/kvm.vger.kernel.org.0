Return-Path: <kvm+bounces-41528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E06FDA69C8B
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 00:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EAAB7AE321
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 23:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D1D222590;
	Wed, 19 Mar 2025 23:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bkih2udH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6FA221F3E
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 23:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742425748; cv=none; b=B3joc8qnvKbSAQMPdDP2JVqI3+wMA6fSF7ViaRyneuko8kdYBxipXGV9IX3Y1p+l4KEzk7ImDc+AujHtu9f00e7FYl32ElA2Uv8GqU6Ri2dFv17qs/d5JYoYQ2cDET+PROGIvdtyHA6yqrAS4mWfVkNba7BUZeAVY0by06+FTmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742425748; c=relaxed/simple;
	bh=vc1QjsrUNop6NT34LfjdBlMP7nwjGJRKQWt7xwjFmPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=km4WonDAM5CWo3nJ1YV7lFwPuaMZqyxXHS1zQeRExuj6d3RS55SzFLt98Zi+FwpYfvzJgJ6QF+RGd9y0QGVZo4VylnjT+f/LjS5Uwdj08c0oEwYafxsUtqw6xohVGUh9q4rpNJEegQf9zU81UCgK0FSB1Jm0Gxc135URtNPaGqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bkih2udH; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2235189adaeso3103985ad.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 16:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742425745; x=1743030545; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vc1QjsrUNop6NT34LfjdBlMP7nwjGJRKQWt7xwjFmPw=;
        b=bkih2udH1TZroUZ/bJiksZMKEjEqnTlxzTLF5R5kWHigL0eFSfsnsvWaFPW/KQie64
         ZQF7Nd91izY0Q7g2p+QtUqmQ7cOhH2b9wYo29W1aw+qBGYlcT/2MQ9Sv33+YWoiX6fJn
         SkIuj2DTrpckQlW0u51J+tAkfHDOcHuDGDYxe7y8p2o6jQZ850rYZ6G467S2meFPAya3
         U4YZXDHpC9O0MaKkrFGqtAz5M2yf21c4OpcHw8XoaBLWBsMMUjuK0jqV+3laYrbFqyfg
         o0ooSd5sjkLHxU/aOXdbTD+CnwtMR00hFOO5O5nCWwMuBwJkA1N+Pt8y+aOzx8EQNRjq
         YcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742425745; x=1743030545;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vc1QjsrUNop6NT34LfjdBlMP7nwjGJRKQWt7xwjFmPw=;
        b=M77dFG58Qzen0QayFKQqec2LxkShiTAsL4SPay28e8FyNB7wvbTopMFt7I59ya3MOJ
         z4VYXGpWLxN6r4xuB7sRUdEuFLdLGRT1Na9lYAusDP31Lsua4I6+7V0TF5O63JZjagv1
         uHadswQie0p9PNw1nPEXCw6ki2xHMEzRNBLFaZhAF2JkeUp+/MsFOlNi9OYSvdGsSRMi
         q2B/S/xC4OZ6wYjEEceqwlX9lojr1Vsa2HW+UXalvo0mFK6SooaxxPKi//wd/K3tA3ZX
         pUGBUehzLbnh7BuyAbB32j2Jj+UPHYCnfDuX1YDRq6dtvAWF2z1Ep4JTB+2pXQI8cJtB
         EDeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvRdkQoQYuVPWd/HBFVgD0MCuMLcDza6ZiS1fD4COlzKZkpTik4SZWeY2YKnDtTsMBiKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwthZvo6CS5kWxKGhI7+ifBFhUieYxlsD2vOmus0EwwL/7FEfSU
	VFSKOQiVED01601UbEGfOjcjWtXR+mf0nZG3ndYbYSrQddaRLa/DIg1LJzrzSSA=
X-Gm-Gg: ASbGnct4lQf1LAnDLE3ji80pGzFjdzViEHp6IpBztglWMQavbA6fPh/yeWg8tEQtdgq
	xSjnYOF11HMugwIQuNipV0GOKtGFXvFd948GvdoFDqorMJ8NddFOhiba3KHOTgWJ6TQuougraqM
	KyKWr1/3BaS3cLz+UVNDYLP55zJ5Cx8JNL8cGL1rOAP5u3+6YdZIPN5Rd7kn2bvM9GR0879yvUf
	MD/uk2n5iCPjCKvFK76J9kb+hRMd5h6zex4/ZZnfsRw6NyThiGjq+caEfFuulJVB2HoBrdnsR5l
	vIUolZS2WIxlpvZMafX6T8WkGAcF9tMi4XaNzXLlt81yAzxfaYwcV3A1Qw==
X-Google-Smtp-Source: AGHT+IEybpOSsnbkV87Um3HczhmpYrkNqcFe1swRytU+M2QpreJDTcs7ZY3BLcVX4mk11SEbqt2IdQ==
X-Received: by 2002:a17:903:1a27:b0:21f:98fc:8414 with SMTP id d9443c01a7336-2265e7c2830mr19945575ad.26.1742425745587;
        Wed, 19 Mar 2025 16:09:05 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6ba724asm121095885ad.152.2025.03.19.16.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 16:09:05 -0700 (PDT)
Message-ID: <5c977254-ee11-4604-91f0-70720d06eaeb@linaro.org>
Date: Wed, 19 Mar 2025 16:09:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] target/arm/cpu: define ARM_MAX_VQ once for aarch32
 and aarch64
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
 <20250318045125.759259-10-pierrick.bouvier@linaro.org>
 <a88f54cb-73be-4947-b3be-aa12b120f07e@linaro.org>
 <52000c3d-827f-4e21-afa3-f191c6636b9d@linaro.org>
 <52c8b6dc-048c-49d2-b535-4855b9f3d26b@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <52c8b6dc-048c-49d2-b535-4855b9f3d26b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOS8yNSAwMDowMywgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDE4LzMvMjUgMjM6MDIsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBPbiAzLzE4LzI1
IDExOjUwLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4+PiBPbiAxOC8zLzI1
IDA1OjUxLCBQaWVycmljayBCb3V2aWVyIHdyb3RlOg0KPj4+PiBUaGlzIHdpbGwgYWZmZWN0
IHpyZWdzIGZpZWxkIGZvciBhYXJjaDMyLg0KPj4+PiBUaGlzIGZpZWxkIGlzIHVzZWQgZm9y
IE1WRSBhbmQgU1ZFIGltcGxlbWVudGF0aW9ucy4gTVZFIGltcGxlbWVudGF0aW9uDQo+Pj4+
IGlzIGNsaXBwaW5nIGluZGV4IHZhbHVlIHRvIDAgb3IgMSBmb3IgenJlZ3NbKl0uZFtdLA0K
Pj4+PiBzbyB3ZSBzaG91bGQgbm90IHRvdWNoIHRoZSByZXN0IG9mIGRhdGEgaW4gdGhpcyBj
YXNlIGFueXdheS4NCj4+Pg0KPj4+IFdlIHNob3VsZCBkZXNjcmliZSB3aHkgaXQgaXMgc2Fm
ZSBmb3IgbWlncmF0aW9uLg0KPj4+DQo+Pj4gSS5lLiB2bXN0YXRlX3phIGRlcGVuZHMgb24g
emFfbmVlZGVkKCkgLT4gU01FLCBub3QgaW5jbHVkZWQgaW4gMzItYml0DQo+Pj4gY3B1cywg
ZXRjLg0KPj4+DQo+Pj4gU2hvdWxkIHdlIHVwZGF0ZSB0YXJnZXQvYXJtL21hY2hpbmUuYyBp
biB0aGlzIHNhbWUgcGF0Y2gsIG9yIGENCj4+PiBwcmVsaW1pbmFyeSBvbmU/DQo+Pj4NCj4+
DQo+PiB2bXN0YXRlX3phIGRlZmluaXRpb24gYW5kIGluY2x1c2lvbiBpbiB2bXN0YXRlX2Fy
bV9jcHUgaXMgdW5kZXIgI2lmZGVmDQo+PiBUQVJHRVRfQUFSQ0g2NC4gSW4gdGhpcyBjYXNl
IChUQVJHRVRfQUFSQ0g2NCksIEFSTV9NQVhfVlEgd2FzIGFscmVhZHkNCj4+IGRlZmluZWQg
YXMgMTYsIHNvIHRoZXJlIHNob3VsZCBub3QgYmUgYW55IGNoYW5nZS4NCj4gDQo+IEknbSBu
b3Qgc2F5aW5nIHRoaXMgaXMgaW52YWxpZCwgSSdtIHRyeWluZyB0byBzYXkgd2UgbmVlZCB0
byBkb2N1bWVudA0KPiB3aHkgaXQgaXMgc2FmZS4NCj4gDQo+PiBPdGhlciB2YWx1ZXMgZGVw
ZW5kaW5nIG9uIEFSTV9NQVhfVlEsIGZvciBtaWdyYXRpb24sIGFyZSBhcyB3ZWxsIHVuZGVy
DQo+PiBUQVJHRVRfQUFSQ0g2NCBpZmRlZnMgKHZtc3RhdGVfenJlZ19oaV9yZWcsIHZtc3Rh
dGVfcHJlZ19yZWcsDQo+PiB2bXN0YXRlX3ZyZWcpLg0KPj4NCj4+IEFuZCBmb3Igdm1zdGF0
ZV92ZnAsIHdoaWNoIGlzIHByZXNlbnQgZm9yIGFhcmNoMzIgYXMgd2VsbCwgdGhlIHNpemUg
b2YNCj4+IGRhdGEgdW5kZXIgZWFjaCByZWdpc3RlciBpcyBzcGVjaWZpY2FsbHkgc2V0IHRv
IDIuDQo+PiBWTVNUQVRFX1VJTlQ2NF9TVUJfQVJSQVkoZW52LnZmcC56cmVnc1swXS5kLCBB
Uk1DUFUsIDAsIDIpDQo+Pg0KPj4gU28gZXZlbiBpZiBzdG9yYWdlIGhhcyBtb3JlIHNwYWNl
LCBpdCBzaG91bGQgbm90IGltcGFjdCBhbnkgdXNhZ2Ugb2YgaXQuDQo+Pg0KPj4gRXZlbiB0
aG91Z2ggdGhpcyBjaGFuZ2UgaXMgdHJpdmlhbCwgSSBkaWRuJ3QgZG8gaXQgYmxpbmRseSB0
byAibWFrZSBpdA0KPj4gY29tcGlsZSIgYW5kIEkgY2hlY2tlZCB0aGUgdmFyaW91cyB1c2Fn
ZXMgb2YgQVJNX01BWF9WUSBhbmQgenJlZ3MsIGFuZCBJDQo+PiBkaWRuJ3Qgc2VlIGFueXRo
aW5nIHRoYXQgc2VlbXMgdG8gYmUgYSBwcm9ibGVtLg0KPiANCj4gWW91IGRpZCB0aGUgYW5h
bHlzaXMgb25jZSwgbGV0J3MgYWRkIGl0IGluIHRoZSBjb21taXQgZGVzY3JpcHRpb24gc28N
Cj4gb3RoZXIgZGV2ZWxvcGVycyBsb29raW5nIGF0IHRoaXMgY29tbWl0IHdvbid0IGhhdmUg
dG8gZG8gaXQgYWdhaW4uDQo+IA0KDQpTdXJlLCBJJ2xsIGFkZCB0aGlzIHRvIHRoZSBjb21t
aXQgbWVzc2FnZS4NCg0KPj4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogUGllcnJpY2sg
Qm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KPj4+PiAtLS0NCj4+Pj4g
IMKgwqAgdGFyZ2V0L2FybS9jcHUuaCB8IDYgKy0tLS0tDQo+Pj4+ICDCoMKgIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNSBkZWxldGlvbnMoLSkNCj4+Pj4NCj4+Pj4gZGlm
ZiAtLWdpdCBhL3RhcmdldC9hcm0vY3B1LmggYi90YXJnZXQvYXJtL2NwdS5oDQo+Pj4+IGlu
ZGV4IDI3YTBkNDU1MGYyLi4wMGY3OGQ2NGJkOCAxMDA2NDQNCj4+Pj4gLS0tIGEvdGFyZ2V0
L2FybS9jcHUuaA0KPj4+PiArKysgYi90YXJnZXQvYXJtL2NwdS5oDQo+Pj4+IEBAIC0xNjks
MTEgKzE2OSw3IEBAIHR5cGVkZWYgc3RydWN0IEFSTUdlbmVyaWNUaW1lciB7DQo+Pj4+ICDC
oMKgwqAgKiBBbGlnbiB0aGUgZGF0YSBmb3IgdXNlIHdpdGggVENHIGhvc3QgdmVjdG9yIG9w
ZXJhdGlvbnMuDQo+Pj4+ICDCoMKgwqAgKi8NCj4+Pj4gLSNpZmRlZiBUQVJHRVRfQUFSQ0g2
NA0KPj4+PiAtIyBkZWZpbmUgQVJNX01BWF9WUcKgwqDCoCAxNg0KPj4+PiAtI2Vsc2UNCj4+
Pj4gLSMgZGVmaW5lIEFSTV9NQVhfVlHCoMKgwqAgMQ0KPj4+PiAtI2VuZGlmDQo+Pj4+ICsj
ZGVmaW5lIEFSTV9NQVhfVlHCoMKgwqAgMTYNCj4+Pj4gIMKgwqAgdHlwZWRlZiBzdHJ1Y3Qg
QVJNVmVjdG9yUmVnIHsNCj4+Pj4gIMKgwqDCoMKgwqDCoCB1aW50NjRfdCBkWzIgKiBBUk1f
TUFYX1ZRXSBRRU1VX0FMSUdORUQoMTYpOw0KPj4+DQo+Pg0KPiANCg0K

