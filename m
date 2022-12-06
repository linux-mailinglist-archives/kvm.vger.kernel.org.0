Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04838644D65
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 21:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLFUmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 15:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLFUmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 15:42:00 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382BB140CE
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 12:41:59 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d1so25194421wrs.12
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 12:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jrY5fUHkqeAyOydO3erpRha3IR3Wyl+3Cda9Eh5slJY=;
        b=FAZU9OW0Jzz/3hYPLpamvudKw8H90Y9qELvIq62fNEuM9jknqDmCTxapdXjOy9oMzh
         p369cqJihqRU18duaLuzVWYQLR5kkx1b+55tD33rl6911HSxwH0MSJmz8cMa+KYWcKIx
         hhZeMoHXx0Tp1ewkNp4Pfjtc3FSCu2nO4CEKLIrIPhTysp5uB70VSgPTLlB3FN7+T5M3
         37YQkknyRjhILyEOZAetjeJnO6q8W0ugVaqoMXCcj0vmEFv2wn/sZDMz26LtQLd3Imx2
         nON5vy7grbmIMDAwc2uG6Qa3eOTF8EA+RqBzi+Fut8pHC5gixDmtfilGy83IPjBL504B
         RFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jrY5fUHkqeAyOydO3erpRha3IR3Wyl+3Cda9Eh5slJY=;
        b=kfcnT4vl4c9YXaCLeJMN79kWm8bRTj5x1ZuTYfS0zYvmX4YQyL9Lj97OyT98kdPdjd
         u9CQMEx7tDsivn6fIIQA8C+S7ZTqPFGUcH/4ri9kOPFNIxftkLL+ZKOrGEfcJVgdP9gb
         xA38xuTVZzof8zP+VHsQHv/zlIAhWPtsmO4mCRhrfxq8SsHHRB1CRSihdXxlko1a3YoS
         os+VCQriKPSjwfGs+IXtlC8DWO+tCuI1h/LbUcFByOCfWIGjfSsVd95jkR6iig97c2UB
         u7mlQxwbwek3/C2hNCGXdGhVkSOIowHCp++HPz+DaJPH2GMv9Cci1vyWx+AAGRTstrfO
         qNxA==
X-Gm-Message-State: ANoB5pmVZztlB0Uvko40tCs1MP2SgKVHWqCwEKGvdX/52CNFSNBBIMDB
        mBfkPRlFLVgPEWP7WPGAk1xAfT+cTbVGZODgJnCZoDrdU6SsdQ==
X-Google-Smtp-Source: AA0mqf7Kv9y6AlmtkEHHoJvMzOi800UE3Kv49+hGEvI1ZQE+TzTLRcqeOgAWRuNRo+j6EFYqzmb5Jba48P6/NrrWC5A=
X-Received: by 2002:a5d:524f:0:b0:242:dee:716c with SMTP id
 k15-20020a5d524f000000b002420dee716cmr28660992wrc.664.1670359317722; Tue, 06
 Dec 2022 12:41:57 -0800 (PST)
MIME-Version: 1.0
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com> <Y44NylxprhPn6AoN@x1n> <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com> <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
 <Y46VgQRU+do50iuv@google.com> <CADrL8HVM1poR5EYCsghhMMoN2U+FYT6yZr_5hZ8pLZTXpLnu8Q@mail.gmail.com>
 <Y4+DVdq1Pj3k4Nyz@google.com>
In-Reply-To: <Y4+DVdq1Pj3k4Nyz@google.com>
From:   James Houghton <jthoughton@google.com>
Date:   Tue, 6 Dec 2022 15:41:46 -0500
Message-ID: <CADrL8HVftX-B+oHLbjnJCret01yjUpOjQfmHdDa7mYkMenOa+A@mail.gmail.com>
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Dec 6, 2022 at 1:01 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Dec 06, 2022, James Houghton wrote:
> > On Mon, Dec 5, 2022 at 8:06 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Dec 05, 2022, James Houghton wrote:
> > > > On Mon, Dec 5, 2022 at 1:20 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Mon, Dec 05, 2022, David Matlack wrote:
> > > > > > On Mon, Dec 5, 2022 at 7:30 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > > > ...
> > > > > > > I'll have a closer read on the nested part, but note that this path already
> > > > > > > has the mmap lock then it invalidates the goal if we want to avoid taking
> > > > > > > it from the first place, or maybe we don't care?
> > > >
> > > > Not taking the mmap lock would be helpful, but we still have to take
> > > > it in UFFDIO_CONTINUE, so it's ok if we have to still take it here.
> > >
> > > IIUC, Peter is suggesting that the kernel not even get to the point where UFFD
> > > is involved.  The "fault" would get propagated to userspace by KVM, userspace
> > > fixes the fault (gets the page from the source, does MADV_POPULATE_WRITE), and
> > > resumes the vCPU.
> >
> > If we haven't UFFDIO_CONTINUE'd some address range yet,
> > MADV_POPULATE_WRITE for that range will drop into handle_userfault and
> > go to sleep. Not good!
>
> Ah, right, userspace would still need to register UFFD for the region to handle
> non-KVM (or incompatible KVM) accesses and could loop back on itself.
>
> > So, going with the no-slow-GUP approach, resolving faults is done like this:
> > - If we haven't UFFDIO_CONTINUE'd yet, do that now and restart
> > KVM_RUN. The PTEs will be none/blank right now. This is the common
> > case.
> > - If we have UFFDIO_CONTINUE'd already, if we were to do it again, we
> > would get EEXIST. (In this case, we probably have some type of swap
> > entry in the page tables.) We have to change the page tables to make
> > fast GUP succeed now *without* using UFFDIO_CONTINUE now.
> > MADV_POPULATE_WRITE seems to be the right tool for the job. This case
> > happens if the kernel has swapped the memory out, is migrating it, has
> > poisoned it, etc. If MADV_POPULATE_WRITE fails, we probably need to
> > crash or inject a memory error.
> >
> > So with this approach, we never need to take the mmap_lock for reading
> > in hva_to_pfn, but we still need to take it in UFFDIO_CONTINUE.
> > Without removing the mmap_lock from *both*, we don't gain much.
> >
> > So if we disregard this tiny mmap_lock benefit, the other approach
> > (the PF_NO_UFFD_WAIT approach) seems better.
>
> Can you elaborate on what makes it better?  Or maybe generate a list of pros and
> cons?  I can think of (dis)advantages for both approaches, but I haven't identified
> anything that would be a blocking issue for either approach.  Doesn't mean there
> isn't one or more blocking issues, just that I haven't thought of any :-)

Let's see.... so using no-slow-GUP over no UFFD waiting:
- No need to take mmap_lock in mem fault path.
- Change the relevant __gfn_to_pfn_memslot callers
(kvm_faultin_pfn/user_mem_abort/others?) to set `atomic = true` if the
new CAP is used.
- No need for a new PF_NO_UFFD_WAIT (would be toggled somewhere
in/near kvm_faultin_pfn/user_mem_abort).
- Userspace has to indirectly figure out the state of the page tables
to know what action to take (which introduces some weirdness, like if
anyone MADV_DONTNEEDs some guest memory, we need to know).
- While userfaultfd is registered (so like during post-copy), any
hva_to_pfn() calls that were resolvable with slow GUP before (without
dropping into handle_userfault()) will now need to be resolved by
userspace manually with a call to MADV_POPULATE_WRITE. This extra trip
to userspace could slow things down.

Both of these seem pretty simple to implement in the kernel; the most
complicated part is just returning KVM_EXIT_MEMORY_FAULT in more
places / for other architectures (I care about x86 and arm64).

Right now both approaches seem fine to me. Not having to take the
mmap_lock in the fault path, while being such a minor difference now,
could be a huge benefit if we can later get around to making
UFFDIO_CONTINUE not need the mmap lock. Disregarding that, not
requiring userspace to guess the state of the page tables seems
helpful (less bug-prone, I guess).

>
> > When KVM_RUN exits:
> > - If we haven't UFFDIO_CONTINUE'd yet, do that now and restart KVM_RUN.
> > - If we have, then something bad has happened. Slow GUP already ran
> > and failed, so we need to treat this in the same way we treat a
> > MADV_POPULATE_WRITE failure above: userspace might just want to crash
> > (or inject a memory error or something).
> >
> > - James
