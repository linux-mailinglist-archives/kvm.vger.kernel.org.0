Return-Path: <kvm+bounces-35055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5C1A093A4
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:35:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F08DD3A9CCF
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F632211473;
	Fri, 10 Jan 2025 14:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="go8IX5Qj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EBC211269
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519734; cv=none; b=SH3Y6x39jlXKPzcv40yHWpuFc6crPG5p+vNS/H+twfVs2FaDOgbb5D1gUWQSTnNBRC5b6oTxGstAKrCXdkIXpNJIOuQTRKV2uzW9rZPOmOFbxdDWBWn/5AERTHss6PeMvYZbi3FIrZzu+trSChFFHhFKK6bq0Bm8jsA1msL0tKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519734; c=relaxed/simple;
	bh=XxZTQ94IOB5giv2MX3QhVKqpyrKqpYGSguRp1nXjqRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=powH0/s4Wmfw3m+R+cd1xVlD0e8XtWKenpy5HsVGALyMCwJyCoOanBk5LkMOr2HEvHboCrxq9vbRXJ2sZ1IRk6T8b2fHfwl3491uX6FsaOVePYah5916BOS7NZEPoKklIABWbruXANRbTnVCXY9Wtlu6QukTwofyaE6Kw01rXKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=go8IX5Qj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D32CC4CED6;
	Fri, 10 Jan 2025 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736519734;
	bh=XxZTQ94IOB5giv2MX3QhVKqpyrKqpYGSguRp1nXjqRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=go8IX5QjRYm7Sfxekep3fqF3SL1bscXJahGh6ZNlPpJC6mBgoxVqzs7xdV5Ks0lbU
	 zKTkUR5gaf3YYK76mC8EWS+Of1a/SLBc0p9Ftwb8vZArfo2iZ5Ov1bQh8OcrUHac61
	 IoN42jeN69LWBJx1J+QZCJWLitM78nFEsrrzh7fs=
Date: Fri, 10 Jan 2025 15:35:30 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <2025011041-fervor-enlarged-9d52@gregkh>
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
> 
> In addition it uses only a part of the class_compat functionality.
> So inline the needed functionality, and afterwards all class_compat
> code can be removed.
> 
> No functional change intended. Compile-tested only.

Did this ever get tested?

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

If you want to resubmit this, after testing, you need some BIG comments
here as to what you are doing and why, and that no one else should EVER
do this again so they don't cut/paste from this code to create the same
mess.

thanks,

greg k-h

