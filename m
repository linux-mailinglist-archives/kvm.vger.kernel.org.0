Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4094F6E75B2
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 10:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjDSIxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 04:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjDSIxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 04:53:43 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD6694220;
        Wed, 19 Apr 2023 01:53:41 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8CxztoUrD9kddweAA--.36498S3;
        Wed, 19 Apr 2023 16:53:40 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxWb0SrD9k6tIuAA--.54393S3;
        Wed, 19 Apr 2023 16:53:39 +0800 (CST)
Subject: Re: [PATCH v7 16/30] LoongArch: KVM: Implement update VM id function
To:     Huacai Chen <chenhuacai@kernel.org>
References: <20230417094649.874671-1-zhaotianrui@loongson.cn>
 <20230417094649.874671-17-zhaotianrui@loongson.cn>
 <CAAhV-H4pyBi=0ckNDLErz6G_b5G7ti2wVDXF3a7xv-MiJtF_tA@mail.gmail.com>
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
Message-ID: <d2dbcf54-4015-81ec-6b96-47cdcc22cd13@loongson.cn>
Date:   Wed, 19 Apr 2023 16:53:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4pyBi=0ckNDLErz6G_b5G7ti2wVDXF3a7xv-MiJtF_tA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxWb0SrD9k6tIuAA--.54393S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxCrykGw17uw4fuFyDGFW7Jwb_yoW5Xry3pF
        WxCFn5Gr4xJr13C34aqr1FqFnI9395KF12va47t3WYyr12kwn5CrWvkrWDCFyrXr1rCr1I
        vF15tF4akF1jy37anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E
        87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jz5lbUUUUU=
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年04月19日 10:01, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Mon, Apr 17, 2023 at 5:47 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Implement kvm check vmid and update vmid, the vmid should be checked before
>> vcpu enter guest.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/kvm/vmid.c | 65 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 65 insertions(+)
>>   create mode 100644 arch/loongarch/kvm/vmid.c
>>
>> diff --git a/arch/loongarch/kvm/vmid.c b/arch/loongarch/kvm/vmid.c
>> new file mode 100644
>> index 000000000000..7d9688c24184
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/vmid.c
>> @@ -0,0 +1,65 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <asm/kvm_host.h>
> linux/kvm_host.h already include asm/kvm_host.h
>
> Huacai
Thanks, I will remove the asm/kvm_host.h.

Thanks
Tianrui Zhao
>> +#include "trace.h"
>> +
>> +static void _kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +       struct kvm_context *context;
>> +       unsigned long vpid;
>> +
>> +       context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
>> +       vpid = context->vpid_cache + 1;
>> +       if (!(vpid & vpid_mask)) {
>> +               /* finish round of 64 bit loop */
>> +               if (unlikely(!vpid))
>> +                       vpid = vpid_mask + 1;
>> +
>> +               /* vpid 0 reserved for root */
>> +               ++vpid;
>> +
>> +               /* start new vpid cycle */
>> +               kvm_flush_tlb_all();
>> +       }
>> +
>> +       context->vpid_cache = vpid;
>> +       vcpu->arch.vpid = vpid;
>> +}
>> +
>> +void _kvm_check_vmid(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +       struct kvm_context *context;
>> +       bool migrated;
>> +       unsigned long ver, old, vpid;
>> +
>> +       /*
>> +        * Are we entering guest context on a different CPU to last time?
>> +        * If so, the VCPU's guest TLB state on this CPU may be stale.
>> +        */
>> +       context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
>> +       migrated = (vcpu->arch.last_exec_cpu != cpu);
>> +       vcpu->arch.last_exec_cpu = cpu;
>> +
>> +       /*
>> +        * Check if our vpid is of an older version
>> +        *
>> +        * We also discard the stored vpid if we've executed on
>> +        * another CPU, as the guest mappings may have changed without
>> +        * hypervisor knowledge.
>> +        */
>> +       ver = vcpu->arch.vpid & ~vpid_mask;
>> +       old = context->vpid_cache  & ~vpid_mask;
>> +       if (migrated || (ver != old)) {
>> +               _kvm_update_vpid(vcpu, cpu);
>> +               trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
>> +       }
>> +
>> +       /* Restore GSTAT(0x50).vpid */
>> +       vpid = (vcpu->arch.vpid & vpid_mask)
>> +               << CSR_GSTAT_GID_SHIFT;
>> +       change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
>> +}
>> --
>> 2.31.1
>>

