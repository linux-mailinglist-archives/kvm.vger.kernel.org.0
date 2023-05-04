Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CAC6F630E
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 04:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjEDC7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 22:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEDC7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 22:59:43 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1381A4
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 19:59:41 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8DxI_CcH1NkH2MEAA--.7116S3;
        Thu, 04 May 2023 10:59:40 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMiYH1Nk6ShJAA--.4539S3;
        Thu, 04 May 2023 10:59:36 +0800 (CST)
Subject: Re: [PATCH RFC v2 4/9] target/loongarch: Implement kvm get/set
 registers
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
 <20230427072645.3368102-5-zhaotianrui@loongson.cn>
 <f56a6f93-c3ae-5d61-f6ab-bb1eee265197@linaro.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        philmd@linaro.org, peter.maydell@linaro.org
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <3be995d8-e6e3-431f-e047-6bb42887d643@loongson.cn>
Date:   Thu, 4 May 2023 10:59:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <f56a6f93-c3ae-5d61-f6ab-bb1eee265197@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxMMiYH1Nk6ShJAA--.4539S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7Kr43ZFW5Zr4kAw1DGryUWrg_yoW8tr15pF
        ykCF45Kr4xX39rCan3Xw1UXas8X3yxGr4DZa4ftw4SyF4YyrykJrykK39IkF17Ca4xGF10
        vFyYkF18Wa10yFDanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E
        87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jOiSdUUUUU=
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年05月02日 19:24, Richard Henderson 写道:
> On 4/27/23 08:26, Tianrui Zhao wrote:
>> Implement kvm_arch_get/set_registers interfaces, many regs
>> can be get/set in the function, such as core regs, csr regs,
>> fpu regs, mp state, etc.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   meson.build                   |   1 +
>>   target/loongarch/kvm.c        | 356 +++++++++++++++++++++++++++++++++-
>>   target/loongarch/trace-events |  11 ++
>>   target/loongarch/trace.h      |   1 +
>>   4 files changed, 367 insertions(+), 2 deletions(-)
>>   create mode 100644 target/loongarch/trace-events
>>   create mode 100644 target/loongarch/trace.h
>>
>> diff --git a/meson.build b/meson.build
>> index 29f8644d6d..b1b29299da 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -3039,6 +3039,7 @@ if have_system or have_user
>>       'target/s390x',
>>       'target/s390x/kvm',
>>       'target/sparc',
>> +    'target/loongarch',
>>     ]
>
> Sort before mips to keep alphabetic ordering.
Thanks, I will move it to the suitable place.

Thanks
Tianrui Zhao
>
>> +static int kvm_loongarch_get_regs_core(CPUState *cs)
>> +{
>> +    int ret = 0;
>> +    int i;
>> +    struct kvm_regs regs;
>> +    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
>> +    CPULoongArchState *env = &cpu->env;
>> +
>> +    /* Get the current register set as KVM seems it */
>> +    ret = kvm_vcpu_ioctl(cs, KVM_GET_REGS, &regs);
>> +    if (ret < 0) {
>> +        trace_kvm_failed_get_regs_core(strerror(errno));
>> +        return ret;
>> +    }
>> +
>> +    for (i = 0; i < 32; i++) {
>> +        env->gpr[i] = regs.gpr[i];
>
> For i = 1; register 0 is 0...
Thanks,  I will fix it.

Thanks
Tianrui Zhao
>
>> +static inline int kvm_larch_getq(CPUState *cs, uint64_t reg_id,
>> +                                 uint64_t *addr)
>> +{
>> +    struct kvm_one_reg csrreg = {
>> +        .id = reg_id,
>> +        .addr = (uintptr_t)addr
>> +    };
>> +
>> +    return kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &csrreg);
>> +}
>
> Drop inline marker and let the compiler choose.
Thanks , I will drop the inline statement.

Thanks
Tianrui Zhao
>
>> +static inline int kvm_larch_putq(CPUState *cs, uint64_t reg_id,
>> +                                 uint64_t *addr)
>
> Likewise.
>
> Otherwise,
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>
>
> r~

