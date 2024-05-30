Return-Path: <kvm+bounces-18457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6A268D5560
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 00:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A41DE285F40
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 22:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2679917DE23;
	Thu, 30 May 2024 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DVGyzyaB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D1224211
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 22:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717108196; cv=none; b=jrRxvBFKx83970GITOiW8XMfiWfgz3gVEzyDaKcyykSo8+rAs9QT/rTwF2YgVXyYcL0EnM/oSj8G7WwdfuonMBGQPWRMZwqCH3ik9U1wvDoDrRzeeAm+xglm+4N6kJQejOpR7+aTAs2uSyAVlALV0JaCAdcDYRfZ9fQ/FopS1iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717108196; c=relaxed/simple;
	bh=hkPBMHLeRBfVAiU/7B4tMOnwG8CBmmo53p2GWWLUMeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lXyd40WxB4BaNaoOjuX+qDkQZzmX7paWmkqqnGgOVe4Dnqh+cbFPGTCCES/qucalLWJTQTlAuCUXGNjqUI021sHOdnAQ3UnkB7amDqWHQYErqFSlPDdSS8gxuC8ulzVzdYlg2dKaAqcl7lVDEdXms5jIP51AVZLFtP+GO2y2r7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DVGyzyaB; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f62a628b4cso5723745ad.1
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717108194; x=1717712994; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hkPBMHLeRBfVAiU/7B4tMOnwG8CBmmo53p2GWWLUMeI=;
        b=DVGyzyaBWKfX/NwEZosiexIT7hRZLRFBSnae6wQOUP7IXYxVbvdH6E9aWuSNr/Qx7u
         SzNRcI5jtDraxXvIiOd/2YnF2fyxkZ4QTOoSXS8G2V+65ZAGgNTpWqaTeWpgPaERaJKX
         ww+JyiVaFOZBu5AjKl9Dqsg/N444EjQjPeA7xHUIxfM3O41kp+EHlmCHbwUqU2ztTcA8
         GlWMAzlkTYL6IG3xHD87UhalS3PE7K835c23qqbh4x+K9hO7CV86cJ+jmtn6Q2FM5brU
         B40wGKDVKZG1j3CdmkSRjJL/c1aV6Zmd1EbA62Mv749zFNFf7OD7MWGw3IkzG+QpyUhw
         WIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717108194; x=1717712994;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkPBMHLeRBfVAiU/7B4tMOnwG8CBmmo53p2GWWLUMeI=;
        b=bF8BS7cWfYQb4iu1BazTNzJ2h8ncOfEUenzEAz0egXLrW9ku2Rlmc6qgdDguwbcx1E
         6HsqgBf+QzoI615iufxzvXBPxO64WQToUBegTr6VE3y23lqBczZNG+GdeO95pfhSHJ8W
         8yipPOh7eW5gCrqvaxYJXziXnY+VSDQ4Y7213+0EGp+kviRHsf89AY3AsRCV3go4v0fV
         /T/n8mJRnwcEvI+YPyzvKtGygR32I/cDBr0QYGVjoUA3TjWwwIVVURGg/CqQOK6xNrYF
         p4sDU9UXPqJ8ztY6CgcagMzXAhl+anRdktHLstQ/eDtZpN3892K0l6IUe7XDOlXEE5A3
         sJ4A==
X-Forwarded-Encrypted: i=1; AJvYcCWGZC1QDA0DEB2DMnmdFdO13xdZShaUhaz0k/hbgdA29b3M5PCpvayMqVi54FdKuRKsy3PYOl6YnlAb0tk50T7vpszm
X-Gm-Message-State: AOJu0YwHYr91SN0a1NeX3nIT4QMDM+S6vSLkG+xVP/PbT0QrPBRM58ol
	CI54u0F1gMtfv78ONdVu9+sbgnznOZnFVkjN4Y0JxT3Oc1Bk2j4CscQ6qV6QFJw=
X-Google-Smtp-Source: AGHT+IEodTSwSq7zDnxZmvSRW6Gv4nMGV6OiOIIM6I4rmnUi0AT7QlRC3L09LX+PevZ0d7jLLNFlNw==
X-Received: by 2002:a17:902:db08:b0:1f3:1200:ceb3 with SMTP id d9443c01a7336-1f6370a0d07mr2192985ad.51.1717108194193;
        Thu, 30 May 2024 15:29:54 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::e697? ([2604:3d08:9384:1d00::e697])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323f6e98sm2734425ad.217.2024.05.30.15.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 15:29:53 -0700 (PDT)
Message-ID: <c86136b9-aaaa-4216-bf95-38908af9d3eb@linaro.org>
Date: Thu, 30 May 2024 15:29:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] cpu-target: don't set cpu->thread_id to bogus value
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Yanan Wang <wangyanan55@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Reinoud Zandijk
 <reinoud@netbsd.org>, kvm@vger.kernel.org,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-4-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240530194250.1801701-4-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNS8zMC8yNCAxMjo0MiwgQWxleCBCZW5uw6llIHdyb3RlOg0KPiBUaGUgdGhyZWFkX2lk
IGlzbid0IHZhbGlkIHVudGlsIHRoZSB0aHJlYWRzIGFyZSBjcmVhdGVkLiBUaGVyZSBpcyBu
bw0KPiBwb2ludCBzZXR0aW5nIGl0IGhlcmUuIFRoZSBvbmx5IHRoaW5nIHRoYXQgY2FyZXMg
YWJvdXQgdGhlIHRocmVhZF9pZA0KPiBpcyBxbXBfcXVlcnlfY3B1c19mYXN0Lg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPg0K
PiAtLS0NCj4gICBjcHUtdGFyZ2V0LmMgfCAxIC0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2NwdS10YXJnZXQuYyBiL2NwdS10YXJn
ZXQuYw0KPiBpbmRleCA1YWYxMjBlOGFhLi40OTlmYWNmNzc0IDEwMDY0NA0KPiAtLS0gYS9j
cHUtdGFyZ2V0LmMNCj4gKysrIGIvY3B1LXRhcmdldC5jDQo+IEBAIC0yNDEsNyArMjQxLDYg
QEAgdm9pZCBjcHVfZXhlY19pbml0Zm4oQ1BVU3RhdGUgKmNwdSkNCj4gICAgICAgY3B1LT5u
dW1fYXNlcyA9IDA7DQo+ICAgDQo+ICAgI2lmbmRlZiBDT05GSUdfVVNFUl9PTkxZDQo+IC0g
ICAgY3B1LT50aHJlYWRfaWQgPSBxZW11X2dldF90aHJlYWRfaWQoKTsNCj4gICAgICAgY3B1
LT5tZW1vcnkgPSBnZXRfc3lzdGVtX21lbW9yeSgpOw0KPiAgICAgICBvYmplY3RfcmVmKE9C
SkVDVChjcHUtPm1lbW9yeSkpOw0KPiAgICNlbmRpZg0KDQpSZXZpZXdlZC1ieTogUGllcnJp
Y2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0K

