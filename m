Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F5852D961
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 17:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbiESPwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 11:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241385AbiESPwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 11:52:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD4D2737B3
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 08:52:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A56E1477;
        Thu, 19 May 2022 08:52:06 -0700 (PDT)
Received: from [10.57.36.62] (unknown [10.57.36.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCCD03F718;
        Thu, 19 May 2022 08:52:05 -0700 (PDT)
Message-ID: <be60c5e6-8313-6547-49d2-ab0700cabd89@arm.com>
Date:   Thu, 19 May 2022 16:52:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 02/23] lib: Ensure all struct definition
 for ACPI tables are packed
Content-Language: en-GB
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-3-nikos.nikoleris@arm.com>
 <20220519131746.cpiiq5ndfvip4asq@gator>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220519131746.cpiiq5ndfvip4asq@gator>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 19/05/2022 14:17, Andrew Jones wrote:
> On Fri, May 06, 2022 at 09:55:44PM +0100, Nikos Nikoleris wrote:
>> All ACPI table definitions are provided with precise definitions of
>> field sizes and offsets, make sure that no compiler optimization can
>> interfere with the memory layout of the corresponding structs.
> 
> That seems like a reasonable thing to do. I'm wondering why Linux doesn't
> appear to do it. I see u-boot does, but not for all tables, which also
> makes me scratch my head... I see this patch packs every struct except
> rsdp_descriptor. Is there a reason it was left out?
> 

Thanks for the review!

Linux uses the following:

/*
  * All tables must be byte-packed to match the ACPI specification, since
  * the tables are provided by the system BIOS.
  */
#pragma pack(1)


...


/* Reset to default packing */

#pragma pack()


Happy to switch to #pragma, if we prefer this style.

I missed rsdp_descriptor, it should be packed will fix in v3.


> Another comment below
> 
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/acpi.h | 11 ++++++++---
>>   x86/s3.c   | 16 ++++------------
>>   2 files changed, 12 insertions(+), 15 deletions(-)
>>
>> diff --git a/lib/acpi.h b/lib/acpi.h
>> index 1e89840..42a2c16 100644
>> --- a/lib/acpi.h
>> +++ b/lib/acpi.h
>> @@ -3,6 +3,11 @@
>>   
>>   #include "libcflat.h"
>>   
>> +/*
>> + * All tables and structures must be byte-packed to match the ACPI
>> + * specification, since the tables are provided by the system BIOS
>> + */
>> +
>>   #define ACPI_SIGNATURE(c1, c2, c3, c4) \
>>   	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
>>   
>> @@ -44,12 +49,12 @@ struct rsdp_descriptor {        /* Root System Descriptor Pointer */
>>   struct acpi_table {
>>       ACPI_TABLE_HEADER_DEF
>>       char data[0];
>> -};
>> +} __attribute__ ((packed));
>>   
>>   struct rsdt_descriptor_rev1 {
>>       ACPI_TABLE_HEADER_DEF
>>       u32 table_offset_entry[0];
>> -};
>> +} __attribute__ ((packed));
>>   
>>   struct fadt_descriptor_rev1
>>   {
>> @@ -104,7 +109,7 @@ struct facs_descriptor_rev1
>>       u32 S4bios_f        : 1;    /* Indicates if S4BIOS support is present */
>>       u32 reserved1       : 31;   /* Must be 0 */
>>       u8  reserved3 [40];         /* Reserved - must be zero */
>> -};
>> +} __attribute__ ((packed));
>>   
>>   void set_efi_rsdp(struct rsdp_descriptor *rsdp);
>>   void* find_acpi_table_addr(u32 sig);
>> diff --git a/x86/s3.c b/x86/s3.c
> 
> The changes below in this file are unrelated, so they should be in a
> separate patch. However, I'm also curious why they're needed. I see
> that find_acpi_table_addr() can return NULL, so it doesn't seem like
> we should be removing the check, but instead changing the check to
> an assert.
> 

These changes are necessary to appease gcc after requiring struct 
facs_descriptor_rev1 to be packed.

>> index 378d37a..89d69fc 100644
>> --- a/x86/s3.c
>> +++ b/x86/s3.c
>> @@ -2,15 +2,6 @@
>>   #include "acpi.h"
>>   #include "asm/io.h"
>>   
>> -static u32* find_resume_vector_addr(void)
>> -{
>> -    struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
>> -    if (!facs)
>> -        return 0;
>> -    printf("FACS is at %p\n", facs);
>> -    return &facs->firmware_waking_vector;

This statement in particular results to a gcc warning. We can't get a 
reference to member of a packed struct.

"taking address of packed member of ‘struct facs_descriptor_rev1’ may 
result in an unaligned pointer value"

What I could do is move the x86/* changes in a separate patch in 
preparation of this one that packs all structs in <acpi.h>

Thanks,

Nikos

>> -}
>> -
>>   #define RTC_SECONDS_ALARM       1
>>   #define RTC_MINUTES_ALARM       3
>>   #define RTC_HOURS_ALARM         5
>> @@ -40,12 +31,13 @@ extern char resume_start, resume_end;
>>   int main(int argc, char **argv)
>>   {
>>   	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
>> -	volatile u32 *resume_vector_ptr = find_resume_vector_addr();
>> +	struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
>>   	char *addr, *resume_vec = (void*)0x1000;
>>   
>> -	*resume_vector_ptr = (u32)(ulong)resume_vec;
>> +	facs->firmware_waking_vector = (u32)(ulong)resume_vec;
>>   
>> -	printf("resume vector addr is %p\n", resume_vector_ptr);
>> +	printf("FACS is at %p\n", facs);
>> +	printf("resume vector addr is %p\n", &facs->firmware_waking_vector);
>>   	for (addr = &resume_start; addr < &resume_end; addr++)
>>   		*resume_vec++ = *addr;
>>   	printf("copy resume code from %p\n", &resume_start);
>> -- 
>> 2.25.1
>>
> 
> Thanks,
> drew
> 
