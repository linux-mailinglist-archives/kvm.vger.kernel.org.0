Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E5055EB92
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 19:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiF1R6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 13:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbiF1R6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 13:58:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F80A6599
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 10:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C69A619E1
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 17:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F616C3411D;
        Tue, 28 Jun 2022 17:57:57 +0000 (UTC)
Date:   Tue, 28 Jun 2022 18:57:53 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <YrtBIX0/0jyAdgnz@arm.com>
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com>
 <CAMn1gO7-qVzZrAt63BJC-M8gKLw4=60iVUo6Eu8T_5y3AZnKcA@mail.gmail.com>
 <YrmXzHXv4babwbNZ@arm.com>
 <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 11:16:17AM -0700, Peter Collingbourne wrote:
> On Mon, Jun 27, 2022 at 4:43 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Fri, Jun 24, 2022 at 02:50:53PM -0700, Peter Collingbourne wrote:
> > > On Fri, Jun 24, 2022 at 10:05 AM Catalin Marinas
> > > <catalin.marinas@arm.com> wrote:
> > > > + Steven as he added the KVM and swap support for MTE.
> > > >
> > > > On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
> > > > > Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
> > > > > depend on being able to map guest memory as MAP_SHARED. The current
> > > > > restriction on sharing MAP_SHARED pages with the guest is preventing
> > > > > the use of those features with MTE. Therefore, remove this restriction.
> > > >
> > > > We already have some corner cases where the PG_mte_tagged logic fails
> > > > even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
> > > > KVM MAP_SHARED will potentially make things worse (or hard to reason
> > > > about; for example the VMM sets PROT_MTE as well). I'm more inclined to
> > > > get rid of PG_mte_tagged altogether, always zero (or restore) the tags
> > > > on user page allocation, copy them on write. For swap we can scan and if
> > > > all tags are 0 and just skip saving them.
> > >
> > > A problem with this approach is that it would conflict with any
> > > potential future changes that we might make that would require the
> > > kernel to avoid modifying the tags for non-PROT_MTE pages.
> >
> > Not if in all those cases we check VM_MTE_ALLOWED. We seem to have the
> > vma available where it matters. We can keep PG_mte_tagged around but
> > always set it on page allocation (e.g. when zeroing or CoW) and check
> > VM_MTE_ALLOWED rather than VM_MTE.
> 
> Right, but for avoiding tagging we would like that to apply to as many
> pages as possible. If we check VM_MTE_ALLOWED then the heap pages of
> those processes that are not using MTE would not be covered, which on
> a mostly non-MTE system would be a majority of pages.

By non-MTE system, I guess you mean a system that supports MTE but most
of the user apps don't use it. That's why it would be interesting to see
the effect of using DC GZVA instead of DC ZVA for page zeroing.

I suspect on Android you'd notice the fork() penalty a bit more with all
the copy-on-write having to copy tags. But we can't tell until we do
some benchmarks. If the penalty is indeed significant, we'll go back to
assessing the races here.

Another thing that won't happen for PG_mte_tagged currently is KSM page
merging. I had a patch to allow comparing the tags but eventually
dropped it (can dig it out).

> Over the weekend I thought of another policy, which would be similar
> to your original one. We can always tag pages which are mapped as
> MAP_SHARED. These pages are much less common than private pages, so
> the impact would be less. So the if statement in
> alloc_zeroed_user_highpage_movable would become:
> 
> if ((vma->vm_flags & VM_MTE) || (system_supports_mte() &&
>				   (vma->vm_flags & VM_SHARED)))
> 
> That would allow us to put basically any shared mapping in the guest
> address space without needing to deal with races in sanitise_mte_tags.

It's not just about VM_SHARED. A page can be effectively shared as a
result of a fork(). It is read-only in all processes but still shared
and one task may call mprotect(PROT_MTE).

Another case of sharing is between the VMM and the guest though I think
an mprotect() in the VMM would trigger the unmapping of the guest
address and pages mapped into guests already have PG_mte_tagged set.

We probably need to draw a state machine of all the cases. AFAICT, we
need to take into account a few of the below (it's probably incomplete;
I've been with Steven through most of them IIRC):

1. Private mappings with mixed PROT_MTE, CoW sharing and concurrent
   mprotect(PROT_MTE). That's one of the things I dislike is that a late
   tag clearing via set_pte_at() can happen without breaking the CoW
   mapping. It's a bit counter-intuitive if you treat the tags as data
   (rather than some cache), you don't expect a read-only page to have
   some (tag) updated.

2. Shared mappings with concurrent mprotect(PROT_MTE).

3. Shared mapping restoring from swap.

4. Private mapping restoring from swap into CoW mapping.

5. KVM faults.

6. Concurrent ptrace accesses (or KVM tag copying)

What currently risks failing I think is breaking a CoW mapping with
concurrent mprotect(PROT_MTE) - we set PG_mte_tagged before zeroing the
tags. A concurrent copy may read stale tags. In sanitise_mte_tags() we
do this the other way around - clear tags first and then set the flag.

I think using another bit as a lock may solve most (all) of these but
another option is to treat the tags as data and make sure they are set
before mapping.

> We may consider going further than this and require all pages mapped
> into guests with MTE enabled to be PROT_MTE.

We discussed this when upstreaming KVM support and the idea got pushed
back. The main problem is that the VMM may use MTE for itself but can no
longer access the guest memory without the risk of taking a fault. We
don't have a match-all tag in user space and we can't teach the VMM to
use the PSTATE.TCO bit since driver emulation can be fairly generic.
And, of course, there's also the ABI change now.

> I think it would allow
> dropping sanitise_mte_tags entirely. This would not be a relaxation of
> the ABI but perhaps we can get away with it if, as Cornelia mentioned,
> QEMU does not currently support MTE, and since crosvm doesn't
> currently support it either there's no userspace to break AFAIK. This
> would also address a current weirdness in the API where it is possible
> for the underlying pages of a MAP_SHARED file mapping to become tagged
> via KVM, said tags are exposed to the guest and are discarded when the
> underlying page is paged out.

Ah, good point, shared file mappings is another reason we did not allow
MAP_SHARED and MTE for guest memory.

BTW, in user_mem_abort() we should probably check for VM_MTE_ALLOWED
irrespective of whether we allow MAP_SHARED or not.

> We can perhaps accomplish it by dropping
> support for KVM_CAP_ARM_MTE in the kernel and introducing something
> like a KVM_CAP_ARM_MTE_V2 with the new restriction.

That's an option for the ABI upgrade but we still need to solve the
potential races.

-- 
Catalin
