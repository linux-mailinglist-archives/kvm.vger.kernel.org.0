Return-Path: <kvm+bounces-20159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD3A911147
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 20:49:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3BF91F21091
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165BC1BD02C;
	Thu, 20 Jun 2024 18:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MMX12Pcn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCA61BB696
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 18:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718908805; cv=none; b=au7mZuOfioH6eWFj6NJyKHb6vgosxPd1XM2KKBafbBHv8gxsurkoigGqZrHmfeJvB+LUsD7p7mqpdrbJ/3ipWPpFp3j3YTLR6lQoHsSbGqvfgg6Ct9qCBKJfCuWGBnQIoR4qm7PNKlUO8Mp8rYqcs1g2xUbkNVznrmv1gmDaXRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718908805; c=relaxed/simple;
	bh=t7ugR8LyJ4yhjJE6jRVvqgPt4wBlmHq1ns/6Tho+3ic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fLg+Kepx6eOjjXKfb6CGggXeXIPWARYQsPqIE/COY6Wbp+c2QlmA192t/gq9WNyqe8VBYgntCrrJJoL+QJkYjlMHEHK6T0iey4xzHVNeu/SnVua6CVkdoVJPk2fgJ6VNjRiWBtGn6gBqvY030YKgWzNSVZPvI/zYUbKw+AdXg/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MMX12Pcn; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70109d34a16so1135667b3a.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 11:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718908803; x=1719513603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t7ugR8LyJ4yhjJE6jRVvqgPt4wBlmHq1ns/6Tho+3ic=;
        b=MMX12PcnvjaLE8jZVlb00K52O6VwrXHByHHJJpKDDoyqC+qLo1BkN4wWtKx3VgYdy5
         hU/jVees8IqMA0IB/gWyRf3ebeFuooigRYJghqlhDbjmSc4V3dKuVnHDHnnEKVFhO5tZ
         2nze8hP4Qf0B8cXLrWXni3WRsg/Pwm26PBLswYeTrIzDhDA8w+VprhTJQoEaAubjyo+s
         /rWbOyXNS7HEkw9w4SjVuz66tiyLYPH5+pTDWO5QwibvhUE/SLkj9kB92IdxLW2l9KHu
         zVHPLqOIzTNp69I0taZ/ix96gvRuS1Vjcf0TV6d0sapq2WkZEygqVKeFMQIlC4k5lxDW
         39rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718908803; x=1719513603;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t7ugR8LyJ4yhjJE6jRVvqgPt4wBlmHq1ns/6Tho+3ic=;
        b=UAIk+uJhHbzcEOomNq1F5GrA1ACfBVJDPEBpSPA0eEy5RTyfQAZNpU8jtetrW8+57r
         5H659S5EqXDS6u7PcGAnF+RV4+4Tq/RXiuNpclNi7BP3qbgcL7OT1aJfnNGqEnWBOy5d
         CUgs6kauKVYCiz0rYo9oa6qGA7WRbGAWS8RUj0N1ke9jsVrQt3GaLnpSfyLVzDV9HI+M
         67b6wxjpUX79p2EG6QuWNUgOMpPudez8fPEDh6OHqPZXIu7NSqWfeCfq9IrgfzZtH4wM
         PRe/PaChO1jRFACtYgnBHSGm2awmot0dz+GOqse/L8ONXR2WJk9XO52UnnhSF+uKsW1L
         8qiw==
X-Forwarded-Encrypted: i=1; AJvYcCU4g3aH4TBdsa/QSf6R/PR7m6Lo4KA8zUswFtIPfOAD9ZTqunHHTsQM7gTosmpGNOKzwXfz9bZ6SaUVT/DfPNTHVZyv
X-Gm-Message-State: AOJu0Yx4nR3Sq00lA71dIYg0jfAV1+3WRHPSJyx5VW2ISSdzBp2X84sB
	Xe9Dk46vLDDTnr2aDEr9UQ/NUQbHCpv/5HNmWRjyBWk+c3TY7eo1FW89cPbvMwU=
X-Google-Smtp-Source: AGHT+IH9ViMIWfbt0h1UCKQ/eJd8MvZzPCQ22Cxn984MQSLtU3vwcXljPn1bCtC/O7uwoBqYxsye6Q==
X-Received: by 2002:a05:6a20:b202:b0:1b8:6ed5:a70 with SMTP id adf61e73a8af0-1bcbb5d5116mr6437613637.49.1718908802848;
        Thu, 20 Jun 2024 11:40:02 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::2193? ([2604:3d08:9384:1d00::2193])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70649012058sm939903b3a.35.2024.06.20.11.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 11:40:02 -0700 (PDT)
Message-ID: <59ef28a2-7a29-4214-893c-67d27bea8377@linaro.org>
Date: Thu, 20 Jun 2024 11:40:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] accel/tcg: Avoid unnecessary call overhead from
 qemu_plugin_vcpu_mem_cb
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jamie Iles <quic_jiles@quicinc.com>,
 David Hildenbrand <david@redhat.com>, Mark Burton
 <mburton@qti.qualcomm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
 qemu-arm@nongnu.org, Laurent Vivier <lvivier@redhat.com>,
 Alexander Graf <agraf@csgraf.de>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Halil Pasic <pasic@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Nicholas Piggin <npiggin@gmail.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Max Chou <max.chou@sifive.com>, Frank Chang <frank.chang@sifive.com>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
 <20240620152220.2192768-13-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240620152220.2192768-13-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8yMC8yNCAwODoyMiwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBGcm9tOiBNYXggQ2hv
dSA8bWF4LmNob3VAc2lmaXZlLmNvbT4NCj4gDQo+IElmIHRoZXJlIGFyZSBub3QgYW55IFFF
TVUgcGx1Z2luIG1lbW9yeSBjYWxsYmFjayBmdW5jdGlvbnMsIGNoZWNraW5nDQo+IGJlZm9y
ZSBjYWxsaW5nIHRoZSBxZW11X3BsdWdpbl92Y3B1X21lbV9jYiBmdW5jdGlvbiBjYW4gcmVk
dWNlIHRoZQ0KPiBmdW5jdGlvbiBjYWxsIG92ZXJoZWFkLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogTWF4IENob3UgPG1heC5jaG91QHNpZml2ZS5jb20+DQo+IFJldmlld2VkLWJ5OiBSaWNo
YXJkIEhlbmRlcnNvbiA8cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZz4NCj4gUmV2aWV3
ZWQtYnk6IEZyYW5rIENoYW5nIDxmcmFuay5jaGFuZ0BzaWZpdmUuY29tPg0KPiBNZXNzYWdl
LUlkOiA8MjAyNDA2MTMxNzUxMjIuMTI5OTIxMi0yLW1heC5jaG91QHNpZml2ZS5jb20+DQo+
IC0tLQ0KPiAgIGFjY2VsL3RjZy9sZHN0X2NvbW1vbi5jLmluYyB8IDggKysrKysrLS0NCj4g
ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2FjY2VsL3RjZy9sZHN0X2NvbW1vbi5jLmluYyBiL2FjY2VsL3Rj
Zy9sZHN0X2NvbW1vbi5jLmluYw0KPiBpbmRleCBjODIwNDhlMzc3Li44N2NlYjk1NDg3IDEw
MDY0NA0KPiAtLS0gYS9hY2NlbC90Y2cvbGRzdF9jb21tb24uYy5pbmMNCj4gKysrIGIvYWNj
ZWwvdGNnL2xkc3RfY29tbW9uLmMuaW5jDQo+IEBAIC0xMjUsNyArMTI1LDkgQEAgdm9pZCBo
ZWxwZXJfc3RfaTEyOChDUFVBcmNoU3RhdGUgKmVudiwgdWludDY0X3QgYWRkciwgSW50MTI4
IHZhbCwgTWVtT3BJZHggb2kpDQo+ICAgDQo+ICAgc3RhdGljIHZvaWQgcGx1Z2luX2xvYWRf
Y2IoQ1BVQXJjaFN0YXRlICplbnYsIGFiaV9wdHIgYWRkciwgTWVtT3BJZHggb2kpDQo+ICAg
ew0KPiAtICAgIHFlbXVfcGx1Z2luX3ZjcHVfbWVtX2NiKGVudl9jcHUoZW52KSwgYWRkciwg
b2ksIFFFTVVfUExVR0lOX01FTV9SKTsNCj4gKyAgICBpZiAoY3B1X3BsdWdpbl9tZW1fY2Jz
X2VuYWJsZWQoZW52X2NwdShlbnYpKSkgew0KPiArICAgICAgICBxZW11X3BsdWdpbl92Y3B1
X21lbV9jYihlbnZfY3B1KGVudiksIGFkZHIsIG9pLCBRRU1VX1BMVUdJTl9NRU1fUik7DQo+
ICsgICAgfQ0KPiAgIH0NCj4gICANCj4gICB1aW50OF90IGNwdV9sZGJfbW11KENQVUFyY2hT
dGF0ZSAqZW52LCBhYmlfcHRyIGFkZHIsIE1lbU9wSWR4IG9pLCB1aW50cHRyX3QgcmEpDQo+
IEBAIC0xODgsNyArMTkwLDkgQEAgSW50MTI4IGNwdV9sZDE2X21tdShDUFVBcmNoU3RhdGUg
KmVudiwgYWJpX3B0ciBhZGRyLA0KPiAgIA0KPiAgIHN0YXRpYyB2b2lkIHBsdWdpbl9zdG9y
ZV9jYihDUFVBcmNoU3RhdGUgKmVudiwgYWJpX3B0ciBhZGRyLCBNZW1PcElkeCBvaSkNCj4g
ICB7DQo+IC0gICAgcWVtdV9wbHVnaW5fdmNwdV9tZW1fY2IoZW52X2NwdShlbnYpLCBhZGRy
LCBvaSwgUUVNVV9QTFVHSU5fTUVNX1cpOw0KPiArICAgIGlmIChjcHVfcGx1Z2luX21lbV9j
YnNfZW5hYmxlZChlbnZfY3B1KGVudikpKSB7DQo+ICsgICAgICAgIHFlbXVfcGx1Z2luX3Zj
cHVfbWVtX2NiKGVudl9jcHUoZW52KSwgYWRkciwgb2ksIFFFTVVfUExVR0lOX01FTV9XKTsN
Cj4gKyAgICB9DQo+ICAgfQ0KPiAgIA0KPiAgIHZvaWQgY3B1X3N0Yl9tbXUoQ1BVQXJjaFN0
YXRlICplbnYsIGFiaV9wdHIgYWRkciwgdWludDhfdCB2YWwsDQoNCllvdSBtaWdodCB3YW50
IHRvIGFkZCB0aGUgc2FtZSB0aGluZyBpbjogYWNjZWwvdGNnL2F0b21pY19jb21tb24uYy5p
bmMNCg0KUGllcnJpY2sNCg==

