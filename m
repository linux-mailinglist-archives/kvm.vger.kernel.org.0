Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6F9755ECA
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 10:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjGQIxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 04:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjGQIxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 04:53:17 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A566D1AE
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 01:53:15 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C93CD75;
        Mon, 17 Jul 2023 01:53:58 -0700 (PDT)
Received: from [10.57.28.142] (unknown [10.57.28.142])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 73AD93F73F;
        Mon, 17 Jul 2023 01:53:14 -0700 (PDT)
Message-ID: <8d4c1105-bf9b-d4b0-a2a3-be306474bf56@arm.com>
Date:   Mon, 17 Jul 2023 09:53:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>,
        Nadav Amit <namit@vmware.com>
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
 <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
 <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
 <57A6ABC7-8A95-4199-92E3-FA4D89D6705F@vmware.com>
 <20230717-52b1cacc323e5105506e5079@orel>
 <20230717-085f1ee1d631f213544fed03@orel>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230717-085f1ee1d631f213544fed03@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/2023 07:52, Andrew Jones wrote:
> On Mon, Jul 17, 2023 at 08:50:30AM +0200, Andrew Jones wrote:
>> On Fri, Jul 14, 2023 at 06:42:25PM +0000, Nadav Amit wrote:
>>>
>>>
>>>> On Jul 14, 2023, at 4:29 AM, Shaoqin Huang <shahuang@redhat.com> wrote:
>>>>
>>>> !! External Email
>>>>
>>>> Hi,
>>>>
>>>> On 7/14/23 18:31, Alexandru Elisei wrote:
>>>>> Hi,
>>>>>
>>>>> On Sat, Jun 17, 2023 at 01:31:37AM +0000, Nadav Amit wrote:
>>>>>> From: Nadav Amit <namit@vmware.com>
>>>>>>
>>>>>> Do not assume PAN is not supported or that sctlr_el1.SPAN is already set.
>>>>>
>>>>> In arm/cstart64.S
>>>>>
>>>>> .globl start
>>>>> start:
>>>>>          /* get our base address */
>>>>>       [..]
>>>>>
>>>>> 1:
>>>>>          /* zero BSS */
>>>>>       [..]
>>>>>
>>>>>          /* zero and set up stack */
>>>>>       [..]
>>>>>
>>>>>          /* set SCTLR_EL1 to a known value */
>>>>>          ldr     x4, =INIT_SCTLR_EL1_MMU_OFF
>>>>>       [..]
>>>>>
>>>>>          /* set up exception handling */
>>>>>          bl      exceptions_init
>>>>>       [..]
>>>>>
>>>>> Where in lib/arm64/asm/sysreg.h:
>>>>>
>>>>> #define SCTLR_EL1_RES1  (_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
>>>>>                           _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
>>>>> #define INIT_SCTLR_EL1_MMU_OFF  \
>>>>>                          SCTLR_EL1_RES1
>>>>>
>>>>> Look like bit 23 (SPAN) should be set.
>>>>>
>>>>> How are you seeing SCTLR_EL1.SPAN unset?
>>>>
>>>> Yeah. the sctlr_el1.SPAN has always been set by the above flow. So Nadav
>>>> you can describe what you encounter with more details. Like which tests
>>>> crash you encounter, and how to reproduce it.
>>>
>>> I am using Nikos’s work to run the test using EFI, not from QEMU.
>>>
>>> So the code that you mentioned - which is supposed to initialize SCTLR -
>>> is not executed (and actually not part of the EFI image).
>>>
>>> Note that using EFI, the entry point is _start [1], and not “start”.
>>>
>>> That is also the reason lack of BSS zeroing also caused me issues with the
>>> EFI setup, which I reported before.
>>
>> Nadav,
>>
>> Would you mind reposting this along with the BSS zeroing patch, the
>> way I proposed we do that, and anything else you've discovered when
>> trying to use the EFI unit tests without QEMU? We'll call that our
>> first non-QEMU EFI support series, since the first EFI series was
>> only targeting QEMU.
> 
> Oh, and I meant to mention that, when reposting this patch, maybe we
> can consider managing sctlr in a similar way to the non-efi start path?
> 

Nadav, if you are running baremetal, it might be worth checking what EL 
you're running in as well. If HW is implementing EL2, EFI will handover 
in EL2.

I was planning to rebase an old patch (more like rewrite it) but I 
haven't found the time yet [1]. If I remember correctly, we have to 
check what EL we're running in and if it's EL2 we have to add a stub 
EL2, drop to EL1 and setup EL1. But things have change since that patch 
and with the new structure, I am not sure if we would drop to EL1 right 
at the start (crt0-efi-aarch64.S) or somewhere in setup_efi().

In general, I think, it would be easier to deal with this in QEMU 
(-machine secure=on) and before we even start thinking about real 
hardware where it is very likely that we will have to address other 
issues (such as the problem with the BSS, cache maintenance) as well.

[1]: 
https://github.com/relokin/kvm-unit-tests/commit/1468abeee7be1d85140ed92cb91a42ee27a9bf1f

Thanks,

Nikos
