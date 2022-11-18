Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1428A62FEEC
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 21:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiKRUht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 15:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKRUhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 15:37:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98462A424
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 12:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668803812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ye+hdJn0iMAY7H28RR1S50v1wOqLDToomQpV+Fm4bWY=;
        b=Xz5Ev0elEymDSk7KVnS6fk9ixx/g/yCKMdxI5JfBW/m2h6kYn6PmxNk5BFj1WI+iM6xG5I
        iyr0+1F/5sBzBCH3MPD9RA8HWoHVbZkFvcBch7hIknPeNid5D1ApDzV5JKd/eW3+Oxqnbv
        5+RY6RJt/Cdorcba0hIf1zOKEpHpVTo=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-339-2WoLzY_YOkymCMecZcOwmg-1; Fri, 18 Nov 2022 15:36:51 -0500
X-MC-Unique: 2WoLzY_YOkymCMecZcOwmg-1
Received: by mail-il1-f198.google.com with SMTP id k3-20020a92c243000000b0030201475a6bso4006452ilo.9
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 12:36:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ye+hdJn0iMAY7H28RR1S50v1wOqLDToomQpV+Fm4bWY=;
        b=KKOGWV2PpLbePiK21XzjB+xi9TL6bzOnDOYySCZg71kB9bO9KnJeL3BoXH/U//XKJr
         jMR9mmLz5vT8uSp2vtHNpkfcnCcCYh4laU92fGwBfqLnbypWQQS0jOYKuOZJdN1uFHrh
         IqwVnjnqO3PodPZe+a6vwscXtjSn+gNybQLLE24BpAZSz0s+lqgHc0mu7/FkQgfcNwdh
         mqxWC95xY+DarSf87qfpTNS4nZ8pI6nmsDzWOvRzerLDdfa7AFzvIeGIZtSe4l5ETHCh
         cUXrX0dzo4yMl4X9/Y58YGIvBTk4Z6omqKSDoSOLEDa+bBieT8Zb/Rm6VGm60OHjDT9I
         KkPw==
X-Gm-Message-State: ANoB5pm2B482X+ViA1hqgxoLK5VgL5hsxxnI2TRdzlQhjwNLZg9t/D8v
        y6OiJTCax2D6zETiSi0pAeZqKXxG76VVlUkTDUTnEdHEJQiacHa8obuFJuS9FOHWHL39mfqvbVB
        28Eqo/PYxcMAP
X-Received: by 2002:a05:6602:1843:b0:6d9:a2bf:54ae with SMTP id d3-20020a056602184300b006d9a2bf54aemr4175705ioi.23.1668803810609;
        Fri, 18 Nov 2022 12:36:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7ogsl2l3Wr9uTRsCzD5sd9iPG8eC4TzKBnWEzI3gz1EZKyvMqAniGP0QId9tYD9QNXh+mYmw==
X-Received: by 2002:a05:6602:1843:b0:6d9:a2bf:54ae with SMTP id d3-20020a056602184300b006d9a2bf54aemr4175697ioi.23.1668803810362;
        Fri, 18 Nov 2022 12:36:50 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b00300d658f4b6sm1556385ilm.19.2022.11.18.12.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 12:36:49 -0800 (PST)
Date:   Fri, 18 Nov 2022 13:36:46 -0700
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
Message-ID: <20221118133646.7c6421e7.alex.williamson@redhat.com>
In-Reply-To: <Y3embh+09Fqu26wJ@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
        <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
        <20221117131451.7d884cdc.alex.williamson@redhat.com>
        <Y3embh+09Fqu26wJ@nvidia.com>
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

On Fri, 18 Nov 2022 11:36:14 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Nov 17, 2022 at 01:14:51PM -0700, Alex Williamson wrote:
> > On Wed, 16 Nov 2022 17:05:29 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > This legacy module knob has become uAPI, when set on the vfio_iommu_type1
> > > it disables some security protections in the iommu drivers. Move the
> > > storage for this knob to vfio_main.c so that iommufd can access it too.
> > > 
> > > The may need enhancing as we learn more about how necessary
> > > allow_unsafe_interrupts is in the current state of the world. If vfio
> > > container is disabled then this option will not be available to the user.
> > > 
> > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > Tested-by: Yi Liu <yi.l.liu@intel.com>
> > > Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > Tested-by: Yu He <yu.he@intel.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/vfio/vfio.h             | 2 ++
> > >  drivers/vfio/vfio_iommu_type1.c | 5 ++---
> > >  drivers/vfio/vfio_main.c        | 3 +++
> > >  3 files changed, 7 insertions(+), 3 deletions(-)  
> > 
> > It's really quite trivial to convert to a vfio_iommu.ko module to host
> > a separate option for this.  Half of the patch below is undoing what's
> > done here.  Is your only concern with this approach that we use a few
> > KB more memory for the separate module?  
> 
> My main dislike is that it just seems arbitary to shunt iommufd
> support to a module when it is always required by vfio.ko. In general
> if you have a module that is only ever used by 1 other module, you
> should probably just combine them. It saves memory and simplifies
> operation (eg you don't have to unload a zoo of modules during
> development testing)

These are all great reasons for why iommufd should host this option, as
it's fundamentally part of the DMA isolation of the device, which vfio
relies on iommufd to provide in this case.  Adding a module option to
vfio.ko conflicts with the existing option on vfio_iommu_type1.ko,
which leads to the problem of duplicate module options manipulating the
same variable, or options that disappear when other modules are
deprecated, which are both issues I have with the originally proposed
code.  Since iommufd won't accept such an option, we maintain the
logical association via modularizing the vfio interface to iommufd.

> If it wasn't for the module option ABI problem I would propse to merge
> vfio_type1/spapr into vfio.ko too - vfio.ko doesn't work without them
> and the module soft dependencies are hint something is weird here.

In fact no-iommu mode works w/o them.

> An alternative suggestion is to just retain a stub vfio_iommu_type1.ko
> which only exposes the module option if iommufd is enabled. At least
> this would preserve the semi-ABI.

See below.

> However, if you think this fits your vision for VFIO better I will
> take it.
> 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 186e33a006d3..23c24fe98c00 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -44,8 +44,9 @@
> >  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> >  #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
> >  
> > +static bool allow_unsafe_interrupts;
> >  module_param_named(allow_unsafe_interrupts,
> > -		   vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> > +		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> >  MODULE_PARM_DESC(allow_unsafe_interrupts,
> >  		 "Enable VFIO IOMMU support for on platforms without
> >  interrupt remapping support.");  
> 
> Except this, I think we still should have iommufd compat with the
> current module ABI, so this should still get moved into vfio.ko and
> both vfio_iommu_type1.ko and vfio_iommufd.ko should jointly manipulate
> the same memory with their module options.

Modules implicitly interacting in this way is exactly what I find so
terrible in the original proposal.  The idea of a stub type1 module to
preserve that uAPI was only proposed as a known terrible solution to the
problem.

The more I think about it, the less convinced I am that the kernel has
a responsibility to automatically carry forward the behavior of a
module option for a module that's no longer used.  The only way we make
use of IOMMUFD is if either the distribution has opt'd to disable
VFIO_CONTAINER and enable IOMMUFD emulation or userspace has opt'd to
pass an iommufd to vfio rather than a container.  The former could only
be forced after a deprecation period for VFIO_CONTAINER, after which I
think it's fair to require a re-opt-in by the user.  In the latter
case, userspace is intentionally choosing to use a highly compatible
uAPI, but nonetheless, it's still a different uAPI.

Thus the proposal here for a separate, but equivalent module option in
the vfio interface to iommufd.  Let's also not forget that at it's
core, this option is an opt-in to allow less secure configurations.
It's prudent to tread lightly with automatically carrying it forward.
Thanks,

Alex

