Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776A833728B
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 13:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhCKM1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 07:27:22 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13593 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbhCKM0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 07:26:54 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dx7SB0fTgz17Jh9;
        Thu, 11 Mar 2021 20:24:58 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 20:26:38 +0800
Subject: Re: [PATCH v3 1/4] KVM: arm64: GICv4.1: Add function to get VLPI
 state
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
 <20210127121337.1092-2-lushenming@huawei.com> <87wnuef4oj.wl-maz@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <fc7dc4ec-e223-91ae-536f-1aa52c8a5739@huawei.com>
Date:   Thu, 11 Mar 2021 20:26:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87wnuef4oj.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/11 16:57, Marc Zyngier wrote:
> On Wed, 27 Jan 2021 12:13:34 +0000,
> Shenming Lu <lushenming@huawei.com> wrote:
>>
>> With GICv4.1 and the vPE unmapped, which indicates the invalidation
>> of any VPT caches associated with the vPE, we can get the VLPI state
>> by peeking at the VPT. So we add a function for this.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v4.c | 19 +++++++++++++++++++
>>  arch/arm64/kvm/vgic/vgic.h    |  1 +
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
>> index 66508b03094f..ac029ba3d337 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v4.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
>> @@ -203,6 +203,25 @@ void vgic_v4_configure_vsgis(struct kvm *kvm)
>>  	kvm_arm_resume_guest(kvm);
>>  }
>>  
>> +/*
>> + * Must be called with GICv4.1 and the vPE unmapped, which
>> + * indicates the invalidation of any VPT caches associated
>> + * with the vPE, thus we can get the VLPI state by peeking
>> + * at the VPT.
>> + */
>> +void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val)
>> +{
>> +	struct its_vpe *vpe = &irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>> +	int mask = BIT(irq->intid % BITS_PER_BYTE);
>> +	void *va;
>> +	u8 *ptr;
>> +
>> +	va = page_address(vpe->vpt_page);
>> +	ptr = va + irq->intid / BITS_PER_BYTE;
>> +
>> +	*val = !!(*ptr & mask);
> 
> What guarantees that you can actually read anything valid? Yes, the
> VPT caches are clean. But that doesn't make them coherent with CPU
> caches.
> 
> You need some level of cache maintenance here.

Yeah, and you have come up with some codes for this in v2:

diff --git a/drivers/irqchip/irq-gic-v3-its.c
b/drivers/irqchip/irq-gic-v3-its.c
index 7db602434ac5..2dbef127ca15 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4552,6 +4552,10 @@ static void its_vpe_irq_domain_deactivate(struct
irq_domain *domain,

  		its_send_vmapp(its, vpe, false);
  	}
+
+	if (find_4_1_its() && !atomic_read(vpe->vmapp_count))
+		gic_flush_dcache_to_poc(page_address(vpe->vpt_page),
+					LPI_PENDBASE_SZ);
  }

  static const struct irq_domain_ops its_vpe_domain_ops = {

Could I add it to this series? :-)

Thanks,
Shenming

> 
> Thanks,
> 
> 	M.
> 
