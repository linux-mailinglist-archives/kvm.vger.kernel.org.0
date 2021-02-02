Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCAA30CBEB
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhBBTjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:39:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239970AbhBBTi7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 14:38:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612294652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TY7xT7CryzsyD+6N2DgUNqE8eAM93zEP1Tc1jg6azeU=;
        b=IX+cCcs5vKUUCJrZET4hXDGWNVywbeSNOP13tZ20uddCdnVcdXoy4WTOO2z8KPYJnQWbrR
        t5B2QaDDY8+GY5qqi0X6dDrKdcs6pYwH830Wm/mh8azdOJOR07J9zPhMxDi+qKGKzoEiVu
        99xrQmP9JEf7GGeqXN/WBZFL1LdQeMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-jO6Dx0Q9NqiZHD5--mTLxw-1; Tue, 02 Feb 2021 14:37:28 -0500
X-MC-Unique: jO6Dx0Q9NqiZHD5--mTLxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1EEA801817;
        Tue,  2 Feb 2021 19:37:25 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87BAA1F41A;
        Tue,  2 Feb 2021 19:37:24 +0000 (UTC)
Date:   Tue, 2 Feb 2021 12:37:23 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202123723.6cc018b8@omen.home.shazbot.org>
In-Reply-To: <20210202185017.GZ4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-9-mgurtovoy@nvidia.com>
        <20210201181454.22112b57.cohuck@redhat.com>
        <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
        <20210201114230.37c18abd@omen.home.shazbot.org>
        <20210202170659.1c62a9e8.cohuck@redhat.com>
        <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
        <20210202105455.5a358980@omen.home.shazbot.org>
        <20210202185017.GZ4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 14:50:17 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 02, 2021 at 10:54:55AM -0700, Alex Williamson wrote:
> 
> > As noted previously, if we start adding ids for vfio drivers then we
> > create conflicts with the native host driver.  We cannot register a
> > vfio PCI driver that automatically claims devices.  
> 
> We can't do that in vfio_pci.ko, but a nvlink_vfio_pci.ko can, just
> like the RFC showed with the mlx5 example. The key thing is the module
> is not autoloadable and there is no modules.alias data for the PCI
> IDs.
> 
> The admin must explicitly load the module, just like the admin must
> explicitly do "cat > new_id". "modprobe nvlink_vfio_pci" replaces
> "newid", and preloading the correct IDs into the module's driver makes
> the entire admin experience much more natural and safe.
> 
> This could be improved with some simple work in the driver core:
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 2f32f38a11ed0b..dc3b088ad44d69 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -828,6 +828,9 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
>  	bool async_allowed;
>  	int ret;
>  
> +	if (drv->flags & DRIVER_EXPLICIT_BIND_ONLY)
> +		continue;
> +
>  	ret = driver_match_device(drv, dev);
>  	if (ret == 0) {
>  		/* no match */
> 
> Thus the match table could be properly specified, but only explicit
> manual bind would attach the driver. This would cleanly resolve the
> duplicate ID problem, and we could even set a wildcard PCI match table
> for vfio_pci and eliminate the new_id part of the sequence.
> 
> However, I'd prefer to split any driver core work from VFIO parts - so
> I'd propose starting by splitting to vfio_pci_core.ko, vfio_pci.ko,
> nvlink_vfio_pci.ko, and igd_vfio_pci.ko working as above.

For the most part, this explicit bind interface is redundant to
driver_override, which already avoids the duplicate ID issue.  A user
specifies a driver to use for a given device, which automatically makes
the driver match accept the device and there are no conflicts with
native drivers.  The problem is still how the user knows to choose
vfio-pci-igd for a device versus vfio-pci-nvlink, other vendor drivers,
or vfio-pci.

A driver id table doesn't really help for binding the device,
ultimately even if a device is in the id table it might fail to probe
due to the missing platform support that each of these igd and nvlink
drivers expose, at which point the user would need to pick a next best
options.  Are you somehow proposing the driver id table for the user to
understand possible drivers, even if that doesn't prioritize them?  I
don't see that there's anything new here otherwise.  Thanks,

Alex

