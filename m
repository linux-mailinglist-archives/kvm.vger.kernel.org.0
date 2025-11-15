Return-Path: <kvm+bounces-63285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E85A5C60018
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 06:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B346E4E10A5
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 05:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E564B1ACDFD;
	Sat, 15 Nov 2025 05:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Nr1KZ8IK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5431B35CBC5
	for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 05:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763183382; cv=none; b=WpabK+iNwIfJZ0F9dvG0kFNO6kS2oVufCwOcxq+phpDP1EwuyXH0ELJeCPyi5oR8MRJRmoR5ilBXDYERALsYdQV9Ix2ztXtYluYcJz6sLRyz0+9c6DKHTmmbzuFaE4Fk318Exva/bwCxPE5ShxpZjQ9VSHrMveQccpTVLr6KCz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763183382; c=relaxed/simple;
	bh=Y5l4LXuIo9Ut8kD4BxdTLUvk9B10HCXPkbcL3moAxR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bg2k5eqRrv3iwQNCtmd58ocV49bSSfOTRWO0Yh2N5eMJH0M3QxeK8uNH43BDFUZCjyc/r6l3C7AbToSYVhFrMgLFJVPSOoMsIHalgu1GcA7T7OzZZt2XxDQwmJulh5iCS4jWfWVx6bG4BQK87/wYBl8DhNFLQdPRQGwm/SiydFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Nr1KZ8IK; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429c8632fcbso1822825f8f.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 21:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763183379; x=1763788179; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2SM8vJaCP6gM3RIX0En3VS26T9A8FE5y76lajobq/KE=;
        b=Nr1KZ8IKzLap3x1gY15RyHMxhu3Jsn95gyOvyEdiJGK/kiMk4P7/ViIYIXMUy/vVUq
         B5CiQIt2piRL/SzNMOhc4HC/UW94Wkm+UkabRWUnJWMwPffMew3aByOy/bcbe3th3QvK
         HZl2B29PWtcSbJom7JPyoMytpNO8VcIIinkOhzF2A2OSBbPENzC4NnxRItiBIFXXABbC
         gXOdgR4XTGNgWGk8OOY0z7HcZoSVYXwDBBVdTvXwwjdDzC3wqd+Y7jj3fsNKjKMrs3Dy
         GfOf0cpPPpJ2mW7dV2s8UcIcRfTlVaCiCkiltSedwE+rjYWhjKtshMFFc5voNSGAx18R
         BSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763183379; x=1763788179;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2SM8vJaCP6gM3RIX0En3VS26T9A8FE5y76lajobq/KE=;
        b=r1YK7Opw5EMhbSEAMTl4GXqauM6Nwdh41RAPG4Jqdq2dkfc7k+B9xKUmIDukGZtFZs
         iiJFGIohqt5Y1F7CztmKSPvQ3ylHI2cz3G/qfucLKrViXic+DKtpRnBULtOHddO5QjWp
         flOOjSnLfZsJqqLzIH/lTcVXqoKxha+C0UQmHXSk30DHT9iUnxwQdvwk0gXagifLP5ck
         L7kBJJC6zhfLhjrtVww5b9JjCdR6N2g/HHruNvJ2xc5I2hhZ9srbZ+GuNihLDLbaIzBV
         Lg2NALSQJOK1nMgdMbFalNTiSKB6FwDIadXFFBqvfeBVWln/WX7a8TLTcU/1iEJ6UgAl
         mtUg==
X-Gm-Message-State: AOJu0Yx6RZsaxasYskp++iqxWUMieuG+BDY6u2bPHPl0oPTbgKBGUZ0N
	spxYGAtjpYSW4RLAHaSW5iEbjMmBkTiderKe1WQoZP1xciZa7G+U4TbqERKMc2qB8Xw=
X-Gm-Gg: ASbGncvgQtxWUJQdmkcBVahv1qafKCUdAJNXsz5RObf9GUho/AlD7o/X2vfT9Bey4hR
	Snbsf8PE0kFXoFrfwEHPAMA1c3Wx6e0a8eVpruvPYPTx7YnlkKUXzh8yCypEMrcxEGfhgCnN8O8
	ESQCfQKS5q04hDe/sfz6QPGa23Shj7iSzwtzTQSzvOO4W5KNExmllVn0xarkTK1nhAhHIJj5uwE
	755yCf2Kn9GHSjf0cVTPYuOt1Tnu4wRIcVyz2nvSBpclDimccJb0eq8n8eBBYe3gb17VlZU9UF3
	8EW1Ql1nFyl+boP8emGlgXe4mIFuKDAlqev2PSUvOoKDs9mkXEU298plIeqfl/9laTX2y+m6vMf
	xTX6g4z49lEOcif7/reXiDUC0ofBA7cvPhP8JPNjO4Px5LNg9jmzjW+xN7DGY/JhUsCIXEB8HGf
	ab5u4suud3b+P26nevvcfcu/VIWRVEKpXG0JHC4mqaYQ2T3SPmK8k2hmIjN3FKC1cq2UDdu4ofU
	BqB7YYPULKM6UOEJDykZh2AH4v27/0b0Kc=
X-Google-Smtp-Source: AGHT+IFA6Ht5Z3LA0vnNN3PteOmWcpqypx7ObBpK936IWzAZs4muXPzNKwLVRBN6h4UjoM3G0gqCRA==
X-Received: by 2002:a5d:5885:0:b0:42b:3bc4:16c9 with SMTP id ffacd0b85a97d-42b59373ee4mr4642971f8f.51.1763183378686;
        Fri, 14 Nov 2025 21:09:38 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f174afsm13496601f8f.33.2025.11.14.21.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 21:09:38 -0800 (PST)
Message-ID: <7d84127d-f7ee-435f-8a77-923b74a695a6@grsecurity.net>
Date: Sat, 15 Nov 2025 06:09:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 01/17] x86/run_in_user: Add an "end
 branch" marker on the user_mode destination
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114001258.1717007-1-seanjc@google.com>
 <20251114001258.1717007-2-seanjc@google.com>
 <dbe12f67-79d0-4d92-b510-56f32401e330@grsecurity.net>
 <aReVN65Tgaanqd_l@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aReVN65Tgaanqd_l@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 21:46, Sean Christopherson wrote:
> On Fri, Nov 14, 2025, Mathias Krause wrote:
>> [...]
>>
>> Attached is a patch on top of [1] that does that but is, admitted, a
>> little hacky and evolved. However, it shows that above ENDBR64 is, in
>> fact, not needed.
> 
> You say hacky, I say clever and correct. :-)
> 
>> diff --git a/x86/cet.c b/x86/cet.c
>> index 801d8da6e929..bcf1ca6d740a 100644
>> --- a/x86/cet.c
>> +++ b/x86/cet.c
>> @@ -1,4 +1,3 @@
>> -
>>  #include "libcflat.h"
>>  #include "x86/desc.h"
>>  #include "x86/processor.h"
>> @@ -192,6 +191,10 @@ static uint64_t cet_ibt_emulation(void)
>>  #define CET_ENABLE_SHSTK	BIT(0)
>>  #define CET_ENABLE_IBT		BIT(2)
>>  #define CET_ENABLE_NOTRACK	BIT(4)
>> +#define CET_IBT_SUPPRESS	BIT(10)
>> +#define CET_IBT_TRACKER_STATE	BIT(11)
>> +#define     IBT_TRACKER_IDLE			0
>> +#define     IBT_TRACKER_WAIT_FOR_ENDBRANCH	BIT(11)
> 
> For this, I think it makes sense to diverge slightly from the SDM and just do
> 
>   #define CET_IBT_TRACKER_WAIT_FOR_ENDBRANCH	BIT(11)
> 
> because...
> 
>>  static void test_shstk(void)
>>  {
>> @@ -244,6 +247,22 @@ static void test_shstk(void)
>>  	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
>>  }
>>  
>> +static void ibt_tracker_fixup(struct ex_regs *regs)
>> +{
>> +	u64 cet_u = rdmsr(MSR_IA32_U_CET);
>> +
>> +	/*
>> +	 * Switch the IBT tracker state to IDLE to have a clean state for
>> +	 * following tests.
>> +	 */
>> +	if ((cet_u & CET_IBT_TRACKER_STATE) == IBT_TRACKER_WAIT_FOR_ENDBRANCH) {
>> +		cet_u &= ~IBT_TRACKER_WAIT_FOR_ENDBRANCH;
> 
> ...this is quite weird/confusing.  It relies on CET_IBT_TRACKER_STATE being a
> single bit, and "(x & y) == z)" is very un-idiomatic for a single bit.

Well, it doesn't rely on IBT_TRACKER_WAIT_FOR_ENDBRANCH being a single
bit, but a value with all ones.

Essentially what I wanted to do was (in pseudo-code):

  if cet_u.tracker_state == WAIT_FOR_ENDBRANCH:
     cet_u.tracker_state = IDLE
     wrmsr(MSR_IA32_U_CET, cet_u)

I tried to make clear that it's the IBT tracker state, the code is
interested in. But yeah, it's a single bit with only two states so just
testing and toggling that single bit is fine.

Initially I thought that setting CET_IBT_SUPPRESS is needed was well,
but it's not. It's related to the "legacy handling" which is yet another
can of worms we haven't opened yet ;)

> 
>> +		printf("CET: suppressing IBT WAIT_FOR_ENDBRANCH state at RIP: %lx\n",
>> +		       regs->rip);
>> +		wrmsr(MSR_IA32_U_CET, cet_u);
>> +	}
>> +}

