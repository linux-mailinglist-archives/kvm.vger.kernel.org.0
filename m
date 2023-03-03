Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6456A9C7E
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 17:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCCQ5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 11:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjCCQ5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 11:57:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508DC5F22B
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 08:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677862547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wQaN2w6WPy4qe2LbDS5GqBL5o5ir0ZpFEJOy/c7VAXk=;
        b=f+hRDWMxaVGlaJN+L9wHB0jx84cVR9Qt7mGOeEgSe/aPZ6DzIyP42e70rC+4suLffz3fip
        2SBbUOsYrBIkDc9dlfNonnSZRUy0pMO3NzrJuGoCq6KOTaclPl277HH0YD4rlXG2DraG9P
        4yzoBNx4XSL9yhyv4vam7sEZvYbRpW4=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-SUdgHrG-OmuY9015pLdrow-1; Fri, 03 Mar 2023 11:55:46 -0500
X-MC-Unique: SUdgHrG-OmuY9015pLdrow-1
Received: by mail-il1-f199.google.com with SMTP id l5-20020a92d8c5000000b00316f26477d6so1613864ilo.10
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 08:55:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wQaN2w6WPy4qe2LbDS5GqBL5o5ir0ZpFEJOy/c7VAXk=;
        b=ujWdr6Elsgsn0tt1WtvPGFQB7PWzsoYNADfwa3pOIs/up1vVb0wmY9sFfbq2/R/o7/
         NskOS4cq2vugn3u3ebflkI2OTAkgk1mJxIMtVo4Bp/Axc3unYrOGQLITIc9FZ19NEbVB
         aW0ZW4f6HMVHbTBQ+VJDW4RMSCl2JQFucrY5AcLOu3veFvx3YR/GU3AKvj0XhypgBmY4
         6VZALvuQ77E1lBp4r3rLkCEKeS5QTlkUOs4FNEazusFcCpA5h363KlbPb8WwRMaZ1ytN
         OwED2Rre+lBVqsQKYK+sFDjznqNqpev3EVgTVFjUtWgDMkoOhIGnEsVfRqLZkq7ScNJb
         AJ5w==
X-Gm-Message-State: AO0yUKWcWrWCzvGePTSD13ScOyNMDoIDEWoJxoa7+rKAvGEofIaQ/NJN
        HKiBpBi1DZxU+euF5ZXcAr4VRY/vE+8N7ubn8APjsI3DDWpIqchWP2ch2ABy/VxevYr5w+yFarV
        k9Wg8dckgIIWX
X-Received: by 2002:a05:6e02:1b0b:b0:314:e56:54fc with SMTP id i11-20020a056e021b0b00b003140e5654fcmr2317785ilv.1.1677862546143;
        Fri, 03 Mar 2023 08:55:46 -0800 (PST)
X-Google-Smtp-Source: AK7set+zTdgOdL+Cvm/GHdzHlk9qNHC8FUzt7q1k0ffumCIR03rPcZWQtCDbvcczq+7wSTu39R/sFQ==
X-Received: by 2002:a05:6e02:1b0b:b0:314:e56:54fc with SMTP id i11-20020a056e021b0b00b003140e5654fcmr2317767ilv.1.1677862545900;
        Fri, 03 Mar 2023 08:55:45 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p5-20020a02b385000000b003de9d8de0edsm871392jan.88.2023.03.03.08.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 08:55:44 -0800 (PST)
Date:   Fri, 3 Mar 2023 09:55:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array
 in VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230303095542.2bfce5c2.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
        <20230227111135.61728-10-yi.l.liu@intel.com>
        <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZACX+Np/IY7ygqL5@nvidia.com>
        <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 Mar 2023 06:36:35 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Thursday, March 2, 2023 10:20 PM
> >  =20
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, March 2, 2023 8:35 PM
> > >
> > > On Thu, Mar 02, 2023 at 09:55:46AM +0000, Tian, Kevin wrote: =20
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Thursday, March 2, 2023 2:07 PM
> > > > > =20
> > > > > > -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> > > > > > +		if (cur_vma->vdev.open_count &&
> > > > > > +		    !vfio_dev_in_groups(cur_vma, groups) &&
> > > > > > +		    !vfio_dev_in_iommufd_ctx(cur_vma, =20
> > iommufd_ctx)) { =20
> > > > >
> > > > > Hi Alex, Jason,
> > > > >
> > > > > There is one concern on this approach which is related to the
> > > > > cdev noiommu mode. As patch 16 of this series, cdev path
> > > > > supports noiommu mode by passing a negative iommufd to
> > > > > kernel. In such case, the vfio_device is not bound to a valid
> > > > > iommufd. Then the check in vfio_dev_in_iommufd_ctx() is
> > > > > to be broken.
> > > > >
> > > > > An idea is to add a cdev_noiommu flag in vfio_device, when
> > > > > checking the iommufd_ictx, also check this flag. If all the opened
> > > > > devices in the dev_set have vfio_device->cdev_noiommu=3D=3Dtrue,
> > > > > then the reset is considered to be doable. But there is a special
> > > > > case. If devices in this dev_set are opened by two applications
> > > > > that operates in cdev noiommu mode, then this logic is not able
> > > > > to differentiate them. In that case, should we allow the reset?
> > > > > It seems to ok to allow reset since noiommu mode itself means
> > > > > no security between the applications that use it. thoughts?
> > > > > =20
> > > >
> > > > Probably we need still pass in a valid iommufd (instead of using
> > > > a negative value) in noiommu case to mark the ownership so the
> > > > check in the reset path can correctly catch whether an opened
> > > > device belongs to this user. =20
> > >
> > > There should be no iommufd at all in no-iommu mode
> > >
> > > Adding one just to deal with noiommu reset seems pretty sad :\
> > >
> > > no-iommu is only really used by dpdk, and it doesn't invoke
> > > VFIO_DEVICE_PCI_HOT_RESET at all. =20
> >=20
> > Does it happen to be or by design, this ioctl is not needed by dpdk? =20

I can't think of a reason DPDK couldn't use hot-reset.  If we want to
make it a policy, it should be enforced by code, but creating that
policy based on a difficulty in supporting that mode with iommufd isn't
great.
=20
> use of noiommu should be discouraged.
>=20
> if only known noiommu user doesn't use it then having certain
> new restriction for noiommu in the hot reset path might be an
> acceptable tradeoff.
>=20
> but again needs Alex's input as he knows all the history about
> noiommu. =F0=9F=98=8A

No-IOMMU mode was meant to be a minimally invasive code change to
re-use the vfio device interface, or alternatively avoid extending
uio-pci-generic to support MSI/X, with better logging/tainting to know
when userspace is driving devices without IOMMU protection, and as a
means to promote a transition to standard support of vfio.  AFAIK,
there are still environments without v/IOMMU that make use of no-iommu
mode.  Thanks,

Alex

