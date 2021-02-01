Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE40130A224
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhBAGn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:43:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231732AbhBAFsL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 00:48:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612158404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f2ImvkHtiWKuR6rS+/oQGBneQ9ERdYR3AODwgtXhy8s=;
        b=Nokv0k5IBHqJaRC9TfSRKTN5sukTrWu5bRxQNPD8yEHSpY1gp8mm6mINvN8mxxhJ21Q/sH
        rUsEQF98m01qimRlkxQhCx7XQc5s2JdTu6uaHf7QsxgRGqmJlb6xbs9B4gIYPnZuhkFO+n
        mIYSCn2OCeYizjncsM2aumQaVefwLQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-YD89M8YCMyS_gQszRSShvw-1; Mon, 01 Feb 2021 00:46:42 -0500
X-MC-Unique: YD89M8YCMyS_gQszRSShvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 412171005504;
        Mon,  1 Feb 2021 05:46:41 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72FDA5E1A8;
        Mon,  1 Feb 2021 05:46:29 +0000 (UTC)
Subject: Re: [PATCH RFC v2 05/10] vringh: add vringh_kiov_length() helper
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-6-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c4db2e0c-995f-ee03-0dee-3af2bb6e20c9@redhat.com>
Date:   Mon, 1 Feb 2021 13:46:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128144127.113245-6-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/28 下午10:41, Stefano Garzarella wrote:
> This new helper returns the total number of bytes covered by
> a vringh_kiov.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   include/linux/vringh.h | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> index 755211ebd195..84db7b8f912f 100644
> --- a/include/linux/vringh.h
> +++ b/include/linux/vringh.h
> @@ -199,6 +199,17 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
>   	kiov->iov = NULL;
>   }
>   
> +static inline size_t vringh_kiov_length(struct vringh_kiov *kiov)
> +{
> +	size_t len = 0;
> +	int i;
> +
> +	for (i = kiov->i; i < kiov->used; i++)
> +		len += kiov->iov[i].iov_len;
> +
> +	return len;
> +}
> +
>   void vringh_kiov_advance(struct vringh_kiov *kiov, size_t len);
>   
>   int vringh_getdesc_kern(struct vringh *vrh,

