Return-Path: <kvm+bounces-40400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B786A57166
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C52BC16B8CF
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A27253330;
	Fri,  7 Mar 2025 19:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nf2GU4xP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA08D250BFB
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374926; cv=none; b=dk+Xi8c/IKcQ1F8edpabXXJ7TnTlAoHZBiQJ7ImRZ1VW+sS7Ddrl/u5ZVKN7k7OdW7Froz9YulrvZReJwD0tqd/LNhOT5oqFetJp5nSLEcPosBOGq4Cei8sGcbnGkIC7FxcAGlMDqCv+rDBHEdDSPcqfhNaUc2FtaHDzZv8ipIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374926; c=relaxed/simple;
	bh=uwYc9p1kXttTG6382TJaxB99a5wuQBiYD3sq+AX1GGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MH3ifXoLG/Xs6GUSC8Ni+ORpdMwuL44NrqnsUsGGt9TwA5weZwUxdyymTM/6HzTWqq6cPvLzf6W8ffJci57klgjF9MVM23+tapq0CUWMkXBvuyj76xcV+uhum8xE+OuEAbGy4K9vTmrme7CDNLvcrM2aLg0ZgfjBguMjzu/RW3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Nf2GU4xP; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2239f8646f6so43554475ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374924; x=1741979724; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uwYc9p1kXttTG6382TJaxB99a5wuQBiYD3sq+AX1GGM=;
        b=Nf2GU4xPkppHyzPmTXZhiqBvFCDva+DobCbMjSkd+XbnIgWjB5JpzQXbbJQJH/l6kB
         RJcQrWOvgNh66wt0f9dHyK37cp0H6b6cyg+5SrExnJ58R8Zs4X9v4oDqL/J2P1R1gO0s
         IrdewwZL/g71RRgUgs4rES7Ly3O9vuqGUK725nvf1KYfCQUIYjtF4QwfYuLFpJhShdwF
         WwJTWZpSVd1HH/1wiRIHgeW+VZiVxQW06FnHXHjLfksB+AC7iKmOUNvQmYStHM2xVYXg
         u8/im5kHFR8/WGXhx7ZLu5WxNlCbC+bFRUPwijzF5pa5RyIKhcpauaT5CGNjP0uwzk93
         yE3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374924; x=1741979724;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uwYc9p1kXttTG6382TJaxB99a5wuQBiYD3sq+AX1GGM=;
        b=eEOx8xwBB1/5kHkjLbkVoShy5tZ79ga5IxwFoEiAT+NWkvkRI8HIu0ZNwQvCmrWxyI
         bU9BTmmnPvaY8Dumk2oXkyNW0rG057rpwDNmaAc6QuJ1QhIMSn95IJQRshmEXr8WrKm/
         JD22R+aiCaqqb+8wPJm/fCTVcLLWNGpzv77r4/2PFMxACmeYLi1fXvpfK8i2dT6az8gH
         m35c59LhTRLGin+3SXeGiiNY0gHmO/n3YzK2DHpMA6SJT3inALVAPFG/jNEqeXFlCBaE
         rPT/rSbNOOVyZ8wjtW8jrrci0nHy1grFJJiLMChOJlHkn09bJd/WWwDsCpjnWJw0k397
         RDGA==
X-Forwarded-Encrypted: i=1; AJvYcCX8gKZnTJOIFn42d+yBHrh17ufSdWNhqdtcV343nKo0UEWBBvPwPm74ZG0WDhbBj09kuV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPovCyw/X+0aW20JZwimF34lAi6LfGjS5Gpds2DLWWGnhmF1LO
	Muzrtojh9FrJTHEvm+GFL6GncTQ1kjEiSOhL7kjWWlNEZm9Y0qj5axTwi7Wudgg=
X-Gm-Gg: ASbGnctDlJreI9+TEjS8HAaVxcOIEGrY6IG4GourqrmDfvJjOfFsvoz3kQ6Gwba8Drm
	Vi/GyvM5MPaiksvc33U3yrZA3ofcBLtd9pqnFKOwbHdokXMfKggIG0gDlYrmKGy39BUoa7ZLIxx
	tLbZ84RW6jy9s+yYURa/mejYN++YTo1Q+rMXD9FmiSQVGdljyHi6QMFZWgsUT6amEOS1jUbBo8o
	pbkV/X5YVFVpRC3CTDsOo0rtjVEZOgX41xAuWVn1RMzwKTVXz79ilYXfz8kuGzLeMbSvdo0ih5m
	5G8xLuvbBXhG8cKLFzy3fmHogCZ/LR6jxYHwHD3fKqtxA+UTafM4J+9tsA==
X-Google-Smtp-Source: AGHT+IGo9prg4b/2FXdagrrmhBEJEH0dcZUgAuL/WOiVD4MA96tJGEQan07XoYtTGmcH/icqlRVVlA==
X-Received: by 2002:a05:6a00:21ce:b0:736:53c5:33ba with SMTP id d2e1a72fcca58-736aaabeccemr5719882b3a.16.1741374923813;
        Fri, 07 Mar 2025 11:15:23 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73698243fd6sm3754249b3a.66.2025.03.07.11.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:15:23 -0800 (PST)
Message-ID: <ec744091-da4e-496d-bbb3-90d35fd66161@linaro.org>
Date: Fri, 7 Mar 2025 11:15:22 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] hw/vfio: Compile some common objects once
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, qemu-ppc@nongnu.org,
 Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Daniel Henrique Barboza
 <danielhb413@gmail.com>, Eric Auger <eric.auger@redhat.com>,
 qemu-s390x@nongnu.org, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 David Hildenbrand <david@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20250307180337.14811-1-philmd@linaro.org>
 <20250307180337.14811-4-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gU29t
ZSBmaWxlcyBkb24ndCByZWx5IG9uIGFueSB0YXJnZXQtc3BlY2lmaWMga25vd2xlZGdlDQo+
IGFuZCBjYW4gYmUgY29tcGlsZWQgb25jZToNCj4gDQo+ICAgLSBoZWxwZXJzLmMNCj4gICAt
IGNvbnRhaW5lci1iYXNlLmMNCj4gICAtIG1pZ3JhdGlvbi5jIChyZW1vdmluZyB1bm5lY2Vz
c2FyeSAiZXhlYy9yYW1fYWRkci5oIikNCj4gICAtIG1pZ3JhdGlvbi1tdWx0aWZkLmMNCj4g
ICAtIGNwci5jDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTD
qSA8cGhpbG1kQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIGh3L3ZmaW8vbWlncmF0aW9uLmMg
fCAgMSAtDQo+ICAgaHcvdmZpby9tZXNvbi5idWlsZCB8IDEzICsrKysrKysrLS0tLS0NCj4g
ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9ody92ZmlvL21pZ3JhdGlvbi5jIGIvaHcvdmZpby9taWdyYXRp
b24uYw0KPiBpbmRleCA0MTY2NDNkZGQ2OS4uZmJmZjQ2Y2ZjMzUgMTAwNjQ0DQo+IC0tLSBh
L2h3L3ZmaW8vbWlncmF0aW9uLmMNCj4gKysrIGIvaHcvdmZpby9taWdyYXRpb24uYw0KPiBA
QCAtMjcsNyArMjcsNiBAQA0KPiAgICNpbmNsdWRlICJxYXBpL2Vycm9yLmgiDQo+ICAgI2lu
Y2x1ZGUgInFhcGkvcWFwaS1ldmVudHMtdmZpby5oIg0KPiAgICNpbmNsdWRlICJleGVjL3Jh
bWxpc3QuaCINCj4gLSNpbmNsdWRlICJleGVjL3JhbV9hZGRyLmgiDQo+ICAgI2luY2x1ZGUg
InBjaS5oIg0KPiAgICNpbmNsdWRlICJ0cmFjZS5oIg0KPiAgICNpbmNsdWRlICJody9ody5o
Ig0KPiBkaWZmIC0tZ2l0IGEvaHcvdmZpby9tZXNvbi5idWlsZCBiL2h3L3ZmaW8vbWVzb24u
YnVpbGQNCj4gaW5kZXggMjYwZDY1ZmViZDYuLjhlMzc2Y2ZjYmY4IDEwMDY0NA0KPiAtLS0g
YS9ody92ZmlvL21lc29uLmJ1aWxkDQo+ICsrKyBiL2h3L3ZmaW8vbWVzb24uYnVpbGQNCj4g
QEAgLTEsMTIgKzEsNyBAQA0KPiAgIHZmaW9fc3MgPSBzcy5zb3VyY2Vfc2V0KCkNCj4gICB2
ZmlvX3NzLmFkZChmaWxlcygNCj4gLSAgJ2hlbHBlcnMuYycsDQo+ICAgICAnY29tbW9uLmMn
LA0KPiAtICAnY29udGFpbmVyLWJhc2UuYycsDQo+ICAgICAnY29udGFpbmVyLmMnLA0KPiAt
ICAnbWlncmF0aW9uLmMnLA0KPiAtICAnbWlncmF0aW9uLW11bHRpZmQuYycsDQo+IC0gICdj
cHIuYycsDQo+ICAgKSkNCj4gICB2ZmlvX3NzLmFkZCh3aGVuOiAnQ09ORklHX1BTRVJJRVMn
LCBpZl90cnVlOiBmaWxlcygnc3BhcHIuYycpKQ0KPiAgIHZmaW9fc3MuYWRkKHdoZW46ICdD
T05GSUdfSU9NTVVGRCcsIGlmX3RydWU6IGZpbGVzKA0KPiBAQCAtMjUsMyArMjAsMTEgQEAg
dmZpb19zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPX0FQJywgaWZfdHJ1ZTogZmlsZXMoJ2Fw
LmMnKSkNCj4gICB2ZmlvX3NzLmFkZCh3aGVuOiAnQ09ORklHX1ZGSU9fSUdEJywgaWZfdHJ1
ZTogZmlsZXMoJ2lnZC5jJykpDQo+ICAgDQo+ICAgc3BlY2lmaWNfc3MuYWRkX2FsbCh3aGVu
OiAnQ09ORklHX1ZGSU8nLCBpZl90cnVlOiB2ZmlvX3NzKQ0KPiArDQo+ICtzeXN0ZW1fc3Mu
YWRkKHdoZW46ICdDT05GSUdfVkZJTycsIGlmX3RydWU6IGZpbGVzKA0KPiArICAnaGVscGVy
cy5jJywNCj4gKyAgJ2NvbnRhaW5lci1iYXNlLmMnLA0KPiArICAnbWlncmF0aW9uLmMnLA0K
PiArICAnbWlncmF0aW9uLW11bHRpZmQuYycsDQo+ICsgICdjcHIuYycsDQo+ICspKQ0KDQpS
ZXZpZXdlZC1ieTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8u
b3JnPg0KDQo=

