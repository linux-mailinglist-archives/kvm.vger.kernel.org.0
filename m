Return-Path: <kvm+bounces-19502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2A9905C5D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A1A51C21CFE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EEF283CD3;
	Wed, 12 Jun 2024 19:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G4//iXNO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F359381C4
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718222082; cv=none; b=tFUSz4WrAmxYrdEyHMxA8VDQ27nFmm0M21I6QGneNcMjdxCa3AJRznxEfk+AF9qkZFyu7Y2yvzET3kLpQGdb+Q4h+RwQncQjGFnTyZhZiExMmqnrUjW7Mjex7WwMavHmvELM5VijQL3fcjMO8/VUrd2xvF0HYk+ipgjKWLqMBYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718222082; c=relaxed/simple;
	bh=014mCvmsneMMkuLx+Xyiw1WdgpnbnmCM9FvWncbYNgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxdvfrCZT0zkTIFGvbXhVIGIaT1ApGNwMWamZ1l0lkNJWyv8NB2EJfRXAdYOoHDJcNTnVxTDmKuU3FDJMJOHwHciPO00vJrRiKjZUsJxToEmfz4yOmdDOzTecrSx4/TZjT8wepFWGAe3vkyeh/tvTc189L5WOxgw7YxUXlCc590=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G4//iXNO; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1f6559668e1so2609565ad.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 12:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718222080; x=1718826880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=014mCvmsneMMkuLx+Xyiw1WdgpnbnmCM9FvWncbYNgI=;
        b=G4//iXNOgJwD1iGJyEihAnHDGtlTyPZK5Q29d0UxftCyTJSMimcjBXOn73QcjLk+MW
         zp8ogKDpblZW41JeHhgLxc90x6RmMkeBKFA7ISCDeK7y7+SYAjIQrKlHut4C23R4Z4vh
         gGtmgIDAWGX8RqPSpKtLDLo7pkdJKzFzHFTp2DxlmO0lFpViitcj8xJCo3Ss20T9pm5z
         W8FnAJcK3dzxb6L7u3vxBZNP3H5IYdqzwuYHsbMFq/A16Jg1EbhHo9qaxw9Rd6uPzdeg
         yUrKK9yPDx3odj9R7ceT/ebRTKYinLt/5jMqMIYoewpiNm33TuK9TwdCq0VP58Vl2VLM
         62dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718222080; x=1718826880;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=014mCvmsneMMkuLx+Xyiw1WdgpnbnmCM9FvWncbYNgI=;
        b=COns5gR9cxN3fFsNom5d6nMW29Nf1Kc5iTOQZb0/bWRvfcrJxo8rXSpLPJkpZDSrL/
         He/ZJnOWb9Cz8rSIZ031inTpDC4/jwy7wXqRWBnDQFaC77DSZPYH+GLjZD3D3igJ+MoP
         EPNcMMrzwMJa1XR56MlpZeStB7AJoaf+77YSL5Fnz7LOMsce+nUERhMYUkpxgyfLhR04
         BB48yFQmvtkrV6JoxMvmRrb9YHFYjvD2DyvbEwfPGwwIP0MX9TeiQgRfEjJQgyaIrkL9
         QPMceURqqEtchLZ9SfDC17Vo56tV4VWcydbYdB0o5m5HFK+Gkb4716M7SonGU+YyrDvT
         yk6A==
X-Forwarded-Encrypted: i=1; AJvYcCWIdwufOoOIrlxxSy1ukT64sOck5ptt6TrCc5YOEoTR3sk3G36UxHR3MRlfUv55l+JA5CNAL1kT2IrYD5tmU3MUZJmD
X-Gm-Message-State: AOJu0Yw936lmJnZ2i7jy+peaAsKUgQUmcWQ9Vtm563sd4Tb5X0URt0dX
	TxV5jw+4UkSHhnUZX/q1T++XQpGfcWKhaJtMfvuIcFmcYgLnNLbyBOv/XeUAafk=
X-Google-Smtp-Source: AGHT+IFiZMLDHj1AGhVp8Sgaq2CBrQxTQCF/xc8ZKCR3TczAc73j+H0Z3wRTa2yTgiR8xyhFeQrcYg==
X-Received: by 2002:a17:90b:2250:b0:2c4:b300:1b4c with SMTP id 98e67ed59e1d1-2c4b3001d74mr1876019a91.24.1718222080434;
        Wed, 12 Jun 2024 12:54:40 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::2193? ([2604:3d08:9384:1d00::2193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a7602690sm2256310a91.28.2024.06.12.12.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 12:54:40 -0700 (PDT)
Message-ID: <ec9ded4e-4a06-4472-84fc-1942010b34c8@linaro.org>
Date: Wed, 12 Jun 2024 12:54:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] plugins: add time control API
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, David Hildenbrand <david@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
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
 Richard Henderson <richard.henderson@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
 <20240612153508.1532940-9-alex.bennee@linaro.org>
 <abe88b9b-621a-4956-877d-dd311a7fd58b@linaro.org>
 <87ikyevtoc.fsf@draig.linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <87ikyevtoc.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNi8xMi8yNCAxMjozNywgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBQaWVycmljayBCb3V2
aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+IHdyaXRlczoNCj4gDQo+PiBIaSBB
bGV4LA0KPj4NCj4+IEkgbm90aWNlZCB0aGUgbmV3IHN5bWJvbHMgbGFjayBRRU1VX1BMVUdJ
Tl9BUEkgcXVhbGlmaWVyIGluDQo+PiBpbmNsdWRlL3FlbXUvcWVtdS1wbHVnaW4uaDoNCj4+
IC0gcWVtdV9wbHVnaW5fdXBkYXRlX25zDQo+PiAtIHFlbXVfcGx1Z2luX3JlcXVlc3RfdGlt
ZV9jb250cm9sDQo+Pg0KPj4gU28gaXQgd291bGQgYmUgaW1wb3NzaWJsZSB0byB1c2UgdGhv
c2Ugc3ltYm9scyBvbiB3aW5kb3dzLg0KPj4NCj4+IEkga2VwdCBhIHJlbWluZGVyIHRvIHNl
bmQgYSBuZXcgcGF0Y2ggYWZ0ZXIgeW91IHB1bGxlZCB0aGlzLCBidXQgaWYgd2UNCj4+IGdv
IHRvIGEgbmV3IHNlcmllcywgaXQgY291bGQgYmUgYXMgZmFzdCBmb3IgeW91IHRvIGp1c3Qg
YWRkIHRoaXMNCj4+IGRpcmVjdGx5Lg0KPiANCj4gU3VyZSBpZiB5b3Ugc2VuZCB0aGUgcGF0
Y2ggSSdsbCBqdXN0IG1lcmdlIGl0IGludG8gdGhlIHNlcmllcy4NCj4gDQoNCkkgcG9zdGVk
IHRoZSBzZXJpZXMgPDIwMjQwNjEyMTk1MTQ3LjkzMTIxLTEtcGllcnJpY2suYm91dmllckBs
aW5hcm8ub3JnPiANCndpdGggdGhpcyBmaXgsIGFuZCBhIHNlY29uZCBmb3IgaXNzdWUgcmVw
b3J0ZWQgYnkgUmljaGFyZC4NCg0KSWYgeW91IGNvdWxkIGludGVncmF0ZSB0aG9zZSBpbiBj
dXJyZW50IHNlcmllcywgdGhhdCB3b3VsZCBiZSBwZXJmZWN0IDopDQoNClRoYW5rcyENClBp
ZXJyaWNrDQo=

