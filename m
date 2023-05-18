Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B3C708890
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 21:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjERTqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 15:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjERTqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 15:46:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C21E67
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684439157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YyW7RBXSmGHBAYv2QWmk4im2x9juM0YLLtgp7WpEXSw=;
        b=FpNmHjCd+u36gnqi6m71LpAhtePi6SER74z6Ii7bmv7zSToINzzbs4TZTmA8e9eXFBIpfD
        GCTAVoFeucvPObuKaV+sprMQzu5H+PDOXpZzeRUXkDm0KHMf6fvdSALEk57TIkprYxDqWl
        56SH6R8KXSpBsG497tnSC8GIMK/NEq8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-VyJ5UBtuORmBfWW1sB0EyQ-1; Thu, 18 May 2023 15:45:56 -0400
X-MC-Unique: VyJ5UBtuORmBfWW1sB0EyQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-76fffd0116eso398776439f.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684439156; x=1687031156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YyW7RBXSmGHBAYv2QWmk4im2x9juM0YLLtgp7WpEXSw=;
        b=JWtA/C7vHR7NGLQDAR8WffLuuyVW/kWBS1LksKs9YUblkWh2ZOyhqKKlonNA7dvGZe
         DjMcVsQvkBYgCLWqKVl/NvLnpK3LCEkkhgwcqEcXpx5+p8WH+Lz8SybWJO/dAhxlJRf0
         PXmJFjNFTCYLBWPa3K3R/XZ34k94thlPL/SCknpGbvK1OaM5Iv6cpLFWze6VeBAcL7lw
         dPFe1fymbsRWzFZj8oE5LxaUfwsSg/cEQRl7Pq8gp+LRLnPnQkS4QCmcyFtjZv1f1CVw
         +m8I7kesFOWwpSOfwU2P3dRD7556nQpsTttaOkYBnDlJ3kbn+7T0b4MsfZPjxl8yeUpe
         p8Bg==
X-Gm-Message-State: AC+VfDx3/QWokqXZ0bgm/aINB/XeEvj+K+/ksTyMt1MeF3NcHQWGF83y
        506QELk9Q9VvmfOAx0pFyj/YeKlJ70bLfb5grCE8JxFGocOz8KOaRrcs+xxr9TKGAQVqgEIQhw5
        sG65ShUJdhP6J
X-Received: by 2002:a5d:8a0f:0:b0:76c:542f:d72d with SMTP id w15-20020a5d8a0f000000b0076c542fd72dmr7574475iod.8.1684439155756;
        Thu, 18 May 2023 12:45:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6mLg71ghw6nUoJ1B4NGoNnfmwKaX7dGCH7IWZJcYah+MUSz+GwstUtbVvS/kPE6+ZuOI19yw==
X-Received: by 2002:a5d:8a0f:0:b0:76c:542f:d72d with SMTP id w15-20020a5d8a0f000000b0076c542fd72dmr7574467iod.8.1684439155504;
        Thu, 18 May 2023 12:45:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c12-20020a05660221cc00b007702f55116fsm599490ioc.38.2023.05.18.12.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:45:54 -0700 (PDT)
Date:   Thu, 18 May 2023 13:45:53 -0600
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
Subject: Re: [PATCH v5 07/10] vfio: Add helper to search vfio_device in a
 dev_set
Message-ID: <20230518134553.27fdf0b0.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529BAEF7080D2EA66912510C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-8-yi.l.liu@intel.com>
        <20230517131243.7028bf9c.alex.williamson@redhat.com>
        <DS0PR11MB7529BAEF7080D2EA66912510C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 May 2023 12:31:07 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, May 18, 2023 3:13 AM
> > 
> > On Sat, 13 May 2023 06:21:33 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> > > There are drivers that need to search vfio_device within a given dev_set.
> > > e.g. vfio-pci. So add a helper.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_core.c |  8 +++-----
> > >  drivers/vfio/vfio_main.c         | 15 +++++++++++++++
> > >  include/linux/vfio.h             |  3 +++
> > >  3 files changed, 21 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > > index 39e7823088e7..4df2def35bdd 100644
> > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > @@ -2335,12 +2335,10 @@ static bool vfio_dev_in_groups(struct  
> > vfio_pci_core_device *vdev,  
> > >  static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *data)
> > >  {
> > >  	struct vfio_device_set *dev_set = data;
> > > -	struct vfio_device *cur;
> > >
> > > -	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> > > -		if (cur->dev == &pdev->dev)
> > > -			return 0;
> > > -	return -EBUSY;
> > > +	lockdep_assert_held(&dev_set->lock);
> > > +
> > > +	return vfio_find_device_in_devset(dev_set, &pdev->dev) ? 0 : -EBUSY;  
> > 
> > Maybe an opportunity to revisit why this returns -EBUSY rather than
> > something reasonable like -ENODEV.  It looks like we picked up the
> > -EBUSY in a882c16a2b7e where I think it was trying to preserve the
> > return of vfio_pci_try_zap_and_vma_lock_cb() but the return value here
> > is not even propagated so this looks like an chance to have it make
> > sense again.  Thanks,  
> 
> From the name of this function, yes, -ENODEV is better. is it
> Ok to modify it to be -ENODEV in this patch or a separate one?

This patch is fine so long as it's noted in the commit log.  Thanks,

Alex
 
> > >  }
> > >
> > >  /*
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index f0ca33b2e1df..ab4f3a794f78 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -141,6 +141,21 @@ unsigned int vfio_device_set_open_count(struct  
> > vfio_device_set *dev_set)  
> > >  }
> > >  EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
> > >
> > > +struct vfio_device *
> > > +vfio_find_device_in_devset(struct vfio_device_set *dev_set,
> > > +			   struct device *dev)
> > > +{
> > > +	struct vfio_device *cur;
> > > +
> > > +	lockdep_assert_held(&dev_set->lock);
> > > +
> > > +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> > > +		if (cur->dev == dev)
> > > +			return cur;
> > > +	return NULL;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_find_device_in_devset);
> > > +
> > >  /*
> > >   * Device objects - create, release, get, put, search
> > >   */
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index fcbe084b18c8..4c17395ed4d2 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -259,6 +259,9 @@ void vfio_unregister_group_dev(struct vfio_device *device);
> > >
> > >  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
> > >  unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
> > > +struct vfio_device *
> > > +vfio_find_device_in_devset(struct vfio_device_set *dev_set,
> > > +			   struct device *dev);
> > >
> > >  int vfio_mig_get_next_state(struct vfio_device *device,
> > >  			    enum vfio_device_mig_state cur_fsm,  
> 

