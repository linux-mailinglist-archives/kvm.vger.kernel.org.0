Return-Path: <kvm+bounces-54029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC8AB1B9CB
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 20:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5CA718A6873
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 18:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA10C295D91;
	Tue,  5 Aug 2025 18:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NcWK4Ajs"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4E811712;
	Tue,  5 Aug 2025 18:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754417060; cv=none; b=hT0k1Kdm4sEdFjqT8dQ24JsCrSsT7ozB+oPoJWwMQJZK3rS212Dy3SM0ufzF6r43pgbznLuQ5Pf/8y6LGgek8iKu6ff04kR3xiUODnsuTiRXFB1P/n8cA1+F8it+RZMuqywwhHOoP4x9iLEaQr7LY2l7VDrlW5hPTZqI1mMn78I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754417060; c=relaxed/simple;
	bh=MJtN4k1Nruf/ZmY148j2YWicg+9zvj2TWex6ubyTDM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t3mD5JQquoIXjqA1rg0L1xvsfB7ktZdDsouy0tOEO9PSayU1YOzmLm9twt3v9BOWm6Rfd2fHehlDt0jWXxxsLniwcS6ECqXTsFFIR9NRpoGsYcDsKyMiFUyBa5NzWehPouNvB6wvl7MCPlRfK+zvCWDM4KuRUoM0AqVyLv/Aei0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NcWK4Ajs; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.80.129.135] (unknown [20.107.5.167])
	by linux.microsoft.com (Postfix) with ESMTPSA id 006A5202189A;
	Tue,  5 Aug 2025 11:04:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 006A5202189A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1754417053;
	bh=+X8vGedp4v4FTKCazxcmKil7EM3tRuf78vox+z+LWEc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NcWK4Ajs8ip8f/wd6l4Riw4CVUwJZsnAhsTtFWBycqrPAezptPWFhwfwaH0muabNQ
	 C7xp7XdoP7L+MFTs8j78NwlAjXoXuVfjgSOocE1R++moz30hw+R0JiwZyFhuteIdbC
	 XANK8YLtqqZXHq50O7ys9HYoNFHek0pw3x5+C3fg=
Message-ID: <ce7ef1f0-c098-4669-85f3-b6ebb437a568@linux.microsoft.com>
Date: Tue, 5 Aug 2025 20:04:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB
 flushes
To: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 alanjiang@microsoft.com, chinang.ma@microsoft.com,
 andrea.pellegrini@microsoft.com, Kevin Tian <kevin.tian@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
 <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
 <875xghoaac.fsf@redhat.com>
 <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
 <87o6tttliq.fsf@redhat.com> <aHWjPSIdp5B-2UBl@google.com>
 <87tt2nm6ie.fsf@redhat.com> <aJE9x_pjBVIdiEJN@google.com>
Content-Language: en-US
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <aJE9x_pjBVIdiEJN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/08/2025 01:09, Sean Christopherson wrote:
> On Mon, Aug 04, 2025, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>> It'll take more work than the below, e.g. to have VMX's construct_eptp() pull the
>>> level and A/D bits from kvm_mmu_page (vendor code can get at the kvm_mmu_page with
>>> root_to_sp()), but for the core concept/skeleton, I think this is it?
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 6e838cb6c9e1..298130445182 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -3839,6 +3839,37 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>>>  }
>>>  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
>>>  
>>> +struct kvm_tlb_flush_root {
>>> +       struct kvm *kvm;
>>> +       hpa_t root;
>>> +};
>>> +
>>> +static void kvm_flush_tlb_root(void *__data)
>>> +{
>>> +       struct kvm_tlb_flush_root *data = __data;
>>> +
>>> +       kvm_x86_call(flush_tlb_root)(data->kvm, data->root);
>>> +}
>>> +
>>> +void kvm_mmu_flush_all_tlbs_root(struct kvm *kvm, struct kvm_mmu_page *root)
>>> +{
>>> +       struct kvm_tlb_flush_root data = {
>>> +               .kvm = kvm,
>>> +               .root = __pa(root->spt),
>>> +       };
>>> +
>>> +       /*
>>> +        * Flush any TLB entries for the new root, the provenance of the root
>>> +        * is unknown.  Even if KVM ensures there are no stale TLB entries
>>> +        * for a freed root, in theory another hypervisor could have left
>>> +        * stale entries.  Flushing on alloc also allows KVM to skip the TLB
>>> +        * flush when freeing a root (see kvm_tdp_mmu_put_root()), and flushing
>>> +        * TLBs on all CPUs allows KVM to elide TLB flushes when a vCPU is
>>> +        * migrated to a different pCPU.
>>> +        */
>>> +       on_each_cpu(kvm_flush_tlb_root, &data, 1);
>>
>> Would it make sense to complement this with e.g. a CPU mask tracking all
>> the pCPUs where the VM has ever been seen running (+ a flush when a new
>> one is added to it)?
>>
>> I'm worried about the potential performance impact for a case when a
>> huge host is running a lot of small VMs in 'partitioning' mode
>> (i.e. when all vCPUs are pinned). Additionally, this may have a negative
>> impact on RT use-cases where each unnecessary interruption can be seen
>> problematic. 
> 
> Oof, right.  And it's not even a VM-to-VM noisy neighbor problem, e.g. a few
> vCPUs using nested TDP could generate a lot of noist IRQs through a VM.  Hrm.
> 
> So I think the basic idea is so flawed/garbage that even enhancing it with per-VM
> pCPU tracking wouldn't work.  I do think you've got the right idea with a pCPU mask
> though, but instead of using a mask to scope IPIs, use it to elide TLB flushes.

Sorry for the delay in replying, I've been sidetracked a bit.

I like this idea more, not special casing the TLB flushing approach per hypervisor is
preferable.

> 
> With the TDP MMU, KVM can have at most 6 non-nested roots active at any given time:
> SMM vs. non-SMM, 4-level vs. 5-level, L1 vs. L2.  Allocating a cpumask for each
> TDP MMU root seems reasonable.  Then on task migration, instead of doing a global
> INVEPT, only INVEPT the current and prev_roots (because getting a new root will
> trigger a flush in kvm_mmu_load()), and skip INVEPT on TDP MMU roots if the pCPU
> has already done a flush for the root.

Just to make sure I follow: current+prev_roots do you mean literally those (i.e. cached prev roots)
or all roots on kvm->arch.tdp_mmu_roots?

So this would mean: on pCPU migration, check if current mmu has is_tdp_mmu_active()
and then perform the INVEPT-single over roots instead of INVEPT-global. Otherwise stick
to the KVM_REQ_TLB_FLUSH.

Would there need to be a check for is_guest_mode(), or that the switch is coming from
the vmx/nested.c? I suppose not because nested doesn't seem to use TDP MMU.
> 
> Or we could do the optimized tracking for all roots.  x86 supports at most 8192
> CPUs, which means 1KiB per root.  That doesn't seem at all painful given that
> each shadow pages consumes 4KiB...

Similar question here: which all roots would need to be tracked+flushed for shadow
paging? pae_roots?


