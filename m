Return-Path: <kvm+bounces-50414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB56AE4E24
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F7A1189C718
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83162D5438;
	Mon, 23 Jun 2025 20:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Ik3UXai9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9153822F77F
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 20:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750710587; cv=none; b=GwgMAdZTQy+u82CajhsntjUkbFnA0+posrVDb0xyXVYg1+H40zjySGc0GCVLSD45UHienz9jiXh7zMLJC7f2HdgoHU9ZGywudREOT5lPqSPlFo+pks4V6rZ80EmAfQULnnmek6aDfdCRj+S9FBvcxIHBaBYIZcWZVrws3GdH1Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750710587; c=relaxed/simple;
	bh=MUTbeSlMElSRYbL7xBsyJJMC9HYGdeNhwGY4pzloeDw=;
	h=Message-ID:Date:MIME-Version:From:Subject:References:To:Cc:
	 In-Reply-To:Content-Type; b=KTUmne+NzLCC9gG/0sk/f/C2mpC9v1XAJ4cFGvSdJvfm1GX6j5Ya2hLl5iDlUUIHVSOFUfA0WQydvc40P/J+ABQEu3Q6UpPtEUBO89k7ZHH45cQAgVYTNNXcU3Hwz3IG3oRlRHPFnFU6IymCWzQAQnIkRf4PT2kXtpgxIVAsXlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Ik3UXai9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-235a3dd4f0dso31753615ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750710585; x=1751315385; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:cc:to:reply-to
         :content-language:references:subject:from:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uspidLfgJvUSMKS6dpb2FfJ1dJx24s+/Cz+Y3SmG7mI=;
        b=Ik3UXai9+fw9oBtJC2dCrr4vRulyKzeTsJW03lFucchywSOokvh0yF4dC28u1cMs5i
         6Yf+NsJIgPhPtIg1MxwiZAtWvcm0VBAwUHkbWnoJUvxnujs7iwy9cbtCuN8tsHg2GBiW
         CSYpUWsJLeGeTpp0SYTlMxL7p3YApAwaojRGCecaYL3nFjXs3RWLVkxgfNBfMlyVQv9h
         WNoWGatr/O4uOZzBC4Yitv8bV7Ck5UZxPZ85CvOYFVWI0EC0nkG1x++rTH1f2sERJrW6
         L2sK1nS/p/jbg8lGOJ0im7/7imh6rQwLpy+NYgN5LWovZB8iZ2eE5Kew/8aZUHF9GDZ/
         DxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750710585; x=1751315385;
        h=content-transfer-encoding:in-reply-to:autocrypt:cc:to:reply-to
         :content-language:references:subject:from:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uspidLfgJvUSMKS6dpb2FfJ1dJx24s+/Cz+Y3SmG7mI=;
        b=Roqx9bKKPpERLmtlL/RN0WjOgFk2ezi34zkiue2arNfcjOEQVzW3LDqfVQXtMeANQ4
         AaZiPIVaiG57QRvVHJOpUB08C93s7fyYzJn2hOyfVEoKbH6T+XKil1qQ+LFUgzNUl3ar
         8T9u8+YBWGeCBH7gXiFIQTniZ8SY5nJ/Ogw+VekTIq8bHtrFhSxWttCg/kL0V9TsDaKh
         aGbBQmDI0e2il4BRm+sHp+StHuzvGKTtjhrvlhoiBg9hJczsFYORVZ/6Lje2jh0mBpcu
         vXXaC4OU66V6bX2L3XinAD3SCyrTRLsxZSuWvL1eyrPMzQG1jtRyDcN4TY81wuedoq5f
         WlWA==
X-Forwarded-Encrypted: i=1; AJvYcCVPMgXX68mDAs100h0daMxhJU/9gvITJHC2Mx9yHIJfFu/BAKGnUvwpWUKNJLLSe0iJXlY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/OdrwQDGJ/hr61MbmNOlHNQnu9mUqBqVVSvNVqyoHMX2yv4h8
	W0idZ8P2PtAtT0HOVMnWdSPlXRcJdjyXQoxoLETQ7aKI0IDVxG8uYnkezCVnPShfeRg=
X-Gm-Gg: ASbGncvuZcS1KUeHkFQQAi7nZ8B7BoNo38RH+j9O0Ew5nBiikrJiCFpQwciZpUs5eDG
	4aSOKxE8SFHevMja7TlFKDAN6feFcZnHAvu+yLOuWMlRWsId8LIZfLwYsuHMAAcoXd0raZkcS/2
	RBw5hpLyoaWEtHKeI/rS1r6tFNhgvJHrP4HdqLl1YqZKWQ6dBBlk5ZpuPwVZOyOrkuy8QznBkvZ
	1LBTyqay1EUYTHfhDN8CPjYa12oo3qHUE//4EekyltpHi+RvNXEpeahCskH/lMBkJiVUsrHcI4B
	mg8vrIgqmioWJqvFnBXJctNpbTbe8PQFnqPSEdJ4u+rqlhSL8IakfF5xMIL9D182QFiyvUufVx8
	lUPW1flKFrqE67uEc+9sqDBrKR1fNa0vpNtsHcJXFroY61M1nKP3JRg3itCSKPphlGeH9sDrLUl
	efm++XBLnmCeIydpITG/M=
X-Google-Smtp-Source: AGHT+IH46xuxqoQ4c5WdFOaIpGG0nJe7BFSQ8BH9zshg2/l6yRiyFeILDOhbIVZfCczDgJe85/w6QQ==
X-Received: by 2002:a17:903:11c4:b0:235:f45f:ed49 with SMTP id d9443c01a7336-237d986fc49mr239299325ad.33.1750710584842;
        Mon, 23 Jun 2025 13:29:44 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d866b664sm89176675ad.169.2025.06.23.13.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 13:29:44 -0700 (PDT)
Message-ID: <8b2eb284-efb7-42d2-aaea-e9568e23f594@grsecurity.net>
Date: Mon, 23 Jun 2025 22:29:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 6/8] x86/cet: Simplify IBT test
References: <e53b66b9-6b32-4834-a34e-17c307c19a82@grsecurity.net>
Content-Language: en-US, de-DE
Reply-To: Mathias Krause <minipli@grsecurity.net>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <e53b66b9-6b32-4834-a34e-17c307c19a82@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[resend with kvm@ on cc]

On 23.06.25 07:32, Chao Gao wrote:
> On Fri, Jun 20, 2025 at 05:39:10PM +0200, Mathias Krause wrote:
>> static uint64_t cet_ibt_func(void)
>> {
>> +	unsigned long tmp;
>> 	/*
>> 	 * In below assembly code, the first instruction at label 2 is not
>> 	 * endbr64, it'll trigger #CP with error code 0x3, and the execution
>> 	 * is terminated when HW detects the violation.
>> 	 */
>> 	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
>> -	asm volatile ("movq $2, %rcx\n"
>> -		      "dec %rcx\n"
>> -		      "leaq 2f(%rip), %rax\n"
>> -		      "jmp *%rax \n"
>> -		      "2:\n"
>> -		      "dec %rcx\n");
>> +	asm volatile ("leaq 2f(%%rip), %0\n\t"
>> +		      "jmpq *%0\n\t"
>> +		      "2:"
>> +		      : "=r"(tmp));
> 
> @tmp isn't needed. We can still use "rax" and list it as clobbered. 
> 

I still prefer letting the compiler choose a fitting register. This also
makes it easier to enable this code to be 32-bit ready. So 'tmp' may
seem unnecessary, but it's a vehicle to allow the compiler to choose an
unused register. RAX needs to be set to zero, after all.

Thanks,
Mathias

>> 	return 0;
>> }
>>

