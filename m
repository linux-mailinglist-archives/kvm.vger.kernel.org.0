Return-Path: <kvm+bounces-40396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C00A5713E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42D0018985F8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42DA2505B6;
	Fri,  7 Mar 2025 19:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hdpzEdzC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593B7215F49
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374891; cv=none; b=PKa3jtnMh3P3qSlAAsjqaGz0Pi+3b5EXbQ7jX7sUUpeuBCXwgeVtzcb15BFQbPkUDb+rAGKnzO+jn94P11JPVUlQWj4Ikj1KGJ4U39wWnSiSPPCaYZ24IwPS+4NQSwCIGSjDtr2p2mLlPAVlG5OafK39tnFpsgzcKtEJYNgS0Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374891; c=relaxed/simple;
	bh=xS48sSfR/nqvciBSEcVtX4LFE00mJJmnZli1lqwc2I8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JhqH6jCu067g+a193Iaw1L45LAclGV7AfAhgGkURcjmrN4huyeCTpOPCcKNzVkAle9bh2B+khwdLmy2xtqAfQ7ggjIdePplRfXqPMRpKt+VEHRjMLSYKpt7XdlOnDrYJ+UuPQXgEQdHBD5ROi+CfJsWcujeeA7oCvSyfnc8BcN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hdpzEdzC; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2fe9759e5c1so3474722a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374889; x=1741979689; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xS48sSfR/nqvciBSEcVtX4LFE00mJJmnZli1lqwc2I8=;
        b=hdpzEdzCt0Kh5KvMqVHRYfhA452iOWTZd1/N1wc/megfyoqM3p+aLyPXNSwLXvKw+f
         tf/gjAO26WuHGfAHVp6+3gmqfbFlfi+HFUgz2e9XH7bhs0lAvGLn7rGE6gpdfTMrn8yq
         151C1rJ70qXAHDH/fMEyMifKiXfwDfXRn9iZaVlVDv0vedoDg11MgK2zMQHHZS6TUn7r
         YZyukkL5TGNL6yA84deprScUrKbHoskPDrGhmW9CBqgDnavTlmSDfzbjeqeTVWDkl1DS
         GSJJQYh0cVQ/ANgFlrdikTqNBQV6NQh77jt4MsZwD4l/jx8c0T8hRzTwQISeu+SSyxFK
         FY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374889; x=1741979689;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xS48sSfR/nqvciBSEcVtX4LFE00mJJmnZli1lqwc2I8=;
        b=h/KIcFhLLN5dUe/JIBPztreBIzIegOPoh8mH772DYNZveQSX+P6/6gRE5oaMz0qF2x
         z/xhG44By8cbggbCV+gDM4ULRIkwNg5qi0Kr2LpqyxPvxu/LAvQBa5bsQ7PDHRszo3Oa
         xNasO+J/ssv3EPGRwlkah3pkIH88uw5+cojqwecav/QnGqDHEhsUcPE87k8G3fBk/g+x
         odn7ZEYDG3nE5nz6cKOIFEeECdPmgXLM8Cakd9jva0FM0he+tF6lm1OB/Dalvf0SydiH
         3m9/2ohD4L+F/e0jUHQwDbrM855D1JfauYL/o6JR9C4XDsuJjCMFJsVvPK/6r9TU0V2J
         1WTg==
X-Forwarded-Encrypted: i=1; AJvYcCU2rgaiYSevKVhoHM5kCD+nb/2/tYQdXGHBOlTfg+7KYy8fCSZnA1cMI7nzmWHut5QKWz0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8eQaTdY2nLJ09LMHLShegNhAz/EeRDoUTiljJwVG5brs9kOlt
	tIaL0mtSDOItrJBZdwF6pMQnl92TMjp2B1EaXTLVkgm4/ZmyFdsUXWKIjRfRGJE=
X-Gm-Gg: ASbGncvhA/Oew0MzPn2J+V5kncTR76akTsixEVEp6T8SO5noJQN0m/UjcOoQYA4qi9U
	xU+wN/LYlRITN48gNk1lJ+ySvZNxz3Nq5qyLjlqAG2eO4k5SJi0i7FzBmdmpd1MxFAH/FfvIvpr
	LVhqG4oThu3tQRvGyIL+l3n4uU4KlPK7lwQt34M+BeyFvWbaqYV6r5hsCM6j7iiiPbqSPq5FY3F
	KPg78/Wy/4ml2ej2gWFpU9wyc9ScVt09TD5EI9C1uCuBEBOEoJX5Ma0eUElzWgPKR9IeakWTSsi
	fmKFmTN6YUWg0Zh3yZVgZMzc0Y1r9HbXP7zbV59xZVvc4Szpj2kKPZTC7w==
X-Google-Smtp-Source: AGHT+IE73Alk6UcBWkg7YWfas3SGCUdlCaGCInmV4gpMnbflJafpM2h5wcqHKXoJ2T/ROUJtTSsGkg==
X-Received: by 2002:a17:90b:4b11:b0:2fe:994d:613b with SMTP id 98e67ed59e1d1-2ff7cf2b59fmr7212164a91.35.1741374889557;
        Fri, 07 Mar 2025 11:14:49 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff728a901bsm3014197a91.49.2025.03.07.11.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:14:49 -0800 (PST)
Message-ID: <59b3d1a3-541d-47a1-abd0-e649e9007990@linaro.org>
Date: Fri, 7 Mar 2025 11:14:48 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] hw/vfio/common: Include missing 'system/tcg.h'
 header
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
 <20250307180337.14811-2-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250307180337.14811-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy83LzI1IDEwOjAzLCBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSB3cm90ZToNCj4gQWx3
YXlzIGluY2x1ZGUgbmVjZXNzYXJ5IGhlYWRlcnMgZXhwbGljaXRseSwgdG8gYXZvaWQNCj4g
d2hlbiByZWZhY3RvcmluZyB1bnJlbGF0ZWQgb25lczoNCj4gDQo+ICAgIGh3L3ZmaW8vY29t
bW9uLmM6MTE3Njo0NTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9u
IOKAmHRjZ19lbmFibGVk4oCZOw0KPiAgICAgMTE3NiB8ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgdGNnX2VuYWJsZWQoKSA/IERJUlRZX0NMSUVOVFNf
QUxMIDoNCj4gICAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIF5+fn5+fn5+fn5+DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBN
YXRoaWV1LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIGh3L3ZmaW8v
Y29tbW9uLmMgfCAxICsNCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9ody92ZmlvL2NvbW1vbi5jIGIvaHcvdmZpby9jb21tb24uYw0K
PiBpbmRleCA3YTQwMTBlZjRlZS4uYjE1OTZiNmJmNjQgMTAwNjQ0DQo+IC0tLSBhL2h3L3Zm
aW8vY29tbW9uLmMNCj4gKysrIGIvaHcvdmZpby9jb21tb24uYw0KPiBAQCAtNDIsNiArNDIs
NyBAQA0KPiAgICNpbmNsdWRlICJtaWdyYXRpb24vbWlzYy5oIg0KPiAgICNpbmNsdWRlICJt
aWdyYXRpb24vYmxvY2tlci5oIg0KPiAgICNpbmNsdWRlICJtaWdyYXRpb24vcWVtdS1maWxl
LmgiDQo+ICsjaW5jbHVkZSAic3lzdGVtL3RjZy5oIg0KPiAgICNpbmNsdWRlICJzeXN0ZW0v
dHBtLmgiDQo+ICAgDQo+ICAgVkZJT0RldmljZUxpc3QgdmZpb19kZXZpY2VfbGlzdCA9DQoN
ClJldmlld2VkLWJ5OiBQaWVycmljayBCb3V2aWVyIDxwaWVycmljay5ib3V2aWVyQGxpbmFy
by5vcmc+DQoNCg==

