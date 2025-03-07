Return-Path: <kvm+bounces-40408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5FAA57179
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ABA33AA7F8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4818E256C94;
	Fri,  7 Mar 2025 19:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bCnnCK4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAC12512C9
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375150; cv=none; b=o4R1EINPaQOoT1IAJzdYDeEA78JPQg3TqylW9m/dT2En6Uq72Uv56HZq8ZtGr07pKZYyMoadsOmKCU8FGZGXp1yBUWEdQ0xXNC9Ew/12MHxgzCQ8e40iYNEaaGGX6/XAbu85r93gRSVwZzsFy2PcJOiBWm0omXtaHZ4pQAwJIQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375150; c=relaxed/simple;
	bh=EL9ev4fYnuwjSp/gbtmrkNBbADrSXP4Qa9leqBRx5eY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U2LdGtXmwnTBb6wOmopxAei6ddVwv0zx5OIBV67wEbCkVDQPpK9U6SEFdSXlR4GzIjbYkOZvQWRHs/Wcc5xuWadl/knULobnbXtpuOz3ZzS+2cAPQmjjluC6CZy33dWbq2DRJONlnnAbrf6klw/yzWXpLLC7w/JbUz9YJUwF2Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bCnnCK4x; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22356471820so37842635ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375148; x=1741979948; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EL9ev4fYnuwjSp/gbtmrkNBbADrSXP4Qa9leqBRx5eY=;
        b=bCnnCK4x2fHjQ/M65WdHYyR7YdSFR2nTRRDz+6m4NF3rpF1X/AIuJ6mEYC5Sp5uCTG
         ZW+u2tp93fBo4g1dGdP+0kYUroE2H8haqBJ64UQhjTYtK71FUXoLaC1nnmky+llmWHJi
         8qska1xL36p7ISD3Qnt8rF0RnWyB7WYJX8mTvwX37p+2FOJsI8TUPNNVEcDHrbYnljnO
         YONKZWolBRWpwE47Llut9dcHYK+2vXOckzDeF7lmC+h/+4gRYeDtQBHe85IcUAkHv4L8
         2k+swa2hf2+Xe1mj8htKZr8PrThKgBxD7PAe+VHcmQ7GRYYjZsPaknCp7U3F2SayyyXu
         7PNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375148; x=1741979948;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EL9ev4fYnuwjSp/gbtmrkNBbADrSXP4Qa9leqBRx5eY=;
        b=vT7GuQbo6gCK3ZIv3YP63pqCDMHE8i0lvXzAZ/ln6h8ttL7MRiXMJga9t+B3hKG/LK
         m9NCJzxMLHm1i7IfQ5DecaKrPBRuUOlWKTrKf+0skc5qXT1UyFsER3PzmtfQZ2vFj8oD
         y2sgmLLMnZuGNia7HbWnzSAcEgPg/l5UDOnfv9d3tRvnFr1xx+kK3dm06og1aSmcFjik
         s0z0n9NAkjB9HFnm2dYeMjN2viUE9nlPKyevwxVDYnm2+/UNoIwAMymwbart42UD8RIP
         sIEEyXNR4l4bLrNb8Hh61Kw28DT6PJ6bXqhDkKo4axe5MhZdaxjL7XO5W2/yveXVsrHv
         Hk6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDUF44ZmnJ5bqXPcAVTTwkzJ9qvQ9P8Za4eAmNtdQhul6XyfPxzokG/TIFyJk7M8/fIys=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgWEeiIzyceYJ52DCJDlTtpciw80GJGqM11WO5XVPeJAMWcDPD
	ke3ZwlXxOmbp7aqJJZJo+z52L8yA+ItDf+NI3AEAd/SQ1RSqTiEOb0krIr4k0i4=
X-Gm-Gg: ASbGnctXC2k1r5z1PgioDfJr0XRDu6ZC6FfPftRZapnyzb2Bc24dhuTVgecotXWFVCG
	HMxzsyHiuKK+k/5C9yW4MHTfsgTZIbBEfcVHo63R1AmLEAQF/02frXKB+mbV+71a8OYa4IKv4Qw
	FhoWlvI1kvU+FibEREIlVMVnu9zFlgEqieRRK2Oy8gBf+L1hc+egd2kqiWxP87vo9w/KDnLdWGz
	PC6BJZhYGRgT8aJvCO5IdtBYGGOnKAyosvh9zPkT9izbvlUgK6HMAn1eKWjhi646tfwjJK3rjMm
	5xtKuNuR7T6iZR+gyTcSQNuiUi35hsQSVcL6lIseg0Pfkc8Avhv/M98CZw==
X-Google-Smtp-Source: AGHT+IGmifsCw1FrIn9vrgcuI8mwFfE3GFR/kzOuNybbE/PFBGf19XE5D9LoWY3OgbblqUkVIuE0fw==
X-Received: by 2002:a05:6a00:4b4a:b0:736:5753:12f7 with SMTP id d2e1a72fcca58-736aa9b9741mr7490231b3a.3.1741375147975;
        Fri, 07 Mar 2025 11:19:07 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736984f723asm3739928b3a.96.2025.03.07.11.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:19:07 -0800 (PST)
Message-ID: <0c70440f-675f-472b-a684-3cb8424715d4@linaro.org>
Date: Fri, 7 Mar 2025 11:19:06 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/14] hw/vfio/pci: Check CONFIG_IOMMUFD at runtime using
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
 <20250307180337.14811-12-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-12-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gQ29u
dmVydCB0aGUgY29tcGlsZSB0aW1lIGNoZWNrIG9uIHRoZSBDT05GSUdfSU9NTVVGRCBkZWZp
bml0aW9uDQo+IGJ5IGEgcnVudGltZSBvbmUgYnkgY2FsbGluZyBpb21tdWZkX2J1aWx0aW4o
KS4NCj4gDQo+IFNpbmNlIHRoZSBmaWxlIGRvZXNuJ3QgdXNlIGFueSB0YXJnZXQtc3BlY2lm
aWMga25vd2xlZGdlIGFueW1vcmUsDQo+IG1vdmUgaXQgdG8gc3lzdGVtX3NzW10gdG8gYnVp
bGQgaXQgb25jZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1
ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4NCj4gLS0tDQo+ICAgaHcvdmZpby9wY2kuYyAgICAg
ICB8IDM4ICsrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAgaHcv
dmZpby9tZXNvbi5idWlsZCB8ICAyICstDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNl
cnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9ody92Zmlv
L3BjaS5jIGIvaHcvdmZpby9wY2kuYw0KPiBpbmRleCA5ODcyODg0ZmY4YS4uZTgzMjUyNzY2
ZDEgMTAwNjQ0DQo+IC0tLSBhL2h3L3ZmaW8vcGNpLmMNCj4gKysrIGIvaHcvdmZpby9wY2ku
Yw0KPiBAQCAtMTksNyArMTksNiBAQA0KPiAgICAqLw0KPiAgIA0KPiAgICNpbmNsdWRlICJx
ZW11L29zZGVwLmgiDQo+IC0jaW5jbHVkZSBDT05GSUdfREVWSUNFUyAvKiBDT05GSUdfSU9N
TVVGRCAqLw0KPiAgICNpbmNsdWRlIDxsaW51eC92ZmlvLmg+DQo+ICAgI2luY2x1ZGUgPHN5
cy9pb2N0bC5oPg0KPiAgIA0KPiBAQCAtMjk3MywxMSArMjk3MiwxMCBAQCBzdGF0aWMgdm9p
ZCB2ZmlvX3JlYWxpemUoUENJRGV2aWNlICpwZGV2LCBFcnJvciAqKmVycnApDQo+ICAgICAg
ICAgICBpZiAoISh+dmRldi0+aG9zdC5kb21haW4gfHwgfnZkZXYtPmhvc3QuYnVzIHx8DQo+
ICAgICAgICAgICAgICAgICB+dmRldi0+aG9zdC5zbG90IHx8IH52ZGV2LT5ob3N0LmZ1bmN0
aW9uKSkgew0KPiAgICAgICAgICAgICAgIGVycm9yX3NldGcoZXJycCwgIk5vIHByb3ZpZGVk
IGhvc3QgZGV2aWNlIik7DQo+IC0gICAgICAgICAgICBlcnJvcl9hcHBlbmRfaGludChlcnJw
LCAiVXNlIC1kZXZpY2UgdmZpby1wY2ksaG9zdD1EREREOkJCOkRELkYgIg0KPiAtI2lmZGVm
IENPTkZJR19JT01NVUZEDQo+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAib3Ig
LWRldmljZSB2ZmlvLXBjaSxmZD1ERVZJQ0VfRkQgIg0KPiAtI2VuZGlmDQo+IC0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAib3IgLWRldmljZSB2ZmlvLXBjaSxzeXNmc2Rldj1Q
QVRIX1RPX0RFVklDRVxuIik7DQo+ICsgICAgICAgICAgICBlcnJvcl9hcHBlbmRfaGludChl
cnJwLCAiVXNlIC1kZXZpY2UgdmZpby1wY2ksaG9zdD1EREREOkJCOkRELkYgJXMiDQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAib3IgLWRldmljZSB2ZmlvLXBjaSxzeXNm
c2Rldj1QQVRIX1RPX0RFVklDRVxuIiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGlvbW11ZmRfYnVpbHRpbigpDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICA/ICJvciAtZGV2aWNlIHZmaW8tcGNpLGZkPURFVklDRV9GRCAiIDogIiIpOw0KPiAgICAg
ICAgICAgICAgIHJldHVybjsNCj4gICAgICAgICAgIH0NCj4gICAgICAgICAgIHZiYXNlZGV2
LT5zeXNmc2RldiA9DQo+IEBAIC0zNDEyLDE5ICszNDEwLDE4IEBAIHN0YXRpYyBjb25zdCBQ
cm9wZXJ0eSB2ZmlvX3BjaV9kZXZfcHJvcGVydGllc1tdID0gew0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgcWRldl9wcm9wX252X2dwdWRpcmVjdF9jbGlxdWUs
IHVpbnQ4X3QpLA0KPiAgICAgICBERUZJTkVfUFJPUF9PRkZfQVVUT19QQ0lCQVIoIngtbXNp
eC1yZWxvY2F0aW9uIiwgVkZJT1BDSURldmljZSwgbXNpeF9yZWxvLA0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgT0ZGX0FVVE9fUENJQkFSX09GRiksDQo+IC0jaWZk
ZWYgQ09ORklHX0lPTU1VRkQNCj4gLSAgICBERUZJTkVfUFJPUF9MSU5LKCJpb21tdWZkIiwg
VkZJT1BDSURldmljZSwgdmJhc2VkZXYuaW9tbXVmZCwNCj4gLSAgICAgICAgICAgICAgICAg
ICAgIFRZUEVfSU9NTVVGRF9CQUNLRU5ELCBJT01NVUZEQmFja2VuZCAqKSwNCj4gLSNlbmRp
Zg0KPiAgICAgICBERUZJTkVfUFJPUF9CT09MKCJza2lwLXZzYy1jaGVjayIsIFZGSU9QQ0lE
ZXZpY2UsIHNraXBfdnNjX2NoZWNrLCB0cnVlKSwNCj4gICB9Ow0KPiAgIA0KPiAtI2lmZGVm
IENPTkZJR19JT01NVUZEDQo+ICtzdGF0aWMgY29uc3QgUHJvcGVydHkgdmZpb19wY2lfZGV2
X2lvbW11ZmRfcHJvcGVydGllc1tdID0gew0KPiArICAgIERFRklORV9QUk9QX0xJTksoImlv
bW11ZmQiLCBWRklPUENJRGV2aWNlLCB2YmFzZWRldi5pb21tdWZkLA0KPiArICAgICAgICAg
ICAgICAgICAgICAgVFlQRV9JT01NVUZEX0JBQ0tFTkQsIElPTU1VRkRCYWNrZW5kICopLA0K
PiArfTsNCj4gKw0KPiAgIHN0YXRpYyB2b2lkIHZmaW9fcGNpX3NldF9mZChPYmplY3QgKm9i
aiwgY29uc3QgY2hhciAqc3RyLCBFcnJvciAqKmVycnApDQo+ICAgew0KPiAgICAgICB2Zmlv
X2RldmljZV9zZXRfZmQoJlZGSU9fUENJKG9iaiktPnZiYXNlZGV2LCBzdHIsIGVycnApOw0K
PiAgIH0NCj4gLSNlbmRpZg0KPiAgIA0KPiAgIHN0YXRpYyB2b2lkIHZmaW9fcGNpX2Rldl9j
bGFzc19pbml0KE9iamVjdENsYXNzICprbGFzcywgdm9pZCAqZGF0YSkNCj4gICB7DQo+IEBA
IC0zNDMzLDkgKzM0MzAsMTAgQEAgc3RhdGljIHZvaWQgdmZpb19wY2lfZGV2X2NsYXNzX2lu
aXQoT2JqZWN0Q2xhc3MgKmtsYXNzLCB2b2lkICpkYXRhKQ0KPiAgIA0KPiAgICAgICBkZXZp
Y2VfY2xhc3Nfc2V0X2xlZ2FjeV9yZXNldChkYywgdmZpb19wY2lfcmVzZXQpOw0KPiAgICAg
ICBkZXZpY2VfY2xhc3Nfc2V0X3Byb3BzKGRjLCB2ZmlvX3BjaV9kZXZfcHJvcGVydGllcyk7
DQo+IC0jaWZkZWYgQ09ORklHX0lPTU1VRkQNCj4gLSAgICBvYmplY3RfY2xhc3NfcHJvcGVy
dHlfYWRkX3N0cihrbGFzcywgImZkIiwgTlVMTCwgdmZpb19wY2lfc2V0X2ZkKTsNCj4gLSNl
bmRpZg0KPiArICAgIGlmIChpb21tdWZkX2J1aWx0aW4oKSkgew0KPiArICAgICAgICBkZXZp
Y2VfY2xhc3Nfc2V0X3Byb3BzKGRjLCB2ZmlvX3BjaV9kZXZfaW9tbXVmZF9wcm9wZXJ0aWVz
KTsNCj4gKyAgICAgICAgb2JqZWN0X2NsYXNzX3Byb3BlcnR5X2FkZF9zdHIoa2xhc3MsICJm
ZCIsIE5VTEwsIHZmaW9fcGNpX3NldF9mZCk7DQo+ICsgICAgfQ0KPiAgICAgICBkYy0+ZGVz
YyA9ICJWRklPLWJhc2VkIFBDSSBkZXZpY2UgYXNzaWdubWVudCI7DQo+ICAgICAgIHNldF9i
aXQoREVWSUNFX0NBVEVHT1JZX01JU0MsIGRjLT5jYXRlZ29yaWVzKTsNCj4gICAgICAgcGRj
LT5yZWFsaXplID0gdmZpb19yZWFsaXplOw0KPiBAQCAtMzU0MCwxMSArMzUzOCwxMSBAQCBz
dGF0aWMgdm9pZCB2ZmlvX3BjaV9kZXZfY2xhc3NfaW5pdChPYmplY3RDbGFzcyAqa2xhc3Ms
IHZvaWQgKmRhdGEpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgInZmLXRva2VuIiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAiU3BlY2lmeSBVVUlEIFZGIHRva2VuLiBSZXF1aXJlZCBmb3IgVkYgd2hl
biBQRiBpcyBvd25lZCAiDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgImJ5IGFub3RoZXIgVkZJTyBkcml2ZXIiKTsNCj4gLSNpZmRlZiBDT05GSUdf
SU9NTVVGRA0KPiAtICAgIG9iamVjdF9jbGFzc19wcm9wZXJ0eV9zZXRfZGVzY3JpcHRpb24o
a2xhc3MsIC8qIDkuMCAqLw0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgImlvbW11ZmQiLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIlNldCBob3N0IElPTU1VRkQgYmFja2VuZCBkZXZpY2UiKTsNCj4gLSNl
bmRpZg0KPiArICAgIGlmIChpb21tdWZkX2J1aWx0aW4oKSkgew0KPiArICAgICAgICBvYmpl
Y3RfY2xhc3NfcHJvcGVydHlfc2V0X2Rlc2NyaXB0aW9uKGtsYXNzLCAvKiA5LjAgKi8NCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiaW9tbXVm
ZCIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IlNldCBob3N0IElPTU1VRkQgYmFja2VuZCBkZXZpY2UiKTsNCj4gKyAgICB9DQo+ICAgICAg
IG9iamVjdF9jbGFzc19wcm9wZXJ0eV9zZXRfZGVzY3JpcHRpb24oa2xhc3MsIC8qIDkuMSAq
Lw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJ4LWRl
dmljZS1kaXJ0eS1wYWdlLXRyYWNraW5nIiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAiRGlzYWJsZSBkZXZpY2UgZGlydHkgcGFnZSB0cmFja2lu
ZyBhbmQgdXNlICINCj4gZGlmZiAtLWdpdCBhL2h3L3ZmaW8vbWVzb24uYnVpbGQgYi9ody92
ZmlvL21lc29uLmJ1aWxkDQo+IGluZGV4IDk2ZTM0MmFhOGNiLi45YTAwNDk5MmMxMSAxMDA2
NDQNCj4gLS0tIGEvaHcvdmZpby9tZXNvbi5idWlsZA0KPiArKysgYi9ody92ZmlvL21lc29u
LmJ1aWxkDQo+IEBAIC02LDcgKzYsNiBAQCB2ZmlvX3NzLmFkZChmaWxlcygNCj4gICB2Zmlv
X3NzLmFkZCh3aGVuOiAnQ09ORklHX1BTRVJJRVMnLCBpZl90cnVlOiBmaWxlcygnc3BhcHIu
YycpKQ0KPiAgIHZmaW9fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJT19QQ0knLCBpZl90cnVl
OiBmaWxlcygNCj4gICAgICdwY2ktcXVpcmtzLmMnLA0KPiAtICAncGNpLmMnLA0KPiAgICkp
DQo+ICAgdmZpb19zcy5hZGQod2hlbjogJ0NPTkZJR19WRklPX0NDVycsIGlmX3RydWU6IGZp
bGVzKCdjY3cuYycpKQ0KPiAgIHZmaW9fc3MuYWRkKHdoZW46ICdDT05GSUdfVkZJT19QTEFU
Rk9STScsIGlmX3RydWU6IGZpbGVzKCdwbGF0Zm9ybS5jJykpDQo+IEBAIC0yOSw0ICsyOCw1
IEBAIHN5c3RlbV9zcy5hZGQod2hlbjogWydDT05GSUdfVkZJTycsICdDT05GSUdfSU9NTVVG
RCddLCBpZl90cnVlOiBmaWxlcygNCj4gICApKQ0KPiAgIHN5c3RlbV9zcy5hZGQod2hlbjog
J0NPTkZJR19WRklPX1BDSScsIGlmX3RydWU6IGZpbGVzKA0KPiAgICAgJ2Rpc3BsYXkuYycs
DQo+ICsgICdwY2kuYycsDQo+ICAgKSkNCg0KUmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZp
ZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4NCg0K

