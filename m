Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E603898C3
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 23:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhESVrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 17:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhESVrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 17:47:13 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DD3C061760
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:45:53 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id g11so9484144ilq.3
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n+MU5sQJyoUxoQR/RnPtWo1DwBMH6gtnYsN37Ax0beM=;
        b=mBB+1FV4MtxiRwkKsGVfbsWWHrOfVTntJlUTN9QLTf0cSwRZbYx+7h3P6X8QYdpN8q
         7MCCd8bs7mIuFt72Sk0WYO+mQtl7EX3g1hutzP7YrzBWI16poLAGSlY2Sy10GNTDMhUH
         CSya8+hnrmxugrw+xoi7htTIgtRknQUluubWU5LrdLH/pJBHFAULg1EJpMIXbfo1gA66
         +qiUZSo/q/WKEDMKXNMv9MROhXmHzRtHogMhehD9sr7BgLRuaJMNLtAJl2jAL3sAftFU
         8680Qmhs7/Mny5vfG+ypQUIvMZgcYHIUADYFgHqpxb/fJlORQb/79jpooKWO0oSbMMDM
         ENSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n+MU5sQJyoUxoQR/RnPtWo1DwBMH6gtnYsN37Ax0beM=;
        b=ste8LS/8dALmZhfs80V+TL0loh7t2wLBeBLyZKEsZuYcANBk1/sTXjr8xVkaEAoUFp
         gV6tTE8kJ3rHxOTluHouyKFlTXYn6d7KdMTpsIS+6E0qZNSFhnjQ6fNeoxKf+djpsy7i
         X3yARc2DWVOFUwcQdpeKXLzw4GTfVoGplaiZkl/aUomK5e71ykf5ydFF0U6fTlYUTg9Y
         P7DSyFRkTCn/Td21/wqd5cmB5tlOEQt9BeqJXsfvFWT88W9+cLFgtfq/YvU0Xhm0Rnaq
         4O6g/EmAnLuugFC+mcA98AK/5O9gMJwsotRHATeSC0MRt3xeUV0HAmF8fl+I4mstRvdU
         7sDA==
X-Gm-Message-State: AOAM533mU8tcBcq73J09KjbM5JWfpYJD7n45Zk2uo02GFpTwYylOEELg
        DSXdwtk4Hc2kp2l+6vtKwwHDrdKz3p3NuK8gkQE3EQ==
X-Google-Smtp-Source: ABdhPJwktiwv3aU3KIGOoAvcgktQDDuH4nFS8fhYrPFwZd7Y9gtC5QSUysygH3xucU9DUmNGWpTOWf5S7oPJkeW1Fa4=
X-Received: by 2002:a05:6e02:13ec:: with SMTP id w12mr1414415ilj.285.1621460752580;
 Wed, 19 May 2021 14:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210519200339.829146-1-axelrasmussen@google.com> <20210519200339.829146-3-axelrasmussen@google.com>
In-Reply-To: <20210519200339.829146-3-axelrasmussen@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 19 May 2021 14:45:41 -0700
Message-ID: <CANgfPd-dF+vWafBC5DsNhf5C0M12+LxRQLhsBM=CzOKTsep+og@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] KVM: selftests: simplify setup_demand_paging
 error handling
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 1:03 PM Axel Rasmussen <axelrasmussen@google.com> wrote:
>
> A small cleanup. Our caller writes:
>
>   r = setup_demand_paging(...);
>   if (r < 0) exit(-r);
>
> Since we're just going to exit anyway, instead of returning an error we
> can just re-use TEST_ASSERT. This makes the caller simpler, as well as
> the function itself - no need to write our branches, etc.
>
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  .../selftests/kvm/demand_paging_test.c        | 51 +++++++------------
>  1 file changed, 19 insertions(+), 32 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 9398ba6ef023..601a1df24dd2 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -9,6 +9,8 @@
>
>  #define _GNU_SOURCE /* for pipe2 */
>
> +#include <inttypes.h>
> +#include <stdint.h>

Why do the includes need to change in this commit? Is it for the PRIu64 below?

>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <time.h>
> @@ -198,42 +200,32 @@ static void *uffd_handler_thread_fn(void *arg)
>         return NULL;
>  }
>
> -static int setup_demand_paging(struct kvm_vm *vm,
> -                              pthread_t *uffd_handler_thread, int pipefd,
> -                              useconds_t uffd_delay,
> -                              struct uffd_handler_args *uffd_args,
> -                              void *hva, uint64_t len)
> +static void setup_demand_paging(struct kvm_vm *vm,
> +                               pthread_t *uffd_handler_thread, int pipefd,
> +                               useconds_t uffd_delay,
> +                               struct uffd_handler_args *uffd_args,
> +                               void *hva, uint64_t len)
>  {
>         int uffd;
>         struct uffdio_api uffdio_api;
>         struct uffdio_register uffdio_register;
>
>         uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
> -       if (uffd == -1) {
> -               pr_info("uffd creation failed\n");
> -               return -1;
> -       }
> +       TEST_ASSERT(uffd >= 0, "uffd creation failed, errno: %d", errno);
>
>         uffdio_api.api = UFFD_API;
>         uffdio_api.features = 0;
> -       if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1) {
> -               pr_info("ioctl uffdio_api failed\n");
> -               return -1;
> -       }
> +       TEST_ASSERT(ioctl(uffd, UFFDIO_API, &uffdio_api) != -1,
> +                   "ioctl UFFDIO_API failed: %" PRIu64,
> +                   (uint64_t)uffdio_api.api);
>
>         uffdio_register.range.start = (uint64_t)hva;
>         uffdio_register.range.len = len;
>         uffdio_register.mode = UFFDIO_REGISTER_MODE_MISSING;
> -       if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) == -1) {
> -               pr_info("ioctl uffdio_register failed\n");
> -               return -1;
> -       }
> -
> -       if ((uffdio_register.ioctls & UFFD_API_RANGE_IOCTLS) !=
> -                       UFFD_API_RANGE_IOCTLS) {
> -               pr_info("unexpected userfaultfd ioctl set\n");
> -               return -1;
> -       }
> +       TEST_ASSERT(ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) != -1,
> +                   "ioctl UFFDIO_REGISTER failed");
> +       TEST_ASSERT((uffdio_register.ioctls & UFFD_API_RANGE_IOCTLS) ==
> +                   UFFD_API_RANGE_IOCTLS, "unexpected userfaultfd ioctl set");
>
>         uffd_args->uffd = uffd;
>         uffd_args->pipefd = pipefd;
> @@ -243,8 +235,6 @@ static int setup_demand_paging(struct kvm_vm *vm,
>
>         PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
>                        hva, hva + len);
> -
> -       return 0;
>  }
>
>  struct test_params {
> @@ -321,13 +311,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                   O_CLOEXEC | O_NONBLOCK);
>                         TEST_ASSERT(!r, "Failed to set up pipefd");
>
> -                       r = setup_demand_paging(vm,
> -                                               &uffd_handler_threads[vcpu_id],
> -                                               pipefds[vcpu_id * 2],
> -                                               p->uffd_delay, &uffd_args[vcpu_id],
> -                                               vcpu_hva, vcpu_mem_size);
> -                       if (r < 0)
> -                               exit(-r);
> +                       setup_demand_paging(vm, &uffd_handler_threads[vcpu_id],
> +                                           pipefds[vcpu_id * 2], p->uffd_delay,
> +                                           &uffd_args[vcpu_id], vcpu_hva,
> +                                           vcpu_mem_size);
>                 }
>         }
>
> --
> 2.31.1.751.gd2f1c929bd-goog
>
