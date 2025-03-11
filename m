Return-Path: <kvm+bounces-40776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C909CA5C5B0
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 641CE3B21C6
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD1C25E807;
	Tue, 11 Mar 2025 15:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TnplqAjd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D87725D8F9
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706030; cv=none; b=il+D5bQ5MlyicjKG04jTzpPw50jQMIZxsXzqmgCm/EXgBOqJvMve97wderWjrjiXxV+nS1H8GRRtZ/BKtWJjHJqda1BmoEbfRrsmDd8BvGqJzVABWNRjSoUyGIU2mcI8CDxhVW0LbrWfgoDjLI7dZw17Feunw/4uhtSBRJqauwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706030; c=relaxed/simple;
	bh=86STdfu7sbDSkiwCii3eDdimSERy6/v6Vuyj4krzCSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GKfUMAIbvmKc7m002D9J/FGScHJ8HgXX+SRULXr1p+DUsAqMLJHDRBdl+XaoOgoHMBhyHGs/rvvKqSYGumedat6ZfWoqwAyVH3Dh4QfBx2AtxPV8fZil9VwebsyKniHmX6aY8p/hNSOsDdxCG6B64bY5+3KPtpqgOGDm170L9Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TnplqAjd; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22401f4d35aso100406785ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741706028; x=1742310828; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=86STdfu7sbDSkiwCii3eDdimSERy6/v6Vuyj4krzCSs=;
        b=TnplqAjda+I+a0z9VWTxXKFwK2O2Eaa6X5zn1Aj+lgpTE124T5aQyf1VpCMPGMlLK+
         Z5hmT+TObV5anSP3ZxOOtQseAGvALB8tJrurjw4YjUZwLabeQ4R21B+BriG33eKBGPRl
         IXQwC5ATvwf+vXBAvDgc9BeHlTkqoSIlEYkwVxBOauiyUK6sk5gCA7mIdOs1P1IgdTrU
         aSvrJuSMqveuNCLtEZCOPSYSWbZIEaKzDL0BdKedfWP1SpfGJmQMq8PqFbFdASknriSX
         vbRCYPWJFEx1kqwMHt7MOumxugXmoX7T0vHyk7osq5mXPFA69KU9TOcJR2VK+H8saa04
         pCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741706028; x=1742310828;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=86STdfu7sbDSkiwCii3eDdimSERy6/v6Vuyj4krzCSs=;
        b=WtpcextB6aJsYM7jXk1lDxdQMY2m1wRZU12rmxUnTtQi1cvSUzvDd0O9Xgipy39xjW
         JdEdHB211r7suPmqNPJS6Tp/Tyng0plRQ/j9BOleWN96mCv8mc8H0pmomOuf75RzIZFA
         CeCivc0UkKn+APGMjXgSUWqh+SdQILTGjDoSmxjTFVvGpsEhjFKrztewnYQSD2peq0tl
         QYR0eFVf6M2QD+VFPR763PgOxYhxz8rUeH6b3JOjtrThnzKh5UThadYoLNOJ7rRz/U/F
         zv2SdLC1ER5WcrV+9j+e+d/eXkao0J+5U+O0lcf9fWRCRaAOuWxo18gh7RHsGTuTgGa0
         HtQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQsT4SIR5CbxRKKUaR4tcHk4Y+3bezlNUAPNXfYd15ffIdMv7xENUzc07FChjNSUmf9ps=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBnoWXQ8yH+perquv6gKsnBoSB4iMkESZ6rP3+G5HXkiTz4I78
	GLYfOZeuLKokdCaDIG4rVJoi5xxIPNy4Xh/s4vzqvT251PoSGRkOIgindUTg2Ts=
X-Gm-Gg: ASbGncss1s591///PgQEAgzSHbdKShRdEfV9BSNgxoTwZ73mvTCzL7GZxjxNpIDrgf0
	0xEdGqg6pPDtyCWXq3RM0L3JW07mziYP9Dc1OOA0DB3OefUMAoqTGhC358L5sqPn3CqV735sR4C
	b0vHo6cTvqZqFjl1ae507JqfliEUZky2qrBuUSmN65s4oWPr08Y29Pgv8sBvm5OtOXQcjtgjiS1
	7BuzpGf4kMVg24G6uyGCQ9R/Prwb2lTH/gxnyGaVV6Q9dE9CiQyX5kQdDGZfWNhovr040NBkNlc
	QrDTxc1Z1bab99xOMqdrSBKuDtSRjpf1qlMCR3GgAwCTmRsmcTYYAzX//A==
X-Google-Smtp-Source: AGHT+IEZ5MBTaCdyWT08MqOAa8+LxkV8QowtXuqs/UZhCfCdiX14jnvavHT21U00/SV+pE0VLr2heQ==
X-Received: by 2002:a05:6a00:10d5:b0:736:47a5:e268 with SMTP id d2e1a72fcca58-736eb7b363bmr5355533b3a.1.1741706027670;
        Tue, 11 Mar 2025 08:13:47 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736cb466a6csm5505816b3a.165.2025.03.11.08.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 08:13:47 -0700 (PDT)
Message-ID: <72e938d4-fb4e-4be4-9a34-7b0321ee2554@linaro.org>
Date: Tue, 11 Mar 2025 08:13:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/16] exec/memory-internal: remove dependency on cpu.h
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
 <20250311040838.3937136-9-pierrick.bouvier@linaro.org>
 <9f92a783-3826-4a06-9944-0e0ec5faccc9@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <9f92a783-3826-4a06-9944-0e0ec5faccc9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xMS8yNSAwMDoyNiwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDExLzMvMjUgMDU6MDgsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBSZXZpZXdlZC1i
eTogUmljaGFyZCBIZW5kZXJzb24gPHJpY2hhcmQuaGVuZGVyc29uQGxpbmFyby5vcmc+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxp
bmFyby5vcmc+DQo+IA0KPiBNaXNzaW5nIHRoZSAid2h5IiBqdXN0aWZpY2F0aW9uIHdlIGNv
dWxkbid0IGRvIHRoYXQgYmVmb3JlLg0KPiANCj4+IC0tLQ0KPj4gICAgaW5jbHVkZS9leGVj
L21lbW9yeS1pbnRlcm5hbC5oIHwgMiAtLQ0KPj4gICAgMSBmaWxlIGNoYW5nZWQsIDIgZGVs
ZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvZXhlYy9tZW1vcnktaW50
ZXJuYWwuaCBiL2luY2x1ZGUvZXhlYy9tZW1vcnktaW50ZXJuYWwuaA0KPj4gaW5kZXggMTAw
YzEyMzdhYzIuLmI3MjlmM2IyNWFkIDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9leGVjL21l
bW9yeS1pbnRlcm5hbC5oDQo+PiArKysgYi9pbmNsdWRlL2V4ZWMvbWVtb3J5LWludGVybmFs
LmgNCj4+IEBAIC0yMCw4ICsyMCw2IEBADQo+PiAgICAjaWZuZGVmIE1FTU9SWV9JTlRFUk5B
TF9IDQo+PiAgICAjZGVmaW5lIE1FTU9SWV9JTlRFUk5BTF9IDQo+PiAgICANCj4+IC0jaW5j
bHVkZSAiY3B1LmgiDQo+PiAtDQo+PiAgICAjaWZuZGVmIENPTkZJR19VU0VSX09OTFkNCj4+
ICAgIHN0YXRpYyBpbmxpbmUgQWRkcmVzc1NwYWNlRGlzcGF0Y2ggKmZsYXR2aWV3X3RvX2Rp
c3BhdGNoKEZsYXRWaWV3ICpmdikNCj4+ICAgIHsNCj4gDQoNCk5vIGRpcmVjdCBkZXBlbmRl
bmN5LCBidXQgd2hlbiBhIGNvbW1vbiBjb2RlIHdpbGwgaW5jbHVkZSB0aGF0IChsaWtlIA0K
c3lzdGVtL21lbW9yeS5jKSwgd2UgY2FuJ3QgaGF2ZSBhIGRlcGVuZGVuY3kgb24gY3B1Lmgg
YW55bW9yZS4NCkkgY2FuIHJlb3JkZXIgb3Igc3F1YXNoIGNvbW1pdHMgaWYgeW91IHByZWZl
ci4NCg==

