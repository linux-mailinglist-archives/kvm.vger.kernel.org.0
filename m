Return-Path: <kvm+bounces-40405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B30D0A57173
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:20:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FA65189C38D
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955C0255E2F;
	Fri,  7 Mar 2025 19:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dECJcS25"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D645254B11
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375053; cv=none; b=abQUAiIa65g6YcdnncFFtn5R7v38zBYdZhqZNgeL1IPiE9mn+PxBnRI/wwhe2WbuhRPINA3bGP06QwthLFHBjiy7nweKE/YO3ie4rJhBuUSgrh7Ban+Mq79w0mCrIrY3gA4j1KRVxrKQk3vU/qWlUtmRUl5Qxsb1TKAS602MPH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375053; c=relaxed/simple;
	bh=BPLqVn8VYFNzc949TxsQE1MT5WiJdnycfU2e++TtZnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZ9SdBgn3x+8/h/1cHtFP6YzlFNuvu62B7w6/ZYo5sGzG2Ys8f5l0Jh14FPipHrIt4mBcNB2Qq0ynhejhBmuVdHS+usf0tPOpXnYjGh5M/TMTEZxsNW8zli79+X9vRzbl3UT/pOumcrs8gqBhGI0W8QjP5pBXV27dyIajCk1BAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dECJcS25; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22349bb8605so43700665ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375051; x=1741979851; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BPLqVn8VYFNzc949TxsQE1MT5WiJdnycfU2e++TtZnQ=;
        b=dECJcS25DHylJREl23INnLcnWmX5WxPRflR2EM35Fd0cs2Y1RDiSYZBxn6iuh13cuY
         x15jqqHDjJHWpQhfEbgjwjcXqzEWutJgkGBWUAU/3c5xM3Zm6pL5KWsxEWf/bSpZpkle
         fT5t1eDgmPhLt4U1muBn6SEzKbPXTFyzL4Iy9utaQMnEfgGhCkGWpLKXh2WC6Tgps1yF
         dVSNnUL7cqdj9IlYovMmhMbdCW5PYL5kf4aXhNtFdy8FU8Cks1uFH4sFkq4+Nvf2q90Y
         K+Ns63HpfTpQo4XmxxEeL2jaIRLqXjBNIvPqGpmqvK9wRAspOLsnQpa0C/jaMJkaUO+l
         sZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375051; x=1741979851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BPLqVn8VYFNzc949TxsQE1MT5WiJdnycfU2e++TtZnQ=;
        b=gOLn2Teixbhz7P8rRt/Ko56Qv2fkh8ufjX2vyxbhQ9nXa6NX1HCIrmVdJ/uklt08Ts
         VTT9+utILk8mOr+fH2Vorgxrx6yKmoBQ5he66hKJvqx2qOYEyWbJh9aNtRZmyS71vlK6
         0RQT79KH7I7IVMeX6LoMUOpPZoWsfuU5XF37NMMK3qc6fBQ8WOo5B69kIVufe0u+js2m
         bVjsBZHV8UB08yH2Ve6pPOpwt2wBwkZhyspuuSDOPX/rDVl5CuZzSETUR+0QTmN+chMy
         HeOq7/ropUgqi+2aImeAT2PFVuNPl7CwozoKZDx18RjxfknDjF1ul8O+kX25YGFgRIia
         aFHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOvT7l890pF6/CD2ruPV7OUmwBFIx8sb4/19AdAEkjZ+vo3k5AjvklbVSPMske1B5UA4k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5vcQEV8if6qsA10APXFYy4FqrUVTMkJkeWICKAcNx8WvYYE7R
	CycUSFwOaFg2oT0gdTbR6G+m86tmBDOu/jQz9j629/Lv5qHcK8tHxiWEwyk5+bs=
X-Gm-Gg: ASbGnct7cHp0hIEGeRnJte5BH6KFlGBPDvj9I7IQ1FPUoYIL8V16pk75m9iLb01eRKr
	CUAFb3ddTbYfWtBoaqKIFJ2lBGIdHRjWJ/hyLoGw9FaSyLSvrrrlHs8TNySaiZjedoyeLfw4P7u
	JdbkrvEq/0aKZfrTqnRKeCpYWXiuIgZHGqmgEZreayNb6ba5JIe5s3Fm9DcbVL5Zjy3sNQK1Wf+
	5KVQpmDP8lSl/zDHuPjrBxPohWKpyMohX263p9rVJxKhr8ikwZ5m6Uzknn/f1bG6cdEMPaIAfUx
	9/ThSkcE1/n1JjDGQViZ6mwF4uRlqNQgBeCJ8lsPwROBET8xsgBquVeWjA==
X-Google-Smtp-Source: AGHT+IHCOdU1jo4N2/3Xn+NIQXXngzOozOrAD+PVnvNMr/RyYgIxJOFYyvx7SDeOlHhlVEJLZ9Fmug==
X-Received: by 2002:a17:902:ceca:b0:224:2175:b0cd with SMTP id d9443c01a7336-22428aa1c02mr61046555ad.26.1741375051398;
        Fri, 07 Mar 2025 11:17:31 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410aaba8csm33790645ad.245.2025.03.07.11.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:17:30 -0800 (PST)
Message-ID: <595c60d9-c77c-40bc-ad00-5964dbe3df64@linaro.org>
Date: Fri, 7 Mar 2025 11:17:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/14] system/kvm: Expose
 kvm_irqchip_[add,remove]_change_notifier()
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
 <20250307180337.14811-9-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-9-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gQ3Vy
cmVudGx5IGt2bV9pcnFjaGlwX2FkZF9pcnFmZF9ub3RpZmllcigpIGFuZA0KPiBrdm1faXJx
Y2hpcF9yZW1vdmVfaXJxZmRfbm90aWZpZXIoKSBhcmUgb25seSBkZWNsYXJlZCBvbg0KPiB0
YXJnZXQgc3BlY2lmaWMgY29kZS4gVGhlcmUgaXMgbm90IHBhcnRpY3VsYXIgcmVhc29uIHRv
LA0KPiBhcyB0aGVpciBwcm90b3R5cGVzIGRvbid0IHVzZSBhbnl0aGluZyB0YXJnZXQgcmVs
YXRlZC4NCj4gDQo+IE1vdmUgdGhlaXIgZGVjbGFyYXRpb24gd2l0aCBjb21tb24gcHJvdG90
eXBlcywgYW5kDQo+IGltcGxlbWVudCB0aGVpciBzdHViLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPg0KPiAtLS0N
Cj4gICBpbmNsdWRlL3N5c3RlbS9rdm0uaCAgIHwgIDggKysrKy0tLS0NCj4gICBhY2NlbC9z
dHVicy9rdm0tc3R1Yi5jIHwgMTIgKysrKysrKysrKysrDQo+ICAgMiBmaWxlcyBjaGFuZ2Vk
LCAxNiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvc3lzdGVtL2t2bS5oIGIvaW5jbHVkZS9zeXN0ZW0va3ZtLmgNCj4gaW5kZXgg
YWIxN2MwOWE1NTEuLjc1NjczZmI3OTRlIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3N5c3Rl
bS9rdm0uaA0KPiArKysgYi9pbmNsdWRlL3N5c3RlbS9rdm0uaA0KPiBAQCAtNDEyLDEwICs0
MTIsNiBAQCBpbnQga3ZtX2lycWNoaXBfc2VuZF9tc2koS1ZNU3RhdGUgKnMsIE1TSU1lc3Nh
Z2UgbXNnKTsNCj4gICANCj4gICB2b2lkIGt2bV9pcnFjaGlwX2FkZF9pcnFfcm91dGUoS1ZN
U3RhdGUgKnMsIGludCBnc2ksIGludCBpcnFjaGlwLCBpbnQgcGluKTsNCj4gICANCj4gLXZv
aWQga3ZtX2lycWNoaXBfYWRkX2NoYW5nZV9ub3RpZmllcihOb3RpZmllciAqbik7DQo+IC12
b2lkIGt2bV9pcnFjaGlwX3JlbW92ZV9jaGFuZ2Vfbm90aWZpZXIoTm90aWZpZXIgKm4pOw0K
PiAtdm9pZCBrdm1faXJxY2hpcF9jaGFuZ2Vfbm90aWZ5KHZvaWQpOw0KPiAtDQo+ICAgc3Ry
dWN0IGt2bV9ndWVzdF9kZWJ1ZzsNCj4gICBzdHJ1Y3Qga3ZtX2RlYnVnX2V4aXRfYXJjaDsN
Cj4gICANCj4gQEAgLTUxNyw2ICs1MTMsMTAgQEAgdm9pZCBrdm1faXJxY2hpcF9yZWxlYXNl
X3ZpcnEoS1ZNU3RhdGUgKnMsIGludCB2aXJxKTsNCj4gICB2b2lkIGt2bV9hZGRfcm91dGlu
Z19lbnRyeShLVk1TdGF0ZSAqcywNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBz
dHJ1Y3Qga3ZtX2lycV9yb3V0aW5nX2VudHJ5ICplbnRyeSk7DQo+ICAgDQo+ICt2b2lkIGt2
bV9pcnFjaGlwX2FkZF9jaGFuZ2Vfbm90aWZpZXIoTm90aWZpZXIgKm4pOw0KPiArdm9pZCBr
dm1faXJxY2hpcF9yZW1vdmVfY2hhbmdlX25vdGlmaWVyKE5vdGlmaWVyICpuKTsNCj4gK3Zv
aWQga3ZtX2lycWNoaXBfY2hhbmdlX25vdGlmeSh2b2lkKTsNCj4gKw0KPiAgIGludCBrdm1f
aXJxY2hpcF9hZGRfaXJxZmRfbm90aWZpZXJfZ3NpKEtWTVN0YXRlICpzLCBFdmVudE5vdGlm
aWVyICpuLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEV2
ZW50Tm90aWZpZXIgKnJuLCBpbnQgdmlycSk7DQo+ICAgaW50IGt2bV9pcnFjaGlwX3JlbW92
ZV9pcnFmZF9ub3RpZmllcl9nc2koS1ZNU3RhdGUgKnMsIEV2ZW50Tm90aWZpZXIgKm4sDQo+
IGRpZmYgLS1naXQgYS9hY2NlbC9zdHVicy9rdm0tc3R1Yi5jIGIvYWNjZWwvc3R1YnMva3Zt
LXN0dWIuYw0KPiBpbmRleCBlY2ZkNzYzNmY1Zi4uYTMwNWIzM2Q4NGQgMTAwNjQ0DQo+IC0t
LSBhL2FjY2VsL3N0dWJzL2t2bS1zdHViLmMNCj4gKysrIGIvYWNjZWwvc3R1YnMva3ZtLXN0
dWIuYw0KPiBAQCAtODMsNiArODMsMTggQEAgdm9pZCBrdm1faXJxY2hpcF9jaGFuZ2Vfbm90
aWZ5KHZvaWQpDQo+ICAgew0KPiAgIH0NCj4gICANCj4gK2ludCBrdm1faXJxY2hpcF9hZGRf
aXJxZmRfbm90aWZpZXIoS1ZNU3RhdGUgKnMsIEV2ZW50Tm90aWZpZXIgKm4sDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEV2ZW50Tm90aWZpZXIgKnJuLCBxZW11
X2lycSBpcnEpDQo+ICt7DQo+ICsgICAgcmV0dXJuIC1FTk9TWVM7DQo+ICt9DQo+ICsNCj4g
K2ludCBrdm1faXJxY2hpcF9yZW1vdmVfaXJxZmRfbm90aWZpZXIoS1ZNU3RhdGUgKnMsIEV2
ZW50Tm90aWZpZXIgKm4sDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHFlbXVfaXJxIGlycSkNCj4gK3sNCj4gKyAgICByZXR1cm4gLUVOT1NZUzsNCj4gK30N
Cj4gKw0KPiAgIGludCBrdm1faXJxY2hpcF9hZGRfaXJxZmRfbm90aWZpZXJfZ3NpKEtWTVN0
YXRlICpzLCBFdmVudE5vdGlmaWVyICpuLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIEV2ZW50Tm90aWZpZXIgKnJuLCBpbnQgdmlycSkNCj4gICB7DQoN
ClJldmlld2VkLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFy
by5vcmc+DQoNCg==

