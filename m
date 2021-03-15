Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5298B33B31A
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 13:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhCOM4X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 15 Mar 2021 08:56:23 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2698 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCOMzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 08:55:52 -0400
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Dzbpk4qbmz67yxm;
        Mon, 15 Mar 2021 20:49:34 +0800 (CST)
Received: from lhreml721-chm.china.huawei.com (10.201.108.72) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 13:55:43 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml721-chm.china.huawei.com (10.201.108.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 12:55:43 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.013; Mon, 15 Mar 2021 12:55:43 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Howard Zhang <Howard.Zhang@arm.com>,
        Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 7/8] KVM: arm64: Workaround firmware wrongly advertising
 GICv2-on-v3 compatibility
Thread-Topic: [PATCH 7/8] KVM: arm64: Workaround firmware wrongly advertising
 GICv2-on-v3 compatibility
Thread-Index: AQHXEfDNrYnyjo3A40aH4g7YcYymu6qFD7Yw
Date:   Mon, 15 Mar 2021 12:55:42 +0000
Message-ID: <d38d4dc684f94221bdf5ca35b8f66cfc@huawei.com>
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
 <20210305185254.3730990-8-maz@kernel.org>
In-Reply-To: <20210305185254.3730990-8-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.84.80]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 05 March 2021 18:53
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>; Andre Przywara
> <andre.przywara@arm.com>; Andrew Scull <ascull@google.com>; Catalin
> Marinas <catalin.marinas@arm.com>; Christoffer Dall
> <christoffer.dall@arm.com>; Howard Zhang <Howard.Zhang@arm.com>; Jia
> He <justin.he@arm.com>; Mark Rutland <mark.rutland@arm.com>; Quentin
> Perret <qperret@google.com>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Suzuki K Poulose
> <suzuki.poulose@arm.com>; Will Deacon <will@kernel.org>; James Morse
> <james.morse@arm.com>; Julien Thierry <julien.thierry.kdev@gmail.com>;
> kernel-team@android.com; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
> Subject: [PATCH 7/8] KVM: arm64: Workaround firmware wrongly advertising
> GICv2-on-v3 compatibility
> 
> It looks like we have broken firmware out there that wrongly advertises
> a GICv2 compatibility interface, despite the CPUs not being able to deal
> with it.
> 
> To work around this, check that the CPU initialising KVM is actually able
> to switch to MMIO instead of system registers, and use that as a
> precondition to enable GICv2 compatibility in KVM.
> 
> Note that the detection happens on a single CPU. If the firmware is
> lying *and* that the CPUs are asymetric, all hope is lost anyway.
> 
> Reported-by: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Is it possible to add stable tag for this? Looks like we do have systems out there
and reports issues.

Thanks,
Shameer

> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 35 +++++++++++++++++++++++++++++++--
>  arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++--
>  2 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 005daa0c9dd7..ee3682b9873c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -408,11 +408,42 @@ void __vgic_v3_init_lrs(void)
>  /*
>   * Return the GIC CPU configuration:
>   * - [31:0]  ICH_VTR_EL2
> - * - [63:32] RES0
> + * - [62:32] RES0
> + * - [63]    MMIO (GICv2) capable
>   */
>  u64 __vgic_v3_get_gic_config(void)
>  {
> -	return read_gicreg(ICH_VTR_EL2);
> +	u64 val, sre = read_gicreg(ICC_SRE_EL1);
> +	unsigned long flags = 0;
> +
> +	/*
> +	 * To check whether we have a MMIO-based (GICv2 compatible)
> +	 * CPU interface, we need to disable the system register
> +	 * view. To do that safely, we have to prevent any interrupt
> +	 * from firing (which would be deadly).
> +	 *
> +	 * Note that this only makes sense on VHE, as interrupts are
> +	 * already masked for nVHE as part of the exception entry to
> +	 * EL2.
> +	 */
> +	if (has_vhe())
> +		flags = local_daif_save();
> +
> +	write_gicreg(0, ICC_SRE_EL1);
> +	isb();
> +
> +	val = read_gicreg(ICC_SRE_EL1);
> +
> +	write_gicreg(sre, ICC_SRE_EL1);
> +	isb();
> +
> +	if (has_vhe())
> +		local_daif_restore(flags);
> +
> +	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
> +	val |= read_gicreg(ICH_VTR_EL2);
> +
> +	return val;
>  }
> 
>  u64 __vgic_v3_read_vmcr(void)
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index c3e6c3fd333b..6f530925a231 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -575,8 +575,10 @@ early_param("kvm-arm.vgic_v4_enable",
> early_gicv4_enable);
>  int vgic_v3_probe(const struct gic_kvm_info *info)
>  {
>  	u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
> +	bool has_v2;
>  	int ret;
> 
> +	has_v2 = ich_vtr_el2 >> 63;
>  	ich_vtr_el2 = (u32)ich_vtr_el2;
> 
>  	/*
> @@ -596,13 +598,15 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  			 gicv4_enable ? "en" : "dis");
>  	}
> 
> +	kvm_vgic_global_state.vcpu_base = 0;
> +
>  	if (!info->vcpu.start) {
>  		kvm_info("GICv3: no GICV resource entry\n");
> -		kvm_vgic_global_state.vcpu_base = 0;
> +	} else if (!has_v2) {
> +		pr_warn(FW_BUG "CPU interface incapable of MMIO access\n");
>  	} else if (!PAGE_ALIGNED(info->vcpu.start)) {
>  		pr_warn("GICV physical address 0x%llx not page aligned\n",
>  			(unsigned long long)info->vcpu.start);
> -		kvm_vgic_global_state.vcpu_base = 0;
>  	} else {
>  		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
>  		kvm_vgic_global_state.can_emulate_gicv2 = true;
> --
> 2.29.2

