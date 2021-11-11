Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E26D44DB4D
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 18:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhKKR47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 12:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbhKKR47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 12:56:59 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BE0C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:54:09 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id i9so6594714ilu.8
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ZkCx8Pnahq8QLhrJGtSb9RmKs5I7seyUDP9Uib6srE=;
        b=kWW4Z6tDO3F17isSM6WlzAAJxMO+g6/ydAxq9pf3ESED+tafWiLqvk8Ro+4X5PyAoO
         aNrnrj1oCWqXrns/nSxaBOJwA1gKwnQPCzbkqMLsko4T1TEdSP3ux9dBW/QYwgQq8PI+
         GNt5Tli2LVnp2/KKzNyHpxpG35M54mqPRHtvqK7LAciL0+1wyrGPLcTCSze8LY5CeJm5
         haZuUFOQ5hfe0dW4/q06x1L/M6z8M+citxYbPfg9GCzjp9v1Y1wHtVToapdsqoLqKXSf
         OfdPeYG1G/hNf++43KnPGpDrXdLEfNTIPLg7aLA2p+Hm5V9dzBDjdWEOx2Cx71VRbfDn
         cHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ZkCx8Pnahq8QLhrJGtSb9RmKs5I7seyUDP9Uib6srE=;
        b=d+To6yj9ySCkKp4OHb6wIVEmXEIB9aPQ+QUky4oaJmKFp4u7zDWFElKCvJOU108Lbz
         EwyEDnDdxndmussYDUPWL1rV/AA8jhyhbJNjuVDFYqR9ogeQwBKduy8gWP08nv3pgFFD
         UjEbN8b4UW4IKcuNMS6WDDGnvIvr3zVNg/k+KiQ9SEy+UMLd2e8JsIBb/y96ntucGRLp
         ebXXRmS6rGKQOgBajgk4p1anP/2w+u41sNqniTq1RI2GauxMp0CNlvbNR4jx/GM2RHV/
         +d0yTy35SxgJ+35EH242uxplsbKrIfNrhl+P4kYpjcYojK6QY58h2e/lQQkURFRLsuJm
         pMnQ==
X-Gm-Message-State: AOAM531pXcsQliL+km6cxI+iptC1lyxdGXqjBqBQK/E8WlB6InN/ND8z
        s+p6x/5lC/0gykYzIt4th9OfJoddF8RXYFproGdt5T8DCc0=
X-Google-Smtp-Source: ABdhPJxv4RsFzt9tzyQvohfOn2SHFHrrnlRg0P1Il4z85PEW3IgmbKLF13j4I7iimz+k4wMXhFkFzirKXHdI/06SfAQ=
X-Received: by 2002:a05:6e02:52d:: with SMTP id h13mr5595469ils.274.1636653248864;
 Thu, 11 Nov 2021 09:54:08 -0800 (PST)
MIME-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com> <20211111000310.1435032-12-dmatlack@google.com>
In-Reply-To: <20211111000310.1435032-12-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 11 Nov 2021 09:53:57 -0800
Message-ID: <CANgfPd-mEk4Q5uEXCz+J27kKCrNL=-YMNsK0X3C9p8LtT5NmLw@mail.gmail.com>
Subject: Re: [PATCH v2 11/12] KVM: selftests: Fill per-vCPU struct during
 "perf_test" VM creation
To:     David Matlack <dmatlack@google.com>
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

On Wed, Nov 10, 2021 at 4:03 PM David Matlack <dmatlack@google.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Fill the per-vCPU args when creating the perf_test VM instead of having
> the caller do so.  This helps ensure that any adjustments to the number
> of pages (and thus vcpu_memory_bytes) are reflected in the per-VM args.
> Automatically filling the per-vCPU args will also allow a future patch
> to do the sync to the guest during creation.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [Updated access_tracking_perf_test as well.]
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../selftests/kvm/access_tracking_perf_test.c |  5 +-
>  .../selftests/kvm/demand_paging_test.c        |  5 +-
>  .../selftests/kvm/dirty_log_perf_test.c       |  6 +-
>  .../selftests/kvm/include/perf_test_util.h    |  6 +-
>  .../selftests/kvm/lib/perf_test_util.c        | 71 ++++++++++---------
>  .../kvm/memslot_modification_stress_test.c    |  6 +-
>  6 files changed, 45 insertions(+), 54 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index 5d95113c7b7c..fdef6c906388 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -332,10 +332,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         int vcpus = params->vcpus;
>
>         vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes, 1,
> -                                params->backing_src);
> -
> -       perf_test_setup_vcpus(vm, vcpus, params->vcpu_memory_bytes,
> -                             !overlap_memory_access);
> +                                params->backing_src, !overlap_memory_access);
>
>         vcpu_threads = create_vcpu_threads(vcpus);
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 3c729a0a1ab1..0fee44f5e5ae 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -293,7 +293,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         int r;
>
>         vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
> -                                p->src_type);
> +                                p->src_type, p->partition_vcpu_memory_access);
>
>         perf_test_args.wr_fract = 1;
>
> @@ -307,9 +307,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
>
> -       perf_test_setup_vcpus(vm, nr_vcpus, guest_percpu_mem_size,
> -                             p->partition_vcpu_memory_access);
> -
>         if (p->uffd_mode) {
>                 uffd_handler_threads =
>                         malloc(nr_vcpus * sizeof(*uffd_handler_threads));
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 7ffab5bd5ce5..62f9cc2a3146 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -186,7 +186,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         struct timespec clear_dirty_log_total = (struct timespec){0};
>
>         vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
> -                                p->slots, p->backing_src);
> +                                p->slots, p->backing_src,
> +                                p->partition_vcpu_memory_access);
>
>         perf_test_args.wr_fract = p->wr_fract;
>
> @@ -206,9 +207,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
>
> -       perf_test_setup_vcpus(vm, nr_vcpus, guest_percpu_mem_size,
> -                             p->partition_vcpu_memory_access);
> -
>         sync_global_to_guest(vm, perf_test_args);
>
>         /* Start the iterations */
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 9348580dc5be..91804be1cf53 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -39,10 +39,8 @@ extern struct perf_test_args perf_test_args;
>
>  struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>                                    uint64_t vcpu_memory_bytes, int slots,
> -                                  enum vm_mem_backing_src_type backing_src);
> +                                  enum vm_mem_backing_src_type backing_src,
> +                                  bool partition_vcpu_memory_access);
>  void perf_test_destroy_vm(struct kvm_vm *vm);
> -void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
> -                          uint64_t vcpu_memory_bytes,
> -                          bool partition_vcpu_memory_access);
>
>  #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index b3154b5b0cfd..13c8bc22f4e1 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -48,9 +48,43 @@ static void guest_code(uint32_t vcpu_id)
>         }
>  }
>
> +void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
> +                          uint64_t vcpu_memory_bytes,
> +                          bool partition_vcpu_memory_access)
> +{
> +       struct perf_test_args *pta = &perf_test_args;
> +       struct perf_test_vcpu_args *vcpu_args;
> +       int vcpu_id;
> +
> +       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> +               vcpu_args = &pta->vcpu_args[vcpu_id];
> +
> +               vcpu_args->vcpu_id = vcpu_id;
> +               if (partition_vcpu_memory_access) {
> +                       vcpu_args->gva = guest_test_virt_mem +
> +                                        (vcpu_id * vcpu_memory_bytes);
> +                       vcpu_args->pages = vcpu_memory_bytes /
> +                                          pta->guest_page_size;
> +                       vcpu_args->gpa = pta->gpa + (vcpu_id * vcpu_memory_bytes);
> +               } else {
> +                       vcpu_args->gva = guest_test_virt_mem;
> +                       vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
> +                                          pta->guest_page_size;
> +                       vcpu_args->gpa = pta->gpa;
> +               }
> +
> +               vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
> +
> +               pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
> +                        vcpu_id, vcpu_args->gpa, vcpu_args->gpa +
> +                        (vcpu_args->pages * pta->guest_page_size));
> +       }
> +}
> +
>  struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>                                    uint64_t vcpu_memory_bytes, int slots,
> -                                  enum vm_mem_backing_src_type backing_src)
> +                                  enum vm_mem_backing_src_type backing_src,
> +                                  bool partition_vcpu_memory_access)
>  {
>         struct perf_test_args *pta = &perf_test_args;
>         struct kvm_vm *vm;
> @@ -119,6 +153,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>         /* Do mapping for the demand paging memory slot */
>         virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages);
>
> +       perf_test_setup_vcpus(vm, vcpus, vcpu_memory_bytes, partition_vcpu_memory_access);
> +
>         ucall_init(vm, NULL);
>
>         return vm;
> @@ -129,36 +165,3 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
>         ucall_uninit(vm);
>         kvm_vm_free(vm);
>  }
> -
> -void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
> -                          uint64_t vcpu_memory_bytes,
> -                          bool partition_vcpu_memory_access)
> -{
> -       struct perf_test_args *pta = &perf_test_args;
> -       struct perf_test_vcpu_args *vcpu_args;
> -       int vcpu_id;
> -
> -       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> -               vcpu_args = &pta->vcpu_args[vcpu_id];
> -
> -               vcpu_args->vcpu_id = vcpu_id;
> -               if (partition_vcpu_memory_access) {
> -                       vcpu_args->gva = guest_test_virt_mem +
> -                                        (vcpu_id * vcpu_memory_bytes);
> -                       vcpu_args->pages = vcpu_memory_bytes /
> -                                          pta->guest_page_size;
> -                       vcpu_args->gpa = pta->gpa + (vcpu_id * vcpu_memory_bytes);
> -               } else {
> -                       vcpu_args->gva = guest_test_virt_mem;
> -                       vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
> -                                          pta->guest_page_size;
> -                       vcpu_args->gpa = pta->gpa;
> -               }
> -
> -               vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
> -
> -               pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
> -                        vcpu_id, vcpu_args->gpa, vcpu_args->gpa +
> -                        (vcpu_args->pages * pta->guest_page_size));
> -       }
> -}
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index d105180d5e8c..27af0bb8deb7 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -105,16 +105,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         int vcpu_id;
>
>         vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
> -                                VM_MEM_SRC_ANONYMOUS);
> +                                VM_MEM_SRC_ANONYMOUS,
> +                                p->partition_vcpu_memory_access);
>
>         perf_test_args.wr_fract = 1;
>
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
>
> -       perf_test_setup_vcpus(vm, nr_vcpus, guest_percpu_mem_size,
> -                             p->partition_vcpu_memory_access);
> -
>         /* Export the shared variables to the guest */
>         sync_global_to_guest(vm, perf_test_args);
>
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
