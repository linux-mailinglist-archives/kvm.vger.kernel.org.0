Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107C569E0F1
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 14:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbjBUNAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 08:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbjBUNAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 08:00:33 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6396317CE9;
        Tue, 21 Feb 2023 05:00:29 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8Axkk5rwPRjuigDAA--.989S3;
        Tue, 21 Feb 2023 21:00:27 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx2r1qwPRjncI3AA--.36473S3;
        Tue, 21 Feb 2023 21:00:26 +0800 (CST)
Subject: Re: [PATCH v2 27/29] LoongArch: KVM: Implement vcpu world switch
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-28-zhaotianrui@loongson.cn>
 <50575db8-efb8-2d56-5dd9-fe4318db2af3@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <e33bbe6b-fb21-7473-cb8a-5068b44f21ce@loongson.cn>
Date:   Tue, 21 Feb 2023 21:00:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <50575db8-efb8-2d56-5dd9-fe4318db2af3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cx2r1qwPRjncI3AA--.36473S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7KFyDCF1Utw43GrWkAr45Awb_yoW8uFWxp3
        y8JrZIyFyUKrs7uF4vvrWUWw4IqF4fWr4Igrn8Wr18urykWFW0vF1UKF1DK347tr18XF1U
        ZF4rJr17ArsrA3DanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0owAa
        w2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2
        jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU28nYUUUUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年02月21日 15:45, Paolo Bonzini 写道:
> On 2/20/23 07:57, Tianrui Zhao wrote:
>> +    /* Load Guest gprs */
>> +    ld.d    $r1,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 1)
>> +    ld.d    $r2,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 2)
>> +    ld.d    $r3,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 3)
>> +    ld.d    $r4,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 4)
>> +    ld.d    $r5,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 5)
>> +    ld.d    $r7,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 7)
>> +    ld.d    $r8,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 8)
>> +    ld.d    $r9,   \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 9)
>> +    ld.d    $r10,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 10)
>> +    ld.d    $r11,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 11)
>> +    ld.d    $r12,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 12)
>> +    ld.d    $r13,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 13)
>> +    ld.d    $r14,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 14)
>> +    ld.d    $r15,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 15)
>> +    ld.d    $r16,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 16)
>> +    ld.d    $r17,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 17)
>> +    ld.d    $r18,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 18)
>> +    ld.d    $r19,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 19)
>> +    ld.d    $r20,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 20)
>> +    ld.d    $r21,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 21)
>> +    ld.d    $r22,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 22)
>> +    ld.d    $r23,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 23)
>> +    ld.d    $r24,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 24)
>> +    ld.d    $r25,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 25)
>> +    ld.d    $r26,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 26)
>> +    ld.d    $r27,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 27)
>> +    ld.d    $r28,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 28)
>> +    ld.d    $r29,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 29)
>> +    ld.d    $r30,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 30)
>> +    ld.d    $r31,  \KVM_ARCH,  (KVM_ARCH_GGPR + 8 * 31)
>> +    /* Load KVM_ARCH register */
>> +    ld.d    \KVM_ARCH, \KVM_ARCH, (KVM_ARCH_GGPR + 8 * \GPRNUM)
>
> This in practice relies on KVM_ARCH being a2 so please remove the 
> KVM_ARCH and GPRNUM arguments from the macro; just replace \KVM_ARCH 
> with a2 as needed.
>
> Also, in these ld.d and st.d sequences you may want to use the ABI 
> names instead of the rNN names, so it's clearer that you are skipping 
> the KVM_ARCH register.
>
> Paolo

Thanks, I will use a2 to replace the KVM_ARCH and remove the GPRNUM 
argument.

Thanks
Tianrui Zhao


