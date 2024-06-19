Return-Path: <kvm+bounces-19918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A44DD90E262
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 06:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12117B227E1
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 04:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50AB41746;
	Wed, 19 Jun 2024 04:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iEsZ2iDv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E90B3DB89
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718772046; cv=none; b=N/g53U6LMeJ0S83zv/Za1YNe3E2pk4yl0cBWaX4NKbH12dCccDIZfn9G15s3xGnchAO0UswkSFhWZO7MShiGfgR55lPH160UO00WEIS5/6A8KaNrrBXYSxmBixZr/Y5ruvhbL5Yiv/umBBqfjQzXJkaAjmtWi9znnd8d3FTOrLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718772046; c=relaxed/simple;
	bh=g4BmsQ1QJzxyLe7NE6YfkwAvTr4YTIzX0Wng0BIcdls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ROQ2JC4MDlmkilqB5eGCmcLNM9rusP44wdKSvUc9YvK7q3MlSTY7Dqv2srwvMfZ5UjtVliGqTU/aKN6fObmuOGVLEaTBbNS/xvNsVHExwtP4QspRYUtjKqU64DlbsFPtmHj7gMe9JyJz+rLm1Cu5fBuENAZ40tSBP8mq8vkbAWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iEsZ2iDv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f9885d5c04so17264165ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 21:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718772044; x=1719376844; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g4BmsQ1QJzxyLe7NE6YfkwAvTr4YTIzX0Wng0BIcdls=;
        b=iEsZ2iDvZtlcP5O2v5b/70h6n3AcYTH23hkR6YdoscpVWmPKNtP0/M8wcoGCkJA3GE
         HoOCzj/Kd2eQrkZ9RODjzR1/DkmbTJ3J/3Xy3U37VkeaWNvl0ewYQs4yaIdpDH4g0N7P
         zRxXrSQYoaPpjc5O0UD/QrxHn6ySuXBfyF5CdB7dxH3H7M7dktbRvAfJiod5HQ2/drVm
         UfxupSnt3uSSnf6iCtf0ALKiYN+tZulJl2Cb/di2ZHHbCAfnURK16XPxOEQsMv8qW1Oh
         30hkZv0+xAv1KxFV0GUlHLBFWwOG4X14zURlAusvie+ERKN1FOHCxtGiFyMnVevxouVy
         tpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718772044; x=1719376844;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g4BmsQ1QJzxyLe7NE6YfkwAvTr4YTIzX0Wng0BIcdls=;
        b=LkPXpb17CbFJ9o+A7N5PfeOER4W2B/J82tZO+j/wWVvsPhirhzyYfe7YpV7jH1rzkm
         pZwMThVNTLsTAhobJZLRL5qi9f9yVZHUcw7XHK2LpxqZE9D9iO7ZXHjrplhYdeNY4Fww
         PNkLfSTqoMd+XiJ2pZNN8/T4yfnDoLQGJnq0KVmdgydmnDwCIwKYga3wrtXCbvjqTVkd
         d1ttpzPxm13yvbox5ED8rxHLz6KIQFL1l7dgz3bS/uUTMX4CaZ2DpU5o/0bRig61M9Dq
         vsEaEmA6zx9qDGox6nWUIHlEWJpd4W5x4rFpc4eCaXQTqm7z0FV1wpefTs4p/uULBkwo
         cvvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPeNUZvIsjul7jXSUtooaMp0pP4/rp/mpNuOWIRqkizO0+H9GLP8x8v8iPRV96i1f27wQutWKJGE+k0rfhAlQfzx4B
X-Gm-Message-State: AOJu0Yz7rNA4kw47umRv8oF0sPnLWUZyUvNlTCgElhIXNZj8MOEafjy7
	GbSTx5u/k98dSaIBsQwgKBGcftkFCWVDwdnmNehjU48Qr64EibzqG9OFh/mlSMw=
X-Google-Smtp-Source: AGHT+IHFfqYIDFPB2Pn70eKtMLfzZPDMlN9O6iloy8dsexph+5biJsZB7KaVhUQUSQGsB2WaUEO6cQ==
X-Received: by 2002:a17:902:a585:b0:1f6:343f:dc4d with SMTP id d9443c01a7336-1f9aa462941mr15179015ad.49.1718772044195;
        Tue, 18 Jun 2024 21:40:44 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::2193? ([2604:3d08:9384:1d00::2193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f98fd829adsm23772835ad.231.2024.06.18.21.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 21:40:43 -0700 (PDT)
Message-ID: <78003bee-08f7-4860-a675-b09721955e60@linaro.org>
Date: Tue, 18 Jun 2024 21:40:32 -0700
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
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <874j9qefv0.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xOC8yNCAwMjo1MywgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBQaWVycmljayBCb3V2
aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+IHdyaXRlczoNCj4gDQo+PiBPbiA2
LzE3LzI0IDEzOjU2LCBEci4gRGF2aWQgQWxhbiBHaWxiZXJ0IHdyb3RlOg0KPj4+ICogUGll
cnJpY2sgQm91dmllciAocGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnKSB3cm90ZToNCj4+
Pj4gT24gNi8xNC8yNCAxNTowMCwgRHIuIERhdmlkIEFsYW4gR2lsYmVydCB3cm90ZToNCj4+
Pj4+ICogUGllcnJpY2sgQm91dmllciAocGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnKSB3
cm90ZToNCj4+Pj4+PiBIaSBEYXZlLA0KPj4+Pj4+DQo+Pj4+Pj4gT24gNi8xMi8yNCAxNDow
MiwgRHIuIERhdmlkIEFsYW4gR2lsYmVydCB3cm90ZToNCj4+Pj4+Pj4gKiBBbGV4IEJlbm7D
qWUgKGFsZXguYmVubmVlQGxpbmFyby5vcmcpIHdyb3RlOg0KPj4+Pj4+Pj4gRnJvbTogUGll
cnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KPj4+Pj4+Pj4N
Cj4+Pj4+Pj4+IFRoaXMgcGx1Z2luIHVzZXMgdGhlIG5ldyB0aW1lIGNvbnRyb2wgaW50ZXJm
YWNlIHRvIG1ha2UgZGVjaXNpb25zDQo+Pj4+Pj4+PiBhYm91dCB0aGUgc3RhdGUgb2YgdGlt
ZSBkdXJpbmcgdGhlIGVtdWxhdGlvbi4gVGhlIGFsZ29yaXRobSBpcw0KPj4+Pj4+Pj4gY3Vy
cmVudGx5IHZlcnkgc2ltcGxlLiBUaGUgdXNlciBzcGVjaWZpZXMgYW4gaXBzIHJhdGUgd2hp
Y2ggYXBwbGllcw0KPj4+Pj4+Pj4gcGVyIGNvcmUuIElmIHRoZSBjb3JlIHJ1bnMgYWhlYWQg
b2YgaXRzIGFsbG9jYXRlZCBleGVjdXRpb24gdGltZSB0aGUNCj4+Pj4+Pj4+IHBsdWdpbiBz
bGVlcHMgZm9yIGEgYml0IHRvIGxldCByZWFsIHRpbWUgY2F0Y2ggdXAuIEVpdGhlciB3YXkg
dGltZSBpcw0KPj4+Pj4+Pj4gdXBkYXRlZCBmb3IgdGhlIGVtdWxhdGlvbiBhcyBhIGZ1bmN0
aW9uIG9mIHRvdGFsIGV4ZWN1dGVkIGluc3RydWN0aW9ucw0KPj4+Pj4+Pj4gd2l0aCBzb21l
IGFkanVzdG1lbnRzIGZvciBjb3JlcyB0aGF0IGlkbGUuDQo+Pj4+Pj4+DQo+Pj4+Pj4+IEEg
ZmV3IHJhbmRvbSB0aG91Z2h0czoNCj4+Pj4+Pj4gICAgICAgYSkgQXJlIHRoZXJlIGFueSBk
ZWZpbml0aW9ucyBvZiB3aGF0IGEgcGx1Z2luIHRoYXQgY29udHJvbHMgdGltZQ0KPj4+Pj4+
PiAgICAgICAgICBzaG91bGQgZG8gd2l0aCBhIGxpdmUgbWlncmF0aW9uPw0KPj4+Pj4+DQo+
Pj4+Pj4gSXQncyBub3Qgc29tZXRoaW5nIHRoYXQgd2FzIGNvbnNpZGVyZWQgYXMgcGFydCBv
ZiB0aGlzIHdvcmsuDQo+Pj4+Pg0KPj4+Pj4gVGhhdCdzIE9LLCB0aGUgb25seSB0aGluZyBp
cyB3ZSBuZWVkIHRvIHN0b3AgYW55b25lIGZyb20gaGl0dGluZyBwcm9ibGVtcw0KPj4+Pj4g
d2hlbiB0aGV5IGRvbid0IHJlYWxpc2UgaXQncyBub3QgYmVlbiBhZGRyZXNzZWQuDQo+Pj4+
PiBPbmUgd2F5IG1pZ2h0IGJlIHRvIGFkZCBhIG1pZ3JhdGlvbiBibG9ja2VyOyBzZWUgaW5j
bHVkZS9taWdyYXRpb24vYmxvY2tlci5oDQo+Pj4+PiB0aGVuIHlvdSBtaWdodCBwcmludCBz
b21ldGhpbmcgbGlrZSAnTWlncmF0aW9uIG5vdCBhdmFpbGFibGUgZHVlIHRvIHBsdWdpbiAu
Li4uJw0KPj4+Pj4NCj4+Pj4NCj4+Pj4gU28gYmFzaWNhbGx5LCB3ZSBjb3VsZCBtYWtlIGEg
Y2FsbCB0byBtaWdyYXRlX2FkZF9ibG9ja2VyKCksIHdoZW4gc29tZW9uZQ0KPj4+PiByZXF1
ZXN0IHRpbWVfY29udHJvbCB0aHJvdWdoIHBsdWdpbiBBUEk/DQo+Pj4+DQo+Pj4+IElNSE8s
IGl0J3Mgc29tZXRoaW5nIHRoYXQgc2hvdWxkIGJlIHBhcnQgb2YgcGx1Z2luIEFQSSAoaWYg
YW55IHBsdWdpbiBjYWxscw0KPj4+PiBxZW11X3BsdWdpbl9yZXF1ZXN0X3RpbWVfY29udHJv
bCgpKSwgaW5zdGVhZCBvZiB0aGUgcGx1Z2luIGNvZGUgaXRzZWxmLiBUaGlzDQo+Pj4+IHdh
eSwgYW55IHBsdWdpbiBnZXR0aW5nIHRpbWUgY29udHJvbCBhdXRvbWF0aWNhbGx5IGJsb2Nr
cyBhbnkgcG90ZW50aWFsDQo+Pj4+IG1pZ3JhdGlvbi4NCj4+PiBOb3RlIG15IHF1ZXN0aW9u
IGFza2VkIGZvciBhICdhbnkgZGVmaW5pdGlvbnMgb2Ygd2hhdCBhIHBsdWdpbiAuLicgLQ0K
Pj4+IHNvDQo+Pj4geW91IGNvdWxkIGRlZmluZSBpdCB0aGF0IHdheSwgYW5vdGhlciBvbmUg
aXMgdG8gdGhpbmsgdGhhdCBpbiB0aGUgZnV0dXJlDQo+Pj4geW91IG1heSBhbGxvdyBpdCBh
bmQgdGhlIHBsdWdpbiBzb21laG93IGludGVyYWN0cyB3aXRoIG1pZ3JhdGlvbiBub3QgdG8N
Cj4+PiBjaGFuZ2UgdGltZSBhdCBjZXJ0YWluIG1pZ3JhdGlvbiBwaGFzZXMuDQo+Pj4NCj4+
DQo+PiBJIHdvdWxkIGJlIGluIGZhdm9yIHRvIGZvcmJpZCB1c2FnZSBmb3Igbm93IGluIHRo
aXMgY29udGV4dC4gSSdtIG5vdA0KPj4gc3VyZSB3aHkgcGVvcGxlIHdvdWxkIHBsYXkgd2l0
aCBtaWdyYXRpb24gYW5kIHBsdWdpbnMgZ2VuZXJhbGx5IGF0DQo+PiB0aGlzIHRpbWUgKHRo
ZXJlIG1pZ2h0IGJlIGV4cGVyaW1lbnRzIG9yIHVzZSBjYXNlcyBJJ20gbm90IGF3YXJlIG9m
KSwNCj4+IHNvIGEgc2ltcGxlIGJhcnJpZXIgcHJldmVudGluZyB0aGF0IHNlZW1zIG9rLg0K
Pj4NCj4+IFRoaXMgcGx1Z2luIGlzIHBhcnQgb2YgYW4gZXhwZXJpbWVudCB3aGVyZSB3ZSBp
bXBsZW1lbnQgYSBxZW11IGZlYXR1cmUNCj4+IChpY291bnQ9YXV0byBpbiB0aGlzIGNhc2Up
IGJ5IHVzaW5nIHBsdWdpbnMuIElmIGl0IHR1cm5zIGludG8gYQ0KPj4gc3VjY2Vzc2Z1bCB1
c2FnZSBhbmQgdGhpcyBwbHVnaW4gYmVjb21lcyBwb3B1bGFyLCB3ZSBjYW4gYWx3YXlzIGxp
ZnQNCj4+IHRoZSBsaW1pdGF0aW9uIGxhdGVyLg0KPj4NCj4+IEBBbGV4LCB3b3VsZCB5b3Ug
bGlrZSB0byBhZGQgdGhpcyBub3cgKGljb3VudD1hdXRvIGlzIHN0aWxsIG5vdA0KPj4gcmVt
b3ZlZCBmcm9tIHFlbXUpLCBvciB3YWl0IGZvciBpbnRlZ3JhdGlvbiwgYW5kIGFkZCB0aGlz
IGFzIGFub3RoZXINCj4+IHBhdGNoPw0KPiANCj4gSSB0aGluayB3ZSBmb2xsb3cgdGhlIGRl
cHJlY2F0aW9uIHByb2Nlc3Mgc28gb25jZSBpbnRlZ3JhdGVkIHdlIHBvc3QgYQ0KPiBkZXBy
ZWNhdGlvbiBub3RpY2UgaW46DQo+IA0KPiAgICBodHRwczovL3FlbXUucmVhZHRoZWRvY3Mu
aW8vZW4vbWFzdGVyL2Fib3V0L2RlcHJlY2F0ZWQuaHRtbA0KPiANCj4gYW5kIHRoZW4gcmVt
b3ZlIGl0IGFmdGVyIGEgY291cGxlIG9mIHJlbGVhc2VzLg0KPiANCg0KU29ycnksIEkgd2Fz
IG5vdCBjbGVhci4gSSBtZWFudCBkbyB3ZSBhZGQgYSBibG9ja2VyIGluIGNhc2Ugc29tZW9u
ZSANCnRyaWVzIHRvIG1pZ3JhdGUgYSB2bSB3aGlsZSB0aGlzIHBsdWdpbiBpcyB1c2VkPw0K


