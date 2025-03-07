Return-Path: <kvm+bounces-40410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2648A5717A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D245F1630EF
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F76B250BF2;
	Fri,  7 Mar 2025 19:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DwsX6Jlt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A79A21E0A8
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375186; cv=none; b=Cncnx108wXmjLpaWBLx3fIBSlaQLiyw4hhUFB/jrhfu36/dmLqlCj0X2jn1LWP/f7F5lgmDlqt9s3GmMEZI6HmAxXzXPy4ey4Jiqq9p+7ciEtJaNL+RnP5tU1La3bOmEvfxUb/gKx95J2VSKnuzOD2PF2Wvjx40YKdSucfOQOds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375186; c=relaxed/simple;
	bh=dGBOPEpoLJnftv+F44IL9sSyl0wd48zAbI62G0mxsjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mepY7lBJ5V3hz1elhPzFvqsNS0v16+4xs3WzTx/fpJ1EK+haE9t3TSATMhsHARBpHeovRP04KoyJxtIckPRF2soquyEDtOj1jsyJkPPMaYN1z4miBv0HPlSTnBtKcxaPhDKhhywgpXOlGkmS36RSm/ch1vw39RtJilRzL/im3m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DwsX6Jlt; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2f44353649aso3655070a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375183; x=1741979983; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dGBOPEpoLJnftv+F44IL9sSyl0wd48zAbI62G0mxsjk=;
        b=DwsX6JltMS95316uWpn2rhMj95WQSJpOMgSsjhnl6DJMYzoOZBRW7+WUDuE7XYl+aY
         oAdG53Ir0lDNSVHLHF15cCLtSkv5XFL2gRfcwejiW3bbyzvbBeV3Hm6RhxEesr6VeRQy
         Jb8scFEj7VGVKM6zWSSJYIHKTJLF4V/OIXwjRfX8cuc+psIiTwYRQl1YFUfFuwvbZLCa
         gpG3b6HUip1yrRt/HLqQcWIrL9eHgMwaUPv8WepYczUnJihLQtxZvhWNAi+oyQ6Lw85r
         7lNUlPT7VJeVLH2BiVWmENoFaN+4SmYHSqrHUlViAhTuV3Aa0DrG7ayIuZizQju+m2EB
         v7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375183; x=1741979983;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGBOPEpoLJnftv+F44IL9sSyl0wd48zAbI62G0mxsjk=;
        b=eMvsyXnliXWJv+J70SRxB2S6j/s3iWDtV3zEX+RyQ03OpLt8x/AHKb3Ym4d1GgNkz6
         Ztla15nPxGIytdi9WldoOAHG9JaTkPQ08W+K0nRqeKztnmqHNxf6Mqbst4wG4/lJpJFX
         Pfubyh/zGv9kmDMeqE0bktX7QVhgdPyQk+8FEgnncQXvM+LxvbHAevD+G70lFX4+ee5V
         ThLvjVT0k5N43mcgc3EMUOnIP02EX/TYCU9AmLzJgrFO+keAo7ZxBuhbxdxpd+1ucVFn
         D0TFhuK17CztxPH533GFBaZFOVKr0S7cCfWZcx03bZVs06+Sk8+cj2NravxDAqPJ5xQ3
         wzlw==
X-Forwarded-Encrypted: i=1; AJvYcCXDnKTcVvAObWXmZPrQ7/oVCp5UUG6HYIqUmJQtzsPbIPK5kMSEwBFEbyEHTV9eKOwQLvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYnPqMRjQV+Z3aJn3SF3QK1vuvDke6eIYpkFLMz+Byc19tBS9r
	irpmeBW9tTOsTjkgP4g9WbRfYDGMF0vBH3qkaiAkhcl+eHJc4wnZUuLkLSbKkUM=
X-Gm-Gg: ASbGncuWnCZdiQzzDSUI55fopdLX26TtPyUs2Hvxfrv/7w0BDu7jt/tf1kNw5y4wmwm
	3mLaWdy3WQiKK035YDhG4nK//jxfnUzvcA40lMO56f9XnFLTJY2EdHBpqGHtuk8wjH7Pj72RG2k
	DuhL+cit5INJHvyTQcJpouFUdbY6Rd6Ej5+yAAeOrLQjgLjrrhT1cwjPXhrBxiBtcFQcyMAkfAl
	e4x9AgskDI/1GmNyC4m/K2NojlkbIJYfosIDXL019by9EaFK6YkQYKRUCIQE4cqJZeiGRkeweqP
	jXK3/m/D87zbOTKEcjyCXZOP20fVDlOIpaJtiPKI6bqzBqiSwV1hNJ7Tug==
X-Google-Smtp-Source: AGHT+IH5/ocuUtLYUB/yaLzF5E8eNuzuh2M6KM3Ni4grpdlzQKCtZpFi+/Uqjj64U/wGveE6ONOPNA==
X-Received: by 2002:a17:90b:1a86:b0:2f6:dcc9:38e0 with SMTP id 98e67ed59e1d1-2ff7cd58013mr8625652a91.0.1741375183369;
        Fri, 07 Mar 2025 11:19:43 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff4e773c87sm5339712a91.16.2025.03.07.11.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:19:42 -0800 (PST)
Message-ID: <e8171f31-6796-48dd-80cf-4fb637deb1d5@linaro.org>
Date: Fri, 7 Mar 2025 11:19:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] hw/vfio/ccw: Check CONFIG_IOMMUFD at runtime using
 iommufd_builtin()
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
 <20250307180337.14811-14-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-14-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gQ29u
dmVydCB0aGUgY29tcGlsZSB0aW1lIGNoZWNrIG9uIHRoZSBDT05GSUdfSU9NTVVGRCBkZWZp
bml0aW9uDQo+IGJ5IGEgcnVudGltZSBvbmUgYnkgY2FsbGluZyBpb21tdWZkX2J1aWx0aW4o
KS4NCj4gDQo+IFNpbmNlIHRoZSBmaWxlIGRvZXNuJ3QgdXNlIGFueSB0YXJnZXQtc3BlY2lm
aWMga25vd2xlZGdlIGFueW1vcmUsDQo+IG1vdmUgaXQgdG8gc3lzdGVtX3NzW10gdG8gYnVp
bGQgaXQgb25jZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1
ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj4gLS0tDQo+ICAgaHcvdmZpby9jY3cuYyAgICAg
ICB8IDI3ICsrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgIGh3L3ZmaW8vbWVzb24u
YnVpbGQgfCAgMiArLQ0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwg
MTUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaHcvdmZpby9jY3cuYyBiL2h3
L3ZmaW8vY2N3LmMNCj4gaW5kZXggZTVlMGQ5ZTNlN2UuLjg0ZDE0MzdhNTY4IDEwMDY0NA0K
PiAtLS0gYS9ody92ZmlvL2Njdy5jDQo+ICsrKyBiL2h3L3ZmaW8vY2N3LmMNCj4gQEAgLTE1
LDcgKzE1LDYgQEANCj4gICAgKi8NCj4gICANCj4gICAjaW5jbHVkZSAicWVtdS9vc2RlcC5o
Ig0KPiAtI2luY2x1ZGUgQ09ORklHX0RFVklDRVMgLyogQ09ORklHX0lPTU1VRkQgKi8NCj4g
ICAjaW5jbHVkZSA8bGludXgvdmZpby5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC92ZmlvX2Nj
dy5oPg0KPiAgICNpbmNsdWRlIDxzeXMvaW9jdGwuaD4NCj4gQEAgLTY1MCwxMSArNjQ5LDEy
IEBAIHN0YXRpYyB2b2lkIHZmaW9fY2N3X3VucmVhbGl6ZShEZXZpY2VTdGF0ZSAqZGV2KQ0K
PiAgIHN0YXRpYyBjb25zdCBQcm9wZXJ0eSB2ZmlvX2Njd19wcm9wZXJ0aWVzW10gPSB7DQo+
ICAgICAgIERFRklORV9QUk9QX1NUUklORygic3lzZnNkZXYiLCBWRklPQ0NXRGV2aWNlLCB2
ZGV2LnN5c2ZzZGV2KSwNCj4gICAgICAgREVGSU5FX1BST1BfQk9PTCgiZm9yY2Utb3JiLXBm
Y2giLCBWRklPQ0NXRGV2aWNlLCBmb3JjZV9vcmJfcGZjaCwgZmFsc2UpLA0KPiAtI2lmZGVm
IENPTkZJR19JT01NVUZEDQo+ICsgICAgREVGSU5FX1BST1BfQ0NXX0xPQURQQVJNKCJsb2Fk
cGFybSIsIENjd0RldmljZSwgbG9hZHBhcm0pLA0KPiArfTsNCj4gKw0KPiArc3RhdGljIGNv
bnN0IFByb3BlcnR5IHZmaW9fY2N3X2lvbW11ZmRfcHJvcGVydGllc1tdID0gew0KPiAgICAg
ICBERUZJTkVfUFJPUF9MSU5LKCJpb21tdWZkIiwgVkZJT0NDV0RldmljZSwgdmRldi5pb21t
dWZkLA0KPiAgICAgICAgICAgICAgICAgICAgICAgIFRZUEVfSU9NTVVGRF9CQUNLRU5ELCBJ
T01NVUZEQmFja2VuZCAqKSwNCj4gLSNlbmRpZg0KPiAtICAgIERFRklORV9QUk9QX0NDV19M
T0FEUEFSTSgibG9hZHBhcm0iLCBDY3dEZXZpY2UsIGxvYWRwYXJtKSwNCj4gICB9Ow0KPiAg
IA0KPiAgIHN0YXRpYyBjb25zdCBWTVN0YXRlRGVzY3JpcHRpb24gdmZpb19jY3dfdm1zdGF0
ZSA9IHsNCj4gQEAgLTY4MiwxMiArNjgyLDEwIEBAIHN0YXRpYyB2b2lkIHZmaW9fY2N3X2lu
c3RhbmNlX2luaXQoT2JqZWN0ICpvYmopDQo+ICAgICAgICAgICAgICAgICAgICAgICAgREVW
SUNFKHZjZGV2KSwgdHJ1ZSk7DQo+ICAgfQ0KPiAgIA0KPiAtI2lmZGVmIENPTkZJR19JT01N
VUZEDQo+ICAgc3RhdGljIHZvaWQgdmZpb19jY3dfc2V0X2ZkKE9iamVjdCAqb2JqLCBjb25z
dCBjaGFyICpzdHIsIEVycm9yICoqZXJycCkNCj4gICB7DQo+ICAgICAgIHZmaW9fZGV2aWNl
X3NldF9mZCgmVkZJT19DQ1cob2JqKS0+dmRldiwgc3RyLCBlcnJwKTsNCj4gICB9DQo+IC0j
ZW5kaWYNCj4gICANCj4gICBzdGF0aWMgdm9pZCB2ZmlvX2Njd19jbGFzc19pbml0KE9iamVj
dENsYXNzICprbGFzcywgdm9pZCAqZGF0YSkNCj4gICB7DQo+IEBAIC02OTUsOSArNjkzLDEw
IEBAIHN0YXRpYyB2b2lkIHZmaW9fY2N3X2NsYXNzX2luaXQoT2JqZWN0Q2xhc3MgKmtsYXNz
LCB2b2lkICpkYXRhKQ0KPiAgICAgICBTMzkwQ0NXRGV2aWNlQ2xhc3MgKmNkYyA9IFMzOTBf
Q0NXX0RFVklDRV9DTEFTUyhrbGFzcyk7DQo+ICAgDQo+ICAgICAgIGRldmljZV9jbGFzc19z
ZXRfcHJvcHMoZGMsIHZmaW9fY2N3X3Byb3BlcnRpZXMpOw0KPiAtI2lmZGVmIENPTkZJR19J
T01NVUZEDQo+IC0gICAgb2JqZWN0X2NsYXNzX3Byb3BlcnR5X2FkZF9zdHIoa2xhc3MsICJm
ZCIsIE5VTEwsIHZmaW9fY2N3X3NldF9mZCk7DQo+IC0jZW5kaWYNCj4gKyAgICBpZiAoaW9t
bXVmZF9idWlsdGluKCkpIHsNCj4gKyAgICAgICAgZGV2aWNlX2NsYXNzX3NldF9wcm9wcyhk
YywgdmZpb19jY3dfaW9tbXVmZF9wcm9wZXJ0aWVzKTsNCj4gKyAgICAgICAgb2JqZWN0X2Ns
YXNzX3Byb3BlcnR5X2FkZF9zdHIoa2xhc3MsICJmZCIsIE5VTEwsIHZmaW9fY2N3X3NldF9m
ZCk7DQo+ICsgICAgfQ0KPiAgICAgICBkYy0+dm1zZCA9ICZ2ZmlvX2Njd192bXN0YXRlOw0K
PiAgICAgICBkYy0+ZGVzYyA9ICJWRklPLWJhc2VkIHN1YmNoYW5uZWwgYXNzaWdubWVudCI7
DQo+ICAgICAgIHNldF9iaXQoREVWSUNFX0NBVEVHT1JZX01JU0MsIGRjLT5jYXRlZ29yaWVz
KTsNCj4gQEAgLTcxNiwxMSArNzE1LDExIEBAIHN0YXRpYyB2b2lkIHZmaW9fY2N3X2NsYXNz
X2luaXQoT2JqZWN0Q2xhc3MgKmtsYXNzLCB2b2lkICpkYXRhKQ0KPiAgICAgICBvYmplY3Rf
Y2xhc3NfcHJvcGVydHlfc2V0X2Rlc2NyaXB0aW9uKGtsYXNzLCAvKiAzLjAgKi8NCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiZm9yY2Utb3JiLXBm
Y2giLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJG
b3JjZSB1bmxpbWl0ZWQgcHJlZmV0Y2giKTsNCj4gLSNpZmRlZiBDT05GSUdfSU9NTVVGRA0K
PiAtICAgIG9iamVjdF9jbGFzc19wcm9wZXJ0eV9zZXRfZGVzY3JpcHRpb24oa2xhc3MsIC8q
IDkuMCAqLw0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ImlvbW11ZmQiLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIlNldCBob3N0IElPTU1VRkQgYmFja2VuZCBkZXZpY2UiKTsNCj4gLSNlbmRpZg0KPiAr
ICAgIGlmIChpb21tdWZkX2J1aWx0aW4oKSkgew0KPiArICAgICAgICBvYmplY3RfY2xhc3Nf
cHJvcGVydHlfc2V0X2Rlc2NyaXB0aW9uKGtsYXNzLCAvKiA5LjAgKi8NCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiaW9tbXVmZCIsDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIlNldCBob3N0
IElPTU1VRkQgYmFja2VuZCBkZXZpY2UiKTsNCj4gKyAgICB9DQo+ICAgICAgIG9iamVjdF9j
bGFzc19wcm9wZXJ0eV9zZXRfZGVzY3JpcHRpb24oa2xhc3MsIC8qIDkuMiAqLw0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJsb2FkcGFybSIsDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIkRlZmluZSB3
aGljaCBkZXZpY2VzIHRoYXQgY2FuIGJlIHVzZWQgZm9yIGJvb3RpbmciKTsNCj4gZGlmZiAt
LWdpdCBhL2h3L3ZmaW8vbWVzb24uYnVpbGQgYi9ody92ZmlvL21lc29uLmJ1aWxkDQo+IGlu
ZGV4IDUxMGViZTZkNzIwLi5iZDZlMWQ5OTllNCAxMDA2NDQNCj4gLS0tIGEvaHcvdmZpby9t
ZXNvbi5idWlsZA0KPiArKysgYi9ody92ZmlvL21lc29uLmJ1aWxkDQo+IEBAIC03LDcgKzcs
NiBAQCB2ZmlvX3NzLmFkZCh3aGVuOiAnQ09ORklHX1BTRVJJRVMnLCBpZl90cnVlOiBmaWxl
cygnc3BhcHIuYycpKQ0KPiAgIHZmaW9fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJT19QQ0kn
LCBpZl90cnVlOiBmaWxlcygNCj4gICAgICdwY2ktcXVpcmtzLmMnLA0KPiAgICkpDQo+IC12
ZmlvX3NzLmFkZCh3aGVuOiAnQ09ORklHX1ZGSU9fQ0NXJywgaWZfdHJ1ZTogZmlsZXMoJ2Nj
dy5jJykpDQo+ICAgdmZpb19zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPX1BMQVRGT1JNJywg
aWZfdHJ1ZTogZmlsZXMoJ3BsYXRmb3JtLmMnKSkNCj4gICANCj4gICBzcGVjaWZpY19zcy5h
ZGRfYWxsKHdoZW46ICdDT05GSUdfVkZJTycsIGlmX3RydWU6IHZmaW9fc3MpDQo+IEBAIC0y
Niw2ICsyNSw3IEBAIHN5c3RlbV9zcy5hZGQod2hlbjogWydDT05GSUdfVkZJTycsICdDT05G
SUdfSU9NTVVGRCddLCBpZl90cnVlOiBmaWxlcygNCj4gICAgICdpb21tdWZkLmMnLA0KPiAg
ICkpDQo+ICAgc3lzdGVtX3NzLmFkZCh3aGVuOiAnQ09ORklHX1ZGSU9fQVAnLCBpZl90cnVl
OiBmaWxlcygnYXAuYycpKQ0KPiArc3lzdGVtX3NzLmFkZCh3aGVuOiAnQ09ORklHX1ZGSU9f
Q0NXJywgaWZfdHJ1ZTogZmlsZXMoJ2Njdy5jJykpDQo+ICAgc3lzdGVtX3NzLmFkZCh3aGVu
OiAnQ09ORklHX1ZGSU9fUENJJywgaWZfdHJ1ZTogZmlsZXMoDQo+ICAgICAnZGlzcGxheS5j
JywNCj4gICAgICdwY2kuYycsDQoNClJldmlld2VkLWJ5OiBQaWVycmljayBCb3V2aWVyIDxw
aWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQoNCg==

