Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006386E923D
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 13:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbjDTLQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 07:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbjDTLQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 07:16:39 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F6A01B6
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 04:12:44 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8AxYeW3HEFkY3sfAA--.49402S3;
        Thu, 20 Apr 2023 19:06:31 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axy7K2HEFkGQsxAA--.908S3;
        Thu, 20 Apr 2023 19:06:31 +0800 (CST)
Subject: Re: [PATCH RFC v1 07/10] target/loongarch: Implement
 kvm_arch_handle_exit
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, gaosong@loongson.cn
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
 <20230420093606.3366969-8-zhaotianrui@loongson.cn>
 <bbc4bf1b-9855-db6f-05d4-aa3baac96ee2@linaro.org>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <5c97bd6b-1796-e069-3d8f-4c5a659cad17@loongson.cn>
Date:   Thu, 20 Apr 2023 19:06:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <bbc4bf1b-9855-db6f-05d4-aa3baac96ee2@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axy7K2HEFkGQsxAA--.908S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7urWxKFy8AF1rZw47WryDWrg_yoW8Aw4xpa
        ykAF45KrWIg39rt3ZxX3Waq3W3ZrWrGr47Xa47tFya9ws8Zr95CFykKwnIgFWYyryxGa10
        vF10yFnFgF1YyrDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bxkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwA2z4
        x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E
        0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzV
        Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S
        6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82
        IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
        0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMI
        IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF
        0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z2
        80aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8yrW7UUUUU==
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年04月20日 18:00, Philippe Mathieu-Daudé 写道:
> On 20/4/23 11:36, Tianrui Zhao wrote:
>> Implement kvm_arch_handle_exit for loongarch. In this
>> function, the KVM_EXIT_LOONGARCH_IOCSR is handled,
>> we read or write the iocsr address space by the addr,
>> length and is_write argument in kvm_run.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   target/loongarch/kvm.c | 24 +++++++++++++++++++++++-
>>   1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
>> index f8772bbb27..4ce343d276 100644
>> --- a/target/loongarch/kvm.c
>> +++ b/target/loongarch/kvm.c
>> @@ -499,7 +499,29 @@ bool kvm_arch_cpu_check_are_resettable(void)
>>     int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>>   {
>> -    return 0;
>> +    int ret = 0;
>> +    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
>> +    CPULoongArchState *env = &cpu->env;
>> +    MemTxAttrs attrs = {};
>> +
>> +    attrs.requester_id = env_cpu(env)->cpu_index;
>> +
>> +    DPRINTF("%s\n", __func__);
>
> Please use trace events instead of DPRINTF(), as we are trying to remove
> these.
Thanks, I will replace it with trace events.

Thanks
Tianrui Zhao
>
>> +    switch (run->exit_reason) {
>> +    case KVM_EXIT_LOONGARCH_IOCSR:
>> +        address_space_rw(&env->address_space_iocsr,
>> +                         run->iocsr_io.phys_addr,
>> +                         attrs,
>> +                         run->iocsr_io.data,
>> +                         run->iocsr_io.len,
>> +                         run->iocsr_io.is_write);
>> +        break;
>> +    default:
>> +        ret = -1;
>> +        fprintf(stderr, "KVM: unknown exit reason %d\n", 
>> run->exit_reason);
>
> Would warn_report() be more appropriate here?
Thanks, I will use warn_report() here.

Thanks
Tianrui Zhao
>
>> +        break;
>> +    }
>> +    return ret;
>>   }
>>     void kvm_arch_accel_class_init(ObjectClass *oc)

