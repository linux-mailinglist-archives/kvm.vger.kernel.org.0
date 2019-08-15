Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2AA18F301
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 20:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732378AbfHOSQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 14:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfHOSQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 14:16:08 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFA9DC057E9F;
        Thu, 15 Aug 2019 18:16:07 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79B5D43FD5;
        Thu, 15 Aug 2019 18:16:07 +0000 (UTC)
Date:   Thu, 15 Aug 2019 12:16:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190815121607.29055aa2@x1.home>
In-Reply-To: <20190815160006.GC27076@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
        <20190205210137.1377-11-sean.j.christopherson@intel.com>
        <20190813100458.70b7d82d@x1.home>
        <20190813170440.GC13991@linux.intel.com>
        <20190813115737.5db7d815@x1.home>
        <20190813133316.6fc6f257@x1.home>
        <20190813201914.GI13991@linux.intel.com>
        <20190815092324.46bb3ac1@x1.home>
        <20190815160006.GC27076@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 15 Aug 2019 18:16:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Aug 2019 09:00:06 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Thu, Aug 15, 2019 at 09:23:24AM -0600, Alex Williamson wrote:
> > Ok, fun day of trying to figure out which ranges are relevant, I've
> > narrowed it down to all of these:
> > 
> > 0xffe00
> > 0xfee00
> > 0xfec00  
> 
> APIC and I/O APIC stuff
> 
> > 0xc1000  
> 
> Assigned audio
> 
> > 0x80a000  
> 
> ?
> 
> > 0x800000  
> 
> GPU BAR
> 
> > 0x100000  
> 
> ?
> 
> The APIC ranges are puzzling, I wouldn't expect their mappings to change.
> 
> > ie. I can effective only say that sp->gfn values of 0x0, 0x40000, and
> > 0x80000 can take the continue branch without seeing bad behavior in the
> > VM.
> > 
> > The assigned GPU has BARs at GPAs:
> > 
> > 0xc0000000-0xc0ffffff
> > 0x800000000-0x808000000
> > 0x808000000-0x809ffffff
> > 
> > And the assigned companion audio function is at GPA:
> > 
> > 0xc1080000-0xc1083fff
> > 
> > Only one of those seems to align very well with a gfn base involved
> > here.  The virtio ethernet has an mmio range at GPA 0x80a000000,
> > otherwise I don't find any other I/O devices coincident with the gfns
> > above.
> > 
> > I'm running the VM with 2MB hugepages, but I believe the issue still
> > occurs with standard pages.  When run with standard pages I see more
> > hits to gfn values 0, 0x40000, 0x80000, but the same number of hits to
> > the set above that cannot take the continue branch.  I don't know if
> > that means anything.
> > 
> > Any further ideas what to look for?  Thanks,  
> 
> Maybe try isolating which memslot removal causes problems?  E.g. flush
> the affected ranges if base_gfn == (xxx || yyy || zzz), otherwise flush
> only the memslot's gfns.  Based on the log you sent a while back for gfn
> mismatches, I'm guessing the culprits are all GPU BARs, but it's
> probably worth confirming.  That might also explain why gfn == 0x80000
> can take the continue branch, i.e. if removing the corresponding memslot
> is what's causing problems, then it's being flushed and not actually
> taking the continue path.

If I print out the memslot base_gfn, it seems pretty evident that only
the assigned device mappings are triggering this branch.  The base_gfns
exclusively include:

 0x800000
 0x808000
 0xc0089

Where the first two clearly match the 64bit BARs and the last is the
result of a page that we need to emulate within the BAR @0xc0000000 at
offset 0x88000, so the base_gfn is the remaining direct mapping.

I don't know if this implies we're doing something wrong for assigned
device slots, but maybe a more targeted workaround would be if we could
specifically identify these slots, though there's no special
registration of them versus other slots.  Did you have any non-device
assignment test cases that took this branch when developing the series?

> One other thought would be to force a call to kvm_flush_remote_tlbs(kvm),
> e.g. set flush=true just before the final kvm_mmu_remote_flush_or_zap().
> Maybe it's a case where there are no SPTEs for the memslot, but the TLB
> flush is needed for some reason.

This doesn't work.  Thanks,

Alex
