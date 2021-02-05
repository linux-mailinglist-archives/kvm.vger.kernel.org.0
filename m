Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56229310371
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 04:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhBEDTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 22:19:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229717AbhBEDTu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 22:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612495104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8f5YNAREUXRNKxTFWHdq8ACl9JhrFD9o9V+DNNSV58o=;
        b=gR3S6MVbr3wyieaXjzC8NAWaP31O6co1t94SgylRipQubYlXMwDrZx/1wWowlSJLo2zeO6
        aVaPQBHHsZ0GNitQJBdCtLUbHd6t50v3DViKNLgljBU1vFZfVETM2KPs5zoMzYyzXp5vA1
        j8+mIl0YcTOw1QpeVhCOESJcYYk+hK8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-JOAVM-QBOKGtssQ-ddjj_Q-1; Thu, 04 Feb 2021 22:18:20 -0500
X-MC-Unique: JOAVM-QBOKGtssQ-ddjj_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B0CC91271;
        Fri,  5 Feb 2021 03:18:19 +0000 (UTC)
Received: from [10.72.12.112] (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AB4972F81;
        Fri,  5 Feb 2021 03:18:08 +0000 (UTC)
Subject: Re: [PATCH v3 03/13] vringh: reset kiov 'consumed' field in
 __vringh_iov()
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-4-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1a8f925a-13ea-a04e-1130-690fb0886bcd@redhat.com>
Date:   Fri, 5 Feb 2021 11:18:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210204172230.85853-4-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/5 上午1:22, Stefano Garzarella wrote:
> __vringh_iov() overwrites the contents of riov and wiov, in fact it
> resets the 'i' and 'used' fields, but also the 'consumed' field should
> be reset to avoid an inconsistent state.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   drivers/vhost/vringh.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)


Acked-by: Jason Wang <jasowang@redhat.com>


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

