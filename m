Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E803A7BD8
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 12:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhFOKbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 06:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231362AbhFOKbJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 06:31:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623752945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VhDOgMjiOwt7H+lgbYmC14lLfCiQZ3CWo0eN0+/p/wA=;
        b=WVj+kV1pNZtXqbgGdGWu0J/brmL1bcVz6Dxlc2jiKzZjPSFvQ7TIgAW9kFhZMtAjdwem94
        Cwr2tpoOniWUonudtbAVUmdd+eoVhMqavu7bSw4tgXRlOAK0PP5jaOuVatqNub2KB5rt2C
        mbBYsE4hzarViWb7+WZCdGV9yI5XARg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-28sqSogFMDmkecx9WwbJyQ-1; Tue, 15 Jun 2021 06:27:59 -0400
X-MC-Unique: 28sqSogFMDmkecx9WwbJyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95D6D802575;
        Tue, 15 Jun 2021 10:27:56 +0000 (UTC)
Received: from localhost (ovpn-113-156.ams2.redhat.com [10.36.113.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FA5A5C1D5;
        Tue, 15 Jun 2021 10:27:55 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 01/10] driver core: Pull required checks into
 driver_probe_device()
In-Reply-To: <20210614150846.4111871-2-hch@lst.de>
Organization: Red Hat GmbH
References: <20210614150846.4111871-1-hch@lst.de>
 <20210614150846.4111871-2-hch@lst.de>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 15 Jun 2021 12:27:53 +0200
Message-ID: <87h7hzxw0m.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14 2021, Christoph Hellwig <hch@lst.de> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
>
> Checking if the dev is dead or if the dev is already bound is a required
> precondition to invoking driver_probe_device(). All the call chains
> leading here duplicate these checks.
>
> Add it directly to driver_probe_device() so the precondition is clear and
> remove the checks from device_driver_attach() and
> __driver_attach_async_helper().
>
> The other call chain going through __device_attach_driver() does have
> these same checks but they are inlined into logic higher up the call stack
> and can't be removed.
>
> The sysfs uAPI call chain starting at bind_store() is a bit confused
> because it reads dev->driver unlocked and returns -ENODEV if it is !NULL,
> otherwise it reads it again under lock and returns 0 if it is !NULL. Fix
> this to always return -EBUSY and always read dev->driver under its lock.
>
> Done in preparation for the next patches which will add additional
> callers to driver_probe_device() and will need these checks as well.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [hch: drop the extra checks in device_driver_attach and bind_store]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/base/bus.c |  2 +-
>  drivers/base/dd.c  | 32 ++++++++++----------------------
>  2 files changed, 11 insertions(+), 23 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

