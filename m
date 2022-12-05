Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CF3642FCB
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiLESUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 13:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiLESUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:20:44 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FD92099A
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 10:20:41 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w23so11588153ply.12
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 10:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+bOJKTiPkfMHk6uxaZoppVRYQMYBhmTscSqARviGH6I=;
        b=A/ZBFF+0chYWUBxVma+AtamAbUokaN1/mdtekkaBq/N8uat0FmmtuLcI+4/P4xBIhy
         ca6LDTqcxdFr+zgqX8cQ2pfYf8jXX6BbgqNQ9Bh/JC0XhIz6k3Z16npbUyR5peIen7M6
         Mkw44kH/qNIfAQXzRNuyamx9C0DtULYt8vXQjeycVq+DE8rRD39XEWd2TqFYGiQWxA9s
         uSiD7dTPPTHBJ+biIkD0vilQlKIbod57uyo+EfLmGiTlvVd+3J7g9MxId2cYMhDYQC5F
         obfdpMs6gjynBC8omQG+Yxc78nBU/cOZJKpWU3ZAebxq1nxD2Xen/22XAqfdheeqnN/k
         pxbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+bOJKTiPkfMHk6uxaZoppVRYQMYBhmTscSqARviGH6I=;
        b=7sA2WjTA17FOyBq4tTDjBdU11X2g+LFPs7yDXvFPYUjD2rRMT+L/NbodaJnUs3MuC8
         hEoeHdKKpLQGCXND1r3E2iPz7pK1GoEABGP5F5JaiPXp72RN10WmAXjpaE5oORY+JwcL
         u9rcBGOFVCtDGjqOxI6BKh5sP00yxTdtuEI/WZilUXuoDghheX9e+oMTD5kh7mrW56Z4
         zBPhFaUJCPXIeY9IsB6OzrGohxtz9vMlbq54GrbUlJJoa/nBjiasPFWWviC2mzhWgRwg
         ewlP3Q+HjIcauxuHXON1GmpOTsCU8zm6aJm5Po2GugkCVxv6oAZSOumYIWnqBJIQ+TZT
         FgeQ==
X-Gm-Message-State: ANoB5pleTKlOV7jkPKB4qU+It5GLSzDnZFJTHF/JCBcUIIv5vIi1ADza
        jg07JCEbwKDS2uKZDHSUNM10Jw==
X-Google-Smtp-Source: AA0mqf7bma3A3dXb4cBUkvq1rm3yfGH83Fz6ysb4agHDeVOLMg8FIrSV/KqaeJaAPoDK0We6iKdKzQ==
X-Received: by 2002:a17:90a:a611:b0:219:3a95:5b0b with SMTP id c17-20020a17090aa61100b002193a955b0bmr40930132pjq.190.1670264440830;
        Mon, 05 Dec 2022 10:20:40 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b0016d9b101413sm10865780pll.200.2022.12.05.10.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 10:20:40 -0800 (PST)
Date:   Mon, 5 Dec 2022 18:20:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
Message-ID: <Y442dPwu2L6g8zAo@google.com>
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com>
 <Y44NylxprhPn6AoN@x1n>
 <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
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

On Mon, Dec 05, 2022, David Matlack wrote:
> On Mon, Dec 5, 2022 at 7:30 AM Peter Xu <peterx@redhat.com> wrote:
> > > > == Getting the faulting GPA to userspace ==
> > > > KVM_EXIT_MEMORY_FAULT was introduced recently [1] (not yet merged),
> > > > and it provides the main functionality we need. We can extend it
> > > > easily to support our use case here, and I think we have at least two
> > > > options:
> > > > - Introduce something like KVM_CAP_MEM_FAULT_REPORTING, which causes
> > > > KVM_RUN to exit with exit reason KVM_EXIT_MEMORY_FAULT when it would
> > > > otherwise just return -EFAULT (i.e., when kvm_handle_bad_page returns
> > > > -EFAULT).
> > > > - We're already introducing a new CAP, so just tie the above behavior
> > > > to whether or not one of the CAPs (below) is being used.
> > >
> > > We might even be able to get away with a third option: unconditionally return
> > > KVM_EXIT_MEMORY_FAULT instead of -EFAULT when the error occurs when accessing
> > > guest memory.
> > >
> > > > == Problems ==
> > > > The major problem here is that this only solves the scalability
> > > > problem for the KVM demand paging case. Other userfaultfd users, if
> > > > they have scalability problems, will need to find another approach.
> > >
> > > It may not fully solve KVM's problem either.  E.g. if the VM is running nested
> > > VMs, many (most?) of the user faults could be triggered by FNAME(walk_addr_generic)
> > > via __get_user() when walking L1's EPT tables.
> 
> We could always modify FNAME(walk_addr_generic) to return out to user
> space in the same way if that is indeed another bottleneck.

Yes, but given that there's a decent chance that solving this problem will add
new ABI, I want to make sure that we are confident that we won't end up with gaps
in the ABI.  I.e. I don't want to punt the nested case to the future.

> > > Disclaimer: I know _very_ little about UFFD.
> > >
> > > Rather than add yet another flag to gup(), what about flag to say the task doesn't
> > > want to wait for UFFD faults?  If desired/necessary, KVM could even toggle the flag
> > > in KVM_RUN so that faults that occur outside of KVM ultimately don't send an actual
> > > SIGBUGS.
> 
> There are some copy_to/from_user() calls in KVM that cannot easily
> exit out to KVM_RUN (for example, in the guts of the emulator IIRC).
> But we could use your approach just to wrap the specific call sites
> that can return from KVM_RUN.

Yeah, it would definitely need to be opt-in. 

> > > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > > index 07c81ab3fd4d..7f66b56dd6e7 100644
> > > --- a/fs/userfaultfd.c
> > > +++ b/fs/userfaultfd.c
> > > @@ -394,7 +394,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> > >          * shmem_vm_ops->fault method is invoked even during
> > >          * coredumping without mmap_lock and it ends up here.
> > >          */
> > > -       if (current->flags & (PF_EXITING|PF_DUMPCORE))
> > > +       if (current->flags & (PF_EXITING|PF_DUMPCORE|PF_NO_UFFD_WAIT))
> > >                 goto out;
> >
> > I'll have a closer read on the nested part, but note that this path already
> > has the mmap lock then it invalidates the goal if we want to avoid taking
> > it from the first place, or maybe we don't care?
> >
> > If we want to avoid taking the mmap lock at all (hence the fast-gup
> > approach), I'd also suggest we don't make it related to uffd at all but
> > instead an interface to say "let's check whether the page tables are there
> > (walk pgtable by fast-gup only), if not return to userspace".

Ooh, good point.  If KVM provided a way for userspace to toggle a "fast-only" flag,
then hva_to_pfn() could bail if hva_to_pfn_fast() failed, and I think KVM could
just do pagefault_disable/enable() around compatible KVM uaccesses?

> > Because IIUC fast-gup has nothing to do with uffd, so it can also be a more
> > generic interface.  It's just that if the userspace knows what it's doing
> > (postcopy-ing), it knows then the faults can potentially be resolved by
> > userfaultfd at this stage.
> 
> Are there any cases where fast-gup can fail while uffd is enabled but
> it's not due to uffd? e.g. if a page is swapped out?

Undoubtedly.  COW, NUMA balancing, KSM?, etc.  Nit, I don't think "due to uffd"
is the right terminology, I think the right phrasing is something like "but can't
be resolved by userspace", or maybe "but weren't induced by userspace".  UFFD
itself never causes faults.

> I don't know what userspace would do in those situations to make forward progress.

Access the page from userspace?  E.g. a "LOCK AND -1" would resolve read and write
faults without modifying guest memory.

That won't work for guests backed by "restricted mem", a.k.a. UPM guests, but
restricted mem really should be able to prevent those types of faults in the first
place.  SEV guests are the one case I can think of where that approach won't work,
since writes will corrupt the guest.  SEV guests can likely be special cased though.
