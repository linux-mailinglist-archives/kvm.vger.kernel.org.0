Return-Path: <kvm+bounces-8125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A43C84BCD9
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 940C31F21E17
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FBD4134DB;
	Tue,  6 Feb 2024 18:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="P3gAv4Ja"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D262F134CA
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707243818; cv=none; b=Apsg9JLTs5qU8iT/aJGfG6PZlMjQiTRrq1FNYXvdWwDENMvcISw0PkNIZjxG6wa3GyUz/juoOhfTJghzGsRGjakvMD0cbW9zVVRy3FQ2/3bRxuMZx3MlpxRBNyprdGBSsrJKDCIV5IV3H9+d/sGbfJnvyNebT+FuCKCB2E1ovYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707243818; c=relaxed/simple;
	bh=WpF7Ns0W2rbf8FcZ6YlR8RDJd/WPpJMZrZ9vObH7JTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJiFkL4iH94Flun+SN/pjCXVsco/glqZU/6//eZlausQ8/yi2My/Nd3OlwL6pY/iKcH7i0AFKQe0AZgwbBE/O6KPmzjVWaIjrkTd6uLMxYWlCb6rD3vJwJHV1PhrksYxlYcCZFP+JsXsOQBRvqLr3Aawg9ghpfFSmaC0qzyyCHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=P3gAv4Ja; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5600d950442so1495074a12.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707243815; x=1707848615; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=StTdsqJeWRwYgnUE0gfc2tZBO/xSMu2em6FgEzzImwA=;
        b=P3gAv4Ja0FLwV9b9TmdjcaSX3DdOXCThveTjPLczqOrc7PWFM6Zk9ted87w7tJUChi
         d3tfuelmHCJxtEPRaEeD4dXwpfSVPMKSmqIhsXC4MTF3PJpfdwLWMW/04acmvWp5ci1G
         6cmsqXqTg3sXZP/bzEY76Sp8rUk5OQJU7jf6oNR+COb8dLYC5kd8GnMW9c1yWiEwb5L6
         V2BzsXzDVY0cf/X9n19aaN2T6L5TtwWYv4Pq3M9sd8dXWphOP5olUIcV8nuvr/rAIP7b
         iUI9Cju0jjiuvxvbbWGQZ58ctwHGcFKVQfhgmjL6bSa9UQNB+qY9Y4d9ul/e9bY/e+ni
         yJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707243815; x=1707848615;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StTdsqJeWRwYgnUE0gfc2tZBO/xSMu2em6FgEzzImwA=;
        b=Z9KjBxIFeDUCDU9ERXt9P4mJ+B63/BrrWXG8WEyRn1StX/2n54bN/BQBZYIa+O66Th
         lOdQAAap61jaeX2aJRAIEBlw/9XE9w0XVyjndDJ5nncNki/FQ/FILa1kltQWUa5U9XNn
         8SZH3Ko96L/WVqreuSP9ChThiupIAoXmjTIwR5ld/0zSTPdX05EX+Y7WwyWPuKRpHHiu
         UVFpk4NLgFbmQX/0lcoKssX9TgYkYruaHYMJjq2sAfCyEROUiSeWoTmL7NK//k+sNCap
         03mvODnpYjmgyTFdZsOPlGWKcwk2XAAbPefxexG9IL2rWhV4ca9+5MNQsoWbvKrbHrQZ
         18jQ==
X-Gm-Message-State: AOJu0Yxa62260iBreHU92hFZdsNdJ5mJ5sS8tTy8C2Uq79O7jvQK0xQ6
	iMes71ZkWQr3tvsMHaoHdAKa1fAjzkeYCFwcEn0IoHCUZ8u536JB5rk5CdKDE7KLIWCuKTFdvLI
	g
X-Google-Smtp-Source: AGHT+IFX7XCR0Q5YRSoKZg7418uoPiAHYK8UYwifXfS7/OKXIuFXXI0pYHyYgWAc7Rq+fIhFhHNzgw==
X-Received: by 2002:a17:906:3b48:b0:a37:2b5a:e945 with SMTP id h8-20020a1709063b4800b00a372b5ae945mr2727603ejf.4.1707243814794;
        Tue, 06 Feb 2024 10:23:34 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWiS+jmI0YA9eEHh/CXKlOJGpW2782qT4/TV4msvtKAuSRgrngmRLzy00f5bfLDM6RySDZ2PK+K2YjWmlXwffO6o29w
Received: from ?IPV6:2003:f6:af18:9900:571f:d8fb:277e:99a5? (p200300f6af189900571fd8fb277e99a5.dip0.t-ipconnect.de. [2003:f6:af18:9900:571f:d8fb:277e:99a5])
        by smtp.gmail.com with ESMTPSA id qo4-20020a170907874400b00a35cd148c7esm1400396ejc.212.2024.02.06.10.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 10:23:34 -0800 (PST)
Message-ID: <e9e35d1e-3aa1-4045-a047-d920761b2fb8@grsecurity.net>
Date: Tue, 6 Feb 2024 19:23:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: x86: Fix broken debugregs ABI for 32 bit kernels
Content-Language: en-US, de-DE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <20240203124522.592778-4-minipli@grsecurity.net>
 <ZcEtExGzJKCnuRLg@google.com>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZcEtExGzJKCnuRLg@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05.02.24 19:46, Sean Christopherson wrote:
> On Sat, Feb 03, 2024, Mathias Krause wrote:
>> The ioctl()s to get and set KVM's debug registers are broken for 32 bit
>> kernels as they'd only copy half of the user register state because of a
>> UAPI and in-kernel type mismatch (__u64 vs. unsigned long; 8 vs. 4
>> bytes).
>>
>> This makes it impossible for userland to set anything but DR0 without
>> resorting to bit folding tricks.
>>
>> Switch to a loop for copying debug registers that'll implicitly do the
>> type conversion for us, if needed.
>>
>> There are likely no users (left) for 32bit KVM, fix the bug nonetheless.
> 
> And this has always been broken,

Jepp, that's why the fixes tag mentions the commit introducing the API.
I also mentioned it already last year, tho[1]:
"... The bug (existing since the introduction of the API) effectively
makes using DR1..3 impossible."

[1]
https://lore.kernel.org/kvm/20230220104050.419438-1-minipli@grsecurity.net/

>                                  so if there were ever users of 32-bit KVM, they
> obviously didn't use this API :-)

Well, I do remember having issues with hardware breakpoints in
combination with 32 bit guests. But that was *years* ago -- maybe even
decades. Man, I'm old!

> 
> If the code weren't also a cleanup for 64-bit, I would vote to change the APIs
> to just fail for 32-bit.  But there's just no good reason to assume that the
> layouts of KVM's internal storage and "struct kvm_debugregs" are identical.

Thanks!

