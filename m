Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7584F72271B
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjFENOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjFENOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:14:14 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77EF5E43;
        Mon,  5 Jun 2023 06:13:57 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8BxmfGS331k1xkAAA--.555S3;
        Mon, 05 Jun 2023 21:13:54 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxJeSS331kJYQAAA--.2165S3;
        Mon, 05 Jun 2023 21:13:54 +0800 (CST)
Message-ID: <1e783f1f-db42-0e16-a61b-245442b84ce6@loongson.cn>
Date:   Mon, 5 Jun 2023 21:13:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 12/31] LoongArch: KVM: Implement vcpu interrupt
 operations
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-13-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-13-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxJeSS331kJYQAAA--.2165S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZFW3JrW5XF1UAF45KFyfAFc_yoW7JF45pr
        W8Cw1fZ3yftr17Kw15W3ZY9rs0qw4vgrW7ZrZxX343Grnrtrn0yF4xKryqyrW7Cw4kGF1S
        gF4a9rWqka1Dt3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUQFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Wrv_ZF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcV
        AKI48JM4x0Y40E4IxF1VCIxcxG6Fyj6r4UJwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0E
        n4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbc
        kI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_
        JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26F
        1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG
        6r1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07bOSdkUUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Bibo, Mao <maobibo@loongson.cn>

在 2023/5/30 09:52, Tianrui Zhao 写道:
> Implement vcpu interrupt operations such as vcpu set irq and
> vcpu clear irq, using set_gcsr_estat to set irq which is
> parsed by the irq bitmap.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/interrupt.c | 127 +++++++++++++++++++++++++++++++++
>  arch/loongarch/kvm/vcpu.c      |  45 ++++++++++++
>  2 files changed, 172 insertions(+)
>  create mode 100644 arch/loongarch/kvm/interrupt.c
> 
> diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
> new file mode 100644
> index 000000000000..243bb19b387e
> --- /dev/null
> +++ b/arch/loongarch/kvm/interrupt.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <asm/kvm_vcpu.h>
> +#include <asm/kvm_csr.h>
> +
> +static unsigned int int_to_coreint[EXCCODE_INT_NUM] = {
> +	[INT_TI]	= CPU_TIMER,
> +	[INT_IPI]	= CPU_IPI,
> +	[INT_SWI0]	= CPU_SIP0,
> +	[INT_SWI1]	= CPU_SIP1,
> +	[INT_HWI0]	= CPU_IP0,
> +	[INT_HWI1]	= CPU_IP1,
> +	[INT_HWI2]	= CPU_IP2,
> +	[INT_HWI3]	= CPU_IP3,
> +	[INT_HWI4]	= CPU_IP4,
> +	[INT_HWI5]	= CPU_IP5,
> +	[INT_HWI6]	= CPU_IP6,
> +	[INT_HWI7]	= CPU_IP7,
> +};
> +
> +static int _kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
> +{
> +	unsigned int irq = 0;
> +
> +	clear_bit(priority, &vcpu->arch.irq_pending);
> +	if (priority < EXCCODE_INT_NUM)
> +		irq = int_to_coreint[priority];
> +
> +	switch (priority) {
> +	case INT_TI:
> +	case INT_IPI:
> +	case INT_SWI0:
> +	case INT_SWI1:
> +		set_gcsr_estat(irq);
> +		break;
> +
> +	case INT_HWI0:
> +	case INT_HWI1:
> +	case INT_HWI2:
> +	case INT_HWI3:
> +	case INT_HWI4:
> +	case INT_HWI5:
> +	case INT_HWI6:
> +	case INT_HWI7:
> +		set_csr_gintc(irq);
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	return 1;
> +}
> +
> +static int _kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
> +{
> +	unsigned int irq = 0;
> +
> +	clear_bit(priority, &vcpu->arch.irq_clear);
> +	if (priority < EXCCODE_INT_NUM)
> +		irq = int_to_coreint[priority];
> +
> +	switch (priority) {
> +	case INT_TI:
> +	case INT_IPI:
> +	case INT_SWI0:
> +	case INT_SWI1:
> +		clear_gcsr_estat(irq);
> +		break;
> +
> +	case INT_HWI0:
> +	case INT_HWI1:
> +	case INT_HWI2:
> +	case INT_HWI3:
> +	case INT_HWI4:
> +	case INT_HWI5:
> +	case INT_HWI6:
> +	case INT_HWI7:
> +		clear_csr_gintc(irq);
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	return 1;
> +}
> +
> +void _kvm_deliver_intr(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long *pending = &vcpu->arch.irq_pending;
> +	unsigned long *pending_clr = &vcpu->arch.irq_clear;
> +	unsigned int priority;
> +
> +	if (!(*pending) && !(*pending_clr))
> +		return;
> +
> +	if (*pending_clr) {
> +		priority = __ffs(*pending_clr);
> +		while (priority <= INT_IPI) {
> +			_kvm_irq_clear(vcpu, priority);
> +			priority = find_next_bit(pending_clr,
> +					BITS_PER_BYTE * sizeof(*pending_clr),
> +					priority + 1);
> +		}
> +	}
> +
> +	if (*pending) {
> +		priority = __ffs(*pending);
> +		while (priority <= INT_IPI) {
> +			_kvm_irq_deliver(vcpu, priority);
> +			priority = find_next_bit(pending,
> +					BITS_PER_BYTE * sizeof(*pending),
> +					priority + 1);
> +		}
> +	}
> +}
> +
> +int _kvm_pending_timer(struct kvm_vcpu *vcpu)
> +{
> +	return test_bit(INT_TI, &vcpu->arch.irq_pending);
> +}
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 60213f7f7bac..f661743dbe66 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -304,6 +304,51 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
>  	preempt_enable();
>  }
>  
> +int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> +			     struct kvm_loongarch_interrupt *irq)
> +{
> +	int intr = (int)irq->irq;
> +	struct kvm_vcpu *dvcpu = NULL;
> +
> +	if (irq->cpu == -1)
> +		dvcpu = vcpu;
> +	else
> +		dvcpu = kvm_get_vcpu(vcpu->kvm, irq->cpu);
> +
> +	if (intr > 0)
> +		_kvm_queue_irq(dvcpu, intr);
> +	else if (intr < 0)
> +		_kvm_dequeue_irq(dvcpu, -intr);
> +	else {
> +		kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
> +				irq->cpu, irq->irq);
> +		return -EINVAL;
> +	}
> +
> +	kvm_vcpu_kick(dvcpu);
> +	return 0;
> +}
> +
> +long kvm_arch_vcpu_async_ioctl(struct file *filp,
> +			       unsigned int ioctl, unsigned long arg)
> +{
> +	struct kvm_vcpu *vcpu = filp->private_data;
> +	void __user *argp = (void __user *)arg;
> +
> +	if (ioctl == KVM_INTERRUPT) {
> +		struct kvm_loongarch_interrupt irq;
> +
> +		if (copy_from_user(&irq, argp, sizeof(irq)))
> +			return -EFAULT;
> +		kvm_debug("[%d] %s: irq: %d\n", vcpu->vcpu_id, __func__,
> +			  irq.irq);
> +
> +		return kvm_vcpu_ioctl_interrupt(vcpu, &irq);
> +	}
> +
> +	return -ENOIOCTLCMD;
> +}
> +
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>  {
>  	return 0;

