Return-Path: <kvm+bounces-29144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE4D9A363B
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 08:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DBFF1F24D11
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 06:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E917C186613;
	Fri, 18 Oct 2024 06:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="OMyw4nQD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566B24084C;
	Fri, 18 Oct 2024 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729234687; cv=none; b=qNyq/mMnC4rTk0Mq46QwQ1a/dm/5xkAUrPwbTRFZs8o+VXrlU4rH3JX2suNPnozFQrOdNNp49TmoiQJQO+poefKiB9PnVlIp9zOF4vKC+jVD2/WmRnj1hhGkljpRKcTwGF//zJebti/vGHWqiWfX6Q7UUwbxpCx/7Ni6iaC/jWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729234687; c=relaxed/simple;
	bh=EczKt7y/VizZTFeaJTGxrhA9ecdv+OWWhq2AH80u2JA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rnp0TKDukPjNyl/tNMtZN9NgxbMdLcWO1CzoykMTVasFZRo9+f5GmxUgn870Duc0xFqQfDNpFZrmayamthmHk4MJHooTcW3n1kHGXloFGmkogjqHm447UTjQzTNgeiGfPrPrl5PacU/HlzYvTa8lrGo82VHEdoW83w7XY+Jc7VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=OMyw4nQD; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1729234686; x=1760770686;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mZ1eLDh06JHURySKlmMff5smCYvbh+7KwOaiRngge2Q=;
  b=OMyw4nQDMK13F3TvVd1pjFVQFgwecxj33fboe7fW4fTMlRQZSJenDu3C
   b0fDLLB54e/ai/ZF++oEGWmDAUGwmrDUseugCeFL1eRUTgi5i6Tl7NQgf
   QnHHU2oLbzQngclRRYSvQn7Piw2f8TGM0iMpvCRca09RBvn2Rc68dIgBb
   s=;
X-IronPort-AV: E=Sophos;i="6.11,212,1725321600"; 
   d="scan'208";a="344111322"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 06:58:04 +0000
Received: from EX19MTAUEB002.ant.amazon.com [10.0.0.204:62437]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.62.171:2525] with esmtp (Farcaster)
 id 7405845f-60f7-4d9d-8b04-1518434ae9d0; Fri, 18 Oct 2024 06:58:03 +0000 (UTC)
X-Farcaster-Flow-ID: 7405845f-60f7-4d9d-8b04-1518434ae9d0
Received: from EX19EXOUEC001.ant.amazon.com (10.252.135.173) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 18 Oct 2024 06:57:56 +0000
Received: from EX19MTAUEB002.ant.amazon.com (10.252.135.47) by
 EX19EXOUEC001.ant.amazon.com (10.252.135.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 18 Oct 2024 06:57:54 +0000
Received: from email-imr-corp-prod-pdx-all-2c-c4413280.us-west-2.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Fri, 18 Oct 2024 06:57:54 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-pdx-all-2c-c4413280.us-west-2.amazon.com (Postfix) with ESMTPS id A861AA03BD;
	Fri, 18 Oct 2024 06:57:42 +0000 (UTC)
Message-ID: <8c6b9bfb-292f-45c8-916e-e0aae961ba5c@amazon.co.uk>
Date: Fri, 18 Oct 2024 07:57:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/11] KVM: guest_memfd: Add guest_memfd support to
 kvm_(read|/write)_guest_page()
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>
CC: <kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<linux-mm@kvack.org>, <pbonzini@redhat.com>, <chenhuacai@kernel.org>,
	<mpe@ellerman.id.au>, <anup@brainfault.org>, <paul.walmsley@sifive.com>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <seanjc@google.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <xiaoyao.li@intel.com>, <yilun.xu@intel.com>,
	<chao.p.peng@linux.intel.com>, <jarkko@kernel.org>, <amoorthy@google.com>,
	<dmatlack@google.com>, <yu.c.zhang@linux.intel.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <mail@maciej.szmigiero.name>, <david@redhat.com>,
	<michael.roth@amd.com>, <wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <shuah@kernel.org>,
	<hch@infradead.org>, <jgg@nvidia.com>, <rientjes@google.com>,
	<jhubbard@nvidia.com>, <fvdl@google.com>, <hughd@google.com>,
	<jthoughton@google.com>
References: <diqzttdaxuol.fsf@ackerleytng-ctop-specialist.c.googlers.com>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <diqzttdaxuol.fsf@ackerleytng-ctop-specialist.c.googlers.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On Thu, 2024-10-17 at 22:53 +0100, Ackerley Tng wrote:
> Fuad Tabba <tabba@google.com> writes:
> 
>> Make kvm_(read|/write)_guest_page() capable of accessing guest
>> memory for slots that don't have a userspace address, but only if
>> the memory is mappable, which also indicates that it is
>> accessible by the host.
> 
> Fuad explained to me that this patch removes the need for userspace to
> mmap a guest_memfd fd just to provide userspace_addr when only a limited
> range of shared pages are required, e.g. for kvm_clock.
> 
> Questions to anyone who might be more familiar:
> 
> 1. Should we let userspace save the trouble of providing userspace_addr
>    if only KVM (and not userspace) needs to access the shared pages?
> 2. Other than kvm_{read,write}_guest_page, are there any other parts of
>    KVM that may require updates so that guest_memfd can be used directly
>    from the kernel?
> 
> Patrick, does this help to answer the question of "how does KVM
> internally access guest_memfd for non-CoCo VMs" that you brought up in
> this other thread [*]?

Just patching kvm_{read,write}_guest sadly does not solve all the
problems on x86, there's also guest page table walks (which use a
get_user/try_cmpxchg on userspace_addr directly), and kvm-clock, which
uses a special mechanism (gfn_to_pfn_cache) to translate gpa to pfns via
userspace_addr (and uses gup in the process). These aren't impossible to
also teach about gmem (details in my patch series [1], which does all
this in the context of direct map removal), but with direct map removal,
all these would need to additionally temporarily restore the direct map,
which is expensive due to tlb flushes. That's the main reason why I was
so excited about the userspace_addr approach, because it'd mean no need
for tlb flushes (you can do copy_from_user and friends without direct
map entries), and every thing except kvm-clock will "just work" (and
massaging kvm-clock to also work in this model is easier than making it
work with on-demand direct map restoration, I think).

There's also something called `kvm_{read,write}_guest_cached`, (I think
async page faulting uses it), but that's fairly easy to deal with [3].

There's another problem for x86 here, which is that during instruction
fetch for MMIO emulation (the CPU doesn't help us here sadly, outside of
modern AMD processors [2]), there is no way to mark pages as
shared/mappable ahead of time (although I guess this is only a problem
for CoCo VMs with in-place sharing on x86 that don't do TDX-style
paravirtual MMIO, which I am not sure is something that even exists. I
know for my non-CoCo usecase I would just unconditionally set all of
gmem to faultable but without direct map entries. But then I'd need
separate knobs for "private" and "faultable").

[1]: https://lore.kernel.org/kvm/20240910163038.1298452-1-roypat@amazon.co.uk/
[2]: https://lore.kernel.org/kvm/ZkI0SCMARCB9bAfc@google.com/
[3]: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.co.uk/T/#ma61de70f906cd6553ffba02563d1e617f7c9246b

> [*] https://lore.kernel.org/all/6bca3ad4-3eca-4a75-a775-5f8b0467d7a3@amazon.co.uk/
> 
>>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>  virt/kvm/kvm_main.c | 137 ++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 118 insertions(+), 19 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index aed9cf2f1685..77e6412034b9 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3399,23 +3399,114 @@ int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
>>       return kvm_gmem_toggle_mappable(kvm, start, end, false);
>>  }
>>
>> +static int __kvm_read_guest_memfd_page(struct kvm *kvm,
>> +                                    struct kvm_memory_slot *slot,
>> +                                    gfn_t gfn, void *data, int offset,
>> +                                    int len)
>> +{
>> +     struct page *page;
>> +     u64 pfn;
>> +     int r;
>> +
>> +     /*
>> +      * Holds the folio lock until after checking whether it can be faulted
>> +      * in, to avoid races with paths that change a folio's mappability.
>> +      */
>> +     r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
>> +     if (r)
>> +             return r;
>> +
>> +     page = pfn_to_page(pfn);
>> +
>> +     if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
>> +             r = -EPERM;
>> +             goto unlock;
>> +     }
>> +     memcpy(data, page_address(page) + offset, len);
>> +unlock:
>> +     if (r)
>> +             put_page(page);
>> +     else
>> +             kvm_release_pfn_clean(pfn);
>> +     unlock_page(page);
>> +
>> +     return r;
>> +}
>> +
>> +static int __kvm_write_guest_memfd_page(struct kvm *kvm,
>> +                                     struct kvm_memory_slot *slot,
>> +                                     gfn_t gfn, const void *data,
>> +                                     int offset, int len)
>> +{
>> +     struct page *page;
>> +     u64 pfn;
>> +     int r;
>> +
>> +     /*
>> +      * Holds the folio lock until after checking whether it can be faulted
>> +      * in, to avoid races with paths that change a folio's mappability.
>> +      */
>> +     r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
>> +     if (r)
>> +             return r;
>> +
>> +     page = pfn_to_page(pfn);
>> +
>> +     if (!kvm_gmem_is_mappable(kvm, gfn, gfn + 1)) {
>> +             r = -EPERM;
>> +             goto unlock;
>> +     }
>> +     memcpy(page_address(page) + offset, data, len);
>> +unlock:
>> +     if (r)
>> +             put_page(page);
>> +     else
>> +             kvm_release_pfn_dirty(pfn);
>> +     unlock_page(page);
>> +
>> +     return r;
>> +}
>> +#else
>> +static int __kvm_read_guest_memfd_page(struct kvm *kvm,
>> +                                    struct kvm_memory_slot *slot,
>> +                                    gfn_t gfn, void *data, int offset,
>> +                                    int len)
>> +{
>> +     WARN_ON_ONCE(1);
>> +     return -EIO;
>> +}
>> +
>> +static int __kvm_write_guest_memfd_page(struct kvm *kvm,
>> +                                     struct kvm_memory_slot *slot,
>> +                                     gfn_t gfn, const void *data,
>> +                                     int offset, int len)
>> +{
>> +     WARN_ON_ONCE(1);
>> +     return -EIO;
>> +}
>>  #endif /* CONFIG_KVM_GMEM_MAPPABLE */
>>
>>  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
>> -static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>> -                              void *data, int offset, int len)
>> +
>> +static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
>> +                              gfn_t gfn, void *data, int offset, int len)
>>  {
>> -     int r;
>>       unsigned long addr;
>>
>>       if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
>>               return -EFAULT;
>>
>> +     if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
>> +         kvm_slot_can_be_private(slot) &&
>> +         !slot->userspace_addr) {
>> +             return __kvm_read_guest_memfd_page(kvm, slot, gfn, data,
>> +                                                offset, len);
>> +     }
>> +
>>       addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
>>       if (kvm_is_error_hva(addr))
>>               return -EFAULT;
>> -     r = __copy_from_user(data, (void __user *)addr + offset, len);
>> -     if (r)
>> +     if (__copy_from_user(data, (void __user *)addr + offset, len))
>>               return -EFAULT;
>>       return 0;
>>  }
>> @@ -3425,7 +3516,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>>  {
>>       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>>
>> -     return __kvm_read_guest_page(slot, gfn, data, offset, len);
>> +     return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_read_guest_page);
>>
>> @@ -3434,7 +3525,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
>>  {
>>       struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>>
>> -     return __kvm_read_guest_page(slot, gfn, data, offset, len);
>> +     return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
>>
>> @@ -3511,22 +3602,30 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>>
>>  /* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
>>  static int __kvm_write_guest_page(struct kvm *kvm,
>> -                               struct kvm_memory_slot *memslot, gfn_t gfn,
>> -                               const void *data, int offset, int len)
>> +                               struct kvm_memory_slot *slot, gfn_t gfn,
>> +                               const void *data, int offset, int len)
>>  {
>> -     int r;
>> -     unsigned long addr;
>> -
>>       if (WARN_ON_ONCE(offset + len > PAGE_SIZE))
>>               return -EFAULT;
>>
>> -     addr = gfn_to_hva_memslot(memslot, gfn);
>> -     if (kvm_is_error_hva(addr))
>> -             return -EFAULT;
>> -     r = __copy_to_user((void __user *)addr + offset, data, len);
>> -     if (r)
>> -             return -EFAULT;
>> -     mark_page_dirty_in_slot(kvm, memslot, gfn);
>> +     if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&
>> +         kvm_slot_can_be_private(slot) &&
>> +         !slot->userspace_addr) {
>> +             int r = __kvm_write_guest_memfd_page(kvm, slot, gfn, data,
>> +                                                  offset, len);
>> +
>> +             if (r)
>> +                     return r;
>> +     } else {
>> +             unsigned long addr = gfn_to_hva_memslot(slot, gfn);
>> +
>> +             if (kvm_is_error_hva(addr))
>> +                     return -EFAULT;
>> +             if (__copy_to_user((void __user *)addr + offset, data, len))
>> +                     return -EFAULT;
>> +     }
>> +
>> +     mark_page_dirty_in_slot(kvm, slot, gfn);
>>       return 0;
>>  }

