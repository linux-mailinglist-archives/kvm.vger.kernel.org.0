Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C9A3182DD
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 02:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhBKBCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 20:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhBKBCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 20:02:50 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FAEC06174A
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:02:10 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id n14so4031971iog.3
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXPz8x009zJOB7UNZK68toCz+xiJ1t8lXIR6DThDxyo=;
        b=qfv6e6bp2CKLC3U11i/OzkwTqQcAjNwXNLo4uHaSMp/SkdJn5nXlBT9PunvcIvqSzt
         tpf36qMgsFkeH5CEy4XZGU1u8aPo9ly+ImNKZNJf3qR58XlyglNK2/z5r6sKcaxnRkQw
         Gu17bGiI0pQjI8fcVwVxkCqIucTDsBFvpFPXVbazSAJofdGBiGqf4fa7gVaR/pJuG0Ng
         uiU0ecbm1TQwmDhPl8PVSI0n81xRuj1p7vlwmpMi3AwZvLzTxN5dtecgGoKrADGwMC+/
         rwEIbwy5Lnj/Pl9q+jdD3TNHgASwv58/xXxo1dQChT5EppWeVOvnCgHNqplfBXUorP9z
         QwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXPz8x009zJOB7UNZK68toCz+xiJ1t8lXIR6DThDxyo=;
        b=a6oNRr0wPUfv/ft9XlBelq5Q/xjr+4VJWTwMvIqKmI3rYLU4487VaGWN383j7vcbq+
         bOQnnLbwMunXscMhuNrKevzycV7/nODYUMCnd9CUeGtTsWx0zvsIF5FzymCmSQRX1II9
         e3MQDfmh7PmQ90XmezfB+9Qet9t/fD8uJrpp8H4ReLoijTa33fVpEiOZz3GtcGAIVoPN
         MrvcjWbqWlF1SrmxtR6rxUJgF0VOvug79DkApDVYLzab41qDeCKghixXjl7CLVWRrA+s
         gLO1zwqMTNFNolF2QuIN5WjpX1WhDV8lzneNi3lrcMc6xL4AY9nFz0bWad9rhkEi6/F8
         hZug==
X-Gm-Message-State: AOAM530mNMIRiBCnFWweYYMoeyQnnNGHzLC2a5ez/0aIdGTdD9GcpdvN
        B6FPgctQX9MaYF2v9dpuNgkSuchbPMEH8dSliXPiItjFd5okgw==
X-Google-Smtp-Source: ABdhPJyaTVEr/tPirJU5lXHJ0wfXo4qC5Dap7iQCSpN9lAgwCd3ZXFSaJlIoHgABSrvSD/yBiQ5hMMJlvAfJW5uek8U=
X-Received: by 2002:a05:6602:2e01:: with SMTP id o1mr3312618iow.9.1613005329871;
 Wed, 10 Feb 2021 17:02:09 -0800 (PST)
MIME-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com> <20210210230625.550939-6-seanjc@google.com>
In-Reply-To: <20210210230625.550939-6-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Feb 2021 17:01:58 -0800
Message-ID: <CANgfPd_1O-Ziw-CyES+VZaPebkxHoDkRX3WYvEFMLP+6nukAaA@mail.gmail.com>
Subject: Re: [PATCH 05/15] KVM: selftests: Require GPA to be aligned when
 backed by hugepages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 3:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Assert that the GPA for a memslot backed by a hugepage is 1gb aligned,
> and fix perf_test_util accordingly.  Lack of GPA alignment prevents KVM
> from backing the guest with hugepages, e.g. x86's write-protection of
> hugepages when dirty logging is activated is otherwise not exercised.
>
> Add a comment explaining that guest_page_size is for non-huge pages to
> try and avoid confusion about what it actually tracks.
>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Yanan Wang <wangyanan55@huawei.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c       | 2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c | 9 +++++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 2e497fbab6ae..855d20784ba7 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -735,6 +735,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>         else
>                 ASSERT_EQ(src_type, VM_MEM_SRC_ANONYMOUS);
>
> +       ASSERT_EQ(guest_paddr, align(guest_paddr, alignment));
> +
>         /* Add enough memory to align up if necessary */
>         if (alignment > 1)
>                 region->mmap_size += alignment;
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 81490b9b4e32..f187b86f2e14 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -58,6 +58,11 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>
>         perf_test_args.host_page_size = getpagesize();
> +
> +       /*
> +        * Snapshot the non-huge page size.  This is used by the guest code to
> +        * access/dirty pages at the logging granularity.
> +        */
>         perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
>
>         guest_num_pages = vm_adjust_num_guest_pages(mode,
> @@ -87,6 +92,10 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>         guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
>                               perf_test_args.guest_page_size;
>         guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
> +       if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
> +           backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
> +               guest_test_phys_mem &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);

You could use the align helper here as well. That would make this a
little easier for me to read.

> +
>  #ifdef __s390x__
>         /* Align to 1M (segment size) */
>         guest_test_phys_mem &= ~((1 << 20) - 1);
> --
> 2.30.0.478.g8a0d178c01-goog
>
