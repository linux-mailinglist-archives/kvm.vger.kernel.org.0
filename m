Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1B189464
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 04:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCRDUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 23:20:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47092 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgCRDUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 23:20:19 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1177339079FA78282461;
        Wed, 18 Mar 2020 11:20:10 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 18 Mar 2020
 11:19:59 +0800
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
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
 <20200304203330.4967-24-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <850438a7-2549-8b89-8d09-ee30198c4c6e@huawei.com>
Date:   Wed, 18 Mar 2020 11:19:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-24-maz@kernel.org>
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
> The vgic-state debugfs file could do with showing the pending state
> of the HW-backed SGIs. Plug it into the low-level code.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> ---
>   virt/kvm/arm/vgic/vgic-debug.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
> index cc12fe9b2df3..b13a9e3f99dd 100644
> --- a/virt/kvm/arm/vgic/vgic-debug.c
> +++ b/virt/kvm/arm/vgic/vgic-debug.c
> @@ -178,6 +178,8 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>   			    struct kvm_vcpu *vcpu)
>   {
>   	char *type;
> +	bool pending;
> +
>   	if (irq->intid < VGIC_NR_SGIS)
>   		type = "SGI";
>   	else if (irq->intid < VGIC_NR_PRIVATE_IRQS)
> @@ -190,6 +192,16 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>   	if (irq->intid ==0 || irq->intid == VGIC_NR_PRIVATE_IRQS)
>   		print_header(s, irq, vcpu);
>   
> +	pending = irq->pending_latch;
> +	if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> +		int err;
> +
> +		err = irq_get_irqchip_state(irq->host_irq,
> +					    IRQCHIP_STATE_PENDING,
> +					    &pending);
> +		WARN_ON_ONCE(err);
> +	}
> +
>   	seq_printf(s, "       %s %4d "
>   		      "    %2d "
>   		      "%d%d%d%d%d%d%d "
> @@ -201,7 +213,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
>   		      "\n",
>   			type, irq->intid,
>   			(irq->target_vcpu) ? irq->target_vcpu->vcpu_id : -1,
> -			irq->pending_latch,
> +			pending,
>   			irq->line_level,
>   			irq->active,
>   			irq->enabled,
> 

