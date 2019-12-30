Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21E412CDCD
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2019 09:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfL3Iuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Dec 2019 03:50:39 -0500
Received: from foss.arm.com ([217.140.110.172]:53308 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbfL3Iuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Dec 2019 03:50:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93AFF1FB;
        Mon, 30 Dec 2019 00:50:38 -0800 (PST)
Received: from [10.37.8.67] (unknown [10.37.8.67])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACF243F703;
        Mon, 30 Dec 2019 00:50:36 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 08/18] lib: arm: Implement flush_tlb_all
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, mark.rutland@arm.com
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
 <20191128180418.6938-9-alexandru.elisei@arm.com>
 <dc80218c-5833-5495-e52d-d2f65ef7adff@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <75f764da-0d7e-f623-3e25-074bfadc021b@arm.com>
Date:   Mon, 30 Dec 2019 08:50:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <dc80218c-5833-5495-e52d-d2f65ef7adff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 11/28/19 11:24 PM, André Przywara wrote:
> On 28/11/2019 18:04, Alexandru Elisei wrote:
>
> Hi,
>
>> flush_tlb_all performs a TLBIALL, which affects only the executing PE; fix
>> that by executing a TLBIALLIS. Note that virtualization extensions imply
>> the multiprocessing extensions, so we're safe to use that instruction.
>>
>> While we're at it, let's add a comment to flush_dcache_addr stating what
>> instruction is uses (unsurprisingly, it's a dcache clean and invalidate to
>> PoC).
> Good idea, but for people not fluent in ARMish I might be even better to
> actually spell that out there in the comment, also mentioning VA, maybe.
>
> Apart from that this looks good, also checked the encodings.

Sure, I'll explain what the tlb maintenance operation do.

Thanks,
Alex
> Cheers,
> Andre
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm/asm/mmu.h | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
>> index 361f3cdcc3d5..7c9ee3dbc079 100644
>> --- a/lib/arm/asm/mmu.h
>> +++ b/lib/arm/asm/mmu.h
>> @@ -25,8 +25,10 @@ static inline void local_flush_tlb_all(void)
>>  
>>  static inline void flush_tlb_all(void)
>>  {
>> -	//TODO
>> -	local_flush_tlb_all();
>> +	/* TLBIALLIS */
>> +	asm volatile("mcr p15, 0, %0, c8, c3, 0" :: "r" (0));
>> +	dsb();
>> +	isb();
>>  }
>>  
>>  static inline void flush_tlb_page(unsigned long vaddr)
>> @@ -39,6 +41,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
>>  
>>  static inline void flush_dcache_addr(unsigned long vaddr)
>>  {
>> +	/* DCCIMVAC */
>>  	asm volatile("mcr p15, 0, %0, c7, c14, 1" :: "r" (vaddr));
>>  }
>>  
>>
