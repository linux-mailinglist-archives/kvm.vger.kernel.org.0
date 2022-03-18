Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7104C4DE283
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 21:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbiCRU3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 16:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiCRU3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 16:29:21 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE936E2A6
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:27:58 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e6so5793940pgn.2
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LaiVYd6GJvI6PMAwhHm2QeTd3AhiKaEd2MQ1wU3zw60=;
        b=S9Fv1y7sWhzHm9jxK8sBQjW5CQ8OJ1iOyE7s/j3LVEH8lFbneFn5m3bZo2dZbBnnNw
         /Vawb06FjTdoOEnQeHZsMlBEoyv8fAxH3PJfl2bnuhuGTspzv4hYMWAaIrQ5jA9hnpnD
         mLbCb7C5Sj4uXL4uOl5dDmqvrKsYASJC5NGbbC/xldr7l4RlcyRvJjuowk3vmngWVgYS
         jk1fgYldN1FV9gLyvV5VPmTUHWt69IicjXkmSSZMRA2CYOKqMSBcexApMtkuXXcice+i
         FVdYBIs3bFhvzpyGNioOS7l3/tH5V7nfl2K/HRzljsv3NqFhoK7++02mfBU9D31vtNbU
         ImXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LaiVYd6GJvI6PMAwhHm2QeTd3AhiKaEd2MQ1wU3zw60=;
        b=AL/NaMCLgU23GlUidoxez9X1/E1+m9AQxI2bqI3RHnO9WTipb/goc2ae3KLLYW3lwk
         rwlu7fUSwTaIMe/R80STnozRXNqu1Td5WEZtzfDPykY2kFTw5BWu3BgJmJOnYBz1zHlJ
         UqpEXRQnOAPxhmGCmJDzbg8s2G2I8eq4sOZ9CVAGmnwe6+g1idZbGqI6fHabKU/NPRqA
         Q4+bqAUVMlyAGiAwy84D1ikguKJWhELFQpqAA2deRF0LdU9YRawf8kbikqtsv3uE/GGK
         bVS7nhVU86XJ8Bdtay/2dPip6kuxQYd3k6WQFZtcE8BGUSY06SFzoZNDTiVgbHP9pyTR
         b0Qw==
X-Gm-Message-State: AOAM531lPEO/DO4Pz7bQfvsFMuFS61kSMYQDNyZVG2F7WvHThmRKEzzR
        OdM3f5gtK5hEHajDNCk6JtxlhQ==
X-Google-Smtp-Source: ABdhPJxG1cKEsL3x/tGAsm0Ei/AMtJUoTj6AD4K9fD1hi3hOv5oUlasoZvdZf04wXpsu1bMgzMTRUw==
X-Received: by 2002:a63:111a:0:b0:382:3e2d:c237 with SMTP id g26-20020a63111a000000b003823e2dc237mr2140737pgl.22.1647635277305;
        Fri, 18 Mar 2022 13:27:57 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id p15-20020a056a000b4f00b004f7b71f8bd6sm10558178pfo.47.2022.03.18.13.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:27:56 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:27:52 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 01/11] KVM: selftests: Add a userfaultfd library
Message-ID: <YjTrSOROmPhEhFOr@google.com>
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-2-ricarkol@google.com>
 <CANgfPd81R3oiyYeC6PucqFdUEWYzf9ooqCb_gJWf2URxnPabwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd81R3oiyYeC6PucqFdUEWYzf9ooqCb_gJWf2URxnPabwQ@mail.gmail.com>
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

On Wed, Mar 16, 2022 at 12:02:18PM -0600, Ben Gardon wrote:
> On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Move the generic userfaultfd code out of demand_paging_test.c into a
> > common library, userfaultfd_util. This library consists of a setup and a
> > stop function. The setup function starts a thread for handling page
> > faults using the handler callback function. This setup returns a
> > uffd_desc object which is then used in the stop function (to wait and
> > destroy the threads).
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   2 +-
> >  .../selftests/kvm/demand_paging_test.c        | 227 +++---------------
> >  .../selftests/kvm/include/userfaultfd_util.h  |  46 ++++
> >  .../selftests/kvm/lib/userfaultfd_util.c      | 196 +++++++++++++++
> >  4 files changed, 272 insertions(+), 199 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 0e4926bc9a58..bc5f89b3700e 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -37,7 +37,7 @@ ifeq ($(ARCH),riscv)
> >         UNAME_M := riscv
> >  endif
> >
> > -LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
> > +LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c lib/userfaultfd_util.c
> >  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> >  LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
> >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index 6a719d065599..b3d457cecd68 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -22,23 +22,13 @@
> >  #include "test_util.h"
> >  #include "perf_test_util.h"
> >  #include "guest_modes.h"
> > +#include "userfaultfd_util.h"
> >
> >  #ifdef __NR_userfaultfd
> >
> > -#ifdef PRINT_PER_PAGE_UPDATES
> > -#define PER_PAGE_DEBUG(...) printf(__VA_ARGS__)
> > -#else
> > -#define PER_PAGE_DEBUG(...) _no_printf(__VA_ARGS__)
> > -#endif
> > -
> > -#ifdef PRINT_PER_VCPU_UPDATES
> > -#define PER_VCPU_DEBUG(...) printf(__VA_ARGS__)
> > -#else
> > -#define PER_VCPU_DEBUG(...) _no_printf(__VA_ARGS__)
> > -#endif
> > -
> >  static int nr_vcpus = 1;
> >  static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> > +
> >  static size_t demand_paging_size;
> >  static char *guest_data_prototype;
> >
> > @@ -69,9 +59,11 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
> >                        ts_diff.tv_sec, ts_diff.tv_nsec);
> >  }
> >
> > -static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t addr)
> > +static int handle_uffd_page_request(int uffd_mode, int uffd,
> > +               struct uffd_msg *msg)
> >  {
> >         pid_t tid = syscall(__NR_gettid);
> > +       uint64_t addr = msg->arg.pagefault.address;
> >         struct timespec start;
> >         struct timespec ts_diff;
> >         int r;
> > @@ -118,175 +110,32 @@ static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t addr)
> >         return 0;
> >  }
> >
> > -bool quit_uffd_thread;
> > -
> > -struct uffd_handler_args {
> > +struct test_params {
> >         int uffd_mode;
> > -       int uffd;
> > -       int pipefd;
> > -       useconds_t delay;
> > +       useconds_t uffd_delay;
> > +       enum vm_mem_backing_src_type src_type;
> > +       bool partition_vcpu_memory_access;
> >  };
> >
> > -static void *uffd_handler_thread_fn(void *arg)
> > +static void prefault_mem(void *alias, uint64_t len)
> >  {
> > -       struct uffd_handler_args *uffd_args = (struct uffd_handler_args *)arg;
> > -       int uffd = uffd_args->uffd;
> > -       int pipefd = uffd_args->pipefd;
> > -       useconds_t delay = uffd_args->delay;
> > -       int64_t pages = 0;
> > -       struct timespec start;
> > -       struct timespec ts_diff;
> > -
> > -       clock_gettime(CLOCK_MONOTONIC, &start);
> > -       while (!quit_uffd_thread) {
> > -               struct uffd_msg msg;
> > -               struct pollfd pollfd[2];
> > -               char tmp_chr;
> > -               int r;
> > -               uint64_t addr;
> > -
> > -               pollfd[0].fd = uffd;
> > -               pollfd[0].events = POLLIN;
> > -               pollfd[1].fd = pipefd;
> > -               pollfd[1].events = POLLIN;
> > -
> > -               r = poll(pollfd, 2, -1);
> > -               switch (r) {
> > -               case -1:
> > -                       pr_info("poll err");
> > -                       continue;
> > -               case 0:
> > -                       continue;
> > -               case 1:
> > -                       break;
> > -               default:
> > -                       pr_info("Polling uffd returned %d", r);
> > -                       return NULL;
> > -               }
> > -
> > -               if (pollfd[0].revents & POLLERR) {
> > -                       pr_info("uffd revents has POLLERR");
> > -                       return NULL;
> > -               }
> > -
> > -               if (pollfd[1].revents & POLLIN) {
> > -                       r = read(pollfd[1].fd, &tmp_chr, 1);
> > -                       TEST_ASSERT(r == 1,
> > -                                   "Error reading pipefd in UFFD thread\n");
> > -                       return NULL;
> > -               }
> > -
> > -               if (!(pollfd[0].revents & POLLIN))
> > -                       continue;
> > -
> > -               r = read(uffd, &msg, sizeof(msg));
> > -               if (r == -1) {
> > -                       if (errno == EAGAIN)
> > -                               continue;
> > -                       pr_info("Read of uffd got errno %d\n", errno);
> > -                       return NULL;
> > -               }
> > -
> > -               if (r != sizeof(msg)) {
> > -                       pr_info("Read on uffd returned unexpected size: %d bytes", r);
> > -                       return NULL;
> > -               }
> > -
> > -               if (!(msg.event & UFFD_EVENT_PAGEFAULT))
> > -                       continue;
> > +       size_t p;
> >
> > -               if (delay)
> > -                       usleep(delay);
> > -               addr =  msg.arg.pagefault.address;
> > -               r = handle_uffd_page_request(uffd_args->uffd_mode, uffd, addr);
> > -               if (r < 0)
> > -                       return NULL;
> > -               pages++;
> > +       TEST_ASSERT(alias != NULL, "Alias required for minor faults");
> > +       for (p = 0; p < (len / demand_paging_size); ++p) {
> > +               memcpy(alias + (p * demand_paging_size),
> > +                      guest_data_prototype, demand_paging_size);
> >         }
> > -
> > -       ts_diff = timespec_elapsed(start);
> > -       PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
> > -                      pages, ts_diff.tv_sec, ts_diff.tv_nsec,
> > -                      pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
> > -
> > -       return NULL;
> >  }
> >
> > -static void setup_demand_paging(struct kvm_vm *vm,
> > -                               pthread_t *uffd_handler_thread, int pipefd,
> > -                               int uffd_mode, useconds_t uffd_delay,
> > -                               struct uffd_handler_args *uffd_args,
> > -                               void *hva, void *alias, uint64_t len)
> > -{
> > -       bool is_minor = (uffd_mode == UFFDIO_REGISTER_MODE_MINOR);
> > -       int uffd;
> > -       struct uffdio_api uffdio_api;
> > -       struct uffdio_register uffdio_register;
> > -       uint64_t expected_ioctls = ((uint64_t) 1) << _UFFDIO_COPY;
> > -
> > -       PER_PAGE_DEBUG("Userfaultfd %s mode, faults resolved with %s\n",
> > -                      is_minor ? "MINOR" : "MISSING",
> > -                      is_minor ? "UFFDIO_CONINUE" : "UFFDIO_COPY");
> > -
> > -       /* In order to get minor faults, prefault via the alias. */
> > -       if (is_minor) {
> > -               size_t p;
> > -
> > -               expected_ioctls = ((uint64_t) 1) << _UFFDIO_CONTINUE;
> > -
> > -               TEST_ASSERT(alias != NULL, "Alias required for minor faults");
> > -               for (p = 0; p < (len / demand_paging_size); ++p) {
> > -                       memcpy(alias + (p * demand_paging_size),
> > -                              guest_data_prototype, demand_paging_size);
> > -               }
> > -       }
> > -
> > -       uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
> > -       TEST_ASSERT(uffd >= 0, "uffd creation failed, errno: %d", errno);
> > -
> > -       uffdio_api.api = UFFD_API;
> > -       uffdio_api.features = 0;
> > -       TEST_ASSERT(ioctl(uffd, UFFDIO_API, &uffdio_api) != -1,
> > -                   "ioctl UFFDIO_API failed: %" PRIu64,
> > -                   (uint64_t)uffdio_api.api);
> > -
> > -       uffdio_register.range.start = (uint64_t)hva;
> > -       uffdio_register.range.len = len;
> > -       uffdio_register.mode = uffd_mode;
> > -       TEST_ASSERT(ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) != -1,
> > -                   "ioctl UFFDIO_REGISTER failed");
> > -       TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) ==
> > -                   expected_ioctls, "missing userfaultfd ioctls");
> > -
> > -       uffd_args->uffd_mode = uffd_mode;
> > -       uffd_args->uffd = uffd;
> > -       uffd_args->pipefd = pipefd;
> > -       uffd_args->delay = uffd_delay;
> > -       pthread_create(uffd_handler_thread, NULL, uffd_handler_thread_fn,
> > -                      uffd_args);
> > -
> > -       PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
> > -                      hva, hva + len);
> > -}
> > -
> > -struct test_params {
> > -       int uffd_mode;
> > -       useconds_t uffd_delay;
> > -       enum vm_mem_backing_src_type src_type;
> > -       bool partition_vcpu_memory_access;
> > -};
> > -
> >  static void run_test(enum vm_guest_mode mode, void *arg)
> >  {
> >         struct test_params *p = arg;
> > -       pthread_t *uffd_handler_threads = NULL;
> > -       struct uffd_handler_args *uffd_args = NULL;
> > +       struct uffd_desc **uffd_descs = NULL;
> >         struct timespec start;
> >         struct timespec ts_diff;
> > -       int *pipefds = NULL;
> >         struct kvm_vm *vm;
> >         int vcpu_id;
> > -       int r;
> >
> >         vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
> >                                  p->src_type, p->partition_vcpu_memory_access);
> > @@ -299,15 +148,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         memset(guest_data_prototype, 0xAB, demand_paging_size);
> >
> >         if (p->uffd_mode) {
> > -               uffd_handler_threads =
> > -                       malloc(nr_vcpus * sizeof(*uffd_handler_threads));
> > -               TEST_ASSERT(uffd_handler_threads, "Memory allocation failed");
> > -
> > -               uffd_args = malloc(nr_vcpus * sizeof(*uffd_args));
> > -               TEST_ASSERT(uffd_args, "Memory allocation failed");
> > -
> > -               pipefds = malloc(sizeof(int) * nr_vcpus * 2);
> > -               TEST_ASSERT(pipefds, "Unable to allocate memory for pipefd");
> > +               uffd_descs = malloc(nr_vcpus * sizeof(struct uffd_desc *));
> > +               TEST_ASSERT(uffd_descs, "Memory allocation failed");
> >
> >                 for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> >                         struct perf_test_vcpu_args *vcpu_args;
> > @@ -320,19 +162,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >                         vcpu_hva = addr_gpa2hva(vm, vcpu_args->gpa);
> >                         vcpu_alias = addr_gpa2alias(vm, vcpu_args->gpa);
> >
> > +                       prefault_mem(vcpu_alias,
> > +                               vcpu_args->pages * perf_test_args.guest_page_size);
> > +
> >                         /*
> >                          * Set up user fault fd to handle demand paging
> >                          * requests.
> >                          */
> > -                       r = pipe2(&pipefds[vcpu_id * 2],
> > -                                 O_CLOEXEC | O_NONBLOCK);
> > -                       TEST_ASSERT(!r, "Failed to set up pipefd");
> > -
> > -                       setup_demand_paging(vm, &uffd_handler_threads[vcpu_id],
> > -                                           pipefds[vcpu_id * 2], p->uffd_mode,
> > -                                           p->uffd_delay, &uffd_args[vcpu_id],
> > -                                           vcpu_hva, vcpu_alias,
> > -                                           vcpu_args->pages * perf_test_args.guest_page_size);
> > +                       uffd_descs[vcpu_id] = uffd_setup_demand_paging(
> > +                               p->uffd_mode, p->uffd_delay, vcpu_hva,
> > +                               vcpu_args->pages * perf_test_args.guest_page_size,
> > +                               &handle_uffd_page_request);
> >                 }
> >         }
> >
> > @@ -347,15 +187,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         pr_info("All vCPU threads joined\n");
> >
> >         if (p->uffd_mode) {
> > -               char c;
> > -
> >                 /* Tell the user fault fd handler threads to quit */
> > -               for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> > -                       r = write(pipefds[vcpu_id * 2 + 1], &c, 1);
> > -                       TEST_ASSERT(r == 1, "Unable to write to pipefd");
> > -
> > -                       pthread_join(uffd_handler_threads[vcpu_id], NULL);
> > -               }
> > +               for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
> > +                       uffd_stop_demand_paging(uffd_descs[vcpu_id]);
> >         }
> >
> >         pr_info("Total guest execution time: %ld.%.9lds\n",
> > @@ -367,11 +201,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         perf_test_destroy_vm(vm);
> >
> >         free(guest_data_prototype);
> > -       if (p->uffd_mode) {
> > -               free(uffd_handler_threads);
> > -               free(uffd_args);
> > -               free(pipefds);
> > -       }
> > +       if (p->uffd_mode)
> > +               free(uffd_descs);
> >  }
> >
> >  static void help(char *name)
> > diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> > new file mode 100644
> > index 000000000000..7b294ce8147c
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> > @@ -0,0 +1,46 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * KVM userfaultfd util
> > + * Adapted from demand_paging_test.c
> > + *
> > + * Copyright (C) 2018, Red Hat, Inc.
> > + * Copyright (C) 2019, Google, Inc.
> > + * Copyright (C) 2022, Google, Inc.
> > + */
> > +
> > +#define _GNU_SOURCE /* for pipe2 */
> > +
> > +#include <inttypes.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <time.h>
> > +#include <poll.h>
> > +#include <pthread.h>
> > +#include <linux/userfaultfd.h>
> > +#include <sys/syscall.h>
> > +
> > +#include "kvm_util.h"
> > +#include "test_util.h"
> > +#include "perf_test_util.h"
> > +
> > +typedef int (*uffd_handler_t)(int uffd_mode, int uffd, struct uffd_msg *msg);
> > +
> > +struct uffd_desc;
> 
> Do we gain anything from making this opaque? Given the 100+ patch
> series Sean just sent out to expose the KVM util library functions,
> I'd be inclined to just define the struct in the header file.

Ah, good point. Yes, I better change this.

> 
> Otherwise, I'm really happy to see all this code factored out into its
> own little library.
> 
> > +
> > +struct uffd_desc *uffd_setup_demand_paging(int uffd_mode,
> > +               useconds_t uffd_delay, void *hva, uint64_t len,
> > +               uffd_handler_t handler);
> > +
> > +void uffd_stop_demand_paging(struct uffd_desc *uffd);
> > +
> > +#ifdef PRINT_PER_PAGE_UPDATES
> > +#define PER_PAGE_DEBUG(...) printf(__VA_ARGS__)
> > +#else
> > +#define PER_PAGE_DEBUG(...) _no_printf(__VA_ARGS__)
> > +#endif
> > +
> > +#ifdef PRINT_PER_VCPU_UPDATES
> > +#define PER_VCPU_DEBUG(...) printf(__VA_ARGS__)
> > +#else
> > +#define PER_VCPU_DEBUG(...) _no_printf(__VA_ARGS__)
> > +#endif
> > diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> > new file mode 100644
> > index 000000000000..5e0878878a69
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> > @@ -0,0 +1,196 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * KVM userfaultfd util
> > + * Adapted from demand_paging_test.c
> > + *
> > + * Copyright (C) 2018, Red Hat, Inc.
> > + * Copyright (C) 2019, Google, Inc.
> > + * Copyright (C) 2022, Google, Inc.
> > + */
> > +
> > +#define _GNU_SOURCE /* for pipe2 */
> > +
> > +#include <inttypes.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <time.h>
> > +#include <poll.h>
> > +#include <pthread.h>
> > +#include <linux/userfaultfd.h>
> > +#include <sys/syscall.h>
> > +
> > +#include "kvm_util.h"
> > +#include "test_util.h"
> > +#include "perf_test_util.h"
> > +#include "userfaultfd_util.h"
> > +
> > +#ifdef __NR_userfaultfd
> > +
> > +struct uffd_desc {
> > +       int uffd_mode;
> > +       int uffd;
> > +       int pipefds[2];
> > +       useconds_t delay;
> > +       uffd_handler_t handler;
> > +       pthread_t thread;
> > +};
> > +
> > +static void *uffd_handler_thread_fn(void *arg)
> > +{
> > +       struct uffd_desc *uffd_desc = (struct uffd_desc *)arg;
> > +       int uffd = uffd_desc->uffd;
> > +       int pipefd = uffd_desc->pipefds[0];
> > +       useconds_t delay = uffd_desc->delay;
> > +       int64_t pages = 0;
> > +       struct timespec start;
> > +       struct timespec ts_diff;
> > +
> > +       clock_gettime(CLOCK_MONOTONIC, &start);
> > +       while (1) {
> > +               struct uffd_msg msg;
> > +               struct pollfd pollfd[2];
> > +               char tmp_chr;
> > +               int r;
> > +
> > +               pollfd[0].fd = uffd;
> > +               pollfd[0].events = POLLIN;
> > +               pollfd[1].fd = pipefd;
> > +               pollfd[1].events = POLLIN;
> > +
> > +               r = poll(pollfd, 2, -1);
> > +               switch (r) {
> > +               case -1:
> > +                       pr_info("poll err");
> > +                       continue;
> > +               case 0:
> > +                       continue;
> > +               case 1:
> > +                       break;
> > +               default:
> > +                       pr_info("Polling uffd returned %d", r);
> > +                       return NULL;
> > +               }
> > +
> > +               if (pollfd[0].revents & POLLERR) {
> > +                       pr_info("uffd revents has POLLERR");
> > +                       return NULL;
> > +               }
> > +
> > +               if (pollfd[1].revents & POLLIN) {
> > +                       r = read(pollfd[1].fd, &tmp_chr, 1);
> > +                       TEST_ASSERT(r == 1,
> > +                                   "Error reading pipefd in UFFD thread\n");
> > +                       return NULL;
> > +               }
> > +
> > +               if (!(pollfd[0].revents & POLLIN))
> > +                       continue;
> > +
> > +               r = read(uffd, &msg, sizeof(msg));
> > +               if (r == -1) {
> > +                       if (errno == EAGAIN)
> > +                               continue;
> > +                       pr_info("Read of uffd got errno %d\n", errno);
> > +                       return NULL;
> > +               }
> > +
> > +               if (r != sizeof(msg)) {
> > +                       pr_info("Read on uffd returned unexpected size: %d bytes", r);
> > +                       return NULL;
> > +               }
> > +
> > +               if (!(msg.event & UFFD_EVENT_PAGEFAULT))
> > +                       continue;
> > +
> > +               if (delay)
> > +                       usleep(delay);
> > +               r = uffd_desc->handler(uffd_desc->uffd_mode, uffd, &msg);
> > +               if (r < 0)
> > +                       return NULL;
> > +               pages++;
> > +       }
> > +
> > +       ts_diff = timespec_elapsed(start);
> > +       PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
> > +                      pages, ts_diff.tv_sec, ts_diff.tv_nsec,
> > +                      pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
> > +
> > +       return NULL;
> > +}
> > +
> > +struct uffd_desc *uffd_setup_demand_paging(int uffd_mode,
> > +               useconds_t uffd_delay, void *hva, uint64_t len,
> > +               uffd_handler_t handler)
> > +{
> > +       struct uffd_desc *uffd_desc;
> > +       bool is_minor = (uffd_mode == UFFDIO_REGISTER_MODE_MINOR);
> > +       int uffd;
> > +       struct uffdio_api uffdio_api;
> > +       struct uffdio_register uffdio_register;
> > +       uint64_t expected_ioctls = ((uint64_t) 1) << _UFFDIO_COPY;
> > +       int ret;
> > +
> > +       PER_PAGE_DEBUG("Userfaultfd %s mode, faults resolved with %s\n",
> > +                      is_minor ? "MINOR" : "MISSING",
> > +                      is_minor ? "UFFDIO_CONINUE" : "UFFDIO_COPY");
> > +
> > +       uffd_desc = malloc(sizeof(struct uffd_desc));
> > +       TEST_ASSERT(uffd_desc, "malloc failed");
> > +
> > +       /* In order to get minor faults, prefault via the alias. */
> > +       if (is_minor)
> > +               expected_ioctls = ((uint64_t) 1) << _UFFDIO_CONTINUE;
> > +
> > +       uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
> > +       TEST_ASSERT(uffd >= 0, "uffd creation failed, errno: %d", errno);
> > +
> > +       uffdio_api.api = UFFD_API;
> > +       uffdio_api.features = 0;
> > +       TEST_ASSERT(ioctl(uffd, UFFDIO_API, &uffdio_api) != -1,
> > +                   "ioctl UFFDIO_API failed: %" PRIu64,
> > +                   (uint64_t)uffdio_api.api);
> > +
> > +       uffdio_register.range.start = (uint64_t)hva;
> > +       uffdio_register.range.len = len;
> > +       uffdio_register.mode = uffd_mode;
> > +       TEST_ASSERT(ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) != -1,
> > +                   "ioctl UFFDIO_REGISTER failed");
> > +       TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) ==
> > +                       expected_ioctls, "missing userfaultfd ioctls");
> > +
> > +       ret = pipe2(uffd_desc->pipefds, O_CLOEXEC | O_NONBLOCK);
> > +       TEST_ASSERT(!ret, "Failed to set up pipefd");
> > +
> > +       uffd_desc->uffd_mode = uffd_mode;
> > +       uffd_desc->uffd = uffd;
> > +       uffd_desc->delay = uffd_delay;
> > +       uffd_desc->handler = handler;
> > +       pthread_create(&uffd_desc->thread, NULL, uffd_handler_thread_fn,
> > +                      uffd_desc);
> > +
> > +       PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
> > +                      hva, hva + len);
> > +
> > +       return uffd_desc;
> > +}
> > +
> > +void uffd_stop_demand_paging(struct uffd_desc *uffd)
> > +{
> > +       char c = 0;
> > +       int ret;
> > +
> > +       ret = write(uffd->pipefds[1], &c, 1);
> > +       TEST_ASSERT(ret == 1, "Unable to write to pipefd");
> > +
> > +       ret = pthread_join(uffd->thread, NULL);
> > +       TEST_ASSERT(ret == 0, "Pthread_join failed.");
> > +
> > +       close(uffd->uffd);
> > +
> > +       close(uffd->pipefds[1]);
> > +       close(uffd->pipefds[0]);
> > +
> > +       free(uffd);
> > +}
> > +
> > +#endif /* __NR_userfaultfd */
> > --
> > 2.35.1.723.g4982287a31-goog
> >
