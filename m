Return-Path: <kvm+bounces-29454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5049ABA95
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 02:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 670C0284C4E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 00:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBDAC1B813;
	Wed, 23 Oct 2024 00:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nz8zuJtG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277201804E
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 00:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729643605; cv=none; b=RrMM24JM6HKdWzVz4OOoWU3zYJxOupHEc4x2FSpUaxFerogSRZkNFQv4b2ImElFggfk5NlzeUB7Bi/qgKi6YYy+SVZu15Is7+m4GSKzruup/OCXUOKMCN+/KrYSWSav81Dc9fKOHMXncNgpqrqFM+t/9iZtTRwyMgxWcK9EdP+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729643605; c=relaxed/simple;
	bh=79ndCH4BWZEfycwpeQ4eGvQI1Eq+4kSlvhh1T8GdH5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZBZH2SSLSZ7pEzKRZiM7sV7VOOWmdYgk6qkN1QSjduE4NKHYOvBHvB4XGVoGEcm8/iaV+CFCcG2pQU/0amyGkVAChvLG8JbDJZ/su5XUuzysuDL8p0ztgKTLtb1a0q5t70FbT9hT+iESyPqLKoGv72GpS1TBT/T6T5omk6C5cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nz8zuJtG; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-207115e3056so52481305ad.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 17:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729643603; x=1730248403; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=79ndCH4BWZEfycwpeQ4eGvQI1Eq+4kSlvhh1T8GdH5Q=;
        b=nz8zuJtG+FaIqPmKAOsC0KJBp2UDQ85c0M9VZSAIzGTGqoWybcbZvX7UYcdNjTPDmN
         p6WcHxfAckyoTCEbd+6mJKahcSplAltAnuqg8EwmacxZHQFGKr9XJugaXXb3uNzddxQJ
         b2A0PQY4GwmzOwjnU7hGWhYS1Q4ayiaMsyUard6zSdf5tGzrDGbudvhZARobA/z3z0m9
         Fze6wCiwOxwWYa2PgkvhMBNWNxZePkUuipmaxX4G8f1/ajtMS7rh42CB8hWwwK+2Pmyx
         cPye/d/WqyJytFYXKLWkcJNm6z0Xxm0IOXZ/1SS7oOqis9Ia/ivjM0ymDckfUdQpB0EL
         VxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729643603; x=1730248403;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=79ndCH4BWZEfycwpeQ4eGvQI1Eq+4kSlvhh1T8GdH5Q=;
        b=eLDU24MOIFbXtQrgMnhVMc2FKFBMI3vT4jfO78Gxr7tH549ho5eQpF5LwxyoDINOGi
         Bj9SUEXMDDvNemugQ9jhhEGW1iMeho8SNnl+U+nRpo/kLIG4JYdojIgLJdArefqIFjfp
         a0WaIHDfXd7b3MZwD54RfJOSCa49HWqZRgGKcjSbvHLqKroyUrUQOP3CCnpudosyvWA1
         s74Mtk7HqfNofpaMNALNpmmpMJyV1dfIQhTrgWIyMzeJlpFjo6chUlrwOcb9Tk2ND4nw
         8X7Tq8AUpTAc9wDTZ8kL/WcOmbj03ogT4Lm/WfwVG0myaGIrrIt3vpBI4XVWORI5vGVm
         vMsg==
X-Forwarded-Encrypted: i=1; AJvYcCUX5QUSsj/Jt+m7kMRY+x5Q+cAOYJA2N4KvRbAfdss696nkrnLGwyHWBuWZp3C4Dix1wik=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY6Brz61HtcUBsNKp6+OALfu3TU2Y6/zDqJYGAwAfwWlMB5kzh
	nk5Muz1d2a1UBjvzLPHA0ZaLj5RX7mcOxgp2we1c1ifrFvKl8Xw2pRySmnIQsp8=
X-Google-Smtp-Source: AGHT+IFhsM4ymH4z9iMfmjz8kHFWc3s1RItxg2i/WUFTPSle33GeerWDLNrU1JzWzNM+vUvkbjTJDw==
X-Received: by 2002:a17:902:e883:b0:20b:7ed8:3990 with SMTP id d9443c01a7336-20fa9de8bf5mr14329755ad.12.1729643603347;
        Tue, 22 Oct 2024 17:33:23 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0ebb5csm48187915ad.240.2024.10.22.17.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 17:33:22 -0700 (PDT)
Message-ID: <17ab6a26-bfd2-4ee6-8fc4-c371d266dcb1@linaro.org>
Date: Tue, 22 Oct 2024 17:33:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/20] tests/tcg/x86_64: Add cross-modifying code test
To: Ilya Leoshkevich <iii@linux.ibm.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, qemu-devel@nongnu.org
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
 <20241022105614.839199-8-alex.bennee@linaro.org>
 <6b18238b-f9c3-4046-964f-de16dc30d26e@linaro.org>
 <4c383f09bd6bd9b488ad301e5f050b8c9971f3a2.camel@linux.ibm.com>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <4c383f09bd6bd9b488ad301e5f050b8c9971f3a2.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMTc6MTYsIElseWEgTGVvc2hrZXZpY2ggd3JvdGU6DQo+IE9uIFR1ZSwg
MjAyNC0xMC0yMiBhdCAxMzozNiAtMDcwMCwgUGllcnJpY2sgQm91dmllciB3cm90ZToNCj4+
IE9uIDEwLzIyLzI0IDAzOjU2LCBBbGV4IEJlbm7DqWUgd3JvdGU6DQo+Pj4gRnJvbTogSWx5
YSBMZW9zaGtldmljaCA8aWlpQGxpbnV4LmlibS5jb20+DQo+Pj4NCj4+PiBjb21taXQgZjAy
NTY5MmM5OTJjICgiYWNjZWwvdGNnOiBDbGVhciBQQUdFX1dSSVRFIGJlZm9yZQ0KPj4+IHRy
YW5zbGF0aW9uIikNCj4+PiBmaXhlZCBjcm9zcy1tb2RpZnlpbmcgY29kZSBoYW5kbGluZywg
YnV0IGRpZCBub3QgYWRkIGEgdGVzdC4gVGhlDQo+Pj4gY2hhbmdlZCBjb2RlIHdhcyBmdXJ0
aGVyIGltcHJvdmVkIHJlY2VudGx5IFsxXSwgYW5kIEkgd2FzIG5vdCBzdXJlDQo+Pj4gd2hl
dGhlciB0aGVzZSBtb2RpZmljYXRpb25zIHdlcmUgc2FmZSAoc3BvaWxlcjogdGhleSB3ZXJl
IGZpbmUpLg0KPj4+DQo+Pj4gQWRkIGEgdGVzdCB0byBtYWtlIHN1cmUgdGhlcmUgYXJlIG5v
IHJlZ3Jlc3Npb25zLg0KPj4+DQo+Pj4gWzFdDQo+Pj4gaHR0cHM6Ly9saXN0cy5nbnUub3Jn
L2FyY2hpdmUvaHRtbC9xZW11LWRldmVsLzIwMjItMDkvbXNnMDAwMzQuaHRtbA0KPj4+DQo+
Pj4gU2lnbmVkLW9mZi1ieTogSWx5YSBMZW9zaGtldmljaCA8aWlpQGxpbnV4LmlibS5jb20+
DQo+Pj4gTWVzc2FnZS1JZDogPDIwMjQxMDAxMTUwNjE3Ljk5NzctMS1paWlAbGludXguaWJt
LmNvbT4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxp
bmFyby5vcmc+DQo+Pj4gLS0tDQo+Pj4gIMKgIHRlc3RzL3RjZy94ODZfNjQvY3Jvc3MtbW9k
aWZ5aW5nLWNvZGUuYyB8IDgwDQo+Pj4gKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4+
ICDCoCB0ZXN0cy90Y2cveDg2XzY0L01ha2VmaWxlLnRhcmdldMKgwqDCoMKgwqDCoMKgIHzC
oCA0ICsrDQo+Pj4gIMKgIDIgZmlsZXMgY2hhbmdlZCwgODQgaW5zZXJ0aW9ucygrKQ0KPj4+
ICDCoCBjcmVhdGUgbW9kZSAxMDA2NDQgdGVzdHMvdGNnL3g4Nl82NC9jcm9zcy1tb2RpZnlp
bmctY29kZS5jDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvdGVzdHMvdGNnL3g4Nl82NC9jcm9z
cy1tb2RpZnlpbmctY29kZS5jDQo+Pj4gYi90ZXN0cy90Y2cveDg2XzY0L2Nyb3NzLW1vZGlm
eWluZy1jb2RlLmMNCj4+PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPj4+IGluZGV4IDAwMDAw
MDAwMDAuLjI3MDRkZjYwNjENCj4+PiAtLS0gL2Rldi9udWxsDQo+Pj4gKysrIGIvdGVzdHMv
dGNnL3g4Nl82NC9jcm9zcy1tb2RpZnlpbmctY29kZS5jDQo+Pj4gQEAgLTAsMCArMSw4MCBA
QA0KPj4+ICsvKg0KPj4+ICsgKiBUZXN0IHBhdGNoaW5nIGNvZGUsIHJ1bm5pbmcgaW4gb25l
IHRocmVhZCwgZnJvbSBhbm90aGVyIHRocmVhZC4NCj4+PiArICoNCj4+PiArICogSW50ZWwg
U0RNIGNhbGxzIHRoaXMgImNyb3NzLW1vZGlmeWluZyBjb2RlIiBhbmQgcmVjb21tZW5kcyBh
DQo+Pj4gc3BlY2lhbA0KPj4+ICsgKiBzZXF1ZW5jZSwgd2hpY2ggcmVxdWlyZXMgYm90aCB0
aHJlYWRzIHRvIGNvb3BlcmF0ZS4NCj4+PiArICoNCj4+PiArICogTGludXgga2VybmVsIHVz
ZXMgYSBkaWZmZXJlbnQgc2VxdWVuY2UgdGhhdCBkb2VzIG5vdCByZXF1aXJlDQo+Pj4gY29v
cGVyYXRpb24gYW5kDQo+Pj4gKyAqIGludm9sdmVzIHBhdGNoaW5nIHRoZSBmaXJzdCBieXRl
IHdpdGggaW50My4NCj4+PiArICoNCj4+PiArICogRmluYWxseSwgdGhlcmUgaXMgdXNlci1t
b2RlIHNvZnR3YXJlIG91dCB0aGVyZSB0aGF0IHNpbXBseSB1c2VzDQo+Pj4gYXRvbWljcywg
YW5kDQo+Pj4gKyAqIHRoYXQgc2VlbXMgdG8gYmUgZ29vZCBlbm91Z2ggaW4gcHJhY3RpY2Uu
IFRlc3QgdGhhdCBRRU1VIGhhcyBubw0KPj4+IHByb2JsZW1zDQo+Pj4gKyAqIHdpdGggdGhp
cyBhcyB3ZWxsLg0KPj4+ICsgKi8NCj4+PiArDQo+Pj4gKyNpbmNsdWRlIDxhc3NlcnQuaD4N
Cj4+PiArI2luY2x1ZGUgPHB0aHJlYWQuaD4NCj4+PiArI2luY2x1ZGUgPHN0ZGJvb2wuaD4N
Cj4+PiArI2luY2x1ZGUgPHN0ZGxpYi5oPg0KPj4+ICsNCj4+PiArdm9pZCBhZGQxX29yX25v
cChsb25nICp4KTsNCj4+PiArYXNtKCIucHVzaHNlY3Rpb24gLnJ3eCxcImF3eFwiLEBwcm9n
Yml0c1xuIg0KPj4+ICvCoMKgwqAgIi5nbG9ibCBhZGQxX29yX25vcFxuIg0KPj4+ICvCoMKg
wqAgLyogYWRkcSAkMHgxLCglcmRpKSAqLw0KPj4+ICvCoMKgwqAgImFkZDFfb3Jfbm9wOiAu
Ynl0ZSAweDQ4LCAweDgzLCAweDA3LCAweDAxXG4iDQo+Pj4gK8KgwqDCoCAicmV0XG4iDQo+
Pj4gK8KgwqDCoCAiLnBvcHNlY3Rpb25cbiIpOw0KPj4+ICsNCj4+PiArI2RlZmluZSBUSFJF
QURfV0FJVCAwDQo+Pj4gKyNkZWZpbmUgVEhSRUFEX1BBVENIIDENCj4+PiArI2RlZmluZSBU
SFJFQURfU1RPUCAyDQo+Pj4gKw0KPj4+ICtzdGF0aWMgdm9pZCAqdGhyZWFkX2Z1bmModm9p
ZCAqYXJnKQ0KPj4+ICt7DQo+Pj4gK8KgwqDCoCBpbnQgdmFsID0gMHgwMDI2NzQ4ZDsgLyog
bm9wICovDQo+Pj4gKw0KPj4+ICvCoMKgwqAgd2hpbGUgKHRydWUpIHsNCj4+PiArwqDCoMKg
wqDCoMKgwqAgc3dpdGNoIChfX2F0b21pY19sb2FkX24oKGludCAqKWFyZywgX19BVE9NSUNf
U0VRX0NTVCkpIHsNCj4+PiArwqDCoMKgwqDCoMKgwqAgY2FzZSBUSFJFQURfV0FJVDoNCj4+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsNCj4+PiArwqDCoMKgwqDCoMKgwqAg
Y2FzZSBUSFJFQURfUEFUQ0g6DQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmFsID0g
X19hdG9taWNfZXhjaGFuZ2VfbigoaW50ICopJmFkZDFfb3Jfbm9wLCB2YWwsDQo+Pj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIF9fQVRPTUlDX1NFUV9DU1QpOw0KPj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+ICvCoMKgwqDCoMKgwqDCoCBjYXNlIFRIUkVBRF9T
VE9QOg0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBOVUxMOw0KPj4+ICvC
oMKgwqDCoMKgwqDCoCBkZWZhdWx0Og0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGFz
c2VydChmYWxzZSk7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX19idWlsdGluX3Vu
cmVhY2hhYmxlKCk7DQo+Pg0KPj4gVXNlIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCkgaW5zdGVh
ZC4NCj4+IGNoZWNrcGF0Y2ggZW1pdHMgYW4gZXJyb3IgZm9yIGl0IG5vdy4NCj4gDQo+IElz
IHRoZXJlIGFuIGVhc3kgd2F5IHRvIGluY2x1ZGUgZ2xpYiBmcm9tIHRlc3RjYXNlcz8NCj4g
SXQncyBsb2NhdGVkIHVzaW5nIG1lc29uLCBhbmQgSSBjYW4ndCBpbW1lZGlhdGVseSBzZWUg
aG93IHRvIHB1c2ggdGhlDQo+IHJlc3BlY3RpdmUgY29tcGlsZXIgZmxhZ3MgdG8gdGhlIHRl
c3QgTWFrZWZpbGVzIC0gdGhpcyBzZWVtcyB0byBiZQ0KPiBjdXJyZW50bHkgaGFuZGxlZCBi
eSBjb25maWd1cmUgd3JpdGluZyB0byAkY29uZmlnX3RhcmdldF9tYWsuDQo+IA0KPiBbLi4u
XQ0KPiANCg0KU29ycnkgeW91J3JlIHJpZ2h0LCBJIG1pc3NlZCB0aGUgZmFjdCB0ZXN0cyBk
b24ndCBoYXZlIHRoZSBkZXBzIHdlIGhhdmUgDQppbiBRRU1VIGl0c2VsZi4NCkkgZG9uJ3Qg
dGhpbmsgYW55IHRlc3QgY2FzZSBpbmNsdWRlIGFueSBleHRyYSBkZXBlbmRlbmN5IGZvciBu
b3cgKGFuZCANCndvdWxkIG1ha2UgaXQgaGFyZCB0byBjcm9zcyBjb21waWxlIHRoZW0gdG9v
KSwgc28gaXQncyBub3Qgd29ydGggdHJ5aW5nIA0KdG8gZ2V0IHRoZSByaWdodCBnbGliIGhl
YWRlciBmb3IgdGhpcy4NCg0KSSBkb24ndCBub3cgaWYgaXQgd2lsbCBiZSBhIHByb2JsZW0g
d2hlbiBtZXJnaW5nIHRoZSBzZXJpZXMgcmVnYXJkaW5nIA0KY2hlY2twYXRjaCwgYnV0IGlm
IGl0IGlzLCB3ZSBjYW4gYWx3YXlzIHJlcGxhY2UgdGhpcyBieSBhYm9ydCwgb3IgZXhpdC4N
Cg0KPiANCg0KQXMgaXQgaXMsDQpSZXZpZXdlZC1ieTogUGllcnJpY2sgQm91dmllciA8cGll
cnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0K

