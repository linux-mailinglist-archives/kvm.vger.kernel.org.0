Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA25372358C
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 05:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbjFFDAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 23:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjFFDAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 23:00:00 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A33C102;
        Mon,  5 Jun 2023 19:59:58 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.86])
        by gateway (Coremail) with SMTP id _____8AxyvEsoX5kOFkAAA--.1329S3;
        Tue, 06 Jun 2023 10:59:56 +0800 (CST)
Received: from [10.20.42.86] (unknown [10.20.42.86])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxNeQroX5k26oBAA--.7388S3;
        Tue, 06 Jun 2023 10:59:56 +0800 (CST)
Subject: Re: [PATCH v12 20/31] LoongArch: KVM: Implement handle csr excption
To:     "bibo, mao" <maobibo@loongson.cn>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-21-zhaotianrui@loongson.cn>
 <4831764b-c53a-188f-cdd2-6764c76fc627@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <6c44a0d7-d6c0-95c6-3959-f423040c3e08@loongson.cn>
Date:   Tue, 6 Jun 2023 10:59:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <4831764b-c53a-188f-cdd2-6764c76fc627@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxNeQroX5k26oBAA--.7388S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxCFWDAw1fCFyrGF1fArW8AFc_yoWrJF1DpF
        ykC3W5Ca18Xw1xt34SqrsIqFn8Xr95Gr12yFW7ta45ZwnFyr1fGFWkKryDur1DtFs3XF1I
        vay5trn3CFs0yFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4Xo7DU
        UUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年06月06日 09:35, bibo, mao 写道:
>
> 在 2023/5/30 09:52, Tianrui Zhao 写道:
>> Implement kvm handle LoongArch vcpu exit caused by reading and
>> writing csr. Using csr structure to emulate the registers.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/kvm/exit.c | 98 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 98 insertions(+)
>>   create mode 100644 arch/loongarch/kvm/exit.c
>>
>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>> new file mode 100644
>> index 000000000000..508cbce31aa5
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/exit.c
>> @@ -0,0 +1,98 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/err.h>
>> +#include <linux/module.h>
>> +#include <linux/preempt.h>
>> +#include <linux/vmalloc.h>
>> +#include <asm/fpu.h>
>> +#include <asm/inst.h>
>> +#include <asm/time.h>
>> +#include <asm/tlb.h>
>> +#include <asm/loongarch.h>
>> +#include <asm/numa.h>
>> +#include <asm/kvm_vcpu.h>
>> +#include <asm/kvm_csr.h>
>> +#include <linux/kvm_host.h>
>> +#include <asm/mmzone.h>
>> +#include "trace.h"
>> +
>> +static unsigned long _kvm_emu_read_csr(struct kvm_vcpu *vcpu, int csrid)
>> +{
>> +	struct loongarch_csrs *csr = vcpu->arch.csr;
>> +	unsigned long val = 0;
>> +
>> +	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR))
>> +		val = kvm_read_sw_gcsr(csr, csrid);
>> +	else
>> +		pr_warn_once("Unsupport csrread 0x%x with pc %lx\n",
>> +			csrid, vcpu->arch.pc);
>> +	return val;
>> +}
> can 4096 be replace with macro, or be wrapped in function get_gcsr_flag and add GCSR_VALID flag?
Thanks, I will wrap the condition "csr < 4096" in the get_gcsr_flag 
function.

Thanks
Tianrui Zhao
>> +
>> +static void _kvm_emu_write_csr(struct kvm_vcpu *vcpu, int csrid,
>> +	unsigned long val)
>> +{
>> +	struct loongarch_csrs *csr = vcpu->arch.csr;
>> +
>> +	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR))
>> +		kvm_write_sw_gcsr(csr, csrid, val);
>> +	else
>> +		pr_warn_once("Unsupport csrwrite 0x%x with pc %lx\n",
>> +				csrid, vcpu->arch.pc);
>> +}
> ditto
>
>> +
>> +static void _kvm_emu_xchg_csr(struct kvm_vcpu *vcpu, int csrid,
>> +	unsigned long csr_mask, unsigned long val)
>> +{
>> +	struct loongarch_csrs *csr = vcpu->arch.csr;
>> +
>> +	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR)) {
>> +		unsigned long orig;
>> +
>> +		orig = kvm_read_sw_gcsr(csr, csrid);
>> +		orig &= ~csr_mask;
>> +		orig |= val & csr_mask;
>> +		kvm_write_sw_gcsr(csr, csrid, orig);
>> +	} else
>> +		pr_warn_once("Unsupport csrxchg 0x%x with pc %lx\n",
>> +				csrid, vcpu->arch.pc);
>> +}
> ditto
>
> Regards
> Bibo, Mao
>> +
>> +static int _kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
>> +{
>> +	unsigned int rd, rj, csrid;
>> +	unsigned long csr_mask;
>> +	unsigned long val = 0;
>> +
>> +	/*
>> +	 * CSR value mask imm
>> +	 * rj = 0 means csrrd
>> +	 * rj = 1 means csrwr
>> +	 * rj != 0,1 means csrxchg
>> +	 */
>> +	rd = inst.reg2csr_format.rd;
>> +	rj = inst.reg2csr_format.rj;
>> +	csrid = inst.reg2csr_format.csr;
>> +
>> +	/* Process CSR ops */
>> +	if (rj == 0) {
>> +		/* process csrrd */
>> +		val = _kvm_emu_read_csr(vcpu, csrid);
>> +		vcpu->arch.gprs[rd] = val;
>> +	} else if (rj == 1) {
>> +		/* process csrwr */
>> +		val = vcpu->arch.gprs[rd];
>> +		_kvm_emu_write_csr(vcpu, csrid, val);
>> +	} else {
>> +		/* process csrxchg */
>> +		val = vcpu->arch.gprs[rd];
>> +		csr_mask = vcpu->arch.gprs[rj];
>> +		_kvm_emu_xchg_csr(vcpu, csrid, csr_mask, val);
>> +	}
>> +
>> +	return EMULATE_DONE;
>> +}

