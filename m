Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90773372AB
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 13:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhCKMcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 07:32:41 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13594 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhCKMcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 07:32:20 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dx7ZX3jllz16Hkl;
        Thu, 11 Mar 2021 20:30:28 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 20:32:07 +0800
Subject: Re: [PATCH v3 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state
 to physical side
To:     Marc Zyngier <maz@kernel.org>
CC:     Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Lorenzo Pieralisi" <lorenzo.pieralisi@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-4-lushenming@huawei.com> <87tupif3x3.wl-maz@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <0820f429-4c29-acd6-d9e0-af9f6deb68e4@huawei.com>
Date:   Thu, 11 Mar 2021 20:32:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87tupif3x3.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/11 17:14, Marc Zyngier wrote:
> On Wed, 27 Jan 2021 12:13:36 +0000,
> Shenming Lu <lushenming@huawei.com> wrote:
>>
>> From: Zenghui Yu <yuzenghui@huawei.com>
>>
>> When setting the forwarding path of a VLPI (switch to the HW mode),
>> we could also transfer the pending state from irq->pending_latch to
>> VPT (especially in migration, the pending states of VLPIs are restored
>> into kvm’s vgic first). And we currently send "INT+VSYNC" to trigger
>> a VLPI to pending.
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index ac029ba3d337..a3542af6f04a 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -449,6 +449,20 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
>>  	irq->host_irq	= virq;
>>  	atomic_inc(&map.vpe->vlpi_count);
>>  
>> +	/* Transfer pending state */
>> +	if (irq->pending_latch) {
>> +		ret = irq_set_irqchip_state(irq->host_irq,
>> +					    IRQCHIP_STATE_PENDING,
>> +					    irq->pending_latch);
>> +		WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
>> +
>> +		/*
>> +		 * Let it be pruned from ap_list later and don't bother
>> +		 * the List Register.
>> +		 */
>> +		irq->pending_latch = false;
> 
> NAK. If the interrupt is on the AP list, it must be pruned from it
> *immediately*. The only case where it can be !pending and still on the
> AP list is in interval between sync and prune. If we start messing
> with this, we can't reason about the state of this list anymore.
> 
> Consider calling vgic_queue_irq_unlock() here.

Thanks for giving a hint, but it seems that vgic_queue_irq_unlock() only
queues an IRQ after checking, did you mean vgic_prune_ap_list() instead?

Thanks a lot for the comments! :-)
Shenming

> 
> Thanks,
> 
> 	M.
> 
