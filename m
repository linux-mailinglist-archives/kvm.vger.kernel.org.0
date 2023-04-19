Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54D26E75D5
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 10:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjDSI7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 04:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjDSI7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 04:59:05 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C69E19AA;
        Wed, 19 Apr 2023 01:59:03 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8AxrtpWrT9k39weAA--.36323S3;
        Wed, 19 Apr 2023 16:59:02 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxbb5UrT9kp9UuAA--.15562S3;
        Wed, 19 Apr 2023 16:59:01 +0800 (CST)
Subject: Re: [PATCH v7 17/30] LoongArch: KVM: Implement virtual machine tlb
 operations
To:     Huacai Chen <chenhuacai@kernel.org>
References: <20230417094649.874671-1-zhaotianrui@loongson.cn>
 <20230417094649.874671-18-zhaotianrui@loongson.cn>
 <CAAhV-H4Ca18bo-DV8gzaJeVCDT8o_dqFfX4+ruQLHL+V+HrmOg@mail.gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <9209324c-28c5-1305-8ff3-95e79b380f4d@loongson.cn>
Date:   Wed, 19 Apr 2023 16:59:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4Ca18bo-DV8gzaJeVCDT8o_dqFfX4+ruQLHL+V+HrmOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bxbb5UrT9kp9UuAA--.15562S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7tw18uF1kJF43uF4rCF18Grg_yoW8Ar4fpF
        y8uF4rtF4xXrnrJ3sIqw13WFnxZrWkKF12vFWSv34fArZFkr18Kr9akr98GFyrJ34rJr10
        va4rtrsFgF1UJ37anT9S1TB71UUUUj7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0owAa
        w2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2
        jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62
        AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCa
        FVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2
        IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI
        42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42
        IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280
        aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8KNt3UUUUU==
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年04月19日 10:02, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Mon, Apr 17, 2023 at 5:47 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Implement loongarch virtual machine tlb operations such as flush tlb by
>> specific gpa parameter and flush all of the virt machines tlb.
> Use LoongArch instead of loongarch in commit messages and comments, please.
>
> Huacai
Ok, I will replace loongarch with LoongArch, thanks.

Thanks
Tianrui Zhao
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/kvm/tlb.c | 31 +++++++++++++++++++++++++++++++
>>   1 file changed, 31 insertions(+)
>>   create mode 100644 arch/loongarch/kvm/tlb.c
>>
>> diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
>> new file mode 100644
>> index 000000000000..66e116cf2486
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/tlb.c
>> @@ -0,0 +1,31 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <asm/tlb.h>
>> +
>> +int kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
>> +{
>> +       preempt_disable();
>> +       gpa &= (PAGE_MASK << 1);
>> +       invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
>> +       preempt_enable();
>> +       return 0;
>> +}
>> +
>> +/**
>> + * kvm_flush_tlb_all() - Flush all root TLB entries for
>> + * guests.
>> + *
>> + * Invalidate all entries including GVA-->GPA and GPA-->HPA mappings.
>> + */
>> +void kvm_flush_tlb_all(void)
>> +{
>> +       unsigned long flags;
>> +
>> +       local_irq_save(flags);
>> +       invtlb_all(INVTLB_ALLGID, 0, 0);
>> +       local_irq_restore(flags);
>> +}
>> --
>> 2.31.1
>>

