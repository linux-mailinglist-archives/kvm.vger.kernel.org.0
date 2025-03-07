Return-Path: <kvm+bounces-40407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7134A57176
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A02B43A2B58
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57392517A6;
	Fri,  7 Mar 2025 19:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jigSPGzb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D561241689
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375128; cv=none; b=gtc+Q/sGqa91+Gi+Qg9YujXywnQl9rjdfRcheDmTf2TcDFawfWm7QsfIlk+Qv9315W6oLPKedCZxyk485GqFIHZMv1UdLUdSp0gkI7BPQEjwS3cmyh2panLGJelqDD/uFO11wQfPGsSxu+I6f9l2qXeBqU1OxWCY/uiBtbMkJj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375128; c=relaxed/simple;
	bh=ipNYvIfGy9HCoQoe95qjnIHQHz6NRkZlcZWjnotENhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ou8oFuqtecBp/dww5oVvfit4TDrt+NqvFVI5xkGq3OOzRaAR8plR0fypWnZkxWb9FYN7/g6PQJBFFdYkuEwvqanf69360i3esQj/Dia8wl4fHhU9DisIlygVT7V6GbrqZCovcEh5RyY5Hsyyt1zqdf9Nm1aqurFT8QGAiq8yBBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jigSPGzb; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224191d92e4so38032045ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375126; x=1741979926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipNYvIfGy9HCoQoe95qjnIHQHz6NRkZlcZWjnotENhs=;
        b=jigSPGzbz8gy/wd1zM4h28GYbJI0Qbwcq4fNuXMEf+NHAi3JiRGdaLkbuiF606SSoe
         On4PSvf1oqclRTfUfXZbCud9luRzR2T7NyU57vPK5oveniVDDn80gcXRKnnkSlNGLcNn
         SIk+XMQVEoKDe3UuDQrvV/DMeCv8f4jBWCIaLyJS5xUkWe6Kwk0IEQUQq4OZoFOZIkCZ
         wJQb84gyqfaxrUJUmrHiK37wYEoRyhxdeNLyDoOaoZcYfo25H9BuocDq0Ji0cDMfKigK
         Y8dlsM+SSG/oxe5WROIk1XuTQt3kGG0k12RFWC7zBl+1mfH20eydPkxjL4/Zglqyg+33
         EMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375126; x=1741979926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipNYvIfGy9HCoQoe95qjnIHQHz6NRkZlcZWjnotENhs=;
        b=bdY5qdoad1Fak8TmMpexq7etgeLU21XudNg2JGcIwkMAw02QNRKdbeRiZlRhEoxUPp
         XmItmIYpNEFd7J5PhHndXy1KjLL8BO72g/96vCtgG8Bhp3KUGrHwgY/lraviEHyJN4SU
         LE/KnUz16498BIBZmUnjAlz/vSJycKQVQIgxA/iijEvV26l8X+aKp/otY9c8Nzqhifv9
         83GkO8hNIaIrA0FbiPxHCLnXUm/2wXRYOuoGd3Nv7dMVSR9Tf8X20UwUVV25rTtwTdsj
         lvPCHa8gFmLUdAOYeBmwAuZd+b3IEmOu7cKF4Ygt12wW0ZVZkwqb9hT7lOuUvYfpRaXK
         4TrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPZvrIZTIr0finYJi6Rj2yO9M2Q3CIwrgtL+EBYVAmGoqVcS14eXviA+2xm61oW6hJYhY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeOHMPxfQkwp1ISd9BspOBLyRTmORpcl8O9GpSk5a6lHYPGCND
	LkwQq7LAc0nTDfESCJV0h65se0SuFwNXZlQkGU3V6a2+Srsbu2wQXE9aABLsfIA=
X-Gm-Gg: ASbGnctMP4udvmT8YQPcB1KC9wItpUdj73BwvXBatqc2D/3QzWVwS3KpVowsUt4xef3
	U3jBieck/7GQO9p1lCFhCIZ18N7tUsCUjI80q24b+4Fx2/dDsogYsOEisbMjS50oat+rGDNGiI1
	I4YUsvmMlidNOtrm+EbSWkAQxe91BhLhwDrR3bK0v8oLxajcMIKOTJhGJG/qQXf5kNOc2UH0P7K
	d8N+Z6+wcXxYOTreT2zZ5azk89qckh7PJwAmsDAtMFYVQrzUzdAuLZVMhDrxO40Dgs4JRf3Hz4n
	bvaFuuqoBfGhQO+9OvcRrqbvWF8ltdvTZ1diTeF1LEQ+FBAkebKExthuDg==
X-Google-Smtp-Source: AGHT+IE0ktWZg6kUQjqKpbuS3MyU7bxSsG+GT0spGEIEs+xSxG1l+PxJ1p/cqv6pse/p+Lgki+OoTw==
X-Received: by 2002:a17:902:f547:b0:224:d72:920d with SMTP id d9443c01a7336-22428c056a5mr68176855ad.37.1741375126480;
        Fri, 07 Mar 2025 11:18:46 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e944csm33899445ad.74.2025.03.07.11.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:18:46 -0800 (PST)
Message-ID: <86a37660-51be-4777-8bc0-794efc189a60@linaro.org>
Date: Fri, 7 Mar 2025 11:18:45 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/14] system/iommufd: Introduce iommufd_builtin() helper
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
 <20250307180337.14811-11-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-11-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gaW9t
bXVmZF9idWlsdGluKCkgY2FuIGJlIHVzZWQgdG8gY2hlY2sgYXQgcnVudGltZSB3aGV0aGVy
DQo+IHRoZSBJT01NVUZEIGZlYXR1cmUgaXMgYnVpbHQgaW4gYSBxZW11LXN5c3RlbSBiaW5h
cnkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhp
bG1kQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIGRvY3MvZGV2ZWwvdmZpby1pb21tdWZkLnJz
dCB8IDIgKy0NCj4gICBpbmNsdWRlL3N5c3RlbS9pb21tdWZkLmggICAgfCA4ICsrKysrKysr
DQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kb2NzL2RldmVsL3ZmaW8taW9tbXVmZC5yc3QgYi9kb2Nz
L2RldmVsL3ZmaW8taW9tbXVmZC5yc3QNCj4gaW5kZXggM2QxYzExZjE3NWUuLjA4ODgyMDk0
ZWVlIDEwMDY0NA0KPiAtLS0gYS9kb2NzL2RldmVsL3ZmaW8taW9tbXVmZC5yc3QNCj4gKysr
IGIvZG9jcy9kZXZlbC92ZmlvLWlvbW11ZmQucnN0DQo+IEBAIC04OCw3ICs4OCw3IEBAIFN0
ZXAgMjogY29uZmlndXJlIFFFTVUNCj4gICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAg
DQo+ICAgSW50ZXJhY3Rpb25zIHdpdGggdGhlIGBgL2Rldi9pb21tdWBgIGFyZSBhYnN0cmFj
dGVkIGJ5IGEgbmV3IGlvbW11ZmQNCj4gLW9iamVjdCAoY29tcGlsZWQgaW4gd2l0aCB0aGUg
YGBDT05GSUdfSU9NTVVGRGBgIG9wdGlvbikuDQo+ICtvYmplY3QgKHdoaWNoIGF2YWlsYWJp
bGl0eSBjYW4gYmUgY2hlY2tlZCBhdCBydW50aW1lIHVzaW5nIGBgaW9tbXVmZF9idWlsdGlu
KClgYCkuDQo+ICAgDQo+ICAgQW55IFFFTVUgZGV2aWNlIChlLmcuIFZGSU8gZGV2aWNlKSB3
aXNoaW5nIHRvIHVzZSBgYC9kZXYvaW9tbXVgYCBtdXN0DQo+ICAgYmUgbGlua2VkIHdpdGgg
YW4gaW9tbXVmZCBvYmplY3QuIEl0IGdldHMgYSBuZXcgb3B0aW9uYWwgcHJvcGVydHkNCj4g
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvc3lzdGVtL2lvbW11ZmQuaCBiL2luY2x1ZGUvc3lzdGVt
L2lvbW11ZmQuaA0KPiBpbmRleCBjYmFiNzViZmJmNi4uY2U0NTkyNTQwMjUgMTAwNjQ0DQo+
IC0tLSBhL2luY2x1ZGUvc3lzdGVtL2lvbW11ZmQuaA0KPiArKysgYi9pbmNsdWRlL3N5c3Rl
bS9pb21tdWZkLmgNCj4gQEAgLTYzLDQgKzYzLDEyIEBAIGJvb2wgaW9tbXVmZF9iYWNrZW5k
X2dldF9kaXJ0eV9iaXRtYXAoSU9NTVVGREJhY2tlbmQgKmJlLCB1aW50MzJfdCBod3B0X2lk
LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRXJyb3IgKipl
cnJwKTsNCj4gICANCj4gICAjZGVmaW5lIFRZUEVfSE9TVF9JT01NVV9ERVZJQ0VfSU9NTVVG
RCBUWVBFX0hPU1RfSU9NTVVfREVWSUNFICItaW9tbXVmZCINCj4gKw0KPiArc3RhdGljIGlu
bGluZSBib29sIGlvbW11ZmRfYnVpbHRpbih2b2lkKQ0KPiArew0KPiArICAgIGJvb2wgYW1i
aWcgPSBmYWxzZTsNCj4gKw0KPiArICAgIHJldHVybiBvYmplY3RfcmVzb2x2ZV9wYXRoX3R5
cGUoIiIsIFRZUEVfSU9NTVVGRF9CQUNLRU5ELCAmYW1iaWcpIHx8IGFtYmlnOw0KPiArfQ0K
PiArDQo+ICAgI2VuZGlmDQoNClJldmlld2VkLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVy
cmljay5ib3V2aWVyQGxpbmFyby5vcmc+DQoNCg==

