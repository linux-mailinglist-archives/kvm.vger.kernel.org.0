Return-Path: <kvm+bounces-19816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA0590BA9B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 21:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77DAB1C22FB6
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 19:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA15198E96;
	Mon, 17 Jun 2024 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gJ43WobN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94886161305
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718651523; cv=none; b=eUzQbhndkw3jGAeORfVLAlPjVWPXmPrkQx4JnvTDGWSfulZqFLGsUym46MECKataQ35hj8b2aY/YlKo564Jaw3o8aEOA43eU0pqoXwQEAX8wuDmMGy7yRWK+rFvh15J0VcZ6K43QLZmICuwsvtkFL0hGHPsh0ezz3D7AjjSlwag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718651523; c=relaxed/simple;
	bh=27m3jkUizoYonw2agAsRnLxLdTrKJ2tqvnlMBNPR110=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IeGfym++ACrXrp+TEOJkBb0GMQCFwXE+TcCGNuqcQ14oF7nHRVx7rj3Rt86oniTO87gNjI+cxG4FSHFSBW/AAjQLUc+NF1Q++W4kJSl3BJdZ+6QOQJmIIaaIHL9NpWIX2Ex/h2DdYH3h2IPoK4BbBQzg9YWyXB9yos8l6F8H1IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gJ43WobN; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-705b9a89e08so4067153b3a.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 12:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718651521; x=1719256321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=27m3jkUizoYonw2agAsRnLxLdTrKJ2tqvnlMBNPR110=;
        b=gJ43WobN1O3MK8P2b7kS1KvkVciGFqDkiNX1rqLt4a8H2SXDFfLETPe3UwjqfHco8I
         16hrOnYcZmElUUI2W03wa+9ePUE9HTLolghs4yAqAEPIpgXR7C+F1HpBneuzSVgw1icw
         il3UdR4H/c1GDGHOwBDOmeaDOzKrrayWLS6QJEZFS3LPdvxd9K3brVjkV3U5TBuHdsWU
         8+BVDt2NZdlbis7E41mOD2F9wyKkGuNzX2IEqi6W+0sJCkYBMfNjRcneuxYA2C3kMpju
         hgDd2NyMg5rTlbgUj8H2XtiqHpeh4qLoce6uOX+Alb8nCRA4JJGcRh8N3ljZ6V6s3+XI
         XSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718651521; x=1719256321;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27m3jkUizoYonw2agAsRnLxLdTrKJ2tqvnlMBNPR110=;
        b=snCqg2dLI3bfk7hjpYNVuOVsDoHN6pBOAKCGQpLEP3geYYI5MZ9sAYl0pJ6i0O1KPU
         mrT4bfS4W/5kTAJiAHlrWsTZ6k3IoEBbDxVjDOTAp4Gd89mvWKhJfpGMLsvsIoEP6pvk
         i8ddRCk9VreD8Pbjp74K651RpLth2qA+qkDo+83WiZBjkHT1tSc9JFKhwqXsqPpZQOK7
         ENBWB6mbBNM94YTgjqh5fekpn6+CNTgh8L0vTxZx83VFdNBaH0/acIVv8nw7lQjp+3YH
         qHQNS6IEzicSTAz7k0hAdl6zGtAtB/RsbEHtx1lbJ3Nm4lrZ8F1IfCZK63e6qWMS1SYu
         owzg==
X-Forwarded-Encrypted: i=1; AJvYcCWF4GS00J2lrgr/BAY/VotVh3DfTFYTVZudHGoKSEkrayNm7RS8aYw+0VUVA+STt2oFhXgIhdMNaKAJmuKG9pm7Vtgk
X-Gm-Message-State: AOJu0Yw0M/iAsTTYOvGo9TVP4zxYRVRg1fKPfcA0HSiR5o7c03IXX0O+
	xLzRV9W8pl5TAqH2K1x9Wdh3O8AjbmZqbco509CwYduqMjd30S2egzKQpyylgNw=
X-Google-Smtp-Source: AGHT+IHJp9kki1S5nqQIolzKisaYTlpNMGUfjzK19P8zMd64Akc3JmfaA+GFDQrTwd8jRGGi6m08pA==
X-Received: by 2002:a05:6a20:918f:b0:1b8:4107:ce4d with SMTP id adf61e73a8af0-1bae7e0a009mr11147821637.19.1718651520766;
        Mon, 17 Jun 2024 12:12:00 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::2193? ([2604:3d08:9384:1d00::2193])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fede16b269sm5981045a12.34.2024.06.17.12.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 12:12:00 -0700 (PDT)
Message-ID: <13caad47-a0ae-4d39-98b6-208d3c0cd8fb@linaro.org>
Date: Mon, 17 Jun 2024 12:11:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] contrib/plugins: add ips plugin example for cost
 modeling
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, David Hildenbrand <david@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
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
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-10-alex.bennee@linaro.org>
 <31ba8570-9009-4530-934d-3b73b07520d0@linaro.org>
 <db8d82d4-c88d-45ac-bc99-e85a4240add2@linaro.org>
 <87frtcsp7q.fsf@draig.linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <87frtcsp7q.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xNi8yNCAxMTo0MywgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBQaWVycmljayBCb3V2
aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+IHdyaXRlczoNCj4gDQo+PiBPbiA2
LzEzLzI0IDAxOjU0LCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4+PiBPbiAx
Mi82LzI0IDE3OjM1LCBBbGV4IEJlbm7DqWUgd3JvdGU6DQo+Pj4+IEZyb206IFBpZXJyaWNr
IEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+Pj4NCj4+Pj4gVGhp
cyBwbHVnaW4gdXNlcyB0aGUgbmV3IHRpbWUgY29udHJvbCBpbnRlcmZhY2UgdG8gbWFrZSBk
ZWNpc2lvbnMNCj4+Pj4gYWJvdXQgdGhlIHN0YXRlIG9mIHRpbWUgZHVyaW5nIHRoZSBlbXVs
YXRpb24uIFRoZSBhbGdvcml0aG0gaXMNCj4+Pj4gY3VycmVudGx5IHZlcnkgc2ltcGxlLiBU
aGUgdXNlciBzcGVjaWZpZXMgYW4gaXBzIHJhdGUgd2hpY2ggYXBwbGllcw0KPj4+IC4uLiBJ
UFMgcmF0ZSAoSW5zdHJ1Y3Rpb25zIFBlciBTZWNvbmQpIHdoaWNoIC4uLg0KPj4+DQo+Pj4+
IHBlciBjb3JlLiBJZiB0aGUgY29yZSBydW5zIGFoZWFkIG9mIGl0cyBhbGxvY2F0ZWQgZXhl
Y3V0aW9uIHRpbWUgdGhlDQo+Pj4+IHBsdWdpbiBzbGVlcHMgZm9yIGEgYml0IHRvIGxldCBy
ZWFsIHRpbWUgY2F0Y2ggdXAuIEVpdGhlciB3YXkgdGltZSBpcw0KPj4+PiB1cGRhdGVkIGZv
ciB0aGUgZW11bGF0aW9uIGFzIGEgZnVuY3Rpb24gb2YgdG90YWwgZXhlY3V0ZWQgaW5zdHJ1
Y3Rpb25zDQo+Pj4+IHdpdGggc29tZSBhZGp1c3RtZW50cyBmb3IgY29yZXMgdGhhdCBpZGxl
Lg0KPj4+Pg0KPj4+PiBFeGFtcGxlcw0KPj4+PiAtLS0tLS0tLQ0KPj4+Pg0KPj4+PiBTbG93
IGRvd24gZXhlY3V0aW9uIG9mIC9iaW4vdHJ1ZToNCj4+Pj4gJCBudW1faW5zbj0kKC4vYnVp
bGQvcWVtdS14ODZfNjQgLXBsdWdpbiAuL2J1aWxkL3Rlc3RzL3BsdWdpbi9saWJpbnNuLnNv
IC1kIHBsdWdpbiAvYmluL3RydWUgfCYgZ3JlcCB0b3RhbCB8IHNlZCAtZSAncy8uKjogLy8n
KQ0KPj4+PiAkIHRpbWUgLi9idWlsZC9xZW11LXg4Nl82NCAtcGx1Z2luIC4vYnVpbGQvY29u
dHJpYi9wbHVnaW5zL2xpYmlwcy5zbyxpcHM9JCgoJG51bV9pbnNuLzQpKSAvYmluL3RydWUN
Cj4+Pj4gcmVhbCA0LjAwMHMNCj4+Pj4NCj4+Pj4gQm9vdCBhIExpbnV4IGtlcm5lbCBzaW11
bGF0aW5nIGEgMjUwTUh6IGNwdToNCj4+Pj4gJCAvYnVpbGQvcWVtdS1zeXN0ZW0teDg2XzY0
IC1rZXJuZWwgL2Jvb3Qvdm1saW51ei02LjEuMC0yMS1hbWQ2NCAtYXBwZW5kICJjb25zb2xl
PXR0eVMwIiAtcGx1Z2luIC4vYnVpbGQvY29udHJpYi9wbHVnaW5zL2xpYmlwcy5zbyxpcHM9
JCgoMjUwKjEwMDAqMTAwMCkpIC1zbXAgMSAtbSA1MTINCj4+Pj4gY2hlY2sgdGltZSB1bnRp
bCBrZXJuZWwgcGFuaWMgb24gc2VyaWFsMA0KPj4+Pg0KPj4+PiBUZXN0ZWQgaW4gc3lzdGVt
IG1vZGUgYnkgYm9vdGluZyBhIGZ1bGwgZGViaWFuIHN5c3RlbSwgYW5kIHVzaW5nOg0KPj4+
PiAkIHN5c2JlbmNoIGNwdSBydW4NCj4+Pj4gUGVyZm9ybWFuY2UgZGVjcmVhc2UgbGluZWFy
bHkgd2l0aCB0aGUgZ2l2ZW4gbnVtYmVyIG9mIGlwcy4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9m
Zi1ieTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0K
Pj4+PiBNZXNzYWdlLUlkOiA8MjAyNDA1MzAyMjA2MTAuMTI0NTQyNC03LXBpZXJyaWNrLmJv
dXZpZXJAbGluYXJvLm9yZz4NCj4+Pj4gLS0tDQo+Pj4+ICAgICBjb250cmliL3BsdWdpbnMv
aXBzLmMgICAgfCAxNjQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
DQo+Pj4+ICAgICBjb250cmliL3BsdWdpbnMvTWFrZWZpbGUgfCAgIDEgKw0KPj4+PiAgICAg
MiBmaWxlcyBjaGFuZ2VkLCAxNjUgaW5zZXJ0aW9ucygrKQ0KPj4+PiAgICAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IGNvbnRyaWIvcGx1Z2lucy9pcHMuYw0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0
IGEvY29udHJpYi9wbHVnaW5zL2lwcy5jIGIvY29udHJpYi9wbHVnaW5zL2lwcy5jDQo+Pj4+
IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+Pj4+IGluZGV4IDAwMDAwMDAwMDAuLmRiNzc3Mjky
NjQNCj4+Pj4gLS0tIC9kZXYvbnVsbA0KPj4+PiArKysgYi9jb250cmliL3BsdWdpbnMvaXBz
LmMNCj4+Pj4gQEAgLTAsMCArMSwxNjQgQEANCj4+Pj4gKy8qDQo+Pj4+ICsgKiBpcHMgcmF0
ZSBsaW1pdGluZyBwbHVnaW4uDQo+Pj4gVGhlIHBsdWdpbiBuYW1lcyBhcmUgcmVhbGx5IHRv
IHBhY2tlZCB0byBteSB0YXN0ZSAoZWFjaCB0aW1lIEkgbG9vaw0KPj4+IGZvcg0KPj4+IG9u
ZSBJIGhhdmUgdG8gb3BlbiBtb3N0IHNvdXJjZSBmaWxlcyB0byBmaWd1cmUgb3V0IHRoZSBj
b3JyZWN0IG9uZSk7IHNvDQo+Pj4gcGxlYXNlIGVhc2UgbXkgbGlmZSBieSB1c2luZyBhIG1v
cmUgZGVzY3JpcHRpdmUgaGVhZGVyIGF0IGxlYXN0Og0KPj4+ICAgICAgICAgSW5zdHJ1Y3Rp
b25zIFBlciBTZWNvbmQgKElQUykgcmF0ZSBsaW1pdGluZyBwbHVnaW4uDQo+Pj4gVGhhbmtz
Lg0KPj4+DQo+Pg0KPj4gSSBhZ3JlZSBtb3N0IG9mIHRoZSBwbHVnaW4gbmFtZXMgYXJlIHBy
ZXR0eSBjcnlwdGljLCBhbmQgdGhleSBhcmUNCj4+IGxhY2tpbmcgYSBjb21tb24gImhlbHAi
IHN5c3RlbSwgdG8gZGVzY3JpYmUgd2hhdCB0aGV5IGRvLCBhbmQgd2hpY2gNCj4+IG9wdGlv
bnMgYXJlIGF2YWlsYWJsZSBmb3IgdGhlbS4gSXQncyBkZWZpbml0ZWx5IHNvbWV0aGluZyB3
ZSBjb3VsZCBhZGQNCj4+IGluIHRoZSBmdXR1cmUuDQo+Pg0KPj4gUmVnYXJkaW5nIHdoYXQg
eW91IHJlcG9ydGVkLCBJJ20gdG90YWxseSBvayB3aXRoIHRoZSBjaGFuZ2UuDQo+Pg0KPj4g
SG93ZXZlciwgc2luY2UgdGhpcyBpcyBhIG5ldyBzZXJpZXMsIEknbSBub3QgaWYgSSBvciBB
bGV4IHNob3VsZA0KPj4gY2hhbmdlIGl0LiBJZiBpdCdzIG9rIGZvciB5b3UgdG8gbW9kaWZ5
IHRoaXMgQWxleCwgaXQgY291bGQgYmUgc2ltcGxlcg0KPj4gdGhhbiB3YWl0aW5nIGZvciBt
ZSB0byBwdXNoIGEgbmV3IHBhdGNoIHdpdGgganVzdCB0aGlzLg0KPiANCj4gSXRzIG15IHRy
ZWUgc28gSSdsbCBmaXggaXQgdXAuIEknbGwgYXNrIHlvdSBpZiBJIHdhbnQgYSByZXNwaW4g
Oy0pDQo+IA0KDQpUaGFua3MgQWxleC4NCg==

