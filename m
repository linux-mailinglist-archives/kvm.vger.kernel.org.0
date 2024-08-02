Return-Path: <kvm+bounces-23011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A40E594594A
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 09:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A1F5281CFA
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 07:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5BA1BF32F;
	Fri,  2 Aug 2024 07:53:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A813482CA;
	Fri,  2 Aug 2024 07:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722585238; cv=none; b=fik3RDQ+ZhNAVPVJdhHNM8zB+ZWbJ8rRCr+ZJlallAc3zJguJdDd0Nkb0AlfvvMKAzLSq46RUHG1A8oqf5Odi8w/ofESuUXafRlhctrw5mv43UGvnx7MG3mNT639zluD9csbcMwxnOYlTODjZwyWMZHaf2iVAwjFUiF2QJ+5NXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722585238; c=relaxed/simple;
	bh=R7eZpuNqrRayCW5KMkFo/pXMqCPlvzzqC5jwDXByyG0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=m4lQuG9D7wydVJN5XC2NZTKt7k+I5PCvn6ZT9G3TyosSFnbsy2x2f6PwbCs5AAUsmY19xUQRCklpOBGd5b+h+oyEkrNB/XVmfWTcMNAeEwVRLYeOqdK/5X/BgH7v6RXjRML9vzjI/caDZu3qpGZd9HCHky8wRHcyd0Li7zOEN38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Ax2emRkKxmjVwGAA--.22182S3;
	Fri, 02 Aug 2024 15:53:53 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxbuWNkKxmIGcLAA--.55918S3;
	Fri, 02 Aug 2024 15:53:50 +0800 (CST)
Subject: Re: [PATCH v12 64/84] KVM: LoongArch: Mark "struct page" pfns dirty
 only in "slow" page fault path
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
 David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-65-seanjc@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <a039b758-d4e3-3798-806f-25bceb2f33a5@loongson.cn>
Date: Fri, 2 Aug 2024 15:53:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240726235234.228822-65-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxbuWNkKxmIGcLAA--.55918S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7WFW8JryfWw13KFy5Xw4kKrX_yoW8ZFWxpF
	W7CrZrCrWrtrnav39rt3sF9rs0yrs8Kr1xX3W7G34rKF1qqr1Yq3W0grZ7WF1fJ3s3AayS
	qF1rKa4q9Fs5AwbCm3ZEXasCq-sJn29KB7ZKAUJUUUUt529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUtVW8ZwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUShiSDU
	UUU



On 2024/7/27 上午7:52, Sean Christopherson wrote:
> Mark pages/folios dirty only the slow page fault path, i.e. only when
> mmu_lock is held and the operation is mmu_notifier-protected, as marking a
> page/folio dirty after it has been written back can make some filesystems
> unhappy (backing KVM guests will such filesystem files is uncommon, and
> the race is minuscule, hence the lack of complaints).
> 
> See the link below for details.
> 
> Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/loongarch/kvm/mmu.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 2634a9e8d82c..364dd35e0557 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -608,13 +608,13 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>   		if (kvm_pte_young(changed))
>   			kvm_set_pfn_accessed(pfn);
>   
> -		if (kvm_pte_dirty(changed)) {
> -			mark_page_dirty(kvm, gfn);
> -			kvm_set_pfn_dirty(pfn);
> -		}
>   		if (page)
>   			put_page(page);
>   	}
> +
> +	if (kvm_pte_dirty(changed))
> +		mark_page_dirty(kvm, gfn);
> +
>   	return ret;
>   out:
>   	spin_unlock(&kvm->mmu_lock);
> @@ -915,12 +915,14 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>   	else
>   		++kvm->stat.pages;
>   	kvm_set_pte(ptep, new_pte);
> -	spin_unlock(&kvm->mmu_lock);
>   
> -	if (prot_bits & _PAGE_DIRTY) {
> -		mark_page_dirty_in_slot(kvm, memslot, gfn);
> +	if (writeable)
Is it better to use write or (prot_bits & _PAGE_DIRTY) here?  writable 
is pte permission from function hva_to_pfn_slow(), write is fault action.

Regards
Bibo Mao
>   		kvm_set_pfn_dirty(pfn);
> -	}
> +
> +	spin_unlock(&kvm->mmu_lock);
> +
> +	if (prot_bits & _PAGE_DIRTY)
> +		mark_page_dirty_in_slot(kvm, memslot, gfn);
>   
>   	kvm_release_pfn_clean(pfn);
>   out:
> 


