Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E9A736150
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 03:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjFTB4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 21:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjFTB4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 21:56:44 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F7FAB9;
        Mon, 19 Jun 2023 18:56:41 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8Cxc+hXB5FkTwQHAA--.384S3;
        Tue, 20 Jun 2023 09:56:39 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxPMpWB5FkKQohAA--.18095S3;
        Tue, 20 Jun 2023 09:56:39 +0800 (CST)
Subject: Re: [PATCH v14 21/30] LoongArch: KVM: Implement handle iocsr
 exception
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
References: <20230619083255.3841777-1-zhaotianrui@loongson.cn>
 <20230619083255.3841777-22-zhaotianrui@loongson.cn>
 <CAAhV-H6VcQUYu8Q7Cd2vbd=XQZmdTxUHV0bnuwr4vteLBpKEoQ@mail.gmail.com>
From:   zhaotianrui <zhaotianrui@loongson.cn>
Message-ID: <c6e1beef-925a-9e6b-c61e-b50f815aaa26@loongson.cn>
Date:   Tue, 20 Jun 2023 09:56:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6VcQUYu8Q7Cd2vbd=XQZmdTxUHV0bnuwr4vteLBpKEoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8AxPMpWB5FkKQohAA--.18095S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxGw4fCrWUWFyrArW3WF4xZrc_yoWrZrW5pF
        WDZrn5KrW8Gr1xtwsrXFs7Wr1aqFs5Gry7AFy3J3WruFWYyas5JrW0krnF9FWkK3sxGr4I
        9F1fZry7uF1qyFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
        kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
        XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
        k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
        4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
        42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4Xo7DUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/6/19 下午6:13, Huacai Chen 写道:
> Hi, Tianrui,
>
> On Mon, Jun 19, 2023 at 4:33 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>> Implement kvm handle vcpu iocsr exception, setting the iocsr info into
>> vcpu_run and return to user space to handle it.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/inst.h | 16 ++++++
>>   arch/loongarch/kvm/exit.c         | 92 +++++++++++++++++++++++++++++++
>>   2 files changed, 108 insertions(+)
>>
>> diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/asm/inst.h
>> index b09887ffcd15..db5857796432 100644
>> --- a/arch/loongarch/include/asm/inst.h
>> +++ b/arch/loongarch/include/asm/inst.h
>> @@ -56,6 +56,14 @@ enum reg2_op {
>>          revbd_op        = 0x0f,
>>          revh2w_op       = 0x10,
>>          revhd_op        = 0x11,
>> +       iocsrrdb_op     = 0x19200,
>> +       iocsrrdh_op     = 0x19201,
>> +       iocsrrdw_op     = 0x19202,
>> +       iocsrrdd_op     = 0x19203,
>> +       iocsrwrb_op     = 0x19204,
>> +       iocsrwrh_op     = 0x19205,
>> +       iocsrwrw_op     = 0x19206,
>> +       iocsrwrd_op     = 0x19207,
>>   };
>>
>>   enum reg2i5_op {
>> @@ -298,6 +306,13 @@ struct reg3sa2_format {
>>          unsigned int opcode : 15;
>>   };
>>
>> +struct reg2csr_format {
>> +       unsigned int rd : 5;
>> +       unsigned int rj : 5;
>> +       unsigned int csr : 14;
>> +       unsigned int opcode : 8;
>> +};
> Put it before reg3_format.
Thanks, I will re-order it.
>
>> +
>>   union loongarch_instruction {
>>          unsigned int word;
>>          struct reg0i15_format   reg0i15_format;
>> @@ -313,6 +328,7 @@ union loongarch_instruction {
>>          struct reg2bstrd_format reg2bstrd_format;
>>          struct reg3_format      reg3_format;
>>          struct reg3sa2_format   reg3sa2_format;
>> +       struct reg2csr_format   reg2csr_format;
> The same, thanks.
>
> Huacai
I will exchange them too.

Thanks
Tianrui Zhao
>>   };
>>
>>   #define LOONGARCH_INSN_SIZE    sizeof(union loongarch_instruction)
>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>> index 18635333fc9a..32edd915ebcb 100644
>> --- a/arch/loongarch/kvm/exit.c
>> +++ b/arch/loongarch/kvm/exit.c
>> @@ -96,3 +96,95 @@ static int _kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
>>
>>          return EMULATE_DONE;
>>   }
>> +
>> +int _kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
>> +{
>> +       u32 rd, rj, opcode;
>> +       u32 addr;
>> +       unsigned long val;
>> +       int ret;
>> +
>> +       /*
>> +        * Each IOCSR with different opcode
>> +        */
>> +       rd = inst.reg2_format.rd;
>> +       rj = inst.reg2_format.rj;
>> +       opcode = inst.reg2_format.opcode;
>> +       addr = vcpu->arch.gprs[rj];
>> +       ret = EMULATE_DO_IOCSR;
>> +       run->iocsr_io.phys_addr = addr;
>> +       run->iocsr_io.is_write = 0;
>> +
>> +       /* LoongArch is Little endian */
>> +       switch (opcode) {
>> +       case iocsrrdb_op:
>> +               run->iocsr_io.len = 1;
>> +               break;
>> +       case iocsrrdh_op:
>> +               run->iocsr_io.len = 2;
>> +               break;
>> +       case iocsrrdw_op:
>> +               run->iocsr_io.len = 4;
>> +               break;
>> +       case iocsrrdd_op:
>> +               run->iocsr_io.len = 8;
>> +               break;
>> +       case iocsrwrb_op:
>> +               run->iocsr_io.len = 1;
>> +               run->iocsr_io.is_write = 1;
>> +               break;
>> +       case iocsrwrh_op:
>> +               run->iocsr_io.len = 2;
>> +               run->iocsr_io.is_write = 1;
>> +               break;
>> +       case iocsrwrw_op:
>> +               run->iocsr_io.len = 4;
>> +               run->iocsr_io.is_write = 1;
>> +               break;
>> +       case iocsrwrd_op:
>> +               run->iocsr_io.len = 8;
>> +               run->iocsr_io.is_write = 1;
>> +               break;
>> +       default:
>> +               ret = EMULATE_FAIL;
>> +               break;
>> +       }
>> +
>> +       if (ret == EMULATE_DO_IOCSR) {
>> +               if (run->iocsr_io.is_write) {
>> +                       val = vcpu->arch.gprs[rd];
>> +                       memcpy(run->iocsr_io.data, &val, run->iocsr_io.len);
>> +               }
>> +               vcpu->arch.io_gpr = rd;
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +int _kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +{
>> +       unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
>> +       enum emulation_result er = EMULATE_DONE;
>> +
>> +       switch (run->iocsr_io.len) {
>> +       case 8:
>> +               *gpr = *(s64 *)run->iocsr_io.data;
>> +               break;
>> +       case 4:
>> +               *gpr = *(int *)run->iocsr_io.data;
>> +               break;
>> +       case 2:
>> +               *gpr = *(short *)run->iocsr_io.data;
>> +               break;
>> +       case 1:
>> +               *gpr = *(char *) run->iocsr_io.data;
>> +               break;
>> +       default:
>> +               kvm_err("Bad IOCSR length: %d,addr is 0x%lx",
>> +                               run->iocsr_io.len, vcpu->arch.badv);
>> +               er = EMULATE_FAIL;
>> +               break;
>> +       }
>> +
>> +       return er;
>> +}
>> --
>> 2.39.1
>>
>>

