Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3C96149A9
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 12:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiKALng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 07:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiKALnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 07:43:20 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B392820F5C
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 04:35:52 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N1nvF6CZ2zJnN7;
        Tue,  1 Nov 2022 19:32:57 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 19:35:50 +0800
Subject: Re: [PATCH v2] KVM: x86: fix undefined behavior in bit shift for
 __feature_bit
To:     Peter Zijlstra <peterz@infradead.org>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>
References: <20221101022828.565075-1-cuigaosheng1@huawei.com>
 <Y2DchcVrZIMfk8Fv@hirez.programming.kicks-ass.net>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <96c87b1e-2297-2eb6-0475-a773d7f5a214@huawei.com>
Date:   Tue, 1 Nov 2022 19:35:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <Y2DchcVrZIMfk8Fv@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Again; please go fix your toolchain and don't quote broken crap like
> this to change the code.
>
> I'm fine with the changes, but there is no UB here, don't pretend there
> is.

I have made patch v3 and submitted it, removed the UBSAN warning calltrace,
thanks for taking time review patch!

On 2022/11/1 16:44, Peter Zijlstra wrote:
> On Tue, Nov 01, 2022 at 10:28:28AM +0800, Gaosheng Cui wrote:
>> Shifting signed 32-bit value by 31 bits is undefined, so we fix it
>> with the BIT() macro, at the same time, we change the input to
>> unsigned, and replace "/ 32" with ">> 5".
>>
>> The UBSAN warning calltrace like below:
>>
>> UBSAN: shift-out-of-bounds in arch/x86/kvm/reverse_cpuid.h:101:11
>> left shift of 1 by 31 places cannot be represented in type 'int'
> Again; please go fix your toolchain and don't quote broken crap like
> this to change the code.
>
> I'm fine with the changes, but there is no UB here, don't pretend there
> is.
>
> .
