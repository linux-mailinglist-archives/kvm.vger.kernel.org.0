Return-Path: <kvm+bounces-29581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 258829AD6C5
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 23:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BF301C20AA2
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 21:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB531E2304;
	Wed, 23 Oct 2024 21:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cOBNzqfE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24021ADFE2
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 21:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729719109; cv=none; b=b4EB67b4q6eZg2pCq7AttypFHy1OIsvdF12xp3c0aN885wsuL9HZpVSWdM7QK9Lj0a63umu9PISc0KQq8sfx7J3/A7dTnqhON2F5prYus/HE9DdnsPU8kKk1hXBwPMrZBJZd+NGVzfFITJSwbD0hf8NgWcqo8v6HpqH8wvPK9QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729719109; c=relaxed/simple;
	bh=XMV66Tma+m+DyNkwDKnD2R7rJWyhw+6KbQDPG90Lh9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=laNBcuFmVAMnFL1By4R3hkIcZeOrDeVitGXr7/96YKcT88OKNZMnrm/Cx6qSIUVASbrFMSDdzKs3ZJwM54KHgVNXKxuu6ymq+ax0gSuLZ+exuwn7tDY+tHuOEEgcmnvvUDy27P3NrOwMvrfh4ihoOFa6Ifb+rJlyfzjOXro7wqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cOBNzqfE; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7e6cbf6cd1dso144062a12.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 14:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729719107; x=1730323907; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XMV66Tma+m+DyNkwDKnD2R7rJWyhw+6KbQDPG90Lh9o=;
        b=cOBNzqfEhm11X34cUD5eT8PiHae30fls4b0GpZFzpAWnItrX2QaQfniGh+HkkaLBx9
         321AMlFA/WcKQAVO7nDkF/XlW+MOS+FObl4ksBDf0WHrsKrC6dQskcWr4AS3e+3Jz9Fv
         0U/igtdz6IWotoZ/UTXeIfJyuV6rTmbtjsSAHm26/uGt8QFzSihL6nPB/PMJDAD8XhIM
         fHtJCIM9BXzyXyXxNzACAIbFpQGeIJKQyk6jQ0Acyp57oTtxtHb8CvzkNKl5JGY8ygsz
         KLptb9ox/E61Ol1c7hMj96gDWGJIcDjmF8IIEM9Nkqdr9hDSsik52PeFq8Ny9Ogpu7In
         xYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729719107; x=1730323907;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XMV66Tma+m+DyNkwDKnD2R7rJWyhw+6KbQDPG90Lh9o=;
        b=lt7iAMpArndjcuGhv0LuyQtgWosLhm20PE6kJejijXlARAsZe23g72sJUrdSzs8ETT
         78eL8ER0KUIijtg1RywD2x6TKuQuvRrjj48OHDovFM9zSM/7Pztvt9fBBSNLSViyAIbR
         6ZE2wryo8eDejf97lj+lWk5oWo00caT+s0zzW1UIv6tSdPIciZQlwHy7Pj4ph9lnDAhV
         CFMDqJEk0xecmgKiQUINgex7cH2o3A2ZuFMu38aHxXpTTsoqLKQq7jDCLXjjqpNXz1Dz
         2LXpwW3ra6DVnNTG6tsG6l7ZToTd4bfffROHo/s0jDRBETEX/Vb6Exd75+xzcYDBAtLU
         jnFw==
X-Forwarded-Encrypted: i=1; AJvYcCX3qeUeeAQpiFrV1b1stS0zI0CIF+ToggB1HGkYEEW4ayaNi/Z/U2xND4ngJQW+QMYaVZo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw62VzYJM1dVO+Pcgk4DMzYd2tfikHtp9FByS8jEh2sZ+8Vl7/r
	uzoYlkj4day0uQykefMpWCv+wLoYgQcL9S1qnMhSrEnCUOyKmtfKbvUiuPyQeNI=
X-Google-Smtp-Source: AGHT+IECIPlif+Tu0yu3XBicCEMHLEOzNPxUBgiSXihwbTu2CDR+24J+6/0XGCXXFNeLSWMcYXUV8g==
X-Received: by 2002:a05:6a21:6b0c:b0:1d9:78c:dcf2 with SMTP id adf61e73a8af0-1d978bd32cdmr5191354637.43.1729719106774;
        Wed, 23 Oct 2024 14:31:46 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaec52dd6csm6230401a12.4.2024.10.23.14.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 14:31:46 -0700 (PDT)
Message-ID: <202cd5e2-3732-479d-ab02-67061e2114cc@linaro.org>
Date: Wed, 23 Oct 2024 14:31:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/20] meson: build contrib/plugins with meson
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Beraldo Leal <bleal@redhat.com>,
 Laurent Vivier <laurent@vivier.eu>,
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
 <fe33c996-3241-4706-9ac1-85f00cb8f388@linaro.org>
 <87sesnkxhm.fsf@draig.linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <87sesnkxhm.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjMvMjQgMDE6NTcsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gUGllcnJpY2sgQm91
dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPiB3cml0ZXM6DQo+IA0KPj4gT24g
MTAvMjIvMjQgMDM6NTYsIEFsZXggQmVubsOpZSB3cm90ZToNCj4+PiBGcm9tOiBQaWVycmlj
ayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo+Pj4gVHJpZWQgdG8g
dW5pZnkgdGhpcyBtZXNvbi5idWlsZCB3aXRoIHRlc3RzL3RjZy9wbHVnaW5zL21lc29uLmJ1
aWxkDQo+Pj4gYnV0DQo+Pj4gdGhlIHJlc3VsdGluZyBtb2R1bGVzIGFyZSBub3Qgb3V0cHV0
IGluIHRoZSByaWdodCBkaXJlY3RvcnkuDQo+Pj4gT3JpZ2luYWxseSBwcm9wb3NlZCBieSBB
bnRvbiBLb2Noa292LCB0aGFuayB5b3UhDQo+Pj4gU29sdmVzOiBodHRwczovL2dpdGxhYi5j
b20vcWVtdS1wcm9qZWN0L3FlbXUvLS9pc3N1ZXMvMTcxMA0KPj4+IFNpZ25lZC1vZmYtYnk6
IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+PiBN
ZXNzYWdlLUlkOiA8MjAyNDA5MjUyMDQ4NDUuMzkwNjg5LTItcGllcnJpY2suYm91dmllckBs
aW5hcm8ub3JnPg0KPj4+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5u
ZWVAbGluYXJvLm9yZz4NCj4+PiAtLS0NCj4+PiAgICBtZXNvbi5idWlsZCAgICAgICAgICAg
ICAgICAgfCAgNCArKysrDQo+Pj4gICAgY29udHJpYi9wbHVnaW5zL21lc29uLmJ1aWxkIHwg
MjMgKysrKysrKysrKysrKysrKysrKysrKysNCj4+PiAgICAyIGZpbGVzIGNoYW5nZWQsIDI3
IGluc2VydGlvbnMoKykNCj4+PiAgICBjcmVhdGUgbW9kZSAxMDA2NDQgY29udHJpYi9wbHVn
aW5zL21lc29uLmJ1aWxkDQo+Pj4gZGlmZiAtLWdpdCBhL21lc29uLmJ1aWxkIGIvbWVzb24u
YnVpbGQNCj4+PiBpbmRleCBiZGQ2N2EyZDZkLi4zZWEwM2M0NTFiIDEwMDY0NA0KPj4+IC0t
LSBhL21lc29uLmJ1aWxkDQo+Pj4gKysrIGIvbWVzb24uYnVpbGQNCj4+PiBAQCAtMzY3OCw2
ICszNjc4LDEwIEBAIHN1YmRpcignYWNjZWwnKQ0KPj4+ICAgIHN1YmRpcigncGx1Z2lucycp
DQo+Pj4gICAgc3ViZGlyKCdlYnBmJykNCj4+PiAgICAraWYgJ0NPTkZJR19UQ0cnIGluIGNv
bmZpZ19hbGxfYWNjZWwNCj4+PiArICBzdWJkaXIoJ2NvbnRyaWIvcGx1Z2lucycpDQo+Pj4g
K2VuZGlmDQo+Pj4gKw0KPj4+ICAgIGNvbW1vbl91c2VyX2luYyA9IFtdDQo+Pj4gICAgICBz
dWJkaXIoJ2NvbW1vbi11c2VyJykNCj4+PiBkaWZmIC0tZ2l0IGEvY29udHJpYi9wbHVnaW5z
L21lc29uLmJ1aWxkIGIvY29udHJpYi9wbHVnaW5zL21lc29uLmJ1aWxkDQo+Pj4gbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCj4+PiBpbmRleCAwMDAwMDAwMDAwLi5hMGUwMjZkMjVlDQo+Pj4g
LS0tIC9kZXYvbnVsbA0KPj4+ICsrKyBiL2NvbnRyaWIvcGx1Z2lucy9tZXNvbi5idWlsZA0K
Pj4+IEBAIC0wLDAgKzEsMjMgQEANCj4+PiArdCA9IFtdDQo+Pj4gK2lmIGdldF9vcHRpb24o
J3BsdWdpbnMnKQ0KPj4+ICsgIGZvcmVhY2ggaSA6IFsnY2FjaGUnLCAnZHJjb3YnLCAnZXhl
Y2xvZycsICdob3RibG9ja3MnLCAnaG90cGFnZXMnLCAnaG93dmVjJywNCj4+PiArICAgICAg
ICAgICAgICAgJ2h3cHJvZmlsZScsICdpcHMnLCAnbG9ja3N0ZXAnLCAnc3RvcHRyaWdnZXIn
XQ0KPj4NCj4+IGxvY2tzdGVwIGRvZXMgbm90IGJ1aWxkIHVuZGVyIFdpbmRvd3MgKGl0IHVz
ZXMgc29ja2V0cyksIHNvIGl0IHNob3VsZA0KPj4gYmUgY29uZGl0aW9ubmFsbHkgbm90IGJ1
aWx0IG9uIHRoaXMgcGxhdGZvcm0uDQo+PiBAQWxleCwgaWYgeW91IGZlZWwgbGlrZSBtb2Rp
ZnlpbmcgdGhpcywgeW91IGNhbi4gSWYgbm90LCB5b3UgY2FuIGRyb3ANCj4+IHRoZSBtZXNv
biBidWlsZCBwYXRjaGVzIGZyb20gdGhpcyBzZXJpZXMgdG8gbm90IGJsb2NrIGl0Lg0KPiAN
Cj4gSSdsbCBkcm9wIGZyb20gdGhlIFBSIGFuZCBsZXQgeW91IHJlLXN1Ym1pdC4NCj4gDQoN
ClNlbnQgYSB2MyB3aXRoIHdpbmRvd3MgZml4Og0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
cWVtdS1kZXZlbC8yMDI0MTAyMzIxMjgxMi4xMzc2OTcyLTEtcGllcnJpY2suYm91dmllckBs
aW5hcm8ub3JnL1QvI3QNCg0KVGhhbmtzLA0KUGllcnJpY2sNCg==

