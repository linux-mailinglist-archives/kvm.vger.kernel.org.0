Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AEA674765
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjASXsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjASXsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:48:30 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020C59F398
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:48:28 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qx13so9852775ejb.13
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ax52PxQcUB86ZZa5cNbU1WVgqIMXtwZG4WanvmA1AQo=;
        b=Vb/OkEE/qNrRPF8cKiSioV8riOPYqhZK/+DEPv+npXGYJWCfQVhh4j2qlnZxet7oA1
         H8tYHFUe+mbp4Of1ZX0bBbdWJmTIddghvIRQyh79x8prJKtGvoiRsaS52wfJhEdv1PTB
         LfyRDFy6jSK43ir7TgotFgorXG/h4ZEftH1Z51up8wmoCXAzKZje+Lpf4ijHk9Y6ZmwJ
         7niIuM1sjoDXr4NcCskw0344c+44Xv2IpVM4/8h/4b4KzJBwmQqjsczzbzo+sGBi9Dxb
         IkxTJc/H9O3n6CqrJE3wT5PhdY2osyV2De1oZ7rrofi6O6gGgD6ZBGJLUHFX0U5jLUzV
         mYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ax52PxQcUB86ZZa5cNbU1WVgqIMXtwZG4WanvmA1AQo=;
        b=ATDtXBHbCSIZII2vIJ7QRz6KRYgrokj3h6Zqr/vbGOeV2A4GGyIMwDDDkr743Dr6d4
         gaC11NUUoMH3eoR+28KdROwfjlLKaKoB9hTFdMbpzSLp1ulp9Wy+uviE1DzkCrQDQpir
         69cRHWWaOjL2SgYDLw7ZGZg9PPibOTom6JukA79OSKTnM2sxOMxkCY0ljFg8R7bVP18f
         WkhpbDNZnc3j4rCGzJgl88tY80T71EmS3Ji+UAnd/4iOBA5f91i1Ld8nFpuTWYdtSOaq
         ap0y2cjj7alR6ZB72GQE7aeCl4VLTLQqsvi2uRomCStkZNyug25EtYal58YDIQ+ugaUp
         V7tA==
X-Gm-Message-State: AFqh2koe0UtJxVOFjUyo0lwsCBZaTfcdFTRlGpx0MxbWeUGdQH0TiLJX
        AYH5yR4eeyqJj18kIjD5OhgWR6ivsj2KDohJeNs5Eg==
X-Google-Smtp-Source: AMrXdXuaNg3dS6YFkLOiuBolhweteL+t4YAHUHXynplY7DWeR1NVhegfDevq5PrXLZ8MZmSlafhwKphZZ8M+Wg2zSyo=
X-Received: by 2002:a17:906:3f91:b0:870:4648:e8a9 with SMTP id
 b17-20020a1709063f9100b008704648e8a9mr1131264ejj.433.1674172106131; Thu, 19
 Jan 2023 15:48:26 -0800 (PST)
MIME-Version: 1.0
References: <20230119212510.3938454-1-bgardon@google.com> <20230119212510.3938454-3-bgardon@google.com>
 <Y8nKerX9tDRHkFq+@google.com>
In-Reply-To: <Y8nKerX9tDRHkFq+@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 19 Jan 2023 15:48:14 -0800
Message-ID: <CANgfPd8B_0w39d7V+c4GnUxdqrc8qN78r8Pq0Con3Mx9WO0hkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Add page splitting test
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 2:56 PM David Matlack <dmatlack@google.com> wrote:
...
> > +static int NR_VCPUS = 2;
> > +static int NR_SLOTS = 2;
> > +static int NR_ITERATIONS = 2;
>
> These should be macros or at least const?

Yikes, woops, that was a basic mistake.

>
> > +static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> > +
> > +/* Host variables */
>
> What does "Host variables" mean? (And why is guest_percpu_mem_size not a
> "Host variable"?)
>
> I imagine this is copy-pasta from a test that has some global variables
> that are used by guest code? If that's correct, it's probably best to
> just drop this comment.

Yeah, shameful copypasta. I'll drop it.

>
> > +static u64 dirty_log_manual_caps;
...

> > +             /*
> > +              * Incrementing the iteration number will start the vCPUs
> > +              * dirtying memory again.
> > +              */
> > +             iteration++;
> > +
> > +             for (i = 0; i < NR_VCPUS; i++) {
> > +                     while (READ_ONCE(vcpu_last_completed_iteration[i])
> > +                            != iteration)
> > +                             ;
> > +             }
> > +
> > +             pr_debug("\nGetting stats after dirtying memory on pass %d:\n", iteration);
> > +             get_page_stats(vm, &stats_dirty_pass[iteration - 1]);
>
> Incrementing iteration, waiting for vCPUs, and grabbing stats is
> repeated below. Throw it in a helper function?

Good call.

>
> > +
> > +             memstress_get_dirty_log(vm, bitmaps, NR_SLOTS);
> > +
> > +             if (dirty_log_manual_caps) {
> > +                     memstress_clear_dirty_log(vm, bitmaps, NR_SLOTS, pages_per_slot);
> > +
> > +                     pr_debug("\nGetting stats after clearing dirty log pass %d:\n", iteration);
> > +                     get_page_stats(vm, &stats_clear_pass[iteration - 1]);
> > +             }
> > +     }
> > +
> > +     /* Disable dirty logging */
> > +     memstress_disable_dirty_logging(vm, NR_SLOTS);
> > +
> > +     pr_debug("\nGetting stats after disabling dirty logging:\n");
> > +     get_page_stats(vm, &stats_dirty_logging_disabled);
> > +
> > +     /* Run vCPUs again to fault pages back in. */
> > +     iteration++;
> > +     for (i = 0; i < NR_VCPUS; i++) {
> > +             while (READ_ONCE(vcpu_last_completed_iteration[i]) != iteration)
> > +                     ;
> > +     }
> > +
> > +     pr_debug("\nGetting stats after repopulating memory:\n");
> > +     get_page_stats(vm, &stats_repopulated);
> > +
> > +     /*
> > +      * Tell the vCPU threads to quit.  No need to manually check that vCPUs
> > +      * have stopped running after disabling dirty logging, the join will
> > +      * wait for them to exit.
> > +      */
> > +     host_quit = true;
> > +     memstress_join_vcpu_threads(NR_VCPUS);
> > +
> > +     memstress_free_bitmaps(bitmaps, NR_SLOTS);
> > +     memstress_destroy_vm(vm);
> > +
> > +     /* Make assertions about the page counts. */
> > +     total_4k_pages = stats_populated.pages_4k;
> > +     total_4k_pages += stats_populated.pages_2m * 512;
> > +     total_4k_pages += stats_populated.pages_1g * 512 * 512;
> > +
> > +     /*
> > +      * Check that all huge pages were split. Since large pages can only
> > +      * exist in the data slot, and the vCPUs should have dirtied all pages
> > +      * in the data slot, there should be no huge pages left after splitting.
> > +      * Splitting happens at dirty log enable time without
> > +      * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 and after the first clear pass
> > +      * with that capability.
> > +      */
> > +     if (dirty_log_manual_caps) {
> > +             TEST_ASSERT(stats_clear_pass[0].hugepages == 0,
>
> Consider using ASSERT_EQ() to simplify these checks. It will
> automatically print out the values for you, but you'll lose the
> contextual error message ("Unexpected huge page count after
> splitting..."). But maybe we could add support for a custom extra error
> string?
>
> __ASSERT_EQ(stats_clear_pass[0].hugepages, 0,
>             "Expected 0 hugepages after splitting");
>
> Or use a comment to document the context for the assertion. Whoever is
> debugging a failure is going to come look at the selftest code no matter
> what.
>
> I think I prefer ASSERT_EQ() + comment, especially since the comment
> pretty much already exists above.

That's fair. I prefer the way it is because the resulting error
message is a lot easier to read and I don't need to look at the test
code to decrypt it. If I'm developing a feature and just running all
tests, it's nice to not have to track down the test source code.

>
> > +                         "Unexpected huge page count after splitting. Expected 0, got %ld",
> > +                         stats_clear_pass[0].hugepages);
> > +             TEST_ASSERT(stats_clear_pass[0].pages_4k == total_4k_pages,
> > +                         "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
> > +                         total_4k_pages, stats_clear_pass[0].pages_4k);
>
> Also assert that huge pages are *not* split when dirty logging is first
> enabled.

Ah great idea. I felt like I was a little light on the assertions.
That'll be a good addition.

>
> > +     } else {
...
> > +
> > +     dirty_log_manual_caps =
> > +             kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> > +     dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> > +                               KVM_DIRTY_LOG_INITIALLY_SET);
>
> Since this is a correctness test I think the test should, by default,
> test both KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE and 0, to ensure we get
> test coverage of both.
>
> And with that in place, there's probably no need for the -g flag.

Good idea.

>
> > +
> > +     guest_modes_append_default();
...
> > +
> > +     if (!is_backing_src_hugetlb(p.backing_src)) {
> > +             pr_info("This test will only work reliably with HugeTLB memory. "
> > +                     "It can work with THP, but that is best effort.");
> > +             return KSFT_SKIP;
> > +     }
>
> backing_src only controls the memstress data slots. The rest of guest
> memory could be a source of noise for this test.

That's true, but we compensate for that noise by taking a measurement
after the population pass. At that point the guest has executed all
it's code (or at least from all it's code pages) and touched every
page in the data slot. Since the other slots aren't backed with huge
pages, NX hugepages shouldn't be an issue. As a result, I would be
surprised if noise from the other memory became a problem.

>
> > +
> > +     run_test(&p);
>
> Use for_each_guest_mode() to run against all supported guest modes.

I'm not sure that would actually improve coverage. None of the page
splitting behavior depends on the mode AFAICT.

>
> > +
> > +     return 0;
> > +}
> > --
> > 2.39.1.405.gd4c25cc71f-goog
> >
