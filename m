Return-Path: <kvm+bounces-32992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 420309E36BB
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08297280CE7
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 09:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D741AB6D4;
	Wed,  4 Dec 2024 09:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZMnBbIH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DD61A38E3
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 09:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733304807; cv=none; b=a+zX2zAZm5qY3/DOea7dUMBaifo3DdUcwvcm9kI1XLJoyiWolGkGO7vlkXIapRqtrj8FbQ9SuiktRrJnmfSSEvoqS/+wmEZMH9nsTTOSqbPEKy3Vsig5SUJE5FjtpAxpCARMSroXztwfsmVjVJW+nxGaVv1+RUPBPKCcgo82GZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733304807; c=relaxed/simple;
	bh=Khb8LZ/QSzDOCaNq6dFGqIOsdkPMkeZgZu/SNyNAZP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YH7rPNxxNqgab0EG1hSs5wkYbyCpJWpAxEXZ95q0MRgu9VVTkYRwWlKnMoLAwzKpd0Ujw7ogMJHC27tGtMknLtUWCVqC5R6tJZClyyx+//Pg0HWVpiMvOrun8XIHsIps2arQCPMQeJciGobv0d8q6LXQ6KraunxCOHyftN996eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZMnBbIH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756CDC4CED1;
	Wed,  4 Dec 2024 09:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733304807;
	bh=Khb8LZ/QSzDOCaNq6dFGqIOsdkPMkeZgZu/SNyNAZP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OZMnBbIHxQUCsuQ83RuYP/zpRx8mn7oEB6vpXhjPH/QJDv0aXbANKP4lGNQAdU2Ak
	 q1Bv0DcJ8IAB3vTAxYlf7j3T8053k/KFj5owhG7SgRcNwkWYNwGQ8N5Un+vYWZt5H2
	 6rGO8vGT3YelBJ1mAzcqkhTIHTfXlTTjnmYYOPAo=
Date: Wed, 4 Dec 2024 10:33:23 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core: class: add class_pseudo_register
Message-ID: <2024120435-deserving-elf-c1e1@gregkh>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
 <b8122113-5863-4057-81b5-73f86c9fde4d@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8122113-5863-4057-81b5-73f86c9fde4d@gmail.com>

On Tue, Dec 03, 2024 at 09:10:05PM +0100, Heiner Kallweit wrote:
> In preparation of removing class_compat support, add a helper for
> creating a pseudo class in sysfs. This way we can keep class_kset
> private to driver core. This helper will be used by vfio/mdev,
> replacing the call to class_compat_create().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/base/class.c         | 14 ++++++++++++++
>  include/linux/device/class.h |  1 +
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/base/class.c b/drivers/base/class.c
> index 582b5a02a..f812236e2 100644
> --- a/drivers/base/class.c
> +++ b/drivers/base/class.c
> @@ -578,6 +578,20 @@ struct class_compat *class_compat_register(const char *name)
>  }
>  EXPORT_SYMBOL_GPL(class_compat_register);
>  
> +/**
> + * class_pseudo_register - create a pseudo class entry in sysfs
> + * @name: the name of the child
> + *
> + * Helper for creating a pseudo class in sysfs, keeps class_kset private
> + *
> + * Returns: the created kobject
> + */
> +struct kobject *class_pseudo_register(const char *name)
> +{
> +	return kobject_create_and_add(name, &class_kset->kobj);
> +}
> +EXPORT_SYMBOL_GPL(class_pseudo_register);

I see the goal here, but let's not continue on and create fake kobjects
in places where there should NOT be any kobjects.  Also, you might get
in trouble when removing this kobject as it thinks it is a 'struct
class' but yet it isn't, right?  Did you test that?

thanks,

greg k-h

