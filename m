Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F3918C664
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 05:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgCTEX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 00:23:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12111 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbgCTEX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 00:23:29 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 36E0FF08001D6C88CCDA;
        Fri, 20 Mar 2020 12:23:27 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 12:23:19 +0800
Subject: Re: [PATCH v5 22/23] KVM: arm64: GICv4.1: Allow non-trapping WFI when
 using HW SGIs
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-23-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1eef38a1-4ee1-a88c-53bd-5994421a8186@huawei.com>
Date:   Fri, 20 Mar 2020 12:23:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-23-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/5 4:33, Marc Zyngier wrote:
> Just like for VLPIs, it is beneficial to avoid trapping on WFI when the
> vcpu is using the GICv4.1 SGIs.
> 
> Add such a check to vcpu_clear_wfx_traps().
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> ---
>   arch/arm64/include/asm/kvm_emulate.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f658dda12364..a30b4eec7cb4 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -89,7 +89,8 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>   static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
>   {
>   	vcpu->arch.hcr_el2 &= ~HCR_TWE;
> -	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count))
> +	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
> +	    vcpu->kvm->arch.vgic.nassgireq)
>   		vcpu->arch.hcr_el2 &= ~HCR_TWI;
>   	else
>   		vcpu->arch.hcr_el2 |= HCR_TWI;
> 

