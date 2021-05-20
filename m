Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C491A38BA7A
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhETXnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhETXnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:43:32 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EE9C061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:42:10 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 69-20020a9d0a4b0000b02902ed42f141e1so16443418otg.2
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZNA51VE0q/ujKoRhP3sJ06xR3qTM8S6pO6zy4LNTR+0=;
        b=fALF87PoFyF7o/b0P7MeSf96GsTeWG0ZqzKl4y0eccxqvBZi1hH0tgsr5oGlsT30G4
         1q8YJWt0Ytzsbwt+Sx5uMJQJbFhKny/JVDxyDpPFdpVDYFvFq4gcaoRNniTQn7ByWT9y
         EM78cX+7eKbvbLHfme7apybM7QfwJW2AIQyPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZNA51VE0q/ujKoRhP3sJ06xR3qTM8S6pO6zy4LNTR+0=;
        b=NkyTCcoJFozgn07SuTX0+82cXS10owwgqF1k5S98kdZ4r+AMlByJJKHzCCvA8k+bCq
         G5wv4ujh31n/Nv/RtbV2lgR8I9JhFkFX2KnLHea099ymUOAVNYczaC2Uz36qqpNaPMae
         rKHDB7HoeFXgn6X3eQKl7yE9j2s/phoozQh9PxXyBi05KZiFmhlyrHb1uWedc/hYhQkP
         wTTDe1/zAVCD9aDnWxhTA40yHNrcS+PaMZXIa7PwgOYMTlTOhR+gHQB5gMxh4nV8v9mc
         rTsqBZlC2eNzKPS252DLVSVeYk6UorMbk0vZjec8hsbQ68ADDsZXhOFpoQaBI2toUgBr
         Ae4A==
X-Gm-Message-State: AOAM531D1ZNsjJTSTzppyAIeXTobeSx91JWcaIGo53SUP4EaoQPPjh1P
        DD671hY51+FKW+hD0P203C96OJu1DuU7b5JbEWht9g==
X-Google-Smtp-Source: ABdhPJzeKZLfzXGRmi1+bEb7w1EAwZ4//uL1QtOgL0OOr3ejHUrBk6WcsGKtpgHW079ExbMcMbaJbpI9kQ2DZtpBdFc=
X-Received: by 2002:a9d:5786:: with SMTP id q6mr5833959oth.56.1621554130190;
 Thu, 20 May 2021 16:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210520212654.712276-1-dmatlack@google.com>
In-Reply-To: <20210520212654.712276-1-dmatlack@google.com>
From:   Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Thu, 20 May 2021 16:41:58 -0700
Message-ID: <CAA0tLEpfc0vGW7Jazqrn6D==z+rdBv2GLeYf=2p0hqREZJEwew@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 2:27 PM David Matlack <dmatlack@google.com> wrote:
>
> vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
> which causes the upper 32-bits of the max_gfn to get truncated.
>
> Nobody noticed until now likely because vm_get_max_gfn() is only used
> as a mechanism to create a memslot in an unused region of the guest
> physical address space (the top), and the top of the 32-bit physical
> address space was always good enough.
>
> This fix reveals a bug in memslot_modification_stress_test which was
> trying to create a dummy memslot past the end of guest physical memory.
> Fix that by moving the dummy memslot lower.
>
> Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h |  2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c     |  2 +-
>  .../testing/selftests/kvm/lib/perf_test_util.c |  2 +-
>  .../kvm/memslot_modification_stress_test.c     | 18 +++++++++++-------
>  4 files changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 84982eb02b29..5d9b35d09251 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -303,7 +303,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
>
>  unsigned int vm_get_page_size(struct kvm_vm *vm);
>  unsigned int vm_get_page_shift(struct kvm_vm *vm);
> -unsigned int vm_get_max_gfn(struct kvm_vm *vm);
> +uint64_t vm_get_max_gfn(struct kvm_vm *vm);
>  int vm_get_fd(struct kvm_vm *vm);
>
>  unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1af1009254c4..aeffbb1e7c7d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2058,7 +2058,7 @@ unsigned int vm_get_page_shift(struct kvm_vm *vm)
>         return vm->page_shift;
>  }
>
> -unsigned int vm_get_max_gfn(struct kvm_vm *vm)
> +uint64_t vm_get_max_gfn(struct kvm_vm *vm)
>  {
>         return vm->max_gfn;
>  }
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 81490b9b4e32..ed4424ed26d6 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -80,7 +80,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>          */
>         TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
>                     "Requested more guest memory than address space allows.\n"
> -                   "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
> +                   "    guest pages: %lx max gfn: %lx vcpus: %d wss: %lx]\n",
>                     guest_num_pages, vm_get_max_gfn(vm), vcpus,
>                     vcpu_memory_bytes);
>
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 6096bf0a5b34..98351ba0933c 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -71,14 +71,22 @@ struct memslot_antagonist_args {
>  };
>
>  static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
> -                             uint64_t nr_modifications, uint64_t gpa)
> +                              uint64_t nr_modifications)
>  {
> +       const uint64_t pages = 1;
> +       uint64_t gpa;
>         int i;
>
> +       /*
> +        * Add the dummy memslot just below the perf_test_util memslot, which is
> +        * at the top of the guest physical address space.
> +        */
> +       gpa = guest_test_phys_mem - pages * vm_get_page_size(vm);
> +
>         for (i = 0; i < nr_modifications; i++) {
>                 usleep(delay);
>                 vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa,
> -                                           DUMMY_MEMSLOT_INDEX, 1, 0);
> +                                           DUMMY_MEMSLOT_INDEX, pages, 0);
>
>                 vm_mem_region_delete(vm, DUMMY_MEMSLOT_INDEX);
>         }
> @@ -120,11 +128,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         pr_info("Started all vCPUs\n");
>
>         add_remove_memslot(vm, p->memslot_modification_delay,
> -                          p->nr_memslot_modifications,
> -                          guest_test_phys_mem +
> -                          (guest_percpu_mem_size * nr_vcpus) +
> -                          perf_test_args.host_page_size +
> -                          perf_test_args.guest_page_size);
> +                          p->nr_memslot_modifications);
>
>         run_vcpus = false;
>
> --
> 2.31.1.818.g46aad6cb9e-goog

Hah, good catch!

Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
