Return-Path: <kvm+bounces-40775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D56A5C55C
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9590F3B5F2C
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1250725D8EB;
	Tue, 11 Mar 2025 15:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xcczenKU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D6225E831
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705850; cv=none; b=WBaS1Pfr5N/KhwP6/34jkxfJ8HRjx1Q4fhRutm9GYa/IJgAIl976qAIcOzyHfREk9l7CrkRCytX4CFDKRzKivM4RT9VNLkQyR2j1ddco5HeVjOii4RJGJW6t+WUN3RHLHhbDG+/VcUdyolbuLMSt8qzVP3LvuFZ78HlgWjcr19s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705850; c=relaxed/simple;
	bh=cQwJl5AaMpNuj13k4T9FN6aD7KIBuzBDEK+lwo9Ext8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ttg9JfAvF2n09hL0UzkjTC9zGnuf74P45gMuf8XSrN4FVdKFQb/6L4jbmKhod44hHVxyJpi15321PKecV6cHgLqXfIXpBAnMEYZ8MXg3JuPIstO69G3bZ7eIOufwykiVVd7L0whcfi4n2bF8oE+QEwrOMl7VnluDZ+EBU52Cfog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xcczenKU; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2239aa5da08so91952145ad.3
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741705848; x=1742310648; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cQwJl5AaMpNuj13k4T9FN6aD7KIBuzBDEK+lwo9Ext8=;
        b=xcczenKUn2TdLEmMPGbVgjlnOE+XzpwxDjrmPdwEG4cAl1unszr1I9kqQwW4BiLKl1
         e0fJod4U9dIYNEnAHek66Qmt/dC5T2+P3jXNIrjxIi9OgrVvjwVKSpWgDI8TJd3c4Fxu
         kCpE/4y1OcD73zDTgWkL1ZUchy/V/ppX9fMosCT6/5mlatbwT0h66oQVee47WJuHLqu0
         bNjNoe4VkpnrmEljLjeBVdDBjHmxcZsvzOi7rm6G96KZFtaTwkSfvkr5AiRnti/U2lbx
         hmDKR+28Fy02RchHoOJnUQrX+ZBG60eYb6mNUpU9st0gEWCDQA4iX16Z1bCJXmr9TtdK
         Lf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741705848; x=1742310648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cQwJl5AaMpNuj13k4T9FN6aD7KIBuzBDEK+lwo9Ext8=;
        b=WjhYy1ek9TdyrtsM6LmG1snFGdldCfYpQmNQoZWc8H9jVwVufBt8mU9g7Pz9Uiil2O
         oirCX02nKINf9k45OM2RqrUGKpNRJTswI4MnoUOM8H1nsmZnBkeWjYod3TpbK+ye+uoA
         l2bSHnhQDr48AvjcOtKedPY3EJkf1IhTplqoxI3PTemASNexkyAvay/J5yyO7M0xx1jq
         9cne/njfJdl6yyBtop2F5PoMbs3xjFRwejjRR4T3Anx8QJwTt0YAV/1YMYRJARUICowm
         ANbNzKGPP9SgsN2FpFxrtv6/CGbQnSn911ekNzl8y3BKfvDZbR8yJltdqH21edi/3h4M
         zGtA==
X-Forwarded-Encrypted: i=1; AJvYcCWnuAJHxVP2w1SdxRzSOdmbEWk9NQvIh0u68HYOIePoYLFIV4G3u6YTIeeR9O6I1lohH2c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUEYZNQ8Mw2jh0QLAjGiiZcD9V0QDcrvXCf8hMRsQCW2YA5bzM
	XU6mpo5n676LbynlKwfy0Bv5biIfDZKVMb18p8Y00s1txt7VW7KoOMfJW+YpzVc=
X-Gm-Gg: ASbGncsfQW9jueGl1Gectl4M1UeuYy6tbdp7RB+Ju6BujzA98aqU6fRn8td6y0kAjuP
	V5VnW5MoZ1VDO0NcHYeJhRPezBvvLZAoGE9ZK7t8D/qMMSFrSSFQ8KTXH3N74QT3iExJwZy71zi
	qZxvNZ7xMZRX8RCPdVlR4EKyhYrCVcbm6P27dyJpF+unzu9VcGZR02a9FWBjrC9r5BX4qDzwdVG
	RCsNwCnAzkS+rf/p0khDOA15zWk0U2N/VsSM1Ntiyv/XzkqSqmLVtUdPmaxbLtTAw9LiXMZVFUR
	fc7kD+Hev+hWOpoKVeXpEpJSTSvJmR4HtJu+fMKEfQUjFkIM3mydHBBx8g==
X-Google-Smtp-Source: AGHT+IEITMrsbR3vHiF3IG5H7RZJtH9+eCZYnI84EngoCoPfv0vimXTB3AzAhTXNWBOwPqkcAjXLsA==
X-Received: by 2002:a05:6a20:7fa1:b0:1ee:dd60:194f with SMTP id adf61e73a8af0-1f544c378b7mr26705105637.26.1741705847979;
        Tue, 11 Mar 2025 08:10:47 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28126d69bsm9585406a12.51.2025.03.11.08.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 08:10:47 -0700 (PDT)
Message-ID: <9706a688-b466-40ca-a6b8-0221b11f749c@linaro.org>
Date: Tue, 11 Mar 2025 08:10:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/16] exec/exec-all: remove dependency on cpu.h
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 xen-devel@lists.xenproject.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Anthony PERARD <anthony@xenproject.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
 <20250311040838.3937136-8-pierrick.bouvier@linaro.org>
 <f0c7b0ff-a43a-4203-aba1-2e06a462771e@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <f0c7b0ff-a43a-4203-aba1-2e06a462771e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xMS8yNSAwMDoyNiwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDExLzMvMjUgMDU6MDgsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBSZXZpZXdlZC1i
eTogUmljaGFyZCBIZW5kZXJzb24gPHJpY2hhcmQuaGVuZGVyc29uQGxpbmFyby5vcmc+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxp
bmFyby5vcmc+DQo+IA0KPiBNaXNzaW5nIHRoZSAid2h5IiBqdXN0aWZpY2F0aW9uIHdlIGNv
dWxkbid0IGRvIHRoYXQgYmVmb3JlLg0KPiANCj4+IC0tLQ0KPj4gICAgaW5jbHVkZS9leGVj
L2V4ZWMtYWxsLmggfCAxIC0NCj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0p
DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvZXhlYy9leGVjLWFsbC5oIGIvaW5jbHVk
ZS9leGVjL2V4ZWMtYWxsLmgNCj4+IGluZGV4IGRkNWM0MGYyMjMzLi4xOWIwZWRhNDRhNyAx
MDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvZXhlYy9leGVjLWFsbC5oDQo+PiArKysgYi9pbmNs
dWRlL2V4ZWMvZXhlYy1hbGwuaA0KPj4gQEAgLTIwLDcgKzIwLDYgQEANCj4+ICAgICNpZm5k
ZWYgRVhFQ19BTExfSA0KPj4gICAgI2RlZmluZSBFWEVDX0FMTF9IDQo+PiAgICANCj4+IC0j
aW5jbHVkZSAiY3B1LmgiDQo+PiAgICAjaWYgZGVmaW5lZChDT05GSUdfVVNFUl9PTkxZKQ0K
Pj4gICAgI2luY2x1ZGUgImV4ZWMvY3B1X2xkc3QuaCINCj4+ICAgICNlbmRpZg0KPiANCg0K
UHJldmlvdXMgY29tbWl0IGlzIG5hbWVkOg0KY29kZWJhc2U6IHByZXBhcmUgdG8gcmVtb3Zl
IGNwdS5oIGZyb20gZXhlYy9leGVjLWFsbC5oDQpTbyBiZWZvcmUgdGhvc2UgY2hhbmdlcywg
aXQncyBub3QgcG9zc2libGUuDQoNCkkgY2FuIHJlcGVhdCB0aGF0IGhlcmUsIG9yIHNxdWFz
aCB0aGUgcGF0Y2hlcyB0b2dldGhlciwgYXMgeW91IHByZWZlci4NCg==

