Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69E572E5A5
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238902AbjFMOZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239766AbjFMOZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:25:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C02EC
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686666273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uNaTTX2jpfAAP/LJoW3TLJvil6qu1dd8mTfnU5F8em0=;
        b=Q8oVyZv87ec/kdtpyS0v9pUu7ugUnln9IyWdA9AlbXwHNZB20RYmZ/In2lzUNQqRcxxpX6
        vHbZrTlmKbTcGztGwq3g4P/0wXLf+0EMZ1D8UbIRzvwrD4RcmOtLZy33av2oEb7zB/ff0g
        Pxu/phordQPCvLtrkbxa52WbTwgawKw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-H28-iMXbN62_GhjfZc7Aug-1; Tue, 13 Jun 2023 10:24:30 -0400
X-MC-Unique: H28-iMXbN62_GhjfZc7Aug-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-33bf805e901so59603995ab.2
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686666270; x=1689258270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uNaTTX2jpfAAP/LJoW3TLJvil6qu1dd8mTfnU5F8em0=;
        b=AAcGdswFCZHGgyClM4VMJvUD2TpRO9xnfInuCuhwPzWIwzur7X0j80TVFmhlsEww//
         7Rv0wDrJDkoXTLeR/pMKk/2hZ2XZTJVYvkwjOlSH89DeY0LgpxxjMKdYBBsyLGTxba1T
         TYeCwv+7MlqBQicO6ZtaETZAzfDllRLGGtgguMCEKCyhqjPzMxjqNG5U+7wxtrGR+DKA
         gKej/MYPNCFGt5Oij56fBztRZzNiemdoiimjuHcfj6AS0ncVGsqNts7+uhxhoPB4xTRr
         XfqzehIZ6Q+JmQUUvo/OA/Uh42a4t46XMKg63XMX8snJqmke65LumKfAM3q6pF9JvrK+
         8C2w==
X-Gm-Message-State: AC+VfDxkpQQ+DgTO6zyMVEEQfi2nkAeWDqF9kG6bZfQfZ7cSIaKbdQiO
        pwdvTqaFyexgRoeNasNSb7awyacExh2WW+uuH7NxDWoqCvUH59l4WSFxPDUFvFf/RJTqaicEWXW
        A49s6uX5CjuRs
X-Received: by 2002:a92:d7cd:0:b0:32b:5e:e22a with SMTP id g13-20020a92d7cd000000b0032b005ee22amr10786003ilq.17.1686666269816;
        Tue, 13 Jun 2023 07:24:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5KU1E6AFjVveX2o9hXRzGdCkKtng9KR4tZYBJtO5BSqSOb3FWAM0AzE8jKPCez7h5MNkFahQ==
X-Received: by 2002:a92:d7cd:0:b0:32b:5e:e22a with SMTP id g13-20020a92d7cd000000b0032b005ee22amr10785970ilq.17.1686666269583;
        Tue, 13 Jun 2023 07:24:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ee24-20020a056638293800b0041658c1838asm3436802jab.81.2023.06.13.07.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:24:29 -0700 (PDT)
Date:   Tue, 13 Jun 2023 08:24:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v12 24/24] docs: vfio: Add vfio device cdev description
Message-ID: <20230613082427.453748f5.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529B0A71849EA06DA953BBCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-25-yi.l.liu@intel.com>
        <20230612170628.661ab2a6.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A71849EA06DA953BBCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Tue, 13 Jun 2023 12:01:51 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 7:06 AM
> > 
> > On Fri,  2 Jun 2023 05:16:53 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> > > This gives notes for userspace applications on device cdev usage.
> > >
> > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  Documentation/driver-api/vfio.rst | 132 ++++++++++++++++++++++++++++++
> > >  1 file changed, 132 insertions(+)
> > >
> > > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> > > index 363e12c90b87..f00c9b86bda0 100644
> > > --- a/Documentation/driver-api/vfio.rst
> > > +++ b/Documentation/driver-api/vfio.rst
> > > @@ -239,6 +239,130 @@ group and can access them as follows::
> > >  	/* Gratuitous device reset and go... */
> > >  	ioctl(device, VFIO_DEVICE_RESET);
> > >
> > > +IOMMUFD and vfio_iommu_type1
> > > +----------------------------
> > > +
> > > +IOMMUFD is the new user API to manage I/O page tables from userspace.
> > > +It intends to be the portal of delivering advanced userspace DMA
> > > +features (nested translation [5]_, PASID [6]_, etc.) while also providing
> > > +a backwards compatibility interface for existing VFIO_TYPE1v2_IOMMU use
> > > +cases.  Eventually the vfio_iommu_type1 driver, as well as the legacy
> > > +vfio container and group model is intended to be deprecated.
> > > +
> > > +The IOMMUFD backwards compatibility interface can be enabled two ways.
> > > +In the first method, the kernel can be configured with
> > > +CONFIG_IOMMUFD_VFIO_CONTAINER, in which case the IOMMUFD subsystem
> > > +transparently provides the entire infrastructure for the VFIO
> > > +container and IOMMU backend interfaces.  The compatibility mode can
> > > +also be accessed if the VFIO container interface, ie. /dev/vfio/vfio is
> > > +simply symlink'd to /dev/iommu.  Note that at the time of writing, the
> > > +compatibility mode is not entirely feature complete relative to
> > > +VFIO_TYPE1v2_IOMMU (ex. DMA mapping MMIO) and does not attempt to
> > > +provide compatibility to the VFIO_SPAPR_TCE_IOMMU interface.  Therefore
> > > +it is not generally advisable at this time to switch from native VFIO
> > > +implementations to the IOMMUFD compatibility interfaces.
> > > +
> > > +Long term, VFIO users should migrate to device access through the cdev
> > > +interface described below, and native access through the IOMMUFD
> > > +provided interfaces.
> > > +
> > > +VFIO Device cdev
> > > +----------------
> > > +
> > > +Traditionally user acquires a device fd via VFIO_GROUP_GET_DEVICE_FD
> > > +in a VFIO group.
> > > +
> > > +With CONFIG_VFIO_DEVICE_CDEV=y the user can now acquire a device fd
> > > +by directly opening a character device /dev/vfio/devices/vfioX where
> > > +"X" is the number allocated uniquely by VFIO for registered devices.
> > > +cdev interface does not support noiommu, so user should use the legacy
> > > +group interface if noiommu is needed.
> > > +
> > > +The cdev only works with IOMMUFD.  Both VFIO drivers and applications
> > > +must adapt to the new cdev security model which requires using
> > > +VFIO_DEVICE_BIND_IOMMUFD to claim DMA ownership before starting to
> > > +actually use the device.  Once BIND succeeds then a VFIO device can
> > > +be fully accessed by the user.
> > > +
> > > +VFIO device cdev doesn't rely on VFIO group/container/iommu drivers.
> > > +Hence those modules can be fully compiled out in an environment
> > > +where no legacy VFIO application exists.
> > > +
> > > +So far SPAPR does not support IOMMUFD yet.  So it cannot support device
> > > +cdev neither.  
> > 
> > s/neither/either/  
> 
> Got it.
> 
> > 
> > Unless I missed it, we've not described that vfio device cdev access is
> > still bound by IOMMU group semantics, ie. there can be one DMA owner
> > for the group.  That's a pretty common failure point for multi-function
> > consumer device use cases, so the why, where, and how it fails should
> > be well covered.  
> 
> Yes. this needs to be documented. How about below words:
> 
> vfio device cdev access is still bound by IOMMU group semantics, ie. there
> can be only one DMA owner for the group.  Devices belonging to the same
> group can not be bound to multiple iommufd_ctx.

... or shared between native kernel and vfio drivers.


>  The users that try to bind
> such device to different iommufd shall be failed in VFIO_DEVICE_BIND_IOMMUFD
> which is the start point to get full access for the device.

"A violation of this ownership requirement will fail at the
VFIO_DEVICE_BIND_IOMMUFD ioctl, which gates full device access."

Thanks,
Alex

