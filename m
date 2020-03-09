Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FA517DEE9
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 12:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCILpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 07:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCILpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 07:45:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26F7F20675;
        Mon,  9 Mar 2020 11:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583754341;
        bh=PcfNfUAlnC8NHw7ToNItaeEPY13GO9PcdycnAWmwYng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WzQ/rqpIMevdrzPCise56y+ZmhkTY1k8rn5glvbIgnjctpFnqFCifdDdu5oJgrGzK
         9pxGnT88lMKbJpjdyTulXH5dqSb9jPpZyYhRVFq2cCddkDwA2BDCvUYnsbJJtCVeIX
         RakR0HAZt5m2v+hgzcMjhAje5fVAtI9RMH7PeA8c=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBGqp-00BEqC-4R; Mon, 09 Mar 2020 11:45:39 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 09 Mar 2020 11:45:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jay Zhou <jianjay.zhou@huawei.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [RFC] KVM: arm64: support enabling dirty log graually in small
 chunks
In-Reply-To: <20200309085727.1106-1-zhukeqian1@huawei.com>
References: <20200309085727.1106-1-zhukeqian1@huawei.com>
Message-ID: <4b85699ec1d354cc73f5302560231f86@misterjones.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jianjay.zhou@huawei.com, sean.j.christopherson@intel.com, pbonzini@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kegian,

In the future, please Cc me on  your KVM/arm64 patches, as well as
all the reviewers mentioned in the MAINTAINERS file.

On 2020-03-09 08:57, Keqian Zhu wrote:
> There is already support of enabling dirty log graually

gradually?

> in small chunks for x86. This adds support for arm64.
> 
> Under the Huawei Kunpeng 920 2.6GHz platform, I did some
> tests with a 128G linux VM and counted the time taken of

Linux

> memory_global_dirty_log_start, here is the numbers:
> 
> VM Size        Before    After optimization
> 128G           527ms     4ms

What does this benchmark do? Can you please provide a pointer to it?

> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
> Cc: Jay Zhou <jianjay.zhou@huawei.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  Documentation/virt/kvm/api.rst    |  2 +-
>  arch/arm64/include/asm/kvm_host.h |  4 ++++
>  virt/kvm/arm/mmu.c                | 30 ++++++++++++++++++++++--------
>  3 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst 
> b/Documentation/virt/kvm/api.rst
> index 0adef66585b1..89d4f2680af1 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5735,7 +5735,7 @@ will be initialized to 1 when created.  This
> also improves performance because
>  dirty logging can be enabled gradually in small chunks on the first 
> call
>  to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
>  KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
> -x86 for now).
> +x86 and arm64 for now).

What is this based on? I can't find this in -next, and you provide no
context whatsoever.

I assume this is related to this:
https://lore.kernel.org/kvm/20200227013227.1401-1-jianjay.zhou@huawei.com/

Is there a userspace counterpart to it?

>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the 
> name
>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that 
> make
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index d87aa609d2b6..0deb2ac7d091 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -16,6 +16,7 @@
>  #include <linux/jump_label.h>
>  #include <linux/kvm_types.h>
>  #include <linux/percpu.h>
> +#include <linux/kvm.h>
>  #include <asm/arch_gicv3.h>
>  #include <asm/barrier.h>
>  #include <asm/cpufeature.h>
> @@ -45,6 +46,9 @@
>  #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
>  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
> 
> +#define KVM_DIRTY_LOG_MANUAL_CAPS   
> (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> +					KVM_DIRTY_LOG_INITIALLY_SET)
> +
>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
> 
>  extern unsigned int kvm_sve_max_vl;
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index e3b9ee268823..5c7ca84dec85 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1438,9 +1438,11 @@ static void stage2_wp_ptes(pmd_t *pmd,
> phys_addr_t addr, phys_addr_t end)
>   * @pud:	pointer to pud entry
>   * @addr:	range start address
>   * @end:	range end address
> + * @wp_ptes:	write protect ptes or not
>   */
>  static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
> -			   phys_addr_t addr, phys_addr_t end)
> +			   phys_addr_t addr, phys_addr_t end,
> +			   bool wp_ptes)

If you are going to pass extra parameters like this, make it at least
extensible (unsigned long flags, for example).

>  {
>  	pmd_t *pmd;
>  	phys_addr_t next;
> @@ -1453,7 +1455,7 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t 
> *pud,
>  			if (pmd_thp_or_huge(*pmd)) {
>  				if (!kvm_s2pmd_readonly(pmd))
>  					kvm_set_s2pmd_readonly(pmd);
> -			} else {
> +			} else if (wp_ptes) {
>  				stage2_wp_ptes(pmd, addr, next);
>  			}
>  		}
> @@ -1465,9 +1467,11 @@ static void stage2_wp_pmds(struct kvm *kvm, 
> pud_t *pud,
>   * @pgd:	pointer to pgd entry
>   * @addr:	range start address
>   * @end:	range end address
> + * @wp_ptes:	write protect ptes or not
>   */
>  static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
> -			    phys_addr_t addr, phys_addr_t end)
> +			    phys_addr_t addr, phys_addr_t end,
> +			    bool wp_ptes)
>  {
>  	pud_t *pud;
>  	phys_addr_t next;
> @@ -1480,7 +1484,7 @@ static void  stage2_wp_puds(struct kvm *kvm, 
> pgd_t *pgd,
>  				if (!kvm_s2pud_readonly(pud))
>  					kvm_set_s2pud_readonly(pud);
>  			} else {
> -				stage2_wp_pmds(kvm, pud, addr, next);
> +				stage2_wp_pmds(kvm, pud, addr, next, wp_ptes);
>  			}
>  		}
>  	} while (pud++, addr = next, addr != end);
> @@ -1491,8 +1495,10 @@ static void  stage2_wp_puds(struct kvm *kvm, 
> pgd_t *pgd,
>   * @kvm:	The KVM pointer
>   * @addr:	Start address of range
>   * @end:	End address of range
> + * @wp_ptes:	Write protect ptes or not
>   */
> -static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, 
> phys_addr_t end)
> +static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr,
> +			    phys_addr_t end, bool wp_ptes)
>  {
>  	pgd_t *pgd;
>  	phys_addr_t next;
> @@ -1513,7 +1519,7 @@ static void stage2_wp_range(struct kvm *kvm,
> phys_addr_t addr, phys_addr_t end)
>  			break;
>  		next = stage2_pgd_addr_end(kvm, addr, end);
>  		if (stage2_pgd_present(kvm, *pgd))
> -			stage2_wp_puds(kvm, pgd, addr, next);
> +			stage2_wp_puds(kvm, pgd, addr, next, wp_ptes);
>  	} while (pgd++, addr = next, addr != end);
>  }
> 
> @@ -1535,6 +1541,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, 
> int slot)
>  	struct kvm_memslots *slots = kvm_memslots(kvm);
>  	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
>  	phys_addr_t start, end;
> +	bool wp_ptes;
> 
>  	if (WARN_ON_ONCE(!memslot))
>  		return;
> @@ -1543,7 +1550,14 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, 
> int slot)
>  	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
> 
>  	spin_lock(&kvm->mmu_lock);
> -	stage2_wp_range(kvm, start, end);
> +	/*
> +	 * If we're with initial-all-set, we don't need to write protect
> +	 * any small page because they're reported as dirty already.
> +	 * However we still need to write-protect huge pages so that the
> +	 * page split can happen lazily on the first write to the huge page.
> +	 */
> +	wp_ptes = !kvm_dirty_log_manual_protect_and_init_set(kvm);
> +	stage2_wp_range(kvm, start, end, wp_ptes);
>  	spin_unlock(&kvm->mmu_lock);
>  	kvm_flush_remote_tlbs(kvm);
>  }
> @@ -1567,7 +1581,7 @@ static void
> kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>  	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
>  	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
> 
> -	stage2_wp_range(kvm, start, end);
> +	stage2_wp_range(kvm, start, end, true);
>  }
> 
>  /*

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
