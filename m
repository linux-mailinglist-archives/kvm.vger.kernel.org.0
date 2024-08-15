Return-Path: <kvm+bounces-24326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F085E953989
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72AEA1F246D1
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CE847A4C;
	Thu, 15 Aug 2024 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o0OOn3CI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E4A4205D
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723744736; cv=none; b=ZzcV3tj1it+nRML+q+WWNhn1rhvug+rEu8EOl6FzH3rafbk7VASdfk6Ft/EYDNm7jYfVpTBrs9lyypfQ8zJEC9l0QrD+ZU4b05+/7Tg8N5IvCe/7wvm153Mh6fUmchaohcEEjJCa+CgdydRigD+eBHSjvRj92S6e7uWtm6uaYiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723744736; c=relaxed/simple;
	bh=soW/UxNTVhflNJS4erlXhZSbLv/T+YEiK5qqd9ov4Jw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fk8HSYJfOfnTPo9t2hOvpT8y/Ah8SS3hHGzvP/iw2W9HNKd9Ei4d5GFQU39qztRrNYezJdu532y/gfROaovmtoX9hFEGY0tWlGSFLfVnTnyJw5qmLOiMsxzQNUGcRQyWXusDEKRieor49q1ZLIoJ/ze8Tcm5OLS5iOQ0n2HeIo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o0OOn3CI; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc611a0f8cso10490025ad.2
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 10:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723744734; x=1724349534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=soW/UxNTVhflNJS4erlXhZSbLv/T+YEiK5qqd9ov4Jw=;
        b=o0OOn3CIMQA+SbjQ6/irxNJInHsC8fZvEspreBJcIplXu5thjWPwSlInuAFfVT744+
         Qje6sik8Bj6XuGBk7VPFLKU/o6DM25vBPXEQqhsznfxTxa9TNKvJUbEPWTqUli+pzI16
         WAlYOtW1qWJ2ODAc/kGl6Z+cTdPwxftQLCq4/4VCzeVz5snx4a+JYulFJ2dkouohaHmJ
         DzvqD+rdqZDMTZUWNm1j633WXI3YcbINoCLPr4/AGLs98qNPUAk/j5aqMA/zsVQqlIlD
         3/b7jDevTCDPLln3LxF0Wn5e8iOVO9+bkjUJDZ/aGUslTajAzEdKSdbUUo+izXPmHAih
         C5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723744734; x=1724349534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=soW/UxNTVhflNJS4erlXhZSbLv/T+YEiK5qqd9ov4Jw=;
        b=KLoDupqe4ql7OKvIzFmw2ye2IZmd/WAlRl44X+SewyxtheHifZyS0NkssIwiAFlFlu
         A7CH63TtBxuxR1FXMcsLXXcDucygWSYpIm08GiIiHI86oRAZcqpT6g9NqhEw1bod32f2
         fjF6kgKrx+4DEBVbcfMUnhHdgL+yBk/q+iXwCHT+xdISsewzUI07NOOtG/KpcV16xqNj
         e1vzWbpxFm91r2K+q7inFBSR42GGSsOkTycS2kJbYcPI/LsziNcJN8cAPN/YKycSucgv
         YL4jwgZtj0Mq5mwjpyXqjPSocyZq8GEKIbF18kOZ2xepIsEUsMXWuebgl17iqaFgSruh
         MCAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb/D14N555FQsbXU0fHQGAl7vI+jZY5kbGsGkiwTmsGYhvWH0cRmtvMt8z7cJk1CPRPX18IN5Oc5MVzpYgb81SuKWg
X-Gm-Message-State: AOJu0YwslpHzC7X8VdIlXhKQWj3Vaj598iQdxXAI+OF0bNuMoVKc+HWQ
	TrZHyg+inbqUCO+g+s1hqY2MjOZn7ibAWUS75Os4OQAEef/Kj4v0kY1ttl2LE6g=
X-Google-Smtp-Source: AGHT+IG8RgoCPeYjVGtE5HgUKk1iC6j3rCHioXfqsJUhDkWkGFBqSH86EVRl3Fze5yBsgzIdlxFsRQ==
X-Received: by 2002:a17:903:22cf:b0:1fb:6294:2e35 with SMTP id d9443c01a7336-20203f280a2mr5097105ad.50.1723744734003;
        Thu, 15 Aug 2024 10:58:54 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::b861? ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f039e084sm12724745ad.243.2024.08.15.10.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 10:58:53 -0700 (PDT)
Message-ID: <4c133680-1be8-41f1-82ce-78e967809da1@linaro.org>
Date: Thu, 15 Aug 2024 10:58:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] meson: hide tsan related warnings
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Beraldo Leal <bleal@redhat.com>,
 David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-2-pierrick.bouvier@linaro.org>
 <CAFEAcA-EAm9mEdGz6m2Y-yxK16TgX6CpxnXc6hW59iAxhXhHtw@mail.gmail.com>
 <Zr3g7lEfteRpNYVC@redhat.com>
 <CAFEAcA8xMjd2w5tT-sMcHKuKGXbqZg4HtTerNFG=_YpNRVVhxQ@mail.gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <CAFEAcA8xMjd2w5tT-sMcHKuKGXbqZg4HtTerNFG=_YpNRVVhxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC8xNS8yNCAxMDo1NCwgUGV0ZXIgTWF5ZGVsbCB3cm90ZToNCj4gT24gVGh1LCAxNSBB
dWcgMjAyNCBhdCAxMjowNSwgRGFuaWVsIFAuIEJlcnJhbmfDqSA8YmVycmFuZ2VAcmVkaGF0
LmNvbT4gd3JvdGU6DQo+Pg0KPj4gT24gVGh1LCBBdWcgMTUsIDIwMjQgYXQgMTE6MTI6MzlB
TSArMDEwMCwgUGV0ZXIgTWF5ZGVsbCB3cm90ZToNCj4+PiBPbiBXZWQsIDE0IEF1ZyAyMDI0
IGF0IDIzOjQyLCBQaWVycmljayBCb3V2aWVyDQo+Pj4gPHBpZXJyaWNrLmJvdXZpZXJAbGlu
YXJvLm9yZz4gd3JvdGU6DQo+Pj4+DQo+Pj4+IFdoZW4gYnVpbGRpbmcgd2l0aCBnY2MtMTIg
LWZzYW5pdGl6ZT10aHJlYWQsIGdjYyByZXBvcnRzIHNvbWUNCj4+Pj4gY29uc3RydWN0aW9u
cyBub3Qgc3VwcG9ydGVkIHdpdGggdHNhbi4NCj4+Pj4gRm91bmQgb24gZGViaWFuIHN0YWJs
ZS4NCj4+Pj4NCj4+Pj4gcWVtdS9pbmNsdWRlL3FlbXUvYXRvbWljLmg6MzY6NTI6IGVycm9y
OiDigJhhdG9taWNfdGhyZWFkX2ZlbmNl4oCZIGlzIG5vdCBzdXBwb3J0ZWQgd2l0aCDigJgt
ZnNhbml0aXplPXRocmVhZOKAmSBbLVdlcnJvcj10c2FuXQ0KPj4+PiAgICAgMzYgfCAjZGVm
aW5lIHNtcF9tYigpICAgICAgICAgICAgICAgICAgICAgKHsgYmFycmllcigpOyBfX2F0b21p
Y190aHJlYWRfZmVuY2UoX19BVE9NSUNfU0VRX0NTVCk7IH0pDQo+Pj4+ICAgICAgICB8ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPj4+Pg0KPj4+PiBTaWduZWQt
b2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+
DQo+Pj4+IC0tLQ0KPj4+PiAgIG1lc29uLmJ1aWxkIHwgMTAgKysrKysrKysrLQ0KPj4+PiAg
IDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+Pj4N
Cj4+Pj4gZGlmZiAtLWdpdCBhL21lc29uLmJ1aWxkIGIvbWVzb24uYnVpbGQNCj4+Pj4gaW5k
ZXggODFlY2Q0YmFlN2MuLjUyZTVhYTk1Y2MwIDEwMDY0NA0KPj4+PiAtLS0gYS9tZXNvbi5i
dWlsZA0KPj4+PiArKysgYi9tZXNvbi5idWlsZA0KPj4+PiBAQCAtNDk5LDcgKzQ5OSwxNSBA
QCBpZiBnZXRfb3B0aW9uKCd0c2FuJykNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgcHJlZml4OiAnI2luY2x1ZGUgPHNhbml0aXplci90c2FuX2ludGVyZmFjZS5oPicpDQo+
Pj4+ICAgICAgIGVycm9yKCdDYW5ub3QgZW5hYmxlIFRTQU4gZHVlIHRvIG1pc3NpbmcgZmli
ZXIgYW5ub3RhdGlvbiBpbnRlcmZhY2UnKQ0KPj4+PiAgICAgZW5kaWYNCj4+Pj4gLSAgcWVt
dV9jZmxhZ3MgPSBbJy1mc2FuaXRpemU9dGhyZWFkJ10gKyBxZW11X2NmbGFncw0KPj4+PiAr
ICB0c2FuX3dhcm5fc3VwcHJlc3MgPSBbXQ0KPj4+PiArICAjIGdjYyAoPj0xMSkgd2lsbCBy
ZXBvcnQgY29uc3RydWN0aW9ucyBub3Qgc3VwcG9ydGVkIGJ5IHRzYW46DQo+Pj4+ICsgICMg
ImVycm9yOiDigJhhdG9taWNfdGhyZWFkX2ZlbmNl4oCZIGlzIG5vdCBzdXBwb3J0ZWQgd2l0
aCDigJgtZnNhbml0aXplPXRocmVhZOKAmSINCj4+Pj4gKyAgIyBodHRwczovL2djYy5nbnUu
b3JnL2djYy0xMS9jaGFuZ2VzLmh0bWwNCj4+Pj4gKyAgIyBIb3dldmVyLCBjbGFuZyBkb2Vz
IG5vdCBzdXBwb3J0IHRoaXMgd2FybmluZyBhbmQgdGhpcyB0cmlnZ2VycyBhbiBlcnJvci4N
Cj4+Pj4gKyAgaWYgY2MuaGFzX2FyZ3VtZW50KCctV25vLXRzYW4nKQ0KPj4+PiArICAgIHRz
YW5fd2Fybl9zdXBwcmVzcyA9IFsnLVduby10c2FuJ10NCj4+Pj4gKyAgZW5kaWYNCj4+Pg0K
Pj4+IFRoYXQgbGFzdCBwYXJ0IHNvdW5kcyBsaWtlIGEgY2xhbmcgYnVnIC0tIC1Xbm8tZm9v
IGlzIHN1cHBvc2VkDQo+Pj4gdG8gbm90IGJlIGFuIGVycm9yIG9uIGNvbXBpbGVycyB0aGF0
IGRvbid0IGltcGxlbWVudCAtV2ZvbyBmb3INCj4+PiBhbnkgdmFsdWUgb2YgZm9vICh1bmxl
c3Mgc29tZSBvdGhlciB3YXJuaW5nL2Vycm9yIHdvdWxkIGFsc28NCj4+PiBiZSBlbWl0dGVk
KS4NCj4+DQo+PiAtV25vLWZvbyBpc24ndCBhbiBlcnJvciwgYnV0IGl0IGlzIGEgd2Fybmlu
Zy4uLiB3aGljaCB3ZSB0aGVuDQo+PiB0dXJuIGludG8gYW4gZXJyb3IgZHVlIHRvIC1XZXJy
b3IsIHVubGVzcyB3ZSBwYXNzIC1Xbm8tdW5rbm93bi13YXJuaW5nLW9wdGlvbg0KPj4gdG8g
Y2xhbmcuDQo+IA0KPiBXaGljaCBpcyBpcnJpdGF0aW5nIGlmIHlvdSB3YW50IHRvIGJlIGFi
bGUgdG8gYmxhbmtldCBzYXkNCj4gJy1Xbm8tc2lsbHktY29tcGlsZXItd2FybmluZycgYW5k
IG5vdCBzZWUgYW55IG9mIHRoYXQNCj4gd2FybmluZyByZWdhcmRsZXNzIG9mIGNvbXBpbGVy
IHZlcnNpb24uIFRoYXQncyB3aHkgdGhlDQo+IGdjYyBiZWhhdmlvdXIgaXMgdGhlIHdheSBp
dCBpcyAoaS5lLiAtV25vLXN1Y2gtdGhpbmd5DQo+IGlzIG5laXRoZXIgYSB3YXJuaW5nIG5v
ciBhbiBlcnJvciBpZiBpdCB3b3VsZCBiZSB0aGUgb25seQ0KPiB3YXJuaW5nL2Vycm9yKSwg
YW5kIGlmIGNsYW5nIGRvZXNuJ3QgbWF0Y2ggaXQgdGhhdCdzIGEgc2hhbWUuDQo+IA0KDQpJ
dCdzIHdoeSBJIGNob3NlIHRvIGltcGxlbWVudCB0aGlzIHVzaW5nIGNjLmhhc19hcmd1bWVu
dCgpLCBpbnN0ZWFkIG9mIA0KdHJ5aW5nIHRvIGlkZW50aWZ5IGNvbXBpbGVyL3ZlcnNpb24u
DQoNCj4gdGhhbmtzDQo+IC0tIFBNTQ0K

