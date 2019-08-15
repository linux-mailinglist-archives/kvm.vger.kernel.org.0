Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C03A8F583
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 22:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbfHOULO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 16:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbfHOULN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 16:11:13 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A639A316D8D2;
        Thu, 15 Aug 2019 20:11:13 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40EFA5C219;
        Thu, 15 Aug 2019 20:11:13 +0000 (UTC)
Date:   Thu, 15 Aug 2019 14:11:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190815141112.1c11b115@x1.home>
In-Reply-To: <20190815192531.GE27076@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
        <20190205210137.1377-11-sean.j.christopherson@intel.com>
        <20190813100458.70b7d82d@x1.home>
        <20190813170440.GC13991@linux.intel.com>
        <20190813115737.5db7d815@x1.home>
        <20190813133316.6fc6f257@x1.home>
        <20190813201914.GI13991@linux.intel.com>
        <20190815092324.46bb3ac1@x1.home>
        <20190815160006.GC27076@linux.intel.com>
        <20190815121607.29055aa2@x1.home>
        <20190815192531.GE27076@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 15 Aug 2019 20:11:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Aug 2019 12:25:31 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Thu, Aug 15, 2019 at 12:16:07PM -0600, Alex Williamson wrote:
> > On Thu, 15 Aug 2019 09:00:06 -0700
> > Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > If I print out the memslot base_gfn, it seems pretty evident that only
> > the assigned device mappings are triggering this branch.  The base_gfns
> > exclusively include:
> > 
> >  0x800000
> >  0x808000
> >  0xc0089
> > 
> > Where the first two clearly match the 64bit BARs and the last is the
> > result of a page that we need to emulate within the BAR @0xc0000000 at
> > offset 0x88000, so the base_gfn is the remaining direct mapping.  
> 
> That's consistent with my understanding of userspace, e.g. normal memory
> regions aren't deleted until the VM is shut down (barring hot unplug).
> 
> > I don't know if this implies we're doing something wrong for assigned
> > device slots, but maybe a more targeted workaround would be if we could
> > specifically identify these slots, though there's no special
> > registration of them versus other slots.  
> 
> What is triggering the memslot removal/update?  Is it possible that
> whatever action is occuring is modifying multiple memslots?  E.g. KVM's
> memslot-only zapping is allowing the guest to access stale entries for
> the unzapped-but-related memslots, whereas the full zap does not.
> 
> FYI, my VFIO/GPU/PCI knowledge is abysmal, please speak up if any of my
> ideas are nonsensical.

The memory bit in the PCI command register of config space for each
device controls whether the device decoders are active for the MMIO BAR
ranges.  These get flipped as both the guest firmware and guest OS
enumerate and assign resources to the PCI subsystem.  Generally these
are not further manipulated while the guest OS is running except for
hotplug operations.  The guest OS device driver will generally perform
the final enable of these ranges and they'll remain enabled until the
guest is rebooted.

I recall somewhere in this thread you referenced reading the ROM as
part of the performance testing of this series.  The ROM has it's own
enable bit within the ROM BAR as the PCI spec allows devices to share
decoders between the standard BARs and the ROM BAR.  Enabling and
disabling the enable bit in the ROM BAR should be very similar in
memslot behavior to the overall memory enable bit for the other BARs
within the device.

Note that often the faults that I'm seeing occur a long time after BAR
mappings are finalized, usually (not always) the VM boots to a fully
functional desktop and it's only as I run various tests do the glitches
start to appear.  For instance, when I allowed sp->gfn 0xfec00 to take
the continue branch, I got an OpenCL error.  For either 0xffee00 or
0xc1000 I got graphics glitches, for example stray geometric artifacts
flashed on the screen.  For 0x100000 and 0x800000 I'd get a black
screen or blank 3D graphics window.  For 0x80a000 the VM froze
(apparently).  I can't say whether each of these is a consistent failure
mode, I only tested to the point of determining whether a range
generates an error.

> > Did you have any non-device
> > assignment test cases that took this branch when developing the series?  
> 
> The primary testing was performance oriented, using a slightly modified
> version of a synthetic benchmark[1] from a previous series[2] that touched
> the memslot flushing flow.  From a functional perspective, I highly doubt
> that test would have been able expose an improper zapping bug.

:-\

It seems like there's probably some sort of inflection point where it
becomes faster to zap all pages versus the overhead of walking every
page in a memory slot, was that evaluated?  Not sure if that's relevant
here, but curious.  Thanks,

Alex
