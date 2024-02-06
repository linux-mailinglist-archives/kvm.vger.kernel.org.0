Return-Path: <kvm+bounces-8128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC8A84BCF2
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 614FB1C20292
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 18:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E79C148;
	Tue,  6 Feb 2024 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="StBOuqaH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACD134C3
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707244233; cv=none; b=OLlFtT5NimfHkZJuZ9xqA0tBFF+wYieWKZ2ZbQLOg3n6uhkGq8mXGoyxeOdb3geaklmza/E+2YfqbyzY/iSr3EUQX3UDi9qOCaRriPP8hyo5JVi0obnPrYzfMc4Q5oiJnDtmxuA5TQnmnkAm92WUOqmWVek770uHTR201JypRwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707244233; c=relaxed/simple;
	bh=e7367HiuTIgOjGKt1dhIzNpPH/PqUb1lItfEODOblpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WVPZvntKh5Elw6OC/S5Z/bs8SdkzYwra2CECTzBgLRdanBbxXHEd0jEIjWuwnWObvYlEJt92TX1LwbL1ImX+iQnhW4ZOwLjJeOJ1BdI9RVe17tGgcYnD44p4ofL6RCD0zSLGjStJ/pjsoxxqumfklWRewr3pPV3OguOh2tiKWSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=StBOuqaH; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5600d950442so1502642a12.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 10:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1707244230; x=1707849030; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GABUZuAioDBDuZt1CwqcwaLffD+ZnRUCju2IZbwi/jk=;
        b=StBOuqaH/YD5CBJ5UB0RQCBnIJpx3RZk8Hmfw8J3et3eRt87/sYbpYDD9lRMoRn1M2
         dzyNgu2+dTiSysokT0DKz1wJ7RJmIKykv5oO4lb98GTx4khHZUPZBEGyTunYYOskR8KF
         +/hhhiaz44ORYbOhxoUSSmdqjPXsc0ep8oCKysFdD+DGLSzG9dpu5NPNzPXHjpRzu+CQ
         Y9LRIPDNmFrd2AWQUsylkQke+bONDXW2fyGzRmYEcIBCKS4YYQ5EygfD5UgdSU7ogqWH
         +PJXBUGf0y475KHhnecVktCMPJM/XEhx3sCHHOqCFRnQRTNa4xqooQeRAJtwQNgK5+4d
         IGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707244230; x=1707849030;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GABUZuAioDBDuZt1CwqcwaLffD+ZnRUCju2IZbwi/jk=;
        b=GGNT2eWUQU/v++1Shz0C0MrOu8W6LAMPZASqZ9h48UiUJxsG4YcfACTF7+4rdq8Gsp
         VGxWPEOSE3C7e7AytepMBgdDg3/egHDKZfdAeYKjam/oAIJe5BRqU7KiNCnIUUVvqdGW
         fiQwV5yv5HJPeXEsJbu8ngHjf5bBW218cC6dmoL9P8JUWXMJRNrBfsS83sVKOOqF5Kly
         5BbHt5oS60/aYDR77jzqRxsYVi5ZkYt+4WoguejfLnddcCl+tEGGna9n6VWumS+yhRx1
         ZMsPaadYNLPwQDFLCm0daIoS+/D2DAJGWH7RaGj+gFKhuXODGDB5HW93eAD5bnuenvLH
         RGuw==
X-Gm-Message-State: AOJu0YxK5ycnVp6yR/WSnYTRcPsBz3P8KNBYqwaHGLktFlzpJ4DKfwvI
	URNP3PDdk424OQpQRUavIkAEA9XecLcgtTM1z1Q9rg0GEzUbWOYfJ/h2NkzCs3c=
X-Google-Smtp-Source: AGHT+IGGuikL6RHwAWmzYtJaOn/EvjMCeA1KmUqqur2QjE7uTPHZaTtscn6GiFHOCd8XIS702nRFGA==
X-Received: by 2002:a17:906:13d6:b0:a37:b6e9:478 with SMTP id g22-20020a17090613d600b00a37b6e90478mr2515448ejc.72.1707244229870;
        Tue, 06 Feb 2024 10:30:29 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCX63bxbR1eaFxZldvQFVawxDXUyWgfZMrSn/62PoHOZtmBadfJBuJhEKVdBX7pdbm9xZZqcHGHmktrW+Mv5cAltaFOi
Received: from ?IPV6:2003:f6:af18:9900:571f:d8fb:277e:99a5? (p200300f6af189900571fd8fb277e99a5.dip0.t-ipconnect.de. [2003:f6:af18:9900:571f:d8fb:277e:99a5])
        by smtp.gmail.com with ESMTPSA id h11-20020a170906718b00b00a36fc7f0f85sm1434778ejk.47.2024.02.06.10.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 10:30:29 -0800 (PST)
Message-ID: <1505cc9c-ce3d-4fda-95f1-3ab9f028a1a2@grsecurity.net>
Date: Tue, 6 Feb 2024 19:30:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
Content-Language: en-US, de-DE
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240203124522.592778-1-minipli@grsecurity.net>
 <20240203124522.592778-3-minipli@grsecurity.net>
 <ZcE8rXJiXFS6OFRR@google.com>
 <86024ab8-0483-42a2-ab71-56c720b01b9e@grsecurity.net>
 <ZcJ5YqJhSOrt-GMk@google.com>
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZcJ5YqJhSOrt-GMk@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06.02.24 19:24, Sean Christopherson wrote:
> On Tue, Feb 06, 2024, Mathias Krause wrote:
>> On 05.02.24 20:53, Sean Christopherson wrote:
>>> On Sat, Feb 03, 2024, Mathias Krause wrote:
>>>> Take 'dr6' from the arch part directly as already done for 'dr7'.
>>>> There's no need to take the clunky route via kvm_get_dr().
>>>>
>>>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>>>> ---
>>>>  arch/x86/kvm/x86.c | 5 +----
>>>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 13ec948f3241..0f958dcf8458 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -5504,12 +5504,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>>>>  static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>>>>  					     struct kvm_debugregs *dbgregs)
>>>>  {
>>>> -	unsigned long val;
>>>> -
>>>>  	memset(dbgregs, 0, sizeof(*dbgregs));
>>>>  	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>>>> -	kvm_get_dr(vcpu, 6, &val);
>>>> -	dbgregs->dr6 = val;
>>>> +	dbgregs->dr6 = vcpu->arch.dr6;
>>>
>>> Blech, kvm_get_dr() is so dumb, it takes an out parameter despite have a void
>>> return.
>>
>> Jepp, that's why I tried to get rid of it.
>>
>>>          I would rather fix that wart and go the other direction, i.e. make dr7
>>> go through kvm_get_dr().  This obviously isn't a fast path, so the extra CALL+RET
>>> is a non-issue.
>>
>> Okay. I thought, as this is an indirect call which is slightly more
>> expensive under RETPOLINE, I'd go the other way and simply open-code the
>> access, as done a few lines below in kvm_vcpu_ioctl_x86_set_debugregs().
> 
> It's not an indirect call.  It's not even strictly guaranteed to be a function
> call, e.g. within x86.c, kvm_get_dr() is in scope of kvm_vcpu_ioctl_x86_get_debugregs()
> and so a very smart compiler could fully inline and optimize it to just
> "xxx = vcpu->arch.dr6" through dead code elimination (I doubt gcc or clang actually
> does this, but it's possible).

Oh, snap! I got confused by your later patch which had all the indirect
calls. But yes, for arch/x86/kvm/x86.c you're right, gcc is smart enough
to inline it. I guess, clang can do that as well.

Thanks,
Mathias

