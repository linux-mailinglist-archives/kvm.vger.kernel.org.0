Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A94064F063
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 18:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiLPRaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 12:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiLPRa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 12:30:26 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20427379E7
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 09:30:24 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p6EXM-004Rhp-Tp; Fri, 16 Dec 2022 18:30:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=bBQzfb3no7iU+hlwfH4aL2FU1w+CFBThCxsBfRtmHIo=; b=ewr89GG+Js5e/x/a6K2CxbzSve
        fCt54ybzI/aGeksWIyNV9VwXt/nRf8B5FXGCJI2RapLXVTbklsFXitbfrzuqcZdNvvoktkP9h3/3j
        ALucYb3SmSizddoh17nCrTinIl/LNw2sQNSo8YTuLKrnRcUN4wjcZdLkCYmOMC8TEijJ8iRXNU8GQ
        FkbkZAbWlXRlEtyLLbC/utke7ikmSrxkevrb5o7XhsgMvHC9wpEmUSx3SFEtVwOu0t51WrH3eKHyM
        CfIInGcDfSPL4zZegj6auvqhyu2L/M5+dJb0AGcAp3pKAbNPQBt9xhDndJU+ZkPzFBPYK1U3gEsWs
        6GbP9QPQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p6EXB-0001FH-Lm; Fri, 16 Dec 2022 18:30:09 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p6EX1-0000Ku-5k; Fri, 16 Dec 2022 18:29:59 +0100
Message-ID: <eece8595-0791-a646-6d4e-936eea481ec0@rbox.co>
Date:   Fri, 16 Dec 2022 18:29:57 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH v4 1/2] KVM: MMU: Introduce 'INVALID_GFN' and use it for
 GFN values
Content-Language: pl-PL
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org,
        dwmw2@infradead.org, paul@xen.org
References: <20221216085928.1671901-1-yu.c.zhang@linux.intel.com>
 <20221216085928.1671901-2-yu.c.zhang@linux.intel.com>
 <f2fbe2ec-cf8e-7cb3-748d-b7ad753cc455@rbox.co> <Y5yZ6CFkEMBqyJ6v@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <Y5yZ6CFkEMBqyJ6v@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/22 17:16, Sean Christopherson wrote:
> On Fri, Dec 16, 2022, Michal Luczaj wrote:
>> On 12/16/22 09:59, Yu Zhang wrote:
>>> +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
>>> @@ -20,7 +20,7 @@
>>>  #include <sys/eventfd.h>
>>>  
>>>  /* Defined in include/linux/kvm_types.h */
>>> -#define GPA_INVALID		(~(ulong)0)
>>> +#define INVALID_GFN		(~(ulong)0)
>>
>>
>> Thank you for fixing the selftest!
>>
>> Regarding xen_shinfo_test.c, a question to maintainers, would it be ok if I
>> submit a simple patch fixing the misnamed cache_init/cache_destroy =>
>> cache_activate/cache_deactivate or it's just not worth the churn now?
> 
> It's not too much churn.  My only hesitation would be that chasing KVM names is
> usually a fruitless endeavor, but in this case I agree (de)activate is better
> terminology even if KVM changes again in the future.

All right, I'll send the fix after Yu's patches land in queue.

Thanks,
Michal

