Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0628698E91
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 11:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbfHVJA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 05:00:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732842AbfHVJA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 05:00:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55D6E10F23E1;
        Thu, 22 Aug 2019 09:00:26 +0000 (UTC)
Received: from [10.36.116.105] (ovpn-116-105.ams2.redhat.com [10.36.116.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3830F5DC1E;
        Thu, 22 Aug 2019 09:00:23 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Allow more than 256 vcpus for
 KVM_IRQ_LINE
To:     Marc Zyngier <maz@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Cc:     qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20190818140710.23920-1-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e37a2b72-5027-b553-377c-8ec06a988fb6@redhat.com>
Date:   Thu, 22 Aug 2019 11:00:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190818140710.23920-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Thu, 22 Aug 2019 09:00:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 8/18/19 4:07 PM, Marc Zyngier wrote:
> While parts of the VGIC support a large number of vcpus (we
> bravely allow up to 512), other parts are more limited.
> 
> One of these limits is visible in the KVM_IRQ_LINE ioctl, which
> only allows 256 vcpus to be signalled when using the CPU or PPI
> types. Unfortunately, we've cornered ourselves badly by allocating
> all the bits in the irq field.
> 
> Since the irq_type subfield (8 bit wide) is currently only taking
> the values 0, 1 and 2 (and we have been careful not to allow anything
> else), let's reduce this field to only 4 bits, and allocate the
> remaining 4 bits to a vcpu2_index, which acts as a multiplier:
> 
>   vcpu_id = 256 * vcpu2_index + vcpu_index
> 
> With that, and a new capability (KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)
> allowing this to be discovered, it becomes possible to inject
> PPIs to up to 4096 vcpus. But please just don't.
> 
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/api.txt    | 8 ++++++--
>  arch/arm/include/uapi/asm/kvm.h   | 4 +++-
>  arch/arm64/include/uapi/asm/kvm.h | 4 +++-
>  include/uapi/linux/kvm.h          | 1 +
>  virt/kvm/arm/arm.c                | 2 ++
>  5 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 2d067767b617..85518bfb2a99 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -753,8 +753,8 @@ in-kernel irqchip (GIC), and for in-kernel irqchip can tell the GIC to
>  use PPIs designated for specific cpus.  The irq field is interpreted
>  like this:
>  
> -  bits:  | 31 ... 24 | 23  ... 16 | 15    ...    0 |
> -  field: | irq_type  | vcpu_index |     irq_id     |
> +  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
> +  field: | vcpu2_index | irq_type  | vcpu_index |  irq_id  |
>  
>  The irq_type field has the following values:
>  - irq_type[0]: out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
> @@ -766,6 +766,10 @@ The irq_type field has the following values:
>  
>  In both cases, level is used to assert/deassert the line.
>  
> +When KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 is supported, the target vcpu is
> +identified as (256 * vcpu2_index + vcpu_index). Otherwise, vcpu2_index
> +must be zero.
> +
>  struct kvm_irq_level {
>  	union {
>  		__u32 irq;     /* GSI */
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index a4217c1a5d01..2769360f195c 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -266,8 +266,10 @@ struct kvm_vcpu_events {
>  #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>  
>  /* KVM_IRQ_LINE irq field index values */
> +#define KVM_ARM_IRQ_VCPU2_SHIFT		28
> +#define KVM_ARM_IRQ_VCPU2_MASK		0xf
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> -#define KVM_ARM_IRQ_TYPE_MASK		0xff
> +#define KVM_ARM_IRQ_TYPE_MASK		0xf
>  #define KVM_ARM_IRQ_VCPU_SHIFT		16
>  #define KVM_ARM_IRQ_VCPU_MASK		0xff
>  #define KVM_ARM_IRQ_NUM_SHIFT		0
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9a507716ae2f..67c21f9bdbad 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -325,8 +325,10 @@ struct kvm_vcpu_events {
>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
>  
>  /* KVM_IRQ_LINE irq field index values */
> +#define KVM_ARM_IRQ_VCPU2_SHIFT		28
> +#define KVM_ARM_IRQ_VCPU2_MASK		0xf
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> -#define KVM_ARM_IRQ_TYPE_MASK		0xff
> +#define KVM_ARM_IRQ_TYPE_MASK		0xf
>  #define KVM_ARM_IRQ_VCPU_SHIFT		16
>  #define KVM_ARM_IRQ_VCPU_MASK		0xff
>  #define KVM_ARM_IRQ_NUM_SHIFT		0
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5e3f12d5359e..5414b6588fbb 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -996,6 +996,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
>  #define KVM_CAP_PMU_EVENT_FILTER 173
> +#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 35a069815baf..c1385911de69 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -182,6 +182,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	int r;
>  	switch (ext) {
>  	case KVM_CAP_IRQCHIP:
> +	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>  		r = vgic_present;
>  		break;
>  	case KVM_CAP_IOEVENTFD:
> @@ -888,6 +889,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>  
>  	irq_type = (irq >> KVM_ARM_IRQ_TYPE_SHIFT) & KVM_ARM_IRQ_TYPE_MASK;
>  	vcpu_idx = (irq >> KVM_ARM_IRQ_VCPU_SHIFT) & KVM_ARM_IRQ_VCPU_MASK;
> +	vcpu_idx += ((irq >> KVM_ARM_IRQ_VCPU2_SHIFT) & KVM_ARM_IRQ_VCPU2_MASK) * (KVM_ARM_IRQ_VCPU_MASK + 1);
>  	irq_num = (irq >> KVM_ARM_IRQ_NUM_SHIFT) & KVM_ARM_IRQ_NUM_MASK;
>  
>  	trace_kvm_irq_line(irq_type, vcpu_idx, irq_num, irq_level->level);
> 

Thank you for the patch!

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

