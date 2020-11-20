Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373662BA8D1
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 12:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKTLRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 06:17:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727118AbgKTLRc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Nov 2020 06:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605871050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcw4Y1PESRnAwZtsXIHO3caeYkWvDYbZ2c47jc0MTmI=;
        b=VZS4mAoIps6qvvvujbmIF9zl4/bvAgbv4hnlFVundheTCM+AZUr//moiXoKsLu3uchU+Vu
        UbgXk8J4QjgZxG3fnr5ELqrAeKw1jJ2vvbamC0y6KwG8GlJOTph4LFHIWXxJFxQAhcjvDF
        x4fRgjynNw2ao/0063T9ceNYWncvYU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-n_ZL6EXPMn2QkaxgAJuJOQ-1; Fri, 20 Nov 2020 06:17:28 -0500
X-MC-Unique: n_ZL6EXPMn2QkaxgAJuJOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54CC080F04F;
        Fri, 20 Nov 2020 11:17:26 +0000 (UTC)
Received: from gondolin (ovpn-112-250.ams2.redhat.com [10.36.112.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB4FD60853;
        Fri, 20 Nov 2020 11:17:24 +0000 (UTC)
Date:   Fri, 20 Nov 2020 12:17:22 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [RFC PATCH 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
Message-ID: <20201120121722.6ae6ba22.cohuck@redhat.com>
In-Reply-To: <20201119165611.6a811d76.pasic@linux.ibm.com>
References: <20201117032139.50988-1-farman@linux.ibm.com>
        <20201117032139.50988-2-farman@linux.ibm.com>
        <20201119123026.1353cb3c.cohuck@redhat.com>
        <20201119165611.6a811d76.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Nov 2020 16:56:11 +0100
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Thu, 19 Nov 2020 12:30:26 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > > +static void vfio_mdev_request(void *device_data, unsigned int count)
> > > +{
> > > +	struct mdev_device *mdev = device_data;
> > > +	struct mdev_parent *parent = mdev->parent;
> > > +
> > > +	if (unlikely(!parent->ops->request))    
> > 
> > Hm. Do you think that all drivers should implement a ->request()
> > callback?  
> 
> @Tony: What do you think, does vfio_ap need something like this?
> 
> BTW how is this supposed to work in a setup where the one parent
> has may children (like vfio_ap or the gpu slice and dice usecases).

I'd think that the driver would either keep some kind of reference
counting (do something when the last child is gone), notifies all
other children as well, or leaves the decision to userspace. Probably
highly depends on the driver.

> 
> After giving this some thought I'm under the impression, I don't
> get the full picture yet.
> 
> Regards,
> Halil
> 

