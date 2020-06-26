Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21FB20B712
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 19:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgFZRcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 13:32:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:60379 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgFZRcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 13:32:51 -0400
IronPort-SDR: oDDpGQ9DkD2yhajW3T0Nw4HdzOwTRuneL1APYHIpUni0A5+NDB3hSaGolxLHmQ+d0647rznA7z
 Y8905fz8Qlbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="143636123"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="143636123"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 10:32:50 -0700
IronPort-SDR: 683zrk3+/N0PzTLuVyGiqSJ0I1/gZCPh8DgZ/lJ9MLkP64scatxeS6cNssvvj5JvvQhpLiZREg
 jxFCqGc+HRLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="354832808"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 26 Jun 2020 10:32:50 -0700
Date:   Fri, 26 Jun 2020 10:32:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20200626173250.GD6583@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820200318.GA15808@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

/cast <thread necromancy>

On Tue, Aug 20, 2019 at 01:03:19PM -0700, Sean Christopherson wrote:
> On Mon, Aug 19, 2019 at 06:03:05PM +0200, Paolo Bonzini wrote:
> > It seems like the problem occurs when the sp->gfn you "continue over"
> > includes a userspace-MMIO gfn.  But since I have no better ideas right
> > now, I'm going to apply the revert (we don't know for sure that it only
> > happens with assigned devices).
> 
> After many hours of staring, I've come to the conclusion that
> kvm_mmu_invalidate_zap_pages_in_memslot() is completely broken, i.e.
> a revert is definitely in order for 5.3 and stable.

Whelp, past me was wrong.  The patch wasn't completely broken, as the rmap
zapping piece of kvm_mmu_invalidate_zap_pages_in_memslot() was sufficient
to satisfy removal of the memslot.  I.e. zapping leaf PTEs (including large
pages) should prevent referencing the old memslot, the fact that zapping
upper level shadow pages was broken was irrelevant because there should be
no need to zap non-leaf PTEs.

The one thing that sticks out as potentially concerning is passing %false
for @lock_flush_tlb.  Dropping mmu_lock during slot_handle_level_range()
without flushing would allow a vCPU to create and use a new entry while a
different vCPU has the old entry cached in its TLB.  I think that could
even happen with a single vCPU if the memslot is deleted by a helper task,
and the zapped page was a large page that was fractured into small pages
when inserted into the TLB.

TL;DR: Assuming no other bugs in the kernel, this should be sufficient if
the goal is simply to prevent usage of a memslot:

static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
			struct kvm_memory_slot *slot,
			struct kvm_page_track_notifier_node *node)
{
	bool flush;

	spin_lock(&kvm->mmu_lock);
	flush = slot_handle_all_level(kvm, slot, kvm_zap_rmapp, true);
	if (flush)
		kvm_flush_remote_tlbs(kvm);
	spin_unlock(&
}

> mmu_page_hash is indexed by the gfn of the shadow pages, not the gfn of
> the shadow ptes, e.g. for_each_valid_sp() will find page tables, page
> directories, etc...  Passing in the raw gfns of the memslot doesn't work
> because the gfn isn't properly adjusted/aligned to match how KVM tracks
> gfns for shadow pages, e.g. removal of the companion audio memslot that
> occupies gfns 0xc1080 - 0xc1083 would need to query gfn 0xc1000 to find
> the shadow page table containing the relevant sptes.
> 
> This is why Paolo's suggestion to remove slot_handle_all_level() on
> kvm_zap_rmapp() caused a BUG(), as zapping the rmaps cleaned up KVM's
> accounting without actually zapping the relevant sptes.

This is just straight up wrong, zapping the rmaps does zap the leaf sptes.
The BUG() occurs because gfn_to_rmap() works on the _new_ memslots instance,
and if a memslot is being deleted there is no memslot for the gfn, hence the
NULL pointer bug when mmu_page_zap_pte() attempts to zap a PTE.  Zapping the
rmaps (leaf/last PTEs) first "fixes" the issue by making it so that
mmu_page_zap_pte() will never see a present PTE for a non-existent meslot.

I don't think any of this explains the pass-through GPU issue.  But, we
have a few use cases where zapping the entire MMU is undesirable, so I'm
going to retry upstreaming this patch as with per-VM opt-in.  I wanted to
set the record straight for posterity before doing so.
