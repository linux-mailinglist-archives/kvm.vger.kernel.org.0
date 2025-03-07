Return-Path: <kvm+bounces-40406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40378A57172
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D72E16258F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8DB2417D6;
	Fri,  7 Mar 2025 19:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QmB7q7E9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E9D250BE9
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375098; cv=none; b=BiPpqS40qCHx+0d1G1YYTh7BdnrjnmNb9P1D8f1cbM5L8rkyY/uLQ13mKskNLWmyfTLcb913nKJGISdGQ3jS/9KPFINig6SHatES7TiRP3AYvOjBP8OeiD0ad8CDrlyApXki/Hkmz36SuKDwjNpfVHpHDWBhPAHxM1cSWd4Z/WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375098; c=relaxed/simple;
	bh=3p9RAOkMR4+J/NKAAm7eKy2q67QMezwc8dkXu0QQvck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fvVWPYdjnC1f6ZRGlweiVf07/MR0v0QdfWrsSLAYHvAHGO4nwPriikX4cBONjo+saif1u7QmZEUHqJYI4WxmNO5YADqLnfx48bzrmdazTpIHZV5S3JpSnKi9m3XyD0LfSgo8dccP3xYBjaA3Z5SL/UTm5qddm8uFPXCcqit7xJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QmB7q7E9; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22356471820so37830145ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375096; x=1741979896; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3p9RAOkMR4+J/NKAAm7eKy2q67QMezwc8dkXu0QQvck=;
        b=QmB7q7E9B6pvUrUKWkAdf+MfLAmAvAHJu0r6MehEbjsiaogxhMaxFFmXD6qOF3x5/b
         zxOrVLGJt9ZFJ2b4ecJb4U1cvto+lxwRAGIT+3+bW1ZKTMe6lV53m3X8WewVDuzj5rC6
         hPMZdnlQaHRqRtOmIm3LtKosltpmd9QqpvIOw0R9jOCAvyfGpKdGwdAWUAE4H3u1ggLR
         SVgeY0vb9qDrh5hQyOjFgv3OZDZ/reonQVreSlJr26QbEcUA3MnIKAsGJOKHcc37vkkO
         hcRRtZwzxb6kfsoFQtLt5bbns9n1idYU1I/Vi7imlB908cShwl4QVu9jrqd2eaIw1uAt
         z9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375096; x=1741979896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3p9RAOkMR4+J/NKAAm7eKy2q67QMezwc8dkXu0QQvck=;
        b=goqelw6lJX1c0W2Zj9ImieoFQfiwZSUdIndmOdUIvCSJa4enLIwZJkkBteOED2GHVL
         yfUThPPu2D7/fMNGc9KBLY02ti1n8bdt/BwoCRCkINIzuAqlZ8jZeJ9JEzIHgnCh5e8I
         daUkxdpHD4zKNmY5HbHigT5WBqipjaub1wIFUgIB3it60HNeh4d6oi3+Kl/TX8TJfmjb
         guT/VrrHC3u6+LVuoxfZuuVZkv+aiBEfRIhAw5vWvVMghnhGFMrGR+D+mxXEsOLRBONn
         IjXyf8OPG7z6xuVIepFDO9wG2tdr91k7RPeYSVdCG4MV17riBjfmYZQisKhtsEaB7BUC
         z2kA==
X-Forwarded-Encrypted: i=1; AJvYcCV1hHUW0oY4Q5oIhdP26ZQKkltGYK0biowTy0lI+pA183Sql2ubN7OjDIJTcQy+hXT26jk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKQW7NCWUrusF1P+xtMeLQ0SNLZgE2LfOcTBYtuxxJUNhzW3ws
	Fx2UbaYH3v0R0s0uQd+/J57W05iN8w7LuMiw6xhu7CIAag+HdWh5ynIbS63qrVE=
X-Gm-Gg: ASbGncuB4EaX9N8SatkrQa1Pg22ff3GIcL6ESK9cf8LEN7GE+dhYK7dppO00CmOUCJC
	yXNenn9LQMNIX/0PXMcQB7pkYjnrjrRkkCYMM1IUTHDinyI3zUQEq8Z0lgzeyQYU/H5prHScueM
	cf+bg7olxoBdtXw2lkO5z+QGHmAIdrKW2BxzYUYiaygPoaGWzx51p5JoMA8iHSx9QMxq2rI6+bm
	7xzkPG6VdPvQlIxj5ONe9LaWnVmHSp8Rd9VF5LOPRc3+GXs+jNgvsHT8GqMf4wcpw4P44usJu7P
	ujlMs6QoyEL9iHI3IiKGFJlXSJsLrp9r96Y/8d+/QR1MvoBdXqDmJHuJuw==
X-Google-Smtp-Source: AGHT+IFLxvQXq8Q81yznZtKMHT/lFMvLwKw11hMDx5fuvUZsIiMteJnVYk8BhWt8Dqfosdfwi+nC+Q==
X-Received: by 2002:a05:6a20:430a:b0:1f3:48d5:7303 with SMTP id adf61e73a8af0-1f544c5fb2bmr8851480637.31.1741375094961;
        Fri, 07 Mar 2025 11:18:14 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736984f718bsm3635175b3a.85.2025.03.07.11.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:18:14 -0800 (PST)
Message-ID: <a90fa8c1-c804-4359-b1d9-da8aece5a404@linaro.org>
Date: Fri, 7 Mar 2025 11:18:13 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/14] hw/vfio/pci: Convert CONFIG_KVM check to runtime
 one
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
 <20250307180337.14811-10-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gVXNl
IHRoZSBydW50aW1lIGt2bV9lbmFibGVkKCkgaGVscGVyIHRvIGNoZWNrIHdoZXRoZXINCj4g
S1ZNIGlzIGF2YWlsYWJsZSBvciBub3QuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQaGlsaXBw
ZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIGh3L3Zm
aW8vcGNpLmMgfCAxOSArKysrKysrKystLS0tLS0tLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQs
IDkgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
aHcvdmZpby9wY2kuYyBiL2h3L3ZmaW8vcGNpLmMNCj4gaW5kZXggZmRiYzE1ODg1ZDQuLjk4
NzI4ODRmZjhhIDEwMDY0NA0KPiAtLS0gYS9ody92ZmlvL3BjaS5jDQo+ICsrKyBiL2h3L3Zm
aW8vcGNpLmMNCj4gQEAgLTExOCw4ICsxMTgsMTMgQEAgc3RhdGljIHZvaWQgdmZpb19pbnR4
X2VvaShWRklPRGV2aWNlICp2YmFzZWRldikNCj4gICANCj4gICBzdGF0aWMgYm9vbCB2Zmlv
X2ludHhfZW5hYmxlX2t2bShWRklPUENJRGV2aWNlICp2ZGV2LCBFcnJvciAqKmVycnApDQo+
ICAgew0KPiAtI2lmZGVmIENPTkZJR19LVk0NCj4gLSAgICBpbnQgaXJxX2ZkID0gZXZlbnRf
bm90aWZpZXJfZ2V0X2ZkKCZ2ZGV2LT5pbnR4LmludGVycnVwdCk7DQo+ICsgICAgaW50IGly
cV9mZDsNCj4gKw0KPiArICAgIGlmICgha3ZtX2VuYWJsZWQoKSkgew0KPiArICAgICAgICBy
ZXR1cm4gdHJ1ZTsNCj4gKyAgICB9DQo+ICsNCj4gKyAgICBpcnFfZmQgPSBldmVudF9ub3Rp
Zmllcl9nZXRfZmQoJnZkZXYtPmludHguaW50ZXJydXB0KTsNCj4gICANCj4gICAgICAgaWYg
KHZkZXYtPm5vX2t2bV9pbnR4IHx8ICFrdm1faXJxZmRzX2VuYWJsZWQoKSB8fA0KPiAgICAg
ICAgICAgdmRldi0+aW50eC5yb3V0ZS5tb2RlICE9IFBDSV9JTlRYX0VOQUJMRUQgfHwNCj4g
QEAgLTE3MSwxNiArMTc2LDEzIEBAIGZhaWxfaXJxZmQ6DQo+ICAgZmFpbDoNCj4gICAgICAg
cWVtdV9zZXRfZmRfaGFuZGxlcihpcnFfZmQsIHZmaW9faW50eF9pbnRlcnJ1cHQsIE5VTEws
IHZkZXYpOw0KPiAgICAgICB2ZmlvX3VubWFza19zaW5nbGVfaXJxaW5kZXgoJnZkZXYtPnZi
YXNlZGV2LCBWRklPX1BDSV9JTlRYX0lSUV9JTkRFWCk7DQo+ICsNCj4gICAgICAgcmV0dXJu
IGZhbHNlOw0KPiAtI2Vsc2UNCj4gLSAgICByZXR1cm4gdHJ1ZTsNCj4gLSNlbmRpZg0KPiAg
IH0NCj4gICANCj4gICBzdGF0aWMgdm9pZCB2ZmlvX2ludHhfZGlzYWJsZV9rdm0oVkZJT1BD
SURldmljZSAqdmRldikNCj4gICB7DQo+IC0jaWZkZWYgQ09ORklHX0tWTQ0KPiAtICAgIGlm
ICghdmRldi0+aW50eC5rdm1fYWNjZWwpIHsNCj4gKyAgICBpZiAoIWt2bV9lbmFibGVkKCkg
fHwgIXZkZXYtPmludHgua3ZtX2FjY2VsKSB7DQo+ICAgICAgICAgICByZXR1cm47DQo+ICAg
ICAgIH0NCj4gICANCj4gQEAgLTIxMSw3ICsyMTMsNiBAQCBzdGF0aWMgdm9pZCB2ZmlvX2lu
dHhfZGlzYWJsZV9rdm0oVkZJT1BDSURldmljZSAqdmRldikNCj4gICAgICAgdmZpb191bm1h
c2tfc2luZ2xlX2lycWluZGV4KCZ2ZGV2LT52YmFzZWRldiwgVkZJT19QQ0lfSU5UWF9JUlFf
SU5ERVgpOw0KPiAgIA0KPiAgICAgICB0cmFjZV92ZmlvX2ludHhfZGlzYWJsZV9rdm0odmRl
di0+dmJhc2VkZXYubmFtZSk7DQo+IC0jZW5kaWYNCj4gICB9DQo+ICAgDQo+ICAgc3RhdGlj
IHZvaWQgdmZpb19pbnR4X3VwZGF0ZShWRklPUENJRGV2aWNlICp2ZGV2LCBQQ0lJTlR4Um91
dGUgKnJvdXRlKQ0KPiBAQCAtMjc4LDcgKzI3OSw2IEBAIHN0YXRpYyBib29sIHZmaW9faW50
eF9lbmFibGUoVkZJT1BDSURldmljZSAqdmRldiwgRXJyb3IgKiplcnJwKQ0KPiAgICAgICB2
ZGV2LT5pbnR4LnBpbiA9IHBpbiAtIDE7IC8qIFBpbiBBICgxKSAtPiBpcnFbMF0gKi8NCj4g
ICAgICAgcGNpX2NvbmZpZ19zZXRfaW50ZXJydXB0X3Bpbih2ZGV2LT5wZGV2LmNvbmZpZywg
cGluKTsNCj4gICANCj4gLSNpZmRlZiBDT05GSUdfS1ZNDQo+ICAgICAgIC8qDQo+ICAgICAg
ICAqIE9ubHkgY29uZGl0aW9uYWwgdG8gYXZvaWQgZ2VuZXJhdGluZyBlcnJvciBtZXNzYWdl
cyBvbiBwbGF0Zm9ybXMNCj4gICAgICAgICogd2hlcmUgd2Ugd29uJ3QgYWN0dWFsbHkgdXNl
IHRoZSByZXN1bHQgYW55d2F5Lg0KPiBAQCAtMjg3LDcgKzI4Nyw2IEBAIHN0YXRpYyBib29s
IHZmaW9faW50eF9lbmFibGUoVkZJT1BDSURldmljZSAqdmRldiwgRXJyb3IgKiplcnJwKQ0K
PiAgICAgICAgICAgdmRldi0+aW50eC5yb3V0ZSA9IHBjaV9kZXZpY2Vfcm91dGVfaW50eF90
b19pcnEoJnZkZXYtPnBkZXYsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB2ZGV2LT5pbnR4LnBpbik7DQo+ICAgICAgIH0N
Cj4gLSNlbmRpZg0KPiAgIA0KPiAgICAgICByZXQgPSBldmVudF9ub3RpZmllcl9pbml0KCZ2
ZGV2LT5pbnR4LmludGVycnVwdCwgMCk7DQo+ICAgICAgIGlmIChyZXQpIHsNCg0KUmV2aWV3
ZWQtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJvLm9yZz4N
Cg0K

