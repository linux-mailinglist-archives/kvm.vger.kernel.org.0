Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EA2675700
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 15:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjATOYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 09:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjATOY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 09:24:28 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D62402FC
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 06:23:46 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id lp10so2326198pjb.4
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 06:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0L8qehXkyT8nN8i5Xw4I2Rk4pvQxtLnVbkupn2WJizI=;
        b=Bj7O3fFykT7hjFU8cn6pteJKv/QWzIGptG1gqQ84QyCZmi7SRzmUpqFyYkD9IHKpg/
         k37IjF4Vz3VfMxyjvO0/N33c3woIdBHPIpcJxoz9Xr2Gs2mpJK8buOpWSzWgvTbTAYq+
         +HqkLpUEkoOAehC5tTUD1aiITqjFp1yQ3E5mFw9DfTRvVbBIwKHQ6nXiMBUJNpNfeT0S
         HrYrr77jFIOtPd6CeWjXvnWvRZA0TPDs7AceSY+4Qa0HqzDw7vfoJKdRpU1SEk5rqlNI
         dLflYDcMjfEBIWg2uN3AqPha20uY8azXlxlYUXfODvKk3hFmCN+xtIiJOJB2O0kNVq5g
         8uPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0L8qehXkyT8nN8i5Xw4I2Rk4pvQxtLnVbkupn2WJizI=;
        b=4yyLxzZRE7HSOO/SB5rZIVbdKQPOK4ZM6mWw9MVlGO08vSsUilDc32FlRu3gtGXaa0
         golox9Hax783t2zXnDJ6dcjUs4pjSQMRlT1iVFCi9RmjO09jf+HfQ8g8MoC/4QvFFPRA
         IKdZxjaIgpyrWaQXHPnRBsnWu1laLBfXrZgzXqk+qGwWA5Ll5kPg+ABVr3XbVdC37Ilk
         X3Rop/c5cCePmL4eo1wjfzNpS1yxdNy9OVLTOkuLReTqWEP1IRNyLyoLBt8vi6+MyADs
         WC18ETD3EMbRJWLkQ9SU/E91ViL9TdKb2JvgaqQ8ClQ75bngD1EUKYiKQKI5mHbxbG1+
         35lQ==
X-Gm-Message-State: AFqh2kpmXN3zsXHhlG1jvtoZNwvf08G1yFigs7IR0jX/TiKhAjX9yY+9
        INRK72++b4XmJE+/uyNP8zvlTw==
X-Google-Smtp-Source: AMrXdXvGFRyhYXIkSECHfeqD3kNj/lc6tJ/x31jDVe2p/KpejjlZNnSvjOrVK3G/3c+LckOfWlN6DQ==
X-Received: by 2002:a05:6a21:9214:b0:b8:c3c0:e7f7 with SMTP id tl20-20020a056a21921400b000b8c3c0e7f7mr199960pzb.1.1674224601394;
        Fri, 20 Jan 2023 06:23:21 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709027fcc00b00186748fe6ccsm12559850plb.214.2023.01.20.06.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 06:23:20 -0800 (PST)
Date:   Fri, 20 Jan 2023 06:23:17 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Add page splitting test
Message-ID: <Y8qj1QS1VadgaX7A@google.com>
References: <20230119212510.3938454-1-bgardon@google.com>
 <20230119212510.3938454-3-bgardon@google.com>
 <Y8nKerX9tDRHkFq+@google.com>
 <CANgfPd8B_0w39d7V+c4GnUxdqrc8qN78r8Pq0Con3Mx9WO0hkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8B_0w39d7V+c4GnUxdqrc8qN78r8Pq0Con3Mx9WO0hkQ@mail.gmail.com>
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

On Thu, Jan 19, 2023 at 03:48:14PM -0800, Ben Gardon wrote:
> On Thu, Jan 19, 2023 at 2:56 PM David Matlack <dmatlack@google.com> wrote:
> ...
> > > +static int NR_VCPUS = 2;
> > > +static int NR_SLOTS = 2;
> > > +static int NR_ITERATIONS = 2;
> >
> > These should be macros or at least const?
> 
> Yikes, woops, that was a basic mistake.
> 
> >
> > > +static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> > > +
> > > +/* Host variables */
> >
> > What does "Host variables" mean? (And why is guest_percpu_mem_size not a
> > "Host variable"?)
> >
> > I imagine this is copy-pasta from a test that has some global variables
> > that are used by guest code? If that's correct, it's probably best to
> > just drop this comment.
> 
> Yeah, shameful copypasta. I'll drop it.
> 
> >
> > > +static u64 dirty_log_manual_caps;
> ...
> 
> > > +             /*
> > > +              * Incrementing the iteration number will start the vCPUs
> > > +              * dirtying memory again.
> > > +              */
> > > +             iteration++;
> > > +
> > > +             for (i = 0; i < NR_VCPUS; i++) {
> > > +                     while (READ_ONCE(vcpu_last_completed_iteration[i])
> > > +                            != iteration)
> > > +                             ;
> > > +             }
> > > +
> > > +             pr_debug("\nGetting stats after dirtying memory on pass %d:\n", iteration);
> > > +             get_page_stats(vm, &stats_dirty_pass[iteration - 1]);
> >
> > Incrementing iteration, waiting for vCPUs, and grabbing stats is
> > repeated below. Throw it in a helper function?
> 
> Good call.
> 
> >
> > > +
> > > +             memstress_get_dirty_log(vm, bitmaps, NR_SLOTS);
> > > +
> > > +             if (dirty_log_manual_caps) {
> > > +                     memstress_clear_dirty_log(vm, bitmaps, NR_SLOTS, pages_per_slot);
> > > +
> > > +                     pr_debug("\nGetting stats after clearing dirty log pass %d:\n", iteration);
> > > +                     get_page_stats(vm, &stats_clear_pass[iteration - 1]);
> > > +             }
> > > +     }
> > > +
> > > +     /* Disable dirty logging */
> > > +     memstress_disable_dirty_logging(vm, NR_SLOTS);
> > > +
> > > +     pr_debug("\nGetting stats after disabling dirty logging:\n");
> > > +     get_page_stats(vm, &stats_dirty_logging_disabled);
> > > +
> > > +     /* Run vCPUs again to fault pages back in. */
> > > +     iteration++;
> > > +     for (i = 0; i < NR_VCPUS; i++) {
> > > +             while (READ_ONCE(vcpu_last_completed_iteration[i]) != iteration)
> > > +                     ;
> > > +     }
> > > +
> > > +     pr_debug("\nGetting stats after repopulating memory:\n");
> > > +     get_page_stats(vm, &stats_repopulated);
> > > +
> > > +     /*
> > > +      * Tell the vCPU threads to quit.  No need to manually check that vCPUs
> > > +      * have stopped running after disabling dirty logging, the join will
> > > +      * wait for them to exit.
> > > +      */
> > > +     host_quit = true;
> > > +     memstress_join_vcpu_threads(NR_VCPUS);
> > > +
> > > +     memstress_free_bitmaps(bitmaps, NR_SLOTS);
> > > +     memstress_destroy_vm(vm);
> > > +
> > > +     /* Make assertions about the page counts. */
> > > +     total_4k_pages = stats_populated.pages_4k;
> > > +     total_4k_pages += stats_populated.pages_2m * 512;
> > > +     total_4k_pages += stats_populated.pages_1g * 512 * 512;
> > > +
> > > +     /*
> > > +      * Check that all huge pages were split. Since large pages can only
> > > +      * exist in the data slot, and the vCPUs should have dirtied all pages
> > > +      * in the data slot, there should be no huge pages left after splitting.
> > > +      * Splitting happens at dirty log enable time without
> > > +      * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 and after the first clear pass
> > > +      * with that capability.
> > > +      */
> > > +     if (dirty_log_manual_caps) {
> > > +             TEST_ASSERT(stats_clear_pass[0].hugepages == 0,
> >
> > Consider using ASSERT_EQ() to simplify these checks. It will
> > automatically print out the values for you, but you'll lose the
> > contextual error message ("Unexpected huge page count after
> > splitting..."). But maybe we could add support for a custom extra error
> > string?
> >
> > __ASSERT_EQ(stats_clear_pass[0].hugepages, 0,
> >             "Expected 0 hugepages after splitting");
> >
> > Or use a comment to document the context for the assertion. Whoever is
> > debugging a failure is going to come look at the selftest code no matter
> > what.
> >
> > I think I prefer ASSERT_EQ() + comment, especially since the comment
> > pretty much already exists above.
> 
> That's fair. I prefer the way it is because the resulting error
> message is a lot easier to read and I don't need to look at the test
> code to decrypt it. If I'm developing a feature and just running all
> tests, it's nice to not have to track down the test source code.
> 
> >
> > > +                         "Unexpected huge page count after splitting. Expected 0, got %ld",
> > > +                         stats_clear_pass[0].hugepages);
> > > +             TEST_ASSERT(stats_clear_pass[0].pages_4k == total_4k_pages,
> > > +                         "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
> > > +                         total_4k_pages, stats_clear_pass[0].pages_4k);
> >
> > Also assert that huge pages are *not* split when dirty logging is first
> > enabled.
> 
> Ah great idea. I felt like I was a little light on the assertions.
> That'll be a good addition.
> 
> >
> > > +     } else {
> ...
> > > +
> > > +     dirty_log_manual_caps =
> > > +             kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> > > +     dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> > > +                               KVM_DIRTY_LOG_INITIALLY_SET);
> >
> > Since this is a correctness test I think the test should, by default,
> > test both KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE and 0, to ensure we get
> > test coverage of both.
> >
> > And with that in place, there's probably no need for the -g flag.
> 
> Good idea.
> 
> >
> > > +
> > > +     guest_modes_append_default();
> ...
> > > +
> > > +     if (!is_backing_src_hugetlb(p.backing_src)) {
> > > +             pr_info("This test will only work reliably with HugeTLB memory. "
> > > +                     "It can work with THP, but that is best effort.");
> > > +             return KSFT_SKIP;
> > > +     }
> >
> > backing_src only controls the memstress data slots. The rest of guest
> > memory could be a source of noise for this test.
> 
> That's true, but we compensate for that noise by taking a measurement
> after the population pass. At that point the guest has executed all
> it's code (or at least from all it's code pages) and touched every
> page in the data slot. Since the other slots aren't backed with huge
> pages, NX hugepages shouldn't be an issue. As a result, I would be
> surprised if noise from the other memory became a problem.
> 
> >
> > > +
> > > +     run_test(&p);
> >
> > Use for_each_guest_mode() to run against all supported guest modes.
> 
> I'm not sure that would actually improve coverage. None of the page
> splitting behavior depends on the mode AFAICT.

You need to use for_each_guest_mode() for the ARM case. The issue is
that whatever mode (guest page size and VA size) you pick might not be
supported by the host. So, you first to explore what's available (via
for_each_guest_mode()).

Thanks,
Ricardo

> 
> >
> > > +
> > > +     return 0;
> > > +}
> > > --
> > > 2.39.1.405.gd4c25cc71f-goog
> > >
