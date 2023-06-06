Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7789B723CA4
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjFFJMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjFFJMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:12:14 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADB70FA;
        Tue,  6 Jun 2023 02:12:12 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.86])
        by gateway (Coremail) with SMTP id _____8Cx_epq+H5ktQ8AAA--.367S3;
        Tue, 06 Jun 2023 17:12:10 +0800 (CST)
Received: from [10.20.42.86] (unknown [10.20.42.86])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx+ORo+H5kMhECAA--.9044S3;
        Tue, 06 Jun 2023 17:12:09 +0800 (CST)
Subject: Re: [PATCH v12 09/31] LoongArch: KVM: Implement vcpu get, vcpu set
 registers
To:     Youling Tang <tangyouling@loongson.cn>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-10-zhaotianrui@loongson.cn>
 <4bb703e2-3255-f6c1-5451-ef16c6f0f52a@loongson.cn>
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
Message-ID: <f67ccb6d-df9a-e35a-ac2e-7ec8aabd5cc5@loongson.cn>
Date:   Tue, 6 Jun 2023 17:12:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <4bb703e2-3255-f6c1-5451-ef16c6f0f52a@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bx+ORo+H5kMhECAA--.9044S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxArykXF1rXr17tw1ruF47Jrc_yoW5XrykpF
        1UC3Z5Ka10gry7AF1fXan8Cr13Cr93Kry2g3W3Ca4qyFy7KryjyFyF9r9xGF97tFW5Ar10
        va4UXas29Fs8J3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
        6r1DMcIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8
        Jr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8oGQD
        UUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年06月06日 14:41, Youling Tang 写道:
>
>
> On 05/30/2023 09:52 AM, Tianrui Zhao wrote:
>> Implement LoongArch vcpu get registers and set registers operations, it
>> is called when user space use the ioctl interface to get or set regs.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>  arch/loongarch/kvm/csr_ops.S |  76 +++++++++++++
>>  arch/loongarch/kvm/vcpu.c    | 206 +++++++++++++++++++++++++++++++++++
>>  2 files changed, 282 insertions(+)
>>  create mode 100644 arch/loongarch/kvm/csr_ops.S
>>
>> diff --git a/arch/loongarch/kvm/csr_ops.S b/arch/loongarch/kvm/csr_ops.S
>> new file mode 100644
>> index 000000000000..962b96d8291a
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/csr_ops.S
>> @@ -0,0 +1,76 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <asm/regdef.h>
>> +#include <linux/linkage.h>
>> +    .text
>> +    .section        .text
>> +    .cfi_sections   .debug_frame
>> +/*
>> + * we have splited hw gcsr into three parts, so we can
>> + * calculate the code offset by gcsrid and jump here to
>> + * run the gcsrwr instruction.
>> + */
>> +SYM_FUNC_START(set_hw_gcsr)
>> +    addi.d      t0,   a0,   0
>> +    addi.w      t1,   zero, 96
>> +    bltu        t1,   t0,   1f
>> +    la.pcrel    t0,   10f
>> +    alsl.d      t0,   a0,   t0, 3
>> +    jirl        zero, t0,   0
> jr t0
Thanks, I will fix those instructions.

Thanks
Tianrui Zhao
>
>> +1:
>> +    addi.w      t1,   a0,   -128
>> +    addi.w      t2,   zero, 15
>> +    bltu        t2,   t1,   2f
>> +    la.pcrel    t0,   11f
>> +    alsl.d      t0,   t1,   t0, 3
>> +    jirl        zero, t0,   0
> jr t0
>
>> +2:
>> +    addi.w      t1,   a0,   -384
>> +    addi.w      t2,   zero, 3
>> +    bltu        t2,   t1,   3f
>> +    la.pcrel    t0,   12f
>> +    alsl.d      t0,   t1,   t0, 3
>> +    jirl        zero, t0,   0
> jr t0
>
>> +3:
>> +    addi.w      a0,   zero, -1
>> +    jirl        zero, ra,   0
> jr ra
>
>> +/*
>> + * write guest csr
>> + * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1 << 5 | a1
>> + * range from 0x0(KVM_CSR_CRMD) to 0x60 (KVM_CSR_LLBCTL)
>> + */
>> +10:
>> +    csrnum = 0
>> +    .rept 0x61
>> +        .word 0x05000020 | csrnum << 10 | 5
>> +        jirl zero, ra, 0
> ditto.
>> +        csrnum = csrnum + 1
>> +    .endr
>> +/*
>> + * write guest csr
>> + * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1<<5 | a1
>> + * range from 0x80 (KVM_CSR_IMPCTL1) to 0x8f (KVM_CSR_TLBRPRMD)
>> + */
>> +11:
>> +    csrnum = 0x80
>> +    .rept 0x10
>> +        .word 0x05000020 | csrnum << 10 | 5
>> +        jirl zero, ra, 0
> ditto.
>> +        csrnum = csrnum + 1
>> +    .endr
>> +/*
>> + * write guest csr
>> + * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1<<5 | a1
>> + * range from 0x180(KVM_CSR_DMWIN0) to 0x183(KVM_CSR_DMWIN3)
>> + */
>> +12:
>> +    csrnum = 0x180
>> +    .rept 0x4
>> +        .word 0x05000020 | csrnum << 10 | 5
>> +        jirl zero, ra, 0
> ditto.
>
> Thanks,
> Youling
>> +        csrnum = csrnum + 1
>> +    .endr
>> +SYM_FUNC_END(set_hw_gcsr)

