Return-Path: <kvm+bounces-19838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A5E90C32F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 07:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25E7D1C218C8
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 05:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70551B285;
	Tue, 18 Jun 2024 05:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cpyo+eIc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A812923A9
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 05:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718689716; cv=none; b=jA+GFD6U73hOGDkpn0RDK5fp4FqaOmaIessiTP9aLIxgKsg3ItJ7HoD8f3jjFenMqZyM5f4LnH6c7Rc39i282WtbAfZLNLt6PlZE5KA8ewNCqw4SrNj9QGjfZn4DRS2kQE53jLFQKIllCyWY9vhruvOY3K4NZX494FEiv1hjqtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718689716; c=relaxed/simple;
	bh=aDSCb2xB7clfj25Nf3Wn+g8ffbs7mLcrAmopAV3ANw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nk+0vgN1UqRcqmd3J6RonGfQmA2pSUEYUqx1kJuYM/maDynb1nSMbjNLuHGuRdEJQ4wVuVJ7rCm/XoCxmqw+ztnRu3VyM3my25DLgqvEetlWq8E4Y/ZK+3RAhj5Z6OCL7C0JD9kot9X3puMBkYdMtDbQIPRefRZNq+uGMU4OF0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cpyo+eIc; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718689714; x=1750225714;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aDSCb2xB7clfj25Nf3Wn+g8ffbs7mLcrAmopAV3ANw4=;
  b=cpyo+eIcmcxzgnqR0HuEwZbarQ2IjvJzZjz5T8lOLhYRlxRv/m58iTqN
   lNAUEnft/I8kNM3sgIjFHxN7TLHT6H7zU9wpRlwvfGNepToPWZat5EPKC
   NPXyD94DdTGoX0lN0u8h0d6bzPxKtMruqUDV3t9GhdKC9bA9JDaZSVfBX
   DpeTd39LeJEJDvE/3rzrzd//MxeXtsKGL9dXPYM3IiSNhY1vqeMgmtBcD
   yLg2cxEdiVzwWej2tkSb0aDSrwEd8CFnw0uN055xZpYiBnqUsgd6A2vIx
   yp6I28O9ClBh1LmNcf8+vBNRqY3X36WVcbXbpSgcOGcPUD05DJHYrgsnR
   g==;
X-CSE-ConnectionGUID: gAHEPWAYQm2zMnxoJYb+tw==
X-CSE-MsgGUID: L9q8RxElS1S7KW6KHZkZDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="18457189"
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="18457189"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 22:48:33 -0700
X-CSE-ConnectionGUID: qIhQEVLCTJSCbRoEcsSRCA==
X-CSE-MsgGUID: izOTE8LZRzWVzXstTIFBSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="42116217"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 22:48:32 -0700
Message-ID: <00a74cb3-4f03-4eb3-a969-04293841f64a@linux.intel.com>
Date: Tue, 18 Jun 2024 13:48:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v6 2/4] x86: Add test case for LAM_SUP
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
 robert.hu@linux.intel.com
References: <20240122085354.9510-1-binbin.wu@linux.intel.com>
 <20240122085354.9510-3-binbin.wu@linux.intel.com>
 <ZmCtVWQ_7KdMqcmf@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZmCtVWQ_7KdMqcmf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/6/2024 2:24 AM, Sean Christopherson wrote:
> On Mon, Jan 22, 2024, Binbin Wu wrote:
>> diff --git a/x86/lam.c b/x86/lam.c
>> new file mode 100644
>> index 00000000..0ad16be5
>> --- /dev/null
>> +++ b/x86/lam.c
>> @@ -0,0 +1,243 @@
>> +/*
>> + * Intel LAM unit test
>> + *
>> + * Copyright (C) 2023 Intel
>> + *
>> + * Author: Robert Hoo <robert.hu@linux.intel.com>
>> + *         Binbin Wu <binbin.wu@linux.intel.com>
>> + *
>> + * This work is licensed under the terms of the GNU LGPL, version 2 or
>> + * later.
>> + */
>> +
>> +#include "libcflat.h"
>> +#include "processor.h"
>> +#include "desc.h"
>> +#include "vmalloc.h"
>> +#include "alloc_page.h"
>> +#include "vm.h"
>> +#include "asm/io.h"
>> +#include "ioram.h"
>> +
>> +#define FLAGS_LAM_ACTIVE	BIT_ULL(0)
>> +#define FLAGS_LA57		BIT_ULL(1)
>> +
>> +struct invpcid_desc {
>> +	u64 pcid : 12;
>> +	u64 rsv  : 52;
>> +	u64 addr;
>> +};
>> +
>> +static inline bool is_la57(void)
>> +{
>> +	return !!(read_cr4() & X86_CR4_LA57);
>> +}
>> +
>> +static inline bool lam_sup_active(void)
> Needs an "is_" prefix.  And be consistent, e.g. is_lam_sup() to go with is_la57(),
> or is_lam_sup_enabled() and is_la57_enabled().  I'd probably vote for the latter,
> though KVM does have is_paging() and the like, so I'm fine either way.
>
> And these belong in processor.h

OK, will use is_lam_sup_enabled() / is_la57_enabled() and move them to 
processor.h.

>
>> +{
>> +	return !!(read_cr4() & X86_CR4_LAM_SUP);
>> +}
>> +
>> +static void cr4_set_lam_sup(void *data)
>> +{
>> +	unsigned long cr4;
>> +
>> +	cr4 = read_cr4();
>> +	write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
>> +}
>> +
>> +static void cr4_clear_lam_sup(void *data)
>> +{
>> +	unsigned long cr4;
>> +
>> +	cr4 = read_cr4();
>> +	write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
>> +}
> Please drop these helpers and instead use _safe() variants when possible, e.g.
>
> 	vector = write_cr4_safe(cr4 | X86_CR4_LAM_SUP);
> 	report(has_lam ? !vector : vector == GP_VECTOR,
> 	       "Expected CR4.LAM_SUP=1 to %s" ? has_lam ? "succeed" : "#GP");
>
> 	vector = write_cr4_safe(cr4 & ~X86_CR4_LAM_SUP);
> 	report(!vector, "Expected CR4.LAM_SUP=0 to succeed");
OK.

>
>> +static void test_cr4_lam_set_clear(bool has_lam)
>> +{
>> +	bool fault;
>> +
>> +	fault = test_for_exception(GP_VECTOR, &cr4_set_lam_sup, NULL);
>> +	report((fault != has_lam) && (lam_sup_active() == has_lam),
>> +	       "Set CR4.LAM_SUP");
>> +
>> +	fault = test_for_exception(GP_VECTOR, &cr4_clear_lam_sup, NULL);
>> +	report(!fault, "Clear CR4.LAM_SUP");
>> +}
>> +
>> +/* Refer to emulator.c */
>> +static void do_mov(void *mem)
>> +{
>> +	unsigned long t1, t2;
>> +
>> +	t1 = 0x123456789abcdefull & -1ul;
>> +	asm volatile("mov %[t1], (%[mem])\n\t"
>> +		     "mov (%[mem]), %[t2]"
>> +		     : [t2]"=r"(t2)
>> +		     : [t1]"r"(t1), [mem]"r"(mem)
>> +		     : "memory");
>> +	report(t1 == t2, "Mov result check");
>> +}
>> +
>> +static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
> There's no reason to name these arg1..arg4.  And unless I'm missing something,
> there's no need for these flags at all.  All the info is derived from vCPU state,
> so just re-grab it.  The cost of a CR4 read is negligible relative to the expected
> runtime of these tests.
The reason for these arguments is the userspace pointer will be tested 
in userspace using the same function,
and CR3/CR4 can not be read in ring3, so these CR3/CR4 LAM/LA57 related 
information needs to be passed.

Based on your comment and the comment from patch 3
https://lore.kernel.org/kvm/ZmC0GC3wAdiO0Dp2@google.com/
Does the number of arguments bothering you?
If not, I can pass CR3 and CR4 value to test_ptr() and let the test 
function to retrieve LAM information itself.
I.e, the 4 inputs will be CR3, CR4, memory pointer, is_mmio.


>
>> +{
>> +	bool lam_active = !!(arg1 & FLAGS_LAM_ACTIVE);
>> +	u64 lam_mask = arg2;
>> +	u64 *ptr = (u64 *)arg3;
>> +	bool is_mmio = !!arg4;
>> +	bool fault;
>> +
>> +	fault = test_for_exception(GP_VECTOR, do_mov, ptr);
>> +	report(!fault, "Test untagged addr (%s)", is_mmio ? "MMIO" : "Memory");
>> +
>> +	ptr = (u64 *)set_la_non_canonical((u64)ptr, lam_mask);
>> +	fault = test_for_exception(GP_VECTOR, do_mov, ptr);
>> +	report(fault != lam_active,"Test tagged addr (%s)",
>> +	       is_mmio ? "MMIO" : "Memory");
>> +
>> +	return 0;
>> +}
>> +
>> +static void do_invlpg(void *mem)
>> +{
>> +	invlpg(mem);
>> +}
>> +
>> +static void do_invlpg_fep(void *mem)
>> +{
>> +	asm volatile(KVM_FEP "invlpg (%0)" ::"r" (mem) : "memory");
>> +}
>> +
>> +/* invlpg with tagged address is same as NOP, no #GP expected. */
>> +static void test_invlpg(u64 lam_mask, void *va, bool fep)
>> +{
>> +	bool fault;
>> +	u64 *ptr;
>> +
>> +	ptr = (u64 *)set_la_non_canonical((u64)va, lam_mask);
>> +	if (fep)
>> +		fault = test_for_exception(GP_VECTOR, do_invlpg_fep, ptr);
>> +	else
>> +		fault = test_for_exception(GP_VECTOR, do_invlpg, ptr);
> INVLPG never faults, so don't bother with wrappers.  If INVPLG faults, the test
> fails, i.e. mission accomplished.

OK.
>
>> +
>> +	report(!fault, "%sINVLPG with tagged addr", fep ? "fep: " : "");
>> +}
>> +
>> +static void do_invpcid(void *desc)
>> +{
>> +	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)desc;
>> +
>> +	asm volatile("invpcid %0, %1" :
>> +	                              : "m" (*desc_ptr), "r" (0UL)
>> +	                              : "memory");
>> +}
> Similar thing here, invpcid() belongs in processor.h, alongside invpcid_safe().

OK, I think I can use invpcid_safe() directly for test cases.


>
>> +/* LAM doesn't apply to the linear address in the descriptor of invpcid */
>> +static void test_invpcid(u64 flags, u64 lam_mask, void *data)
>> +{
>> +	/*
>> +	 * Reuse the memory address for the descriptor since stack memory
>> +	 * address in KUT doesn't follow the kernel address space partitions.
>> +	 */
>> +	struct invpcid_desc *desc_ptr = (struct invpcid_desc *)data;
>> +	bool lam_active = !!(flags & FLAGS_LAM_ACTIVE);
>> +	bool fault;
>> +
>> +	if (!this_cpu_has(X86_FEATURE_PCID) ||
> I don't _think_ we need to check for PCID support.  It's a KVM/QEMU bug if INVPCID
> is advertised but it doesn't work for the "all PCIDs" flavor.
OK, will remove it.

>
>> +	    !this_cpu_has(X86_FEATURE_INVPCID)) {
>> +		report_skip("INVPCID not supported");
>> +		return;
>> +	}
>> +
> ...
>
>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>> index 3fe59449..224df45b 100644
>> --- a/x86/unittests.cfg
>> +++ b/x86/unittests.cfg
>> @@ -491,3 +491,13 @@ file = cet.flat
>>   arch = x86_64
>>   smp = 2
>>   extra_params = -enable-kvm -m 2048 -cpu host
>> +
>> +[intel-lam]
>> +file = lam.flat
>> +arch = x86_64
>> +extra_params = -enable-kvm -cpu host
>> +
>> +[intel-no-lam]
>> +file = lam.flat
>> +arch = x86_64
>> +extra_params = -enable-kvm -cpu host,-lam
> Hrm, not something that needs to be solved now, but we really need a better
> interface for iterating over features in tests :-/


