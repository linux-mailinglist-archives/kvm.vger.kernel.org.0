Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D98F347CF8
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 16:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236701AbhCXPsN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 24 Mar 2021 11:48:13 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2738 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbhCXPrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 11:47:41 -0400
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4F5CDX6fSSz683Wv;
        Wed, 24 Mar 2021 23:42:52 +0800 (CST)
Received: from lhreml720-chm.china.huawei.com (10.201.108.71) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 24 Mar 2021 16:47:37 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml720-chm.china.huawei.com (10.201.108.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 15:47:37 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.013; Wed, 24 Mar 2021 15:47:37 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Marc Zyngier <maz@kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: RE: [PATCH] KVM: arm64: Fix CPU interface MMIO compatibility
 detection
Thread-Topic: [PATCH] KVM: arm64: Fix CPU interface MMIO compatibility
 detection
Thread-Index: AQHXIADnSRTuVbDHwkyLZJ68PSrFKqqTR4Mw
Date:   Wed, 24 Mar 2021 15:47:37 +0000
Message-ID: <e7cb67d609924108ae944935f8493745@huawei.com>
References: <20210323162301.2049595-1-maz@kernel.org>
In-Reply-To: <20210323162301.2049595-1-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.93.221]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 23 March 2021 16:23
> To: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org
> Cc: Ard Biesheuvel <ardb@kernel.org>; kernel-team@android.com; Shameerali
> Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Subject: [PATCH] KVM: arm64: Fix CPU interface MMIO compatibility detection
> 
> In order to detect whether a GICv3 CPU interface is MMIO capable,
> we switch ICC_SRE_EL1.SRE to 0 and check whether it sticks.
> 
> However, this is only possible if *ALL* of the HCR_EL2 interrupt
> overrides are set, and the CPU is perfectly allowed to ignore
> the write to ICC_SRE_EL1 otherwise. This leads KVM to pretend
> that a whole bunch of ARMv8.0 CPUs aren't MMIO-capable, and
> breaks VMs that should work correctly otherwise.
> 
> Fix this by setting IMO/FMO/IMO before touching ICC_SRE_EL1,
> and clear them afterwards. This allows us to reliably detect
> the CPU interface capabilities.
> 

Tested on HiSilicon D06 platform where the original issue(firmware wrongly
advertising GICv2-on-v3 compatibility) was reported and all seems to be fine.

Though not sure whether this fix is relevant to this particular platform,
FWIW,

  Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Fixes: 9739f6ef053f ("KVM: arm64: Workaround firmware wrongly advertising
> GICv2-on-v3 compatibility")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index ee3682b9873c..39f8f7f9227c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -429,6 +429,13 @@ u64 __vgic_v3_get_gic_config(void)
>  	if (has_vhe())
>  		flags = local_daif_save();
> 
> +	/*
> +	 * Table 11-2 "Permitted ICC_SRE_ELx.SRE settings" indicates
> +	 * that to be able to set ICC_SRE_EL1.SRE to 0, all the
> +	 * interrupt overrides must be set. You've got to love this.
> +	 */
> +	sysreg_clear_set(hcr_el2, 0, HCR_AMO | HCR_FMO | HCR_IMO);
> +	isb();
>  	write_gicreg(0, ICC_SRE_EL1);
>  	isb();
> 
> @@ -436,6 +443,8 @@ u64 __vgic_v3_get_gic_config(void)
> 
>  	write_gicreg(sre, ICC_SRE_EL1);
>  	isb();
> +	sysreg_clear_set(hcr_el2, HCR_AMO | HCR_FMO | HCR_IMO, 0);
> +	isb();
> 
>  	if (has_vhe())
>  		local_daif_restore(flags);
> --
> 2.30.0

