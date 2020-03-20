Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FDF18C547
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 03:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCTCbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 22:31:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12166 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbgCTCbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 22:31:34 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2AC509635A3A5CBCEBBC;
        Fri, 20 Mar 2020 10:31:31 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Mar 2020
 10:31:22 +0800
Subject: Re: [PATCH v5 16/23] irqchip/gic-v4.1: Eagerly vmap vPEs
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "Robert Richter" <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Eric Auger" <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-17-maz@kernel.org>
 <2817cb89-4cc2-549f-6e40-91d941aa8a5f@huawei.com>
 <d45e7ddfd51d4d8229e02efc42c8da04@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <2f667113-8241-dce6-0a5e-3acb5ef9cf7f@huawei.com>
Date:   Fri, 20 Mar 2020 10:31:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <d45e7ddfd51d4d8229e02efc42c8da04@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/3/19 18:55, Marc Zyngier wrote:
> On 2020-03-17 02:49, Zenghui Yu wrote:
>> Hi Marc,
>>
>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>> Now that we have HW-accelerated SGIs being delivered to VPEs, it
>>> becomes required to map the VPEs on all ITSs instead of relying
>>> on the lazy approach that we would use when using the ITS-list
>>> mechanism.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>
>> Before GICv4.1, we use vlpi_count to evaluate whether the vPE has been
>> mapped on the specified ITS, and use this refcount to only issue VMOVP
>> to those involved ITSes. It's broken after this patch.
>>
>> We may need to re-evaluate "whether the vPE is mapped" now that we're at
>> GICv4.1, otherwise *no* VMOVP will be issued on the v4.1 capable machine
>> (I mean those without single VMOVP support).
>>
>> What I'm saying is something like below (only an idea, it even can't
>> compile), any thoughts?
>>
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index 2e12bc52e3a2..3450b5e847ca 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -198,7 +198,8 @@ static u16 get_its_list(struct its_vm *vm)
>>          if (!is_v4(its))
>>              continue;
>>
>> -        if (vm->vlpi_count[its->list_nr])
>> +        if (vm->vlpi_count[its->list_nr] ||
>> +            gic_requires_eager_mapping())
>>              __set_bit(its->list_nr, &its_list);
>>      }
>>
>> @@ -1295,7 +1296,8 @@ static void its_send_vmovp(struct its_vpe *vpe)
>>          if (!is_v4(its))
>>              continue;
>>
>> -        if (!vpe->its_vm->vlpi_count[its->list_nr])
>> +        if (!vpe->its_vm->vlpi_count[its->list_nr] &&
>> +            !gic_requires_eager_mapping())
>>              continue;
>>
>>          desc.its_vmovp_cmd.col = &its->collections[col_id];
> 
> It took me a while to wrap my head around that one, but you're as usual 
> spot on.
> 
> The use of gic_requires_eager_mapping() is a bit confusing here, as it 
> isn't
> so much that the VPE is eagerly mapped, but the predicate on which we 
> evaluate
> the need for a VMOVP. How about this:
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
> b/drivers/irqchip/irq-gic-v3-its.c
> index cd6451e190c9..348f7a909a69 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -189,6 +189,15 @@ static DEFINE_IDA(its_vpeid_ida);
>   #define gic_data_rdist_rd_base()    (gic_data_rdist()->rd_base)
>   #define gic_data_rdist_vlpi_base()    (gic_data_rdist_rd_base() + 
> SZ_128K)
> 
> +/*
> + * Skip ITSs that have no vLPIs mapped, unless we're on GICv4.1, as we
> + * always have vSGIs mapped.
> + */
> +static bool require_its_list_vmovp(struct its_vm *vm, struct its_node 
> *its)
> +{
> +    return (gic_rdists->has_rvpeid || vm->vlpi_count[its->list_nr]);
> +}
> +
>   static u16 get_its_list(struct its_vm *vm)
>   {
>       struct its_node *its;
> @@ -198,7 +207,7 @@ static u16 get_its_list(struct its_vm *vm)
>           if (!is_v4(its))
>               continue;
> 
> -        if (vm->vlpi_count[its->list_nr])
> +        if (require_its_list_vmovp(vm, its))
>               __set_bit(its->list_nr, &its_list);
>       }
> 
> @@ -1295,7 +1304,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
>           if (!is_v4(its))
>               continue;
> 
> -        if (!vpe->its_vm->vlpi_count[its->list_nr])
> +        if (!require_its_list_vmovp(vpe->its_vm, its))
>               continue;
> 
>           desc.its_vmovp_cmd.col = &its->collections[col_id];

Indeed this looks much clearer. We're actually evaluating the need
for issuing VMOVP to a specified ITS, on system using its_list_map
feature (though we evaluate it by checking whether the vPE is mapped
on this ITS).


Thanks,
Zenghui

