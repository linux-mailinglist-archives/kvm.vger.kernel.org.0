Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB01D5E80B8
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 19:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiIWRa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 13:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiIWRaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 13:30:55 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F0F11D622
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 10:30:54 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d24so803590pls.4
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=qJzYbdxPdJBy5B98drjTcwheVcMT+0xQr/y75AAFgfc=;
        b=dGH1rmBrr1J53tjugVy7eMH1y9HvMdTH+3b9zE8Azi+Wy7JPxUGfucHzlSCCC9qhLQ
         XK++zdS/2t9YXDcSyj7ScAuv5DjbtN/EE+f1OCFtmXmb7pt72wjWF/Vd3W7uyNSZF8hA
         gALtbqiRicqF7OLPwUmxdQPY1ZdZlXMGDT+QreTeD/jfA0pp1EQKaKEFyqmsElgwKDuU
         U1eSBg5Wz8z2R8BMpjWrJGf2Orib48JzRxDwwnQNP51WLyRP0OfqIaL6kHJo9xIJ+c0A
         8aeAZsF6z0h5L7A/KD17yE6o6IXOgpBjTSKiJOkBkwRjvwrIhxiMJXvG0w+SY86NOKPl
         hSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qJzYbdxPdJBy5B98drjTcwheVcMT+0xQr/y75AAFgfc=;
        b=Kf23UWHuHeiHpiQtAyoMAfin//10t+j5eDyfH1N/Q7aIM5AgzLKHcUHa/qDKAzxkvW
         ZGlfuQvk3ntn8MbhMVyfC6wr4jYxGMAWtSXxXNFbY+RsvruMeq6JejKRZNPaolyS4glX
         FUCcrkpk1yVpgfpabg5bswijOvZ3uF7PSEmsneLe9igrUfXXHMfXcFBwfeHj5JjZUBva
         6Flq83NqsNgQQaF6M05GryFVhjNli8/vUEMPSb+tJb1G1R/Z+8z00J0ct+d912K5p+8r
         gB0lN/ZqfmrzPemjrlXTRXk1IS+ew/5VYpU53DCKxkOD1xDFR1C2x7sN/OnB2UlxbZpp
         NS1g==
X-Gm-Message-State: ACrzQf3HcFnV6EKT8cPoO2E2kfib8FwW5/If6N8jtX7mQQfW+EJOdM5Y
        CkfwOxFNZZdjlC8k0P7KrOnXBA==
X-Google-Smtp-Source: AMsMyM4yMG0aUAQYYE3WiNN49UeE4wHdNnBqe4Sgqy0H2AElF18HXVehoGmUOSrchVmu0cj2HY89vw==
X-Received: by 2002:a17:902:e850:b0:178:64f:a57d with SMTP id t16-20020a170902e85000b00178064fa57dmr9859821plg.110.1663954254078;
        Fri, 23 Sep 2022 10:30:54 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090a284e00b001fd9c63e56bsm1824291pjf.32.2022.09.23.10.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 10:30:53 -0700 (PDT)
Date:   Fri, 23 Sep 2022 10:30:48 -0700
From:   David Matlack <dmatlack@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        Sean Christopherson <seanjc@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: Re: The root cause of failure of access_tracking_perf_test in a
 nested guest
Message-ID: <Yy3tSAMesFzEhAKe@google.com>
References: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50dfe81bf95db91e6148b421740490c35c33233e.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 01:16:04PM +0300, Maxim Levitsky wrote:
> Hi!
> 
> Me and Emanuele Giuseppe Esposito were working on trying to understand why the access_tracking_perf_test
> fails when run in a nested guest on Intel, and I finally was able to find the root casue.
> 
> So the access_tracking_perf_test tests the following:
> 
> - It opens /sys/kernel/mm/page_idle/bitmap which is a special root read/writiable
> file which allows a process to set/clear the accessed bit in its page tables.
> the interface of this file is inverted, it is a bitmap of 'idle' bits
> Idle bit set === dirty bit is clear.
> 
> - It then runs a KVM guest, and checks that when the guest accesses its memory
> (through EPT/NPT), the accessed bits are still updated normally as seen from /sys/kernel/mm/page_idle/bitmap.
> 
> In particular it first clears the accesssed bit using /sys/kernel/mm/page_idle/bitmap,
> and then runs a guest which reads/writes all its memory, and then
> it checks that the accessed bit is set again by reading the /sys/kernel/mm/page_idle/bitmap.
> 
> 
> 
> Now since KVM uses its own paging (aka secondary MMU), mmu notifiers are used, and in particular
> - kvm_mmu_notifier_clear_flush_young
> - kvm_mmu_notifier_clear_young
> - kvm_mmu_notifier_test_young
> 
> First two clear the accessed bit from NPT/EPT, and the 3rd only checks its value.
> 
> The difference between the first two notifiers is that the first one flushes EPT/NPT,
> and the second one doesn't, and apparently the /sys/kernel/mm/page_idle/bitmap uses the second one.
> 
> This means that on the bare metal, the tlb might still have the accessed bit set, and thus
> it might not set it again in the PTE when a memory access is done through it.
> 
> There is a comment in kvm_mmu_notifier_clear_young about this inaccuracy, so this seems to be
> done on purpose.
> 
> I would like to hear your opinion on why it was done this way, and if the original reasons for
> not doing the tlb flush are still valid.
> 
> Now why the access_tracking_perf_test fails in a nested guest?
> It is because kvm shadow paging which is used to shadow the nested EPT, and it has a "TLB" which
> is not bounded by size, because it is stored in the unsync sptes in memory.
> 
> Because of this, when the guest clears the accessed bit in its nested EPT entries, KVM doesn't
> notice/intercept it and corresponding EPT sptes remain the same, thus later the guest access to
> the memory is not intercepted and because of this doesn't turn back
> the accessed bit in the guest EPT tables.
> 
> (If TLB flush were to happen, we would 'sync' the unsync sptes, by zapping them because we don't
> keep sptes for gptes with no accessed bit)
> 
> 
> Any comments are welcome!
> 
> If you think that the lack of the EPT flush is still the right thing to do,
> I vote again to have at least some form of a blacklist of selftests which
> are expected to fail, when run under KVM (fix_hypercall_test is the other test
> I already know that fails in a KVM guest, also without a practical way to fix it).

Nice find. I don't recommend changing page_idle just for this test.

I added this test to evaluate the performance of KVM's access tracking
faulting handling, e.g. for when eptad=N. page_idle just happens to be
the only userspace mechanism available today to exercise access
tracking. But it has serious downsides as you discovered and are
documented at the top of the test:

/*
 ...
 * Note that a deterministic correctness test of access tracking is not possible
 * by using page_idle as it exists today. This is for a few reasons:
 *
 * 1. page_idle only issues clear_young notifiers, which lack a TLB flush. This
 *    means subsequent guest accesses are not guaranteed to see page table
 *    updates made by KVM until some time in the future.
 *
 * 2. page_idle only operates on LRU pages. Newly allocated pages are not
 *    immediately allocated to LRU lists. Instead they are held in a "pagevec",
 *    which is drained to LRU lists some time in the future. There is no
 *    userspace API to force this drain to occur.
 *
 * These limitations are worked around in this test by using a large enough
 * region of memory for each vCPU such that the number of translations cached in
 * the TLB and the number of pages held in pagevecs are a small fraction of the
 * overall workload. And if either of those conditions are not true this test
 * will fail rather than silently passing.
 ...
 */

When I wrote the test, I did not realize that nested effectively has an
unlimited TLB since shadow pages can just be left unsync. So the comment
above does not hold for nested.

My recommendation to move forward would be to get rid of this
TEST_ASSERT():

	TEST_ASSERT(still_idle < pages / 10,
		    "vCPU%d: Too many pages still idle (%"PRIu64 " out of %"
		    PRIu64 ").\n",
		    vcpu_idx, still_idle, pages);

And instead just print a warning message to tell the user that memory is
not being marked idle, and that will affect the performance results (not
as many access will actually go through access tracking). This will stop
the test from failing.

Long term, it would be great to switch to a more deterministic userspace
mechanism to trigger access tracking. My understanding is the new
multi-gen LRU that is slated for 6.1 or 6.2 might provide a better
option.
