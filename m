Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199893AA46B
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 21:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbhFPTlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 15:41:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229951AbhFPTls (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Jun 2021 15:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623872381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y9FuMG3m1xKRK/z+Xy2lSS5E6ix0RsnQzrGrDQMmVyQ=;
        b=d6oRV7OvMCKB3A30eMGgxuTR/D8JqrpoK5VP7knIw+OsXpQprftWWavJgMzt30b+YtlL5l
        rRnP8Xdlp68rQ7XmIKlk78bXd1QT0ycJBGUmOpQAaHFpLCYUB9QAmgQhwYJN5jaSw4q1rc
        KbaS8xmCG9otaYVBSTv9bse2RDnprwk=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-hvEcSkrvNlGLz-pxwG9Wlw-1; Wed, 16 Jun 2021 15:39:40 -0400
X-MC-Unique: hvEcSkrvNlGLz-pxwG9Wlw-1
Received: by mail-oi1-f199.google.com with SMTP id y137-20020aca4b8f0000b02901f1fb748c74so1634354oia.21
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 12:39:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=y9FuMG3m1xKRK/z+Xy2lSS5E6ix0RsnQzrGrDQMmVyQ=;
        b=VuDJc6gtvvLZlIix6iqSy622JpAbYZjrAX2dvMW6ckXAqY4U9BdxL9qdiiK3xphH/p
         4e1wgnlrOTRy6k9ZLBp2W3L4jcv9iOnZjMwkE/4wbYCHkD4XH3bjGnVLhqMKOuZJwYOD
         /M5b1M9y7O7zqcZJZEtqReldlrmfY99iJHyr7GV23+59PgZzqlFBLZp2OKqyMjAEISky
         smD/6HXEy+pOESyXXGj8G+aLnq8fmzzH4ZXAS1vuITuTZQkmQE/Us4o+QFmttnrcBpXO
         PYWyepk69ua+UY2YYN42glNYjbRg/Ys1AJuFjUFXAnwRoOl4eMER5raDzRY/QsiZfNYC
         LAoA==
X-Gm-Message-State: AOAM530dm80EVhb+P+LFwrEWxZAhpCqA/j6CgPSXAI/uQxf09KvCJlcY
        PaY0mIhG4WqQEj/cpDkgUHxzeIzOQbGCuI4gPQVkhe/zFaqcru4dX8lfQfbXDNG809Vk7HNyKlK
        tL/SKuFwIRtGr
X-Received: by 2002:aca:b343:: with SMTP id c64mr766232oif.137.1623872379711;
        Wed, 16 Jun 2021 12:39:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjtI+/Fq5N9lE7q8HfQkpNywO/gAv0e0ihr/dLu1XDE8s6kC5y+Txq7hCDd8IsknRy6pT4DQ==
X-Received: by 2002:aca:b343:: with SMTP id c64mr766213oif.137.1623872379318;
        Wed, 16 Jun 2021 12:39:39 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id h193sm626704oib.3.2021.06.16.12.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:39:38 -0700 (PDT)
Date:   Wed, 16 Jun 2021 13:39:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210616133937.59050e1a.alex.williamson@redhat.com>
In-Reply-To: <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <20210611164529.GR1002214@nvidia.com>
        <20210611133828.6c6e8b29.alex.williamson@redhat.com>
        <20210612012846.GC1002214@nvidia.com>
        <20210612105711.7ac68c83.alex.williamson@redhat.com>
        <20210614140711.GI1002214@nvidia.com>
        <20210614102814.43ada8df.alex.williamson@redhat.com>
        <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210615101215.4ba67c86.alex.williamson@redhat.com>
        <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Jun 2021 06:43:23 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, June 16, 2021 12:12 AM
> > 
> > On Tue, 15 Jun 2021 02:31:39 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, June 15, 2021 12:28 AM
> > > >  
> > > [...]  
> > > > > IOASID. Today the group fd requires an IOASID before it hands out a
> > > > > device_fd. With iommu_fd the device_fd will not allow IOCTLs until it
> > > > > has a blocked DMA IOASID and is successefully joined to an iommu_fd.  
> > > >
> > > > Which is the root of my concern.  Who owns ioctls to the device fd?
> > > > It's my understanding this is a vfio provided file descriptor and it's
> > > > therefore vfio's responsibility.  A device-level IOASID interface
> > > > therefore requires that vfio manage the group aspect of device access.
> > > > AFAICT, that means that device access can therefore only begin when all
> > > > devices for a given group are attached to the IOASID and must halt for
> > > > all devices in the group if any device is ever detached from an IOASID,
> > > > even temporarily.  That suggests a lot more oversight of the IOASIDs by
> > > > vfio than I'd prefer.
> > > >  
> > >
> > > This is possibly the point that is worthy of more clarification and
> > > alignment, as it sounds like the root of controversy here.
> > >
> > > I feel the goal of vfio group management is more about ownership, i.e.
> > > all devices within a group must be assigned to a single user. Following
> > > the three rules defined by Jason, what we really care is whether a group
> > > of devices can be isolated from the rest of the world, i.e. no access to
> > > memory/device outside of its security context and no access to its
> > > security context from devices outside of this group. This can be achieved
> > > as long as every device in the group is either in block-DMA state when
> > > it's not attached to any security context or attached to an IOASID context
> > > in IOMMU fd.
> > >
> > > As long as group-level isolation is satisfied, how devices within a group
> > > are further managed is decided by the user (unattached, all attached to
> > > same IOASID, attached to different IOASIDs) as long as the user
> > > understands the implication of lacking of isolation within the group. This
> > > is what a device-centric model comes to play. Misconfiguration just hurts
> > > the user itself.
> > >
> > > If this rationale can be agreed, then I didn't see the point of having VFIO
> > > to mandate all devices in the group must be attached/detached in
> > > lockstep.  
> > 
> > In theory this sounds great, but there are still too many assumptions
> > and too much hand waving about where isolation occurs for me to feel
> > like I really have the complete picture.  So let's walk through some
> > examples.  Please fill in and correct where I'm wrong.  
> 
> Thanks for putting these examples. They are helpful for clearing the 
> whole picture.
> 
> Before filling in let's first align on what is the key difference between
> current VFIO model and this new proposal. With this comparison we'll
> know which of following questions are answered with existing VFIO
> mechanism and which are handled differently.
> 
> With Yi's help we figured out the current mechanism:
> 
> 1) vfio_group_viable. The code comment explains the intention clearly:
> 
> --
> * A vfio group is viable for use by userspace if all devices are in
>  * one of the following states:
>  *  - driver-less
>  *  - bound to a vfio driver
>  *  - bound to an otherwise allowed driver
>  *  - a PCI interconnect device
> --
> 
> Note this check is not related to an IOMMU security context.

Because this is a pre-requisite for imposing that IOMMU security
context.
 
> 2) vfio_iommu_group_notifier. When an IOMMU_GROUP_NOTIFY_
> BOUND_DRIVER event is notified, vfio_group_viable is re-evaluated.
> If the affected group was previously viable but now becomes not 
> viable, BUG_ON() as it implies that this device is bound to a non-vfio 
> driver which breaks the group isolation.

This notifier action is conditional on there being users of devices
within a secure group IOMMU context.

> 3) vfio_group_get_device_fd. User can acquire a device fd only after
> 	a) the group is viable;
> 	b) the group is attached to a container;
> 	c) iommu is set on the container (implying a security context
> 	    established);

The order is actually b) a) c) but arguably b) is a no-op until:

    d) a device fd is provided to the user
 
> The new device-centric proposal suggests:
> 
> 1) vfio_group_viable;
> 2) vfio_iommu_group_notifier;
> 3) block-DMA if a device is detached from previous domain (instead of
> switching back to default domain as today);

I'm literally begging for specifics in this thread, but none are
provided here.  What is the "previous domain"?  How is a device placed
into a DMA blocking IOMMU context?  Is this the IOMMU default domain?
Doesn't that represent a change in IOMMU behavior to place devices into
a blocking DMA context in several of the group-viable scenarios?

> 4) vfio_group_get_device_fd. User can acquire a device fd once the group
> is viable;

But as you've noted, "viable" doesn't test the IOMMU context of the
group devices, it's only a pre-condition for attaching the group to an
IOMMU context for isolated access.  What changes in the kernel that
makes "viable" become "isolated"?  A device bound to pci-stub today is
certainly not in a DMA blocking context when the host is booted with
iommu=pt.  Enabling the IOMMU only for device assignment by using
iommu=pt is arguably the predominant use case of the IOMMU.

> 5) device-centric when binding to IOMMU fd or attaching to IOASID
> 
> In this model the group viability mechanism is kept but there is no need
> for VFIO to track the actual attaching status.
> 
> Now let's look at how the new model works.
> 
> > 
> > 1) A dual-function PCIe e1000e NIC where the functions are grouped
> >    together due to ACS isolation issues.
> > 
> >    a) Initial state: functions 0 & 1 are both bound to e1000e driver.
> > 
> >    b) Admin uses driverctl to bind function 1 to vfio-pci, creating
> >       vfio device file, which is chmod'd to grant to a user.  
> 
> This implies that function 1 is in block-DMA mode when it's unbound
> from e1000e.

Does this require a kernel change from current?  Does it require the
host is not in iommu=pt mode?  Did vfio or vfio-pci do anything to
impose this DMA blocking context?  What if function 1 is actually a DMA
alias of function 0, wouldn't changing function 1's IOMMU context break
the operation of function 0?

> > 
> >    c) User opens vfio function 1 device file and an iommu_fd, binds
> >    device_fd to iommu_fd.  
> 
> User should check group viability before step c).

Sure, but "user should" is not a viable security model.

> > 
> >    Does this succeed?
> >      - if no, specifically where does it fail?
> >      - if yes, vfio can now allow access to the device?
> >   
> 
> with group viability step c) fails.

I'm asking for specifics, is it vfio's responsibility to test viability
before trying to bind the device_fd to the iommu_fd and it's vfio that
triggers this failure?  This sounds like vfio is entirely responsible
for managing the integrity of the group.
 
> >    d) Repeat b) for function 0.  
> 
> function 0 is in block DMA mode now.

Somehow...

> > 
> >    e) Repeat c), still using function 1, is it different?  Where?  Why?  
> 
> it's different because group becomes viable now. Then step c) succeeds.
> At this point, both function 0/1 are in block-DMA mode thus isolated
> from the rest of the system. VFIO allows the user to access function 1
> without the need of knowing when function 1 is attached to a new
> context (IOASID) via IOMMU fd and whether function 0 is left detached.
> 
> > 
> > 2) The same NIC as 1)
> > 
> >    a) Initial state: functions 0 & 1 bound to vfio-pci, vfio device
> >       files granted to user, user has bound both device_fds to the same
> >       iommu_fd.
> > 
> >    AIUI, even though not bound to an IOASID, vfio can now enable access
> >    through the device_fds, right?  What specific entity has placed these  
> 
> yes
> 
> >    devices into a block DMA state, when, and how?  
> 
> As explained in 2.b), both devices are put into block-DMA when they
> are detached from the default domain which is used when they are
> bound to e1000e driver.

How do stub drivers interact with this model?  How do PCI interconnect
drivers work with this model?  How do DMA alias devices work with this
model?  How does iommu=pt work with this model?  Does vfio just
passively assume the DMA blocking IOMMU context based on other random
attributes of the device?

> > 
> >    b) Both devices are attached to the same IOASID.
> > 
> >    Are we assuming that each device was atomically moved to the new
> >    IOMMU context by the IOASID code?  What if the IOMMU cannot change
> >    the domain atomically?  
> 
> No. Moving function 0 then function 1, or moving function 0 alone can
> all works. The one which hasn't been attached to an IOASID is kept in
> block-DMA state.

I'm asking whether this can be accomplished atomically relative to
device DMA.  If the user has access to the device after the bind
operation and the device operates in a DMA blocking IOMMU context at
that point, it seems that every IOASID context switch must be atomic
relative to device DMA or we present an exploitable gap to the user.

This is another change from vfio, the lifetime of the IOMMU context
encompasses the lifetime of device access.

> > 
> >    c) The device_fd for function 1 is detached from the IOASID.
> > 
> >    Are we assuming the reverse of b) performed by the IOASID code?  
> 
> function 1 turns back to block-DMA
> 
> > 
> >    d) The device_fd for function 1 is unbound from the iommu_fd.
> > 
> >    Does this succeed?
> >      - if yes, what is the resulting IOMMU context of the device and
> >        who owns it?
> >      - if no, well, that results in numerous tear-down issues.  
> 
> Yes. function 1 is block-DMA while function 0 still attached to IOASID.
> Actually unbind from IOMMU fd doesn't change the security context.
> the change is conducted when attaching/detaching device to/from an
> IOASID.

But I think you're suggesting that the IOMMU context is simply the
device's default domain, so vfio is left in the position where the user
gained access to the device by binding it to an iommu_fd, but now the
device exists outside of the iommu_fd.  Doesn't that make it pointless
to gate device access on binding the device to the iommu_fd?  The user
can get an accessible device_fd unbound from an iommu_fd on the reverse
path.

That would mean vfio's only control point for device access is on
open().

> > 
> >    e) Function 1 is unbound from vfio-pci.
> > 
> >    Does this work or is it blocked?  If blocked, by what entity
> >    specifically?  
> 
> works. 
> 
> > 
> >    f) Function 1 is bound to e1000e driver.
> > 
> >    We clearly have a violation here, specifically where and by who in
> >    this path should have prevented us from getting here or who pushes
> >    the BUG_ON to abort this?  
> 
> via vfio_iommu_group_notifier, same as today.

So as above, group integrity remains entirely vfio's issue?  Didn't we
discuss elsewhere in this thread that unless group integrity is managed
by /dev/iommu that we're going to have a mess of different consumers
managing it different degrees and effectiveness (or more likely just
ignoring it)?

> > 
> > 3) A dual-function conventional PCI e1000 NIC where the functions are
> >    grouped together due to shared RID.
> > 
> >    a) Repeat 2.a) and 2.b) such that we have a valid, user accessible
> >       devices in the same IOMMU context.
> > 
> >    b) Function 1 is detached from the IOASID.
> > 
> >    I think function 1 cannot be placed into a different IOMMU context
> >    here, does the detach work?  What's the IOMMU context now?  
> 
> Yes. Function 1 is back to block-DMA. Since both functions share RID,
> essentially it implies function 0 is in block-DMA state too (though its
> tracking state may not change yet) since the shared IOMMU context 
> entry blocks DMA now. In IOMMU fd function 0 is still attached to the
> IOASID thus the user still needs do an explicit detach to clear the 
> tracking state for function 0.
> 
> > 
> >    c) A new IOASID is alloc'd within the existing iommu_fd and function
> >       1 is attached to the new IOASID.
> > 
> >    Where, how, by whom does this fail?  
> 
> No need to fail. It can succeed since doing so just hurts user's own foot.
> 
> The only question is how user knows the fact that a group of devices
> share RID thus avoid such thing. I'm curious how it is communicated
> with today's VFIO mechanism. Yes the group-centric VFIO uAPI prevents
> a group of devices from attaching to multiple IOMMU contexts, but 
> suppose we still need a way to tell the user to not do so. Especially 
> such knowledge would be also reflected in the virtual PCI topology
> when the entire group is assigned to the guest which needs to know
> this fact when vIOMMU is exposed. I haven't found time to investigate
> it but suppose if such channel exists it could be reused, or in the worst 
> case we may have the new device capability interface to convey...

No such channel currently exists, it's not an issue today, IOMMU
context is group-based.

> > If vfio gets to offload all of it's group management to IOASID code,
> > that's great, but I'm afraid that IOASID is so focused on a
> > device-level API that we're instead just ignoring the group dynamics
> > and vfio will be forced to provide oversight to maintain secure
> > userspace access.  Thanks,
> >   
> 
> In summary, the security of the group dynamics are handled through 
> block-DMA plus existing vfio_group_viable mechanism in this device-
> centric design. VFIO still keeps its group management, but no need
> to track the attaching status for allowing user access.

Still seems pretty loosely defined to me, the DMA blocking mechanism
isn't specified, there's no verification of the IOMMU context for
"stray" group devices, the group management is based in the IOASID
consumer code leading to varying degrees of implementation and
effectiveness between callers, we lean more heavily on a fragile
notifier to notice and hit the panic button on violation.

It would make a lot more sense to me if the model were for vfio to
bind groups to /dev/iommu, the IOASID code manages group integrity, and
devices can still be moved between IOASIDs as is the overall goal.  The
group is the basis of ownership, which makes it a worthwhile part of
the API.  Thanks,

Alex

