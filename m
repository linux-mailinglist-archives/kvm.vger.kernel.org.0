Return-Path: <kvm+bounces-19478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0679057C0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A99F0B28828
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9338D18131A;
	Wed, 12 Jun 2024 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wjAlhVG1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2219F180A9B
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207777; cv=none; b=p9lINo0A247+4NNW1kY9UYp3nRBOWDGqaqs2z9JrzBzEQmau3PB3mXW562ynvBvpXQ1Y6qnTUbe2XyhUINO/BAFXFcG6IyHyvaQSxo+RZURjEY4o3lrpFLmj44Jz6cD5e21KEDAtxFjP8AiNzPTZ+81j9Ni9JpwZdVh3Kv4x3B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207777; c=relaxed/simple;
	bh=4LtFCU0OaqID7yg77vJPhZn4oHg5DdiD9TxoARUTdz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MwBEz27MwFaO2QpGQHGeybouHU+0LbmNWti6uZ0LOhAphc8e6fQKvvrEFccKkX6e8Pcq04JaJ8PnF3ZxS3wNX4GBfyD8FHHNzWPCfV3D1CuJ7AnROwctsmzyCCVTd9VfaZlrgNNZOWxQd24LnfFcDVzyGAHlToQM3vJOFkCEqD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wjAlhVG1; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2c2f8f73010so3330561a91.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718207775; x=1718812575; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4LtFCU0OaqID7yg77vJPhZn4oHg5DdiD9TxoARUTdz0=;
        b=wjAlhVG1PXdBHMT1epq2D9YoC0lBhO8VYGTUXDpXGYgUfiYqtMrQj9fAycg36JC1xC
         i7zFKHQyLPMpIGURmDYT1VLu9rRZoDserjD6cSw1q7UawpvuDNHPHa5uJ48FqvKDhVDw
         HpJ6pWEi0xOd2+92q4YHXrs/SWUSQ7o+fNkLzLDHk/WkJTkPdyhul347xnOAU/rev3cq
         QzXEzqZ525Zaw45OFD0m0NcVvMcpoEgEfhKabFCfcjnZkb1BJwxpojVAk2SmHdsLEPTi
         lpBoM/DlQIWiMOcGw8jE1oL3uBJHCS58xkap3VpcQpa4J9ZUOPR1VPyIhgHa6SHK8p0n
         97Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718207775; x=1718812575;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4LtFCU0OaqID7yg77vJPhZn4oHg5DdiD9TxoARUTdz0=;
        b=gPFgrcHC+JteIQw4kXIgJ+CSWPPM17SDZSIl43usL2TVi+zPgMbausCDQLXsUtTKli
         v9+UZ2vEzGRwuQifCw1hwbDs6kJd9SpyX1fDcUbAYosFqrkRDDy+QzPml4IrGlDaQlib
         6p55ol8ZzlfP0ozs9ljrVpKFgebbthy8vN0Iujw7WWosmns4HMa33IcUsB2S/xc2mhPE
         VNnH765kB0RHxYVLIT04AI3TZvzmu+CBWlKn/0gmk9QCRhLzrVRjra7RbheK4Mn0vIqF
         wfvKGVZZQnXKxL07LLp1EtxFLKcQ5GtY2PT7InXI5fBYKDO2gR5Pl25/Kqq25dS7hKmc
         W0Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWSWA0JCOkIFD3qrbuTMCJSgxrp6L0p0bMpKRSD7zFtjfCKbRR/ZDyrUm2CadB6u53Dd8zia8hw5Z7naRWIjGYl6fqQ
X-Gm-Message-State: AOJu0YwxojtG7qlLLbvNOdfzXacnZW6pB3gTQWQ1R7xh2SmgEpNGTydk
	f4SRJMpR4TOtZmnhaIINd5K41vm7w8T+CbTCavOHSiisa57Gca14MBAiC4FtP8M=
X-Google-Smtp-Source: AGHT+IGVcaSBJlCHExD1W9Gu9M4SAY6gJcEtzhfoBdpGma9zpWI7MEzivtPw3zBsz+xTPZz63bFXOA==
X-Received: by 2002:a17:90a:c83:b0:2c3:236e:473c with SMTP id 98e67ed59e1d1-2c4a7643085mr2419168a91.21.1718207775372;
        Wed, 12 Jun 2024 08:56:15 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::2193? ([2604:3d08:9384:1d00::2193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a769bc48sm1941009a91.38.2024.06.12.08.56.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 08:56:14 -0700 (PDT)
Message-ID: <abe88b9b-621a-4956-877d-dd311a7fd58b@linaro.org>
Date: Wed, 12 Jun 2024 08:56:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] plugins: add time control API
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>, Ilya Leoshkevich
 <iii@linux.ibm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
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
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-9-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <20240612153508.1532940-9-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgQWxleCwNCg0KSSBub3RpY2VkIHRoZSBuZXcgc3ltYm9scyBsYWNrIFFFTVVfUExVR0lO
X0FQSSBxdWFsaWZpZXIgaW4gDQppbmNsdWRlL3FlbXUvcWVtdS1wbHVnaW4uaDoNCi0gcWVt
dV9wbHVnaW5fdXBkYXRlX25zDQotIHFlbXVfcGx1Z2luX3JlcXVlc3RfdGltZV9jb250cm9s
DQoNClNvIGl0IHdvdWxkIGJlIGltcG9zc2libGUgdG8gdXNlIHRob3NlIHN5bWJvbHMgb24g
d2luZG93cy4NCg0KSSBrZXB0IGEgcmVtaW5kZXIgdG8gc2VuZCBhIG5ldyBwYXRjaCBhZnRl
ciB5b3UgcHVsbGVkIHRoaXMsIGJ1dCBpZiB3ZSANCmdvIHRvIGEgbmV3IHNlcmllcywgaXQg
Y291bGQgYmUgYXMgZmFzdCBmb3IgeW91IHRvIGp1c3QgYWRkIHRoaXMgZGlyZWN0bHkuDQoN
ClRoYW5rcywNClBpZXJyaWNrDQoNCk9uIDYvMTIvMjQgMDg6MzUsIEFsZXggQmVubsOpZSB3
cm90ZToNCj4gRXhwb3NlIHRoZSBhYmlsaXR5IHRvIGNvbnRyb2wgdGltZSB0aHJvdWdoIHRo
ZSBwbHVnaW4gQVBJLiBPbmx5IG9uZQ0KPiBwbHVnaW4gY2FuIGNvbnRyb2wgdGltZSBzbyBp
dCBoYXMgdG8gcmVxdWVzdCBjb250cm9sIHdoZW4gbG9hZGVkLg0KPiBUaGVyZSBhcmUgcHJv
YmFibHkgbW9yZSBjb3JuZXIgY2FzZXMgdG8gY2F0Y2ggaGVyZS4NCj4gDQo+IEZyb206IEFs
ZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTog
UGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KPiBbQUpC
OiB0d2Vha2VkIHVzZXItbW9kZSBoYW5kbGluZ10NCj4gU2lnbmVkLW9mZi1ieTogQWxleCBC
ZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPg0KPiBNZXNzYWdlLUlkOiA8MjAyNDA1
MzAyMjA2MTAuMTI0NTQyNC02LXBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4gDQo+
IC0tLQ0KPiBwbHVnaW5zL25leHQNCj4gICAgLSBtYWtlIHFlbXVfcGx1Z2luX3VwZGF0ZV9u
cyBhIE5PUCBpbiB1c2VyLW1vZGUNCj4gLS0tDQo+ICAgaW5jbHVkZS9xZW11L3FlbXUtcGx1
Z2luLmggICB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysrKysNCj4gICBwbHVnaW5zL2Fw
aS5jICAgICAgICAgICAgICAgIHwgMzUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4gICBwbHVnaW5zL3FlbXUtcGx1Z2lucy5zeW1ib2xzIHwgIDIgKysNCj4gICAz
IGZpbGVzIGNoYW5nZWQsIDYyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL3FlbXUvcWVtdS1wbHVnaW4uaCBiL2luY2x1ZGUvcWVtdS9xZW11LXBsdWdpbi5o
DQo+IGluZGV4IDk1NzAzZDhmZWMuLmRiNGQ2NzUyOWUgMTAwNjQ0DQo+IC0tLSBhL2luY2x1
ZGUvcWVtdS9xZW11LXBsdWdpbi5oDQo+ICsrKyBiL2luY2x1ZGUvcWVtdS9xZW11LXBsdWdp
bi5oDQo+IEBAIC02NjEsNiArNjYxLDMxIEBAIHZvaWQgcWVtdV9wbHVnaW5fcmVnaXN0ZXJf
dmNwdV9tZW1faW5saW5lX3Blcl92Y3B1KA0KPiAgICAgICBxZW11X3BsdWdpbl91NjQgZW50
cnksDQo+ICAgICAgIHVpbnQ2NF90IGltbSk7DQo+ICAgDQo+ICsvKioNCj4gKyAqIHFlbXVf
cGx1Z2luX3JlcXVlc3RfdGltZV9jb250cm9sKCkgLSByZXF1ZXN0IHRoZSBhYmlsaXR5IHRv
IGNvbnRyb2wgdGltZQ0KPiArICoNCj4gKyAqIFRoaXMgZ3JhbnRzIHRoZSBwbHVnaW4gdGhl
IGFiaWxpdHkgdG8gY29udHJvbCBzeXN0ZW0gdGltZS4gT25seSBvbmUNCj4gKyAqIHBsdWdp
biBjYW4gY29udHJvbCB0aW1lIHNvIGlmIG11bHRpcGxlIHBsdWdpbnMgcmVxdWVzdCB0aGUg
YWJpbGl0eQ0KPiArICogYWxsIGJ1dCB0aGUgZmlyc3Qgd2lsbCBmYWlsLg0KPiArICoNCj4g
KyAqIFJldHVybnMgYW4gb3BhcXVlIGhhbmRsZSBvciBOVUxMIGlmIGZhaWxzDQo+ICsgKi8N
Cj4gK2NvbnN0IHZvaWQgKnFlbXVfcGx1Z2luX3JlcXVlc3RfdGltZV9jb250cm9sKHZvaWQp
Ow0KPiArDQo+ICsvKioNCj4gKyAqIHFlbXVfcGx1Z2luX3VwZGF0ZV9ucygpIC0gdXBkYXRl
IHN5c3RlbSBlbXVsYXRpb24gdGltZQ0KPiArICogQGhhbmRsZTogb3BhcXVlIGhhbmRsZSBy
ZXR1cm5lZCBieSBxZW11X3BsdWdpbl9yZXF1ZXN0X3RpbWVfY29udHJvbCgpDQo+ICsgKiBA
dGltZTogdGltZSBpbiBuYW5vc2Vjb25kcw0KPiArICoNCj4gKyAqIFRoaXMgYWxsb3dzIGFu
IGFwcHJvcHJpYXRlbHkgYXV0aG9yaXNlZCBwbHVnaW4gKGkuZS4gaG9sZGluZyB0aGUNCj4g
KyAqIHRpbWUgY29udHJvbCBoYW5kbGUpIHRvIG1vdmUgc3lzdGVtIHRpbWUgZm9yd2FyZCB0
byBAdGltZS4gRm9yDQo+ICsgKiB1c2VyLW1vZGUgZW11bGF0aW9uIHRoZSB0aW1lIGlzIG5v
dCBjaGFuZ2VkIGJ5IHRoaXMgYXMgYWxsIHJlcG9ydGVkDQo+ICsgKiB0aW1lIGNvbWVzIGZy
b20gdGhlIGhvc3Qga2VybmVsLg0KPiArICoNCj4gKyAqIFN0YXJ0IHRpbWUgaXMgMC4NCj4g
KyAqLw0KPiArdm9pZCBxZW11X3BsdWdpbl91cGRhdGVfbnMoY29uc3Qgdm9pZCAqaGFuZGxl
LCBpbnQ2NF90IHRpbWUpOw0KPiArDQo+ICAgdHlwZWRlZiB2b2lkDQo+ICAgKCpxZW11X3Bs
dWdpbl92Y3B1X3N5c2NhbGxfY2JfdCkocWVtdV9wbHVnaW5faWRfdCBpZCwgdW5zaWduZWQg
aW50IHZjcHVfaW5kZXgsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aW50NjRfdCBudW0sIHVpbnQ2NF90IGExLCB1aW50NjRfdCBhMiwNCj4gZGlmZiAtLWdpdCBh
L3BsdWdpbnMvYXBpLmMgYi9wbHVnaW5zL2FwaS5jDQo+IGluZGV4IDZiZGIyNmJiZTMuLjQ0
MzFhMGVhN2UgMTAwNjQ0DQo+IC0tLSBhL3BsdWdpbnMvYXBpLmMNCj4gKysrIGIvcGx1Z2lu
cy9hcGkuYw0KPiBAQCAtMzksNiArMzksNyBAQA0KPiAgICNpbmNsdWRlICJxZW11L21haW4t
bG9vcC5oIg0KPiAgICNpbmNsdWRlICJxZW11L3BsdWdpbi5oIg0KPiAgICNpbmNsdWRlICJx
ZW11L2xvZy5oIg0KPiArI2luY2x1ZGUgInFlbXUvdGltZXIuaCINCj4gICAjaW5jbHVkZSAi
dGNnL3RjZy5oIg0KPiAgICNpbmNsdWRlICJleGVjL2V4ZWMtYWxsLmgiDQo+ICAgI2luY2x1
ZGUgImV4ZWMvZ2Ric3R1Yi5oIg0KPiBAQCAtNTgzLDMgKzU4NCwzNyBAQCB1aW50NjRfdCBx
ZW11X3BsdWdpbl91NjRfc3VtKHFlbXVfcGx1Z2luX3U2NCBlbnRyeSkNCj4gICAgICAgfQ0K
PiAgICAgICByZXR1cm4gdG90YWw7DQo+ICAgfQ0KPiArDQo+ICsvKg0KPiArICogVGltZSBj
b250cm9sDQo+ICsgKi8NCj4gK3N0YXRpYyBib29sIGhhc19jb250cm9sOw0KPiArDQo+ICtj
b25zdCB2b2lkICpxZW11X3BsdWdpbl9yZXF1ZXN0X3RpbWVfY29udHJvbCh2b2lkKQ0KPiAr
ew0KPiArICAgIGlmICghaGFzX2NvbnRyb2wpIHsNCj4gKyAgICAgICAgaGFzX2NvbnRyb2wg
PSB0cnVlOw0KPiArICAgICAgICByZXR1cm4gJmhhc19jb250cm9sOw0KPiArICAgIH0NCj4g
KyAgICByZXR1cm4gTlVMTDsNCj4gK30NCj4gKw0KPiArI2lmZGVmIENPTkZJR19TT0ZUTU1V
DQo+ICtzdGF0aWMgdm9pZCBhZHZhbmNlX3ZpcnR1YWxfdGltZV9fYXN5bmMoQ1BVU3RhdGUg
KmNwdSwgcnVuX29uX2NwdV9kYXRhIGRhdGEpDQo+ICt7DQo+ICsgICAgaW50NjRfdCBuZXdf
dGltZSA9IGRhdGEuaG9zdF91bG9uZzsNCj4gKyAgICBxZW11X2Nsb2NrX2FkdmFuY2Vfdmly
dHVhbF90aW1lKG5ld190aW1lKTsNCj4gK30NCj4gKyNlbmRpZg0KPiArDQo+ICt2b2lkIHFl
bXVfcGx1Z2luX3VwZGF0ZV9ucyhjb25zdCB2b2lkICpoYW5kbGUsIGludDY0X3QgbmV3X3Rp
bWUpDQo+ICt7DQo+ICsjaWZkZWYgQ09ORklHX1NPRlRNTVUNCj4gKyAgICBpZiAoaGFuZGxl
ID09ICZoYXNfY29udHJvbCkgew0KPiArICAgICAgICAvKiBOZWVkIHRvIGV4ZWN1dGUgb3V0
IG9mIGNwdV9leGVjLCBzbyBicWwgY2FuIGJlIGxvY2tlZC4gKi8NCj4gKyAgICAgICAgYXN5
bmNfcnVuX29uX2NwdShjdXJyZW50X2NwdSwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICBhZHZhbmNlX3ZpcnR1YWxfdGltZV9fYXN5bmMsDQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgUlVOX09OX0NQVV9IT1NUX1VMT05HKG5ld190aW1lKSk7DQo+ICsgICAgfQ0KPiAr
I2VuZGlmDQo+ICt9DQo+IGRpZmYgLS1naXQgYS9wbHVnaW5zL3FlbXUtcGx1Z2lucy5zeW1i
b2xzIGIvcGx1Z2lucy9xZW11LXBsdWdpbnMuc3ltYm9scw0KPiBpbmRleCBhYTBhNzdhMzE5
Li5jYTc3M2Q4ZDlmIDEwMDY0NA0KPiAtLS0gYS9wbHVnaW5zL3FlbXUtcGx1Z2lucy5zeW1i
b2xzDQo+ICsrKyBiL3BsdWdpbnMvcWVtdS1wbHVnaW5zLnN5bWJvbHMNCj4gQEAgLTM4LDYg
KzM4LDcgQEANCj4gICAgIHFlbXVfcGx1Z2luX3JlZ2lzdGVyX3ZjcHVfdGJfZXhlY19jb25k
X2NiOw0KPiAgICAgcWVtdV9wbHVnaW5fcmVnaXN0ZXJfdmNwdV90Yl9leGVjX2lubGluZV9w
ZXJfdmNwdTsNCj4gICAgIHFlbXVfcGx1Z2luX3JlZ2lzdGVyX3ZjcHVfdGJfdHJhbnNfY2I7
DQo+ICsgIHFlbXVfcGx1Z2luX3JlcXVlc3RfdGltZV9jb250cm9sOw0KPiAgICAgcWVtdV9w
bHVnaW5fcmVzZXQ7DQo+ICAgICBxZW11X3BsdWdpbl9zY29yZWJvYXJkX2ZyZWU7DQo+ICAg
ICBxZW11X3BsdWdpbl9zY29yZWJvYXJkX2ZpbmQ7DQo+IEBAIC01MSw1ICs1Miw2IEBADQo+
ICAgICBxZW11X3BsdWdpbl91NjRfc2V0Ow0KPiAgICAgcWVtdV9wbHVnaW5fdTY0X3N1bTsN
Cj4gICAgIHFlbXVfcGx1Z2luX3VuaW5zdGFsbDsNCj4gKyAgcWVtdV9wbHVnaW5fdXBkYXRl
X25zOw0KPiAgICAgcWVtdV9wbHVnaW5fdmNwdV9mb3JfZWFjaDsNCj4gICB9Ow0K

