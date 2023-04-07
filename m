Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C107F6DAE75
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjDGN5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 09:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjDGN5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 09:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BED10D1
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 06:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680875712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5oB5DxaREwrVRr8+bFg0rReMg3cK5Dvz3xm2hNY4dxU=;
        b=cerFXZMQmAhgTYf+J2p75VkZ9+iUF3MfZU4k6XjPB7QwME50Azx1/hgYoR5Px2OQHaNbAg
        Ym+IYAkKlIP3SAbkorLiuD2/Szm6IESpGaMbJSeH79xBzSanTbGwihzJ/ZJxDhB71dU3KX
        LWXwHY61eqvQq3S1h5TZou+MOHZTtxY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-IbZOgi6DPP6Stqc_YS-uWw-1; Fri, 07 Apr 2023 09:52:00 -0400
X-MC-Unique: IbZOgi6DPP6Stqc_YS-uWw-1
Received: by mail-il1-f197.google.com with SMTP id c6-20020a056e020bc600b00325da077351so27526237ilu.11
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 06:52:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875520; x=1683467520;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5oB5DxaREwrVRr8+bFg0rReMg3cK5Dvz3xm2hNY4dxU=;
        b=pz4iMqirNATabzVncXP+lD6Fw98zLhhY03BRkZqSsAhs8GnlDb0RIfXvykQH7/vG4I
         Oiy5NYL5IF+3WRktQHS1uma9WQgG+D17asacN6SU2PkfRCogU0nbl6gyHnLOEbntkQc1
         8WrR2u9njPYsP/1Lf8Zm+41x6hzd1VxkMcfkcG7sBY0p0D2yn3aGa1VbcHPN2EXfWQ4U
         b9oTe+QKZvCG9E9x/uVXODa0rVJY1bhn7BSnnHsoOPvHfA9aPQIyLAQ/GiTILEtegscu
         N55wXqZAbTF5/To8vGVK+l4iZpbYdwBAPGMhykIlLK8yW/GCnjHsvTXYMdDULUuArVk0
         07Xw==
X-Gm-Message-State: AAQBX9cgyaikupYwHUPdhhHyVLHaBsM+FEgjt/XiMo7J9Eayq90U0/eb
        JfsMAa8FM5WqNlCg1+Az1gpb45BNCP8YbOO3jBMbqdp7SYBzR9rQjq7TF8yeWpfWerHJ7wuhXx2
        ueSFjxO5zK+pN
X-Received: by 2002:a92:d48f:0:b0:328:6172:a743 with SMTP id p15-20020a92d48f000000b003286172a743mr443850ilg.17.1680875519894;
        Fri, 07 Apr 2023 06:51:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zt5SmVHCjY2WY3fhBLjS2FZtxV74Lk/zdXvq7uKSlH13byRx8CMKnoBIxJ5VwJKvWvSSSNGA==
X-Received: by 2002:a92:d48f:0:b0:328:6172:a743 with SMTP id p15-20020a92d48f000000b003286172a743mr443824ilg.17.1680875519642;
        Fri, 07 Apr 2023 06:51:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s28-20020a02b15c000000b00374fa5b600csm1112214jah.0.2023.04.07.06.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:51:59 -0700 (PDT)
Date:   Fri, 7 Apr 2023 07:51:55 -0600
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230407075155.3ad4c804.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407060335.7babfeb8.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Apr 2023 13:24:25 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 7, 2023 8:04 PM
> >   
> > > > > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void  
> > > > *data)  
> > > > > >  	if (!iommu_group)
> > > > > >  		return -EPERM; /* Cannot reset non-isolated devices */  
> 
> [1]
> 
> > > > >
> > > > > Hi Alex,
> > > > >
> > > > > Is disabling iommu a sane way to test vfio noiommu mode?  
> > > >
> > > > Yes
> > > >  
> > > > > I added intel_iommu=off to disable intel iommu and bind a device to vfio-pci.
> > > > > I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices/noiommu-vfio0. Bind
> > > > > iommufd==-1 can succeed, but failed to get hot reset info due to the above
> > > > > group check. Reason is that this happens to have some affected devices, and
> > > > > these devices have no valid iommu_group (because they are not bound to vfio-  
> > pci  
> > > > > hence nobody allocates noiommu group for them). So when hot reset info loops
> > > > > such devices, it failed with -EPERM. Is this expected?  
> > > >
> > > > Hmm, I didn't recall that we put in such a limitation, but given the
> > > > minimally intrusive approach to no-iommu and the fact that we never
> > > > defined an invalid group ID to return to the user, it makes sense that
> > > > we just blocked the ioctl for no-iommu use.  I guess we can do the same
> > > > for no-iommu cdev.  
> > >
> > > I just realize a further issue related to this limitation. Remember that we
> > > may finally compile out the vfio group infrastructure in the future. Say I
> > > want to test noiommu, I may boot such a kernel with iommu disabled. I think
> > > the _INFO ioctl would fail as there is no iommu_group. Does it mean we will
> > > not support hot reset for noiommu in future if vfio group infrastructure is
> > > compiled out?  
> > 
> > We're talking about IOMMU groups, IOMMU groups are always present
> > regardless of whether we expose a vfio group interface to userspace.
> > Remember, we create IOMMU groups even in the no-iommu case.  Even with
> > pure cdev, there are underlying IOMMU groups that maintain the DMA
> > ownership.  
> 
> hmmm. As [1], when iommu is disabled, there will be no iommu_group for a
> given device unless it is registered to VFIO, which a fake group is created.
> That's why I hit the limitation [1]. When vfio_group is compiled out, then
> even fake group goes away.

In the vfio group case, [1] can be hit with no-iommu only when there
are affected devices which are not bound to vfio.  Why are we not
allocating an IOMMU group to no-iommu devices when vfio group is
disabled?  Thanks,

Alex

