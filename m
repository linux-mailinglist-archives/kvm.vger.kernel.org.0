Return-Path: <kvm+bounces-19841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4450F90C3B1
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 08:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE4A51F226F9
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 06:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7784F881;
	Tue, 18 Jun 2024 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fDtenz+V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC88288BD
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718692644; cv=none; b=qvFYm13BGcwhTiqWgm3aPFr/1wiMZYV9pA51ZKrLw+hzTfGFM6s6wVHDoNfIaunr9/O32H49sNf7yrqhwmv4kAgYAekXRfhRv69ebIIYu6nVmlDG4qIOEqOlEh/+jthrZGJgpRmSb51lhWd3+5vWAodm8004hQxJt2PhsCCAXc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718692644; c=relaxed/simple;
	bh=r3FikChk/YUF8wYHJX7eYAyWNOpq/1RKJWbMg3nm8d8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GcmEobVtIjJgzNpos82hxIuzGEiFpjr30qh8/8R3gFoJHbML8RpSjlX/CneJMXNyifPXCp4S3hrLZ4cPaD1HtkzFC9uZR0TN3oDecckqaCu9bDPlW4sfLTD5k0dHR6H1RptSRePKz9iOWpZYefZe68sMmMLxIr9JydmQuloKhcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fDtenz+V; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718692643; x=1750228643;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=r3FikChk/YUF8wYHJX7eYAyWNOpq/1RKJWbMg3nm8d8=;
  b=fDtenz+VVA0XF8BcnTf+DYRsBuSpDO0LN96SIN2stfULDL3BPq8RIxCa
   NNsR+T1mxWKxWzky0ifnbV0T5OWc3YR0yku2s8dvAwfLP41jX6bctELKf
   xkVyfULZ5aAUN7Owt6PCzMz2RIKw3fIN8SFGNEzJmiFM/WQShap7Nv3Pm
   yNche5PsUfsnRJP+aLAwkBEWw+rvmu/M7gDpWj71SqAmNTDpOO7SJjixY
   0N4s71wKBJQboR9KvrTFXY5FXljpSB6yFyb0ff/ye5G6Aw3tYrc59W60W
   b8OroRib+Gu9i2XgcJg2Y6lMLIk2ILIvqEUD8Ru8WxaPprzOR0Zb1vSNl
   w==;
X-CSE-ConnectionGUID: uBQwCQd7Sgu6xY/bjeVe9Q==
X-CSE-MsgGUID: 3Qa18YW1SiS3oE0babhQ8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="12124636"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="12124636"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 23:37:19 -0700
X-CSE-ConnectionGUID: TUJkB5BVTniLOQIfJRBSMg==
X-CSE-MsgGUID: ym5W0uN2RTuWWVNIqOsmdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="41377490"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 23:37:18 -0700
Message-ID: <2d39ba72-159e-4315-a50a-d9b483b0c479@linux.intel.com>
Date: Tue, 18 Jun 2024 14:37:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v6 2/4] x86: Add test case for LAM_SUP
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
 robert.hu@linux.intel.com
References: <20240122085354.9510-1-binbin.wu@linux.intel.com>
 <20240122085354.9510-3-binbin.wu@linux.intel.com>
 <ZmCtVWQ_7KdMqcmf@google.com>
 <00a74cb3-4f03-4eb3-a969-04293841f64a@linux.intel.com>
Content-Language: en-US
In-Reply-To: <00a74cb3-4f03-4eb3-a969-04293841f64a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/18/2024 1:48 PM, Binbin Wu wrote:
>
>
> On 6/6/2024 2:24 AM, Sean Christopherson wrote:
>> On Mon, Jan 22, 2024, Binbin Wu wrote:
>>> diff --git a/x86/lam.c b/x86/lam.c
>>> new file mode 100644
>>> index 00000000..0ad16be5
>>> --- /dev/null
>>> +++ b/x86/lam.c
>>> @@ -0,0 +1,243 @@
>>> +/*
>>> + * Intel LAM unit test
>>> + *
>>> + * Copyright (C) 2023 Intel
>>> + *
>>> + * Author: Robert Hoo <robert.hu@linux.intel.com>
>>> + *         Binbin Wu <binbin.wu@linux.intel.com>
>>> + *
>>> + * This work is licensed under the terms of the GNU LGPL, version 2 or
>>> + * later.
>>> + */
>>> +
>>> +#include "libcflat.h"
>>> +#include "processor.h"
>>> +#include "desc.h"
>>> +#include "vmalloc.h"
>>> +#include "alloc_page.h"
>>> +#include "vm.h"
>>> +#include "asm/io.h"
>>> +#include "ioram.h"
>>> +
>>> +#define FLAGS_LAM_ACTIVE    BIT_ULL(0)
>>> +#define FLAGS_LA57        BIT_ULL(1)
>>> +
>>> +struct invpcid_desc {
>>> +    u64 pcid : 12;
>>> +    u64 rsv  : 52;
>>> +    u64 addr;
>>> +};
>>> +
>>> +static inline bool is_la57(void)
>>> +{
>>> +    return !!(read_cr4() & X86_CR4_LA57);
>>> +}
>>> +
>>> +static inline bool lam_sup_active(void)
>> Needs an "is_" prefix.  And be consistent, e.g. is_lam_sup() to go 
>> with is_la57(),
>> or is_lam_sup_enabled() and is_la57_enabled().  I'd probably vote for 
>> the latter,
>> though KVM does have is_paging() and the like, so I'm fine either way.
>>
>> And these belong in processor.h
>
> OK, will use is_lam_sup_enabled() / is_la57_enabled() and move them to 
> processor.h.
>
>>
>>> +{
>>> +    return !!(read_cr4() & X86_CR4_LAM_SUP);
>>> +}
>>> +
>>> +static void cr4_set_lam_sup(void *data)
>>> +{
>>> +    unsigned long cr4;
>>> +
>>> +    cr4 = read_cr4();
>>> +    write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
>>> +}
>>> +
>>> +static void cr4_clear_lam_sup(void *data)
>>> +{
>>> +    unsigned long cr4;
>>> +
>>> +    cr4 = read_cr4();
>>> +    write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
>>> +}
>> Please drop these helpers and instead use _safe() variants when 
>> possible, e.g.
>>
>>     vector = write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
>>     report(has_lam ? !vector : vector == GP_VECTOR,
>>            "Expected CR4.LAM_SUP=1 to %s" ? has_lam ? "succeed" : 
>> "#GP");
>>
>>     vector = write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
>>     report(!vector, "Expected CR4.LAM_SUP=0 to succeed");
> OK.
>
>>
>>> +static void test_cr4_lam_set_clear(bool has_lam)
>>> +{
>>> +    bool fault;
>>> +
>>> +    fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
>>> +    report((fault != has_lam) && (lam_sup_active() == has_lam),
>>> +           "Set CR4.LAM_SUP");
>>> +
>>> +    fault = test_for_exception(GP_VECTOR, &cr4_clear_lam_sup, NULL);
>>> +    report(!fault, "Clear CR4.LAM_SUP");
>>> +}
>>> +
>>> +/* Refer to emulator.c */
>>> +static void do_mov(void *mem)
>>> +{
>>> +    unsigned long t1, t2;
>>> +
>>> +    t1 = 0x123456789abcdefull & -1ul;
>>> +    asm volatile("mov %[t1], (%[mem])\n\t"
>>> +             "mov (%[mem]), %[t2]"
>>> +             : [t2]"=r"(t2)
>>> +             : [t1]"r"(t1), [mem]"r"(mem)
>>> +             : "memory");
>>> +    report(t1 == t2, "Mov result check");
>>> +}
>>> +
>>> +static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
>> There's no reason to name these arg1..arg4.  And unless I'm missing 
>> something,
>> there's no need for these flags at all.  All the info is derived from 
>> vCPU state,
>> so just re-grab it.  The cost of a CR4 read is negligible relative to 
>> the expected
>> runtime of these tests.
> The reason for these arguments is the userspace pointer will be tested 
> in userspace using the same function,
> and CR3/CR4 can not be read in ring3, so these CR3/CR4 LAM/LA57 
> related information needs to be passed.

Another way to simplify it is: LAM identifies a pointer as kernel or 
user pointer only based on the pointer itself, there is no need to run 
the test in userspace to test user pointers.
Since SMAP is not enabled by default in KUT, we can use user pointers in 
ring0 directly, then no need to pass CR3/CR4 info to the function.


>
> Based on your comment and the comment from patch 3
> https://lore.kernel.org/kvm/ZmC0GC3wAdiO0Dp2@google.com/
> Does the number of arguments bothering you?
> If not, I can pass CR3 and CR4 value to test_ptr() and let the test 
> function to retrieve LAM information itself.
> I.e, the 4 inputs will be CR3, CR4, memory pointer, is_mmio.
>
>
>>
>>> +{
>>> +    bool lam_active = !!(arg1 & FLAGS_LAM_ACTIVE);
>>> +    u64 lam_mask = arg2;
>>> +    u64 *ptr = (u64 *)arg3;
>>> +    bool is_mmio = !!arg4;
>>> +    bool fault;
>>> +
>>> +    fault = test_for_exception(GP_VECTOR, do_mov, ptr);
>>> +    report(!fault, "Test untagged addr (%s)", is_mmio ? "MMIO" : 
>>> "Memory");
>>> +
>>> +    ptr = (u64 *)set_la_non_canonical((u64)ptr, lam_mask);
>>> +    fault = test_for_exception(GP_VECTOR, do_mov, ptr);
>>> +    report(fault != lam_active,"Test tagged addr (%s)",
>>> +           is_mmio ? "MMIO" : "Memory");
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void do_invlpg(void *mem)
>>> +{
>>> +    invlpg(mem);
>>> +}
>>> +
>>> +static void do_invlpg_fep(void *mem)
>>> +{
>>> +    asm volatile(KVM_FEP "invlpg (%0)" ::"r" (mem) : "memory");
>>> +}
>>> +
>>> +/* invlpg with tagged address is same as NOP, no #GP expected. */
>>> +static void test_invlpg(u64 lam_mask, void *va, bool fep)
>>> +{
>>> +    bool fault;
>>> +    u64 *ptr;
>>> +
>>> +    ptr = (u64 *)set_la_non_canonical((u64)va, lam_mask);
>>> +    if (fep)
>>> +        fault = test_for_exception(GP_VECTOR, do_invlpg_fep, ptr);
>>> +    else
>>> +        fault = test_for_exception(GP_VECTOR, do_invlpg, ptr);
>> INVLPG never faults, so don't bother with wrappers.  If INVPLG 
>> faults, the test
>> fails, i.e. mission accomplished.
>
> OK.
>>
>>> +
>>> +    report(!fault, "%sINVLPG with tagged addr", fep ? "fep: " : "");
>>> +}
>>> +
>>> +static void do_invpcid(void *desc)
>>> +{
>>> +    struct invpcid_desc *desc_ptr = (struct invpcid_desc *)desc;
>>> +
>>> +    asm volatile("invpcid %0, %1" :
>>> +                                  : "m" (*desc_ptr), "r" (0UL)
>>> +                                  : "memory");
>>> +}
>> Similar thing here, invpcid() belongs in processor.h, alongside 
>> invpcid_safe().
>
> OK, I think I can use invpcid_safe() directly for test cases.
>
>
>>
>>> +/* LAM doesn't apply to the linear address in the descriptor of 
>>> invpcid */
>>> +static void test_invpcid(u64 flags, u64 lam_mask, void *data)
>>> +{
>>> +    /*
>>> +     * Reuse the memory address for the descriptor since stack memory
>>> +     * address in KUT doesn't follow the kernel address space 
>>> partitions.
>>> +     */
>>> +    struct invpcid_desc *desc_ptr = (struct invpcid_desc *)data;
>>> +    bool lam_active = !!(flags & FLAGS_LAM_ACTIVE);
>>> +    bool fault;
>>> +
>>> +    if (!this_cpu_has(X86_FEATURE_PCID) ||
>> I don't _think_ we need to check for PCID support.  It's a KVM/QEMU 
>> bug if INVPCID
>> is advertised but it doesn't work for the "all PCIDs" flavor.
> OK, will remove it.
>
>>
>>> + !this_cpu_has(X86_FEATURE_INVPCID)) {
>>> +        report_skip("INVPCID not supported");
>>> +        return;
>>> +    }
>>> +
>> ...
>>
>>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>>> index 3fe59449..224df45b 100644
>>> --- a/x86/unittests.cfg
>>> +++ b/x86/unittests.cfg
>>> @@ -491,3 +491,13 @@ file = cet.flat
>>>   arch = x86_64
>>>   smp = 2
>>>   extra_params = -enable-kvm -m 2048 -cpu host
>>> +
>>> +[intel-lam]
>>> +file = lam.flat
>>> +arch = x86_64
>>> +extra_params = -enable-kvm -cpu host
>>> +
>>> +[intel-no-lam]
>>> +file = lam.flat
>>> +arch = x86_64
>>> +extra_params = -enable-kvm -cpu host,-lam
>> Hrm, not something that needs to be solved now, but we really need a 
>> better
>> interface for iterating over features in tests :-/
>
>


