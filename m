Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559A55B272E
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 21:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIHTxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 15:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiIHTxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 15:53:20 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC137F9F80
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 12:53:16 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id bn9so21218866ljb.6
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 12:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PoHjEjrTxZtalJVDnjuVZgtzbR9wI2R3rgk4GhCQWaA=;
        b=hAFkYy1Ndo326SUMEYYUtUjenDAUBE6PaJzRJB1ZnO8QeUbVBoY/v9BZ4395P76FiO
         hIhAkj8gyBmNGT5p9/HCJW4FUv1hAIdS7QKM8f8zbEgon74NAmaeg6NLwxXLdct1FjXH
         LdZTGjzFW/YXlRelMhvzAkVa77polf6txrqtiweBnGkZyM4BPLbVLVJHkAzjM4cKcDuV
         q/sSmVd14C8+li+FJibK6qQwvUrDxIyq0da3qc0CKi7eUjGGfJyxnaLYq8MRp2UgaZ7r
         q+rO1uLojp8fp1trPGsEG69AAjtKDbSQhWXc1SxZkh2oFhldV1mdKWxqSfpyndkfLWot
         eodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PoHjEjrTxZtalJVDnjuVZgtzbR9wI2R3rgk4GhCQWaA=;
        b=Vr1d1SPJPrEUsHB055JVXqjiNfEgGNbzulK+pHxyn0nzHbyHPP0oWLourKf8DS6fg6
         c+saevmXY59I1fY+jjxl/bsi/8mgBfz+fN506zKZUPYZxY7iHPnDYmnrdpZFCIz8ihJi
         vQ11/JeBrrfes8jxxlIO3+K2kN7y8aLVetYDwliX52dicgrCte8rZhjceonKqckDZ4X3
         F6nE22jPv4iTpC5lTfwumHwJ2Jb4G3p8CJe3AslIHlfe+memWlUruZ+B3LXeB9QqU3eS
         H2YsZf4lUh1ufmi5q+kvlakXIkLIsHXoY5ltsJdxayD1FSgEU8v3OLNmF+0krR77HqJM
         s9Qg==
X-Gm-Message-State: ACgBeo0W/XYgJrw1Thy9vCKi/6abNoapv8koEXXuwdd+iz4ToCRlVLPo
        K9SnWLou5pkgVIsZKUuG4zHh2rjjVDqS/G4sfC7kcA==
X-Google-Smtp-Source: AA6agR6UNPotEkCw9z6c6lBKfcAvtpFOwoPjC9G+rg4C5XpaFl4bf8UXGuLVN18QWm2+C5pv9r18LIvqPyOVyTUjijE=
X-Received: by 2002:a2e:a884:0:b0:25d:ea06:6a3f with SMTP id
 m4-20020a2ea884000000b0025dea066a3fmr2851688ljq.335.1662666794915; Thu, 08
 Sep 2022 12:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <Yxo5lFuCRgbn+svL@google.com> <gsntmtb9ps2j.fsf@coltonlewis-kvm.c.googlers.com>
In-Reply-To: <gsntmtb9ps2j.fsf@coltonlewis-kvm.c.googlers.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 8 Sep 2022 12:52:47 -0700
Message-ID: <CALzav=dzNe6p=MATC_UPX3J7Q=kdUkV1YzEUmb3s9qh9n1WMxA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: selftests: Randomize which pages are written
 vs read.
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

On Thu, Sep 8, 2022 at 12:46 PM Colton Lewis <coltonlewis@google.com> wrote:
>
> David Matlack <dmatlack@google.com> writes:
>
> > On Tue, Aug 30, 2022 at 07:02:10PM +0000, Colton Lewis wrote:
> >> David Matlack <dmatlack@google.com> writes:
>
> >> > On Wed, Aug 17, 2022 at 09:41:45PM +0000, Colton Lewis wrote:
> >> > > Randomize which tables are written vs read using the random number
> >> > > arrays. Change the variable wr_fract and associated function calls to
> >> > > write_percent that now operates as a percentage from 0 to 100 where X
> >> > > means each page has an X% chance of being written. Change the -f
> >> > > argument to -w to reflect the new variable semantics. Keep the same
> >> > > default of 100 percent writes.
>
> >> > Doesn't the new option cause like a 1000x slowdown in "Dirty memory
> >> > time"?  I don't think we should merge this until that is understood and
> >> > addressed (and it should be at least called out here so that reviewers
> >> > can be made aware).
>
>
> >> I'm guessing you got that from my internally posted tests. This option
> >> itself does not cause the slowdown. If this option is set to 0% or 100%
> >> (the default), there is no slowdown at all. The slowdown I measured was
> >> at 50%, probably because that makes branch prediction impossible because
> >> it has an equal chance of doing a read or a write each time. This is a
> >> good thing. It's much more realistic than predictably alternating read
> >> and write.
>
> > I found it hard to believe that branch prediction could affect
> > performance by 1000x (and why wouldn't random access order show the same
> > effect?) so I looked into it further.
>
> > The cause of the slowdown is actually MMU lock contention:
>
> > -   82.62%  [k] queued_spin_lock_slowpath
> >     - 82.09% queued_spin_lock_slowpath
> >        - 48.36% queued_write_lock_slowpath
> >           - _raw_write_lock
> >              - 22.18% kvm_mmu_notifier_invalidate_range_start
> >                   __mmu_notifier_invalidate_range_start
> >                   wp_page_copy
> >                   do_wp_page
> >                   __handle_mm_fault
> >                   handle_mm_fault
> >                   __get_user_pages
> >                   get_user_pages_unlocked
> >                   hva_to_pfn
> >                   __gfn_to_pfn_memslot
> >                   kvm_faultin_pfn
> >                   direct_page_fault
> >                   kvm_tdp_page_fault
> >                   kvm_mmu_page_fault
> >                   handle_ept_violation
>
> > I think the bug is due to the following:
>
> >   1. Randomized reads/writes were being applied to the Populate phase,
> >      which (when using anonymous memory) results in the guest memory being
> >      mapped to the Zero Page.
> >   2. The random access order changed across each iteration (Population
> >      phase included) which means that some pages were written to during
> > each
> >      iteration for the first time. Those pages resulted in a copy-on-write
> >      in the host MM fault handler, which invokes the invalidate range
> >      notifier and acquires the MMU lock in write-mode.
> >   3. All vCPUs are doing this in parallel which results in a ton of lock
> >      contention.
>
> > Your internal test results also showed that performance got better
> > during each iteration. That's because more and more of the guest memory
> > has been faulted in during each iteration (less and less copy-on-write
> > faults that need to acquire the MMU lock in write-mode).
>
>
> Thanks for the analysis David. I had wondered about the effects of
> randomized reads/writes during the populate phase.
>
> > The proper fix for v4 would be to set write-percent to 100 during the
> > populate phase so all memory actually gets populated. Then only use the
> > provided write-percent for testing dirty logging.
>
>
> Will do that.

Sounds good, thanks. I do think that this is an interesting discovery
though that we wouldn't have known about without your random access
series. So I am somewhat tempted to say let's leave the behavior as
is. But doing that will end up conflating two different tests.
dirty_log_perf_test should really isolate the performance of dirty
logging independent of memory population.

It would be interesting though to create a generalized memory access
test that randomizes reads, writes and even execution (to exercise NX
Huge Pages) so that we do have a test that exercises the copy-on-write
behavior. But I think that falls outside the scope of your series.
