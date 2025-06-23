Return-Path: <kvm+bounces-50357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7304AE4644
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 560304A04E4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996F3221703;
	Mon, 23 Jun 2025 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xXRQJOrr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C663D145346
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 14:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750687878; cv=none; b=VSXASA28OLB/V9zhBZWEJym4JJUPGXcR+ojTmIpOhoIT8YzBvTr8CDSTPU4FBM9oxmavGdMw7UUWjIAjN2GukrJBYwFegABBAVHGsUNeSNI88CBk5Y5ahWQWtjF8wW1xzH2uRikcUDyb4zaCDaK5WjOZjfPCSl7zZ3Me2ZlT/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750687878; c=relaxed/simple;
	bh=nLpJdcMRA0PycrQurXF+ezZlCyf7g0yC6nQu363kRv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EIClxueoY7aXTG9gZYverK7RacjwZ75LdIAOoMgvirG+Fn08qHQ47KUCHalH7QGafo+MO/1BKrhJXyoiD8AohX19IfoP9IB1wW4h1FS7+IsnMsDYKl6gXOF7X7uMP+bHpQLPjvmMwP/EYrCz6YgyE8K9HOPb3bxLozdGGoVvICQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=xXRQJOrr; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22c33677183so38044925ad.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 07:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750687875; x=1751292675; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0JU0VDAOl0xp48slJP1HnDa01/Cn9JLDzXpC7kAL+XI=;
        b=xXRQJOrrpgLpgEfJ8fdCluF36WaGJklfVEwVvax0McmRzPmcubDQcCPfUvnxVIQj8z
         irzhar6GqmcZIlewJmczJ9AqiTxS/FjOpd7ddinG58HMxQbFqWbn+PwElSqLcoW+ae/Z
         CVLovcnY+rUuWGetq6OnaUdq7KprjOG4fiDogWxPmmh2kbp83kUHKIDsBC7FEntNY6oD
         yieCVxfL7lr0bio/bgkBmxLI8BlmSCErtS28TcUnG8YLRaNSBYoRZaqo4OCx2ZA/Xztd
         Q/tIqsmrcMI8bvq4QXNKozTFz48tRKHGOz1VlgUI7O0Ektp+xk/xsrf4sVOtwdCnJOEW
         w0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750687875; x=1751292675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0JU0VDAOl0xp48slJP1HnDa01/Cn9JLDzXpC7kAL+XI=;
        b=sWSFc+vRAF3WVQwb8gM6FqFg/gosudjmToVfT3Ino5yEbyLJlGPD/Iw+aPQn0piv5b
         ucJTEvCi9kkTREmUVPDHSmARtALsyvNeridbO+E6L6/1X+kxhUBTBZ2afp1nCwoGadc+
         p0YgIlY95GPrTIcgaGAMDgRGT2hoMCDVKCoNhJVb8MoxlVI6INFB6io9xH9SFuf1QgrN
         nviIr/2L/3FSKR88vZDwJeEUfBQcL/57VYG2mLd1/tP8NEJJM9PYGlsyIPK4tidsISJ8
         0guQd/XVJmJzio7O8o/CqpgZn5sA3Er76HvAW/yuU4aPAFOJrhHtCRBw9AThzzrExWD6
         WqSg==
X-Forwarded-Encrypted: i=1; AJvYcCXYBKmoEtMjNZSWCgM61hWdSCmIDDdmwU87faKYgSeHzGHtXPgcpO/GhfOlexE+QNUuLKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqsBnseN3MRK3ueZ8AwTTYN15xEIVIIOsyEhw6Axw7ysfsYf+w
	GRpHsXm/8o4mOxxrzYp78c9Yox4DEqsYVyMWzYtmfJ3MNO7YX1+Yxr2F3MmMuCG0l2Y=
X-Gm-Gg: ASbGncsnpfHPBRJdYAGp2iiWlSt+PKVgIX9KmfIYJoba0qXHAb2r3ma1Kdmdau1EN9O
	b1qC/Dfq3UyGJoJPcnUG3fQwiBm5+JWZ1KXJOA+CD1RVamuqwiicKhdzJ/niIs3Ghtb/g9GsJfY
	q6DiCN1V6KMI0aEdT5UuCZqTgfAJnrzoH5cXCsarpU9XMRgSD5f5dKm7sUynJbXSDytbqhgj9dQ
	PkSMGcTRSspUewwWGh50udExwD5iBXTkXRTgN3u4zNdVNiSEjjlhkeKbApASNCgw3FAzLOllzoo
	N2PMC/EaxB64kVZy84Gk+9sXcxezkU+7MRivbMcNROcSV3o4iqI0Zqn1wSxVLa//af0YNS0thzn
	t5JJbvI6uvauUEctpR3ehPAEN7URfsr0=
X-Google-Smtp-Source: AGHT+IGKd+CQPsVgOF0ea1oG9ZNvhLvhM2VtRT+tIBXg+tti1smIEI0Ux7dKipDMeg942JOeQKTvfQ==
X-Received: by 2002:a17:903:330b:b0:238:121:b841 with SMTP id d9443c01a7336-2380121b84bmr5146845ad.17.1750687875096;
        Mon, 23 Jun 2025 07:11:15 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d86f8261sm84407015ad.221.2025.06.23.07.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 07:11:14 -0700 (PDT)
Message-ID: <f18f7a72-b896-47a6-8f7d-f504a1a89026@rivosinc.com>
Date: Mon, 23 Jun 2025 16:11:05 +0200
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
 <b9203c8d-4c34-4eb3-a94f-5455cfc2eb53@rivosinc.com>
 <CAPYmKFtCx0qg4fEOVAhthXYvhu-X0MR5zXZLVfSmbCmNMN=ZYg@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <CAPYmKFtCx0qg4fEOVAhthXYvhu-X0MR5zXZLVfSmbCmNMN=ZYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 23/06/2025 16:09, Xu Lu wrote:
> On Mon, Jun 23, 2025 at 9:42 PM Clément Léger <cleger@rivosinc.com> wrote:
>>
>>
>>
>> On 23/06/2025 15:30, Xu Lu wrote:
>>> Hi Clément,
>>>
>>> On Mon, Jun 23, 2025 at 8:35 PM Clément Léger <cleger@rivosinc.com> wrote:
>>>>
>>>>
>>>>
>>>> On 23/06/2025 14:12, Xu Lu wrote:
>>>>> Hi Clément,
>>>>>
>>>>> On Mon, Jun 23, 2025 at 4:05 PM Clément Léger <cleger@rivosinc.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 20/06/2025 14:04, Radim Krčmář wrote:
>>>>>>> 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
>>>>>>>> Delegate illegal instruction fault to VS mode in default to avoid such
>>>>>>>> exceptions being trapped to HS and redirected back to VS.
>>>>>>>>
>>>>>>>> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
>>>>>>>> ---
>>>>>>>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>>>>>>>> @@ -48,6 +48,7 @@
>>>>>>>> +                                     BIT(EXC_INST_ILLEGAL)    | \
>>>>>>>
>>>>>>> You should also remove the dead code in kvm_riscv_vcpu_exit.
>>>>>>>
>>>>>>> And why not delegate the others as well?
>>>>>>> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
>>>>>>>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)
>>>>>>
>>>>>> Currently, OpenSBI does not delegate misaligned exception by default and
>>>>>> handles misaligned access by itself, this is (partially) why we added
>>>>>> the FWFT SBI extension to request such delegation. Since some supervisor
>>>>>> software expect that default, they do not have code to handle misaligned
>>>>>> accesses emulation. So they should not be delegated by default.
>>>>>
>>>>> It doesn't matter whether these exceptions are delegated in medeleg.
>>>>
>>>> Not sure to totally understand, but if the exceptions are not delegated
>>>> in medeleg, they won't be delegated to VS-mode even though hedeleg bit
>>>> is set right ? The spec says:
>>>>
>>>> A synchronous trap that has been delegated to HS-mode (using medeleg)
>>>> is further delegated to VS-mode if V=1 before the trap and the
>>>> corresponding hedeleg bit is set.
>>>
>>> Yes, you are right. The illegal insn exception is still trapped in M
>>> mode if it is not delegated in medeleg. But delegating it in hedeleg
>>> is still useful. The opensbi will check CSR_HEDELEG in the function
>>> sbi_trap_redirect. If the exception has been delegated to VS-mode in
>>> CSR_HEDLEG, opensbi can directly return back to VS-mode, without the
>>> overhead of going back to HS-mode and then going back to VS-mode.
>>>
>>>>
>>>>
>>>>
>>>>> KVM in HS-mode does not handle illegal instruction or misaligned
>>>>> access and only redirects them back to VS-mode. Delegating such
>>>>> exceptions in hedeleg helps save CPU usage even when they are not
>>>>> delegated in medeleg: opensbi will check whether these exceptions are
>>>>> delegated to VS-mode and redirect them to VS-mode if possible. There
>>>>> seems to be no conflicts with SSE implementation. Please correct me if
>>>>> I missed anything.
>>>>
>>>> AFAIU, this means that since medeleg bit for misaligned accesses were
>>>> not delegated up to the introduction of the FWFT extension, VS-mode
>>>> generated misaligned accesses were handled by OpenSBI right ? Now that
>>>> we are requesting openSBI to delegate misaligned accesses, HS-mode
>>>> handles it's own misaligned accesses through the trap handler. With that
>>>> configuration, if VS-mode generate a misaligned access, it will end up
>>>> being redirected to VS-mode and won't be handle by HS-mode.
>>>>
>>>> To summarize, prior to FWFT, medeleg wasn't delegating misaligned
>>>> accesses to S-mode:
>>>>
>>>> - VS-mode misaligned access -> trap to M-mode -> OpenSBI handle it ->
>>>> Back to VS-mode, misaligned access fixed up by OpenSBI
>>>
>>> Yes, this is what I want the procedure of handling illegal insn
>>> exceptions to be. Actually it now behaves as:
>>>
>>> VS-mode illegal insn exception -> trap to M-mode -> OpenSBI handles it
>>> -> Back to HS-mode, does nothing -> Back to VS-mode.
>>>
>>> I want to avoid going through HS-mode.
>>
>> Hi Xu,
>>
>> Yeah, that make sense as well but that should only happen if the VS-mode
>> requested misaligned access delegation via KVM SBI FWFT interface. I
>> know that currently KVM does do anything useful from the misaligned
>> exception except redirecting it to VS-mode but IMHO, that's a regression
>> I introduced with FWFT misaligned requested delegation...
>>
>>>
>>>>
>>>> Now that Linux uses SBI FWFT to delegates misaligned accesses (without
>>>> hedeleg being set for misaligned delegation, but that doesn't really
>>>> matter, the outcome is the same):
>>>>
>>>> - VS-mode misaligned access -> trap to HS-mode -> redirection to
>>>> VS-mode, needs to handle the misaligned access by itself
>>>>
>>>>
>>>> This means that previously, misaligned access were silently fixed up by
>>>> OpenSBI for VS-mode and now that FWFT is used for delegation, this isn't
>>>> true anymore. So, old kernel or sueprvisor software that  included code
>>>> to handle misaligned accesses will crash. Did I missed something ?
>>>
>>> Great! You make it very clear! Thanks for your explanation. But even
>>> when misalign exceptions are delegated to HS-mode, KVM seems to do
>>> nothing but redirect to VS-mode when VM get trapped due to misalign
>>> exceptions.
>>
>> Exactly, which is why I said that either setting hedeleg by default or
>> not will lead to the same outcome, ie: VS-mode needs to handle access by
>> itself (which is a regression introduced by FWFT usage).
>>
>>
>>> So maybe we can directly delegate the misaligned
>>> exceptions in hedeleg too before running VCPU and retrieve them after
>>> VCPU exists. And then the handling procedure will be:
>>>
>>> VS-mode misaligned exception -> trap to VS-mode -> VS handles it ->
>>> Back to VU-mode.
>>
>> I'd better want to let the HS-mode handle the misaligned accesses if not
>> requested via the KVM SBI FWFT interface by VS-mode to keep HS-mode
>> expected behavior. As you pointed out, this is not currently the case
>> and the misaligned exceptions are directly redirected to VS-mode, this
>> differs from what was actually done previously without FWFT (ie OpenSBI
>> handles the misaligned access).
>>
>> To summarize, I think HS-mode should fixup VS-mode misaligned accesses
>> unless requested via KVM SBI FWFT interface, in which case it will
>> delegates them (which is done by the FWFT series). This would match the
>> HS-mode <-> OpenSBI behavior.
> 
> Great! Roger that. Hope it can be fixed in the future.

Ahah ! I'll take a look at it if everyone agrees that it's a regression.

Thanks,

Clément

> 
>>
>> Thanks,
>>
>> Clément
>>
>>>
>>> Please correct me if I missed anything.
>>>
>>> Best Regards,
>>>
>>> Xu Lu
>>>
>>>>
>>>> Note: this is not directly related to your series but my introduction of
>>>> FWFT !
>>>>
>>>> Thanks,
>>>>
>>>> Clément
>>>>
>>>>>
>>>>> Best Regards,
>>>>> Xu Lu
>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Clément
>>>>>>
>>>>>>>
>>>>>>> Thanks.
>>>>>>>
>>>>>>> _______________________________________________
>>>>>>> linux-riscv mailing list
>>>>>>> linux-riscv@lists.infradead.org
>>>>>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>>>>>>
>>>>
>>


