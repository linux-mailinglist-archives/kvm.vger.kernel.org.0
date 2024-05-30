Return-Path: <kvm+bounces-18455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F198D555D
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 00:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6BE01F253FD
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 22:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44912182D25;
	Thu, 30 May 2024 22:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E5pl2QjT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF2624211
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 22:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717108143; cv=none; b=N8gKK6/G68ck+DkVCnJQcj1MqAprjgAbadJ6oNxqzduT/tgYdssb1dKqJaRb7htz6syKxIu9/R6xN7TqtFMXW77I1B+MffGy5cVWkEnORepdyRwLss3SJ6owbb/zKeRqG1GSCMLTg5FvYPjEGqjr4lM1Jh/qtIa9VPFSIbcvctU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717108143; c=relaxed/simple;
	bh=SujEfHIJ+IAcJHimyI8x8Y47L6eCMAuBqrwtxm9g4t4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RmJNuQBY2bEk6Iv5YIjZkhyfU4xo2EfVXwpf5luxGFA27DOY97IeLW29t0ILqnfkYKU80P0HERHs7bJbpxc2lNvp1W1mB4op3KyhpBJJ0YMOmtF8SbRH9kl8vd4x1xHWDZq+96gHNd35m8+w4Pe2DIZwdOmKGZZz2Gzqni1Zhoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E5pl2QjT; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70234843a67so1004314b3a.1
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 15:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717108141; x=1717712941; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SujEfHIJ+IAcJHimyI8x8Y47L6eCMAuBqrwtxm9g4t4=;
        b=E5pl2QjT6XeGaByyKx1g52TwJejv7Mle3hQbAbIIVfgA3/NmwCGWLtT+jOPAefZqe7
         C7oOv3mHBF7wux9T78P5NPHplXB6ozj1BRILrul7TNkAbdP21zo8yLLSeMCFOLZuqMo8
         VMXZ7epKN5HRWNvNj5SN9Lah01vGQ9IzgL+4g/K8ylH1lbjPo5I8lzlvaU/xpckkt5O8
         lcSYsWtNCKHw0QOF5oPSM2W9lQJ9Tz1+v1K/HuKfF10paYGrfUx1CDwdDwIf0PM3jo0W
         Cc0ao+ZH24i+38mTItZXkgHHWr3pTfAWSzJgmpwkzVlQp5/rRlM1s+mbTHflQ1sJGDo3
         uvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717108141; x=1717712941;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SujEfHIJ+IAcJHimyI8x8Y47L6eCMAuBqrwtxm9g4t4=;
        b=MljmwOPltyziNl24TRk4cC3SrBrAEEG+SFcHhup2BibJY34Op+Qkvs3NG0tt89E2oA
         fiEzB7QTJNX0eE02eYIs4H9aB7RnWNLDuCeSTG5pAJtzAQ50dmhOaoW0hA7Jp5t9eyMG
         K1BBYxUFdYIshgFoxnnvwUFfFx9thMH9TkUIXMG9WshqZRkYKIxQZx+P/DgQ0SRiBEZY
         6AeFem/pa4+1eO07wVGqQ9ueKYlm6dPzaaF3fVb5byCFjnqKtge5IyRMaVlNLz+AnlAK
         oGspZYfQdKZnzj8g7U+h/3hRsTJcmZS3clQCjc4wdms0cBh2L1pdo0C6tVO8sBPGhPzl
         eM8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhkjxU8Q9my1asWBBzkYtUACWZIqgIvASEJZ9USpFpU5J8nBKCx+am8i6HhcoKs/VpgLsi0SYwLFvG1PCI3pFNjpZm
X-Gm-Message-State: AOJu0Yxy8CPiKFKWWZgJza3gPIzkWMXoDRswXo7PGqUKkoO6kP5RmRhl
	tVT3VnXhCW29l6xeUbLN1zu2ujDqB2gzTGzXNfNMjt5L5/53fomTYvhrYxv4HQ4=
X-Google-Smtp-Source: AGHT+IHiG3IoqS6XYzHziaHGZ7QHZB2ubAA5Lfx9rBCHBDlqcK91cXZTSgG4RTcZwGikKa649x4wbw==
X-Received: by 2002:a05:6a00:18a7:b0:6f3:f062:c09b with SMTP id d2e1a72fcca58-702477bbc5cmr164851b3a.6.1717108140909;
        Thu, 30 May 2024 15:29:00 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::e697? ([2604:3d08:9384:1d00::e697])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242b09c71sm233929b3a.181.2024.05.30.15.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 15:29:00 -0700 (PDT)
Message-ID: <b1f82476-1cbf-4e25-84b4-66abfb406b2c@linaro.org>
Date: Thu, 30 May 2024 15:28:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] hw/core: expand on the alignment of CPUState
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Yanan Wang <wangyanan55@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Reinoud Zandijk
 <reinoud@netbsd.org>, kvm@vger.kernel.org,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-2-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240530194250.1801701-2-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNS8zMC8yNCAxMjo0MiwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBNYWtlIHRoZSByZWxh
dGlvbnNoaXAgYmV0d2VlbiBDUFVTdGF0ZSwgQXJjaENQVSBhbmQgY3B1X2VudiBhIGJpdA0K
PiBjbGVhcmVyIGluIHRoZSBrZG9jIGNvbW1lbnRzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
QWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPg0KPiAtLS0NCj4gICBpbmNs
dWRlL2h3L2NvcmUvY3B1LmggfCAxNCArKysrKysrKysrLS0tLQ0KPiAgIDEgZmlsZSBjaGFu
Z2VkLCAxMCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2luY2x1ZGUvaHcvY29yZS9jcHUuaCBiL2luY2x1ZGUvaHcvY29yZS9jcHUuaA0KPiBp
bmRleCBiYjM5OGU4MjM3Li4zNWQzNDUzNzFiIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2h3
L2NvcmUvY3B1LmgNCj4gKysrIGIvaW5jbHVkZS9ody9jb3JlL2NwdS5oDQo+IEBAIC0zOTEs
NyArMzkxLDggQEAgc3RydWN0IHFlbXVfd29ya19pdGVtOw0KPiAgICNkZWZpbmUgQ1BVX1VO
U0VUX05VTUFfTk9ERV9JRCAtMQ0KPiAgIA0KPiAgIC8qKg0KPiAtICogQ1BVU3RhdGU6DQo+
ICsgKiBzdHJ1Y3QgQ1BVU3RhdGUgLSBjb21tb24gc3RhdGUgb2Ygb25lIENQVSBjb3JlIG9y
IHRocmVhZC4NCj4gKyAqDQo+ICAgICogQGNwdV9pbmRleDogQ1BVIGluZGV4IChpbmZvcm1h
dGl2ZSkuDQo+ICAgICogQGNsdXN0ZXJfaW5kZXg6IElkZW50aWZpZXMgd2hpY2ggY2x1c3Rl
ciB0aGlzIENQVSBpcyBpbi4NCj4gICAgKiAgIEZvciBib2FyZHMgd2hpY2ggZG9uJ3QgZGVm
aW5lIGNsdXN0ZXJzIG9yIGZvciAibG9vc2UiIENQVXMgbm90IGFzc2lnbmVkDQo+IEBAIC00
MzksMTAgKzQ0MCwxNSBAQCBzdHJ1Y3QgcWVtdV93b3JrX2l0ZW07DQo+ICAgICogQGt2bV9m
ZXRjaF9pbmRleDogS2VlcHMgdGhlIGluZGV4IHRoYXQgd2UgbGFzdCBmZXRjaGVkIGZyb20g
dGhlIHBlci12Q1BVDQo+ICAgICogICAgZGlydHkgcmluZyBzdHJ1Y3R1cmUuDQo+ICAgICoN
Cj4gLSAqIFN0YXRlIG9mIG9uZSBDUFUgY29yZSBvciB0aHJlYWQuDQo+ICsgKiBAbmVnX2Fs
aWduOiBUaGUgQ1BVU3RhdGUgaXMgdGhlIGNvbW1vbiBwYXJ0IG9mIGEgY29uY3JldGUgQXJj
aENQVQ0KPiArICogd2hpY2ggaXMgYWxsb2NhdGVkIHdoZW4gYW4gaW5kaXZpZHVhbCBDUFUg
aW5zdGFuY2UgaXMgY3JlYXRlZC4gQXMNCj4gKyAqIHN1Y2ggY2FyZSBpcyB0YWtlbiBpcyBl
bnN1cmUgdGhlcmUgaXMgbm8gZ2FwIGJldHdlZW4gYmV0d2Vlbg0KPiArICogQ1BVU3RhdGUg
YW5kIENQVUFyY2hTdGF0ZSB3aXRoaW4gQXJjaENQVS4NCj4gICAgKg0KPiAtICogQWxpZ24s
IGluIG9yZGVyIHRvIG1hdGNoIHBvc3NpYmxlIGFsaWdubWVudCByZXF1aXJlZCBieSBDUFVB
cmNoU3RhdGUsDQo+IC0gKiBhbmQgZWxpbWluYXRlIGEgaG9sZSBiZXR3ZWVuIENQVVN0YXRl
IGFuZCBDUFVBcmNoU3RhdGUgd2l0aGluIEFyY2hDUFUuDQo+ICsgKiBAbmVnOiBUaGUgYXJj
aGl0ZWN0dXJhbCByZWdpc3RlciBzdGF0ZSAoImNwdV9lbnYiKSBpbW1lZGlhdGVseSBmb2xs
b3dzIENQVVN0YXRlDQo+ICsgKiBpbiBBcmNoQ1BVIGFuZCBpcyBwYXNzZWQgdG8gVENHIGNv
ZGUuIFRoZSBAbmVnIHN0cnVjdHVyZSBob2xkcyBzb21lDQo+ICsgKiBjb21tb24gVENHIENQ
VSB2YXJpYWJsZXMgd2hpY2ggYXJlIGFjY2Vzc2VkIHdpdGggYSBuZWdhdGl2ZSBvZmZzZXQN
Cj4gKyAqIGZyb20gY3B1X2Vudi4NCj4gICAgKi8NCj4gICBzdHJ1Y3QgQ1BVU3RhdGUgew0K
PiAgICAgICAvKjwgcHJpdmF0ZSA+Ki8NCg0KUmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZp
ZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCg==

