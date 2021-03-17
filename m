Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCFD33EB24
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 09:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhCQINa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 04:13:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhCQINC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 04:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615968782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ADhPq2k0LcRqVj4L2ezqOMeyS6mp96DFeOfcwe+L5Ss=;
        b=WqXZ4u6OmqOpV2yPP1Zruzrc+WVx/vEo3pAy0sr29RKcvHqG5C71K6X51i/umFjaOk3/BK
        haIyN7f2lRbfsimchdjoxBRKPIYy6rHhQTKXGxluxDZEkv7tbDD/VEJucbN19LwGsajIO3
        K3v4xOv1aNIlr6X32wQMpnNjgI9fLTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-szyO-KWNPn2BgkMAYcpQQQ-1; Wed, 17 Mar 2021 04:12:57 -0400
X-MC-Unique: szyO-KWNPn2BgkMAYcpQQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99F1E83DD20;
        Wed, 17 Mar 2021 08:12:55 +0000 (UTC)
Received: from gondolin (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6E825D74F;
        Wed, 17 Mar 2021 08:12:46 +0000 (UTC)
Date:   Wed, 17 Mar 2021 09:12:44 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/14] vfio: Simplify the lifetime logic for
 vfio_device
Message-ID: <20210317091244.26457621.cohuck@redhat.com>
In-Reply-To: <20210316142454.401d77fb@omen.home.shazbot.org>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <2-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <MWHPR11MB18865B08DE53D9E9EE04DA5B8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210316142454.401d77fb@omen.home.shazbot.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 14:24:54 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 16 Mar 2021 07:38:09 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Saturday, March 13, 2021 8:56 AM
> > > 
> > > The vfio_device is using a 'sleep until all refs go to zero' pattern for
> > > its lifetime, but it is indirectly coded by repeatedly scanning the group
> > > list waiting for the device to be removed on its own.
> > > 
> > > Switch this around to be a direct representation, use a refcount to count
> > > the number of places that are blocking destruction and sleep directly on a
> > > completion until that counter goes to zero. kfree the device after other
> > > accesses have been excluded in vfio_del_group_dev(). This is a fairly
> > > common Linux idiom.
> > > 
> > > Due to this we can now remove kref_put_mutex(), which is very rarely used
> > > in the kernel. Here it is being used to prevent a zero ref device from
> > > being seen in the group list. Instead allow the zero ref device to
> > > continue to exist in the device_list and use refcount_inc_not_zero() to
> > > exclude it once refs go to zero.
> > > 
> > > This patch is organized so the next patch will be able to alter the API to
> > > allow drivers to provide the kfree.
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/vfio/vfio.c | 79 ++++++++++++++-------------------------------
> > >  1 file changed, 25 insertions(+), 54 deletions(-)
> > > 

> > > @@ -935,32 +916,18 @@ void *vfio_del_group_dev(struct device *dev)
> > >  	WARN_ON(!unbound);
> > > 
> > >  	vfio_device_put(device);
> > > -
> > > -	/*
> > > -	 * If the device is still present in the group after the above
> > > -	 * 'put', then it is in use and we need to request it from the
> > > -	 * bus driver.  The driver may in turn need to request the
> > > -	 * device from the user.  We send the request on an arbitrary
> > > -	 * interval with counter to allow the driver to take escalating
> > > -	 * measures to release the device if it has the ability to do so.
> > > -	 */    
> > 
> > Above comment still makes sense even with this patch. What about
> > keeping it? otherwise:  
> 
> The comment is not exactly correct after this code change either, the
> device will always be present in the group after this 'put'.  Instead,
> the completion now indicates the reference count has reached zero.  If
> it's worthwhile to keep more context to the request callback, perhaps:
> 
> 	/*
> 	 * If there are still outstanding device references, such as
> 	 * from the device being in use, periodically kick the optional
> 	 * device request callback while waiting.
> 	 */

I like that comment; I don't think it hurts to be a bit verbose here.

> 
> It's also a little obvious that's what we're doing here even without
> the comment.  Thanks,
> 
> Alex

