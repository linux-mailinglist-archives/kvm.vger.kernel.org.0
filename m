Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B0CF48D
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 10:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbfJHIGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 04:06:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730414AbfJHIGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 04:06:08 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 42FE0AF6A3E762B4E9AC;
        Tue,  8 Oct 2019 16:06:04 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 8 Oct 2019
 16:05:54 +0800
Subject: Re: [PATCH v18 5/6] target-arm: kvm64: inject synchronous External
 Abort
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        "QEMU Developers" <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20190906083152.25716-1-zhengxiang9@huawei.com>
 <20190906083152.25716-6-zhengxiang9@huawei.com>
 <CAFEAcA-xc2XUq2Kwa1cK=4sAMq8B-2jUFAmxiGOQbmRCp-+UmQ@mail.gmail.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <76f33d58-d9b5-3a68-ecfa-72fd0d7eb445@huawei.com>
Date:   Tue, 8 Oct 2019 16:05:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-xc2XUq2Kwa1cK=4sAMq8B-2jUFAmxiGOQbmRCp-+UmQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/9/27 21:33, Peter Maydell wrote:
> On Fri, 6 Sep 2019 at 09:33, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>>
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> Introduce kvm_inject_arm_sea() function in which we will setup the type
>> of exception and the syndrome information in order to inject a virtual
>> synchronous external abort. When switching to guest, it will jump to the
>> synchronous external abort vector table entry.
>>
>> The ESR_ELx.DFSC is set to synchronous external abort(0x10), and
>> ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
>> not valid and hold an UNKNOWN value. These values will be set to KVM
>> register structures through KVM_SET_ONE_REG IOCTL.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> 
>> +/* Inject synchronous external abort */
>> +static void kvm_inject_arm_sea(CPUState *c)
> 
> This will cause a compilation failure at this point in
> the patch series, because the compiler will complain about
> a static function which is defined but never used.
> To avoid breaking bisection, we need to put the definition
> of the function in the same patch where it's used.

Thanks, I will merge this patch with the next patch.

> 
>> +{
>> +    ARMCPU *cpu = ARM_CPU(c);
>> +    CPUARMState *env = &cpu->env;
>> +    CPUClass *cc = CPU_GET_CLASS(c);
>> +    uint32_t esr;
>> +    bool same_el;
>> +
>> +    /**
>> +     * Set the exception type to synchronous data abort
>> +     * and the target exception Level to EL1.
>> +     */
> 
> This comment doesn't really tell us anything that's not obvious
> from the two lines of code that it's commenting on:

Yes, I will remove this comment.

> 
>> +    c->exception_index = EXCP_DATA_ABORT;
>> +    env->exception.target_el = 1;
>> +
>> +    /*
>> +     * Set the DFSC to synchronous external abort and set FnV to not valid,
>> +     * this will tell guest the FAR_ELx is UNKNOWN for this abort.
>> +     */
>> +
>> +    /* This exception comes from lower or current exception level. */
> 
> This comment too is stating the obvious I think.

I will remove it too.

> 
>> +    same_el = arm_current_el(env) == env->exception.target_el;
>> +    esr = syn_data_abort_no_iss(same_el, 1, 0, 0, 0, 0, 0x10);
>> +
>> +    env->exception.syndrome = esr;
>> +
>> +    /**
> 
> There's a stray second '*' in this comment-start.

OK, I will remove this stray '*'.

> 
> 
>> +     * The vcpu thread already hold BQL, so no need hold again when
>> +     * calling do_interrupt
> 
> I think this requirement would be better placed as a
> comment at the top of the function noting that callers
> must hold the iothread lock.

OK, I will add the comment at the top of the function.

> 
>> +     */
>> +    cc->do_interrupt(c);
>> +}
>> +
>>  #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
>>                   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
>>
>> diff --git a/target/arm/tlb_helper.c b/target/arm/tlb_helper.c
>> index 5feb312941..499672ebbc 100644
>> --- a/target/arm/tlb_helper.c
>> +++ b/target/arm/tlb_helper.c
>> @@ -33,7 +33,7 @@ static inline uint32_t merge_syn_data_abort(uint32_t template_syn,
>>       * ISV field.
>>       */
>>      if (!(template_syn & ARM_EL_ISV) || target_el != 2 || s1ptw) {
>> -        syn = syn_data_abort_no_iss(same_el,
>> +        syn = syn_data_abort_no_iss(same_el, 0,
>>                                      ea, 0, s1ptw, is_write, fsc);
>>      } else {
>>          /*
>> --
>> 2.19.1
> 
> thanks
> -- PMM
> 
> .
> 

-- 

Thanks,
Xiang

