Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29693027B6
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 17:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbhAYQWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 11:22:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730674AbhAYQW0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 11:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611591658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d8rYmfLQ4//SMhY+Gkg+k76r3SnhHe3zISj6ZiBrG4Y=;
        b=ihy6sFZp92x2XiIjRt3iskniFukXNZZJDGd2ntX9Q0jdadiEs6Xwcg83GFrSkxy/3pxM+k
        +yrha1Y0lnH3Im/7yb0jCuctZHhyvEkXq0I0QcLfK3ReddhvKi9b5Esu02iNVE66p03jSD
        uB9B3KY1J/n4Cf5Twm+CLbZwUPYSAPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-CK0MpY7VNdCvcI1ywKLZEw-1; Mon, 25 Jan 2021 11:20:54 -0500
X-MC-Unique: CK0MpY7VNdCvcI1ywKLZEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0183107ACE4;
        Mon, 25 Jan 2021 16:20:51 +0000 (UTC)
Received: from gondolin (ovpn-113-161.ams2.redhat.com [10.36.113.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2F566ACE5;
        Mon, 25 Jan 2021 16:20:37 +0000 (UTC)
Date:   Mon, 25 Jan 2021 17:20:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210125172035.3b61b91b.cohuck@redhat.com>
In-Reply-To: <20210122200421.GH4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
        <20210122122503.4e492b96@omen.home.shazbot.org>
        <20210122200421.GH4147@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jan 2021 16:04:21 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Jan 22, 2021 at 12:25:03PM -0700, Alex Williamson wrote:

> > > In this way, we'll use the HW vendor driver core to manage the lifecycle
> > > of these devices. This is reasonable since only the vendor driver knows
> > > exactly about the status on its internal state and the capabilities of
> > > its acceleratots, for example.  
> > 
> > But mdev provides that too, or the vendor could write their own vfio  
> 
> Not really, mdev has a completely different lifecycle model that is
> not very compatible with what is required here.
> 
> And writing a VFIO driver is basically what this does, just a large
> portion of the driver is reusing code from the normal vfio-pci cases.

I think you cut out an important part of Alex' comment, so let me
repost it here:

"But mdev provides that too, or the vendor could write their own vfio
bus driver for the device, this doesn't really justify or delve deep
enough to show examples beyond "TODO" remarks for a vendor driver
actually interacting with vfio-pci-core in an extensible way.  One of
the concerns of previous efforts was that it's trying to directly
expose vfio-pci's implementation as an API for vendor drivers, I don't
really see that anything has changed in that respect here."

I'm missing the bigger picture of how this api is supposed to work out,
a driver with a lot of TODOs does not help much to figure out whether
this split makes sense and is potentially useful for a number of use
cases, or whether mdev (even with its different lifecycle model) or a
different vfio bus driver might be a better fit for the more involved
cases. (For example, can s390 ISM fit here?)

