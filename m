Return-Path: <kvm+bounces-41881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C82B8A6E813
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 02:48:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F9CB3AC9A1
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 01:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DBA131E49;
	Tue, 25 Mar 2025 01:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fbqlbt/Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A98CA4E
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 01:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742867322; cv=none; b=SbHfzadHJz3sTXQa/pM9WW731xN5rD/2xywfwxqYH1PfXDsOyd0HQgX4ezPkEzRIYjkbqMlWk8mQMcd9YfZcG7H74UFhs5c9SyvPF3UsdeXN9n3KYbtgOSwyW2ojzWcjAiZjP/W0LQSNYsffSuBp9FmuRIIDGlO09heAJnue4e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742867322; c=relaxed/simple;
	bh=jepGxtMetxth7FUIkF6aKP1E2vtROZB2g8aTn+vFrpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=szlX3QiBtiehqHBLNe9tcgSSCfxj3Rsny4UQcSFS8lJ83Wf952mSCtZij5O9hYjvmacwsQm5ny8z92S1JMBdjFNh7dSU5hPHQSwlcqQrKapv/IQ/LKOJDAgn3cserKqAl2DlAixgzH9q8oMt3fXRuJDcqJ9oQfQZ8KWmKjsBsCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fbqlbt/Y; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224341bbc1dso95373945ad.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 18:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742867319; x=1743472119; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jepGxtMetxth7FUIkF6aKP1E2vtROZB2g8aTn+vFrpA=;
        b=fbqlbt/YO6XxfRa1DSMV6WzVeN1mkcLlxK/dj2VLVb9gCA/v824FOTILFjZTLrTcAL
         1CmlNF/AVPFZOGx2uH4c6S6v+1zeBMWM4tSmh/bsfDZBIgP3iTBnh2XK3gAxcHufhsBs
         DdSwHag6ht/0rRebg40h36L/u7uQ/7w6BEwbT5FiqKLcib4kUAHEgOe6zitwRDwo2Pp3
         xiTKxeIekLtWHnU+fXVGjQfGHdD9uSTMO7biUTzY+usZ8B6sMtNSlduBHiPkjO7GTvf3
         hov3ot3tEa7Ocw9WmZQSRYgZMv3UudQjbOh7XV2E3u/C4fTSXhVEZwEFNZdrmssgrgJx
         FLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742867319; x=1743472119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jepGxtMetxth7FUIkF6aKP1E2vtROZB2g8aTn+vFrpA=;
        b=fGqHAKD2lNm/teEQcqZzUgKzS0R4zuivZWvz/nnl7Xs2ndAYTco4xMS2MwKhh4huFB
         yOHqweKgOxZtW6rGoWs5nL1tcj0vBh/8ExQ0mRJusNi7NxuVDUMNjYnrJiQvGsyjjwOm
         W/Hda2y3X+PJuF59dIzkaWO4U8d8JDPbbDMaAHvm9crV70q/liwwQ1YPF/3Yz6XGTGwU
         XMK6rXv5akKmcWkYP4yM1bcqk+V8aeqOFdpjvG21/k5HGTGqKERR0mk2+JyrP1ML7dYM
         skqTHHhGT10zDa/8Z6tabvrIpTkKCMUJmGAV+DudikVDet6di6ssbTxJ46YHrAIjon1u
         jSHA==
X-Gm-Message-State: AOJu0Yy208R7i5KEi5hO0SPUgqvTeUJhVSSG0dFg+5NoQgWh1cWMvY6/
	878FOa7rmjXoHYxHajInArfZfR8wVj8cdL//saWAistyHBd0RJ1a/JJ7Gp0D5io=
X-Gm-Gg: ASbGncvQd0ep85kdrOh34/zgciM3wja34sdWbN+/iM5kS2kO8zSXDq2AtPzOegWm6iG
	lWnQxRS1MUSHQMaFDzluEXBKgOYt1CQ5bwJHxj2+r/K2VOanTReZCyjUPpzJCOe070uDu5Ba3sL
	ytIAZjxXPaBaCHsDVV9sPQot2zUuiNZRQ7a+uu9y75yB+llEg+ZDIlM4KVUBTg7Lqq98yzZ6LaN
	ebXoAZQwfZTsagTMmQCVKI9RtamPsQntvddeyOAGhs+1lckoC8pdJ+aWUL5ZViUe6zBusrq30tw
	KKwiJCA2Myf8O0MAQyqHkxvsu9/1qMTfgcbgh/Z0OFCU2CAbSNSIlYItsg==
X-Google-Smtp-Source: AGHT+IHoINdwL8jgY5FqgvZtk5Q6BeVpE4yF1ws/NywnBXzBwUcbjtM6+wv8Mc2pJC11Q5+zeW1xjA==
X-Received: by 2002:a05:6a20:12cf:b0:1f5:86f2:a674 with SMTP id adf61e73a8af0-1fe42f326e4mr25190629637.12.1742867318910;
        Mon, 24 Mar 2025 18:48:38 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a2a23b2asm7923700a12.50.2025.03.24.18.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 18:48:38 -0700 (PDT)
Message-ID: <60aa7341-e462-4334-bc85-f70f6d48e392@linaro.org>
Date: Mon, 24 Mar 2025 18:48:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/30] hw/arm/armv7m: prepare compilation unit to be
 common
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-27-pierrick.bouvier@linaro.org>
 <0c9055a3-2650-4802-a28c-e5d79052bc81@linaro.org>
 <6cce9fd1-d008-4b63-a77f-c091fcd933e0@linaro.org>
 <67313299-0ce6-457d-ace7-73ad864a0eb0@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <67313299-0ce6-457d-ace7-73ad864a0eb0@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8yNC8yNSAxODoyMiwgUmljaGFyZCBIZW5kZXJzb24gd3JvdGU6DQo+IE9uIDMvMjQv
MjUgMTQ6MzEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBPbiAzLzIzLzI1IDEyOjQ4
LCBSaWNoYXJkIEhlbmRlcnNvbiB3cm90ZToNCj4+PiBPbiAzLzIwLzI1IDE1OjI5LCBQaWVy
cmljayBCb3V2aWVyIHdyb3RlOg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBQaWVycmljayBCb3V2
aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo+Pj4+IC0tLQ0KPj4+PiAgwqDC
oCBody9hcm0vYXJtdjdtLmMgfCAxMiArKysrKysrKy0tLS0NCj4+Pj4gIMKgwqAgMSBmaWxl
IGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4+Pj4NCj4+Pj4g
ZGlmZiAtLWdpdCBhL2h3L2FybS9hcm12N20uYyBiL2h3L2FybS9hcm12N20uYw0KPj4+PiBp
bmRleCA5OGE2OTg0NjExOS4uYzM2N2MyZGNiOTkgMTAwNjQ0DQo+Pj4+IC0tLSBhL2h3L2Fy
bS9hcm12N20uYw0KPj4+PiArKysgYi9ody9hcm0vYXJtdjdtLmMNCj4+Pj4gQEAgLTEzOSw4
ICsxMzksOSBAQCBzdGF0aWMgTWVtVHhSZXN1bHQgdjdtX3N5c3JlZ19uc193cml0ZSh2b2lk
ICpvcGFxdWUsIGh3YWRkciBhZGRyLA0KPj4+PiAgwqDCoMKgwqDCoMKgIGlmIChhdHRycy5z
ZWN1cmUpIHsNCj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIFMgYWNjZXNzZXMgdG8g
dGhlIGFsaWFzIGFjdCBsaWtlIE5TIGFjY2Vzc2VzIHRvIHRoZSByZWFsIHJlZ2lvbiAqLw0K
Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYXR0cnMuc2VjdXJlID0gMDsNCj4+Pj4gK8Kg
wqDCoMKgwqDCoMKgIE1lbU9wIGVuZCA9IHRhcmdldF93b3Jkc19iaWdlbmRpYW4oKSA/IE1P
X0JFIDogTU9fTEU7DQo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gbWVtb3J5
X3JlZ2lvbl9kaXNwYXRjaF93cml0ZShtciwgYWRkciwgdmFsdWUsDQo+Pj4+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzaXplX21lbW9wKHNpemUpIHwgTU9fVEUsIGF0
dHJzKTsNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVfbWVt
b3Aoc2l6ZSkgfCBlbmQsIGF0dHJzKTsNCj4+Pg0KPj4+IHRhcmdldF93b3Jkc19iaWdlbmRp
YW4oKSBpcyBhbHdheXMgZmFsc2UgZm9yIGFybSBzeXN0ZW0gbW9kZS4NCj4+PiBKdXN0IHMv
VEUvTEUvLg0KPj4+DQo+Pg0KPj4gR29vZCBwb2ludC4NCj4+DQo+PiBCeSB0aGUgd2F5LCB3
aGF0J3MgdGhlIFFFTVUgcmF0aW9uYWxlIGJlaGluZCBoYXZpbmcgQXJtIGJpZyBlbmRpYW4g
dXNlciBiaW5hcmllcywgYW5kIG5vdA0KPj4gcHJvdmlkZSBpdCBmb3Igc29mdG1tdSBiaW5h
cmllcz8NCj4gDQo+IEZvciBzeXN0ZW0gbW9kZSwgZW5kaWFubmVzcyBpcyBzZXQgdmlhIGEg
Y29tYmluYXRpb24gb2YgQ1BTUi5FLCBTQ1RMUi5CIGFuZCBTQ1RMUi5FRSwNCj4gZGV0YWls
cyBkZXBlbmRpbmcgb24gYXJtdjQsIGFybXY2LCBhcm12NysuDQo+IA0KPiBJdCBpcyBJTVBM
RU1FTlRBVElPTiBERUZJTkVEIGhvdyB0aGUgY3B1IGluaXRpYWlsaXplcyBhdCByZXNldC4g
IEluIG9sZGVuIHRpbWVzLCB2aWEgYQ0KPiBib2FyZC1sZXZlbCBwaW4gKHNvbWV0aW1lcyBz
d2l0Y2hlZCwgc29tZXRpbWVzIHNvbGRlcmVkKS4gIFdlIG1vZGVsIHRoZSBib2FyZC1sZXZl
bCBwaW4NCj4gdmlhIHRoZSAiY2ZnZW5kIiBjcHUgcHJvcGVydHkuDQo+IA0KPiBJbiBhbnkg
Y2FzZSwgZm9yIHN5c3RlbSBtb2RlIHdlIGV4cGVjdCB0aGUgZ3Vlc3QgdG8gZG8gdGhlIHNh
bWUgdGhpbmcgaXQgd291bGQgbmVlZCB0byBkbw0KPiBvbiByZWFsIGhhcmR3YXJlLiAgRm9y
IHVzZXIgbW9kZSwgd2UgY2FuJ3QgZG8gdGhhdCwgYXMgd2UncmUgYWxzbyBlbXVsYXRpbmcg
dGhlIE9TIGxheWVyLA0KPiB3aGljaCBuZWVkcyB0byBrbm93IHRoZSBlbmRpYW5uZXNzIHRv
IGV4cGVjdCBmcm9tIHRoZSBndWVzdCBiaW5hcmllcy4NCj4gDQoNCk9oIHllcywgdG90YWxs
eSBtYWtlcyBzZW5zZS4gVGhhbmtzLg0KDQo+PiBJZiB0aG9zZSBzeXN0ZW1zIGFyZSBzbyBy
YXJlLCB3aHkgd291bGQgcGVvcGxlIG5lZWQgYSB1c2VyIG1vZGUgZW11bGF0aW9uPw0KPiAN
Cj4gSU1PIGFybWJlLWxpbnV4LXVzZXIgaXMgZXh0aW5jdC4NCj4gDQo+IERlYmlhbiBuZXZl
ciBoYWQgYmlnLWVuZGlhbiBzdXBwb3J0IGF0IGFsbC4gIElmIHRoZXJlIHdhcyBzb21lIG90
aGVyIGRpc3RybyB3aGljaCBoYWQgaXQsDQo+IEkgZG9uJ3QgcmVjYWxsIHdoaWNoLiAgT3Ro
ZXJ3aXNlIHlvdSdkIG5lZWQgdG8gYm9vdHN0cmFwIHRoZSBlbnRpcmUgdG9vbGNoYWluLCB3
aGljaCB0byBtZQ0KPiBzZWVtcyByYXRoZXIgYmVzaWRlIHRoZSBwb2ludC4NCj4gDQo+IA0K
PiByfg0KDQo=

