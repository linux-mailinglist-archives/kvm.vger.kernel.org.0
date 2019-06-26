Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FB95700C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 19:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfFZRxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 13:53:12 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14966 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZRxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 13:53:12 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d13b1060000>; Wed, 26 Jun 2019 10:53:10 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 26 Jun 2019 10:53:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 26 Jun 2019 10:53:11 -0700
Received: from [10.24.71.21] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Jun
 2019 17:53:08 +0000
Subject: Re: [PATCH] mdev: Send uevents around parent device registration
To:     Alex Williamson <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <156155924767.11505.11457229921502145577.stgit@gimli.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <1ea5c171-cd42-1c10-966e-1b82a27351d9@nvidia.com>
Date:   Wed, 26 Jun 2019 23:23:00 +0530
MIME-Version: 1.0
In-Reply-To: <156155924767.11505.11457229921502145577.stgit@gimli.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561571590; bh=LGSTYDz/2xMeg3hCVhFABpMD1S8R+w3gGWDgczmXtqw=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=RUzreyTBwB3woVqA5qPgEp6k7Xi3YMzpUaCfsMzTiaMF2r97aNaCrrLUBzTVjYWdX
         fYwJ+gPtvGmF4L5nvnpo1Yr8sFQ5HM47vJT4YxtbaQN1l1tOETjzJvMIt6SwPJJCL5
         mxIAFY6BjlyxOKuunHKZqDpgzPB+ytZvKSTJScM23noZNktp4Kr6licizavrDGLLE/
         3rurrirldNWgTp7WAMMHtwtbKhm1TFijJJpQgk0GUe+dQvRpnNfpczZ0sm4CQx4KyK
         iT8dw2q+BC0knJ4ca9fUaom9fuDlcK7qW4czNeG3os2R80OTHSXcVEqx9Rvxh+2D6h
         KPvGGWU+t4jMg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/26/2019 7:57 PM, Alex Williamson wrote:
> This allows udev to trigger rules when a parent device is registered
> or unregistered from mdev.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/mdev/mdev_core.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index ae23151442cb..ecec2a3b13cb 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -146,6 +146,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>  {
>  	int ret;
>  	struct mdev_parent *parent;
> +	char *env_string = "MDEV_STATE=registered";
> +	char *envp[] = { env_string, NULL };
>  
>  	/* check for mandatory ops */
>  	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
> @@ -196,7 +198,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>  	list_add(&parent->next, &parent_list);
>  	mutex_unlock(&parent_list_lock);
>  
> -	dev_info(dev, "MDEV: Registered\n");
> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> +

Its good to have udev event, but don't remove debug print from dmesg.
Same for unregister.

Thanks,
Kirti


>  	return 0;
>  
>  add_dev_err:
> @@ -220,6 +223,8 @@ EXPORT_SYMBOL(mdev_register_device);
>  void mdev_unregister_device(struct device *dev)
>  {
>  	struct mdev_parent *parent;
> +	char *env_string = "MDEV_STATE=unregistered";
> +	char *envp[] = { env_string, NULL };
>  
>  	mutex_lock(&parent_list_lock);
>  	parent = __find_parent_device(dev);
> @@ -228,7 +233,6 @@ void mdev_unregister_device(struct device *dev)
>  		mutex_unlock(&parent_list_lock);
>  		return;
>  	}
> -	dev_info(dev, "MDEV: Unregistering\n");
>  
>  	list_del(&parent->next);
>  	mutex_unlock(&parent_list_lock);
> @@ -243,6 +247,8 @@ void mdev_unregister_device(struct device *dev)
>  	up_write(&parent->unreg_sem);
>  
>  	mdev_put_parent(parent);
> +
> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>  }
>  EXPORT_SYMBOL(mdev_unregister_device);
>  
> 
