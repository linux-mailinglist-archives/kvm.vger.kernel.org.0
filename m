Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D85723D23
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbjFFJXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbjFFJXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:23:03 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33412E6A;
        Tue,  6 Jun 2023 02:22:59 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.86])
        by gateway (Coremail) with SMTP id _____8CxLPB6+X5kQBAAAA--.462S3;
        Tue, 06 Jun 2023 17:16:42 +0800 (CST)
Received: from [10.20.42.86] (unknown [10.20.42.86])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxPMp2+X5koxICAA--.366S3;
        Tue, 06 Jun 2023 17:16:39 +0800 (CST)
Subject: Re: [PATCH v12 26/31] LoongArch: KVM: Implement kvm exception vector
To:     Youling Tang <tangyouling@loongson.cn>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-27-zhaotianrui@loongson.cn>
 <b0e8a311-d988-a1be-a256-130adcdbbfc6@loongson.cn>
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
Message-ID: <14021ed3-7afd-f6a9-e889-53f92fb5aa90@loongson.cn>
Date:   Tue, 6 Jun 2023 17:16:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <b0e8a311-d988-a1be-a256-130adcdbbfc6@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxPMp2+X5koxICAA--.366S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxGFy7KF4UuFyUWrWfKw1xJFc_yoW5AF1fpF
        yfC3WYyrWjg342yFy2yr4qgF13A3yxKr17Cr4xK34UZw4vvryrt395K393CFsxKrykZF1x
        ZayUtr15uF4UG3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8
        Jr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07j873
        kUUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年06月06日 15:00, Youling Tang 写道:
>
>
> On 05/30/2023 09:52 AM, Tianrui Zhao wrote:
>> Implement kvm exception vector, using _kvm_fault_tables array to save
>> the handle function pointer and it is used when vcpu handle exit.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>  arch/loongarch/kvm/exit.c | 48 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 48 insertions(+)
>>
>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>> index 10f9922a7e76..625045fc95c8 100644
>> --- a/arch/loongarch/kvm/exit.c
>> +++ b/arch/loongarch/kvm/exit.c
>> @@ -657,3 +657,51 @@ static int _kvm_handle_fpu_disabled(struct 
>> kvm_vcpu *vcpu)
>>      kvm_own_fpu(vcpu);
>>      return RESUME_GUEST;
>>  }
>> +
>> +/*
>> + * Loongarch KVM callback handling for not implemented guest exiting
>> + */
>> +static int _kvm_fault_ni(struct kvm_vcpu *vcpu)
>> +{
>> +    unsigned long estat, badv;
>> +    unsigned int exccode, inst;
>> +
>> +    /*
>> +     *  Fetch the instruction.
>> +     */
>> +    badv = vcpu->arch.badv;
>> +    estat = vcpu->arch.host_estat;
>> +    exccode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
>> +    inst = vcpu->arch.badi;
>> +    kvm_err("Exccode: %d PC=%#lx inst=0x%08x BadVaddr=%#lx 
>> estat=%#lx\n",
>> +            exccode, vcpu->arch.pc, inst, badv, read_gcsr_estat());
>> +    kvm_arch_vcpu_dump_regs(vcpu);
>> +    vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +
>> +    return RESUME_HOST;
>> +}
>> +
>> +static exit_handle_fn _kvm_fault_tables[EXCCODE_INT_START] = {
>> +    [EXCCODE_TLBL]        = _kvm_handle_read_fault,
>> +    [EXCCODE_TLBI]        = _kvm_handle_read_fault,
>> +    [EXCCODE_TLBNR]        = _kvm_handle_read_fault,
>> +    [EXCCODE_TLBNX]        = _kvm_handle_read_fault,
>> +    [EXCCODE_TLBS]        = _kvm_handle_write_fault,
>> +    [EXCCODE_TLBM]        = _kvm_handle_write_fault,
>> +    [EXCCODE_FPDIS]        = _kvm_handle_fpu_disabled,
>> +    [EXCCODE_GSPR]        = _kvm_handle_gspr,
>> +};
> It can be modified as follows and remove _kvm_init_fault().
>
> static exit_handle_fn _kvm_fault_tables[EXCCODE_INT_START] = {
>     [0 ... EXCCODE_INT_START - 1]    = _kvm_fault_ni,
>
>     [EXCCODE_TLBL]            = _kvm_handle_read_fault,
>     [EXCCODE_TLBI]            = _kvm_handle_read_fault,
>     [EXCCODE_TLBNR]            = _kvm_handle_read_fault,
>     [EXCCODE_TLBNX]            = _kvm_handle_read_fault,
>     [EXCCODE_TLBS]            = _kvm_handle_write_fault,
>     [EXCCODE_TLBM]            = _kvm_handle_write_fault,
>     [EXCCODE_FPDIS]            = _kvm_handle_fpu_disabled,
>     [EXCCODE_GSPR]            = _kvm_handle_gspr,
> };
>
> Thanks,
> Youling
Thanks, this method can simplify the code, I will fix it.

Thanks
Tianrui Zhao
>
>> +
>> +int _kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
>> +{
>> +    return _kvm_fault_tables[fault](vcpu);
>> +}
>> +
>> +void _kvm_init_fault(void)
>> +{
>> +    int i;
>> +
>> +    for (i = 0; i < EXCCODE_INT_START; i++)
>> +        if (!_kvm_fault_tables[i])
>> +            _kvm_fault_tables[i] = _kvm_fault_ni;
>> +}
>>

