Return-Path: <kvm+bounces-10861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4D4871412
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 04:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FACFB21776
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4780129416;
	Tue,  5 Mar 2024 03:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jDAfBtw2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97937125C1
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 03:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709607823; cv=none; b=eK4pj6/T4NRSD8P34+bjxapYrPgT8HQOBQnpgl+Ns9YENeNC4FjAwBhOtHMF0FDyf2LAan7RQQJU9Fg0H9vRV5IVQ2TybZKuEgFhM/TcjI/QFVIMwD7HzwYIOyhrnE1pUtDLfMzbaXVcM/1IFupezXtuuIcbe+5jbW9R32pNcn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709607823; c=relaxed/simple;
	bh=mp+ol3XwG06p9glsFnLYwqdxgHrJDYRhiNjw+YkZF1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SDEFO57nOAx2fEsR5T+5A3YB3wKR0aklT38h4idpf68UR4x6370Ci439ZhaEkKlWyWp2FujAF7Fkz8gauykHRnXWHE1ex98I/4fKoLHCKun1OUmZNsB7F2YYWissNqq8Z1KiewR0ffUn2QzOudsZhPHMkTaQ6OK3noXPA1XGd4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jDAfBtw2; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709607821; x=1741143821;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mp+ol3XwG06p9glsFnLYwqdxgHrJDYRhiNjw+YkZF1A=;
  b=jDAfBtw2wcNd2fyIZ5rsrVwHtw1TcG+kbR4Q+mgga1Rv3t+bKKr5vGy7
   usrXkqIj69vBySSTqukK3sKs9fHwpLqlI1QbB1PVOB1nbjrp8lzo0kPv+
   AOMgO7P23mreQSawZlHOvDpg53GPgMdZCkue1ynQeP3JukMHAo82rx0JT
   3JdvEgmjNcTWfx29pv0CkVtvAUOenEc8pR8RuKZbATuX5DZnZN25xOxYk
   cfCkTt5kKDVefrjgI5xyt4Bu9Zcb4MqC9bLFS1KeWu2zw7IXCW/Ko74wY
   KF23XQKDN+1MCZ1BUP5/71Yl9CZYpMchPmklN9MVp5L23I2SDQxxRW2br
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4059144"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4059144"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 19:03:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="9325010"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 19:03:39 -0800
Message-ID: <7a77eb25-2287-4e30-813d-c3b0e9bae4a6@intel.com>
Date: Tue, 5 Mar 2024 11:03:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] kvm: add support for guest physical bits
Content-Language: en-US
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240301101713.356759-1-kraxel@redhat.com>
 <20240301101713.356759-2-kraxel@redhat.com>
 <3ab64c0f-7387-4738-b78c-cf798528d5f4@intel.com>
 <z4di6tev2kdeddclskhl5xhrlpseykgukfwit6ickrh57zscyv@bkjtbyj3enjx>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <z4di6tev2kdeddclskhl5xhrlpseykgukfwit6ickrh57zscyv@bkjtbyj3enjx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/2024 10:58 PM, Gerd Hoffmann wrote:
> On Mon, Mar 04, 2024 at 09:54:40AM +0800, Xiaoyao Li wrote:
>> On 3/1/2024 6:17 PM, Gerd Hoffmann wrote:
>>> query kvm for supported guest physical address bits using
>>> KVM_CAP_VM_GPA_BITS.  Expose the value to the guest via cpuid
>>> (leaf 0x80000008, eax, bits 16-23).
>>>
>>> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>>> ---
>>>    target/i386/cpu.h     | 1 +
>>>    target/i386/cpu.c     | 1 +
>>>    target/i386/kvm/kvm.c | 8 ++++++++
>>>    3 files changed, 10 insertions(+)
>>>
>>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>>> index 952174bb6f52..d427218827f6 100644
>>> --- a/target/i386/cpu.h
>>> +++ b/target/i386/cpu.h
>>> @@ -2026,6 +2026,7 @@ struct ArchCPU {
>>>        /* Number of physical address bits supported */
>>>        uint32_t phys_bits;
>>> +    uint32_t guest_phys_bits;
>>>        /* in order to simplify APIC support, we leave this pointer to the
>>>           user */
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index 2666ef380891..1a6cfc75951e 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>>>            if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
>>>                /* 64 bit processor */
>>>                 *eax |= (cpu_x86_virtual_addr_width(env) << 8);
>>> +             *eax |= (cpu->guest_phys_bits << 16);
>>
>> I think you misunderstand this field.
>>
>> If you expose this field to guest, it's the information for nested guest.
>> i.e., the guest itself runs as a hypervisor will know its nested guest can
>> have guest_phys_bits for physical addr.
> 
> I think those limits (l1 + l2 guest phys-bits) are identical, no?

Sorry, I didn't know this patch was based on the off-list proposal made 
by Paolo that changing the definition of CPUID.0x80000008:EAX[23:16] to 
advertise the "maximum usable physical address bits".

If you call out this in the change log, it can avoid the misunderstanding.

As I replied to KVM series, I think the info is better to setup by KVM 
and reported by GET_SUPPORTED_CPUID.

> The problem this tries to solve is that making the guest phys-bits
> smaller than the host phys-bits is problematic (which why we have
> allow_smaller_maxphyaddr), but nevertheless there are cases where
> the usable guest physical address space is smaller than the host
> physical address space.  One case is intel processors with phys-bits
> larger than 48 and 4-level EPT.  Another case is amd processors with
> phys-bits larger than 48 and the l0 hypervisor using 4-level paging.
> 
> The guest needs to know that limit, specifically the guest firmware
> so it knows where it can map PCI bars.
> 
> take care,
>    Gerd
> 


