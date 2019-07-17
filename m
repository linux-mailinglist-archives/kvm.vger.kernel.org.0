Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B806BC70
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 14:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfGQMfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 08:35:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQMfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 08:35:43 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 143BA330265;
        Wed, 17 Jul 2019 12:35:43 +0000 (UTC)
Received: from [10.72.12.61] (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 746645D9D6;
        Wed, 17 Jul 2019 12:35:37 +0000 (UTC)
Subject: Re: [PATCH] vhost_net: fix missing descriptor recovery
To:     huhai <huhai@kylinos.cn>, mst@redhat.com
Cc:     kvm@vger.kernel.org
References: <20190717115834.25988-1-huhai@kylinos.cn>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2b582257-d3f3-2793-2256-c6120b6459c0@redhat.com>
Date:   Wed, 17 Jul 2019 20:35:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190717115834.25988-1-huhai@kylinos.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 17 Jul 2019 12:35:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/7/17 下午7:58, huhai wrote:
> When get_tx_bufs get descriptor successful, but this descriptor have
> some problem, we should inform the guest to recycle this descriptor,
> instead of doing nothing.
>
> Signed-off-by: huhai <huhai@kylinos.cn>
> ---
>   drivers/vhost/net.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 247e5585af5d..939a2ef9c223 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -620,6 +620,7 @@ static int get_tx_bufs(struct vhost_net *net,
>   	if (*in) {
>   		vq_err(vq, "Unexpected descriptor format for TX: out %d, int %d\n",
>   			*out, *in);
> +		vhost_add_used_and_signal(&net->dev, vq, ret, 0);
>   		return -EFAULT;
>   	}
>   
> @@ -628,6 +629,7 @@ static int get_tx_bufs(struct vhost_net *net,
>   	if (*len == 0) {
>   		vq_err(vq, "Unexpected header len for TX: %zd expected %zd\n",
>   			*len, nvq->vhost_hlen);
> +		vhost_add_used_and_signal(&net->dev, vq, ret, 0);
>   		return -EFAULT;
>   	}
>   


This is usually a hint of driver bug. I believe it's better to fail 
explicitly here instead of trying to workaround it.

Thanks

