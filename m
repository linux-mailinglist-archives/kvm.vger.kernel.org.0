Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F9B98542
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 22:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfHUUKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 16:10:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:58029 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfHUUKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 16:10:44 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 13:10:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="172887634"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 21 Aug 2019 13:10:43 -0700
Date:   Wed, 21 Aug 2019 13:10:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190821201043.GI29345@linux.intel.com>
References: <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20190820144204.161f49e0@x1.home>
 <20190820210245.GC15808@linux.intel.com>
 <20190821130859.4330bcf4@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821130859.4330bcf4@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 01:08:59PM -0600, Alex Williamson wrote:
> On Tue, 20 Aug 2019 14:02:45 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> > Hrm, I'm back to being completely flummoxed.
> > 
> > Would you be able to generate a trace of all events/kvmmmu, using the
> > latest patch?  I'd like to rule out a stupid code bug if it's not too
> > much trouble.
> 
> I tried to simplify the patch, making it closer to zap_all, so I
> removed the max_level calculation and exclusion based on s->role.level,
> as well as the gfn range filtering.  For good measure I even removed
> the sp->root_count test, so any sp not marked invalid is zapped.  This
> works, and I can also add back the sp->root_count test and things
> remain working.

The sp->root_count test is necessary to avoid an infinite loop when not
using tdp, e.g. EPT.  The root sp can't be moved off active_mmu_pages and
thus freed until all references to the root are gone.  When not using tdp,
the loop can restart in response to __kvm_mmu_prepare_zap_page(), even if
the root sp page was already invalid.

Functionally, skipping an invalid sp *shouldn't* change anything, as the
actual ptes have been zapped, it's only the kernel resources that aren't
yet freed.

TL;DR: completely expected that removing the sp->root_count didn't
affect the result.

> From there I added back the gfn range test, but I left out the gfn_mask
> because I'm not doing the level filtering and I think(?) this is just
> another optimization.  So essentially I only add:
> 
> 	if (sp->gfn < slot->base_gfn ||
>             sp->gfn > (slot->base_gfn + slot->npages - 1))
> 		continue;

This doesn't work because of what sp->gfn contains.  The shadow page is
the page/table holding the spt entries, e.g. a level 1 sp refers to a page
table for entries defining 4k pages.  sp->gfn holds the base gfn of the
range of gfns covered by the sp, which allows finding all parent sps for a
given gfn.  E.g. for level 1 sp, sp->gfn is found by masking the gfn of a
given page by 0xFFFFFFFFFFFFFE00, level 2 sp by 0xFFFFFFFFFFFC0000, and so
on up the chain.

This is what the original code botched, as it would only find all sps for
a memslot if the base of the memslot were 2mb aligned for 4k pages, 1gb
aligned for 2mb pages, etc...  This just happened to mostly work since
memslots are usually aligned to such requirements.  In the original code,
removing the "sp->gfn != gfn" check caused KVM to zap random sps that just
happened to hash to the same entry.  Likewise, omitting the gfn filter in
this code means everything gets zapped.

What I don't understand is why zapping everything, or at least userspace
MMIO addresses, is necessary when removing the GPU BAR memslot.  The
IOAPIC sp in particular makes no sense.  AIUI, the IOAPIC is always
emulated, i.e. not passed through, and its base/size is static (or at
least static after init).  Zapping an IOAPIC sp will send KVM down
different paths but AFAIK the final outsome should be unaffected.

> Not only does this not work, the host will sometimes oops:
> 
> [  808.541168] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  808.555065] #PF: supervisor read access in kernel mode
> [  808.565326] #PF: error_code(0x0000) - not-present page
> [  808.575588] PGD 0 P4D 0 
> [  808.580649] Oops: 0000 [#1] SMP PTI
> [  808.587617] CPU: 3 PID: 1965 Comm: CPU 0/KVM Not tainted 5.3.0-rc4+ #4
> [  808.600652] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> [  808.618907] RIP: 0010:gfn_to_rmap+0xd9/0x120 [kvm]
> [  808.628472] Code: c7 48 8d 0c 80 48 8d 04 48 4d 8d 14 c0 49 8b 02 48 39 c6 72 15 49 03 42 08 48 39 c6 73 0c 41 89 b9 08 b4 00 00 49 8b 3a eb 0b <48> 8b 3c 25 00 00 00 00 45 31 d2 0f b6 42 24 83 e0 0f 83 e8 01 8d
> [  808.665945] RSP: 0018:ffffa888009a3b20 EFLAGS: 00010202
> [  808.676381] RAX: 00000000000c1040 RBX: ffffa888007d5000 RCX: 0000000000000014
> [  808.690628] RDX: ffff8eadd0708260 RSI: 00000000000c1080 RDI: 0000000000000004
> [  808.704877] RBP: ffff8eadc3d11400 R08: ffff8ead97cf0008 R09: ffff8ead97cf0000
> [  808.719124] R10: ffff8ead97cf0168 R11: 0000000000000004 R12: ffff8eadd0708260
> [  808.733374] R13: ffffa888007d5000 R14: 0000000000000000 R15: 0000000000000004
> [  808.747620] FS:  00007f28dab7c700(0000) GS:ffff8eb19f4c0000(0000) knlGS:0000000000000000
> [  808.763776] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  808.775249] CR2: 0000000000000000 CR3: 000000003f508006 CR4: 00000000001626e0
> [  808.789499] Call Trace:
> [  808.794399]  drop_spte+0x77/0xa0 [kvm]
> [  808.801885]  mmu_page_zap_pte+0xac/0xe0 [kvm]
> [  808.810587]  __kvm_mmu_prepare_zap_page+0x69/0x350 [kvm]
> [  808.821196]  kvm_mmu_invalidate_zap_pages_in_memslot+0x87/0xf0 [kvm]
> [  808.833881]  kvm_page_track_flush_slot+0x55/0x80 [kvm]
> [  808.844140]  __kvm_set_memory_region+0x821/0xaa0 [kvm]
> [  808.854402]  kvm_set_memory_region+0x26/0x40 [kvm]
> [  808.863971]  kvm_vm_ioctl+0x59a/0x940 [kvm]
> [  808.872318]  ? pagevec_lru_move_fn+0xb8/0xd0
> [  808.880846]  ? __seccomp_filter+0x7a/0x680
> [  808.889028]  do_vfs_ioctl+0xa4/0x630
> [  808.896168]  ? security_file_ioctl+0x32/0x50
> [  808.904695]  ksys_ioctl+0x60/0x90
> [  808.911316]  __x64_sys_ioctl+0x16/0x20
> [  808.918807]  do_syscall_64+0x5f/0x1a0
> [  808.926121]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  808.936209] RIP: 0033:0x7f28ebf2b0fb
> 
> Does this suggests something is still fundamentally wrong with the
> premise of this change or have I done something stupid?  Thanks,

The NULL pointer thing is unexpected, it means we have a spte, i.e. the
actual entry seen/used by hardware, that KVM thinks is present but doesn't
have the expected KVM tracking.  I'll take a look, my understanding is
that zapping shadow pages at random shouldn't cause problems.
