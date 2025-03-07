Return-Path: <kvm+bounces-40411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C12A1A57183
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AB057A268E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDC01A5BA2;
	Fri,  7 Mar 2025 19:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="grk2/f2i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C35021A45A
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375219; cv=none; b=gv7we131AQYla46753TdkSqFK2NfWocq1B3awplWkf5N91FYRC1C55XRN5svKiwNINjdvyJExzf0wCwT9ZkshKOq7AmJnsr7gcAA+Cs/IWqYRBZGT29S8ik0j1WZv3fzJRuWrHUhmUFmE7Dz1WwH3n1cPClSo7uP7Mf3Qsyf2i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375219; c=relaxed/simple;
	bh=QnZzQ8xIkaMXC8cGThBUN9qjyauvWJ30D/qPq+dR2KA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GXT7dezihY8z5SZk1T/7bMHjgPULvuLcwkJtPN5fFc/Oa1MmjfUzQtnrIuWAo1lpdHlDyZyYuTfJYCiiJKKtuyPMG/2Fu/OqHV6/VN3fvsI0Po0eOey3ecCf5eu9VrgSJD2AZMqtaGWGavb8FDwM4rnNrVlaDn6exPnbIut372E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=grk2/f2i; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-219f8263ae0so44905755ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375217; x=1741980017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QnZzQ8xIkaMXC8cGThBUN9qjyauvWJ30D/qPq+dR2KA=;
        b=grk2/f2i1cSirxQlRMsOSwjWQ68zPQGJJYdqLna5lfFuhiJ6K2RE6pVuKooun0Qw28
         FtbR1UJmGyZAn93X3p6r5DqPbqM5K7F8nhlEymmo5aweYOkhn9RopPehT5g/cwrkbBTc
         vM/hPT/jMu1QgqsSYksOHN42IZH8vNJZLh7L5A1e9SSaAiXiAltZdLBckKqDF1dOianX
         rBJtlKuxVzufrkXlvOYU7qUTHcOamjuK1nMPA+J3RrzWrbGKxK102KNTpgUSdKnG/Tax
         zWSnM0S4BbKPSltaldQwVeu6YfrqIhTmO8zzh/3f8gnGprLs9FyQNifoL8TI4Lqnrnv5
         Arhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375217; x=1741980017;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QnZzQ8xIkaMXC8cGThBUN9qjyauvWJ30D/qPq+dR2KA=;
        b=QYKVP67J3SI2zChnTDS1eCq804Qg9v2hwtB6KafGzdAYNq9CbfgOg5PbINIQYj9lB/
         pd8Z/e2H5SKMaLgFqpoiuUuzzDwheaCtp2H+5Njg7XkaubxSLUg2EoIaCB++3RP9WICk
         JZkcyhsaAEPfBv+zNSmSsNNeo0pKRHSomIz+vPHkbhlGudiPMkW13z/kkikI8rCSrpL6
         ZpX0c2gyP4yAjuD6JW1jm38ZAUh+QHC7K3Ya2MNpaXsc3Xl53+lhFlNJm7xBITYUNYGh
         8JDndLSCci9Kx+rf/r3XXEyeEwI1lWo+zr1QpdWNiHU2M9D+4lQPKme+mYm2X3n4lfrj
         z/fg==
X-Forwarded-Encrypted: i=1; AJvYcCXqGuJ2qocapIij1AIzu0YlkMWxFwTC0WaxiSA4zry5acLS4+uHTVlA1Q3Iu5nBn61iuak=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNeXI08Q6GNMsb4a2e9TYXLWIvLP//ApxMM9vUXndcnyij5wqg
	HuVF2qMzoXe8yxZMtYoEG69/1Ng8qJzshlXoXC2P6vRnEMGO9UpbTxpsv0KyMRA=
X-Gm-Gg: ASbGncvtbBWZ50l8asxpNGAsKFKPSeMRuRvvjhQzGN3vIq1Z8jcySjMB0vxmulR0dP5
	RxEwY8rxh1xrRnjbGeGw+eWfNxmRCqWqSYu8aaQmqganmrMJbKoNbf2gm1rqr4bLnA3mrFhpAlp
	5ujyn/fFHtjDapCRstLYaDWv7/tICg+SYKDxD2uHFKekaMf7ghmiVjjd+XshU8i/AHwXe/SLQRk
	IUPWujHKkp1+djb13WpPrWHrN0I3RM1n/EEWu1zrlkjlDD2PKyrrQpanNBIFRLs3j1bVSDz/esI
	/7S39GnvEtEIBzanJTzWH9zfm6paNjXTTWrUtGIg1G521D0cxneYrAOF2w==
X-Google-Smtp-Source: AGHT+IEw4kycfkExnTF4ehnxSH6o0twQeGdPU6hW4taR7U1Qi6yn3fbpGFFzlNqdG8L8FTLqPdU/aA==
X-Received: by 2002:a05:6a20:7fa1:b0:1f0:e706:1370 with SMTP id adf61e73a8af0-1f544cac82amr9581732637.35.1741375216875;
        Fri, 07 Mar 2025 11:20:16 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73698519395sm3618435b3a.153.2025.03.07.11.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:20:16 -0800 (PST)
Message-ID: <8e8b6f27-9247-4154-a276-e51267c04d18@linaro.org>
Date: Fri, 7 Mar 2025 11:20:15 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/14] hw/vfio/platform: Check CONFIG_IOMMUFD at runtime
 using iommufd_builtin
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
 <20250307180337.14811-15-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-15-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gQ29u
dmVydCB0aGUgY29tcGlsZSB0aW1lIGNoZWNrIG9uIHRoZSBDT05GSUdfSU9NTVVGRCBkZWZp
bml0aW9uDQo+IGJ5IGEgcnVudGltZSBvbmUgYnkgY2FsbGluZyBpb21tdWZkX2J1aWx0aW4o
KS4NCj4gDQo+IFNpbmNlIHRoZSBmaWxlIGRvZXNuJ3QgdXNlIGFueSB0YXJnZXQtc3BlY2lm
aWMga25vd2xlZGdlIGFueW1vcmUsDQo+IG1vdmUgaXQgdG8gc3lzdGVtX3NzW10gdG8gYnVp
bGQgaXQgb25jZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1
ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj4gLS0tDQo+ICAgaHcvdmZpby9wbGF0Zm9ybS5j
ICB8IDI1ICsrKysrKysrKysrKy0tLS0tLS0tLS0tLS0NCj4gICBody92ZmlvL21lc29uLmJ1
aWxkIHwgIDIgKy0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDE0
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2h3L3ZmaW8vcGxhdGZvcm0uYyBi
L2h3L3ZmaW8vcGxhdGZvcm0uYw0KPiBpbmRleCA2N2JjNTc0MDljMS4uMjY1YzU1MGI3NDcg
MTAwNjQ0DQo+IC0tLSBhL2h3L3ZmaW8vcGxhdGZvcm0uYw0KPiArKysgYi9ody92ZmlvL3Bs
YXRmb3JtLmMNCj4gQEAgLTE1LDcgKzE1LDYgQEANCj4gICAgKi8NCj4gICANCj4gICAjaW5j
bHVkZSAicWVtdS9vc2RlcC5oIg0KPiAtI2luY2x1ZGUgQ09ORklHX0RFVklDRVMgLyogQ09O
RklHX0lPTU1VRkQgKi8NCj4gICAjaW5jbHVkZSAicWFwaS9lcnJvci5oIg0KPiAgICNpbmNs
dWRlIDxzeXMvaW9jdGwuaD4NCj4gICAjaW5jbHVkZSA8bGludXgvdmZpby5oPg0KPiBAQCAt
NjM3LDEwICs2MzYsMTEgQEAgc3RhdGljIGNvbnN0IFByb3BlcnR5IHZmaW9fcGxhdGZvcm1f
ZGV2X3Byb3BlcnRpZXNbXSA9IHsNCj4gICAgICAgREVGSU5FX1BST1BfVUlOVDMyKCJtbWFw
LXRpbWVvdXQtbXMiLCBWRklPUGxhdGZvcm1EZXZpY2UsDQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICBtbWFwX3RpbWVvdXQsIDExMDApLA0KPiAgICAgICBERUZJTkVfUFJPUF9CT09M
KCJ4LWlycWZkIiwgVkZJT1BsYXRmb3JtRGV2aWNlLCBpcnFmZF9hbGxvd2VkLCB0cnVlKSwN
Cj4gLSNpZmRlZiBDT05GSUdfSU9NTVVGRA0KPiArfTsNCj4gKw0KPiArc3RhdGljIGNvbnN0
IFByb3BlcnR5IHZmaW9fcGxhdGZvcm1fZGV2X2lvbW11ZmRfcHJvcGVydGllc1tdID0gew0K
PiAgICAgICBERUZJTkVfUFJPUF9MSU5LKCJpb21tdWZkIiwgVkZJT1BsYXRmb3JtRGV2aWNl
LCB2YmFzZWRldi5pb21tdWZkLA0KPiAgICAgICAgICAgICAgICAgICAgICAgIFRZUEVfSU9N
TVVGRF9CQUNLRU5ELCBJT01NVUZEQmFja2VuZCAqKSwNCj4gLSNlbmRpZg0KPiAgIH07DQo+
ICAgDQo+ICAgc3RhdGljIHZvaWQgdmZpb19wbGF0Zm9ybV9pbnN0YW5jZV9pbml0KE9iamVj
dCAqb2JqKQ0KPiBAQCAtNjUyLDEyICs2NTIsMTAgQEAgc3RhdGljIHZvaWQgdmZpb19wbGF0
Zm9ybV9pbnN0YW5jZV9pbml0KE9iamVjdCAqb2JqKQ0KPiAgICAgICAgICAgICAgICAgICAg
ICAgIERFVklDRSh2ZGV2KSwgZmFsc2UpOw0KPiAgIH0NCj4gICANCj4gLSNpZmRlZiBDT05G
SUdfSU9NTVVGRA0KPiAgIHN0YXRpYyB2b2lkIHZmaW9fcGxhdGZvcm1fc2V0X2ZkKE9iamVj
dCAqb2JqLCBjb25zdCBjaGFyICpzdHIsIEVycm9yICoqZXJycCkNCj4gICB7DQo+ICAgICAg
IHZmaW9fZGV2aWNlX3NldF9mZCgmVkZJT19QTEFURk9STV9ERVZJQ0Uob2JqKS0+dmJhc2Vk
ZXYsIHN0ciwgZXJycCk7DQo+ICAgfQ0KPiAtI2VuZGlmDQo+ICAgDQo+ICAgc3RhdGljIHZv
aWQgdmZpb19wbGF0Zm9ybV9jbGFzc19pbml0KE9iamVjdENsYXNzICprbGFzcywgdm9pZCAq
ZGF0YSkNCj4gICB7DQo+IEBAIC02NjYsOSArNjY0LDEwIEBAIHN0YXRpYyB2b2lkIHZmaW9f
cGxhdGZvcm1fY2xhc3NfaW5pdChPYmplY3RDbGFzcyAqa2xhc3MsIHZvaWQgKmRhdGEpDQo+
ICAgDQo+ICAgICAgIGRjLT5yZWFsaXplID0gdmZpb19wbGF0Zm9ybV9yZWFsaXplOw0KPiAg
ICAgICBkZXZpY2VfY2xhc3Nfc2V0X3Byb3BzKGRjLCB2ZmlvX3BsYXRmb3JtX2Rldl9wcm9w
ZXJ0aWVzKTsNCj4gLSNpZmRlZiBDT05GSUdfSU9NTVVGRA0KPiAtICAgIG9iamVjdF9jbGFz
c19wcm9wZXJ0eV9hZGRfc3RyKGtsYXNzLCAiZmQiLCBOVUxMLCB2ZmlvX3BsYXRmb3JtX3Nl
dF9mZCk7DQo+IC0jZW5kaWYNCj4gKyAgICBpZiAoaW9tbXVmZF9idWlsdGluKCkpIHsNCj4g
KyAgICAgICAgZGV2aWNlX2NsYXNzX3NldF9wcm9wcyhkYywgdmZpb19wbGF0Zm9ybV9kZXZf
aW9tbXVmZF9wcm9wZXJ0aWVzKTsNCj4gKyAgICAgICAgb2JqZWN0X2NsYXNzX3Byb3BlcnR5
X2FkZF9zdHIoa2xhc3MsICJmZCIsIE5VTEwsIHZmaW9fcGxhdGZvcm1fc2V0X2ZkKTsNCj4g
KyAgICB9DQo+ICAgICAgIGRjLT52bXNkID0gJnZmaW9fcGxhdGZvcm1fdm1zdGF0ZTsNCj4g
ICAgICAgZGMtPmRlc2MgPSAiVkZJTy1iYXNlZCBwbGF0Zm9ybSBkZXZpY2UgYXNzaWdubWVu
dCI7DQo+ICAgICAgIHNiYy0+Y29ubmVjdF9pcnFfbm90aWZpZXIgPSB2ZmlvX3N0YXJ0X2ly
cWZkX2luamVjdGlvbjsNCj4gQEAgLTY5MiwxMSArNjkxLDExIEBAIHN0YXRpYyB2b2lkIHZm
aW9fcGxhdGZvcm1fY2xhc3NfaW5pdChPYmplY3RDbGFzcyAqa2xhc3MsIHZvaWQgKmRhdGEp
DQo+ICAgICAgIG9iamVjdF9jbGFzc19wcm9wZXJ0eV9zZXRfZGVzY3JpcHRpb24oa2xhc3Ms
IC8qIDIuNiAqLw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICJzeXNmc2RldiIsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIkhvc3Qgc3lzZnMgcGF0aCBvZiBhc3NpZ25lZCBkZXZpY2UiKTsNCj4gLSNp
ZmRlZiBDT05GSUdfSU9NTVVGRA0KPiAtICAgIG9iamVjdF9jbGFzc19wcm9wZXJ0eV9zZXRf
ZGVzY3JpcHRpb24oa2xhc3MsIC8qIDkuMCAqLw0KPiAtICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgImlvbW11ZmQiLA0KPiAtICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIlNldCBob3N0IElPTU1VRkQgYmFja2VuZCBkZXZp
Y2UiKTsNCj4gLSNlbmRpZg0KPiArICAgIGlmIChpb21tdWZkX2J1aWx0aW4oKSkgew0KPiAr
ICAgICAgICBvYmplY3RfY2xhc3NfcHJvcGVydHlfc2V0X2Rlc2NyaXB0aW9uKGtsYXNzLCAv
KiA5LjAgKi8NCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAiaW9tbXVmZCIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIlNldCBob3N0IElPTU1VRkQgYmFja2VuZCBkZXZpY2UiKTsNCj4gKyAg
ICB9DQo+ICAgfQ0KPiAgIA0KPiAgIHN0YXRpYyBjb25zdCBUeXBlSW5mbyB2ZmlvX3BsYXRm
b3JtX2Rldl9pbmZvID0gew0KPiBkaWZmIC0tZ2l0IGEvaHcvdmZpby9tZXNvbi5idWlsZCBi
L2h3L3ZmaW8vbWVzb24uYnVpbGQNCj4gaW5kZXggYmQ2ZTFkOTk5ZTQuLmU1MDEwZGIyYzcx
IDEwMDY0NA0KPiAtLS0gYS9ody92ZmlvL21lc29uLmJ1aWxkDQo+ICsrKyBiL2h3L3ZmaW8v
bWVzb24uYnVpbGQNCj4gQEAgLTcsNyArNyw2IEBAIHZmaW9fc3MuYWRkKHdoZW46ICdDT05G
SUdfUFNFUklFUycsIGlmX3RydWU6IGZpbGVzKCdzcGFwci5jJykpDQo+ICAgdmZpb19zcy5h
ZGQod2hlbjogJ0NPTkZJR19WRklPX1BDSScsIGlmX3RydWU6IGZpbGVzKA0KPiAgICAgJ3Bj
aS1xdWlya3MuYycsDQo+ICAgKSkNCj4gLXZmaW9fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJ
T19QTEFURk9STScsIGlmX3RydWU6IGZpbGVzKCdwbGF0Zm9ybS5jJykpDQo+ICAgDQo+ICAg
c3BlY2lmaWNfc3MuYWRkX2FsbCh3aGVuOiAnQ09ORklHX1ZGSU8nLCBpZl90cnVlOiB2Zmlv
X3NzKQ0KPiAgIA0KPiBAQCAtMjYsNiArMjUsNyBAQCBzeXN0ZW1fc3MuYWRkKHdoZW46IFsn
Q09ORklHX1ZGSU8nLCAnQ09ORklHX0lPTU1VRkQnXSwgaWZfdHJ1ZTogZmlsZXMoDQo+ICAg
KSkNCj4gICBzeXN0ZW1fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJT19BUCcsIGlmX3RydWU6
IGZpbGVzKCdhcC5jJykpDQo+ICAgc3lzdGVtX3NzLmFkZCh3aGVuOiAnQ09ORklHX1ZGSU9f
Q0NXJywgaWZfdHJ1ZTogZmlsZXMoJ2Njdy5jJykpDQo+ICtzeXN0ZW1fc3MuYWRkKHdoZW46
ICdDT05GSUdfVkZJT19QTEFURk9STScsIGlmX3RydWU6IGZpbGVzKCdwbGF0Zm9ybS5jJykp
DQo+ICAgc3lzdGVtX3NzLmFkZCh3aGVuOiAnQ09ORklHX1ZGSU9fUENJJywgaWZfdHJ1ZTog
ZmlsZXMoDQo+ICAgICAnZGlzcGxheS5jJywNCj4gICAgICdwY2kuYycsDQoNClJldmlld2Vk
LWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQoN
Cg==

