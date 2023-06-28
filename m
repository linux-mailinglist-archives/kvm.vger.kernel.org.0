Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBC6740E72
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 12:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjF1KN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 06:13:59 -0400
Received: from mail.loongson.cn ([114.242.206.163]:60946 "EHLO
        mail.loongson.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjF1KLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 06:11:38 -0400
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Axy8ZYB5xkWXADAA--.5475S3;
        Wed, 28 Jun 2023 18:11:36 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxF8xXB5xkuyUOAA--.13135S3;
        Wed, 28 Jun 2023 18:11:35 +0800 (CST)
Message-ID: <30261345-45de-8511-e285-fe16ee408ba1@loongson.cn>
Date:   Wed, 28 Jun 2023 18:11:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v15 27/30] LoongArch: KVM: Implement vcpu world switch
Content-Language: en-US
To:     WANG Xuerui <kernel@xen0n.name>,
        zhaotianrui <zhaotianrui@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
References: <20230626084752.1138621-1-zhaotianrui@loongson.cn>
 <20230626084752.1138621-28-zhaotianrui@loongson.cn>
 <f648a182-7c26-5bbc-6ae5-584af26e9db1@loongson.cn>
 <7017277c-3721-b417-5215-491efae7c8a9@loongson.cn>
 <cfc87f85-3a09-8a9e-4258-4fb1fd8013ab@xen0n.name>
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <cfc87f85-3a09-8a9e-4258-4fb1fd8013ab@xen0n.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxF8xXB5xkuyUOAA--.13135S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGry3CF4kKrWfXw15XrWUtrc_yoW5WFy5pF
        18AFW3GrZ8Jrs5Gw1UK3WUZF9ayF18ta15Xr1Fqa45A348Kwn2gF10gr1q9F1fJw4rJryj
        9r4jqws7ZF13AFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_GFv_Wrylx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUU
        UU=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/6/28 17:51, WANG Xuerui 写道:
> Hi,
> 
> On 2023/6/28 16:34, zhaotianrui wrote:
>>
>> 在 2023/6/28 上午11:42, Jinyang He 写道:
>>> On 2023-06-26 16:47, Tianrui Zhao wrote:
>>>
>>>> [snip]
>>>
>>>> +    ldx.d   t0, t1, t0
>>>> +    csrwr    t0, LOONGARCH_CSR_PGDL
>>>> +
>>>> +    /* Mix GID and RID */
>>>> +    csrrd        t1, LOONGARCH_CSR_GSTAT
>>>> +    bstrpick.w    t1, t1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SHIFT
>>>> +    csrrd        t0, LOONGARCH_CSR_GTLBC
>>>> +    bstrins.w    t0, t1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
>>>> +    csrwr        t0, LOONGARCH_CSR_GTLBC
>>>> +
>>>> +    /*
>>>> +     * Switch to guest:
>>>> +     *  GSTAT.PGM = 1, ERRCTL.ISERR = 0, TLBRPRMD.ISTLBR = 0
>>>> +     *  ertn
>>>> +     */
>>>> +
>>>> +    /*
>>>> +     * Enable intr in root mode with future ertn so that host interrupt
>>>> +     * can be responsed during VM runs
>>>> +     * guest crmd comes from separate gcsr_CRMD register
>>>> +     */
>>>> +    ori    t0, zero, CSR_PRMD_PIE
>>> li.w t0, CSR_PRMD_PIE
>> Thanks for your advice, and I think it need not to replace it with "li.w" there, as it has the same meaning with "ori" instruction, and "ori" instruction is simple and clear enough. The same as the following "move" instructions. What do you think of it.
> 
> Just my 2c: I'd agree that pseudo-instructions should be used wherever possible and helping readability.
"lu12i.w+srli.w" can be replaced by "li.w t0, KVM_GPGD" 
we accept the suggestion two instructions should be replaced with pseudo-instruction.

For the instruction "ori    t0, zero, CSR_PRMD_PIE"
what is advantage of this pseudo-instruction
    li.w t0, CSR_PRMD_PIE

is "ori t0, zero, CSR_PRMD_PIE" hard to understand? It is basic arithmetic instr and easy to understand also. To be frank I do not see the advantage of using li.w, also there is no document that pseudo-instruction should be used with high priority.

Regards
Bibo Mao
> 
> FYI there were similar usages way before, but all were cleaned up with my previous commit 57ce5d3eefac ("LoongArch: Use the "move" pseudo-instruction where applicable").
> 
> Such usages apparently came from an era when the LoongArch toolchains didn't support any pseudo-instruction, and are less intuitive especially for someone not familiar with LoongArch assembly. Given that familiarity with LoongArch won't be widespread (unlike with e.g. RISC-V that are adopted more widely), we should optimize for readability when writing code; it's also a best practice in general because code is read way more often than written, and people care about semantics not unnecessary details like "how are moves like this or that materialized".
> 

