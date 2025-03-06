Return-Path: <kvm+bounces-40285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B428AA55A3D
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5DBA17192A
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 22:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A4027CB1F;
	Thu,  6 Mar 2025 22:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yC8vLLus"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9494206F22
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 22:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301810; cv=none; b=o72dIvflOjq5W5s3PB3YAHFMdIn5R4amd5d7DHOD5LhCeo7r4t4rQ9aEV/84CpFLv+k+WJOsoCmbDTzPIUmrfvwEbB1kn+rRieeZV+K3iJy56LC9AqH1aZD7ljs4DwRxyYHNUasi1HpOH8YlpzuuXJn8+IR0D49kJdwW/Tj1oRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301810; c=relaxed/simple;
	bh=tFHrc692Y8qh90DSYv2k4rkKWn77/70LUiREi1bmfTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HRsDTwLH9B3iPLnCSshvdi03RHp/OSzDB+LVN9FK/FheESakBsuLHMEknZpT6WuMAB3lDtvCAn/AYKhLt/tVR6bJWaeLhQjoF9ti+Z1on9hyElUApGES8x7Ya91HlzpGWYD93PQR2zh5wpkLzFnLcZHAHPehGIwuSvCxr2jENgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yC8vLLus; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2fecba90cc3so2674933a91.2
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 14:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741301808; x=1741906608; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tFHrc692Y8qh90DSYv2k4rkKWn77/70LUiREi1bmfTk=;
        b=yC8vLLusRagZMEvxxBGMj6wA05FVm2W3S8qdPCtZ3KISD/3OhZiYnywYB3b20HfUBl
         NW2rcIG5WOhCQACSoYEKlmeFmKAVdwke57urcXK2hVhsWQ8vvDMFLEaR2oXUIC1ytTtu
         J5w4W6j3FKEfI+gLiK4s5a44oFmoAtw/OYF1xUq4jE5QFauKzm8pKbwCpYi5UxR8uT5l
         5gnskFIK2Khjsv5EIVUPkPsy1AUKbwTzKLJMEc0CiMeAoSRO4ourfKSXdPr2ekjF3Qp8
         Z39Dsk5tUQhxqjRL6zitueYVmlnEVEuz4e40muxMliDJO5l2Fi/ctJTIEJQ7brn/MD8h
         9M2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741301808; x=1741906608;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tFHrc692Y8qh90DSYv2k4rkKWn77/70LUiREi1bmfTk=;
        b=UhSNlPp0/Og/YUelwCIGi//gy9nXlYLIY/2eG7tPXyEZjjGjTMqi7j8QMs7jEwZjUr
         FZKNx9rhldHzcn78rpU1yWBAhrVNqnKCqZEib+87PgqGs2eSfBZn9bU5uMvpqUPF/Vte
         TceYaW01Pxc4mhp7+gE3XXuWFDVkuAL3jAPMcazl3RfQda6INyrJ735fzfAy9z/CMrkH
         bCepVLq1IrAmpyEFOxUrm/ZPc74MXIAGhvH4G1xPuWqPGMFFa5Jz5ewlRiA6S4Pr4dYP
         WZlP0n+XKpMhyNJgawppI7SDju0h1t9wP095v0goOgFSjAewA/K5tWxNGrvkVidaNyMc
         R8PA==
X-Gm-Message-State: AOJu0YxuLzdJB4i89IZ0fxD+t3Kunot67HZAzn2yleK7pvXu2k4hR+6I
	TyzeFb3899Jd2T+4wZUrbhY2UJFFRLkSgMgWmOwZTxVJd3Z2OKUoqPK/GA2vPrU=
X-Gm-Gg: ASbGncu/cKESBIBUcNX2LU6ltM0UbEnkXp1GoxsaU5dm/k+T4f66TUi0cBIH84tnqv1
	z1aiEUqkEtzju/eIIpuDZtWdM8YM0PRgkQhU39kymFrXyJGm9ufc9bveuDrobJOXI6EOs8iHSLA
	xiZZBHFUU3IRHGpDp+CIyLf22w8vA1MqJOkYiUUxaUEmLV6sgltsk7Pk++9HWSSmG0hwg0XRT0b
	LZtiI4KhXckFLq4k3FpNqnlx2gE+PG1ksNKJ4CsyB+JYShb+LZwOwXdxdOPhCArL3bS2KK5Ghmt
	lzQpqCLV9s3cTBsMvxxejipuf1S5+jOHPhCE/q8cTed2Y+oZZXGGTGnNpQ==
X-Google-Smtp-Source: AGHT+IFOJ1hF06oncnjzqkL9LiblvIpsOu4HzSGUo4HKzGxGg+Ah+gCd3U2ZhxwNyrKtxXO8Wt7zDQ==
X-Received: by 2002:a05:6a20:748e:b0:1ee:d418:f764 with SMTP id adf61e73a8af0-1f544c98cb0mr1855892637.38.1741301808110;
        Thu, 06 Mar 2025 14:56:48 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73698518e21sm1970732b3a.148.2025.03.06.14.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 14:56:47 -0800 (PST)
Message-ID: <6556fdd8-83ea-4cc6-9a3b-3822fdc8cb5d@linaro.org>
Date: Thu, 6 Mar 2025 14:56:46 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] hw/hyperv/syndbg: common compilation unit
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-6-pierrick.bouvier@linaro.org>
 <353b36fd-2265-43c3-8072-3055e5bd7057@linaro.org>
 <35c2c7a5-5b12-4c21-a40a-375caae60d0c@linaro.org>
 <d62743f5-ca79-47c0-a72b-c36308574bdd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <d62743f5-ca79-47c0-a72b-c36308574bdd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy82LzI1IDA5OjU4LCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gT24g
Ni8zLzI1IDE3OjIzLCBQaWVycmljayBCb3V2aWVyIHdyb3RlOg0KPj4gT24gMy82LzI1IDA4
OjE5LCBSaWNoYXJkIEhlbmRlcnNvbiB3cm90ZToNCj4+PiBPbiAzLzUvMjUgMjI6NDEsIFBp
ZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+Pj4+IFJlcGxhY2UgVEFSR0VUX1BBR0UuKiBieSBy
dW50aW1lIGNhbGxzDQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IFBpZXJyaWNrIEJvdXZp
ZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+Pj4gLS0tDQo+Pj4+ICDCoMKg
IGh3L2h5cGVydi9zeW5kYmcuY8KgwqDCoCB8IDcgKysrKy0tLQ0KPj4+PiAgwqDCoCBody9o
eXBlcnYvbWVzb24uYnVpbGQgfCAyICstDQo+Pj4+ICDCoMKgIDIgZmlsZXMgY2hhbmdlZCwg
NSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0
IGEvaHcvaHlwZXJ2L3N5bmRiZy5jIGIvaHcvaHlwZXJ2L3N5bmRiZy5jDQo+Pj4+IGluZGV4
IGQzZTM5MTcwNzcyLi5mOTM4MjIwMmVkMyAxMDA2NDQNCj4+Pj4gLS0tIGEvaHcvaHlwZXJ2
L3N5bmRiZy5jDQo+Pj4+ICsrKyBiL2h3L2h5cGVydi9zeW5kYmcuYw0KPj4+PiBAQCAtMTQs
NyArMTQsNyBAQA0KPj4+PiAgwqDCoCAjaW5jbHVkZSAibWlncmF0aW9uL3Ztc3RhdGUuaCIN
Cj4+Pj4gIMKgwqAgI2luY2x1ZGUgImh3L3FkZXYtcHJvcGVydGllcy5oIg0KPj4+PiAgwqDC
oCAjaW5jbHVkZSAiaHcvbG9hZGVyLmgiDQo+Pj4+IC0jaW5jbHVkZSAiY3B1LmgiDQo+Pj4+
ICsjaW5jbHVkZSAiZXhlYy90YXJnZXRfcGFnZS5oIg0KPj4+PiAgwqDCoCAjaW5jbHVkZSAi
aHcvaHlwZXJ2L2h5cGVydi5oIg0KPj4+PiAgwqDCoCAjaW5jbHVkZSAiaHcvaHlwZXJ2L3Zt
YnVzLWJyaWRnZS5oIg0KPj4+PiAgwqDCoCAjaW5jbHVkZSAiaHcvaHlwZXJ2L2h5cGVydi1w
cm90by5oIg0KPj4+PiBAQCAtMTg4LDcgKzE4OCw4IEBAIHN0YXRpYyB1aW50MTZfdCBoYW5k
bGVfcmVjdl9tc2coSHZTeW5EYmcgKnN5bmRiZywNCj4+Pj4gdWludDY0X3Qgb3V0Z3BhLA0K
Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgdWludDY0X3QgdGltZW91dCwgdWludDMyX3QNCj4+Pj4g
KnJldHJpZXZlZF9jb3VudCkNCj4+Pj4gIMKgwqAgew0KPj4+PiAgwqDCoMKgwqDCoMKgIHVp
bnQxNl90IHJldDsNCj4+Pj4gLcKgwqDCoCB1aW50OF90IGRhdGFfYnVmW1RBUkdFVF9QQUdF
X1NJWkUgLSBVRFBfUEtUX0hFQURFUl9TSVpFXTsNCj4+Pj4gK8KgwqDCoCBjb25zdCBzaXpl
X3QgYnVmX3NpemUgPSBxZW11X3RhcmdldF9wYWdlX3NpemUoKSAtDQo+Pj4+IFVEUF9QS1Rf
SEVBREVSX1NJWkU7DQo+Pj4+ICvCoMKgwqAgdWludDhfdCAqZGF0YV9idWYgPSBnX2FsbG9j
YShidWZfc2l6ZSk7DQo+Pj4+ICDCoMKgwqDCoMKgwqAgaHdhZGRyIG91dF9sZW47DQo+Pj4+
ICDCoMKgwqDCoMKgwqAgdm9pZCAqb3V0X2RhdGE7DQo+Pj4+ICDCoMKgwqDCoMKgwqAgc3Np
emVfdCByZWN2X2J5dGVfY291bnQ7DQo+Pj4NCj4+PiBXZSd2ZSBwdXJnZWQgdGhlIGNvZGUg
YmFzZSBvZiBWTEFzLCBhbmQgdGhvc2UgYXJlIHByZWZlcmFibGUgdG8gYWxsb2NhLg0KPj4+
IEp1c3QgdXNlIGdfbWFsbG9jIGFuZCBnX2F1dG9mcmVlLg0KPj4+DQo+Pg0KPj4gSSBoZXNp
dGF0ZWQsIGR1ZSB0byBwb3RlbnRpYWwgcGVyZm9ybWFuY2UgY29uc2lkZXJhdGlvbnMgZm9y
IHBlb3BsZQ0KPj4gcmV2aWV3aW5nIHRoZSBwYXRjaC4gSSdsbCBzd2l0Y2ggdG8gaGVhcCBi
YXNlZCBzdG9yYWdlLg0KPiANCj4gT1RPSCBoeXBlcnYgaXMgeDg2LW9ubHksIHNvIHdlIGNv
dWxkIGRvOg0KPiANCj4gI2RlZmluZSBCVUZTWiAoNCAqIEtpQikNCj4gDQo+IGhhbmRsZV9y
ZWN2X21zZygpDQo+IHsNCj4gICAgIHVpbnQ4X3QgZGF0YV9idWZbQlVGU1ogLSBVRFBfUEtU
X0hFQURFUl9TSVpFXTsNCj4gICAgIC4uLg0KPiANCj4gaHZfc3luZGJnX2NsYXNzX2luaXQo
KQ0KPiB7DQo+ICAgICBhc3NlcnQoQlVGU1ogPiBxZW11X3RhcmdldF9wYWdlX3NpemUoKSk7
DQo+ICAgICAuLi4NCj4gDQo+IGFuZCBjYWxsIGl0IGEgZGF5Lg0KDQpDb3VsZCBiZSBwb3Nz
aWJsZSBmb3Igbm93IHllcy4NCg0KQW55IG9waW5pb24gZnJvbSBjb25jZXJuZWQgbWFpbnRh
aW5lcnM/DQo=

