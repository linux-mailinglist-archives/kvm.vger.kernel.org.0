Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D057AA1C0
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjIUVFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjIUVE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:04:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47B7566D8
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:27:11 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RrqMV5BfPzrSwx;
        Thu, 21 Sep 2023 17:08:54 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 21 Sep 2023 17:11:01 +0800
Subject: Re: [PATCH v2 01/11] KVM: arm64: vgic: Make kvm_vgic_inject_irq()
 take a vcpu pointer
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <kvm@vger.kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
References: <20230920181731.2232453-1-maz@kernel.org>
 <20230920181731.2232453-2-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c511ff67-fd8c-6edd-8239-2bacc3ad16f6@huawei.com>
Date:   Thu, 21 Sep 2023 17:11:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20230920181731.2232453-2-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/21 2:17, Marc Zyngier wrote:
> Passing a vcpu_id to kvm_vgic_inject_irq() is silly for two reasons:
> 
> - we often confuse vcpu_id and vcpu_idx
> - we eventually have to convert it back to a vcpu
> - we can't count
> 
> Instead, pass a vcpu pointer, which is unambiguous. A NULL vcpu
> is also allowed for interrupts that are not private to a vcpu
> (such as SPIs).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c      |  2 +-
>  arch/arm64/kvm/arm.c             | 20 ++++++++++----------
>  arch/arm64/kvm/pmu-emul.c        |  2 +-
>  arch/arm64/kvm/vgic/vgic-irqfd.c |  2 +-
>  arch/arm64/kvm/vgic/vgic.c       | 12 +++++-------
>  include/kvm/arm_vgic.h           |  4 ++--
>  6 files changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 6dcdae4d38cb..1f828f3b854c 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -458,7 +458,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>  				   timer_ctx->irq.level);
>  
>  	if (!userspace_irqchip(vcpu->kvm)) {
> -		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> +		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu,
>  					  timer_irq(timer_ctx),
>  					  timer_ctx->irq.level,
>  					  timer_ctx);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4866b3f7b4ea..872679a0cbd7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1134,27 +1134,27 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>  			  bool line_status)
>  {
>  	u32 irq = irq_level->irq;
> -	unsigned int irq_type, vcpu_idx, irq_num;
> +	unsigned int irq_type, vcpu_id, irq_num;
>  	int nrcpus = atomic_read(&kvm->online_vcpus);
>  	struct kvm_vcpu *vcpu = NULL;
>  	bool level = irq_level->level;
>  
>  	irq_type = (irq >> KVM_ARM_IRQ_TYPE_SHIFT) & KVM_ARM_IRQ_TYPE_MASK;
> -	vcpu_idx = (irq >> KVM_ARM_IRQ_VCPU_SHIFT) & KVM_ARM_IRQ_VCPU_MASK;
> -	vcpu_idx += ((irq >> KVM_ARM_IRQ_VCPU2_SHIFT) & KVM_ARM_IRQ_VCPU2_MASK) * (KVM_ARM_IRQ_VCPU_MASK + 1);
> +	vcpu_id = (irq >> KVM_ARM_IRQ_VCPU_SHIFT) & KVM_ARM_IRQ_VCPU_MASK;
> +	vcpu_id += ((irq >> KVM_ARM_IRQ_VCPU2_SHIFT) & KVM_ARM_IRQ_VCPU2_MASK) * (KVM_ARM_IRQ_VCPU_MASK + 1);
>  	irq_num = (irq >> KVM_ARM_IRQ_NUM_SHIFT) & KVM_ARM_IRQ_NUM_MASK;
>  
> -	trace_kvm_irq_line(irq_type, vcpu_idx, irq_num, irq_level->level);
> +	trace_kvm_irq_line(irq_type, vcpu_id, irq_num, irq_level->level);
>  
>  	switch (irq_type) {
>  	case KVM_ARM_IRQ_TYPE_CPU:
>  		if (irqchip_in_kernel(kvm))
>  			return -ENXIO;
>  
> -		if (vcpu_idx >= nrcpus)
> +		if (vcpu_id >= nrcpus)
>  			return -EINVAL;

What we actually need to check is 'vcpu->vcpu_idx >= nrcpus' and this is
covered by the 'if (!vcpu)' statement below. Let's just drop this
_incorrect_ checking?

>  
> -		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
> +		vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
>  		if (!vcpu)
>  			return -EINVAL;
>  
> @@ -1166,17 +1166,17 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>  		if (!irqchip_in_kernel(kvm))
>  			return -ENXIO;
>  
> -		if (vcpu_idx >= nrcpus)
> +		if (vcpu_id >= nrcpus)
>  			return -EINVAL;

Same here.

Thanks,
Zenghui
