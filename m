Return-Path: <kvm+bounces-51315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC41FAF5E24
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 780147A52E0
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F59C2E7BD7;
	Wed,  2 Jul 2025 16:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gZNSODaO"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7CF1E0DD8;
	Wed,  2 Jul 2025 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751472709; cv=none; b=RRHeoznXm30KstXDmm5jc+amBg9GZohyVa34x5uozFZwX8AoML1vAsm3+JtCp0nVEOFqsbnijtrKRKDGZWO6uPfIbrDzmCI8vNMKNngY0sjRKRY5u2Dhf5o9LLUxKw8Vo+LnC34qGcJCuBdo24UmMw0amtY4Wv2CK6N2K8jV9+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751472709; c=relaxed/simple;
	bh=yS/Dw9mwlzCfupsNGgq6I0EPxICqWfjGtM2H6uUtaGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUnQsO4ZcYj7pTeojna3KYdZpftg5e5zAMaOzIk3/oCD8xvLC0o72BnncQ/sfadrKeN16tQ15xu7tHazvGxYyKqKjOtSHkTD7vdLJC7n3XOTEI8MKuYEfhN9o2pMPzHPDXEmBTGaEeP/03xU/iJ1kVUGinFBbWuptLO5dxHazWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=gZNSODaO; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.66.201.102] (unknown [40.68.200.63])
	by linux.microsoft.com (Postfix) with ESMTPSA id EA292201A4D4;
	Wed,  2 Jul 2025 09:11:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EA292201A4D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1751472707;
	bh=g9AKuBvLaq/WBbfdsgGRcIJWQPeX4lLdRaRJp8x1I0s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gZNSODaO7kwE0UbD/eZnrrO8CNnaIStHeRpiXeUoWuTm32wGkNosO/Q/m36jWsf4r
	 s89HlQZMl2Vn07oGhTh9ghiRIVFv5ZIxoz6MojX+knBBI2GGmi2ApkzjZpbP32mhvk
	 SPbGGBrhS+4UicxwTkulUP/Hjw05OEeTJ1fAAU1Y=
Message-ID: <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
Date: Wed, 2 Jul 2025 18:11:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB
 flushes
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 alanjiang@microsoft.com, chinang.ma@microsoft.com,
 andrea.pellegrini@microsoft.com, Kevin Tian <kevin.tian@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org
References: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
 <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
 <875xghoaac.fsf@redhat.com>
Content-Language: en-US
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <875xghoaac.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/06/2025 10:31, Vitaly Kuznetsov wrote:
> Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:
> 
>> Use Hyper-V's HvCallFlushGuestPhysicalAddressSpace for local TLB flushes.
>> This makes any KVM_REQ_TLB_FLUSH_CURRENT (such as on root alloc) visible to
>> all CPUs which means we no longer need to do a KVM_REQ_TLB_FLUSH on CPU
>> migration.
>>
>> The goal is to avoid invept-global in KVM_REQ_TLB_FLUSH. Hyper-V uses a
>> shadow page table for the nested hypervisor (KVM) and has to invalidate all
>> EPT roots when invept-global is issued. This has a performance impact on
>> all nested VMs.  KVM issues KVM_REQ_TLB_FLUSH on CPU migration, and under
>> load the performance hit causes vCPUs to use up more of their slice of CPU
>> time, leading to more CPU migrations. This has a snowball effect and causes
>> CPU usage spikes.
>>
>> By issuing the hypercall we are now guaranteed that any root modification
>> that requires a local TLB flush becomes visible to all CPUs. The same
>> hypercall is already used in kvm_arch_flush_remote_tlbs and
>> kvm_arch_flush_remote_tlbs_range.  The KVM expectation is that roots are
>> flushed locally on alloc and we achieve consistency on migration by
>> flushing all roots - the new behavior of achieving consistency on alloc on
>> Hyper-V is a superset of the expected guarantees. This makes the
>> KVM_REQ_TLB_FLUSH on CPU migration no longer necessary on Hyper-V.
> 
> Sounds reasonable overall, my only concern (not sure if valid or not) is
> that using the hypercall for local flushes is going to be more expensive
> than invept-context we do today and thus while the performance is
> improved for the scenario when vCPUs are migrating a lot, we will take a
> hit in other cases.
> 

Discussion below, I think the impact should be limited and will try to quantify it.

>>
>> Coincidentally - we now match the behavior of SVM on Hyper-V.
>>
>> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/vmx/vmx.c          | 20 +++++++++++++++++---
>>  arch/x86/kvm/vmx/vmx_onhyperv.h |  6 ++++++
>>  arch/x86/kvm/x86.c              |  3 +++
>>  4 files changed, 27 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index b4a391929cdb..d3acab19f425 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1077,6 +1077,7 @@ struct kvm_vcpu_arch {
>>  
>>  #if IS_ENABLED(CONFIG_HYPERV)
>>  	hpa_t hv_root_tdp;
>> +	bool hv_vmx_use_flush_guest_mapping;
>>  #endif
>>  };
>>  
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 4953846cb30d..f537e0df56fc 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1485,8 +1485,12 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
>>  		/*
>>  		 * Flush all EPTP/VPID contexts, the new pCPU may have stale
>>  		 * TLB entries from its previous association with the vCPU.
>> +		 * Unless we are running on Hyper-V where we promotes local TLB
> 
> s,promotes,promote, or, as Sean doesn't like pronouns, 
> 
> "... where local TLB flushes are promoted ..."
> 

Will do.

>> +		 * flushes to be visible across all CPUs so no need to do again
>> +		 * on migration.
>>  		 */
>> -		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>> +		if (!vmx_hv_use_flush_guest_mapping(vcpu))
>> +			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>>  
>>  		/*
>>  		 * Linux uses per-cpu TSS and GDT, so set these when switching
>> @@ -3243,11 +3247,21 @@ void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
>>  	if (!VALID_PAGE(root_hpa))
>>  		return;
>>  
>> -	if (enable_ept)
>> +	if (enable_ept) {
>> +		/*
>> +		 * hyperv_flush_guest_mapping() has the semantics of
>> +		 * invept-single across all pCPUs. This makes root
>> +		 * modifications consistent across pCPUs, so an invept-global
>> +		 * on migration is no longer required.
>> +		 */
>> +		if (vmx_hv_use_flush_guest_mapping(vcpu))
>> +			return (void)WARN_ON_ONCE(hyperv_flush_guest_mapping(root_hpa));
>> +
> 
> HvCallFlushGuestPhysicalAddressSpace sounds like a heavy operation as it
> affects all processors. Is there any visible perfomance impact of this
> change when there are no migrations (e.g. with vCPU pinning)? Or do we
> believe that Hyper-V actually handles invept-context the exact same way?
> 
I'm going to have to do some more investigation to answer that - do you have an
idea of a workload that would be sensitive to tlb flushes that I could compare
this on?

In terms of cost, Hyper-V needs to invalidate the VMs shadow page table for a root
and do the tlb flush. The first part is CPU intensive but is the same in both cases
(hypercall and invept-single). The tlb flush part will require a bit more work for
the hypercall as it needs to happen on all cores, and the tlb will now be empty
for that root.

My assumption is that these local tlb flushes are rather rare as they will
only happen when:
- new root is allocated
- we need to switch to a special root

So not very frequent post vm boot (with or without pinning). And the effect of the
tlb being empty for that root on other CPUs should be a neutral, as users of the
root would have performed the same local flush at a later point in time (when using it).

All the other mmu updates use kvm_flush_remote_tlbs* which already go through the
hypercall.

Jeremi


