Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FCC5530D7
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 13:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349383AbiFUL0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 07:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348722AbiFUL0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 07:26:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEAD038A4
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 04:26:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B69F2165C;
        Tue, 21 Jun 2022 04:26:11 -0700 (PDT)
Received: from [10.57.39.102] (unknown [10.57.39.102])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B49D53F534;
        Tue, 21 Jun 2022 04:26:10 -0700 (PDT)
Message-ID: <e88ba9c2-bb6e-b35a-d05f-08eacaa21d46@arm.com>
Date:   Tue, 21 Jun 2022 12:26:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 03/23] lib: Add support for the XSDT
 ACPI table
Content-Language: en-GB
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-4-nikos.nikoleris@arm.com>
 <Yq0eaaOiud8pOXZN@google.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <Yq0eaaOiud8pOXZN@google.com>
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

Thanks for the review!

On 18/06/2022 01:38, Ricardo Koller wrote:
> Hi Nikos,
> 
> On Fri, May 06, 2022 at 09:55:45PM +0100, Nikos Nikoleris wrote:
>> XSDT provides pointers to other ACPI tables much like RSDT. However,
>> contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
>> pointers. ACPI requires that if XSDT is valid then it takes precedence
>> over RSDT.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/acpi.h |   6 ++++
>>   lib/acpi.c | 103 ++++++++++++++++++++++++++++++++---------------------
>>   2 files changed, 68 insertions(+), 41 deletions(-)
>>
>> diff --git a/lib/acpi.h b/lib/acpi.h
>> index 42a2c16..d80b983 100644
>> --- a/lib/acpi.h
>> +++ b/lib/acpi.h
>> @@ -13,6 +13,7 @@
>>   
>>   #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
>>   #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
>> +#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>>   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>>   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
>>   
>> @@ -56,6 +57,11 @@ struct rsdt_descriptor_rev1 {
>>       u32 table_offset_entry[0];
>>   } __attribute__ ((packed));
>>   
>> +struct acpi_table_xsdt {
>> +    ACPI_TABLE_HEADER_DEF
>> +    u64 table_offset_entry[1];
> 
> nit: This should be "[0]" to match the usage above (in rsdt).
> 
> I was about to suggest using an unspecified size "[]", but after reading
> what the C standard says about it (below), now I'm not sure. was the
> "[1]" needed for something that I'm missing?
> 
> 	106) The length is unspecified to allow for the fact that
> 	implementations may give array members different
> 	alignments according to their lengths.
> 
> 
>> +} __attribute__ ((packed));
>> +
>>   struct fadt_descriptor_rev1
>>   {
>>       ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
>> diff --git a/lib/acpi.c b/lib/acpi.c
>> index de275ca..9b8700c 100644
>> --- a/lib/acpi.c
>> +++ b/lib/acpi.c
>> @@ -38,45 +38,66 @@ static struct rsdp_descriptor *get_rsdp(void)
>>   
>>   void* find_acpi_table_addr(u32 sig)
> 
> nit: This one could also be fixed as well: "void *".
> 
>>   {
>> -    struct rsdp_descriptor *rsdp;
>> -    struct rsdt_descriptor_rev1 *rsdt;
>> -    void *end;
>> -    int i;
>> -
>> -    /* FACS is special... */
>> -    if (sig == FACS_SIGNATURE) {
>> -        struct fadt_descriptor_rev1 *fadt;
>> -        fadt = find_acpi_table_addr(FACP_SIGNATURE);
>> -        if (!fadt) {
>> -            return NULL;
>> -        }
>> -        return (void*)(ulong)fadt->firmware_ctrl;
>> -    }
>> -
>> -    rsdp = get_rsdp();
>> -    if (rsdp == NULL) {
>> -        printf("Can't find RSDP\n");
>> -        return 0;
>> -    }
>> -
>> -    if (sig == RSDP_SIGNATURE) {
>> -        return rsdp;
>> -    }
>> -
>> -    rsdt = (void*)(ulong)rsdp->rsdt_physical_address;
>> -    if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
>> -        return 0;
>> -
>> -    if (sig == RSDT_SIGNATURE) {
>> -        return rsdt;
>> -    }
>> -
>> -    end = (void*)rsdt + rsdt->length;
>> -    for (i=0; (void*)&rsdt->table_offset_entry[i] < end; i++) {
>> -        struct acpi_table *t = (void*)(ulong)rsdt->table_offset_entry[i];
>> -        if (t && t->signature == sig) {
>> -            return t;
>> -        }
>> -    }
>> -   return NULL;
>> +	struct rsdp_descriptor *rsdp;
>> +	struct rsdt_descriptor_rev1 *rsdt;
>> +	struct acpi_table_xsdt *xsdt = NULL;
>> +	void *end;
>> +	int i;
>> +
>> +	/* FACS is special... */
>> +	if (sig == FACS_SIGNATURE) {
>> +		struct fadt_descriptor_rev1 *fadt;
>> +
>> +		fadt = find_acpi_table_addr(FACP_SIGNATURE);
>> +		if (!fadt)
>> +			return NULL;
>> +
>> +		return (void*)(ulong)fadt->firmware_ctrl;
>> +	}
>> +
>> +	rsdp = get_rsdp();
>> +	if (rsdp == NULL) {
>> +		printf("Can't find RSDP\n");
>> +		return 0;
>> +	}
>> +
>> +	if (sig == RSDP_SIGNATURE)
>> +		return rsdp;
>> +
>> +	rsdt = (void *)(ulong)rsdp->rsdt_physical_address;
>> +	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
>> +		rsdt = NULL;
>> +
>> +	if (sig == RSDT_SIGNATURE)
>> +		return rsdt;
>> +
>> +	if (rsdp->revision > 1)
>> +		xsdt = (void *)(ulong)rsdp->xsdt_physical_address;
>> +	if (!xsdt || xsdt->signature != XSDT_SIGNATURE)
>> +		xsdt = NULL;
>> +
> 
> To simplify this function a bit, finding the xsdt could be moved to some
> kind of init function.

That's a good point, I can add xsdt and rsdt as globals (like we do for 
efi_rsdp) and then initialise them in set_efi_rsdp().

On the other hand, if we would like to avoid the global variables there 
  is only a handful of time we will be calling  find_acpi_table_addr()

> 
>> +	if (sig == XSDT_SIGNATURE)
>> +		return xsdt;
>> +
>> +	// APCI requires that we first try to use XSDT if it's valid,
>> +	//  we use to find other tables, otherwise we use RSDT.
>> +	if (xsdt) {
>> +		end = (void *)(ulong)xsdt + xsdt->length;
>> +		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
>> +			struct acpi_table *t =
>> +				(void *)xsdt->table_offset_entry[i];
>> +			if (t && t->signature == sig)
>> +				return t;
>> +		}
>> +	} else if (rsdt) {
>> +		end = (void *)rsdt + rsdt->length;
>> +		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
>> +			struct acpi_table *t =
>> +				(void *)(ulong)rsdt->table_offset_entry[i];
>> +			if (t && t->signature == sig)
>> +				return t;
>> +		}
>> +	}
> 
> The two for-loops could be moved into some common function, or maybe a
> macro to deal with the fact that it deals with two different structures
> (the rsdt and the xsdt). This is my attempt at making it a function:
> 
> void *scan_system_descriptor_table(void *dt)
> {
> 	int i;
> 	void *end;
> 	/* XXX: Not sure if this is the nicest thing to do, but the rsdt
> 	 * and the xsdt have "length" and "table_offset_entry" at the
> 	 * same offsets. */
> 	struct acpi_table_xsdt *xsdt = dt;
> 
> 	end = (void *)(ulong)xsdt + xsdt->length;
> 	for (i = 0; &xsdt->table_offset_entry[i] < end; i++) {
> 		struct acpi_table *t = (void *)xsdt->table_offset_entry[i];
> 		if (t && t->signature == sig)
> 			return t;
> }
> 

I remember trying something similar but it got a bit messy because 
table_offset_entry is u32 in rsdt and u64 in xsdt. I'll check again if 
there is a way we can improve this in v3.

Thanks,

Nikos

> Thanks,
> Ricardo
> 
>> +
>> +	return NULL;
>>   }
>> -- 
>> 2.25.1
>>
