Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1FD4E3837
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 06:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbiCVFLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 01:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbiCVFLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 01:11:20 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB9EE03F
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 22:09:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mm17-20020a17090b359100b001c6da62a559so1435914pjb.3
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 22:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fDXhm+RK1m7fZKaYwZIMM/iMGbp4yJhf9o4ZO9CuiVk=;
        b=SA+0u2ZCsN1JRGN+8G3kO6l6TsM2azbqy9m2SrLcGM+Z3VRCD65kSn/GyWoixd9pAA
         wLPESxr9lCruhs2fYkKM8ahUnKh9yCJBvcaXUCuc+f38QprYFpn5xH1jGBhQE18/5qKP
         zYqccsV/8DYrOY3lDgspa3+jJvZ37bjR9GiOifgvy3mABx9ul1NY3It3sBKaLxN4+3yW
         bO52D1xVn3L/OQooNi/Vjp2pczt98WXXblCqrC+pCjP7Sfkp+mFeYydCzLvKzsox1KuC
         VV8G4JPpO+/AZxkMUfj3YlVYrn8RMQu10Ej+Gpj1ruCt3SwQMSoFeieSkqL7E6EnmCxV
         lwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fDXhm+RK1m7fZKaYwZIMM/iMGbp4yJhf9o4ZO9CuiVk=;
        b=x3n0qRJvW8P6ZyEDdK+Q1ygDeed18PSJlaGayB2CngVzNi5IYWCAYYh6PwfCM45oIw
         jrCOPoLOHGQ5QWTim267gFfGvui0kh7zH/bdOjfAGfHoPccWDv3qtKUWxfpK7HdGL1Uy
         1rgH7b2YzD8OO680jrNF+hptaQtSL9B1biA0tSJLzrJEGVaITcU32GEUPNfSaotWybmx
         ssJAXvnyxr5T2JmEtzOXojXO6oRmes1Ev2Mq3NXusd5ijTUhO9m7cwx3PUzuGqDcALu0
         RzcWOAAZxsRXr2+UXmgtKUfO0jnuQ9pNMt5gK79a+K/xhEc8TgaPP78Gq6x7zeKAP0Ks
         1OHA==
X-Gm-Message-State: AOAM530hhasmbx3GYe2IYsSoNq++xvRa5AjulXmBgKd1g5/tM+6Mey2T
        8HlGU82M0LyQ1speY1buPxNYyg==
X-Google-Smtp-Source: ABdhPJyWOul9rH4gEUGO0dkMiJm3kpCidirNUAvNTHdQPi0DS1qZINZVbIPMvc7iQ0an04fRSqSGBw==
X-Received: by 2002:a17:90a:a390:b0:1c6:ed76:f555 with SMTP id x16-20020a17090aa39000b001c6ed76f555mr2883292pjp.65.1647925793030;
        Mon, 21 Mar 2022 22:09:53 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b004f140515d56sm21081801pfh.46.2022.03.21.22.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 22:09:52 -0700 (PDT)
Date:   Tue, 22 Mar 2022 05:09:48 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 4/4] selftests: KVM: use dirty logging to check if page
 stats work correctly
Message-ID: <YjlaHLUcvb3ZPgS1@google.com>
References: <20220321002638.379672-1-mizhang@google.com>
 <20220321002638.379672-5-mizhang@google.com>
 <CANgfPd8feg_4vhNJqhFViDaMfvp_C4PdtEGMGOJ-Z8smQuf3rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8feg_4vhNJqhFViDaMfvp_C4PdtEGMGOJ-Z8smQuf3rQ@mail.gmail.com>
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

On Mon, Mar 21, 2022, Ben Gardon wrote:
> On Sun, Mar 20, 2022 at 5:26 PM Mingwei Zhang <mizhang@google.com> wrote:
> >
> > When dirty logging is enabled, KVM splits the all hugepage mapping in
> > NPT/EPT into the smallest 4K size. This property could be used to check if
> > the page stats metrics work properly in KVM mmu. At the same time, this
> > logic might be used the other way around: using page stats to verify if
> > dirty logging really splits all huge pages. Moreover, when dirty logging is
> > disabled, KVM zaps corresponding SPTEs and we could check whether the large
> > pages come back when guest touches the pages again.
> >
> > So add page stats checking in dirty logging performance selftest. In
> > particular, add checks in three locations:
> >  - just after vm is created;
> >  - after populating memory into vm but before enabling dirty logging;
> >  - just after turning on dirty logging.
> >  - after one final iteration after turning off dirty logging.
> >
> > Tested using commands:
> >  - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
> >  - ./dirty_log_perf_test -s anonymous_thp
> >
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: David Matlack <dmatlack@google.com>
> > Cc: Jing Zhang <jingzhangos@google.com>
> > Cc: Peter Xu <peterx@redhat.com>
> >
> > Suggested-by: Ben Gardon <bgorden@google.com>
> 
> Woops, got a mail bounce from this. Should be:
> Suggested-by: Ben Gardon <bgardon@google.com>
> 

Oh... sorry about that. Will discuss with you offline. Really want to
avoid this in the future.

> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  .../selftests/kvm/dirty_log_perf_test.c       | 52 +++++++++++++++++++
> >  1 file changed, 52 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > index 1954b964d1cf..ab0457d91658 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > @@ -19,6 +19,10 @@
> >  #include "perf_test_util.h"
> >  #include "guest_modes.h"
> >
> > +#ifdef __x86_64__
> > +#include "processor.h"
> > +#endif
> > +
> >  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
> >  #define TEST_HOST_LOOP_N               2UL
> >
> > @@ -185,6 +189,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >                                  p->slots, p->backing_src,
> >                                  p->partition_vcpu_memory_access);
> >
> > +#ifdef __x86_64__
> > +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") == 0,
> > +                   "4K page is non zero");
> > +       TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") == 0,
> > +                   "2M page is non zero");
> > +       TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") == 0,
> > +                   "1G page is non zero");
> > +#endif
> >         perf_test_set_wr_fract(vm, p->wr_fract);
> >
> >         guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
> > @@ -222,6 +234,16 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         pr_info("Populate memory time: %ld.%.9lds\n",
> >                 ts_diff.tv_sec, ts_diff.tv_nsec);
> >
> > +#ifdef __x86_64__
> > +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
> > +                   "4K page is zero");
> > +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
> > +               TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
> > +                           "2M page is zero");
> > +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
> > +               TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
> > +                           "1G page is zero");
> > +#endif
> >         /* Enable dirty logging */
> >         clock_gettime(CLOCK_MONOTONIC, &start);
> >         enable_dirty_logging(vm, p->slots);
> > @@ -267,6 +289,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >                                 iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
> >                 }
> >         }
> > +#ifdef __x86_64__
> > +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
> > +                   "4K page is zero after dirty logging");
> > +       TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") == 0,
> > +                   "2M page is non-zero after dirty logging");
> > +       TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") == 0,
> > +                   "1G page is non-zero after dirty logging");
> > +#endif
> >
> >         /* Disable dirty logging */
> >         clock_gettime(CLOCK_MONOTONIC, &start);
> > @@ -275,6 +305,28 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >         pr_info("Disabling dirty logging time: %ld.%.9lds\n",
> >                 ts_diff.tv_sec, ts_diff.tv_nsec);
> >
> > +#ifdef __x86_64__
> > +       /*
> > +        * Increment iteration to run the vcpus again to verify if huge pages
> > +        * come back.
> > +        */
> > +       iteration++;
> > +       pr_info("Starting the final iteration to verify page stats\n");
> > +
> > +       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> > +               while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id])
> > +                      != iteration)
> > +                       ;
> > +       }
> > +
> > +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
> > +               TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
> > +                           "2M page is zero");
> > +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
> > +               TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
> > +                           "1G page is zero");
> > +#endif
> > +
> >         /* Tell the vcpu thread to quit */
> >         host_quit = true;
> >         perf_test_join_vcpu_threads(nr_vcpus);
> > --
> > 2.35.1.894.gb6a874cedc-goog
> >
