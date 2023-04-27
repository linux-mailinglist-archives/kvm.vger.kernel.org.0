Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926E56F08B1
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 17:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243864AbjD0Psx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 11:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243950AbjD0Pss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 11:48:48 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D15B98
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 08:48:46 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-3f0a2f8216fso747981cf.0
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 08:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682610525; x=1685202525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ra3lc9/H4wcgVrQw+kc0T3mP6bSycu04OLDc8L+03Ps=;
        b=wFO81PkcebqJl2lisLqmfwDZt35a16fGtFBNHSD9fjSAXgLt0NgwwTeZsFebBnYfWn
         HCkeVlpCOSD4BiS0ZhSzyHU5A5K1LjfzVkPxXF7zsSX5flxyZlKLOoL2pJLRqpH3GJO1
         YaBADkanAHSYlO1HEdCcgr4URbOWA4HLxDT/1l46p/FXN03wOjc9nT45LfIXuFWqOO69
         ecnExMuxy1PDHaUeJ2qd3r/FtTHkMAYoNaJljXyI8CuGTjrRCUw19NJdmD0Wy/pNjfAV
         fVPkx9dZ7IqaF0b5gzpYyWbVMZYi4AbcXeu+y5cRtpz633+GB/x/vP11wMePLMN75Rd9
         4rrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682610525; x=1685202525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ra3lc9/H4wcgVrQw+kc0T3mP6bSycu04OLDc8L+03Ps=;
        b=bWJCpXxFIi25bw9QRvInYdRpYZgNDnlYRz3GGXYhPsMwX5l0pE5e2UUwNsdFrnVGE7
         282h+oi/D2L9tgVbAmC87WNRoiEEEh2lJaYLk7NMYWULdXn4rR7kPNMkM0lakvhbu6bk
         E9O2LLCwfOltFuYNztsX4/HBFgonQpbBrwSTVQodEX1HwHycKGNLCCeo0WbokB0o7kQZ
         ToZeZh0bnvuEhORGcIzMRU/wbSKb2uWm3m8B+pJQm5ZPx1M/29Eu0fLSdB5Lfk6jtMe6
         e6NfQHfo7X6qoAkDJJX6gIBzTdTmaPQBm8Or4OPOYAqd7WZ4I9f+M73wR4QGR5d7hcM2
         JLtQ==
X-Gm-Message-State: AC+VfDxGsxKbRKZhmfjPEZqlLZ9fvtHz6r+k5Y7E387JuQHCmGGO/WsP
        rLQHJi52oVLRXPF/bYYXSBM9GcdfrkuvHm+/EtWiAg==
X-Google-Smtp-Source: ACHHUZ5+Q7lKTCNvx/YBWWqVuIj499763Jrb3yv/iNrFJdpCA24SI8mfYFK41bu1S5E/AobdmI6nDwzFPAZCigXAU18=
X-Received: by 2002:ac8:594a:0:b0:3d6:5f1b:1e7c with SMTP id
 10-20020ac8594a000000b003d65f1b1e7cmr304997qtz.9.1682610525081; Thu, 27 Apr
 2023 08:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-23-amoorthy@google.com>
In-Reply-To: <20230412213510.1220557-23-amoorthy@google.com>
From:   James Houghton <jthoughton@google.com>
Date:   Thu, 27 Apr 2023 08:48:08 -0700
Message-ID: <CADrL8HUQWFtY+2XgT0f6fBhWrdTCvQ1n-99k9oV_5UiFnamv9Q@mail.gmail.com>
Subject: Re: [PATCH v3 22/22] KVM: selftests: Handle memory fault exits in demand_paging_test
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Apr 12, 2023 at 2:35=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> Demonstrate a (very basic) scheme for supporting memory fault exits.
>
> From the vCPU threads:
> 1. Simply issue UFFDIO_COPY/CONTINUEs in response to memory fault exits,
>    with the purpose of establishing the absent mappings. Do so with
>    wake_waiters=3Dfalse to avoid serializing on the userfaultfd wait queu=
e
>    locks.
>
> 2. When the UFFDIO_COPY/CONTINUE in (1) fails with EEXIST,
>    assume that the mapping was already established but is currently
>    absent [A] and attempt to populate it using MADV_POPULATE_WRITE.
>
> Issue UFFDIO_COPY/CONTINUEs from the reader threads as well, but with
> wake_waiters=3Dtrue to ensure that any threads sleeping on the uffd are
> eventually woken up.
>
> A real VMM would track whether it had already COPY/CONTINUEd pages (eg,
> via a bitmap) to avoid calls destined to EEXIST. However, even the
> naive approach is enough to demonstrate the performance advantages of
> KVM_EXIT_MEMORY_FAULT.
>
> [A] In reality it is much likelier that the vCPU thread simply lost a
>     race to establish the mapping for the page.
>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> Acked-by: James Houghton <jthoughton@google.com>
> ---
>  .../selftests/kvm/demand_paging_test.c        | 209 +++++++++++++-----
>  1 file changed, 155 insertions(+), 54 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
> index e84dde345edbc..668bd63d944e7 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -15,6 +15,7 @@
>  #include <time.h>
>  #include <pthread.h>
>  #include <linux/userfaultfd.h>
> +#include <sys/mman.h>
>  #include <sys/syscall.h>
>
>  #include "kvm_util.h"
> @@ -31,6 +32,57 @@ static uint64_t guest_percpu_mem_size =3D DEFAULT_PER_=
VCPU_MEM_SIZE;
>  static size_t demand_paging_size;
>  static char *guest_data_prototype;
>
> +static int num_uffds;
> +static size_t uffd_region_size;
> +static struct uffd_desc **uffd_descs;
> +/*
> + * Delay when demand paging is performed through userfaultfd or directly=
 by
> + * vcpu_worker in the case of a KVM_EXIT_MEMORY_FAULT.
> + */
> +static useconds_t uffd_delay;
> +static int uffd_mode;
> +
> +
> +static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t hv=
a,
> +                                                                       b=
ool is_vcpu);
> +
> +static void madv_write_or_err(uint64_t gpa)
> +{
> +       int r;
> +       void *hva =3D addr_gpa2hva(memstress_args.vm, gpa);
> +
> +       r =3D madvise(hva, demand_paging_size, MADV_POPULATE_WRITE);
> +       TEST_ASSERT(r =3D=3D 0,
> +                               "MADV_POPULATE_WRITE on hva 0x%lx (gpa 0x=
%lx) fail, errno %i\n",
> +                               (uintptr_t) hva, gpa, errno);
> +}
> +
> +static void ready_page(uint64_t gpa)
> +{
> +       int r, uffd;
> +
> +       /*
> +        * This test only registers memslot 1 w/ userfaultfd. Any accesse=
s outside
> +        * the registered ranges should fault in the physical pages throu=
gh
> +        * MADV_POPULATE_WRITE.
> +        */
> +       if ((gpa < memstress_args.gpa)
> +               || (gpa >=3D memstress_args.gpa + memstress_args.size)) {
> +               madv_write_or_err(gpa);
> +       } else {
> +               if (uffd_delay)
> +                       usleep(uffd_delay);
> +
> +               uffd =3D uffd_descs[(gpa - memstress_args.gpa) / uffd_reg=
ion_size]->uffd;
> +
> +               r =3D handle_uffd_page_request(uffd_mode, uffd,
> +                                       (uint64_t) addr_gpa2hva(memstress=
_args.vm, gpa), true);
> +
> +               if (r =3D=3D EEXIST)
> +                       madv_write_or_err(gpa);
> +       }
> +}
> +
>  static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
>  {
>         struct kvm_vcpu *vcpu =3D vcpu_args->vcpu;
> @@ -42,25 +94,36 @@ static void vcpu_worker(struct memstress_vcpu_args *v=
cpu_args)
>
>         clock_gettime(CLOCK_MONOTONIC, &start);
>
> -       /* Let the guest access its memory */
> -       ret =3D _vcpu_run(vcpu);
> -       TEST_ASSERT(ret =3D=3D 0, "vcpu_run failed: %d\n", ret);
> -       if (get_ucall(vcpu, NULL) !=3D UCALL_SYNC) {
> -               TEST_ASSERT(false,
> -                           "Invalid guest sync status: exit_reason=3D%s\=
n",
> -                           exit_reason_str(run->exit_reason));
> -       }
> +       while (true) {
> +               /* Let the guest access its memory */
> +               ret =3D _vcpu_run(vcpu);
> +               TEST_ASSERT(ret =3D=3D 0
> +                                       || (errno =3D=3D EFAULT
> +                                               && run->exit_reason =3D=
=3D KVM_EXIT_MEMORY_FAULT),
> +                                       "vcpu_run failed: %d\n", ret);
> +               if (ret !=3D 0 && get_ucall(vcpu, NULL) !=3D UCALL_SYNC) =
{
> +
> +                       if (run->exit_reason =3D=3D KVM_EXIT_MEMORY_FAULT=
) {
> +                               ready_page(run->memory_fault.gpa);
> +                               continue;
> +                       }
> +
> +                       TEST_ASSERT(false,
> +                                               "Invalid guest sync statu=
s: exit_reason=3D%s\n",
> +                                               exit_reason_str(run->exit=
_reason));
> +               }
>
> -       ts_diff =3D timespec_elapsed(start);
> -       PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
> -                      ts_diff.tv_sec, ts_diff.tv_nsec);
> +               ts_diff =3D timespec_elapsed(start);
> +               PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vc=
pu_idx,
> +                                          ts_diff.tv_sec, ts_diff.tv_nse=
c);
> +               break;
> +       }
>  }
>
> -static int handle_uffd_page_request(int uffd_mode, int uffd,
> -               struct uffd_msg *msg)
> +static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t hv=
a,
> +                                                                       b=
ool is_vcpu)
>  {
>         pid_t tid =3D syscall(__NR_gettid);
> -       uint64_t addr =3D msg->arg.pagefault.address;
>         struct timespec start;
>         struct timespec ts_diff;
>         int r;
> @@ -71,56 +134,78 @@ static int handle_uffd_page_request(int uffd_mode, i=
nt uffd,
>                 struct uffdio_copy copy;
>
>                 copy.src =3D (uint64_t)guest_data_prototype;
> -               copy.dst =3D addr;
> +               copy.dst =3D hva;
>                 copy.len =3D demand_paging_size;
> -               copy.mode =3D 0;
> +               copy.mode =3D UFFDIO_COPY_MODE_DONTWAKE;
>
> -               r =3D ioctl(uffd, UFFDIO_COPY, &copy);
>                 /*
> -                * With multiple vCPU threads fault on a single page and =
there are
> -                * multiple readers for the UFFD, at least one of the UFF=
DIO_COPYs
> -                * will fail with EEXIST: handle that case without signal=
ing an
> -                * error.
> +                * With multiple vCPU threads and at least one of multipl=
e reader threads
> +                * or vCPU memory faults, multiple vCPUs accessing an abs=
ent page will
> +                * almost certainly cause some thread doing the UFFDIO_CO=
PY here to get
> +                * EEXIST: make sure to allow that case.
>                  */
> -               if (r =3D=3D -1 && errno !=3D EEXIST) {
> -                       pr_info("Failed UFFDIO_COPY in 0x%lx from thread =
%d, errno =3D %d\n",
> -                                       addr, tid, errno);
> -                       return r;
> -               }
> +               r =3D ioctl(uffd, UFFDIO_COPY, &copy);
> +               TEST_ASSERT(r =3D=3D 0 || errno =3D=3D EEXIST,
> +                       "Thread 0x%x failed UFFDIO_COPY on hva 0x%lx, err=
no =3D %d",
> +                       gettid(), hva, errno);
>         } else if (uffd_mode =3D=3D UFFDIO_REGISTER_MODE_MINOR) {
> +               /* The comments in the UFFDIO_COPY branch also apply here=
. */
>                 struct uffdio_continue cont =3D {0};
>
> -               cont.range.start =3D addr;
> +               cont.range.start =3D hva;
>                 cont.range.len =3D demand_paging_size;
> +               cont.mode =3D UFFDIO_CONTINUE_MODE_DONTWAKE;
>
>                 r =3D ioctl(uffd, UFFDIO_CONTINUE, &cont);
> -               /* See the note about EEXISTs in the UFFDIO_COPY branch. =
*/
> -               if (r =3D=3D -1 && errno !=3D EEXIST) {
> -                       pr_info("Failed UFFDIO_CONTINUE in 0x%lx, thread =
%d, errno =3D %d\n",
> -                                       addr, tid, errno);
> -                       return r;
> -               }
> +               TEST_ASSERT(r =3D=3D 0 || errno =3D=3D EEXIST,
> +                       "Thread 0x%x failed UFFDIO_CONTINUE on hva 0x%lx,=
 errno =3D %d",
> +                       gettid(), hva, errno);
>         } else {
>                 TEST_FAIL("Invalid uffd mode %d", uffd_mode);
>         }
>
> +       /*
> +        * If the above UFFDIO_COPY/CONTINUE fails with EEXIST, it will d=
o so without
> +        * waking threads waiting on the UFFD: make sure that happens her=
e.
> +        */

This comment sounds a little bit strange because we're always passing
MODE_DONTWAKE to UFFDIO_COPY/CONTINUE.

You *could* update the comment to reflect what this test is really
doing, but I think you actually probably want the test to do what the
comment suggests. That is, I think the code you should write should:
1. DONTWAKE if is_vcpu
2. UFFDIO_WAKE if !is_vcpu && UFFDIO_COPY/CONTINUE failed (with
EEXIST, but we would have already crashed if it weren't).

This way, we can save a syscall with almost no added complexity, and
the existing userfaultfd tests remain basically untouched (i.e., no
longer always need an explicit UFFDIO_WAKE).

Thanks!

> +       if (!is_vcpu) {
> +               struct uffdio_range range =3D {
> +                       .start =3D hva,
> +                       .len =3D demand_paging_size
> +               };
> +               r =3D ioctl(uffd, UFFDIO_WAKE, &range);
> +               TEST_ASSERT(
> +                       r =3D=3D 0,
> +                       "Thread 0x%x failed UFFDIO_WAKE on hva 0x%lx, err=
no =3D %d",
> +                       gettid(), hva, errno);
> +       }
> +
>         ts_diff =3D timespec_elapsed(start);
>
>         PER_PAGE_DEBUG("UFFD page-in %d \t%ld ns\n", tid,
>                        timespec_to_ns(ts_diff));
>         PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
> -                      demand_paging_size, addr, tid);
> +                      demand_paging_size, hva, tid);
>
>         return 0;
>  }
>
> +static int handle_uffd_page_request_from_uffd(int uffd_mode, int uffd,
> +                               struct uffd_msg *msg)
> +{
> +       TEST_ASSERT(msg->event =3D=3D UFFD_EVENT_PAGEFAULT,
> +               "Received uffd message with event %d !=3D UFFD_EVENT_PAGE=
FAULT",
> +               msg->event);
> +       return handle_uffd_page_request(uffd_mode, uffd,
> +                                       msg->arg.pagefault.address, false=
);
> +}
> +
>  struct test_params {
> -       int uffd_mode;
>         bool single_uffd;
> -       useconds_t uffd_delay;
>         int readers_per_uffd;
>         enum vm_mem_backing_src_type src_type;
>         bool partition_vcpu_memory_access;
> +       bool memfault_exits;
>  };
>
>  static void prefault_mem(void *alias, uint64_t len)
> @@ -137,15 +222,26 @@ static void prefault_mem(void *alias, uint64_t len)
>  static void run_test(enum vm_guest_mode mode, void *arg)
>  {
>         struct test_params *p =3D arg;
> -       struct uffd_desc **uffd_descs =3D NULL;
>         struct timespec start;
>         struct timespec ts_diff;
>         struct kvm_vm *vm;
> -       int i, num_uffds =3D 0;
> -       uint64_t uffd_region_size;
> +       int i;
> +       uint32_t slot_flags =3D 0;
> +       bool uffd_memfault_exits =3D uffd_mode && p->memfault_exits;
> +
> +       if (uffd_memfault_exits) {
> +               TEST_ASSERT(kvm_has_cap(KVM_CAP_ABSENT_MAPPING_FAULT) > 0=
,
> +                                       "KVM does not have KVM_CAP_ABSENT=
_MAPPING_FAULT");
> +               slot_flags =3D KVM_MEM_ABSENT_MAPPING_FAULT;
> +       }
>
>         vm =3D memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
> -                               1, 0, p->src_type, p->partition_vcpu_memo=
ry_access);
> +                               1, slot_flags, p->src_type, p->partition_=
vcpu_memory_access);
> +
> +       if (uffd_memfault_exits) {
> +               vm_enable_cap(vm,
> +                                         KVM_CAP_MEMORY_FAULT_INFO, KVM_=
MEMORY_FAULT_INFO_ENABLE);
> +       }
>
>         demand_paging_size =3D get_backing_src_pagesz(p->src_type);
>
> @@ -154,12 +250,12 @@ static void run_test(enum vm_guest_mode mode, void =
*arg)
>                     "Failed to allocate buffer for guest data pattern");
>         memset(guest_data_prototype, 0xAB, demand_paging_size);
>
> -       if (p->uffd_mode) {
> +       if (uffd_mode) {
>                 num_uffds =3D p->single_uffd ? 1 : nr_vcpus;
>                 uffd_region_size =3D nr_vcpus * guest_percpu_mem_size / n=
um_uffds;
>
>                 uffd_descs =3D malloc(num_uffds * sizeof(struct uffd_desc=
 *));
> -               TEST_ASSERT(uffd_descs, "Memory allocation failed");
> +               TEST_ASSERT(uffd_descs, "Failed to allocate memory of uff=
d descriptors");
>
>                 for (i =3D 0; i < num_uffds; i++) {
>                         struct memstress_vcpu_args *vcpu_args;
> @@ -179,10 +275,10 @@ static void run_test(enum vm_guest_mode mode, void =
*arg)
>                          * requests.
>                          */
>                         uffd_descs[i] =3D uffd_setup_demand_paging(
> -                               p->uffd_mode, p->uffd_delay, vcpu_hva,
> +                               uffd_mode, uffd_delay, vcpu_hva,
>                                 uffd_region_size,
>                                 p->readers_per_uffd,
> -                               &handle_uffd_page_request);
> +                               &handle_uffd_page_request_from_uffd);
>                 }
>         }
>
> @@ -196,7 +292,7 @@ static void run_test(enum vm_guest_mode mode, void *a=
rg)
>         ts_diff =3D timespec_elapsed(start);
>         pr_info("All vCPU threads joined\n");
>
> -       if (p->uffd_mode) {
> +       if (uffd_mode) {
>                 /* Tell the user fault fd handler threads to quit */
>                 for (i =3D 0; i < num_uffds; i++)
>                         uffd_stop_demand_paging(uffd_descs[i]);
> @@ -211,7 +307,7 @@ static void run_test(enum vm_guest_mode mode, void *a=
rg)
>         memstress_destroy_vm(vm);
>
>         free(guest_data_prototype);
> -       if (p->uffd_mode)
> +       if (uffd_mode)
>                 free(uffd_descs);
>  }
>
> @@ -220,7 +316,7 @@ static void help(char *name)
>         puts("");
>         printf("usage: %s [-h] [-m vm_mode] [-u uffd_mode] [-a]\n"
>                    "          [-d uffd_delay_usec] [-r readers_per_uffd] =
[-b memory]\n"
> -                  "          [-s type] [-v vcpus] [-o]\n", name);
> +                  "          [-w] [-s type] [-v vcpus] [-o]\n", name);
>         guest_modes_help();
>         printf(" -u: use userfaultfd to handle vCPU page faults. Mode is =
a\n"
>                "     UFFD registration mode: 'MISSING' or 'MINOR'.\n");
> @@ -231,6 +327,7 @@ static void help(char *name)
>                "     FD handler to simulate demand paging\n"
>                "     overheads. Ignored without -u.\n");
>         printf(" -r: Set the number of reader threads per uffd.\n");
> +       printf(" -w: Enable kvm cap for memory fault exits.\n");
>         printf(" -b: specify the size of the memory region which should b=
e\n"
>                "     demand paged by each vCPU. e.g. 10M or 3G.\n"
>                "     Default: 1G\n");
> @@ -250,29 +347,30 @@ int main(int argc, char *argv[])
>                 .partition_vcpu_memory_access =3D true,
>                 .readers_per_uffd =3D 1,
>                 .single_uffd =3D false,
> +               .memfault_exits =3D false,
>         };
>         int opt;
>
>         guest_modes_append_default();
>
> -       while ((opt =3D getopt(argc, argv, "ahom:u:d:b:s:v:r:")) !=3D -1)=
 {
> +       while ((opt =3D getopt(argc, argv, "ahowm:u:d:b:s:v:r:")) !=3D -1=
) {
>                 switch (opt) {
>                 case 'm':
>                         guest_modes_cmdline(optarg);
>                         break;
>                 case 'u':
>                         if (!strcmp("MISSING", optarg))
> -                               p.uffd_mode =3D UFFDIO_REGISTER_MODE_MISS=
ING;
> +                               uffd_mode =3D UFFDIO_REGISTER_MODE_MISSIN=
G;
>                         else if (!strcmp("MINOR", optarg))
> -                               p.uffd_mode =3D UFFDIO_REGISTER_MODE_MINO=
R;
> -                       TEST_ASSERT(p.uffd_mode, "UFFD mode must be 'MISS=
ING' or 'MINOR'.");
> +                               uffd_mode =3D UFFDIO_REGISTER_MODE_MINOR;
> +                       TEST_ASSERT(uffd_mode, "UFFD mode must be 'MISSIN=
G' or 'MINOR'.");
>                         break;
>                 case 'a':
>                         p.single_uffd =3D true;
>                         break;
>                 case 'd':
> -                       p.uffd_delay =3D strtoul(optarg, NULL, 0);
> -                       TEST_ASSERT(p.uffd_delay >=3D 0, "A negative UFFD=
 delay is not supported.");
> +                       uffd_delay =3D strtoul(optarg, NULL, 0);
> +                       TEST_ASSERT(uffd_delay >=3D 0, "A negative UFFD d=
elay is not supported.");
>                         break;
>                 case 'b':
>                         guest_percpu_mem_size =3D parse_size(optarg);
> @@ -295,6 +393,9 @@ int main(int argc, char *argv[])
>                                                 "Invalid number of reader=
s per uffd %d: must be >=3D1",
>                                                 p.readers_per_uffd);
>                         break;
> +               case 'w':
> +                       p.memfault_exits =3D true;
> +                       break;
>                 case 'h':
>                 default:
>                         help(argv[0]);
> @@ -302,7 +403,7 @@ int main(int argc, char *argv[])
>                 }
>         }
>
> -       if (p.uffd_mode =3D=3D UFFDIO_REGISTER_MODE_MINOR &&
> +       if (uffd_mode =3D=3D UFFDIO_REGISTER_MODE_MINOR &&
>             !backing_src_is_shared(p.src_type)) {
>                 TEST_FAIL("userfaultfd MINOR mode requires shared memory;=
 pick a different -s");
>         }
> --
> 2.40.0.577.gac1e443424-goog
>
