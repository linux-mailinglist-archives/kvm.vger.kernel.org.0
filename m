Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C326F160E2F
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 10:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgBQJMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 04:12:03 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:43474 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728681AbgBQJMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 04:12:03 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C17C2B5DC1BA1A12947B;
        Mon, 17 Feb 2020 17:11:55 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 17 Feb 2020
 17:11:48 +0800
Subject: Re: [PATCH v4 01/20] irqchip/gic-v4.1: Skip absent CPUs while
 iterating over redistributors
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
 <20200214145736.18550-2-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1f86bcdd-01ca-4925-3163-d47e17d006ab@huawei.com>
Date:   Mon, 17 Feb 2020 17:11:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200214145736.18550-2-maz@kernel.org>
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
> In a system that is only sparsly populated with CPUs, we can end-up with
> redistributors structures that are not initialized. Let's make sure we
> don't try and access those when iterating over them (in this case when
> checking we have a L2 VPE table).
> 
> Fixes: 4e6437f12d6e ("irqchip/gic-v4.1: Ensure L2 vPE table is allocated at RD level")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 83b1186ffcad..da883a691028 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -2452,6 +2452,10 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
>   	if (!gic_rdists->has_rvpeid)
>   		return true;
>   
> +	/* Skip non-present CPUs */
> +	if (!base)
> +		return true;
> +

Thanks for fixing this,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

>   	val  = gicr_read_vpropbaser(base + SZ_128K + GICR_VPROPBASER);
>   
>   	esz  = FIELD_GET(GICR_VPROPBASER_4_1_ENTRY_SIZE, val) + 1;
> 

