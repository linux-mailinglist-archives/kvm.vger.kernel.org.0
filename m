Return-Path: <kvm+bounces-42480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65303A79217
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 17:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18ED77A1E7A
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E79D23BCEE;
	Wed,  2 Apr 2025 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v6yFnE5J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8B820E70F
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743607512; cv=none; b=JZPoZHMtysVvziw9z6sqlTdf1MCSYDfbbNNZId7qVuegOSZnppLn6a/pnm4iz06PCAdLa/B2Ukdg0pqoT/8Bg6XTKdvfA8VZPRnHpBmSwIaBm/ylny8cXCgc8rsyrJ7dZevW0bWwnlSCl5k+0s0pQlvG7kGd2lthEjfK4j7Ki4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743607512; c=relaxed/simple;
	bh=Cx8+TpYzNRgjiV6IWF30R39Lr38y3gIFRuMPt3h82Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0cm7uzv/qWinqU7qKIuWlK37MozLKgbGqMfX7Icke5exxD1CQqiQ0ZBmXFtReWqfLgLeJ/f3GXuaWk56ve2DmPc+s7XliaJ5g2bfrCS6wrHgD6LAFIAhnJWPHcpXvuapn1gDWDDgrwzwhKVWpIt3gqM6pppkVdtgyT5ZgrAukg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v6yFnE5J; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7370a2d1981so310971b3a.2
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 08:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743607510; x=1744212310; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cx8+TpYzNRgjiV6IWF30R39Lr38y3gIFRuMPt3h82Vs=;
        b=v6yFnE5JVXEWAL/NY04KEwyQ9kxz/hGwXQoQXuz4jyfqtgWooCaPgEShqMTtb3prgC
         pD2o01ZEn8jFbGoOWrrpzD+tQ+5nzP6k2eGyf8eS0MOf5YNT/3laMrF938Izsja3Q188
         C28MpPrt3Rqh7RkJPyZLsImt6o0Sp7SpxXXiXesiO2MP/bBSmpedPguQNFmVUKaTg3oX
         WIyVKUXejCj6Y4yBH8cSB03zUmHI9u7ziLzvPkHnsfJesLDnll7RV/f5gSKRUkSAwDiQ
         2pK0VR5NQCy+SgnoQNxEGg2+lSuBhMSQK8/iXun5O7f0hE4MW/TVEy2YDTykQ+14qIjj
         3h/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743607510; x=1744212310;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cx8+TpYzNRgjiV6IWF30R39Lr38y3gIFRuMPt3h82Vs=;
        b=DoFg/rD8jQf+6neEopBn2FI9dze0BT2FCQjPR0PhSHR6ZDWoSzoNr7Y9xYpAdu4mnW
         gC1uXmKFKRsKH/WvXeQJSEFDhcGzeukdT+QJzgJFNl0KgWq8PTafVIzp6jP4JY0RONLw
         yQkOtcLvkkcBQXxkK5HejQnnl+NVQ80EEOg6uwkPQF979BIzeDMmJp4fezXoKDr9ibk2
         oghwR+NW/7l5Vhjhai/rA3WInqGNvXx5NXWQffQzv5DW9fuXXmhLzlXbjhitRLZf3kYj
         N90tMGH79DAo+jyWG0kIitaQ5Oy6Fse1xDykVYAa7+3sXhEiUyNU5GuD56UDrkecEp1w
         J6Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWOptZ4nfe/BHQSR2RE5bP3Y/XPZ8RrYUzNi9JFfh821TeqQgrKgKO23pMcyNWnGOVG34A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdgB2KY501AVAYYZk4/rLsCcxlK34PSwoGaiNK3Mh5TOurLe4v
	/x9jhHjPgqOoWD4JN8Qyw3w2svMy8bSEDAXweuhPWKvZwYuuItQU2w67cQxiEJ0=
X-Gm-Gg: ASbGnctCNnSuc1RVqdxaFSPzh+zhCsmXAZw6RKqR59pnl8dYk9agZT2BYcks6pq72I9
	7sJ/RvqVt3QdjjZNi2DST/ahXTaDgT6ydukZllyxA7VFoaDrr5unhM0Ta7XuCrvhzx0zqN6V5QO
	7zFckpnoGx+KwY1QemTsNfzhdjVfDtKPnOQ4rDLcWCz5arrNt/iKWLJ/tb0+wUh2fNZ8HpjUlJ1
	R5OrjwuI7KPXu+gHCJUBBEqH0yGGSL2bK/4rSAjyklK6Cbghc5nsz9bWjmaxD9Xex1E8DHx2lAR
	obIzGe60kDLn9j+BuOxAC59smOn0nHFX2yzrNds+ddg+E5JWJervrFMytg==
X-Google-Smtp-Source: AGHT+IHKMqp53wunIMnK9HnaQVXKKO/uyWdrxdLYqEqNY5EMIwtYdBJ37QQg4k9gyF9l6HILW7KIkg==
X-Received: by 2002:a05:6a21:150e:b0:1f5:83da:2f9f with SMTP id adf61e73a8af0-2009f609015mr27159264637.12.1743607510247;
        Wed, 02 Apr 2025 08:25:10 -0700 (PDT)
Received: from [192.168.1.87] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af93b8b1aa6sm10090857a12.52.2025.04.02.08.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Apr 2025 08:25:09 -0700 (PDT)
Message-ID: <319fd6a2-93c1-42ec-866b-86e4d01b4b39@linaro.org>
Date: Wed, 2 Apr 2025 08:25:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/29] include/exec/cpu-all: move compile time check
 for CPUArchState to cpu-target.c
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
 <20250325045915.994760-4-pierrick.bouvier@linaro.org>
 <e11f5f2e-0838-4f28-88c1-a7241504d28a@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <e11f5f2e-0838-4f28-88c1-a7241504d28a@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8xLzI1IDIwOjMxLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gT24g
MjUvMy8yNSAwNTo1OCwgUGllcnJpY2sgQm91dmllciB3cm90ZToNCj4+IFJldmlld2VkLWJ5
OiBSaWNoYXJkIEhlbmRlcnNvbiA8cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZz4NCj4+
IFNpZ25lZC1vZmYtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGlu
YXJvLm9yZz4NCj4+IC0tLQ0KPj4gICAgaW5jbHVkZS9leGVjL2NwdS1hbGwuaCB8IDQgLS0t
LQ0KPj4gICAgY3B1LXRhcmdldC5jICAgICAgICAgICB8IDQgKysrKw0KPj4gICAgMiBmaWxl
cyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvZXhlYy9jcHUtYWxsLmggYi9pbmNsdWRlL2V4ZWMvY3B1LWFs
bC5oDQo+PiBpbmRleCA3NDAxN2E1Y2U3Yy4uYjEwNjcyNTllNmIgMTAwNjQ0DQo+PiAtLS0g
YS9pbmNsdWRlL2V4ZWMvY3B1LWFsbC5oDQo+PiArKysgYi9pbmNsdWRlL2V4ZWMvY3B1LWFs
bC5oDQo+PiBAQCAtMzQsOCArMzQsNCBAQA0KPj4gICAgDQo+PiAgICAjaW5jbHVkZSAiY3B1
LmgiDQo+IA0KPiBUaGlzIGluY2x1ZGUgXl5eXl5eIC4uLg0KPiANCj4+ICAgIA0KPj4gLS8q
IFZhbGlkYXRlIGNvcnJlY3QgcGxhY2VtZW50IG9mIENQVUFyY2hTdGF0ZS4gKi8NCj4+IC1R
RU1VX0JVSUxEX0JVR19PTihvZmZzZXRvZihBcmNoQ1BVLCBwYXJlbnRfb2JqKSAhPSAwKTsN
Cj4+IC1RRU1VX0JVSUxEX0JVR19PTihvZmZzZXRvZihBcmNoQ1BVLCBlbnYpICE9IHNpemVv
ZihDUFVTdGF0ZSkpOw0KPj4gLQ0KPj4gICAgI2VuZGlmIC8qIENQVV9BTExfSCAqLw0KPj4g
ZGlmZiAtLWdpdCBhL2NwdS10YXJnZXQuYyBiL2NwdS10YXJnZXQuYw0KPj4gaW5kZXggNTE5
YjBmODkwMDUuLjU4N2YyNGIzNGU1IDEwMDY0NA0KPj4gLS0tIGEvY3B1LXRhcmdldC5jDQo+
PiArKysgYi9jcHUtdGFyZ2V0LmMNCj4+IEBAIC0yOSw2ICsyOSwxMCBAQA0KPj4gICAgI2lu
Y2x1ZGUgImFjY2VsL2FjY2VsLWNwdS10YXJnZXQuaCINCj4+ICAgICNpbmNsdWRlICJ0cmFj
ZS90cmFjZS1yb290LmgiDQo+IA0KPiAuLi4gaXMgYWxzbyBuZWVkZWQgaGVyZSwgb3RoZXJ3
aXNlIHdlIGdldDoNCj4gDQo+IC4uLy4uL2NwdS10YXJnZXQuYzozMDoxOTogZXJyb3I6IG9m
ZnNldG9mIG9mIGluY29tcGxldGUgdHlwZSAnQXJjaENQVScNCj4gKGFrYSAnc3RydWN0IEFy
Y2hDUFUnKQ0KPiAgICAgIDMwIHwgUUVNVV9CVUlMRF9CVUdfT04ob2Zmc2V0b2YoQXJjaENQ
VSwgcGFyZW50X29iaikgIT0gMCk7DQo+ICAgICAgICAgfCAgICAgICAgICAgICAgICAgICBe
DQo+IA0KPj4gICAgDQo+ICAgPiArLyogVmFsaWRhdGUgY29ycmVjdCBwbGFjZW1lbnQgb2Yg
Q1BVQXJjaFN0YXRlLiAqLz4NCj4gK1FFTVVfQlVJTERfQlVHX09OKG9mZnNldG9mKEFyY2hD
UFUsIHBhcmVudF9vYmopICE9IDApOw0KPj4gK1FFTVVfQlVJTERfQlVHX09OKG9mZnNldG9m
KEFyY2hDUFUsIGVudikgIT0gc2l6ZW9mKENQVVN0YXRlKSk7DQo+PiArDQo+PiAgICBjaGFy
ICpjcHVfbW9kZWxfZnJvbV90eXBlKGNvbnN0IGNoYXIgKnR5cGVuYW1lKQ0KPj4gICAgew0K
Pj4gICAgICAgIGNvbnN0IGNoYXIgKnN1ZmZpeCA9ICItIiBDUFVfUkVTT0xWSU5HX1RZUEU7
DQo+IA0KPiBXaXRoICJjcHUuaCIgaW5jbHVkZToNCj4gUmV2aWV3ZWQtYnk6IFBoaWxpcHBl
IE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj4gVGVzdGVkLWJ5OiBQaGls
aXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+DQo+IA0KDQpJIGNhbid0
IHJlcHJvZHVjZSB0aGlzIGVycm9yLg0KV2l0aCB0aGlzIHNlcmllcywgY3B1LmggaXMgcHVs
bGVkIHRyYW5zaXRpdmVseSBmcm9tIA0KImFjY2VsL2FjY2VsLWNwdS10YXJnZXQuaCIuIElk
ZWFsbHksIGl0IHdvdWxkIGJlIGJldHRlciB0byBhZGQgaXQgDQpleHBsaWNpdGVseSB5ZXMu
DQoNCkBSaWNoYXJkLCBjb3VsZCB5b3UgcGxlYXNlIGFtZW5kIHRoaXMgY29tbWl0IG9uIHRj
Zy1uZXh0IGFuZCBhZGQgYSANCmRpcmVjdCBpbmNsdWRlIHRvIGNwdS5oPw0KDQpUaGFua3Ms
DQpQaWVycmljaw0K

