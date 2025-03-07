Return-Path: <kvm+bounces-40402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B962A57169
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1474F16C43F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABB4254AE5;
	Fri,  7 Mar 2025 19:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c1j1UmrW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C7F253F02
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374971; cv=none; b=GaXI3LDCBhD0IPPdfdh0wZ/QSSvWLby/4Okkhr1ZiCKn3x0jnAv9D5cjbULRv49Aiz3gvHKkvk+kN04OMi30U/BvYx7yUPmQNX5DenHELYFmsIi6y1qGTM28ZBcnwt28/wbVPpFxMGncw2O+qd1lbJcbppEQPvbIOa4f9MK85p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374971; c=relaxed/simple;
	bh=OeP69WaxLi4fNPjz8XHoe9xACL5tC1MEITIPsCFXcfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3kBBQWoWs6CGTBx/tyzs3m2nb6Kz1pK8YyxUp2DoMUfLGHm7S4CAlXGg+0UqO0MRmGufo193eODJacYZ1/w1sxjg8K3HXlyfrFl+gP2FKKLzpaLBjKld6yLsVM/hbr8d5aQGTbFioxtADx61KqLu8TzXyZQuqmA7XG67U28OlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c1j1UmrW; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2241053582dso17584295ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374969; x=1741979769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OeP69WaxLi4fNPjz8XHoe9xACL5tC1MEITIPsCFXcfA=;
        b=c1j1UmrWHWC4JQWAH5na1RfL3Ow8RItb+R3FKT/Yeq7sBHAZcO8Q+gJZYtzTcU7i4+
         Xj8KZNBmn7MuT7hMSJh+9TCeKpuAXXFjfXIEOfJwjZ/D9v8Ssew9vhF8o4YoJ6sJ0a7w
         8LMMcekftVWSGy3GCBxgTmGcgocIUHUokagh4hiXkwMWmAp6uzdvbkJp6ZUow6ncq49v
         z5VRJA4TBZwO5aX4PHP0hlfDyzbwpMGejMtEZ0a4p2RBXopt89SOMW2Uz6UM/WK0cA7m
         L/e9WJdGa4djWvTzNaA8j0iflwAWW7UGFVtgsDWKGnerqPrWt0KDcTkTv/K06zSx+Ncp
         NPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374969; x=1741979769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OeP69WaxLi4fNPjz8XHoe9xACL5tC1MEITIPsCFXcfA=;
        b=cyUfN011qFc9ZvUdVh3XpL5nQHLLQksa0floMgqUSyyQoI1/EP9jkK7VQ4+Z0BiVug
         lwjHh2P3WWOMSAhHVTDkcSFYcQnGtrFDJd47Cg5ayxHCw9A7wXr3Ml2mzcOBtAlg0saM
         9+7VziuTolOfwpqvo3c+X1bLvnzDG0ZfjOqaL3yu5kcmLuwy3T747mgCab19MvRxO1q4
         nLJmHHXW6xTAA4dLvmSH/rj41O0XWdJFJrQVHhK8BWejVH92D9Gc3O+6auOZTo2B2ERH
         mb+XLeTnARtI8pst9SYE+mBmBFCXsAF1K93tm4T9+pObjqrwt6nRLxDyiApREOKOP2MY
         HYaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcRqMtQO9Ctpnj94SqBZcgf9y/0qAWftiPjjad96n5PigtxX85VqbSdLQuPHgpNAOzo8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwN0HwKiWvGK86nlyUonoyYR0aYoJbONH/jmbDPNHTlyYS0D22
	2OUE32pfUs5INCFFFlLHVXwpQtjBEdWH/sd0Krqff/fj9YCoHczQk+pTNoS7e6c=
X-Gm-Gg: ASbGncuTgi88c2TGZ3XHOj6DCp4xDU3Bt6OlMgqpHnm3oCYa81HJ3l0VReuDerLN+sZ
	9X75brAJ6L1+bMhaCZTjOXCQKIyn+3tSblL919Ij3Gm/3A4YhrCh4JevVVHPjLzReg+iZ8zKkf3
	btHNnfABjU2xrYVEw71i5LV+8Reta6m/+hItJRJntkbor19/0IM+NYs3ppl6kZiVdfBqzKafIiT
	pBm4xqXTtC8F8Ezky9zAtckW77XGEPXtmw3N+nDVLuM4Kx9B2/4akfvusgacydfvaqS2bdOIaw2
	aRqq8dM/4id3q8htnv+WYR7Po2RLXZY2WzCWXwc7GRUbp1D3jvvGubI1Pg==
X-Google-Smtp-Source: AGHT+IGfPDOi36BknB8CY6dfJ0l8MlpdsZ6+O7IgClqLllxzbmME4yWe6V/2v88EVPuw41CC/cziww==
X-Received: by 2002:a17:902:db10:b0:224:1781:a947 with SMTP id d9443c01a7336-2242888b368mr72753315ad.21.1741374969486;
        Fri, 07 Mar 2025 11:16:09 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693f7cebsm3427547a91.45.2025.03.07.11.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:16:09 -0800 (PST)
Message-ID: <9e896ed1-0b82-4270-9b55-5b87ab3290cf@linaro.org>
Date: Fri, 7 Mar 2025 11:16:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/14] hw/vfio: Compile iommufd.c once
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
 <20250307180337.14811-6-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-6-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gUmVt
b3ZpbmcgdW51c2VkICJleGVjL3JhbV9hZGRyLmgiIGhlYWRlciBhbGxvdyB0byBjb21waWxl
DQo+IGlvbW11ZmQuYyBvbmNlIGZvciBhbGwgdGFyZ2V0cy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj4gLS0t
DQo+ICAgaHcvdmZpby9pb21tdWZkLmMgICB8IDEgLQ0KPiAgIGh3L3ZmaW8vbWVzb24uYnVp
bGQgfCA2ICsrKy0tLQ0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2h3L3ZmaW8vaW9tbXVmZC5jIGIv
aHcvdmZpby9pb21tdWZkLmMNCj4gaW5kZXggZGY2MWVkZmZjMDguLjQyYzg0MTJiYmY1IDEw
MDY0NA0KPiAtLS0gYS9ody92ZmlvL2lvbW11ZmQuYw0KPiArKysgYi9ody92ZmlvL2lvbW11
ZmQuYw0KPiBAQCAtMjUsNyArMjUsNiBAQA0KPiAgICNpbmNsdWRlICJxZW11L2N1dGlscy5o
Ig0KPiAgICNpbmNsdWRlICJxZW11L2NoYXJkZXZfb3Blbi5oIg0KPiAgICNpbmNsdWRlICJw
Y2kuaCINCj4gLSNpbmNsdWRlICJleGVjL3JhbV9hZGRyLmgiDQo+ICAgDQo+ICAgc3RhdGlj
IGludCBpb21tdWZkX2NkZXZfbWFwKGNvbnN0IFZGSU9Db250YWluZXJCYXNlICpiY29udGFp
bmVyLCBod2FkZHIgaW92YSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmFt
X2FkZHJfdCBzaXplLCB2b2lkICp2YWRkciwgYm9vbCByZWFkb25seSkNCj4gZGlmZiAtLWdp
dCBhL2h3L3ZmaW8vbWVzb24uYnVpbGQgYi9ody92ZmlvL21lc29uLmJ1aWxkDQo+IGluZGV4
IDI5NzJjNmZmOGRlLi5mZWE2ZGJlODhjZCAxMDA2NDQNCj4gLS0tIGEvaHcvdmZpby9tZXNv
bi5idWlsZA0KPiArKysgYi9ody92ZmlvL21lc29uLmJ1aWxkDQo+IEBAIC00LDkgKzQsNiBA
QCB2ZmlvX3NzLmFkZChmaWxlcygNCj4gICAgICdjb250YWluZXIuYycsDQo+ICAgKSkNCj4g
ICB2ZmlvX3NzLmFkZCh3aGVuOiAnQ09ORklHX1BTRVJJRVMnLCBpZl90cnVlOiBmaWxlcygn
c3BhcHIuYycpKQ0KPiAtdmZpb19zcy5hZGQod2hlbjogJ0NPTkZJR19JT01NVUZEJywgaWZf
dHJ1ZTogZmlsZXMoDQo+IC0gICdpb21tdWZkLmMnLA0KPiAtKSkNCj4gICB2ZmlvX3NzLmFk
ZCh3aGVuOiAnQ09ORklHX1ZGSU9fUENJJywgaWZfdHJ1ZTogZmlsZXMoDQo+ICAgICAnZGlz
cGxheS5jJywNCj4gICAgICdwY2ktcXVpcmtzLmMnLA0KPiBAQCAtMjgsMyArMjUsNiBAQCBz
eXN0ZW1fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJTycsIGlmX3RydWU6IGZpbGVzKA0KPiAg
ICAgJ21pZ3JhdGlvbi1tdWx0aWZkLmMnLA0KPiAgICAgJ2Nwci5jJywNCj4gICApKQ0KPiAr
c3lzdGVtX3NzLmFkZCh3aGVuOiBbJ0NPTkZJR19WRklPJywgJ0NPTkZJR19JT01NVUZEJ10s
IGlmX3RydWU6IGZpbGVzKA0KPiArICAnaW9tbXVmZC5jJywNCj4gKykpDQoNClJldmlld2Vk
LWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQoN
Cg==

