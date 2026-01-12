Return-Path: <kvm+bounces-67778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0423DD1404E
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6C1A3079AEC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C4E364EB1;
	Mon, 12 Jan 2026 16:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="JMvyJ515"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B7363C78
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768235282; cv=none; b=Po7Qgl9FwIYMrQMPZABZgE53BkbqfgAD1ClhWWJZL3QY80QFimZNuTHQW6xC81yhYiVZW7MQqKvxEA/iBe0PFE8bVKV9gvH8eS/PLamrnq5ZLnmxvpdNkHVNw+1uIFLl1mOeqv8z17zkrsDGCV57JUuqZQmMCySNSNlN+svouzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768235282; c=relaxed/simple;
	bh=SGMfroYvIwXbetnBdKmQKNmKIDe0qBhCFKDXrymiZho=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sn25EAOd8jg5eeAXyh/y67AwQWzc+xotdLxNOlWrz+cXaBWPOwqhcCG5fIH4dvlTy+2g46I/SH+t/cpjeghQXG3Uk3t59wQVqkyxPBztuhokr0nXkLNwYj0O4sQFKiydn4VI6gVqNbuscxkieyQqIRG+NI1fNC4gRKtb75dMFvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=JMvyJ515; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hHzxW/GO7Jo8ul/vRmbAq+7gB4FLjreZTN5kn+6zkTQ=;
	b=JMvyJ515uoNW4aACKSHfHOUsshQP5eI717eoj6X2AQdxuhRsN2PZfx1sL/HPjYfhyOsm1KR32
	SAhK6MpqWt6XkyyD7yWxMvmJNE/Tn0vrYj+DlOb2+YJfM+RpwM4QGoQILWJPNbAmgOr+PJeGpLT
	Pik9JRznXclvGMUEM1l/0ro=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqd5h0Gb2z1P7kf;
	Tue, 13 Jan 2026 00:25:27 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqd875mKdzHnGhc;
	Tue, 13 Jan 2026 00:27:35 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D8394056B;
	Tue, 13 Jan 2026 00:27:52 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:27:21 +0000
Date: Mon, 12 Jan 2026 16:27:20 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v3 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Message-ID: <20260112162720.0000400d@huawei.com>
In-Reply-To: <20260109170400.1585048-27-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-27-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:47 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Now that GICv5 has arrived, the arch timer requires some TLC to
> address some of the key differences introduced with GICv5.
> 
> For PPIs on GICv5, the set_pending_state and queue_irq_unlock irq_ops
> are used as AP lists are not required at all for GICv5. The arch timer
> also introduces an irq_op - get_input_level. Extend the
> arch-timer-provided irq_ops to include the two PPI ops for vgic_v5
> guests.
> 
> When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
> using a vgic_v5, which directly inject the pending state into the
> guest. This means that the host never sees the interrupt for the guest
> for these interrupts. This has three impacts.
> 
> * First of all, the kvm_cpu_has_pending_timer check is updated to
>   explicitly check if the timers are expected to fire.
> 
> * Secondly, for mapped timers (which use DVI) they must be masked on
>   the host prior to entering a GICv5 guest, and unmasked on the return
>   path. This is handled in set_timer_irq_phys_masked.
> 
> * Thirdly, it makes zero sense to attempt to inject state for a DVI'd
>   interrupt. Track which timers are direct, and skip the call to
>   kvm_vgic_inject_irq() for these.
> 
> The final, but rather important, change is that the architected PPIs
> for the timers are made mandatory for a GICv5 guest. Attempts to set
> them to anything else are actively rejected. Once a vgic_v5 is
> initialised, the arch timer PPIs are also explicitly reinitialised to
> ensure the correct GICv5-compatible PPIs are used - this also adds in
> the GICv5 PPI type to the intid.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Trivial comment below, but either way I'm fine with it. If you do
split the patch, than both can have tag, if not then this one can have it.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  arch/arm64/kvm/arch_timer.c     | 117 +++++++++++++++++++++++++-------
>  arch/arm64/kvm/vgic/vgic-init.c |   9 +++
>  arch/arm64/kvm/vgic/vgic-v5.c   |   8 +--
>  include/kvm/arm_arch_timer.h    |  11 ++-
>  include/kvm/arm_vgic.h          |   4 ++
>  5 files changed, 119 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 6f033f6644219..2f30d69dbf1ac 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c

> @@ -1601,12 +1665,11 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	if (!(irq_is_ppi(vcpu->kvm, irq)))
>  		return -EINVAL;
>  
> -	mutex_lock(&vcpu->kvm->arch.config_lock);
> +	guard(mutex)(&vcpu->kvm->arch.config_lock);

In ideal world, separate patch for guard() introduction, but if the maintainers
are happy I don't care that much!

>  
>  	if (test_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE,
>  		     &vcpu->kvm->arch.flags)) {
> -		ret = -EBUSY;
> -		goto out;
> +		return -EBUSY;
>  	}
>  
>  	switch (attr->attr) {
> @@ -1623,10 +1686,16 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		idx = TIMER_HPTIMER;
>  		break;
>  	default:
> -		ret = -ENXIO;
> -		goto out;
> +		return -ENXIO;
>  	}
>  
> +	/*
> +	 * The PPIs for the Arch Timers are architecturally defined for
> +	 * GICv5. Reject anything that changes them from the specified value.
> +	 */
> +	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] != irq)
> +		return -EINVAL;
> +
>  	/*
>  	 * We cannot validate the IRQ unicity before we run, so take it at
>  	 * face value. The verdict will be given on first vcpu run, for each
> @@ -1634,8 +1703,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	 */
>  	vcpu->kvm->arch.timer_data.ppi[idx] = irq;
>  
> -out:
> -	mutex_unlock(&vcpu->kvm->arch.config_lock);
>  	return ret;
>  }


