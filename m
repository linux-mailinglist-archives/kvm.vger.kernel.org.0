Return-Path: <kvm+bounces-40363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCFE8A56F01
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:28:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D30C0188BB7E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563CB23FC54;
	Fri,  7 Mar 2025 17:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qRvmhaa/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103C32940D
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741368523; cv=none; b=EqtM3yJfjG6Xvm7eviQDXpza1SvHpBZsf9sJyAmuTXieeHNnq9qYrXyb4otmHqsrAnoBsH1b8oOzAI/eW/f7hQqpTEs1choA9bd89esE6azS9jbpz/wXlmJZ+Z/+aqe/xRJXIcvDnQ3nueiLwiW1tkm4d8o/7wIDHetA4iyTcNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741368523; c=relaxed/simple;
	bh=fuCjjgBkNEewYDYmiM8ozxvRqJg4DrU5jlpsU73PMjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uSrSjKdr2mk622mydKnkCwApubaAMU/GPrlQY08fcajjXIXV8HKNRrkS1U7u6Eip0KEf8oZ/a5lMvzKgsnqFN/pkav8hhFQ23nldQ1IM/0Qbd9tbdEoevXG5QfCK1mQzseJNOhBzN3P15zba5fNS9uFqz2oCgAvr16JaDYLCr4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qRvmhaa/; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-223378e2b0dso33268475ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 09:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741368521; x=1741973321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fuCjjgBkNEewYDYmiM8ozxvRqJg4DrU5jlpsU73PMjU=;
        b=qRvmhaa/gnMfEH30ipzg2el22N/xmFNku8jXS9L94QB0dPNGiLxYuli07oPcUoNMvg
         fkTaAIq7WTL8sQcMVD/y1rf3DkJet1lQBPwjjSbyy/eUf1XmDx+0bjm88BBzZNLnKSfU
         Zj/mBKvLx5JasSi4cnfiMtIyezQUygm6DvQn1nMWtvfyMqfPlErSz1QmDOoz4sOYr5z2
         LZ428bbV4kVpIFPmgmscLqzxPSkcD3WujFJDTu/zUqHJFhwHlu4W9+4BNhgL+w70Mv0A
         b8mR/MJ5E7cIEq3pimGWsVl6+ItjLhdTI0wRTyEHRJ+keHSpcf5QkZvnrb1S12AngmE1
         0NZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741368521; x=1741973321;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fuCjjgBkNEewYDYmiM8ozxvRqJg4DrU5jlpsU73PMjU=;
        b=L55DpAPi6UUAuD/29RP27Bbkl0Ok5zgJnzetZf0eCgZzRU1rIxz8+fcNYcCshMFEl+
         AuLM8h62GDVj8dDZp0erFQ+wZsUAMIKx3JcktYZhA5W14qsO/Mx/qIAJDgetXkrjezMG
         lkj6KseuZBs55N2sIJsLgfK0ZrPFVw5x7f8n4L0cfBpsRHciEu5Aj8/pe1HQiZ2I0bUp
         nfsTO9celYT4eakeBbtclCWwt8ekC+zZuGJLc3/oIo2zOVP4CyklMRjp9DQrfT/Mic7z
         Nwgd+t0bZ4E42n7g3YQf9iPCnT4jn0UnGxD0kcTS91wQbt6DLyEnxWEa3KCej7ZZGpNb
         /rRg==
X-Gm-Message-State: AOJu0YwqI4hoil0X3PZMshK68qDF8VzR3YOznriMIUzLlm2jrzA4JA8q
	Dduc+YjEDpbOeKsQjOa3SqNg8hLD51vc0wG/SBt4/Ul2U82nCTwmuy+Ea2I6nSs=
X-Gm-Gg: ASbGnctiJQwdDjGh8KgzVQunmoukssQeNZqizoFG0uB0vYbaeDop6sc4WOgQNMeQ+tl
	njz/EY8bTWFAvKtmepF2CDUoeRYC5bHB6xnb4nkCzYq2820SDSNQKi7ZN1mCHzN4pYSNkXl9OJU
	vKIIxLapoIniBBo0LHrvXffG7bnhLA4hDYk9DKisun0DzvYidVi1Tbffa6Mj3XvB2/QV5oIa1yq
	rtmzQPpqMEvRvxVqTBUnejGjHbmjxTik/TsNuKgz+D7eByMCY6/8m/UPd7C//5NfBGJyWcukvKp
	zkc2kj6VQqzGbO8PdxnUUxySHCDhKCLx/caecY/hu9l8Ynl1b/4i/2G+Pg==
X-Google-Smtp-Source: AGHT+IHkmMPBeC7Jjz6QaagGABV93I+Jsq2T/Kqau419WQZhtTKYIasZKgrWrz43zBNXteOS9gtokg==
X-Received: by 2002:a05:6a20:43a0:b0:1f1:253:2e6d with SMTP id adf61e73a8af0-1f544c377efmr7566014637.29.1741368521281;
        Fri, 07 Mar 2025 09:28:41 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af2812887b3sm2819173a12.71.2025.03.07.09.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 09:28:40 -0800 (PST)
Message-ID: <ab1a90fb-e068-4ddc-865e-07bdeb2789e3@linaro.org>
Date: Fri, 7 Mar 2025 09:28:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] hw/hyperv/syndbg: common compilation unit
Content-Language: en-US
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 manos.pitsidianakis@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <20250306064118.3879213-6-pierrick.bouvier@linaro.org>
 <353b36fd-2265-43c3-8072-3055e5bd7057@linaro.org>
 <35c2c7a5-5b12-4c21-a40a-375caae60d0c@linaro.org>
 <d62743f5-ca79-47c0-a72b-c36308574bdd@linaro.org>
 <6556fdd8-83ea-4cc6-9a3b-3822fdc8cb5d@linaro.org>
 <95a6f718-8fab-434c-9b02-6812f7afbcc3@maciej.szmigiero.name>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <95a6f718-8fab-434c-9b02-6812f7afbcc3@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDAzOjA3LCBNYWNpZWogUy4gU3ptaWdpZXJvIHdyb3RlOg0KPiBPbiA2LjAz
LjIwMjUgMjM6NTYsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBPbiAzLzYvMjUgMDk6
NTgsIFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIHdyb3RlOg0KPj4+IE9uIDYvMy8yNSAxNzoy
MywgUGllcnJpY2sgQm91dmllciB3cm90ZToNCj4+Pj4gT24gMy82LzI1IDA4OjE5LCBSaWNo
YXJkIEhlbmRlcnNvbiB3cm90ZToNCj4+Pj4+IE9uIDMvNS8yNSAyMjo0MSwgUGllcnJpY2sg
Qm91dmllciB3cm90ZToNCj4+Pj4+PiBSZXBsYWNlIFRBUkdFVF9QQUdFLiogYnkgcnVudGlt
ZSBjYWxscw0KPj4+Pj4+DQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogUGllcnJpY2sgQm91dmll
ciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KPj4+Pj4+IC0tLQ0KPj4+Pj4+ICDC
oMKgwqAgaHcvaHlwZXJ2L3N5bmRiZy5jwqDCoMKgIHwgNyArKysrLS0tDQo+Pj4+Pj4gIMKg
wqDCoCBody9oeXBlcnYvbWVzb24uYnVpbGQgfCAyICstDQo+Pj4+Pj4gIMKgwqDCoCAyIGZp
bGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4+Pj4+Pg0K
Pj4+Pj4+IGRpZmYgLS1naXQgYS9ody9oeXBlcnYvc3luZGJnLmMgYi9ody9oeXBlcnYvc3lu
ZGJnLmMNCj4+Pj4+PiBpbmRleCBkM2UzOTE3MDc3Mi4uZjkzODIyMDJlZDMgMTAwNjQ0DQo+
Pj4+Pj4gLS0tIGEvaHcvaHlwZXJ2L3N5bmRiZy5jDQo+Pj4+Pj4gKysrIGIvaHcvaHlwZXJ2
L3N5bmRiZy5jDQo+Pj4+Pj4gQEAgLTE0LDcgKzE0LDcgQEANCj4+Pj4+PiAgwqDCoMKgICNp
bmNsdWRlICJtaWdyYXRpb24vdm1zdGF0ZS5oIg0KPj4+Pj4+ICDCoMKgwqAgI2luY2x1ZGUg
Imh3L3FkZXYtcHJvcGVydGllcy5oIg0KPj4+Pj4+ICDCoMKgwqAgI2luY2x1ZGUgImh3L2xv
YWRlci5oIg0KPj4+Pj4+IC0jaW5jbHVkZSAiY3B1LmgiDQo+Pj4+Pj4gKyNpbmNsdWRlICJl
eGVjL3RhcmdldF9wYWdlLmgiDQo+Pj4+Pj4gIMKgwqDCoCAjaW5jbHVkZSAiaHcvaHlwZXJ2
L2h5cGVydi5oIg0KPj4+Pj4+ICDCoMKgwqAgI2luY2x1ZGUgImh3L2h5cGVydi92bWJ1cy1i
cmlkZ2UuaCINCj4+Pj4+PiAgwqDCoMKgICNpbmNsdWRlICJody9oeXBlcnYvaHlwZXJ2LXBy
b3RvLmgiDQo+Pj4+Pj4gQEAgLTE4OCw3ICsxODgsOCBAQCBzdGF0aWMgdWludDE2X3QgaGFu
ZGxlX3JlY3ZfbXNnKEh2U3luRGJnICpzeW5kYmcsDQo+Pj4+Pj4gdWludDY0X3Qgb3V0Z3Bh
LA0KPj4+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVpbnQ2NF90IHRpbWVvdXQsIHVpbnQzMl90
DQo+Pj4+Pj4gKnJldHJpZXZlZF9jb3VudCkNCj4+Pj4+PiAgwqDCoMKgIHsNCj4+Pj4+PiAg
wqDCoMKgwqDCoMKgwqAgdWludDE2X3QgcmV0Ow0KPj4+Pj4+IC3CoMKgwqAgdWludDhfdCBk
YXRhX2J1ZltUQVJHRVRfUEFHRV9TSVpFIC0gVURQX1BLVF9IRUFERVJfU0laRV07DQo+Pj4+
Pj4gK8KgwqDCoCBjb25zdCBzaXplX3QgYnVmX3NpemUgPSBxZW11X3RhcmdldF9wYWdlX3Np
emUoKSAtDQo+Pj4+Pj4gVURQX1BLVF9IRUFERVJfU0laRTsNCj4+Pj4+PiArwqDCoMKgIHVp
bnQ4X3QgKmRhdGFfYnVmID0gZ19hbGxvY2EoYnVmX3NpemUpOw0KPj4+Pj4+ICDCoMKgwqDC
oMKgwqDCoCBod2FkZHIgb3V0X2xlbjsNCj4+Pj4+PiAgwqDCoMKgwqDCoMKgwqAgdm9pZCAq
b3V0X2RhdGE7DQo+Pj4+Pj4gIMKgwqDCoMKgwqDCoMKgIHNzaXplX3QgcmVjdl9ieXRlX2Nv
dW50Ow0KPj4+Pj4NCj4+Pj4+IFdlJ3ZlIHB1cmdlZCB0aGUgY29kZSBiYXNlIG9mIFZMQXMs
IGFuZCB0aG9zZSBhcmUgcHJlZmVyYWJsZSB0byBhbGxvY2EuDQo+Pj4+PiBKdXN0IHVzZSBn
X21hbGxvYyBhbmQgZ19hdXRvZnJlZS4NCj4+Pj4+DQo+Pj4+DQo+Pj4+IEkgaGVzaXRhdGVk
LCBkdWUgdG8gcG90ZW50aWFsIHBlcmZvcm1hbmNlIGNvbnNpZGVyYXRpb25zIGZvciBwZW9w
bGUNCj4+Pj4gcmV2aWV3aW5nIHRoZSBwYXRjaC4gSSdsbCBzd2l0Y2ggdG8gaGVhcCBiYXNl
ZCBzdG9yYWdlLg0KPj4+DQo+Pj4gT1RPSCBoeXBlcnYgaXMgeDg2LW9ubHksIHNvIHdlIGNv
dWxkIGRvOg0KPj4+DQo+Pj4gI2RlZmluZSBCVUZTWiAoNCAqIEtpQikNCj4+Pg0KPj4+IGhh
bmRsZV9yZWN2X21zZygpDQo+Pj4gew0KPj4+ICDCoMKgwqAgdWludDhfdCBkYXRhX2J1ZltC
VUZTWiAtIFVEUF9QS1RfSEVBREVSX1NJWkVdOw0KPj4+ICDCoMKgwqAgLi4uDQo+Pj4NCj4+
PiBodl9zeW5kYmdfY2xhc3NfaW5pdCgpDQo+Pj4gew0KPj4+ICDCoMKgwqAgYXNzZXJ0KEJV
RlNaID4gcWVtdV90YXJnZXRfcGFnZV9zaXplKCkpOw0KPj4+ICDCoMKgwqAgLi4uDQo+Pj4N
Cj4+PiBhbmQgY2FsbCBpdCBhIGRheS4NCj4+DQo+PiBDb3VsZCBiZSBwb3NzaWJsZSBmb3Ig
bm93IHllcy4NCj4+DQo+PiBBbnkgb3BpbmlvbiBmcm9tIGNvbmNlcm5lZCBtYWludGFpbmVy
cz8NCj4gDQo+IEkgdGhpbmsgZXNzZW50aWFsbHkgaGFyZGNvZGluZyA0ayBwYWdlcyBpbiBo
eXBlcnYgaXMgb2theQ0KPiAod2l0aCBhbiBhcHByb3ByaWF0ZSBjaGVja2luZy9lbmZvcmNl
bWVudCBhc3NlcnRzKCkgb2YgY291cnNlKSwNCj4gc2luY2UgZXZlbiBpZiB0aGlzIGdldHMg
cG9ydGVkIHRvIEFSTTY0IGF0IHNvbWUgcG9pbnQNCj4gaXQgaXMgZ29pbmcgdG8gbmVlZCAq
YSBsb3QqIG9mIGNoYW5nZXMgYW55d2F5Lg0KPiANCg0KT2ssIEkgd2lsbCBoYXJkY29kZSB0
aGlzIGZvbGxvd2luZyBQaGlsaXBwZSBzdWdnZXN0aW9uIHRoZW4uDQoNCj4gVGhhbmtzLA0K
PiBNYWNpZWoNCj4gDQoNCg==

