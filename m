Return-Path: <kvm+bounces-41735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 826B3A6C6A5
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 01:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C9CD7A6FEA
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 00:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460E34A3C;
	Sat, 22 Mar 2025 00:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qqiQnGDx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB091FC3
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 00:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742602816; cv=none; b=uOHR9nRFLiN8k6cmr8AltTeMw2NAi5fM+Q3P400jJaT47M0ftitHI/0W+MhrFEGigqBbX6CYQ9T3pm50cHnydJF6dqVgk60ifaycC7rh160YgU0C5BlkXQj1aEp9DFHuB7ZIzYCVr5xVmzqGl+gTr89qyL96gkqsXIs31dgNZDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742602816; c=relaxed/simple;
	bh=gmihTeepoM01G32VwMRKIpoRxTtCyWjhxO8/HlXx56w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=teNcNXhFPq3QrSppszTSl+C2hQSaNa3mp8gRiuczJjoBWZWSSOHRcKvf0FELyYwHhcouHg0Lbz5AN7bhn8mAvenaHzzeGou9msF3pG3xbbZ+/2wYcTCxW2s/VjWUzVyBXsDJFHVQ4L61SMk9EjZH0P9Fx8aKZKkdJ1JxPgKYApo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qqiQnGDx; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2279915e06eso2490145ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 17:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742602814; x=1743207614; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gmihTeepoM01G32VwMRKIpoRxTtCyWjhxO8/HlXx56w=;
        b=qqiQnGDx0VWooNe16zQCO5Sb3CZZ5+06+b2B1rEAQ1ITdHQAumheMBVRVm0MLf8KZM
         b8kyg7duEe5UK+gPMWrEDam3GUEl8wb6YlUy7u+1Feb/f65gj1qwYh72SZw98pllB9PM
         s8x4/YbVhlc+Ic4svWUO82MCeR2+Ly3nE6gP0FOpixJvdLXZbRdZPl0obE+T3ldqfr8b
         ejvEq6ZS8j1Z1CrN5Ej/U2jLdKJY0ln06+EcEkArQNMyk1V3INvbDc+mhxQSvLOiuCYu
         HvCLYwxJpOFGWdU4L347GKxpm1zo4qIPM+sY1mo/XEm7ZRyUae9h+gqnsfUKfeBlLcbe
         C/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742602814; x=1743207614;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmihTeepoM01G32VwMRKIpoRxTtCyWjhxO8/HlXx56w=;
        b=PNEHWnKD0uZffo4sY6mWein1cyZtgx8j8iSoj46q6liN8gLanNOu4qLMdirNIa3/6H
         g91GxS86I/+a5Kd0otOz9G3l6ZsMc9c9cBZ2aKNfIlggffnUbbuuUbF8QXZla955d20N
         3oO8DF3PclLjjQ2bwz8n0V7MyBp+FQf/v4NQU4X9JqIazXCqxYRwFgt5hm24bz7sjJmx
         fUpF5Nit0xDVdtcV2TcEBJ0bgHHiUPC/5mJkLjaWvu7CAHrKExTe9Y2EChqgNzcAiU0p
         cMZfvVKe+hIGByPPVW+g3/kkZameFGezQXrZs417LdCm5NMVdcudgtfQyN+JYfPHdvmD
         WRzw==
X-Gm-Message-State: AOJu0YyyobzyTY/8E9S0LigfxO/vJrtME4IVN0AUGOAG1PZZIcodLZMr
	fGsjxxlFXttY/hR93m6QqtewND/oZvg5Y0G2Mi0QuwbGzMnfhPgjF45NhUZkTh8=
X-Gm-Gg: ASbGncst1l4Y5vvbFGlYPpCpSy53ybFiKMFYbU2jAkvuNTNrHeHS7lxN43MhYOeiD/x
	MvFzPfxoVVie3QJ9jrLmaD0UeANszM5f9VjREBPiOw+YKztemrxb09eZDJOg1So5oC5Fu4qkXjj
	scHTvK+iT3cskOFMjrrOwDxkv8YZdFFCQICbCbjANgclTO/79zRTvVYtq9LI7HUiGGdh04PIR19
	cabEa6N5IbJPs9z3R6wO60bkDcEnLyUAG2WYOMObsM0RGRLXvIEZuGKcm1MBo+O1InRaPws7wHd
	Twhzh2mrvYZy+h3BWJXkUrZ6E7efmBFIHdSAftlUGpef0zux/fmcAj1gFCZEfZsJa7uA
X-Google-Smtp-Source: AGHT+IEiwshH0mEB0ml11+5ohr1OVAQK1GvcSU9JeTsnEj9XYL0ycGei7ChHq5z6xhuvXYlP6cdGKQ==
X-Received: by 2002:a17:903:18c:b0:220:d909:1734 with SMTP id d9443c01a7336-22780c7a955mr74702015ad.14.1742602814010;
        Fri, 21 Mar 2025 17:20:14 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf576aa7sm6892181a91.4.2025.03.21.17.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 17:20:13 -0700 (PDT)
Message-ID: <c1b7b73e-0a59-46cf-bf33-5712df5d9b75@linaro.org>
Date: Fri, 21 Mar 2025 17:20:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/30] exec/target_page: runtime defintion for
 TARGET_PAGE_BITS_MIN
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-18-pierrick.bouvier@linaro.org>
 <2e667bb0-7357-4caf-ab60-4e57aabdceeb@linaro.org>
 <e738b8b8-e06f-48d0-845e-f263adb3dee5@linaro.org>
 <a67d17bb-e0dc-4767-8a43-8f057db70c71@linaro.org>
 <216a39c6-384d-4f9e-b615-05af18c6ef59@linaro.org>
 <c0e338f5-6592-4d83-9f17-120b9c4f039e@linaro.org>
 <ebd25730-1947-4360-af36-cf1131f4155c@linaro.org>
Content-Language: en-US
In-Reply-To: <ebd25730-1947-4360-af36-cf1131f4155c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8yMS8yNSAxNzowMSwgUGllcnJpY2sgQm91dmllciB3cm90ZToNCj4gT24gMy8yMS8y
NSAxNToxOSwgUmljaGFyZCBIZW5kZXJzb24gd3JvdGU6DQo+PiBPbiAzLzIxLzI1IDEzOjEx
LCBQaWVycmljayBCb3V2aWVyIHdyb3RlOg0KPj4+IE9uIDMvMjEvMjUgMTI6MjcsIFJpY2hh
cmQgSGVuZGVyc29uIHdyb3RlOg0KPj4+PiBPbiAzLzIxLzI1IDExOjA5LCBQaWVycmljayBC
b3V2aWVyIHdyb3RlOg0KPj4+Pj4+IE1tbSwgb2sgSSBndWVzcy7CoCBZZXN0ZXJkYXkgSSB3
b3VsZCBoYXZlIHN1Z2dlc3RlZCBtZXJnaW5nIHRoaXMgd2l0aCBwYWdlLXZhcnkuaCwgYnV0
DQo+Pj4+Pj4gdG9kYXkgSSdtIGFjdGl2ZWx5IHdvcmtpbmcgb24gbWFraW5nIFRBUkdFVF9Q
QUdFX0JJVFNfTUlOIGEgZ2xvYmFsIGNvbnN0YW50Lg0KPj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4g
V2hlbiB5b3UgbWVudGlvbiB0aGlzLCBkbyB5b3UgbWVhbiAiY29uc3RhbnQgYWNjcm9zcyBh
bGwgYXJjaGl0ZWN0dXJlcyIsIG9yIGEgZ2xvYmFsDQo+Pj4+PiAoY29uc3QpIHZhcmlhYmxl
IHZzIGhhdmluZyBhIGZ1bmN0aW9uIGNhbGw/DQo+Pj4+IFRoZSBmaXJzdCAtLSBjb25zdGFu
dCBhY3Jvc3MgYWxsIGFyY2hpdGVjdHVyZXMuDQo+Pj4+DQo+Pj4NCj4+PiBUaGF0J3MgZ3Jl
YXQuDQo+Pj4gRG9lcyBjaG9vc2luZyB0aGUgbWluKHNldF9vZihUQVJHRVRfUEFHRV9CSVRT
X01JTikpIGlzIHdoYXQgd2Ugd2FudCB0aGVyZSwgb3IgaXMgdGhlDQo+Pj4gYW5zd2VyIG1v
cmUgc3VidGxlIHRoYW4gdGhhdD8NCj4+DQo+PiBJdCB3aWxsIGJlLCB5ZXMuDQo+Pg0KPj4g
VGhpcyBpc24ndCBhcyBoYXJkIGFzIGl0IHNlZW1zLCBiZWNhdXNlIHRoZXJlIGFyZSBleGFj
dGx5IHR3byB0YXJnZXRzIHdpdGgNCj4+IFRBUkdFVF9QQUdFX0JJVFMgPCAxMjogYXJtIGFu
ZCBhdnIuDQo+Pg0KPj4gQmVjYXVzZSB3ZSBzdGlsbCBzdXBwb3J0IGFybXY0LCBUQVJHRVRf
UEFHRV9CSVRTX01JTiBtdXN0IGJlIDw9IDEwLg0KPj4NCj4+IEFWUiBjdXJyZW50bHkgaGFz
IFRBUkdFVF9QQUdFX0JJVFMgPT0gOCwgd2hpY2ggaXMgYSBiaXQgb2YgYSBwcm9ibGVtLg0K
Pj4gTXkgZmlyc3QgdGFzayBpcyB0byBhbGxvdyBhdnIgdG8gY2hvb3NlIFRBUkdFVF9QQUdF
X0JJVFNfTUlOID49IDEwLg0KPj4NCj4+IFdoaWNoIHdpbGwgbGVhdmUgdXMgd2l0aCBUQVJH
RVRfUEFHRV9CSVRTX01JTiA9PSAxMC4NCj4+DQo+IA0KPiBPay4NCj4gDQo+ICAgRnJvbSB3
aGF0IEkgdW5kZXJzdGFuZCwgd2UgbWFrZSBzdXJlIHRsYiBmbGFncyBhcmUgc3RvcmVkIGlu
IGFuDQo+IGltbXV0YWJsZSBwb3NpdGlvbiwgd2l0aGluIHZpcnR1YWwgYWRkcmVzc2VzIHJl
bGF0ZWQgdG8gZ3Vlc3QsIGJ5IHVzaW5nDQo+IGxvd2VyIGJpdHMgYmVsb25naW5nIHRvIGFk
ZHJlc3MgcmFuZ2UgaW5zaWRlIGEgZ2l2ZW4gcGFnZSwgc2luY2UgcGFnZQ0KPiBhZGRyZXNz
ZXMgYXJlIGFsaWduZWQgb24gcGFnZSBzaXplLCBsZWF2aW5nIHRob3NlIGJpdHMgZnJlZS4N
Cj4gDQo+IGJpdHMgWzAuLjIpIGFyZSBic3dhcCwgd2F0Y2hwb2ludCBhbmQgY2hlY2tfYWxp
Z25lZC4NCj4gYml0cyBbVEFSR0VUX1BBR0VfQklUU19NSU4gLSA1Li5UQVJHRVRfUEFHRV9C
SVRTX01JTikgYXJlIHNsb3csDQo+IGRpc2NhcmRfd3JpdGUsIG1taW8sIG5vdGRpcnR5LCBh
bmQgaW52YWxpZCBtYXNrLg0KPiBBbmQgdGhlIGNvbXBpbGUgdGltZSBjaGVjayB3ZSBoYXZl
IGlzIHRvIG1ha2Ugc3VyZSB3ZSBkb24ndCBvdmVybGFwDQo+IHRob3NlIHNldHMgKHdvdWxk
IGhhcHBlbiBpbiBUQVJHRVRfUEFHRV9CSVRTX01JTiA8PSA3KS4NCj4gDQo+IEkgd29uZGVy
IHdoeSB3ZSBjYW4ndCB1c2UgYml0cyBbMy4uOCkgZXZlcnl3aGVyZSwgbGlrZSBpdCdzIGRv
bmUgZm9yDQo+IEFWUiwgZXZlbiBmb3IgYmlnZ2VyIHBhZ2Ugc2l6ZXMuIEkgbm90aWNlZCB0
aGUgY29tbWVudCBhYm91dCAiYWRkcmVzcw0KPiBhbGlnbm1lbnQgYml0cyIsIGJ1dCBJJ20g
Y29uZnVzZWQgd2h5IGJpdHMgWzAuLjIpIGNhbiBiZSB1c2VkLCBhbmQgbm90DQo+IHVwcGVy
IG9uZXMuDQo+IA0KPiBBcmUgd2Ugc3RvcmluZyBzb21ldGhpbmcgZWxzZSBpbiB0aGUgbWlk
ZGxlIG9uIG90aGVyIGFyY2hzLCBvciBkaWQgSQ0KPiBtaXNzIHNvbWUgcGllY2Ugb2YgdGhl
IHB1enpsZT8NCj4gDQoNCkFmdGVyIGxvb2tpbmcgYmV0dGVyLCBUTEJfU0xPV19GTEFHUyBh
cmUgbm90IHBhcnQgb2YgYWRkcmVzcywgc28gd2UgDQpkb24ndCB1c2UgYml0cyBbMC4uMiku
DQoNCkZvciBhIGdpdmVuIFRBUkdFVF9QQUdFX1NJWkUsIGhvdyBkbyB3ZSBkZWZpbmUgYWxp
Z25tZW50IGJpdHM/DQoNCj4gVGhhbmtzLA0KPiBQaWVycmljaw0KPiANCj4+DQo+PiByfg0K
PiANCg0K

