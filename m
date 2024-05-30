Return-Path: <kvm+bounces-18459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A55368D556C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 00:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65633283FD3
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 22:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5215B1761B6;
	Thu, 30 May 2024 22:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xJs9y+eO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1893E187565
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 22:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717108317; cv=none; b=E5B6srKC3X5ZoexH1reqGRLJFxkLzPthVRMGDaMT9L7EoBMxDA1UOLiIkA2LnDn2eN6z3/Ck76ol/q3AOfZgWkGGeG/Z0mQinff6t71X2gF+3+ilpfiQypbCwSK7mKX2qdUV8QF7i4vhNhFG+J8Pytd6r1r5ocz3rh3iWXSPEx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717108317; c=relaxed/simple;
	bh=1JxSua5tIhIMFRj7DIoOkLpqa/U0TWnELnntr8zZWYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YfQdCmxlUzCWgUa6hnPdgzY9+zFH2jwX2dJh/ASihLZEEN4yVX2T8jNM4YsSIRAWzDXWcYTY1hBC6iEmoBXJM4fuzJV9mlHaou9i+KZ3d9aeivNd4vnwgRJNKRDOHvBFVFQFoSvqzOW2bvb5uEroyEGsIWpUGILZ36iMsLkoN1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xJs9y+eO; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-702323ea6b2so1066962b3a.3
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 15:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717108315; x=1717713115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1JxSua5tIhIMFRj7DIoOkLpqa/U0TWnELnntr8zZWYQ=;
        b=xJs9y+eOmSPfdoHipP1hdEsvw5TbfjtWtk1Xmo3CCXZ500IEgR3ikqh+rDIm+NqnC+
         Qi/LAZNGfmBPMZHNSIekMR5r14hHQ+WAAflqzk8gVnDJwMbH9R1jbDkOVIVb6uE/0Ns3
         q6b73TYXYX7zZ5/aksL4dRWuSAGTYM6a8Hft1WaKazix7fMp4/NOiY3GEd++cbNateRd
         xbWycDBqRnChS8QSs24/lO3/fngsL/nYaFRxm5aVNxAlxBp7CLpt//sfmiECFGzD/l31
         yUrJDTynp3a27Sjd6kl4ZEEFbaWGwPVrIm8AwnbxS0uDhb6pkbgU8625m6I7QTiv0chW
         67kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717108315; x=1717713115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1JxSua5tIhIMFRj7DIoOkLpqa/U0TWnELnntr8zZWYQ=;
        b=Kz/Y6UsMXOkscigzhCk1VApEqadmxgeqQCLAL3rTZ9YurPDYC/tEDzvB/rZ0SFj4/e
         5HOY35sdi/tqOVJg5RdHSjmWqPXawpRNSsBD8pRJUhommFJLYL1BtZht+n4EEym3IXZY
         Mz/scPavwvqSG3+vrgHkL3K2yrUusSmsQh4+veQXsQG9JOrf6/3Wx/gsqGBbIWMnlekb
         IDlwv/nllapI916m4KxNAH5MHA0xHQvuksWzlSmSolwXAaSij3RolmaiRM1AAPO90G6r
         LdWMCFLStjPxis5QbbUMiUbAbNn8HXtdVLOh80aocMiAgXT96EJvHNixIBmnSJKpDbQQ
         /huw==
X-Forwarded-Encrypted: i=1; AJvYcCVcORPRhno6sjn6SrfkNx6teuBH8Z1oZ9ovLQP8XkLZ7mvnGqIT/QMfjt1pZTbJ+GsCHKaAw4My0zM8XEerjMqWZW20
X-Gm-Message-State: AOJu0YwSvdmsp6ifUJAUONbVI8KZII7+/8foJUPeB2PqfF4T4+Uqp2Iw
	pMhQYv/BOPYu1Sn6y9tF6zUt+nJbm4lz6NOxbqxpjhtduTFkKteRxMRTAOuVkjc=
X-Google-Smtp-Source: AGHT+IGUeCwbiAx6qjfHTnUtm8xXH583AcCLVxl3qyPVWWsbDXZhlCtX44C8wnstnbVpR5X7uaz+Jg==
X-Received: by 2002:a05:6a21:788a:b0:1af:59b9:e3ed with SMTP id adf61e73a8af0-1b26f0e60eamr419228637.5.1717108315295;
        Thu, 30 May 2024 15:31:55 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::e697? ([2604:3d08:9384:1d00::e697])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6c35a88d096sm214861a12.93.2024.05.30.15.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 15:31:54 -0700 (PDT)
Message-ID: <23926d03-b55f-448f-82b1-99e4bc9d76dd@linaro.org>
Date: Thu, 30 May 2024 15:31:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] core/cpu-common: initialise plugin state before
 thread creation
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Yanan Wang <wangyanan55@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Reinoud Zandijk
 <reinoud@netbsd.org>, kvm@vger.kernel.org,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-6-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240530194250.1801701-6-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNS8zMC8yNCAxMjo0MiwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBPcmlnaW5hbGx5IEkg
dHJpZWQgdG8gbW92ZSB3aGVyZSB2Q1BVIHRocmVhZCBpbml0aWFsaXNhdGlvbiB0byBsYXRl
cg0KPiBpbiByZWFsaXplLiBIb3dldmVyIHB1bGxpbmcgdGhhdCB0aHJlYWQgKHNpYykgZ290
IGduYXJseSByZWFsbHkNCj4gcXVpY2tseS4gSXQgdHVybnMgb3V0IHNvbWUgc3RlcHMgb2Yg
Q1BVIHJlYWxpemF0aW9uIG5lZWQgdmFsdWVzIHRoYXQNCj4gY2FuIG9ubHkgYmUgZGV0ZXJt
aW5lZCBmcm9tIHRoZSBydW5uaW5nIHZDUFUgdGhyZWFkLg0KPiANCj4gSG93ZXZlciBoYXZp
bmcgbW92ZWQgZW5vdWdoIG91dCBvZiB0aGUgdGhyZWFkIGNyZWF0aW9uIHdlIGNhbiBub3cN
Cj4gcXVldWUgd29yayBiZWZvcmUgdGhlIHRocmVhZCBzdGFydHMgKGF0IGxlYXN0IGZvciBU
Q0cgZ3Vlc3RzKSBhbmQNCj4gYXZvaWQgdGhlIHJhY2UgYmV0d2VlbiB2Y3B1X2luaXQgYW5k
IG90aGVyIHZjcHUgc3RhdGVzIGEgcGx1Z2luIG1pZ2h0DQo+IHN1YnNjcmliZSB0by4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9y
Zz4NCj4gLS0tDQo+ICAgaHcvY29yZS9jcHUtY29tbW9uLmMgfCAyMCArKysrKysrKysrKyst
LS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA4IGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2h3L2NvcmUvY3B1LWNvbW1vbi5jIGIvaHcv
Y29yZS9jcHUtY29tbW9uLmMNCj4gaW5kZXggNmNmYzAxNTkzYS4uYmYxYTdiODg5MiAxMDA2
NDQNCj4gLS0tIGEvaHcvY29yZS9jcHUtY29tbW9uLmMNCj4gKysrIGIvaHcvY29yZS9jcHUt
Y29tbW9uLmMNCj4gQEAgLTIyMiwxNCArMjIyLDYgQEAgc3RhdGljIHZvaWQgY3B1X2NvbW1v
bl9yZWFsaXplZm4oRGV2aWNlU3RhdGUgKmRldiwgRXJyb3IgKiplcnJwKQ0KPiAgICAgICAg
ICAgY3B1X3Jlc3VtZShjcHUpOw0KPiAgICAgICB9DQo+ICAgDQo+IC0gICAgLyogUGx1Z2lu
IGluaXRpYWxpemF0aW9uIG11c3Qgd2FpdCB1bnRpbCB0aGUgY3B1IHN0YXJ0IGV4ZWN1dGlu
ZyBjb2RlICovDQo+IC0jaWZkZWYgQ09ORklHX1BMVUdJTg0KPiAtICAgIGlmICh0Y2dfZW5h
YmxlZCgpKSB7DQo+IC0gICAgICAgIGNwdS0+cGx1Z2luX3N0YXRlID0gcWVtdV9wbHVnaW5f
Y3JlYXRlX3ZjcHVfc3RhdGUoKTsNCj4gLSAgICAgICAgYXN5bmNfcnVuX29uX2NwdShjcHUs
IHFlbXVfcGx1Z2luX3ZjcHVfaW5pdF9fYXN5bmMsIFJVTl9PTl9DUFVfTlVMTCk7DQo+IC0g
ICAgfQ0KPiAtI2VuZGlmDQo+IC0NCj4gICAgICAgLyogTk9URTogbGF0ZXN0IGdlbmVyaWMg
cG9pbnQgd2hlcmUgdGhlIGNwdSBpcyBmdWxseSByZWFsaXplZCAqLw0KPiAgIH0NCj4gICAN
Cj4gQEAgLTI3Myw2ICsyNjUsMTggQEAgc3RhdGljIHZvaWQgY3B1X2NvbW1vbl9pbml0Zm4o
T2JqZWN0ICpvYmopDQo+ICAgICAgIFFUQUlMUV9JTklUKCZjcHUtPndhdGNocG9pbnRzKTsN
Cj4gICANCj4gICAgICAgY3B1X2V4ZWNfaW5pdGZuKGNwdSk7DQo+ICsNCj4gKyAgICAvKg0K
PiArICAgICAqIFBsdWdpbiBpbml0aWFsaXphdGlvbiBtdXN0IHdhaXQgdW50aWwgdGhlIGNw
dSBzdGFydCBleGVjdXRpbmcNCj4gKyAgICAgKiBjb2RlLCBidXQgd2UgbXVzdCBxdWV1ZSB0
aGlzIHdvcmsgYmVmb3JlIHRoZSB0aHJlYWRzIGFyZQ0KPiArICAgICAqIGNyZWF0ZWQgdG8g
ZW5zdXJlIHdlIGRvbid0IHJhY2UuDQo+ICsgICAgICovDQo+ICsjaWZkZWYgQ09ORklHX1BM
VUdJTg0KPiArICAgIGlmICh0Y2dfZW5hYmxlZCgpKSB7DQo+ICsgICAgICAgIGNwdS0+cGx1
Z2luX3N0YXRlID0gcWVtdV9wbHVnaW5fY3JlYXRlX3ZjcHVfc3RhdGUoKTsNCj4gKyAgICAg
ICAgYXN5bmNfcnVuX29uX2NwdShjcHUsIHFlbXVfcGx1Z2luX3ZjcHVfaW5pdF9fYXN5bmMs
IFJVTl9PTl9DUFVfTlVMTCk7DQo+ICsgICAgfQ0KPiArI2VuZGlmDQo+ICAgfQ0KPiAgIA0K
PiAgIHN0YXRpYyB2b2lkIGNwdV9jb21tb25fZmluYWxpemUoT2JqZWN0ICpvYmopDQoNCkNv
dWxkIHlvdSBjaGVjayBpdCB3b3JrcyBmb3IgYWxsIGNvbWJpbmF0aW9uPw0KLSB1c2VyLW1v
ZGUNCi0gc3lzdGVtLW1vZGUgdGNnDQotIHN5c3RlbS1tb2RlIG10dGNnDQoNCldoZW4gSSB0
cmllZCB0byBtb3ZlIHRoaXMgY29kZSBhcm91bmQsIG9uZSBvZiB0aGVtIGRpZG4ndCB3b3Jr
IGNvcnJlY3RseS4NCg0KRWxzZSwNClJldmlld2VkLWJ5OiBQaWVycmljayBCb3V2aWVyIDxw
aWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo=

