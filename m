Return-Path: <kvm+bounces-41419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39097A67B5C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B2BC19C28E2
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15CB212B2F;
	Tue, 18 Mar 2025 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dZ2BBg2y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6F91917FB
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320216; cv=none; b=hNPqM7Gj3Ld6HXpPWcL0JbpjlzWS46Pi3N/iRTSBuV9yMjRo1o3NyFa6c+odhcsT+HeKiF/rVz7N61N2w4AyY1TXkFyMepv+aCeu5FstGkOwXdyelA4FIjByTTEe7TTqodvfLVBVE0anBjEUDqBLelLqarsv1VE+TCcB005/lsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320216; c=relaxed/simple;
	bh=b1xKnKy4CGJ/XdKVe9sQQOXwvKQLk6WAfJQbJ8AYkec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qo+1ga8jW4lhOzfPgV4Tmv+W+9adw3fs+L/9IGYnm2QgoCNCICyMk08s0Atuh6meFdbp8QLQMoJFK6EXdhMHWvwDlZsK4YXkbZ5lcmzZCJ/oVViQXecghY/F1aCK9jX1F68s6v0NtdWDCJ0lRCFc7hHUenncHKLeNWI3dmRuAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dZ2BBg2y; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3018c9c6b5fso3896290a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 10:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742320214; x=1742925014; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b1xKnKy4CGJ/XdKVe9sQQOXwvKQLk6WAfJQbJ8AYkec=;
        b=dZ2BBg2ywCyrV6lA+dTH9ORCJxFu1FesAnSZWGnyGGf2NWgUjDh/FVFopiM8EGncs+
         9avDfJEml/qguDi1ssCLNu5zTzGSkdheAQfrJgdm+2iTT/+TZ4DsSW/dCbm9CTC+/0ct
         gW3euVPilmedub5cDgpfUGdluk11PoXhcHtDdv+Lj5ug9ztzp0kVFcOAaD/b1hFRfvrq
         6Tp7CmDWfeUqoEIbgMXfWYTvo8jhJake0ufrdFCoE8RFFvGcxcDiE7UTWMGuB4QJMklz
         +KQr0g7ZkrBU6yktb6sOlZx6ONzqj4YbKk4IPsJQQMOiZAxlLSQKOo0uc2Pe183f+nBl
         44TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320214; x=1742925014;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b1xKnKy4CGJ/XdKVe9sQQOXwvKQLk6WAfJQbJ8AYkec=;
        b=iptiiiEiqchyIMIBteBB24sJgNjSqtZ7KlgElRIM+OlE83zQrVLeIVSfMoiv07Qt2x
         thZkE8eO+RKNy0APyDVgUfi1Ua9UsA5nGOvikvw0gmaJ2Fe6TUlumE3u1V9QaaU9ePP+
         fFRv2BxJzpFXRLSSvElK1TafqDUjIIVOkTO+EghZVwmEAgDke9xOh+dd6PEOFDXKyVlq
         evXdQI6XLxn0o1eMGl227IxvgJvgHSlRy4wclg5YJ0lPIEMxqraY79zF6DaCDHDa1fu2
         Pd0CX2biu8/LRWfLQ9fKrTdlbVeCBNMFBPxBgJgnDyrmmhwkBFXK2RdSl2FGQ4YeAMbU
         TnCg==
X-Forwarded-Encrypted: i=1; AJvYcCVCSuSeYaipiMb9gCOErvEBl82xgsze0VexEwspiGN2inRbCVo/SpJgU083xNQmu5oRJf0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmzzq5d9vFtS+CbS66rVudbV7NHDpbzeKZbaeO7egy4EWM8hxa
	PpMNdXSfZtA8XQyC0EJxYnrp19Sn6T/9kQ+dsmU+zZ8cYNBPba7dC1aMfcMBGT0=
X-Gm-Gg: ASbGnctv3jsX11XAgcpzl24QoxzRwzjWooWkoVLQM930YKFCeA+zbiF5AoNce9ITvzD
	rO7TbqchQqmu2ZHgSuTEF8hA4uBPhDveAcrCsI28719boUTZVEGrsAm6SlWdV4SKsFRWft5zwXV
	tm2lten1aA2Qw3iIMPryK2u8dBhyrDe4s5Eq64hu7Gn5WKvTNKYZlW4EhjrAkJv1NT1Ozr/s5yS
	1mYtNBV8qba7KZ5I9QopJF3k8WKFyL0UU4zTaUm7XfmmSbL5AiT9nosBMA5szjKHiMApmc3My7g
	+DmZcks0D5BvnG0pfGlq1gRu1MC/BSwjlPQouDbXNgnoIXjPCmrUB54YaQ==
X-Google-Smtp-Source: AGHT+IH78tif7R6gzXurAW0XZxtmFJkJ2vsvt+xbpOCzQtnizanOa49k0QkDmETa9oq+SboQl1/F7w==
X-Received: by 2002:a17:90b:3142:b0:301:1d03:93b3 with SMTP id 98e67ed59e1d1-301ba143043mr108818a91.22.1742320214477;
        Tue, 18 Mar 2025 10:50:14 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3015351961csm8531313a91.14.2025.03.18.10.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 10:50:14 -0700 (PDT)
Message-ID: <dba359a9-0e9a-471c-a34c-d4aefbf21ccb@linaro.org>
Date: Tue, 18 Mar 2025 10:50:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] target/arm/cpu: remove inline stubs for aarch32
 emulation
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-12-pierrick.bouvier@linaro.org>
 <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOC8yNSAxMDo0MiwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDE4LzMvMjUgMDU6NTEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBEaXJlY3RseSBj
b25kaXRpb24gYXNzb2NpYXRlZCBjYWxscyBpbiB0YXJnZXQvYXJtL2hlbHBlci5jIGZvciBu
b3cuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2su
Ym91dmllckBsaW5hcm8ub3JnPg0KPj4gLS0tDQo+PiAgICB0YXJnZXQvYXJtL2NwdS5oICAg
IHwgOCAtLS0tLS0tLQ0KPj4gICAgdGFyZ2V0L2FybS9oZWxwZXIuYyB8IDYgKysrKysrDQo+
PiAgICAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkN
Cj4+DQo+PiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9jcHUuaCBiL3RhcmdldC9hcm0vY3B1
LmgNCj4+IGluZGV4IDUxYjY0MjhjZmVjLi45MjA1Y2JkZWM0MyAxMDA2NDQNCj4+IC0tLSBh
L3RhcmdldC9hcm0vY3B1LmgNCj4+ICsrKyBiL3RhcmdldC9hcm0vY3B1LmgNCj4+IEBAIC0x
MjIyLDcgKzEyMjIsNiBAQCBpbnQgYXJtX2NwdV93cml0ZV9lbGYzMl9ub3RlKFdyaXRlQ29y
ZUR1bXBGdW5jdGlvbiBmLCBDUFVTdGF0ZSAqY3MsDQo+PiAgICAgKi8NCj4+ICAgIHZvaWQg
YXJtX2VtdWxhdGVfZmlybXdhcmVfcmVzZXQoQ1BVU3RhdGUgKmNwdXN0YXRlLCBpbnQgdGFy
Z2V0X2VsKTsNCj4+ICAgIA0KPj4gLSNpZmRlZiBUQVJHRVRfQUFSQ0g2NA0KPj4gICAgaW50
IGFhcmNoNjRfY3B1X2dkYl9yZWFkX3JlZ2lzdGVyKENQVVN0YXRlICpjcHUsIEdCeXRlQXJy
YXkgKmJ1ZiwgaW50IHJlZyk7DQo+PiAgICBpbnQgYWFyY2g2NF9jcHVfZ2RiX3dyaXRlX3Jl
Z2lzdGVyKENQVVN0YXRlICpjcHUsIHVpbnQ4X3QgKmJ1ZiwgaW50IHJlZyk7DQo+PiAgICB2
b2lkIGFhcmNoNjRfc3ZlX25hcnJvd192cShDUFVBUk1TdGF0ZSAqZW52LCB1bnNpZ25lZCB2
cSk7DQo+PiBAQCAtMTI1NCwxMyArMTI1Myw2IEBAIHN0YXRpYyBpbmxpbmUgdWludDY0X3Qg
KnN2ZV9ic3dhcDY0KHVpbnQ2NF90ICpkc3QsIHVpbnQ2NF90ICpzcmMsIGludCBucikNCj4+
ICAgICNlbmRpZg0KPj4gICAgfQ0KPj4gICAgDQo+PiAtI2Vsc2UNCj4+IC1zdGF0aWMgaW5s
aW5lIHZvaWQgYWFyY2g2NF9zdmVfbmFycm93X3ZxKENQVUFSTVN0YXRlICplbnYsIHVuc2ln
bmVkIHZxKSB7IH0NCj4+IC1zdGF0aWMgaW5saW5lIHZvaWQgYWFyY2g2NF9zdmVfY2hhbmdl
X2VsKENQVUFSTVN0YXRlICplbnYsIGludCBvLA0KPj4gLSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgaW50IG4sIGJvb2wgYSkNCj4+IC17IH0NCj4+IC0jZW5k
aWYNCj4+IC0NCj4+ICAgIHZvaWQgYWFyY2g2NF9zeW5jXzMyX3RvXzY0KENQVUFSTVN0YXRl
ICplbnYpOw0KPj4gICAgdm9pZCBhYXJjaDY0X3N5bmNfNjRfdG9fMzIoQ1BVQVJNU3RhdGUg
KmVudik7DQo+PiAgICANCj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2hlbHBlci5jIGIv
dGFyZ2V0L2FybS9oZWxwZXIuYw0KPj4gaW5kZXggYjQ2YjJiZmZjZjMuLjc3NGUxZWUwMjQ1
IDEwMDY0NA0KPj4gLS0tIGEvdGFyZ2V0L2FybS9oZWxwZXIuYw0KPj4gKysrIGIvdGFyZ2V0
L2FybS9oZWxwZXIuYw0KPj4gQEAgLTY1NjIsNyArNjU2Miw5IEBAIHN0YXRpYyB2b2lkIHpj
cl93cml0ZShDUFVBUk1TdGF0ZSAqZW52LCBjb25zdCBBUk1DUFJlZ0luZm8gKnJpLA0KPj4g
ICAgICAgICAqLw0KPj4gICAgICAgIG5ld19sZW4gPSBzdmVfdnFtMV9mb3JfZWwoZW52LCBj
dXJfZWwpOw0KPj4gICAgICAgIGlmIChuZXdfbGVuIDwgb2xkX2xlbikgew0KPj4gKyNpZmRl
ZiBUQVJHRVRfQUFSQ0g2NA0KPiANCj4gV2hhdCBhYm91dCB1c2luZyBydW50aW1lIGNoZWNr
IGluc3RlYWQ/DQo+IA0KPiAgICBpZiAoYXJtX2ZlYXR1cmUoJmNwdS0+ZW52LCBBUk1fRkVB
VFVSRV9BQVJDSDY0KSAmJiBuZXdfbGVuIDwgb2xkX2xlbikgew0KPiANCg0KVGhpcyBpcyB0
aGUgcmlnaHQgd2F5IHRvIGRlYWwgd2l0aCBpdCwgYnV0IEkgd291bGQgcHJlZmVyIHRvIGRv
IGl0IHdoZW4gDQp0aGUgY29uY2VybmVkIGZpbGUgKHRhcmdldC9hcm0vaGVscGVyLmMpIHdp
bGwgYmUgbW9kaWZpZWQsIGluIGEgZnV0dXJlIA0Kc2VyaWVzLg0KDQpUaGUgY3VycmVudCBv
bmUgZm9jdXNlcyBvbiBody9hcm0gYW5kICJwdXNoZXMgYmFjayIgZGVwZW5kZW5jaWVzIGlu
IA0Kb3RoZXIgcGxhY2VzLCB0aGF0IHdlIGNhbiBkZWFsIHdpdGggbGF0ZXIuDQoNCk5vdGhp
bmcgd3Jvbmcgd2l0aCB0aGUgY2hhbmdlIHByb3Bvc2VkLCBqdXN0IHRyeWluZyB0byBmb2N1
cyBvbiB0aGUgDQptaW5pbWFsIHNldCBuZWVkZWQgdG8gcmVhY2ggdGhlIGdvYWwsIHdpdGhv
dXQgYW55IGRldG91ci4NCg0KPj4gICAgICAgICAgICBhYXJjaDY0X3N2ZV9uYXJyb3dfdnEo
ZW52LCBuZXdfbGVuICsgMSk7DQo+PiArI2VuZGlmDQo+PiAgICAgICAgfQ0KPj4gICAgfQ0K
PiANCg0K

