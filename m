Return-Path: <kvm+bounces-14755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1138B8A67E3
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 12:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34DB01C20B2B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BBC86AFC;
	Tue, 16 Apr 2024 10:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSoXQZMt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3B585280
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 10:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713262291; cv=none; b=eZSPP6gNE1nBvSaZ5CV23adKZM3f6lvp+R75kraq6mD3oFoWwVgltddMkhI0EMIu+zyiBp+ppC80cG9boPdoLoWoOX0LDhbTZ/Rl4+o/6FtjxH1exRttJW9lw52p94GRdE4j0w0X1SUXdCbttYMmYjxRMew/6oMEvYUQKN6uED4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713262291; c=relaxed/simple;
	bh=fuUfkS4Cdj3gmRIw30vkKCgapMExCu4O78fGt3JB2Nc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VbDlYZHamCrilAnVDkbOUKCt3HBvNE7vZpsO7M/8qwZk7YFiJdGwr0mk2mAAACKC8s2t4pTdxag3hsAXIQsJ5p3Zn9PgHe/rhT7o7YieFoRGTgiwGIgyJrtNWJPKz5bWAcR3g4e1tlwM+Boyl3YuYO+FIyhEV6meJVdrmWrxmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jSoXQZMt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713262289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lSM0WhLsf89SZo0EvzbbPBb1lo71R7rQdXb0pfYifIc=;
	b=jSoXQZMtpXYZV4EJcOlhQsy9gSP9xusZM/R5ibSzZlz8GZFUqwdXUOdtY8eLwKDCAw5Kis
	eBKA5qj6uODBO9piDneGsF1/kHtK2murQYpnlFUyVgB+WdfIk7aVUVu9poJwVL1eVYzNRf
	+FIwlnCIqaz0ueGEb9iqx4ZbRyldx7M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-rzqNaReaNEWGF3jPRdb-HA-1; Tue, 16 Apr 2024 06:11:28 -0400
X-MC-Unique: rzqNaReaNEWGF3jPRdb-HA-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-56e59bdf440so4813384a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 03:11:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713262287; x=1713867087;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lSM0WhLsf89SZo0EvzbbPBb1lo71R7rQdXb0pfYifIc=;
        b=KGnGAJISKm6emBIhhVDlggWAyzgCz8pIKf4ZRaoipfOZS1W+1qa9R77c9kf91wh5Yo
         SBVlaKbhHc+FrzZZ1onCdLksxrvB0SQb6h15WKaiLUkIYWVYCX9Wsl6aOZWalmQRsXU+
         0+D5KkNX6FbHDaOOJ1qVAA8iYKsgQCn6WLLVBqlfcf8D7IcnQfCasKasonDd9YBXu32Z
         4FpK8rQfEifGW/V7YaFK+NxgkD+GYNGi7qMw1P1LOg98cmu18zO3kJ6XLi5eZv6BHWPo
         MNi7r647uI2EMsc4HGUqiSXDipWxFr8EOMVri51VaCYN6/FvuHsvawWCGamzY0ZIEyFO
         jo3g==
X-Forwarded-Encrypted: i=1; AJvYcCVytq3ip24mlKGdwRAbX6wH3+LqWaMJMly0W9ptNiXJ6VO3fLVshyVa8topPXifNgDijcENdfr2JizvDgeLhReCUr7k
X-Gm-Message-State: AOJu0YyTh3JBcx2zMS71R2Xk2fbTbN2QZei7Ge3lacvU7q3H07nal8v3
	HyhGFowr2GxhTvw8F2+rQaZ3W9OVgWvF5Ux/GLA8xjaahjkV/1w3d1YO9acWabtqzx3LJtGQB44
	5FQ7gNiahLszKZD294OmFke4bTQhUyE2lNH/w57/7u6632tUfKg==
X-Received: by 2002:a50:9f03:0:b0:570:1ea8:c7b9 with SMTP id b3-20020a509f03000000b005701ea8c7b9mr1412575edf.8.1713262287089;
        Tue, 16 Apr 2024 03:11:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqOqUr1SbomN37Qk4Ne+O7ACenneuovJQTA2NdSSZ0DYEfTOSjeAMV7DePUnDgZHR0BEtduQ==
X-Received: by 2002:a50:9f03:0:b0:570:1ea8:c7b9 with SMTP id b3-20020a509f03000000b005701ea8c7b9mr1412551edf.8.1713262286787;
        Tue, 16 Apr 2024 03:11:26 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-50.web.vodafone.de. [109.43.179.50])
        by smtp.gmail.com with ESMTPSA id z21-20020a05640235d500b0056e718795f8sm5838521edc.36.2024.04.16.03.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 03:11:26 -0700 (PDT)
Message-ID: <adb4aa1e-a56e-4786-ba59-830d58967c0e@redhat.com>
Date: Tue, 16 Apr 2024 12:11:25 +0200
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
 <bc91c2e1-6099-46c5-bbca-18bb7adb82d2@redhat.com>
 <56b4514b-e873-4509-89f3-fb6d96ff1274@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <56b4514b-e873-4509-89f3-fb6d96ff1274@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/04/2024 09.55, Thomas Huth wrote:
> On 16/04/2024 09.18, Thomas Huth wrote:
>> On 11/04/2024 21.22, Thomas Huth wrote:
>>> On 08/04/2024 18.06, Nico Boehr wrote:
>>>> Quoting Nicholas Piggin (2024-04-05 10:35:07)
>>>>> The migration harness is complicated and easy to break so CI will
>>>>> be helpful.
>>>>>
>>>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>>>> ---
>>>>>   .gitlab-ci.yml      | 32 +++++++++++++++++++++++---------
>>>>>   s390x/unittests.cfg |  8 ++++++++
>>>>>   2 files changed, 31 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>>>>> index ff34b1f50..60b3cdfd2 100644
>>>>> --- a/.gitlab-ci.yml
>>>>> +++ b/.gitlab-ci.yml
>>>> [...]
>>>>> @@ -135,7 +147,7 @@ build-riscv64:
>>>>>   build-s390x:
>>>>>    extends: .outoftree_template
>>>>>    script:
>>>>> - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
>>>>> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
>>>>>    - mkdir build
>>>>>    - cd build
>>>>>    - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>>>>> @@ -161,6 +173,8 @@ build-s390x:
>>>>>         sclp-1g
>>>>>         sclp-3g
>>>>>         selftest-setup
>>>>> +      selftest-migration-kvm
>>>>
>>>> We're running under TCG in the Gitlab CI. I'm a little bit confused why
>>>> we're running a KVM-only test here.
>>>
>>> The build-s390x job is TCG, indeed, but we have the "s390x-kvm" job that 
>>> runs on a KVM-capable s390x host, so it could be added there?
>>
>> I now gave it a try and it seems to work, so I updated this patch and 
>> pushed it to the repository now.
> 
> Hmm, "selftest-migration" now was failing once here:
> 
>   https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/6633865591
> 
> Let's keep an eye on it, and if it is not stable enough, we might need to 
> disable it in the CI again...

And it just failed again:

  https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/6635395811

... not sure whether this is due to the slow CI machine or whether there is 
still a bug lurking around somewhere, but anyway, I disabled it now for the 
CI again to avoid that other MRs get affected.

  Thomas



