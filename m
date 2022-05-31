Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF3538D45
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 10:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbiEaIzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 04:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiEaIzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 04:55:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 124DB8FFB5
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 01:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653987332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iaP4Rx4SV9w6UZ0UimQmEHdq+Pczo5IQxJG2ZngiOPM=;
        b=gBmdtN37zGBnesVp9nKsmJ6Uti5+LytGymv8hm8VUru7XERM3MIbhKPtEpwuhGsl7cy7L+
        rRpS1oPqt55bPMtqUpaCFzu1gEg4j0RKsFyFuBvFjy8lN6srd7owjTRB/uySsjrZZgLTcc
        BBpqaGzfRCVBDCqpKqkO9JHDoEriIWg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-2oTXCQbjPbSfRNaVUbJzlA-1; Tue, 31 May 2022 04:55:30 -0400
X-MC-Unique: 2oTXCQbjPbSfRNaVUbJzlA-1
Received: by mail-wm1-f70.google.com with SMTP id k7-20020a05600c1c8700b003974d762928so5709247wms.7
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 01:55:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iaP4Rx4SV9w6UZ0UimQmEHdq+Pczo5IQxJG2ZngiOPM=;
        b=7G5LWIWSmRsmQ9U/XWznMA5FMhiB9/KkRuX4A0jQn0NtqxWEWr1EVIx2f9s4ANctkv
         +30sSbxO1F/4MYU/d30fHdWUz7hkaJ9bZMADQOCxbAvLAZkul/1K1H0Jsxrd+WE/Blpj
         W9Jyhs9TQzrrxuIxk7B7xQgY9PlkLcdRYJwjcOifco0icdWi+1O6f/UjS8xrT81NJ4kH
         7WKnfKC4tTjd4hL+JpEakYhZU/1eiWZdv1RKHakUEJKXHawRE3kMVQY22b9qN8Gtnmi4
         WZyUdwz8n4hSgoU+NiwV56BzDurkhTe0IyzLlEDvoQZ7AJr9luOcvReoOWGYLEN9h2wO
         fLkA==
X-Gm-Message-State: AOAM531utS/N53kqTncFgTm85FfuYPnibZZcepLQ/pPNHKma1dZ+43sw
        u88xpJ/ULUv0wRjpn0fYCfFTQfpCkbCdPNBfjm3GQFMp1kc+kG9GDBIMmhCmDekaI6vc1gvTojG
        nH7ntF+xVJ/J+
X-Received: by 2002:a05:600c:4fce:b0:397:84e3:2297 with SMTP id o14-20020a05600c4fce00b0039784e32297mr20649145wmq.197.1653987329679;
        Tue, 31 May 2022 01:55:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmtw0XS0DBlA1YvKfMMOV2qEVZg5v+DEqF8KrKAaLiktU6Q6McjheYaP8uCBOW3Vk193L4MA==
X-Received: by 2002:a05:600c:4fce:b0:397:84e3:2297 with SMTP id o14-20020a05600c4fce00b0039784e32297mr20649129wmq.197.1653987329497;
        Tue, 31 May 2022 01:55:29 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-177-214.web.vodafone.de. [109.43.177.214])
        by smtp.gmail.com with ESMTPSA id v5-20020a1cac05000000b003974df805c7sm1551685wme.8.2022.05.31.01.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 01:55:29 -0700 (PDT)
Message-ID: <ed8e3b8a-e7ac-d432-f733-82fdaf668c1b@redhat.com>
Date:   Tue, 31 May 2022 10:55:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: add migration test for
 storage keys
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, scgl@linux.ibm.com
References: <20220531083713.48534-1-nrb@linux.ibm.com>
 <20220531083713.48534-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220531083713.48534-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/05/2022 10.37, Nico Boehr wrote:
> Upon migration, we expect storage keys set by the guest to be preserved, so add
> a test for it.
> 
> We keep 128 pages and set predictable storage keys. Then, we migrate and check
> that they can be read back and match the value originally set.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/Makefile         |  1 +
>   s390x/migration-skey.c | 76 ++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg    |  4 +++
>   3 files changed, 81 insertions(+)
>   create mode 100644 s390x/migration-skey.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 25802428fa13..94fc5c1a3527 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -33,6 +33,7 @@ tests += $(TEST_DIR)/adtl-status.elf
>   tests += $(TEST_DIR)/migration.elf
>   tests += $(TEST_DIR)/pv-attest.elf
>   tests += $(TEST_DIR)/migration-cmm.elf
> +tests += $(TEST_DIR)/migration-skey.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> new file mode 100644
> index 000000000000..f846ac435836
> --- /dev/null
> +++ b/s390x/migration-skey.c
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Storage Key migration tests
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/facility.h>
> +#include <asm/page.h>
> +#include <asm/mem.h>
> +#include <asm/interrupt.h>
> +#include <hardware.h>
> +
> +#define NUM_PAGES 128
> +static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
> +static void test_migration(void)
> +{
> +	union skey expected_key, actual_key;
> +	int i, key_to_set;
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		/*
> +		 * Storage keys are 7 bit, lowest bit is always returned as zero
> +		 * by iske
> +		 */
> +		key_to_set = i * 2;
> +		set_storage_key(pagebuf[i], key_to_set, 1);
> +	}
> +
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +	for (i = 0; i < NUM_PAGES; i++) {
> +		report_prefix_pushf("page %d", i);
> +
> +		actual_key.val = get_storage_key(pagebuf[i]);
> +		expected_key.val = i * 2;
> +
> +		/* ignore reference bit */
> +		actual_key.str.rf = 0;
> +		expected_key.str.rf = 0;

If the reference bit gets always ignored, testing 64 pages should be enough? 
OTOH this will complicate the for-loop / creation of the key value, so I 
don't mind too much if we keep it this way.

> +		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);
> +
> +		report_prefix_pop();
> +	}
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("migration-skey");
> +	if (test_facility(169)) {
> +		report_skip("storage key removal facility is active");
> +
> +		/*
> +		 * If we just exit and don't ask migrate_cmd to migrate us, it
> +		 * will just hang forever. Hence, also ask for migration when we
> +		 * skip this test altogether.
> +		 */
> +		puts("Please migrate me, then press return\n");
> +		(void)getchar();
> +
> +		goto done;
> +	}
> +
> +	test_migration();
> +
> +done:

	} else {
		test_migration();
	}

to get rid of the goto?

> +	report_prefix_pop();
> +	return report_summary();
> +}

Either way:
Reviewed-by: Thomas Huth <thuth@redhat.com>

