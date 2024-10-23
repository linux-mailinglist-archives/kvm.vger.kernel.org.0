Return-Path: <kvm+bounces-29468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 694659AC0A9
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 09:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24AF528429E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 07:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0885155A59;
	Wed, 23 Oct 2024 07:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jSC7OSaG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C1D15443C
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 07:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729669896; cv=none; b=jobG5qd7wCkn4EexnyX3Yh+qpTbl+jD30abOK7HmubLNbqryYiBLPJXlcos1r+yIX0CcIggyIPop+RhTEXHNgDaNmsfXwlOCaTvaPPc6IRsLueWfPHr9RJICkRmH7C/zgWyhKlRYggORqd83qOaUm3yuaDb4k8uzCzxO35GMsWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729669896; c=relaxed/simple;
	bh=MepkjDJ2ngcxljXy3snTzhEiovBpyY4ILIqybTz6Vcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pctv2BHXmakXrI+3tNMfSOQTGRgk9d8wD3HD6/3Weouz/1D0j7la30IMLIx7A71Bzq4N9LrUwn63F759ouNSL43AGxn2At6yObKykCqM2ynT3mVrveUy69fYYRFLrpsamK3GSIs74pYxfCq3GlQcqSmeYMNjXX94BA9nSQLcQPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jSC7OSaG; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20c70abba48so54341985ad.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 00:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729669894; x=1730274694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MepkjDJ2ngcxljXy3snTzhEiovBpyY4ILIqybTz6Vcw=;
        b=jSC7OSaGFNPmozZT3Y/r5aKrxHcjUfqLSwdPxDtwvO1xAco6d0mkiQL9Sl9vIKPrpO
         cS1YLBtt9kN9bKPLy/fPp1YqeSjIaw+0QmvuLoehRB7O4nWPzvvOlxUJKLNLSmoH7Igb
         sAJtFsXLq9jgI3LOyHKL1uHNugEXDzZxFpcDz6DuXclV4Edvfpb2abSPA7mymaVy7PFd
         iNHOTZlU1gA1Zs7DMQu2tj9qdGO1ZAE5XFTLQ4ROs61M/Anb0j2rQLSzvr0l/UfNdTj/
         CkskeN2ZSNToaxjfTLCpNoF9uOJBYUVL1ITns+zX3P10Ld/VBCVkROSex4TfE8iaLPUv
         EZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729669894; x=1730274694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MepkjDJ2ngcxljXy3snTzhEiovBpyY4ILIqybTz6Vcw=;
        b=mJayns/yRBC2Ayz89MzhIyn+YHnWw8xb60RJN+dvUQlEWpfhKypgS0XhwSWx51+czs
         DU54mlYtx/LUYf39fYe60k4cXbgUdWnjwJvmtv4OzVFJUOAMoXH8reFMqX3XOPCkuXyC
         DX3nvijV9kmeLGky96Ne4gFD/IdKrxO50HNsqgroBRyg7T9HBwBrVWYyErXZeZfpCw81
         VkQ+hQoDbY3KLL/tQY+CTiBZnJkSWvoUmr4tEFx9iYh9aY02/b9ZnO/FseztfCHbGn2J
         /uRhcGdtXTbosoCAm91fwjnijUnBSraYRjNr9It0IR98NKd6y0PS4Jz/Z8Trp4j2QqTD
         dTtA==
X-Forwarded-Encrypted: i=1; AJvYcCUJHOi1DiPUjpmpliVmGt3DfdbRxvUXFiKNF/jD9qpg3BP629kxwFtFtLgNqOFhj2AQBik=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHc/EauhyAFofSPjNkl1MLfSwAsGDxYH8H7IZR7hoefbKcnKpJ
	/mwspQp3/r5UPA2ipF9fSW/Y3G3nHZuPH47RqvzaiULXiPm5kmsNqLuok3hM86A=
X-Google-Smtp-Source: AGHT+IGNBB4bbKqXJ3Wb1+fBO9LhwIz0J+plK6Cd2LbsP0Eo4zu0cRnOrM5NJnHjCVrMqBXhu4NedQ==
X-Received: by 2002:a17:903:22ce:b0:20c:ce9c:bbb0 with SMTP id d9443c01a7336-20fa7074a94mr22409375ad.0.1729669893937;
        Wed, 23 Oct 2024 00:51:33 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0cc12sm52872905ad.95.2024.10.23.00.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 00:51:33 -0700 (PDT)
Message-ID: <fe33c996-3241-4706-9ac1-85f00cb8f388@linaro.org>
Date: Wed, 23 Oct 2024 00:51:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/20] meson: build contrib/plugins with meson
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
 Paolo Bonzini <pbonzini@redhat.com>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
 <20241022105614.839199-19-alex.bennee@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20241022105614.839199-19-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMDM6NTYsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gRnJvbTogUGllcnJp
Y2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KPiANCj4gVHJpZWQg
dG8gdW5pZnkgdGhpcyBtZXNvbi5idWlsZCB3aXRoIHRlc3RzL3RjZy9wbHVnaW5zL21lc29u
LmJ1aWxkIGJ1dA0KPiB0aGUgcmVzdWx0aW5nIG1vZHVsZXMgYXJlIG5vdCBvdXRwdXQgaW4g
dGhlIHJpZ2h0IGRpcmVjdG9yeS4NCj4gDQo+IE9yaWdpbmFsbHkgcHJvcG9zZWQgYnkgQW50
b24gS29jaGtvdiwgdGhhbmsgeW91IQ0KPiANCj4gU29sdmVzOiBodHRwczovL2dpdGxhYi5j
b20vcWVtdS1wcm9qZWN0L3FlbXUvLS9pc3N1ZXMvMTcxMA0KPiBTaWduZWQtb2ZmLWJ5OiBQ
aWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo+IE1lc3Nh
Z2UtSWQ6IDwyMDI0MDkyNTIwNDg0NS4zOTA2ODktMi1waWVycmljay5ib3V2aWVyQGxpbmFy
by5vcmc+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGlu
YXJvLm9yZz4NCj4gLS0tDQo+ICAgbWVzb24uYnVpbGQgICAgICAgICAgICAgICAgIHwgIDQg
KysrKw0KPiAgIGNvbnRyaWIvcGx1Z2lucy9tZXNvbi5idWlsZCB8IDIzICsrKysrKysrKysr
KysrKysrKysrKysrDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspDQo+
ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGNvbnRyaWIvcGx1Z2lucy9tZXNvbi5idWlsZA0KPiAN
Cj4gZGlmZiAtLWdpdCBhL21lc29uLmJ1aWxkIGIvbWVzb24uYnVpbGQNCj4gaW5kZXggYmRk
NjdhMmQ2ZC4uM2VhMDNjNDUxYiAxMDA2NDQNCj4gLS0tIGEvbWVzb24uYnVpbGQNCj4gKysr
IGIvbWVzb24uYnVpbGQNCj4gQEAgLTM2NzgsNiArMzY3OCwxMCBAQCBzdWJkaXIoJ2FjY2Vs
JykNCj4gICBzdWJkaXIoJ3BsdWdpbnMnKQ0KPiAgIHN1YmRpcignZWJwZicpDQo+ICAgDQo+
ICtpZiAnQ09ORklHX1RDRycgaW4gY29uZmlnX2FsbF9hY2NlbA0KPiArICBzdWJkaXIoJ2Nv
bnRyaWIvcGx1Z2lucycpDQo+ICtlbmRpZg0KPiArDQo+ICAgY29tbW9uX3VzZXJfaW5jID0g
W10NCj4gICANCj4gICBzdWJkaXIoJ2NvbW1vbi11c2VyJykNCj4gZGlmZiAtLWdpdCBhL2Nv
bnRyaWIvcGx1Z2lucy9tZXNvbi5idWlsZCBiL2NvbnRyaWIvcGx1Z2lucy9tZXNvbi5idWls
ZA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwLi5hMGUwMjZk
MjVlDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvY29udHJpYi9wbHVnaW5zL21lc29uLmJ1
aWxkDQo+IEBAIC0wLDAgKzEsMjMgQEANCj4gK3QgPSBbXQ0KPiAraWYgZ2V0X29wdGlvbign
cGx1Z2lucycpDQo+ICsgIGZvcmVhY2ggaSA6IFsnY2FjaGUnLCAnZHJjb3YnLCAnZXhlY2xv
ZycsICdob3RibG9ja3MnLCAnaG90cGFnZXMnLCAnaG93dmVjJywNCj4gKyAgICAgICAgICAg
ICAgICdod3Byb2ZpbGUnLCAnaXBzJywgJ2xvY2tzdGVwJywgJ3N0b3B0cmlnZ2VyJ10NCg0K
bG9ja3N0ZXAgZG9lcyBub3QgYnVpbGQgdW5kZXIgV2luZG93cyAoaXQgdXNlcyBzb2NrZXRz
KSwgc28gaXQgc2hvdWxkIGJlIA0KY29uZGl0aW9ubmFsbHkgbm90IGJ1aWx0IG9uIHRoaXMg
cGxhdGZvcm0uDQpAQWxleCwgaWYgeW91IGZlZWwgbGlrZSBtb2RpZnlpbmcgdGhpcywgeW91
IGNhbi4gSWYgbm90LCB5b3UgY2FuIGRyb3AgDQp0aGUgbWVzb24gYnVpbGQgcGF0Y2hlcyBm
cm9tIHRoaXMgc2VyaWVzIHRvIG5vdCBibG9jayBpdC4NCg0KPiArICAgIGlmIGhvc3Rfb3Mg
PT0gJ3dpbmRvd3MnDQo+ICsgICAgICB0ICs9IHNoYXJlZF9tb2R1bGUoaSwgZmlsZXMoaSAr
ICcuYycpICsgJ3dpbjMyX2xpbmtlci5jJywNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
IGluY2x1ZGVfZGlyZWN0b3JpZXM6ICcuLi8uLi9pbmNsdWRlL3FlbXUnLA0KPiArICAgICAg
ICAgICAgICAgICAgICAgICAgbGlua19kZXBlbmRzOiBbd2luMzJfcWVtdV9wbHVnaW5fYXBp
X2xpYl0sDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICBsaW5rX2FyZ3M6IFsnLUxwbHVn
aW5zJywgJy1scWVtdV9wbHVnaW5fYXBpJ10sDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICBkZXBlbmRlbmNpZXM6IGdsaWIpDQo+ICsNCj4gKyAgICBlbHNlDQo+ICsgICAgICB0ICs9
IHNoYXJlZF9tb2R1bGUoaSwgZmlsZXMoaSArICcuYycpLA0KPiArICAgICAgICAgICAgICAg
ICAgICAgICAgaW5jbHVkZV9kaXJlY3RvcmllczogJy4uLy4uL2luY2x1ZGUvcWVtdScsDQo+
ICsgICAgICAgICAgICAgICAgICAgICAgICBkZXBlbmRlbmNpZXM6IGdsaWIpDQo+ICsgICAg
ZW5kaWYNCj4gKyAgZW5kZm9yZWFjaA0KPiArZW5kaWYNCj4gK2lmIHQubGVuZ3RoKCkgPiAw
DQo+ICsgIGFsaWFzX3RhcmdldCgnY29udHJpYi1wbHVnaW5zJywgdCkNCj4gK2Vsc2UNCj4g
KyAgcnVuX3RhcmdldCgnY29udHJpYi1wbHVnaW5zJywgY29tbWFuZDogZmluZF9wcm9ncmFt
KCd0cnVlJykpDQo+ICtlbmRpZg0K

