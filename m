Return-Path: <kvm+bounces-19705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BE159091E4
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 19:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2808328E1A2
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 17:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8360D16DEB8;
	Fri, 14 Jun 2024 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jrcHDadE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111BED52A
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718386783; cv=none; b=ho2G8Q0TEkvZ06WtajLT0g2RVwXuzq+0/H+7E6HHD5QpuqixHalyP1uubc++fWz23C32AVtjugUwGeRyJN12Dry/YpDvWE0GxHYSwvUO9++jaQckhAmOfCjy1pWuoEaJPJ20Y8BnLScfl+iSLRn3QThT0Cymws7RcPOUMj/qoPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718386783; c=relaxed/simple;
	bh=LZVk0DXKOWm6MvJWNYzIbrwLlYqE1AU9Mbeh1DO6+c0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LuUmKlPleRfOjQ3hjZcodSN8Q0XnVuwsj2o2TR5M00nc3x+PzHm65CZ6JbvMd53zb2VhVR/uiufSVnl88clYAYxwnli1/lhsMBdZFZ2Wm7pMejBcVnZk/miGCDcqaPIsR+ants7vKSnYcs/NCbnOSHQ4xcYl400zvAbuQHHKg6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jrcHDadE; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2c2ecd25e5aso2007757a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 10:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718386781; x=1718991581; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LZVk0DXKOWm6MvJWNYzIbrwLlYqE1AU9Mbeh1DO6+c0=;
        b=jrcHDadEq1SJmUQMXbi+tX4KPhQ0aqATOZ8jeutrYpmCGZKC5bpIwLVEe9bo/UR2oX
         Da7tZQplIBTkewkEtb2vqa852qQdxVihkotQNguVytq+frQI/qXyTiMBQd+oSTZyfu+A
         nbWoaaNn+T1v+3x0OBWWqnlbByzu3wYDe5EDzNiQ+E1bv+smNXhai5FLBmbYIthyxnOw
         snmG2rNDVYEI6TNCeV4tISW4CknhDZEd1LbWOAVIAYJy76J4dxawIiC1vGirBOcXyDwb
         /AoqbNT1oyBfTn6XKrlWdzNf0zOhTuukzBHEyImMIR6QcdqWABTxrmuY0mpCpKDKw26Q
         EZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718386781; x=1718991581;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LZVk0DXKOWm6MvJWNYzIbrwLlYqE1AU9Mbeh1DO6+c0=;
        b=CY7bpErLc0LAX7t2oZZvxQCgiJDxIc49E/4rEqK+fAlMMMu9kk9bjsB6l8hxamrIE8
         dlToDT9O3A6d1Omn/docBWDWnwUJ6cbJzBtbxIaRXC9uBV/PKrfruTSaTrcQE/gTJsWy
         Q6bpDgK0FiD3T43D/TlV/XgmXh+opYVkRQOhVFXnZZTWx11YU+BWpqHRVLUKJyEd5CZk
         /d6a/mr3fahTucKaiLCCzOoMTZduskaGdhI1pXl8Zn+b9B5fxVblELLTYVyXpOoI5SwK
         cKmHWhs31ZYQEsrlbf6mLyTFpY23UrJXtyQO5GrPgctmFsgWvPI920b3jIYX5BzmM9Qr
         ZSmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvdbL95PakpnKG782MlF5bcjrWl7G8MCVfGq+vdFN2pIzA6vKIxd+zS0R8QT60myNfEQeBT8Cdi7lzukfV1scgwdHC
X-Gm-Message-State: AOJu0YzXn9EKrSO+4/RcoTv3RZJb6PNSw11B6SkB+tv/f0sm/hNtcouB
	icbpZtuQAQIed+ebnyTNBe/NfcbAHUmMa487lWskZ1EVBqC9Xsxt0qLo0S7uJaY=
X-Google-Smtp-Source: AGHT+IE5urql5YpawKC+jj7jv8LyLVzZJYw6QrDSxegrz2UowPKK9+FYNMnJ8E7y9V5qTR8ntxVfEQ==
X-Received: by 2002:a17:90a:2d82:b0:2c3:8d6:eb38 with SMTP id 98e67ed59e1d1-2c4db44ba1fmr3944452a91.26.1718386780132;
        Fri, 14 Jun 2024 10:39:40 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00:5b09:8db7:b002:cf61? ([2604:3d08:9384:1d00:5b09:8db7:b002:cf61])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fede169c6bsm2860610a12.22.2024.06.14.10.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 10:39:39 -0700 (PDT)
Message-ID: <db8d82d4-c88d-45ac-bc99-e85a4240add2@linaro.org>
Date: Fri, 14 Jun 2024 10:39:38 -0700
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
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>, Ilya Leoshkevich
 <iii@linux.ibm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
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
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <31ba8570-9009-4530-934d-3b73b07520d0@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xMy8yNCAwMTo1NCwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDEyLzYvMjQgMTc6MzUsIEFsZXggQmVubsOpZSB3cm90ZToNCj4+IEZyb206IFBpZXJyaWNr
IEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+DQo+PiBUaGlzIHBs
dWdpbiB1c2VzIHRoZSBuZXcgdGltZSBjb250cm9sIGludGVyZmFjZSB0byBtYWtlIGRlY2lz
aW9ucw0KPj4gYWJvdXQgdGhlIHN0YXRlIG9mIHRpbWUgZHVyaW5nIHRoZSBlbXVsYXRpb24u
IFRoZSBhbGdvcml0aG0gaXMNCj4+IGN1cnJlbnRseSB2ZXJ5IHNpbXBsZS4gVGhlIHVzZXIg
c3BlY2lmaWVzIGFuIGlwcyByYXRlIHdoaWNoIGFwcGxpZXMNCj4gDQo+IC4uLiBJUFMgcmF0
ZSAoSW5zdHJ1Y3Rpb25zIFBlciBTZWNvbmQpIHdoaWNoIC4uLg0KPiANCj4+IHBlciBjb3Jl
LiBJZiB0aGUgY29yZSBydW5zIGFoZWFkIG9mIGl0cyBhbGxvY2F0ZWQgZXhlY3V0aW9uIHRp
bWUgdGhlDQo+PiBwbHVnaW4gc2xlZXBzIGZvciBhIGJpdCB0byBsZXQgcmVhbCB0aW1lIGNh
dGNoIHVwLiBFaXRoZXIgd2F5IHRpbWUgaXMNCj4+IHVwZGF0ZWQgZm9yIHRoZSBlbXVsYXRp
b24gYXMgYSBmdW5jdGlvbiBvZiB0b3RhbCBleGVjdXRlZCBpbnN0cnVjdGlvbnMNCj4+IHdp
dGggc29tZSBhZGp1c3RtZW50cyBmb3IgY29yZXMgdGhhdCBpZGxlLg0KPj4NCj4+IEV4YW1w
bGVzDQo+PiAtLS0tLS0tLQ0KPj4NCj4+IFNsb3cgZG93biBleGVjdXRpb24gb2YgL2Jpbi90
cnVlOg0KPj4gJCBudW1faW5zbj0kKC4vYnVpbGQvcWVtdS14ODZfNjQgLXBsdWdpbiAuL2J1
aWxkL3Rlc3RzL3BsdWdpbi9saWJpbnNuLnNvIC1kIHBsdWdpbiAvYmluL3RydWUgfCYgZ3Jl
cCB0b3RhbCB8IHNlZCAtZSAncy8uKjogLy8nKQ0KPj4gJCB0aW1lIC4vYnVpbGQvcWVtdS14
ODZfNjQgLXBsdWdpbiAuL2J1aWxkL2NvbnRyaWIvcGx1Z2lucy9saWJpcHMuc28saXBzPSQo
KCRudW1faW5zbi80KSkgL2Jpbi90cnVlDQo+PiByZWFsIDQuMDAwcw0KPj4NCj4+IEJvb3Qg
YSBMaW51eCBrZXJuZWwgc2ltdWxhdGluZyBhIDI1ME1IeiBjcHU6DQo+PiAkIC9idWlsZC9x
ZW11LXN5c3RlbS14ODZfNjQgLWtlcm5lbCAvYm9vdC92bWxpbnV6LTYuMS4wLTIxLWFtZDY0
IC1hcHBlbmQgImNvbnNvbGU9dHR5UzAiIC1wbHVnaW4gLi9idWlsZC9jb250cmliL3BsdWdp
bnMvbGliaXBzLnNvLGlwcz0kKCgyNTAqMTAwMCoxMDAwKSkgLXNtcCAxIC1tIDUxMg0KPj4g
Y2hlY2sgdGltZSB1bnRpbCBrZXJuZWwgcGFuaWMgb24gc2VyaWFsMA0KPj4NCj4+IFRlc3Rl
ZCBpbiBzeXN0ZW0gbW9kZSBieSBib290aW5nIGEgZnVsbCBkZWJpYW4gc3lzdGVtLCBhbmQg
dXNpbmc6DQo+PiAkIHN5c2JlbmNoIGNwdSBydW4NCj4+IFBlcmZvcm1hbmNlIGRlY3JlYXNl
IGxpbmVhcmx5IHdpdGggdGhlIGdpdmVuIG51bWJlciBvZiBpcHMuDQo+Pg0KPj4gU2lnbmVk
LW9mZi1ieTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3Jn
Pg0KPj4gTWVzc2FnZS1JZDogPDIwMjQwNTMwMjIwNjEwLjEyNDU0MjQtNy1waWVycmljay5i
b3V2aWVyQGxpbmFyby5vcmc+DQo+PiAtLS0NCj4+ICAgIGNvbnRyaWIvcGx1Z2lucy9pcHMu
YyAgICB8IDE2NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+
ICAgIGNvbnRyaWIvcGx1Z2lucy9NYWtlZmlsZSB8ICAgMSArDQo+PiAgICAyIGZpbGVzIGNo
YW5nZWQsIDE2NSBpbnNlcnRpb25zKCspDQo+PiAgICBjcmVhdGUgbW9kZSAxMDA2NDQgY29u
dHJpYi9wbHVnaW5zL2lwcy5jDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2NvbnRyaWIvcGx1Z2lu
cy9pcHMuYyBiL2NvbnRyaWIvcGx1Z2lucy9pcHMuYw0KPj4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQNCj4+IGluZGV4IDAwMDAwMDAwMDAuLmRiNzc3MjkyNjQNCj4+IC0tLSAvZGV2L251bGwN
Cj4+ICsrKyBiL2NvbnRyaWIvcGx1Z2lucy9pcHMuYw0KPj4gQEAgLTAsMCArMSwxNjQgQEAN
Cj4+ICsvKg0KPj4gKyAqIGlwcyByYXRlIGxpbWl0aW5nIHBsdWdpbi4NCj4gDQo+IFRoZSBw
bHVnaW4gbmFtZXMgYXJlIHJlYWxseSB0byBwYWNrZWQgdG8gbXkgdGFzdGUgKGVhY2ggdGlt
ZSBJIGxvb2sgZm9yDQo+IG9uZSBJIGhhdmUgdG8gb3BlbiBtb3N0IHNvdXJjZSBmaWxlcyB0
byBmaWd1cmUgb3V0IHRoZSBjb3JyZWN0IG9uZSk7IHNvDQo+IHBsZWFzZSBlYXNlIG15IGxp
ZmUgYnkgdXNpbmcgYSBtb3JlIGRlc2NyaXB0aXZlIGhlYWRlciBhdCBsZWFzdDoNCj4gDQo+
ICAgICAgICBJbnN0cnVjdGlvbnMgUGVyIFNlY29uZCAoSVBTKSByYXRlIGxpbWl0aW5nIHBs
dWdpbi4NCj4gDQo+IFRoYW5rcy4NCj4gDQoNCkkgYWdyZWUgbW9zdCBvZiB0aGUgcGx1Z2lu
IG5hbWVzIGFyZSBwcmV0dHkgY3J5cHRpYywgYW5kIHRoZXkgYXJlIA0KbGFja2luZyBhIGNv
bW1vbiAiaGVscCIgc3lzdGVtLCB0byBkZXNjcmliZSB3aGF0IHRoZXkgZG8sIGFuZCB3aGlj
aCANCm9wdGlvbnMgYXJlIGF2YWlsYWJsZSBmb3IgdGhlbS4gSXQncyBkZWZpbml0ZWx5IHNv
bWV0aGluZyB3ZSBjb3VsZCBhZGQgDQppbiB0aGUgZnV0dXJlLg0KDQpSZWdhcmRpbmcgd2hh
dCB5b3UgcmVwb3J0ZWQsIEknbSB0b3RhbGx5IG9rIHdpdGggdGhlIGNoYW5nZS4NCg0KSG93
ZXZlciwgc2luY2UgdGhpcyBpcyBhIG5ldyBzZXJpZXMsIEknbSBub3QgaWYgSSBvciBBbGV4
IHNob3VsZCBjaGFuZ2UgDQppdC4gSWYgaXQncyBvayBmb3IgeW91IHRvIG1vZGlmeSB0aGlz
IEFsZXgsIGl0IGNvdWxkIGJlIHNpbXBsZXIgdGhhbiANCndhaXRpbmcgZm9yIG1lIHRvIHB1
c2ggYSBuZXcgcGF0Y2ggd2l0aCBqdXN0IHRoaXMuDQoNCkxldCBtZSBrbm93IGhvdyB5b3Ug
ZGVhbCB3aXRoIHRoaXMgdXN1YWxseSwgYW5kIEknbGwgZG8gd2hhdCBpcyBuZWVkZWQuDQoN
ClRoYW5rcywNClBpZXJyaWNrDQoNCj4+ICsgKiBUaGlzIHBsdWdpbiBjYW4gYmUgdXNlZCB0
byByZXN0cmljdCB0aGUgZXhlY3V0aW9uIG9mIGEgc3lzdGVtIHRvIGENCj4+ICsgKiBwYXJ0
aWN1bGFyIG51bWJlciBvZiBJbnN0cnVjdGlvbnMgUGVyIFNlY29uZCAoaXBzKS4gVGhpcyBj
b250cm9scw0KPj4gKyAqIHRpbWUgYXMgc2VlbiBieSB0aGUgZ3Vlc3Qgc28gd2hpbGUgd2Fs
bC1jbG9jayB0aW1lIG1heSBiZSBsb25nZXINCj4+ICsgKiBmcm9tIHRoZSBndWVzdHMgcG9p
bnQgb2YgdmlldyB0aW1lIHdpbGwgcGFzcyBhdCB0aGUgbm9ybWFsIHJhdGUuDQo+PiArICoN
Cj4+ICsgKiBUaGlzIHVzZXMgdGhlIG5ldyBwbHVnaW4gQVBJIHdoaWNoIGFsbG93cyB0aGUg
cGx1Z2luIHRvIGNvbnRyb2wNCj4+ICsgKiBzeXN0ZW0gdGltZS4NCj4+ICsgKg0KPj4gKyAq
IENvcHlyaWdodCAoYykgMjAyMyBMaW5hcm8gTHRkDQo+PiArICoNCj4+ICsgKiBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KPj4gKyAqLw0KPiANCg==

