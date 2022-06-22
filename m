Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F509554BA8
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 15:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbiFVNr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 09:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiFVNrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 09:47:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF2A427CE4
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 06:47:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5C9F1042;
        Wed, 22 Jun 2022 06:47:24 -0700 (PDT)
Received: from [10.1.39.31] (Q2TWYV475D.cambridge.arm.com [10.1.39.31])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C02643F792;
        Wed, 22 Jun 2022 06:47:23 -0700 (PDT)
Message-ID: <8bc4e400-f507-d174-204a-1f243e4201ee@arm.com>
Date:   Wed, 22 Jun 2022 14:47:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 21/23] x86: Move x86_64-specific EFI
 CFLAGS to x86_64 Makefile
Content-Language: en-GB
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-22-nikos.nikoleris@arm.com>
 <YrJJ9xDhOWDI7dOV@google.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <YrJJ9xDhOWDI7dOV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 21/06/2022 23:45, Ricardo Koller wrote:
> On Fri, May 06, 2022 at 09:56:03PM +0100, Nikos Nikoleris wrote:
>> Compiler flag -macculate-outgoing-args is only needed by the x86_64
>> ABI. Move it to the relevant Makefile.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   Makefile            | 4 ----
>>   x86/Makefile.x86_64 | 4 ++++
>>   2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 6ed5dea..307bc29 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -40,14 +40,10 @@ OBJDIRS += $(LIBFDT_objdir)
>>   
>>   # EFI App
>>   ifeq ($(CONFIG_EFI),y)
>> -EFI_ARCH = x86_64
> 
> Should this be moved to the x86 Makefile as well? (just in case)

I searched for uses of EFI_ARCH and I couldn't find any. It would be 
good if people more familiar with x86 would approve this though.

Thanks,

Nikos

> 
>>   EFI_CFLAGS := -DCONFIG_EFI
>>   # The following CFLAGS and LDFLAGS come from:
>>   #   - GNU-EFI/Makefile.defaults
>>   #   - GNU-EFI/apps/Makefile
>> -# Function calls must include the number of arguments passed to the functions
>> -# More details: https://wiki.osdev.org/GNU-EFI
>> -EFI_CFLAGS += -maccumulate-outgoing-args
>>   # GCC defines wchar to be 32 bits, but EFI expects 16 bits
>>   EFI_CFLAGS += -fshort-wchar
>>   # EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
>> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
>> index f18c1e2..ac588ed 100644
>> --- a/x86/Makefile.x86_64
>> +++ b/x86/Makefile.x86_64
>> @@ -2,6 +2,10 @@ cstart.o = $(TEST_DIR)/cstart64.o
>>   bits = 64
>>   ldarch = elf64-x86-64
>>   ifeq ($(CONFIG_EFI),y)
>> +# Function calls must include the number of arguments passed to the functions
>> +# More details: https://wiki.osdev.org/GNU-EFI
>> +CFLAGS += -maccumulate-outgoing-args
>> +
>>   exe = efi
>>   bin = so
>>   FORMAT = efi-app-x86_64
>> -- 
>> 2.25.1
>>
> 
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
