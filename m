Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26E4515850
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 00:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239741AbiD2WZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 18:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbiD2WZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 18:25:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C70FEDC9B9
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 15:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651270935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATKyFNAAAkRRTMtWxAFMAqDXlfz2eEkoQ0lWbdsfdDE=;
        b=Sotr3eMloqN0ZlZVp5Y8kmqjHGLKruYHkOTOcB2o2HDWlbCJyt9Hctja3/il4cTFEfWX75
        zliAn94WhWUnJkAR4ObFtmvJeb/OKqNYzd+AgrR3OTNHZKWg+QZoViLHTb/0VVDmvKhniP
        BoYlm9WXgarQpStRnEM5Jtv7pgZDyYY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-C_1FTP0CMvK9b1sO3VVVjw-1; Fri, 29 Apr 2022 18:22:13 -0400
X-MC-Unique: C_1FTP0CMvK9b1sO3VVVjw-1
Received: by mail-il1-f199.google.com with SMTP id m11-20020a056e020deb00b002cbde7e7dcfso4315962ilj.2
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 15:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATKyFNAAAkRRTMtWxAFMAqDXlfz2eEkoQ0lWbdsfdDE=;
        b=0Rv5u+tr1Qb7Hck5zXPcAqTFPhHgWHKdumzNYY1OBJJNeVUl/mheq3JGLE7oIIvZ/R
         QVaourAxy2xhbNIj8fAtqRqK9fYKq5qqq3EOd3ZWYv4riTnj4oBBvWWjEK2+XIHmeG/H
         hu2Ol4g7v3ZA7rRGg/JGok1dCT6xqRyZo1O27s6B2XN23CZ2UMF0AW76JhE8DKAUgWQ0
         f9ARFv+s93AjkQfZW/U6nlH0f8QEM/H2+yY6mIyJwlU0C328tRPPUxR0D58/hF3JND+a
         vEfBnYLdB5FdGGmzmjXwJPvPbOA8qprU29uRtTU1zH+oJEw71VPLvWBLySJIFkRwjWUD
         wxdg==
X-Gm-Message-State: AOAM531UhD/rrtM1Yswd1Dv1ZMLkNxevuEH1rpHG2Qa7HatnWRmy9/XA
        kYRexBw3qdDNXHR2ZakhJb0o+m5LYMG/2vBWb17AqcCtxgRd2ueBwI0NCZ91bWW7a1kR+iuGym9
        qnMjSmbLO8aW/
X-Received: by 2002:a05:6638:4604:b0:32b:4eab:7394 with SMTP id bw4-20020a056638460400b0032b4eab7394mr636127jab.18.1651270932498;
        Fri, 29 Apr 2022 15:22:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPQNrRSGnW48FBq1t2/hjh8q51j2JzUcOvWsug9aMrqr32bPZVspTaleHuRHvQdSR9CF/bGw==
X-Received: by 2002:a05:6638:4604:b0:32b:4eab:7394 with SMTP id bw4-20020a056638460400b0032b4eab7394mr636115jab.18.1651270932123;
        Fri, 29 Apr 2022 15:22:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e71-20020a02864d000000b0032b3a78176bsm897885jai.47.2022.04.29.15.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 15:22:11 -0700 (PDT)
Date:   Fri, 29 Apr 2022 16:22:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
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
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/7] Make the rest of the VFIO driver interface use
 vfio_device
Message-ID: <20220429162209.2ec03e4f.alex.williamson@redhat.com>
In-Reply-To: <20220429173149.GA167483@nvidia.com>
References: <0-v2-6011bde8e0a1+5f-vfio_mdev_no_group_jgg@nvidia.com>
        <20220429173149.GA167483@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Apr 2022 14:31:49 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Apr 21, 2022 at 01:28:31PM -0300, Jason Gunthorpe wrote:
> > Prior series have transformed other parts of VFIO from working on struct
> > device or struct vfio_group into working directly on struct
> > vfio_device. Based on that work we now have vfio_device's readily
> > available in all the drivers.
> > 
> > Update the rest of the driver facing API to use vfio_device as an input.
> > 
> > The following are switched from struct device to struct vfio_device:
> >   vfio_register_notifier()
> >   vfio_unregister_notifier()
> >   vfio_pin_pages()
> >   vfio_unpin_pages()
> >   vfio_dma_rw()
> > 
> > The following group APIs are obsoleted and removed by just using struct
> > vfio_device with the above:
> >   vfio_group_pin_pages()
> >   vfio_group_unpin_pages()
> >   vfio_group_iommu_domain()
> >   vfio_group_get_external_user_from_dev()
> > 
> > To retain the performance of the new device APIs relative to their group
> > versions optimize how vfio_group_add_container_user() is used to avoid
> > calling it when the driver must already guarantee the device is open and
> > the container_users incrd.
> > 
> > The remaining exported VFIO group interfaces are only used by kvm, and are
> > addressed by a parallel series.
> > 
> > This series is based on Christoph's gvt rework here:
> > 
> >  https://lore.kernel.org/all/5a8b9f48-2c32-8177-1c18-e3bd7bfde558@intel.com/
> > 
> > and so will need the PR merged first.  
> 
> Hi Alex,
> 
> Since all the shared branch PRs are ready, do you have any remarks on
> this series and the others before I rebase and repost them?

Only the nit in the commit log:
https://lore.kernel.org/all/20220429142820.6afe7bbe.alex.williamson@redhat.com/ 

> This one has a few changes to the commit messages outstanding, but v2
> didn't have any code changes.
> 
> Also, what order would like the different series in - they conflict
> with each other a little bit. I suggest this:
> 
> - mdev group removal (this one)
> - Remove vfio_device_get_from_dev()
>   https://lore.kernel.org/r/0-v1-7f2292e6b2ba+44839-vfio_get_from_dev_jgg@nvidia.com
> - Remove group from kvm
>   https://lore.kernel.org/r/0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com

I think you mean (v2):

https://lore.kernel.org/all/0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com/

Otherwise, thanks for sorting these out for me.

> All of them seem to have got enough reviews now.
>
> I have one more series on this group topic and a few little patches still
> 
> It would be great if you could merge the gvt and iommu series together
> into your tree toward linux-next so I can post patches against a
> stable commit ID so the build-bots can test them.

Please check my vfio next branch and see if this matches what you're
looking for:

https://github.com/awilliam/linux-vfio/commits/next

I'll look for any fallout from Stephen and build bots on Monday's
linux-next compilation.  Thanks,

Alex

