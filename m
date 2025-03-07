Return-Path: <kvm+bounces-40409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 074E7A5717C
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DD8F1896A84
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B1412500D0;
	Fri,  7 Mar 2025 19:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q1j8oDxY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C38250BFB
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375166; cv=none; b=rHwDYLebp1tJ5NrQsx4ZmrZ8tUecYwszgqCTDeQLG9eGOIkLJTMPsK3d8D0XP5ZEKz6qfz/Ox0ND5Frqz7AQ0SDZYD6hTwXLjYLYCnGM4sjUcGuZeLh24xSya6AZtNYL8otl99hzw+eMAulIT4XxrOk2NYE4xSnLJGjGI2iOPHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375166; c=relaxed/simple;
	bh=CwGeDAcGlrIg3UuUXUXJHyQU+nMyCUI9TS4YSn5Ch5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ltYGUd4fnUt6LpOfG011F2sSovb2JOVFk2qER2uWMMUe2kzyjdWFKKllEvfFmdC+6C7poyGhzHjLXqdJKTmvgABaZO1vYZ75XYgbomcvNw5G8KTWB+FV0TJT3Mt2aFHifM+eaECYXyaaU/4MSGAWhe6EDy0A0HygGtJvLvRCnbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q1j8oDxY; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-223cc017ef5so45673655ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375164; x=1741979964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CwGeDAcGlrIg3UuUXUXJHyQU+nMyCUI9TS4YSn5Ch5w=;
        b=q1j8oDxYfYThrB48avqi+IBeFCtW5a1xar8A4A3R3m7sscmG3Yjo7a0kc2gWlBIkRG
         KdIMwQNzkyaJ7bK6NWWXrVY4zNirUqBTNaTlcaX03+BG0PoSHo57G6Qkx9+EwNtPvnEl
         DMtsWhd/KHhhq7IIQEFkJy3vlLV+u5LdyucbsdwR73b8VXBTVtDKAoQVmY0cDdBIs8Du
         XjDFXUGsoIVxdnaySYFVm6va14URIHwLiyBgH1EKVaS43InMI0kwPlixy5HEXJFZXgN7
         4w3sPdMpCT/AdTksAczyVCifcg7LbRchDShjP+4vBlsUqKbJMC2AYBEqb3mgHdYUcOyT
         Y5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375164; x=1741979964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwGeDAcGlrIg3UuUXUXJHyQU+nMyCUI9TS4YSn5Ch5w=;
        b=QIFhArrG5pth3pbBfu2FlewijOmk1ylPRxdvri3J9ymb6JV7p9EKrKjCiopU7/zlLN
         HXRpIhcPIVFjR3axpWcyrIsvdFofTMmscbkMevZRItkp/1hJBm+Ek0Eo7es2LZb+tq7G
         q5z/GLPn5qlQnJsJhqn8x6qAEyOK80sLtXvjWuzq7+/6gt1hT7b0lLNLt+/K0Cr/AiWR
         DwUydDs0VfgQ8kvmIfABetQGBQM7dX4M2q5+WKE/Ji0VF7VohEAFVjcD8t0n9aNRWOTK
         q97uo8MkxFu2Zv8cfGzBGvekdGJ2VXxmmnAVp6oLrRp4hHSrKPDm67eR0IUW+o4dB2Ht
         xrRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeE3dJyVdTgYMtb8h/0P6w1uKvSf/defJ7yqnK1E22IDgf24ZGNb/aIaDMsibSovNF8GY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnX7hK/UHAoY+xs3eSvTLxX82dobz3il3Srqetep6lXPFNT8yw
	FYoXS7gxecaPOfJFsxaTOpVxo2W5y7S7VgRpaKQQ1iPpnWQjUAEUH1QzXotDN7GBkgVcd9br9kL
	s
X-Gm-Gg: ASbGncspmN6GludDY855m8yGchU8toRC0g1wR+1cxDinQTbGh+INz8ENKJepBWkyRVK
	OCDhwYi0Ae6R9cW5KnbV4JZ1q9ZVSz4CAB0fYYZMDHU+/aLVgO9LcxpPJr8GgLr1kdT7sY+pLYA
	aqL7XKsG09MDcerXtiERXKPOPG9ZdFl3sRMdMXWqJ5BYHUh4mf1sIgyCWlbFclgN1hHBrHvrVRI
	uqhTX/4GJzaO5HDoSrwW98aaPCAe0TM1xUsYWj0WeAnMVOJES8QbTcyZwpcgrE8wyoObAIqj3FT
	Bli3Z6SuruxdzK9oxxSBG7ReWh945Jn8Ofbdmi107sR4ZUG5tPk/5ykevw==
X-Google-Smtp-Source: AGHT+IG7w5mw5HnSJKXZr5RM/WkHkvBxEsrVuPUoKkyboUmCtKU0grP1Dihy3YlMH57nYdyK0m+VfQ==
X-Received: by 2002:a17:902:dac8:b0:220:d439:2485 with SMTP id d9443c01a7336-22428aa4033mr76277085ad.29.1741375163941;
        Fri, 07 Mar 2025 11:19:23 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410aa8a86sm33714705ad.240.2025.03.07.11.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:19:23 -0800 (PST)
Message-ID: <b66a9a03-9f8e-4a91-a138-b25af0bf62f9@linaro.org>
Date: Fri, 7 Mar 2025 11:19:22 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/14] hw/vfio/ap: Check CONFIG_IOMMUFD at runtime using
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
 <20250307180337.14811-13-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-13-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gQ29u
dmVydCB0aGUgY29tcGlsZSB0aW1lIGNoZWNrIG9uIHRoZSBDT05GSUdfSU9NTVVGRCBkZWZp
bml0aW9uDQo+IGJ5IGEgcnVudGltZSBvbmUgYnkgY2FsbGluZyBpb21tdWZkX2J1aWx0aW4o
KS4NCj4gDQo+IFNpbmNlIHRoZSBmaWxlIGRvZXNuJ3QgdXNlIGFueSB0YXJnZXQtc3BlY2lm
aWMga25vd2xlZGdlIGFueW1vcmUsDQo+IG1vdmUgaXQgdG8gc3lzdGVtX3NzW10gdG8gYnVp
bGQgaXQgb25jZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1
ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj4gLS0tDQo+ICAgdGFyZ2V0L3MzOTB4L2t2bS9r
dm1fczM5MHguaCB8ICAyICstDQo+ICAgaHcvdmZpby9hcC5jICAgICAgICAgICAgICAgICB8
IDI3ICsrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgIGh3L3ZmaW8vbWVzb24uYnVp
bGQgICAgICAgICAgfCAgMiArLQ0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9u
cygrKSwgMTYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L3MzOTB4
L2t2bS9rdm1fczM5MHguaCBiL3RhcmdldC9zMzkweC9rdm0va3ZtX3MzOTB4LmgNCj4gaW5k
ZXggNjQ5ZGFlNTk0OGEuLjdiMWNjZTNlNjBkIDEwMDY0NA0KPiAtLS0gYS90YXJnZXQvczM5
MHgva3ZtL2t2bV9zMzkweC5oDQo+ICsrKyBiL3RhcmdldC9zMzkweC9rdm0va3ZtX3MzOTB4
LmgNCj4gQEAgLTEwLDcgKzEwLDcgQEANCj4gICAjaWZuZGVmIEtWTV9TMzkwWF9IDQo+ICAg
I2RlZmluZSBLVk1fUzM5MFhfSA0KPiAgIA0KPiAtI2luY2x1ZGUgImNwdS1xb20uaCINCj4g
KyNpbmNsdWRlICJ0YXJnZXQvczM5MHgvY3B1LXFvbS5oIg0KPiAgIA0KPiAgIHN0cnVjdCBr
dm1fczM5MF9pcnE7DQo+ICAgDQo+IGRpZmYgLS1naXQgYS9ody92ZmlvL2FwLmMgYi9ody92
ZmlvL2FwLmMNCj4gaW5kZXggYzdhYjRmZjU3YWQuLjgzMmI5ODUzMmVhIDEwMDY0NA0KPiAt
LS0gYS9ody92ZmlvL2FwLmMNCj4gKysrIGIvaHcvdmZpby9hcC5jDQo+IEBAIC0xMSw3ICsx
MSw2IEBADQo+ICAgICovDQo+ICAgDQo+ICAgI2luY2x1ZGUgInFlbXUvb3NkZXAuaCINCj4g
LSNpbmNsdWRlIENPTkZJR19ERVZJQ0VTIC8qIENPTkZJR19JT01NVUZEICovDQo+ICAgI2lu
Y2x1ZGUgPGxpbnV4L3ZmaW8uaD4NCj4gICAjaW5jbHVkZSA8c3lzL2lvY3RsLmg+DQo+ICAg
I2luY2x1ZGUgInFhcGkvZXJyb3IuaCINCj4gQEAgLTI0LDcgKzIzLDcgQEANCj4gICAjaW5j
bHVkZSAicWVtdS9tb2R1bGUuaCINCj4gICAjaW5jbHVkZSAicWVtdS9vcHRpb24uaCINCj4g
ICAjaW5jbHVkZSAicWVtdS9jb25maWctZmlsZS5oIg0KPiAtI2luY2x1ZGUgImt2bS9rdm1f
czM5MHguaCINCj4gKyNpbmNsdWRlICJ0YXJnZXQvczM5MHgva3ZtL2t2bV9zMzkweC5oIg0K
PiAgICNpbmNsdWRlICJtaWdyYXRpb24vdm1zdGF0ZS5oIg0KPiAgICNpbmNsdWRlICJody9x
ZGV2LXByb3BlcnRpZXMuaCINCj4gICAjaW5jbHVkZSAiaHcvczM5MHgvYXAtYnJpZGdlLmgi
DQo+IEBAIC0xOTMsMTAgKzE5MiwxMSBAQCBzdGF0aWMgdm9pZCB2ZmlvX2FwX3VucmVhbGl6
ZShEZXZpY2VTdGF0ZSAqZGV2KQ0KPiAgIA0KPiAgIHN0YXRpYyBjb25zdCBQcm9wZXJ0eSB2
ZmlvX2FwX3Byb3BlcnRpZXNbXSA9IHsNCj4gICAgICAgREVGSU5FX1BST1BfU1RSSU5HKCJz
eXNmc2RldiIsIFZGSU9BUERldmljZSwgdmRldi5zeXNmc2RldiksDQo+IC0jaWZkZWYgQ09O
RklHX0lPTU1VRkQNCj4gK307DQo+ICsNCj4gK3N0YXRpYyBjb25zdCBQcm9wZXJ0eSB2Zmlv
X2FwX2lvbW11ZmRfcHJvcGVydGllc1tdID0gew0KPiAgICAgICBERUZJTkVfUFJPUF9MSU5L
KCJpb21tdWZkIiwgVkZJT0FQRGV2aWNlLCB2ZGV2LmlvbW11ZmQsDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgVFlQRV9JT01NVUZEX0JBQ0tFTkQsIElPTU1VRkRCYWNrZW5kICopLA0K
PiAtI2VuZGlmDQo+ICAgfTsNCj4gICANCj4gICBzdGF0aWMgdm9pZCB2ZmlvX2FwX3Jlc2V0
KERldmljZVN0YXRlICpkZXYpDQo+IEBAIC0yMzQsMjEgKzIzNCwyMCBAQCBzdGF0aWMgdm9p
ZCB2ZmlvX2FwX2luc3RhbmNlX2luaXQoT2JqZWN0ICpvYmopDQo+ICAgICAgIHZiYXNlZGV2
LT5tZGV2ID0gdHJ1ZTsNCj4gICB9DQo+ICAgDQo+IC0jaWZkZWYgQ09ORklHX0lPTU1VRkQN
Cj4gICBzdGF0aWMgdm9pZCB2ZmlvX2FwX3NldF9mZChPYmplY3QgKm9iaiwgY29uc3QgY2hh
ciAqc3RyLCBFcnJvciAqKmVycnApDQo+ICAgew0KPiAgICAgICB2ZmlvX2RldmljZV9zZXRf
ZmQoJlZGSU9fQVBfREVWSUNFKG9iaiktPnZkZXYsIHN0ciwgZXJycCk7DQo+ICAgfQ0KPiAt
I2VuZGlmDQo+ICAgDQo+ICAgc3RhdGljIHZvaWQgdmZpb19hcF9jbGFzc19pbml0KE9iamVj
dENsYXNzICprbGFzcywgdm9pZCAqZGF0YSkNCj4gICB7DQo+ICAgICAgIERldmljZUNsYXNz
ICpkYyA9IERFVklDRV9DTEFTUyhrbGFzcyk7DQo+ICAgDQo+ICAgICAgIGRldmljZV9jbGFz
c19zZXRfcHJvcHMoZGMsIHZmaW9fYXBfcHJvcGVydGllcyk7DQo+IC0jaWZkZWYgQ09ORklH
X0lPTU1VRkQNCj4gLSAgICBvYmplY3RfY2xhc3NfcHJvcGVydHlfYWRkX3N0cihrbGFzcywg
ImZkIiwgTlVMTCwgdmZpb19hcF9zZXRfZmQpOw0KPiAtI2VuZGlmDQo+ICsgICAgaWYgKGlv
bW11ZmRfYnVpbHRpbigpKSB7DQo+ICsgICAgICAgIGRldmljZV9jbGFzc19zZXRfcHJvcHMo
ZGMsIHZmaW9fYXBfaW9tbXVmZF9wcm9wZXJ0aWVzKTsNCj4gKyAgICAgICAgb2JqZWN0X2Ns
YXNzX3Byb3BlcnR5X2FkZF9zdHIoa2xhc3MsICJmZCIsIE5VTEwsIHZmaW9fYXBfc2V0X2Zk
KTsNCj4gKyAgICB9DQo+ICAgICAgIGRjLT52bXNkID0gJnZmaW9fYXBfdm1zdGF0ZTsNCj4g
ICAgICAgZGMtPmRlc2MgPSAiVkZJTy1iYXNlZCBBUCBkZXZpY2UgYXNzaWdubWVudCI7DQo+
ICAgICAgIHNldF9iaXQoREVWSUNFX0NBVEVHT1JZX01JU0MsIGRjLT5jYXRlZ29yaWVzKTsN
Cj4gQEAgLTI2MSwxMSArMjYwLDExIEBAIHN0YXRpYyB2b2lkIHZmaW9fYXBfY2xhc3NfaW5p
dChPYmplY3RDbGFzcyAqa2xhc3MsIHZvaWQgKmRhdGEpDQo+ICAgICAgIG9iamVjdF9jbGFz
c19wcm9wZXJ0eV9zZXRfZGVzY3JpcHRpb24oa2xhc3MsIC8qIDMuMSAqLw0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJzeXNmc2RldiIsDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIkhvc3Qgc3lzZnMg
cGF0aCBvZiBhc3NpZ25lZCBkZXZpY2UiKTsNCj4gLSNpZmRlZiBDT05GSUdfSU9NTVVGRA0K
PiAtICAgIG9iamVjdF9jbGFzc19wcm9wZXJ0eV9zZXRfZGVzY3JpcHRpb24oa2xhc3MsIC8q
IDkuMCAqLw0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ImlvbW11ZmQiLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIlNldCBob3N0IElPTU1VRkQgYmFja2VuZCBkZXZpY2UiKTsNCj4gLSNlbmRpZg0KPiAr
ICAgIGlmIChpb21tdWZkX2J1aWx0aW4oKSkgew0KPiArICAgICAgICBvYmplY3RfY2xhc3Nf
cHJvcGVydHlfc2V0X2Rlc2NyaXB0aW9uKGtsYXNzLCAvKiA5LjAgKi8NCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiaW9tbXVmZCIsDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIlNldCBob3N0
IElPTU1VRkQgYmFja2VuZCBkZXZpY2UiKTsNCj4gKyAgICB9DQo+ICAgfQ0KPiAgIA0KPiAg
IHN0YXRpYyBjb25zdCBUeXBlSW5mbyB2ZmlvX2FwX2luZm8gPSB7DQo+IGRpZmYgLS1naXQg
YS9ody92ZmlvL21lc29uLmJ1aWxkIGIvaHcvdmZpby9tZXNvbi5idWlsZA0KPiBpbmRleCA5
YTAwNDk5MmMxMS4uNTEwZWJlNmQ3MjAgMTAwNjQ0DQo+IC0tLSBhL2h3L3ZmaW8vbWVzb24u
YnVpbGQNCj4gKysrIGIvaHcvdmZpby9tZXNvbi5idWlsZA0KPiBAQCAtOSw3ICs5LDYgQEAg
dmZpb19zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPX1BDSScsIGlmX3RydWU6IGZpbGVzKA0K
PiAgICkpDQo+ICAgdmZpb19zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPX0NDVycsIGlmX3Ry
dWU6IGZpbGVzKCdjY3cuYycpKQ0KPiAgIHZmaW9fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJ
T19QTEFURk9STScsIGlmX3RydWU6IGZpbGVzKCdwbGF0Zm9ybS5jJykpDQo+IC12ZmlvX3Nz
LmFkZCh3aGVuOiAnQ09ORklHX1ZGSU9fQVAnLCBpZl90cnVlOiBmaWxlcygnYXAuYycpKQ0K
PiAgIA0KPiAgIHNwZWNpZmljX3NzLmFkZF9hbGwod2hlbjogJ0NPTkZJR19WRklPJywgaWZf
dHJ1ZTogdmZpb19zcykNCj4gICANCj4gQEAgLTI2LDYgKzI1LDcgQEAgc3lzdGVtX3NzLmFk
ZCh3aGVuOiAnQ09ORklHX1ZGSU8nLCBpZl90cnVlOiBmaWxlcygNCj4gICBzeXN0ZW1fc3Mu
YWRkKHdoZW46IFsnQ09ORklHX1ZGSU8nLCAnQ09ORklHX0lPTU1VRkQnXSwgaWZfdHJ1ZTog
ZmlsZXMoDQo+ICAgICAnaW9tbXVmZC5jJywNCj4gICApKQ0KPiArc3lzdGVtX3NzLmFkZCh3
aGVuOiAnQ09ORklHX1ZGSU9fQVAnLCBpZl90cnVlOiBmaWxlcygnYXAuYycpKQ0KPiAgIHN5
c3RlbV9zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPX1BDSScsIGlmX3RydWU6IGZpbGVzKA0K
PiAgICAgJ2Rpc3BsYXkuYycsDQo+ICAgICAncGNpLmMnLA0KDQpSZXZpZXdlZC1ieTogUGll
cnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KDQo=

