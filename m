Return-Path: <kvm+bounces-40532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37162A5894D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 00:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D19FC7A40D6
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 23:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0982E221541;
	Sun,  9 Mar 2025 23:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uzMsOnzM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACA117A31A
	for <kvm@vger.kernel.org>; Sun,  9 Mar 2025 23:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741563191; cv=none; b=a/jfJ1zpMPhdQqCsQWgt5/KSX13xd+zzI2OHi0EwS8QE/IUr3B+jWEMOqOTbmbtGUyoK4D0WgYEBurE7jxBBdY3R5qrqhSoCnSD2zPL/dTB5H844Ws1DW5hkHlAW5gDWH1Vt0O0fFg/r98adC5VK4h6PzCUI/1Gc/iUQCBkAvhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741563191; c=relaxed/simple;
	bh=4b/UkAzN7ZHYgiU4BKJLTd8rxlg4iR/5B9OEm16oOJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DvBCmWZkgZvCz7Qi3cjqRV/gLJXJ7YMn4G13CWzEzwN1pkoreM9M53nUzlHJbMsTzX3FVzbyH9PuInEJGyaBStl6nWgiFwfue5ERCldwxa/a+HY8Pov1YeRkIssHf/AtknC2GN/fiI7oSxMvVpw4qZ+D2sg+BWqKZpWXtgQOx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uzMsOnzM; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223fd89d036so68747135ad.1
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 16:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741563188; x=1742167988; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4b/UkAzN7ZHYgiU4BKJLTd8rxlg4iR/5B9OEm16oOJU=;
        b=uzMsOnzM1Hiyx7kxDK2PelTbniGHXda3pELfsVGCH4ZB0P//HfkzPA/tLPgLJ1+5sk
         KY9gzObWOy+8uGR+IoFc5rYq0QKjWZ0WvqUkeDVNTOOeTFS6dcnqohjjHMrgt4LyOnGc
         Vy1ADXkQPxWW+QVOP0mpUDKBFxGCQmAo04Sn+tfbs0IBLOcPVCh5f42RZYnH8NG56AX9
         FtcsEC5bzL9LMNLD/GI+eYQnxsreIwfjIDvpobG2opwULpLUgrFARnbJ5UeVTAYRURUD
         c6rqFdSIOocY6sKpdYYkz0srFLuLzAgK2C27bsWdqoYhbc9apwnbWVa2fBTikYxAp+DA
         NPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741563188; x=1742167988;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4b/UkAzN7ZHYgiU4BKJLTd8rxlg4iR/5B9OEm16oOJU=;
        b=HKNqEV926HqnbQKc19bWR9Zpe3jp2EAQcq4QGoN+IqGMy7js5o6ql0usgJ7+Lt7Rah
         9yP0dkS1rA//Jd/Wshlprkg6HEDLAI/gReKSbssl8BFcB+s1zeAFdLs1rTj5JkiDtB7N
         wXbg3Lvaao6NzvjQNBa58OItCNQJteUY2TFM5gkVA07+xdC7dR0+9faelieK+TnjmMB/
         t0+A9YzMxaYSDhHde9xSSnm1VLU5GZGgVSxtjOJu7roCDHAGCiBbaoo52lBVvzEY/xKL
         dwbLx+rb3j3E1zOBo6H/g+kfoWx8yaEOGuLmTDUTc3/GmkaAm7XJTcjvqLUDZ5+T2oXq
         sXbw==
X-Forwarded-Encrypted: i=1; AJvYcCVyzHQDg+deA/+iw1W2X2x/gNbsC8Up8mjUiOJnxc/zx96VBNC/kaJHvzeDdxE9dua3wYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXyBn6g1mj5u+E4XJkXNG1JeXkvsd+d03gVLu6B1eveHJiFlzl
	hWtwXT35TpyC0Z0HbpnZCmIqMBpC11fNM7D9QUf3hmCqbIPXvG5rys7cBLjrXJI=
X-Gm-Gg: ASbGnctYNRxSFLLa1G87an/0Z87mLm01ZcxbQtwCx9DKvX094pw/WMGHL4mt1AqWKw4
	TBUfe5oSwzcHxdI4QQFirsBd2Bs6+NZmYhVFF6C0Sb9ycx6SVbccQW5Xh54+E7rDMlvaCJIKpzx
	n5Dv3qmzrSawEYlHcYpBUgiu5s3XEvN2aH0yfXcIKkbr96IjsRRbPljT7pt6clvrdcd6foAeadb
	uKPcWGeZSfijrY2IQY2rwGw6zURtIRKHqazkgb9VKUdBDa5cfhbWsvtN8tZs0agFiCunYtuCUXT
	a50CPYocAUOAz4a2fk/WWgHfWbefzd4ozHML606zNUgS+ZY1co71auu0Wg==
X-Google-Smtp-Source: AGHT+IEJJimItTTmgzjc12itv0ixC5PTKLwwNaQJYzRT3y52Qe5O6A4YR8D59kmlSgj77EP8O5qChQ==
X-Received: by 2002:a05:6a20:43a7:b0:1f5:7ba7:69d8 with SMTP id adf61e73a8af0-1f57ba76d96mr2705823637.15.1741563188021;
        Sun, 09 Mar 2025 16:33:08 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28126e2c1sm5379232a12.52.2025.03.09.16.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Mar 2025 16:33:07 -0700 (PDT)
Message-ID: <91ddf98c-3a5d-404b-9e80-ed4580c1c373@linaro.org>
Date: Sun, 9 Mar 2025 16:33:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
Content-Language: en-US
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, qemu-devel@nongnu.org,
 Marcelo Tosatti <mtosatti@redhat.com>, richard.henderson@linaro.org,
 manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
 <8c511d16-05d6-4852-86fc-a3be993557c7@linaro.org>
 <8d2a19a8-e0a4-4050-8ba5-9baa9b47782f@maciej.szmigiero.name>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <8d2a19a8-e0a4-4050-8ba5-9baa9b47782f@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgTWFjaWVqLA0KDQpPbiAzLzcvMjUgMTQ6MzEsIE1hY2llaiBTLiBTem1pZ2llcm8gd3Jv
dGU6DQo+IEhpIFBoaWxpcHBlLA0KPiANCj4gT24gNy4wMy4yMDI1IDIzOjI1LCBQaGlsaXBw
ZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4+IEhpIE1hY2llaiwNCj4+DQo+PiBPbiA3LzMv
MjUgMjI6NTYsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+Pj4gV29yayB0b3dhcmRzIGhh
dmluZyBhIHNpbmdsZSBiaW5hcnksIGJ5IHJlbW92aW5nIGR1cGxpY2F0ZWQgb2JqZWN0IGZp
bGVzLg0KPj4NCj4+PiBQaWVycmljayBCb3V2aWVyICg3KToNCj4+PiAgwqDCoCBody9oeXBl
cnYvaHYtYmFsbG9vbi1zdHViOiBjb21tb24gY29tcGlsYXRpb24gdW5pdA0KPj4+ICDCoMKg
IGh3L2h5cGVydi9oeXBlcnYuaDogaGVhZGVyIGNsZWFudXANCj4+PiAgwqDCoCBody9oeXBl
cnYvdm1idXM6IGNvbW1vbiBjb21waWxhdGlvbiB1bml0DQo+Pj4gIMKgwqAgaHcvaHlwZXJ2
L2h5cGVydi1wcm90bzogbW92ZSBTWU5EQkcgZGVmaW5pdGlvbiBmcm9tIHRhcmdldC9pMzg2
DQo+Pj4gIMKgwqAgaHcvaHlwZXJ2L3N5bmRiZzogY29tbW9uIGNvbXBpbGF0aW9uIHVuaXQN
Cj4+PiAgwqDCoCBody9oeXBlcnYvYmFsbG9vbjogY29tbW9uIGJhbGxvb24gY29tcGlsYXRp
b24gdW5pdHMNCj4+PiAgwqDCoCBody9oeXBlcnYvaHlwZXJ2X3Rlc3RkZXY6IGNvbW1vbiBj
b21waWxhdGlvbiB1bml0DQo+Pg0KPj4gSWYgeW91IGFyZSBoYXBweSB3aXRoIHRoaXMgc2Vy
aWVzIGFuZCBwcm92aWRlIHlvdXIgQWNrLWJ5IHRhZywNCj4+IEkgY2FuIHRha2UgaXQgaW4g
bXkgbmV4dCBody1taXNjIHB1bGwgcmVxdWVzdCBpZiB0aGF0IGhlbHBzLg0KPiANCj4gVGhl
cmUncyBub3RoaW5nIG9idmlvdXNseSB3cm9uZyBpbiB0aGUgcGF0Y2ggc2V0LA0KPiBidXQg
aWYgd2UgY2FuIGRlZmVyIHRoaXMgdG8gTW9uZGF5IHRoZW4gSSBjb3VsZCBkbw0KPiBhIHJ1
bnRpbWUgY2hlY2sgd2l0aCBhIFdpbmRvd3MgVk0gdG9vLg0KPiANCg0KdGhpcyBzZXJpZXMg
bmVlZHMgc29tZSBmaXh1cCBhZnRlciB0aGUgbWVyZ2Ugb2YgNThkMDA1MzogaW5jbHVkZS9l
eGVjOiANCk1vdmUgVEFSR0VUX1BBR0Vfe1NJWkUsTUFTSyxCSVRTfSB0byB0YXJnZXRfcGFn
ZS5oLg0KDQpJJ2xsIHJlLXNwaW4gaXQgbGF0ZXIsIHNvIGRvbid0IHdhc3RlIHlvdXIgdGlt
ZSB0cnlpbmcgaXQuDQoNClRoYW5rcywNClBpZXJyaWNrDQoNCj4+IFJlZ2FyZHMsDQo+Pg0K
Pj4gUGhpbC4NCj4gDQo+IFRoYW5rcywNCj4gTWFjaWVqDQo+IA0KDQo=

