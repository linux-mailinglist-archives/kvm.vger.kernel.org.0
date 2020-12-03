Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AA92CD69E
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 14:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgLCNXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 08:23:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727322AbgLCNXV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 08:23:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607001715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xr6ubetRcdw3MknkwI3+tg6m/AwRRq+QdjB3wYZxUt8=;
        b=VjUf11qJ+DwmmNZQaEszEUSXspFjJiApPumCHvGPZyUwG1dVigWz6wTV8X1YJJoaVsFo39
        Gioi7uKBUw+IQcE4dL8xqniilyK/fRayXFJzjkKtbos45OOGeYyGyBayDH3sQ0O5iXPONY
        ryCrz1GuxTY+NcsWPMdXErXVmsJDFJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-ivUdRog-NqWVMt9wROXWjg-1; Thu, 03 Dec 2020 08:21:53 -0500
X-MC-Unique: ivUdRog-NqWVMt9wROXWjg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4FDC100F350;
        Thu,  3 Dec 2020 13:21:51 +0000 (UTC)
Received: from gondolin (ovpn-113-106.ams2.redhat.com [10.36.113.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F17035C1BD;
        Thu,  3 Dec 2020 13:21:42 +0000 (UTC)
Date:   Thu, 3 Dec 2020 14:21:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-usb@vger.kernel.org,
        Peng Hao <peng.hao2@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v1 1/5] driver core: platform: Introduce
 platform_get_mem_or_io_resource()
Message-ID: <20201203142140.73a0c5e6.cohuck@redhat.com>
In-Reply-To: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Oct 2020 19:58:02 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> There are at least few existing users of the proposed API which
> retrieves either MEM or IO resource from platform device.
> 
> Make it common to utilize in the existing and new users.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Peng Hao <peng.hao2@zte.com.cn>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/platform_device.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 77a2aada106d..eb8d74744e29 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -52,6 +52,19 @@ extern struct device platform_bus;
>  
>  extern struct resource *platform_get_resource(struct platform_device *,
>  					      unsigned int, unsigned int);
> +static inline
> +struct resource *platform_get_mem_or_io_resource(struct platform_device *pdev,

Minor nit: If I would want to break up the long line, I'd use

static inline struct resource *
platform_get_mem_or_io_resource(...)

> +						 unsigned int num)
> +{
> +	struct resource *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, num);
> +	if (res)
> +		return res;
> +
> +	return platform_get_resource(pdev, IORESOURCE_IO, num);
> +}
> +
>  extern struct device *
>  platform_find_device_by_driver(struct device *start,
>  			       const struct device_driver *drv);

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

