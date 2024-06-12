Return-Path: <kvm+bounces-19481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF459057E0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 18:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8547B2925C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E9518306E;
	Wed, 12 Jun 2024 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TkdAzIu8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3510E1822EC
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207943; cv=none; b=F4Bd+Io0H5V8bXR/uS7Jel59wrpqgfWPNoQEBuWfifx8LHYSSPPppzZnwivmZXHFAVoLu24qgkJHpavkPwpACOc/B+mytpDh/pWWMbC9HfszHm1qmv6XsQwcbNMTJr2BBwRm2XHCaZvsfx2O9rCWent3d/MLMd317awLO7qRqpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207943; c=relaxed/simple;
	bh=w09RxZOBny7Sg1bz7VrqcLEIzdlX8GfmywPXOlJGEc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iugrewLxzoeqyJhtbIgLhCQ+h57U1UNiUpyhavG3ek5MzX5jIyk24Fd/hgZoJ8OWcfJvtNl0RzBKxDk2fYiXbOFwKJ5+9jTtMsLKJzPP1s4Wu+woH7UxyQERi1P2qaX2UhOaNzUOLyhW4z9gUgUrvb33304k3LgHXg6CGDeTeTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TkdAzIu8; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-652fd0bb5e6so6118521a12.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718207941; x=1718812741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w09RxZOBny7Sg1bz7VrqcLEIzdlX8GfmywPXOlJGEc0=;
        b=TkdAzIu8jxuArbul6eirkvmt352f461LFLVO76wqft6wKT8Frw+2+sCMdAA8D+JFMc
         2ZSaAIPy63A0pbF1Xp2XfVlPZ2XhUhYGbnDS42REY+dqwha8A3FijF/MJ+U65oWSciPD
         rB6gOIwJTJ8HQsl7Eqj62IfvKgqVjPJ2zMxhjjZvV0JuGg4/kPwSulhByaYOXoWNlLlq
         hLg2VhoCaOCMGF9evosftN5BQ8kMmBjsXLJZaRVF6U1TXWTD9LzT0r6Nobr8PV2ogTEU
         KUw/E3SJy/mSlohPpBbzGD1rCG8hzxQMbCm0OU0hwCv01qHXXymbNHDgo9PMbxtz+hnA
         Ap1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718207941; x=1718812741;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w09RxZOBny7Sg1bz7VrqcLEIzdlX8GfmywPXOlJGEc0=;
        b=gNuwoaYuuUuUbB05Bg2iQlqlcFc/z+q9OgyH+pfY2VsqyuXk/eNua0tzP8t2AM95nE
         IPivt/L8ylygka2/Aw8vdMp+UUHXjNVNhCbtaSWL6qFFHcAwFkvLk4X49Iu40mtJx5ax
         JKCqtE737/ou8HU4WYAMPBbrpWuGDRqug5hgcb3RKXhxgykh1DaUJHrb0O4kCARZLE0H
         jVsbwnp1fKK3wned3HSkgqL/WxqmtKiCJ6rqyDCg9TRfutj+H6spaCdsjchSJZKHSa4P
         6zhkPhHBQC4oD+1jSJGnkh/MoPMXvoxkRy/kImkiMhUJBOrmInqo15eko0YXs6GF4hpG
         A0gA==
X-Forwarded-Encrypted: i=1; AJvYcCUjdbxuIege/8+ov/jNrYw6VpwbHzGS9JTI9K46ZkKzDCx9kmcbjVWyKnw+iet5zPWUbiUI3AqP+CU7/kmfD5RKdDMN
X-Gm-Message-State: AOJu0Yz2ypsriHD1fq1EETk4hgn9KY42Lbaz11Gjn9AWu9naCEJzSRNV
	gOjAh6U4QbNpAja5HSJcPBYbXYizcadwZdzSHkeBgQHS+k3PRC00xjJczQTgPro=
X-Google-Smtp-Source: AGHT+IFoOB41A/pNuCVe7i10DhwZq0RfFVAAxo73DwlamIyd9qOnO1yuSNSWMDuxunZowX6e1t+sWA==
X-Received: by 2002:a17:90a:5904:b0:2c2:f70a:3c17 with SMTP id 98e67ed59e1d1-2c4a772cbd0mr2100460a91.46.1718207941451;
        Wed, 12 Jun 2024 08:59:01 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::2193? ([2604:3d08:9384:1d00::2193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75e1130sm1980891a91.3.2024.06.12.08.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 08:59:01 -0700 (PDT)
Message-ID: <757024bf-9da2-4f2e-9df1-dcbfac573582@linaro.org>
Date: Wed, 12 Jun 2024 08:58:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] plugins: Ensure register handles are not NULL
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>, Ilya Leoshkevich
 <iii@linux.ibm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mark Burton <mburton@qti.qualcomm.com>, qemu-s390x@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Laurent Vivier <lvivier@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Alexandre Iooss <erdnaxe@crans.org>, qemu-arm@nongnu.org,
 Alexander Graf <agraf@csgraf.de>, Nicholas Piggin <npiggin@gmail.com>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, qemu-ppc@nongnu.org,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Cameron Esfahani <dirty@apple.com>,
 Jamie Iles <quic_jiles@quicinc.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-4-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240612153508.1532940-4-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xMi8yNCAwODozNSwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBGcm9tOiBBa2loaWtv
IE9kYWtpIDxha2loaWtvLm9kYWtpQGRheW5peC5jb20+DQo+IA0KPiBFbnN1cmUgcmVnaXN0
ZXIgaGFuZGxlcyBhcmUgbm90IE5VTEwgc28gdGhhdCBhIHBsdWdpbiBjYW4gYXNzdW1lIE5V
TEwgaXMNCj4gaW52YWxpZCBhcyBhIHJlZ2lzdGVyIGhhbmRsZS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEFraWhpa28gT2Rha2kgPGFraWhpa28ub2Rha2lAZGF5bml4LmNvbT4NCj4gTWVz
c2FnZS1JZDogPDIwMjQwMjI5LW51bGwtdjEtMS1lNzE2NTAxZDk4MWVAZGF5bml4LmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3Jn
Pg0KPiAtLS0NCj4gICBwbHVnaW5zL2FwaS5jIHwgNCArKy0tDQo+ICAgMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9wbHVnaW5zL2FwaS5jIGIvcGx1Z2lucy9hcGkuYw0KPiBpbmRleCA1YTBhN2Y4YzcxLi42
YmRiMjZiYmUzIDEwMDY0NA0KPiAtLS0gYS9wbHVnaW5zL2FwaS5jDQo+ICsrKyBiL3BsdWdp
bnMvYXBpLmMNCj4gQEAgLTUwNyw3ICs1MDcsNyBAQCBzdGF0aWMgR0FycmF5ICpjcmVhdGVf
cmVnaXN0ZXJfaGFuZGxlcyhHQXJyYXkgKmdkYnN0dWJfcmVncykNCj4gICAgICAgICAgIH0N
Cj4gICANCj4gICAgICAgICAgIC8qIENyZWF0ZSBhIHJlY29yZCBmb3IgdGhlIHBsdWdpbiAq
Lw0KPiAtICAgICAgICBkZXNjLmhhbmRsZSA9IEdJTlRfVE9fUE9JTlRFUihncmQtPmdkYl9y
ZWcpOw0KPiArICAgICAgICBkZXNjLmhhbmRsZSA9IEdJTlRfVE9fUE9JTlRFUihncmQtPmdk
Yl9yZWcgKyAxKTsNCj4gICAgICAgICAgIGRlc2MubmFtZSA9IGdfaW50ZXJuX3N0cmluZyhn
cmQtPm5hbWUpOw0KPiAgICAgICAgICAgZGVzYy5mZWF0dXJlID0gZ19pbnRlcm5fc3RyaW5n
KGdyZC0+ZmVhdHVyZV9uYW1lKTsNCj4gICAgICAgICAgIGdfYXJyYXlfYXBwZW5kX3ZhbChm
aW5kX2RhdGEsIGRlc2MpOw0KPiBAQCAtNTI4LDcgKzUyOCw3IEBAIGludCBxZW11X3BsdWdp
bl9yZWFkX3JlZ2lzdGVyKHN0cnVjdCBxZW11X3BsdWdpbl9yZWdpc3RlciAqcmVnLCBHQnl0
ZUFycmF5ICpidWYpDQo+ICAgew0KPiAgICAgICBnX2Fzc2VydChjdXJyZW50X2NwdSk7DQo+
ICAgDQo+IC0gICAgcmV0dXJuIGdkYl9yZWFkX3JlZ2lzdGVyKGN1cnJlbnRfY3B1LCBidWYs
IEdQT0lOVEVSX1RPX0lOVChyZWcpKTsNCj4gKyAgICByZXR1cm4gZ2RiX3JlYWRfcmVnaXN0
ZXIoY3VycmVudF9jcHUsIGJ1ZiwgR1BPSU5URVJfVE9fSU5UKHJlZykgLSAxKTsNCj4gICB9
DQo+ICAgDQo+ICAgc3RydWN0IHFlbXVfcGx1Z2luX3Njb3JlYm9hcmQgKnFlbXVfcGx1Z2lu
X3Njb3JlYm9hcmRfbmV3KHNpemVfdCBlbGVtZW50X3NpemUpDQoNClJldmlld2VkLWJ5OiBQ
aWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQo=

