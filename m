Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2646402F0
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 10:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiLBJKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 04:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiLBJKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 04:10:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE40A0BEF
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 01:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669972150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zFeB4i4WDP7Cd1oIXD0yCSuKmWiq2ua/0n/1k8VAkkM=;
        b=XFnXJVwWc6WLKX6nVZIc3QYeo0XfdPE/0VMEvNsfAYOiSMij5FSQUzacZRXdSPhulisI61
        W1vy+9NT4WVQYmluCrFd5hEiWA/ZsaLHbBK55SV0g43ch+jIxJW7Y9GQTi7tOdfMvG81W8
        ChwicZm5YiecvKNNIxwCFTUzYTsy21Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-15-wiRGH_T8OB-uUuNNdf5-HQ-1; Fri, 02 Dec 2022 04:09:07 -0500
X-MC-Unique: wiRGH_T8OB-uUuNNdf5-HQ-1
Received: by mail-wm1-f71.google.com with SMTP id l42-20020a05600c1d2a00b003cf8e70c1ecso3842436wms.4
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 01:09:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFeB4i4WDP7Cd1oIXD0yCSuKmWiq2ua/0n/1k8VAkkM=;
        b=lusooH25hUQXWTE0m1/riPzY2D94dQoMXvw3takmTel05xjBbFF9S/9eagrMXY0XC8
         6Z5/vhQCR/f5rgiJ8+KzXncG2NsQUYKG8vyYf1QL2Xjx05jZaCiCPRl3XXq1WrC4WZX1
         4B0YiU+xuUVuomqQ9f6bkBB9A5ketdVqHfNBeqNOkj15nSmAUuzNNqSjoXsoxWMLwpqc
         /yNPwonFFFmUAibuxabGOBV+qXABjeurlYLs0RljWc8w8zXsBJrJWFfKbea7X3NteCj5
         TUWrRhusioGIPQYY9AnbSZqfV2aUbXjfs739s6Er3H3UcSTQW0rGkbE9mjCtH0vtmO1i
         YY/g==
X-Gm-Message-State: ANoB5pnkM5RQBO8N4C2RB3E1nlluAZGoqZVPkOVZJ0tZ4yZFP9SYLn2F
        uIzyA8kV9MLD+dcz0x2Myrcf4NU0+7fTSb/f85Xge0KA05n49qOrijQ9CjVpXr98QFTbWCjDqJQ
        0lu0PtV6F0/7l
X-Received: by 2002:a5d:5955:0:b0:241:553e:5040 with SMTP id e21-20020a5d5955000000b00241553e5040mr37472426wri.578.1669972146003;
        Fri, 02 Dec 2022 01:09:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5kUX+7486/WuNjgEExauWE4HrTbSCv0z369UjnrrUi73m7KxmDEkLCsNwoU36RV0sqmNPWNw==
X-Received: by 2002:a5d:5955:0:b0:241:553e:5040 with SMTP id e21-20020a5d5955000000b00241553e5040mr37472413wri.578.1669972145729;
        Fri, 02 Dec 2022 01:09:05 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-178-86.web.vodafone.de. [109.43.178.86])
        by smtp.gmail.com with ESMTPSA id d14-20020adff2ce000000b00241fab5a296sm6600807wrp.40.2022.12.02.01.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 01:09:04 -0800 (PST)
Message-ID: <7a05af7b-96e0-7914-1415-62443f6646dd@redhat.com>
Date:   Fri, 2 Dec 2022 10:09:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related
 functions
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, pbonzini@redhat.com
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
 <20221201084642.3747014-2-nrb@linux.ibm.com>
 <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2022 10.03, Janosch Frank wrote:
> On 12/1/22 09:46, Nico Boehr wrote:
>> Upcoming changes will add a test which is very similar to the existing
>> skey migration test. To reduce code duplication, move the common
>> functions to a library which can be re-used by both tests.
>>
> 
> NACK
> 
> We're not putting test specific code into the library.

Do we need a new file (in the third patch) for the new test at all, or could 
the new test simply be added to s390x/migration-skey.c instead?

  Thomas


>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---
>>   lib/s390x/skey.c       | 92 ++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/skey.h       | 32 +++++++++++++++
>>   s390x/Makefile         |  1 +
>>   s390x/migration-skey.c | 44 +++-----------------
>>   4 files changed, 131 insertions(+), 38 deletions(-)
>>   create mode 100644 lib/s390x/skey.c
>>   create mode 100644 lib/s390x/skey.h
>>
>> diff --git a/lib/s390x/skey.c b/lib/s390x/skey.c
>> new file mode 100644
>> index 000000000000..100f0949a244
>> --- /dev/null
>> +++ b/lib/s390x/skey.c
>> @@ -0,0 +1,92 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Storage key migration test library
>> + *
>> + * Copyright IBM Corp. 2022
>> + *
>> + * Authors:
>> + *  Nico Boehr <nrb@linux.ibm.com>
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <asm/facility.h>
>> +#include <asm/mem.h>
>> +#include <skey.h>
>> +
>> +/*
>> + * Set storage keys on pagebuf.
>> + * pagebuf must point to page_count consecutive pages.
>> + */
>> +void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
>> +{
>> +    unsigned char key_to_set;
>> +    unsigned long i;
>> +
>> +    for (i = 0; i < page_count; i++) {
>> +        /*
>> +         * Storage keys are 7 bit, lowest bit is always returned as zero
>> +         * by iske.
>> +         * This loop will set all 7 bits which means we set fetch
>> +         * protection as well as reference and change indication for
>> +         * some keys.
>> +         */
>> +        key_to_set = i * 2;
>> +        set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);
>> +    }
>> +}
>> +
>> +/*
>> + * Verify storage keys on pagebuf.
>> + * Storage keys must have been set by skey_set_keys on pagebuf before.
>> + *
>> + * If storage keys match the expected result, will return a 
>> skey_verify_result
>> + * with verify_failed false. All other fields are then invalid.
>> + * If there is a mismatch, returned struct will have verify_failed true 
>> and will
>> + * be filled with the details on the first mismatch encountered.
>> + */
>> +struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned 
>> long page_count)
>> +{
>> +    union skey expected_key, actual_key;
>> +    struct skey_verify_result result = {
>> +        .verify_failed = true
>> +    };
>> +    uint8_t *cur_page;
>> +    unsigned long i;
>> +
>> +    for (i = 0; i < page_count; i++) {
>> +        cur_page = pagebuf + i * PAGE_SIZE;
>> +        actual_key.val = get_storage_key(cur_page);
>> +        expected_key.val = i * 2;
>> +
>> +        /*
>> +         * The PoP neither gives a guarantee that the reference bit is
>> +         * accurate nor that it won't be cleared by hardware. Hence we
>> +         * don't rely on it and just clear the bits to avoid compare
>> +         * errors.
>> +         */
>> +        actual_key.str.rf = 0;
>> +        expected_key.str.rf = 0;
>> +
>> +        if (actual_key.val != expected_key.val) {
>> +            result.expected_key.val = expected_key.val;
>> +            result.actual_key.val = actual_key.val;
>> +            result.page_mismatch_idx = i;
>> +            result.page_mismatch_addr = (unsigned long)cur_page;
>> +            return result;
>> +        }
>> +    }
>> +
>> +    result.verify_failed = false;
>> +    return result;
>> +}
>> +
>> +void skey_report_verify(struct skey_verify_result * const result)
>> +{
>> +    if (result->verify_failed)
>> +        report_fail("page skey mismatch: first page idx = %lu, addr = 
>> 0x%lx, "
>> +            "expected_key = 0x%x, actual_key = 0x%x",
>> +            result->page_mismatch_idx, result->page_mismatch_addr,
>> +            result->expected_key.val, result->actual_key.val);
>> +    else
>> +        report_pass("skeys match");
>> +}
>> diff --git a/lib/s390x/skey.h b/lib/s390x/skey.h
>> new file mode 100644
>> index 000000000000..a0f8caa1270b
>> --- /dev/null
>> +++ b/lib/s390x/skey.h
>> @@ -0,0 +1,32 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Storage key migration test library
>> + *
>> + * Copyright IBM Corp. 2022
>> + *
>> + * Authors:
>> + *  Nico Boehr <nrb@linux.ibm.com>
>> + */
>> +#ifndef S390X_SKEY_H
>> +#define S390X_SKEY_H
>> +
>> +#include <libcflat.h>
>> +#include <asm/facility.h>
>> +#include <asm/page.h>
>> +#include <asm/mem.h>
>> +
>> +struct skey_verify_result {
>> +    bool verify_failed;
>> +    union skey expected_key;
>> +    union skey actual_key;
>> +    unsigned long page_mismatch_idx;
>> +    unsigned long page_mismatch_addr;
>> +};
>> +
>> +void skey_set_keys(uint8_t *pagebuf, unsigned long page_count);
>> +
>> +struct skey_verify_result skey_verify_keys(uint8_t *pagebuf, unsigned 
>> long page_count);
>> +
>> +void skey_report_verify(struct skey_verify_result * const result);
>> +
>> +#endif /* S390X_SKEY_H */
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index bf1504f9d58c..d097b7071dfb 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -99,6 +99,7 @@ cflatobjs += lib/s390x/malloc_io.o
>>   cflatobjs += lib/s390x/uv.o
>>   cflatobjs += lib/s390x/sie.o
>>   cflatobjs += lib/s390x/fault.o
>> +cflatobjs += lib/s390x/skey.o
>>   OBJDIRS += lib/s390x
>> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
>> index b7bd82581abe..fed6fc1ed0f8 100644
>> --- a/s390x/migration-skey.c
>> +++ b/s390x/migration-skey.c
>> @@ -10,55 +10,23 @@
>>   #include <libcflat.h>
>>   #include <asm/facility.h>
>> -#include <asm/page.h>
>> -#include <asm/mem.h>
>> -#include <asm/interrupt.h>
>>   #include <hardware.h>
>> +#include <skey.h>
>>   #define NUM_PAGES 128
>> -static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] 
>> __attribute__((aligned(PAGE_SIZE)));
>> +static uint8_t pagebuf[NUM_PAGES * PAGE_SIZE] 
>> __attribute__((aligned(PAGE_SIZE)));
>>   static void test_migration(void)
>>   {
>> -    union skey expected_key, actual_key;
>> -    int i, key_to_set, key_mismatches = 0;
>> +    struct skey_verify_result result;
>> -    for (i = 0; i < NUM_PAGES; i++) {
>> -        /*
>> -         * Storage keys are 7 bit, lowest bit is always returned as zero
>> -         * by iske.
>> -         * This loop will set all 7 bits which means we set fetch
>> -         * protection as well as reference and change indication for
>> -         * some keys.
>> -         */
>> -        key_to_set = i * 2;
>> -        set_storage_key(pagebuf[i], key_to_set, 1);
>> -    }
>> +    skey_set_keys(pagebuf, NUM_PAGES);
>>       puts("Please migrate me, then press return\n");
>>       (void)getchar();
>> -    for (i = 0; i < NUM_PAGES; i++) {
>> -        actual_key.val = get_storage_key(pagebuf[i]);
>> -        expected_key.val = i * 2;
>> -
>> -        /*
>> -         * The PoP neither gives a guarantee that the reference bit is
>> -         * accurate nor that it won't be cleared by hardware. Hence we
>> -         * don't rely on it and just clear the bits to avoid compare
>> -         * errors.
>> -         */
>> -        actual_key.str.rf = 0;
>> -        expected_key.str.rf = 0;
>> -
>> -        /* don't log anything when key matches to avoid spamming the log */
>> -        if (actual_key.val != expected_key.val) {
>> -            key_mismatches++;
>> -            report_fail("page %d expected_key=0x%x actual_key=0x%x", i, 
>> expected_key.val, actual_key.val);
>> -        }
>> -    }
>> -
>> -    report(!key_mismatches, "skeys after migration match");
>> +    result = skey_verify_keys(pagebuf, NUM_PAGES);
>> +    skey_report_verify(&result);
>>   }
>>   int main(void)
> 

