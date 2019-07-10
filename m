Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8794F64BEC
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 20:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfGJSLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 14:11:41 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10961 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbfGJSLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 14:11:41 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d262a610001>; Wed, 10 Jul 2019 11:11:45 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 10 Jul 2019 11:11:40 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 10 Jul 2019 11:11:40 -0700
Received: from [10.24.71.30] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Jul
 2019 18:11:37 +0000
Subject: Re: [PATCH v3] mdev: Send uevents around parent device registration
To:     Alex Williamson <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <156278027422.16516.5157992389394627876.stgit@gimli.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <4f32e5e2-2bac-81f2-9fb6-3d0023ed009b@nvidia.com>
Date:   Wed, 10 Jul 2019 23:41:21 +0530
MIME-Version: 1.0
In-Reply-To: <156278027422.16516.5157992389394627876.stgit@gimli.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562782305; bh=Jm+B0NDGcf5E+KZa28wTh/6TcnljOB+d/mUr++GB+Ss=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Kpp1R694nKbrkkjAfYZt7UHmvADP1mGL54vOLzZpd9OmLia/W6dQojqtAXS0VYjb/
         /QrYwBf4Vt++M9MhCSYhkDoK+OANyYj4D+U6XzDx6+zzVespP/019ey6D84QdX2Mc3
         NeNy8SqsAC9KHtR8nn+4/6rR0qi7WhGsRJp4q+UzatUVB+95OVPqiSclKRfC/k/RSI
         BnCHuXfvl0K9r2bc84QX68bJqWheAnV8c2/HHytVb+u313eAHvq1pPAwJSQ980p3rB
         B/zQpfBLs9R863ojAWYsJAmJbblqg7Cvcdb/9n6I7tCsp3LSanQyCRom62RWflhXHQ
         s0uL8Gcgjnf2A==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/10/2019 11:11 PM, Alex Williamson wrote:
> This allows udev to trigger rules when a parent device is registered
> or unregistered from mdev.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> v3: Add Connie's R-b
>     Add comment clarifying expected device requirements for unreg
> 

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

Thanks,
Kirti

>  drivers/vfio/mdev/mdev_core.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index ae23151442cb..23976db6c6c7 100644
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
> @@ -197,6 +199,8 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>  	mutex_unlock(&parent_list_lock);
>  
>  	dev_info(dev, "MDEV: Registered\n");
> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
> +
>  	return 0;
>  
>  add_dev_err:
> @@ -220,6 +224,8 @@ EXPORT_SYMBOL(mdev_register_device);
>  void mdev_unregister_device(struct device *dev)
>  {
>  	struct mdev_parent *parent;
> +	char *env_string = "MDEV_STATE=unregistered";
> +	char *envp[] = { env_string, NULL };
>  
>  	mutex_lock(&parent_list_lock);
>  	parent = __find_parent_device(dev);
> @@ -243,6 +249,9 @@ void mdev_unregister_device(struct device *dev)
>  	up_write(&parent->unreg_sem);
>  
>  	mdev_put_parent(parent);
> +
> +	/* We still have the caller's reference to use for the uevent */
> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>  }
>  EXPORT_SYMBOL(mdev_unregister_device);
>  
> 
