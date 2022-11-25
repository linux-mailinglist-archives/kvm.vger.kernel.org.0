Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A33638BBA
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 14:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiKYN7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 08:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKYN7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 08:59:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F2E1A38B
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 05:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669384719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aw1P2Ri0mqwmUcaXAnyPkNOEMZ9IWbfSbhEHVlaLRfk=;
        b=Kumwv4hjTyBc2OcFl88PdNR4ZZsVdc7+9qFByzxe4QDx2RK2oHwSS2h5mqUcCeE8pNGFbm
        CvQJoEFRAqFu4RfMc98XlFUpb0uz+8Dl27dPITfMuFBxo8dKWqudMh231vAKTCxu3zyiUG
        HlEI/TV/7U6sPuVSQ5HRK/W1+I1HVx4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-331-m61ZX-HCMXCQMmWtX6A3Cw-1; Fri, 25 Nov 2022 08:58:38 -0500
X-MC-Unique: m61ZX-HCMXCQMmWtX6A3Cw-1
Received: by mail-wm1-f71.google.com with SMTP id f1-20020a1cc901000000b003cf703a4f08so1849775wmb.2
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 05:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aw1P2Ri0mqwmUcaXAnyPkNOEMZ9IWbfSbhEHVlaLRfk=;
        b=vMSIlgQE8Dj+GZPsk0Pd3Ra2ypqJ8sYcWrLZ11f8/1EKmv98B00r4uALiZfwa0qrYL
         B/gjv14NRh6IJzsMhAU4POkA1lUNu9EfDXk2bhTcb7utDvjMmO66GmtY8f47KqY1BBHP
         rJOAx/v5ssA63785d6Phsl58pC/9LUI1PfoPt36O0QGFr+63KVBVTTBQL/A1f0OTaF2W
         BHXgSdwGf7XCi9YxDAtPFwYcge3c9NzKHtgVop0FFH68VXrErAqwK1HffI8HoJsPPUcx
         S59wFULSU0zpiZHmim12Z74YebQIZ3QVhs37DxEZNeACjZHMFO9lxDGL4k9UnyEhjUv5
         +erA==
X-Gm-Message-State: ANoB5pljtBiDGWarJ0wvDY2wwrWnVGOHzvte9TU1KAoHQw3T5hUMycdL
        UguFMUA+fFhl/hQgHhNKKZrEMDTqibqNlZB6iG6s3g1ThJ/9gm2HXQf2VQZFJKmzudGuG7LhUXD
        V6ihthRf+lW8u
X-Received: by 2002:a05:600c:54cd:b0:3cf:67ae:3a4a with SMTP id iw13-20020a05600c54cd00b003cf67ae3a4amr14294911wmb.22.1669384717176;
        Fri, 25 Nov 2022 05:58:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7YuQDJIHBaNiEZImP1BKHYmyF6hi1io9i8XM/278ZlkAASwIifrXd58Wv8FtjYzrCb+bGRCA==
X-Received: by 2002:a05:600c:54cd:b0:3cf:67ae:3a4a with SMTP id iw13-20020a05600c54cd00b003cf67ae3a4amr14294903wmb.22.1669384716958;
        Fri, 25 Nov 2022 05:58:36 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-41.web.vodafone.de. [109.43.176.41])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d69cb000000b002366f9bd717sm4601153wrw.45.2022.11.25.05.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 05:58:36 -0800 (PST)
Message-ID: <8829c1f2-46cd-12b7-5939-48a1866ed001@redhat.com>
Date:   Fri, 25 Nov 2022 14:58:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20221124134429.612467-1-nrb@linux.ibm.com>
 <20221124134429.612467-3-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: add CMM test during
 migration
In-Reply-To: <20221124134429.612467-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/2022 14.44, Nico Boehr wrote:
> Add a test which modifies CMM page states while migration is in
> progress.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile               |   1 +
>   s390x/migration-during-cmm.c | 121 +++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg          |   5 ++
>   3 files changed, 127 insertions(+)
>   create mode 100644 s390x/migration-during-cmm.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 401cb6371cee..64c7c04409ae 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>   tests += $(TEST_DIR)/panic-loop-pgm.elf
>   tests += $(TEST_DIR)/migration-sck.elf
>   tests += $(TEST_DIR)/exittime.elf
> +tests += $(TEST_DIR)/migration-during-cmm.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/migration-during-cmm.c b/s390x/migration-during-cmm.c
> new file mode 100644
> index 000000000000..afe1f73605ba
> --- /dev/null
> +++ b/s390x/migration-during-cmm.c
> @@ -0,0 +1,121 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Perform CMMA actions while migrating.
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <smp.h>
> +#include <asm-generic/barrier.h>
> +
> +#include "cmm.h"
> +
> +#define NUM_PAGES 128
> +
> +/*
> + * Allocate 3 pages more than we need so we can start at different offsets. This ensures page states

I'd suggest to break the line after "offsets.", that's better to read.

> + * change on every loop iteration.
> + */
> +static uint8_t pagebuf[(NUM_PAGES + 3) * PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
> +
> +static unsigned int thread_iters;
> +static int thread_should_exit;
> +static int thread_exited;
> +struct cmm_verify_result result;
> +
> +static void test_cmm_during_migration(void)
> +{
> +	uint8_t *pagebuf_start;
> +	/*
> +	 * The second CPU must not print on the console, otherwise it will race with

"print to the console" ? ... no clue, I'm not a native speaker ;-)

> +	 * the primary CPU on the SCLP buffer.
> +	 */
> +	while (!thread_should_exit) {
> +		/*
> +		 * Start on a offset different from the last iteration so page states change with
> +		 * every iteration. This is why pagebuf has 3 extra pages.
> +		 */
> +		pagebuf_start = pagebuf + (thread_iters % 4) * PAGE_SIZE;
> +		cmm_set_page_states(pagebuf_start, NUM_PAGES);
> +
> +		/*
> +		 * Always increment even if the verify fails. This ensures primary CPU knows where
> +		 * we left off and can do an additional verify round after migration finished.
> +		 */
> +		thread_iters++;
> +
> +		result = cmm_verify_page_states(pagebuf_start, NUM_PAGES);
> +		if (result.verify_failed)
> +			goto out;

A "break" would be nicer than a goto.

> +	}
> +
> +out:
> +	WRITE_ONCE(thread_exited, 1);
> +}
> +
> +int main(void)
> +{
> +	bool has_essa = check_essa_available();
> +	struct psw psw;
> +
> +	report_prefix_push("migration-during-cmm");
> +	if (!has_essa) {
> +		report_skip("ESSA is not available");
> +		goto error;
> +	}
> +
> +	if (smp_query_num_cpus() == 1) {
> +		report_skip("need at least 2 cpus for this test");
> +		goto error;
> +	}
> +
> +	psw.mask = extract_psw_mask();
> +	psw.addr = (unsigned long)test_cmm_during_migration;
> +	smp_cpu_setup(1, psw);
> +
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +	WRITE_ONCE(thread_should_exit, 1);
> +
> +	while (!thread_exited)
> +		mb();
> +
> +	report_info("thread completed %u iterations", thread_iters);
> +
> +	report_prefix_push("during migration");
> +	cmm_report_verify(&result);
> +	report_prefix_pop();
> +
> +	/*
> +	 * Verification of page states occurs on the thread. We don't know if we
> +	 * were still migrating during the verification.
> +	 * To be sure, make another verification round after the migration
> +	 * finished to catch page states which might not have been migrated
> +	 * correctly.
> +	 */
> +	report_prefix_push("after migration");
> +	assert(thread_iters > 0);
> +	result = cmm_verify_page_states(pagebuf + ((thread_iters - 1) % 4) * PAGE_SIZE, NUM_PAGES);
> +	cmm_report_verify(&result);
> +	report_prefix_pop();
> +
> +	goto done;
> +
> +error:
> +	/*
> +	 * If we just exit and don't ask migrate_cmd to migrate us, it
> +	 * will just hang forever. Hence, also ask for migration when we
> +	 * skip this test alltogether.

s/alltogether/all together/

> +	 */
> +	puts("Please migrate me, then press return\n");
> +	(void)getchar();
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 3caf81eda396..f6889bd4da01 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -208,3 +208,8 @@ groups = migration
>   [exittime]
>   file = exittime.elf
>   smp = 2
> +
> +[migration-during-cmm]
> +file = migration-during-cmm.elf
> +groups = migration
> +smp = 2

With the nits fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

