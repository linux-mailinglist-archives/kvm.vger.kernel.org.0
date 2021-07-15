Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442BF3CAF1C
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 00:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhGOWas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 18:30:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhGOWap (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 18:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626388071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLA8eO2Mn4hxr+cJbgc910e8VN/wkTHNL7BaNmCYSD0=;
        b=CZseuO4VjGJ+qQf/Rw1LhVWGrKLWUBZQ8kZuBJ1P/GQJTWgaixX4F/8gGi1HJHnn2gdIxo
        d4jQG+N4/eUR+upugTRhyL+A3gKyJUDs/30Ml3E6FiqMZXr9UrCUAPpMMKzAZpgToVTynk
        xH6yvu5Uym90YwjBaJB4rFHFNXssnLM=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-gpuW5wP-NSyG_R7kBlRIug-1; Thu, 15 Jul 2021 18:27:50 -0400
X-MC-Unique: gpuW5wP-NSyG_R7kBlRIug-1
Received: by mail-ot1-f70.google.com with SMTP id y59-20020a9d22c10000b0290451891192f0so5697139ota.1
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 15:27:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLA8eO2Mn4hxr+cJbgc910e8VN/wkTHNL7BaNmCYSD0=;
        b=V81RNMA+rP1uIhgLgAoM79T9mr0Ju8FyXDLWDhEizUgnKHX0sWlDilbUJXVZdo5m/m
         wBXmXf2C6ylx+sY+Nt+tXjmZCqiqES0L4CzI0FNR5CkbBzqI0Ne/kft66M/ZhxcOA1H0
         kCwWzMcRYr+6NzMWt4XainI38Gg+y6owAu2JS+UN3m3Y4LGNlQEj8iIKjnSwuAmoH8/T
         ZV+ET27QxEtf6sUJF7EAgh5CxILyllLuyTeUFNwLj4tQv/DNe4MwQfGOFRfXQHFSejip
         4CLQaRfSZdZMTvAUjI7tko8cHMbiGOmflvmkmTNPo08f+EePWJQ3oNqP1qfAGipdgc9E
         m42w==
X-Gm-Message-State: AOAM531RMH5BLnlBDSvG0SU+bB5w/ljZqiK7Ino/aN+dW0O+DEcZE3GY
        9HT50T7mmANjaupLwj5BQhEJk6Bp9TRmVrVXEyA2BGXeK8KZc3ALDDdQI7unN96E7BWED/C47fP
        t44QmGb3UWBLP
X-Received: by 2002:a9d:5e15:: with SMTP id d21mr5845728oti.280.1626388069903;
        Thu, 15 Jul 2021 15:27:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyp8ZblGgPS0JAdEwOCHdvHkA3HueEV2SZpBhta6Fuh8EOKxxl4birTsJK3gicGUmZGOxesYw==
X-Received: by 2002:a9d:5e15:: with SMTP id d21mr5845703oti.280.1626388069722;
        Thu, 15 Jul 2021 15:27:49 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id v203sm1565993oib.37.2021.07.15.15.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 15:27:49 -0700 (PDT)
Date:   Thu, 15 Jul 2021 16:27:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH 09/13] vfio/pci: Reorganize VFIO_DEVICE_PCI_HOT_RESET to
 use the device set
Message-ID: <20210715162747.4186b482.alex.williamson@redhat.com>
In-Reply-To: <20210715221149.GJ543781@nvidia.com>
References: <0-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
        <9-v1-eaf3ccbba33c+1add0-vfio_reflck_jgg@nvidia.com>
        <20210715150055.474f535f.alex.williamson@redhat.com>
        <20210715221149.GJ543781@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Jul 2021 19:11:49 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jul 15, 2021 at 03:00:55PM -0600, Alex Williamson wrote:
> > On Wed, 14 Jul 2021 21:20:38 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:  
> > > +/*
> > > + * We need to get memory_lock for each device, but devices can share mmap_lock,
> > > + * therefore we need to zap and hold the vma_lock for each device, and only then
> > > + * get each memory_lock.
> > > + */
> > > +static int vfio_hot_reset_device_set(struct vfio_pci_device *vdev,
> > > +				     struct vfio_pci_group_info *groups)
> > > +{
> > > +	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
> > > +	struct vfio_pci_device *cur_mem =
> > > +		list_first_entry(&dev_set->device_list, struct vfio_pci_device,
> > > +				 vdev.dev_set_list);  
> > 
> > We shouldn't be looking at the list outside of the lock, if the first
> > entry got removed we'd break our unwind code.
> >   
> > > +	struct vfio_pci_device *cur_vma;
> > > +	struct vfio_pci_device *cur;
> > > +	bool is_mem = true;
> > > +	int ret;
> > >  
> > > -	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
> > > -		vfio_device_put(device);
> > > -		return -EBUSY;
> > > +	mutex_lock(&dev_set->lock);  
> >         ^^^^^^^^^^^^^^^^^^^^^^^^^^^  
> 
> Oh, righto, this is an oopsie!
> 
> > > +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
> > > +		up_write(&cur->memory_lock);
> > > +	mutex_unlock(&dev_set->lock);
> > > +
> > > +	return ret;  
> > 
> > 
> > Isn't the above section actually redundant to below, ie. we could just
> > fall through after the pci_reset_bus()?  Thanks,  
> 
> It could, but I thought it was less confusing this way due to how
> oddball the below is:
> 
> > > +err_undo:
> > > +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> > > +		if (cur == cur_mem)
> > > +			is_mem = false;
> > > +		if (cur == cur_vma)
> > > +			break;
> > > +		if (is_mem)
> > > +			up_write(&cur->memory_lock);
> > > +		else
> > > +			mutex_unlock(&cur->vma_lock);
> > > +	}  
> 
> But either works, do want it switch in v2?

Yeah, I think the simpler version just adds to the confusion of what
this oddball logic does.  It already handles all cases, up to and
including success, so let's give it more exercise by always using it.
Thanks,

Alex

