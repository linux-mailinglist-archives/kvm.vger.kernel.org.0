Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D721D6F51
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 05:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgERD1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 23:27:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41464 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726731AbgERD1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 23:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589772466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XWq69cxc6uMliMSLmzS+y2EN4gmCm0BpLb7U6ruoHg0=;
        b=CdDKS8HTH6L6NKbyOBHKBaJ8sHW5bkX2hpddAmkVwp/02k4l1dKMQIRFiHyXjAKtq8Yg82
        kN59+1sez7du8a+HsKJPJWucS1KN/MVxOU/iStEePnWE8Vf+YXuRjBm9Gf67F5sA12P84K
        J751ihtAAj8aSqmrzCQCU8OriqXdRQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-bZgQyu2AMO-a8DtVqHT04g-1; Sun, 17 May 2020 23:27:44 -0400
X-MC-Unique: bZgQyu2AMO-a8DtVqHT04g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D42A8015D2;
        Mon, 18 May 2020 03:27:43 +0000 (UTC)
Received: from [10.72.13.232] (ovpn-13-232.pek2.redhat.com [10.72.13.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE12E10013D9;
        Mon, 18 May 2020 03:27:38 +0000 (UTC)
Subject: Re: [PATCH] vhost: missing __user tags
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     kbuild test robot <lkp@intel.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200515153347.1092235-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f6d7e432-0951-8c3f-829e-78466fd39446@redhat.com>
Date:   Mon, 18 May 2020 11:27:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200515153347.1092235-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/5/15 下午11:33, Michael S. Tsirkin wrote:
> sparse warns about converting void * to void __user *. This is not new
> but only got noticed now that vhost is built on more systems.
> This is just a question of __user tags missing in a couple of places,
> so fix it up.
>
> Fixes: f88949138058 ("vhost: introduce O(1) vq metadata cache")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/vhost.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index d450e16c5c25..21a59b598ed8 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -730,7 +730,7 @@ static inline void __user *vhost_vq_meta_fetch(struct vhost_virtqueue *vq,
>   	if (!map)
>   		return NULL;
>   
> -	return (void *)(uintptr_t)(map->addr + addr - map->start);
> +	return (void __user *)(uintptr_t)(map->addr + addr - map->start);
>   }
>   
>   /* Can we switch to this memory table? */
> @@ -869,7 +869,7 @@ static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
>    * not happen in this case.
>    */
>   static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
> -					    void *addr, unsigned int size,
> +					    void __user *addr, unsigned int size,
>   					    int type)
>   {
>   	void __user *uaddr = vhost_vq_meta_fetch(vq,


Acked-by: Jason Wang <jasowang@redhat.com>


