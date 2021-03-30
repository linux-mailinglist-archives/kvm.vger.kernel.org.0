Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8CB34ED49
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 18:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhC3QOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 12:14:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231874AbhC3QO2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 12:14:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617120867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1lhkcT5r+OM7Qgloe51xI5HqNRTOSLiAM2tBUhuhdwo=;
        b=R2Nz1U0Zgpxc4zEjQMIo+JjqhHffDUBw8q/6gintBTZbmT4qwjesfIOACbUys1gUsC8XWs
        r+lqox/hGMAJQ5yx1ugzLvaWYzcNSdxBQSDUpW72MtCPRjbRPH0GKzK9RSEQrin/9wVf+t
        EnypkUov8K+gxgeeukP7AW9WgdnGdvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-ysqk8si2NNKxTWRVlwtMow-1; Tue, 30 Mar 2021 12:14:23 -0400
X-MC-Unique: ysqk8si2NNKxTWRVlwtMow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FE2E87A826;
        Tue, 30 Mar 2021 16:14:21 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E04B60861;
        Tue, 30 Mar 2021 16:14:15 +0000 (UTC)
Date:   Tue, 30 Mar 2021 18:14:13 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 10/18] vfio/mdev: Remove duplicate storage of parent in
 mdev_device
Message-ID: <20210330181413.4602f816.cohuck@redhat.com>
In-Reply-To: <20210326115350.GM2356281@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <10-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
        <MWHPR11MB18864F0836984277A52BB4CB8C619@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210326115350.GM2356281@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Mar 2021 08:53:50 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Mar 26, 2021 at 03:53:10AM +0000, Tian, Kevin wrote:
> 
> > > @@ -58,12 +58,11 @@ void mdev_release_parent(struct kref *kref)
> > >  /* Caller must hold parent unreg_sem read or write lock */
> > >  static void mdev_device_remove_common(struct mdev_device *mdev)
> > >  {
> > > -	struct mdev_parent *parent;
> > > +	struct mdev_parent *parent = mdev->type->parent;  
> > 
> > What about having a wrapper here, like mdev_parent_dev? For
> > readability it's not necessary to show that the parent is indirectly
> > retrieved through mdev_type.  
> 
> I think that is too much wrappering, we only have three usages of the
> mdev->type->parent sequence and two are already single line inlines.

I'm counting more of those in this patch... or do you mean at the end
of the series?

