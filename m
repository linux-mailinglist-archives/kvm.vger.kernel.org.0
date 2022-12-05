Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AFF642ED4
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 18:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiLERcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 12:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiLERcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 12:32:17 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E50F2183F
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 09:32:15 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id o127so15366307yba.5
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 09:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LItvTSNO/liErpomngMhd0/FAUJ8lKefBZplhX+MQ6I=;
        b=j7Gqdg3N3+REJrQ9nV9uyQlZ/kWcGNV9ZXK3hms2c87c+h779yBNPYWbBKCj56C897
         pV2WG0+7+tF6gjtIDi5hZ/zKRSUNc6x4LsVzxjmGF+BuW4JsvLNH74pec1CwYoTw4Pls
         k0TnkrKblPPQGI2B2xBpRnR1SP+1h/Jw1vh0o+kv0czRZfjSxBRIlMvhcp7LRZr4Adgf
         QFQOb4UjfSBxPdAQtN0lsOInGiFqmckh9v1rksrqHKjmpCPRcRwGQHXoKsPF/HLyycH2
         st5tot8XuePmQmuYGiiT1WFN4fk8q3D8B1CZeXGIDV4LL2qHsX4i2KHBYb9dbwR9wwgr
         WErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LItvTSNO/liErpomngMhd0/FAUJ8lKefBZplhX+MQ6I=;
        b=bCfDxPVFQ3tteE2Ggs3JH92TShjAuzGPIeRU4uen/ViA/wdo4K24oy1hqeezx2au7i
         SzCNI8v+qffjBi1u/G9ZzktLzwsxnItzBeAGEr8t98/LQszVHsRY9+V8H/EpP0swMm+7
         qIiiWsD6Zio2KRaA5qcIZUOJHDsY9P/S5573+GJHXzrBm0KEvbwj0iYaGABje2biSfOB
         61gwW4F7ftSg40L6rpWgEhhMwGow83KprtPHlfFcCtNeL3vELnsgdJfsVSK19YKAqeC6
         1P2Ybhu5GJdn2TqLfpetlP/MJLaxboVOEexykoNfC7eQKnib5iG7pD/dphDWwsraFpKP
         JbBw==
X-Gm-Message-State: ANoB5pntuY9d5ii+UHl4egr8UAvZzAZ2f5yi9jqOK/IVMXfZSGoTua9Y
        JN2KeCH5VJm2Rl5UUzsHgkwkhRWSHoYBy3U4gKmWbA==
X-Google-Smtp-Source: AA0mqf7NfS2kiviqDrnp78Zj00MDps83Skg19wO0v4KhlJqyKbEaFBLoNKYA2/JeflBY7GMlygILLfEAU3dwpt2Dq20=
X-Received: by 2002:a25:41d1:0:b0:6f0:8cc2:22ac with SMTP id
 o200-20020a2541d1000000b006f08cc222acmr52449178yba.303.1670261534607; Mon, 05
 Dec 2022 09:32:14 -0800 (PST)
MIME-Version: 1.0
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com> <Y44NylxprhPn6AoN@x1n>
In-Reply-To: <Y44NylxprhPn6AoN@x1n>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 5 Dec 2022 09:31:48 -0800
Message-ID: <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
To:     Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
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

On Mon, Dec 5, 2022 at 7:30 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Sat, Dec 03, 2022 at 01:03:38AM +0000, Sean Christopherson wrote:
> > On Thu, Dec 01, 2022, James Houghton wrote:
> > > #1, however, is quite doable. The main codepath for post-copy, the
> > > path that is taken when a vCPU attempts to access unmapped memory, is
> > > (for x86, but similar for other architectures): handle_ept_violation
> > > -> hva_to_pfn -> GUP -> handle_userfault. I'll call this the "EPT
> > > violation path" or "mem fault path." Other post-copy paths include at
> > > least: (i) KVM attempts to access guest memory via.
> > > copy_{to,from}_user -> #pf -> handle_mm_fault -> handle_userfault, and
> > > (ii) other callers of gfn_to_pfn* or hva_to_pfn* outside of the EPT
> > > violation path (e.g., instruction emulation).
> > >
> > > We want the EPT violation path to be fast, as it is taken the vast
> > > majority of the time.
> >
> > ...
> >
> > > == Getting the faulting GPA to userspace ==
> > > KVM_EXIT_MEMORY_FAULT was introduced recently [1] (not yet merged),
> > > and it provides the main functionality we need. We can extend it
> > > easily to support our use case here, and I think we have at least two
> > > options:
> > > - Introduce something like KVM_CAP_MEM_FAULT_REPORTING, which causes
> > > KVM_RUN to exit with exit reason KVM_EXIT_MEMORY_FAULT when it would
> > > otherwise just return -EFAULT (i.e., when kvm_handle_bad_page returns
> > > -EFAULT).
> > > - We're already introducing a new CAP, so just tie the above behavior
> > > to whether or not one of the CAPs (below) is being used.
> >
> > We might even be able to get away with a third option: unconditionally return
> > KVM_EXIT_MEMORY_FAULT instead of -EFAULT when the error occurs when accessing
> > guest memory.
> >
> > > == Problems ==
> > > The major problem here is that this only solves the scalability
> > > problem for the KVM demand paging case. Other userfaultfd users, if
> > > they have scalability problems, will need to find another approach.
> >
> > It may not fully solve KVM's problem either.  E.g. if the VM is running nested
> > VMs, many (most?) of the user faults could be triggered by FNAME(walk_addr_generic)
> > via __get_user() when walking L1's EPT tables.

We could always modify FNAME(walk_addr_generic) to return out to user
space in the same way if that is indeed another bottleneck.

> >
> > Disclaimer: I know _very_ little about UFFD.
> >
> > Rather than add yet another flag to gup(), what about flag to say the task doesn't
> > want to wait for UFFD faults?  If desired/necessary, KVM could even toggle the flag
> > in KVM_RUN so that faults that occur outside of KVM ultimately don't send an actual
> > SIGBUGS.

There are some copy_to/from_user() calls in KVM that cannot easily
exit out to KVM_RUN (for example, in the guts of the emulator IIRC).
But we could use your approach just to wrap the specific call sites
that can return from KVM_RUN.

> >
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index 07c81ab3fd4d..7f66b56dd6e7 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -394,7 +394,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> >          * shmem_vm_ops->fault method is invoked even during
> >          * coredumping without mmap_lock and it ends up here.
> >          */
> > -       if (current->flags & (PF_EXITING|PF_DUMPCORE))
> > +       if (current->flags & (PF_EXITING|PF_DUMPCORE|PF_NO_UFFD_WAIT))
> >                 goto out;
>
> I'll have a closer read on the nested part, but note that this path already
> has the mmap lock then it invalidates the goal if we want to avoid taking
> it from the first place, or maybe we don't care?
>
> If we want to avoid taking the mmap lock at all (hence the fast-gup
> approach), I'd also suggest we don't make it related to uffd at all but
> instead an interface to say "let's check whether the page tables are there
> (walk pgtable by fast-gup only), if not return to userspace".
>
> Because IIUC fast-gup has nothing to do with uffd, so it can also be a more
> generic interface.  It's just that if the userspace knows what it's doing
> (postcopy-ing), it knows then the faults can potentially be resolved by
> userfaultfd at this stage.

Are there any cases where fast-gup can fail while uffd is enabled but
it's not due to uffd? e.g. if a page is swapped out? I don't know what
userspace would do in those situations to make forward progress.



>
> >
> >         /*
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index ffb6eb55cd13..4c6c53ac6531 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1729,7 +1729,7 @@ extern struct pid *cad_pid;
> >  #define PF_MEMALLOC            0x00000800      /* Allocating memory */
> >  #define PF_NPROC_EXCEEDED      0x00001000      /* set_user() noticed that RLIMIT_NPROC was exceeded */
> >  #define PF_USED_MATH           0x00002000      /* If unset the fpu must be initialized before use */
> > -#define PF__HOLE__00004000     0x00004000
> > +#define PF_NO_UFFD_WAIT                0x00004000
> >  #define PF_NOFREEZE            0x00008000      /* This thread should not be frozen */
> >  #define PF__HOLE__00010000     0x00010000
> >  #define PF_KSWAPD              0x00020000      /* I am kswapd */
> >
>
> --
> Peter Xu
>
