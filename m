Return-Path: <kvm+bounces-18458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CFF98D5562
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 00:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B877285E31
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 22:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21601761B6;
	Thu, 30 May 2024 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hDCegadg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FE213B290
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717108208; cv=none; b=V/kH89mc8kkwdQf08jpbz5REPGArOyXC+2/rQN/a9e+BQFo1n7GrxM8xhALBL8dMoqAfSAttlwpPvE7nIz4XecXQhmzsJtz+l72d8MjLPzMqM2c3S6rwNbCnHYBT0R0WsL+pQ/k+oISvPNuARCYLP3yE/udjU6sExRYv+ZZ7DsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717108208; c=relaxed/simple;
	bh=xzNt1QiEjKt0w1/4U9EbtaV5vV9cgC+eL3TRM5VCBzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hxkmCA0ecMsj5anAcyTU/siK36UdhSXXuLHXBPR73y8+m+VBVd1UKle16ZZCxnalNvhNhwbTGoWyomDVZyVegtra9gwU2sgUAzYbISvluXaQNiuyLjWtcdHto/u4gicsBp5INK76emnO2mL5Cff0gjOysTG//VXoJqx1VtKNXCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hDCegadg; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7021ab0d0f5so408627b3a.2
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 15:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717108206; x=1717713006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xzNt1QiEjKt0w1/4U9EbtaV5vV9cgC+eL3TRM5VCBzc=;
        b=hDCegadgxb6MMItqzSQ65mBt2m5ESZJomM30BPV43WPlm9M5Ws5tOHX9fSmxDWhXaL
         ipG9t1PPESn3+tjmDprOqQSVyJ08dx7HtgeRS6GveD3sEt7LGpGSZL4gZgRhA8hWJdcH
         fnEY++twoSfPqZ3MEx72o7R67dvBXM0VgzbygTfHwx2zKlXcgjF2aY9cot5QKlnNWpMQ
         m3oReNPGQ4ejhSeHm/919wgCHsjxMwStR+Wm5883X0x0mdy/wxCJTw+rpmS+5xDBHosF
         1kSFEJqd+qj/VZwqBe2762M1yLQdL5aS6lZ+twOdUvFhrbnGZxBJMZU231CY9MbJlOyU
         eb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717108206; x=1717713006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xzNt1QiEjKt0w1/4U9EbtaV5vV9cgC+eL3TRM5VCBzc=;
        b=HC4fdQqaolwQgyoU7kWqeliHm/dcE1F92HJLHngc78CZPmxWbk85bLkqpGVTZJ8Bto
         Wc42okem9HlCeNDDKKAV8bhXm1yLffiNSb14Xp3a9v9eIEjtS9bBZ6N22kV65ewGRCed
         64mAx96LAAT1laBM04zyKS1X5JXepUHe73EDDTIgnXn37JjNpJsyivx8mlPqN0Po9XEZ
         4KW3826dScT517VTfk0Rq3ejAt+dB2Hkzy0EKm7T8YsILFRt/nQPthRfkVAlbzuiDJAa
         WTuHKWuFqRDjNA2/UJ1MsLy3eGCiP073saVL3rgvHsclJ5BAVfoew3P0soAt5xrkXfK2
         1C+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUylHnBywrzfw7vlT1xVsqJISvo+FVlR2dFNJWMgCbOrv3wEQ3hsksTvY84Quwz21+ttAB9BrPxj6QNuY7HeR16998/
X-Gm-Message-State: AOJu0Ywv/tsIZvWJmgs9qjlaCDUad+b2G+cT0VX4nnA1qk0pFHd7mKHm
	+t1t6ttYVgFlvjUvlS45I81ZzwdjiZVmKw/4IUOoNpF+UZjc93XSMU69CJZzD5w=
X-Google-Smtp-Source: AGHT+IGQq9UBMHIpPaBKjiysXskFrZdduyvYpJkfCU/fNn9CDd86YzAn3IseJJPYTCnL98rgDfS99A==
X-Received: by 2002:a05:6a20:914e:b0:1af:4ea2:5424 with SMTP id adf61e73a8af0-1b26f20d7e3mr341572637.33.1717108205820;
        Thu, 30 May 2024 15:30:05 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::e697? ([2604:3d08:9384:1d00::e697])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242b0518csm225153b3a.147.2024.05.30.15.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 15:30:05 -0700 (PDT)
Message-ID: <f1b8d2dc-c803-4c45-898e-ef39934bbd0e@linaro.org>
Date: Thu, 30 May 2024 15:30:04 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] plugins: remove special casing for cpu->realized
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
 <20240530194250.1801701-5-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240530194250.1801701-5-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNS8zMC8yNCAxMjo0MiwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBOb3cgdGhlIGNvbmRp
dGlvbiB2YXJpYWJsZSBpcyBpbml0aWFsaXNlZCBlYXJseSBvbiB3ZSBkb24ndCBuZWVkIHRv
IGdvDQo+IHRocm91Z2ggaG9vcHMgdG8gYXZvaWQgY2FsbGluZyBhc3luY19ydW5fb25fY3B1
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5h
cm8ub3JnPg0KPiAtLS0NCj4gICBwbHVnaW5zL2NvcmUuYyB8IDYgKy0tLS0tDQo+ICAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL3BsdWdpbnMvY29yZS5jIGIvcGx1Z2lucy9jb3JlLmMNCj4gaW5kZXggMDcy
NmJjN2YyNS4uYmFkZWRlMjhjZiAxMDA2NDQNCj4gLS0tIGEvcGx1Z2lucy9jb3JlLmMNCj4g
KysrIGIvcGx1Z2lucy9jb3JlLmMNCj4gQEAgLTY1LDExICs2NSw3IEBAIHN0YXRpYyB2b2lk
IHBsdWdpbl9jcHVfdXBkYXRlX19sb2NrZWQoZ3BvaW50ZXIgaywgZ3BvaW50ZXIgdiwgZ3Bv
aW50ZXIgdWRhdGEpDQo+ICAgICAgIENQVVN0YXRlICpjcHUgPSBjb250YWluZXJfb2Yoaywg
Q1BVU3RhdGUsIGNwdV9pbmRleCk7DQo+ICAgICAgIHJ1bl9vbl9jcHVfZGF0YSBtYXNrID0g
UlVOX09OX0NQVV9IT1NUX1VMT05HKCpwbHVnaW4ubWFzayk7DQo+ICAgDQo+IC0gICAgaWYg
KERFVklDRShjcHUpLT5yZWFsaXplZCkgew0KPiAtICAgICAgICBhc3luY19ydW5fb25fY3B1
KGNwdSwgcGx1Z2luX2NwdV91cGRhdGVfX2FzeW5jLCBtYXNrKTsNCj4gLSAgICB9IGVsc2Ug
ew0KPiAtICAgICAgICBwbHVnaW5fY3B1X3VwZGF0ZV9fYXN5bmMoY3B1LCBtYXNrKTsNCj4g
LSAgICB9DQo+ICsgICAgYXN5bmNfcnVuX29uX2NwdShjcHUsIHBsdWdpbl9jcHVfdXBkYXRl
X19hc3luYywgbWFzayk7DQo+ICAgfQ0KPiAgIA0KPiAgIHZvaWQgcGx1Z2luX3VucmVnaXN0
ZXJfY2JfX2xvY2tlZChzdHJ1Y3QgcWVtdV9wbHVnaW5fY3R4ICpjdHgsDQoNClJldmlld2Vk
LWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo=


