Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BBC82DB6
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 10:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732187AbfHFI3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 04:29:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbfHFI3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 04:29:08 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D63430083EE;
        Tue,  6 Aug 2019 08:29:08 +0000 (UTC)
Received: from gondolin (dhcp-192-181.str.redhat.com [10.33.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B386B608AB;
        Tue,  6 Aug 2019 08:29:04 +0000 (UTC)
Date:   Tue, 6 Aug 2019 10:29:02 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, wankhede@nvidia.com,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        cjia@nvidia.com
Subject: Re: [PATCH 2/2] vfio/mdev: Removed unused and redundant API for
 mdev name
Message-ID: <20190806102902.3e09ab1a.cohuck@redhat.com>
In-Reply-To: <20190802065905.45239-3-parav@mellanox.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190802065905.45239-3-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 06 Aug 2019 08:29:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Aug 2019 01:59:05 -0500
Parav Pandit <parav@mellanox.com> wrote:

> There is no single production driver who is interested in mdev device
> name.
> Additionally mdev device name is already available using core kernel
> API dev_name().

The patch description is a bit confusing: You talk about removing an
api to access the device name, but what you are actually removing is
the api to access the device's uuid. That uuid is, of course, used to
generate the device name, but the two are not the same. Using
dev_name() gives you a string containing the uuid, not the uuid.

> 
> Hence removed unused exported symbol.

I'm not really against removing this api if no driver has interest in
the device's uuid (and I'm currently not seeing why they would need it;
we can easily add it back, should the need arise); but this needs a
different description.

> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 6 ------
>  include/linux/mdev.h          | 1 -
>  2 files changed, 7 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b558d4cfd082..c2b809cbe59f 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -57,12 +57,6 @@ struct mdev_device *mdev_from_dev(struct device *dev)
>  }
>  EXPORT_SYMBOL(mdev_from_dev);
>  
> -const guid_t *mdev_uuid(struct mdev_device *mdev)
> -{
> -	return &mdev->uuid;
> -}
> -EXPORT_SYMBOL(mdev_uuid);
> -
>  /* Should be called holding parent_list_lock */
>  static struct mdev_parent *__find_parent_device(struct device *dev)
>  {
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..375a5830c3d8 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -131,7 +131,6 @@ struct mdev_driver {
>  
>  void *mdev_get_drvdata(struct mdev_device *mdev);
>  void mdev_set_drvdata(struct mdev_device *mdev, void *data);
> -const guid_t *mdev_uuid(struct mdev_device *mdev);
>  
>  extern struct bus_type mdev_bus_type;
>  

