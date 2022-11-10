Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1E2623832
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 01:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiKJAde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 19:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiKJAdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 19:33:31 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C20BAE53
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 16:33:30 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id b185so300585pfb.9
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 16:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYi0GZGMn5TC2lhvPcFDZ9xBuACGkto6jmH1Czub6A0=;
        b=tZq0PqDpfPR419ZFwAPi7cG9DySFU1sJP27XIuwOmJleanpv3u3VkHO1qgRiDgWY3v
         zPh3/PpXfHtccFz+IpqYkwqh5wMudWF6fg2GhQBwO7WCK3FpqAwPSYUDvT6TgsxwRbyK
         Vm3Apk+GRyikt6WvGWv0ILAUaxXJe2HMWPQuevLuz7cqe06ipSATYJ1WI50J0qSSzE9i
         WeMsgD6/b4GKLWAcDenzB/dIVnG5+Xo5vvI8YC59XPRbBxCuSEUmPOmJF8dEiVGKpMEc
         qoKY6Y2ruqguBRwXi0fX0PCz7p2YcvSrQoez19i4RcfuH84RIeRLjSiZC3QtC4NvVZCk
         K31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYi0GZGMn5TC2lhvPcFDZ9xBuACGkto6jmH1Czub6A0=;
        b=m1PHKX8AhdtMAKI7P1Q1+hbuHoAt8aZrJ97HtqfWFpBGv0xOWuyoqYULHAiWFUMgVG
         Cmdm+HNFyRqL7H0VK1Z1HjorTvL4ZLH+5zs4bBNH0iitTHQ4zGTnV6Pd7xblVLSuP9ei
         RNiK5UTcVmXfRkV7PM8itVHl9dbGnigs9EaqU1/VrYHNQHvUb9evR8/DJ8IgeAkQ9RsB
         azqtM8xnt26WFY6xVOxjaekASikxEWmZsKETMpVI9nREXzfP5b9uURfCK+VmdkdMY0eY
         fUd+0z5VE4YIoQPr6bd+dXW1Lu/F5GQtD1iJJGfhwHsWrZ0XzgN3amtfSvYefx7wSVHN
         4iMQ==
X-Gm-Message-State: ANoB5pk61GOl2rY+uoSusZD9xasNqtsFfjXGvr//mk5H5F8WzNIbp+Dp
        qZaUw3upaeTZqR4eMIg+MA0QJA==
X-Google-Smtp-Source: AA0mqf6IwulYIdSeSlHYYMtf2wIm4fnBNI9XNM3Fo6I+UFyQMb2vfh07eq+i6gx1r32A8/HcZ+7yPw==
X-Received: by 2002:a63:f347:0:b0:470:580a:cb7 with SMTP id t7-20020a63f347000000b00470580a0cb7mr986390pgj.73.1668040409296;
        Wed, 09 Nov 2022 16:33:29 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 185-20020a6217c2000000b0056bc1d7816dsm9118261pfx.99.2022.11.09.16.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 16:33:28 -0800 (PST)
Date:   Thu, 10 Nov 2022 00:33:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: move memslot invalidation later than possible
 failures
Message-ID: <Y2xG1SY/kNULHFck@google.com>
References: <20221108084416.11447-1-yan.y.zhao@intel.com>
 <Y2qSwlN26qWi3ZqH@google.com>
 <Y2tNGHF5Lbjk4DQV@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2tNGHF5Lbjk4DQV@yzhao56-desk.sh.intel.com>
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

On Wed, Nov 09, 2022, Yan Zhao wrote:
> On Tue, Nov 08, 2022 at 05:32:50PM +0000, Sean Christopherson wrote:
> > On Tue, Nov 08, 2022, Yan Zhao wrote:
> > > For memslot delete and move, kvm_invalidate_memslot() is required before
> > > the real changes committed.
> > > Besides swapping to an inactive slot, kvm_invalidate_memslot() will call
> > > kvm_arch_flush_shadow_memslot() and further kvm_page_track_flush_slot() in
> > > arch x86.
> > > And according to the definition in kvm_page_track_notifier_node, users can
> > > drop write-protection for the pages in the memory slot on receiving
> > > .track_flush_slot.
> > 
> > Ugh, that's a terrible API.  The entire page track API is a mess, e.g. KVMGT is
> > forced to grab its own references to KVM and also needs to manually acquire/release
> > mmu_lock in some flows but not others.
> > 
> > Anyways, this is a flaw in the page track API that should be fixed.  Flushing a
> > slot should not be overloaded to imply "this slot is gone", it should be a flush
> > command, no more, no less.
> hmm, but KVM also registers to the page track
> "node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;"
> And in kvm_mmu_invalidate_zap_pages_in_memslot, memslot (actaully all the shadow
> page tables) is zapped. And during the zap, unaccount_shadowed() will drop the
> write protection. But KVM is ok because the dropped write-protection can be
> rebuilt during rebuilding the shadow page table.
> So, for .track_flush_slot, it's expected that "users can drop write-protection
> for the pages in the memory slot", right?

No.  KVM isn't actually dropping write-protection, because for the internal KVM
case, KVM obliterates all of its page tables.

> > AFAICT, KVMGT never flushes anything, so fixing the bug should be a simple matter
> > of adding another hook that's invoked when the memory region change is committed.
> >
> Do you mean adding a new hook in page track, e.g. .track_slot_change?
> Then right before committing slot changes, call this interface to notify slot
> DELETE/MOVE?
> 
> Not only KVMGT, KVM can also be affected by this failure to MOVE if it wants to
> support below usecase:
> 1. KVM pre-populated a memslot
> 2. memslot MOVE happened
> 3. KVM pre-populates the new memslot (MOVE succeeds) or the old one (MOVE fails).
> So also add a new interface for the MOVE failure?
> 
> > That would allow KVMGT to fix another bug.  If a memory region is moved and the
> > new region partially overlaps the old region, KVMGT technically probably wants to
> > retain its write-protection scheme.  Though that's probably not worth supporting,
> > might be better to say "don't move memory regions if KVMGT is enabled", because
> > AFAIK there is no VMM that actually moves memory regions (KVM's MOVE support was
> > broken for years and no one noticed).
> >
> So, could we disable MOVE in KVM at all?

Ideally, yes.  Practically?  Dunno.  It's difficult to know whether or not there
are users out there.

> > Actually, given that MOVE + KVMGT probably doesn't work regardless of where the
> > region is moved to, maybe we can get away with rejecting MOVE if an external
> > page tracker cares about the slot in question.
> > 
> > > However, if kvm_prepare_memory_region() fails, the later
> > > kvm_activate_memslot() will only swap back the original slot, leaving
> > > previous write protection not recovered.
> > > 
> > > This may not be a problem for kvm itself as a page tracker user, but may
> > > cause problem to other page tracker users, e.g. kvmgt, whose
> > > write-protected pages are removed from the write-protected list and not
> > > added back.
> > > 
> > > So call kvm_prepare_memory_region first for meta data preparation before
> > > the slot invalidation so as to avoid failure and recovery.
> > 
> > IIUC, this is purely a theoretical bug and practically speaking can't be a problem
> > in practice, at least not without completely breaking KVMGT.
> > 
> > On DELETE, kvm_prepare_memory_region() will never fail on x86 (s390's ultravisor
> > protected VM case is the only scenario where DELETE can fail on any architecture).
> > The common code in kvm_prepare_memory_region() does nothing for DELETE, ditto for
> > kvm_arch_prepare_memory_region().
> But as long as with current code sequence, we can't relying on that
> kvm_prepare_memory_region() will never fail for DELETE.
> Or, we need to call kvm_prepare_memory_region() only for !DELETE to avoid future
> possible broken.

Agreed, I just don't want to touch the common memslots code unless it's necessary.

> > And for MOVE, it can only fail in two scenarios: (1) the end gfn is beyond the
> > max gfn, i.e. userspace gave bad input or (2) the new memslot is unaligned but
> > the old memslot was not, and so KVM needs to allocate new metadata due to the new
> > memslot needed larger arrays.
> kvm_prepare_memory_region() can also fail for MOVE during live migration when
> memslot->dirty_bitmap allocation is failed in kvm_alloc_dirty_bitmap().
> and in x86, kvm_arch_prepare_memory_region() can also fail for MOVE if
> kvm_alloc_memslot_metadata() fails due to -ENOMEM. 
> BTW, I don't find the "(2) the new memslot is unaligned but the old memslot was not,
> and so KVM needs to allocate new metadata due to the new memslot needed
> larger arrays". 
> > 
> > As above MOVE is not handled correctly by KVMGT, so I highly doubt there is a VMM
> > that supports KVMGT and moves relevant memory regions, let alove does something
> > that can result in MOVE failing _and_ moves the memslot that KVMGT is shadowing.
> > 
> > Heh, and MOVE + KVM_MEM_LOG_DIRTY_PAGES is also arguably broken, as KVM reuses
> > the existing dirty bitmap but doesn't shift the dirty bits.  This is likely
> Do you mean, for the new slot in MOVE, the new dirty bitmap should be
> cleared? Otherwise, why shift is required, given mem->userspace_addr and npages
> are not changed and dirty_bitmap is indexed using rel_gfn 
> (rel_gfn = gfn - memslot->base_gfn) and both QEMU/KVM aligns the bitmap
> size to BITS_PER_LONG.

Oh, you're right.  I forgot that userspace would also be doing a gfn-relative
calculation in the ridiculously theoretically scenario that a memslot is moved
while it's being dirty-logged.

> > another combination that KVM can simply reject.
> > 
> > Assuming this is indeed purely theoretical, that should be called out in the
> > changelog.  Or as above, simply disallow MOVE in this case, which probably has
> > my vote.
> >
> Yes, currently it's a purely theoretical bug, as I'm not seeing MOVE is triggered
> in upstream QEMU.
> 
> <...>
> 
> > I'm not 100% sure that simply moving kvm_invalidate_memslot() is functionally
> > correct.  It might be, but there are so many subtleties in this code that I don't
> > want to change this ordering unless absolutely necessary, or at least not without
> > an in-depth analysis and a pile of tests.  E.g. it's possible one or more
> > architectures relies on unmapping, flushing, and invalidating the old region
> > prior to preparing the new region, e.g. to reuse arch memslot data.
> yes. what about just moving kvm_arch_flush_shadow_memslot() and
> kvm_arch_guest_memory_reclaimed() to later than kvm_arch_prepare_memory_region()?

I'm not dead set against tweaking the memslots flow, but I don't want to do so to
fix this extremely theoretical bug.  In other words, I want to fix this by giving
KVM-GT a more appropriate hook, not by shuffling common KVM code to fudge around
a poor KVM x86 API.

And if KVM-GT moves away from track_flush_slot(), we can delete the hook entirely
after cleaning up clean up another pile of ugly: KVM always registers a page-track
notifier because it relies on the track_flush_slot() call to invoke
kvm_mmu_invalidate_zap_pages_in_memslot(), even when KVM isn't tracking anything.
I'll send patches for this; if/when both land, track_flush_slot() can be deleted
on top.
