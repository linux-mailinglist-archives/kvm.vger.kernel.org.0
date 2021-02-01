Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E0830A21F
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhBAGnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:43:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231598AbhBAFls (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 00:41:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612158016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5mQIIlM5CFm8xeXBVRv4nhYcFaur8L2TXYtvPPpQAxw=;
        b=dhKJrP/xoCyPJVF3+19azybF6bXigf5S1QqUbP0OcLRkomGIkEA3LySWzpHkifxUuXWbSz
        rBSsQD3V/+pwLc0faEQwEoL9/26syyuQeVsDNbzTjzXQandpt9gPgc9Aa0cfsJV1Bq2qAX
        ZiE2kpegDo8REL30KL8gSu1fDwLa3PU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-vKvb8gjeOfq7lZK4FcopZQ-1; Mon, 01 Feb 2021 00:40:15 -0500
X-MC-Unique: vKvb8gjeOfq7lZK4FcopZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD98FCC620;
        Mon,  1 Feb 2021 05:40:13 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 476F627CA9;
        Mon,  1 Feb 2021 05:40:03 +0000 (UTC)
Subject: Re: [PATCH RFC v2 03/10] vringh: reset kiov 'consumed' field in
 __vringh_iov()
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-4-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <62bb2e93-4ac3-edf5-2baa-4c2be8257cf0@redhat.com>
Date:   Mon, 1 Feb 2021 13:40:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128144127.113245-4-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/28 下午10:41, Stefano Garzarella wrote:
> __vringh_iov() overwrites the contents of riov and wiov, in fact it
> resets the 'i' and 'used' fields, but also the consumed field should
> be reset to avoid an inconsistent state.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


I had a question(I remember we had some discussion like this but I 
forget the conclusion):

I see e.g in vringh_getdesc_kern() it has the following comment:

/*
  * Note that you may need to clean up riov and wiov, even on error!
  */

So it looks to me the correct way is to call vringh_kiov_cleanup() before?

Thanks


> ---
>   drivers/vhost/vringh.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index f68122705719..bee63d68201a 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -290,9 +290,9 @@ __vringh_iov(struct vringh *vrh, u16 i,
>   		return -EINVAL;
>   
>   	if (riov)
> -		riov->i = riov->used = 0;
> +		riov->i = riov->used = riov->consumed = 0;
>   	if (wiov)
> -		wiov->i = wiov->used = 0;
> +		wiov->i = wiov->used = wiov->consumed = 0;
>   
>   	for (;;) {
>   		void *addr;

