Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB63260CF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 11:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbfEVJzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 05:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbfEVJzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 05:55:08 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A459F8553B;
        Wed, 22 May 2019 09:55:07 +0000 (UTC)
Received: from gondolin (dhcp-192-213.str.redhat.com [10.33.192.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EFAF2CF79;
        Wed, 22 May 2019 09:55:06 +0000 (UTC)
Date:   Wed, 22 May 2019 11:55:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com, cjia@nvidia.com
Subject: Re: [PATCHv3 2/3] vfio/mdev: Avoid creating sysfs remove file on
 stale device removal
Message-ID: <20190522115504.2c440245.cohuck@redhat.com>
In-Reply-To: <20190516233034.16407-3-parav@mellanox.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-3-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 22 May 2019 09:55:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 May 2019 18:30:33 -0500
Parav Pandit <parav@mellanox.com> wrote:

> If device is removal is initiated by two threads as below, mdev core
> attempts to create a syfs remove file on stale device.
> During this flow, below [1] call trace is observed.
> 
>      cpu-0                                    cpu-1
>      -----                                    -----
>   mdev_unregister_device()
>     device_for_each_child
>        mdev_device_remove_cb
>           mdev_device_remove
>                                        user_syscall
>                                          remove_store()
>                                            mdev_device_remove()
>                                         [..]
>    unregister device();
>                                        /* not found in list or
>                                         * active=false.
>                                         */
>                                           sysfs_create_file()
>                                           ..Call trace
> 
> Now that mdev core follows correct device removal system of the linux
> bus model, remove shouldn't fail in normal cases. If it fails, there is
> no point of creating a stale file or checking for specific error status.
> 
> kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
> sysfs_create_file_ns+0x7f/0x90
> kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
> 5.1.0-rc6-vdevbus+ #6
> kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b
> 08/09/2016
> kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> kernel: Call Trace:
> kernel: remove_store+0xdc/0x100 [mdev]
> kernel: kernfs_fop_write+0x113/0x1a0
> kernel: vfs_write+0xad/0x1b0
> kernel: ksys_write+0x5a/0xe0
> kernel: do_syscall_64+0x5a/0x210
> kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 9f774b91d275..ffa3dcebf201 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -237,10 +237,8 @@ static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
>  		int ret;
>  
>  		ret = mdev_device_remove(dev);
> -		if (ret) {
> -			device_create_file(dev, attr);
> +		if (ret)
>  			return ret;
> -		}
>  	}
>  
>  	return count;

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
