Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3207C5F7B06
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 17:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiJGPv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 11:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiJGPv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 11:51:28 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A58FBCDA
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 08:51:26 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z20so4885145plb.10
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 08:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S7A4Pm1g9nKupDBvwjs8vsWihcrAJJgMfzZ6A5ROFyw=;
        b=Xqe/R0tQvXIxKiiV4Ulrbbw3y3LP3S6o5F9jGKKyCi6BAkIjmP3XgpkN+SQ0JDiiuN
         8ODsANZR3lqbh0XVg9RLhUd4vlPBNF9EOtA5YSJNcCIcx2au3zT/Qbv/m+gxOvbnLG9T
         vicS0HYMas4GqsgDNaHNcpEO6XhoVhgal6hmDfMucstC/g8yie/6j4gr0IboP6aO/+N0
         ZNHns4DG+kn1cCe8dX4y31CedgtjjtkR9bJtUABBzTU3hQRcqO1+OWicu08gUlaCZEFG
         QaExeUtgudp+xLVfxYISJA1AAut3oD/ERy9ToWwMjojnzG1FA1eX0gtK6zKj1c2rBHph
         vg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7A4Pm1g9nKupDBvwjs8vsWihcrAJJgMfzZ6A5ROFyw=;
        b=rs6xzovjpXgRupgBz58jgmQRt6BCJjkgfjSnGu0JSDZzWBCZiFuP+feHD/CzN/zne2
         EXoF+6dqrO9Wpm45P6J9sYJzOFBkO6PCVuL/gr4PQlpeCydLw6k23kgtTBeefjgrreHA
         m09Rhbxyue7dfP226j+wra/8giLnOYD3hPVzrC4NWGtwmQg9WwuNHDizOn8sBqaHrP5Q
         b4oyENbC8qFoOt2bggeU7NA8zMLLFSy1kkWwes60+91wMVVq/+rFNB2Ib8WAcmPWo8EG
         r061tuvDpKj3l3uehsOppMFe8C0qaOlTWR0qDBx/MipvCVcl/8ybYTc3tM8TvJ5QEkpj
         eYmQ==
X-Gm-Message-State: ACrzQf3j7QIkPeTq7/fUvdfJz3X0f2T+OiLDA9lxUemyYgMgli3emygL
        6GvCZMduuLJnknmhVJel1RNFmw==
X-Google-Smtp-Source: AMsMyM7zMkVGmhuTTrl07PXwD4kgHIrUAcGG/11eU05ua+ng6eScnzYgQAwVKL3jxx3uiq1D8wuX/Q==
X-Received: by 2002:a17:902:b089:b0:178:54cf:d692 with SMTP id p9-20020a170902b08900b0017854cfd692mr5682021plr.1.1665157885358;
        Fri, 07 Oct 2022 08:51:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090a2c0900b00202fbd9c21dsm1643701pjd.48.2022.10.07.08.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 08:51:24 -0700 (PDT)
Date:   Fri, 7 Oct 2022 15:51:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        ovidiu.panait@windriver.com, kvm@vger.kernel.org,
        liam.merwick@oracle.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, pgonda@google.com,
        marcorr@google.com, alpergun@google.com, jarkko@kernel.org,
        jroedel@suse.de, bp@alien8.de, rientjes@google.com
Subject: Re: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Message-ID: <Y0BK9/uo9eUE1RKb@google.com>
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
 <20220927000729.498292-1-Ashish.Kalra@amd.com>
 <YzJFvWPb1syXcVQm@google.com>
 <215ee1ce-b6eb-9699-d682-f2e592cde448@amd.com>
 <Yz99nF+d6D+37efE@google.com>
 <CAL715WL4L=9vhhU3TvY7TOe3HZ73weWFNiaP2RyBtzN-kZ4EoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL715WL4L=9vhhU3TvY7TOe3HZ73weWFNiaP2RyBtzN-kZ4EoQ@mail.gmail.com>
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

On Thu, Oct 06, 2022, Mingwei Zhang wrote:
> On Thu, Oct 6, 2022 at 6:15 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Oct 06, 2022, Kalra, Ashish wrote:
> > > For the MMU invalidation notifiers we are going to make two changes
> > > currently:
> > >
> > > 1). Use clflush/clflushopt instead of wbinvd_on_all_cpus() for range <= 2MB.
> >
> > IMO, this isn't worth pursuing, to the point where I might object to this code
> > being added upstream.  Avoiding WBINVD for the mmu_notifiers doesn't prevent a
> > malicious userspace from using SEV-induced WBINVD to effectively DoS the host,
> > e.g. userspace can simply ADD+DELETE memslots, or mprotect() chunks > 2mb.
> >
> 
> I think using clflush/clflushopt is a tactical workaround for SNP VMs.
> As mentioned earlier by Ashish:
> 
> "For SNP guests we don't need to invoke the MMU invalidation notifiers
> and the cache flush should be done at the point of RMP ownership change
> instead of mmu_notifier, which will be when the unregister_enc_region
> ioctl is called, but as we don't trust the userspace (which can bypass
> this ioctl), therefore we continue to use the MMU invalidation
> notifiers."
> 
> So if that is true: SNP VMs also have to use mmu_notifiers for
> splitting the PMDs

SNP private memory will be backed by UPM, and thus won't have host PMDs to split.
And splitting guest PMDs to convert between shared and private doesn't initiate
an RMP ownership change of the underlying physical page.  The ownership of a page
will change back to "hypervisor" only when the page is truly freed from the private
backing store.

> then I think using clflush/clflushopt might be the
> only workaround that I know of.
> 
> > Using clfushopt also effectively puts a requirement on mm/ that the notifiers
> > be invoked _before_ PTEs are modified in the primary MMU, otherwise KVM may not
> > be able to resolve the VA=>PFN, or even worse, resolve the wrong PFN.
> 
> I don't understand this. Isn't it always true that MM should fire
> mmu_notifiers before modifying PTEs in host MMU? This should be a
> strict rule as in my knowledge, no?

It will hold true for all flavors of invalidate_range, but not for change_pte().
The original intent of change_pte() is that it would be called without an
invalidation, _after_ the primary MMU changed its PTE, so that secondary MMUs
could pick up the new PTE without causing a VM-Exit.

E.g. snippets from the original changelog and code:

    The set_pte_at_notify() macro allows setting a pte in the shadow page
    table directly, instead of flushing the shadow page table entry and then
    getting vmexit to set it.  It uses a new change_pte() callback to do so.
    
    set_pte_at_notify() is an optimization for kvm, and other users of
    mmu_notifiers, for COW pages.  It is useful for kvm when ksm is used,
    because it allows kvm not to have to receive vmexit and only then map the
    ksm page into the shadow page table, but instead map it directly at the
    same time as Linux maps the page into the host page table.
    

                /*
                 * Clear the pte entry and flush it first, before updating the
                 * pte with the new entry. This will avoid a race condition
                 * seen in the presence of one thread doing SMC and another
                 * thread doing COW.
                 */
                ptep_clear_flush(vma, address, page_table);
                page_add_new_anon_rmap(new_page, vma, address);
                /*
                 * We call the notify macro here because, when using secondary
                 * mmu page tables (such as kvm shadow page tables), we want the
                 * new page to be mapped directly into the secondary page table.
                 */
                set_pte_at_notify(mm, address, page_table, entry);


#define set_pte_at_notify(__mm, __address, __ptep, __pte)               \
({                                                                      \
        struct mm_struct *___mm = __mm;                                 \
        unsigned long ___address = __address;                           \
        pte_t ___pte = __pte;                                           \
                                                                        \
        set_pte_at(___mm, ___address, __ptep, ___pte);                  \
        mmu_notifier_change_pte(___mm, ___address, ___pte);             \
})


That behavior got smushed by commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify
with invalidate_range_start and invalidate_range_end"), which depsite clearly
intending to wrap change_pte() with an invalidation, completely overlooked the original
intent of the change_pte() notifier.

Whether or not anyone cares enough about KSM to fix that remains to be seen, but
I don't think it KVM should put restrictions on change_pte() just so that KVM can
put a band-aid on a wart for a very specific type of VM.

> > And no sane VMM should be modifying userspace mappings that cover SEV guest memory
> > at any reasonable rate.
> >
> > In other words, switching to CLFUSHOPT for SEV+SEV-ES VMs is effectively a
> > band-aid for the NUMA balancing issue.
> 
> That's not true. KSM might also use the same mechanism. For NUMA
> balancing and KSM, there seems to be a pattern: blindly flushing
> mmu_notifier first, then try to do the actual work.

See above for KSM.

> I have a limited knowledge on MM, but from my observations, it looks
> like the property of a page being "PINNED" is very unreliable (or
> expensive), i.e., anyone can jump in and pin the page. So it is hard
> to see whether a page is truly "PINNED" or maybe just someone is
> "working" on it without holding the lock.

mm/ differentiates between various types of pins, e.g. elevated refcount vs. pin
vs. longterm pin.  See the comments in include/linux/mm.h for FOLL_PIN.

> Holding the refcount of a struct page requires a spinlock. I suspect that
> might be the reason why NUMA balancing and KSM is just aggressively firing
> mmu_notifiers first. I don't know if there is other stuff in MM following the
> same pattern.
> 
> Concretely, my deep worry is the mmu_notifier in try_to_unmap_one(). I
> cannot enumerate all of the callers. But if there is someone who calls
> into this, it might be a disaster level (4K) performance lock.

Like NUMA balancing, anything that triggers unmapping of SEV memory is a problem
that needs to be fixed.  I'm arguing that we should fix the actual problems, not
put a band-aid on things to make the problems less painful.

>  Hope we can prove that won't happen.

Truly proving it can't happen is likely infeasible.  But I also think it's
unnecessary and would be a poor use of time/resources to try and hunt down every
possible edge case.  Userspace is already highly motivated to ensure SEV guest memory
is as static as possible, and so edge cases that are theoretically possible will
likely not be problematic in practice.

And if there are spurious unappings, they likely affect non-SEV VMs as well, just
to a much lesser degree.  I.e. fixing the underlying problems would benefit all
KVM VMs, not just SEV VMs.
