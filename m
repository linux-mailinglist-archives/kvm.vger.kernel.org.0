Return-Path: <kvm+bounces-24408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F88795504E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB0AC288702
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 17:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04951C379A;
	Fri, 16 Aug 2024 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rTy0qKEy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576351BDABF
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723830876; cv=none; b=r23PLOE42p4rKGUy4t4K64sVbHWDZRQ3SoNP3Oz8+mezoeKgN5fKp3F3y+ZfJHQx8d6v3XhQrLgto8tyKjAIFMl2MaiCEv8BZFI06Q0J6NY4G2PwxCwsU5EaVORp+PvUoWijsMfqYJz6/jhShf052dEZILFqW191FDgWIUAETMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723830876; c=relaxed/simple;
	bh=vKkLRfLwd+3pXpbvNbngAZ+9T9Lz9kOCjy+cNgYYdAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZwRrmoV1xx3yEzHmpzwUlixed27JaxqDBazi7/1ekGoOanKQnyaeZRneFJ9Yd3ZTE9LTgM1YkTEGACtPEDweN2xpZNuL4IUDeqg7sTH4no5g6Ef/7UHK1nbZsE0bpNgvfelbI7W2qHWM0QRwyccY+dxck/61AjczeDCOcExVcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rTy0qKEy; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70d1c655141so1557251b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 10:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723830873; x=1724435673; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vKkLRfLwd+3pXpbvNbngAZ+9T9Lz9kOCjy+cNgYYdAY=;
        b=rTy0qKEygn7rcvdLS4upqVikKGudf2WAv8fcFLlDIbv4xwdefUDutsDfp8wAd7r5+K
         cKi6CbgtKjPMeGyq8mYBN/e6CVwQxQG7IFaA+XfmTi0jZJqKj4NtLPDZecVCOyGnRqTy
         EjyzLO9sxdmDpLGvyIXpa0t4bwUZN3EaewCHljRPMHt2PU/ByRZuIZz2DaYxZCvqtt5Q
         mA7jO4Y9m8U0sneKB6xAM8kjm6Jbd80u5tqRUB4FzexpUguaHNjZ6IJIYaKyA3lQCHn2
         8SaVu6NDqr7j9cjSx0MIeD0SUu3wkK1MyYmQSVv+0fFVpkaFyu7CuXMHVIDXFkLWo7J1
         f9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723830873; x=1724435673;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vKkLRfLwd+3pXpbvNbngAZ+9T9Lz9kOCjy+cNgYYdAY=;
        b=In3TRFm9orgye0B7K49lPlV4lV/BksWc/QSGTy8LOtPK2wckBTw5BJaZlda5h3JSbX
         aPsQfQWtiiye3Tr9n1cXNzkh++IWeqPHxKqyeFe2m52mz9AU1UJ/mvScOnmus7GKnnKf
         u2VDCj9BoYSdqiE0c0pY0Q3y+WRZaD5iyGbQHbtcglswB0m4QD6RpKlGKQ7IJMoLg+3x
         0KGDJO1lDg3VUWjLgmFCf2c5AgiCxCHX4I15BAZBqQ5VqCW1XNdMcZe9RuY5n2D4nQQT
         4WEaeTskEEe1qtss/7V54kxvL2ZMlcLQ73omsTB+2Uatc2KTWkOREIuNUUdiyBESjPXe
         /AZw==
X-Forwarded-Encrypted: i=1; AJvYcCVKVpTMDZ2PZMR8ZKz1SurY5H2W9WUFLwAMbVtI6Noan9pUJxfvQpOK3XcZ6DP70DWFFnbONZ+HV7Vi0bf/i0W+v5rm
X-Gm-Message-State: AOJu0YwVn97FGLvOuOR6kE+6KccHihoXSO/IPhc2k4F9JK68AOqX3GmL
	yvQM5D19RI4bpXhL5l6m7UfAh50zeZNRMnBsQ2XiCxcx2wDc0S558deU/lX6cLg=
X-Google-Smtp-Source: AGHT+IEbfHawBN3cm/BrNhs25Miea0myhD7+YcS/i6OLgODWH/6jqWoXdfVk4cc6MbIKi0KX9CZc1Q==
X-Received: by 2002:a05:6a00:915f:b0:70d:2693:d208 with SMTP id d2e1a72fcca58-713c4e857c5mr4269815b3a.15.1723830873559;
        Fri, 16 Aug 2024 10:54:33 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::b861? ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127aefa113sm2965498b3a.99.2024.08.16.10.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 10:54:32 -0700 (PDT)
Message-ID: <dbce200b-a6ac-46ed-aec3-4a87f1434797@linaro.org>
Date: Fri, 16 Aug 2024 10:54:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] target/i386: fix build warning (gcc-12
 -fsanitize=thread)
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, David Hildenbrand <david@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-3-pierrick.bouvier@linaro.org>
 <54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC8xNi8yNCAwMzo1OSwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6DQo+IE9u
IDE1LzgvMjQgMDA6NDEsIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+PiBGb3VuZCBvbiBk
ZWJpYW4gc3RhYmxlLg0KPj4NCj4+IC4uL3RhcmdldC9pMzg2L2t2bS9rdm0uYzogSW4gZnVu
Y3Rpb24g4oCYa3ZtX2hhbmRsZV9yZG1zcuKAmToNCj4+IC4uL3RhcmdldC9pMzg2L2t2bS9r
dm0uYzo1MzQ1OjE6IGVycm9yOiBjb250cm9sIHJlYWNoZXMgZW5kIG9mIG5vbi12b2lkIGZ1
bmN0aW9uIFstV2Vycm9yPXJldHVybi10eXBlXQ0KPj4gICAgNTM0NSB8IH0NCj4+ICAgICAg
ICAgfCBeDQo+PiAuLi90YXJnZXQvaTM4Ni9rdm0va3ZtLmM6IEluIGZ1bmN0aW9uIOKAmGt2
bV9oYW5kbGVfd3Jtc3LigJk6DQo+PiAuLi90YXJnZXQvaTM4Ni9rdm0va3ZtLmM6NTM2NDox
OiBlcnJvcjogY29udHJvbCByZWFjaGVzIGVuZCBvZiBub24tdm9pZCBmdW5jdGlvbiBbLVdl
cnJvcj1yZXR1cm4tdHlwZV0NCj4+ICAgIDUzNjQgfCB9DQo+Pg0KPj4gU2lnbmVkLW9mZi1i
eTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5hcm8ub3JnPg0KPj4g
LS0tDQo+PiAgICB0YXJnZXQvaTM4Ni9rdm0va3ZtLmMgfCA0ICsrLS0NCj4+ICAgIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBSZXZp
ZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8ub3JnPg0K
PiANCj4gQnV0IHdoYXQgYWJvdXQgdGhlIG90aGVyIGNhc2VzPw0KPiANCj4gJCBnaXQgZ3Jl
cCAnYXNzZXJ0KGZhbHNlKScNCj4gYmxvY2svcWNvdzIuYzo1MzAyOiAgICAgICAgYXNzZXJ0
KGZhbHNlKTsNCj4gaHcvaHlwZXJ2L2h5cGVydl90ZXN0ZGV2LmM6OTE6ICAgIGFzc2VydChm
YWxzZSk7DQo+IGh3L2h5cGVydi9oeXBlcnZfdGVzdGRldi5jOjE5MDogICAgYXNzZXJ0KGZh
bHNlKTsNCj4gaHcvaHlwZXJ2L2h5cGVydl90ZXN0ZGV2LmM6MjQwOiAgICBhc3NlcnQoZmFs
c2UpOw0KPiBody9oeXBlcnYvdm1idXMuYzoxODc3OiAgICBhc3NlcnQoZmFsc2UpOw0KPiBo
dy9oeXBlcnYvdm1idXMuYzoxODkyOiAgICBhc3NlcnQoZmFsc2UpOw0KPiBody9oeXBlcnYv
dm1idXMuYzoxOTM0OiAgICBhc3NlcnQoZmFsc2UpOw0KPiBody9oeXBlcnYvdm1idXMuYzox
OTQ5OiAgICBhc3NlcnQoZmFsc2UpOw0KPiBody9oeXBlcnYvdm1idXMuYzoxOTk5OiAgICBh
c3NlcnQoZmFsc2UpOw0KPiBody9oeXBlcnYvdm1idXMuYzoyMDIzOiAgICBhc3NlcnQoZmFs
c2UpOw0KPiBody9uZXQvZTEwMDBlX2NvcmUuYzo1NjQ6ICAgICAgICBhc3NlcnQoZmFsc2Up
Ow0KPiBody9uZXQvaWdiX2NvcmUuYzo0MDA6ICAgICAgICBhc3NlcnQoZmFsc2UpOw0KPiBo
dy9uZXQvbmV0X3J4X3BrdC5jOjM3ODogICAgICAgIGFzc2VydChmYWxzZSk7DQo+IGh3L252
bWUvY3RybC5jOjE4MTk6ICAgICAgICBhc3NlcnQoZmFsc2UpOw0KPiBody9udm1lL2N0cmwu
YzoxODczOiAgICAgICAgYXNzZXJ0KGZhbHNlKTsNCj4gaHcvbnZtZS9jdHJsLmM6NDY1Nzog
ICAgICAgIGFzc2VydChmYWxzZSk7DQo+IGh3L252bWUvY3RybC5jOjcyMDg6ICAgICAgICBh
c3NlcnQoZmFsc2UpOw0KPiBody9wY2kvcGNpLXN0dWIuYzo0OTogICAgZ19hc3NlcnQoZmFs
c2UpOw0KPiBody9wY2kvcGNpLXN0dWIuYzo1NTogICAgZ19hc3NlcnQoZmFsc2UpOw0KPiBo
dy9wcGMvc3BhcHJfZXZlbnRzLmM6NjQ4OiAgICAgICAgZ19hc3NlcnQoZmFsc2UpOw0KPiBp
bmNsdWRlL2h3L3MzOTB4L2NwdS10b3BvbG9neS5oOjYwOiAgICBhc3NlcnQoZmFsc2UpOw0K
PiBpbmNsdWRlL3FlbXUvb3NkZXAuaDoyNDA6ICogYXNzZXJ0KGZhbHNlKSBhcyB1bnVzZWQu
ICBXZSByZWx5IG9uIHRoaXMNCj4gd2l0aGluIHRoZSBjb2RlIGJhc2UgdG8gZGVsZXRlDQo+
IG1pZ3JhdGlvbi9kaXJ0eXJhdGUuYzoyMzE6ICAgICAgICBhc3NlcnQoZmFsc2UpOyAvKiB1
bnJlYWNoYWJsZSAqLw0KPiB0YXJnZXQvaTM4Ni9rdm0va3ZtLmM6NTc3MzogICAgYXNzZXJ0
KGZhbHNlKTsNCj4gdGFyZ2V0L2kzODYva3ZtL2t2bS5jOjU3OTI6ICAgIGFzc2VydChmYWxz
ZSk7DQo+IA0KDQpUaGV5IGRvbid0IHNlZW0gdG8gYmUgYSBwcm9ibGVtLCBidXQgSSdsbCBk
byBhIHNlcmllcyB0byBjbGVhbiB0aGlzIA0KY29tcGxldGVseSBmcm9tIHRoZSBjb2RlIGJh
c2UsIHNvIGFzc2VydChmYWxzZSkgaXMgZXJhZGljYXRlZC4NCg==

