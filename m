Return-Path: <kvm+bounces-26792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9DA977C17
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18E401F28C49
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 09:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDC51D6DA7;
	Fri, 13 Sep 2024 09:20:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A4C0175D45
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 09:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726219226; cv=none; b=E81pYSKGGK5bEiKckCfqzaodjBx0Aq4WWjzu/mOUqJNkgbaTQLAYqmDK0uusnf6QsDSbFSNQVKDFN+nHqnz+fL9eAGWrpXL5SLD5e0ibDzdZ06mbBTq9NVu0vcu3I4Skh2I0pef80DtkSl798a/B+5zEF6AQslPCfxjMq9CNb98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726219226; c=relaxed/simple;
	bh=zmWPNb0zLRwifSl8fo+Pmp2E+9Xg4kr/XkokhEtNbS8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XffH76uxyjIfBpzFPXqlcfO61u5tF3AeTbByd5cqcLCR2W6du4NcqGhZv6nDmqcOWtVicUKxXupyfP+bqlWlDEJwW+e8a9zxTqb9BSYbPM46YlOZpkUpK5uJ6XwxCO2vI33sFjKF0xu9ra07PC9d3pv1k9HLuSwk1LPxdMqn5Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bxb+vOA+RmqcgGAA--.15977S3;
	Fri, 13 Sep 2024 17:20:14 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxLeTLA+RmG60FAA--.32697S3;
	Fri, 13 Sep 2024 17:20:12 +0800 (CST)
Subject: Re: [RFC PATCH V2 4/5] hw/loongarch: Add KVM pch pic device support
To: Xianglai Li <lixianglai@loongson.cn>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 kvm@vger.kernel.org
References: <cover.1725969898.git.lixianglai@loongson.cn>
 <86f29d4f56b12f826e8a5817cdb1efbfb6007a08.1725969898.git.lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <267f54d5-8660-b3b3-7cc3-bb851a5bfbae@loongson.cn>
Date: Fri, 13 Sep 2024 17:20:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <86f29d4f56b12f826e8a5817cdb1efbfb6007a08.1725969898.git.lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxLeTLA+RmG60FAA--.32697S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3try3uF4xtF4xtF47WF47KFX_yoW8WFW5to
	WftF1SvF4xGr1fArWFkrn8tFW7CrWIkFZ8Aa9Fva15CF4Utry5KF9xKw1FyrW7Jws5Krn3
	Aa4SgFs0yasFyrs7l-sFpf9Il3svdjkaLaAFLSUrUUUU8b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUO07kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
	xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcpBTUU
	UUU



On 2024/9/10 下午8:18, Xianglai Li wrote:
> Added pch_pic interrupt controller for kvm emulation.
> The main process is to send the command word for
> creating an pch_pic device to the kernel,
> Delivers the pch pic interrupt controller configuration
> register base address to the kernel.
> When the VM is saved, the ioctl obtains the pch_pic
> interrupt controller data in the kernel and saves it.
> When the VM is recovered, the saved data is sent to the kernel.
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
>   hw/intc/Kconfig                 |   3 +
>   hw/intc/loongarch_pch_pic.c     |  40 ++++---
>   hw/intc/loongarch_pch_pic_kvm.c | 180 ++++++++++++++++++++++++++++++++
>   hw/intc/meson.build             |   1 +
>   hw/loongarch/Kconfig            |   1 +
>   hw/loongarch/virt.c             |  67 ++++++------
>   6 files changed, 249 insertions(+), 43 deletions(-)
>   create mode 100644 hw/intc/loongarch_pch_pic_kvm.c
> 
> diff --git a/hw/intc/Kconfig b/hw/intc/Kconfig
> index df9352d41d..1169926eec 100644
> --- a/hw/intc/Kconfig
> +++ b/hw/intc/Kconfig
> @@ -105,6 +105,9 @@ config LOONGARCH_PCH_PIC
>       bool
>       select UNIMP
>   
> +config LOONGARCH_PCH_PIC_KVM
> +    bool
> +
>   config LOONGARCH_PCH_MSI
>       select MSI_NONBROKEN
>       bool
> diff --git a/hw/intc/loongarch_pch_pic.c b/hw/intc/loongarch_pch_pic.c
> index 2d5e65abff..13934be7d9 100644
> --- a/hw/intc/loongarch_pch_pic.c
> +++ b/hw/intc/loongarch_pch_pic.c
> @@ -16,18 +16,27 @@
>   #include "migration/vmstate.h"
>   #include "trace.h"
>   #include "qapi/error.h"
> +#include "sysemu/kvm.h"
>   
>   static void pch_pic_update_irq(LoongArchPCHPIC *s, uint64_t mask, int level)
>   {
>       uint64_t val;
>       int irq;
> +    int kvm_irq;
>   
>       if (level) {
>           val = mask & s->intirr & ~s->int_mask;
>           if (val) {
>               irq = ctz64(val);
>               s->intisr |= MAKE_64BIT_MASK(irq, 1);
> -            qemu_set_irq(s->parent_irq[s->htmsi_vector[irq]], 1);
> +            if (kvm_enabled() && kvm_irqchip_in_kernel()) {
> +                kvm_irq = (
> +                KVM_LOONGARCH_IRQ_TYPE_IOAPIC << KVM_LOONGARCH_IRQ_TYPE_SHIFT)
> +                | (0 <<  KVM_LOONGARCH_IRQ_VCPU_SHIFT) | s->htmsi_vector[irq];
> +                kvm_set_irq(kvm_state, kvm_irq, !!level);
> +            } else {
> +                qemu_set_irq(s->parent_irq[s->htmsi_vector[irq]], 1);
> +            }
 From my point, modification is unnecessay, since there is separate irq 
handler if irqchip_in_kernel in file hw/intc/loongarch_pch_pic_kvm.c

Also I do not know why there is so such modification with file 
hw/intc/loongarch_pch_pic.c, it is irrelative and not used if 
irqchip_in_kernel is set.

Regards
Bibo Mao

>           }
>       } else {
>           /*
> @@ -38,7 +47,14 @@ static void pch_pic_update_irq(LoongArchPCHPIC *s, uint64_t mask, int level)
>           if (val) {
>               irq = ctz64(val);
>               s->intisr &= ~MAKE_64BIT_MASK(irq, 1);
> -            qemu_set_irq(s->parent_irq[s->htmsi_vector[irq]], 0);
> +            if (kvm_enabled() && kvm_irqchip_in_kernel()) {
> +                kvm_irq = (
> +                KVM_LOONGARCH_IRQ_TYPE_IOAPIC << KVM_LOONGARCH_IRQ_TYPE_SHIFT)
> +                | (0 <<  KVM_LOONGARCH_IRQ_VCPU_SHIFT) | s->htmsi_vector[irq];
> +                kvm_set_irq(kvm_state, kvm_irq, !!level);
> +            } else {
> +                qemu_set_irq(s->parent_irq[s->htmsi_vector[irq]], 0);
> +            }
>           }
>       }
>   }
> @@ -265,18 +281,18 @@ static uint64_t loongarch_pch_pic_readb(void *opaque, hwaddr addr,
>   {
>       LoongArchPCHPIC *s = LOONGARCH_PCH_PIC(opaque);
>       uint64_t val = 0;
> -    uint32_t offset = (addr & 0xfff) + PCH_PIC_ROUTE_ENTRY_OFFSET;
> +    uint32_t offset = (addr & 0xfff) + PCH_PIC_ROUTE_ENTRY_START;
>       int64_t offset_tmp;
>   
>       switch (offset) {
> -    case PCH_PIC_HTMSI_VEC_OFFSET ... PCH_PIC_HTMSI_VEC_END:
> -        offset_tmp = offset - PCH_PIC_HTMSI_VEC_OFFSET;
> +    case PCH_PIC_HTMSI_VEC_START ... PCH_PIC_HTMSI_VEC_END:
> +        offset_tmp = offset - PCH_PIC_HTMSI_VEC_START;
>           if (offset_tmp >= 0 && offset_tmp < 64) {
>               val = s->htmsi_vector[offset_tmp];
>           }
>           break;
> -    case PCH_PIC_ROUTE_ENTRY_OFFSET ... PCH_PIC_ROUTE_ENTRY_END:
> -        offset_tmp = offset - PCH_PIC_ROUTE_ENTRY_OFFSET;
> +    case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
> +        offset_tmp = offset - PCH_PIC_ROUTE_ENTRY_START;
>           if (offset_tmp >= 0 && offset_tmp < 64) {
>               val = s->route_entry[offset_tmp];
>           }
> @@ -294,19 +310,19 @@ static void loongarch_pch_pic_writeb(void *opaque, hwaddr addr,
>   {
>       LoongArchPCHPIC *s = LOONGARCH_PCH_PIC(opaque);
>       int32_t offset_tmp;
> -    uint32_t offset = (addr & 0xfff) + PCH_PIC_ROUTE_ENTRY_OFFSET;
> +    uint32_t offset = (addr & 0xfff) + PCH_PIC_ROUTE_ENTRY_START;
>   
>       trace_loongarch_pch_pic_writeb(size, addr, data);
>   
>       switch (offset) {
> -    case PCH_PIC_HTMSI_VEC_OFFSET ... PCH_PIC_HTMSI_VEC_END:
> -        offset_tmp = offset - PCH_PIC_HTMSI_VEC_OFFSET;
> +    case PCH_PIC_HTMSI_VEC_START ... PCH_PIC_HTMSI_VEC_END:
> +        offset_tmp = offset - PCH_PIC_HTMSI_VEC_START;
>           if (offset_tmp >= 0 && offset_tmp < 64) {
>               s->htmsi_vector[offset_tmp] = (uint8_t)(data & 0xff);
>           }
>           break;
> -    case PCH_PIC_ROUTE_ENTRY_OFFSET ... PCH_PIC_ROUTE_ENTRY_END:
> -        offset_tmp = offset - PCH_PIC_ROUTE_ENTRY_OFFSET;
> +    case PCH_PIC_ROUTE_ENTRY_START ... PCH_PIC_ROUTE_ENTRY_END:
> +        offset_tmp = offset - PCH_PIC_ROUTE_ENTRY_START;
>           if (offset_tmp >= 0 && offset_tmp < 64) {
>               s->route_entry[offset_tmp] = (uint8_t)(data & 0xff);
>           }
> diff --git a/hw/intc/loongarch_pch_pic_kvm.c b/hw/intc/loongarch_pch_pic_kvm.c
> new file mode 100644
> index 0000000000..9b6a2f6784
> --- /dev/null
> +++ b/hw/intc/loongarch_pch_pic_kvm.c
> @@ -0,0 +1,180 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * LoongArch kvm pch pic interrupt support
> + *
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
> + */
> +
> +#include "qemu/osdep.h"
> +#include "hw/qdev-properties.h"
> +#include "qemu/typedefs.h"
> +#include "hw/intc/loongarch_pch_pic.h"
> +#include "hw/sysbus.h"
> +#include "linux/kvm.h"
> +#include "migration/vmstate.h"
> +#include "qapi/error.h"
> +#include "sysemu/kvm.h"
> +#include "hw/loongarch/virt.h"
> +#include "hw/pci-host/ls7a.h"
> +#include "qemu/error-report.h"
> +
> +static void kvm_pch_pic_access_regs(int fd, uint64_t addr,
> +                                       void *val, bool is_write)
> +{
> +        kvm_device_access(fd, KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS,
> +                          addr, val, is_write, &error_abort);
> +}
> +
> +static void kvm_loongarch_pch_pic_save_load(void *opaque, bool is_write)
> +{
> +    KVMLoongArchPCHPIC *s = (KVMLoongArchPCHPIC *)opaque;
> +    KVMLoongArchPCHPICClass *class = KVM_LOONGARCH_PCH_PIC_GET_CLASS(s);
> +    int fd = class->dev_fd;
> +    int addr, offset;
> +
> +    kvm_pch_pic_access_regs(fd, PCH_PIC_MASK_START,
> +                            (void *)&s->int_mask, is_write);
> +    kvm_pch_pic_access_regs(fd, PCH_PIC_HTMSI_EN_START,
> +                            (void *)&s->htmsi_en, is_write);
> +    kvm_pch_pic_access_regs(fd, PCH_PIC_EDGE_START,
> +                            (void *)&s->intedge, is_write);
> +    kvm_pch_pic_access_regs(fd, PCH_PIC_AUTO_CTRL0_START,
> +                            (void *)&s->auto_crtl0, is_write);
> +    kvm_pch_pic_access_regs(fd, PCH_PIC_AUTO_CTRL1_START,
> +                            (void *)&s->auto_crtl1, is_write);
> +
> +    for (addr = PCH_PIC_ROUTE_ENTRY_START;
> +         addr < PCH_PIC_ROUTE_ENTRY_END; addr++) {
> +        offset = addr - PCH_PIC_ROUTE_ENTRY_START;
> +        kvm_pch_pic_access_regs(fd, addr,
> +                                (void *)&s->route_entry[offset], is_write);
> +    }
> +
> +    for (addr = PCH_PIC_HTMSI_VEC_START; addr < PCH_PIC_HTMSI_VEC_END; addr++) {
> +        offset = addr - PCH_PIC_HTMSI_VEC_START;
> +        kvm_pch_pic_access_regs(fd, addr,
> +                                (void *)&s->htmsi_vector[offset], is_write);
> +    }
> +
> +    kvm_pch_pic_access_regs(fd, PCH_PIC_INT_IRR_START,
> +                            (void *)&s->intirr, is_write);
> +    kvm_pch_pic_access_regs(fd, PCH_PIC_INT_ISR_START,
> +                            (void *)&s->intisr, is_write);
> +    kvm_pch_pic_access_regs(fd, PCH_PIC_POLARITY_START,
> +                            (void *)&s->int_polarity, is_write);
> +}
> +
> +static int kvm_loongarch_pch_pic_pre_save(void *opaque)
> +{
> +    kvm_loongarch_pch_pic_save_load(opaque, false);
> +    return 0;
> +}
> +
> +static int kvm_loongarch_pch_pic_post_load(void *opaque, int version_id)
> +{
> +    kvm_loongarch_pch_pic_save_load(opaque, true);
> +    return 0;
> +}
> +
> +static void kvm_pch_pic_handler(void *opaque, int irq, int level)
> +{
> +    int kvm_irq;
> +
> +    if (kvm_enabled()) {
> +        kvm_irq = \
> +            (KVM_LOONGARCH_IRQ_TYPE_IOAPIC << KVM_LOONGARCH_IRQ_TYPE_SHIFT)
> +            | (0 <<  KVM_LOONGARCH_IRQ_VCPU_SHIFT) | irq;
> +        kvm_set_irq(kvm_state, kvm_irq, !!level);
> +    }
> +}
> +
> +static void kvm_loongarch_pch_pic_realize(DeviceState *dev, Error **errp)
> +{
> +    KVMLoongArchPCHPICClass *pch_pic_class =
> +            KVM_LOONGARCH_PCH_PIC_GET_CLASS(dev);
> +    struct kvm_create_device cd = {0};
> +    uint64_t pch_pic_base = VIRT_PCH_REG_BASE;
> +    Error *err = NULL;
> +    int ret;
> +
> +    pch_pic_class->parent_realize(dev, &err);
> +    if (err) {
> +        error_propagate(errp, err);
> +        return;
> +    }
> +
> +    if (!pch_pic_class->is_created) {
> +        cd.type = KVM_DEV_TYPE_LOONGARCH_PCH_PIC;
> +        ret = kvm_vm_ioctl(kvm_state, KVM_CREATE_DEVICE, &cd);
> +        if (ret < 0) {
> +            error_setg_errno(errp, errno,
> +                             "Creating the KVM pch pic device failed");
> +            return;
> +        }
> +        pch_pic_class->is_created = true;
> +        pch_pic_class->dev_fd = cd.fd;
> +        fprintf(stdout, "Create LoongArch pch pic irqchip in KVM done!\n");
> +
> +        ret = kvm_device_access(cd.fd, KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL,
> +                                KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT,
> +                                &pch_pic_base, true, NULL);
> +        if (ret < 0) {
> +            error_report(
> +                "KVM PCH_PIC: failed to set the base address of PCH PIC");
> +            exit(1);
> +        }
> +
> +        qdev_init_gpio_in(dev, kvm_pch_pic_handler, VIRT_PCH_PIC_IRQ_NUM);
> +    }
> +}
> +
> +static const VMStateDescription vmstate_kvm_loongarch_pch_pic = {
> +    .name = TYPE_LOONGARCH_PCH_PIC,
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .pre_save = kvm_loongarch_pch_pic_pre_save,
> +    .post_load = kvm_loongarch_pch_pic_post_load,
> +    .fields = (const VMStateField[]) {
> +        VMSTATE_UINT64(int_mask, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT64(htmsi_en, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT64(intedge, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT64(intclr, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT64(auto_crtl0, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT64(auto_crtl1, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT8_ARRAY(route_entry, KVMLoongArchPCHPIC, 64),
> +        VMSTATE_UINT8_ARRAY(htmsi_vector, KVMLoongArchPCHPIC, 64),
> +        VMSTATE_UINT64(last_intirr, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT64(intirr, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT64(intisr, KVMLoongArchPCHPIC),
> +        VMSTATE_UINT64(int_polarity, KVMLoongArchPCHPIC),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +
> +static void kvm_loongarch_pch_pic_class_init(ObjectClass *oc, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(oc);
> +    KVMLoongArchPCHPICClass *pch_pic_class = KVM_LOONGARCH_PCH_PIC_CLASS(oc);
> +
> +    pch_pic_class->parent_realize = dc->realize;
> +    dc->realize = kvm_loongarch_pch_pic_realize;
> +    pch_pic_class->is_created = false;
> +    dc->vmsd = &vmstate_kvm_loongarch_pch_pic;
> +
> +}
> +
> +static const TypeInfo kvm_loongarch_pch_pic_info = {
> +    .name = TYPE_KVM_LOONGARCH_PCH_PIC,
> +    .parent = TYPE_SYS_BUS_DEVICE,
> +    .instance_size = sizeof(KVMLoongArchPCHPIC),
> +    .class_size = sizeof(KVMLoongArchPCHPICClass),
> +    .class_init = kvm_loongarch_pch_pic_class_init,
> +};
> +
> +static void kvm_loongarch_pch_pic_register_types(void)
> +{
> +    type_register_static(&kvm_loongarch_pch_pic_info);
> +}
> +
> +type_init(kvm_loongarch_pch_pic_register_types)
> diff --git a/hw/intc/meson.build b/hw/intc/meson.build
> index 85174d1af1..c20c0a2c05 100644
> --- a/hw/intc/meson.build
> +++ b/hw/intc/meson.build
> @@ -77,3 +77,4 @@ specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_PIC', if_true: files('loongarch_pch_
>   specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_MSI', if_true: files('loongarch_pch_msi.c'))
>   specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI', if_true: files('loongarch_extioi.c'))
>   specific_ss.add(when: 'CONFIG_LOONGARCH_EXTIOI_KVM', if_true: files('loongarch_extioi_kvm.c'))
> +specific_ss.add(when: 'CONFIG_LOONGARCH_PCH_PIC_KVM', if_true: files('loongarch_pch_pic_kvm.c'))
> diff --git a/hw/loongarch/Kconfig b/hw/loongarch/Kconfig
> index 99a523171f..f909f799ad 100644
> --- a/hw/loongarch/Kconfig
> +++ b/hw/loongarch/Kconfig
> @@ -17,6 +17,7 @@ config LOONGARCH_VIRT
>       select LOONGARCH_PCH_MSI
>       select LOONGARCH_EXTIOI
>       select LOONGARCH_IPI_KVM if KVM
> +    select LOONGARCH_PCH_PIC_KVM if KVM
>       select LOONGARCH_EXTIOI_KVM if KVM
>       select LS7A_RTC
>       select SMBIOS
> diff --git a/hw/loongarch/virt.c b/hw/loongarch/virt.c
> index 8ca7c09016..db0c08899b 100644
> --- a/hw/loongarch/virt.c
> +++ b/hw/loongarch/virt.c
> @@ -865,40 +865,45 @@ static void virt_irq_init(LoongArchVirtMachineState *lvms)
>       /* Add Extend I/O Interrupt Controller node */
>       fdt_add_eiointc_node(lvms, &cpuintc_phandle, &eiointc_phandle);
>   
> -    pch_pic = qdev_new(TYPE_LOONGARCH_PCH_PIC);
> -    num = VIRT_PCH_PIC_IRQ_NUM;
> -    qdev_prop_set_uint32(pch_pic, "pch_pic_irq_num", num);
> -    d = SYS_BUS_DEVICE(pch_pic);
> -    sysbus_realize_and_unref(d, &error_fatal);
> -    memory_region_add_subregion(get_system_memory(), VIRT_IOAPIC_REG_BASE,
> -                            sysbus_mmio_get_region(d, 0));
> -    memory_region_add_subregion(get_system_memory(),
> -                            VIRT_IOAPIC_REG_BASE + PCH_PIC_ROUTE_ENTRY_OFFSET,
> +    if (kvm_enabled() && kvm_irqchip_in_kernel()) {
> +        pch_pic = qdev_new(TYPE_KVM_LOONGARCH_PCH_PIC);
> +        sysbus_realize_and_unref(SYS_BUS_DEVICE(pch_pic), &error_fatal);
> +    } else {
> +        pch_pic = qdev_new(TYPE_LOONGARCH_PCH_PIC);
> +        num = VIRT_PCH_PIC_IRQ_NUM;
> +        qdev_prop_set_uint32(pch_pic, "pch_pic_irq_num", num);
> +        d = SYS_BUS_DEVICE(pch_pic);
> +        sysbus_realize_and_unref(d, &error_fatal);
> +        memory_region_add_subregion(get_system_memory(), VIRT_IOAPIC_REG_BASE,
> +                                sysbus_mmio_get_region(d, 0));
> +        memory_region_add_subregion(get_system_memory(),
> +                            VIRT_IOAPIC_REG_BASE + PCH_PIC_ROUTE_ENTRY_START,
>                               sysbus_mmio_get_region(d, 1));
> -    memory_region_add_subregion(get_system_memory(),
> -                            VIRT_IOAPIC_REG_BASE + PCH_PIC_INT_STATUS_LO,
> -                            sysbus_mmio_get_region(d, 2));
> -
> -    /* Connect pch_pic irqs to extioi */
> -    for (i = 0; i < num; i++) {
> -        qdev_connect_gpio_out(DEVICE(d), i, qdev_get_gpio_in(extioi, i));
> -    }
> +        memory_region_add_subregion(get_system_memory(),
> +                                VIRT_IOAPIC_REG_BASE + PCH_PIC_INT_STATUS_LO,
> +                                sysbus_mmio_get_region(d, 2));
>   
> -    /* Add PCH PIC node */
> -    fdt_add_pch_pic_node(lvms, &eiointc_phandle, &pch_pic_phandle);
> +        /* Connect pch_pic irqs to extioi */
> +        for (i = 0; i < num; i++) {
> +            qdev_connect_gpio_out(DEVICE(d), i, qdev_get_gpio_in(extioi, i));
> +        }
>   
> -    pch_msi = qdev_new(TYPE_LOONGARCH_PCH_MSI);
> -    start   =  num;
> -    num = EXTIOI_IRQS - start;
> -    qdev_prop_set_uint32(pch_msi, "msi_irq_base", start);
> -    qdev_prop_set_uint32(pch_msi, "msi_irq_num", num);
> -    d = SYS_BUS_DEVICE(pch_msi);
> -    sysbus_realize_and_unref(d, &error_fatal);
> -    sysbus_mmio_map(d, 0, VIRT_PCH_MSI_ADDR_LOW);
> -    for (i = 0; i < num; i++) {
> -        /* Connect pch_msi irqs to extioi */
> -        qdev_connect_gpio_out(DEVICE(d), i,
> -                              qdev_get_gpio_in(extioi, i + start));
> +        /* Add PCH PIC node */
> +        fdt_add_pch_pic_node(lvms, &eiointc_phandle, &pch_pic_phandle);
> +
> +        pch_msi = qdev_new(TYPE_LOONGARCH_PCH_MSI);
> +        start   =  num;
> +        num = EXTIOI_IRQS - start;
> +        qdev_prop_set_uint32(pch_msi, "msi_irq_base", start);
> +        qdev_prop_set_uint32(pch_msi, "msi_irq_num", num);
> +        d = SYS_BUS_DEVICE(pch_msi);
> +        sysbus_realize_and_unref(d, &error_fatal);
> +        sysbus_mmio_map(d, 0, VIRT_PCH_MSI_ADDR_LOW);
> +        for (i = 0; i < num; i++) {
> +            /* Connect pch_msi irqs to extioi */
> +            qdev_connect_gpio_out(DEVICE(d), i,
> +                                  qdev_get_gpio_in(extioi, i + start));
> +        }
>       }
>   
>       /* Add PCH MSI node */
> 


