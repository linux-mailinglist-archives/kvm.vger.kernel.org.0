Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271314E2FA5
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 19:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352001AbiCUSJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 14:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351994AbiCUSJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 14:09:46 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4233E387AA
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 11:08:20 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2e612af95e3so53638337b3.9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 11:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MPBHLr0cnx+S1dvf9V9sqGfXPZPsxNMBB1OP6fOxbfo=;
        b=JFFEh1CTGLbS7t3f7mr0ceuCtf00CYZBnI4evLM7E4wDEEhE/w8kiOWfjfqIgas2Lc
         yhbz9cou9K3ZQNWVwAZuXk04N/Ouym7QdnoNUAR8OBUXWCmWr0UeVeprTUicc/NfrsJ7
         4hc2NQ+tKEJZJOOk0V+7Gcju8PCa6w9AfEFNI94XiIqJ5CW+u8VfFKh7J5LErquzFlRo
         xBe9yhPXjwhfBXyWFWPDmhgvfquTvn7CZC2cfh9qCiCaSJPXMc55hgrtfIzXJ6y2bRhx
         f+kMY70XmmzigJCqkvcinx88w57JNMpO9yS819FDxXspGbGIEGBXOQbqyVD4LnFwNtaf
         CmpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MPBHLr0cnx+S1dvf9V9sqGfXPZPsxNMBB1OP6fOxbfo=;
        b=BavLeYSHENvn3s9GBGUMcMpnHTSUToudqYJMJTjHLmdWhyA9SLElHLKwLfhsQtr7Ul
         I8fQDl6x4OyyAchHLtJUrdL+LyOO50kpz0Si/ijXDovpuVA7TzeRzsKzMWkajrz7GU8d
         1o/H2QUFqQ3IqBfeC1kwoMFXhrkOoNbYOzw++9I6991nzy7isvOZHGLnaEvpjqM6oyy5
         rXLpyPKMQ6Rz4rbMyC58jblM+W974V5mtaw2EMWBS3fTR3OZxj8uAiT/ZP+rGSeflJqk
         fLCr9z9bgtvKHXM8JHhaLgMvy51GVxu+sY+OyM+mElE9RfhNIBYqGt3+LuQlzEM9ctLA
         rI0g==
X-Gm-Message-State: AOAM530Z5hSKJJzauDvyJtefaxdlIbareuzpEI0LKgXtLNbqn/s6GVQB
        mevaYYYhFRssQGkSI6HbCfTRRKZLpePvrGDJDKygjw==
X-Google-Smtp-Source: ABdhPJzTfPQ/TNiJ8Ed+m0Hc2I16HRfZHKoAu/TOzPP/1wMRBrTv1KVrLuKj0ysPsKK/aqH7hvmrs9sI4ayfx5VaOQI=
X-Received: by 2002:a0d:d44e:0:b0:2e5:dc71:c82b with SMTP id
 w75-20020a0dd44e000000b002e5dc71c82bmr16488979ywd.42.1647886098873; Mon, 21
 Mar 2022 11:08:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220321002638.379672-1-mizhang@google.com> <20220321002638.379672-5-mizhang@google.com>
In-Reply-To: <20220321002638.379672-5-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 21 Mar 2022 11:08:08 -0700
Message-ID: <CANgfPd8feg_4vhNJqhFViDaMfvp_C4PdtEGMGOJ-Z8smQuf3rQ@mail.gmail.com>
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
> the page stats metrics work properly in KVM mmu. At the same time, this
> logic might be used the other way around: using page stats to verify if
> dirty logging really splits all huge pages. Moreover, when dirty logging is
> disabled, KVM zaps corresponding SPTEs and we could check whether the large
> pages come back when guest touches the pages again.
>
> So add page stats checking in dirty logging performance selftest. In
> particular, add checks in three locations:
>  - just after vm is created;
>  - after populating memory into vm but before enabling dirty logging;
>  - just after turning on dirty logging.
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

Woops, got a mail bounce from this. Should be:
Suggested-by: Ben Gardon <bgardon@google.com>

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
