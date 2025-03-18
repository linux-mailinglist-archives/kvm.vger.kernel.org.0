Return-Path: <kvm+bounces-41458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B1EA67FC5
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:26:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F1DC19C7CB2
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DEF0205E0F;
	Tue, 18 Mar 2025 22:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bSQwGaYq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A0F9DA
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336719; cv=none; b=ewN4De2lVRWMO7ACuhqmwBmYkcV9LyEDuat+Tw1QoZxeybAyS+APUBOMGL+IanFdS2qSNM9xxWv5E40E3VjUNqs8r+Y+3OxlaDa36oMg2AupoXcstVWJumfKqBaXK5Af4KoTBFIs5nExOC+9zJ6NrUgZW02cG112RSsgRW2HKLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336719; c=relaxed/simple;
	bh=+OZcSxEjvy5barsrM9YzuoeAs1gtQHABtK6IPFv4fFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4BctKam/xB+ZUXu2D8ZZDeP2qyicUYaqpL4f2UoDgJJjOaP66jrbSeYD7TtKhZOVIONlHzbhuPAE7GDQJ4G3UxxXX95Wn9xp76qV7UvtUuG3VXl5Fa9Wg4AK/h4Y/nldtvn3mnJBExne4MYrAoztpjJ0lUILXGYpqDxNXCFmSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bSQwGaYq; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ff6ae7667dso7698641a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742336717; x=1742941517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+OZcSxEjvy5barsrM9YzuoeAs1gtQHABtK6IPFv4fFE=;
        b=bSQwGaYqHRv1DEox5LsAHYIQnAoqEjxqSdsIyWDhNjRV29/pi9czKM1C2MQ5ZTXTZ8
         q79T/XEfZjtUEdfSCD7ynFYDlY3MLBTE7VGJeVORl3APj3bYYH/AEIzBvz+YKTRrVRTW
         W3ISyImE42eHthcm7qDLUAQnwe/B+VROa5IZeP0ZA07ST3IYIu0GInU3wpyTL1GJfOwl
         KhbujIPCBHXxarCDbd4trwLdXS+IS029bpB555EjxMAI4FiC/tchwN6Z6pKqxVlI6HNb
         e8JS6xIZBsycfLnNo5AMPFyzrqm279Jk1RTwCFlSdcYN63FdMA1HLGkQLGkrJS5XgKha
         gHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742336717; x=1742941517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+OZcSxEjvy5barsrM9YzuoeAs1gtQHABtK6IPFv4fFE=;
        b=nz8z92F81N8WvD/LLnr4NxJoeOpiPZ2QXR8aa+f8jTmvwlAvISuY7rkktgRVOTllrN
         d1fvaurw3OMHO4DR2kHQPoQqNeQKxuBUZrCuFBw4ZzzGICW+fuj00CYxQ4myr2r53PBm
         upc0Odq+U0xLI+xbZqp3JpxjcBe/Cu1b0k480xbtdtvCdesLgsqAJMJLvUU+ubQeRjTx
         E5b8Zut/o2Td4DV1cDqxpLe+eER3JyhnmUvXlBRAFqzkV6EZkVmL4susSK8gMGiAxGA2
         LH3GsgwKlCn3oqAHcB9Zm6hU5d6t9JVh/aCc+kvLp6gyb62V1GofF5s7sdRTQwIQ34bj
         BnHA==
X-Forwarded-Encrypted: i=1; AJvYcCVjykX+yhqFlYEgiRmaeljDBy1pJlNXqbou2P/g2ywaJBnc0iMcZvogzmqcLNJbMqGQepE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK+3E/mqGo6r86lW4W+EzPcFOU/e0HIBaS4Z9TzxncDEGeKnGN
	jb+paPu1e3ZxrH6ThM5v7oBxnUuKMB0VyjNiEx4c15Lz2RvE4kcUf1W9UBkRaQ8=
X-Gm-Gg: ASbGncvSRqYI8fnCT2bzd8u5mkdq3mGNLOJJLAy3kheiYk7p1fDp13iE77EuYkAA/IL
	dweThETSZhfjclzVPV719/XFyY3uGQH2ySYACoGih1zzyoCXx9tcQ3ipKU9pA8Rn4RP0jfyK6FZ
	bXG+KQltaoaW3mWbv508JZMy27Xuxs0MnDcF8vOXozr/LpRH6DyY9C+DKyZyLpNcO5+uoPBWYNw
	qmeFdDII3pdAhQO7jkuimBSmUxp7u7lo1y+YJJRO8TeVZuXB6PIduNAv+DpSN6VFCflemRX3wFi
	5F/SjdLOwsCYW/CTCEb2cWwpVKd1COauMF3wwYkKN1mPxrk6sgn4vZrtQg==
X-Google-Smtp-Source: AGHT+IGmH0IikLDiUP1B2sJeJzQbJRgDAITprzk8AgiG9cM4xJ5TN/4hReGgOfBC1vsSdDXqD1UKow==
X-Received: by 2002:a17:90b:3ccc:b0:2ee:edae:75e with SMTP id 98e67ed59e1d1-301bde62101mr577697a91.13.1742336717408;
        Tue, 18 Mar 2025 15:25:17 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf5cddd6sm21699a91.41.2025.03.18.15.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:25:17 -0700 (PDT)
Message-ID: <172a10d0-f479-4d6c-9555-a9060bdf744e@linaro.org>
Date: Tue, 18 Mar 2025 15:25:16 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] exec/cpu-all: allow to include specific cpu
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-5-pierrick.bouvier@linaro.org>
 <35c90e78-2c2c-4bbb-9996-4031c9eef08a@linaro.org>
 <7202c9e9-1002-4cdc-9ce4-64785aac5de4@linaro.org>
 <0c6f23d5-d220-4fa7-957e-8721f1aa732f@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <0c6f23d5-d220-4fa7-957e-8721f1aa732f@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xOC8yNSAxNToyMSwgUmljaGFyZCBIZW5kZXJzb24gd3JvdGU6DQo+IE9uIDMvMTgv
MjUgMTU6MTYsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+Pj4gVGhpcyBkb2Vzbid0IG1h
a2UgYW55IHNlbnNlIHRvIG1lLsKgIENQVV9JTkNMVURFIGlzIGRlZmluZWQgd2l0aGluIHRo
ZSB2ZXJ5IGZpbGUgdGhhdA0KPj4+IHlvdSdyZSB0cnlpbmcgdG8gaW5jbHVkZSBieSBhdm9p
ZGluZyAiY3B1LmgiLg0KPj4+DQo+Pg0KPj4gRXZlcnkgdGFyZ2V0L1gvY3B1LmggaW5jbHVk
ZXMgY3B1LWFsbC5oLCB3aGljaCBpbmNsdWRlcyAiY3B1LmgiIGl0c2VsZiwgcmVseWluZyBv
biBwZXINCj4+IHRhcmdldCBpbmNsdWRlIHBhdGggc2V0IGJ5IGJ1aWxkIHN5c3RlbS4NCj4g
DQo+IFNvLCBhbm90aGVyIHNvbHV0aW9uIHdvdWxkIGJlIHRvIGZpeCB0aGUgc2lsbHkgaW5j
bHVkZSBsb29wPw0KPg0KDQpJZiB5b3UncmUgb2sgd2l0aCBpdCwgSSdtIHdpbGxpbmcgdG8g
cmVtb3ZlIGNwdS1hbGwuaCBjb21wbGV0ZWx5IChtb3ZpbmcgDQp0bGIgZmxhZ3MgYml0cyBp
biBhIG5ldyBoZWFkZXIpLCBhbmQgZml4aW5nIG1pc3NpbmcgaW5jbHVkZXMgZXZlcnl3aGVy
ZS4NCg0KSSBqdXN0IHdhbnRlZCB0byBtYWtlIHN1cmUgaXQncyBhbiBhY2NlcHRhYmxlIHBh
dGggYmVmb3JlIHNwZW5kaW5nIHRvbyANCm11Y2ggdGltZSBvbiBpdC4NCg0KPiANCj4gcn4N
Cg0K

