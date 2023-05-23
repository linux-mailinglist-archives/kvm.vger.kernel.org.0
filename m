Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9063F70D998
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 11:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbjEWJxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 05:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjEWJx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 05:53:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC1D0171F
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 02:52:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88940139F;
        Tue, 23 May 2023 02:53:24 -0700 (PDT)
Received: from [192.168.5.13] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD0463F6C4;
        Tue, 23 May 2023 02:52:38 -0700 (PDT)
Message-ID: <cbda3543-1cad-b05b-1188-e0ecba6f302d@arm.com>
Date:   Tue, 23 May 2023 10:52:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH] arm64: Make vector_table and vector_stub
 weak symbols
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, luc.maranget@inria.fr,
        Jade Alglave <Jade.Alglave@arm.com>
References: <20230515221517.646549-1-nikos.nikoleris@arm.com>
 <20230518-d8bd66e7bf671f5df706a216@orel>
 <032397f4-62d2-add3-f7d5-0377e125454a@arm.com>
 <20230523-3729e940652cc3b2b753cb8d@orel>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230523-3729e940652cc3b2b753cb8d@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/05/2023 09:56, Andrew Jones wrote:
> On Mon, May 22, 2023 at 02:54:14PM +0100, Nikos Nikoleris wrote:
>> On 18/05/2023 17:06, Andrew Jones wrote:
>>> On Mon, May 15, 2023 at 11:15:17PM +0100, Nikos Nikoleris wrote:
>>>> This changes allows a test to define and override the declared symbols,
>>>> taking control of the whole vector_table or a vector_stub.
>>>
>>> Hi Nikos,
>>>
>>> Can you add some motivation for this change to the commit message or
>>> submit it along with some test that needs it?
>>>
>>
>> Hi Drew,
>>
>> Thanks for reviewing this.
>>
>> What do you think about adding the following to the commit message?
>>
>>> With the ability to override specific exception handlers, litmus7
>>> [1] a tool used to generate c sources for a given memory model
>>> litmus test, can override the el1h_sync symbol to implement tests
>>> with explicit exception handlers. For example:
>>>
>>> AArch64 LDRv0+I2V-dsb.ishst
>>> { >   [PTE(x)]=(oa:PA(x),valid:0);
>>>    x=1;
>>>
>>>    0:X1=x;
>>>    0:X3=PTE(x); >   0:X2=(oa:PA(x),valid:1);
>>> }>  P0          | P0.F         ;
>>> L0:          | ADD X8,X8,#1 ;
>>>   LDR W0,[X1] | STR X2,[X3]  ;
>>>               | DSB ISHST    ;
>>>               | ERET         ; > exists(0:X0=0 \/ 0:X8!=1)
>>>
>>> In this test, a thread running in core P0 executes a load to a memory
>>> location x. The PTE of the virtual address x is initially invalid.
>>> The execution of the load causes a synchronous EL1 exception which is
>>> handled by the code in P0.F. P0.F increments a counter which is
>>> maintained in X8, updates the PTE of x and makes it valid, executes a
>>> DSB ISHST and calls ERET which is expected to return and retry the
>>> execution of the load in P0:L0.
>>>
>>> The postcondition checks if there is any execution where the load wasn't
>>> executed (X0 its destination register is not update), or that the P0.F >
>>> handler was invoked more than once (the counter X8 is not 1).
>>>
>>> For this tests, litmus7 needs to control the el1h_sync. Calling
>>> install_exception_handler() would be suboptimal because the vector_stub
>>> would wrap around the code of P0.F and disturb the test.
>>>
>>> [1]: https://diy.inria.fr/doc/litmus.html
>> If you think this is sufficient, I will update the patch.
> 
> The above works for me.
> 
> (Unrelated: Sorry I haven't had a chance to give your latest efi branch
> a test drive. I think you can probably go ahead and post the next version
> of the series, though. That'll help bring it to the forefront for me to
> prioritize.)
> 

Thanks Drew, I'll send a new revision of this patch and the EFI series.

Nikos
