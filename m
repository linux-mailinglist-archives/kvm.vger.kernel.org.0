Return-Path: <kvm+bounces-42477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F28A0A791D2
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 17:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E78E3B2844
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D69A23BD05;
	Wed,  2 Apr 2025 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MKBb2O5z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2522D7BF
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743606394; cv=none; b=d/uL7CSRHQMgkp6On5578sf1wEQ+X3FHNDbrnIJwDoCroMpD5D7ryaA9TSeaKY+QWQ0RKIpKylAZbGG0OJX0VCyk6r3oq1VKEIcHeovgXrUknFefyOHrjt0gAbXJKqsRR4rPNDKI9bxEzB2aElvktab2NmYuro3uMEGQG6MyUIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743606394; c=relaxed/simple;
	bh=+suyxI6UtimLYmX9HGZ6Yx3RjITGhRsYKZALhU8U+ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pBKMjWLcsMl9YVqp4TWCnrAmwqo8/Qowzdo2vT2QeBJ/UAG9aiuFaobUKZPN6nWKhNdYZG2Lz1N37hfTdCFlHSk2VSDuYukmpNPpNW+kiBHsYMXUU6d+txoMYW16wSocOpODEhRBxcfiKDFtbvcSCA8YtO4NDjW1XOm9Ah5Lf7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MKBb2O5z; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-730517040a9so363611b3a.0
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 08:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743606392; x=1744211192; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+suyxI6UtimLYmX9HGZ6Yx3RjITGhRsYKZALhU8U+ig=;
        b=MKBb2O5z9qYYbtWCkJbAT8AyIDwXO3fkkbmukAL8MX66N5JNUYTSmpkvTOjAPI7fSc
         EuKwwkt519KoNQ0bZwHMKOs/8QFe+ewl4RHXLagkIFRZpD8sJ2F4wQbbaZN/J/e4BMp+
         wPas4lbfQdVet81ldcckK+ZwkSl9mcdeFuINUPKf5eKbfIxAln9icrx0Cn2VxBYh89ND
         GE6EtpWF7dDC/kLE1PinAj65CL4A23ov/BJ6kjoX3QFg6hw2e4vLcH24NE2gJkmFk1q4
         tglVyO3TLHzJC51CUKdne0pSVjjF0c/Fqgk6PSIVboV+VwgbaCOfK1VtWd6rK865G62A
         ytZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743606392; x=1744211192;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+suyxI6UtimLYmX9HGZ6Yx3RjITGhRsYKZALhU8U+ig=;
        b=Xeb3bIvDZKP/th7czi/swfUketDUbNhLsknABKiDhXrcy7TE4Brv+eKaK9p1itCxpP
         fB8kusScx3xHSnFoFUopGO40xraJShhr8gfOdPqqbuIb2xlt7Q5kZS3hMhfcQNy389GV
         b1l72QTNiEWFWX5mdfMTkhgV1ze1kNIfD1akTmC+j31+ee5c1BrlbBDLArYWWiszmve7
         HBUMABygGq1RLRw+wLB2vjQHiIRH5PeCUA5+VmBLElKxT64HPllIS+GUmUBTsgUYu3eb
         YTfVVZ54znHuqaVzNvSerBkgUbljSlC7unn3UkQrcq5qMaWZgzbe/PCyyzniwj3k25+w
         hKpg==
X-Gm-Message-State: AOJu0YzcIkCvC4T/DMSBwEnExWivnHhW6ZXrUkGKKw92UnCkgsMJy3lr
	fWUHSq1vmnGHP46sr0wC6f9jVgclUJVES7h9r/5924kFKF1bAEaW0V+qEqjfaiU=
X-Gm-Gg: ASbGnctfKyUucGgwy+so1nlwP51bWFOvp6E1jMOIGrE0DQHOj6ngV4hTQxAxTO1QSUN
	7jSQLyX3BYDaidHCKM/Oe316KJFGIurnhR4MKiIB8c6zvDX9m0pxUbjB3hi2kPm6PDr0X6DFPJp
	bg8lWGM3N93qYBetoHRV3WTZdf9KmMoOU7rIxR8GMh8xxuJobW+r/+il9ACQXcZ+xUJqBzRWWT1
	C14OiwbpAmo0dJYzWxMQEagRCeyaDntotLGcRr4weEVsQC/v7Y94xcpDqIGQqfjXIrvx2Nku0r5
	CMgVCM6D9wPlBkj/s14IwdoHD8eov8oeyimOMvdBh7AkTeWimvrGgQAh6g==
X-Google-Smtp-Source: AGHT+IE2WfizvIScfv6TpCwQcsyk99JyjHPhECR5f2dEFmILSKSO5YDax5Dfjn0t/XU0VwHf2cA1JQ==
X-Received: by 2002:a05:6a20:3952:b0:1f5:535c:82dc with SMTP id adf61e73a8af0-2009f79c626mr28021630637.42.1743606392389;
        Wed, 02 Apr 2025 08:06:32 -0700 (PDT)
Received: from [192.168.1.87] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af93b8b48e3sm10001437a12.58.2025.04.02.08.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Apr 2025 08:06:31 -0700 (PDT)
Message-ID: <10759233-e73b-49e2-870b-c7687c9cfd1e@linaro.org>
Date: Wed, 2 Apr 2025 08:06:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/30] target/arm/cpu: always define kvm related
 registers
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-21-pierrick.bouvier@linaro.org>
 <1109fe22-9008-47c6-b14d-7323f9888822@linaro.org>
 <11b5441f-c7c0-4b4c-8061-471a49e8465a@linaro.org>
 <428e6fdb-24b9-47a2-9d3f-4ef5c2e1a0ae@linaro.org>
 <ca52ecb4-6c1d-4299-9764-5839db2d013e@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <ca52ecb4-6c1d-4299-9764-5839db2d013e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8yLzI1IDA2OjM2LCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gT24g
MjUvMy8yNSAwMjoyNCwgUmljaGFyZCBIZW5kZXJzb24gd3JvdGU6DQo+PiBPbiAzLzI0LzI1
IDE0OjExLCBQaWVycmljayBCb3V2aWVyIHdyb3RlOg0KPj4+IE9uIDMvMjMvMjUgMTI6Mzcs
IFJpY2hhcmQgSGVuZGVyc29uIHdyb3RlOg0KPj4+PiBPbiAzLzIwLzI1IDE1OjI5LCBQaWVy
cmljayBCb3V2aWVyIHdyb3RlOg0KPj4+Pj4gVGhpcyBkb2VzIG5vdCBodXJ0LCBldmVuIGlm
IHRoZXkgYXJlIG5vdCB1c2VkLg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFBpZXJy
aWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+Pj4+IC0tLQ0K
Pj4+Pj4gIMKgwqAgdGFyZ2V0L2FybS9jcHUuaCB8IDIgLS0NCj4+Pj4+ICDCoMKgIDEgZmls
ZSBjaGFuZ2VkLCAyIGRlbGV0aW9ucygtKQ0KPj4+Pj4NCj4+Pj4+IGRpZmYgLS1naXQgYS90
YXJnZXQvYXJtL2NwdS5oIGIvdGFyZ2V0L2FybS9jcHUuaA0KPj4+Pj4gaW5kZXggYThhMWE4
ZmFmNmIuLmFiNzQxMjc3MmJjIDEwMDY0NA0KPj4+Pj4gLS0tIGEvdGFyZ2V0L2FybS9jcHUu
aA0KPj4+Pj4gKysrIGIvdGFyZ2V0L2FybS9jcHUuaA0KPj4+Pj4gQEAgLTk3MSw3ICs5NzEs
NiBAQCBzdHJ1Y3QgQXJjaENQVSB7DQo+Pj4+PiAgwqDCoMKgwqDCoMKgwqAgKi8NCj4+Pj4+
ICDCoMKgwqDCoMKgwqAgdWludDMyX3Qga3ZtX3RhcmdldDsNCj4+Pj4+IC0jaWZkZWYgQ09O
RklHX0tWTQ0KPj4+Pj4gIMKgwqDCoMKgwqDCoCAvKiBLVk0gaW5pdCBmZWF0dXJlcyBmb3Ig
dGhpcyBDUFUgKi8NCj4+Pj4+ICDCoMKgwqDCoMKgwqAgdWludDMyX3Qga3ZtX2luaXRfZmVh
dHVyZXNbN107DQo+Pj4+PiBAQCAtOTg0LDcgKzk4Myw2IEBAIHN0cnVjdCBBcmNoQ1BVIHsN
Cj4+Pj4+ICDCoMKgwqDCoMKgwqAgLyogS1ZNIHN0ZWFsIHRpbWUgKi8NCj4+Pj4+ICDCoMKg
wqDCoMKgwqAgT25PZmZBdXRvIGt2bV9zdGVhbF90aW1lOw0KPj4+Pj4gLSNlbmRpZiAvKiBD
T05GSUdfS1ZNICovDQo+Pj4+PiAgwqDCoMKgwqDCoMKgIC8qIFVuaXByb2Nlc3NvciBzeXN0
ZW0gd2l0aCBNUCBleHRlbnNpb25zICovDQo+Pj4+PiAgwqDCoMKgwqDCoMKgIGJvb2wgbXBf
aXNfdXA7DQo+Pj4+DQo+Pj4+IEknbSBub3Qgc3VyZSB3aGF0IHRoaXMgYWNoaWV2ZXM/wqDC
oCBDT05GSUdfS1ZNIGlzIGEgY29uZmlndXJlLXRpbWUNCj4+Pj4gc2VsZWN0aW9uLg0KPj4+
Pg0KPj4+DQo+Pj4gQ09ORklHX0tWTSBpcyBhIHBvaXNvbmVkIGlkZW50aWZpZXIuDQo+Pj4g
SXQncyBpbmNsdWRlZCB2aWEgY29uZmlnLXRhcmdldC5oLCBhbmQgbm90IGNvbmZpZy1ob3N0
LmguDQo+Pg0KPj4gV2hvb3BzLCB5ZXMuDQo+IA0KPiBJZiB3ZSBnbyB0aGlzIHdheSwgY2Fu
IHdlIGNvbnNpc3RlbnRseSBhbGxvdyBDT05GSUdfJHtIV19BQ0NFTH0NCj4gKHJlYWQgInJl
bW92ZSBwb2lzb25lZCBkZWZzIGluIGNvbmZpZy1wb2lzb24uaCk/DQoNCkl0IHdvdWxkIGJl
IHNhZmUgdG8gZG8gdGhpcyBmb3IgQ09ORklHX1RDRywgd2hpY2ggaXMgYXBwbGllZCB0byBh
bGwgDQpjb21waWxhdGlvbiB1bml0cyAodGhyb3VnaCBjb25maWdfaG9zdCkuIEFuZCB3ZSds
bCBkbyBpdCB3aGVuIHdlIG1lZXQgYSANCmNhc2UgdGhhdCByZWFsbHkgbmVlZHMgaXQsIG5v
dCBiZWZvcmUuIEFzIGxvbmcgYXMgdGhlIGNvZGUgY2FuIGJlIA0KY2xlYW5lZCB1cCBmcm9t
IHRob3NlIGlmZGVmcywgaXQncyBiZXR0ZXIuDQoNCkhvd2V2ZXIsIGl0J3Mgbm90IHNhZmUg
Zm9yIGFsbCBvdGhlciBDT05GSUdfJHtIV19BQ0NFTH0sIHdoaWNoIGFyZSANCmFwcGxpZWQg
c2VsZWN0aXZlbHkgb24gc29tZSB0YXJnZXRzIChiYXNpY2FsbHksIGZvciB0aGUgcGFpciB7
aG9zdCA9PSANCnRhcmdldH0sIHdoZW4gaG9zdCBzdXBwb3J0cyB0aGlzIGFjY2VsZXJhdGlv
bikuDQpGb3IgdGhlbSwgdGhlIHJpZ2h0IGZpeCBpcyB0byBtYWtlIHN1cmUgd2UgY2FsbCAi
e2FjY2VsfV9lbmFibGVkKCkiLCANCmV4cG9zZSB0aGUgYXNzb2NpYXRlZCBjb2RlLCBhbmQg
ZXZlbnR1YWxseSBkZWFsIHdpdGggbWlzc2luZyBzeW1ib2xzIGF0IA0KbGluay4NCg==

