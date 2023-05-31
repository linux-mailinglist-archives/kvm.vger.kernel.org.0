Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC85718860
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 19:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjEaRWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 13:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjEaRWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 13:22:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD50101
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 10:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685553710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=unoADcy00HURTkExTqZPRFYBUmgfMnSVQyq5zSCV++k=;
        b=jMpYoSUuoPoaHkpsmRra0eZNiNfEZEpitH7ZdRu8DnsMfqyWMPbBXVkKRj8CaaewZ9dBF4
        AJip0bcV0nZ28gM4hBhIkZFdP2IgiUsvDXsYQ0abSwi6zm2rEmE2Fjx1CjHgWdwFTiuo8G
        Xy2L4qFSY5zrnpi90cx4oGaEkW+Eh2E=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-fXuek4BGNwe3zUifi5fUAA-1; Wed, 31 May 2023 13:21:49 -0400
X-MC-Unique: fXuek4BGNwe3zUifi5fUAA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33b372d1deeso24712955ab.3
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 10:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685553709; x=1688145709;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=unoADcy00HURTkExTqZPRFYBUmgfMnSVQyq5zSCV++k=;
        b=ljX6LCrteAOOZiM7xUcXP4nwrFWtg9Bt+7SVNydEOROjdk/B4ftqZOCndSuuRnRSxJ
         nPTA1OlAK2U/RTvb4Ep8LJr9lNCTOUxqbF40nrNeAQ8zbYqgfC6Ty5BgKBO2heOwmKmj
         exxN29l47VlF7sHqggjU6e4VKYeVYOli82g8tG+kUEH+7RCl2p9WHSJQlQ/BmTqIemuO
         8cLZCaSXshZIHl7O0e8qHr03pq1HI2dOz+MxmImzI0yDMZ9Y5tF3uuxlt0PppzYfIPBJ
         B7zk4wb3Tp6eSp6LSU5aAwy9O6T2X586x7RgJh7ujBY+eu+0kWUiwNKSzcU5Rxvf6FkD
         HvkA==
X-Gm-Message-State: AC+VfDxFqi7vodhSNZzKS/ViCwKTug8AarK+7zrx7eRX0nMRSOONICi8
        DfNuYdlFC+LgokhXLh+HtPt9GUhQdXiBOsRGTksOd6xPOYal6T9+tse0eBsebx3T8mDM5l+HCGz
        UOTRTlA0e1dub
X-Received: by 2002:a92:d405:0:b0:33b:f86:d2ac with SMTP id q5-20020a92d405000000b0033b0f86d2acmr2382580ilm.1.1685553708758;
        Wed, 31 May 2023 10:21:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6P0oEgVKY8TVz/ygEwiXD57KJ2zlUOMBxDT4c1n3wyxsizN9qCiBQXW87HVXgkIWREJnNksQ==
X-Received: by 2002:a92:d405:0:b0:33b:f86:d2ac with SMTP id q5-20020a92d405000000b0033b0f86d2acmr2382558ilm.1.1685553708472;
        Wed, 31 May 2023 10:21:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m2-20020a0566380dc200b0040fd1340997sm1614894jaj.140.2023.05.31.10.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 10:21:47 -0700 (PDT)
Date:   Wed, 31 May 2023 11:21:46 -0600
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
Subject: Re: [PATCH v6 10/10] vfio/pci: Allow passing zero-length fd array
 in VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230531112146.7950d01a.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75298C069D298D29D9B7B459C34B9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
        <20230522115751.326947-11-yi.l.liu@intel.com>
        <20230524141956.3655fab5.alex.williamson@redhat.com>
        <DS0PR11MB75298C069D298D29D9B7B459C34B9@DS0PR11MB7529.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 May 2023 04:23:12 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, May 25, 2023 4:20 AM
> > 
> > On Mon, 22 May 2023 04:57:51 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> > > This is the way user to invoke hot-reset for the devices opened by cdev
> > > interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED
> > > in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
> > > hot-reset for cdev devices.
> > >
> > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_core.c | 56 +++++++++++++++++++++++++-------
> > >  include/uapi/linux/vfio.h        | 14 ++++++++
> > >  2 files changed, 59 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > > index 890065f846e4..67f1cb426505 100644
> > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > @@ -181,7 +181,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device  
> > *vdev)  
> > >  struct vfio_pci_group_info;
> > >  static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
> > >  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> > > -				      struct vfio_pci_group_info *groups);
> > > +				      struct vfio_pci_group_info *groups,
> > > +				      struct iommufd_ctx *iommufd_ctx);
> > >
> > >  /*
> > >   * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
> > > @@ -1301,8 +1302,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct  
> > vfio_pci_core_device *vdev,  
> > >  	if (ret)
> > >  		return ret;
> > >
> > > -	/* Somewhere between 1 and count is OK */
> > > -	if (!array_count || array_count > count)
> > > +	if (array_count > count || vfio_device_cdev_opened(&vdev->vdev))
> > >  		return -EINVAL;
> > >
> > >  	group_fds = kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
> > > @@ -1351,7 +1351,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct  
> > vfio_pci_core_device *vdev,  
> > >  	info.count = array_count;
> > >  	info.files = files;
> > >
> > > -	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
> > > +	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
> > >
> > >  hot_reset_release:
> > >  	for (file_idx--; file_idx >= 0; file_idx--)
> > > @@ -1380,7 +1380,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct  
> > vfio_pci_core_device *vdev,  
> > >  	else if (pci_probe_reset_bus(vdev->pdev->bus))
> > >  		return -ENODEV;
> > >
> > > -	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
> > > +	if (hdr.count)
> > > +		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
> > > +
> > > +	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
> > > +					  vfio_iommufd_device_ictx(&vdev->vdev));
> > >  }
> > >
> > >  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
> > > @@ -2347,13 +2351,16 @@ const struct pci_error_handlers  
> > vfio_pci_core_err_handlers = {  
> > >  };
> > >  EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
> > >
> > > -static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> > > +static bool vfio_dev_in_groups(struct vfio_device *vdev,
> > >  			       struct vfio_pci_group_info *groups)
> > >  {
> > >  	unsigned int i;
> > >
> > > +	if (!groups)
> > > +		return false;
> > > +
> > >  	for (i = 0; i < groups->count; i++)
> > > -		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> > > +		if (vfio_file_has_dev(groups->files[i], vdev))
> > >  			return true;
> > >  	return false;
> > >  }
> > > @@ -2429,7 +2436,8 @@ static int vfio_pci_dev_set_pm_runtime_get(struct  
> > vfio_device_set *dev_set)  
> > >   * get each memory_lock.
> > >   */
> > >  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> > > -				      struct vfio_pci_group_info *groups)
> > > +				      struct vfio_pci_group_info *groups,
> > > +				      struct iommufd_ctx *iommufd_ctx)
> > >  {
> > >  	struct vfio_pci_core_device *cur_mem;
> > >  	struct vfio_pci_core_device *cur_vma;
> > > @@ -2459,11 +2467,37 @@ static int vfio_pci_dev_set_hot_reset(struct  
> > vfio_device_set *dev_set,  
> > >  		goto err_unlock;
> > >
> > >  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
> > > +		bool owned;
> > > +
> > >  		/*
> > > -		 * Test whether all the affected devices are contained by the
> > > -		 * set of groups provided by the user.
> > > +		 * Test whether all the affected devices can be reset by the
> > > +		 * user.
> > > +		 *
> > > +		 * If the user provides a set of groups, all the devices
> > > +		 * in the dev_set should be contained by the set of groups
> > > +		 * provided by the user.  
> > 
> > "If called from a group opened device and the user provides a set of
> > groups,..."
> >   
> > > +		 *
> > > +		 * If the user provides a zero-length group fd array, then  
> > 
> > "If called from a cdev opened device and the user provides a
> > zero-length array,..."
> > 
> >   
> > > +		 * all the devices in the dev_set must be bound to the same
> > > +		 * iommufd_ctx as the input iommufd_ctx.  If there is any
> > > +		 * device that has not been bound to iommufd_ctx yet, check
> > > +		 * if its iommu_group has any device bound to the input
> > > +		 * iommufd_ctx Such devices can be considered owned by  
> > 
> > "."...........................^  
> 
> Thanks, above comments well received.
> 
> > > +		 * the input iommufd_ctx as the device cannot be owned
> > > +		 * by another iommufd_ctx when its iommu_group is owned.
> > > +		 *
> > > +		 * Otherwise, reset is not allowed.  
> > 
> > 
> > In the case where a non-null array is provided,
> > vfio_pci_ioctl_pci_hot_reset_groups() explicitly tests
> > vfio_device_cdev_opened(), so we exclude cdev devices from providing a
> > group list.   
> 
> Yes.
> 
> > However, what prevents a compat opened group device from
> > providing a null array?  
> 
> I think I've asked this question before. What I got is seems no need
> to prevent it[1].
> 
> [1] https://lore.kernel.org/kvm/BN9PR11MB5276ABE919C04E06A0326E8E8CBC9@BN9PR11MB5276.namprd11.prod.outlook.com/
> 
> Now, I intend to disallow it. If compat mode user binds the devices
> to different containers, it shall be able to do hot reset as it can use
> group fd to prove ownership. But if using the zero-length array, it
> would be failed. So we may add below logic and remove the
> vfio_device_cdev_opened() in vfio_pci_ioctl_pci_hot_reset_groups().
> 
> vfio_pci_ioctl_pci_hot_reset()
> {
> ...
> 	if (!!hdr.count == !!vfio_device_cdev_opened(&vdev->vdev))
> 		return -EINVAL;
> 	if (hdr.count)
> 		vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
> 	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
> 					     vfio_iommufd_device_ictx(&vdev->vdev));
> }
> 
> > 
> > I thought it would be that this function is called with groups == NULL
> > and therefore the vfio_dev_in_groups() test below fails, but I don't
> > think that's true for a compat opened device.  Thanks,  
> 
> How about above logic?

The double negating a function that already returns bool is a bit
excessive.  I might also move the test closer to the other parameter
checking with a comment noting the null array interface is only for
cdev opened devices.  Thanks,

Alex

