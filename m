Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E597C4E70
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 11:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjJKJXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 05:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjJKJXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 05:23:08 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 947DF94
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 02:23:06 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.32])
        by gateway (Coremail) with SMTP id _____8AxDOt5aSZlb_cwAA--.23539S3;
        Wed, 11 Oct 2023 17:23:05 +0800 (CST)
Received: from [10.20.42.32] (unknown [10.20.42.32])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxHC92aSZlhSIgAA--.3006S2;
        Wed, 11 Oct 2023 17:23:04 +0800 (CST)
Subject: Re: [PATCH RFC v4 4/9] target/loongarch: Implement kvm get/set
 registers
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Bibo Mao <maobibo@loongson.cn>, Song Gao <gaosong@loongson.cn>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>
References: <cover.1696841645.git.lixianglai@loongson.cn>
 <f4399db694265f34dbe9aafd024c56470e8a0f54.1696841645.git.lixianglai@loongson.cn>
 <1f552f71-3b47-a2be-67c5-fdca86bf59f7@linaro.org>
From:   lixianglai <lixianglai@loongson.cn>
Message-ID: <e1a55222-a588-3921-627a-da8ffa3e7297@loongson.cn>
Date:   Wed, 11 Oct 2023 17:23:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1f552f71-3b47-a2be-67c5-fdca86bf59f7@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8BxHC92aSZlhSIgAA--.3006S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxAr4xXrW5tF1kZFWftFy3Jrc_yoWrZr1kpr
        18Jr1UJryUJr18Jr1UJr1UJFyUJr1UJw1UXr1xJF1UAr1UJr1jqr1UXr1jgr1UJr48Jr1U
        Jr1UJr1UZr1UJrgCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
        Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
        14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
        AE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
        4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnI
        WIevJa73UjIFyTuYvjxU2BT5DUUUU
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Philippe Mathieu-Daudé:

> Hi Li and Zhao,
>
> On 9/10/23 11:01, xianglai li wrote:
>> From: Tianrui Zhao <zhaotianrui@loongson.cn>
>>
>> Implement kvm_arch_get/set_registers interfaces, many regs
>> can be get/set in the function, such as core regs, csr regs,
>> fpu regs, mp state, etc.
>>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: "Marc-André Lureau" <marcandre.lureau@redhat.com>
>> Cc: "Daniel P. Berrangé" <berrange@redhat.com>
>> Cc: Thomas Huth <thuth@redhat.com>
>> Cc: "Philippe Mathieu-Daudé" <philmd@linaro.org>
>> Cc: Richard Henderson <richard.henderson@linaro.org>
>> Cc: Peter Maydell <peter.maydell@linaro.org>
>> Cc: Bibo Mao <maobibo@loongson.cn>
>> Cc: Song Gao <gaosong@loongson.cn>
>> Cc: Xiaojuan Yang <yangxiaojuan@loongson.cn>
>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> Signed-off-by: xianglai li <lixianglai@loongson.cn>
>> ---
>>   meson.build                   |   1 +
>>   target/loongarch/cpu.c        |   3 +
>>   target/loongarch/cpu.h        |   2 +
>>   target/loongarch/kvm.c        | 406 +++++++++++++++++++++++++++++++++-
>>   target/loongarch/trace-events |  13 ++
>>   target/loongarch/trace.h      |   1 +
>>   6 files changed, 424 insertions(+), 2 deletions(-)
>>   create mode 100644 target/loongarch/trace-events
>>   create mode 100644 target/loongarch/trace.h
>
>
>> +static int kvm_larch_getq(CPUState *cs, uint64_t reg_id,
>> +                                 uint64_t *addr)
>> +{
>> +    struct kvm_one_reg csrreg = {
>> +        .id = reg_id,
>> +        .addr = (uintptr_t)addr
>> +    };
>> +
>> +    return kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &csrreg);
>> +}
>
> This is kvm_get_one_reg().

I'll replace kvm_larch_getq() with kvm_get_one_reg().


>
>
>> +static int kvm_larch_putq(CPUState *cs, uint64_t reg_id,
>> +                                 uint64_t *addr)
>> +{
>> +    struct kvm_one_reg csrreg = {
>> +        .id = reg_id,
>> +        .addr = (uintptr_t)addr
>> +    };
>> +
>> +    return kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &csrreg);
>> +}
>
> This is kvm_set_one_reg().
>
I'll replace kvm_larch_putq() with kvm_set_one_reg().

Thanks,

Xianglai.


>> +
>> +#define KVM_GET_ONE_UREG64(cs, ret, regidx, addr)                 \
>> + ({                                                            \
>> +        err = kvm_larch_getq(cs, KVM_IOC_CSRID(regidx), addr);    \
>> +        if (err < 0) {                                            \
>> +            ret = err;                                            \
>> +            trace_kvm_failed_get_csr(regidx, strerror(errno));    \
>> + }                                                         \
>> +    })
>> +
>> +#define KVM_PUT_ONE_UREG64(cs, ret, regidx, addr)                 \
>> + ({                                                            \
>> +        err = kvm_larch_putq(cs, KVM_IOC_CSRID(regidx), addr);    \
>> +        if (err < 0) {                                            \
>> +            ret = err;                                            \
>> +            trace_kvm_failed_put_csr(regidx, strerror(errno));    \
>> + }                                                         \
>> +    })
>

