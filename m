Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7FE39AB79
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 22:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhFCUDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 16:03:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229665AbhFCUDg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 16:03:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622750511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6+LhEY/maKDsGguwuWfmgtdd1oJK4V5TtjaYZTDv20=;
        b=MhBT0DhVd+0HRM1K4AAD8uKlA0pNkvkTpkgH0LQ7CivkDS1dAGcC9VvxPV7qJsYbUoEuRI
        MHV7pCU9wn2wvv8mQOeeJqO7llgrDOgCYoxOTDtpiEwbZuH9sALBqvrVw66IC/QQWRu0Kz
        fmuQsYv8NHWJPpvIsl5WnkbKu3g6NbI=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-EhykPLV7NiejD-XcCsLgEg-1; Thu, 03 Jun 2021 16:01:49 -0400
X-MC-Unique: EhykPLV7NiejD-XcCsLgEg-1
Received: by mail-ot1-f71.google.com with SMTP id x2-20020a9d62820000b02902e4ff743c4cso3800935otk.8
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 13:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F6+LhEY/maKDsGguwuWfmgtdd1oJK4V5TtjaYZTDv20=;
        b=NqGCLwZpPZvGIrtI+OspQ5HQI5iRVvER/XmCvODRTNaqAFYFXeiRh85rNhPxNZD72s
         VbgG8mBrwLfYq6BFJTtaR8B6zLN8aFmSiAMOfSK0C5tB+T8MmoSeRN0+GJlObNRXhdU5
         no5mBy7ekCGlrJT8xWBGzgOjcJwAggrpxC3aXLzrWMimETWBmK/w5k2jQ+THFxNM8jQG
         De0NdNxWhh4KklaSbM37CiUMOcW5MlZm4CiYcL7MsTB795m3vYQjKUQIferYjdLYQYkq
         1Fu0HllDzQn5Q1zRU9GwNOSKxosNsquwMvpEpK5N1qMJMMSJ5Eg1lCnpCYKupYASHCNO
         IpDw==
X-Gm-Message-State: AOAM530fOyAtjRICcTbhjjHt/1a21YnzVowKfbbLY503Py/qm6gT0jEU
        VXm6ZsUJLuIPO9jPErAnal9pS3Hmb382EBppLB4y4/xp4FIJt7Xml5OkHufYCXTyE7U5YATcTxD
        FbPd2IxhQ/MuC
X-Received: by 2002:a05:6820:169:: with SMTP id k9mr788074ood.92.1622750508899;
        Thu, 03 Jun 2021 13:01:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybJFE1PtzN0iAak9GBGh+YKYVXBvdZUdaTPamYD6BYxoi0dVe3UA/w7oY39pMfZVQl/8UgAw==
X-Received: by 2002:a05:6820:169:: with SMTP id k9mr788045ood.92.1622750508679;
        Thu, 03 Jun 2021 13:01:48 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p9sm891275otl.64.2021.06.03.13.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 13:01:48 -0700 (PDT)
Date:   Thu, 3 Jun 2021 14:01:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603140146.5ce4f08a.alex.williamson@redhat.com>
In-Reply-To: <20210603123401.GT1002214@nvidia.com>
References: <20210602160140.GV1002214@nvidia.com>
        <20210602111117.026d4a26.alex.williamson@redhat.com>
        <20210602173510.GE1002214@nvidia.com>
        <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
        <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
        <20210602143734.72fb4fa4.alex.williamson@redhat.com>
        <20210602224536.GJ1002214@nvidia.com>
        <20210602205054.3505c9c3.alex.williamson@redhat.com>
        <20210603123401.GT1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Jun 2021 09:34:01 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jun 02, 2021 at 08:50:54PM -0600, Alex Williamson wrote:
> > On Wed, 2 Jun 2021 19:45:36 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Jun 02, 2021 at 02:37:34PM -0600, Alex Williamson wrote:
> > >   
> > > > Right.  I don't follow where you're jumping to relaying DMA_PTE_SNP
> > > > from the guest page table... what page table?      
> > > 
> > > I see my confusion now, the phrasing in your earlier remark led me
> > > think this was about allowing the no-snoop performance enhancement in
> > > some restricted way.
> > > 
> > > It is really about blocking no-snoop 100% of the time and then
> > > disabling the dangerous wbinvd when the block is successful.
> > > 
> > > Didn't closely read the kvm code :\
> > > 
> > > If it was about allowing the optimization then I'd expect the guest to
> > > enable no-snoopable regions via it's vIOMMU and realize them to the
> > > hypervisor and plumb the whole thing through. Hence my remark about
> > > the guest page tables..
> > > 
> > > So really the test is just 'were we able to block it' ?  
> > 
> > Yup.  Do we really still consider that there's some performance benefit
> > to be had by enabling a device to use no-snoop?  This seems largely a
> > legacy thing.  
> 
> I've recently had some no-snoopy discussions lately.. The issue didn't
> vanish, it is still expensive going through all that cache hardware.
> 
> > > But Ok, back the /dev/ioasid. This answers a few lingering questions I
> > > had..
> > > 
> > > 1) Mixing IOMMU_CAP_CACHE_COHERENCY and !IOMMU_CAP_CACHE_COHERENCY
> > >    domains.
> > > 
> > >    This doesn't actually matter. If you mix them together then kvm
> > >    will turn on wbinvd anyhow, so we don't need to use the DMA_PTE_SNP
> > >    anywhere in this VM.
> > > 
> > >    This if two IOMMU's are joined together into a single /dev/ioasid
> > >    then we can just make them both pretend to be
> > >    !IOMMU_CAP_CACHE_COHERENCY and both not set IOMMU_CACHE.  
> > 
> > Yes and no.  Yes, if any domain is !IOMMU_CAP_CACHE_COHERENCY then we
> > need to emulate wbinvd, but no we'll use IOMMU_CACHE any time it's
> > available based on the per domain support available.  That gives us the
> > most consistent behavior, ie. we don't have VMs emulating wbinvd
> > because they used to have a device attached where the domain required
> > it and we can't atomically remap with new flags to perform the same as
> > a VM that never had that device attached in the first place.  
> 
> I think we are saying the same thing..

Hrm?  I think I'm saying the opposite of your "both not set
IOMMU_CACHE".  IOMMU_CACHE is the mapping flag that enables
DMA_PTE_SNP.  Maybe you're using IOMMU_CACHE as the state reported to
KVM?

> > > 2) How to fit this part of kvm in some new /dev/ioasid world
> > > 
> > >    What we want to do here is iterate over every ioasid associated
> > >    with the group fd that is passed into kvm.  
> > 
> > Yeah, we need some better names, binding a device to an ioasid (fd) but
> > then attaching a device to an allocated ioasid (non-fd)... I assume
> > you're talking about the latter ioasid.  
> 
> Fingers crossed on RFCv2.. Here I mean the IOASID object inside the
> /dev/iommu FD. The vfio_device would have some kref handle to the
> in-kernel representation of it. So we can interact with it..
> 
> > >    Or perhaps more directly: an op attaching the vfio_device to the
> > >    kvm and having some simple helper 
> > >          '(un)register ioasid with kvm (kvm, ioasid)'
> > >    that the vfio_device driver can call that just sorts this out.  
> >
> > We could almost eliminate the device notion altogether here, use an
> > ioasidfd_for_each_ioasid() but we really want a way to trigger on each
> > change to the composition of the device set for the ioasid, which is
> > why we currently do it on addition or removal of a group, where the
> > group has a consistent set of IOMMU properties.  
> 
> That is another quite good option, just forget about trying to be
> highly specific and feed in the /dev/ioasid FD and have kvm ask "does
> anything in here not enforce snoop?"
> 
> With something appropriate to track/block changing that answer.
> 
> It doesn't solve the problem to connect kvm to AP and kvmgt though

It does not, we'll probably need a vfio ioctl to gratuitously announce
the KVM fd to each device.  I think some devices might currently fail
their open callback if that linkage isn't already available though, so
it's not clear when that should happen, ie. it can't currently be a
VFIO_DEVICE ioctl as getting the device fd requires an open, but this
proposal requires some availability of the vfio device fd without any
setup, so presumably that won't yet call the driver open callback.
Maybe that's part of the attach phase now... I'm not sure, it's not
clear when the vfio device uAPI starts being available in the process
of setting up the ioasid.  Thanks,

Alex

