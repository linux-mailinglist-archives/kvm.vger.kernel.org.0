Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381BA4E2F70
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351880AbiCUR5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351885AbiCUR5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:57:34 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BFB4CD43
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:56:08 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id u103so29450658ybi.9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k5w4N0h5znLSssiHLgmDMLO/EudzOjUrkLNNjZheWAI=;
        b=edwCAu21KDfzwfsUIjxupxnxd03VoHAyLXhHQyjvqBVhnTNuuUBnhzl3dEniVEm8aO
         Guj+kVOdz+kWhZ7OLAU+UlGILytgfK/lD6/L2C6bH9tiBpTT1xPU0QJsb1wrfnZJe9al
         UnguvPQ+7ir7phVa4D1FtxSMzn4gZnCFBomPGoNNF+2mnAwJJl3cEKvXjGL6XCDH2Olp
         ox3XrJfUyN4RhnLB9Zeb+RbaaZ3d0CvbRYL+pxgfj//VysIfyXA1OqrUCYQN6+yW6c7F
         q8Uz1v1nmmp5tzNp3/OZ81jJYyBrTcGHeKdFQxgaKL4xwxeWmIIXBePdrNtV/ejuP+M4
         A5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k5w4N0h5znLSssiHLgmDMLO/EudzOjUrkLNNjZheWAI=;
        b=AoQ4BTmCojeXjUCEb3QLa/eceH6lb/ntTfFpLkxzIOanV+OIjW6FxSdbNAOj+yjQQp
         U3xGOzdG5I4Xr5DXR9Anvm3qfo+DF6DvT2wqS62W1PGkhyyrixv3+OMrbu7NyVZ615CT
         LQmWZKya28DBNUBhWoDg64UXHVP+KnaUp3PCHnYp+G2kYDPnBzK6OTz5EsSH23eEjmze
         Wnv2cM04jQwd53lxcCVBjVmQsW9s1y4uq5ONjp9ookXDDXXCChmuz5i/IUGrEdNsvW0O
         +OHIzSa8pYLDKwfUnzVlQDiuwX0CNts0DQeD+/1NeJtia/wvPB9r7Bq9p6gENe8qZQPX
         sRZg==
X-Gm-Message-State: AOAM530ZdwYRNwPZ+CTOqyNc9KgG8uNtfxrIoMzLtADcnnQhWaoXLFc5
        Fxmpq0fZl/LXo0FmiOOgCoPHVzqJfa8x24IBTCkR1Q==
X-Google-Smtp-Source: ABdhPJw2AQyeJkSafMniLtcOGztE8PR6b7b1KblkVCIsGFnrWx2WM666NvFASa7wzGDFFWXLPErj3px3Vnte1K5Spcw=
X-Received: by 2002:a25:2449:0:b0:633:c9aa:b9de with SMTP id
 k70-20020a252449000000b00633c9aab9demr13464598ybk.255.1647885367378; Mon, 21
 Mar 2022 10:56:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220321002638.379672-1-mizhang@google.com> <20220321002638.379672-5-mizhang@google.com>
In-Reply-To: <20220321002638.379672-5-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 21 Mar 2022 10:55:56 -0700
Message-ID: <CANgfPd-Q_a5kc9on3Lcps=1tghAGvacbojPu9uS37bspupskGg@mail.gmail.com>
Subject: Re: [PATCH 4/4] selftests: KVM: use dirty logging to check if page
 stats work correctly
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Sun, Mar 20, 2022 at 5:26 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> When dirty logging is enabled, KVM splits the all hugepage mapping in
> NPT/EPT into the smallest 4K size. This property could be used to check if

Note this is only true if eager page splitting is enabled. It would be
more accurate to say:
"While dirty logging is enabled, KVM will re-map any accessed page in
NPT/EPT at 4K."

> the page stats metrics work properly in KVM mmu. At the same time, this
> logic might be used the other way around: using page stats to verify if
> dirty logging really splits all huge pages. Moreover, when dirty logging is

It might be worth having a follow up commit which checks if eager
splitting is enabled and changes the assertions accordingly.

> disabled, KVM zaps corresponding SPTEs and we could check whether the large
> pages come back when guest touches the pages again.
>
> So add page stats checking in dirty logging performance selftest. In
> particular, add checks in three locations:
>  - just after vm is created;
>  - after populating memory into vm but before enabling dirty logging;
>  - just after turning on dirty logging.

Note a key stage here is after dirty logging is enabled, and then the
VM touches all the memory in the data region.
I believe that's the point at which you're making the assertion that
all mappings are 4k currently, which is the right place if eager
splitting is not enabled.

>  - after one final iteration after turning off dirty logging.
>
> Tested using commands:
>  - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
>  - ./dirty_log_perf_test -s anonymous_thp
>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: Peter Xu <peterx@redhat.com>
>
> Suggested-by: Ben Gardon <bgorden@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 52 +++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 1954b964d1cf..ab0457d91658 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -19,6 +19,10 @@
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
>
> +#ifdef __x86_64__
> +#include "processor.h"
> +#endif
> +
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N               2UL
>
> @@ -185,6 +189,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                  p->slots, p->backing_src,
>                                  p->partition_vcpu_memory_access);
>
> +#ifdef __x86_64__
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") == 0,
> +                   "4K page is non zero");
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") == 0,
> +                   "2M page is non zero");
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") == 0,
> +                   "1G page is non zero");
> +#endif
>         perf_test_set_wr_fract(vm, p->wr_fract);
>
>         guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
> @@ -222,6 +234,16 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         pr_info("Populate memory time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
>
> +#ifdef __x86_64__
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
> +                   "4K page is zero");
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)

This should also handle 2M hugetlb memory.
I think there might be a library function to translate backing src
type to page size too, which could make this check cleaner.

> +               TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
> +                           "2M page is zero");
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
> +               TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
> +                           "1G page is zero");
> +#endif
>         /* Enable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
>         enable_dirty_logging(vm, p->slots);
> @@ -267,6 +289,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                 iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
>                 }
>         }
> +#ifdef __x86_64__
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
> +                   "4K page is zero after dirty logging");
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") == 0,
> +                   "2M page is non-zero after dirty logging");
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") == 0,
> +                   "1G page is non-zero after dirty logging");
> +#endif

Note this is after dirty logging has been enabled, AND all pages in
the data region have been written by the guest.

>
>         /* Disable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
> @@ -275,6 +305,28 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         pr_info("Disabling dirty logging time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
>
> +#ifdef __x86_64__
> +       /*
> +        * Increment iteration to run the vcpus again to verify if huge pages
> +        * come back.
> +        */
> +       iteration++;
> +       pr_info("Starting the final iteration to verify page stats\n");
> +
> +       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> +               while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id])
> +                      != iteration)
> +                       ;
> +       }

We might as well do this on all archs. Even without the stats, it at
least validates that disabling dirty logging doesn't break the VM.

> +
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
> +               TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
> +                           "2M page is zero");
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
> +               TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
> +                           "1G page is zero");
> +#endif
> +
>         /* Tell the vcpu thread to quit */
>         host_quit = true;
>         perf_test_join_vcpu_threads(nr_vcpus);
> --
> 2.35.1.894.gb6a874cedc-goog
>
