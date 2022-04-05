Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DBE4F20A4
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 04:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiDEBSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 21:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiDEBSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 21:18:41 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DD523FF19
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 17:31:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x16so5187917pfa.10
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 17:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6uDd17eqwT3Kpy62aoXwkm+HeQSk1YT26c4Ib6umdL4=;
        b=eXNk/+Eq0+HjpVZOXFXfe7cNbm+VUddUNlWtr1BGApmmRektjC1jvbuB0FfCDevYlS
         nmKmxsMSuWq3gko2J21n3r7+bYdamBpe+zL6GcVWC9Kwql/kIqZ/Rivjy31cQJ616Oyq
         /ASpc2xBTdORjFXO+FeZvQCM7YbXooHUoy8p2AUJZbnQpCDJVG4CXMSoQ2fZLyq9tGD3
         fGcWw/QvSypvvRoIrJKNjfOJmYwgC3od/HgjWXFMe9DnHleiv80upavVoVsLdvOmui/G
         flswyJeDv1J18vUhyNBh5cw5WJ37p4yBJYY3Ds1vuz5TQGAezs4zT2P0cRs7KdfJ1Drt
         Qxzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6uDd17eqwT3Kpy62aoXwkm+HeQSk1YT26c4Ib6umdL4=;
        b=JsUSBpOdoUGlvpi85QDVzE5ulpQB/1iSboNxih3Qw8dqr2uoBSBLFkxQMY5r78GXKi
         2orRG9Z8P6GiFPaOSHB97XRfMtr8wimorJ9vPWBvPQFTcqQwhpypikblcJbjmGJqaUyr
         /f8vj92hqs/kPRTE3DSqueIAbw7NLVbwpjKK2ry/cqchmprlj23y35qFJLbU87+FsOck
         V3BQSnpS1drj/XjGDBOfAmBahV881vKj7FrmlJBaPuQE+++x9jA4LwwNGwFoA2Bh9ZCS
         95KaMr6hk+A0PPWD1J6xoQWAxNykUjkSoXE5cJ8VNOFnoozfsLEOJTBeFe80eN9bGlwo
         O+BQ==
X-Gm-Message-State: AOAM533fF0H/6x8JTMKHEXmxp4Ee+plbVc9EmWfCh38R69KzWj2OecC5
        XkE//diNtkqOzxnSpyCNzlEMe7bAdAlEkA==
X-Google-Smtp-Source: ABdhPJxmyC1L9wkkrUUenUb5ORTP4NSkIcJ3Bf8yc58eH9UEbTTh92WpCfYd6OwYBVX+KUckN6tkZw==
X-Received: by 2002:a05:6e02:1b0f:b0:2c7:9ec2:1503 with SMTP id i15-20020a056e021b0f00b002c79ec21503mr398706ilv.209.1649117617127;
        Mon, 04 Apr 2022 17:13:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id y8-20020a920908000000b002ca38acaa60sm2802439ilg.81.2022.04.04.17.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 17:13:36 -0700 (PDT)
Date:   Tue, 5 Apr 2022 00:13:33 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com
Subject: Re: [PATCH v4 2/4] KVM: selftests: add is_cpu_eligible_to_run()
 utility function
Message-ID: <YkuJrYL6wL5P5JY/@google.com>
References: <20220404214642.3201659-1-ricarkol@google.com>
 <20220404214642.3201659-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404214642.3201659-3-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Mon, Apr 04, 2022 at 02:46:40PM -0700, Ricardo Koller wrote:
> Add is_cpu_eligible_to_run() utility function, which checks whether the current
> process, or one of its threads, is eligible to run on a particular CPU.
> This information is obtained using sched_getaffinity.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/include/test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/test_util.c   | 20 ++++++++++++++++++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 99e0dcdc923f..a7653f369b6c 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
>  	return (void *)align_up((unsigned long)x, size);
>  }
>  
> +bool is_cpu_eligible_to_run(int pcpu);
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 6d23878bbfe1..7813a68333c0 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -4,6 +4,7 @@
>   *
>   * Copyright (C) 2020, Google LLC.
>   */
> +#define _GNU_SOURCE
>  
>  #include <assert.h>
>  #include <ctype.h>
> @@ -13,7 +14,9 @@
>  #include <sys/stat.h>
>  #include <sys/syscall.h>
>  #include <linux/mman.h>
> -#include "linux/kernel.h"
> +#include <linux/kernel.h>
> +#include <sched.h>
> +#include <sys/sysinfo.h>
>  
>  #include "test_util.h"
>  
> @@ -334,3 +337,18 @@ long get_run_delay(void)
>  
>  	return val[1];
>  }
> +
> +bool is_cpu_eligible_to_run(int pcpu)
> +{
> +	cpu_set_t cpuset;
> +	long i, nprocs;
> +
> +	nprocs = get_nprocs_conf();
> +	sched_getaffinity(0, sizeof(cpu_set_t), &cpuset);
> +	for (i = 0; i < nprocs; i++) {
> +		if (i == pcpu)
> +			return CPU_ISSET(i, &cpuset);
> +	}

I don't think you need the loop and can just do CPU_ISSET(pcpu, &cpuset),
right?

--
Thanks,
Oliver
