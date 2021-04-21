Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CE5367556
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 00:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243839AbhDUWwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 18:52:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235481AbhDUWwU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 18:52:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619045506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2eln1RiXUGbh8l5mrppZibe/ezmLkuWu5Q7gl1yH1I=;
        b=MRAI7oCWFkUQLqtzO0Dh53vdL5Dl5LOpboaZqZshDVPhud6tQZLe0vt1FoVGHyPR/KY5ux
        TYpfLUmNzWHfjWSD29W57MLJuGb2YZYo0hV09ngBM9GZakovC7CbDvVjX/Nj96O0y+D7hd
        DxPHRyaqEtGa5axXsiRRk9iLNAdhcko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-kd-xcCRJM6KjHMqIGpOPVg-1; Wed, 21 Apr 2021 18:51:42 -0400
X-MC-Unique: kd-xcCRJM6KjHMqIGpOPVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 699F4343A3;
        Wed, 21 Apr 2021 22:51:41 +0000 (UTC)
Received: from redhat.com (ovpn-114-21.phx2.redhat.com [10.3.114.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0637F5D747;
        Wed, 21 Apr 2021 22:51:40 +0000 (UTC)
Date:   Wed, 21 Apr 2021 16:51:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vfio/mdev: remove unnecessary NULL check in
 mbochs_create()
Message-ID: <20210421165140.52e9083b@redhat.com>
In-Reply-To: <YIAowNYCOCNu+xhm@mwanda>
References: <YIAowNYCOCNu+xhm@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Apr 2021 16:29:36 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This NULL check is no longer required because "type" now points to
> an element in a non-NULL array.

I think the mdpy change is correct too, but it's hard to verify from
this commit log that it was actually intended.  Can we note that change
as well?  Thanks,

Alex

> 
> Fixes: 3d3a360e570616 ("vfio/mbochs: Use mdev_get_type_group_id()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  samples/vfio-mdev/mbochs.c | 2 --
>  samples/vfio-mdev/mdpy.c | 3 +--
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 861c76914e76..881ef9a7296f 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -513,8 +513,6 @@ static int mbochs_create(struct mdev_device *mdev)
>  	struct device *dev = mdev_dev(mdev);
>  	struct mdev_state *mdev_state;
>  
> -	if (!type)
> -		type = &mbochs_types[0];
>  	if (type->mbytes + mbochs_used_mbytes > max_mbytes)
>  		return -ENOMEM;
>  
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index f0c0e7209719..e889c1cf8fd1 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -667,8 +667,7 @@ static ssize_t description_show(struct mdev_type *mtype,
>  		&mdpy_types[mtype_get_type_group_id(mtype)];
>  
>  	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
> -		       type ? type->width  : 0,
> -		       type ? type->height : 0);
> +		       type->width, type->height);
>  }
>  static MDEV_TYPE_ATTR_RO(description);
>  

