Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E7B44DF49
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 01:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhKLAus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 19:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbhKLAur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 19:50:47 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87152C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 16:47:57 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id l22so18116862lfg.7
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 16:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hQJgRzQ5KbU9M33acHkHn9sWLJ7oISnBVIeIEECtkac=;
        b=d7XBATWgZ7d5Em0byAjDtTk1kJQMiw5TAH0eNamyh7r/bCGGlzWRzxH8j8914n9bU9
         CQx4NiDIzcWyI67hnHjlB70s6uXzcjrY6vd3SBuYAxO/DzQ/hj89Zv2v830XWSxNxf9V
         bjz7cJSChnPC0n95TjUwE7kxtAiGITSphZXEKRYdhonm1V4Q/z0KMjmDlUfHvbxCy3zH
         AHp2ZpMEMStSYA9E9ESjRSyuf2CopJNA+wlN7sQcF0/HJvNBS7WK3Mo8lcNzo0Pcitfg
         sdaebxI/iygRKS1nooubj9trtNa3JysmZkxHlgk7XJKOWuyYgNmEM6O1hX780yoap+nP
         cR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hQJgRzQ5KbU9M33acHkHn9sWLJ7oISnBVIeIEECtkac=;
        b=G9DviqRZaIRd1NJE3TDTPvVys4XGSyN8G6SHerxm/Xgbsi6fFsy7Nl9/prirJcUyVF
         qHGz9uTnYLVbtAXbiU5VaxHIMqB72uqgfznNmZGL9NIfYBGgLmB5Wwc0LyuxjRTr3hf7
         GEgskCtHYAhAitx6NOChgy/nodM05ZoYvW5egDkRXAsL/WZswJx3jBfujGxxzj6ZXqTJ
         lGg//vE87xl5oymySheb9mSLIlDA+UX8QkzFVYoJdbaVbDOUS2PKKtzInBTuKHf21Fku
         1wxK4H/dndjqz1/KdTe5q+D+RC4NgXzttfeOdnLGV1SBFLMnH1Y/jCcfkpxZd01O54/M
         Gtpg==
X-Gm-Message-State: AOAM533jVKlCQRD7rXCclwEPdAlae/LE78myY0xuxG6djgGfFbwCDdgf
        i1fKPDia80G5YEgW4GusxTph1JydNZouIpAHfRMsjA==
X-Google-Smtp-Source: ABdhPJw7FHKsbHNTuqetkQWlQXsqMDXmyjFCuwnPMWy2IucOA8X97Fq/Xl+PWyo17yGHy2bqtZhb3SjZSdufWbEhzjA=
X-Received: by 2002:a05:6512:3501:: with SMTP id h1mr10478289lfs.235.1636678075614;
 Thu, 11 Nov 2021 16:47:55 -0800 (PST)
MIME-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com> <20211111001257.1446428-3-dmatlack@google.com>
 <CANgfPd-vkHxW+CdXRWVHQturF2GTC4mjyKVsAL_AkBXGXpy_DA@mail.gmail.com>
In-Reply-To: <CANgfPd-vkHxW+CdXRWVHQturF2GTC4mjyKVsAL_AkBXGXpy_DA@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 11 Nov 2021 16:47:28 -0800
Message-ID: <CALzav=cpym8WEnO2wQMdJxOsor3iEnf8AKgx2J10DTkp_M-7mw@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Move vCPU thread creation and joining
 to common helpers
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021 at 10:08 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Nov 10, 2021 at 4:13 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Move vCPU thread creation and joining to common helper functions. This
> > is in preparation for the next commit which ensures that all vCPU
> > threads are fully created before entering guest mode on any one
> > vCPU.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Reviewed-by: Ben Gardon <bgardon@google.com>
>
> Besides one comment below, this is an awesome cleanup!
>
> > ---
> >  .../selftests/kvm/access_tracking_perf_test.c | 40 +++-------------
> >  .../selftests/kvm/demand_paging_test.c        | 25 ++--------
> >  .../selftests/kvm/dirty_log_perf_test.c       | 19 ++------
> >  .../selftests/kvm/include/perf_test_util.h    |  5 ++
> >  .../selftests/kvm/lib/perf_test_util.c        | 46 +++++++++++++++++++
> >  .../kvm/memslot_modification_stress_test.c    | 22 ++-------
> >  6 files changed, 67 insertions(+), 90 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > index 7f25a06e19c9..d8909032317a 100644
> > --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > @@ -215,9 +215,8 @@ static bool spin_wait_for_next_iteration(int *current_iteration)
> >         return true;
> >  }
> >
> > -static void *vcpu_thread_main(void *arg)
> > +static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
> >  {
> > -       struct perf_test_vcpu_args *vcpu_args = arg;
> >         struct kvm_vm *vm = perf_test_args.vm;
> >         int vcpu_id = vcpu_args->vcpu_id;
> >         int current_iteration = 0;
> > @@ -235,8 +234,6 @@ static void *vcpu_thread_main(void *arg)
> >
> >                 vcpu_last_completed_iteration[vcpu_id] = current_iteration;
> >         }
> > -
> > -       return NULL;
> >  }
> >
> >  static void spin_wait_for_vcpu(int vcpu_id, int target_iteration)
> > @@ -295,43 +292,16 @@ static void mark_memory_idle(struct kvm_vm *vm, int vcpus)
> >         run_iteration(vm, vcpus, "Mark memory idle");
> >  }
> >
> > -static pthread_t *create_vcpu_threads(int vcpus)
> > -{
> > -       pthread_t *vcpu_threads;
> > -       int i;
> > -
> > -       vcpu_threads = malloc(vcpus * sizeof(vcpu_threads[0]));
> > -       TEST_ASSERT(vcpu_threads, "Failed to allocate vcpu_threads.");
> > -
> > -       for (i = 0; i < vcpus; i++)
> > -               pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main,
> > -                              &perf_test_args.vcpu_args[i]);
> > -
> > -       return vcpu_threads;
> > -}
> > -
> > -static void terminate_vcpu_threads(pthread_t *vcpu_threads, int vcpus)
> > -{
> > -       int i;
> > -
> > -       /* Set done to signal the vCPU threads to exit */
> > -       done = true;
> > -
> > -       for (i = 0; i < vcpus; i++)
> > -               pthread_join(vcpu_threads[i], NULL);
> > -}
> > -
> >  static void run_test(enum vm_guest_mode mode, void *arg)
> >  {
> >         struct test_params *params = arg;
> >         struct kvm_vm *vm;
> > -       pthread_t *vcpu_threads;
> >         int vcpus = params->vcpus;
> >
> >         vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes, 1,
> >                                  params->backing_src, !overlap_memory_access);
> >
> > -       vcpu_threads = create_vcpu_threads(vcpus);
> > +       perf_test_start_vcpu_threads(vcpus, vcpu_thread_main);
> >
> >         pr_info("\n");
> >         access_memory(vm, vcpus, ACCESS_WRITE, "Populating memory");
> > @@ -346,8 +316,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         mark_memory_idle(vm, vcpus);
> >         access_memory(vm, vcpus, ACCESS_READ, "Reading from idle memory");
> >
> > -       terminate_vcpu_threads(vcpu_threads, vcpus);
> > -       free(vcpu_threads);
> > +       /* Set done to signal the vCPU threads to exit */
> > +       done = true;
> > +
> > +       perf_test_join_vcpu_threads(vcpus);
> >         perf_test_destroy_vm(vm);
> >  }
> >
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index 26f8fd8a57ec..6a719d065599 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -42,10 +42,9 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> >  static size_t demand_paging_size;
> >  static char *guest_data_prototype;
> >
> > -static void *vcpu_worker(void *data)
> > +static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
> >  {
> >         int ret;
> > -       struct perf_test_vcpu_args *vcpu_args = (struct perf_test_vcpu_args *)data;
> >         int vcpu_id = vcpu_args->vcpu_id;
> >         struct kvm_vm *vm = perf_test_args.vm;
> >         struct kvm_run *run;
> > @@ -68,8 +67,6 @@ static void *vcpu_worker(void *data)
> >         ts_diff = timespec_elapsed(start);
> >         PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_id,
> >                        ts_diff.tv_sec, ts_diff.tv_nsec);
> > -
> > -       return NULL;
> >  }
> >
> >  static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t addr)
> > @@ -282,7 +279,6 @@ struct test_params {
> >  static void run_test(enum vm_guest_mode mode, void *arg)
> >  {
> >         struct test_params *p = arg;
> > -       pthread_t *vcpu_threads;
> >         pthread_t *uffd_handler_threads = NULL;
> >         struct uffd_handler_args *uffd_args = NULL;
> >         struct timespec start;
> > @@ -302,9 +298,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >                     "Failed to allocate buffer for guest data pattern");
> >         memset(guest_data_prototype, 0xAB, demand_paging_size);
> >
> > -       vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
> > -       TEST_ASSERT(vcpu_threads, "Memory allocation failed");
> > -
> >         if (p->uffd_mode) {
> >                 uffd_handler_threads =
> >                         malloc(nr_vcpus * sizeof(*uffd_handler_threads));
> > @@ -346,22 +339,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         pr_info("Finished creating vCPUs and starting uffd threads\n");
> >
> >         clock_gettime(CLOCK_MONOTONIC, &start);
> > -
> > -       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> > -               pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
> > -                              &perf_test_args.vcpu_args[vcpu_id]);
> > -       }
> > -
> > +       perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
> >         pr_info("Started all vCPUs\n");
> >
> > -       /* Wait for the vcpu threads to quit */
> > -       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> > -               pthread_join(vcpu_threads[vcpu_id], NULL);
> > -               PER_VCPU_DEBUG("Joined thread for vCPU %d\n", vcpu_id);
> > -       }
> > -
> > +       perf_test_join_vcpu_threads(nr_vcpus);
> >         ts_diff = timespec_elapsed(start);
> > -
> >         pr_info("All vCPU threads joined\n");
> >
> >         if (p->uffd_mode) {
> > @@ -385,7 +367,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         perf_test_destroy_vm(vm);
> >
> >         free(guest_data_prototype);
> > -       free(vcpu_threads);
> >         if (p->uffd_mode) {
> >                 free(uffd_handler_threads);
> >                 free(uffd_args);
> > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > index 583b4d95aa98..1954b964d1cf 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > @@ -31,7 +31,7 @@ static bool host_quit;
> >  static int iteration;
> >  static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
> >
> > -static void *vcpu_worker(void *data)
> > +static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
> >  {
> >         int ret;
> >         struct kvm_vm *vm = perf_test_args.vm;
> > @@ -41,7 +41,6 @@ static void *vcpu_worker(void *data)
> >         struct timespec ts_diff;
> >         struct timespec total = (struct timespec){0};
> >         struct timespec avg;
> > -       struct perf_test_vcpu_args *vcpu_args = (struct perf_test_vcpu_args *)data;
> >         int vcpu_id = vcpu_args->vcpu_id;
> >
> >         run = vcpu_state(vm, vcpu_id);
> > @@ -83,8 +82,6 @@ static void *vcpu_worker(void *data)
> >         pr_debug("\nvCPU %d dirtied 0x%lx pages over %d iterations in %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
> >                 vcpu_id, pages_count, vcpu_last_completed_iteration[vcpu_id],
> >                 total.tv_sec, total.tv_nsec, avg.tv_sec, avg.tv_nsec);
> > -
> > -       return NULL;
> >  }
> >
> >  struct test_params {
> > @@ -170,7 +167,6 @@ static void free_bitmaps(unsigned long *bitmaps[], int slots)
> >  static void run_test(enum vm_guest_mode mode, void *arg)
> >  {
> >         struct test_params *p = arg;
> > -       pthread_t *vcpu_threads;
> >         struct kvm_vm *vm;
> >         unsigned long **bitmaps;
> >         uint64_t guest_num_pages;
> > @@ -204,20 +200,15 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >                 vm_enable_cap(vm, &cap);
> >         }
> >
> > -       vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
> > -       TEST_ASSERT(vcpu_threads, "Memory allocation failed");
> > -
> >         /* Start the iterations */
> >         iteration = 0;
> >         host_quit = false;
> >
> >         clock_gettime(CLOCK_MONOTONIC, &start);
> > -       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> > +       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
> >                 vcpu_last_completed_iteration[vcpu_id] = -1;
>
> Did you miss this in the previous commit or mean to leave it here?

Ah I missed cleaning this one up. I'll get rid of this in v2. Thanks!

>
> >
> > -               pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
> > -                              &perf_test_args.vcpu_args[vcpu_id]);
> > -       }
> > +       perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
> >
> >         /* Allow the vCPUs to populate memory */
> >         pr_debug("Starting iteration %d - Populating\n", iteration);
> > @@ -286,8 +277,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >
> >         /* Tell the vcpu thread to quit */
> >         host_quit = true;
> > -       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
> > -               pthread_join(vcpu_threads[vcpu_id], NULL);
> > +       perf_test_join_vcpu_threads(nr_vcpus);
> >
> >         avg = timespec_div(get_dirty_log_total, p->iterations);
> >         pr_info("Get dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
> > @@ -302,7 +292,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         }
> >
> >         free_bitmaps(bitmaps, p->slots);
> > -       free(vcpu_threads);
> >         perf_test_destroy_vm(vm);
> >  }
> >
> > diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> > index 74e3622b3a6e..a86f953d8d36 100644
> > --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> > +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> > @@ -8,6 +8,8 @@
> >  #ifndef SELFTEST_KVM_PERF_TEST_UTIL_H
> >  #define SELFTEST_KVM_PERF_TEST_UTIL_H
> >
> > +#include <pthread.h>
> > +
> >  #include "kvm_util.h"
> >
> >  /* Default guest test virtual memory offset */
> > @@ -45,4 +47,7 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
> >
> >  void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> >
> > +void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
> > +void perf_test_join_vcpu_threads(int vcpus);
> > +
> >  #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > index 77f9eb5667c9..d646477ed16a 100644
> > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > @@ -16,6 +16,20 @@ struct perf_test_args perf_test_args;
> >   */
> >  static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
> >
> > +struct vcpu_thread {
> > +       /* The id of the vCPU. */
> > +       int vcpu_id;
> > +
> > +       /* The pthread backing the vCPU. */
> > +       pthread_t thread;
> > +};
> > +
> > +/* The vCPU threads involved in this test. */
> > +static struct vcpu_thread vcpu_threads[KVM_MAX_VCPUS];
> > +
> > +/* The function run by each vCPU thread, as provided by the test. */
> > +static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
> > +
> >  /*
> >   * Continuously write to the first 8 bytes of each page in the
> >   * specified region.
> > @@ -177,3 +191,35 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
> >         perf_test_args.wr_fract = wr_fract;
> >         sync_global_to_guest(vm, perf_test_args);
> >  }
> > +
> > +static void *vcpu_thread_main(void *data)
> > +{
> > +       struct vcpu_thread *vcpu = data;
> > +
> > +       vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_id]);
> > +
> > +       return NULL;
> > +}
> > +
> > +void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *))
> > +{
> > +       int vcpu_id;
> > +
> > +       vcpu_thread_fn = vcpu_fn;
> > +
> > +       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> > +               struct vcpu_thread *vcpu = &vcpu_threads[vcpu_id];
> > +
> > +               vcpu->vcpu_id = vcpu_id;
> > +
> > +               pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
> > +       }
> > +}
> > +
> > +void perf_test_join_vcpu_threads(int vcpus)
> > +{
> > +       int vcpu_id;
> > +
> > +       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++)
> > +               pthread_join(vcpu_threads[vcpu_id].thread, NULL);
> > +}
> > diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > index df431d0da1ee..5bd0b076f57f 100644
> > --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > @@ -36,11 +36,9 @@ static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> >
> >  static bool run_vcpus = true;
> >
> > -static void *vcpu_worker(void *data)
> > +static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
> >  {
> >         int ret;
> > -       struct perf_test_vcpu_args *vcpu_args =
> > -               (struct perf_test_vcpu_args *)data;
> >         int vcpu_id = vcpu_args->vcpu_id;
> >         struct kvm_vm *vm = perf_test_args.vm;
> >         struct kvm_run *run;
> > @@ -59,8 +57,6 @@ static void *vcpu_worker(void *data)
> >                             "Invalid guest sync status: exit_reason=%s\n",
> >                             exit_reason_str(run->exit_reason));
> >         }
> > -
> > -       return NULL;
> >  }
> >
> >  struct memslot_antagonist_args {
> > @@ -100,22 +96,15 @@ struct test_params {
> >  static void run_test(enum vm_guest_mode mode, void *arg)
> >  {
> >         struct test_params *p = arg;
> > -       pthread_t *vcpu_threads;
> >         struct kvm_vm *vm;
> > -       int vcpu_id;
> >
> >         vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
> >                                  VM_MEM_SRC_ANONYMOUS,
> >                                  p->partition_vcpu_memory_access);
> >
> > -       vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
> > -       TEST_ASSERT(vcpu_threads, "Memory allocation failed");
> > -
> >         pr_info("Finished creating vCPUs\n");
> >
> > -       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
> > -               pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
> > -                              &perf_test_args.vcpu_args[vcpu_id]);
> > +       perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
> >
> >         pr_info("Started all vCPUs\n");
> >
> > @@ -124,16 +113,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >
> >         run_vcpus = false;
> >
> > -       /* Wait for the vcpu threads to quit */
> > -       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
> > -               pthread_join(vcpu_threads[vcpu_id], NULL);
> > -
> > +       perf_test_join_vcpu_threads(nr_vcpus);
> >         pr_info("All vCPU threads joined\n");
> >
> >         ucall_uninit(vm);
> >         kvm_vm_free(vm);
> > -
> > -       free(vcpu_threads);
> >  }
> >
> >  static void help(char *name)
> > --
> > 2.34.0.rc1.387.gb447b232ab-goog
> >
