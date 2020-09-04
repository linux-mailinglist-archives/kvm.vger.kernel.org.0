Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EF225DCA0
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbgIDO7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:59:35 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730237AbgIDO7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 10:59:31 -0400
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 5F1A8D0315C00E3B86EB;
        Fri,  4 Sep 2020 15:59:24 +0100 (IST)
Received: from localhost (10.52.125.29) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 4 Sep 2020
 15:59:23 +0100
Date:   Fri, 4 Sep 2020 15:57:50 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>, <kernel-team@android.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH 12/23] KVM: arm64: Move kvm_vgic_vcpu_pending_irq() to
 irqchip_flow
Message-ID: <20200904155750.00000663@Huawei.com>
In-Reply-To: <20200903152610.1078827-13-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
        <20200903152610.1078827-13-maz@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.125.29]
X-ClientProxiedBy: lhreml743-chm.china.huawei.com (10.201.108.193) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Sep 2020 16:25:59 +0100
Marc Zyngier <maz@kernel.org> wrote:

> Abstract the calls to kvm_vgic_vcpu_pending_irq() via the irqchip_flow
> structure.
> 
> No functional change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

A couple of stray lines in here that I think should be in patch 14

Jonathan

> ---
>  arch/arm64/include/asm/kvm_irq.h | 4 ++++
>  arch/arm64/kvm/arm.c             | 4 ++--
>  arch/arm64/kvm/vgic/vgic-init.c  | 1 +
>  arch/arm64/kvm/vgic/vgic.h       | 6 ++++++
>  include/kvm/arm_vgic.h           | 3 ---
>  5 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
> index 50dfd641cd67..e7a244176ade 100644
> --- a/arch/arm64/include/asm/kvm_irq.h
> +++ b/arch/arm64/include/asm/kvm_irq.h
> @@ -24,6 +24,7 @@ struct kvm_irqchip_flow {
>  	void (*irqchip_vcpu_unblocking)(struct kvm_vcpu *);
>  	void (*irqchip_vcpu_load)(struct kvm_vcpu *);
>  	void (*irqchip_vcpu_put)(struct kvm_vcpu *);
> +	int  (*irqchip_vcpu_pending_irq)(struct kvm_vcpu *);
>  };
>  
>  /*
> @@ -70,4 +71,7 @@ struct kvm_irqchip_flow {
>  #define kvm_irqchip_vcpu_put(v)				\
>  	__vcpu_irqchip_action((v), vcpu_put, (v))
>  
> +#define kvm_irqchip_vcpu_pending_irq(v)			\
> +	__vcpu_irqchip_action_ret((v), vcpu_pending_irq, (v))
> +
>  #endif
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 84d48c312b84..3496d200e488 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -399,8 +399,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
>  	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
> -	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
> -		&& !v->arch.power_off && !v->arch.pause);
> +	return ((irq_lines || kvm_irqchip_vcpu_pending_irq(v)) &&
> +		!v->arch.power_off && !v->arch.pause);
>  }
>  
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 24b3ed9bae5d..8bb847045ef9 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -22,6 +22,7 @@ static struct kvm_irqchip_flow vgic_irqchip_flow = {
>  	.irqchip_vcpu_unblocking	= kvm_vgic_vcpu_unblocking,
>  	.irqchip_vcpu_load		= kvm_vgic_load,
>  	.irqchip_vcpu_put		= kvm_vgic_put,
> +	.irqchip_vcpu_pending_irq	= kvm_vgic_vcpu_pending_irq,
>  };
>  
>  /*
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 190737402365..c5511823eec5 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -321,7 +321,13 @@ int vgic_v4_init(struct kvm *kvm);
>  void vgic_v4_teardown(struct kvm *kvm);
>  void vgic_v4_configure_vsgis(struct kvm *kvm);
>  
> +int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> +
>  void kvm_vgic_load(struct kvm_vcpu *vcpu);
>  void kvm_vgic_put(struct kvm_vcpu *vcpu);
>  
> +void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
> +void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);

Wrong patch?

> +
> +

Nitpick. One line is always enough :)

>  #endif
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index a06d9483e3a6..b2adf9cca334 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -347,14 +347,11 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
>  
> -int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> -
>  #define vgic_initialized(k)	((k)->arch.vgic.initialized)
>  #define vgic_ready(k)		((k)->arch.vgic.ready)
>  #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
>  			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
>  
> -bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid);


