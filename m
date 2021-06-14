Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B8C3A6BBE
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 18:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhFNQaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 12:30:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233430AbhFNQaX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 12:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623688100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzgzJ7O/u7Odok3R1woL2uNTog2ZUDiG4JdZlgR4dCA=;
        b=VwdY2EBe8/m51TXyBi0bRG07r790XcqCocY6yUYwwXS3DuO9lcdHeAZaisf56KrlAN/cUL
        +j68g9sIXsRRuRzQaB/uNhC+3ggn8fUkrKqXG9mqS//fg2kQLSInzdPy16a8Wds85CziAF
        jRop3iY9bjjuVTRb4aa2LcmBr60bvlw=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-4q_s-z9TOs-GDyp5ypcZ9A-1; Mon, 14 Jun 2021 12:28:18 -0400
X-MC-Unique: 4q_s-z9TOs-GDyp5ypcZ9A-1
Received: by mail-oo1-f69.google.com with SMTP id d12-20020a4aeb8c0000b029023bbaaddcbbso7284164ooj.13
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 09:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tzgzJ7O/u7Odok3R1woL2uNTog2ZUDiG4JdZlgR4dCA=;
        b=KMkayS1pucNsnQGuwUY0cG8j4wx8NeRJdbTH9iiwSX1EEJWNvn0tcafQ4SFeokeKdJ
         g4oZ4RnYUVNRk8qCfWYgF2HKtt53BLoeKVEKuwou1om1JuOkkR5tiahNrqAiO9iBC/8n
         9wDgSU5QNlny4UXpY2kh+XgiUFm/jmmeIceBlRbBh3bavcrQ4aIs0alZJr0L5QhmV1lG
         1zZUTrCNVufjQr+gZFaOKwouweLTvf1cpPSSi4hhShrNOu56NDJTVa9K7iIcbf6cjjbt
         yrqH9b6el3E6ECIPUora2GJO4CwjiVftsx2ibVxr/KHoIy3Md0NgcI21gEi5m84bfcGQ
         nOFg==
X-Gm-Message-State: AOAM533pV4xFRYltE4LqhXB56XBBhFNKyvc7IqXDgy36381aFfWSVoj5
        JgKyGqpb/EYmZQhXEAOKr8usT/o/a7tyf9W45uQ43rzMHKVcyjf/rD6zmQoEAaIZcRRR/zGSQRl
        ZfhVG4MS/bPnx
X-Received: by 2002:aca:acd3:: with SMTP id v202mr18921696oie.176.1623688097953;
        Mon, 14 Jun 2021 09:28:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaLd7mVWyg27hknMzbuJky0xO8onV3SMn7Mmdejpwa/NG1TjWls+CiqlABx6tnIc2dJ9Vt7w==
X-Received: by 2002:aca:acd3:: with SMTP id v202mr18921668oie.176.1623688097650;
        Mon, 14 Jun 2021 09:28:17 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id o20sm3351879otl.2.2021.06.14.09.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 09:28:17 -0700 (PDT)
Date:   Mon, 14 Jun 2021 10:28:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210614102814.43ada8df.alex.williamson@redhat.com>
In-Reply-To: <20210614140711.GI1002214@nvidia.com>
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
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Jun 2021 11:07:11 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Sat, Jun 12, 2021 at 10:57:11AM -0600, Alex Williamson wrote:
> > On Fri, 11 Jun 2021 22:28:46 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Fri, Jun 11, 2021 at 01:38:28PM -0600, Alex Williamson wrote:
> > >   
> > > > That's fine for a serial port, but not a device that can do DMA.
> > > > The entire point of vfio is to try to provide secure, DMA capable
> > > > userspace drivers.  If we relax enforcement of that isolation we've
> > > > failed.    
> > > 
> > > I don't understand why the IOASID matters at all in this. Can you
> > > explain? What is the breach of isolation?  
> > 
> > I think we're arguing past each other again.  VFIO does not care one
> > iota how userspace configures IOASID domains for devices.  OTOH, VFIO
> > must be absolutely obsessed that the devices we're providing userspace
> > access to are isolated and continue to be isolated for the extent of
> > that access.  Given that we define that a group is the smallest set of
> > devices that can be isolated, that means that for a device to be
> > isolated, the group needs to be isolated.
> > 
> > VFIO currently has a contract with the IOMMU backend that a group is
> > attached to an IOMMU context (container) and from that point forward,
> > all devices within that group are known to be isolated.  
> 
> Sure - and maybe this is the source of the confusion as I've been
> assuming we'd change the kernel to match what we are doing. As in the
> other note a device under VFIO control should immediately have it's
> IOMMU programmed to block all DMA. This is basically attaching it to a
> dummy ioasid with an empty page table.
> 
> So before VFIO exposes any char device all devices/groups under VFIO
> control cannot do any DMA. The only security/isolation harmful action
> they can do is DMA to devices in the same group.
> 
> > I'm trying to figure out how a device based interface to the IOASID can
> > provide that same contract or whether VFIO needs to be able to monitor
> > the IOASID attachments of the devices in a group to control whether
> > device access is secure.  
> 
> Can you define what specifically secure, and isolation means?
> 
> To my mind it is these three things:
> 
>  1. The device can only do DMA to memory put into its security context

System memory or device memory, yes.

Corollary: The IOMMU group defines the minimum set of devices where the
IOMMU can control inter-device DMA.

>  2. No other security context can control this device
>  3. No other security context can do DMA to my userspace memory

Rule #1 is essentially the golden rule, the rest falls out from it.

> Today in VFIO the security context is the group fd. I would like the
> security context to be the iommu fd.

The vfio group is simply a representation of the IOMMU group, which is
the minimum isolation granularity.  The group is therefore the minimum
security context, but itself is not a security context.  The overall
security context for vfio is the set of containers (IOMMU contexts)
owned by a user, where each container defines the IOMMU context for a
set of groups.  The user can map process and device memory between
containers within the same security context.

As you know, we have various issues with invalidation of device
mappings between containers, so simplifying the security context to the
ioasidfd seems like a good plan.  The vfio notion of a container is
already encompassed in the IOASID of the ioasidfd.

The significant difference is therefore the device level IOASID versus
vfio's group level container granularity.  This means the IOASID model
needs to incorporate the group model not only in terms of isolation,
but also address-ability.  The vfio model allows these to be combined
as a significant simplification.

> 1 is achieved by ensuring the device is always connected to an

s/device/group/

As you note in reply to Kevin, in a multi-device group rule #1 can be
violated if only one device is connected to an IOASID.

> IOASID. Today the group fd requires an IOASID before it hands out a
> device_fd. With iommu_fd the device_fd will not allow IOCTLs until it
> has a blocked DMA IOASID and is successefully joined to an iommu_fd.

Which is the root of my concern.  Who owns ioctls to the device fd?
It's my understanding this is a vfio provided file descriptor and it's
therefore vfio's responsibility.  A device-level IOASID interface
therefore requires that vfio manage the group aspect of device access.
AFAICT, that means that device access can therefore only begin when all
devices for a given group are attached to the IOASID and must halt for
all devices in the group if any device is ever detached from an IOASID,
even temporarily.  That suggests a lot more oversight of the IOASIDs by
vfio than I'd prefer.

> 2 is achieved by ensuring that two security contexts can't open
> devices in the same group. Today the group fd deals with this by being
> single open. With iommu_fd the kenerl would not permit splitting
> groups between iommu_fds.

"Who" within the kernel?  Is it the IOASID code itself or is this
another responsibility of vfio?  If IOASID knows about groups for this,
it's not clear to me why we have a device-level bind interface.  A
group-level bind interface clearly makes this more explicit.

> 3 is achieved today by the group_fd enforcing a single IOASID on all
> devices. Under iommu_fd all devices in the group can use any IOASID in
> their iommu_fd security domain.

As above, while the group is the minimum "security context" for vfio,
the overall security context is much more broad.  The group-level IOMMU
context is a simplification that allows us to combine isolation and
address-ability and so far it's not clear to me that the IOASID model
is also willing to take over these responsibility.  So again, if vfio
needs to manage these aspects that implies a lot of oversight of the
IOASID by vfio.
 
> It is a slightly different model than VFIO uses, but I don't think it
> provides less isolation.

I can be done correctly, but if IOASID isn't willing to take on
responsibility of managing isolation of the group, then it implies a
non-trivial degree of management by users like vfio to make sure
userspace access is and remains secure.

> > Otherwise, for a device centric VFIO/IOASID model, I need to understand
> > exactly when and how VFIO can know that it's safe to provide access to
> > a device and how the IOASID model guarantees the ongoing safety of that
> > access, which must encompass the safety relative to the entire group.  
> 
> Lets agree on what safety means then we can evaluate it.

Largely rule #1

> > For example, is it VFIO's job to BIND every device in the group?    
> 
> I'm thinking no

Then who?  Userspace?  IOASID?
 
> > Does binding the device represent the point at which the IOASID
> > takes responsibility for the isolation of the device?  
> 
> Following Kevin's language BIND is when the device_fd and iommu_fd are
> connected. That is when I see the device as becoming usable. Whatever
> security/isolation requirements we decide should be met here

If device access is usable after a BIND, then that suggests the IOASID
must be managing the group.  So why then do we have a device interface
for BIND rather than a group interface?

For example, given a group with devices A and B, the user performs a
BIND of deviceA_fd through vfio and now has access to device A.  The
user then performs BIND of deviceB_fd through vfio and has access to
device B.  BUT, something must have already taken on management of
device B in order to provide access to device A, so what's the point of
the BIND on device B?  Why isn't it a group interface?

> > If instead it's the ATTACH of a device that provides the isolation,
> > how is VFIO supposed to  
> 
> Not the attach
> 
> > DETACH occur through the IOASIDfd rather than the VFIOfd?  It seems
> > like the IOASIDfd is going to need ways to manipulate device:IOASID
> > mappings outside of VFIO, so again I wonder if we should switch to an
> > IOASID uAPI at that point rather than using VFIO.  Thanks,  
> 
> I don't think so... When the VFIO device_fd is closed it should
> disonnect the iommu from its device, restore the blocked DMA
> configuration, and then remove itself from the iommu_fd.

So continuing the above example, releasing deviceA_fd does what at the
group level?  What if device A and B are DMA aliases of each other?
How does the group remain secure relative to userspace access via
device B?

> Once the device is back to blocked DMA there is no further need for
> the iommu_fd to touch it.

Blocked by whom?  An IOMMU group assumes we cannot block DMA between
devices within the same group.  In vfio, even an unused devices that's
a member of an in-use group is placed into the IOMMU context of the
group, so a driver attaching to it that wants to do DMA will fail.

I'm really not seeing at all how this implicit group management is
supposed to work.  By making it implicit it's clearly too easily
ignored, by the user dependencies and the implementation proposal.
Thanks,

Alex

