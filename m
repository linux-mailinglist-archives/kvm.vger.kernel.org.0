Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9D01E3ACC
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 09:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387524AbgE0HlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 03:41:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5346 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387487AbgE0HlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 03:41:16 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2E655AB7FCECDC21846F;
        Wed, 27 May 2020 15:41:13 +0800 (CST)
Received: from [10.173.222.27] (10.173.222.27) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 15:41:05 +0800
Subject: Re: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Eric Auger <eric.auger@redhat.com>, <kernel-team@android.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>
References: <20200526161136.451312-1-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <47d6d521-f05e-86fe-4a94-ce21754100ae@huawei.com>
Date:   Wed, 27 May 2020 15:41:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200526161136.451312-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/27 0:11, Marc Zyngier wrote:
> On a system that uses SPIs to implement MSIs (as it would be
> the case on a GICv2 system exposing a GICv2m to its guests),
> we deny the possibility of injecting SPIs on the in-atomic
> fast-path.
> 
> This results in a very large amount of context-switches
> (roughly equivalent to twice the interrupt rate) on the host,
> and suboptimal performance for the guest (as measured with
> a test workload involving a virtio interface backed by vhost-net).
> Given that GICv2 systems are usually on the low-end of the spectrum
> performance wise, they could do without the aggravation.
> 
> We solved this for GICv3+ITS by having a translation cache. But
> SPIs do not need any extra infrastructure, and can be immediately
> injected in the virtual distributor as the locking is already
> heavy enough that we don't need to worry about anything.
> 
> This halves the number of context switches for the same workload.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/vgic/vgic-irqfd.c | 20 ++++++++++++++++----
>   arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
>   2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
> index d8cdfea5cc96..11a9f81115ab 100644
> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
> @@ -107,15 +107,27 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>   			      struct kvm *kvm, int irq_source_id, int level,
>   			      bool line_status)

... and you may also need to update the comment on top of it to
reflect this change.

/**
  * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
  *
  * Currently only direct MSI injection is supported.
  */


Thanks,
Zenghui

>   {
> -	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
> +	if (!level)
> +		return -EWOULDBLOCK;
> +
> +	switch (e->type) {
> +	case KVM_IRQ_ROUTING_MSI: {
>   		struct kvm_msi msi;
>   
> +		if (!vgic_has_its(kvm))
> +			return -EINVAL;
> +
>   		kvm_populate_msi(e, &msi);
> -		if (!vgic_its_inject_cached_translation(kvm, &msi))
> -			return 0;
> +		return vgic_its_inject_cached_translation(kvm, &msi);
>   	}
>   
> -	return -EWOULDBLOCK;
> +	case KVM_IRQ_ROUTING_IRQCHIP:
> +		/* Injecting SPIs is always possible in atomic context */
> +		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
> +
> +	default:
> +		return -EWOULDBLOCK;
> +	}
>   }
>   
>   int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index c012a52b19f5..40cbaca81333 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -757,9 +757,8 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
>   
>   	db = (u64)msi->address_hi << 32 | msi->address_lo;
>   	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
> -
>   	if (!irq)
> -		return -1;
> +		return -EWOULDBLOCK;
>   
>   	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>   	irq->pending_latch = true;
> 
