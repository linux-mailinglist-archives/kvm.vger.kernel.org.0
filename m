Return-Path: <kvm+bounces-10874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C032871605
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:50:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9081C1C21001
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1DE45BFB;
	Tue,  5 Mar 2024 06:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E1/OksgF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF9A1EB2A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 06:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709621418; cv=none; b=kNgvj0ts7o+LzMzr5wSWIp2YwyCyveyCM6GBQ838+uQPKlQaGTzeDtS/VCcWRXlZalFhyA6wFPi6EaBGfZr4eAd6FSY9MPs8UbdY2XqBSErS2nTBwm+l9zynaRY5HBWBKwAe/DTOqNNGpHQkd8zwMmrJcwZekZAyFuGj05d6+LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709621418; c=relaxed/simple;
	bh=KkE0wsvot5llwT5NF+CDW9SdIAUMCDBbkGEnUNjRThw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sVYNoaXfuPSsb9qD1qu3DyXywLW8TEpJ7729spCLsK0gYIg+SWZs1OzEpNQs+HNFShn0tP6zYhMmXhWTT7FfHzwY3rAaj72GgMLRy65iyJtU71tURtqOJz2dlqUKvooJGHvoe+L/Bx9iOrgPWrQ+1AgWVqV5MbbliFOcMsB2htI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E1/OksgF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709621415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yUHOxqOqxGyA7MtR9Nnzp2vnulyuYHtJSbKL4qmMk4s=;
	b=E1/OksgFtcEDg44FqPQGD8sMnox6T0+BxPNbhvYH3S4c8wWox4n+hTeXEPZVpPlf5pVv9S
	tId8MKb+4J0IQq2MQgiBMc/7LfCkZwgN49gBz4urBU6ll7W3RNuHCAEuvMGZ/Xgpl9fftU
	uV0Yr5w2GpS95qG8DqEYr20qmnvRDDQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-DhZWITLQMeyNohdJ-nI4CQ-1; Tue, 05 Mar 2024 01:50:13 -0500
X-MC-Unique: DhZWITLQMeyNohdJ-nI4CQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56544b5af9dso3526821a12.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 22:50:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709621412; x=1710226212;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yUHOxqOqxGyA7MtR9Nnzp2vnulyuYHtJSbKL4qmMk4s=;
        b=QpK2x0MzdzYCrsHiSeORCOYObWWsVZoWPvTi0G7hh+WrV7RXr7+/owoKOkcj0xLSIP
         AUaIoUunhacxxOOIRGFtuSI6GTl0aDxHt2ATyuvhNdZMi/pKx+dGHD3W/oaHmy9iRBhq
         U5eW08XsdzWkQU1anjsg/kRn6cxuaZnZeL0aSaS79l+yeV0C+LGZXijuN29v5cptzWoS
         k0pSR5yZWSpXUijXqLVibYtsxggZG5jtB985Nj7XFelhJV2hvmWmIwRvWG2Q8SdltBlN
         IzFuG8i3zNET75TWsMOtGuj+z4s7YXbiutMQiMdWrL8ab5l00F5Eg5/UAN6drLmC7ePN
         FtYA==
X-Gm-Message-State: AOJu0YymlHC3M5mtOgEykchlSysz7/y3TYocKCku5xSInmaG0axds6sb
	GYiQgc1aleDkwIu61MZqU5e5R5nKmjHmnykW6zxRnzBu9QuYsWvg+cWRl74mJRsFVvMurCdCudZ
	GmmpBjirirAEFKWcwLdtsMeh+GvvmvHk3VZnW/3gkhzq2PWI+eQ==
X-Received: by 2002:a05:6402:901:b0:565:e646:5c12 with SMTP id g1-20020a056402090100b00565e6465c12mr8850272edz.0.1709621412707;
        Mon, 04 Mar 2024 22:50:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtP2gEIqeZN5nDOzlMNSXgqysn23HAV2b1atmbvM+KQvO6/brgGjbq/PcchmAc2KGMGnL+hQ==
X-Received: by 2002:a05:6402:901:b0:565:e646:5c12 with SMTP id g1-20020a056402090100b00565e6465c12mr8850252edz.0.1709621412367;
        Mon, 04 Mar 2024 22:50:12 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-243.web.vodafone.de. [109.43.178.243])
        by smtp.gmail.com with ESMTPSA id q22-20020a50aa96000000b00564e489ce9asm5712740edc.12.2024.03.04.22.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 22:50:12 -0800 (PST)
Message-ID: <d78eda02-7cd7-4e66-94d8-8493f8282d72@redhat.com>
Date: Tue, 5 Mar 2024 07:50:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 6/7] gitlab-ci: Run migration selftest on
 s390x and powerpc
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-7-npiggin@gmail.com>
 <7783977b-69ea-4831-a8f2-55de26d7bfd4@redhat.com>
 <CZLGURIYNKHG.1JRG53746LHWI@wheely>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CZLGURIYNKHG.1JRG53746LHWI@wheely>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/03/2024 03.38, Nicholas Piggin wrote:
> On Sat Mar 2, 2024 at 12:16 AM AEST, Thomas Huth wrote:
>> On 26/02/2024 10.38, Nicholas Piggin wrote:
>>> The migration harness is complicated and easy to break so CI will
>>> be helpful.
>>>
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>>    .gitlab-ci.yml | 18 +++++++++++-------
>>>    1 file changed, 11 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>>> index 71d986e98..61f196d5d 100644
>>> --- a/.gitlab-ci.yml
>>> +++ b/.gitlab-ci.yml
>>> @@ -64,26 +64,28 @@ build-arm:
>>>    build-ppc64be:
>>>     extends: .outoftree_template
>>>     script:
>>> - - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
>>> + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
>>>     - mkdir build
>>>     - cd build
>>>     - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
>>>     - make -j2
>>>     - ACCEL=tcg ./run_tests.sh
>>> -     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
>>> -     rtas-set-time-of-day emulator
>>> +     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
>>> +     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
>>> +     emulator
>>>         | tee results.txt
>>>     - if grep -q FAIL results.txt ; then exit 1 ; fi
>>>    
>>>    build-ppc64le:
>>>     extends: .intree_template
>>>     script:
>>> - - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
>>> + - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu nmap-ncat
>>>     - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
>>>     - make -j2
>>>     - ACCEL=tcg ./run_tests.sh
>>> -     selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
>>> -     rtas-set-time-of-day emulator
>>> +     selftest-setup selftest-migration selftest-migration-skip spapr_hcall
>>> +     rtas-get-time-of-day rtas-get-time-of-day-base rtas-set-time-of-day
>>> +     emulator
>>>         | tee results.txt
>>>     - if grep -q FAIL results.txt ; then exit 1 ; fi
>>>    
>>> @@ -107,7 +109,7 @@ build-riscv64:
>>>    build-s390x:
>>>     extends: .outoftree_template
>>>     script:
>>> - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
>>> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
>>>     - mkdir build
>>>     - cd build
>>>     - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>>> @@ -133,6 +135,8 @@ build-s390x:
>>>          sclp-1g
>>>          sclp-3g
>>>          selftest-setup
>>> +      selftest-migration
>>> +      selftest-migration-skip
>>>          sieve
>>>          smp
>>>          stsi
>>
>> While I can update the qemu binary for the s390x-kvm job, the build-* jobs
>> run in a container with a normal QEMU from the corresponding distros, so I
>> think this has to wait 'til we get distros that contain your QEMU TCG
>> migration fix.
> 
> Okay. powerpc *could* run into the TCG bug too, in practice it has not.
> We could try enable it there to get migration into CI, and revert it if
> it starts showing random failures?

Fine for me.

  Thomas


