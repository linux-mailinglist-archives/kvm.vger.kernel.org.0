Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60AA44DB7D
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 19:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhKKSUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 13:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhKKSUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 13:20:30 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AE9C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:17:40 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id v65so8047683ioe.5
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lcl5yw0634Kx5pwbqLMewEnhAihEPUw8G2TcD9D1ecM=;
        b=quas8LPUmiNfG+PClZG3a4hHc3ppRj/f67Vuy+zz41v2Q3rLTiPNx1wysNK3qyu0XH
         cXvALIH3GOQWKjZapHgMDbgG9oWHgUSpwfIHYp5Pf0sEejQ/lYkeUuTEx8i8DRcdR5mx
         FvvJK27LJqgoPica2DhPdT7FlUAvyFqHgfjVyn5CktiWrBh7pCeawpm295hF/xwbbtV5
         y1kmTZB01At62QKImPR6XONVUH+5czzstbAi/B8AiR4wX4jhAfs4vGC2YWIg2fqxy5da
         NzK9kS8CdzyRer23uyD9FWiFeZl0khbi3v51pMPeNGRO/39uF8pdwJ8RYe5Clj9oA3y5
         mXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lcl5yw0634Kx5pwbqLMewEnhAihEPUw8G2TcD9D1ecM=;
        b=sA4EF5oI1cc78XMOe2Ft5+8MR7S6POPTxiQbSzLfuTVO1yLm41WA9dlFZOCSM8xFfb
         6yGV8jJz5VCcbd/OeKnZqA1u0+Bp/NKP5plrn6AUptIH5NPHw8FjVqMQ88iv8mWnEpbh
         NdVLO4q02gcX7iqSgMujOn5g24PPnsz7k68Qt/G0j2KvJoaOF6POkiMUJRMZ5bJ+f+sW
         5PzTqei+PMWnG56UOHnEAMDlkfpym9kHkxuFLnqubf182UaXjVhTlSAIaTUtCJXyaHQw
         eilnjvqVTT4oKtCt7LeyoiFHaDkoBjFQaEE/uoCFiC88cFkKn/7YZC31BVLAA7gDe3fg
         IBIA==
X-Gm-Message-State: AOAM531NrzGJjvs4f/t0jWX+DJv6sf3BG3qrAHWSIyu/gxq2GIlThWV8
        9ruH2hn7q8nhqgFcPb622Ygx7+vbiCLqobKM5tmjmQ==
X-Google-Smtp-Source: ABdhPJzd1XG0Z82McbMw/mbTryr/thpGloiRkTm8jhkkM2HJJVY7jOe3wiOUzkbg3PnPXfNzJxAm62bAiE+trrsiOww=
X-Received: by 2002:a02:624c:: with SMTP id d73mr6988152jac.32.1636654660027;
 Thu, 11 Nov 2021 10:17:40 -0800 (PST)
MIME-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com> <20211111001257.1446428-4-dmatlack@google.com>
In-Reply-To: <20211111001257.1446428-4-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 11 Nov 2021 10:17:28 -0800
Message-ID: <CANgfPd-Gzjvhs0HxCZZtJqmG31rNJ71XFo_SXD9Bbpa3S2E-gg@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: selftests: Wait for all vCPU to be created
 before entering guest mode
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

On Wed, Nov 10, 2021 at 4:13 PM David Matlack <dmatlack@google.com> wrote:
>
> Thread creation requires taking the mmap_sem in write mode, which causes
> vCPU threads running in guest mode to block while they are populating
> memory. Fix this by waiting for all vCPU threads to be created and start
> running before entering guest mode on any one vCPU thread.
>
> This substantially improves the "Populate memory time" when using 1GiB
> pages since it allows all vCPUs to zero pages in parallel rather than
> blocking because a writer is waiting (which is waiting for another vCPU
> that is busy zeroing a 1GiB page).
>
> Before:
>
>   $ ./dirty_log_perf_test -v256 -s anonymous_hugetlb_1gb
>   ...
>   Populate memory time: 52.811184013s
>
> After:
>
>   $ ./dirty_log_perf_test -v256 -s anonymous_hugetlb_1gb
>   ...
>   Populate memory time: 10.204573342s
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../selftests/kvm/lib/perf_test_util.c        | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index d646477ed16a..722df3a28791 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -22,6 +22,9 @@ struct vcpu_thread {
>
>         /* The pthread backing the vCPU. */
>         pthread_t thread;
> +
> +       /* Set to true once the vCPU thread is up and running. */
> +       bool running;
>  };
>
>  /* The vCPU threads involved in this test. */
> @@ -30,6 +33,9 @@ static struct vcpu_thread vcpu_threads[KVM_MAX_VCPUS];
>  /* The function run by each vCPU thread, as provided by the test. */
>  static void (*vcpu_thread_fn)(struct perf_test_vcpu_args *);
>
> +/* Set to true once all vCPU threads are up and running. */
> +static bool all_vcpu_threads_running;
> +
>  /*
>   * Continuously write to the first 8 bytes of each page in the
>   * specified region.
> @@ -196,6 +202,17 @@ static void *vcpu_thread_main(void *data)
>  {
>         struct vcpu_thread *vcpu = data;
>
> +       WRITE_ONCE(vcpu->running, true);
> +
> +       /*
> +        * Wait for all vCPU threads to be up and running before calling the test-
> +        * provided vCPU thread function. This prevents thread creation (which
> +        * requires taking the mmap_sem in write mode) from interfering with the
> +        * guest faulting in its memory.
> +        */
> +       while (!READ_ONCE(all_vcpu_threads_running))
> +               ;
> +

I can never remember the rules on this so I could be wrong, but you
may want a cpu_relax() in that loop to prevent it from being optimized
out. Maybe the READ_ONCE is sufficient though.

>         vcpu_thread_fn(&perf_test_args.vcpu_args[vcpu->vcpu_id]);
>
>         return NULL;
> @@ -206,14 +223,23 @@ void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vc
>         int vcpu_id;
>
>         vcpu_thread_fn = vcpu_fn;
> +       WRITE_ONCE(all_vcpu_threads_running, false);
>
>         for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
>                 struct vcpu_thread *vcpu = &vcpu_threads[vcpu_id];
>
>                 vcpu->vcpu_id = vcpu_id;
> +               WRITE_ONCE(vcpu->running, false);

Do these need to be WRITE_ONCE? I don't think WRITE_ONCE provides any
extra memory ordering guarantees and I don't know why the compiler
would optimize these out. If they do need to be WRITE_ONCE, they
probably merit comments.

>
>                 pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
>         }
> +
> +       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> +               while (!READ_ONCE(vcpu_threads[vcpu_id].running))
> +                       ;
> +       }
> +
> +       WRITE_ONCE(all_vcpu_threads_running, true);
>  }
>
>  void perf_test_join_vcpu_threads(int vcpus)
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
