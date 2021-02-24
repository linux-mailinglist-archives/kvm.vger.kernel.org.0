Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D2A3239E6
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 10:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhBXJve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 04:51:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234693AbhBXJut (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 04:50:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614160163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KYD936HuTNo+KSuXnQ5W3SqImmaE+mqAauiz+YuQXU=;
        b=GWh0jCrYHVxCbLQ6drjNz7t1g1PG9CBOVRQ+bJzlPRfaOW9rnynuhOQt6afai/wVfkqGQE
        2IXRdsgMD9nl4XZ0XA8f5Cpt6elAY/4HkX34u8nNpBmeiYuFS4LlCAn2ZZOyRSYoyYL3cI
        sjcTCtYN0JAbtPkpatZPFzFPfbUrHpg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-ZI62ayo4OQ-5ejOyziUB5w-1; Wed, 24 Feb 2021 04:49:21 -0500
X-MC-Unique: ZI62ayo4OQ-5ejOyziUB5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38AAF1868408;
        Wed, 24 Feb 2021 09:49:20 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B7256F929;
        Wed, 24 Feb 2021 09:49:17 +0000 (UTC)
Subject: Re: [PATCH 3/3] ARM: amba: Allow some ARM_AMBA users to compile with
 COMPILE_TEST
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
References: <3-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e547120a-2c01-b10a-2597-8484c4731d0f@redhat.com>
Date:   Wed, 24 Feb 2021 10:49:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <3-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2/23/21 8:17 PM, Jason Gunthorpe wrote:
> CONFIG_VFIO_AMBA has a light use of AMBA, adding some inline fallbacks
> when AMBA is disabled will allow it to be compiled under COMPILE_TEST and
> make VFIO easier to maintain.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/platform/Kconfig |  2 +-
>  include/linux/amba/bus.h      | 11 +++++++++++
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index 233efde219cc10..ab341108a0be94 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -12,7 +12,7 @@ config VFIO_PLATFORM
>  
>  config VFIO_AMBA
>  	tristate "VFIO support for AMBA devices"
> -	depends on VFIO_PLATFORM && ARM_AMBA
> +	depends on VFIO_PLATFORM && (ARM_AMBA || COMPILE_TEST)
>  	help
>  	  Support for ARM AMBA devices with VFIO. This is required to make
>  	  use of ARM AMBA devices present on the system using the VFIO
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index 0bbfd647f5c6de..977edd6e541ddd 100644
> --- a/include/linux/amba/bus.h
> +++ b/include/linux/amba/bus.h
> @@ -105,8 +105,19 @@ extern struct bus_type amba_bustype;
>  #define amba_get_drvdata(d)	dev_get_drvdata(&d->dev)
>  #define amba_set_drvdata(d,p)	dev_set_drvdata(&d->dev, p)
>  
> +#ifdef CONFIG_ARM_AMBA
>  int amba_driver_register(struct amba_driver *);
>  void amba_driver_unregister(struct amba_driver *);
> +#else
> +static inline int amba_driver_register(struct amba_driver *drv)
> +{
> +	return -EINVAL;
> +}
> +static inline void amba_driver_unregister(struct amba_driver *drv)
> +{
> +}
> +#endif
> +
>  struct amba_device *amba_device_alloc(const char *, resource_size_t, size_t);
>  void amba_device_put(struct amba_device *);
>  int amba_device_add(struct amba_device *, struct resource *);
> 

