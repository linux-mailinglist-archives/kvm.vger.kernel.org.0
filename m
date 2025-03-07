Return-Path: <kvm+bounces-40403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E707A57170
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 036FC189C4D0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995C1254851;
	Fri,  7 Mar 2025 19:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dwe8VaJH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A857253336
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374999; cv=none; b=rwmMumv1MwXl6P4xkMHid6exMmID2I/PxQG/wFRxEMCZuJeuSRx2m3dwYWQft6SKf8FvKSb14jCJM3z2XUwQvl93gFkh7IS4yjiKBgWPNnb/AFd0WXj82c2tII2cldZJ6Czc6wpxuhJPHnR4eU1sxLWJ/EBBQHw5BxhYk2XNx2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374999; c=relaxed/simple;
	bh=FcIgjAldmNTlJDpfNudD2honsQ62don2ZnA8aDXXrh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pOWMGqsqSHW12nkMI8mjmOgTbqlHxyINq8+D/97aMXMCefah3NhbkjP3bqN/7JEhw60MX0Bry+Jgz6n5mg+xSqjpCbOesyjtsgarrgh/aJIZ8WZP8F/I7c9C24fhVVv6hivAaMgJ4iGWliydSr54rtLhOIhQ9nNDJ2yd5qtf7z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Dwe8VaJH; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22349bb8605so43688105ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374997; x=1741979797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FcIgjAldmNTlJDpfNudD2honsQ62don2ZnA8aDXXrh8=;
        b=Dwe8VaJHOxPobw6AJmJu0nYf2LnSPif3oj6pmeG+IG6GrBjYQgAgqVbWW4RL9jWxzV
         xaNvzYXSJyP0V7lYEbmL4CHo+tIsHTzpb6d6rIuEOFiwOFGvM5RNRRHE79tEpCcTU6ro
         UGbcS23rRJiu18RNTm6DAIryJBmd0MFaPunqHDjTCQxaYrR8J9N3f71pFld4w8l8Bu20
         OJ4M4QN+GpVUue/4Ls2mmYRJ1QRH0bnAYVHZl8vjv05HibMIclAmoRC25FST3yQHnvOg
         TndVWj97FK++Gj4Ul2+sucDbSzs+9AOfnrNeinv2aVpD2scftOvhsx0sTU5zPd3UMJ9C
         hs5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374997; x=1741979797;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcIgjAldmNTlJDpfNudD2honsQ62don2ZnA8aDXXrh8=;
        b=j6t+kjIh7Z5rDQtv/d56ip+dhSuSsCq9fzaNvlFU13BXdiTspyzpho4DkjqHJL81tU
         0DjEiDE7VurOXeBtF2bVDZZgSnXiFOJmb7VewEDlQZTp4ALfFCBqQEfYMY55VvN1diTj
         JDhRCcR0I9FWyI9zRA1Xxrhu5c0QL9iis4Ho9Tf70hoOczlJyWaKQbSOWxRxHwNO33qJ
         qawb7lN73lIdekVz1TTW4RLOqsE44XxG+nU5X/rjflSxVQBUmgPlZaX+NgfMi/RKrtYo
         KIVXPbPuGBH8ANocngOmmyGSnVjlbzq5XL9rCjiux7nzgmyeZCPZ5Uz4azWRVR4NVntH
         L4Dg==
X-Forwarded-Encrypted: i=1; AJvYcCVHsyKx59rjpzms+lU7esn76n2InMRFSEA5lpe0JHnvCS7E8HaE2XFP6fzWY0ZKRe3+lPU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx7r1NlVklo3XkpcavyWXlnwpaba3Jc6+Qh2LYIznGQr4AY+jP
	6ZXmxSqBVpdJuefWgxrlOc65l/8PFaz4vHXrlwBSIZQ0iHTaTxAHcY5VPJkB+74=
X-Gm-Gg: ASbGncviXzW2YKKKBrqrABzpjVvA3l2HGCrzhK/bmD4FKL2x0/XlsXXb0O5IKeWJ3BF
	7R7JK+FU94OzUqGU1XpwQ2lNpLMQrZQn1+KiHL9wQRwsZViKu0u7gtthq2xPQKJ02iFvBtaetwz
	asTbQKOl9AQNg4zfbBIBkElHe09laq24Ik/NhLmDaiOaZ3CLQy+/2titbnxCxfFcis3QluFNeVY
	hhX/iqlWAppsLDbsZQmO8eirXPRfElmSBF0RYcyLqZjnJohrKWKxmBvbC1xt69tojyRfyishHiz
	6k2vATISBZ9qMlnoTIpdlDI2AxkeN3VK4Gt8LIwdYUV3EV69DM2t7I8J7g==
X-Google-Smtp-Source: AGHT+IFFcAeOjTAjMG3Bag0rUEEDFXr56Mdr47n7HVur2E3bT9phCmlclPDwElxI5OB8yT4Xtbu8iQ==
X-Received: by 2002:a17:903:234f:b0:224:18bb:44c2 with SMTP id d9443c01a7336-22428881fcfmr61990885ad.6.1741374997529;
        Fri, 07 Mar 2025 11:16:37 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410abb088sm33771545ad.256.2025.03.07.11.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:16:37 -0800 (PST)
Message-ID: <a817e24e-c7b2-45e9-9cd1-81f24465015b@linaro.org>
Date: Fri, 7 Mar 2025 11:16:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/14] system: Declare qemu_[min/max]rampagesize() in
 'system/hostmem.h'
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
 <20250307180337.14811-7-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gQm90
aCBxZW11X21pbnJhbXBhZ2VzaXplKCkgYW5kIHFlbXVfbWF4cmFtcGFnZXNpemUoKSBhcmUN
Cj4gcmVsYXRlZCB0byBob3N0IG1lbW9yeSBiYWNrZW5kcy4gTW92ZSB0aGVpciBwcm90b3R5
cGUNCj4gZGVjbGFyYXRpb24gdG8gInN5c3RlbS9ob3N0bWVtLmgiLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPg0K
PiAtLS0NCj4gICBpbmNsdWRlL2V4ZWMvcmFtX2FkZHIuaCAgICB8IDMgLS0tDQo+ICAgaW5j
bHVkZS9zeXN0ZW0vaG9zdG1lbS5oICAgfCAzICsrKw0KPiAgIGh3L3BwYy9zcGFwcl9jYXBz
LmMgICAgICAgIHwgMSArDQo+ICAgaHcvczM5MHgvczM5MC12aXJ0aW8tY2N3LmMgfCAxICsN
Cj4gICBody92ZmlvL3NwYXByLmMgICAgICAgICAgICB8IDEgKw0KPiAgIDUgZmlsZXMgY2hh
bmdlZCwgNiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2luY2x1ZGUvZXhlYy9yYW1fYWRkci5oIGIvaW5jbHVkZS9leGVjL3JhbV9hZGRyLmgN
Cj4gaW5kZXggOTRiYjNjY2JlNDIuLmNjYzhkZjU2MWFmIDEwMDY0NA0KPiAtLS0gYS9pbmNs
dWRlL2V4ZWMvcmFtX2FkZHIuaA0KPiArKysgYi9pbmNsdWRlL2V4ZWMvcmFtX2FkZHIuaA0K
PiBAQCAtMTAxLDkgKzEwMSw2IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBpbnQg
cmFtYmxvY2tfcmVjdl9iaXRtYXBfb2Zmc2V0KHZvaWQgKmhvc3RfYWRkciwNCj4gICANCj4g
ICBib29sIHJhbWJsb2NrX2lzX3BtZW0oUkFNQmxvY2sgKnJiKTsNCj4gICANCj4gLWxvbmcg
cWVtdV9taW5yYW1wYWdlc2l6ZSh2b2lkKTsNCj4gLWxvbmcgcWVtdV9tYXhyYW1wYWdlc2l6
ZSh2b2lkKTsNCj4gLQ0KPiAgIC8qKg0KPiAgICAqIHFlbXVfcmFtX2FsbG9jX2Zyb21fZmls
ZSwNCj4gICAgKiBxZW11X3JhbV9hbGxvY19mcm9tX2ZkOiAgQWxsb2NhdGUgYSByYW0gYmxv
Y2sgZnJvbSB0aGUgc3BlY2lmaWVkIGJhY2tpbmcNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
c3lzdGVtL2hvc3RtZW0uaCBiL2luY2x1ZGUvc3lzdGVtL2hvc3RtZW0uaA0KPiBpbmRleCA1
YzIxY2E1NWMwMS4uNjI2NDJlNjAyY2EgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvc3lzdGVt
L2hvc3RtZW0uaA0KPiArKysgYi9pbmNsdWRlL3N5c3RlbS9ob3N0bWVtLmgNCj4gQEAgLTkz
LDQgKzkzLDcgQEAgYm9vbCBob3N0X21lbW9yeV9iYWNrZW5kX2lzX21hcHBlZChIb3N0TWVt
b3J5QmFja2VuZCAqYmFja2VuZCk7DQo+ICAgc2l6ZV90IGhvc3RfbWVtb3J5X2JhY2tlbmRf
cGFnZXNpemUoSG9zdE1lbW9yeUJhY2tlbmQgKm1lbWRldik7DQo+ICAgY2hhciAqaG9zdF9t
ZW1vcnlfYmFja2VuZF9nZXRfbmFtZShIb3N0TWVtb3J5QmFja2VuZCAqYmFja2VuZCk7DQo+
ICAgDQo+ICtsb25nIHFlbXVfbWlucmFtcGFnZXNpemUodm9pZCk7DQo+ICtsb25nIHFlbXVf
bWF4cmFtcGFnZXNpemUodm9pZCk7DQo+ICsNCj4gICAjZW5kaWYNCj4gZGlmZiAtLWdpdCBh
L2h3L3BwYy9zcGFwcl9jYXBzLmMgYi9ody9wcGMvc3BhcHJfY2Fwcy5jDQo+IGluZGV4IDkw
NGJmZjg3Y2UxLi45ZTUzZDBjMWZkMSAxMDA2NDQNCj4gLS0tIGEvaHcvcHBjL3NwYXByX2Nh
cHMuYw0KPiArKysgYi9ody9wcGMvc3BhcHJfY2Fwcy5jDQo+IEBAIC0zNCw2ICszNCw3IEBA
DQo+ICAgI2luY2x1ZGUgImt2bV9wcGMuaCINCj4gICAjaW5jbHVkZSAibWlncmF0aW9uL3Zt
c3RhdGUuaCINCj4gICAjaW5jbHVkZSAic3lzdGVtL3RjZy5oIg0KPiArI2luY2x1ZGUgInN5
c3RlbS9ob3N0bWVtLmgiDQo+ICAgDQo+ICAgI2luY2x1ZGUgImh3L3BwYy9zcGFwci5oIg0K
PiAgIA0KPiBkaWZmIC0tZ2l0IGEvaHcvczM5MHgvczM5MC12aXJ0aW8tY2N3LmMgYi9ody9z
MzkweC9zMzkwLXZpcnRpby1jY3cuYw0KPiBpbmRleCA1MWFlMGMxMzNkOC4uMTI2MWQ5M2I3
Y2UgMTAwNjQ0DQo+IC0tLSBhL2h3L3MzOTB4L3MzOTAtdmlydGlvLWNjdy5jDQo+ICsrKyBi
L2h3L3MzOTB4L3MzOTAtdmlydGlvLWNjdy5jDQo+IEBAIC00MSw2ICs0MSw3IEBADQo+ICAg
I2luY2x1ZGUgImh3L3MzOTB4L3RvZC5oIg0KPiAgICNpbmNsdWRlICJzeXN0ZW0vc3lzdGVt
LmgiDQo+ICAgI2luY2x1ZGUgInN5c3RlbS9jcHVzLmgiDQo+ICsjaW5jbHVkZSAic3lzdGVt
L2hvc3RtZW0uaCINCj4gICAjaW5jbHVkZSAidGFyZ2V0L3MzOTB4L2t2bS9wdi5oIg0KPiAg
ICNpbmNsdWRlICJtaWdyYXRpb24vYmxvY2tlci5oIg0KPiAgICNpbmNsdWRlICJxYXBpL3Zp
c2l0b3IuaCINCj4gZGlmZiAtLWdpdCBhL2h3L3ZmaW8vc3BhcHIuYyBiL2h3L3ZmaW8vc3Bh
cHIuYw0KPiBpbmRleCA5YjVhZDA1YmIxYy4uMWE1ZDE2MTFmMmMgMTAwNjQ0DQo+IC0tLSBh
L2h3L3ZmaW8vc3BhcHIuYw0KPiArKysgYi9ody92ZmlvL3NwYXByLmMNCj4gQEAgLTEyLDYg
KzEyLDcgQEANCj4gICAjaW5jbHVkZSA8c3lzL2lvY3RsLmg+DQo+ICAgI2luY2x1ZGUgPGxp
bnV4L3ZmaW8uaD4NCj4gICAjaW5jbHVkZSAic3lzdGVtL2t2bS5oIg0KPiArI2luY2x1ZGUg
InN5c3RlbS9ob3N0bWVtLmgiDQo+ICAgI2luY2x1ZGUgImV4ZWMvYWRkcmVzcy1zcGFjZXMu
aCINCj4gICANCj4gICAjaW5jbHVkZSAiaHcvdmZpby92ZmlvLWNvbW1vbi5oIg0KDQpSZXZp
ZXdlZC1ieTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3Jn
Pg0KDQo=

