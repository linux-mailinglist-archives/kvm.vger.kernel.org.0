Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E14F226ABD
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgGTPtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 11:49:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:15340 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730323AbgGTPtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 11:49:02 -0400
IronPort-SDR: BvuDZ+SPlKVaLJx6+/aKqKeQgXYY2ti5hNTdyhoX/hTKeq/iz+GMUEBuXnvlWxjFSF+NREU1fO
 YQ746wigTttg==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="137421508"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="137421508"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 08:49:01 -0700
IronPort-SDR: 7wECZeH+4V6J/w8tD6ovrEfw1IVToSyHYmVF84XubtXmmukXKIrSDjYiYgPqtaCZUnkyRCGvKV
 vnylDxykbamg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="362055695"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 20 Jul 2020 08:49:01 -0700
Date:   Mon, 20 Jul 2020 08:49:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     contact@kevinloughlin.org
Cc:     kvm@vger.kernel.org
Subject: Re: x86 MMU: RMap Interface
Message-ID: <20200720154901.GB20375@linux.intel.com>
References: <d49ad8fb155e2ebc6e54d8b83c335926@kevinloughlin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d49ad8fb155e2ebc6e54d8b83c335926@kevinloughlin.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 19, 2020 at 06:32:22PM -0400, contact@kevinloughlin.org wrote:
> Hi,
> 
> I'm a bit confused by the interface for interacting with the page rmap. For
> context, on a TDP-enabled x86-64 host, I'm logging each time a GFN->PFN
> mapping is created/modified/removed for a non-MMIO page (kernel version
> 5.4).
> 
> First, my understanding is that the page rmap is a mapping of non-MMIO PFNs
> back to the GFNs that use them. The interface for creating an rmap entry
> (and thus, a new GFN->PFN mapping) appears to be rmap_add() and is quite
> straightforward. However, rmap_remove() does not appear to be the (only)
> function for removing an entry from the page rmap. For instance,
> kvm_zap_rmapp()---used by the mmu_notifier for invalidations---jumps
> straight to pte_list_remove(), while drop_spte() uses rmap_remove().

The rmaps are associated with the memslot, the drop_spte() path allows KVM
to clean up SPTEs without having to guarantee the validity of the memslot
that was used to create the SPTE.

> Would it be fair to say that mmu_spte_clear_track_bits() is found on all
> paths for removing an entry from the page rmap?

Yes, that should hold true.
 
> Second, for updates to the frame numbers in an existing SPTE, there are both
> mmu_set_spte() and mmu_spte_set(). Could someone please clarify the
> difference between these functions?

mmu_set_spte() is the higher level helper that is used during a page fault
or prefetch to convert a host PFN and basic access permissions into a SPTE
value, handle large/huge page interactions and accounting, add the rmap,
etc..., and of course eventually update the SPTE.

mmu_spte_set() is a low level helper that does nothing more than write a
SPTE.  It's just a wrapper to __set_spte() that also WARNs if the old SPTE
is present.

> Finally, much of the logic between the page rmap and parent PTE rmaps
> (understandably) overlaps. However, with TDP-enabled, I'm not entirely sure
> what the role of the parent PTE rmaps is relative to the page rmap. Could
> someone possibly clarify?

KVM needs the backpointers to remove the SPTE for a shadow page, which
exists in the parent shadow page, when the child is zapped, e.g. if a L2 SP
is removed, its SPTE in a L3 SP needs to be updated.
