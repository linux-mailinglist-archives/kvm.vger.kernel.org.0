Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A793E4E6748
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 17:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351886AbiCXQxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 12:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352076AbiCXQw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 12:52:58 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21161B2465
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 09:50:53 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id f38so9516118ybi.3
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 09:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GyEZyeXnbD1SpUVUdTOvI3aFbLpGuqC2Ad/hEjpjtOk=;
        b=s4w3SCbClDQbqQHEkH3T8tXGxP3WgwjpCNDoghGLeBaVPXupD6hoyj7i8LyTU+FpdN
         h8HWzRxuYvFDHORu/PPctH2oCH6EIo1upJk3Z1z4LBBkbXH6umej4Dpq18R3RLTXHy2i
         q79HAiDV+/HMUKnj+bkuAccvYjWUGHi89qJ6iFz6ubn/DmD0cDwgVEG/Edvy0ow4jJkT
         pHpb8QInNmTKy/A3QRn2T7PS0zltPEFqn09HXsXg/95KdZ3QjTeSs35pIIL6sANsgIvc
         jLcIW0t194pfKIpIVYUYhQAjHEV/2h1uZWcRV9lVc+4pWh1RXpUt5uaIO83EtJE5y3LC
         eL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GyEZyeXnbD1SpUVUdTOvI3aFbLpGuqC2Ad/hEjpjtOk=;
        b=ttU4R4QC3eyVBWrnO9YqNTeUeGLDFN7H1igyVPRGUKUyH00nzChHHlyl1KCAaTBy9l
         VCA2jtG+S2duNPuACbNrW9mi6aeX/0e7as52IpAa5RidWK6G/g4VQlugVq/fwB9V08mI
         iugrbd7iMklPergxMXhW5lBWiZ8GOF4Y6dcAQ6PfoqjEApssf+Eth3VeQT6T+wcOtmXF
         Raa+CDTZPTeEPZyl6QCXWWN1EdDDcqbVQH8ubIyWX59LPjEnlWgJGLta81jodSK+llzf
         CeJLDxIR9cQrkRpiQgGX+IAHkO3TTAsCXFHftQkGmWKCITcNBVUYmYc/03xqETu6CGCJ
         WRsA==
X-Gm-Message-State: AOAM531v0P0jDHAgUfTWwje4kZ42DylGBBwR7UExmPC9y9KJDb/4iZe7
        Mo6VZ/DLlYTvtqmq0yfF7EkqE860l7fpEbFcMyDk3g==
X-Google-Smtp-Source: ABdhPJyxW67Ff2D/09dcNpTUEyXuZtRmI1PtchCyeKUQRXxQdOh/GgzMauPBjn98vqo4IgG2nGvgGJL05ruEvKM5AME=
X-Received: by 2002:a25:780a:0:b0:633:ccea:3430 with SMTP id
 t10-20020a25780a000000b00633ccea3430mr5404425ybc.26.1648140652154; Thu, 24
 Mar 2022 09:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220323184915.1335049-1-mizhang@google.com> <20220323184915.1335049-6-mizhang@google.com>
In-Reply-To: <20220323184915.1335049-6-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 24 Mar 2022 09:50:41 -0700
Message-ID: <CANgfPd9MpnSonBzTF8EivXY_vazXFFAA83DPLoiZSgf=7vSrpw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] selftests: KVM: use dirty logging to check if page
 stats work correctly
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Mar 23, 2022 at 11:49 AM Mingwei Zhang <mizhang@google.com> wrote:
>
> When dirty logging is enabled, KVM will remap all accessed pages in
> NPT/EPT at 4K. This property could be used to check if
> the page stats metrics work properly in KVM mmu. At the same time, this
> logic might be used the other way around: using page stats to verify if
> dirty logging really splits all huge pages. Moreover, when dirty logging is
> disabled, KVM zaps corresponding SPTEs and we could check whether the large
> pages come back when guest touches the pages again.
>
> So add page stats checking in dirty logging performance selftest. In
> particular, add checks in three locations:
>  - just after vm is created;
>  - after populating memory into vm but before enabling dirty logging;
>  - finish dirty logging but before disabling it;
>  - behind the final iteration after disabling dirty logging.
>
> Tested using commands:
>  - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
>  - ./dirty_log_perf_test -s anonymous_hugetlb_2mb
>  - ./dirty_log_perf_test -s anonymous_thp
>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: Peter Xu <peterx@redhat.com>
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 53 +++++++++++++++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 1954b964d1cf..21431b0f5547 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -19,6 +19,10 @@
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
>
> +#ifdef __x86_64__
> +#include "processor.h"
> +#endif
> +
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N               2UL
>
> @@ -185,6 +189,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                  p->slots, p->backing_src,
>                                  p->partition_vcpu_memory_access);
>
> +#ifdef __x86_64__
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") == 0,
> +                   "4K page is non zero");
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") == 0,
> +                   "2M page is non zero");
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") == 0,
> +                   "1G page is non zero");
> +#endif
>         perf_test_set_wr_fract(vm, p->wr_fract);
>
>         guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
> @@ -222,6 +234,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         pr_info("Populate memory time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
>
> +#ifdef __x86_64__
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
> +                   "4K page is zero");
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
> +           p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB)
> +               TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
> +                           "2M page is zero");
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
> +               TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
> +                           "1G page is zero");
> +#endif
>         /* Enable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
>         enable_dirty_logging(vm, p->slots);
> @@ -267,6 +290,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                 iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
>                 }
>         }
> +#ifdef __x86_64__
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
> +                   "4K page is zero after dirty logging");
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") == 0,
> +                   "2M page is non-zero after dirty logging");
> +       TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") == 0,
> +                   "1G page is non-zero after dirty logging");
> +#endif
>
>         /* Disable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
> @@ -275,6 +306,28 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         pr_info("Disabling dirty logging time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
>
> +       /*
> +        * Increment iteration to run the vcpus again to ensure all pages come
> +        * back.
> +        */
> +       iteration++;
> +       pr_info("Starting the final iteration to get all pages back.\n");
> +       for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> +               while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id])
> +                      != iteration)
> +                       ;
> +       }
> +
> +#ifdef __x86_64__
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
> +           p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB)
> +               TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
> +                           "2M page is zero");
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
> +               TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
> +                           "1G page is zero");
> +#endif
> +
>         /* Tell the vcpu thread to quit */
>         host_quit = true;
>         perf_test_join_vcpu_threads(nr_vcpus);
> --
> 2.35.1.1021.g381101b075-goog
>
