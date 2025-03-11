Return-Path: <kvm+bounces-40779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6810DA5C661
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93C96189BE7C
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1903D25F785;
	Tue, 11 Mar 2025 15:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A+a+IpTW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A663D25E82F
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706416; cv=none; b=H0wqUrW7kh3XvVhafKua/WlDfcpVsTf2ZBJonQtYYhxcaI+o1/IQGO3XJTGU/9Qx1UyBnDdIOZB+SG+uvBQXJu2hYWM0CXf4qAcF/jWXexkRiYCE1CQpCYngtZE4wuLe9FEYBVWQbUbC8tRq0TDFA+qAbOR7O/hwRS4KabWUIaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706416; c=relaxed/simple;
	bh=lQ1DlCBUIbAraI/JTg1m2qqamEpgEFznt1TObYD6Os0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QgE+LZSfU82gTJiNq3T9cDpeD7VlVRFg1W7rqqrkOJjDDYFnDVfxprjRawuEHEqoRny/6MmK7NQI6zOVZRLxVydPSwa9Fm5jCtuhNU9YoxMHYliRyehNJAFFkTTiCEER8/AskixvH2YhHOz1ilg5hvQrs4fQBh65nfZLaGE83Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A+a+IpTW; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ff80290e44so9174097a91.0
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741706414; x=1742311214; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lQ1DlCBUIbAraI/JTg1m2qqamEpgEFznt1TObYD6Os0=;
        b=A+a+IpTWRPVYnhpHUvSLQBn8WBywiCBu29Nr+AEgGyABp1mdN5UpShwGtdgZq/8Iy0
         TBzRJZtaidahlfNgFsJlAJUJwQhmiDcmOJowRfPkMeC6HJ3CvXb50CM/SxTCOoDx0o1F
         ag/w8tW6ses5ce6Py5+AGOkYh8AxpLijS1YHWyJWVw8NjMr8wm5uuucxPwf1tjF58KKK
         2HmJh6NOn5pvbk6K34+nxUNFpLIDDdLegvIr1zUanyp3hWMFttrz25ttD51/LLda7GAW
         8rIV4gEjbLnGa++Z+QwBT0tOIUGQ3xWZ2guuE8c7+DLoqYh2ftmbIFapELgyjK5P1QwV
         I7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741706414; x=1742311214;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lQ1DlCBUIbAraI/JTg1m2qqamEpgEFznt1TObYD6Os0=;
        b=H4s6ygR+z6ioCEzkCmnsBYySvZ8dNdfFZR8DIiekKmSW9CnimTSy7pFUxFg7EyxaoX
         YtgJdPRGA9L3Lu4L9LwPo9+eYuLkUul/S1F1iaSg1TKHba686zL1r/I5NwA7ywrvvA6i
         i4QLFAVHZgBscLhXMNpiHMaNm22cuN35E99YUkOOcQgS6Jrv40sEb6rmtqD87ROOnTV1
         yVtUs1nkfbDSiU4Q6rPGgzXH9oDS2u0CQ8f9vHZZGe6AUKvQgHWxoY1q/sdErB9ZOw56
         EBMt1EG6ZnB5zM9cGfNtw6PNKuj8nDaiLrWz0osSQN2fwcIULHGcGDGs+Svgai/q7CWc
         6l7w==
X-Forwarded-Encrypted: i=1; AJvYcCWxzkqnHvD5qIuH1xk3V1SoZ+OJfiDJhogqelT+PgVC2BVf51Gg/OKQKCfAf1FmDan/4zc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKlNllySUn4dmrrivsJKbNsDvEdEfuDnBRT7gPPmtMTCiwVlpa
	DZIOUSuu5r8v0M+/5I3EXKjehGg7STmqC4tBJVJXGGcJIZSB3yEIIbwXYGRKAls=
X-Gm-Gg: ASbGncs8LyfgEtjveFunHtW7DY3RqZlOv+kjZQjTlyhglZR1EHEZNn2I6HAeWh15+Pa
	lQ/G4h4OWUTEPlBcOkUY/TkqnTsSyMeCFJU5XDCOgyArnwp5yjv9WlJ2IMlyDFN4am/RZStRfJp
	zTAKA3KR6tRs70S/XGoWyNyhmt+Or6Vlnd3McfnsV01v6Au6HxCY8DK5CsSD4Kw3vsDCV6m0PXN
	LD66TKS2kYDSu3jU/+0Ir1jLLm2gRCWQEnvNiptdUAeGvCqL78vOaZjssjbN4UTTXadjz6kUIRQ
	xDg+YSKhS9nBV5X7kxBQ9fTOwUFjIlYSDEyH+cg18QLNP2qRCJmQB1ywCg==
X-Google-Smtp-Source: AGHT+IHB6/PW0IHKkK7wGI9UOrKJJD3Du6pkJ5/gnIg+/UfsjtLDQjkMRqgvo/n5/5r2fsfdUad9Yg==
X-Received: by 2002:a17:90b:2883:b0:2ff:52e1:c4a1 with SMTP id 98e67ed59e1d1-2ff7cf128acmr27929118a91.24.1741706413718;
        Tue, 11 Mar 2025 08:20:13 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff53eda418sm11565063a91.45.2025.03.11.08.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 08:20:13 -0700 (PDT)
Message-ID: <42184de6-5484-4e5a-b502-48db0e6d2cf5@linaro.org>
Date: Tue, 11 Mar 2025 08:20:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/16] include/exec/memory: extract devend_big_endian
 from devend_memop
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 xen-devel@lists.xenproject.org, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 qemu-riscv@nongnu.org, manos.pitsidianakis@linaro.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Anthony PERARD <anthony@xenproject.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
 <20250311040838.3937136-15-pierrick.bouvier@linaro.org>
 <b8073e25-ae8a-462b-b085-84c471a4bf5e@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <b8073e25-ae8a-462b-b085-84c471a4bf5e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xMS8yNSAwMDozNiwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDExLzMvMjUgMDU6MDgsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiB3ZSdsbCB1c2Ug
aXQgaW4gc3lzdGVtL21lbW9yeS5jLg0KPiANCj4gSGF2aW5nIHBhcnQgb2YgdGhlIGNvbW1p
dCBkZXNjcmlwdGlvbiBzZXBhcmF0ZWQgaW4gaXRzIHN1YmplY3QgaXMgYQ0KPiBiaXQgYW5u
b3lpbmcuIEJ1dCB0aGVuIEknbSBwcm9iYWJseSB1c2luZyAyMC15ZWFycyB0b28gb2xkIHRv
b2xzIGluDQo+IG15IHBhdGNoIHdvcmtmbG93Lg0KPiANCj4gT25seSB1c2VkIGluIHN5c3Rl
bS97bWVtb3J5LHBoeXNtZW19LmMsIHdvcnRoIG1vdmUgdG8gYSBsb2NhbA0KPiBzeXN0ZW0v
bWVtb3J5LWludGVybmFsLmggaGVhZGVyPyBPciBldmVuIHNpbXBsZXIsIG1vdmUNCj4gaW5j
bHVkZS9leGVjL21lbW9yeS1pbnRlcm5hbC5oIC0+IGV4ZWMvbWVtb3J5LWludGVybmFsLmgg
Zmlyc3QuDQo+IA0KDQpHb29kIHBvaW50LCBJJ2xsIG1vdmUgdGhlbSB0byB0aGUgZXhpc3Rp
bmcgZXhlYy9tZW1vcnktaW50ZXJuYWwuaCBpbiBhbiANCmFkZGl0aW9uYWwgY29tbWl0Lg0K
DQo+PiBTaWduZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVy
QGxpbmFyby5vcmc+DQo+PiAtLS0NCj4+ICAgIGluY2x1ZGUvZXhlYy9tZW1vcnkuaCB8IDE4
ICsrKysrKysrKysrKy0tLS0tLQ0KPj4gICAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlv
bnMoKyksIDYgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvZXhl
Yy9tZW1vcnkuaCBiL2luY2x1ZGUvZXhlYy9tZW1vcnkuaA0KPj4gaW5kZXggNjBjMGZiNmNj
ZDQuLjU3NjYxMjgzNjg0IDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS9leGVjL21lbW9yeS5o
DQo+PiArKysgYi9pbmNsdWRlL2V4ZWMvbWVtb3J5LmgNCj4+IEBAIC0zMTM4LDE2ICszMTM4
LDIyIEBAIGFkZHJlc3Nfc3BhY2Vfd3JpdGVfY2FjaGVkKE1lbW9yeVJlZ2lvbkNhY2hlICpj
YWNoZSwgaHdhZGRyIGFkZHIsDQo+PiAgICBNZW1UeFJlc3VsdCBhZGRyZXNzX3NwYWNlX3Nl
dChBZGRyZXNzU3BhY2UgKmFzLCBod2FkZHIgYWRkciwNCj4+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHVpbnQ4X3QgYywgaHdhZGRyIGxlbiwgTWVtVHhBdHRycyBhdHRy
cyk7DQo+PiAgICANCj4+IC0vKiBlbnVtIGRldmljZV9lbmRpYW4gdG8gTWVtT3AuICAqLw0K
Pj4gLXN0YXRpYyBpbmxpbmUgTWVtT3AgZGV2ZW5kX21lbW9wKGVudW0gZGV2aWNlX2VuZGlh
biBlbmQpDQo+PiArLyogcmV0dXJucyB0cnVlIGlmIGVuZCBpcyBiaWcgZW5kaWFuLiAqLw0K
Pj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBkZXZlbmRfYmlnX2VuZGlhbihlbnVtIGRldmljZV9l
bmRpYW4gZW5kKQ0KPj4gICAgew0KPj4gICAgICAgIFFFTVVfQlVJTERfQlVHX09OKERFVklD
RV9IT1NUX0VORElBTiAhPSBERVZJQ0VfTElUVExFX0VORElBTiAmJg0KPj4gICAgICAgICAg
ICAgICAgICAgICAgICAgIERFVklDRV9IT1NUX0VORElBTiAhPSBERVZJQ0VfQklHX0VORElB
Tik7DQo+PiAgICANCj4+IC0gICAgYm9vbCBiaWdfZW5kaWFuID0gKGVuZCA9PSBERVZJQ0Vf
TkFUSVZFX0VORElBTg0KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgPyB0YXJnZXRfd29y
ZHNfYmlnZW5kaWFuKCkNCj4+IC0gICAgICAgICAgICAgICAgICAgICAgIDogZW5kID09IERF
VklDRV9CSUdfRU5ESUFOKTsNCj4+IC0gICAgcmV0dXJuIGJpZ19lbmRpYW4gPyBNT19CRSA6
IE1PX0xFOw0KPj4gKyAgICBpZiAoZW5kID09IERFVklDRV9OQVRJVkVfRU5ESUFOKSB7DQo+
PiArICAgICAgICByZXR1cm4gdGFyZ2V0X3dvcmRzX2JpZ2VuZGlhbigpOw0KPj4gKyAgICB9
DQo+PiArICAgIHJldHVybiBlbmQgPT0gREVWSUNFX0JJR19FTkRJQU47DQo+PiArfQ0KPj4g
Kw0KPj4gKy8qIGVudW0gZGV2aWNlX2VuZGlhbiB0byBNZW1PcC4gICovDQo+PiArc3RhdGlj
IGlubGluZSBNZW1PcCBkZXZlbmRfbWVtb3AoZW51bSBkZXZpY2VfZW5kaWFuIGVuZCkNCj4+
ICt7DQo+PiArICAgIHJldHVybiBkZXZlbmRfYmlnX2VuZGlhbihlbmQpID8gTU9fQkUgOiBN
T19MRTsNCj4+ICAgIH0NCj4+ICAgIA0KPj4gICAgLyoNCj4gDQo=

