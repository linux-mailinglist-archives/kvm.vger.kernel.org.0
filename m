Return-Path: <kvm+bounces-41421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 60EACA67B65
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:53:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33A3E7A342B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4BC212D83;
	Tue, 18 Mar 2025 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hIEdXsnl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679C20F091
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 17:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320380; cv=none; b=VM0lJqpzZJoxVRi2TcQo3rtYYpF1tTFGrD8GM6m2gmYvLvxitkVHcPHZw+AfggGsBNurU9sH+PBKwqXaGjoVxEQjdPE4dNsDUnq2IVwYcp2C3CoTmyrvYtdZhN9iT7nb0CC5OKgFJ7k/6hKdIImAxKiBHSb+5zKVqoCQvCnHMEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320380; c=relaxed/simple;
	bh=E9yUCUro9/6dtE85RT/r5RnqitV+tJ76OF97vhv+iRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eHstTZ8subE3G+gebrUcyxMCMO28YjfrPvRPuNTVD1qC/7nYxK92D0Ui5AvY+vI+XgRhuNUcTRHTiXuBTURQwG+cwZ0g7ODxMtbVfvO704iu3MprxDGKhhpfEp2vHd3Y19FhFW7sbhudw03uNUuMse6m60UrWBta593Ce0hDYhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hIEdXsnl; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-225df540edcso86014335ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 10:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742320378; x=1742925178; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E9yUCUro9/6dtE85RT/r5RnqitV+tJ76OF97vhv+iRY=;
        b=hIEdXsnl4pl2OTqT4HZKzgT/1jLEM8fMCKdI9Rf36dEYcbMhhhqaVDDHYGEzKnM59x
         tbWp1LMkWBG0dvokNDEpNTucQ/KVHj1ZOe5fnjMhRaxEww85cXr2kAn9SYafsbX34ZMS
         WoGc9J3lNpNjPheXdck5XibB71S17yRejSbGK+GXG0kJCBTClswLI9G+0JoYYHsrZTU5
         BJjPFdaequXr/YK/fZ8UFSKVgmCLf1n4LzK39+HPXa95/QOMQDffvMAX82CWik2WMguT
         vjPp3AqA5qhQvHurDd8FjjjJQAwzRSr1o21jR/69ZeRE4eGu66/IEzUjzvAbGTf7pjvk
         Tuhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320378; x=1742925178;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9yUCUro9/6dtE85RT/r5RnqitV+tJ76OF97vhv+iRY=;
        b=vx0fFXMQpcLpPHHi/cSuxK3RpKKJmCP6qo9UHY2rplvGdXAxzYxQ6Z/rgUd1TSkDHA
         EGzWCAb2tiLbR9dw3FucdtoGhqITwiGjbb1DewectEi16GxIUe9Lrpx4Ffl9CY/R6Wgi
         TIKPu3uiPoVTv8HLzaJtkG8Akk8NnGpKD8MXVpbUptZPNlViI3cBG5dxLyxd0aR+OTzq
         BffPVpOwLGFkqfWfN//2ndmlSYs+vKKbYm2s5sr510d32aHr3KS4uiLqMnJqlYcc0CtM
         T/4cy7MAbH0Sjym0AIZTCJiVMKuhFxw+XUlHzAUiYbVrw3kEz5GT3Qkju25mHak6xKwG
         0yXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdFh96SA0eMyFQf/MO9Rq55fIouGMpvLNPxcjJNK7GWX9qip+6JHO2IpvUNpUqZgJr4wI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFQJudMcnExtDoXPh8NotVWqHxjiHWGEp3bidXcvsd7OMcthbS
	ekyZkaHMrPtjnWANACQV5xHlFqcgvoS1bopkNtl83g2WIkfhal60tJFiaXCQRPA=
X-Gm-Gg: ASbGnctCHAmfkpqQUFN3ZgTG7oAdXSfiU3yX+XDvb1WVGkMuC4gKb+yHcw1RQc9vGgy
	PAwy1y/Bg6OScltZmr8mMR0Y9xYpwyH8KsBfzY67c1CB+9bhPvkXHjDIDCzbvHkrQlcJWKFHMLv
	qKGRDLxOtj73fszYlSj28G8sl7g9YescCTziu7lANLP9PA3agCxZhFqG1xgFcwbDNr1Mo3DYWwK
	sVmIVIl+AtPzgCRnBdbDUkkyvQb+yXWwl+v4Ea4/+cg86GKrM+JvwCGtrKLXITYn9mLOW7gGOhw
	W7fKxBGgRcMGiXHdqByiibOfbfDquYTPxH5SAg/QRhLPKQd4sHlTgaOacg==
X-Google-Smtp-Source: AGHT+IGaMme6I4SSWbEnoXoKG8OoitAHBPbvXRICDZMqDDARtTS6S6zcjn70eDe1QiVVIjQrBjyhiA==
X-Received: by 2002:a05:6a00:398d:b0:732:1ce5:4a4c with SMTP id d2e1a72fcca58-737577765b2mr5112478b3a.1.1742320377790;
        Tue, 18 Mar 2025 10:52:57 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711550fe1sm10193587b3a.53.2025.03.18.10.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 10:52:57 -0700 (PDT)
Message-ID: <a3b61916-2466-4ec8-a4e1-567581be7a2b@linaro.org>
Date: Tue, 18 Mar 2025 10:52:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] target/arm/cpu: remove inline stubs for aarch32
 emulation
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, qemu-arm@nongnu.org, alex.bennee@linaro.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-12-pierrick.bouvier@linaro.org>
 <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
 <CAFEAcA--jw3GmS70NTwviAEhdWeJ1UXE+ucNSkR60BXk6G8B6g@mail.gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <CAFEAcA--jw3GmS70NTwviAEhdWeJ1UXE+ucNSkR60BXk6G8B6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOC8yNSAxMDo1MCwgUGV0ZXIgTWF5ZGVsbCB3cm90ZToNCj4gT24gVHVlLCAxOCBN
YXIgMjAyNSBhdCAxNzo0MiwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5h
cm8ub3JnPiB3cm90ZToNCj4+DQo+PiBPbiAxOC8zLzI1IDA1OjUxLCBQaWVycmljayBCb3V2
aWVyIHdyb3RlOg0KPj4+IERpcmVjdGx5IGNvbmRpdGlvbiBhc3NvY2lhdGVkIGNhbGxzIGlu
IHRhcmdldC9hcm0vaGVscGVyLmMgZm9yIG5vdy4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6
IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCj4+PiAt
LS0NCj4+PiAgICB0YXJnZXQvYXJtL2NwdS5oICAgIHwgOCAtLS0tLS0tLQ0KPj4+ICAgIHRh
cmdldC9hcm0vaGVscGVyLmMgfCA2ICsrKysrKw0KPj4+ICAgIDIgZmlsZXMgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBh
L3RhcmdldC9hcm0vY3B1LmggYi90YXJnZXQvYXJtL2NwdS5oDQo+Pj4gaW5kZXggNTFiNjQy
OGNmZWMuLjkyMDVjYmRlYzQzIDEwMDY0NA0KPj4+IC0tLSBhL3RhcmdldC9hcm0vY3B1LmgN
Cj4+PiArKysgYi90YXJnZXQvYXJtL2NwdS5oDQo+Pj4gQEAgLTEyMjIsNyArMTIyMiw2IEBA
IGludCBhcm1fY3B1X3dyaXRlX2VsZjMyX25vdGUoV3JpdGVDb3JlRHVtcEZ1bmN0aW9uIGYs
IENQVVN0YXRlICpjcywNCj4+PiAgICAgKi8NCj4+PiAgICB2b2lkIGFybV9lbXVsYXRlX2Zp
cm13YXJlX3Jlc2V0KENQVVN0YXRlICpjcHVzdGF0ZSwgaW50IHRhcmdldF9lbCk7DQo+Pj4N
Cj4+PiAtI2lmZGVmIFRBUkdFVF9BQVJDSDY0DQo+Pj4gICAgaW50IGFhcmNoNjRfY3B1X2dk
Yl9yZWFkX3JlZ2lzdGVyKENQVVN0YXRlICpjcHUsIEdCeXRlQXJyYXkgKmJ1ZiwgaW50IHJl
Zyk7DQo+Pj4gICAgaW50IGFhcmNoNjRfY3B1X2dkYl93cml0ZV9yZWdpc3RlcihDUFVTdGF0
ZSAqY3B1LCB1aW50OF90ICpidWYsIGludCByZWcpOw0KPj4+ICAgIHZvaWQgYWFyY2g2NF9z
dmVfbmFycm93X3ZxKENQVUFSTVN0YXRlICplbnYsIHVuc2lnbmVkIHZxKTsNCj4+PiBAQCAt
MTI1NCwxMyArMTI1Myw2IEBAIHN0YXRpYyBpbmxpbmUgdWludDY0X3QgKnN2ZV9ic3dhcDY0
KHVpbnQ2NF90ICpkc3QsIHVpbnQ2NF90ICpzcmMsIGludCBucikNCj4+PiAgICAjZW5kaWYN
Cj4+PiAgICB9DQo+Pj4NCj4+PiAtI2Vsc2UNCj4+PiAtc3RhdGljIGlubGluZSB2b2lkIGFh
cmNoNjRfc3ZlX25hcnJvd192cShDUFVBUk1TdGF0ZSAqZW52LCB1bnNpZ25lZCB2cSkgeyB9
DQo+Pj4gLXN0YXRpYyBpbmxpbmUgdm9pZCBhYXJjaDY0X3N2ZV9jaGFuZ2VfZWwoQ1BVQVJN
U3RhdGUgKmVudiwgaW50IG8sDQo+Pj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgaW50IG4sIGJvb2wgYSkNCj4+PiAteyB9DQo+Pj4gLSNlbmRpZg0KPj4+
IC0NCj4+PiAgICB2b2lkIGFhcmNoNjRfc3luY18zMl90b182NChDUFVBUk1TdGF0ZSAqZW52
KTsNCj4+PiAgICB2b2lkIGFhcmNoNjRfc3luY182NF90b18zMihDUFVBUk1TdGF0ZSAqZW52
KTsNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2hlbHBlci5jIGIvdGFyZ2V0
L2FybS9oZWxwZXIuYw0KPj4+IGluZGV4IGI0NmIyYmZmY2YzLi43NzRlMWVlMDI0NSAxMDA2
NDQNCj4+PiAtLS0gYS90YXJnZXQvYXJtL2hlbHBlci5jDQo+Pj4gKysrIGIvdGFyZ2V0L2Fy
bS9oZWxwZXIuYw0KPj4+IEBAIC02NTYyLDcgKzY1NjIsOSBAQCBzdGF0aWMgdm9pZCB6Y3Jf
d3JpdGUoQ1BVQVJNU3RhdGUgKmVudiwgY29uc3QgQVJNQ1BSZWdJbmZvICpyaSwNCj4+PiAg
ICAgICAgICovDQo+Pj4gICAgICAgIG5ld19sZW4gPSBzdmVfdnFtMV9mb3JfZWwoZW52LCBj
dXJfZWwpOw0KPj4+ICAgICAgICBpZiAobmV3X2xlbiA8IG9sZF9sZW4pIHsNCj4+PiArI2lm
ZGVmIFRBUkdFVF9BQVJDSDY0DQo+Pg0KPj4gV2hhdCBhYm91dCB1c2luZyBydW50aW1lIGNo
ZWNrIGluc3RlYWQ/DQo+Pg0KPj4gICAgaWYgKGFybV9mZWF0dXJlKCZjcHUtPmVudiwgQVJN
X0ZFQVRVUkVfQUFSQ0g2NCkgJiYgbmV3X2xlbiA8IG9sZF9sZW4pIHsNCj4+DQo+IA0KPiBU
aGF0IHdvdWxkIGJlIGEgZGVhZCBjaGVjazogaXQgaXMgbm90IHBvc3NpYmxlIHRvIGdldCBo
ZXJlDQo+IHVubGVzcyBBUk1fRkVBVFVSRV9BQVJDSDY0IGlzIHNldC4NCj4gDQoNCldlIGNh
biB0aGVuIGFzc2VydCBpdCwgdG8gbWFrZSBzdXJlIHRoZXJlIGlzIG5vIHJlZ3Jlc3Npb24g
YXJvdW5kIHRoYXQuDQoNCldlIG5vdyBoYXZlIGFub3RoZXIgY29udmVyc2F0aW9uIGFuZCBz
b21ldGhpbmcgdG8gZGVjaWRlIGluIGFub3RoZXIgDQpmaWxlLCBhbmQgdGhhdCdzIHdoeSBJ
IGNob3NlIHRvIGRvIHRoZSBtaW5pbWFsIGNoYW5nZSAoImlmZGVmIHRoZSANCmlzc3VlIikg
aW5zdGVhZCBvZiB0cnlpbmcgdG8gZG8gYW55IGNoYW5nZS4NCg0KPiB0aGFua3MNCj4gLS0g
UE1NDQoNCg==

