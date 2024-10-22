Return-Path: <kvm+bounces-29438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8836A9AB7C6
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:39:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C12A1F23B32
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 20:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970521CC89F;
	Tue, 22 Oct 2024 20:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qm2UR1WB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419541A2872
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 20:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729629590; cv=none; b=hyVRTDEmt0BZxpY8rV7/gwr88NBYPgVS1Qa73eCnjuDuxqwgXlyxUnKWYrD2ercow5EkRSN8W/SOnSJDea5xQWtFCe6kC6ZEIxRSNh4sMqinrgotnmW3GP1qWQevJ8m67y/z/pfwzX3OiTizCZp2B/Ch7fwt7ERcEp1MKfd9QWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729629590; c=relaxed/simple;
	bh=8716lgN4vd3OakIyJc2Ibs0xllERoZjKZIQIBT2RF3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rErzzQGtbKZcd8al3FqDpNjAv3VgqGs/wAhAEN+TcSUA9/E6R+HB6rBl9ZDuZnkjsplrkgezMCgSEZ2zT+Xvr4otgMbBE216Qv5P12RmPgF9tSbBh1z0DPCbBJnJ6EdAlOCzTsAuBygJlyWuW0Lt60mkcrfOHas7+YUO4EFD4EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Qm2UR1WB; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e30db524c2so4519096a91.1
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729629588; x=1730234388; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8716lgN4vd3OakIyJc2Ibs0xllERoZjKZIQIBT2RF3o=;
        b=Qm2UR1WBQpXPpQFDOuefrAqLzmivHeuPDj5ftD00uiMW/7SGZ+NH5sCsE0lNXgyAm2
         dkC8tNuO6V/fpAaXKD4Km9LwqhKYsNzj06YghJk3djQajj7rkRSV3zvl4X730accxT6Q
         +llGtu5c7ldmtnSv2VYmVOsE0B9PNFZD0shIG7FUNPg5GvrvZJbcVyL7GcIRvqg1gLBe
         z37VhBcUr19j0XuJRE0aTCsDbDvtHq+5qWT34Df4gX4KkxshdrFub7XKdVtF7/GYsG3B
         /baxCESBj6nhGpFkmb3Rw4G1pMlxENSSfupKI7EaYblUiaNr/sUYCa7BHnIsXYA+EJrY
         yNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729629588; x=1730234388;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8716lgN4vd3OakIyJc2Ibs0xllERoZjKZIQIBT2RF3o=;
        b=DS/RitEWv1fSOm2t19pHfqJZ+tZUTZDcUK53Grq0/XAi4pi3yxXMwZ8poHvdh7f2v0
         xbBDUawNbdeDHw7cGfvygtggtj6tWy6tGhXrZvzt36pSdHSGuhyF7iLbKgldl7exjBIF
         h/SjTYwqzEMeOqgQrryZebv+CauDDjkpiUMy5uDcbVNlfkQdlUcKbj7dzscughL/feAs
         iDD9X9oYMez+I+Twqs8u5mzzu7F0luagUx97WSuqhNvHRLKwq9Cl0cRp4X+9RSporQx9
         iaIrIcWDpzZN7BdEIZecLeMrir4QR3l1RMQsgBP8FXLwQNbiRvyw+18G85PB4598AJX4
         OBkw==
X-Forwarded-Encrypted: i=1; AJvYcCWwAeP+61l8Gw0jMADaXdsLDQ4oPuNV22frwg+FGU1w3yUffdYWDFQaptkfWKWviFCBeqE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOEP6g+wF0w3ipS+Mq3XAwXL9TO18/oZ2k6Fpbd9PlaRcdGR+U
	Fm7FO40I/x+ZIenymcb7QZxy0ABBUZfTja6oDv46K4o/L6cHq3zLSw6htXBnJ1M=
X-Google-Smtp-Source: AGHT+IF1OaRSF/uO0aEsCCNn9rL9J/Dcu/AyvZOh73bRHQ8pyrVuOGOlGXYGIiRXLfzK3teLBdcL9A==
X-Received: by 2002:a17:90b:4b0d:b0:2c8:65cf:e820 with SMTP id 98e67ed59e1d1-2e76b5b6b34mr236574a91.2.1729629588547;
        Tue, 22 Oct 2024 13:39:48 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad389146sm6646573a91.26.2024.10.22.13.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 13:39:48 -0700 (PDT)
Message-ID: <244addee-9fa0-4476-aa40-a4a316336e61@linaro.org>
Date: Tue, 22 Oct 2024 13:39:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/20] testing: Enhance gdb probe script
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, Laurent Vivier <laurent@vivier.eu>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Yanan Wang <wangyanan55@huawei.com>,
 Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 devel@lists.libvirt.org, Cleber Rosa <crosa@redhat.com>,
 kvm@vger.kernel.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Alexandre Iooss <erdnaxe@crans.org>,
 Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Riku Voipio <riku.voipio@iki.fi>, Zhao Liu <zhao1.liu@intel.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Gustavo Romero <gustavo.romero@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
 <20241022105614.839199-16-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20241022105614.839199-16-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMDM6NTYsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gRnJvbTogR3VzdGF2
byBSb21lcm8gPGd1c3Rhdm8ucm9tZXJvQGxpbmFyby5vcmc+DQo+IA0KPiBVc2UgbGlzdCBh
bmQgc2V0IGNvbXByZWhlbnNpb24gdG8gc2ltcGxpZnkgY29kZS4gQWxzbywgZ2VudGx5IGhh
bmRsZQ0KPiBpbnZhbGlkIGdkYiBmaWxlbmFtZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBH
dXN0YXZvIFJvbWVybyA8Z3VzdGF2by5yb21lcm9AbGluYXJvLm9yZz4NCj4gTWVzc2FnZS1J
ZDogPDIwMjQxMDE1MTQ1ODQ4LjM4NzI4MS0xLWd1c3Rhdm8ucm9tZXJvQGxpbmFyby5vcmc+
DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9y
Zz4NCj4gLS0tDQo+ICAgc2NyaXB0cy9wcm9iZS1nZGItc3VwcG9ydC5weSB8IDc1ICsrKysr
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAz
OSBpbnNlcnRpb25zKCspLCAzNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9z
Y3JpcHRzL3Byb2JlLWdkYi1zdXBwb3J0LnB5IGIvc2NyaXB0cy9wcm9iZS1nZGItc3VwcG9y
dC5weQ0KPiBpbmRleCA2ZGM1OGQwNmM3Li42YmNhZGNlMTUwIDEwMDY0NA0KPiAtLS0gYS9z
Y3JpcHRzL3Byb2JlLWdkYi1zdXBwb3J0LnB5DQo+ICsrKyBiL3NjcmlwdHMvcHJvYmUtZ2Ri
LXN1cHBvcnQucHkNCj4gQEAgLTE5LDU4ICsxOSw2MSBAQA0KPiAgIA0KPiAgIGltcG9ydCBh
cmdwYXJzZQ0KPiAgIGltcG9ydCByZQ0KPiAtZnJvbSBzdWJwcm9jZXNzIGltcG9ydCBjaGVj
a19vdXRwdXQsIFNURE9VVA0KPiArZnJvbSBzdWJwcm9jZXNzIGltcG9ydCBjaGVja19vdXRw
dXQsIFNURE9VVCwgQ2FsbGVkUHJvY2Vzc0Vycm9yDQo+ICtpbXBvcnQgc3lzDQo+ICAgDQo+
IC0jIG1hcHBpbmdzIGZyb20gZ2RiIGFyY2ggdG8gUUVNVSB0YXJnZXQNCj4gLW1hcHBpbmdz
ID0gew0KPiAtICAgICJhbHBoYSIgOiAiYWxwaGEiLA0KPiArIyBNYXBwaW5ncyBmcm9tIGdk
YiBhcmNoIHRvIFFFTVUgdGFyZ2V0DQo+ICtNQVAgPSB7DQo+ICsgICAgImFscGhhIiA6IFsi
YWxwaGEiXSwNCj4gICAgICAgImFhcmNoNjQiIDogWyJhYXJjaDY0IiwgImFhcmNoNjRfYmUi
XSwNCj4gLSAgICAiYXJtdjciOiAiYXJtIiwNCj4gKyAgICAiYXJtdjciOiBbImFybSJdLA0K
PiAgICAgICAiYXJtdjgtYSIgOiBbImFhcmNoNjQiLCAiYWFyY2g2NF9iZSJdLA0KPiAtICAg
ICJhdnIiIDogImF2ciIsDQo+ICsgICAgImF2ciIgOiBbImF2ciJdLA0KPiAgICAgICAjIG5v
IGhleGFnb24gaW4gdXBzdHJlYW0gZ2RiDQo+IC0gICAgImhwcGExLjAiIDogImhwcGEiLA0K
PiAtICAgICJpMzg2IiA6ICJpMzg2IiwNCj4gLSAgICAiaTM4Njp4ODYtNjQiIDogIng4Nl82
NCIsDQo+IC0gICAgIkxvb25nYXJjaDY0IiA6ICJsb29uZ2FyY2g2NCIsDQo+IC0gICAgIm02
OGsiIDogIm02OGsiLA0KPiAtICAgICJNaWNyb0JsYXplIiA6ICJtaWNyb2JsYXplIiwNCj4g
KyAgICAiaHBwYTEuMCIgOiBbImhwcGEiXSwNCj4gKyAgICAiaTM4NiIgOiBbImkzODYiXSwN
Cj4gKyAgICAiaTM4Njp4ODYtNjQiIDogWyJ4ODZfNjQiXSwNCj4gKyAgICAiTG9vbmdhcmNo
NjQiIDogWyJsb29uZ2FyY2g2NCJdLA0KPiArICAgICJtNjhrIiA6IFsibTY4ayJdLA0KPiAr
ICAgICJNaWNyb0JsYXplIiA6IFsibWljcm9ibGF6ZSJdLA0KPiAgICAgICAibWlwczppc2E2
NCIgOiBbIm1pcHM2NCIsICJtaXBzNjRlbCJdLA0KPiAtICAgICJvcjFrIiA6ICJvcjFrIiwN
Cj4gLSAgICAicG93ZXJwYzpjb21tb24iIDogInBwYyIsDQo+ICsgICAgIm9yMWsiIDogWyJv
cjFrIl0sDQo+ICsgICAgInBvd2VycGM6Y29tbW9uIiA6IFsicHBjIl0sDQo+ICAgICAgICJw
b3dlcnBjOmNvbW1vbjY0IiA6IFsicHBjNjQiLCAicHBjNjRsZSJdLA0KPiAtICAgICJyaXNj
djpydjMyIiA6ICJyaXNjdjMyIiwNCj4gLSAgICAicmlzY3Y6cnY2NCIgOiAicmlzY3Y2NCIs
DQo+IC0gICAgInMzOTA6NjQtYml0IiA6ICJzMzkweCIsDQo+ICsgICAgInJpc2N2OnJ2MzIi
IDogWyJyaXNjdjMyIl0sDQo+ICsgICAgInJpc2N2OnJ2NjQiIDogWyJyaXNjdjY0Il0sDQo+
ICsgICAgInMzOTA6NjQtYml0IiA6IFsiczM5MHgiXSwNCj4gICAgICAgInNoNCIgOiBbInNo
NCIsICJzaDRlYiJdLA0KPiAtICAgICJzcGFyYyI6ICJzcGFyYyIsDQo+IC0gICAgInNwYXJj
OnY4cGx1cyI6ICJzcGFyYzMycGx1cyIsDQo+IC0gICAgInNwYXJjOnY5YSIgOiAic3BhcmM2
NCIsDQo+ICsgICAgInNwYXJjIjogWyJzcGFyYyJdLA0KPiArICAgICJzcGFyYzp2OHBsdXMi
OiBbInNwYXJjMzJwbHVzIl0sDQo+ICsgICAgInNwYXJjOnY5YSIgOiBbInNwYXJjNjQiXSwN
Cj4gICAgICAgIyBubyB0cmljb3JlIGluIHVwc3RyZWFtIGdkYg0KPiAgICAgICAieHRlbnNh
IiA6IFsieHRlbnNhIiwgInh0ZW5zYWViIl0NCj4gICB9DQo+ICAgDQo+ICsNCj4gICBkZWYg
ZG9fcHJvYmUoZ2RiKToNCj4gLSAgICBnZGJfb3V0ID0gY2hlY2tfb3V0cHV0KFtnZGIsDQo+
IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgIi1leCIsICJzZXQgYXJjaGl0ZWN0dXJl
IiwNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAiLWV4IiwgInF1aXQiXSwgc3Rk
ZXJyPVNURE9VVCkNCj4gKyAgICB0cnk6DQo+ICsgICAgICAgIGdkYl9vdXQgPSBjaGVja19v
dXRwdXQoW2dkYiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiLWV4Iiwg
InNldCBhcmNoaXRlY3R1cmUiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICItZXgiLCAicXVpdCJdLCBzdGRlcnI9U1RET1VULCBlbmNvZGluZz0idXRmLTgiKQ0KPiAr
ICAgIGV4Y2VwdCAoT1NFcnJvcikgYXMgZToNCj4gKyAgICAgICAgc3lzLmV4aXQoZSkNCj4g
KyAgICBleGNlcHQgQ2FsbGVkUHJvY2Vzc0Vycm9yIGFzIGU6DQo+ICsgICAgICAgIHN5cy5l
eGl0KGYne2V9LiBPdXRwdXQ6XG5cbntlLm91dHB1dH0nKQ0KPiArDQo+ICsgICAgZm91bmRf
Z2RiX2FyY2hzID0gcmUuc2VhcmNoKHInVmFsaWQgYXJndW1lbnRzIGFyZSAoLiopJywgZ2Ri
X291dCkNCj4gICANCj4gLSAgICBtID0gcmUuc2VhcmNoKHIiVmFsaWQgYXJndW1lbnRzIGFy
ZSAoLiopIiwNCj4gLSAgICAgICAgICAgICAgICAgIGdkYl9vdXQuZGVjb2RlKCJ1dGYtOCIp
KQ0KPiArICAgIHRhcmdldHMgPSBzZXQoKQ0KPiArICAgIGlmIGZvdW5kX2dkYl9hcmNoczoN
Cj4gKyAgICAgICAgZ2RiX2FyY2hzID0gZm91bmRfZ2RiX2FyY2hzLmdyb3VwKDEpLnNwbGl0
KCIsICIpDQo+ICsgICAgICAgIG1hcHBlZF9nZGJfYXJjaHMgPSBbYXJjaCBmb3IgYXJjaCBp
biBnZGJfYXJjaHMgaWYgYXJjaCBpbiBNQVBdDQo+ICAgDQo+IC0gICAgdmFsaWRfYXJjaGVz
ID0gc2V0KCkNCj4gKyAgICAgICAgdGFyZ2V0cyA9IHt0YXJnZXQgZm9yIGFyY2ggaW4gbWFw
cGVkX2dkYl9hcmNocyBmb3IgdGFyZ2V0IGluIE1BUFthcmNoXX0NCj4gICANCj4gLSAgICBp
ZiBtLmdyb3VwKDEpOg0KPiAtICAgICAgICBmb3IgYXJjaCBpbiBtLmdyb3VwKDEpLnNwbGl0
KCIsICIpOg0KPiAtICAgICAgICAgICAgaWYgYXJjaCBpbiBtYXBwaW5nczoNCj4gLSAgICAg
ICAgICAgICAgICBtYXBwaW5nID0gbWFwcGluZ3NbYXJjaF0NCj4gLSAgICAgICAgICAgICAg
ICBpZiBpc2luc3RhbmNlKG1hcHBpbmcsIHN0cik6DQo+IC0gICAgICAgICAgICAgICAgICAg
IHZhbGlkX2FyY2hlcy5hZGQobWFwcGluZykNCj4gLSAgICAgICAgICAgICAgICBlbHNlOg0K
PiAtICAgICAgICAgICAgICAgICAgICBmb3IgZW50cnkgaW4gbWFwcGluZzoNCj4gLSAgICAg
ICAgICAgICAgICAgICAgICAgIHZhbGlkX2FyY2hlcy5hZGQoZW50cnkpDQo+ICsgICAgIyBR
RU1VIHRhcmdldHMNCj4gKyAgICByZXR1cm4gdGFyZ2V0cw0KPiAgIA0KPiAtICAgIHJldHVy
biB2YWxpZF9hcmNoZXMNCj4gICANCj4gICBkZWYgbWFpbigpIC0+IE5vbmU6DQo+ICAgICAg
IHBhcnNlciA9IGFyZ3BhcnNlLkFyZ3VtZW50UGFyc2VyKGRlc2NyaXB0aW9uPSdQcm9iZSBH
REIgQXJjaGl0ZWN0dXJlcycpDQoNClJldmlld2VkLWJ5OiBQaWVycmljayBCb3V2aWVyIDxw
aWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo=

