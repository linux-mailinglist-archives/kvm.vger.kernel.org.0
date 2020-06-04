Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835121EDC1B
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 06:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgFDELL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 00:11:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31821 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725959AbgFDELL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 00:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591243868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pJYQiOc0xX40urKPDpngXkAXxVxxYqFmS7EXvpDIHMs=;
        b=jIe8qjjSQxsC7pQ1nMqImyZNlvkiIPQfn6hcCPM5Yid+FhrmOoATHCyyDThL72oDK/iIWC
        fSiweE6ngOg1z5PFLAieqbVLXppwJtCDzgOxmWgzaowjMIKGy5tg+65o2FXe1VkMCoJioL
        usulZfTSe4b05ehtaYqfnqpZriVlUM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-98e8rTb1N728VQ1_xIJy2g-1; Thu, 04 Jun 2020 00:11:01 -0400
X-MC-Unique: 98e8rTb1N728VQ1_xIJy2g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96CE7835B41;
        Thu,  4 Jun 2020 04:10:59 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9617D78F19;
        Thu,  4 Jun 2020 04:10:58 +0000 (UTC)
Date:   Wed, 3 Jun 2020 22:10:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Message-ID: <20200603221058.1927a0fc@x1.home>
In-Reply-To: <20200604024228.GD12300@joy-OptiPlex-7040>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
        <20200518025245.14425-1-yan.y.zhao@intel.com>
        <20200529154547.19a6685f@x1.home>
        <20200601065726.GA5906@joy-OptiPlex-7040>
        <20200601104307.259b0fe1@x1.home>
        <20200602082858.GA8915@joy-OptiPlex-7040>
        <20200602133435.1ab650c5@x1.home>
        <20200603014058.GA12300@joy-OptiPlex-7040>
        <20200603170452.7f172baf@x1.home>
        <20200604024228.GD12300@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Jun 2020 22:42:28 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Wed, Jun 03, 2020 at 05:04:52PM -0600, Alex Williamson wrote:
> > On Tue, 2 Jun 2020 21:40:58 -0400
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Tue, Jun 02, 2020 at 01:34:35PM -0600, Alex Williamson wrote:  
> > > > I'm not at all happy with this.  Why do we need to hide the migration
> > > > sparse mmap from the user until migration time?  What if instead we
> > > > introduced a new VFIO_REGION_INFO_CAP_SPARSE_MMAP_SAVING capability
> > > > where the existing capability is the normal runtime sparse setup and
> > > > the user is required to use this new one prior to enabled device_state
> > > > with _SAVING.  The vendor driver could then simply track mmap vmas to
> > > > the region and refuse to change device_state if there are outstanding
> > > > mmaps conflicting with the _SAVING sparse mmap layout.  No new IRQs
> > > > required, no new irqfds, an incremental change to the protocol,
> > > > backwards compatible to the extent that a vendor driver requiring this
> > > > will automatically fail migration.
> > > >     
> > > right. looks we need to use this approach to solve the problem.
> > > thanks for your guide.
> > > so I'll abandon the current remap irq way for dirty tracking during live
> > > migration.
> > > but anyway, it demos how to customize irq_types in vendor drivers.
> > > then, what do you think about patches 1-5?  
> > 
> > In broad strokes, I don't think we've found the right solution yet.  I
> > really question whether it's supportable to parcel out vfio-pci like
> > this and I don't know how I'd support unraveling whether we have a bug
> > in vfio-pci, the vendor driver, or how the vendor driver is making use
> > of vfio-pci.
> >
> > Let me also ask, why does any of this need to be in the kernel?  We
> > spend 5 patches slicing up vfio-pci so that we can register a vendor
> > driver and have that vendor driver call into vfio-pci as it sees fit.
> > We have two patches creating device specific interrupts and a BAR
> > remapping scheme that we've decided we don't need.  That brings us to
> > the actual i40e vendor driver, where the first patch is simply making
> > the vendor driver work like vfio-pci already does, the second patch is
> > handling the migration region, and the third patch is implementing the
> > BAR remapping IRQ that we decided we don't need.  It's difficult to
> > actually find the small bit of code that's required to support
> > migration outside of just dealing with the protocol we've defined to
> > expose this from the kernel.  So why are we trying to do this in the
> > kernel?  We have quirk support in QEMU, we can easily flip
> > MemoryRegions on and off, etc.  What access to the device outside of
> > what vfio-pci provides to the user, and therefore QEMU, is necessary to
> > implement this migration support for i40e VFs?  Is this just an
> > exercise in making use of the migration interface?  Thanks,
> >   
> hi Alex
> 
> There was a description of intention of this series in RFC v1
> (https://www.spinics.net/lists/kernel/msg3337337.html).
> sorry, I didn't include it in starting from RFC v2.
> 
> "
> The reason why we don't choose the way of writing mdev parent driver is
> that

I didn't mention an mdev approach, I'm asking what are we accomplishing
by doing this in the kernel at all versus exposing the device as normal
through vfio-pci and providing the migration support in QEMU.  Are you
actually leveraging having some sort of access to the PF in supporting
migration of the VF?  Is vfio-pci masking the device in a way that
prevents migrating the state from QEMU?

> (1) VFs are almost all the time directly passthroughed. Directly binding
> to vfio-pci can make most of the code shared/reused. If we write a
> vendor specific mdev parent driver, most of the code (like passthrough
> style of rw/mmap) still needs to be copied from vfio-pci driver, which is
> actually a duplicated and tedious work.
> (2) For features like dynamically trap/untrap pci bars, if they are in
> vfio-pci, they can be available to most people without repeated code
> copying and re-testing.
> (3) with a 1:1 mdev driver which passes through VFs most of the time, people
> have to decide whether to bind VFs to vfio-pci or mdev parent driver before
> it runs into a real migration need. However, if vfio-pci is bound
> initially, they have no chance to do live migration when there's a need
> later.
> "
> particularly, there're some devices (like NVMe) they purely reply on
> vfio-pci to do device pass-through and they have no standalone parent driver
> to do mdev way.
> 
> I think live migration is a general requirement for most devices and to
> interact with the migration interface requires vendor drivers to do
> device specific tasks like geting/seting device state, starting/stopping
> devices, tracking dirty data, report migration capabilities... all those
> works need be in kernel.

I think Alex Graf proved they don't necessarily need to be done in
kernel back in 2015: https://www.youtube.com/watch?v=4RFsSgzuFso
He was able to achieve i40e VF live migration by only hacking QEMU.  In
this series you're allowing a vendor driver to interpose itself between
the user (QEMU) and vfio-pci such that we switch to the vendor code
during migration.  Why can't that interpose layer be in QEMU rather
than the kernel?  It seems that it only must be in the kernel if we
need to provide migration state via backdoor, perhaps like going
through the PF.  So what access to the i40e VF device is not provided to
the user through vfio-pci that is necessary to implement migration of
this device?  The tasks listed above are mostly standard device driver
activities and clearly vfio-pci allows userspace device drivers.

> do you think it's better to create numerous vendor quirks in vfio-pci?

In QEMU, perhaps.  Alternatively, let's look at exactly what access is
not provided through vfio-pci that's necessary for this and decide if
we want to enable that access or if cracking vfio-pci wide open for
vendor drivers to pick and choose when and how to use it is really the
right answer.

> as to this series, though patch 9/10 currently only demos reporting a
> migration region, it actually shows the capability iof vendor driver to
> customize device regions. e.g. in patch 10/10, it customizes the BAR0 to
> be read/write. and though we abandoned the REMAP BAR irq_type in patch
> 10/10 for migration purpose, I have to say this irq_type has its usage
> in other use cases, where synchronization is not a hard requirement and
> all it needs is a notification channel from kernel to use. this series
> just provides a possibility for vendors to customize device regions and
> irqs.

I don't disagree that a device specific interrupt might be useful, but
I would object to implementing this one only as an artificial use case.
We can wait for a legitimate use case to implement that.

> for interfaces exported in patch 3/10-5/10, they anyway need to be
> exported for writing mdev parent drivers that pass through devices at
> normal time to avoid duplication. and yes, your worry about

Where are those parent drivers?  What are their actual requirements?

> identification of bug sources is reasonable. but if a device is binding
> to vfio-pci with a vendor module loaded, and there's a bug, they can do at
> least two ways to identify if it's a bug in vfio-pci itself.
> (1) prevent vendor modules from loading and see if the problem exists
> with pure vfio-pci.
> (2) do what's demoed in patch 8/10, i.e. do nothing but simply pass all
> operations to vfio-pci.

The code split is still extremely ad-hoc, there's no API.  An mdev
driver isn't even a sub-driver of vfio-pci like you're trying to
accomplish here, there would need to be a much more defined API when
the base device isn't even a vfio_pci_device.  I don't see how this
series would directly enable an mdev use case.

> so, do you think this series has its merit and we can continue improving
> it?

I think this series is trying to push an artificial use case that is
perhaps better done in userspace.  What is the actual interaction with
the VF device that can only be done in the host kernel for this
example?  Thanks,

Alex

