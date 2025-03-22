Return-Path: <kvm+bounces-41734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D555FA6C692
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 01:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46B9417CBAB
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 00:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0F315E90;
	Sat, 22 Mar 2025 00:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ax+kMI7V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B2BDDDC
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 00:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742601681; cv=none; b=fi5AiF8Xej6s0nq1pkWnQjABMan3EtofluvuKOZaNFOkiE+cmpah1z5z9qBrmUGopWLQmjGO0MV7ger9mtmn9AfGv8QFH4aY3OhVNKH2+5sSkkKb0ThK4A9mK5UXz8hdlzyFyE9d3bYQhk1bwj3Zy9jBimhYgwvJ+L9TvT0GurY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742601681; c=relaxed/simple;
	bh=8jIF53UuilIp95lERWLD96FBJysroCAg3PsA4TvpjMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KW/25iX9ne8qvqL4pin5wjy8xtbWTJyu7L80o0u573QbtTR+I7RTPR/zCl4O8LGqd0YxFTKXBXFZGwzfGeeYaItzjP6SbgKz23Y/guiJtUXEkGN/ZtKlqv9Soa9ypZmNY6O9IXkYyNfe72E+d3kEzpHHgEe1Dns0+wbmkrpghaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ax+kMI7V; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-225fbdfc17dso42089035ad.3
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 17:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742601678; x=1743206478; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8jIF53UuilIp95lERWLD96FBJysroCAg3PsA4TvpjMo=;
        b=ax+kMI7V4Ld/PE++Jq9CV4bIi/JEpBWe03k8wKiDzIF6V9cJcNvg6qI5Ou+lsdrnVW
         626oTYbLL1pSNiY4EhcxiKz6jMgYTAxCwKI8HuStFZ+rOKCnW+Nv5JWKFCkVL6Q94UxI
         xmXSfIjG5Hqw3lUZOap49Uyc0VkkL7zLkXBFwrr1wvMzYj2UBJN7QrZZor0upDKzwRhT
         iXq8G9mtJdlw8xYgcCVjCTTVq8cG5fNl5CgnG0aQqFTHhyYxKpe25Waq9obMEkYlhcoW
         nk75uDcQYsoxhPZOx50UmeebRTFzFaU7BnQ7D2wlsiHnibuQOD7GcjsYIRSeP4fG7Y+Z
         ZP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742601678; x=1743206478;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8jIF53UuilIp95lERWLD96FBJysroCAg3PsA4TvpjMo=;
        b=Moh1rtK5T7Y1+uBktstU6cPP9FxG3Nnsk2sheNOd8SG05EoTOhzP5rH6QVjTzr/Rri
         wlaa/zX4FBJe0l9c8q3ZM91BMbUBK0b1uDC57MQJOnskAd1BDyzE9Z/2vYnTVYapSK4O
         tZDvyObsXSSf9UPPuMeGelJvy2rJxKREe4cFov2M//gndrvr9G/Ognx+TwBJ9MRumW8B
         MYTpIc7RQoTy8VceG1LsVzRtD/lNfiBA7SrA+O7qsxUO8PBnHERoRI3RpXQ2/0rozczs
         4GyMjU6qZp7eNRhk1gx3cnA60wW/Mf5NdXO9WcQV/SlxGQHs/XIkK1YZj8iUFUYSst8j
         zwsw==
X-Gm-Message-State: AOJu0YzNCl4HoV7I7iOpP67IUklvZpf1cpVVo85nyrt8Q5z0iEwemYCK
	KWwW1aLennae23+X5BPxNY0AA+dQFDoJCRSGOQUG5AQhDDyqwz2pEQy5seo4WkU=
X-Gm-Gg: ASbGncuKIfnb+62SqhTi/9Aw828f+S2661qNmwWyVbTOwUxQiCxFM30iTI6Ecn7m4aE
	aTZckulQSKWXS7KQ8Lhmu9bryvlnrHzDTJ26d1z+HloU/F9nM4TW0TebtZXpuE9nvhrxuwn0eJf
	u1UwiWV5mzAoNfVrgd+bGifwlFLsUU5+ZAlQecCtvTWdlNQqzR8uwdkpRgkz3sBrNScOtCTEqX8
	BWtLAXv+thXmpVqCsUzevx1cPaM556n0S9yK1qvLibtNTT6D5Qxl70xnkcKhAtUjFNXgCB2z42s
	HjCFkFAbpFl37iQgt7yCpr9+FnShUquDr7zkoUjUU1svigl8aN+nxdhgbw==
X-Google-Smtp-Source: AGHT+IFycojw9Uun5vxQflyFUKmw9FGit8EBg4TDZCtmc6CLRIFEIQnJbgKlCoaW1zxWlIPsnn0Hhg==
X-Received: by 2002:aa7:88c7:0:b0:736:5725:59b9 with SMTP id d2e1a72fcca58-7390593d43fmr7967391b3a.2.1742601677692;
        Fri, 21 Mar 2025 17:01:17 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390618f080sm2780961b3a.176.2025.03.21.17.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 17:01:17 -0700 (PDT)
Message-ID: <ebd25730-1947-4360-af36-cf1131f4155c@linaro.org>
Date: Fri, 21 Mar 2025 17:01:16 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/30] exec/target_page: runtime defintion for
 TARGET_PAGE_BITS_MIN
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
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <c0e338f5-6592-4d83-9f17-120b9c4f039e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8yMS8yNSAxNToxOSwgUmljaGFyZCBIZW5kZXJzb24gd3JvdGU6DQo+IE9uIDMvMjEv
MjUgMTM6MTEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBPbiAzLzIxLzI1IDEyOjI3
LCBSaWNoYXJkIEhlbmRlcnNvbiB3cm90ZToNCj4+PiBPbiAzLzIxLzI1IDExOjA5LCBQaWVy
cmljayBCb3V2aWVyIHdyb3RlOg0KPj4+Pj4gTW1tLCBvayBJIGd1ZXNzLsKgIFllc3RlcmRh
eSBJIHdvdWxkIGhhdmUgc3VnZ2VzdGVkIG1lcmdpbmcgdGhpcyB3aXRoIHBhZ2UtdmFyeS5o
LCBidXQNCj4+Pj4+IHRvZGF5IEknbSBhY3RpdmVseSB3b3JraW5nIG9uIG1ha2luZyBUQVJH
RVRfUEFHRV9CSVRTX01JTiBhIGdsb2JhbCBjb25zdGFudC4NCj4+Pj4+DQo+Pj4+DQo+Pj4+
IFdoZW4geW91IG1lbnRpb24gdGhpcywgZG8geW91IG1lYW4gImNvbnN0YW50IGFjY3Jvc3Mg
YWxsIGFyY2hpdGVjdHVyZXMiLCBvciBhIGdsb2JhbA0KPj4+PiAoY29uc3QpIHZhcmlhYmxl
IHZzIGhhdmluZyBhIGZ1bmN0aW9uIGNhbGw/DQo+Pj4gVGhlIGZpcnN0IC0tIGNvbnN0YW50
IGFjcm9zcyBhbGwgYXJjaGl0ZWN0dXJlcy4NCj4+Pg0KPj4NCj4+IFRoYXQncyBncmVhdC4N
Cj4+IERvZXMgY2hvb3NpbmcgdGhlIG1pbihzZXRfb2YoVEFSR0VUX1BBR0VfQklUU19NSU4p
KSBpcyB3aGF0IHdlIHdhbnQgdGhlcmUsIG9yIGlzIHRoZQ0KPj4gYW5zd2VyIG1vcmUgc3Vi
dGxlIHRoYW4gdGhhdD8NCj4gDQo+IEl0IHdpbGwgYmUsIHllcy4NCj4gDQo+IFRoaXMgaXNu
J3QgYXMgaGFyZCBhcyBpdCBzZWVtcywgYmVjYXVzZSB0aGVyZSBhcmUgZXhhY3RseSB0d28g
dGFyZ2V0cyB3aXRoDQo+IFRBUkdFVF9QQUdFX0JJVFMgPCAxMjogYXJtIGFuZCBhdnIuDQo+
IA0KPiBCZWNhdXNlIHdlIHN0aWxsIHN1cHBvcnQgYXJtdjQsIFRBUkdFVF9QQUdFX0JJVFNf
TUlOIG11c3QgYmUgPD0gMTAuDQo+IA0KPiBBVlIgY3VycmVudGx5IGhhcyBUQVJHRVRfUEFH
RV9CSVRTID09IDgsIHdoaWNoIGlzIGEgYml0IG9mIGEgcHJvYmxlbS4NCj4gTXkgZmlyc3Qg
dGFzayBpcyB0byBhbGxvdyBhdnIgdG8gY2hvb3NlIFRBUkdFVF9QQUdFX0JJVFNfTUlOID49
IDEwLg0KPiANCj4gV2hpY2ggd2lsbCBsZWF2ZSB1cyB3aXRoIFRBUkdFVF9QQUdFX0JJVFNf
TUlOID09IDEwLg0KPiANCg0KT2suDQoNCiBGcm9tIHdoYXQgSSB1bmRlcnN0YW5kLCB3ZSBt
YWtlIHN1cmUgdGxiIGZsYWdzIGFyZSBzdG9yZWQgaW4gYW4gDQppbW11dGFibGUgcG9zaXRp
b24sIHdpdGhpbiB2aXJ0dWFsIGFkZHJlc3NlcyByZWxhdGVkIHRvIGd1ZXN0LCBieSB1c2lu
ZyANCmxvd2VyIGJpdHMgYmVsb25naW5nIHRvIGFkZHJlc3MgcmFuZ2UgaW5zaWRlIGEgZ2l2
ZW4gcGFnZSwgc2luY2UgcGFnZSANCmFkZHJlc3NlcyBhcmUgYWxpZ25lZCBvbiBwYWdlIHNp
emUsIGxlYXZpbmcgdGhvc2UgYml0cyBmcmVlLg0KDQpiaXRzIFswLi4yKSBhcmUgYnN3YXAs
IHdhdGNocG9pbnQgYW5kIGNoZWNrX2FsaWduZWQuDQpiaXRzIFtUQVJHRVRfUEFHRV9CSVRT
X01JTiAtIDUuLlRBUkdFVF9QQUdFX0JJVFNfTUlOKSBhcmUgc2xvdywgDQpkaXNjYXJkX3dy
aXRlLCBtbWlvLCBub3RkaXJ0eSwgYW5kIGludmFsaWQgbWFzay4NCkFuZCB0aGUgY29tcGls
ZSB0aW1lIGNoZWNrIHdlIGhhdmUgaXMgdG8gbWFrZSBzdXJlIHdlIGRvbid0IG92ZXJsYXAg
DQp0aG9zZSBzZXRzICh3b3VsZCBoYXBwZW4gaW4gVEFSR0VUX1BBR0VfQklUU19NSU4gPD0g
NykuDQoNCkkgd29uZGVyIHdoeSB3ZSBjYW4ndCB1c2UgYml0cyBbMy4uOCkgZXZlcnl3aGVy
ZSwgbGlrZSBpdCdzIGRvbmUgZm9yIA0KQVZSLCBldmVuIGZvciBiaWdnZXIgcGFnZSBzaXpl
cy4gSSBub3RpY2VkIHRoZSBjb21tZW50IGFib3V0ICJhZGRyZXNzIA0KYWxpZ25tZW50IGJp
dHMiLCBidXQgSSdtIGNvbmZ1c2VkIHdoeSBiaXRzIFswLi4yKSBjYW4gYmUgdXNlZCwgYW5k
IG5vdCANCnVwcGVyIG9uZXMuDQoNCkFyZSB3ZSBzdG9yaW5nIHNvbWV0aGluZyBlbHNlIGlu
IHRoZSBtaWRkbGUgb24gb3RoZXIgYXJjaHMsIG9yIGRpZCBJIA0KbWlzcyBzb21lIHBpZWNl
IG9mIHRoZSBwdXp6bGU/DQoNClRoYW5rcywNClBpZXJyaWNrDQoNCj4gDQo+IHJ+DQoNCg==


