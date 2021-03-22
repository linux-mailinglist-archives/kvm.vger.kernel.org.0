Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB7D343EB2
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 12:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCVK7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 06:59:39 -0400
Received: from foss.arm.com ([217.140.110.172]:57474 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230456AbhCVK7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 06:59:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3262E1063;
        Mon, 22 Mar 2021 03:59:34 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9377A3F718;
        Mon, 22 Mar 2021 03:59:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/4] arm/arm64: Track whether thread_info
 has been initialized
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210319122414.129364-4-nikos.nikoleris@arm.com>
 <9325d09d-aa0b-0715-f013-8926de3673cb@arm.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <80c2632b-4a04-f9b0-9ff9-8403ca1e9451@arm.com>
Date:   Mon, 22 Mar 2021 10:59:31 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <9325d09d-aa0b-0715-f013-8926de3673cb@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 22/03/2021 10:34, Alexandru Elisei wrote:
> Hi Nikos,
> 
> On 3/19/21 12:24 PM, Nikos Nikoleris wrote:
>> Introduce a new flag in the thread_info to track whether a thread_info
>> struct is initialized yet or not.
> 
> There's no explanation why this is needed. The flag checked only by is_user(), and
> before thread_info is initialized, flags is zero, so is_user() would return false,
> right? Or am I missing something?
> 

I am still not sure what's the right approach here. I didn't like and I 
still don't like the fact that we rely on implicit 0 initialization to 
get the right behavior. This will break once we add support for EFI. I 
think we should explicitly initialize thread_info to 0. I was thinking 
of adding a thread_info_alloc() function to do this.

By having this flag I think we can guard accesses to the thread_info in 
general. I didn't want to turn the define smp_processor_id to a function 
here but I think we should and assert that the thread_info is valid and 
avoid reading current_thread_info()->cpu.

Having said that, this would still work without the patch and I am happy 
to drop it if the above doesn't makes sense.

Thanks,

Nikos

> Thanks,
> 
> Alex
> 
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/arm/asm/thread_info.h | 1 +
>>   lib/arm/processor.c       | 5 +++--
>>   lib/arm64/processor.c     | 5 +++--
>>   3 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
>> index eaa7258..926c2a3 100644
>> --- a/lib/arm/asm/thread_info.h
>> +++ b/lib/arm/asm/thread_info.h
>> @@ -45,6 +45,7 @@ static inline void *thread_stack_alloc(void)
>>   }
>>   
>>   #define TIF_USER_MODE		(1U << 0)
>> +#define TIF_VALID		(1U << 1)
>>   
>>   struct thread_info {
>>   	int cpu;
>> diff --git a/lib/arm/processor.c b/lib/arm/processor.c
>> index a2d39a4..702fbc3 100644
>> --- a/lib/arm/processor.c
>> +++ b/lib/arm/processor.c
>> @@ -119,7 +119,7 @@ void thread_info_init(struct thread_info *ti, unsigned int flags)
>>   {
>>   	memset(ti, 0, sizeof(struct thread_info));
>>   	ti->cpu = mpidr_to_cpu(get_mpidr());
>> -	ti->flags = flags;
>> +	ti->flags = flags | TIF_VALID;
>>   }
>>   
>>   void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr)
>> @@ -143,7 +143,8 @@ void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr)
>>   
>>   bool is_user(void)
>>   {
>> -	return current_thread_info()->flags & TIF_USER_MODE;
>> +	struct thread_info *ti = current_thread_info();
>> +	return (ti->flags & TIF_VALID) && (ti->flags & TIF_USER_MODE);
>>   }
>>   
>>   bool __mmu_enabled(void)
>> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
>> index ef55862..231d71e 100644
>> --- a/lib/arm64/processor.c
>> +++ b/lib/arm64/processor.c
>> @@ -227,7 +227,7 @@ static void __thread_info_init(struct thread_info *ti, unsigned int flags)
>>   {
>>   	memset(ti, 0, sizeof(struct thread_info));
>>   	ti->cpu = mpidr_to_cpu(get_mpidr());
>> -	ti->flags = flags;
>> +	ti->flags = flags | TIF_VALID;
>>   }
>>   
>>   void thread_info_init(struct thread_info *ti, unsigned int flags)
>> @@ -255,7 +255,8 @@ void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr)
>>   
>>   bool is_user(void)
>>   {
>> -	return current_thread_info()->flags & TIF_USER_MODE;
>> +	struct thread_info *ti = current_thread_info();
>> +	return (ti->flags & TIF_VALID) && (ti->flags & TIF_USER_MODE);
>>   }
>>   
>>   bool __mmu_enabled(void)
