Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11358510B81
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 23:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346480AbiDZVxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 17:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiDZVxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 17:53:32 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF663340F9
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 14:50:22 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id r189so93592ybr.6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 14:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6lNxWpyMLcMV5KZLewWKCOMBDT9fhScii3YI5rq1O6U=;
        b=gvOqbUJIHuOixkdJL00ZpFOeuECo/xB+aDt76qzYDim7FPySe/7AsXLapSSex2K5rH
         M7M+ssRDS3paCkpAympsdBFGOMZWPUUc9312g/V4UxGp9aQLuO1WI5/E/vlULiFttfHi
         oeh/a24dJFMjZ93ENIY3lOXAVgXZd8U9bxk9On+q2rsevm4i1TtfVPJQUb5CoiMfZq4N
         MURE2CJGoIfhrTzpaf00wcD7VgOFYO2+TktTOYAECZ0f+kwobI+fVv5xZyS5D1qrQE2v
         KP3hOZmbsWAKzMRlx/nfxZ/oa32mo2Gsmb7F1k+0iri1LR9K9+JzsONgySUbxWucb33/
         WltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6lNxWpyMLcMV5KZLewWKCOMBDT9fhScii3YI5rq1O6U=;
        b=rmaP43TgMOTBDBlB/IoIp4ocUZfDTP0rR4iPGBw/JgmOTSZn29rLU1uCWsPhfB4LSu
         IGQ4ouefDq0vLPfCuyZ9PtBCclpSlYRPlhf2Rt1Yu8hcPfaEqVIW4uGbJlnNs0X5N6gK
         Ij7z7mjZRPPYif4O16Yqmjc0OVupeYzgy+nw/r5sQCV1zLMo+hmw2A1fiT12NMH5eosw
         TB6tLFn4oKDJPCOD3QBaYz90zy9N/23pa8ProALniuKhW8Uh2GVWIL6gfON/eHIZYZqQ
         5Q8cEM0w781s9q8q3meYsP1mIYakvpGE+r+90bFh+/nFDLKlbdbD5EohMUiKb1b+loWw
         b5EQ==
X-Gm-Message-State: AOAM531jma3Ny+SuOgp7od5KDUYbnIkJ+FdskKar9pHEvRuvgOzqdfwk
        /tunJRlBKDRVd3ItH88gOsZFVzs7YH4tN0WzN8GIcg==
X-Google-Smtp-Source: ABdhPJzG5T4TncfRxPw5Uq9VHbtbrbRvqhrUkRTtWZkDst5mqCc+Yp4ncGKsTENlF6Qc/ds6LI6blvsCq86NsIUuuT0=
X-Received: by 2002:a25:25cb:0:b0:648:7b92:e37d with SMTP id
 l194-20020a2525cb000000b006487b92e37dmr9218202ybl.341.1651009821769; Tue, 26
 Apr 2022 14:50:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com> <20220420173513.1217360-7-bgardon@google.com>
 <YmGjuVtilcG6kd3f@xz-m1.local>
In-Reply-To: <YmGjuVtilcG6kd3f@xz-m1.local>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 26 Apr 2022 14:50:10 -0700
Message-ID: <CANgfPd_VRYDGAA4iP5Z3HohtqOdtt8U1NwXDzC1eNM-DoXO7bw@mail.gmail.com>
Subject: Re: [PATCH v6 06/10] KVM: selftests: Add NX huge pages test
To:     Peter Xu <peterx@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 11:34 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Apr 20, 2022 at 10:35:09AM -0700, Ben Gardon wrote:
> > There's currently no test coverage of NX hugepages in KVM selftests, so
> > add a basic test to ensure that the feature works as intended.
> >
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |  10 +
> >  .../selftests/kvm/include/kvm_util_base.h     |   1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |  78 ++++++++
> >  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 177 ++++++++++++++++++
> >  .../kvm/x86_64/nx_huge_pages_test.sh          |  25 +++
> >  5 files changed, 291 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> >  create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index af582d168621..9bb9bce4df37 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -43,6 +43,10 @@ LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handler
> >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> >  LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
> >
> > +# Non-compiled test targets
> > +TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
> > +
> > +# Compiled test targets
> >  TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
> > @@ -104,6 +108,9 @@ TEST_GEN_PROGS_x86_64 += steal_time
> >  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> >  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
> >
> > +# Compiled outputs used by test targets
> > +TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
> > +
> >  TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
> >  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> >  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> > @@ -142,7 +149,9 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
> >  TEST_GEN_PROGS_riscv += set_memory_region_test
> >  TEST_GEN_PROGS_riscv += kvm_binary_stats_test
> >
> > +TEST_PROGS += $(TEST_PROGS_$(UNAME_M))
> >  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
> > +TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(UNAME_M))
> >  LIBKVM += $(LIBKVM_$(UNAME_M))
> >
> >  INSTALL_HDR_PATH = $(top_srcdir)/usr
> > @@ -193,6 +202,7 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
> >  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> >  all: $(STATIC_LIBS)
> >  $(TEST_GEN_PROGS): $(STATIC_LIBS)
> > +$(TEST_GEN_PROGS_EXTENDED): $(STATIC_LIBS)
> >
> >  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
> >  cscope:
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 2a3a4d9ed8e3..001b55ae25f8 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -406,6 +406,7 @@ struct kvm_stats_desc *read_stats_desc(int stats_fd,
> >  int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> >                  struct kvm_stats_desc *desc, uint64_t *data,
> >                  ssize_t max_elements);
> > +uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name);
> >
> >  uint32_t guest_get_vcpuid(void);
> >
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index ea4ab64e5997..9896cc49eb54 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2651,3 +2651,81 @@ int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> >
> >       return ret;
> >  }
> > +
> > +/*
> > + * Read the data of the named stat
> > + *
> > + * Input Args:
> > + *   vm - the VM for which the stat should be read
> > + *   stat_name - the name of the stat to read
> > + *   max_elements - the maximum number of 8-byte values to read into data
> > + *
> > + * Output Args:
> > + *   data - the buffer into which stat data should be read
> > + *
> > + * Return:
> > + *   The number of data elements read into data or -ERRNO on error.
> > + *
> > + * Read the data values of a specified stat from the binary stats interface.
> > + */
> > +static int __vm_get_stat(struct kvm_vm *vm, const char *stat_name,
> > +                         uint64_t *data, ssize_t max_elements)
> > +{
> > +     struct kvm_stats_desc *stats_desc;
> > +     struct kvm_stats_header header;
> > +     struct kvm_stats_desc *desc;
> > +     size_t size_desc;
> > +     int stats_fd;
> > +     int ret = -EINVAL;
> > +     int i;
> > +
> > +     stats_fd = vm_get_stats_fd(vm);
> > +
> > +     read_stats_header(stats_fd, &header);
> > +
> > +     stats_desc = read_stats_desc(stats_fd, &header);
> > +
> > +     size_desc = sizeof(struct kvm_stats_desc) + header.name_size;
> > +
> > +     /* Read kvm stats data one by one */
> > +     for (i = 0; i < header.num_desc; ++i) {
> > +             desc = (void *)stats_desc + (i * size_desc);
> > +
> > +             if (strcmp(desc->name, stat_name))
> > +                     continue;
> > +
> > +             ret = read_stat_data(stats_fd, &header, desc, data,
> > +                                  max_elements);
>
> Do we want to stop the loop when found?

Woops, great point.

>
> > +     }
> > +
> > +     free(stats_desc);
> > +     close(stats_fd);
>
> IIUC we call __vm_get_stat() a lot of times in a single test.  It's kind of
> against how kvm stats should be used according to the documents provided in
> binary_stats.c:
>
>  * The file content of a vm/vcpu file descriptor is now defined as below:
>  * +-------------+
>  * |   Header    |
>  * +-------------+
>  * |  id string  |
>  * +-------------+
>  * | Descriptors |
>  * +-------------+
>  * | Stats Data  |
>  * +-------------+
>  * Although this function allows userspace to read any amount of data (as long
>  * as in the limit) from any position, the typical usage would follow below
>  * steps:
>  * 1. Read header from offset 0. Get the offset of descriptors and stats data
>  *    and some other necessary information. This is a one-time work for the
>  *    lifecycle of the corresponding vm/vcpu stats fd.
>  * 2. Read id string from its offset. This is a one-time work for the lifecycle
>  *    of the corresponding vm/vcpu stats fd.
>  * 3. Read descriptors from its offset and discover all the stats by parsing
>  *    descriptors. This is a one-time work for the lifecycle of the
>  *    corresponding vm/vcpu stats fd.
>  * 4. Periodically read stats data from its offset using pread.
>
> IMHO it's nicer if we cache steps 1-3 in struct kvm_vm, but no strong
> opinion (especially when I only jumped in at v6 :).
>
> I think it'll also start to make a difference when we want a new test case
> that'll need to frequently read some stat vars, then hopefully the code
> introduced here can be directly reused (and I'm afraid the current approach
> could drag things down when the period can be small).

David Matlack had the same feedback and I was inclined to put the
caching off until later, but since I've heard this multiple times,
I'll tack a patch on to the end of this series to do that.

>
> > +     return ret;
> > +}
> > +
> > +/*
> > + * Read the value of the named stat
> > + *
> > + * Input Args:
> > + *   vm - the VM for which the stat should be read
> > + *   stat_name - the name of the stat to read
> > + *
> > + * Output Args: None
> > + *
> > + * Return:
> > + *   The value of the stat
> > + *
> > + * Reads the value of the named stat through the binary stat interface. If
> > + * the named stat has multiple data elements, only the first will be returned.
> > + */
> > +uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
> > +{
> > +     uint64_t data;
> > +     int ret;
> > +
> > +     ret = __vm_get_stat(vm, stat_name, &data, 1);
> > +     TEST_ASSERT(ret == 1,
> > +                 "Stat %s expected to have 1 element, but %d returned",
> > +                 stat_name, ret);
> > +     return data;
> > +}
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > new file mode 100644
> > index 000000000000..1c14368500b7
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > @@ -0,0 +1,177 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * tools/testing/selftests/kvm/nx_huge_page_test.c
> > + *
> > + * Usage: to be run via nx_huge_page_test.sh, which does the necessary
> > + * environment setup and teardown
> > + *
> > + * Copyright (C) 2022, Google LLC.
> > + */
> > +
> > +#define _GNU_SOURCE
> > +
> > +#include <fcntl.h>
> > +#include <stdint.h>
> > +#include <time.h>
> > +
> > +#include <test_util.h>
> > +#include "kvm_util.h"
> > +
> > +#define HPAGE_SLOT           10
> > +#define HPAGE_GVA            (23*1024*1024)
> > +#define HPAGE_GPA            (10*1024*1024)
> > +#define HPAGE_SLOT_NPAGES    (512 * 3)
> > +#define PAGE_SIZE            4096
> > +
> > +/*
> > + * Passed by nx_huge_pages_test.sh to provide an easy warning if this test is
> > + * being run without it.
> > + */
> > +#define MAGIC_TOKEN 887563923
> > +
> > +/*
> > + * x86 opcode for the return instruction. Used to call into, and then
> > + * immediately return from, memory backed with hugepages.
> > + */
> > +#define RETURN_OPCODE 0xC3
> > +
> > +/*
> > + * Exit the VM after each memory access so that the userspace component of the
> > + * test can make assertions about the pages backing the VM.
> > + */
> > +void guest_code(void)
> > +{
> > +     uint64_t hpage_1 = HPAGE_GVA;
> > +     uint64_t hpage_2 = hpage_1 + (PAGE_SIZE * 512);
> > +     uint64_t hpage_3 = hpage_2 + (PAGE_SIZE * 512);
> > +
> > +     READ_ONCE(*(uint64_t *)hpage_1);
> > +     GUEST_SYNC(1);
> > +
> > +     READ_ONCE(*(uint64_t *)hpage_2);
> > +     GUEST_SYNC(2);
> > +
> > +     ((void (*)(void)) hpage_1)();
> > +     GUEST_SYNC(3);
> > +
> > +     ((void (*)(void)) hpage_3)();
> > +     GUEST_SYNC(4);
> > +
> > +     READ_ONCE(*(uint64_t *)hpage_1);
> > +     GUEST_SYNC(5);
> > +
> > +     READ_ONCE(*(uint64_t *)hpage_3);
> > +     GUEST_SYNC(6);
> > +}
> > +
> > +static void check_2m_page_count(struct kvm_vm *vm, int expected_pages_2m)
> > +{
> > +     int actual_pages_2m;
> > +
> > +     actual_pages_2m = vm_get_stat(vm, "pages_2m");
> > +
> > +     TEST_ASSERT(actual_pages_2m == expected_pages_2m,
> > +                 "Unexpected 2m page count. Expected %d, got %d",
> > +                 expected_pages_2m, actual_pages_2m);
> > +}
> > +
> > +static void check_split_count(struct kvm_vm *vm, int expected_splits)
> > +{
> > +     int actual_splits;
> > +
> > +     actual_splits = vm_get_stat(vm, "nx_lpage_splits");
> > +
> > +     TEST_ASSERT(actual_splits == expected_splits,
> > +                 "Unexpected nx lpage split count. Expected %d, got %d",
> > +                 expected_splits, actual_splits);
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +     struct kvm_vm *vm;
> > +     struct timespec ts;
> > +     void *hva;
> > +
> > +     if (argc != 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {
> > +             printf("This test must be run through nx_huge_pages_test.sh");
> > +             return KSFT_SKIP;
> > +     }
> > +
> > +     vm = vm_create_default(0, 0, guest_code);
> > +
> > +     vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
> > +                                 HPAGE_GPA, HPAGE_SLOT,
> > +                                 HPAGE_SLOT_NPAGES, 0);
> > +
> > +     virt_map(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_NPAGES);
> > +
> > +     hva = addr_gpa2hva(vm, HPAGE_GPA);
> > +     memset(hva, RETURN_OPCODE, HPAGE_SLOT_NPAGES * PAGE_SIZE);
> > +
> > +     check_2m_page_count(vm, 0);
> > +     check_split_count(vm, 0);
> > +
> > +     /*
> > +      * The guest code will first read from the first hugepage, resulting
> > +      * in a huge page mapping being created.
> > +      */
> > +     vcpu_run(vm, 0);
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 0);
> > +
> > +     /*
> > +      * Then the guest code will read from the second hugepage, resulting
> > +      * in another huge page mapping being created.
> > +      */
> > +     vcpu_run(vm, 0);
> > +     check_2m_page_count(vm, 2);
> > +     check_split_count(vm, 0);
> > +
> > +     /*
> > +      * Next, the guest will execute from the first huge page, causing it
> > +      * to be remapped at 4k.
> > +      */
> > +     vcpu_run(vm, 0);
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 1);
> > +
> > +     /*
> > +      * Executing from the third huge page (previously unaccessed) will
> > +      * cause part to be mapped at 4k.
> > +      */
> > +     vcpu_run(vm, 0);
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 2);
> > +
> > +     /* Reading from the first huge page again should have no effect. */
> > +     vcpu_run(vm, 0);
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 2);
> > +
> > +     /*
> > +      * Give recovery thread time to run. The wrapper script sets
> > +      * recovery_period_ms to 100, so wait 5x that.
> > +      */
> > +     ts.tv_sec = 0;
> > +     ts.tv_nsec = 500000000;
> > +     nanosleep(&ts, NULL);
>
> I understand that we don't have a good way to get notified on the kernel
> thread doing the recycling, but I'd suggest instead of constantly sleeping
> 500ms, I'd just do a periodically checking below 2m=1 and split=0 for each
> 100ms and set the timeout higher (e.g., 10 seconds), so (1) on normal
> systems it ends even faster, and (2) on hot systems it's even less likely
> to fail.

If the reclaimer can't get to these pages in 5x the reclaim period,
something is wrong regardless of how hot the system is. I think we
should fail in that case.
For the sake of simplicity I'm inclined to keep this as-is, but I
agree checking more frequently for completion would be a good way to
make the test run faster.

>
> > +
> > +     /*
> > +      * Now that the reclaimer has run, all the split pages should be gone.
> > +      */
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 0);
> > +
> > +     /*
> > +      * The 4k mapping on hpage 3 should have been removed, so check that
> > +      * reading from it causes a huge page mapping to be installed.
> > +      */
> > +     vcpu_run(vm, 0);
> > +     check_2m_page_count(vm, 2);
> > +     check_split_count(vm, 0);
> > +
> > +     kvm_vm_free(vm);
> > +
> > +     return 0;
> > +}
> > +
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > new file mode 100755
> > index 000000000000..c2429ad8066a
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > @@ -0,0 +1,25 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-only */
> > +
> > +# tools/testing/selftests/kvm/nx_huge_page_test.sh
> > +# Copyright (C) 2022, Google LLC.
> > +
> > +NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
> > +NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
> > +NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
> > +HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
> > +
> > +echo 1 > /sys/module/kvm/parameters/nx_huge_pages
> > +echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> > +echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> > +echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>
> We only need 3 pages, right?

Ah right, now that we're only mapping the data region with hugepages
this can go down. Before we needed enough memory to store the entire
statically built binary.

>
> Shall we also better check this "echo" didn't fail?

Yes, I will add set -e to check that.

>
> Thanks,
>
> > +
> > +"$(dirname $0)"/nx_huge_pages_test 887563923
> > +RET=$?
> > +
> > +echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> > +echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> > +echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> > +echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> > +
> > +exit $RET
> > --
> > 2.36.0.rc0.470.gd361397f0d-goog
> >
>
> --
> Peter Xu
>
