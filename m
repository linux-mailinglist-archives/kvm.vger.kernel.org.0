Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44008310373
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 04:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhBEDUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 22:20:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229750AbhBEDUQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 22:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612495129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z+OMUQChPI2nH7Skoc2akxJEI5HA3PfrfqiF984pQ/0=;
        b=LUrhnNXrmqYVdrA/QPswwFGQNCpYOV29XVZVtpDDUgXPFW/mdYVRkQUqLfc5uPDNPnsjXY
        49eUtSUwTJX/OS+kbjz3Mukolvx5etCrERLBLHeq1/GLOJ4QOMsl2Y4h2f+moqmnodjjet
        dtw0KfathODlxVdJLO0VuYTpEj6UdWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-Er2d2Fp0Pbuskmk1acdrAQ-1; Thu, 04 Feb 2021 22:18:47 -0500
X-MC-Unique: Er2d2Fp0Pbuskmk1acdrAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3E421020C20;
        Fri,  5 Feb 2021 03:18:46 +0000 (UTC)
Received: from [10.72.12.112] (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4448D60BE2;
        Fri,  5 Feb 2021 03:18:37 +0000 (UTC)
Subject: Re: [PATCH v3 04/13] vringh: explain more about cleaning riov and
 wiov
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-5-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4a4bf8ad-5853-c054-4d04-450f1966c9a2@redhat.com>
Date:   Fri, 5 Feb 2021 11:18:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210204172230.85853-5-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/5 上午1:22, Stefano Garzarella wrote:
> riov and wiov can be reused with subsequent calls of vringh_getdesc_*().
>
> Let's add a paragraph in the documentation of these functions to better
> explain when riov and wiov need to be cleaned up.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   drivers/vhost/vringh.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)


Acked-by: Jason Wang <jasowang@redhat.com>


>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index bee63d68201a..2a88e087afd8 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -662,7 +662,10 @@ EXPORT_SYMBOL(vringh_init_user);
>    * *head will be vrh->vring.num.  You may be able to ignore an invalid
>    * descriptor, but there's not much you can do with an invalid ring.
>    *
> - * Note that you may need to clean up riov and wiov, even on error!
> + * Note that you can reuse riov and wiov with subsequent calls. Content is
> + * overwritten and memory reallocated if more space is needed.
> + * When you don't have to use riov and wiov anymore, you should clean up them
> + * calling vringh_iov_cleanup() to release the memory, even on error!
>    */
>   int vringh_getdesc_user(struct vringh *vrh,
>   			struct vringh_iov *riov,
> @@ -932,7 +935,10 @@ EXPORT_SYMBOL(vringh_init_kern);
>    * *head will be vrh->vring.num.  You may be able to ignore an invalid
>    * descriptor, but there's not much you can do with an invalid ring.
>    *
> - * Note that you may need to clean up riov and wiov, even on error!
> + * Note that you can reuse riov and wiov with subsequent calls. Content is
> + * overwritten and memory reallocated if more space is needed.
> + * When you don't have to use riov and wiov anymore, you should clean up them
> + * calling vringh_kiov_cleanup() to release the memory, even on error!
>    */
>   int vringh_getdesc_kern(struct vringh *vrh,
>   			struct vringh_kiov *riov,
> @@ -1292,7 +1298,10 @@ EXPORT_SYMBOL(vringh_set_iotlb);
>    * *head will be vrh->vring.num.  You may be able to ignore an invalid
>    * descriptor, but there's not much you can do with an invalid ring.
>    *
> - * Note that you may need to clean up riov and wiov, even on error!
> + * Note that you can reuse riov and wiov with subsequent calls. Content is
> + * overwritten and memory reallocated if more space is needed.
> + * When you don't have to use riov and wiov anymore, you should clean up them
> + * calling vringh_kiov_cleanup() to release the memory, even on error!
>    */
>   int vringh_getdesc_iotlb(struct vringh *vrh,
>   			 struct vringh_kiov *riov,

