Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41A61655C0
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 04:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBTDhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 22:37:16 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45154 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727370AbgBTDhP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 22:37:15 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2580BC2684EA7326FDBC;
        Thu, 20 Feb 2020 11:37:08 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 11:37:01 +0800
Subject: Re: [PATCH v4 09/20] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI
 callbacks
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
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-10-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <38b42ac1-5a5d-2f10-2cba-b50f37c7a965@huawei.com>
Date:   Thu, 20 Feb 2020 11:37:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200214145736.18550-10-maz@kernel.org>
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

On 2020/2/14 22:57, Marc Zyngier wrote:
> As for VLPIs, there is a number of configuration bits that cannot

As for vSGIs,

> be directly communicated through the normal irqchip API, and we
> have to use our good old friend set_vcpu_affinity.
> 
> This is used to configure group and priority for a given vSGI.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 18 ++++++++++++++++++
>   include/linux/irqchip/arm-gic-v4.h |  5 +++++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index a9753435c4ff..a2e824eae43f 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3969,6 +3969,23 @@ static int its_sgi_get_irqchip_state(struct irq_data *d,
>   	return 0;
>   }
>   
> +static int its_sgi_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> +{
> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +	struct its_cmd_info *info = vcpu_info;
> +
> +	switch (info->cmd_type) {
> +	case PROP_UPDATE_SGI:
> +		vpe->sgi_config[d->hwirq].priority = info->priority;
> +		vpe->sgi_config[d->hwirq].group = info->group;
> +		its_configure_sgi(d, false);
> +		return 0;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>   static struct irq_chip its_sgi_irq_chip = {
>   	.name			= "GICv4.1-sgi",
>   	.irq_mask		= its_sgi_mask_irq,
> @@ -3976,6 +3993,7 @@ static struct irq_chip its_sgi_irq_chip = {
>   	.irq_set_affinity	= its_sgi_set_affinity,
>   	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
>   	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
> +	.irq_set_vcpu_affinity	= its_sgi_set_vcpu_affinity,
>   };
>   
>   static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index 30b4855bf766..a1a9d40266f5 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -98,6 +98,7 @@ enum its_vcpu_info_cmd_type {
>   	SCHEDULE_VPE,
>   	DESCHEDULE_VPE,
>   	INVALL_VPE,
> +	PROP_UPDATE_SGI,

Maybe better to use 'PROP_UPDATE_VSGI'?


Thanks,
Zenghui

>   };
>   
>   struct its_cmd_info {
> @@ -110,6 +111,10 @@ struct its_cmd_info {
>   			bool		g0en;
>   			bool		g1en;
>   		};
> +		struct {
> +			u8		priority;
> +			bool		group;
> +		};
>   	};
>   };
>   
> 

