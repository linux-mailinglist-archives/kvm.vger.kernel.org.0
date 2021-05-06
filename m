Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F228374D76
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 04:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhEFCXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 22:23:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229872AbhEFCXM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 22:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620267734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3CdvH8xTT3peeZGIlgh4cyu9+qImg7sI6BgRnLL1RQU=;
        b=F5IEwQ2iVdfQhriFRxrYLBfBHgDflI93Xm+pWAML4UdvWGejsR9thW/s/xNsWERxFKiEzP
        INAoPJw+4unPRzficUMyWlzW28sXuuMM3UuBuuCP9jWEiRZhnsx0VgordGTtKfbssOCymu
        ZRCPwNVM5YMGjV67MLdK0N3NaXg1ejw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-LcMFX_I5M2GzL0Rvi9eX6A-1; Wed, 05 May 2021 22:22:12 -0400
X-MC-Unique: LcMFX_I5M2GzL0Rvi9eX6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB9C18049C5;
        Thu,  6 May 2021 02:22:11 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-159.pek2.redhat.com [10.72.13.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14AECBA6F;
        Thu,  6 May 2021 02:22:06 +0000 (UTC)
Subject: Re: [PATCH 1/1] virtio-net: don't allocate control_buf if not
 supported
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20210502093319.61313-1-mgurtovoy@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <43ee9a1d-95fc-acbb-0830-1f87770e2f2e@redhat.com>
Date:   Thu, 6 May 2021 10:22:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210502093319.61313-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/2 ÏÂÎç5:33, Max Gurtovoy Ð´µÀ:
> Not all virtio_net devices support the ctrl queue feature. Thus, there
> is no need to allocate unused resources.
>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7fda2ae4c40f..9b6a4a875c55 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2870,9 +2870,13 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>   {
>   	int i;
>   
> -	vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
> -	if (!vi->ctrl)
> -		goto err_ctrl;
> +	if (vi->has_cvq) {
> +		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
> +		if (!vi->ctrl)
> +			goto err_ctrl;
> +	} else {
> +		vi->ctrl = NULL;
> +	}
>   	vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), GFP_KERNEL);
>   	if (!vi->sq)
>   		goto err_sq;

