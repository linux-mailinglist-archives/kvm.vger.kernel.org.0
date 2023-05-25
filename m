Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB82A711037
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 18:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241884AbjEYQAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241872AbjEYQAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 12:00:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DD519C
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 08:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685030383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TsUdauS8oAnL4ydDKikkdnZdQQ7qgtOSloz4PnB1yMk=;
        b=PwKax0Kjr6ZpWeMrsBt5sOzZKa0dtVLgOVlsZnDecUF/TRnNRbBFHCClIVnUyL8gc493wO
        gy/bJHebexCcv2/ONpppI4PMluwTG8C4TMu5H/cveTNGeVIr2NbZZUxJSE9t1OyFG1/092
        eH3h33jzCL9OgcHWGI1kLm2+sfVaSI4=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-GAITxKESPFmH5LVyJDkFpQ-1; Thu, 25 May 2023 11:59:42 -0400
X-MC-Unique: GAITxKESPFmH5LVyJDkFpQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-76c5c78bc24so447012839f.2
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 08:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685030382; x=1687622382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TsUdauS8oAnL4ydDKikkdnZdQQ7qgtOSloz4PnB1yMk=;
        b=MmnQzFIUSwWwXhyzWZBaBZsDy7C5eiJyVPIRIFh/j1U/B8IIjCXLzQtn25Uhtzwz75
         L7umytyqlj13cxgdZeZGvVgtbveYkpMQQkC2eRUdAZhRqVJJ7ZdAzgoRL4vfGN/UXiVh
         Jb/c3IgMv5QelIlP8+zlmKiEpAUHVlu2voS3UaYfJ7CActz2lgKh7+sGAu3oy5M93Lm7
         Zs0/6wCiPMwFSs6RKLwfA1GaKe4QfsXXSu+ubqpIjNeLqjuA0dBRvl6ujihEhI3L2H3h
         yZm8EHYAiD7kkGlB0GLOMjmQqjwxka6HYW7L7To+UEwKa7b/rlWJON4lPwJYFuuLIjOS
         jRMg==
X-Gm-Message-State: AC+VfDy+FyZA2YuEW1HgWHhUB7cSQEszj4htFmPBkCfEpdt+EX+qHcoa
        WTvm4aaViMvBTBt1lxqBuP7JNgRBBvRTTulEo3U5sRil+n1AxtEIXphBVDWO4oRCwJoa+bz8si8
        xkxP74Fu4Rf6G
X-Received: by 2002:a5e:cb0c:0:b0:774:8aee:7e5c with SMTP id p12-20020a5ecb0c000000b007748aee7e5cmr5771355iom.16.1685030381825;
        Thu, 25 May 2023 08:59:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6RmBKbvUUCpZ8rftXOee/+HrBYFX5cHIc3BcBvhdGn7Kpa+mHXP8Mk5ojhtIHMhIYkHJsEZA==
X-Received: by 2002:a5e:cb0c:0:b0:774:8aee:7e5c with SMTP id p12-20020a5ecb0c000000b007748aee7e5cmr5771328iom.16.1685030381540;
        Thu, 25 May 2023 08:59:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p4-20020a5d9844000000b00774861745efsm51591ios.49.2023.05.25.08.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 08:59:40 -0700 (PDT)
Date:   Thu, 25 May 2023 09:59:39 -0600
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
Subject: Re: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <20230525095939.37ddb8ce.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529407F01EE55AE4A0A9F1FC3469@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-21-yi.l.liu@intel.com>
        <20230522161534.32f3bf8e.alex.williamson@redhat.com>
        <DS0PR11MB7529096D1BE1D337BA50884BC3409@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230523095025.1898297c.alex.williamson@redhat.com>
        <DS0PR11MB75292161F081F27C0650EFB3C3419@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230524093142.3cac798e.alex.williamson@redhat.com>
        <DS0PR11MB7529407F01EE55AE4A0A9F1FC3469@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Thu, 25 May 2023 03:03:54 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, May 24, 2023 11:32 PM
> > 
> > On Wed, 24 May 2023 02:12:14 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, May 23, 2023 11:50 PM
> > > >
> > > > On Tue, 23 May 2023 01:20:17 +0000
> > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > >  
> > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Sent: Tuesday, May 23, 2023 6:16 AM
> > > > > >
> > > > > > On Sat, 13 May 2023 06:28:24 -0700
> > > > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > > > >  
> > > > > > >  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> > > > > > > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > > > > > > index 83575b65ea01..799ea322a7d4 100644
> > > > > > > --- a/drivers/vfio/iommufd.c
> > > > > > > +++ b/drivers/vfio/iommufd.c
> > > > > > > @@ -112,6 +112,24 @@ void vfio_iommufd_unbind(struct vfio_device_file *df)
> > > > > > >  		vdev->ops->unbind_iommufd(vdev);
> > > > > > >  }
> > > > > > >
> > > > > > > +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
> > > > > > > +{
> > > > > > > +	lockdep_assert_held(&vdev->dev_set->lock);
> > > > > > > +
> > > > > > > +	if (vfio_device_is_noiommu(vdev))
> > > > > > > +		return 0;  
> > > > > >
> > > > > > Isn't this an invalid operation for a noiommu cdev, ie. -EINVAL?  We
> > > > > > return success and copy back the provided pt_id, why would a user not
> > > > > > consider it a bug that they can't use whatever value was there with
> > > > > > iommufd?  
> > > > >
> > > > > Yes, this is the question I asked in [1]. At that time, it appears to me
> > > > > that better to allow it [2]. Maybe it's more suitable to ask it here.  
> > > >
> > > > From an API perspective it seems wrong.  We return success without
> > > > doing anything.  A user would be right to consider it a bug that the
> > > > attach operation works but there's not actually any association to the
> > > > IOAS.  Thanks,  
> > >
> > > The current version is kind of tradeoff based on prior remarks when
> > > I asked the question. As prior comment[2], it appears to me the attach
> > > shall success for noiommu devices as well, but per your remark it seems
> > > not in plan. So anyway, we may just fail the attach/detach for noiommu
> > > devices. Is it?  
> > 
> > If a user creates an ioas within an iommufd, attaches a device to that
> > ioas and populates it with mappings, wouldn't the user expect the
> > device to have access to and honor those mappings?  I think that's the
> > path we're headed down if we report a successful attach of a noiommu
> > device to an ioas.  
> 
> makes sense. Let's just fail attach/detach for noiommu devices.
> 
> > 
> > We need to keep in mind that noiommu was meant to be a minimally
> > intrusive mechanism to provide a dummy vfio IOMMU backend and satisfy
> > the group requirements, solely for the purpose of making use of the
> > vfio device interface and without providing any DMA mapping services or
> > expectations.  IMO, an argument that we need the attach op to succeed in
> > order to avoid too much disruption in userspace code is nonsense.  On
> > the contrary, userspace needs to be very aware of this difference and
> > we shouldn't invest effort trying to make noiommu more convenient to
> > use.  It's inherently unsafe.
> > 
> > I'm not fond of what a mess noiommu has become with cdev, we're well
> > beyond the minimal code trickery of the legacy implementation.  I hate
> > to ask, but could we reiterate our requirements for noiommu as a part of
> > the native iommufd interface for vfio?  The nested userspace requirement
> > is gone now that hypervisors have vIOMMU support, so my assumption is
> > that this is only for bare metal systems without an IOMMU, which
> > ideally are less and less prevalent.  Are there any noiommu userspaces
> > that are actually going to adopt the noiommu cdev interface?  What
> > terrible things happen if noiommu only exists in the vfio group compat
> > interface to iommufd and at some distant point in the future dies when
> > that gets disabled?  
> 
> vIOMMU may introduce some performance deduction if there
> are frequent map/unmap.

We use passthrough mode of the vIOMMU to negate that overhead for guest
drivers and vfio drivers have typically learned by now that dynamic
mappings using the vfio type1 mapping API are a bad idea.

> As far as I know, some cloud service
> providers are more willing to use noiommu mode within VM.

Sure, the VM itself is still isolated by the host IOMMU, but it's
clearly an extra maintenance and development burden when we should
instead be encouraging those use cases to use vIOMMU rather than
porting to a different noiommu uAPI.  Even if the host is not exposed,
any sort of security and support best practices in the guest should
favor a vIOMMU solution.

> Besides the performance consideration, using a booting a VM
> without vIOMMU is supposed to be more robust. But I'm not

What claims do you have to support lack of robustness in vIOMMU?  Can
they be fixed?

> sure if the noiommu userspace will adapt to cdev noiommu.
> Perhaps yes if group may be deprecated in future.

Deprecation is going to take a long time.  IMO, the VM use cases should
all be encouraged to adopt a vIOMMU solution rather than port to a new
cdev noiommu interface.  The question then is whether there are ongoing
bare metal noiommu use cases and how long those will drag out the vfio
group deprecation.  We could always add noiommu to the native vfio cdev
interface later if there's still demand.

> > > btw. Should we document it somewhere as well? E.g. noiommu userspace
> > > does not support attach/detach? Userspace should know it is opening
> > > noiommu devices.  
> > 
> > Documentation never hurts.  This is such a specialized use case I'm not
> > sure we've bothered to do much documentation for noiommu previously.  
> 
> Seems no, I didn't find special documentation for noiommu. Perhaps
> a comment in the source code is enough. Depends on your taste.

If we're only continuing the group compat noiommu support, I can't very
well require new documentation.  We have a simple model there, noiommu
devices only support the noiommu container type and provide no mapping
interfaces.  The iommufd interface relative to noiommu seems more
nuanced and probably needs to documentation should we decide to pursue
it. Thanks,

Alex

