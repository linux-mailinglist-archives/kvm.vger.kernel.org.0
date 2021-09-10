Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9E5406F38
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 18:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhIJQM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 12:12:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229861AbhIJQLI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 12:11:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631290196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/69qBPEq+ZxoLUCx7D3iUMKDE0eou/SmM/DmrEsT78=;
        b=FN005Z4iU0lqZChXTlZ+78Ze9k/Sqaf9Oc4bzTV28KKla6lMOy1qrkGIAaSotlWG7KeZtN
        oh14wFh9gU6cZcLbioHR0uYj4zEK2qIri4Zepu4SF9T2X6Jg+KToEgdpb04S3JYVmq224U
        MPdh0awidgOGAAtHMviaQATtG/mXwN4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-_FCGVFtMPv6EGgagBBZCOw-1; Fri, 10 Sep 2021 12:09:55 -0400
X-MC-Unique: _FCGVFtMPv6EGgagBBZCOw-1
Received: by mail-io1-f70.google.com with SMTP id s6-20020a5ec646000000b005b7f88ffdd3so4134974ioo.13
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 09:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6/69qBPEq+ZxoLUCx7D3iUMKDE0eou/SmM/DmrEsT78=;
        b=fub1KNvva89ONUrfxTilVNrVhxmDKappdktIjRdkZHzsZTWZekBG9LdUagVoiKjl+6
         Uh+QLQx8XKeCvvjQKj5ujHFtRkyXM+PYYLfi3G8aquWMml8Zvo9wUSmzZ6VHiqBQjoiv
         rNVx8LRlnDDGsEg7LMex/4mQfNIx/Y7R6mpoLoZ/zHELzsZ/wovPJT3S31RhRwnjYKg8
         AN2b+itPJgca/kWJk5s4NGiDAuHC2ptv51S32x9ffgd5cgcQcwrrpdtUPvhd7E10k3Nh
         /v77kKbAoJwZcid8QRehb5kKx0L7qHBD3PHxgsC5aw3sstR9yIDnzPByt3fZtHwIK57I
         jMHA==
X-Gm-Message-State: AOAM5331m4DH8AZ39XAED0b2SxVWiaOQQCIItgHl5SXmZUqSWQW1hi2M
        qeDAGD0DNyn4TetrhVWagoKA4ISawloknRC+XxVSF3Fss8Ec1opa+YPF3HZrGIM9dBcBNvYR9sZ
        58BcIH+k3Ftu/
X-Received: by 2002:a05:6e02:8f2:: with SMTP id n18mr6862646ilt.256.1631290194643;
        Fri, 10 Sep 2021 09:09:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxP8Y1TihJai/O/xPIO5JmfEsEgfV81tQvv38D8IJQRDSK+KLhAXgtQ59aQINI+2fQswrVxaA==
X-Received: by 2002:a05:6e02:8f2:: with SMTP id n18mr6862610ilt.256.1631290194398;
        Fri, 10 Sep 2021 09:09:54 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id y10sm2555019ilv.35.2021.09.10.09.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:09:54 -0700 (PDT)
Date:   Fri, 10 Sep 2021 10:09:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
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
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 5/9] vfio/mdev: Consolidate all the device_api sysfs
 into the core code
Message-ID: <20210910100951.4da06602.alex.williamson@redhat.com>
In-Reply-To: <20210910133850.GT2505917@nvidia.com>
References: <0-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
        <5-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
        <YTtLRmiXq+QtJ+la@infradead.org>
        <20210910133850.GT2505917@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Sep 2021 10:38:50 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Sep 10, 2021 at 01:10:46PM +0100, Christoph Hellwig wrote:
> > On Thu, Sep 09, 2021 at 04:38:45PM -0300, Jason Gunthorpe wrote:  
> > > Every driver just emits a static string, simply feed it through the ops
> > > and provide a standard sysfs show function.  
> > 
> > Looks sensible.  But can you make the attribute optional and add a
> > comment marking it deprecated?  Because it really is completely useless.
> > We don't version userspace APIs, userspae has to discover new features
> > individually by e.g. finding new sysfs files or just trying new ioctls.  
> 
> To be honest I have no idea what side effects that would have..
> 
> device code search tells me libvirt reads it and stuffs it into some
> XML
> 
> Something called mdevctl touches it, feeds it into some JSON and
> other stuff..
> 
> qemu has some VFIO_DEVICE_API_* constants but it is all dead code
> 
> I agree it shouldn't have been there in the first place
> 
> Cornelia? Alex? Any thoughts?

It's not a version, it's a means for userspace to determine the basic
API for an mdev device without needing to go through the process of
creating a container, adding the group, setting an IOMMU type, opening
the device before being able to call VFIO_DEVICE_GET_INFO to determine
the API.  For example, it wouldn't make sense for libvirt to attach a
vfio-ccw device to a PCIe root port in a VM.  It's a means to say this
mdev device is a vfio-pci or that mdev device is a vfio-ccw.  If it were
optional, then management tools would have no basic idea how to attach
the device to a VM without gaining access to the device themselves.
Thanks,

Alex

