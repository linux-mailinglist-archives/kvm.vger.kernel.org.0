Return-Path: <kvm+bounces-32991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 218809E36BF
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:35:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B083B2F0ED
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 09:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248791AF0D6;
	Wed,  4 Dec 2024 09:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dza/0TLa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3501AF0C1
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 09:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733304756; cv=none; b=GA6inBlERf4/JlfqLp4XuezPIzUG9tneNNrbq+w04gdcX/SPukILrdRxjmLeFkIL1N4r4xbmJ+r01aXEBgGcxbKO5L3+POfvbnmZDRmG9/PpjWwRwpg9aGdlJWpI7uD0v3WbnZmL0PlUtukfBOpn0PZ/Wr3GxhXHpxTGM3yaLYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733304756; c=relaxed/simple;
	bh=uGLGUPR11Oq4RIwT+EVUNUyGO+ovlsxIquO5MV/ShKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIYlpYsoWbaXA+fbNcXj+9b/57aUptneymXrBsn9trKMBqTAolVB/okoQy/xDGrqNybQBojpc7/OkciWKa7pn2YBdkZ91fiTpHjpeb+hxjIOACHbR3/GXE+HlsrMc/UAujGDOeo8pneXQvWJQm16pC5Z4nNL4m/7IlIsIP8AwmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dza/0TLa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B691C4CED1;
	Wed,  4 Dec 2024 09:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733304755;
	bh=uGLGUPR11Oq4RIwT+EVUNUyGO+ovlsxIquO5MV/ShKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dza/0TLamDwke1LfTKKGLruo2hhFHPIQsqGZZDLyzRqjZ8dBfHbXXFAQYtsoHdXWj
	 7M41rrhhKRjwNKA8k0tebpqZUPSCPULljFVkk7LWjxyy+PeS2pVT4tj+we1YUL1sJR
	 mQ5sunazC51gyG9aW67Q4PKKErEa/N226PX0hmQM=
Date: Wed, 4 Dec 2024 10:32:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <2024120430-boneless-wafer-bf0c@gregkh>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>

On Tue, Dec 03, 2024 at 09:11:47PM +0100, Heiner Kallweit wrote:
> vfio/mdev is the last user of class_compat, and it doesn't use it for
> the intended purpose. See kdoc of class_compat_register():
> Compatibility class are meant as a temporary user-space compatibility
> workaround when converting a family of class devices to a bus devices.

True, so waht is mdev doing here?

> In addition it uses only a part of the class_compat functionality.
> So inline the needed functionality, and afterwards all class_compat
> code can be removed.
> 
> No functional change intended. Compile-tested only.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index ed4737de4..a22c49804 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -18,7 +18,7 @@
>  #define DRIVER_AUTHOR		"NVIDIA Corporation"
>  #define DRIVER_DESC		"Mediated device Core Driver"
>  
> -static struct class_compat *mdev_bus_compat_class;
> +static struct kobject *mdev_bus_kobj;



>  
>  static LIST_HEAD(mdev_list);
>  static DEFINE_MUTEX(mdev_list_lock);
> @@ -76,7 +76,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>  	if (ret)
>  		return ret;
>  
> -	ret = class_compat_create_link(mdev_bus_compat_class, dev, NULL);
> +	ret = sysfs_create_link(mdev_bus_kobj, &dev->kobj, dev_name(dev));

This feels really wrong, why create a link to a random kobject?  Who is
using this kobject link?

>  	if (ret)
>  		dev_warn(dev, "Failed to create compatibility class link\n");
>  
> @@ -98,7 +98,7 @@ void mdev_unregister_parent(struct mdev_parent *parent)
>  	dev_info(parent->dev, "MDEV: Unregistering\n");
>  
>  	down_write(&parent->unreg_sem);
> -	class_compat_remove_link(mdev_bus_compat_class, parent->dev, NULL);
> +	sysfs_remove_link(mdev_bus_kobj, dev_name(parent->dev));
>  	device_for_each_child(parent->dev, NULL, mdev_device_remove_cb);
>  	parent_remove_sysfs_files(parent);
>  	up_write(&parent->unreg_sem);
> @@ -251,8 +251,8 @@ static int __init mdev_init(void)
>  	if (ret)
>  		return ret;
>  
> -	mdev_bus_compat_class = class_compat_register("mdev_bus");
> -	if (!mdev_bus_compat_class) {
> +	mdev_bus_kobj = class_pseudo_register("mdev_bus");

But this isn't a class, so let's not fake it please.  Let's fix this
properly, odds are all of this code can just be removed entirely, right?

thanks,

greg k-h

