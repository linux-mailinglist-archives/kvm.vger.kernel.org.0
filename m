Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DB779B3E2
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjIKUrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbjIKKX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 06:23:59 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE60A1AB;
        Mon, 11 Sep 2023 03:23:53 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8DxPOu36v5kWYwkAA--.578S3;
        Mon, 11 Sep 2023 18:23:51 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Dx4eS26v5kGCx3AA--.21138S3;
        Mon, 11 Sep 2023 18:23:50 +0800 (CST)
Message-ID: <7379be58-30a5-1f0f-2e13-ca51b7cff096@loongson.cn>
Date:   Mon, 11 Sep 2023 18:23:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v20 16/30] LoongArch: KVM: Implement update VM id function
To:     Huacai Chen <chenhuacai@kernel.org>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-17-zhaotianrui@loongson.cn>
 <CAAhV-H497R=B3KaO8Z5ig2Nwst10dm63eiPnDpfNbFCxG4uVKg@mail.gmail.com>
Content-Language: en-US
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <CAAhV-H497R=B3KaO8Z5ig2Nwst10dm63eiPnDpfNbFCxG4uVKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Dx4eS26v5kGCx3AA--.21138S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAryftF47Kw1xZw4UCrWUWrX_yoW5uFW5pF
        W8C3Z5Gws7JF12v3sIq340qFnIg3s5Kr1j9Fy7ta4Yyr9Fk34kArs5KrWjkFWxJr1fCr4I
        vF1YyFsrCF1DA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
        6F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
        Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
        Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1q6r43MI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUUUUU
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/9/11 18:00, Huacai Chen 写道:
> Hi, Tianrui,
> 
> On Thu, Aug 31, 2023 at 4:30 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>>
>> Implement kvm check vmid and update vmid, the vmid should be checked before
>> vcpu enter guest.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>  arch/loongarch/kvm/vmid.c | 66 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 66 insertions(+)
>>  create mode 100644 arch/loongarch/kvm/vmid.c
>>
>> diff --git a/arch/loongarch/kvm/vmid.c b/arch/loongarch/kvm/vmid.c
>> new file mode 100644
>> index 0000000000..fc25ddc3b7
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/vmid.c
>> @@ -0,0 +1,66 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <linux/kvm_host.h>
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
>> +void _kvm_check_vmid(struct kvm_vcpu *vcpu)
>> +{
>> +       struct kvm_context *context;
>> +       bool migrated;
>> +       unsigned long ver, old, vpid;
>> +       int cpu;
>> +
>> +       cpu = smp_processor_id();
>> +       /*
>> +        * Are we entering guest context on a different CPU to last time?
>> +        * If so, the vCPU's guest TLB state on this CPU may be stale.
>> +        */
>> +       context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
>> +       migrated = (vcpu->cpu != cpu);
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
>> +               vcpu->cpu = cpu;
>> +       }
>> +
>> +       /* Restore GSTAT(0x50).vpid */
>> +       vpid = (vcpu->arch.vpid & vpid_mask)
>> +               << CSR_GSTAT_GID_SHIFT;
>> +       change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
>> +}
> I believe that vpid and vmid are both GID in the gstat register, so
> please unify their names. And I think vpid is better than vmid.

For processor 3A5000 vpid is the same with vmid, with next generation processor
like 3A6000, it is seperated. vpid is for vcpu specific and represents
translation from gva to gpa; vmid is the whole vm and represents translation
from gpa to hpa, all vcpus shares the same vmid, so that tlb indexed with vpid
will be still in effective when flushing shadow tlbs indexed with vmid.

Only that VM patch for 3A6000 is not submitted now, generation method for
vpid and vmid will be much different. It is prepared for future processor
update :)

Regards
Bibo Mao

> 
> Moreover, no need to create a vmid.c file, just putting them in main.c is OK.
> 
> Huacai
> 
>> --
>> 2.27.0
>>

