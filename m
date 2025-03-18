Return-Path: <kvm+bounces-41452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6627A67F2F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0016E42437B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928CF205AD2;
	Tue, 18 Mar 2025 22:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c2cKT5/o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CDF1AF0B4
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742335323; cv=none; b=m0QopahwZFeuzTGqdMmf+bCR2QP+7ZHsOLWQfzD6wfjqn9GxXzKqXAHhAW8pDsQ1XcghaKHAtcq4BbVfqLL+ObU7IaZr0FVlJYw2q5nU3tXxINPeD7wtP+Fub0URZRGiFWbJ2r6/wdHG09+HMfw79J+5OR5baB5CVYh2hyaLhQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742335323; c=relaxed/simple;
	bh=H1ma9eYDFTQwEAmIoEMN4Tv/PH0ALZLbCTLzoj3VnYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GEmCwe2SyoAX5eQ5TRx+1w7SUTAnPMJWCWtiUfmuBUsQ/Yk5WthfVBx5zt8f3HjE2bIY8nKghAC4NIRfLiaJAiA5nj+lrVhVf6ESzNxC2FhC/4F3jOIe8IGJ1Efu6ilkRHe1KsBEogB4zC0EJ+ZRv8RGmcRjskn32UktNWycPYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c2cKT5/o; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ff6ae7667dso7668371a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742335321; x=1742940121; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H1ma9eYDFTQwEAmIoEMN4Tv/PH0ALZLbCTLzoj3VnYo=;
        b=c2cKT5/olTJ4viKCrPKGQw8MUftUFGGpJxl5fs6P91aET2Dtuq4BE7Y8G0T9DLhntw
         4TMeM4jbR+v7WYXIQ1nWRRhljs3P0uXWufKbp59TQeP5Nm5wmmXjmkUXQ4vbzIhvDSn2
         RXeTvK1GDhWco8bfCOQzkhHa3CUAURt4teuLPgsYdA1ReIMyvduUBZi8i00SIr9za+OY
         LSMfBpshNUf8y1wE05EOEzuQnlF54o6/kbvAfUbEI7eZ8UAvxuOYBGZzaef1RsGqk/vw
         BcHU+LzmMQCvnk3I/yLLKRVD3jPsgRgZW6u6dwKNG3Z/x9lPjUvP9Xa1SvaioA8uaf0d
         JfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742335321; x=1742940121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H1ma9eYDFTQwEAmIoEMN4Tv/PH0ALZLbCTLzoj3VnYo=;
        b=qzEym+OwH++8omGhaccW+jrVcWou9hlLx7KAs5pdAeyKJ9laI3sulNwLqJowfFNWbG
         IKGYRpqEXtATYqpYiRnmpVXjurhqLPJFK426eT28uLsG29m5Zwun9UaxtZN7zZph6bSg
         WmW0GQGKe22EG40R2V4YqX2satkP+UEeBGOPfjkt8+DEJ7l5tMKdIWJ12dfJlaOV+tKn
         7xMhYO1zlTak2ql/dP7mLAMFpdCDCg/ACPKHH8yMLTbG364p6GbPfLc5em24mBsEurCw
         VeiTkOfOfB+dFJTwHkbLWRxofs1q8PzfcGAZ0czcyW/U4g0crBSQIPeyh2H7zZFeW9tF
         JuIA==
X-Forwarded-Encrypted: i=1; AJvYcCXx9V11F6kIXW+hu66RXzL4v8ZAhXlBbZsQeJilnlYYJ19t3KXHhxtVXKJ4XZxLkuXzjo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzocHkJkSfvW3HHaMtGOJrtmmbDg/+joqXXpiiUxP0ZMTpFdjJP
	JtNZR1sJU7jfR2wM3VOeo8kb2V2OobJfSE7QG7x7n+lFqwROWfjH2pbz+keS4RU=
X-Gm-Gg: ASbGncuhRHs3svy/WSS9cVIn1CwWCMbGVD+g1o6VgWNUfm6jFnpp2aSgwenOOqx+CGW
	Q7j0TtRLUoQjvkhoJTb3X7nJLbTJRa1PQkifEL08pY+PWRJp3NJE2+PRjjV/RhMty1rvWCK+Jth
	Nu0yPVX4GqBn+Q8E8POxWxwW4/pDVJC6QMcH+XO6z1VspiS6s0Aw5FZjJExFFy5cOJF4tI8Jxdh
	5XLdImbe7Jg0ZAq9XfHJklvuP/rTVb2kT3TGv7y+y1BdKpKnj2pSQY24igOqVHizU7Fyu254l61
	93NNTyxomsB4r3VRGTDQhmAhkSkW7UK2EutiTdDTtQfuBr3Dhi/w+3Fnkg==
X-Google-Smtp-Source: AGHT+IGA6xCelHZF+AcnCIa4FYtOlE+IfHizdWlF6wrWrLYDP61Pg/rKjIzimS7rzlvz3MmiPDdYTQ==
X-Received: by 2002:a17:90b:4b8e:b0:2ee:53b3:3f1c with SMTP id 98e67ed59e1d1-301bde44515mr422400a91.5.1742335321248;
        Tue, 18 Mar 2025 15:02:01 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf5a12fasm4355a91.24.2025.03.18.15.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:02:00 -0700 (PDT)
Message-ID: <52000c3d-827f-4e21-afa3-f191c6636b9d@linaro.org>
Date: Tue, 18 Mar 2025 15:02:00 -0700
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
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <a88f54cb-73be-4947-b3be-aa12b120f07e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOC8yNSAxMTo1MCwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDE4LzMvMjUgMDU6NTEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBUaGlzIHdpbGwg
YWZmZWN0IHpyZWdzIGZpZWxkIGZvciBhYXJjaDMyLg0KPj4gVGhpcyBmaWVsZCBpcyB1c2Vk
IGZvciBNVkUgYW5kIFNWRSBpbXBsZW1lbnRhdGlvbnMuIE1WRSBpbXBsZW1lbnRhdGlvbg0K
Pj4gaXMgY2xpcHBpbmcgaW5kZXggdmFsdWUgdG8gMCBvciAxIGZvciB6cmVnc1sqXS5kW10s
DQo+PiBzbyB3ZSBzaG91bGQgbm90IHRvdWNoIHRoZSByZXN0IG9mIGRhdGEgaW4gdGhpcyBj
YXNlIGFueXdheS4NCj4gDQo+IFdlIHNob3VsZCBkZXNjcmliZSB3aHkgaXQgaXMgc2FmZSBm
b3IgbWlncmF0aW9uLg0KPiANCj4gSS5lLiB2bXN0YXRlX3phIGRlcGVuZHMgb24gemFfbmVl
ZGVkKCkgLT4gU01FLCBub3QgaW5jbHVkZWQgaW4gMzItYml0DQo+IGNwdXMsIGV0Yy4NCj4g
DQo+IFNob3VsZCB3ZSB1cGRhdGUgdGFyZ2V0L2FybS9tYWNoaW5lLmMgaW4gdGhpcyBzYW1l
IHBhdGNoLCBvciBhDQo+IHByZWxpbWluYXJ5IG9uZT8NCj4gDQoNCnZtc3RhdGVfemEgZGVm
aW5pdGlvbiBhbmQgaW5jbHVzaW9uIGluIHZtc3RhdGVfYXJtX2NwdSBpcyB1bmRlciAjaWZk
ZWYgDQpUQVJHRVRfQUFSQ0g2NC4gSW4gdGhpcyBjYXNlIChUQVJHRVRfQUFSQ0g2NCksIEFS
TV9NQVhfVlEgd2FzIGFscmVhZHkgDQpkZWZpbmVkIGFzIDE2LCBzbyB0aGVyZSBzaG91bGQg
bm90IGJlIGFueSBjaGFuZ2UuDQoNCk90aGVyIHZhbHVlcyBkZXBlbmRpbmcgb24gQVJNX01B
WF9WUSwgZm9yIG1pZ3JhdGlvbiwgYXJlIGFzIHdlbGwgdW5kZXIgDQpUQVJHRVRfQUFSQ0g2
NCBpZmRlZnMgKHZtc3RhdGVfenJlZ19oaV9yZWcsIHZtc3RhdGVfcHJlZ19yZWcsIHZtc3Rh
dGVfdnJlZykuDQoNCkFuZCBmb3Igdm1zdGF0ZV92ZnAsIHdoaWNoIGlzIHByZXNlbnQgZm9y
IGFhcmNoMzIgYXMgd2VsbCwgdGhlIHNpemUgb2YgDQpkYXRhIHVuZGVyIGVhY2ggcmVnaXN0
ZXIgaXMgc3BlY2lmaWNhbGx5IHNldCB0byAyLg0KVk1TVEFURV9VSU5UNjRfU1VCX0FSUkFZ
KGVudi52ZnAuenJlZ3NbMF0uZCwgQVJNQ1BVLCAwLCAyKQ0KDQpTbyBldmVuIGlmIHN0b3Jh
Z2UgaGFzIG1vcmUgc3BhY2UsIGl0IHNob3VsZCBub3QgaW1wYWN0IGFueSB1c2FnZSBvZiBp
dC4NCg0KRXZlbiB0aG91Z2ggdGhpcyBjaGFuZ2UgaXMgdHJpdmlhbCwgSSBkaWRuJ3QgZG8g
aXQgYmxpbmRseSB0byAibWFrZSBpdCANCmNvbXBpbGUiIGFuZCBJIGNoZWNrZWQgdGhlIHZh
cmlvdXMgdXNhZ2VzIG9mIEFSTV9NQVhfVlEgYW5kIHpyZWdzLCBhbmQgSSANCmRpZG4ndCBz
ZWUgYW55dGhpbmcgdGhhdCBzZWVtcyB0byBiZSBhIHByb2JsZW0uDQoNCj4+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5v
cmc+DQo+PiAtLS0NCj4+ICAgIHRhcmdldC9hcm0vY3B1LmggfCA2ICstLS0tLQ0KPj4gICAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA1IGRlbGV0aW9ucygtKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2NwdS5oIGIvdGFyZ2V0L2FybS9jcHUuaA0KPj4g
aW5kZXggMjdhMGQ0NTUwZjIuLjAwZjc4ZDY0YmQ4IDEwMDY0NA0KPj4gLS0tIGEvdGFyZ2V0
L2FybS9jcHUuaA0KPj4gKysrIGIvdGFyZ2V0L2FybS9jcHUuaA0KPj4gQEAgLTE2OSwxMSAr
MTY5LDcgQEAgdHlwZWRlZiBzdHJ1Y3QgQVJNR2VuZXJpY1RpbWVyIHsNCj4+ICAgICAqIEFs
aWduIHRoZSBkYXRhIGZvciB1c2Ugd2l0aCBUQ0cgaG9zdCB2ZWN0b3Igb3BlcmF0aW9ucy4N
Cj4+ICAgICAqLw0KPj4gICAgDQo+PiAtI2lmZGVmIFRBUkdFVF9BQVJDSDY0DQo+PiAtIyBk
ZWZpbmUgQVJNX01BWF9WUSAgICAxNg0KPj4gLSNlbHNlDQo+PiAtIyBkZWZpbmUgQVJNX01B
WF9WUSAgICAxDQo+PiAtI2VuZGlmDQo+PiArI2RlZmluZSBBUk1fTUFYX1ZRICAgIDE2DQo+
PiAgICANCj4+ICAgIHR5cGVkZWYgc3RydWN0IEFSTVZlY3RvclJlZyB7DQo+PiAgICAgICAg
dWludDY0X3QgZFsyICogQVJNX01BWF9WUV0gUUVNVV9BTElHTkVEKDE2KTsNCj4gDQoNCg==


