Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7B3FBDF4
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 23:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbhH3VLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 17:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhH3VLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 17:11:11 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5163CC06175F
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 14:10:17 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id j15so17777195ila.1
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 14:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mshXpQmgJqaKCCPtHDuq2mytpmp0ymqRBmmUPpIBMnM=;
        b=iPoqcoDZrM3zUVajQE1RAnOBnq5O494juPqB3MEnBNJHNCeqs5UZzq9X4mxaGuCEZA
         S2RccgEzJle0jyTEHB1iglKT3J7cFdWGUTjeIE/zweiERExFTRRYWdFKRrOXZ6fsSuXd
         nGNU85oV9s2ast3U6WeXeCbD/LLBGy/nxvIyOgOlIHbp8/dMpjwUp1QWWnEI5v0ZkyeS
         hQFKtIyIt+OiUtk/tzH8A+ChquxQz/lufrHQVSvsaJUjWbTiVZ7MJmSpMUpELzq9excS
         lbAzY9lFqACmiuVG+tdCiJ7TSyzJagqXJ6Dyr24EIvrMBgRKy9sDjGNGb5Rj/+kf1nPT
         nDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mshXpQmgJqaKCCPtHDuq2mytpmp0ymqRBmmUPpIBMnM=;
        b=REYhtLGwgnTbMCimvxcKlq71jxgKwXN5jjkyBIm6Z06Ai8Dj17IjTx39suD19BLEAX
         ZH5ZqP0nyc/apNq19CTdpmXbQNMbIRSqGjgHAiXN+5hDZs6+7wXhsxT5wldKpqWbBh/0
         zYaZ81fzhgTc9jhFXvu0GzoQG34M0SvX+dLRDVZA9l/u2S8TYdu+9ZhKnWvClq6g0c8E
         0u7ueSucwgZHJuuxFQc0yXyTjuM6/wSJ5eOywCKVp8gNQpZ4+p21HT3E4FF2jUpR5NNn
         A2xZ4j/lIoO/8pNBgw6FV3pQfF5cr4BHNLwfplrEkIFCKEkOXV7W+a7MMAXuNLAxi0Lg
         XcQA==
X-Gm-Message-State: AOAM533q1R6vrlpOIo4w4pIhIPeNRcbGx17IvcnSNyyGt4AmBrmvs/Uz
        8/zMSagHZxh3jSdKxHOlOKa2RzW1+n2w6PZlnrDHPw==
X-Google-Smtp-Source: ABdhPJwQNvIPMfGNWsL3SqGcwMhma+WRFEs2goX7S2bzgtxrYSsGflpUwtiDZdJQfZR9T0errwnsgU1Bk9FhSSkWYh8=
X-Received: by 2002:a05:6e02:524:: with SMTP id h4mr17765149ils.203.1630357816519;
 Mon, 30 Aug 2021 14:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210830044425.2686755-1-mizhang@google.com> <20210830044425.2686755-3-mizhang@google.com>
In-Reply-To: <20210830044425.2686755-3-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 30 Aug 2021 14:10:05 -0700
Message-ID: <CANgfPd_46=V24r5Qu8cDuOCwVRSEF9RFHuD-1sPpKrBCjWOA2w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] selftests: KVM: use dirty logging to check if page
 stats work correctly
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 29, 2021 at 9:44 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> When dirty logging is enabled, KVM splits the hugepage mapping in NPT/EPT
> into the smallest 4K size after guest VM writes to it. This property could
> be used to check if the page stats metrics work properly in KVM x86/mmu. At
> the same time, this logic might be used the other way around: using page
> stats to verify if dirty logging really splits all huge pages after guest
> VM writes to all memory.
>
> So add page stats checking in dirty logging performance selftest. In
> particular, add checks in three locations:
>  - just after vm is created;
>  - after populating memory into vm without turning on dirty logging;
>  - after guest vm writing to all memory again with dirty logging turned on.
>
> Tested using commands:
>  - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
>  - ./dirty_log_perf_test -s anonymous_hugetlb_2mb
>  - ./dirty_log_perf_test -s anonymous_thp
>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: Peter Xu <peterx@redhat.com>
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 44 +++++++++++++++++++
>  .../testing/selftests/kvm/include/test_util.h |  1 +
>  .../selftests/kvm/include/x86_64/processor.h  |  7 +++
>  tools/testing/selftests/kvm/lib/test_util.c   | 29 ++++++++++++
>  4 files changed, 81 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 3c30d0045d8d..bc598e07b295 100644
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

I know this is only needed for x86_64, but I don't think it needs to
be ifdef in order for everything to work.

>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N               2UL
>
> @@ -166,6 +170,18 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
>                                  p->slots, p->backing_src);
>
> +#ifdef __x86_64__
> +       /*
> +        * No vCPUs have been started yet, so KVM should not have created any
> +        * mapping at this moment.
> +        */
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) == 0,
> +                   "4K page is non zero");
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) == 0,
> +                   "2M page is non zero");
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) == 0,
> +                   "1G page is non zero");
> +#endif
>         perf_test_args.wr_fract = p->wr_fract;
>
>         guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
> @@ -211,6 +227,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         pr_info("Populate memory time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
>
> +#ifdef __x86_64__
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) != 0,
> +                   "4K page is zero");
> +       /* Ensure THP page stats is non-zero to minimize the flakiness. */
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
> +               TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) > 0,
> +                       "2M page number is zero");

Nice. Thanks for handling this case. It's very frustrating when THP
makes test assertions flaky.

> +       else if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB)
> +               TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) ==
> +                       (guest_percpu_mem_size * nr_vcpus) >> X86_PAGE_2M_SHIFT,
> +                       "2M page number does not match");
> +       else if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
> +               TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) ==
> +                       (guest_percpu_mem_size * nr_vcpus) >> X86_PAGE_1G_SHIFT,
> +                       "1G page number does not match");
> +#endif
>         /* Enable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
>         enable_dirty_logging(vm, p->slots);
> @@ -256,6 +288,18 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                 iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
>                 }
>         }
> +#ifdef __x86_64__
> +       /*
> +        * When vCPUs writes to all memory again with dirty logging enabled, we
> +        * should see only 4K page mappings exist in KVM mmu.
> +        */
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) != 0,
> +                   "4K page is zero after dirtying memory");
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) == 0,
> +                   "2M page is non-zero after dirtying memory");
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) == 0,
> +                   "1G page is non-zero  after dirtying memory");
> +#endif
>
>         /* Disable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index d79be15dd3d2..dca5fcf7aa87 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -102,6 +102,7 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i);
>  size_t get_backing_src_pagesz(uint32_t i);
>  void backing_src_help(void);
>  enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
> +size_t get_page_stats(uint32_t page_level);
>
>  /*
>   * Whether or not the given source type is shared memory (as opposed to
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 242ae8e09a65..9749319821a3 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -39,6 +39,13 @@
>  #define X86_CR4_SMAP           (1ul << 21)
>  #define X86_CR4_PKE            (1ul << 22)
>
> +#define X86_PAGE_4K_SHIFT      12
> +#define X86_PAGE_4K            (1ul << X86_PAGE_4K_SHIFT)
> +#define X86_PAGE_2M_SHIFT      21
> +#define X86_PAGE_2M            (1ul << X86_PAGE_2M_SHIFT)
> +#define X86_PAGE_1G_SHIFT      30
> +#define X86_PAGE_1G            (1ul << X86_PAGE_1G_SHIFT)
> +

It would be a nice follow up to use these to clean up the magic
numbers in __virt_pg_map:

const uint64_t pg_size = 1ull << ((page_size * 9) + 12);

:(

>  /* CPUID.1.ECX */
>  #define CPUID_VMX              (1ul << 5)
>  #define CPUID_SMX              (1ul << 6)
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index af1031fed97f..07eb6b5c125e 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -15,6 +15,13 @@
>  #include "linux/kernel.h"
>
>  #include "test_util.h"
> +#include "processor.h"
> +
> +static const char * const pagestat_filepaths[] = {
> +       "/sys/kernel/debug/kvm/pages_4k",
> +       "/sys/kernel/debug/kvm/pages_2m",
> +       "/sys/kernel/debug/kvm/pages_1g",
> +};

I think these should only be defined for x86_64 too. Is this the right
file for these definitions or is there an arch specific file they
should go in?

>
>  /*
>   * Parses "[0-9]+[kmgt]?".
> @@ -141,6 +148,28 @@ size_t get_trans_hugepagesz(void)
>         return size;
>  }
>
> +#ifdef __x86_64__
> +size_t get_stats_from_file(const char *path)
> +{
> +       size_t value;
> +       FILE *f;
> +
> +       f = fopen(path, "r");
> +       TEST_ASSERT(f != NULL, "Error in opening file: %s\n", path);
> +
> +       fscanf(f, "%ld", &value);
> +       fclose(f);
> +
> +       return value;
> +}
> +
> +size_t get_page_stats(uint32_t page_level)
> +{
> +       TEST_ASSERT(page_level <= X86_PAGE_SIZE_1G, "page type error.");
> +       return get_stats_from_file(pagestat_filepaths[page_level]);
> +}
> +#endif
> +
>  size_t get_def_hugetlb_pagesz(void)
>  {
>         char buf[64];
> --
> 2.33.0.259.gc128427fd7-goog
>
