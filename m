Return-Path: <kvm+bounces-50352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3E9AE44E5
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1ECB57AC2FE
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3109D2528F7;
	Mon, 23 Jun 2025 13:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="MKtZpyZB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B890347DD
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686139; cv=none; b=qvsFdlMa3RKU9HDtTNWhRgqmiOVjx9XkG7p5ikMDtYHhjN+iYLxQMsC+bxJ+elDt+oT7e7uq6iPTqGQbzDzJZ0qu2gXBRpw0G+9roCC4Oe6phFlC17LIhiu8D0sm+2WxebjIGlduGbRJjG1q5WEFwHOr7DehVRyYXsaPMsSBXPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686139; c=relaxed/simple;
	bh=CrRsKDVPyJ/LDCb7jZywiywGzx1w9Jk9OLxIhYiBAQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tnAwPr8d3aga8RlwuWjjLjCyUxEcX2HBlc9WUvVt2x7oV9sCm9neOKUvQ7p8n3vooQY86GB/RNqouGTIs5Lt33TsX30BSHKCS6wogdeAPYZmk16pXmI99FnnbmrWSGigM4Bo73kM/hHE0uq/uiNOMklV0llep/6QAgTaXdWZc2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=MKtZpyZB; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-23633a6ac50so58024595ad.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 06:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750686136; x=1751290936; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PftUyQ0Msb1KfMfvQtr5afZD4s8ype5Bn31YXQgjZhQ=;
        b=MKtZpyZB0uYLfZG/Lj82A7B+5fbslP5KwjTiHwxIlVa/dUJF3WAGwO2CIW6oWqSocG
         mdlDMZhQfFXc6Ei7SK7QEwiYFQ8MFolQGdXKn8GJ4WmusbPvExEiWE3ErYZVWhPooM0H
         UpbToMbMrhlZqInXPQUN9TxaR0ksvEyZWdD92aPxJhWtXiuHubZfZXgCHg1v1vySZ7MC
         5mGyTHvYpit1by4rxpcFuMntxnwqHzeqIeHu3rjx2bAq+DYHcBJ/4JcvG6RVHYmi90Av
         8QWf2lHfqZv33PxyCtrHvHuyO4h9xAdeKZJ7YyN+qQrv8DZGIUrrt/Cud5WWFC/bLJJ3
         0XUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750686136; x=1751290936;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PftUyQ0Msb1KfMfvQtr5afZD4s8ype5Bn31YXQgjZhQ=;
        b=YeCffC+tH9GnwwInkLhDWjyn29OkmAd/k8B86a/nft43JPly4eHA6NtjGnfsMmOWb2
         WJJjmDkEVhkUmZDQXreL8c0BKcrIOiz7HJ6Gloe6Dmh3R+MZt4arX1WrfM0+rh1fFGK8
         F0JtFxlMMO7IEFVfGqMSfXw6WShO3s3tIWOkPnGCHFyw2hnhXr46EJOdGf39QEMQuOuz
         +FHEA68iMT0CjWHmgzwNteLuN3fXsacaHe1/aPwVnE7wVb7r4hZcX1nS6EVCChU6K9Fm
         mALfPLC4tOEeIMcYNjZhlz++aue4EqWhLeCNjzSnxe/3fouLmOsFM3NUsH7lBvpxI+B9
         wd3g==
X-Forwarded-Encrypted: i=1; AJvYcCXEWCgDagMOOT9pJ8gSazEBzOdaHlokT2m6CUhG1qzDEmAGpFiETWLiqdUizc+fZphzBFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeMs30x+tvfN36DFL2TLY2jD25YyyKw7rOwbyGYgfzlkEwq5+u
	yBuCShK7br5Zphkgc3QhvxRS433PFVCFK6+zkti83MlxXNdCWIlZoqLc4Z+eHThYoVU=
X-Gm-Gg: ASbGnctZZJY6uWPmwPGB5a4+AF5AFsVHsyhFy8O3EJMWwd/tptbWJ9iYXUFwpQ/QKre
	aD9r5tnlXMpD19ZHr3esbfyPM4eA8TfwzPgP5TCb4O4RpElSFOQZcwcaNE7UoiK5/qkZzfFPMWB
	cjrQGFdCTLRL4s/m14uhp+/lNaLUiUvJL0szvk1OMH6GfjyDH4Tu7vA3swyW61BMW5npuBeOpf1
	77opMTlR7sxdVpZv7YW52PsKn6WbzqiCNT4KUlO49Q2mytVNi+U3dirjVCzqM9tCI2pIrdWGYe5
	WbVLfqvKAYfRaEn7en2lCq4S4L26CX6BfPWtRjijaEurVV4GuBT8wupmS51WqoY1SuwFBE+uUrL
	D6AEFfXYXQmbRuH6nSnBKg6INUo5BnTI=
X-Google-Smtp-Source: AGHT+IHypS+xDzz1U879jtpZhGUvigf9tfNSNnVtuy85SG8m6dKZiZYIxSM/kZgALCzpYtJTzcvwkQ==
X-Received: by 2002:a17:903:2f86:b0:235:caa8:1a72 with SMTP id d9443c01a7336-237d98537fbmr178038585ad.30.1750686136362;
        Mon, 23 Jun 2025 06:42:16 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a23e1a7sm10669858a91.11.2025.06.23.06.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 06:42:15 -0700 (PDT)
Message-ID: <b9203c8d-4c34-4eb3-a94f-5455cfc2eb53@rivosinc.com>
Date: Mon, 23 Jun 2025 15:42:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH] RISC-V: KVM: Delegate illegal instruction
 fault
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 anup@brainfault.org, atish.patra@linux.dev, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv <linux-riscv-bounces@lists.infradead.org>
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
 <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com>
 <1d9ad2a8-6ab5-4f5e-b514-4a902392e074@rivosinc.com>
 <CAPYmKFs7tmMg4VQX=5YFhSzDGxodiBxv+v1SoqwTHvE1Khsr_A@mail.gmail.com>
 <4f47fae6-f516-4b6f-931e-92ee7c406314@rivosinc.com>
 <CAPYmKFvT6HcFByEq+zkh8UBUCyQS_Rv4drnCUU0o-HQ4eScVdA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <CAPYmKFvT6HcFByEq+zkh8UBUCyQS_Rv4drnCUU0o-HQ4eScVdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 23/06/2025 15:30, Xu Lu wrote:
> Hi Clément,
> 
> On Mon, Jun 23, 2025 at 8:35 PM Clément Léger <cleger@rivosinc.com> wrote:
>>
>>
>>
>> On 23/06/2025 14:12, Xu Lu wrote:
>>> Hi Clément,
>>>
>>> On Mon, Jun 23, 2025 at 4:05 PM Clément Léger <cleger@rivosinc.com> wrote:
>>>>
>>>>
>>>>
>>>> On 20/06/2025 14:04, Radim Krčmář wrote:
>>>>> 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
>>>>>> Delegate illegal instruction fault to VS mode in default to avoid such
>>>>>> exceptions being trapped to HS and redirected back to VS.
>>>>>>
>>>>>> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
>>>>>> ---
>>>>>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>>>>>> @@ -48,6 +48,7 @@
>>>>>> +                                     BIT(EXC_INST_ILLEGAL)    | \
>>>>>
>>>>> You should also remove the dead code in kvm_riscv_vcpu_exit.
>>>>>
>>>>> And why not delegate the others as well?
>>>>> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
>>>>>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)
>>>>
>>>> Currently, OpenSBI does not delegate misaligned exception by default and
>>>> handles misaligned access by itself, this is (partially) why we added
>>>> the FWFT SBI extension to request such delegation. Since some supervisor
>>>> software expect that default, they do not have code to handle misaligned
>>>> accesses emulation. So they should not be delegated by default.
>>>
>>> It doesn't matter whether these exceptions are delegated in medeleg.
>>
>> Not sure to totally understand, but if the exceptions are not delegated
>> in medeleg, they won't be delegated to VS-mode even though hedeleg bit
>> is set right ? The spec says:
>>
>> A synchronous trap that has been delegated to HS-mode (using medeleg)
>> is further delegated to VS-mode if V=1 before the trap and the
>> corresponding hedeleg bit is set.
> 
> Yes, you are right. The illegal insn exception is still trapped in M
> mode if it is not delegated in medeleg. But delegating it in hedeleg
> is still useful. The opensbi will check CSR_HEDELEG in the function
> sbi_trap_redirect. If the exception has been delegated to VS-mode in
> CSR_HEDLEG, opensbi can directly return back to VS-mode, without the
> overhead of going back to HS-mode and then going back to VS-mode.
> 
>>
>>
>>
>>> KVM in HS-mode does not handle illegal instruction or misaligned
>>> access and only redirects them back to VS-mode. Delegating such
>>> exceptions in hedeleg helps save CPU usage even when they are not
>>> delegated in medeleg: opensbi will check whether these exceptions are
>>> delegated to VS-mode and redirect them to VS-mode if possible. There
>>> seems to be no conflicts with SSE implementation. Please correct me if
>>> I missed anything.
>>
>> AFAIU, this means that since medeleg bit for misaligned accesses were
>> not delegated up to the introduction of the FWFT extension, VS-mode
>> generated misaligned accesses were handled by OpenSBI right ? Now that
>> we are requesting openSBI to delegate misaligned accesses, HS-mode
>> handles it's own misaligned accesses through the trap handler. With that
>> configuration, if VS-mode generate a misaligned access, it will end up
>> being redirected to VS-mode and won't be handle by HS-mode.
>>
>> To summarize, prior to FWFT, medeleg wasn't delegating misaligned
>> accesses to S-mode:
>>
>> - VS-mode misaligned access -> trap to M-mode -> OpenSBI handle it ->
>> Back to VS-mode, misaligned access fixed up by OpenSBI
> 
> Yes, this is what I want the procedure of handling illegal insn
> exceptions to be. Actually it now behaves as:
> 
> VS-mode illegal insn exception -> trap to M-mode -> OpenSBI handles it
> -> Back to HS-mode, does nothing -> Back to VS-mode.
> 
> I want to avoid going through HS-mode.

Hi Xu,

Yeah, that make sense as well but that should only happen if the VS-mode
requested misaligned access delegation via KVM SBI FWFT interface. I
know that currently KVM does do anything useful from the misaligned
exception except redirecting it to VS-mode but IMHO, that's a regression
I introduced with FWFT misaligned requested delegation...

> 
>>
>> Now that Linux uses SBI FWFT to delegates misaligned accesses (without
>> hedeleg being set for misaligned delegation, but that doesn't really
>> matter, the outcome is the same):
>>
>> - VS-mode misaligned access -> trap to HS-mode -> redirection to
>> VS-mode, needs to handle the misaligned access by itself
>>
>>
>> This means that previously, misaligned access were silently fixed up by
>> OpenSBI for VS-mode and now that FWFT is used for delegation, this isn't
>> true anymore. So, old kernel or sueprvisor software that  included code
>> to handle misaligned accesses will crash. Did I missed something ?
> 
> Great! You make it very clear! Thanks for your explanation. But even
> when misalign exceptions are delegated to HS-mode, KVM seems to do
> nothing but redirect to VS-mode when VM get trapped due to misalign
> exceptions. 

Exactly, which is why I said that either setting hedeleg by default or
not will lead to the same outcome, ie: VS-mode needs to handle access by
itself (which is a regression introduced by FWFT usage).


> So maybe we can directly delegate the misaligned
> exceptions in hedeleg too before running VCPU and retrieve them after
> VCPU exists. And then the handling procedure will be:
> 
> VS-mode misaligned exception -> trap to VS-mode -> VS handles it ->
> Back to VU-mode.

I'd better want to let the HS-mode handle the misaligned accesses if not
requested via the KVM SBI FWFT interface by VS-mode to keep HS-mode
expected behavior. As you pointed out, this is not currently the case
and the misaligned exceptions are directly redirected to VS-mode, this
differs from what was actually done previously without FWFT (ie OpenSBI
handles the misaligned access).

To summarize, I think HS-mode should fixup VS-mode misaligned accesses
unless requested via KVM SBI FWFT interface, in which case it will
delegates them (which is done by the FWFT series). This would match the
HS-mode <-> OpenSBI behavior.

Thanks,

Clément

> 
> Please correct me if I missed anything.
> 
> Best Regards,
> 
> Xu Lu
> 
>>
>> Note: this is not directly related to your series but my introduction of
>> FWFT !
>>
>> Thanks,
>>
>> Clément
>>
>>>
>>> Best Regards,
>>> Xu Lu
>>>
>>>>
>>>> Thanks,
>>>>
>>>> Clément
>>>>
>>>>>
>>>>> Thanks.
>>>>>
>>>>> _______________________________________________
>>>>> linux-riscv mailing list
>>>>> linux-riscv@lists.infradead.org
>>>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>>>>
>>


