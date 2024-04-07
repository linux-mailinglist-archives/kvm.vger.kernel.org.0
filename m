Return-Path: <kvm+bounces-13816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C37289AE0B
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 04:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65A50B22000
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 02:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655681849;
	Sun,  7 Apr 2024 02:26:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3819EDC
	for <kvm@vger.kernel.org>; Sun,  7 Apr 2024 02:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712456761; cv=none; b=l9lwpUmSxWevnoNl2KsqWLBEYxcYPsg3EGyPTW0cmZJ1PmiCDPcroPdZ/eUsBZXhmqWeqd9nsophL8uYNTxzl4dvCVMyT/jgO/72jaeS55oTzCQig0H40d0GT1ZouOISPtOvQhCcE6xDEES11aFcWEcsdA4avf3F7PwhIp0DGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712456761; c=relaxed/simple;
	bh=EkbdKJ11qos7d/qqRHx1IHZdaci9z7VB/ViKsFU/akU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pHYzhV5DEwV1gbx3tEBfFtRKWmIxNlVduDDNPtxNnFFe9VfeIhN4BgkMAh1GL5pCcQxSszIz8nWEm93dk169zmXXJNXAWaCYWIgImbCm+Pi8gO4OEi182yL5K5IZNUoH8H/U/7vXHt8iQyfcuSMu9ZE29fQHV75slfPF5WPwvvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8DxK+k0BBJmj_QjAA--.64550S3;
	Sun, 07 Apr 2024 10:25:56 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDBMwBBJmoGx0AA--.27907S3;
	Sun, 07 Apr 2024 10:25:54 +0800 (CST)
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during
 CLEAR_DIRTY_LOG
To: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20240402213656.3068504-1-dmatlack@google.com>
 <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <be8f55c6-dd28-ba94-b64f-ed86de680902@loongson.cn>
Date: Sun, 7 Apr 2024 10:25:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zg7fAr7uYMiw_pc3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxDBMwBBJmoGx0AA--.27907S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxuw1rXr4DJr15tr13Jr4fJFc_yoW7tr4xpF
	WIvas8KFWaqF18Zryxt34Duw1rtws2grn8JFyrW3yDG39xtrn8Gw1I9ayIvFW3JryFqanY
	ya1Yg3W7W3yDAwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07joc_-UUU
	UU=



On 2024/4/5 上午1:10, Sean Christopherson wrote:
> On Thu, Apr 04, 2024, David Matlack wrote:
>> On Tue, Apr 2, 2024 at 6:50 PM maobibo <maobibo@loongson.cn> wrote:
>>>> This change eliminates dips in guest performance during live migration
>>>> in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
>>>> 1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, which
>>> Frequently drop/reacquire mmu_lock will cause userspace migration
>>> process issuing CLEAR ioctls to contend with 160 vCPU, migration speed
>>> maybe become slower.
>>
>> In practice we have not found this to be the case. With this patch
>> applied we see a significant improvement in guest workload throughput
>> while userspace is issuing CLEAR ioctls without any change to the
>> overall migration duration.
> 
> ...
> 
>> In the case of this patch, there doesn't seem to be a trade-off. We
>> see an improvement to vCPU performance without any regression in
>> migration duration or other metrics.
> 
> For x86.  We need to keep in mind that not all architectures have x86's optimization
> around dirty logging faults, or around faults in general. E.g. LoongArch's (which
> I assume is Bibo Mao's primary interest) kvm_map_page_fast() still acquires mmu_lock.
> And if the fault can't be handled in the fast path, KVM will actually acquire
> mmu_lock twice (mmu_lock is dropped after the fast-path, then reacquired after
> the mmu_seq and fault-in pfn stuff).
yes, there is no lock in function fast_page_fault on x86, however mmu 
spinlock is held on fast path on LoongArch. I do not notice this, 
originally I think that there is read_lock on x86 fast path for pte 
modification, write lock about page table modification.
> 
> So for x86, I think we can comfortably state that this change is a net positive
> for all scenarios.  But for other architectures, that might not be the case.
> I'm not saying this isn't a good change for other architectures, just that we
> don't have relevant data to really know for sure.
 From the code there is contention between migration assistant thread 
and vcpu thread in slow path where huge page need be split if memslot is 
dirty log enabled, however there is no contention between migration 
assistant thread and vcpu fault fast path. If it is right, negative 
effect is small on x86.

> 
> Absent performance data for other architectures, which is likely going to be
> difficult/slow to get, it might make sense to have this be opt-in to start.  We
> could even do it with minimal #ifdeffery, e.g. something like the below would allow
> x86 to do whatever locking it wants in kvm_arch_mmu_enable_log_dirty_pt_masked()
> (I assume we want to give kvm_get_dirty_log_protect() similar treatment?).
> 
> I don't love the idea of adding more arch specific MMU behavior (going the wrong
> direction), but it doesn't seem like an unreasonable approach in this case.
No special modification for this, it is a little strange. LoongArch page 
fault fast path can improve later.

Regards
Bibo Mao
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 86d267db87bb..5eb1ce83f29d 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -66,9 +66,9 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
>          if (!memslot || (offset + __fls(mask)) >= memslot->npages)
>                  return;
>   
> -       KVM_MMU_LOCK(kvm);
> +       KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>          kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
> -       KVM_MMU_UNLOCK(kvm);
> +       KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>   }
>   
>   int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d1fd9cb5d037..74ae844e4ed0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2279,7 +2279,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
>                  dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
>                  memset(dirty_bitmap_buffer, 0, n);
>   
> -               KVM_MMU_LOCK(kvm);
> +               KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>                  for (i = 0; i < n / sizeof(long); i++) {
>                          unsigned long mask;
>                          gfn_t offset;
> @@ -2295,7 +2295,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
>                          kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
>                                                                  offset, mask);
>                  }
> -               KVM_MMU_UNLOCK(kvm);
> +               KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>          }
>   
>          if (flush)
> @@ -2390,7 +2390,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>          if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
>                  return -EFAULT;
>   
> -       KVM_MMU_LOCK(kvm);
> +       KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>          for (offset = log->first_page, i = offset / BITS_PER_LONG,
>                   n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
>               i++, offset += BITS_PER_LONG) {
> @@ -2413,7 +2413,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>                                                                  offset, mask);
>                  }
>          }
> -       KVM_MMU_UNLOCK(kvm);
> +       KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>   
>          if (flush)
>                  kvm_flush_remote_tlbs_memslot(kvm, memslot);
> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
> index ecefc7ec51af..39d8b809c303 100644
> --- a/virt/kvm/kvm_mm.h
> +++ b/virt/kvm/kvm_mm.h
> @@ -20,6 +20,11 @@
>   #define KVM_MMU_UNLOCK(kvm)            spin_unlock(&(kvm)->mmu_lock)
>   #endif /* KVM_HAVE_MMU_RWLOCK */
>   
> +#ifndef KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT
> +#define KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT     KVM_MMU_LOCK
> +#define KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT   KVM_MMU_UNLOCK
> +#endif
> +
>   kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
>                       bool *async, bool write_fault, bool *writable);
>   
> 


