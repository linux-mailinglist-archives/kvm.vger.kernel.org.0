Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40573318307
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 02:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBKBYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 20:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhBKBYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 20:24:33 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A657EC06174A
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:23:53 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id z18so3709282ile.9
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pY8l/20On2UFTPjuvwZ65am2VYSsb4OULocEQ2YqOYM=;
        b=i2SQ/dTzzZaKwHrkjY3KBnmt1Bn1PjJF000isMS95u/EmLn1S8ZG4y4hQalydI1Jpm
         UXzPXSOgiUtofMLohzbgTgLytTOp7Y49G9UinDbwYl3WqURejDVKvG5wL04IgDQlH+6M
         jMibcB4RptQN8WwSdqlzWMLzwGPQvRjCSMP3Qf9xto7bbz0FUIQkWoAGUZgnSzVhtAPA
         t1atncLLFBei6BGFr4uqeIopdMS6mMI82yPVyew0i3KqTPy50lnYFu1sh2MQ0jNHG21y
         53j9/+00boIBLiny465MpsTqhFmYOPD5cbL5e46IaDfcZT9TbUdZFSle/oK2YhWGKMAo
         pVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pY8l/20On2UFTPjuvwZ65am2VYSsb4OULocEQ2YqOYM=;
        b=ejDRUKjSKOoHvQcynzaHKzpVypKlCi48uImLmC3CfpWHbgZvQTya2pmoADa6mhggSr
         SAt/iRpTBS+5FcmDXRoLGDQPWqoUFk60RSL0mSkchQERaXrRFGudl9oVf05SHOBW6t5B
         u8stERkg+Ci5zjDJHXZs5mzufhdnH48ipmOuStrx76nmWikYsCX4y3tHx2Hhlit+SKYV
         xg8uypmYN7DY7d5yg07JIyRiN6UntqGFfwF6QsJL83b1NTKxsq4jjdVa3JmSyRvD9xF1
         RnX2rirhR25Dgr7FEnypClg7xMGDntxfYpUD/GxXMzgwqNZOy6iKTvhMi1xlKg9KG9g7
         Kn4A==
X-Gm-Message-State: AOAM531ar4uasFnFfHn6teiDF6Mshx8/u1Xe0BxZRcWEy9ELSOsH32aM
        y5u1je/ijzDvuDYVKlwbN99Q0HSxXcFZBrb9RpIW4g==
X-Google-Smtp-Source: ABdhPJxI0awZHJJMZLPw7vuRIZ4pTLpkqltJOm601Pm/vjIv7utwxxSqyT6Ujy155z6Adl8cxL0Be2gY3E6Jp1qBbt8=
X-Received: by 2002:a05:6e02:1888:: with SMTP id o8mr3508908ilu.154.1613006632917;
 Wed, 10 Feb 2021 17:23:52 -0800 (PST)
MIME-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com> <20210210230625.550939-9-seanjc@google.com>
In-Reply-To: <20210210230625.550939-9-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Feb 2021 17:23:42 -0800
Message-ID: <CANgfPd_Cqkr_NWt5X9BzopdfkC9m3-DTW0z7rgYgLAPuPXApUQ@mail.gmail.com>
Subject: Re: [PATCH 08/15] KVM: selftests: Use perf util's per-vCPU GPA/pages
 in demand paging test
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
> Grab the per-vCPU GPA and number of pages from perf_util in the demand
> paging test instead of duplicating perf_util's calculations.
>
> Note, this may or may not result in a functional change.  It's not clear
> that the test's calculations are guaranteed to yield the same value as
> perf_util, e.g. if guest_percpu_mem_size != vcpu_args->pages.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../selftests/kvm/demand_paging_test.c        | 20 +++++--------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 5f7a229c3af1..0cbf111e6c21 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -294,24 +294,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                 TEST_ASSERT(pipefds, "Unable to allocate memory for pipefd");
>
>                 for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> -                       vm_paddr_t vcpu_gpa;
> +                       struct perf_test_vcpu_args *vcpu_args;
>                         void *vcpu_hva;
> -                       uint64_t vcpu_mem_size;
>
> -
> -                       if (p->partition_vcpu_memory_access) {
> -                               vcpu_gpa = guest_test_phys_mem +
> -                                          (vcpu_id * guest_percpu_mem_size);
> -                               vcpu_mem_size = guest_percpu_mem_size;
> -                       } else {
> -                               vcpu_gpa = guest_test_phys_mem;
> -                               vcpu_mem_size = guest_percpu_mem_size * nr_vcpus;
> -                       }
> -                       PER_VCPU_DEBUG("Added VCPU %d with test mem gpa [%lx, %lx)\n",
> -                                      vcpu_id, vcpu_gpa, vcpu_gpa + vcpu_mem_size);
> +                       vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
>
>                         /* Cache the HVA pointer of the region */
> -                       vcpu_hva = addr_gpa2hva(vm, vcpu_gpa);
> +                       vcpu_hva = addr_gpa2hva(vm, vcpu_args->gpa);
>
>                         /*
>                          * Set up user fault fd to handle demand paging
> @@ -325,7 +314,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                                 &uffd_handler_threads[vcpu_id],
>                                                 pipefds[vcpu_id * 2],
>                                                 p->uffd_delay, &uffd_args[vcpu_id],
> -                                               vcpu_hva, vcpu_mem_size);
> +                                               vcpu_hva,
> +                                               vcpu_args->pages * perf_test_args.guest_page_size);
>                         if (r < 0)
>                                 exit(-r);
>                 }
> --
> 2.30.0.478.g8a0d178c01-goog
>
