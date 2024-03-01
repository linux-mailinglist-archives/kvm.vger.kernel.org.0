Return-Path: <kvm+bounces-10610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 390E586DE8A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 10:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EB371C20B7C
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8922E6A8B9;
	Fri,  1 Mar 2024 09:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CFP1sI1U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAF26A32F
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 09:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709286321; cv=none; b=koXwSbmvQV8BFvtx1qrx8vXQSwh3HeYLiM2zDk1QKOJE5DYZb4mn8ILkDKT4qIumm1k1NabIKJOpUk7ZVhsRtySue+K8F/aW9KyUF/2lmBFk5gOckJw1SOFOIwQGNcfmN/cu9zQs1Bt0VJRFur2Dtr6V0RCjK11HzApT1SltYkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709286321; c=relaxed/simple;
	bh=oe+STWzSHNFx92Ed5Z4M4cS3V7pEndT2r4nJ64v+428=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JmnzZfuGY5aNNff14EpTQuiudVF/leM45aQiiYGMLoguUunIfATdByNj47fDPJeUQ3TUDEous+4InccBJT1md4VaflR3JDfRkbz9ZQlArW6gLU64Yd5PD9772R+EqGSgALo16cMUX5OsVUbgar6so7OT+WoDMIGDXc0/NS5M6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CFP1sI1U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709286318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4H0OYCm6hFlmx4RA0pYmYEJnMmqz3AUipl1jTzgwcLE=;
	b=CFP1sI1U3F83Ba3udaL37d1uSFre97yDoWCs2NODQCOSog1P3B/7ktJOVDKHcxyXmNHQyQ
	YVZgjyrKWB9bVWUrgMGUm9CiXw753NxvovvAd3da2YFpiADrE6Qlq0XwByH2JH/llWuwei
	GqX9nRu0t67RRm5kmutmABtSBY3nC80=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-7Iwtx11ZP3iZ1IS0sMqgOQ-1; Fri, 01 Mar 2024 04:45:17 -0500
X-MC-Unique: 7Iwtx11ZP3iZ1IS0sMqgOQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-787b8dd3330so499230485a.1
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 01:45:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709286317; x=1709891117;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4H0OYCm6hFlmx4RA0pYmYEJnMmqz3AUipl1jTzgwcLE=;
        b=TDfSx7W8J0iUMNZJIZduMeogj9Jj5cV1oSLswPiQWyGen8EWyXxUYEx3alKw5zqSSH
         hwaI9iCCQVLrvsOTFJsVu8dDRKHVYP3+C4zhk7NT/HyFQvHrafbzKQMsu8I0jiCywdQT
         zjlY3Kz9/yWrOCVJm8IZUWN2n4ENTW2PHGekvkIoAH6it3QsQMpdp4u1OFt4HByQ2amc
         MIHRNxYaSwjfjYwD5e+LUvMDWNrpAdy2P1DfO2Sal8swjD+BskGtIw1FHHOjHl2N/bir
         d3G00qFJefV0LBhpc6LtiombhvlP+K8QqE7NNorhQ6R5ODF97sRDIxzsYLSkFTV213vi
         IUrw==
X-Forwarded-Encrypted: i=1; AJvYcCWK8MtNvrpWNIsN2Pq0z/GZYO1lNpbruCQXHacicoARX1j+MihAxc62gRY1X2UZoVZZfZecNYp9la4yzGx3NfoZMSIZ
X-Gm-Message-State: AOJu0YwnWDe7Cs0YjX6cWuEyKPGdeEQqzq1wPSwX9Pk4SnZsAYbqewmt
	0FdFORVoIb8M18OogB+pbDo8sUz8yhTnFosabGn8IDwpJ41H5FSOQhiZ+l79VvVE3tELUSlWejb
	6Liys080V7M9bqxNk8z9GnATdvZgIHOCJX+S1OZo0AwATNsWXMg==
X-Received: by 2002:a05:620a:b1c:b0:787:a2d2:d59b with SMTP id t28-20020a05620a0b1c00b00787a2d2d59bmr1364784qkg.26.1709286317063;
        Fri, 01 Mar 2024 01:45:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3ZGmrG95zUVRhKvl+Z3Z4TCBmcrBRud34bZ7otTXr0OO1dnrorQHaOC3fDp3qa8laUrQPzw==
X-Received: by 2002:a05:620a:b1c:b0:787:a2d2:d59b with SMTP id t28-20020a05620a0b1c00b00787a2d2d59bmr1364774qkg.26.1709286316816;
        Fri, 01 Mar 2024 01:45:16 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id g4-20020a05620a40c400b0078783b32229sm1491763qko.7.2024.03.01.01.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 01:45:16 -0800 (PST)
Message-ID: <f659964b-da95-4339-9d4f-c7b6a72fbac0@redhat.com>
Date: Fri, 1 Mar 2024 10:45:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 03/32] powerpc: Fix stack backtrace
 termination
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-4-npiggin@gmail.com>
 <94491aab-b252-4590-b2a7-7a581297606f@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <94491aab-b252-4590-b2a7-7a581297606f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27/02/2024 09.50, Thomas Huth wrote:
> On 26/02/2024 11.11, Nicholas Piggin wrote:
>> The backtrace handler terminates when it sees a NULL caller address,
>> but the powerpc stack setup does not keep such a NULL caller frame
>> at the start of the stack.
>>
>> This happens to work on pseries because the memory at 0 is mapped and
>> it contains 0 at the location of the return address pointer if it
>> were a stack frame. But this is fragile, and does not work with powernv
>> where address 0 contains firmware instructions.
>>
>> Use the existing dummy frame on stack as the NULL caller, and create a
>> new frame on stack for the entry code.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>   powerpc/cstart64.S | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Thanks for tackling this! ... however, not doing powerpc work since years 
> anymore, I have some ignorant questions below...
> 
>> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
>> index e18ae9a22..14ab0c6c8 100644
>> --- a/powerpc/cstart64.S
>> +++ b/powerpc/cstart64.S
>> @@ -46,8 +46,16 @@ start:
>>       add    r1, r1, r31
>>       add    r2, r2, r31
>> +    /* Zero backpointers in initial stack frame so backtrace() stops */
>> +    li    r0,0
>> +    std    r0,0(r1)
> 
> 0(r1) is the back chain pointer ...
> 
>> +    std    r0,16(r1)
> 
> ... but what is 16(r1) ? I suppose that should be the "LR save word" ? But 
> isn't that at 8(r1) instead?? (not sure whether I'm looking at the right ELF 
> abi spec right now...)

Ok, I was looking at the wrong ELF spec, indeed (it was an ancient 32-bit 
spec, not the 64-bit ABI). Sorry for the confusion. Having a proper #define 
or a comment for the 16 here would still be helpful, though.

  Thomas


