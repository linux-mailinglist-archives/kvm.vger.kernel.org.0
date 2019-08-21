Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EADC98497
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 21:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfHUTfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 15:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbfHUTfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 15:35:06 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EFB85AFE9;
        Wed, 21 Aug 2019 19:35:05 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32AFE17D69;
        Wed, 21 Aug 2019 19:35:05 +0000 (UTC)
Date:   Wed, 21 Aug 2019 13:35:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190821133504.79b87767@x1.home>
In-Reply-To: <20190821130859.4330bcf4@x1.home>
References: <20190205210137.1377-11-sean.j.christopherson@intel.com>
        <20190813100458.70b7d82d@x1.home>
        <20190813170440.GC13991@linux.intel.com>
        <20190813115737.5db7d815@x1.home>
        <20190813133316.6fc6f257@x1.home>
        <20190813201914.GI13991@linux.intel.com>
        <20190815092324.46bb3ac1@x1.home>
        <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
        <20190820200318.GA15808@linux.intel.com>
        <20190820144204.161f49e0@x1.home>
        <20190820210245.GC15808@linux.intel.com>
        <20190821130859.4330bcf4@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 21 Aug 2019 19:35:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Aug 2019 13:08:59 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 20 Aug 2019 14:02:45 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> > On Tue, Aug 20, 2019 at 02:42:04PM -0600, Alex Williamson wrote:  
> > > On Tue, 20 Aug 2019 13:03:19 -0700
> > > Sean Christopherson <sean.j.christopherson@intel.com> wrote:    
> > > > All that being said, it doesn't explain why gfns like 0xfec00 and 0xfee00
> > > > were sensitive to (lack of) zapping.  My theory is that zapping what were
> > > > effectively random-but-interesting shadow pages cleaned things up enough
> > > > to avoid noticeable badness.
> > > > 
> > > > 
> > > > Alex,
> > > > 
> > > > Can you please test the attached patch?  It implements a very slimmed down
> > > > version of kvm_mmu_zap_all() to zap only shadow pages that can hold sptes
> > > > pointing at the memslot being removed, which was the original intent of
> > > > kvm_mmu_invalidate_zap_pages_in_memslot().  I apologize in advance if it
> > > > crashes the host.  I'm hopeful it's correct, but given how broken the
> > > > previous version was, I'm not exactly confident.    
> > > 
> > > It doesn't crash the host, but the guest is not happy, failing to boot
> > > the desktop in one case and triggering errors in the guest w/o even
> > > running test programs in another case.  Seems like it might be worse
> > > than previous.  Thanks,    
> > 
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
> 
> From there I added back the gfn range test, but I left out the gfn_mask
> because I'm not doing the level filtering and I think(?) this is just
> another optimization.  So essentially I only add:
> 
> 	if (sp->gfn < slot->base_gfn ||
>             sp->gfn > (slot->base_gfn + slot->npages - 1))
> 		continue;
> 
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
> premise of this change or have I done something stupid?

Seems the latter, particularly your comment that we're looking for
pages pointing to the gfn range to be removed, not just those in the
range.  Slot gfn ranges like ffe00-ffe1f are getting reduced to 0-0 or
c0000-c0000, zapping zero or c0000, and I think one of the ones you
were looking for c1080-c1083 is reduce to c1000-c1000 and therefore
zaps sp->gfn c1000.  I'll keep looking.  Thanks,

Alex
