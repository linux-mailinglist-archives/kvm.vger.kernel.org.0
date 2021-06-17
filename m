Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01553ABDDB
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 23:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhFQVRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 17:17:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231679AbhFQVRG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Jun 2021 17:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623964498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oo47wIqh+64AN4kysHC5ZnpWcOA2roMCcbT87S0ukUA=;
        b=Mah9jFWbH1mlKqAdclA0eaimZHgXfO/jYaHsuFxDSaalwwrLgy4jXLtlsjVY1k9MM18apF
        1Q/S7BoA0fvCwnYwe/flD4TdnzjWMHvEdegmlkxQ77kcWXehCbEYeI7p70sXCE7ub/ehMF
        aUYoE4Qc+/0+/ztZSq5ZI0OvbvtEyM4=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-X7KNWJ06OFKO_RCN1QfVPQ-1; Thu, 17 Jun 2021 17:14:56 -0400
X-MC-Unique: X7KNWJ06OFKO_RCN1QfVPQ-1
Received: by mail-oi1-f197.google.com with SMTP id o65-20020acaf0440000b02901f5112008e6so3645281oih.17
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 14:14:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oo47wIqh+64AN4kysHC5ZnpWcOA2roMCcbT87S0ukUA=;
        b=LLWHnVAaP9hdNeHrROsWRcBLAtEdgAzRVPbEIB3C1QxXP8QUsVM56LWMXscMSmI149
         UuYA4qgxUKYdrIAuDrItzIXmetLGjZdqbbUFlm+Cr91XNW91UZ8ICOfco/Q1IsKYP8BE
         g+SxSCYUGzdbrCyq7gSH3fg2acvbtXUQlbVwW5YFblFbdnmuABEyZvqi7YWNZBiQ5p/0
         fS9P/w6mFMJrI3wPkAAOExylbzjeeg3ICeClkIu3Hu6prK6Yov136j3x2ca9jbCvZhpG
         uyb77iVZlaD7TXYP0vKVsBD45YLkf9NnS6AGPX80lMvvzLxc9lUpfnUfrU2E3jysheSd
         pBZQ==
X-Gm-Message-State: AOAM5301U3cGBMvxEuHI6PMttAkbDAmRtTYztd7pXkdrXL5fCblTtkXu
        9PXB6CUv/mZog9rkoIxfDMZuFZ3jjwXLpg2hB+0eF0+LhP5fkTo8lTZSPLuVK2xuaXJ9YX/RTc7
        tLK9pjikydos9
X-Received: by 2002:a9d:39e3:: with SMTP id y90mr6460341otb.257.1623964496056;
        Thu, 17 Jun 2021 14:14:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSDm+Eyz4eQuTDZ9rpOqXZ442ZY5ensHDsN/la5BGEoSZAyELo4lhUDjVxeAhh3NadRWCr6g==
X-Received: by 2002:a9d:39e3:: with SMTP id y90mr6460309otb.257.1623964495561;
        Thu, 17 Jun 2021 14:14:55 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id g38sm1567134otg.28.2021.06.17.14.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:14:55 -0700 (PDT)
Date:   Thu, 17 Jun 2021 15:14:52 -0600
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
Message-ID: <20210617151452.08beadae.alex.williamson@redhat.com>
In-Reply-To: <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
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
        <20210616133937.59050e1a.alex.williamson@redhat.com>
        <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Jun 2021 07:31:03 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, June 17, 2021 3:40 AM
> > 
> > On Wed, 16 Jun 2021 06:43:23 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Wednesday, June 16, 2021 12:12 AM
> > > >
> > > > On Tue, 15 Jun 2021 02:31:39 +0000
> > > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > >  
> > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Sent: Tuesday, June 15, 2021 12:28 AM
> > > > > >  
> > > > > [...]  
> > > > > > > IOASID. Today the group fd requires an IOASID before it hands out a
> > > > > > > device_fd. With iommu_fd the device_fd will not allow IOCTLs until  
> > it  
> > > > > > > has a blocked DMA IOASID and is successefully joined to an  
> > iommu_fd.  
> > > > > >
> > > > > > Which is the root of my concern.  Who owns ioctls to the device fd?
> > > > > > It's my understanding this is a vfio provided file descriptor and it's
> > > > > > therefore vfio's responsibility.  A device-level IOASID interface
> > > > > > therefore requires that vfio manage the group aspect of device access.
> > > > > > AFAICT, that means that device access can therefore only begin when  
> > all  
> > > > > > devices for a given group are attached to the IOASID and must halt for
> > > > > > all devices in the group if any device is ever detached from an IOASID,
> > > > > > even temporarily.  That suggests a lot more oversight of the IOASIDs  
> > by  
> > > > > > vfio than I'd prefer.
> > > > > >  
> > > > >
> > > > > This is possibly the point that is worthy of more clarification and
> > > > > alignment, as it sounds like the root of controversy here.
> > > > >
> > > > > I feel the goal of vfio group management is more about ownership, i.e.
> > > > > all devices within a group must be assigned to a single user. Following
> > > > > the three rules defined by Jason, what we really care is whether a group
> > > > > of devices can be isolated from the rest of the world, i.e. no access to
> > > > > memory/device outside of its security context and no access to its
> > > > > security context from devices outside of this group. This can be  
> > achieved  
> > > > > as long as every device in the group is either in block-DMA state when
> > > > > it's not attached to any security context or attached to an IOASID  
> > context  
> > > > > in IOMMU fd.
> > > > >
> > > > > As long as group-level isolation is satisfied, how devices within a group
> > > > > are further managed is decided by the user (unattached, all attached to
> > > > > same IOASID, attached to different IOASIDs) as long as the user
> > > > > understands the implication of lacking of isolation within the group.  
> > This  
> > > > > is what a device-centric model comes to play. Misconfiguration just  
> > hurts  
> > > > > the user itself.
> > > > >
> > > > > If this rationale can be agreed, then I didn't see the point of having VFIO
> > > > > to mandate all devices in the group must be attached/detached in
> > > > > lockstep.  
> > > >
> > > > In theory this sounds great, but there are still too many assumptions
> > > > and too much hand waving about where isolation occurs for me to feel
> > > > like I really have the complete picture.  So let's walk through some
> > > > examples.  Please fill in and correct where I'm wrong.  
> > >
> > > Thanks for putting these examples. They are helpful for clearing the
> > > whole picture.
> > >
> > > Before filling in let's first align on what is the key difference between
> > > current VFIO model and this new proposal. With this comparison we'll
> > > know which of following questions are answered with existing VFIO
> > > mechanism and which are handled differently.
> > >
> > > With Yi's help we figured out the current mechanism:
> > >
> > > 1) vfio_group_viable. The code comment explains the intention clearly:
> > >
> > > --
> > > * A vfio group is viable for use by userspace if all devices are in
> > >  * one of the following states:
> > >  *  - driver-less
> > >  *  - bound to a vfio driver
> > >  *  - bound to an otherwise allowed driver
> > >  *  - a PCI interconnect device
> > > --
> > >
> > > Note this check is not related to an IOMMU security context.  
> > 
> > Because this is a pre-requisite for imposing that IOMMU security
> > context.
> >   
> > > 2) vfio_iommu_group_notifier. When an IOMMU_GROUP_NOTIFY_
> > > BOUND_DRIVER event is notified, vfio_group_viable is re-evaluated.
> > > If the affected group was previously viable but now becomes not
> > > viable, BUG_ON() as it implies that this device is bound to a non-vfio
> > > driver which breaks the group isolation.  
> > 
> > This notifier action is conditional on there being users of devices
> > within a secure group IOMMU context.
> >   
> > > 3) vfio_group_get_device_fd. User can acquire a device fd only after
> > > 	a) the group is viable;
> > > 	b) the group is attached to a container;
> > > 	c) iommu is set on the container (implying a security context
> > > 	    established);  
> > 
> > The order is actually b) a) c) but arguably b) is a no-op until:
> > 
> >     d) a device fd is provided to the user
> >   
> > > The new device-centric proposal suggests:
> > >
> > > 1) vfio_group_viable;
> > > 2) vfio_iommu_group_notifier;
> > > 3) block-DMA if a device is detached from previous domain (instead of
> > > switching back to default domain as today);  
> > 
> > I'm literally begging for specifics in this thread, but none are
> > provided here.  What is the "previous domain"?  How is a device placed
> > into a DMA blocking IOMMU context?  Is this the IOMMU default domain?
> > Doesn't that represent a change in IOMMU behavior to place devices into
> > a blocking DMA context in several of the group-viable scenarios?  
> 
> Yes, it represents a change in current IOMMU behavior. Here I just
> described what would be the desired logic in concept. 
> 
> More specifically, the current IOMMU behavior is that:
> 
> -   A device is attached to the default domain (identity or dma) when it's
>     probed by the iommu driver. If the domain type is dma, iommu
>     isolation is enabled with an empty I/O page table thus the device
>     DMA is blocked. If the domain type is identity, iommu isolation is
>     disabled thus the device can access arbitrary memory/device even
>     when it's not bound to any driver.
> 
> -   Once the device is bound to a driver which doesn't allocate a new
>     domain, the default domain allows the driver to do DMA API on 
>     the device. Unbound from the driver doesn't change device/domain
>     attaching status i.e. the device is still attached to the default domain.
>     Whether the device can access certain memory locations after unbind
>     depends on whether the driver clears up its mappings properly.
> 
> -   Now the device is bound to a driver (vfio) which manages its own
>     security context (domain type is unmanaged). The device stays
>     attaching to the default domain before the driver explicitly switches
>     it to use the new unmanaged domain. Detaching the device from an 
>     unmanaged domain later puts it back to use the default domain.
> 
> Then the current vfio mechanism makes sense because there is no
> guarantee that the default domain can isolate the device from the 
> rest system (if domain type is identity or dma but previous driver 
> leaves stale mappings due to some bug). vfio has to allow user access
> only after all devices in the group are switched to a known security 
> context that is created by vfio itself.
> 
> Now let's talk about the new IOMMU behavior:
> 
> -   A device is blocked from doing DMA to any resource outside of
>     its group when it's probed by the IOMMU driver. This could be a
>     special state w/o attaching to any domain, or a new special domain
>     type which differentiates it from existing domain types (identity, 
>     dma, or unmanged). Actually existing code already includes a
>     IOMMU_DOMAIN_BLOCKED type but nobody uses it.
> 
> -   Once the device is bound to a driver which doesn't allocate a new
>     domain, the first DMA API call implicitly switches the device from
>     block-DMA state to use the existing default domain (identity or
>     dma). This change should be easy as current code already supports
>     a deferred attach mode which is activated in kdump kernel. Unbound
>     from the driver implicitly detaches the device from the default 
>     domain and switches it back to the block-DMA state. This can be
>     enforced via iommu_bus_notifier().
> 
> -   Now the device is bound to a driver (vfio) which delegates management
>     of security context to iommu fd. The device stays in the block-DMA 
>     state before its attached to an IOASID. After IOASID attaching, it is put
>     in a new security context represented by the IOASID. Detaching the 
>     device from an IOASID puts it back to block-DMA. 
> 
> With this new behavior vfio just needs to track that all devices are in 
> block-DMA state before user access is allowed. This can be reported
> via a new iommu interface and checked in vfio_group_viable() in 
> addition to what it verifies today. Once a group is viable, the user can 
> get a device fd from the group and bind it to iommu fd. vfio doesn't
> need wait for all devices in the group attached to the same IOASID 
> before granting user access, because they are all isolated from the 
> rest system being either in block-DMA or in a new security context.
> Thus a device-centric interface between vfio and iommu fd should
> be sufficient.

Thanks for the additional detail.
 
> vfio_iommu_group_notifier will be slightly changed to check whether 
> any device within the group is bound to iommu fd. If yes BUG_ON 
> is raised to avoid breaking the group isolation. To be consistent
> VFIO_BIND_IOMMU_FD need also check group viability.
> 
> >   
> > > 4) vfio_group_get_device_fd. User can acquire a device fd once the group
> > > is viable;  
> > 
> > But as you've noted, "viable" doesn't test the IOMMU context of the
> > group devices, it's only a pre-condition for attaching the group to an
> > IOMMU context for isolated access.  What changes in the kernel that
> > makes "viable" become "isolated"?  A device bound to pci-stub today is
> > certainly not in a DMA blocking context when the host is booted with
> > iommu=pt.  Enabling the IOMMU only for device assignment by using
> > iommu=pt is arguably the predominant use case of the IOMMU.  
> 
> vfio_group_viable() needs to check block-DMA, and iommu=pt 
> only affects the DMA API path now. A device which is not bound
> to any driver or the driver doesn't do DMA on is left in block-DMA
> state.

I think you're going to get friction from any remaining non-vfio
userspace drivers that rely on a passthrough default domain.  Any such
drivers are clearly insecure, and in the case of uio-pci-generic
violate the intended non-DMA use case of the driver, but I think they
still exist.  This effectively flips the switch that those drivers can
no longer work in an IOMMU enabled environment.
 
> > > 5) device-centric when binding to IOMMU fd or attaching to IOASID
> > >
> > > In this model the group viability mechanism is kept but there is no need
> > > for VFIO to track the actual attaching status.
> > >
> > > Now let's look at how the new model works.
> > >  
> > > >
> > > > 1) A dual-function PCIe e1000e NIC where the functions are grouped
> > > >    together due to ACS isolation issues.
> > > >
> > > >    a) Initial state: functions 0 & 1 are both bound to e1000e driver.
> > > >
> > > >    b) Admin uses driverctl to bind function 1 to vfio-pci, creating
> > > >       vfio device file, which is chmod'd to grant to a user.  
> > >
> > > This implies that function 1 is in block-DMA mode when it's unbound
> > > from e1000e.  
> > 
> > Does this require a kernel change from current?  Does it require the
> > host is not in iommu=pt mode?  Did vfio or vfio-pci do anything to
> > impose this DMA blocking context?  What if function 1 is actually a DMA  
> 
> I hope above explanation answers them.
> 
> > alias of function 0, wouldn't changing function 1's IOMMU context break
> > the operation of function 0?  
> 
> Sorry I'm not familiar with this DMA aliasing thing. Can you elaborate?

Look for users of pci_add_dma_alias().  These are often multi-function
devices where DMA uses the wrong RID, for instance a driver using
function 0 generates TLPs as function 1, or vice versa.  There are
various other combinations of similar, but it's also used for a couple
non-transparent bridges.  Effectively the IOMMU must map all aliases of
a device.  Sometimes those aliases are physical devices within the same
IOMMU group, sometimes there's no struct device at the alias address.
It's a flavor of the addressibility issue we have with conventional PCI
devices, but on PCIe.

In the theoretical case above, we actually can't manipulate function 1
IOMMU mappings separate from function 0 if they were aliases.  There's
a "userspace can shoot themselves in the foot" aspect to this, but there
should also be a way that userspace can understand these dependencies.

> > > >
> > > >    c) User opens vfio function 1 device file and an iommu_fd, binds
> > > >    device_fd to iommu_fd.  
> > >
> > > User should check group viability before step c).  
> > 
> > Sure, but "user should" is not a viable security model.
> >   
> > > >
> > > >    Does this succeed?
> > > >      - if no, specifically where does it fail?
> > > >      - if yes, vfio can now allow access to the device?
> > > >  
> > >
> > > with group viability step c) fails.  
> > 
> > I'm asking for specifics, is it vfio's responsibility to test viability
> > before trying to bind the device_fd to the iommu_fd and it's vfio that
> > triggers this failure?  This sounds like vfio is entirely responsible
> > for managing the integrity of the group.  
> 
> manage integrity of the group based on block-DMA, but no need of 
> a group interface with iommu fd to track group attaching status.
> 
> >   
> > > >    d) Repeat b) for function 0.  
> > >
> > > function 0 is in block DMA mode now.  
> > 
> > Somehow...
> >   
> > > >
> > > >    e) Repeat c), still using function 1, is it different?  Where?  Why?  
> > >
> > > it's different because group becomes viable now. Then step c) succeeds.
> > > At this point, both function 0/1 are in block-DMA mode thus isolated
> > > from the rest of the system. VFIO allows the user to access function 1
> > > without the need of knowing when function 1 is attached to a new
> > > context (IOASID) via IOMMU fd and whether function 0 is left detached.
> > >  
> > > >
> > > > 2) The same NIC as 1)
> > > >
> > > >    a) Initial state: functions 0 & 1 bound to vfio-pci, vfio device
> > > >       files granted to user, user has bound both device_fds to the same
> > > >       iommu_fd.
> > > >
> > > >    AIUI, even though not bound to an IOASID, vfio can now enable access
> > > >    through the device_fds, right?  What specific entity has placed these  
> > >
> > > yes
> > >  
> > > >    devices into a block DMA state, when, and how?  
> > >
> > > As explained in 2.b), both devices are put into block-DMA when they
> > > are detached from the default domain which is used when they are
> > > bound to e1000e driver.  
> > 
> > How do stub drivers interact with this model?  How do PCI interconnect
> > drivers work with this model?  How do DMA alias devices work with this
> > model?  How does iommu=pt work with this model?  Does vfio just
> > passively assume the DMA blocking IOMMU context based on other random
> > attributes of the device?  
> 
> pci-stub and bridge drivers follow the existing viability check.
> 
> iommu=pt has no impact on block-DMA.
> 
> vfio explicitly tracks the dma-blocking state, which doesn't rely on iommu fd.
> 
> but I haven't got time to think about DMA aliasing yet.
> 
> >   
> > > >
> > > >    b) Both devices are attached to the same IOASID.
> > > >
> > > >    Are we assuming that each device was atomically moved to the new
> > > >    IOMMU context by the IOASID code?  What if the IOMMU cannot  
> > change  
> > > >    the domain atomically?  
> > >
> > > No. Moving function 0 then function 1, or moving function 0 alone can
> > > all works. The one which hasn't been attached to an IOASID is kept in
> > > block-DMA state.  
> > 
> > I'm asking whether this can be accomplished atomically relative to
> > device DMA.  If the user has access to the device after the bind
> > operation and the device operates in a DMA blocking IOMMU context at
> > that point, it seems that every IOASID context switch must be atomic
> > relative to device DMA or we present an exploitable gap to the user.  
> 
> the switch is always between block-DMA and a driver-created domain
> which are both secure. Does this assumption meet the 'atomic' behavior
> in your mind?

It's not whether the target domains are secure, it's the fact that
we're now allowing userspace access to a device AND the user can
arbitrarily create new IOASID contexts and switch the device between
them while retaining that access.  That's not possible with vfio and
implies that either the DMA context of the device must remain secure
during the switch or we need to determine a means to revoke device
access during the switch.  For example, if there was any gap in DMA
isolation of the device during the context switch while the user has
access to the device, then the user could exploit that by repeatedly
switching a device between IOASIDs.

I want to make sure vfio doesn't need to be involved in IOASID changes.

> > This is another change from vfio, the lifetime of the IOMMU context
> > encompasses the lifetime of device access.
> >   
> > > >
> > > >    c) The device_fd for function 1 is detached from the IOASID.
> > > >
> > > >    Are we assuming the reverse of b) performed by the IOASID code?  
> > >
> > > function 1 turns back to block-DMA
> > >  
> > > >
> > > >    d) The device_fd for function 1 is unbound from the iommu_fd.
> > > >
> > > >    Does this succeed?
> > > >      - if yes, what is the resulting IOMMU context of the device and
> > > >        who owns it?
> > > >      - if no, well, that results in numerous tear-down issues.  
> > >
> > > Yes. function 1 is block-DMA while function 0 still attached to IOASID.
> > > Actually unbind from IOMMU fd doesn't change the security context.
> > > the change is conducted when attaching/detaching device to/from an
> > > IOASID.  
> > 
> > But I think you're suggesting that the IOMMU context is simply the
> > device's default domain, so vfio is left in the position where the user
> > gained access to the device by binding it to an iommu_fd, but now the
> > device exists outside of the iommu_fd.  Doesn't that make it pointless
> > to gate device access on binding the device to the iommu_fd?  The user
> > can get an accessible device_fd unbound from an iommu_fd on the reverse
> > path.  
> 
> yes, binding to iommu_fd is not the appropriate point of gating
> device access.
> 
> > 
> > That would mean vfio's only control point for device access is on
> > open().  
> 
> yes, on open() via block-DMA check in vfio_group_viable().

Let's explore that.  DeviceA, DeviceB, and DeviceC are grouped together,
vfio gets an open() call on DeviceA, it passes the group viable and DMA
blocked check, the user now has a device_fd with full device access
(within a DMA blocking IOMMU context).  vfio now gets an open() call on
DeviceB... Is it a userspace problem with ACLs on the device files that
the next open could come from a different user?

When the user(s) start binding these device_fds to an iommu_fd, is it
vfio's responsibility to make sure all devices within the group bind to
the same iommu_fd?  I think that suggests internal serialization per
group to ioasid binding and a reference per group to the iommu_fd.

The user has now bound DeviceA to an iommu_fd and attached it to an
IOASID, we then get an open() for DeviceC.  Does the DMA-blocking
domain check skip DeviceA because it's already attached to an iommu_fd?

I think we also have some pathological cases around DMA aliases and
conventional PCI, for instance DeviceY is a DMA alias of DeviceX, the
user gets a device_fd for DeviceX, binds it to an iommu_fd and attaches
DeviceX to an IOASID... this triggers the IOMMU notifier because the
DMA blocking state of DeviceY has changed and triggers a BUG_ON.  Maybe
a niche case, but this particular one would be exploitable by a user
and it's not entirely clear what safeguards and proper sequence by the
user would prevent it.

> > > >
> > > >    e) Function 1 is unbound from vfio-pci.
> > > >
> > > >    Does this work or is it blocked?  If blocked, by what entity
> > > >    specifically?  
> > >
> > > works.
> > >  
> > > >
> > > >    f) Function 1 is bound to e1000e driver.
> > > >
> > > >    We clearly have a violation here, specifically where and by who in
> > > >    this path should have prevented us from getting here or who pushes
> > > >    the BUG_ON to abort this?  
> > >
> > > via vfio_iommu_group_notifier, same as today.  
> > 
> > So as above, group integrity remains entirely vfio's issue?  Didn't we  
> 
> sort of...
> 
> > discuss elsewhere in this thread that unless group integrity is managed
> > by /dev/iommu that we're going to have a mess of different consumers
> > managing it different degrees and effectiveness (or more likely just
> > ignoring it)?  
> 
> Yes, that was the original impression. But after figuring out the new
> block-DMA behavior, I'm not sure whether /dev/iommu must maintain
> its own group integrity check. If it trusts vfio, I feel it's fine to avoid 
> such check which even allows a group of devices bound to different
> IOMMU fd's if user likes. Also if we want to sustain the current vfio
> semantics which doesn't require all devices in the group bound to
> vfio driver, seems it's pointless to enforce such integrity check in
> /dev/iommu.

"even allows a group of devices bound to different IOMMU fd's if user
likes", here lies madness.  This is exactly why vfio uses the group as
the unit of ownership.  To place the entire burden of group isolation
on userspace is essentially the same as removing any concept of group
isolation.  This instantly leads to VMs sharing resources they
shouldn't, bizarre address space issues, and exploits through devices
between VMs.  I think the kernel would be neglecting its duty to manage
and isolate resources for userspace if such were allowed.

Besides, how would the DMA blocking check pass if other devices in the
group were attached to a random non-blocking domain, ie. another user's
IOASID?

Whether isolation enforcement happens in vfio or /dev/iommu shouldn't
be a question of whether vfio is trusted, it should be a question of
whether vfio's use case is sufficiently unique that other users of the
IOASID infrastructure wouldn't need to reproduce the same security
measures.

> Jason, what's your opinion?
> 
> >   
> > > >
> > > > 3) A dual-function conventional PCI e1000 NIC where the functions are
> > > >    grouped together due to shared RID.
> > > >
> > > >    a) Repeat 2.a) and 2.b) such that we have a valid, user accessible
> > > >       devices in the same IOMMU context.
> > > >
> > > >    b) Function 1 is detached from the IOASID.
> > > >
> > > >    I think function 1 cannot be placed into a different IOMMU context
> > > >    here, does the detach work?  What's the IOMMU context now?  
> > >
> > > Yes. Function 1 is back to block-DMA. Since both functions share RID,
> > > essentially it implies function 0 is in block-DMA state too (though its
> > > tracking state may not change yet) since the shared IOMMU context
> > > entry blocks DMA now. In IOMMU fd function 0 is still attached to the
> > > IOASID thus the user still needs do an explicit detach to clear the
> > > tracking state for function 0.
> > >  
> > > >
> > > >    c) A new IOASID is alloc'd within the existing iommu_fd and function
> > > >       1 is attached to the new IOASID.
> > > >
> > > >    Where, how, by whom does this fail?  
> > >
> > > No need to fail. It can succeed since doing so just hurts user's own foot.
> > >
> > > The only question is how user knows the fact that a group of devices
> > > share RID thus avoid such thing. I'm curious how it is communicated
> > > with today's VFIO mechanism. Yes the group-centric VFIO uAPI prevents
> > > a group of devices from attaching to multiple IOMMU contexts, but
> > > suppose we still need a way to tell the user to not do so. Especially
> > > such knowledge would be also reflected in the virtual PCI topology
> > > when the entire group is assigned to the guest which needs to know
> > > this fact when vIOMMU is exposed. I haven't found time to investigate
> > > it but suppose if such channel exists it could be reused, or in the worst
> > > case we may have the new device capability interface to convey...  
> > 
> > No such channel currently exists, it's not an issue today, IOMMU
> > context is group-based.  
> 
> Interesting... If such group of devices are assigned to a guest, how does
> Qemu decide the virtual PCI topology for them? Do they have same
> vRID or different?

That's the beauty of it, it doesn't matter how many RIDs exist in the
group, or which devices have aliases, the group is the minimum
granularity of a container where QEMU knows that a container provides
a single address space.  Therefore a container must exist in a single
address space in the PCI topology.  In a conventional or non-vIOMMU
topology, the PCI address space is equivalent to the system memory
address space.  When vIOMMU gets involved, multiple devices within the
same group must exist in the same address space.  A vPCIe-to-PCI bridge
can be used to create that shared address space.

I've referred to this as a limitation of type1, that we can't put
devices within the same group into different address spaces, such as
behind separate vRoot-Ports in a vIOMMU config, but really, who cares?
As isolation support improves we see fewer multi-device groups, this
scenario becomes the exception.  Buy better hardware to use the devices
independently.

> > > > If vfio gets to offload all of it's group management to IOASID code,
> > > > that's great, but I'm afraid that IOASID is so focused on a
> > > > device-level API that we're instead just ignoring the group dynamics
> > > > and vfio will be forced to provide oversight to maintain secure
> > > > userspace access.  Thanks,
> > > >  
> > >
> > > In summary, the security of the group dynamics are handled through
> > > block-DMA plus existing vfio_group_viable mechanism in this device-
> > > centric design. VFIO still keeps its group management, but no need
> > > to track the attaching status for allowing user access.  
> > 
> > Still seems pretty loosely defined to me, the DMA blocking mechanism  
> 
> Sorry for that and hope the explanation in this mail makes it clearer.
> 
> > isn't specified, there's no verification of the IOMMU context for
> > "stray" group devices, the group management is based in the IOASID
> > consumer code leading to varying degrees of implementation and
> > effectiveness between callers, we lean more heavily on a fragile
> > notifier to notice and hit the panic button on violation.
> > 
> > It would make a lot more sense to me if the model were for vfio to
> > bind groups to /dev/iommu, the IOASID code manages group integrity, and
> > devices can still be moved between IOASIDs as is the overall goal.  The
> > group is the basis of ownership, which makes it a worthwhile part of
> > the API.  Thanks,
> >   
> 
> Having explained the device-centric design, honestly speaking I think
> your model could also work. Group is an iommu concept, thus not
> unsound by asking /dev/iommu to manage the group integrity, e.g. 
> moving the block-DMA verification and vfio_group_viable() into 
> /dev/iommu and verify it when doing group binding. A successful 
> group binding implies all group verification passed then user access 
> can be allowed. But even doing so I don't expect /dev/iommu uAPI 
> will include any explicit group semantics. Just the in-kernel helper 
> functions accepts group via VFIO_GROUP_BIND_IOMMU_FD.

As above, how unique is the vfio use case?  IMO, if there are cases
where we're providing userspace DMA capable access to a device and
we're not taking into account the full IOMMU group isolation model of
that device, it's broken.  Is it really feasible to expect every
consumer of the interface to do this sort of homework?

There are aspects here that I like, it would be convenient to hide
groups, but I'm also rediscovering how many problems we solved with our
usage of groups in vfio.  Thanks,

Alex

