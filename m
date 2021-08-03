Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6F83DEEF9
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 15:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhHCNUF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 3 Aug 2021 09:20:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12442 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbhHCNUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 09:20:05 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GfFkV5ZHJzckN7;
        Tue,  3 Aug 2021 21:16:18 +0800 (CST)
Received: from dggeme703-chm.china.huawei.com (10.1.199.99) by
 dggeme754-chm.china.huawei.com (10.3.19.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 3 Aug 2021 21:19:51 +0800
Received: from dggeme703-chm.china.huawei.com ([10.9.48.230]) by
 dggeme703-chm.china.huawei.com ([10.9.48.230]) with mapi id 15.01.2176.012;
 Tue, 3 Aug 2021 21:19:51 +0800
From:   "limingwang (A)" <limingwang@huawei.com>
To:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v19 11/17] RISC-V: KVM: Implement MMU notifiers
Thread-Topic: [PATCH v19 11/17] RISC-V: KVM: Implement MMU notifiers
Thread-Index: AQHXgqwy4s+Z/E3/sE6z7Q5kXgZ04KthiTvA
Date:   Tue, 3 Aug 2021 13:19:51 +0000
Message-ID: <38734ad1008a46169dcd89e1ded9ac62@huawei.com>
References: <20210727055450.2742868-1-anup.patel@wdc.com>
 <20210727055450.2742868-12-anup.patel@wdc.com>
In-Reply-To: <20210727055450.2742868-12-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.187.17]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c index
> fa9a4f9b9542..4b294113c63b 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -300,7 +300,8 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t
> addr,
>  	}
>  }
> 
> -static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
> +static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
> +			       gpa_t size, bool may_block)
>  {
>  	int ret;
>  	pte_t *ptep;
> @@ -325,6 +326,13 @@ static void stage2_unmap_range(struct kvm *kvm,
> gpa_t start, gpa_t size)
> 
>  next:
>  		addr += page_size;
> +
> +		/*
> +		 * If the range is too large, release the kvm->mmu_lock
> +		 * to prevent starvation and lockup detector warnings.
> +		 */
> +		if (may_block && addr < end)
> +			cond_resched_lock(&kvm->mmu_lock);
>  	}
>  }
> 
> @@ -405,7 +413,6 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa,
> phys_addr_t hpa,
>  out:
>  	stage2_cache_flush(&pcache);
>  	return ret;
> -
>  }
> 
>  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm, @@
> -547,7 +554,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	spin_lock(&kvm->mmu_lock);
>  	if (ret)
>  		stage2_unmap_range(kvm, mem->guest_phys_addr,
> -				   mem->memory_size);
> +				   mem->memory_size, false);
>  	spin_unlock(&kvm->mmu_lock);
> 
>  out:
> @@ -555,6 +562,73 @@ int kvm_arch_prepare_memory_region(struct kvm
> *kvm,
>  	return ret;
>  }
> 
> +bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +	if (!kvm->arch.pgd)
> +		return 0;
> +
> +	stage2_unmap_range(kvm, range->start << PAGE_SHIFT,
> +			   (range->end - range->start) << PAGE_SHIFT,
> +			   range->may_block);
> +	return 0;
> +}
> +
> +bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range) {
> +	int ret;
> +	kvm_pfn_t pfn = pte_pfn(range->pte);
> +
> +	if (!kvm->arch.pgd)
> +		return 0;
> +
> +	WARN_ON(range->end - range->start != 1);
> +
> +	ret = stage2_map_page(kvm, NULL, range->start << PAGE_SHIFT,
> +			      __pfn_to_phys(pfn), PAGE_SIZE, true, true);
> +	if (ret) {
> +		kvm_err("Failed to map stage2 page (error %d)\n", ret);
> +		return 1;
> +	}

Hi, Anup

I think that it is not appropriate to add kvm_err here, because stage2_set_pte function
may apply for memory based on the pcache parameter. If the value of pcache is NULL,
stage2_set_pte function considers that there is not enough memory and here an invalid
error log is generated.

As an example, this error log is printed when a VM is migrating. But finally the VM migration
is successful. And if the kvm_err is added to the same position in the ARM architecture, the
same error log is also printed.

Mingwang

> +	return 0;
> +}
> +

