Return-Path: <kvm+bounces-40537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1651EA58A3D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 03:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D62057A2664
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 02:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD7317A2E8;
	Mon, 10 Mar 2025 02:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GPNorJ+o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C197717A2F0
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 02:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741572639; cv=none; b=n7wAiDJ/6IQFsPQgOLAgqVjbF7UOXtGXnKvGQxCpSnCf5WGny0CVMj2PSQSG4fxJY09/mO33HbfvipVCn7aBXTFBN892TQiWLUdOlw8g+ajyokIUWmNHUnFGGT7t0zNMMMBh9zt62iVI2PIjaCHlmBA4qq7tiySTdGyEzuovGlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741572639; c=relaxed/simple;
	bh=Wf1m1/zuuUt9Sa/sWao+aE4RHawG8odqXAwi31KcpoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sTOHlQDuTjNCGtZ2ariy2B151bMjBVmAO8Sg3GnaLaoRf1u71rzVJL07hapVbJZ3Hgyr8tvQKaE5sBdBpmODnUye718Sg3q8iUkdqaGeDh03r/ofmtjHRGRV9biAeC2k5sHKhHlQvYRgjyb3wJHY1OrOhQEQf2H/8laqbmTk17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GPNorJ+o; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224341bbc1dso33730805ad.3
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 19:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741572637; x=1742177437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wf1m1/zuuUt9Sa/sWao+aE4RHawG8odqXAwi31KcpoI=;
        b=GPNorJ+oho+OSyJtHKFmjOKmBUy7CqVtHlb91v7IOJYM6OW/r1djo0Vs/lGqjzKV4f
         TbfAkXhPRrfA0i85iBWgykrFsIxwdy7YvPy0GLvmFx1eHrzmzpT2bQFazkJTRRF8zM5T
         0isHcXhrr4+g+Qn69YIzNuOTEKT00fE7IxDj1m/4yNtAm1HfY8jm0j0DGS+fRxzIr8pp
         QqEZtcf+qYlbOOQJwO/XcFL+V/OMIPOKraPQajyzbXqMX3+rLk0K1lbvKVy80eXmGAon
         kq44W7Noz3DZ48OS0sLe4R6m8sNmZPmV2bwBftOg1SRuAugWD1RW50fYITb/7YOQguWI
         t5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741572637; x=1742177437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wf1m1/zuuUt9Sa/sWao+aE4RHawG8odqXAwi31KcpoI=;
        b=d9g08dFDcqnd+Uj3wCzxeUMGOuI7Xp9xYnHq69moBpcnZqwqdQz9/kilyWcfm9E02e
         ODPiAGHtvGAoJFxoN9mFXESZKiMSubrjIoGAKP2g8kKSFelywt1CQ3bBb1parzyGp/H/
         czPEU6d9Lp2VKxzWS0EWDDXvXFIquScMBak4ol8V49VKIWl05eRF4MtwPFxRaM0xGMsO
         4q16lJn9xmORXzMpCEUikO+wNwrRNHuh3PfdrtUT0zP8HpGaUXhQs8ue7BHeYbta/Gw6
         JD4/0dWjb3pnQMouEQJ2xsDiSrtDDkJJw2iWNSYnInK+2/iOfwUN+3xx+5VaSYdp9eIv
         aTvw==
X-Forwarded-Encrypted: i=1; AJvYcCVcVdf+pt0Pk4l3UL0lNvpf0swWvgmBZLsj28zNciM/xAnIzNVpGlJoVp1usbGsi+zJgM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKAtL7739pwdJ899aMz8sXmr4e6FdHuOBW+LmNhSKjd2mQ4aKl
	hnvfD83A+AxHe6M/IpZrljas8kR1C8KIq/drL4d8FUU+o5ZTbEZNGO5fBMq/T2Q=
X-Gm-Gg: ASbGncsgISRbc6+CFglAOEF49weJSFlsGx6BCNsd7YITc7eRGoI0t2aKiwb7sLqG4wm
	veCcTLms8fjA1UtVbaa36GZr4yfqI/wJ01KBvFIgcuGsxpnjpz397pOx55UrkSrSnhz+bpZNCc0
	zkeIRT9vFC3vjMUbVXpvrwYW4wZFmMQcgiHbZWJMxluSoOdV8bHF3jRe6DsCkTG005T0Jj0Zdaz
	jN5aOSwjsGqEGzVBpgvr8M5lcielvZOvGDEtYYGxDnb04cHX5U62SyR/37oUZcdd6e+XpiKSDEQ
	TtJ1UgDcs6Rugmswh2CwLp2WdCYp5qIezWz4tbLvOFTc8V8jPLO9Z57Lgw==
X-Google-Smtp-Source: AGHT+IG5824u/Paw5A4ROCYDa6rpBTdV46omB9ADq9EuByBKeioJgUejdzkOM2/mOEgR3EARM7VYmA==
X-Received: by 2002:a05:6a00:1956:b0:736:4c93:1bdf with SMTP id d2e1a72fcca58-736aaac7777mr18584825b3a.18.1741572636966;
        Sun, 09 Mar 2025 19:10:36 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d8f0ea83sm915535b3a.143.2025.03.09.19.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Mar 2025 19:10:36 -0700 (PDT)
Message-ID: <5bbbc0ce-5a83-4574-bca6-a2c9ea87a4e2@linaro.org>
Date: Sun, 9 Mar 2025 19:10:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, qemu-devel@nongnu.org,
 Marcelo Tosatti <mtosatti@redhat.com>, richard.henderson@linaro.org,
 manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
 <8c511d16-05d6-4852-86fc-a3be993557c7@linaro.org>
 <8d2a19a8-e0a4-4050-8ba5-9baa9b47782f@maciej.szmigiero.name>
 <91ddf98c-3a5d-404b-9e80-ed4580c1c373@linaro.org>
 <440fe370-a0d3-4a32-97e2-e5f219f79933@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <440fe370-a0d3-4a32-97e2-e5f219f79933@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy85LzI1IDE3OjE0LCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gT24g
MTAvMy8yNSAwMDozMywgUGllcnJpY2sgQm91dmllciB3cm90ZToNCj4+IEhpIE1hY2llaiwN
Cj4+DQo+PiBPbiAzLzcvMjUgMTQ6MzEsIE1hY2llaiBTLiBTem1pZ2llcm8gd3JvdGU6DQo+
Pj4gSGkgUGhpbGlwcGUsDQo+Pj4NCj4+PiBPbiA3LjAzLjIwMjUgMjM6MjUsIFBoaWxpcHBl
IE1hdGhpZXUtRGF1ZMOpIHdyb3RlOg0KPj4+PiBIaSBNYWNpZWosDQo+Pj4+DQo+Pj4+IE9u
IDcvMy8yNSAyMjo1NiwgUGllcnJpY2sgQm91dmllciB3cm90ZToNCj4+Pj4+IFdvcmsgdG93
YXJkcyBoYXZpbmcgYSBzaW5nbGUgYmluYXJ5LCBieSByZW1vdmluZyBkdXBsaWNhdGVkIG9i
amVjdA0KPj4+Pj4gZmlsZXMuDQo+Pj4+DQo+Pj4+PiBQaWVycmljayBCb3V2aWVyICg3KToN
Cj4+Pj4+ICDCoMKgwqAgaHcvaHlwZXJ2L2h2LWJhbGxvb24tc3R1YjogY29tbW9uIGNvbXBp
bGF0aW9uIHVuaXQNCj4+Pj4+ICDCoMKgwqAgaHcvaHlwZXJ2L2h5cGVydi5oOiBoZWFkZXIg
Y2xlYW51cA0KPj4+Pj4gIMKgwqDCoCBody9oeXBlcnYvdm1idXM6IGNvbW1vbiBjb21waWxh
dGlvbiB1bml0DQo+Pj4+PiAgwqDCoMKgIGh3L2h5cGVydi9oeXBlcnYtcHJvdG86IG1vdmUg
U1lOREJHIGRlZmluaXRpb24gZnJvbSB0YXJnZXQvaTM4Ng0KPj4+Pj4gIMKgwqDCoCBody9o
eXBlcnYvc3luZGJnOiBjb21tb24gY29tcGlsYXRpb24gdW5pdA0KPj4+Pj4gIMKgwqDCoCBo
dy9oeXBlcnYvYmFsbG9vbjogY29tbW9uIGJhbGxvb24gY29tcGlsYXRpb24gdW5pdHMNCj4+
Pj4+ICDCoMKgwqAgaHcvaHlwZXJ2L2h5cGVydl90ZXN0ZGV2OiBjb21tb24gY29tcGlsYXRp
b24gdW5pdA0KPj4+Pg0KPj4+PiBJZiB5b3UgYXJlIGhhcHB5IHdpdGggdGhpcyBzZXJpZXMg
YW5kIHByb3ZpZGUgeW91ciBBY2stYnkgdGFnLA0KPj4+PiBJIGNhbiB0YWtlIGl0IGluIG15
IG5leHQgaHctbWlzYyBwdWxsIHJlcXVlc3QgaWYgdGhhdCBoZWxwcy4NCj4+Pg0KPj4+IFRo
ZXJlJ3Mgbm90aGluZyBvYnZpb3VzbHkgd3JvbmcgaW4gdGhlIHBhdGNoIHNldCwNCj4+PiBi
dXQgaWYgd2UgY2FuIGRlZmVyIHRoaXMgdG8gTW9uZGF5IHRoZW4gSSBjb3VsZCBkbw0KPj4+
IGEgcnVudGltZSBjaGVjayB3aXRoIGEgV2luZG93cyBWTSB0b28uDQo+Pj4NCj4+DQo+PiB0
aGlzIHNlcmllcyBuZWVkcyBzb21lIGZpeHVwIGFmdGVyIHRoZSBtZXJnZSBvZiA1OGQwMDUz
OiBpbmNsdWRlL2V4ZWM6DQo+PiBNb3ZlIFRBUkdFVF9QQUdFX3tTSVpFLE1BU0ssQklUU30g
dG8gdGFyZ2V0X3BhZ2UuaC4NCj4+DQo+PiBJJ2xsIHJlLXNwaW4gaXQgbGF0ZXIsIHNvIGRv
bid0IHdhc3RlIHlvdXIgdGltZSB0cnlpbmcgaXQuDQo+IA0KPiAxLCAyICYgNCBhcmUgbm90
IGFmZmVjdGVkLiBVbnRpbCBzb21lb25lIG9iamVjdCwgSSBwbGFuIHRvIGluY2x1ZGUgdGhl
bQ0KPiBpbiBteSBuZXh0IGh3LW1pc2MgcHVsbCByZXF1ZXN0IG9uIFR1ZXNkYXkuDQoNClRo
YW5rcyBQaGlsbGlwZS4NCg==

