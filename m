Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695433A5BD0
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 05:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhFNDZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Jun 2021 23:25:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhFNDZG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 13 Jun 2021 23:25:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623640983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DH6kGuqwSpyXtcecevk99gjqJDJGvAzEG8igZ3sFLDE=;
        b=a0E+gbJ404sPFbXC51m0g1Sg1AYrbNJD01Clm1WwB1ff0pdJe1+hDptrZSJhJA/R+Uow8t
        PbYzdHsP5yndYPwaL6d02FKNl4DtSYSCCvl/ydRLn1DUTulDrv86mS3g4AT5wmdZgcXCj7
        Uh4aQdEyeBkX6ioQ095H+iFoWgU6GP0=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-FtE4xSTQPxe6sUIutPYseg-1; Sun, 13 Jun 2021 23:23:02 -0400
X-MC-Unique: FtE4xSTQPxe6sUIutPYseg-1
Received: by mail-oi1-f197.google.com with SMTP id w12-20020aca490c0000b02901f1fdc1435aso5061061oia.14
        for <kvm@vger.kernel.org>; Sun, 13 Jun 2021 20:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DH6kGuqwSpyXtcecevk99gjqJDJGvAzEG8igZ3sFLDE=;
        b=sW5jXipE1BRz8jgp/08tCDecoe+wTCTCmOUaL19fvxUwT6YdzclAUyECees3jD9X45
         NZn2JqkmVBjyBRAqk7XkW1GZgi+vWfrDZkIo+7gT2G3fX81m+Iz1b0NHQJY94VuDDzPk
         QFyOyAvEGAAzuEI6YgoS5O64zLblEBDoEEMnCcJBRzoRTh8lJ41vuH5ubhVwlJuCT4NB
         WG/gHr87vGV2Qiw4ENZMth2lXHuqdRdOMzoo5Rq2nCZYIL1aTZsiEi0l/MPru7eievPW
         autFXB0YpkhzBvwEQRrcDyFvGjSSlD0yxktNbn1YqaEG2iXhGmNcRa6GoPkZx+STbf2j
         DQqg==
X-Gm-Message-State: AOAM530zFuRXNz8+K2op+74Ma6qrCDNJN4dbN9ZhI1tq80TV6FRNoDM4
        QHFBvL96aME3DxTp7SyJJyferPnYMx0QkCD1lQc/nOUtdfQN8uzJnFukg1bAhyRJb619FMKcDuv
        0r64kH1aCcI/O
X-Received: by 2002:a4a:d781:: with SMTP id c1mr11469394oou.23.1623640981482;
        Sun, 13 Jun 2021 20:23:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6xToi4wIBsXCCzc9rWc2XuIt2xUM51JIjsKt+2k+TNY3lc6glz0mU52oI39ABCxtmA6uP+Q==
X-Received: by 2002:a4a:d781:: with SMTP id c1mr11469382oou.23.1623640981204;
        Sun, 13 Jun 2021 20:23:01 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id c205sm2706192oib.20.2021.06.13.20.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 20:23:00 -0700 (PDT)
Date:   Sun, 13 Jun 2021 21:22:58 -0600
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
Message-ID: <20210613212258.6f2a2dac.alex.williamson@redhat.com>
In-Reply-To: <MWHPR11MB1886C2A0A8AA3000EBD5F8E18C319@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
        <YMCy48Xnt/aphfh3@8bytes.org>
        <20210609123919.GA1002214@nvidia.com>
        <YMDC8tOMvw4FtSek@8bytes.org>
        <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
        <20210611153850.7c402f0b.alex.williamson@redhat.com>
        <MWHPR11MB1886C2A0A8AA3000EBD5F8E18C319@MWHPR11MB1886.namprd11.prod.outlook.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Jun 2021 03:09:31 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Saturday, June 12, 2021 5:39 AM
> > 
> > On Fri, 11 Jun 2021 00:58:35 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > Hi, Alex,
> > >  
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Thursday, June 10, 2021 11:39 PM
> > > >
> > > > On Wed, 9 Jun 2021 15:49:40 -0300
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >  
> > > > > On Wed, Jun 09, 2021 at 10:27:22AM -0600, Alex Williamson wrote:
> > > > >  
> > > > > > > > It is a kernel decision, because a fundamental task of the kernel is  
> > to  
> > > > > > > > ensure isolation between user-space tasks as good as it can. And if  
> > a  
> > > > > > > > device assigned to one task can interfer with a device of another  
> > task  
> > > > > > > > (e.g. by sending P2P messages), then the promise of isolation is  
> > > > broken.  
> > > > > > >
> > > > > > > AIUI, the IOASID model will still enforce IOMMU groups, but it's not  
> > an  
> > > > > > > explicit part of the interface like it is for vfio.  For example the
> > > > > > > IOASID model allows attaching individual devices such that we have
> > > > > > > granularity to create per device IOASIDs, but all devices within an
> > > > > > > IOMMU group are required to be attached to an IOASID before they  
> > can  
> > > > be  
> > > > > > > used.  
> > > > >
> > > > > Yes, thanks Alex
> > > > >  
> > > > > > > It's not entirely clear to me yet how that last bit gets
> > > > > > > implemented though, ie. what barrier is in place to prevent device
> > > > > > > usage prior to reaching this viable state.  
> > > > >
> > > > > The major security checkpoint for the group is on the VFIO side.  We
> > > > > must require the group before userspace can be allowed access to any
> > > > > device registers. Obtaining the device_fd from the group_fd does this
> > > > > today as the group_fd is the security proof.
> > > > >
> > > > > Actually, thinking about this some more.. If the only way to get a
> > > > > working device_fd in the first place is to get it from the group_fd
> > > > > and thus pass a group-based security check, why do we need to do
> > > > > anything at the ioasid level?
> > > > >
> > > > > The security concept of isolation was satisfied as soon as userspace
> > > > > opened the group_fd. What do more checks in the kernel accomplish?  
> > > >
> > > > Opening the group is not the extent of the security check currently
> > > > required, the group must be added to a container and an IOMMU model
> > > > configured for the container *before* the user can get a devicefd.
> > > > Each devicefd creates a reference to this security context, therefore
> > > > access to a device does not exist without such a context.  
> > >
> > > IIUC each device has a default domain when it's probed by iommu driver
> > > at boot time. This domain includes an empty page table, implying that
> > > device is already in a security context before it's probed by device driver.  
> > 
> > The default domain could be passthrough though, right?  
> 
> Good point.
> 
> >   
> > > Now when this device is added to vfio, vfio creates another security
> > > context through above sequence. This sequence requires the device to
> > > switch from default security context to this new one, before it can be
> > > accessed by user.  
> > 
> > This is true currently, we use group semantics with the type1 IOMMU
> > backend to attach all devices in the group to a secure context,
> > regardless of the default domain.
> >   
> > > Then I wonder whether it's really necessary. As long as a device is in
> > > a security context at any time, access to a device can be allowed. The
> > > user itself should ensure that the access happens only after the device
> > > creates a reference to the new security context that is desired by this
> > > user.
> > >
> > > Then what does group really bring to us?  
> > 
> > By definition an IOMMU group is the smallest set of devices that we
> > can consider isolated from all other devices.  Therefore devices in a
> > group are not necessarily isolated from each other.  Therefore if any
> > device within a group is not isolated, the group is not isolated.  VFIO
> > needs to know when it's safe to provide userspace access to the device,
> > but the device isolation is dependent on the group isolation.  The
> > group is therefore part of this picture whether implicit or explicit.
> >   
> > > With this new proposal we just need to make sure that a device cannot
> > > be attached to any IOASID before all devices in its group are bound to
> > > the IOASIDfd. If we want to start with a vfio-like policy, then all devices
> > > in the group must be attached to the same IOASID. Or as Jason suggests,
> > > they can attach to different IOASIDs (if in the group due to !ACS) if the
> > > user wants, or have some devices attached while others detached since
> > > both are in a security context anyway.  
> > 
> > But if it's the device attachment to the IOASID that provides the
> > isolation and the user might attach a device to multiple IOASIDs within
> > the same IOASIDfd, and presumably make changes to the mapping of device
> > to IOASID dynamically, are we interrupting user access around each of
> > those changes?  How would vfio be able to track this, and not only
> > track it per device, but for all devices in the group.  Suggesting a
> > user needs to explicitly attach every device in the group is also a
> > semantic change versus existing vfio, where other devices in the group
> > must only be considered to be in a safe state for the group to be
> > usable.
> > 
> > The default domain may indeed be a solution to the problem, but we need
> > to enforce a secure default domain for all devices in the group.  To me
> > that suggests that binding the *group* to an IOASIDfd is the point at
> > which device access becomes secure.  VFIO should be able to consider
> > that the IOASIDfd binding has taken over ownership of the DMA context
> > for the device and it will always be either an empty, isolated, default
> > domain or a user defined IOASID.  
> 
> Yes, this is one way of enforcing the group security.
> 
> In the meantime, I'm thinking about another way whether group 
> security can be enforced in the iommu layer to relax the uAPI design. 
> If a device can be always blocked from accessing memory in the 
> IOMMU before it's bound to a driver or more specifically before
> the driver moves it to a new security context, then there is no need
> for VFIO to track whether IOASIDfd has taken over ownership of
> the DMA context for all devices within a group.

But we know we don't have IOMMU level isolation between devices in the
same group, so I don't see how this helps us.

> But as you said this cannot be achieved via existing default domain
> approach. So far a device is always attached to a domain:
> 
> - DOMAIN_IDENTITY: a default domain without DMA protection
> - DOMAIN_DMA: a default domain with DMA protection via DMA 
>   API and iommu core
> - DOMAIN_UNMANAGED: a driver-created domain which is not
>    managed by iommu core.
> 
> The special sequence in current vfio group design is to mitigate
> the 1st case, i.e. if a device is left in passthrough mode before
> bound to VFIO it's definitely insecure to allow user to access it.
> Then the sequence ensures that the user access is granted on it
> only after all devices within a group switch to a security context.
> 
> Now if the new proposed scheme can be supported, a device
> is always in a security context (block-dma) before it's switched 
> to a new security context and existing domain types should be 
> applied only in the new context when the device starts to do 
> DMAs. For VFIO case this switch happens explicitly when attaching 
> the device to an IOASID. For kernel driver it's implicit e.g. could
> happen when the 1st DMA API call is received. 
> 
> If this works I didn't see the need for vfio to keep the sequence. 
> VFIO still keeps group fd to claim ownership of all devices in a 
> group. Once it's done, vfio doesn't need to track the device attach 
> status and user access can be always granted regardless of 
> how the attach status changes. Moving a device from IOASID1 
> to IOASID2 involves detaching from IOASID1 (back to blocked
> dma context) and then reattaching to IOASID2 (switch to a
> new security context).
> 
> Following this direction even IOASIDfd doesn't need to verify
> the group attach upon such guarantee from the iommu layer. 
> The devices within a group can be in different security contexts,
> e.g. with some devices attached to GPA IOASID while others not 
> attached. In this way vfio userspace could choose to not attach 
> every device of a group to sustain the current semantics.

It seems like this entirely misses the point of groups with multiple
devices.  If we had IOMMU level isolation between all devices, we'd
never have multi-device groups.  Thanks,

Alex

