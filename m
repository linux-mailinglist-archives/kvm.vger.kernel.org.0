Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAED7723CBE
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbjFFJOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbjFFJNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:13:50 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48288E79;
        Tue,  6 Jun 2023 02:13:38 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.86])
        by gateway (Coremail) with SMTP id _____8BxLuvA+H5k7w8AAA--.426S3;
        Tue, 06 Jun 2023 17:13:36 +0800 (CST)
Received: from [10.20.42.86] (unknown [10.20.42.86])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxZuS++H5knhECAA--.8809S3;
        Tue, 06 Jun 2023 17:13:35 +0800 (CST)
Subject: Re: [PATCH v12 12/31] LoongArch: KVM: Implement vcpu interrupt
 operations
To:     Youling Tang <tangyouling@loongson.cn>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-13-zhaotianrui@loongson.cn>
 <0fc1f879-f7d9-2891-6169-b78593386cc1@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <44af29e8-16cd-da63-0132-ef9fe469c7fd@loongson.cn>
Date:   Tue, 6 Jun 2023 17:13:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <0fc1f879-f7d9-2891-6169-b78593386cc1@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxZuS++H5knhECAA--.8809S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxAryDZr43Aw1rWF1UAFyrGrX_yoW5Ww4DpF
        48Ca1fXw43Jry7GwnxW3WSkrs5tw4kXryUtrW3ta4UGasFywn5AF1xKry2k347uw4kGrZr
        WF4avr9rCFs8t3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8
        Jr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU82jg7
        UUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年06月06日 14:49, Youling Tang 写道:
>
>
> On 05/30/2023 09:52 AM, Tianrui Zhao wrote:
>> Implement vcpu interrupt operations such as vcpu set irq and
>> vcpu clear irq, using set_gcsr_estat to set irq which is
>> parsed by the irq bitmap.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>  arch/loongarch/kvm/interrupt.c | 127 +++++++++++++++++++++++++++++++++
>>  arch/loongarch/kvm/vcpu.c      |  45 ++++++++++++
>>  2 files changed, 172 insertions(+)
>>  create mode 100644 arch/loongarch/kvm/interrupt.c
>>
>> diff --git a/arch/loongarch/kvm/interrupt.c 
>> b/arch/loongarch/kvm/interrupt.c
>> new file mode 100644
>> index 000000000000..243bb19b387e
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/interrupt.c
>> @@ -0,0 +1,127 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/err.h>
>> +#include <asm/kvm_vcpu.h>
>> +#include <asm/kvm_csr.h>
>> +
>> +static unsigned int int_to_coreint[EXCCODE_INT_NUM] = {
>> +    [INT_TI]    = CPU_TIMER,
>> +    [INT_IPI]    = CPU_IPI,
>> +    [INT_SWI0]    = CPU_SIP0,
>> +    [INT_SWI1]    = CPU_SIP1,
>> +    [INT_HWI0]    = CPU_IP0,
>> +    [INT_HWI1]    = CPU_IP1,
>> +    [INT_HWI2]    = CPU_IP2,
>> +    [INT_HWI3]    = CPU_IP3,
>> +    [INT_HWI4]    = CPU_IP4,
>> +    [INT_HWI5]    = CPU_IP5,
>> +    [INT_HWI6]    = CPU_IP6,
>> +    [INT_HWI7]    = CPU_IP7,
>> +};
>> +
>> +static int _kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int 
>> priority)
>> +{
>> +    unsigned int irq = 0;
>> +
>> +    clear_bit(priority, &vcpu->arch.irq_pending);
>> +    if (priority < EXCCODE_INT_NUM)
>> +        irq = int_to_coreint[priority];
>> +
>> +    switch (priority) {
>> +    case INT_TI:
>> +    case INT_IPI:
>> +    case INT_SWI0:
>> +    case INT_SWI1:
>> +        set_gcsr_estat(irq);
>> +        break;
>> +
>> +    case INT_HWI0:
>> +    case INT_HWI1:
>> +    case INT_HWI2:
>> +    case INT_HWI3:
>> +    case INT_HWI4:
>> +    case INT_HWI5:
>> +    case INT_HWI6:
>> +    case INT_HWI7:
> It can be simplified to,
> case INT_HWI0 ... INT_HWI7:
Thanks, I will simplify those case statement.

Thanks
Tianrui Zhao
>
>> +        set_csr_gintc(irq);
>> +        break;
>> +
>> +    default:
>> +        break;
>> +    }
>> +
>> +    return 1;
>> +}
>> +
>> +static int _kvm_irq_clear(struct kvm_vcpu *vcpu, unsigned int priority)
>> +{
>> +    unsigned int irq = 0;
>> +
>> +    clear_bit(priority, &vcpu->arch.irq_clear);
>> +    if (priority < EXCCODE_INT_NUM)
>> +        irq = int_to_coreint[priority];
>> +
>> +    switch (priority) {
>> +    case INT_TI:
>> +    case INT_IPI:
>> +    case INT_SWI0:
>> +    case INT_SWI1:
>> +        clear_gcsr_estat(irq);
>> +        break;
>> +
>> +    case INT_HWI0:
>> +    case INT_HWI1:
>> +    case INT_HWI2:
>> +    case INT_HWI3:
>> +    case INT_HWI4:
>> +    case INT_HWI5:
>> +    case INT_HWI6:
>> +    case INT_HWI7:
> ditto.
>
> Thanks,
> Youling
>> +        clear_csr_gintc(irq);
>> +        break;
>> +
>> +    default:
>> +        break;
>> +    }
>> +
>> +    return 1;
>> +}

