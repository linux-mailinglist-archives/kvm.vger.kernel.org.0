Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7C15AB4B8
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbiIBPKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiIBPKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:10:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3BA20F64
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 07:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662129582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=teiYFeKW5yzBOg0cJdA5/v1IyYO7ODO4hr2SeOHEd5M=;
        b=F3NYNODn2ILZ6BjsyBtFJ2qzu+8BJdLcWWmToHcdMv0xJW85A7yu6pl6CGCZweEDvUKfNc
        grhJ6iKUZPv3rZ/mgn0HdrRdoPrHw9hiBvgXrkRHuUYWWEKpcVAg2oW4lVg4bwERYiJVf9
        ONaTj3NAbA4iA2oSmSm5Z9PmB7kUSPc=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-22-_jUGDX3CNuCOcdETaCoFkw-1; Fri, 02 Sep 2022 10:39:41 -0400
X-MC-Unique: _jUGDX3CNuCOcdETaCoFkw-1
Received: by mail-ot1-f70.google.com with SMTP id x64-20020a9d20c6000000b006372db8b20bso1182285ota.8
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 07:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=teiYFeKW5yzBOg0cJdA5/v1IyYO7ODO4hr2SeOHEd5M=;
        b=5XB1qNO/3zsc9khTg/lKUo1FWxV3dBvzR+uoKspbvhBfIz8E5a7l59OHF/uOn0QyZH
         Y5Nr8evK3A0+ejXKbBnQfGAmtQ/E/Zi8EskTz36cNFiUCgRQr4cU5jA/2bcQjNjq00UZ
         iQY0Hu3J8k2IyDci6WWZvNYl+l1thrEzGxOBUab1LiGyxPOKGIXmYHQpiNJcwHS3EVf3
         8heI+HPYSlzdDtzXbGyXqV0+P98/9e51j17kqjgsxH5yXYpxeFfrLhHldiMRIDwZH6G7
         gY5fCQySN8Siv7P5wDZpvWPQkT+BMkCGxMcS5D6sBdKCROmC2xWpJ3IUm06/VQPcO28Y
         ju/Q==
X-Gm-Message-State: ACgBeo2l24xQANSM5uaA3Epz4DXvuSofyidtve0dkkwkh+FTSLeEi7J4
        F5BDbLQsi1mw0sL3+QmX/LkRMJAB/FqmnyEO1jB+Ctx9aO+6YAbBj+xNeOZEGi3n0htLCKZaiGp
        k8eL2mdwTcNT6
X-Received: by 2002:a4a:946a:0:b0:43d:1ad2:ee16 with SMTP id j39-20020a4a946a000000b0043d1ad2ee16mr12607263ooi.40.1662129580597;
        Fri, 02 Sep 2022 07:39:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR49De7JUmkoWIwV3X61UV3NX0PbSNOIqc6erMzIUa1Mq+oxyoH5yjYEGWNP67/fmLvSiCfL1Q==
X-Received: by 2002:a4a:946a:0:b0:43d:1ad2:ee16 with SMTP id j39-20020a4a946a000000b0043d1ad2ee16mr12607255ooi.40.1662129580347;
        Fri, 02 Sep 2022 07:39:40 -0700 (PDT)
Received: from redhat.com ([98.55.18.59])
        by smtp.gmail.com with ESMTPSA id e28-20020a544f1c000000b003436fa2c23bsm1023357oiy.7.2022.09.02.07.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 07:39:40 -0700 (PDT)
Date:   Fri, 2 Sep 2022 08:39:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Message-ID: <20220902083934.7e6f6438.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276122C4CBAACB295DD15E78C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
        <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
        <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
        <YxFOPUaab8DZH9v8@nvidia.com>
        <BN9PR11MB5276122C4CBAACB295DD15E78C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Sep 2022 03:51:01 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, September 2, 2022 8:29 AM
> > 
> > On Wed, Aug 31, 2022 at 08:46:30AM +0000, Tian, Kevin wrote:  
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, August 31, 2022 9:02 AM
> > > >
> > > > To vfio_container_detatch_group(). This function is really a container
> > > > function.
> > > >
> > > > Fold the WARN_ON() into it as a precondition assertion.
> > > >
> > > > A following patch will move the vfio_container functions to their own .c
> > > > file.
> > > >
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > ---
> > > >  drivers/vfio/vfio_main.c | 11 +++++------
> > > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > > index bfa6119ba47337..e145c87f208f3a 100644
> > > > --- a/drivers/vfio/vfio_main.c
> > > > +++ b/drivers/vfio/vfio_main.c
> > > > @@ -928,12 +928,13 @@ static const struct file_operations vfio_fops = {
> > > >  /*
> > > >   * VFIO Group fd, /dev/vfio/$GROUP
> > > >   */
> > > > -static void __vfio_group_unset_container(struct vfio_group *group)
> > > > +static void vfio_container_detatch_group(struct vfio_group *group)  
> > >
> > > s/detatch/detach/  
> > 
> > Oops
> >   
> > > Given it's a vfio_container function is it better to have a container pointer
> > > as the first parameter, i.e.:
> > >
> > > static void vfio_container_detatch_group(struct vfio_container *container,
> > > 		struct vfio_group *group)  
> > 
> > Ah, I'm not so sure, it seems weird to make the caller do
> > group->container then pass the group in as well.
> > 
> > This call assumes the container is the container of the group, it
> > doesn't work in situations where that isn't true.  
> 
> Yes, this is a valid interpretation on doing this way.
> 
> Other places e.g. iommu_detach_group(domain, group) go the other way
> even if internally domain is not used at all. I kind of leave that pattern
> in mind thus raised this comment. But not a strong opinion.
> 
> > 
> > It is kind of weird layering in a way, arguably we should have the
> > current group stored in the container if we want things to work that
> > way, but that is a big change and not that wortwhile I think.
> > 
> > Patch 7 is pretty much the same, it doesn't work right unless the
> > container and device are already matched
> >   
> 
> If Alex won't have a different preference and with the typo fixed,

I don't get it, if a group is detaching itself from a container, why
isn't it vfio_group_detach_container().  Given our naming scheme,
vfio_container_detach_group() absolutely implies the args Kevin
suggests, even if they're redundant.  vfio_foo_* functions should
operate on a a vfio_foo object.  Thanks,

Alex

