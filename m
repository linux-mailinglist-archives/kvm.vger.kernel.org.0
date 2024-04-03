Return-Path: <kvm+bounces-13412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D1289623B
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 03:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E27A286241
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 01:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C6815ACB;
	Wed,  3 Apr 2024 01:50:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1B9125CC
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 01:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712109038; cv=none; b=VSYeZVx9+3w/Mzm+H8ob/hX8NrhYVnJcndzWOvqcBa+RqBesJpHktUi7GsudggodJm3sX1MoNAVw8D4BAN2JuAAJgeuO4OY8UKyJqONnkSGPbv2dEnss61BZdhPWfIurZGyuvyhnzP4J2JXDeIAinrQVOOfURwVJBeL0W6127NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712109038; c=relaxed/simple;
	bh=gI0eBQ0I8d63LNXs6IZC57f/D9KjH0P/FN7+Yljy0rE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Iwsyxu5ROH0X/hanulXLWNFfW+4pix7VxCW3oCeuMNKK6m8BD8pag0K1cc1fu7BM5zfHWipsPiVs6iwtZiJhPGrKZhWQffvZGCuB0MHOrJM0XknCn+u9/Tqw8f6Bwxo5cYg49C2v/TmyDk9yNbKLgk+ufElFlxlsYJL2LUdHsuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8CxF+jotQxmt5oiAA--.59669S3;
	Wed, 03 Apr 2024 09:50:32 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWRLetQxm5SlyAA--.13330S3;
	Wed, 03 Apr 2024 09:50:25 +0800 (CST)
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during
 CLEAR_DIRTY_LOG
To: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>
References: <20240402213656.3068504-1-dmatlack@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
Date: Wed, 3 Apr 2024 09:50:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240402213656.3068504-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxWRLetQxm5SlyAA--.13330S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCryfGw1rXFW3tFWftw1rKrX_yoWrGryUpF
	WfAw1DGrW3XryUA3Z2y34Du34ft392gF4DG3Z5tw1rArn8Krn3Wr4Ika1fXF9Yqr1xKan2
	vr4Yqr17u3WUZ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2-VyUUUUU



On 2024/4/3 上午5:36, David Matlack wrote:
> Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG to avoid
> blocking other threads (e.g. vCPUs taking page faults) for too long.
> 
> Specifically, change kvm_clear_dirty_log_protect() to acquire/release
> mmu_lock only when calling kvm_arch_mmu_enable_log_dirty_pt_masked(),
> rather than around the entire for loop. This ensures that KVM will only
> hold mmu_lock for the time it takes the architecture-specific code to
> process up to 64 pages, rather than holding mmu_lock for log->num_pages,
> which is controllable by userspace. This also avoids holding mmu_lock
> when processing parts of the dirty_bitmap that are zero (i.e. when there
> is nothing to clear).
> 
> Moving the acquire/release points for mmu_lock should be safe since
> dirty_bitmap_buffer is already protected by slots_lock, and dirty_bitmap
> is already accessed with atomic_long_fetch_andnot(). And at least on x86
> holding mmu_lock doesn't even serialize access to the memslot dirty
> bitmap, as vCPUs can call mark_page_dirty_in_slot() without holding
> mmu_lock.
> 
> This change eliminates dips in guest performance during live migration
> in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
> 1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, which
Frequently drop/reacquire mmu_lock will cause userspace migration 
process issuing CLEAR ioctls to contend with 160 vCPU, migration speed 
maybe become slower. In theory priority of userspace migration thread 
should be higher than vcpu thread.

Drop and reacquire mmu_lock with 64-pages may be a little too smaller,
in generic it is one huge page size. However it should be decided by 
framework maintainer:)

Regards
Bibo Mao
> would also reduce contention on mmu_lock, but doing so will increase the
> rate of remote TLB flushing. And there's really no reason to punt this
> problem to userspace since KVM can just drop and reacquire mmu_lock more
> frequently.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Anup Patel <anup@brainfault.org>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
> v2:
>   - Rebase onto kvm/queue [Marc]
> 
> v1: https://lore.kernel.org/kvm/20231205181645.482037-1-dmatlack@google.com/
> 
>   virt/kvm/kvm_main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fb49c2a60200..0a8b25a52c15 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2386,7 +2386,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>   	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
>   		return -EFAULT;
>   
> -	KVM_MMU_LOCK(kvm);
>   	for (offset = log->first_page, i = offset / BITS_PER_LONG,
>   		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
>   	     i++, offset += BITS_PER_LONG) {
> @@ -2405,11 +2404,12 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>   		*/
>   		if (mask) {
>   			flush = true;
> +			KVM_MMU_LOCK(kvm);
>   			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
>   								offset, mask);
> +			KVM_MMU_UNLOCK(kvm);
>   		}
>   	}
> -	KVM_MMU_UNLOCK(kvm);
>   
>   	if (flush)
>   		kvm_flush_remote_tlbs_memslot(kvm, memslot);
> 
> base-commit: 9bc60f733839ab6fcdde0d0b15cbb486123e6402
> 


