Return-Path: <kvm+bounces-26915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B95F978EF2
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF1FC2882B1
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD0313A899;
	Sat, 14 Sep 2024 07:38:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58778135A63
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 07:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726299497; cv=none; b=lsU+U6Age+TKmSaNiW17JbSHwI0adMdWuaDLhjVFHuXEgdOhOjsyLALahgxx0sbi+rXfOfTM/A+1YiDJwNLwF08JDGq9YKHqC1Hd2XRogJCwB/95PYPSbxk3qwYdWt+aplzE07e0iVwU1b8koVoMjtna1ITVfZalXT9WopZAvOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726299497; c=relaxed/simple;
	bh=EeGjcnpLPT9UjxYEEgKyjWE2B0WYuC5YVjY/uEI7k0s=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=iSj7FfaleNCn1eZiV/jeY3y/1Rn7NU93WUMqrWMGLuv3XYiKgK0QA6yaEZeTQWX9zmrBn69rUGun2asKdjCkeEDLD67G0HjgZVsdERpXF46743UfKn6Ugcq2Pk2KqHhDHmqXihywDkcHN2r2MDZbFTZ7rKYFuARmmgIZ+MY0+kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bxb+tkPeVmF88HAA--.18237S3;
	Sat, 14 Sep 2024 15:38:12 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxn+RhPeVmOKcGAA--.38233S3;
	Sat, 14 Sep 2024 15:38:11 +0800 (CST)
Subject: Re: [RFC PATCH V2 5/5] hw/loongarch: Add KVM pch msi device support
To: Xianglai Li <lixianglai@loongson.cn>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 kvm@vger.kernel.org
References: <cover.1725969898.git.lixianglai@loongson.cn>
 <8c81313bd4a5c53db5c889f19c9415994a9e007d.1725969898.git.lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <3dda64e5-9fa4-82e6-48c7-0897ce4478a0@loongson.cn>
Date: Sat, 14 Sep 2024 15:38:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <8c81313bd4a5c53db5c889f19c9415994a9e007d.1725969898.git.lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxn+RhPeVmOKcGAA--.38233S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3XFWUAFW5Cr1fuFy5XF1DurX_yoW7Ar13pF
	W3ur1Skr4rJrWxWan3K3yUury5Xan7WryIvF12kryxCr1DZr93WF1vyrsFgFyjk348Gryq
	vFyruFs2ga1DC3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxUGYDU
	UUU

Hi Xianglai,

I do not find any usage about function kvm_irqchip_commit_routes() in 
your patch-set, do I miss something?

Regards
Bibo Mao

On 2024/9/10 下午8:18, Xianglai Li wrote:
> Added pch_msi interrupt controller handling
> during kernel emulation of irq chip.
> 
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Song Gao <gaosong@loongson.cn>
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Xianglai Li <lixianglai@loongson.cn>
> 
>   hw/intc/loongarch_pch_msi.c | 42 +++++++++++++++++++++++++++----------
>   hw/loongarch/virt.c         | 26 +++++++++++++----------
>   target/loongarch/kvm/kvm.c  |  1 -
>   3 files changed, 46 insertions(+), 23 deletions(-)
> 
> diff --git a/hw/intc/loongarch_pch_msi.c b/hw/intc/loongarch_pch_msi.c
> index ecf3ed0267..bab6f852f8 100644
> --- a/hw/intc/loongarch_pch_msi.c
> +++ b/hw/intc/loongarch_pch_msi.c
> @@ -2,7 +2,7 @@
>   /*
>    * QEMU Loongson 7A1000 msi interrupt controller.
>    *
> - * Copyright (C) 2021 Loongson Technology Corporation Limited
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
>    */
>   
>   #include "qemu/osdep.h"
> @@ -14,6 +14,8 @@
>   #include "hw/misc/unimp.h"
>   #include "migration/vmstate.h"
>   #include "trace.h"
> +#include "sysemu/kvm.h"
> +#include "hw/loongarch/virt.h"
>   
>   static uint64_t loongarch_msi_mem_read(void *opaque, hwaddr addr, unsigned size)
>   {
> @@ -26,14 +28,24 @@ static void loongarch_msi_mem_write(void *opaque, hwaddr addr,
>       LoongArchPCHMSI *s = (LoongArchPCHMSI *)opaque;
>       int irq_num;
>   
> -    /*
> -     * vector number is irq number from upper extioi intc
> -     * need subtract irq base to get msi vector offset
> -     */
> -    irq_num = (val & 0xff) - s->irq_base;
> -    trace_loongarch_msi_set_irq(irq_num);
> -    assert(irq_num < s->irq_num);
> -    qemu_set_irq(s->pch_msi_irq[irq_num], 1);
> +    MSIMessage msg = {
> +        .address = addr,
> +        .data = val,
> +    };
> +
> +    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
> +        kvm_irqchip_send_msi(kvm_state, msg);
> +    } else {
> +        /*
> +         * vector number is irq number from upper extioi intc
> +         * need subtract irq base to get msi vector offset
> +         */
> +        irq_num = (val & 0xff) - s->irq_base;
> +        trace_loongarch_msi_set_irq(irq_num);
> +        assert(irq_num < s->irq_num);
> +
> +        qemu_set_irq(s->pch_msi_irq[irq_num], 1);
> +    }
>   }
>   
>   static const MemoryRegionOps loongarch_pch_msi_ops = {
> @@ -45,8 +57,16 @@ static const MemoryRegionOps loongarch_pch_msi_ops = {
>   static void pch_msi_irq_handler(void *opaque, int irq, int level)
>   {
>       LoongArchPCHMSI *s = LOONGARCH_PCH_MSI(opaque);
> -
> -    qemu_set_irq(s->pch_msi_irq[irq], level);
> +    MSIMessage msg = {
> +        .address = 0,
> +        .data = irq,
> +    };
> +
> +    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
> +        kvm_irqchip_send_msi(kvm_state, msg);
> +    } else {
> +        qemu_set_irq(s->pch_msi_irq[irq], level);
> +    }
>   }
>   
>   static void loongarch_pch_msi_realize(DeviceState *dev, Error **errp)
> diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
> index db0c08899b..b42cf7e5af 100644
> --- a/hw/loongarch/virt.c
> +++ b/hw/loongarch/virt.c
> @@ -887,24 +887,28 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
>           for (i = 0; i < num; i++) {
>               qdev_connect_gpio_out(DEVICE(d), i, qdev_get_gpio_in(extioi, i));
>           }
> +    }
>   
> -        /* Add PCH PIC node */
> -        fdt_add_pch_pic_node(lvms, &eiointc_phandle, &pch_pic_phandle);
> +    /* Add PCH PIC node */
> +    fdt_add_pch_pic_node(lvms, &eiointc_phandle, &pch_pic_phandle);
>   
> -        pch_msi = qdev_new(TYPE_LOONGARCH_PCH_MSI);
> -        start   =  num;
> -        num = EXTIOI_IRQS - start;
> -        qdev_prop_set_uint32(pch_msi, "msi_irq_base", start);
> -        qdev_prop_set_uint32(pch_msi, "msi_irq_num", num);
> -        d = SYS_BUS_DEVICE(pch_msi);
> -        sysbus_realize_and_unref(d, &error_fatal);
> -        sysbus_mmio_map(d, 0, VIRT_PCH_MSI_ADDR_LOW);
> +    pch_msi = qdev_new(TYPE_LOONGARCH_PCH_MSI);
> +    num = VIRT_PCH_PIC_IRQ_NUM;
> +    start   =  num;
> +    num = EXTIOI_IRQS - start;
> +    qdev_prop_set_uint32(pch_msi, "msi_irq_base", start);
> +    qdev_prop_set_uint32(pch_msi, "msi_irq_num", num);
> +    d = SYS_BUS_DEVICE(pch_msi);
> +    sysbus_realize_and_unref(d, &error_fatal);
> +
> +    if (!(kvm_enabled() && kvm_irqchip_in_kernel())) {
> +        /* Connect pch_msi irqs to extioi */
>           for (i = 0; i < num; i++) {
> -            /* Connect pch_msi irqs to extioi */
>               qdev_connect_gpio_out(DEVICE(d), i,
>                                     qdev_get_gpio_in(extioi, i + start));
>           }
>       }
> +    sysbus_mmio_map(d, 0, VIRT_PCH_MSI_ADDR_LOW);
>   
>       /* Add PCH MSI node */
>       fdt_add_pch_msi_node(lvms, &eiointc_phandle, &pch_msi_phandle);
> diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
> index c07dcfd85f..e1be6a6959 100644
> --- a/target/loongarch/kvm/kvm.c
> +++ b/target/loongarch/kvm/kvm.c
> @@ -719,7 +719,6 @@ int kvm_arch_get_default_type(MachineState *ms)
>   
>   int kvm_arch_init(MachineState *ms, KVMState *s)
>   {
> -    s->kernel_irqchip_allowed = false;
>       cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
>       return 0;
>   }
> 


