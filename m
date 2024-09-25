Return-Path: <kvm+bounces-27482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E80D98658A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:22:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7559B2131F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8839537F5;
	Wed, 25 Sep 2024 17:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ojr2mec/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A70D520
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284966; cv=none; b=rsfJMwNJ1sVup40CBb0dJSUc+JJG+qyaGc0ZoqXJe0p540+14n9NsLCqvT2BP80gIb0xhcpzd+tfFhRj67h2dOWt7ykjpTpTk/QEmNU61P6Aas8Kjp4rW17NADXSxXPYoWwACfQxE8xmX24ZK+5oxmsUYccER+sHzqych6v4Y1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284966; c=relaxed/simple;
	bh=1cBi18DJbLbtKnO15ZDzgQjdA4tmaG19Gb/9h4A0AB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jZT++J6wfYuFA+HhFo1qwsynVSdr5vSdfh4O0mhtPyPYYUXiD4/uqizYYw4nZxKUpwiTyH0clXxP6gK7044V+BOEYOKytsmXfQzI7s9l3fhCgPDtUWI2JkAl2M1MY3g7UNVPHAiev0SJTWRYKIV74IgwSDLuyOzn1NG5gSh4yWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ojr2mec/; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2054e22ce3fso325895ad.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284964; x=1727889764; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1cBi18DJbLbtKnO15ZDzgQjdA4tmaG19Gb/9h4A0AB8=;
        b=ojr2mec/oYZFfM5JJgaT33lU+AlcAg9LnEpfW74rHx3YLHWCWhvM2l5P7GxN2h3XgS
         gwfa/bGoS4WHgjXXwDsiQ0rE7BepIUP5nO+T/1bBWnUHXQ/h2PMmgVSrgMzJ47ETQmQZ
         RZub+07UUJdZwcu/QvjS18QUGDXnQanUbbXZTSjVoPKZhClpyf0VYFsIQl5LwkMCIDEu
         BmASsQdS413BsjwntVKmhfyXQLAH+d2v2J1SF7gdhYz7H3Uwmglknr2EAw9OfLYLoxVB
         /C/IED4pP+wN1a2EBGcNWS65dB/m09HREkCpu8WVFe8hmCAv8rzzihgcwH+BJKyaPnap
         mR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284964; x=1727889764;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1cBi18DJbLbtKnO15ZDzgQjdA4tmaG19Gb/9h4A0AB8=;
        b=UIkSkblTYTTR1hSHk4wYcu6bxGw9VhJ/aEXAl9RLG/yEe/ZD7VSE5xe5HvmCnVg6n0
         fAWSp+y12qplz4qoMXVfJWXT2PYTIUTovYrWUuTDsdW7mo4Yceg6E12HF7gxfIg52QCL
         IaNaKO/WaYzCvOPDqv+V8/CZqWB4blQ+PCbArIUnMaNgv5YoKEVh6yN50PeeR7wQkjQb
         QjyRbc+8k7RHzsX5J5LeR1ftyYiKzpOeOqKurE2bk1HzMJaLtT5y+97Hez7QhMQ1RnEQ
         ThBUNSXiPdJ55JlH6rbPLJzq8Q8PigBBmSlIG+RAjkhqJolIsXw0np/jTdPz4Px03BIR
         z5Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVZxNciNJ39pfW0tjzyIsadBQ3+sL1m/yuzxTLjIJQmKGblErjxDF74X6Me1oQlhaCPLh4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrjOV3e68fLThdMaFpSeo/QzTgQlQs59ucOr8L9OH9g5D2e8/v
	2Yqi8d99xuNYQ2BZnYmG4uWeAo11EMed68UDPpE05fuCFpedwXL0gkt9xsHOIRI=
X-Google-Smtp-Source: AGHT+IFpe3nBv2xJLPF27RAmV8/+xF723E+vmLXeSWgrX+X++h/lNUxM193xpCw5M0gVTtLxg2Bxwg==
X-Received: by 2002:a17:902:d2c9:b0:206:928c:bfda with SMTP id d9443c01a7336-20afc61cfaamr50046935ad.56.1727284963959;
        Wed, 25 Sep 2024 10:22:43 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20afb021af7sm15136465ad.168.2024.09.25.10.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2024 10:22:43 -0700 (PDT)
Message-ID: <de455384-7929-45df-84fa-7e09c0e86043@linaro.org>
Date: Wed, 25 Sep 2024 10:22:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] maintainer updates (testing, gdbstub)
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Alexandre Iooss <erdnaxe@crans.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, kvm@vger.kernel.org,
 Jiaxun Yang <jiaxun.yang@flygoat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 devel@lists.libvirt.org, Marcelo Tosatti <mtosatti@redhat.com>,
 Laurent Vivier <laurent@vivier.eu>, Yanan Wang <wangyanan55@huawei.com>,
 Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>
References: <20240925171140.1307033-1-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240925171140.1307033-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8yNS8yNCAxMDoxMSwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBXZWxjb21lIHRvIHRo
ZSBmaXJzdCBwb3N0IEtWTSBmb3J1bSBzZXJpZXMuIFdlIGhhdmU6DQo+IA0KPiAgICAtIGZp
eCBmcm9tIElseWEgZm9yIG1pY3JvYmxhemUgYXRvbWljcw0KPiAgICAtIFBpZXJyaWNrJ3Mg
dHNhbiB1cGRhdGVzDQo+ICAgIC0gSSd2ZSBhZGRlZCBteSB0ZXN0aW5nIGFuZCBnZGJzdHVi
IHRyZWVzIHRvIE1BSU5UQUlORVJTDQo+ICAgIC0gZW5hYmxlZCBhIHZlcnkgYmFzaWMgYWFy
Y2g2NF9iZS1saW51eC11c2VyIHRlc3QNCj4gICAgLSBmaXhlZCB0aGUgbWlzc2luZyBnZGIg
WE1MIGZhaWxzIHRoYXQgY2F1c2UgYWFyY2g2NF9iZS1saW51eC11c2VyIHRvIGFzc2VydA0K
PiAgICAtIGZpbmFsbHkgSSd2ZSBtYWRlIHRoZSBtaXBzNjRlbCBjcm9zcyBjb21waWxlciBi
b29rd29ybSBhbmQgYWxsb3dfZmFpbA0KPiANCj4gQWxleCBCZW5uw6llICg2KToNCj4gICAg
dGVzdGluZzogYnVtcCBtaXBzNjRlbCBjcm9zcyB0byBib29rd29ybSBhbmQgYWxsb3cgdG8g
ZmFpbA0KPiAgICB0ZXN0cy9kb2NrZXI6IGFkZCBOT0ZFVENIIGVudiB2YXJpYWJsZSBmb3Ig
dGVzdGluZw0KPiAgICBNQUlOVEFJTkVSUzogbWVudGlvbiBteSB0ZXN0aW5nL25leHQgdHJl
ZQ0KPiAgICBNQUlOVEFJTkVSUzogbWVudGlvbiBteSBnZGJzdHViL25leHQgdHJlZQ0KPiAg
ICBjb25maWcvdGFyZ2V0czogdXBkYXRlIGFhcmNoNjRfYmUtbGludXgtdXNlciBnZGIgWE1M
IGxpc3QNCj4gICAgdGVzdHMvdGNnOiBlbmFibGUgYmFzaWMgdGVzdGluZyBmb3IgYWFyY2g2
NF9iZS1saW51eC11c2VyDQo+IA0KPiBJbHlhIExlb3Noa2V2aWNoICgxKToNCj4gICAgdGVz
dHMvZG9ja2VyOiBGaXggbWljcm9ibGF6ZSBhdG9taWNzDQo+IA0KPiBQaWVycmljayBCb3V2
aWVyICgzKToNCj4gICAgbWVzb246IGhpZGUgdHNhbiByZWxhdGVkIHdhcm5pbmdzDQo+ICAg
IHRhcmdldC9pMzg2OiBmaXggYnVpbGQgd2FybmluZyAoZ2NjLTEyIC1mc2FuaXRpemU9dGhy
ZWFkKQ0KPiAgICBkb2NzL2RldmVsOiB1cGRhdGUgdHNhbiBidWlsZCBkb2N1bWVudGF0aW9u
DQo+IA0KPiAgIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAyICsrDQo+ICAgZG9jcy9kZXZlbC90ZXN0aW5nL21haW4ucnN0ICAgICAgICAgICAg
ICAgICAgIHwgMjYgKysrKysrKysrKystLS0NCj4gICBjb25maWd1cmUgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgNSArKysNCj4gICBjb25maWdzL3RhcmdldHMv
YWFyY2g2NF9iZS1saW51eC11c2VyLm1hayAgICAgfCAgMiArLQ0KPiAgIG1lc29uLmJ1aWxk
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDEwICsrKysrLQ0KPiAgIHRh
cmdldC9pMzg2L2t2bS9rdm0uYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICA0ICstLQ0K
PiAgIHRlc3RzL3RjZy9hYXJjaDY0X2JlL2hlbGxvLmMgICAgICAgICAgICAgICAgICB8IDM1
ICsrKysrKysrKysrKysrKysrKysNCj4gICAuZ2l0bGFiLWNpLmQvY29udGFpbmVyLWNyb3Nz
LnltbCAgICAgICAgICAgICAgfCAgMyArKw0KPiAgIHRlc3RzL2RvY2tlci9NYWtlZmlsZS5p
bmNsdWRlICAgICAgICAgICAgICAgICB8ICA1ICstLQ0KPiAgIC4uLi9idWlsZC10b29sY2hh
aW4uc2ggICAgICAgICAgICAgICAgICAgICAgICB8ICA4ICsrKysrDQo+ICAgLi4uL2RvY2tl
cmZpbGVzL2RlYmlhbi1taXBzNjRlbC1jcm9zcy5kb2NrZXIgIHwgMTAgKysrLS0tDQo+ICAg
Li4uL2RvY2tlcmZpbGVzL2RlYmlhbi10b29sY2hhaW4uZG9ja2VyICAgICAgIHwgIDcgKysr
Kw0KPiAgIHRlc3RzL2xjaXRvb2wvcmVmcmVzaCAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAyICstDQo+ICAgdGVzdHMvdGNnL01ha2VmaWxlLnRhcmdldCAgICAgICAgICAgICAgICAg
ICAgIHwgIDcgKysrLQ0KPiAgIHRlc3RzL3RjZy9hYXJjaDY0X2JlL01ha2VmaWxlLnRhcmdl
dCAgICAgICAgICB8IDE3ICsrKysrKysrKw0KPiAgIDE1IGZpbGVzIGNoYW5nZWQsIDEyNSBp
bnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQg
dGVzdHMvdGNnL2FhcmNoNjRfYmUvaGVsbG8uYw0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0
ZXN0cy90Y2cvYWFyY2g2NF9iZS9NYWtlZmlsZS50YXJnZXQNCj4gDQoNClRoYW5rcyBmb3Ig
cHVsbGluZyB0c2FuIGNoYW5nZXMgYXMgcGFydCBvZiB0aGlzIHNlcmllcy4NCg==

