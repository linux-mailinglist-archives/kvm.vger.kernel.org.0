Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E05C734AB7
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 05:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjFSDn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jun 2023 23:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjFSDn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jun 2023 23:43:56 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 601F1FC;
        Sun, 18 Jun 2023 20:43:53 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8BxL_D4zo9kC7wGAA--.13923S3;
        Mon, 19 Jun 2023 11:43:52 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxluT2zo9ka8QfAA--.23712S3;
        Mon, 19 Jun 2023 11:43:50 +0800 (CST)
Subject: Re: [PATCH v13 03/30] LoongArch: KVM: Implement kvm hardware enable,
 disable interface
To:     "bibo, mao" <bibo.mao@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
 <20230609090832.2131037-4-zhaotianrui@loongson.cn>
 <cc73aaf7-85bf-2062-6d1b-f1cbb70242f8@loongson.cn>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <8bc58ebf-080e-fdb9-5b79-0bfe8412bd32@loongson.cn>
Date:   Mon, 19 Jun 2023 11:43:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cc73aaf7-85bf-2062-6d1b-f1cbb70242f8@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8DxluT2zo9ka8QfAA--.23712S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxXw13KF45CFWUZrW7JF1kJFc_yoW5tr1rpr
        1kAFW5JrWUJrn3GF9xXFn8AFy5Ary8G3ZrJF1Iqa4UJr429r1FgFyjgryqgF15Xw48JF10
        yr1jgrnxuF1DJrgCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUU
        UU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/6/13 下午8:49, bibo, mao 写道:
>
>
> 在 2023/6/9 17:08, Tianrui Zhao 写道:
>> Implement kvm hardware enable, disable interface, setting
>> the guest config register to enable virtualization features
>> when called the interface.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/kvm/main.c | 64 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 64 insertions(+)
>>
>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>> index f98c1619725f..5ebae1ea7565 100644
>> --- a/arch/loongarch/kvm/main.c
>> +++ b/arch/loongarch/kvm/main.c
>> @@ -195,6 +195,70 @@ static void _kvm_init_gcsr_flag(void)
>>       set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR3);
>>   }
>>   +void kvm_init_vmcs(struct kvm *kvm)
>> +{
>> +    kvm->arch.vmcs = vmcs;
>> +}
>> +
>> +long kvm_arch_dev_ioctl(struct file *filp,
>> +            unsigned int ioctl, unsigned long arg)
>> +{
>> +    return -ENOIOCTLCMD;
>> +}
>> +
>> +#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
> Can we remove macro CONFIG_KVM_GENERIC_HARDWARE_ENABLING here since it 
> is always enabled? The other looks good to me.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>
> Regards
> Bibo, Mao
Thanks, this CONFIG_KVM_GENERIC_HARDWARE_ENABLING is meaningless, and I 
will remove it.

Tianrui Zhao
>> +int kvm_arch_hardware_enable(void)
>> +{
>> +    unsigned long env, gcfg = 0;
>> +
>> +    env = read_csr_gcfg();
>> +    /* First init gtlbc, gcfg, gstat, gintc. All guest use the same 
>> config */
>> +    clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI);
>> +    write_csr_gcfg(0);
>> +    write_csr_gstat(0);
>> +    write_csr_gintc(0);
>> +
>> +    /*
>> +     * Enable virtualization features granting guest direct control of
>> +     * certain features:
>> +     * GCI=2:       Trap on init or unimplement cache instruction.
>> +     * TORU=0:      Trap on Root Unimplement.
>> +     * CACTRL=1:    Root control cache.
>> +     * TOP=0:       Trap on Previlege.
>> +     * TOE=0:       Trap on Exception.
>> +     * TIT=0:       Trap on Timer.
>> +     */
>> +    if (env & CSR_GCFG_GCIP_ALL)
>> +        gcfg |= CSR_GCFG_GCI_SECURE;
>> +    if (env & CSR_GCFG_MATC_ROOT)
>> +        gcfg |= CSR_GCFG_MATC_ROOT;
>> +
>> +    gcfg |= CSR_GCFG_TIT;
>> +    write_csr_gcfg(gcfg);
>> +
>> +    kvm_flush_tlb_all();
>> +
>> +    /* Enable using TGID  */
>> +    set_csr_gtlbc(CSR_GTLBC_USETGID);
>> +    kvm_debug("gtlbc:%llx gintc:%llx gstat:%llx gcfg:%llx",
>> +            read_csr_gtlbc(), read_csr_gintc(),
>> +            read_csr_gstat(), read_csr_gcfg());
>> +
>> +    return 0;
>> +}
>> +
>> +void kvm_arch_hardware_disable(void)
>> +{
>> +    clear_csr_gtlbc(CSR_GTLBC_USETGID | CSR_GTLBC_TOTI);
>> +    write_csr_gcfg(0);
>> +    write_csr_gstat(0);
>> +    write_csr_gintc(0);
>> +
>> +    /* Flush any remaining guest TLB entries */
>> +    kvm_flush_tlb_all();
>> +}
>> +#endif
>> +
>>   static int kvm_loongarch_env_init(void)
>>   {
>>       struct kvm_context *context;

