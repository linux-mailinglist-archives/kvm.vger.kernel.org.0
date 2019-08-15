Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E058EF40
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfHOPXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 11:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbfHOPXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 11:23:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1A05CC06511D;
        Thu, 15 Aug 2019 15:23:25 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF9E095A42;
        Thu, 15 Aug 2019 15:23:24 +0000 (UTC)
Date:   Thu, 15 Aug 2019 09:23:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190815092324.46bb3ac1@x1.home>
In-Reply-To: <20190813201914.GI13991@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
        <20190205210137.1377-11-sean.j.christopherson@intel.com>
        <20190813100458.70b7d82d@x1.home>
        <20190813170440.GC13991@linux.intel.com>
        <20190813115737.5db7d815@x1.home>
        <20190813133316.6fc6f257@x1.home>
        <20190813201914.GI13991@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 15 Aug 2019 15:23:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Aug 2019 13:19:14 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Tue, Aug 13, 2019 at 01:33:16PM -0600, Alex Williamson wrote:
> > On Tue, 13 Aug 2019 11:57:37 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:  
> 
> > Could it be something with the gfn test:
> > 
> >                         if (sp->gfn != gfn)
> >                                 continue;
> > 
> > If I remove it, I can't trigger the misbehavior.  If I log it, I only
> > get hits on VM boot/reboot and some of the gfns look suspiciously like
> > they could be the assigned GPU BARs and maybe MSI mappings:
> > 
> >                (sp->gfn) != (gfn)  
> 
> Hits at boot/reboot makes sense, memslots get zapped when userspace
> removes a memory region/slot, e.g. remaps BARs and whatnot.
> 
> ...
>  
> > Is this gfn optimization correct?  Overzealous?  Doesn't account
> > correctly for something about MMIO mappings?  Thanks,  
> 
> Yes?  Shadow pages are stored in a hash table, for_each_valid_sp() walks
> all entries for a given gfn.  The sp->gfn check is there to skip entries
> that hashed to the same list but for a completely different gfn.
> 
> Skipping the gfn check would be sort of a lightweight zap all in the
> sense that it would zap shadow pages that happend to collide with the
> target memslot/gfn but are otherwise unrelated.
> 
> What happens if you give just the GPU BAR at 0x80000000 a pass, i.e.:
> 
> 	if (sp->gfn != gfn && sp->gfn != 0x80000)
> 		continue;
> 
> If that doesn't work, it might be worth trying other gfns to see if you
> can pinpoint which sp is being zapped as collateral damage.
> 
> It's possible there is a pre-existing bug somewhere else that was being
> hidden because KVM was effectively zapping all SPTEs during (re)boot,
> and the hash collision is also hiding the bug by zapping the stale entry.
> 
> Of course it's also possible this code is wrong, :-)

Ok, fun day of trying to figure out which ranges are relevant, I've
narrowed it down to all of these:

0xffe00
0xfee00
0xfec00
0xc1000
0x80a000
0x800000
0x100000

ie. I can effective only say that sp->gfn values of 0x0, 0x40000, and
0x80000 can take the continue branch without seeing bad behavior in the
VM.

The assigned GPU has BARs at GPAs:

0xc0000000-0xc0ffffff
0x800000000-0x808000000
0x808000000-0x809ffffff

And the assigned companion audio function is at GPA:

0xc1080000-0xc1083fff

Only one of those seems to align very well with a gfn base involved
here.  The virtio ethernet has an mmio range at GPA 0x80a000000,
otherwise I don't find any other I/O devices coincident with the gfns
above.

I'm running the VM with 2MB hugepages, but I believe the issue still
occurs with standard pages.  When run with standard pages I see more
hits to gfn values 0, 0x40000, 0x80000, but the same number of hits to
the set above that cannot take the continue branch.  I don't know if
that means anything.

Any further ideas what to look for?  Thanks,

Alex

PS - I see the posted workaround patch, I'll test that in the interim.
