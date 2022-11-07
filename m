Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C852261FCE8
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiKGSKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbiKGSJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:09:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBADC24F14
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667844315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bfWNmfGx0Se3BNvqmrQIw4qequKgdbo0qhO8fe0yzVg=;
        b=THGePlBZ9nXu3/Q2qhOgBIu1tT2dBFQrtuWuYAj9DlqJcpPvVSkPnnPaiUuwc3TddIyKir
        HnDWe5mbFiCIwarupbNbaMeRJ43wGdjDt054Q3NtoSYJobpRE6ckMKbgqryiJuOLgmi2L5
        1+uoGd0yi05ow8qNMi/PcGlbatnCseM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-163-NBxdVfOwOBWZ3OPICCZ0Tg-1; Mon, 07 Nov 2022 13:05:12 -0500
X-MC-Unique: NBxdVfOwOBWZ3OPICCZ0Tg-1
Received: by mail-il1-f198.google.com with SMTP id g4-20020a92cda4000000b00301ff06da14so5349552ild.11
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:05:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bfWNmfGx0Se3BNvqmrQIw4qequKgdbo0qhO8fe0yzVg=;
        b=78ahCEOodW0KolCUHmL4lTXgLQnfz1GZjNbFIRB6zA65TzW/5zMg5/LtPcCGOnkMJ2
         hWENxqfmsgXO9YwhzydGsmfR3tlqitnO60JyFSUEZuz24rPXyLXYMRebFs8Ldj67YXcw
         d9lvkSS40SSqQpOsAJ4IA+4AMRoY3ZKStGcLjjDIgebUDAh+p1jAVilWO7a/k+oqcUOn
         t8Xfm5LsgSXvqbYGskmq4DnCwp0+u34PfeaBye5q3bKxJMnxmaKDbycvlfrT6HvgSJ55
         TH7DVIAacRdO5g7hLJcUHTGeset3+0KY+o70+zaKulix2WCBNnNzpMDfO1FBiS9BMWQp
         /lSw==
X-Gm-Message-State: ANoB5pm83jIHF2qmSvDTmyaMxy+Ncc/KUbWulVsPvx14vBY7GPTgQgU6
        DznNUKT6i0TvFwufNExUGb5p1W923NWI2aUuy6TNXC6N+Mh4hLCyM8875lelKEh1VZ4q3LAzw43
        y+lw7GFT+4NCs
X-Received: by 2002:a05:6638:3590:b0:375:c920:16c2 with SMTP id v16-20020a056638359000b00375c92016c2mr2016463jal.72.1667844311309;
        Mon, 07 Nov 2022 10:05:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UQp/k2xL9xkcSh0+31rabNkEHgXJoe54k/D6xhd/Fo7jMB2KvouVPSBE3IOX+71t7NIX5PA==
X-Received: by 2002:a05:6638:3590:b0:375:c920:16c2 with SMTP id v16-20020a056638359000b00375c92016c2mr2016445jal.72.1667844311051;
        Mon, 07 Nov 2022 10:05:11 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g5-20020a05663810e500b00374d6db7566sm2912129jae.117.2022.11.07.10.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 10:05:10 -0800 (PST)
Date:   Mon, 7 Nov 2022 11:05:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        dri-devel@lists.freedesktop.org,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Longfang Liu <liulongfang@huawei.com>,
        linux-s390@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Halil Pasic <pasic@linux.ibm.com>, iommu@lists.linux.dev,
        Nicolin Chen <nicolinc@nvidia.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org, Zhi Wang <zhi.a.wang@intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH 04/10] vfio: Move storage of allow_unsafe_interrupts to
 vfio_main.c
Message-ID: <20221107110508.7f02abf4.alex.williamson@redhat.com>
In-Reply-To: <Y2klGAUEUwpjWHw6@nvidia.com>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
        <4-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
        <20221026152442.4855c5de.alex.williamson@redhat.com>
        <Y1wiCc33Jh5QY+1f@nvidia.com>
        <20221031164526.0712e456.alex.williamson@redhat.com>
        <Y2kF75zVD581UeR2@nvidia.com>
        <20221107081853.18727337.alex.williamson@redhat.com>
        <Y2klGAUEUwpjWHw6@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Nov 2022 11:32:40 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Nov 07, 2022 at 08:18:53AM -0700, Alex Williamson wrote:
> > On Mon, 7 Nov 2022 09:19:43 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Oct 31, 2022 at 04:45:26PM -0600, Alex Williamson wrote:
> > >   
> > > > > It is one idea, it depends how literal you want to be on "module
> > > > > parameters are ABI". IMHO it is a weak form of ABI and the need of
> > > > > this paramter in particular is not that common in modern times, AFAIK.
> > > > > 
> > > > > So perhaps we just also expose it through vfio.ko and expect people to
> > > > > migrate. That would give a window were both options are available.    
> > > > 
> > > > That might be best.  Ultimately this is an opt-out of a feature that
> > > > has security implications, so I'd rather error on the side of requiring
> > > > the user to re-assert that opt-out.  It seems the potential good in
> > > > eliminating stale or unnecessary options outweighs any weak claims of
> > > > preserving an ABI for a module that's no longer in service.    
> > > 
> > > Ok, lets do this
> > > 
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -55,6 +55,11 @@ static struct vfio {
> > >  bool vfio_allow_unsafe_interrupts;
> > >  EXPORT_SYMBOL_GPL(vfio_allow_unsafe_interrupts);
> > >  
> > > +module_param_named(allow_unsafe_interrupts,
> > > +                  vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> > > +MODULE_PARM_DESC(allow_unsafe_interrupts,
> > > +                "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
> > > +
> > >  static DEFINE_XARRAY(vfio_device_set_xa);
> > >  static const struct file_operations vfio_group_fops;
> > >   
> > > > However, I'd question whether vfio is the right place for that new
> > > > module option.  As proposed, vfio is only passing it through to
> > > > iommufd, where an error related to lack of the hardware feature is
> > > > masked behind an -EPERM by the time it gets back to vfio, making any
> > > > sort of advisory to the user about the module option convoluted.  It
> > > > seems like iommufd should own the option to opt-out universally, not
> > > > just through the vfio use case.  Thanks,    
> > > 
> > > My thinking is this option shouldn't exist at all in other iommufd
> > > users. eg I don't see value in VDPA supporting it.  
> > 
> > I disagree, the IOMMU interface is responsible for isolating the
> > device, this option doesn't make any sense to live in vfio-main, which
> > is the reason it was always a type1 option.    
> 
> You just agreed to this above?

After further consideration... I don't think the option on vfio-main
makes sense, basically for the same reason that the original option
existed on the IOMMU backend rather than vfio-core.  The option
describes a means to relax a specific aspect of IOMMU isolation, which
makes more sense to expose via the IOMMU provider, imo.  For example,
vfio-main cannot generate an equivalent error message as provided in
type1 today, it's too far removed from the IOMMU feature support.

> > If vdpa doesn't allow full device access such that it can guarantee
> > that a device cannot generate a DMA that can spoof MSI, then it
> > sounds like the flag we pass when attaching a device to iommfd
> > should to reflect this difference in usage.  
> 
> VDPA allows arbitary DMA just like VFIO. At most VDPA limits the MMIO
> touches.

So why exactly isn't this an issue for VDPA?  Are we just burying our
head in the sand that such platforms exists and can still be useful
given the appropriate risk vs reward trade-off?

> > The driver either requires full isolation, default, or can indicate a
> > form of restricted DMA programming that prevents interrupt spoofing.
> > The policy whether to permit unsafe configurations should exist in one
> > place, iommufd.  
> 
> iommufd doesn't know the level of unsafely the external driver is
> creating,

Thus the proposed flag.  But maybe we don't need it if VDPA has no
inherent protection against MSI spoofing itself.

> and IMHO we don't actually want to enable this more
> widely. So I don't want to see a global kernel wide flag at this point
> until we get reason to make more than just VFIO insecure.

But this brings into question the entire existence of the opt-in.  Do
we agree that there are valid use cases for such an option?

Unlike things like ACS overrides, lack of interrupt isolation really
requires a malicious actor.  We're not going to inadvertently overlap
DMA to interrupt addresses like we might to a non-isolated MMIO ranges.
Therefore an admin can make a reasonable determination relative to the
extent to which the userspace is trusted.  This is not unlike opt-outs
to CPU vulnerability mitigation imo, there are use cases where the
performance or functionality is more important than the isolation.
Hand waving this away as a vfio-unique insecurity is a bad precedent
for iommufd.  Thanks,

Alex

