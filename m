Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3746F2CD62B
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgLCM4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:56:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730507AbgLCM4O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 07:56:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607000087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JQ5li8kW8vouw7a1BEvL2lAOLaEbq6lyvNfsM0+NZP8=;
        b=Ivis+vVlQTzNc4XiWTut0KHCdHChTsVec3PzY7RndG53evPESBkNUxxepzoGmjsOj7jTjo
        3z2TeY17rs+F6G6fZ483b1cqdEO5p3QZwVjejy4QlMShUlDea7R1FxwSmKwFeZAemKn/Ip
        rTaZkonM3T6fIokW/eqznon+s6Q0A2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-NzWvwRlEO_ae3PfSfHTaAg-1; Thu, 03 Dec 2020 07:54:46 -0500
X-MC-Unique: NzWvwRlEO_ae3PfSfHTaAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05371800050;
        Thu,  3 Dec 2020 12:54:45 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F94410016F4;
        Thu,  3 Dec 2020 12:54:40 +0000 (UTC)
Subject: Re: [PATCH v1 2/5] vfio: platform: Switch to use
 platform_get_mem_or_io_resource()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
 <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <fb0b02a0-d672-0ff8-be80-b95bdbb58e57@redhat.com>
Date:   Thu, 3 Dec 2020 13:54:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andy,

On 10/27/20 6:58 PM, Andy Shevchenko wrote:
> Switch to use new platform_get_mem_or_io_resource() instead of
> home grown analogue.
> 
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  drivers/vfio/platform/vfio_platform.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 1e2769010089..84afafb6941b 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -25,19 +25,8 @@ static struct resource *get_platform_resource(struct vfio_platform_device *vdev,
>  					      int num)
>  {
>  	struct platform_device *dev = (struct platform_device *) vdev->opaque;
> -	int i;
>  
> -	for (i = 0; i < dev->num_resources; i++) {
> -		struct resource *r = &dev->resource[i];
> -
> -		if (resource_type(r) & (IORESOURCE_MEM|IORESOURCE_IO)) {
> -			if (!num)
> -				return r;
> -
> -			num--;
> -		}
> -	}
> -	return NULL;
> +	return platform_get_mem_or_io_resource(dev, num);
>  }
>  
>  static int get_platform_irq(struct vfio_platform_device *vdev, int i)
> 

