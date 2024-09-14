Return-Path: <kvm+bounces-26928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 005E097921D
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 18:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64BE2B21AD5
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 16:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D528D1D0DE2;
	Sat, 14 Sep 2024 16:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="irK6unxW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D461DFFC
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 16:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726331991; cv=none; b=pyDHUuSkoXNrapw0mcL0A3nfv+GBJnO30J5yGmeqDhPFRuAePYzN/NmdcK9cz5p5kXdAl0Rk22AV/wxrcj+5mMFcbF+5N/TlKmyWB7eCXHPKEOqVOzeGhzePEOvV6YEeRxecBAyvvo/kvX4+6RdqlvxBBSvJ+e0GgNpf7lBy+X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726331991; c=relaxed/simple;
	bh=Dvxs9j9TLSUzp3z2Nu/7vUqe2yENvwIXyR/MAq3YdDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MsNYoVAY6+1/YAlvYYBq+gBqR/+yu6+VoemXQ6gqI8HdLxxw0KRH3uaGzFk6YV+atjIYTGHIYfTZsl1PLOYu4BFtfcSZdQsRGmjpG9ZJFlMlyaBE0b+ktiw5CJou7wt4LRSCcI2ivQtO9QCZWo6Yl88JPQ+WlrpJkm2B1uLHC6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=irK6unxW; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-82d07f32eeaso94027239f.2
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 09:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1726331987; x=1726936787; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F5jKDPdzf6bQMz9p0N2ObXfh/X3qnIwnwioASvA03Fk=;
        b=irK6unxWWDDZs+1p07uQ9CjvPWKohwM1fWEfZFwARz9eDKi3j+AMDoCImIWZWDEiAT
         gl8qlMObMYT49miO0Yfo9X/utlb9u8L7ORQLJ3EActgE5Ix60eCUEz162XtS+Z15jZJn
         AITvwib87TpGBAwzx6eIKs9P0xys+vZZXZeDACCldH8OzPFsH+tcMSjUgLAm43XbhOKu
         VmcTHII1WKXkkQgtSFEk1hEIEpLoFdoQNS6uZ64NN+E1Fdt/rxkSoSEYLw8FunSg+Rkq
         cYg8j045hCHMUKaW27D8GAx2AbdFEysZQO54lcMDxlCiSkOE57oGNv+00sNFN3kD5sK7
         IrHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726331987; x=1726936787;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F5jKDPdzf6bQMz9p0N2ObXfh/X3qnIwnwioASvA03Fk=;
        b=VW9kadVn/XAWTj3U6qepIDKmrhCR8A9bIEnQnIkEBmvA8LwIimv7/Iq9wgY5QiA93X
         oEMzCwCF7tT/hpTCgjWsPO0UJbjYr22qGWeDXRMtdDxbG8/uQAgSDfDdu7hX6GLdmKgp
         p5Sce61w2V1PB972MpIYmFQ+AtDuUOMqc/SA52oDNUYfdnTHv8QgZU6Ciw9EBcvRMSBn
         k+ypynOI8iB9OF1IyuTYoJcOf4x2wod4BHZv01/UMmustdxcyvdDyseJcpuiiIgpx9OL
         CHKMX+nIycqPuElMIhTUOIrpX04cnWcq9jIa0JA3vUr0/AB9KpzRNotWzDEHr2MeEG+N
         IAlg==
X-Forwarded-Encrypted: i=1; AJvYcCWsKfSBjHXnXWHLeoUY1v3lQVxXv3Y5jtjrSHnIq4DBeuJUtvemNT4yvaJMQ1LlmF0mryo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgMz5hmp7w5JK0KgHcNqhfVo7tjCMKnyv6AprS9okb01InwnzE
	58n/QwrIEKtqRmLc9cJXA18mrS1ZlCy47CWnXIvSWw2lubTGX9H3DRD7u4X4NPGKGyBFZQGmdVT
	120U=
X-Google-Smtp-Source: AGHT+IHcYNd/jqeI1uUq39K0wTEEILl56cZmfFM206eoGpPJ7N6EmrgIJr8Kaa/jRja1JuZV67rn6g==
X-Received: by 2002:a05:6602:2cd3:b0:82a:a804:2ec1 with SMTP id ca18e2360f4ac-82d378245b8mr721024639f.12.1726331987542;
        Sat, 14 Sep 2024 09:39:47 -0700 (PDT)
Received: from [100.64.0.1] ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d37ed33fd1sm470270173.122.2024.09.14.09.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Sep 2024 09:39:46 -0700 (PDT)
Message-ID: <d161a6ea-6975-4427-8de8-93d4ee9e80fb@sifive.com>
Date: Sat, 14 Sep 2024 11:39:45 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: Redirect instruction access fault trap to
 guest
To: Anup Patel <anup@brainfault.org>
Cc: Quan Zhou <zhouquan@iscas.ac.cn>, ajones@ventanamicro.com,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
References: <83c2234d582b7e823ce9ac9b73a6bbcf63971a29.1724911120.git.zhouquan@iscas.ac.cn>
 <b5128162-278a-4284-8271-b2b91dc446e1@iscas.ac.cn>
 <380f4da9-50e9-4632-bdc8-b1723eb19ca5@sifive.com>
 <CAAhSdy1zSTWuTW1KohUDXr9UXUx-QL1A30AUkTGoL7W2L7JWLQ@mail.gmail.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <CAAhSdy1zSTWuTW1KohUDXr9UXUx-QL1A30AUkTGoL7W2L7JWLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Anup,

On 2024-09-12 11:32 PM, Anup Patel wrote:
> On Fri, Sep 13, 2024 at 6:09 AM Samuel Holland
> <samuel.holland@sifive.com> wrote:
>>
>> On 2024-09-12 4:03 AM, Quan Zhou wrote:
>>>
>>> On 2024/8/29 14:20, zhouquan@iscas.ac.cn wrote:
>>>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>>>
>>>> The M-mode redirects an unhandled instruction access
>>>> fault trap back to S-mode when not delegating it to
>>>> VS-mode(hedeleg). However, KVM running in HS-mode
>>>> terminates the VS-mode software when back from M-mode.
>>>>
>>>> The KVM should redirect the trap back to VS-mode, and
>>>> let VS-mode trap handler decide the next step.
>>>>
>>>> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>>>> ---
>>>>   arch/riscv/kvm/vcpu_exit.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
>>>> index fa98e5c024b2..696b62850d0b 100644
>>>> --- a/arch/riscv/kvm/vcpu_exit.c
>>>> +++ b/arch/riscv/kvm/vcpu_exit.c
>>>> @@ -182,6 +182,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct
>>>> kvm_run *run,
>>>>       ret = -EFAULT;
>>>>       run->exit_reason = KVM_EXIT_UNKNOWN;
>>>>       switch (trap->scause) {
>>>> +    case EXC_INST_ACCESS:
>>>
>>> A gentle ping, the instruction access fault should be redirected to
>>> VS-mode for handling, is my understanding correct?
>>
>> Yes, this looks correct. However, I believe it would be equivalent (and more
>> efficient) to add EXC_INST_ACCESS to KVM_HEDELEG_DEFAULT in asm/kvm_host.h.
>>
>> I don't understand why some exceptions are delegated with hedeleg and others are
>> caught and redirected here with no further processing. Maybe someone thought
>> that it wasn't valid to set a bit in hedeleg if the corresponding bit was
>> cleared in medeleg? But this doesn't make sense, as S-mode cannot know which
>> bits are set in medeleg (maybe none are!).
>>
>> So the hypervisor must either:
>>  1) assume M-mode firmware checks hedeleg and redirects exceptions to VS-mode
>>     regardless of medeleg, in which case all four of these exceptions can be
>>     moved to KVM_HEDELEG_DEFAULT and removed from this switch statement, or
>>
>>  2) assume M-mode might not check hedeleg and redirect exceptions to VS-mode,
>>     and since no bits are guaranteed to be set in medeleg, any bit set in
>>     hedeleg must _also_ be handled in the switch case here.
>>
>> Anup, Atish, thoughts?
> 
> Any exception delegated to VS-mode via hedeleg means it is directly delivered
> to VS-mode without any intervention of HS-mode. This aligns with the RISC-V
> priv specification and there is no alternate semantics assumed by KVM RISC-V.
> 
> At the moment, for KVM RISC-V we are converging towards the following
> approach:
> 
> 1) Only delegate "supervisor expected" traps to VS-mode via hedeleg
> which supervisor software is generally expected to directly handle such
> as breakpoint, user syscall, inst page fault, load page fault, and store
> page fault.
> 
> 2) Other "supervisor unexpected" traps are redirected to VS-mode via
> software in HS-mode because these are not typically expected by supervisor
> software and KVM RISC-V should at least gather some stats for such traps.

Can you point me to where we collect stats for these traps? I don't see any code
in kvm_riscv_vcpu_exit() that does this.

> Previously, we were redirecting such unexpect traps to KVM user space
> where the KVM user space tool will simply dump the VCPU state and kill
> the Guest/VM.

Currently we have 5 exception types that go through software in HS-mode but
never kill the guest: EXC_INST_ILLEGAL, EXC_LOAD_MISALIGNED,
EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS, and EXC_STORE_ACCESS. Are those
considered "expected" or "unexpected"?

> The inst misaligned trap was historically always set in hedeleg but we
> should update it based on the above approach.

What are the criteria for determining if a trap is "supervisor expected" or
"supervisor unexpected"? Certainly any trap that can be triggered by misbehaved
software in VU-mode should not kill the guest. Similarly, any trap that can be
triggered by a misbehaved nested VS-mode guest should not kill the outer guest
either.

So the only reason I see for not delegating them is to collect stats, but I
wonder if that is worth the performance cost. I would rather make misaligned
loads/stores (for example) faster in the guest than have a count of them at the
hypervisor level.

Regards,
Samuel


