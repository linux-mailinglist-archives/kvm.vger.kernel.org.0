Return-Path: <kvm+bounces-14730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2BF8A64E5
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7EA2282480
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52DF80BFE;
	Tue, 16 Apr 2024 07:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXr143cE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE2C7D086
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 07:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713251931; cv=none; b=dPEklxU41RqgcbZHe9pv7Myaia/xegxgeZJKxhsAKh5HjLsz30mZRiU7CaSsn7ZEmih19azy/g8EQhEmgaqL0BfxRUimhEn61yFId0Ab6V26cgfa75YucVADzQUALlHkmwBrsGg3BCB4J8Ck7nuq9yBxQhCjSEL/vN/yHrXjTao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713251931; c=relaxed/simple;
	bh=CXwvyQqlDCMUJbkFs5lA3GpywIzQoFs1ouIlk/9KUys=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Gm2JAfLYpnhuCYZwVqeaf/mrJxZkEVSdE1/R6euLZaN7SXeK8Tu+8eEk3XsoUjDLPQGyzzelCBowojuAO7TeeiT9vtup4lXYCY5kFfk7cGV8nc1Os5/i5Xf0/r0xO11bNhRWdrxg8dyk1AXclyMPSBuaOzx7/vx9lSsGTd0Cbqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YXr143cE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713251929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e5e+KDoend6ys1L9LmDT595ey+XRcm1nHptmRwP1piM=;
	b=YXr143cETpKSgloF9DlJhmutws8PYwZ5qfOad/NzPY4rOm6AvJm5K5KplHx7LaROM+PHc3
	i7Ru7Pqeaz2kRZ/2cY1ueOT0nx9yYNglumWm3HTIlWV3W74d35s0oAE9+JGN/QpyqfIyDa
	/OnL+u9B2MBEodJd5AgTknomnShwoEs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-Zwnf8aiXPde6K5Z-Aux9gQ-1; Tue, 16 Apr 2024 03:18:47 -0400
X-MC-Unique: Zwnf8aiXPde6K5Z-Aux9gQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-518c3c6e757so2053070e87.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 00:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713251926; x=1713856726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5e+KDoend6ys1L9LmDT595ey+XRcm1nHptmRwP1piM=;
        b=VleT6Czl1lVO/mFQhm4Jyto18O8aL7UA9w2OnU3458EqCsotuyUa696Nio3cP1IODz
         OZmqvKpaDHmd2RS/uR4ztBeuGrmIWJBWb89KGjxfGBQtgyOgl9g8IsaO2wGb9PGmWFCc
         QoBMCZK98KyLnPzrgvmHE3f0cSwZpul58PwjHmOrG/HtlV+DwLfaeenqWW7/4NdKKUux
         A7iHmaIvKqknd0232sdVKP6E+8EgnFp6wXmbek8Xv/y+CiGMLSM5tbRs1A7QYftCicJ5
         DiRe5ITjhvOjkktRYZcg8Xc7HPld5bumMe7p50c0/9hcr6kuSad2jaEMw+dmCFeEULtU
         rgWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/izuzoXgml1I1gnCOE39uuN06x9zMJFPts4yLKoLFm0/PIZHKtpmWyEXNAr0RcDn8qRbjm9+HJ6iW3/NBBk7HTxiZ
X-Gm-Message-State: AOJu0YxXP+emb9z3l97Ef9BQE1eS6jBePD0U33cpOHzywGBEm2sXWyVA
	fU8rDdruQMkqCSVJ1RJnHTiyia5MmRks3X++t9l5vesrOpf7zCPb6H7jF6GMF/Ua0UWlAv/0WKV
	VBPi/6FrXMCNxqBVf9auyfi7Z9eAqFM3DAeJe5jI7Zu8uJXsC9g==
X-Received: by 2002:a19:f013:0:b0:513:dd23:7a02 with SMTP id p19-20020a19f013000000b00513dd237a02mr7870989lfc.26.1713251926381;
        Tue, 16 Apr 2024 00:18:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjafICuo5LMwPp30unfFJwJWF4tCZLumMUMpRA+B5uETtyWY+iRGeCE31PSoDRCrKXhxjOaQ==
X-Received: by 2002:a19:f013:0:b0:513:dd23:7a02 with SMTP id p19-20020a19f013000000b00513dd237a02mr7870975lfc.26.1713251925956;
        Tue, 16 Apr 2024 00:18:45 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-50.web.vodafone.de. [109.43.179.50])
        by smtp.gmail.com with ESMTPSA id k21-20020a17090666d500b00a518bcb41c1sm6421258ejp.126.2024.04.16.00.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 00:18:45 -0700 (PDT)
Message-ID: <bc91c2e1-6099-46c5-bbca-18bb7adb82d2@redhat.com>
Date: Tue, 16 Apr 2024 09:18:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 06/35] gitlab-ci: Run migration selftest
 on s390x and powerpc
From: Thomas Huth <thuth@redhat.com>
To: Nico Boehr <nrb@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-7-npiggin@gmail.com>
 <171259239221.48513.3205716585028068515@t14-nrb>
 <e6c452bd-9101-40b7-ae3b-02400fed9e42@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <e6c452bd-9101-40b7-ae3b-02400fed9e42@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/04/2024 21.22, Thomas Huth wrote:
> On 08/04/2024 18.06, Nico Boehr wrote:
>> Quoting Nicholas Piggin (2024-04-05 10:35:07)
>>> The migration harness is complicated and easy to break so CI will
>>> be helpful.
>>>
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>>   .gitlab-ci.yml      | 32 +++++++++++++++++++++++---------
>>>   s390x/unittests.cfg |  8 ++++++++
>>>   2 files changed, 31 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>>> index ff34b1f50..60b3cdfd2 100644
>>> --- a/.gitlab-ci.yml
>>> +++ b/.gitlab-ci.yml
>> [...]
>>> @@ -135,7 +147,7 @@ build-riscv64:
>>>   build-s390x:
>>>    extends: .outoftree_template
>>>    script:
>>> - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
>>> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
>>>    - mkdir build
>>>    - cd build
>>>    - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>>> @@ -161,6 +173,8 @@ build-s390x:
>>>         sclp-1g
>>>         sclp-3g
>>>         selftest-setup
>>> +      selftest-migration-kvm
>>
>> We're running under TCG in the Gitlab CI. I'm a little bit confused why
>> we're running a KVM-only test here.
> 
> The build-s390x job is TCG, indeed, but we have the "s390x-kvm" job that 
> runs on a KVM-capable s390x host, so it could be added there?

I now gave it a try and it seems to work, so I updated this patch and pushed 
it to the repository now.

  Thomas



