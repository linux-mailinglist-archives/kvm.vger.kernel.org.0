Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6AE3189AB
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 12:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhBKLjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 06:39:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhBKLhb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 06:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613043358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zYeHJb7zbEhP3Giqp4jdT5z3cBNO8R74OTAtH7GfRWY=;
        b=IFfham2fEkuSMk6XE/ddq0/rIuzia8JbOCbVwBRjb0f1CnLltuWH7REXik+RQ1qZmjuPKQ
        i700uwgyFTe252rXQ/i3HFizyoci84vQAd3O0PSqdpaRkVz8L5E0aXUaKyT1M1fZdphvhX
        gqyB9+ZPFeDRjwVZHMAxAJs+9wJOmxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-5YGRQqMLO1ua_KJ-2TWwlA-1; Thu, 11 Feb 2021 06:35:56 -0500
X-MC-Unique: 5YGRQqMLO1ua_KJ-2TWwlA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CCAE80402C;
        Thu, 11 Feb 2021 11:35:55 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-46.ams2.redhat.com [10.36.112.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CB3A5D74F;
        Thu, 11 Feb 2021 11:35:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: edat test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
References: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
 <20210209143835.1031617-5-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b069ad4e-b899-218b-a6a3-a371e4238f87@redhat.com>
Date:   Thu, 11 Feb 2021 12:35:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209143835.1031617-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/2021 15.38, Claudio Imbrenda wrote:
> Simple EDAT test.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/Makefile      |   1 +
>   s390x/edat.c        | 238 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   3 +
>   3 files changed, 242 insertions(+)
>   create mode 100644 s390x/edat.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 08d85c9f..fc885150 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -20,6 +20,7 @@ tests += $(TEST_DIR)/sclp.elf
>   tests += $(TEST_DIR)/css.elf
>   tests += $(TEST_DIR)/uv-guest.elf
>   tests += $(TEST_DIR)/sie.elf
> +tests += $(TEST_DIR)/edat.elf
>   
>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>   ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/s390x/edat.c b/s390x/edat.c
> new file mode 100644
> index 00000000..504a1501
> --- /dev/null
> +++ b/s390x/edat.c
> @@ -0,0 +1,238 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * EDAT test.
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *	Claudio Imbrenda <imbrenda@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <vmalloc.h>
> +#include <asm/facility.h>
> +#include <asm/interrupt.h>
> +#include <mmu.h>
> +#include <asm/pgtable.h>
> +#include <asm-generic/barrier.h>
> +
> +#define TEID_ADDR	PAGE_MASK
> +#define TEID_AI		0x003
> +#define TEID_M		0x004
> +#define TEID_A		0x008
> +#define TEID_FS		0xc00
> +
> +#define LC_SIZE	(2 * PAGE_SIZE)
> +#define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
> +
> +static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
> +static unsigned int tmp[1024] __attribute__((aligned(PAGE_SIZE)));
> +static void *root, *mem, *m;
> +static struct lowcore *lc;
> +volatile unsigned int *p;
> +
> +/* Expect a program interrupt, and clear the TEID */
> +static void expect_dat_fault(void)
> +{
> +	expect_pgm_int();
> +	lc->trans_exc_id = 0;
> +}
> +
> +/* Check if a protection exception happened for the given address */
> +static bool check_pgm_prot(void *ptr)
> +{
> +	unsigned long teid = lc->trans_exc_id;
> +
> +	if (lc->pgm_int_code != PGM_INT_CODE_PROTECTION)
> +		return 0;

return false.
It's a bool return type.

> +	if (~teid & TEID_M)

I'd maybe rather write this as:

         if (!(teid & TEID_M))

... but it's just a matter of taste.

> +		return 1;

                 return true;

So this is for backward compatiblity with older Z systems that do not have 
the corresponding facility? Should there be a corresponding facility check 
somewhere? Or maybe add at least a comment?

> +	return (~teid & TEID_A) &&
> +		((teid & TEID_ADDR) == ((uint64_t)ptr & PAGE_MASK)) &&
> +		!(teid & TEID_AI);

So you're checking for one specific type of protection exception here only 
... please add an appropriate comment.

> +}
> +
> +static void test_dat(void)
> +{
> +	report_prefix_push("edat off");
> +	/* disable EDAT */
> +	ctl_clear_bit(0, 23);
> +
> +	/* Check some basics */
> +	p[0] = 42;
> +	report(p[0] == 42, "pte, r/w");
> +	p[0] = 0;
> +
> +	protect_page(m, PAGE_ENTRY_P);
> +	expect_dat_fault();
> +	p[0] = 42;
> +	unprotect_page(m, PAGE_ENTRY_P);
> +	report(!p[0] && check_pgm_prot(m), "pte, ro");
> +
> +	/* The FC bit should be ignored because EDAT is off */
> +	p[0] = 42;

I'd suggest to set p[0] = 0 here...

> +	protect_dat_entry(m, SEGMENT_ENTRY_FC, 4);

... and change the value to 42 after enabling the protection ... otherwise 
you don't really test the non-working write protection here, do you?

> +	report(p[0] == 42, "pmd, fc=1, r/w");
> +	unprotect_dat_entry(m, SEGMENT_ENTRY_FC, 4);
> +	p[0] = 0;
> +
> +	/* Segment protection should work even with EDAT off */
> +	protect_dat_entry(m, SEGMENT_ENTRY_P, 4);
> +	expect_dat_fault();
> +	p[0] = 42;
> +	report(!p[0] && check_pgm_prot(m), "pmd, ro");
> +	unprotect_dat_entry(m, SEGMENT_ENTRY_P, 4);
> +
> +	/* The FC bit should be ignored because EDAT is off*/

Set p[0] to 0 again before enabling the protection? Or maybe use a different 
value than 42 below...?

> +	protect_dat_entry(m, REGION3_ENTRY_FC, 3);
> +	p[0] = 42;
> +	report(p[0] == 42, "pud, fc=1, r/w");
> +	unprotect_dat_entry(m, REGION3_ENTRY_FC, 3);
> +	p[0] = 0;
> +
> +	/* Region1/2/3 protection should not work, because EDAT is off */
> +	protect_dat_entry(m, REGION_ENTRY_P, 3);
> +	p[0] = 42;
> +	report(p[0] == 42, "pud, ro");
> +	unprotect_dat_entry(m, REGION_ENTRY_P, 3);
> +	p[0] = 0;
> +
> +	protect_dat_entry(m, REGION_ENTRY_P, 2);
> +	p[0] = 42;
> +	report(p[0] == 42, "p4d, ro");
> +	unprotect_dat_entry(m, REGION_ENTRY_P, 2);
> +	p[0] = 0;
> +
> +	protect_dat_entry(m, REGION_ENTRY_P, 1);
> +	p[0] = 42;
> +	report(p[0] == 42, "pgd, ro");
> +	unprotect_dat_entry(m, REGION_ENTRY_P, 1);
> +	p[0] = 0;
> +
> +	report_prefix_pop();
> +}

  Thomas

