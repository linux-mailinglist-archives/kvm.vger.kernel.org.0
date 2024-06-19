Return-Path: <kvm+bounces-19990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 701FF90F1B0
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:06:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 777FC1C22A4C
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 15:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5157136664;
	Wed, 19 Jun 2024 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NrnhL1lR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B51C78C65
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718809588; cv=none; b=MAf5ZlrJD7LAq5Xas9qwMKHkgRqUx0rhfcD6NuQf7vT1oRDIbe779xFVAOOShtRmVteBDuAvD+d3KG/nyaAW1XIlUj9LE0F0MkDHm18BZHFx/uuPnA3dxF3ddoLZQ7TgYA6yL42MfJ9N18pjRq66KnFehlcB9nAAazBt+W61dZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718809588; c=relaxed/simple;
	bh=53ccK+CjnnoeqgwrzL2MP2JpY9KmQHqgB9vFIPTJVYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ao6kyAGU7NwgSfhPpBN4Vb3oZOOrEN93N+trnB9bZ6ARZ8o4eld+TMjgomLlS8dRAgWmDBhvwTsRmEKmJ9pqUP94TbxMVvhI0fsfddx1xCB7mIE1H+fm2IOvvV8m9NXpB08CLP2I2Ya+xWeb9wbFb3wZetF5eTP04MoMFVRPvso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NrnhL1lR; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f862f7c7edso45678885ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 08:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718809586; x=1719414386; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=53ccK+CjnnoeqgwrzL2MP2JpY9KmQHqgB9vFIPTJVYc=;
        b=NrnhL1lRSX4LcdabmqisYtoP/lWkUHlZR/nePKySFGfd7BDtX3J8V0i5+QfA9XRF8P
         8EolXI8E9MVH0nYRUP8IUxIYtOBFVgNMvzMNYl0hU6zuFUhzl9kg5Z3Lv9+aWeN8nH8s
         MThWgBWT2+2bo5F0PeRNP+sg6sFce9cJr4sEhi6ymvMYGSPuhSjcvPWRHbD3L/JIoKzX
         NZM8BPo0Fdon6baEiK1QVHfQ4uKaakhTWkqj/Ss8ejw1yhbe4H+SJWg1d1wYHXMBWYjQ
         nBGmSnqvEgdY/UEdawZUzY1mtOWGGVYy4cWcxZf3m3CSZqhw/WWQCn3nIR2326C+aIEv
         c8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718809586; x=1719414386;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=53ccK+CjnnoeqgwrzL2MP2JpY9KmQHqgB9vFIPTJVYc=;
        b=bmOG8846EPzfe9RSgPs90lA/VkIp4GtDPY7l2f2/yVYeG26CIGVy+rOfLTmnGVPRyB
         LFfwlFOfZ1855BK5y8X2zWtibDjo7ZiiDsXb6HR+4FcrEI2ZsxI9MNRpqLDhxQIz8D5k
         o0xomyeSOBK8IrmQ8Pm59zE5xnbBSI3WxijrYD7gNuhLfBL17LX8ne9TPBiSax+gwRnD
         yA2DnqbJDxuYOqAJuWanxidG7k3z0kwgLEkZZToNrb3Zf+5EkCvB5dFmecHt1o1WfenQ
         WNUTdSBINSH5xy0svhEJyBmXNO/RngAAVn1BQWveeULcXAWpTaJ6d9C0fnCXQDcRRykA
         jKqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWc8nxbTm1FFR8qqtrSDF+dxKOzlKFn2yRV0eiEZ1x86cdqSlp6Dp72NVD1k8L3GxffxxMFYOxVAcTL0iac2ta/e6E2
X-Gm-Message-State: AOJu0YwxO15t9oUgvQECMRciRdbNpiaSBlSeAW437iLAkDAs1eLhU9fF
	qxovE4TDxJiG44DNfW0wHymTU6B2N1N/EKoa14WQcDQ24k6UVIJSHMI9Lx75HiQ=
X-Google-Smtp-Source: AGHT+IEKSMPfsUN7rJwC84JD0vEhzz1T9Cqgy0kPSP6eSjrW7wTRT3cMKKmdmSZQ03B2BtAQgWO1yg==
X-Received: by 2002:a17:902:dac6:b0:1f7:ff:b477 with SMTP id d9443c01a7336-1f9aa44fc25mr23739125ad.55.1718809583896;
        Wed, 19 Jun 2024 08:06:23 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::2193? ([2604:3d08:9384:1d00::2193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55e48sm118123385ad.37.2024.06.19.08.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 08:06:23 -0700 (PDT)
Message-ID: <b2975c54-2752-4375-a5ad-13a21f8dde14@linaro.org>
Date: Wed, 19 Jun 2024 08:06:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] contrib/plugins: add ips plugin example for cost
 modeling
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>, qemu-devel@nongnu.org,
 David Hildenbrand <david@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Burton <mburton@qti.qualcomm.com>, qemu-s390x@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Laurent Vivier <lvivier@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Alexandre Iooss <erdnaxe@crans.org>, qemu-arm@nongnu.org,
 Alexander Graf <agraf@csgraf.de>, Nicholas Piggin <npiggin@gmail.com>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, qemu-ppc@nongnu.org,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Cameron Esfahani <dirty@apple.com>,
 Jamie Iles <quic_jiles@quicinc.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-10-alex.bennee@linaro.org>
 <ZmoM2Sac97PdXWcC@gallifrey>
 <777e1b13-9a4f-4c32-9ff7-9cedf7417695@linaro.org>
 <Zmy9g1U1uP1Vhx9N@gallifrey>
 <616df287-a167-4a05-8f08-70a78a544929@linaro.org>
 <ZnCi4hcyR8wMMnK4@gallifrey>
 <4e5fded0-d1a9-4494-a66d-6488ce1bcb33@linaro.org>
 <874j9qefv0.fsf@draig.linaro.org>
 <78003bee-08f7-4860-a675-b09721955e60@linaro.org>
 <87jzilcleh.fsf@draig.linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <87jzilcleh.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xOS8yNCAwMjo0OSwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBQaWVycmljayBCb3V2
aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+IHdyaXRlczoNCj4gDQo+PiBPbiA2
LzE4LzI0IDAyOjUzLCBBbGV4IEJlbm7DqWUgd3JvdGU6DQo+Pj4gUGllcnJpY2sgQm91dmll
ciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPiB3cml0ZXM6DQo+Pj4NCj4+Pj4gT24g
Ni8xNy8yNCAxMzo1NiwgRHIuIERhdmlkIEFsYW4gR2lsYmVydCB3cm90ZToNCj4+Pj4+ICog
UGllcnJpY2sgQm91dmllciAocGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnKSB3cm90ZToN
Cj4+Pj4+PiBPbiA2LzE0LzI0IDE1OjAwLCBEci4gRGF2aWQgQWxhbiBHaWxiZXJ0IHdyb3Rl
Og0KPj4+Pj4+PiAqIFBpZXJyaWNrIEJvdXZpZXIgKHBpZXJyaWNrLmJvdXZpZXJAbGluYXJv
Lm9yZykgd3JvdGU6DQo+Pj4+Pj4+PiBIaSBEYXZlLA0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+IE9u
IDYvMTIvMjQgMTQ6MDIsIERyLiBEYXZpZCBBbGFuIEdpbGJlcnQgd3JvdGU6DQo+Pj4+Pj4+
Pj4gKiBBbGV4IEJlbm7DqWUgKGFsZXguYmVubmVlQGxpbmFyby5vcmcpIHdyb3RlOg0KPj4+
Pj4+Pj4+PiBGcm9tOiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFy
by5vcmc+DQo+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+IFRoaXMgcGx1Z2luIHVzZXMgdGhlIG5l
dyB0aW1lIGNvbnRyb2wgaW50ZXJmYWNlIHRvIG1ha2UgZGVjaXNpb25zDQo+Pj4+Pj4+Pj4+
IGFib3V0IHRoZSBzdGF0ZSBvZiB0aW1lIGR1cmluZyB0aGUgZW11bGF0aW9uLiBUaGUgYWxn
b3JpdGhtIGlzDQo+Pj4+Pj4+Pj4+IGN1cnJlbnRseSB2ZXJ5IHNpbXBsZS4gVGhlIHVzZXIg
c3BlY2lmaWVzIGFuIGlwcyByYXRlIHdoaWNoIGFwcGxpZXMNCj4+Pj4+Pj4+Pj4gcGVyIGNv
cmUuIElmIHRoZSBjb3JlIHJ1bnMgYWhlYWQgb2YgaXRzIGFsbG9jYXRlZCBleGVjdXRpb24g
dGltZSB0aGUNCj4+Pj4+Pj4+Pj4gcGx1Z2luIHNsZWVwcyBmb3IgYSBiaXQgdG8gbGV0IHJl
YWwgdGltZSBjYXRjaCB1cC4gRWl0aGVyIHdheSB0aW1lIGlzDQo+Pj4+Pj4+Pj4+IHVwZGF0
ZWQgZm9yIHRoZSBlbXVsYXRpb24gYXMgYSBmdW5jdGlvbiBvZiB0b3RhbCBleGVjdXRlZCBp
bnN0cnVjdGlvbnMNCj4+Pj4+Pj4+Pj4gd2l0aCBzb21lIGFkanVzdG1lbnRzIGZvciBjb3Jl
cyB0aGF0IGlkbGUuDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBBIGZldyByYW5kb20gdGhvdWdo
dHM6DQo+Pj4+Pj4+Pj4gICAgICAgIGEpIEFyZSB0aGVyZSBhbnkgZGVmaW5pdGlvbnMgb2Yg
d2hhdCBhIHBsdWdpbiB0aGF0IGNvbnRyb2xzIHRpbWUNCj4+Pj4+Pj4+PiAgICAgICAgICAg
c2hvdWxkIGRvIHdpdGggYSBsaXZlIG1pZ3JhdGlvbj8NCj4+Pj4+Pj4+DQo+Pj4+Pj4+PiBJ
dCdzIG5vdCBzb21ldGhpbmcgdGhhdCB3YXMgY29uc2lkZXJlZCBhcyBwYXJ0IG9mIHRoaXMg
d29yay4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gVGhhdCdzIE9LLCB0aGUgb25seSB0aGluZyBpcyB3
ZSBuZWVkIHRvIHN0b3AgYW55b25lIGZyb20gaGl0dGluZyBwcm9ibGVtcw0KPj4+Pj4+PiB3
aGVuIHRoZXkgZG9uJ3QgcmVhbGlzZSBpdCdzIG5vdCBiZWVuIGFkZHJlc3NlZC4NCj4+Pj4+
Pj4gT25lIHdheSBtaWdodCBiZSB0byBhZGQgYSBtaWdyYXRpb24gYmxvY2tlcjsgc2VlIGlu
Y2x1ZGUvbWlncmF0aW9uL2Jsb2NrZXIuaA0KPj4+Pj4+PiB0aGVuIHlvdSBtaWdodCBwcmlu
dCBzb21ldGhpbmcgbGlrZSAnTWlncmF0aW9uIG5vdCBhdmFpbGFibGUgZHVlIHRvIHBsdWdp
biAuLi4uJw0KPj4+Pj4+Pg0KPj4+Pj4+DQo+Pj4+Pj4gU28gYmFzaWNhbGx5LCB3ZSBjb3Vs
ZCBtYWtlIGEgY2FsbCB0byBtaWdyYXRlX2FkZF9ibG9ja2VyKCksIHdoZW4gc29tZW9uZQ0K
Pj4+Pj4+IHJlcXVlc3QgdGltZV9jb250cm9sIHRocm91Z2ggcGx1Z2luIEFQST8NCj4+Pj4+
Pg0KPj4+Pj4+IElNSE8sIGl0J3Mgc29tZXRoaW5nIHRoYXQgc2hvdWxkIGJlIHBhcnQgb2Yg
cGx1Z2luIEFQSSAoaWYgYW55IHBsdWdpbiBjYWxscw0KPj4+Pj4+IHFlbXVfcGx1Z2luX3Jl
cXVlc3RfdGltZV9jb250cm9sKCkpLCBpbnN0ZWFkIG9mIHRoZSBwbHVnaW4gY29kZSBpdHNl
bGYuIFRoaXMNCj4+Pj4+PiB3YXksIGFueSBwbHVnaW4gZ2V0dGluZyB0aW1lIGNvbnRyb2wg
YXV0b21hdGljYWxseSBibG9ja3MgYW55IHBvdGVudGlhbA0KPj4+Pj4+IG1pZ3JhdGlvbi4N
Cj4+Pj4+IE5vdGUgbXkgcXVlc3Rpb24gYXNrZWQgZm9yIGEgJ2FueSBkZWZpbml0aW9ucyBv
ZiB3aGF0IGEgcGx1Z2luIC4uJyAtDQo+Pj4+PiBzbw0KPj4+Pj4geW91IGNvdWxkIGRlZmlu
ZSBpdCB0aGF0IHdheSwgYW5vdGhlciBvbmUgaXMgdG8gdGhpbmsgdGhhdCBpbiB0aGUgZnV0
dXJlDQo+Pj4+PiB5b3UgbWF5IGFsbG93IGl0IGFuZCB0aGUgcGx1Z2luIHNvbWVob3cgaW50
ZXJhY3RzIHdpdGggbWlncmF0aW9uIG5vdCB0bw0KPj4+Pj4gY2hhbmdlIHRpbWUgYXQgY2Vy
dGFpbiBtaWdyYXRpb24gcGhhc2VzLg0KPj4+Pj4NCj4+Pj4NCj4+Pj4gSSB3b3VsZCBiZSBp
biBmYXZvciB0byBmb3JiaWQgdXNhZ2UgZm9yIG5vdyBpbiB0aGlzIGNvbnRleHQuIEknbSBu
b3QNCj4+Pj4gc3VyZSB3aHkgcGVvcGxlIHdvdWxkIHBsYXkgd2l0aCBtaWdyYXRpb24gYW5k
IHBsdWdpbnMgZ2VuZXJhbGx5IGF0DQo+Pj4+IHRoaXMgdGltZSAodGhlcmUgbWlnaHQgYmUg
ZXhwZXJpbWVudHMgb3IgdXNlIGNhc2VzIEknbSBub3QgYXdhcmUgb2YpLA0KPj4+PiBzbyBh
IHNpbXBsZSBiYXJyaWVyIHByZXZlbnRpbmcgdGhhdCBzZWVtcyBvay4NCj4+Pj4NCj4+Pj4g
VGhpcyBwbHVnaW4gaXMgcGFydCBvZiBhbiBleHBlcmltZW50IHdoZXJlIHdlIGltcGxlbWVu
dCBhIHFlbXUgZmVhdHVyZQ0KPj4+PiAoaWNvdW50PWF1dG8gaW4gdGhpcyBjYXNlKSBieSB1
c2luZyBwbHVnaW5zLiBJZiBpdCB0dXJucyBpbnRvIGENCj4+Pj4gc3VjY2Vzc2Z1bCB1c2Fn
ZSBhbmQgdGhpcyBwbHVnaW4gYmVjb21lcyBwb3B1bGFyLCB3ZSBjYW4gYWx3YXlzIGxpZnQN
Cj4+Pj4gdGhlIGxpbWl0YXRpb24gbGF0ZXIuDQo+Pj4+DQo+Pj4+IEBBbGV4LCB3b3VsZCB5
b3UgbGlrZSB0byBhZGQgdGhpcyBub3cgKGljb3VudD1hdXRvIGlzIHN0aWxsIG5vdA0KPj4+
PiByZW1vdmVkIGZyb20gcWVtdSksIG9yIHdhaXQgZm9yIGludGVncmF0aW9uLCBhbmQgYWRk
IHRoaXMgYXMgYW5vdGhlcg0KPj4+PiBwYXRjaD8NCj4+PiBJIHRoaW5rIHdlIGZvbGxvdyB0
aGUgZGVwcmVjYXRpb24gcHJvY2VzcyBzbyBvbmNlIGludGVncmF0ZWQgd2UgcG9zdA0KPj4+
IGENCj4+PiBkZXByZWNhdGlvbiBub3RpY2UgaW46DQo+Pj4gICAgIGh0dHBzOi8vcWVtdS5y
ZWFkdGhlZG9jcy5pby9lbi9tYXN0ZXIvYWJvdXQvZGVwcmVjYXRlZC5odG1sDQo+Pj4gYW5k
IHRoZW4gcmVtb3ZlIGl0IGFmdGVyIGEgY291cGxlIG9mIHJlbGVhc2VzLg0KPj4+DQo+Pg0K
Pj4gU29ycnksIEkgd2FzIG5vdCBjbGVhci4gSSBtZWFudCBkbyB3ZSBhZGQgYSBibG9ja2Vy
IGluIGNhc2Ugc29tZW9uZQ0KPj4gdHJpZXMgdG8gbWlncmF0ZSBhIHZtIHdoaWxlIHRoaXMg
cGx1Z2luIGlzIHVzZWQ/DQo+IA0KPiBPaCB5ZXMgLSBJIGNhbiBhZGQgdGhhdCBpbiB0aGUg
Y29yZSBwbHVnaW4gY29kZS4NCj4gDQoNClRoYW5rcyENCg==

