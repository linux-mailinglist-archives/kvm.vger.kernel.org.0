Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AB830A1EF
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhBAGaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:30:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231886AbhBAGGR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 01:06:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612159491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3DbrYa9lTM0WfBiv6DqSHzncCEvSptL8lHmERyjThJ8=;
        b=D5K7nRAkIOhW2kUF2Hk9lTl1UIpy93yDn3tovYs/aJ5gP1MJLVfnv1+8hhfpigNpXG2x24
        rJwKOeFCOJ+TglRFUTQhpHPN+YrSHo1i9Jcm1iC64cusHBAecz/+lDu8Ha2xn0u7NK9lJL
        TN9oyrWVttsqL0+n33UZqtSOdIQ+t9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-ZEaupziEMA-dvif1_vOjXQ-1; Mon, 01 Feb 2021 01:04:49 -0500
X-MC-Unique: ZEaupziEMA-dvif1_vOjXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59529107ACE3;
        Mon,  1 Feb 2021 06:04:48 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C07660C5F;
        Mon,  1 Feb 2021 06:04:39 +0000 (UTC)
Subject: Re: [PATCH RFC v2 10/10] vdpa_sim_blk: handle VIRTIO_BLK_T_GET_ID
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-11-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bcdc7dd7-856e-8aae-0683-e811081a1521@redhat.com>
Date:   Mon, 1 Feb 2021 14:04:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128144127.113245-11-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/28 下午10:41, Stefano Garzarella wrote:
> Handle VIRTIO_BLK_T_GET_ID request, always answering the
> "vdpa_blk_sim" string.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
> - made 'vdpasim_blk_id' static [Jason]


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> index fc47e8320358..a3f8afad8d14 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -37,6 +37,7 @@
>   #define VDPASIM_BLK_VQ_NUM	1
>   
>   static struct vdpasim *vdpasim_blk_dev;
> +static char vdpasim_blk_id[VIRTIO_BLK_ID_BYTES] = "vdpa_blk_sim";
>   
>   static bool vdpasim_blk_check_range(u64 start_sector, size_t range_size)
>   {
> @@ -152,6 +153,20 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
>   		}
>   		break;
>   
> +	case VIRTIO_BLK_T_GET_ID:
> +		bytes = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
> +					      vdpasim_blk_id,
> +					      VIRTIO_BLK_ID_BYTES);
> +		if (bytes < 0) {
> +			dev_err(&vdpasim->vdpa.dev,
> +				"vringh_iov_push_iotlb() error: %zd\n", bytes);
> +			status = VIRTIO_BLK_S_IOERR;
> +			break;
> +		}
> +
> +		pushed += bytes;
> +		break;
> +
>   	default:
>   		dev_warn(&vdpasim->vdpa.dev,
>   			 "Unsupported request type %d\n", type);

