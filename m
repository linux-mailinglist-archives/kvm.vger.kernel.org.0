Return-Path: <kvm+bounces-23164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA209466FA
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 05:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E40EC1F21CB5
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 03:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18DF9FC01;
	Sat,  3 Aug 2024 03:02:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F53F9E4;
	Sat,  3 Aug 2024 03:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722654145; cv=none; b=cHCs+U7i1EXGYB9oX+QB+H8hvdm9C1GbrA2TGRpXh4ol5xo1Zeo6ijDPViQ1QH7KYUYFgw4u9JFyWCdRhsRtNJQIHqhYRPBCZiQAzUl8rp/fLspUN/h3p0NXjZH6+ZP4IkcILfYRgJQX3HOf18Qgk/IvUA6T3bSWhApnE4/ncxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722654145; c=relaxed/simple;
	bh=NoDHZy9WHNV+LcYNuOiFb+aviu1JIBbgKM7qngzRd8c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dLeofUESOjhfIlHkN+2VHZklkZ49p4GR0NFUearBAaTq/6QkMXtGvXhFUlctLCouqudzVPaB2sUKzlRLW+0oG5udm+FU19iRHc+eKU43vjhIyBYz6fY5+tDcTYH0d4qDDaCeOLYgE4yKFoPnt0ZQ3hhWvIZBKlhrYwQhgov1bww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxKuq2na1mzuEGAA--.24038S3;
	Sat, 03 Aug 2024 11:02:14 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxwuGwna1mXuwAAA--.5506S3;
	Sat, 03 Aug 2024 11:02:10 +0800 (CST)
Subject: Re: [PATCH v12 64/84] KVM: LoongArch: Mark "struct page" pfns dirty
 only in "slow" page fault path
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-65-seanjc@google.com>
 <a039b758-d4e3-3798-806f-25bceb2f33a5@loongson.cn>
 <Zq00OYowF5kc9QFE@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <345d89c1-4f31-6b49-2cd4-a0696210fa7c@loongson.cn>
Date: Sat, 3 Aug 2024 11:02:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zq00OYowF5kc9QFE@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxwuGwna1mXuwAAA--.5506S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJFyfAryfKw1fGw43AFyrGrX_yoW5uw17pF
	WUCFWqkFs5tryYyrZrt39IvrWrK39xKr1xX3W7J34Fkas0qr1IqF10grWfWFyUA3yfAayS
	qr4UKF9xuFZ8AwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUt529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUShiSDUUUU



On 2024/8/3 上午3:32, Sean Christopherson wrote:
> On Fri, Aug 02, 2024, maobibo wrote:
>> On 2024/7/27 上午7:52, Sean Christopherson wrote:
>>> Mark pages/folios dirty only the slow page fault path, i.e. only when
>>> mmu_lock is held and the operation is mmu_notifier-protected, as marking a
>>> page/folio dirty after it has been written back can make some filesystems
>>> unhappy (backing KVM guests will such filesystem files is uncommon, and
>>> the race is minuscule, hence the lack of complaints).
>>>
>>> See the link below for details.
>>>
>>> Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/loongarch/kvm/mmu.c | 18 ++++++++++--------
>>>    1 file changed, 10 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>>> index 2634a9e8d82c..364dd35e0557 100644
>>> --- a/arch/loongarch/kvm/mmu.c
>>> +++ b/arch/loongarch/kvm/mmu.c
>>> @@ -608,13 +608,13 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>>>    		if (kvm_pte_young(changed))
>>>    			kvm_set_pfn_accessed(pfn);
>>> -		if (kvm_pte_dirty(changed)) {
>>> -			mark_page_dirty(kvm, gfn);
>>> -			kvm_set_pfn_dirty(pfn);
>>> -		}
>>>    		if (page)
>>>    			put_page(page);
>>>    	}
>>> +
>>> +	if (kvm_pte_dirty(changed))
>>> +		mark_page_dirty(kvm, gfn);
>>> +
>>>    	return ret;
>>>    out:
>>>    	spin_unlock(&kvm->mmu_lock);
>>> @@ -915,12 +915,14 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>>>    	else
>>>    		++kvm->stat.pages;
>>>    	kvm_set_pte(ptep, new_pte);
>>> -	spin_unlock(&kvm->mmu_lock);
>>> -	if (prot_bits & _PAGE_DIRTY) {
>>> -		mark_page_dirty_in_slot(kvm, memslot, gfn);
>>> +	if (writeable)
>> Is it better to use write or (prot_bits & _PAGE_DIRTY) here?  writable is
>> pte permission from function hva_to_pfn_slow(), write is fault action.
> 
> Marking folios dirty in the slow/full path basically necessitates marking the
> folio dirty if KVM creates a writable SPTE, as KVM won't mark the folio dirty
> if/when _PAGE_DIRTY is set.
> 
> Practically speaking, I'm 99.9% certain it doesn't matter.  The folio is marked
> dirty by core MM when the folio is made writable, and cleaning the folio triggers
> an mmu_notifier invalidation.  I.e. if the page is mapped writable in KVM's
yes, it is. Thanks for the explanation. kvm_set_pfn_dirty() can be put 
only in slow page fault path. I only concern with fault type, read fault 
type can set pte entry writable however not _PAGE_DIRTY at stage-2 mmu 
table.

> stage-2 PTEs, then its folio has already been marked dirty.
Considering one condition although I do not know whether it exists 
actually. user mode VMM writes the folio with hva address firstly, then 
VCPU thread *reads* the folio. With primary mmu table, pte entry is 
writable and _PAGE_DIRTY is set, with secondary mmu table(state-2 PTE 
table), it is pte_none since the filio is accessed at first time, so 
there will be slow page fault path for stage-2 mmu page table filling.

Since it is read fault, stage-2 PTE will be created with 
_PAGE_WRITE(coming from function hva_to_pfn_slow()), however _PAGE_DIRTY 
is not set. Do we need call kvm_set_pfn_dirty() at this situation?

Regards
Bibo Mao


