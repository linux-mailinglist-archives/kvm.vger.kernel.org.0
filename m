Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C0730A220
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhBAGnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:43:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231665AbhBAFpN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 00:45:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612158219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZTIT6r9DAQKDIN9nnIQ8ksj8MiamUBCd7gKXxENqMM=;
        b=XCzlEu3hK7GvM6DDgPe8vljYPL5CEpzkg/2fqgBUbg/ZZ3nxPXRP1sUFvg74imqARFv9qN
        qDIKSHTvm7QY39Y5ESGqgcBNkvjgI9bbE2wuBHAoExoZfGNKBJLnnkCTCYr/OaSMSbfLCH
        0mx/HfiWJohroh3ccGssby0kEg3pAKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-Ovnzy_d2OluYL-XINZbruw-1; Mon, 01 Feb 2021 00:43:35 -0500
X-MC-Unique: Ovnzy_d2OluYL-XINZbruw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13FBE18C89DE;
        Mon,  1 Feb 2021 05:43:34 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC16227C42;
        Mon,  1 Feb 2021 05:43:24 +0000 (UTC)
Subject: Re: [PATCH RFC v2 04/10] vringh: implement vringh_kiov_advance()
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-5-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <78247eb0-8e6e-f2fa-a693-1b0f14db61dd@redhat.com>
Date:   Mon, 1 Feb 2021 13:43:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128144127.113245-5-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/28 下午10:41, Stefano Garzarella wrote:
> In some cases, it may be useful to provide a way to skip a number
> of bytes in a vringh_kiov.
>
> Let's implement vringh_kiov_advance() for this purpose, reusing the
> code from vringh_iov_xfer().
> We replace that code calling the new vringh_kiov_advance().


Acked-by: Jason Wang <jasowang@redhat.com>

In the long run we need to switch to use iov iterator library instead.

Thanks


>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   include/linux/vringh.h |  2 ++
>   drivers/vhost/vringh.c | 41 +++++++++++++++++++++++++++++------------
>   2 files changed, 31 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 9c077863c8f6..755211ebd195 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -199,6 +199,8 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
>   	kiov->iov = NULL;
>   }
>   
> +void vringh_kiov_advance(struct vringh_kiov *kiov, size_t len);
> +
>   int vringh_getdesc_kern(struct vringh *vrh,
>   			struct vringh_kiov *riov,
>   			struct vringh_kiov *wiov,
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index bee63d68201a..4d800e4f31ca 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -75,6 +75,34 @@ static inline int __vringh_get_head(const struct vringh *vrh,
>   	return head;
>   }
>   
> +/**
> + * vringh_kiov_advance - skip bytes from vring_kiov
> + * @iov: an iov passed to vringh_getdesc_*() (updated as we consume)
> + * @len: the maximum length to advance
> + */
> +void vringh_kiov_advance(struct vringh_kiov *iov, size_t len)
> +{
> +	while (len && iov->i < iov->used) {
> +		size_t partlen = min(iov->iov[iov->i].iov_len, len);
> +
> +		iov->consumed += partlen;
> +		iov->iov[iov->i].iov_len -= partlen;
> +		iov->iov[iov->i].iov_base += partlen;
> +
> +		if (!iov->iov[iov->i].iov_len) {
> +			/* Fix up old iov element then increment. */
> +			iov->iov[iov->i].iov_len = iov->consumed;
> +			iov->iov[iov->i].iov_base -= iov->consumed;
> +
> +			iov->consumed = 0;
> +			iov->i++;
> +		}
> +
> +		len -= partlen;
> +	}
> +}
> +EXPORT_SYMBOL(vringh_kiov_advance);
> +
>   /* Copy some bytes to/from the iovec.  Returns num copied. */
>   static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
>   				      struct vringh_kiov *iov,
> @@ -95,19 +123,8 @@ static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
>   		done += partlen;
>   		len -= partlen;
>   		ptr += partlen;
> -		iov->consumed += partlen;
> -		iov->iov[iov->i].iov_len -= partlen;
> -		iov->iov[iov->i].iov_base += partlen;
>   
> -		if (!iov->iov[iov->i].iov_len) {
> -			/* Fix up old iov element then increment. */
> -			iov->iov[iov->i].iov_len = iov->consumed;
> -			iov->iov[iov->i].iov_base -= iov->consumed;
> -
> -			
> -			iov->consumed = 0;
> -			iov->i++;
> -		}
> +		vringh_kiov_advance(iov, partlen);
>   	}
>   	return done;
>   }

