Return-Path: <kvm+bounces-67140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 137B1CF8E04
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 15:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3206A3017872
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 14:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70AEA334C19;
	Tue,  6 Jan 2026 14:51:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E0B331A76
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711097; cv=none; b=O3fad9z2KSnMA24vXObXuT5Up3UwbwaqTGlKZtgiqtiw4HRlRcRgQau1HJOs5pENtPqd6Hr0gyL1lNwHPkcHRA8YsPMgsTIl/E5Kp9LK4JeVLV5PrqiWZmE2IcewSHmGcxH2LZ6E0wmG2W4eLoTG1IxCazA65zb9sOIqJT6fpig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711097; c=relaxed/simple;
	bh=yFlzJk48Ymu1o+d5r2Unk7baG8ts/mudb7x1kd2kZlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eoTvya5HrOUSUKilRX1V4Hj/P5la4Y7qZOS0r47r15rnFb3DMSwDqXS+5dotRvY+Bk0qy8TJk2BE1Z5fGsc5k/h2P3okJFz5TnlbqGtuy5n1IDATtI0xQMqbkAw6t34TsIUtZXSQ05PlpiofCjcP2KgC1ogydt6P4NxmuLhdd9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF9FA497;
	Tue,  6 Jan 2026 06:51:27 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7AD13F6A8;
	Tue,  6 Jan 2026 06:51:32 -0800 (PST)
Date: Tue, 6 Jan 2026 14:51:26 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Message-ID: <20260106145126.GA1982@e124191.cambridge.arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
 <20251219155222.1383109-8-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219155222.1383109-8-sascha.bischoff@arm.com>

Hello from 2026!

On Fri, Dec 19, 2025 at 03:52:38PM +0000, Sascha Bischoff wrote:
> GICv5 has moved from using interrupt ranges for different interrupt
> types to using some of the upper bits of the interrupt ID to denote
> the interrupt type. This is not compatible with older GICs (which rely
> on ranges of interrupts to determine the type), and hence a set of
> helpers is introduced. These helpers take a struct kvm*, and use the
> vgic model to determine how to interpret the interrupt ID.
> 
> Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
> helper is introduced to determine if an interrupt is private - SGIs
> and PPIs for older GICs, and PPIs only for GICv5.
> 
> The helpers are plumbed into the core vgic code, as well as the Arch
> Timer and PMU code.
> 
> There should be no functional changes as part of this change.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/arch_timer.c           |  2 +-
>  arch/arm64/kvm/pmu-emul.c             |  7 ++-
>  arch/arm64/kvm/vgic/vgic-kvm-device.c |  2 +-
>  arch/arm64/kvm/vgic/vgic.c            | 14 ++---
>  include/kvm/arm_vgic.h                | 82 +++++++++++++++++++++++++--
>  5 files changed, 91 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 99a07972068d1..6f033f6644219 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1598,7 +1598,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	if (get_user(irq, uaddr))
>  		return -EFAULT;
>  
> -	if (!(irq_is_ppi(irq)))
> +	if (!(irq_is_ppi(vcpu->kvm, irq)))
>  		return -EINVAL;
>  
>  	mutex_lock(&vcpu->kvm->arch.config_lock);
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index b03dbda7f1ab9..afc838ea2503e 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -939,7 +939,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>  		 * number against the dimensions of the vgic and make sure
>  		 * it's valid.
>  		 */
> -		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
> +		if (!irq_is_ppi(vcpu->kvm, irq) &&
> +		    !vgic_valid_spi(vcpu->kvm, irq))
>  			return -EINVAL;
>  	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
>  		   return -EINVAL;
> @@ -991,7 +992,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  		if (!kvm_arm_pmu_irq_initialized(vcpu))
>  			continue;
>  
> -		if (irq_is_ppi(irq)) {
> +		if (irq_is_ppi(vcpu->kvm, irq)) {
>  			if (vcpu->arch.pmu.irq_num != irq)
>  				return false;
>  		} else {
> @@ -1142,7 +1143,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  			return -EFAULT;
>  
>  		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
> -		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
> +		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
>  			return -EINVAL;
>  
>  		if (!pmu_irq_is_valid(kvm, irq))
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 3d1a776b716d7..b12ba99a423e5 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -639,7 +639,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>  		if (vgic_initialized(dev->kvm))
>  			return -EBUSY;
>  
> -		if (!irq_is_ppi(val))
> +		if (!irq_is_ppi(dev->kvm, val))
>  			return -EINVAL;
>  
>  		dev->kvm->arch.vgic.mi_intid = val;
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 430aa98888fda..2c0e8803342e2 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -94,7 +94,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
>  	}
>  
>  	/* LPIs */
> -	if (intid >= VGIC_MIN_LPI)
> +	if (irq_is_lpi(kvm, intid))
>  		return vgic_get_lpi(kvm, intid);
>  
>  	return NULL;
> @@ -123,7 +123,7 @@ static void vgic_release_lpi_locked(struct vgic_dist *dist, struct vgic_irq *irq
>  
>  static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  {
> -	if (irq->intid < VGIC_MIN_LPI)
> +	if (!irq_is_lpi(kvm, irq->intid))
>  		return false;
>  
>  	return refcount_dec_and_test(&irq->refcount);
> @@ -148,7 +148,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  	 * Acquire/release it early on lockdep kernels to make locking issues
>  	 * in rare release paths a bit more obvious.
>  	 */
> -	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >= VGIC_MIN_LPI) {
> +	if (IS_ENABLED(CONFIG_LOCKDEP) && irq_is_lpi(kvm, irq->intid)) {
>  		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
>  	}
>  
> @@ -186,7 +186,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
>  	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
>  
>  	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
> -		if (irq->intid >= VGIC_MIN_LPI) {
> +		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
>  			raw_spin_lock(&irq->irq_lock);
>  			list_del(&irq->ap_list);
>  			irq->vcpu = NULL;
> @@ -521,12 +521,12 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	if (ret)
>  		return ret;
>  
> -	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
> +	if (!vcpu && irq_is_private(kvm, intid))
>  		return -EINVAL;
>  
>  	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
>  
> -	if (intid < VGIC_NR_PRIVATE_IRQS)
> +	if (irq_is_private(kvm, intid))
>  		irq = vgic_get_vcpu_irq(vcpu, intid);
>  	else
>  		irq = vgic_get_irq(kvm, intid);
> @@ -685,7 +685,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
>  		return -EAGAIN;
>  
>  	/* SGIs and LPIs cannot be wired up to any device */
> -	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
> +	if (!irq_is_ppi(vcpu->kvm, intid) && !vgic_valid_spi(vcpu->kvm, intid))
>  		return -EINVAL;
>  
>  	irq = vgic_get_vcpu_irq(vcpu, intid);
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index b261fb3968d03..6778f676eaf08 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -19,6 +19,7 @@
>  #include <linux/jump_label.h>
>  
>  #include <linux/irqchip/arm-gic-v4.h>
> +#include <linux/irqchip/arm-gic-v5.h>
>  
>  #define VGIC_V3_MAX_CPUS	512
>  #define VGIC_V2_MAX_CPUS	8
> @@ -31,9 +32,78 @@
>  #define VGIC_MIN_LPI		8192
>  #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
>  
> -#define irq_is_ppi(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)
> -#define irq_is_spi(irq) ((irq) >= VGIC_NR_PRIVATE_IRQS && \
> -			 (irq) <= VGIC_MAX_SPI)
> +#define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) == (t))
> +
> +#define __irq_is_sgi(t, i)						\
> +	({								\
> +		bool __ret;						\
> +									\
> +		switch (t) {						\
> +		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
> +			__ret = false;					\
> +			break;						\
> +		default:						\
> +			__ret  = (i) < VGIC_NR_SGIS;			\
> +		}							\
> +									\
> +		__ret;							\
> +	})
> +
> +#define __irq_is_ppi(t, i)						\
> +	({								\
> +		bool __ret;						\
> +									\
> +		switch (t) {						\
> +		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
> +			__ret = is_v5_type(GICV5_HWIRQ_TYPE_PPI, (i));	\
> +			break;						\
> +		default:						\
> +			__ret  = (i) >= VGIC_NR_SGIS;			\
> +			__ret &= (i) < VGIC_NR_PRIVATE_IRQS;		\
> +		}							\
> +									\
> +		__ret;							\
> +	})
> +
> +#define __irq_is_spi(t, i)						\
> +	({								\
> +		bool __ret;						\
> +									\
> +		switch (t) {						\
> +		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
> +			__ret = is_v5_type(GICV5_HWIRQ_TYPE_SPI, (i));	\
> +			break;						\
> +		default:						\
> +			__ret  = (i) <= VGIC_MAX_SPI;			\
> +			__ret &= (i) >= VGIC_NR_PRIVATE_IRQS;		\
> +		}							\
> +									\
> +		__ret;							\
> +	})
> +
> +#define __irq_is_lpi(t, i)						\
> +	({								\
> +		bool __ret;						\
> +									\
> +		switch (t) {						\
> +		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
> +			__ret = is_v5_type(GICV5_HWIRQ_TYPE_LPI, (i));	\
> +			break;						\
> +		default:						\
> +			__ret  = (i) >= 8192;				\
> +		}							\
> +									\
> +		__ret;							\
> +	})
> +
> +#define irq_is_sgi(k, i) __irq_is_sgi((k)->arch.vgic.vgic_model, i)
> +#define irq_is_ppi(k, i) __irq_is_ppi((k)->arch.vgic.vgic_model, i)
> +#define irq_is_spi(k, i) __irq_is_spi((k)->arch.vgic.vgic_model, i)
> +#define irq_is_lpi(k, i) __irq_is_lpi((k)->arch.vgic.vgic_model, i)
> +
> +#define irq_is_private(k, i) (irq_is_ppi(k, i) || irq_is_sgi(k, i))
> +
> +#define vgic_is_v5(k) ((k)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)
>  
>  enum vgic_type {
>  	VGIC_V2,		/* Good ol' GICv2 */
> @@ -418,8 +488,12 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
>  
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	((k)->arch.vgic.initialized)
> -#define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
> +#define vgic_valid_nv5_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
>  			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
> +#define vgic_valid_v5_spi(k, i)	(irq_is_spi(k, i) && \
> +				 (FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis))
> +#define vgic_valid_spi(k, i) (vgic_is_v5(k) ?				\
> +			      vgic_valid_v5_spi(k, i) : vgic_valid_nv5_spi(k, i))
>  
>  bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

