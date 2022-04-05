Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055CF4F4989
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442429AbiDEWTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243390AbiDEVSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 17:18:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B46C15AAED
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 13:59:07 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o20so161542pla.13
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 13:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ezjtcPlO0mMLbkYiwNoWZm/+s1Sh7UAA+FDLobt63qo=;
        b=Ncs0aVGlPRpb3HzCFBEcV6N/NELP7h0z96uPptmplnTnMfiF7AcghURt8+4uNrD8Pr
         UMmv75jcVVj+QPk8hBrotjKy0cq0MbX4UTMxASPENCiRk0iACrlrGsJh2QO1kJTDwy87
         vF8qfcg+7wAFsZuE/QXOGRrXHZBorHmNcHgLA5rCU6T6A0I4xiN2iDmVg7fJOVlTlMaA
         7x4ybf7yqlIKDgDEH6UWS3ZH4oKJBLwrIrXESQg3ux/H7l6zfiyydx1boW4riBw+uDXi
         fXQ/9JVguoT7niOpTUi1KTFKrVRTj25IvkSAp1xObyLYlirEIvUVVFWkbNZ9+Nkc2l8J
         LIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ezjtcPlO0mMLbkYiwNoWZm/+s1Sh7UAA+FDLobt63qo=;
        b=xk59tJE7OS51+tH1x3IH6hP0bAUc6DbmSk1dumBMeJr1XzMMnZ9rlcETFGdusyzujC
         p7kg0sn4n0ZkaWHTY0c4WSjPu0uF2TFqXzIf9GMisVctBpjyi9a5ymPOpWGhUcLtfksN
         N303RyrYqqWEJKoGt76Q8IXOBB4zrHM4+qE1im7TjiGbCIWOymuWU1UIsYEfltt+pIK+
         DEXgsRnjb8v0kwclQhEfW3n0k2kcDirG7SUKRWjbXFwmYTJswVQWnHWBNbgrGrqMeDO6
         wOUVGlnmpPzu4Ho7n+4q7cXDJyO0TwWkACtKs05+UUBPqa5fMruCM6Sf7wAwOMDi8xre
         TLQA==
X-Gm-Message-State: AOAM532D4FyEFmjDpEBo85EMYl833d/17XtT6cKQOUzCoHVJKKYzXfDh
        8doJlQHO7VldFMWuvQdF3ToAG0658pAI/w==
X-Google-Smtp-Source: ABdhPJwkrBHUF1KKo7VKaAtrfQsT4Q0y6xwjs5BLTWAwjZD/XX9VekXABtEWWcycNJbAjBDq7L7qbA==
X-Received: by 2002:a17:90b:4a06:b0:1c7:2020:b5b9 with SMTP id kk6-20020a17090b4a0600b001c72020b5b9mr6143915pjb.58.1649192346695;
        Tue, 05 Apr 2022 13:59:06 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id v13-20020aa799cd000000b004fdaae0a91bsm16711078pfi.20.2022.04.05.13.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 13:59:05 -0700 (PDT)
Date:   Tue, 5 Apr 2022 20:59:01 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 1/3] KVM: selftests: Introduce a selftest to measure
 execution performance
Message-ID: <YkytldsRzFiwgN5H@google.com>
References: <20220401233737.3021889-1-dmatlack@google.com>
 <20220401233737.3021889-2-dmatlack@google.com>
 <CANgfPd9pqE3X9U1sJds7p9frc2n36eK-HJqyLWU7VBXk8h6vEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9pqE3X9U1sJds7p9frc2n36eK-HJqyLWU7VBXk8h6vEg@mail.gmail.com>
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

On Mon, Apr 04, 2022 at 11:13:40AM -0700, Ben Gardon wrote:
> On Fri, Apr 1, 2022 at 4:37 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Introduce a new selftest, execute_perf_test, that uses the
> > perf_test_util framework to measure the performance of executing code
> > within a VM. This test is similar to the other perf_test_util-based
> > tests in that it spins up a variable number of vCPUs and runs them
> > concurrently, accessing memory.
> >
> > In order to support executiong, extend perf_test_util to populate guest
> 
> *executing instructions in the data slot,
> 
> > memory with return instructions rather than random garbage. This way
> > memory can be execute simply by calling it.
> 
> *executed
> 
> >
> > Currently only x86-64 supports execution, but other architectures can be
> > easily added by providing their return code instruction.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../testing/selftests/kvm/execute_perf_test.c | 188 ++++++++++++++++++
> >  .../selftests/kvm/include/perf_test_util.h    |   2 +
> >  .../selftests/kvm/lib/perf_test_util.c        |  25 ++-
> >  5 files changed, 215 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c
> >
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 1f1b6c978bf7..3647ddacb103 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -56,6 +56,7 @@
> >  /demand_paging_test
> >  /dirty_log_test
> >  /dirty_log_perf_test
> > +/execute_perf_test
> >  /hardware_disable_test
> >  /kvm_create_max_vcpus
> >  /kvm_page_table_test
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index c9cdbd248727..3c67346b0766 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -92,6 +92,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
> >  TEST_GEN_PROGS_x86_64 += demand_paging_test
> >  TEST_GEN_PROGS_x86_64 += dirty_log_test
> >  TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
> > +TEST_GEN_PROGS_x86_64 += execute_perf_test
> >  TEST_GEN_PROGS_x86_64 += hardware_disable_test
> >  TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
> >  TEST_GEN_PROGS_x86_64 += kvm_page_table_test
> > diff --git a/tools/testing/selftests/kvm/execute_perf_test.c b/tools/testing/selftests/kvm/execute_perf_test.c
> > new file mode 100644
> > index 000000000000..fa78facf44e7
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/execute_perf_test.c
> > @@ -0,0 +1,188 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <inttypes.h>
> > +#include <limits.h>
> > +#include <pthread.h>
> > +#include <sys/mman.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +
> > +#include "kvm_util.h"
> > +#include "test_util.h"
> > +#include "perf_test_util.h"
> > +#include "guest_modes.h"
> > +
> > +/* Global variable used to synchronize all of the vCPU threads. */
> > +static int iteration;
> 
> Should this be volatile? (same for other globals)

Or atomic_t. This is a common pattern across almost all of the
perf_test_util-based tests that needs to be addressed.

> 
> > +
> > +/* Set to true when vCPU threads should exit. */
> > +static bool done;
> > +
> > +/* The iteration that was last completed by each vCPU. */
> > +static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
> > +
> > +/* Whether to overlap the regions of memory vCPUs access. */
> > +static bool overlap_memory_access;
> 
> Can this be factored into the perf test util framework / test params?

Yes. I'm planning to do a larger refactor of the perf_test_util
framework to consolidate code like this. But I want to leave that to a
separate series.

I'd be fine with deferring this test until that refactor is complete but
I don't think it's stricly necessary.

> 
> > +
> > +struct test_params {
> > +       /* The backing source for the region of memory. */
> > +       enum vm_mem_backing_src_type backing_src;
> > +
> > +       /* The amount of memory to allocate for each vCPU. */
> > +       uint64_t vcpu_memory_bytes;
> > +
> > +       /* The number of vCPUs to create in the VM. */
> > +       int vcpus;
> > +};
> > +
> > +static void assert_ucall(struct kvm_vm *vm, uint32_t vcpu_id,
> > +                        uint64_t expected_ucall)
> > +{
> > +       struct ucall uc;
> > +       uint64_t actual_ucall = get_ucall(vm, vcpu_id, &uc);
> > +
> > +       TEST_ASSERT(expected_ucall == actual_ucall,
> > +                   "Guest exited unexpectedly (expected ucall %" PRIu64
> > +                   ", got %" PRIu64 ")",
> > +                   expected_ucall, actual_ucall);
> > +}
> > +
> > +static bool spin_wait_for_next_iteration(int *current_iteration)
> > +{
> > +       int last_iteration = *current_iteration;
> > +
> > +       do {
> > +               if (READ_ONCE(done))
> > +                       return false;
> > +
> > +               *current_iteration = READ_ONCE(iteration);
> > +       } while (last_iteration == *current_iteration);
> > +
> > +       return true;
> > +}
> > +
> > +static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
> > +{
> > +       struct kvm_vm *vm = perf_test_args.vm;
> > +       int vcpu_id = vcpu_args->vcpu_id;
> > +       int current_iteration = 0;
> > +
> > +       while (spin_wait_for_next_iteration(&current_iteration)) {
> > +               vcpu_run(vm, vcpu_id);
> > +               assert_ucall(vm, vcpu_id, UCALL_SYNC);
> > +               vcpu_last_completed_iteration[vcpu_id] = current_iteration;
> > +       }
> > +}
> > +
> > +static void spin_wait_for_vcpu(int vcpu_id, int target_iteration)
> > +{
> > +       while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) !=
> > +              target_iteration) {
> > +               continue;
> > +       }
> > +}
> > +
> > +static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
> > +{
> > +       struct timespec ts_start;
> > +       struct timespec ts_elapsed;
> > +       int next_iteration;
> > +       int vcpu_id;
> > +
> > +       /* Kick off the vCPUs by incrementing iteration. */
> > +       next_iteration = ++iteration;
> > +
> > +       clock_gettime(CLOCK_MONOTONIC, &ts_start);
> > +
> > +       /* Wait for all vCPUs to finish the iteration. */
> > +       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++)
> > +               spin_wait_for_vcpu(vcpu_id, next_iteration);
> > +
> > +       ts_elapsed = timespec_elapsed(ts_start);
> > +       pr_info("%-30s: %ld.%09lds\n",
> > +               description, ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
> > +}
> > +
> > +static void run_test(enum vm_guest_mode mode, void *arg)
> > +{
> > +       struct test_params *params = arg;
> > +       struct kvm_vm *vm;
> > +       int vcpus = params->vcpus;
> > +
> > +       vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes, 1,
> > +                                params->backing_src, !overlap_memory_access);
> > +
> > +       perf_test_start_vcpu_threads(vcpus, vcpu_thread_main);
> > +
> > +       pr_info("\n");
> > +
> > +       perf_test_set_wr_fract(vm, 1);
> > +       run_iteration(vm, vcpus, "Populating memory");
> > +
> > +       perf_test_set_execute(vm, true);
> > +       run_iteration(vm, vcpus, "Executing from memory");
> > +
> > +       /* Set done to signal the vCPU threads to exit */
> > +       done = true;
> > +
> > +       perf_test_join_vcpu_threads(vcpus);
> > +       perf_test_destroy_vm(vm);
> > +}
> > +
> > +static void help(char *name)
> > +{
> > +       puts("");
> > +       printf("usage: %s [-h] [-m mode] [-b vcpu_bytes] [-v vcpus] [-o]  [-s mem_type]\n",
> > +              name);
> > +       puts("");
> > +       printf(" -h: Display this help message.");
> > +       guest_modes_help();
> > +       printf(" -b: specify the size of the memory region which should be\n"
> > +              "     dirtied by each vCPU. e.g. 10M or 3G.\n"
> > +              "     (default: 1G)\n");
> > +       printf(" -v: specify the number of vCPUs to run.\n");
> > +       printf(" -o: Overlap guest memory accesses instead of partitioning\n"
> > +              "     them into a separate region of memory for each vCPU.\n");
> > +       backing_src_help("-s");
> > +       puts("");
> > +       exit(0);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +       struct test_params params = {
> > +               .backing_src = DEFAULT_VM_MEM_SRC,
> > +               .vcpu_memory_bytes = DEFAULT_PER_VCPU_MEM_SIZE,
> > +               .vcpus = 1,
> > +       };
> > +       int opt;
> > +
> > +       guest_modes_append_default();
> > +
> > +       while ((opt = getopt(argc, argv, "hm:b:v:os:")) != -1) {
> > +               switch (opt) {
> > +               case 'm':
> > +                       guest_modes_cmdline(optarg);
> > +                       break;
> > +               case 'b':
> > +                       params.vcpu_memory_bytes = parse_size(optarg);
> > +                       break;
> > +               case 'v':
> > +                       params.vcpus = atoi(optarg);
> > +                       break;
> > +               case 'o':
> > +                       overlap_memory_access = true;
> > +                       break;
> > +               case 's':
> > +                       params.backing_src = parse_backing_src_type(optarg);
> > +                       break;
> > +               case 'h':
> > +               default:
> > +                       help(argv[0]);
> > +                       break;
> > +               }
> > +       }
> > +
> > +       for_each_guest_mode(run_test, &params);
> > +
> > +       return 0;
> > +}
> > diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> > index a86f953d8d36..0a5a56539aff 100644
> > --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> > +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> > @@ -33,6 +33,7 @@ struct perf_test_args {
> >         uint64_t gpa;
> >         uint64_t guest_page_size;
> >         int wr_fract;
> > +       bool execute;
> >
> >         struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
> >  };
> > @@ -46,6 +47,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
> >  void perf_test_destroy_vm(struct kvm_vm *vm);
> >
> >  void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> > +void perf_test_set_execute(struct kvm_vm *vm, bool execute);
> >
> >  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
> >  void perf_test_join_vcpu_threads(int vcpus);
> > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > index 722df3a28791..1a5eb60b59da 100644
> > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > @@ -36,6 +36,16 @@ static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
> >  /* Set to true once all vCPU threads are up and running. */
> >  static bool all_vcpu_threads_running;
> >
> > +/*
> > + * When writing to guest memory, write the opcode for the `ret` instruction so
> > + * that subsequent iteractions can exercise instruction fetch by calling the
> > + * memory.
> > + *
> > + * NOTE: Non-x86 architectures would to use different values here to support
> > + * execute.
> > + */
> > +#define RETURN_OPCODE 0xC3
> > +
> 
> This should be defined in an arch-specific header or surrounded by
> ifdefs so that the build would fail for other archs.

Agreed, this should really go in an x86-specific header file. There's no
correctness issue (0xC3 works just as well as 0x0123456789ABCDEF and
non-x86 architectures are prevented from setting execute to true in
perf_test_set_execute()), but this is a lazy way to structure the code.

> 
> >  /*
> >   * Continuously write to the first 8 bytes of each page in the
> >   * specified region.
> > @@ -58,8 +68,10 @@ static void guest_code(uint32_t vcpu_id)
> >                 for (i = 0; i < pages; i++) {
> >                         uint64_t addr = gva + (i * pta->guest_page_size);
> >
> > -                       if (i % pta->wr_fract == 0)
> > -                               *(uint64_t *)addr = 0x0123456789ABCDEF;
> > +                       if (pta->execute)
> > +                               ((void (*)(void)) addr)();
> > +                       else if (i % pta->wr_fract == 0)
> > +                               *(uint64_t *)addr = RETURN_OPCODE;
> 
> Oh interesting, you're using a write pass to set up the contents of
> memory. I suppose that probably ends up being faster than memset, but
> it introduces kind of a strange dependency.

It also allows the memory to be mapped in a huge pages first so then it
can be split via NX HugePages. But I agree it's a strange dependency.
I'll have to think more about how to better structure this code.

> 
> >                         else
> >                                 READ_ONCE(*(uint64_t *)addr);
> >                 }
> > @@ -198,6 +210,15 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
> >         sync_global_to_guest(vm, perf_test_args);
> >  }
> >
> > +void perf_test_set_execute(struct kvm_vm *vm, bool execute)
> > +{
> > +#ifndef __x86_64__
> > +       TEST_ASSERT(false, "Execute not supported on this architure; see RETURN_OPCODE.");
> > +#endif
> > +       perf_test_args.execute = execute;
> > +       sync_global_to_guest(vm, perf_test_args);
> > +}
> > +
> >  static void *vcpu_thread_main(void *data)
> >  {
> >         struct vcpu_thread *vcpu = data;
> >
> > base-commit: d1fb6a1ca3e535f89628193ab94203533b264c8c
> > --
> > 2.35.1.1094.g7c7d902a7c-goog
> >
