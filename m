Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E51396ACD
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 22:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfHTUmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 16:42:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729156AbfHTUmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 16:42:06 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DCA3A800DF2;
        Tue, 20 Aug 2019 20:42:05 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 764E05C1D6;
        Tue, 20 Aug 2019 20:42:05 +0000 (UTC)
Date:   Tue, 20 Aug 2019 14:42:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190820144204.161f49e0@x1.home>
In-Reply-To: <20190820200318.GA15808@linux.intel.com>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Tue, 20 Aug 2019 20:42:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Aug 2019 13:03:19 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Mon, Aug 19, 2019 at 06:03:05PM +0200, Paolo Bonzini wrote:
> > On 15/08/19 17:23, Alex Williamson wrote:
> > > 0xffe00
> > > 0xfee00
> > > 0xfec00
> > > 0xc1000
> > > 0x80a000
> > > 0x800000
> > > 0x100000
> > > 
> > > ie. I can effective only say that sp->gfn values of 0x0, 0x40000, and
> > > 0x80000 can take the continue branch without seeing bad behavior in the
> > > VM.
> > > 
> > > The assigned GPU has BARs at GPAs:
> > > 
> > > 0xc0000000-0xc0ffffff
> > > 0x800000000-0x808000000
> > > 0x808000000-0x809ffffff
> > > 
> > > And the assigned companion audio function is at GPA:
> > > 
> > > 0xc1080000-0xc1083fff
> > > 
> > > Only one of those seems to align very well with a gfn base involved
> > > here.  The virtio ethernet has an mmio range at GPA 0x80a000000,
> > > otherwise I don't find any other I/O devices coincident with the gfns
> > > above.
> > 
> > The IOAPIC and LAPIC are respectively gfn 0xfec00 and 0xfee00.  The
> > audio function BAR is only 16 KiB, so the 2 MiB PDE starting at 0xc1000
> > includes both userspace-MMIO and device-MMIO memory.  The virtio-net BAR
> > is also userspace-MMIO.
> > 
> > It seems like the problem occurs when the sp->gfn you "continue over"
> > includes a userspace-MMIO gfn.  But since I have no better ideas right
> > now, I'm going to apply the revert (we don't know for sure that it only
> > happens with assigned devices).
> 
> After many hours of staring, I've come to the conclusion that
> kvm_mmu_invalidate_zap_pages_in_memslot() is completely broken, i.e.
> a revert is definitely in order for 5.3 and stable.
> 
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
> 
> All that being said, it doesn't explain why gfns like 0xfec00 and 0xfee00
> were sensitive to (lack of) zapping.  My theory is that zapping what were
> effectively random-but-interesting shadow pages cleaned things up enough
> to avoid noticeable badness.
> 
> 
> Alex,
> 
> Can you please test the attached patch?  It implements a very slimmed down
> version of kvm_mmu_zap_all() to zap only shadow pages that can hold sptes
> pointing at the memslot being removed, which was the original intent of
> kvm_mmu_invalidate_zap_pages_in_memslot().  I apologize in advance if it
> crashes the host.  I'm hopeful it's correct, but given how broken the
> previous version was, I'm not exactly confident.

It doesn't crash the host, but the guest is not happy, failing to boot
the desktop in one case and triggering errors in the guest w/o even
running test programs in another case.  Seems like it might be worse
than previous.  Thanks,

Alex
