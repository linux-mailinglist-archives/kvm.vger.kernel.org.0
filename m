Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0D644DB47
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 18:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhKKRwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 12:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbhKKRwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 12:52:21 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F901C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:49:32 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id s15so6589072ild.9
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lv9+qRtDfVNBeUPHdXKCzLOXDlveOcVjElOzeyrdypc=;
        b=HgSqY/Dn338zjSb8q6LgbYV9lIAsKW/VfxtKKi/SRkQXPRzsQq5f2aL3bMlyL5HL6q
         WbAz7zoVHUDDxC76llzKrLjRPra+yung/PvUbMqf3xHEhjZ+uxb0Su+NkMLyD5Ao8Vvi
         qzNyPJ4VtjmQarDPBmT84UhTTPhmffZNpbMoJc6rQzY7an5BQ2Ce5gmeHFjuu8Ume8+7
         YFobvXhh6dG/zlP+7X6+sp6O9kOL+egarqIig2WIdRbMykiJ10RFX2Iiq8LSx3Iq1sjw
         OFTR4nOjXQYO8jFHuTWKbDBh+I9tncMyM7c7XL8MvD6etzXi8qpCT7No9wGskkIhjBOL
         +Dvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lv9+qRtDfVNBeUPHdXKCzLOXDlveOcVjElOzeyrdypc=;
        b=MxpY6FFmKnJ90fNp0IdDdzlNjpSDOl/bniY98ubGCARDav82gNzRafOCc0H9qQzMPk
         igPWBuIVMAjBWAYsszZK1jg+OMGQOUKiVEKZTozGNlVyDlXDg0B/TiCGfhnQJTNxuW55
         B+mvA4Vl1nkmy9EqdwLNGXFuMlkCdtVb/HvrdYgHiIHiO5lYIw9PKPPnJqRnMCnedsjH
         l3yN8kwqN6GtxZA2DPALLRndyJX2BjFPvZZB1yhxK3a9Z7oPq20K2hf5KZjV/2QUDGuU
         p3ryzQxhZROWFjTl+N+/YcREKTpVj+wdFsSibWX+6XjKIazFUun4s9ZDPnOwPL7c4ZC4
         v8ZQ==
X-Gm-Message-State: AOAM5304FFd3N9wS5jSTZ/comWmZHd8tmSYhISzDJkzkFg8d0cITM0wn
        YORjpPd/YWB2vk+ojwg7jTNRO2JBSFhcolXKhM2/gA==
X-Google-Smtp-Source: ABdhPJyCS8u9Y8vllNiJoSwFKjAz4U0+U937a9CdPoW/hf+LB5ODMSQPvqSn6+fG5ZhMum09eqK20Zp2MnR5ReKKbsY=
X-Received: by 2002:a05:6e02:604:: with SMTP id t4mr5250036ils.129.1636652971699;
 Thu, 11 Nov 2021 09:49:31 -0800 (PST)
MIME-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com> <20211111000310.1435032-5-dmatlack@google.com>
In-Reply-To: <20211111000310.1435032-5-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 11 Nov 2021 09:49:20 -0800
Message-ID: <CANgfPd9L4pnKQiiTFcccuCQ69Ohta=wvWRH5MVDzCZVZyp_dBA@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] KVM: selftests: Require GPA to be aligned when
 backed by hugepages
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
> Assert that the GPA for a memslot backed by a hugepage is aligned to
> the hugepage size and fix perf_test_util accordingly.  Lack of GPA
> alignment prevents KVM from backing the guest with hugepages, e.g. x86's
> write-protection of hugepages when dirty logging is activated is
> otherwise not exercised.
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
> [Used get_backing_src_pagesz() to determine alignment dynamically.]
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c       | 2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c | 7 ++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 07f37456bba0..1f6a01c33dce 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -875,6 +875,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>         if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
>                 alignment = max(backing_src_pagesz, alignment);
>
> +       ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
> +
>         /* Add enough memory to align up if necessary */
>         if (alignment > 1)
>                 region->mmap_size += alignment;
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 6b8d5020dc54..a015f267d945 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -55,11 +55,16 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  {
>         struct kvm_vm *vm;
>         uint64_t guest_num_pages;
> +       uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
>         int i;
>
>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>
>         perf_test_args.host_page_size = getpagesize();
> +       /*
> +        * Snapshot the non-huge page size.  This is used by the guest code to
> +        * access/dirty pages at the logging granularity.
> +        */
>         perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;

Is this comment correct? I wouldn't expect the guest page size to
determine the host dirty logging granularity.

>
>         guest_num_pages = vm_adjust_num_guest_pages(mode,
> @@ -92,7 +97,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>
>         guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
>                               perf_test_args.guest_page_size;
> -       guest_test_phys_mem = align_down(guest_test_phys_mem, perf_test_args.host_page_size);
> +       guest_test_phys_mem = align_down(guest_test_phys_mem, backing_src_pagesz);
>  #ifdef __s390x__
>         /* Align to 1M (segment size) */
>         guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
