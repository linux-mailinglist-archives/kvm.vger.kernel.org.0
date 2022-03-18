Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF5D4DD4A0
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 07:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiCRGP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 02:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiCRGPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 02:15:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1E5206EEA
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 23:14:36 -0700 (PDT)
Received: from kwepemi100011.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KKYZl5mBZzCqsl;
        Fri, 18 Mar 2022 14:12:31 +0800 (CST)
Received: from kwepemm600020.china.huawei.com (7.193.23.147) by
 kwepemi100011.china.huawei.com (7.221.188.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 14:14:29 +0800
Received: from [10.174.187.192] (10.174.187.192) by
 kwepemm600020.china.huawei.com (7.193.23.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 14:14:28 +0800
Subject: Re: Report an error on GICv4.1 vcpu de-schedule
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        <Martin.Weidmann@arm.com>, <tangnianyao@huawei.com>,
        <chengjian8@huawei.com>
References: <4aae10ba-b39a-5f84-754b-69c2eb0a2c03@huawei.com>
 <87v8wcyjbn.wl-maz@kernel.org>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <24ea78d1-4ea1-ef88-e74c-6fe64a476d87@huawei.com>
Date:   Fri, 18 Mar 2022 14:14:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87v8wcyjbn.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.192]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600020.china.huawei.com (7.193.23.147)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/17/2022 6:17 PM, Marc Zyngier wrote:
> Hi Jingyi,
> 
> On Thu, 17 Mar 2022 07:27:45 +0000,
> Jingyi Wang <wangjingyi11@huawei.com> wrote:
>>
>> Hi Marc，
>>
>> The patch "KVM: arm64: Delay the polling of the GICR_VPENDBASER.Dirty
>> bit"(57e3cebd022fbc035dcf190ac789fd2ffc747f5b) remove the polling of
>> GICR_VPENDBASER.Dirty bit in vcpu_load() , while check the VPT parsing
>> ready in kvm_vgic_flush_hwstate() for better performance.
>>
>> Most time it works, but we have met an error on our hardware recently.
>> In preemptable kernel, the vcpu can be preempted between vcpu_load and
>> kvm_vgic_flush_hwstate. As a result, it get de-scheduled and
>> its_clear_vpend_valid() is called
>>
>> 	val = gicr_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
>> 	val &= ~GICR_VPENDBASER_Valid;
>> 	val &= ~clr;
>> 	val |= set;
>> 	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
>>
>>
>> The function clears Valid bit meanwhile GICR_VPENDBASER_Dirty
>> maybe still 1, which cause the subsequent GICR_VPENDBASER_Dirty polling
>> fail and report ""ITS virtual pending table not cleaning".
>>
>> We have communicated with Martin from ARM and get the conclusion
>> that we should not change valid bit while the dirty bit not clear——
>> "The dirty bit reports whether the last schedule /de-schedule
>> operation has completed.The restriction on not changing Valid when Dirty
>> is 1, is so that hardware can always complete the last operation for
>> starting the next".
> 
> Indeed, the spec is crystal clear about that, and clearing Valid while
> Dirty is set is plain wrong.
> 
>>
>> I think maybe we can check dirty bit clear before clearing the valid bit
>> in its_clear_vpend_valid() code. Hope to know your opinion about this
>> issue.
> 
> Yes, that's what should happen. I came up with the patch below. Please
> give it a shot and let me know if that helps. If it does, I'll queue
> it as a fix.
> 
> Thanks,
> 
> 	M.
> 

Thanks, we will test that soon.

>>From c23ccc9cfa603e30ac189d43af75f03b60d780bc Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Thu, 17 Mar 2022 09:49:02 +0000
> Subject: [PATCH] irqchip/gic-v4: Wait for GICR_VPENDBASER.Dirty to clear
>   before descheduling
> 
> The way KVM drives GICv4.{0,1} is as follows:
> - vcpu_load() makes the VPE resident, instructing the RD to start
>    scanning for interrupts
> - just before entering the guest, we check that the RD has finished
>    scanning and that we can start running the vcpu
> - on preemption, we deschedule the VPE by making it invalid on
>    the RD
> 
> However, we are preemptible between the first two steps. If it so
> happens *and* that the RD was still scanning, we nonetheless write
> to the GICR_VPENDBASER register while Dirty is set, and bad things
> happen (we're in UNPRED land).
> 
> This affects both the 4.0 and 4.1 implementations.
> 
> Make sure Dirty is cleared before performing the deschedule,
> meaning that its_clear_vpend_valid() becomes a sort of full VPE
> residency barrier.
> 
> Reported-by: Jingyi Wang <wangjingyi11@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: 57e3cebd022f ("KVM: arm64: Delay the polling of the GICR_VPENDBASER.Dirty
> bit")
> Link: https://lore.kernel.org/r/4aae10ba-b39a-5f84-754b-69c2eb0a2c03@huawei.com
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 28 +++++++++++++++++++---------
>   1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 9e93ff2b6375..c9b1df980899 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3011,18 +3011,12 @@ static int __init allocate_lpi_tables(void)
>   	return 0;
>   }
>   
> -static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
> +static u64 read_vpend_dirty_clear(void __iomem *vlpi_base)
>   {
>   	u32 count = 1000000;	/* 1s! */
>   	bool clean;
>   	u64 val;
>   
> -	val = gicr_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
> -	val &= ~GICR_VPENDBASER_Valid;
> -	val &= ~clr;
> -	val |= set;
> -	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
> -
>   	do {
>   		val = gicr_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
>   		clean = !(val & GICR_VPENDBASER_Dirty);
> @@ -3033,10 +3027,26 @@ static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
>   		}
>   	} while (!clean && count);
>   
> -	if (unlikely(val & GICR_VPENDBASER_Dirty)) {
> +	if (unlikely(!clean))
>   		pr_err_ratelimited("ITS virtual pending table not cleaning\n");
> +
> +	return val;
> +}
> +
> +static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
> +{
> +	u64 val;
> +
> +	/* Make sure we wait until the RD is done with the initial scan */
> +	val = read_vpend_dirty_clear(vlpi_base);
> +	val &= ~GICR_VPENDBASER_Valid;
> +	val &= ~clr;
> +	val |= set;
> +	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
> +
> +	val = read_vpend_dirty_clear(vlpi_base);
> +	if (unlikely(val & GICR_VPENDBASER_Dirty))
>   		val |= GICR_VPENDBASER_PendingLast;
> -	}
>   
>   	return val;
>   }
> 
