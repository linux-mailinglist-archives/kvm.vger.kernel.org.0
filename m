Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B90A2CB692
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 09:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgLBIPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 03:15:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728833AbgLBIPc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 03:15:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606896846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSArC6dGGVsRkfFz7XmGCs7/7Y4wrkwjTBmdaGQey7s=;
        b=MiMNAbV8v/T8ML09dEAz49/7TN71g8N5iqcrLli//g1w0KOGPmnz0D0feYUYCIRp94jxCu
        0ETFMp+aG0oMD68d/ypkYLYbPtgmFQYiJMzX52R59mGMimqxRmwuqnbvAYQqag9H61w/pq
        LGXNokBewsfM3bmFKJ+oA3N2u+ClMDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-aSLoB9UzM86IkAz7KaUL4w-1; Wed, 02 Dec 2020 03:14:02 -0500
X-MC-Unique: aSLoB9UzM86IkAz7KaUL4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0B9F185E486;
        Wed,  2 Dec 2020 08:14:00 +0000 (UTC)
Received: from [10.72.13.145] (ovpn-13-145.pek2.redhat.com [10.72.13.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 829575D705;
        Wed,  2 Dec 2020 08:13:55 +0000 (UTC)
Subject: Re: [PATCH] vhost_vdpa: return -EFAULT if copy_to_user() fails
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kernel-janitors@vger.kernel.org
References: <X8c32z5EtDsMyyIL@mwanda>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a94dfe3f-2202-7848-ed61-a8b682a7643d@redhat.com>
Date:   Wed, 2 Dec 2020 16:13:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X8c32z5EtDsMyyIL@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/12/2 下午2:44, Dan Carpenter wrote:
> The copy_to_user() function returns the number of bytes remaining to be
> copied but this should return -EFAULT to the user.
>
> Fixes: 1b48dc03e575 ("vhost: vdpa: report iova range")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/vhost/vdpa.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index d6a37b66770b..ef688c8c0e0e 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -344,7 +344,9 @@ static long vhost_vdpa_get_iova_range(struct vhost_vdpa *v, u32 __user *argp)
>   		.last = v->range.last,
>   	};
>   
> -	return copy_to_user(argp, &range, sizeof(range));
> +	if (copy_to_user(argp, &range, sizeof(range)))
> +		return -EFAULT;
> +	return 0;
>   }
>   
>   static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


