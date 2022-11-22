Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11B5634296
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 18:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiKVRgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 12:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiKVRgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 12:36:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA3626F7
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 09:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669138502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YODSWn+5JxpH+sbAx2dpm5qkS38gFi2Q3q/NzXm77VE=;
        b=A8C4cBc8dS3l387teNTgZUSYIHlW2vOKngj3f9h6IuNSCLPa13VePmNU7zUVbQgIov/ayF
        kIOf+T3By+n8VA7Q5xZV1P4gLM+i91s8CpfiHCgOhXQ8F7gGh8CX4FqUOF702+Io28Lwej
        pqj+do3879sCUYBR5mb+JbSc0WU4Hq4=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-313-ptrfsydVOb6tkv1cOPp-ZQ-1; Tue, 22 Nov 2022 12:35:00 -0500
X-MC-Unique: ptrfsydVOb6tkv1cOPp-ZQ-1
Received: by mail-il1-f197.google.com with SMTP id i26-20020a056e021d1a00b003025434c04eso11049834ila.13
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 09:35:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YODSWn+5JxpH+sbAx2dpm5qkS38gFi2Q3q/NzXm77VE=;
        b=OD8C+K2FEd7S7OWyIezQmwdFmLuf7WDtZQmwUTuBz0DWyOQz02l7SikmfSGV6IEtJ3
         J63jI0kdllcepRBe5dF1zVrF4K1pohFZqhVohSuSQZV9i5P8HtGzTwSTFTvJopsN3HEH
         urF7AR90Fz44lCNy+MvOlBP/hhPk6+VPK8reuYyr5e8yfvf0+BJz+BKz+X7n/tvEkATS
         PpsCWUC7FIGMbhkm5yOvzO3BXjhfjbItghik2jXirTQBijIkEhFNqSUtAGkIwGASxrB9
         zUBBFvl61iKgLHM7OvMY91WhFjnazsHoxXV9k/kMszEXGKDZRl3YDfXce3q1/cz2rJEz
         iaSg==
X-Gm-Message-State: ANoB5pm57fIry/ksNGhoqHgPIszPCJwJ+M25cOSKWuausZdSDyv7NkPx
        O2JEJpnkTXYqcHBDU48ZDe7X5QD40ap3HUaCYhK6R2obvjJjfY3OlcyvjGJmofTf3lnt+a1Biki
        6J9iZgzyvlasH
X-Received: by 2002:a02:c723:0:b0:363:b95b:78eb with SMTP id h3-20020a02c723000000b00363b95b78ebmr4648000jao.61.1669138500006;
        Tue, 22 Nov 2022 09:35:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf464yCXJHLA8r+u5yBZTRKqrUYkVjcUFbDV06k0PEpXgNU1UGQkO9QE9uf3ESKyo7a11mc0QQ==
X-Received: by 2002:a02:c723:0:b0:363:b95b:78eb with SMTP id h3-20020a02c723000000b00363b95b78ebmr4647982jao.61.1669138499728;
        Tue, 22 Nov 2022 09:34:59 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i1-20020a02a0c1000000b00369a91d1bd4sm5350675jah.138.2022.11.22.09.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:34:59 -0800 (PST)
Date:   Tue, 22 Nov 2022 10:34:56 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Message-ID: <20221122103456.7a97ac9b.alex.williamson@redhat.com>
In-Reply-To: <Y3wtAPTqKJLxBRBg@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
        <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
        <20221117131451.7d884cdc.alex.williamson@redhat.com>
        <Y3embh+09Fqu26wJ@nvidia.com>
        <20221118133646.7c6421e7.alex.williamson@redhat.com>
        <Y3wtAPTqKJLxBRBg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Nov 2022 21:59:28 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Nov 18, 2022 at 01:36:46PM -0700, Alex Williamson wrote:
> > On Fri, 18 Nov 2022 11:36:14 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Thu, Nov 17, 2022 at 01:14:51PM -0700, Alex Williamson wrote:  
> > > > On Wed, 16 Nov 2022 17:05:29 -0400
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >     
> > > > > This legacy module knob has become uAPI, when set on the vfio_iommu_type1
> > > > > it disables some security protections in the iommu drivers. Move the
> > > > > storage for this knob to vfio_main.c so that iommufd can access it too.
> > > > > 
> > > > > The may need enhancing as we learn more about how necessary
> > > > > allow_unsafe_interrupts is in the current state of the world. If vfio
> > > > > container is disabled then this option will not be available to the user.
> > > > > 
> > > > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > > Tested-by: Yi Liu <yi.l.liu@intel.com>
> > > > > Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> > > > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > > Tested-by: Yu He <yu.he@intel.com>
> > > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > ---
> > > > >  drivers/vfio/vfio.h             | 2 ++
> > > > >  drivers/vfio/vfio_iommu_type1.c | 5 ++---
> > > > >  drivers/vfio/vfio_main.c        | 3 +++
> > > > >  3 files changed, 7 insertions(+), 3 deletions(-)    
> > > > 
> > > > It's really quite trivial to convert to a vfio_iommu.ko module to host
> > > > a separate option for this.  Half of the patch below is undoing what's
> > > > done here.  Is your only concern with this approach that we use a few
> > > > KB more memory for the separate module?    
> > > 
> > > My main dislike is that it just seems arbitary to shunt iommufd
> > > support to a module when it is always required by vfio.ko. In general
> > > if you have a module that is only ever used by 1 other module, you
> > > should probably just combine them. It saves memory and simplifies
> > > operation (eg you don't have to unload a zoo of modules during
> > > development testing)  
> > 
> > These are all great reasons for why iommufd should host this option, as
> > it's fundamentally part of the DMA isolation of the device, which vfio
> > relies on iommufd to provide in this case.   
> 
> Fine, lets do that.
> 
> > > Except this, I think we still should have iommufd compat with the
> > > current module ABI, so this should still get moved into vfio.ko and
> > > both vfio_iommu_type1.ko and vfio_iommufd.ko should jointly manipulate
> > > the same memory with their module options.  
> > 
> > Modules implicitly interacting in this way is exactly what I find so
> > terrible in the original proposal.  The idea of a stub type1 module to
> > preserve that uAPI was only proposed as a known terrible solution to the
> > problem.  
> 
> And I take it you prefer we remove this compat code as well and just
> leave the module option on vfio_type1 non-working?

In the case where userspace provides an iommufd for the container, yes,
the type1 module then isn't involved.
 
> > think it's fair to require a re-opt-in by the user.  In the latter
> > case, userspace is intentionally choosing to use a highly compatible
> > uAPI, but nonetheless, it's still a different uAPI.  
> 
> Well, the later case is likely going to be a choice made by the
> distribution, eg I would expect that libvirt will start automatically
> favoring iommufd if it is available.
> 
> So, instructions someone might find saying to tweak the module option
> and then use libvirt are going to stop working at some point.

libvirt doesn't currently pass any file descriptors for vfio devices in
QEMU, so we're looking a ways down the road here.  Once QEMU gains
native iommufd support, libvirt will launch QEMU in a way that
explicitly enables this iommufd support.  I'd expect libvirt might
implement this by creating a "vfio-legacy" vs "vfio-iommufd" driver
option, where "vfio" becomes an alias to one of those.  That allows both
a staged transition and a fallback for issues.  I'd expect a first
debugging step would be to fallback to legacy support.  But ultimately,
yes, in the rare case that this option is actually necessary, the admin
would need to re-opt-in, and hopefully a dmesg log from iommufd would
make it apparent this is the problem.

I just can't wrap my head around shared module options and stub drivers
being a sane solution simply to make this potentially rare condition
more transparent w/o reminding user's their setup has a vulnerability.

BTW, what is the actual expected use case of passing an iommufd as a
vfio container?  I have doubts that it'd make sense to have QEMU look
for an iommufd in place of a vfio container for anything beyond yet
another means for early testing of iommufd.  Thanks,

Alex

