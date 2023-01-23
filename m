Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A518678913
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 22:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjAWVEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 16:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbjAWVEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 16:04:23 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042E232E70
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 13:04:20 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 123so16512834ybv.6
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 13:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6NJAGbNI8oPlvRxeqKL+jenYaYeVQWdxn2l3Nfe6D7c=;
        b=buYyI/i6zjKLibXxssREyjpPcbyoN1RPOD3Mr2byrxfjhqHpZLw/AqJkapNsUVEW+B
         rKCrhVlBGeO30sR7MG9Q1TElbE9H8hwPVFrCZMyn+7Z+XB3eWgdrHp1AXBs2xycAjDhn
         xRwSbpDrn1CK0RQpErR29ntII/yJKEChGwuKWho5ZuAL7ZdzqzU3nGcvCm3WmNQz/gXk
         a6eT18shA38rUPAfsZcWNS4C5zNF58bQjUEShS5dgAQNWS3SpLHtwVKEqg9I1Z9c0Iw4
         7VMz9QJWwvAO716ugceYwfxN5/QVoSz37uazhvsor4soIza3eEQlu6RIj+9/F5EO4ytS
         8erA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6NJAGbNI8oPlvRxeqKL+jenYaYeVQWdxn2l3Nfe6D7c=;
        b=SSyVPwRCBPYalTPmQm2lTp38hapkXmfE+bMstuJkOfZSbQq6VDX4gekT8tBZKgg4Cw
         XU1Vq4C0NVRvjN+ssZ0fqWE3E2sngXMHF+tcDx8tgnGfvXFqLHNyVoF0RMfrQCvKamNV
         k3Me1filABhJhBslMyg5/ROFQ6+IZx+bPhnulXsKVm4AfnFfmNIT36LK8vfDCmnt1Gdd
         WYXAbTlz0PpTw4kT24Y/qe0sWK+Wizg0M+U6Qrsm8U0TAP+CnV5/vvXjwGh8f+vRiJdD
         m1XVPNoWrtcahKuwD28JdGM2X/6UDtpgY9YA6B34h/ANiYtaZS8S1bdbdCP5BEjsDZKV
         teLw==
X-Gm-Message-State: AFqh2koC5Uwzz5z/Ln/CPgnNGRdvRZVomA0jbM55E6PJKkUfSD2bMiFV
        UU+oyUvNLyHae1QNiIF43lskBE0vgGaxkntLMyVbMw==
X-Google-Smtp-Source: AMrXdXtX7vmKPQsg8GJFUHm8aGqlZR2EcPTkJ/DzR+LfCs+E8BLLP9p2bmnrlQG+b+zo+ow4Js75rX7YVtyH8en0K3k=
X-Received: by 2002:a25:d451:0:b0:7ce:4650:5e5a with SMTP id
 m78-20020a25d451000000b007ce46505e5amr2843155ybf.123.1674507859865; Mon, 23
 Jan 2023 13:04:19 -0800 (PST)
MIME-Version: 1.0
References: <20230123190329.520285-1-bgardon@google.com> <20230123190329.520285-2-bgardon@google.com>
In-Reply-To: <20230123190329.520285-2-bgardon@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 23 Jan 2023 13:03:43 -0800
Message-ID: <CAHVum0cJ1MDMNaq24prxTKfp_UypnzSsQ9vXwzUYaSYBn7Ufqg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] selftests: KVM: Move dirty logging functions to memstress.(c|h)
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 11:03 AM Ben Gardon <bgardon@google.com> wrote:
>
> Move some helper functions from dirty_log_perf_test.c to the memstress
> library so that they can be used in a future commit which tests page
> splitting during dirty logging.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 84 ++-----------------
>  .../testing/selftests/kvm/include/memstress.h |  8 ++
>  tools/testing/selftests/kvm/lib/memstress.c   | 72 ++++++++++++++++
>  3 files changed, 87 insertions(+), 77 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index e9d6d1aecf89c..416719e205183 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -136,77 +136,6 @@ struct test_params {
>         bool random_access;
>  };
>
> -static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
> -{
> -       int i;
> -
> -       for (i = 0; i < slots; i++) {
> -               int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
> -               int flags = enable ? KVM_MEM_LOG_DIRTY_PAGES : 0;
> -
> -               vm_mem_region_set_flags(vm, slot, flags);
> -       }
> -}
> -
> -static inline void enable_dirty_logging(struct kvm_vm *vm, int slots)
> -{
> -       toggle_dirty_logging(vm, slots, true);
> -}
> -
> -static inline void disable_dirty_logging(struct kvm_vm *vm, int slots)
> -{
> -       toggle_dirty_logging(vm, slots, false);
> -}
> -
> -static void get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots)
> -{
> -       int i;
> -
> -       for (i = 0; i < slots; i++) {
> -               int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
> -
> -               kvm_vm_get_dirty_log(vm, slot, bitmaps[i]);
> -       }
> -}
> -
> -static void clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
> -                           int slots, uint64_t pages_per_slot)
> -{
> -       int i;
> -
> -       for (i = 0; i < slots; i++) {
> -               int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
> -
> -               kvm_vm_clear_dirty_log(vm, slot, bitmaps[i], 0, pages_per_slot);
> -       }
> -}
> -
> -static unsigned long **alloc_bitmaps(int slots, uint64_t pages_per_slot)
> -{
> -       unsigned long **bitmaps;
> -       int i;
> -
> -       bitmaps = malloc(slots * sizeof(bitmaps[0]));
> -       TEST_ASSERT(bitmaps, "Failed to allocate bitmaps array.");
> -
> -       for (i = 0; i < slots; i++) {
> -               bitmaps[i] = bitmap_zalloc(pages_per_slot);
> -               TEST_ASSERT(bitmaps[i], "Failed to allocate slot bitmap.");
> -       }
> -
> -       return bitmaps;
> -}
> -
> -static void free_bitmaps(unsigned long *bitmaps[], int slots)
> -{
> -       int i;
> -
> -       for (i = 0; i < slots; i++)
> -               free(bitmaps[i]);
> -
> -       free(bitmaps);
> -}
> -
>  static void run_test(enum vm_guest_mode mode, void *arg)
>  {
>         struct test_params *p = arg;
> @@ -236,7 +165,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>         pages_per_slot = host_num_pages / p->slots;
>
> -       bitmaps = alloc_bitmaps(p->slots, pages_per_slot);
> +       bitmaps = memstress_alloc_bitmaps(p->slots, pages_per_slot);
>
>         if (dirty_log_manual_caps)
>                 vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
> @@ -277,7 +206,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>
>         /* Enable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
> -       enable_dirty_logging(vm, p->slots);
> +       memstress_enable_dirty_logging(vm, p->slots);
>         ts_diff = timespec_elapsed(start);
>         pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
> @@ -306,7 +235,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                         iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
>
>                 clock_gettime(CLOCK_MONOTONIC, &start);
> -               get_dirty_log(vm, bitmaps, p->slots);
> +               memstress_get_dirty_log(vm, bitmaps, p->slots);
>                 ts_diff = timespec_elapsed(start);
>                 get_dirty_log_total = timespec_add(get_dirty_log_total,
>                                                    ts_diff);
> @@ -315,7 +244,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>
>                 if (dirty_log_manual_caps) {
>                         clock_gettime(CLOCK_MONOTONIC, &start);
> -                       clear_dirty_log(vm, bitmaps, p->slots, pages_per_slot);
> +                       memstress_clear_dirty_log(vm, bitmaps, p->slots,
> +                                                 pages_per_slot);
>                         ts_diff = timespec_elapsed(start);
>                         clear_dirty_log_total = timespec_add(clear_dirty_log_total,
>                                                              ts_diff);
> @@ -334,7 +264,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>
>         /* Disable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
> -       disable_dirty_logging(vm, p->slots);
> +       memstress_disable_dirty_logging(vm, p->slots);
>         ts_diff = timespec_elapsed(start);
>         pr_info("Disabling dirty logging time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
> @@ -359,7 +289,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                         clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
>         }
>
> -       free_bitmaps(bitmaps, p->slots);
> +       memstress_free_bitmaps(bitmaps, p->slots);
>         arch_cleanup_vm(vm);
>         memstress_destroy_vm(vm);
>  }
> diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
> index 72e3e358ef7bd..ce4e603050eaa 100644
> --- a/tools/testing/selftests/kvm/include/memstress.h
> +++ b/tools/testing/selftests/kvm/include/memstress.h
> @@ -72,4 +72,12 @@ void memstress_guest_code(uint32_t vcpu_id);
>  uint64_t memstress_nested_pages(int nr_vcpus);
>  void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[]);
>
> +void memstress_enable_dirty_logging(struct kvm_vm *vm, int slots);
> +void memstress_disable_dirty_logging(struct kvm_vm *vm, int slots);
> +void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots);
> +void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
> +                              int slots, uint64_t pages_per_slot);
> +unsigned long **memstress_alloc_bitmaps(int slots, uint64_t pages_per_slot);
> +void memstress_free_bitmaps(unsigned long *bitmaps[], int slots);
> +
>  #endif /* SELFTEST_KVM_MEMSTRESS_H */
> diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
> index 5f1d3173c238c..3632956c6bcf5 100644
> --- a/tools/testing/selftests/kvm/lib/memstress.c
> +++ b/tools/testing/selftests/kvm/lib/memstress.c
> @@ -5,6 +5,7 @@
>  #define _GNU_SOURCE
>
>  #include <inttypes.h>
> +#include <linux/bitmap.h>
>
>  #include "kvm_util.h"
>  #include "memstress.h"
> @@ -320,3 +321,74 @@ void memstress_join_vcpu_threads(int nr_vcpus)
>         for (i = 0; i < nr_vcpus; i++)
>                 pthread_join(vcpu_threads[i].thread, NULL);
>  }
> +
> +static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
> +{
> +       int i;
> +
> +       for (i = 0; i < slots; i++) {
> +               int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
> +               int flags = enable ? KVM_MEM_LOG_DIRTY_PAGES : 0;
> +
> +               vm_mem_region_set_flags(vm, slot, flags);
> +       }
> +}
> +
> +void memstress_enable_dirty_logging(struct kvm_vm *vm, int slots)
> +{
> +       toggle_dirty_logging(vm, slots, true);
> +}
> +
> +void memstress_disable_dirty_logging(struct kvm_vm *vm, int slots)
> +{
> +       toggle_dirty_logging(vm, slots, false);
> +}

Very simple functions, maybe just make it inline in the memstress header.

> +
> +void memstress_get_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[], int slots)
> +{
> +       int i;
> +
> +       for (i = 0; i < slots; i++) {
> +               int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
> +
> +               kvm_vm_get_dirty_log(vm, slot, bitmaps[i]);
> +       }
> +}
> +
> +void memstress_clear_dirty_log(struct kvm_vm *vm, unsigned long *bitmaps[],
> +                              int slots, uint64_t pages_per_slot)
> +{
> +       int i;
> +
> +       for (i = 0; i < slots; i++) {
> +               int slot = MEMSTRESS_MEM_SLOT_INDEX + i;
> +
> +               kvm_vm_clear_dirty_log(vm, slot, bitmaps[i], 0, pages_per_slot);
> +       }
> +}
> +
> +unsigned long **memstress_alloc_bitmaps(int slots, uint64_t pages_per_slot)
> +{
> +       unsigned long **bitmaps;
> +       int i;
> +
> +       bitmaps = malloc(slots * sizeof(bitmaps[0]));
> +       TEST_ASSERT(bitmaps, "Failed to allocate bitmaps array.");
> +
> +       for (i = 0; i < slots; i++) {
> +               bitmaps[i] = bitmap_zalloc(pages_per_slot);
> +               TEST_ASSERT(bitmaps[i], "Failed to allocate slot bitmap.");
> +       }
> +
> +       return bitmaps;
> +}
> +
> +void memstress_free_bitmaps(unsigned long *bitmaps[], int slots)
> +{
> +       int i;
> +
> +       for (i = 0; i < slots; i++)
> +               free(bitmaps[i]);
> +
> +       free(bitmaps);
> +}
> --
> 2.39.1.405.gd4c25cc71f-goog
>

Other than the inline suggestion, which is optional.

Reviewed-by: Vipin Sharma <vipinsh@google.com>
