Return-Path: <kvm+bounces-67251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D01D8CFF691
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 19:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 221473067217
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 18:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07326169AD2;
	Wed,  7 Jan 2026 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="TxGob7h0"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59A2368285
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767804689; cv=none; b=PAKID/3qPMk3KCA3zzpvoKz485yM/TVfYzzRFGxtOgq+Qw9Kx/b5SImN0xWQ1qsADQRNRc1IgZLtdus8+A4h98G0x03JBnBuwhYplAKgnQPly55l3BIRXKa3L6MSOwmQ8n1BHPcllASrd6l1wv3lTX03tEVjL2Cd7E3WVcXxNlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767804689; c=relaxed/simple;
	bh=3ol7RsguyxLJHmLBaeFw1Ne81MaMqEY5wsLuayf73Fc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NVSJebjzKp9x/iIme+dLc6En9hbNs+6BWbxj4CQXeBZDquOWkfZViBsDFKdHlzUUL/PxWOHpIF056MWGJAddz+SLzXy2xk5glp9xfsfGGsaJoinnFNeHKOsgoCUx9oQSjzu4OMnmBzgJifprYvzaqCYrKssI2fmDrwQ2av6sHp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=TxGob7h0; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5C6jQWVfkjb28klDVK2/Iw/96XcNiZg8oDzeVlxXTuw=;
	b=TxGob7h0J7DyuITFxG5P7tY9Io8orxNuKiZH+YRkufrT4nWVdkiU2l7kV+5x5BPK/EV8L/l0x
	sMed21REJUZVbtC+308p685yXNK61w+Fhh68QkeVEwB8SZfQR0/dWk6l2eVj9pzVdvdkkDPs/1b
	h8k022PqXjg0agVhvTtpYfU=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dmYsG4dt4zN0f4;
	Thu,  8 Jan 2026 00:49:06 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmYvZ3nqtzHnGdR;
	Thu,  8 Jan 2026 00:51:06 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 06DAB40570;
	Thu,  8 Jan 2026 00:51:13 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:51:12 +0000
Date: Wed, 7 Jan 2026 16:51:10 +0000
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
Subject: Re: [PATCH v2 36/36] KVM: arm64: gic-v5: Communicate
 userspace-drivable PPIs via a UAPI
Message-ID: <20260107165110.0000638d@huawei.com>
In-Reply-To: <20251219155222.1383109-37-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-37-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:48 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> GICv5 systems will likely not support the full set of PPIs. The
> presence of any virtual PPI is tied to the presence of the physical
> PPI. Therefore, the available PPIs will be limited by the physical
> host. Userspace cannot drive any PPIs that are not implemented.
> 
> Moreover, it is not desirable to expose all PPIs to the guest in the
> first place, even if they are supported in hardware. Some devices,
> such as the arch timer, are implemented in KVM, and hence those PPIs
> shouldn't be driven by userspace, either.
> 
> Provided a new UAPI:
>   KVM_DEV_ARM_VGIC_GRP_CTRL => KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
> 
> This allows userspace to query which PPIs it is able to drive via
> KVM_IRQ_LINE.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

A couple of trivial comments on this patch.

Overall, to me as a definite non expert in kvm GIC emulation this
series looks to be in a pretty good state.

Thanks,

Jonathan
> ---
>  .../virt/kvm/devices/arm-vgic-v5.rst          | 13 ++++++++++
>  arch/arm64/include/uapi/asm/kvm.h             |  1 +
>  arch/arm64/kvm/vgic/vgic-kvm-device.c         | 25 +++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic-v5.c                 |  8 ++++++
>  include/kvm/arm_vgic.h                        |  5 ++++
>  include/linux/irqchip/arm-gic-v5.h            |  4 +++
>  tools/arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  7 files changed, 57 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> index 9904cb888277d..d9f2917b609c5 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> @@ -25,6 +25,19 @@ Groups:
>        request the initialization of the VGIC, no additional parameter in
>        kvm_device_attr.addr. Must be called after all VCPUs have been created.
>  
> +   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
> +      request the mask of userspace-drivable PPIs. Only a subset of the PPIs can
> +      be directly driven from userspace with GICv5, and the returned mask
> +      informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
> +
> +      Userspace must allocate and point to __u64[2] with of data in

with of?

> +      kvm_device_attr.addr. When this call returns, the provided memory will be
> +      populated with the userspace PPI mask. The lower __u64 contains the mask
> +      for the lower 64 PPIS, with the remaining 64 being in the second __u64.
> +
> +      This is a read-only attribute, and cannot be set. Attempts to set it are
> +      rejected.
> +
>    Errors:
>  
>      =======  ========================================================

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 78903182bba08..360c78ed4f104 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -719,6 +719,25 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops = {
>  	.has_attr = vgic_v3_has_attr,
>  };
>  
> +static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
> +				      struct kvm_device_attr *attr)
> +{
> +	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +	struct gicv5_vm *gicv5_vm = &dev->kvm->arch.vgic.gicv5_vm;
> +	int i, ret;
> +
> +	guard(mutex)(&dev->kvm->arch.config_lock);
> +
> +	for (i = 0; i < 2; ++i) {

Can drag declaration of i into loop init.
Also I just noticed the series is rather random wrt to pre or post increment
in cases where it doesn't matter. I'd go with post increment for for loops.
I took a quick look at a random file in this directory and that's what is used there.


> +		ret = put_user(gicv5_vm->userspace_ppis[i], uaddr);
> +		if (ret)
> +			return ret;
> +		uaddr++;
> +	}
> +
> +	return 0;
> +}

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index bf72982d6a2e8..04300926683b6 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -122,6 +122,14 @@ int vgic_v5_init(struct kvm *kvm)
>  		}
>  	}
>  
> +	/*
> +	 * We only allow userspace to drive the SW_PPI, if it is
> +	 * implemented.
> +	 */

	/* We only allow userspace to drive the SW_PPI, if it is implemented. */

Is under 80 chars (just) so go with that.


> +	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] = GICV5_SW_PPI & GICV5_HWIRQ_ID;
> +	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] &= ppi_caps->impl_ppi_mask[0];
> +	kvm->arch.vgic.gicv5_vm.userspace_ppis[1] = 0;
> +
>  	return 0;
>  }



