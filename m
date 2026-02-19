Return-Path: <kvm+bounces-71349-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGqtCcntlmngrAIAu9opvQ
	(envelope-from <kvm+bounces-71349-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 12:02:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CC015E1FB
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 12:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B21D3300515E
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB4F33D6D4;
	Thu, 19 Feb 2026 11:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="J1v/hL83"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803572E9749;
	Thu, 19 Feb 2026 11:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.64.237.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771498947; cv=none; b=Fbz/iBNI4xBPKjHVj4GZk4VuSAsz9t5LVPFQC0Szxcyev2msauwgxNLe3Zjex8ir+BzHtQ1AD0h6Qr25J4Mk3b9gs7eYU26lTVQUkkYRxn4TGTIt4bkUryWV9LTqU5qxc2Slw/zOUuPaDlBaR8mND2yttY2NwafBGg92xmWmVu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771498947; c=relaxed/simple;
	bh=C3azEjd9Q/lpDpEqhZLISwLJK/ySYnW2dc/4k3VDW4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=poKNgOuCiZSv5Ey1gJYrsuR7IYb4prm2gc+UomN6J2QYrdeO5EtUFK1841Tv8EfuyFW8qzYTReQB3QKbBeddWm0tNRkArymYb0mD7VWLGVwwZ9buRW8PEVwSOZU4Jl7YMBZssBdBDrKRqZkB3LkfnkKn0w6OHxkZdlKAcwrD+nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=J1v/hL83; arc=none smtp.client-ip=3.64.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1771498945; x=1803034945;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=eow1P/X0RGiy5mEidwiSagvFpE7USJgElSxN5XrktG4=;
  b=J1v/hL83Osf60TjFI8LWYO44ddIA1lJz4TH1DeLpslLwArDv2NGteBxB
   JYJmBGHB8s965ivAXmY3P0bISRDRGM7ZXR7HirzFk5JOk3AsYFBPyGn/6
   vN6SGQplyIUHOROLhkqFgsz4BDsU2opQqviMvbMkqVVFDxcJ/K20LSLgX
   fuDQtn3kolWJhg1xBUxC89VD7LJIeb7NQYp0gx15epm9veid0Sweb8IFO
   Vqgg+v3ke6iSnLvZ37OOfBa6qV8FjRF3lcLd7Tc7cJT9bZUMnhsNywePN
   HitKCgAJUgWAr4Br284ygtWZ0GXdCXlVkofpVRqTDAp5PMSQHLEUMJfc3
   g==;
X-CSE-ConnectionGUID: 1JvXgHKPTiSwUPOx9CCbYg==
X-CSE-MsgGUID: +J1U6hKtTcyvFQM12wO3Bw==
X-IronPort-AV: E=Sophos;i="6.21,299,1763424000"; 
   d="scan'208";a="9572951"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 11:02:21 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:29903]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.46.179:2525] with esmtp (Farcaster)
 id 49685664-8d44-4dc2-aed2-746cca25b8a9; Thu, 19 Feb 2026 11:02:21 +0000 (UTC)
X-Farcaster-Flow-ID: 49685664-8d44-4dc2-aed2-746cca25b8a9
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 19 Feb 2026 11:02:20 +0000
Received: from [192.168.192.247] (10.106.82.39) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 19 Feb 2026 11:02:19 +0000
Message-ID: <c1241c0b-5930-4b0e-a924-9d9cccee7ebd@amazon.com>
Date: Thu, 19 Feb 2026 11:02:18 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v4 4/4] KVM: Avoid synchronize_srcu() in
 kvm_io_bus_register_dev()
To: Keir Fraser <keirf@google.com>, Sean Christopherson <seanjc@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Eric Auger <eric.auger@redhat.com>, Oliver Upton
	<oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon
	<will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Li RongQing
	<lirongqing@baidu.com>
References: <20250909100007.3136249-1-keirf@google.com>
 <20250909100007.3136249-5-keirf@google.com>
 <a84ddba8-12da-489a-9dd1-ccdf7451a1ba@amazon.com>
 <aY-x0OlJQEqInyNF@google.com>
 <dcbd7a58-c961-4510-ae48-ef7fd4f4d75c@amazon.com>
 <aZS8XXOW7vhMkNWQ@google.com>
 <162cedc3-cd6c-494c-b39e-daadfbd6d8db@amazon.com>
 <aZXifSagpbj4CjBn@google.com>
 <7e46af52-b6f3-43cf-a970-8c179a964729@amazon.com>
 <aZbA0IZE1i0w1BTH@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <aZbA0IZE1i0w1BTH@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D005EUA002.ant.amazon.com (10.252.50.11) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amazon.com:+];
	TO_DN_SOME(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71349-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	HAS_REPLYTO(0.00)[kalyazin@amazon.com];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kalyazin@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 32CC015E1FB
X-Rspamd-Action: no action



On 19/02/2026 07:50, Keir Fraser wrote:
> On Wed, Feb 18, 2026 at 04:15:33PM +0000, Nikita Kalyazin wrote:
>>
>>
>> On 18/02/2026 16:02, Keir Fraser wrote:
>>> On Wed, Feb 18, 2026 at 12:55:11PM +0000, Nikita Kalyazin wrote:
>>>>
>>>>
>>>> On 17/02/2026 19:07, Sean Christopherson wrote:
>>>>> On Mon, Feb 16, 2026, Nikita Kalyazin wrote:
>>>>>> On 13/02/2026 23:20, Sean Christopherson wrote:
>>>>>>> On Fri, Feb 13, 2026, Nikita Kalyazin wrote:
>>>>>>>> I am not aware of way to make it fast for both use cases and would be more
>>>>>>>> than happy to hear about possible solutions.
>>>>>>>
>>>>>>> What if we key off of vCPUS being created?  The motivation for Keir's change was
>>>>>>> to avoid stalling during VM boot, i.e. *after* initial VM creation.
>>>>>>
>>>>>> It doesn't work as is on x86 because the delay we're seeing occurs after the
>>>>>> created_cpus gets incremented
>>>>>
>>>>> I don't follow, the suggestion was to key off created_vcpus in
>>>>> kvm_io_bus_register_dev(), not in kvm_swap_active_memslots().  I can totally
>>>>> imagine the patch not working, but the ordering in kvm_vm_ioctl_create_vcpu()
>>>>> should be largely irrelevant.
>>>>
>>>> Yes, you're right, it's irrelevant.  I had made the change in
>>>> kvm_io_bus_register_dev() like proposed, but have no idea how I couldn't see
>>>> the effect.  I retested it now and it's obvious that it works on x86.  Sorry
>>>> for the confusion.
>>>>
>>>>>
>>>>> Probably a moot point though.
>>>>
>>>> Yes, this will not solve the problem on ARM.
>>>
>>> Sorry for being late to this thread. I'm a bit confused now. Did
>>> Sean's original patch (reintroducing the old logic, based on whether
>>> any vcpus have been created) work for both/either/neither arch? I
>>> would have expected it to work for both ARM and X86, despite the
>>> offending synchronize_srcu() not being in the vcpu-creation ioctl on
>>> ARM, and I think that is finally what your testing seems to show? If
>>> so then that seems the pragmatic if somewhat ugly way forward.
>>
>> The original patch from Sean works for x86.  I didn't test it on ARM as it's
>> harder for me to do, but I don't expect it to work because it only affects
>> the pre-vcpu-creation phase.
> 
> Ok, looking closer at one of your previous replies, the first fix
> doesn't work for you on ARM because there your vcpu creations occur
> earlier than on X86? Fair enough.

Yes, that's correct.

> 
>> We discussed the second patch at the KVM sync earlier today, then I retested
>> it and it appears to solve the issue for both, but I'm going to have more
>> complete results tomorrow.

Sean,

I looked at the tests we ran overnight and your 2nd patch 
(call_srcu_expedited) brings the latencies back to the original 
baselines on both x86 and ARM.  What would be the next steps?  Looping 
Paul in to make sure the proposal is sensible?

>>
>> Are you by chance able to have a look whether KVM_SET_USER_MEMORY_REGION
>> execution elongates on ARM in your environment (with the 4/4 patch)? I'd be
>> curious to know why not if it doesn't.
> 
> On our VMM (crosvm) the kvm_io_bus_register_dev happen much later,
> during actual VM boot (device probe phase), so the results would not
> be comparable. In our scenario we generally save milliseconds on every
> single kvm_io_bus_register_dev invocation.

Ok, thanks.

> 
>>>
>>>    Cheers,
>>>     Keir
>>>
>>>
>>>>>
>>>>>> so it doesn't allow to differentiate the two
>>>>>> cases (below is kvm_vm_ioctl_create_vcpu):
>>>>>>
>>>>>>          kvm->created_vcpus++; // <===== incremented here
>>>>>>          mutex_unlock(&kvm->lock);
>>>>>>
>>>>>>          vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
>>>>>>          if (!vcpu) {
>>>>>>                  r = -ENOMEM;
>>>>>>                  goto vcpu_decrement;
>>>>>>          }
>>>>>>
>>>>>>          BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
>>>>>>          page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>>>>>>          if (!page) {
>>>>>>                  r = -ENOMEM;
>>>>>>                  goto vcpu_free;
>>>>>>          }
>>>>>>          vcpu->run = page_address(page);
>>>>>>
>>>>>>          kvm_vcpu_init(vcpu, kvm, id);
>>>>>>
>>>>>>          r = kvm_arch_vcpu_create(vcpu); // <===== the delay is here
>>>>>>
>>>>>>
>>>>>> firecracker   583 [001]   151.297145: probe:synchronize_srcu_expedited:
>>>>>> (ffffffff813e5cf0)
>>>>>>        ffffffff813e5cf1 synchronize_srcu_expedited+0x1 ([kernel.kallsyms])
>>>>>>        ffffffff81234986 kvm_swap_active_memslots+0x136 ([kernel.kallsyms])
>>>>>>        ffffffff81236cdd kvm_set_memslot+0x1cd ([kernel.kallsyms])
>>>>>>        ffffffff81237518 kvm_set_memory_region.part.0+0x478 ([kernel.kallsyms])
>>>>>>        ffffffff81264dbc __x86_set_memory_region+0xec ([kernel.kallsyms])
>>>>>>        ffffffff8127e2dc kvm_alloc_apic_access_page+0x5c ([kernel.kallsyms])
>>>>>>        ffffffff812b9ed3 vmx_vcpu_create+0x193 ([kernel.kallsyms])
>>>>>>        ffffffff8126788a kvm_arch_vcpu_create+0x1da ([kernel.kallsyms])
>>>>>>        ffffffff8123c54c kvm_vm_ioctl+0x5fc ([kernel.kallsyms])
>>>>>>        ffffffff8167b331 __x64_sys_ioctl+0x91 ([kernel.kallsyms])
>>>>>>        ffffffff8251a89c do_syscall_64+0x4c ([kernel.kallsyms])
>>>>>>        ffffffff8100012b entry_SYSCALL_64_after_hwframe+0x76 ([kernel.kallsyms])
>>>>>>                  6512de ioctl+0x32 (/mnt/host/firecracker)
>>>>>>                   d99a7 std::rt::lang_start+0x37 (/mnt/host/firecracker)
>>>>>>
>>>>>> Also, given that it stumbles after the KVM_CREATE_VCPU on ARM (in
>>>>>> KVM_SET_USER_MEMORY_REGION), it doesn't look like a universal solution.
>>>>>
>>>>> Hmm.  Under the hood, __synchronize_srcu() itself uses __call_srcu, so I _think_
>>>>> the only practical difference (aside from waiting, obviously) between call_srcu()
>>>>> and synchronize_srcu_expedited() with respect to "transferring" grace period
>>>>> latency is that using call_srcu() could start a normal, non-expedited grace period.
>>>>>
>>>>> IIUC, SRCU has best-effort logic to shift in-flight non-expedited grace periods
>>>>> to expedited mode, but if the normal grace period has already started the timer
>>>>> for the delayed invocation of process_srcu(), then SRCU will still wait for one
>>>>> jiffie, i.e. won't immediately queue the work.
>>>>>
>>>>> I have no idea if this is sane and/or acceptable, but before looping in Paul and
>>>>> others, can you try this to see if it helps?
>>>>
>>>> That's exactly what I tried myself before and it didn't help, probably for
>>>> the reason you mentioned above (a normal GP being already started).

I also realised why the same change didn't work for me earlier. 
Apparently other changes in my tree I made for debugging skewed the 
results.  Sorry again for confusion.

>>>>
>>>>>
>>>>> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
>>>>> index 344ad51c8f6c..30437dc8d818 100644
>>>>> --- a/include/linux/srcu.h
>>>>> +++ b/include/linux/srcu.h
>>>>> @@ -89,6 +89,8 @@ void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
>>>>>
>>>>>     void call_srcu(struct srcu_struct *ssp, struct rcu_head *head,
>>>>>                    void (*func)(struct rcu_head *head));
>>>>> +void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
>>>>> +                        rcu_callback_t func);
>>>>>     void cleanup_srcu_struct(struct srcu_struct *ssp);
>>>>>     void synchronize_srcu(struct srcu_struct *ssp);
>>>>>
>>>>> diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
>>>>> index ea3f128de06f..03333b079092 100644
>>>>> --- a/kernel/rcu/srcutree.c
>>>>> +++ b/kernel/rcu/srcutree.c
>>>>> @@ -1493,6 +1493,13 @@ void call_srcu(struct srcu_struct *ssp, struct rcu_head *rhp,
>>>>>     }
>>>>>     EXPORT_SYMBOL_GPL(call_srcu);
>>>>>
>>>>> +void call_srcu_expedited(struct srcu_struct *ssp, struct rcu_head *rhp,
>>>>> +                        rcu_callback_t func)
>>>>> +{
>>>>> +       __call_srcu(ssp, rhp, func, rcu_gp_is_normal());
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(call_srcu_expedited);
>>>>> +
>>>>>     /*
>>>>>      * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
>>>>>      */
>>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>>> index 737b74b15bb5..26215f98c98f 100644
>>>>> --- a/virt/kvm/kvm_main.c
>>>>> +++ b/virt/kvm/kvm_main.c
>>>>> @@ -6036,7 +6036,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>>>>>            memcpy(new_bus->range + i + 1, bus->range + i,
>>>>>                    (bus->dev_count - i) * sizeof(struct kvm_io_range));
>>>>>            rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
>>>>> -       call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
>>>>> +       call_srcu_expedited(&kvm->srcu, &bus->rcu, __free_bus);
>>>>>
>>>>>            return 0;
>>>>>     }
>>>>
>>


