Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D230416664
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 22:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243028AbhIWULq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 16:11:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhIWULp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 16:11:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632427813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pm6ldAPw3QBicFualtGkXcxl0EGrBnYy1E2YrtIEBcU=;
        b=FvnQ/OlMgYezjgX6s025E9fSNOL7oz5bxtVmofXvdUbTas//UYgL0brT0LNUAARVhBW2VY
        2xh0injU/SNf6J7OTZKFvc60jUFMHGHw43gCvX38aL1WxskyDm6l4ut2tuUDP6CCBXF024
        5L2o2F7621196neOlckfocig10EYD2I=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-g8Da_IzMOKuXE8CN2T1ePQ-1; Thu, 23 Sep 2021 16:10:12 -0400
X-MC-Unique: g8Da_IzMOKuXE8CN2T1ePQ-1
Received: by mail-oi1-f198.google.com with SMTP id l6-20020a056808020600b00273c0972441so4869914oie.14
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 13:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pm6ldAPw3QBicFualtGkXcxl0EGrBnYy1E2YrtIEBcU=;
        b=4jCSl2cmnd0hh/+RZVgj3se/zqrHo/1CDg/WB/8QJ8/Ow83kwi+j9mMyfw+nVIdGdY
         3X84M4U4gWDmmzLsLTXmLkuC/MfF9Z5BXAxIuHAB7knMAVrOIqhag2zpk7il7WZRjHCv
         FyQ/CeCMeTWTnRGr8JMhzUUFdORER+/LUI7+TGCEg+9SjkYZWYzzgF5fPJbcnqNMScD8
         Ztx5A3ef6dFZAA4Gqlhe9AR2IT2aRXjJ5wtqgqJXKwu2bvpEAJLZZhOrpZ3E3Y8WhGzT
         jMk3UnWM3xwqKNZbBnPRnsA823vwV8oo393G5XsiaAGBy0IRBbUX3kJPVylVtY4N/J1+
         VvpA==
X-Gm-Message-State: AOAM530gBghl0edSy1UvexqMpUtSgCymtUQyHsbCzb+Xa7yTXdGUiia+
        mTBSh1VxF9cWzWz2YkXlvECbzKHcg2tbzkHtmoFmxNYTwb71wKA37WKiHtAmQ2JAqcJN4baxnaZ
        zvEMX13SSgF8/
X-Received: by 2002:a05:6830:3101:: with SMTP id b1mr510077ots.21.1632427811291;
        Thu, 23 Sep 2021 13:10:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNoizfos0xOXONbPoXxhPavPdK/o+164G5dpAJrJuPwhpQDVyihOFF+oINDFaTtoFUCQrNhQ==
X-Received: by 2002:a05:6830:3101:: with SMTP id b1mr510058ots.21.1632427811056;
        Thu, 23 Sep 2021 13:10:11 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id d7sm1614012ooa.36.2021.09.23.13.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 13:10:10 -0700 (PDT)
Date:   Thu, 23 Sep 2021 14:10:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Message-ID: <20210923141009.5196b90b.alex.williamson@redhat.com>
In-Reply-To: <20210922131150.GP327412@nvidia.com>
References: <0-v3-f9b50340cdbb+e4-ap_uninit_jgg@nvidia.com>
        <4a50ed05-c60c-aad0-bceb-de9665602aed@linux.ibm.com>
        <20210922131150.GP327412@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 10:11:50 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Sep 22, 2021 at 09:05:06AM -0400, Tony Krowiak wrote:
> > 
> > 
> > On 9/21/21 8:11 AM, Jason Gunthorpe wrote:  
> > > Without this call an xarray entry is leaked when the vfio_ap device is
> > > unprobed. It was missed when the below patch was rebased across the
> > > dev_set patch. Keep the remove function in the same order as the error
> > > unwind in probe.
> > > 
> > > Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Tested-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >   drivers/s390/crypto/vfio_ap_ops.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > v3:
> > >   - Keep the remove sequence the same as remove to avoid a lockdep splat
> > > v2: https://lore.kernel.org/r/0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com/
> > >   - Fix corrupted diff
> > > v1: https://lore.kernel.org/r/0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com/
> > > 
> > > diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> > > index 118939a7729a1e..623d5269a52ce5 100644
> > > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > > @@ -361,6 +361,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
> > >   	mutex_lock(&matrix_dev->lock);
> > >   	list_del(&matrix_mdev->node);
> > >   	mutex_unlock(&matrix_dev->lock);
> > > +	vfio_uninit_group_dev(&matrix_mdev->vdev);
> > >   	kfree(matrix_mdev);
> > >   err_dec_available:
> > >   	atomic_inc(&matrix_dev->available_instances);
> > > @@ -376,9 +377,10 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
> > >   	mutex_lock(&matrix_dev->lock);
> > >   	vfio_ap_mdev_reset_queues(matrix_mdev);
> > >   	list_del(&matrix_mdev->node);
> > > +	mutex_unlock(&matrix_dev->lock);
> > > +	vfio_uninit_group_dev(&matrix_mdev->vdev);
> > >   	kfree(matrix_mdev);
> > >   	atomic_inc(&matrix_dev->available_instances);  
> > 
> > I think the above line of code should be done under the
> > matrix_dev->lock after removing the matrix_mdev from
> > the list since it is changing a value in matrix_dev.  
> 
> No, the read-side doesn't hold the lock
> 
> 	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
> 		return -EPERM;
> 
> I think it is just a leftover from the atomic conversion that Alex
> did to keep it under the matrix_dev struct.
> 
> If we were going to hold the lock then it wouldn't need to be an
> atomic.

Tony, I'd love to get an ack if you're satisfied with this so we can
close up fixes for v5.15.  Thanks,

Alex

