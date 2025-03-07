Return-Path: <kvm+bounces-40464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F61A574F8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 23:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BF6C1700AE
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C328257AFC;
	Fri,  7 Mar 2025 22:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="am72BPCV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBB8664C6
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 22:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387103; cv=none; b=UMNjvdCuFIJ4iEqLE2u4vC2JReylkDSIOp60vJgjG4ZpTn/bLPhvkq/14lALK7xhpWFIPn/eCi6PI5XbIqeIkxeODxi1KniLFNwsW3oU9CFFrWTFHtlL0TlCgyYCb1C7127rXx4nMkNHdE4B8Ph5I00krfVjZTyfLZVfghadA8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387103; c=relaxed/simple;
	bh=lpdyTQNoyvLDcPXfv7S+MFAA9YfJCY5NKT43UZABoS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aSyESzWJslyABTNZKyFir0QXXbzCkC/ifF54BeKYJeHUSngYvnvvdsF0O/6UT7HOoq/1Hzl8XWM3F5AJj2WSakLBtLzO2V2L2q4DTnpQk9kG1omW6feTwUt4Ju2dOL960w+TRQRWxoJyu89PqQuPfcS2ndeQgyISbLwN0Fy0nRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=am72BPCV; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2feae794508so3807516a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 14:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741387101; x=1741991901; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lpdyTQNoyvLDcPXfv7S+MFAA9YfJCY5NKT43UZABoS8=;
        b=am72BPCVH14LQy0fjiXbFD6f2IjPbA/OWtw0PKJhZsJP1hVRcpMAIYMy+hrD4+BLS3
         qbzvKR5T5k3+Tkb7bfMdZVQhb5eJdjlM/RfObq5VXke3TDBbWL/wSbZy6a5n1L3SblvA
         NybeJH6VD+Im9Pr1CZBwC6pAMkm4Cto9AJ3xNznQd14pXkln9HQLZ8DbIER35+REIt/G
         PIxzZ6MpUm2LYlzUV4A3tFddgJuqrmk9B6iqnGdT3+Uex/Cm86ls0Ie2B3GO3uvSeukx
         mfd39OHxgVVb5JKNvyGl3NdvQnTV9QLn1ZgzhYD79RMMcGPJyZP7Y+vWV3AeO3tBaOm7
         cXrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741387101; x=1741991901;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lpdyTQNoyvLDcPXfv7S+MFAA9YfJCY5NKT43UZABoS8=;
        b=s6jlveC9ZE6D9Hw9n1pFfCsvdgc2t2KDewHMepeMPop0oh2aCpHYixkPlckf/HWAED
         QrzXya9JYTNtmPkjpH8KC9KJF/PVwVjKRximPVnEshmFCxEtuiyVmPQsKQJPX7u62nTs
         oUWx89WZh5FSn7ykT3ho8a+t5EWY3StJR4sXWJrWJfftbA/PPLgJZcpRXXmqGJdZo8G2
         AnSXZKb9sKdyoFYx0bYGGpbS4PrFx/8My/sKRClImPRErNtT4suKjaiFcFDnrZYLQtIK
         CDC7qycTgxfFNsWc7uTbIhfFd0NJRj/LnaqQlxTzKAS2Q3p1fxrKVbak+9zvYQz+79Qp
         Qtsw==
X-Forwarded-Encrypted: i=1; AJvYcCVMqfJ4kboWD7BN1X5/M0FmZlDR9hfCTSYbTt/OYL4a7vGHJC4DZxd8SeBPSxIat8YSxFs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywolo/KGMt52pkY/vGu1OhpAdjIlH5afYg9Bg8fEz8cvYbgD8EL
	9AWDEMAX4K10shwyCdGNf6AYr7RzCCg40VwGRYzAaupOfvV6LgGfu75sopXRl90=
X-Gm-Gg: ASbGncu6tAgCInaXoDlXObeZqsf86k30l/aiiGmPxd6bzdRLxARt7xyWqLftsH0BcEa
	92qxog/Xb0zNgpLZFSArVeKKMDmWzTyYl01tMTNCMf0A4D4PCtKw5AoINKhmBIVZXpse4r4vKoq
	APwg+CEFxyDjz/fI6IXO0f2y3/JYSmIoMFeSU0tdm1vtPh/HPalsQBx/tL4IOruSxCaQUtycTv5
	rnast1UL8j1nX287S/8d9NoCwOPnP7JPOpBKfafRMRgdTH/GlzCzM/Q1JNcrOOAQPuXJGjLZ6g4
	lNPba90Nj+alWtEschA77tLhJaJ/6NhYqRxBhbzqNnPSbxZIoFUt9u/fpg==
X-Google-Smtp-Source: AGHT+IFRvX91pdjWbDKnSP+k+ImsF7U6gTpnKvt8Vx6MdsWqPIPr62rb0Sr9WIH7YOso2WdWOgisgw==
X-Received: by 2002:a17:90b:48ce:b0:2ff:64c3:3bd9 with SMTP id 98e67ed59e1d1-2ff7ceee4bdmr6532714a91.23.1741387099805;
        Fri, 07 Mar 2025 14:38:19 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693e72basm3591779a91.39.2025.03.07.14.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 14:38:19 -0800 (PST)
Message-ID: <41e7da17-5f8b-4cae-8cab-36055f2b4794@linaro.org>
Date: Fri, 7 Mar 2025 14:38:18 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 richard.henderson@linaro.org, manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
 <fb8f0700-2676-4e7a-8857-ca10f5060b37@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <fb8f0700-2676-4e7a-8857-ca10f5060b37@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDE0OjA2LCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gT24g
Ny8zLzI1IDIyOjU2LCBQaWVycmljayBCb3V2aWVyIHdyb3RlOg0KPj4gV29yayB0b3dhcmRz
IGhhdmluZyBhIHNpbmdsZSBiaW5hcnksIGJ5IHJlbW92aW5nIGR1cGxpY2F0ZWQgb2JqZWN0
IGZpbGVzLg0KPj4NCj4+IGh3L2h5cGVydi9oeXBlcnYuYyB3YXMgZXhjbHVkZWQgYXQgdGhp
cyB0aW1lLCBiZWNhdXNlIGl0IGRlcGVuZHMgb24gdGFyZ2V0DQo+PiBkZXBlbmRlbnQgc3lt
Ym9sczoNCj4+IC0gZnJvbSBzeXN0ZW0va3ZtLmgNCj4+ICAgICAgIC0ga3ZtX2NoZWNrX2V4
dGVuc2lvbg0KPj4gICAgICAgLSBrdm1fdm1faW9jdGwNCj4gDQo+IEJ1ZywgdGhlc2Ugc2hv
dWxkIGJlIGRlY2xhcmVkIG91dHNpZGUgb2YgQ09NUElMSU5HX1BFUl9UQVJHRVQuDQo+DQoN
ClllcywgSSBub3RpY2VkIHlvdSBzb2x2ZWQgaXQgdGhpcyB3YXkgb24gb25lIG9mIHlvdXIg
c2VyaWVzLg0KSW4gdGhlIGVuZCwgc2luY2UgUUVNVSBkb2VzIG5vdCBoYXZlIGFueSBzcGVj
aWZpYyBib3VuZGFyaWVzIGJldHdlZW4gDQpzdWJzeXN0ZW1zIChpLmUuIG5vIHByb3BlciBs
aWJyYXJpZXMgd2l0aCBwcml2YXRlL3B1YmxpYyBzeW1ib2xzKSwgd2UgDQphcmUgbW9zdGx5
IGZyZWUgdG8gaW5jbHVkZSBhbnkgc3ltYm9sIHdlIHNlZSBpbiBhbiBoZWFkZXIgYXMgbG9u
ZyBhcyBpdCANCmRvZXMgbm90IHVzZSBhIHRhcmdldCBkZXBlbmRlbnQgdHlwZSB3aGljaCBj
aGFuZ2VzIHRoZSBzaWduYXR1cmUuDQoNCj4+IC0gZnJvbSBleGVjL2NwdS1hbGwuaCB8IG1l
bW9yeV9sZHN0X3BoeXMuaC5pbmMNCj4+ICAgICAgIC0gbGRxX3BoeXMNCj4gDQo+IFllYWgs
IG5vdCBhbiBlYXN5IG9uZS4NCj4gDQoNCg==

