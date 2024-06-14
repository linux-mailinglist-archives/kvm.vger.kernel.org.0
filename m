Return-Path: <kvm+bounces-19704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 664119091E2
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 19:39:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA7C828DD89
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 17:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897D419AD48;
	Fri, 14 Jun 2024 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mEu/44Fy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F8519ADA6
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718386606; cv=none; b=Kl3VT7qZUq5lmVxOIHVJpALfyqR1FcmoN7rXZQuYCtHjlL1gzH4E8Tb4u6GakGSuTp/RMGmXoyd1T/TNLUJa6hvwkm42d+WbAd8CoXr+wU26yopaLHHTUrQ0maMqn3BIV0vswp0B78szFkhAXe/NIOAhgyBBoIAkYtqbGW7D38c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718386606; c=relaxed/simple;
	bh=1LimRJM9cxSX2f5sFmiGnpuaZ10TrsMotLuL6FGbbKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AlWiUUn5mmWZli3YSVj2DaxBV+LdQXtdY3LjU8DLjQEtdKFQNyAS3Lia4xc3+yLyXpn4Beiwjk6Uquvsh4UMa1mZ7Pv0pSfHvUC5ipaUluTRAIADRo8duiW+ayNTtvGaT5wrZJCMf4EhMDW2CX5lUJbcSwZ36gmNtuD++I715c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mEu/44Fy; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3d22802674cso1270855b6e.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 10:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718386604; x=1718991404; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1LimRJM9cxSX2f5sFmiGnpuaZ10TrsMotLuL6FGbbKo=;
        b=mEu/44FyJQ2TSfOBpBKpi5MBZpgGjsNt/l3B8OM0+e0Ozpk1ha19n5kFCICgyRgBMf
         IoLXXdXr5qULP0MMLGzD5Svu6F3pSmI/wLdG2RFe9PkuQ4uWoNqi306yx/tzO0KvdzhA
         yhE7Fj9B15euM/3kRIOR5Ygitn1ouGwYBGV7DqBtztr4vouW/JJRKFyJ9BakE+gTQo1f
         OF5afibBlJhVRQ7oHEzzyiP5JSRU3dcDy47A748JEyHSLmaChbAGRxa1a7dUb0Qd7eqm
         qbQuaRHwKE7Jc2D8wmzpqXyRK7zck1IZ0RamlAF1oY6JLGbboCnUFpqzNj75KL7dnGye
         FreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718386604; x=1718991404;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1LimRJM9cxSX2f5sFmiGnpuaZ10TrsMotLuL6FGbbKo=;
        b=ZbzszlJAoCvdWIrRYa9+yUiNPewAL32j+jVS70nyftFDLde3tE7HFLWcaT4Ew/HQan
         vHirPEcMNOXy7WA2/9UVW65bOl0tGPBS6LGSZmDbfbuS6iVI1NeioS6r5FYR+/NEAowp
         61j/z8Q6AemuaKQhyl5X2oBgODImoMIKEq7OoJp2UJ3oSto9KR3A8SS/26n4cN7lYcO/
         XPOIf+G6PQz3eNYhGShxoQe7bnDuW7hQ4A+Jvc3JaroHt6ddk4MbSI1ietbiESbDrKQe
         BObKRbvVYYI9go9MkmiS/pZI98haIN8lW/3GFpSRa6k5k04tGc+XT8h47Zm5/2J7pylF
         sSzw==
X-Forwarded-Encrypted: i=1; AJvYcCXnchfo58brZjMyeiC3RhulCmwGvUixCHSBBdYM4eOxv6gMh7LV+Qi7A2vcJXJxq5LY0uGry9INXrGB6zXR1AR1HSQ/
X-Gm-Message-State: AOJu0YwkALaNG2F/yBd/onffDHOlPG+OZFlrYGTRBU/Y5UNWMA2hUSoC
	uVDXOi5BTW0ZFz5qvntR7G59udkPPXN+xbrRLwFj1s97Q1VVodnBRL+T3QfqquY=
X-Google-Smtp-Source: AGHT+IFqp54QBTCWDMIIVSm8l3m8LBnykdkXpasQW4hnt2Hq/DpO3ONARm3we9JumapgK+vz7R3LgQ==
X-Received: by 2002:a05:6870:4194:b0:254:b1b1:7ea5 with SMTP id 586e51a60fabf-25842af7079mr4304081fac.37.1718386604036;
        Fri, 14 Jun 2024 10:36:44 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00:5b09:8db7:b002:cf61? ([2604:3d08:9384:1d00:5b09:8db7:b002:cf61])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc91ed6asm3308225b3a.39.2024.06.14.10.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 10:36:43 -0700 (PDT)
Message-ID: <2812da25-495c-4356-a230-257ea96e6dcc@linaro.org>
Date: Fri, 14 Jun 2024 10:36:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] plugins: add time control API
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, David Hildenbrand <david@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Mark Burton <mburton@qti.qualcomm.com>, qemu-s390x@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Laurent Vivier <lvivier@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Alexandre Iooss <erdnaxe@crans.org>, qemu-arm@nongnu.org,
 Alexander Graf <agraf@csgraf.de>, Nicholas Piggin <npiggin@gmail.com>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, qemu-ppc@nongnu.org,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Cameron Esfahani <dirty@apple.com>,
 Jamie Iles <quic_jiles@quicinc.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-9-alex.bennee@linaro.org>
 <c4d36875-c70d-4e2c-b3a8-c50459c9db0f@linaro.org>
 <87r0d0vnt8.fsf@draig.linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <87r0d0vnt8.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xMy8yNCAwODo1NiwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBQaGlsaXBwZSBNYXRo
aWV1LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+IHdyaXRlczoNCj4gDQo+PiBPbiAxMi82
LzI0IDE3OjM1LCBBbGV4IEJlbm7DqWUgd3JvdGU6DQo+Pj4gRXhwb3NlIHRoZSBhYmlsaXR5
IHRvIGNvbnRyb2wgdGltZSB0aHJvdWdoIHRoZSBwbHVnaW4gQVBJLiBPbmx5IG9uZQ0KPj4+
IHBsdWdpbiBjYW4gY29udHJvbCB0aW1lIHNvIGl0IGhhcyB0byByZXF1ZXN0IGNvbnRyb2wg
d2hlbiBsb2FkZWQuDQo+Pj4gVGhlcmUgYXJlIHByb2JhYmx5IG1vcmUgY29ybmVyIGNhc2Vz
IHRvIGNhdGNoIGhlcmUuDQo+Pj4gRnJvbTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBs
aW5hcm8ub3JnPg0KPj4NCj4+IFNvbWUgb2YgeW91ciBwYXRjaGVzIGluY2x1ZGUgdGhpcyBk
dWJpb3VzIEZyb206IGhlYWRlciwgbWF5YmUgc3RyaXA/DQo+IA0KPiBJIHRoaW5rIGJlY2F1
c2UgbXkgb3JpZ2luYWwgUkZDIHBhdGNoZXMgd2VudCB2aWEgUGllcnJpY2sgYmVmb3JlIHB1
bGxpbmcNCj4gYmFjayBpbnRvIG15IHRyZWUuIEkgY2FuIGNsZWFuIHRob3NlIHVwLg0KPiAN
Cg0KVG8gYmUgaG9uZXN0LCBJIGRvbid0IHJlbWVtYmVyIHdoeSBJIGFkZGVkIHRob3NlLiBF
aXRoZXIgSSBzYXcgdGhhdCBpbiANCmFub3RoZXIgc2VyaWVzLCBvciBpdCB3YXMgYXNrZWQg
ZXhwbGljaXRlbHksIGJ1dCB5b3UgY2FuIHJlbW92ZSB0aGlzIGZvciANCnN1cmUuDQoNCj4+
DQo+Pj4gU2lnbmVkLW9mZi1ieTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmll
ckBsaW5hcm8ub3JnPg0KPj4+IFtBSkI6IHR3ZWFrZWQgdXNlci1tb2RlIGhhbmRsaW5nXQ0K
Pj4+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9y
Zz4NCj4+PiBNZXNzYWdlLUlkOiA8MjAyNDA1MzAyMjA2MTAuMTI0NTQyNC02LXBpZXJyaWNr
LmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+PiAtLS0NCj4+PiBwbHVnaW5zL25leHQNCj4+PiAg
ICAgLSBtYWtlIHFlbXVfcGx1Z2luX3VwZGF0ZV9ucyBhIE5PUCBpbiB1c2VyLW1vZGUNCj4+
PiAtLS0NCj4+PiAgICBpbmNsdWRlL3FlbXUvcWVtdS1wbHVnaW4uaCAgIHwgMjUgKysrKysr
KysrKysrKysrKysrKysrKysrKw0KPj4+ICAgIHBsdWdpbnMvYXBpLmMgICAgICAgICAgICAg
ICAgfCAzNSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4+ICAgIHBs
dWdpbnMvcWVtdS1wbHVnaW5zLnN5bWJvbHMgfCAgMiArKw0KPj4+ICAgIDMgZmlsZXMgY2hh
bmdlZCwgNjIgaW5zZXJ0aW9ucygrKQ0KPiANCg==

