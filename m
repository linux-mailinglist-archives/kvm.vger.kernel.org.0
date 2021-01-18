Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0122F97FF
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 03:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbhARC51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 21:57:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730243AbhARC5T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 17 Jan 2021 21:57:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610938553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btsrrxo7mB11BqinBri0huz58VO1P3XSJaWNyk0vkAw=;
        b=OXcWLaZ920pdEqyexZBESrnER/SbNIXOdvtbO7soU0Uq1NeRSzS3HG262j1E44Ukl1QXmp
        BjIvEPXTQvhxBlTTUcJSip+SxtpQxsgVJeSq4NRheB4KO19isDzeXJjP73tMS59ddDcNbE
        /zN2OcQuyxVVjJCiuP4wp7w92pKVAMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-40R2I4VhMpuBVHJQ-frJ2w-1; Sun, 17 Jan 2021 21:55:51 -0500
X-MC-Unique: 40R2I4VhMpuBVHJQ-frJ2w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0898987950D;
        Mon, 18 Jan 2021 02:55:50 +0000 (UTC)
Received: from [10.72.13.12] (ovpn-13-12.pek2.redhat.com [10.72.13.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D115100239A;
        Mon, 18 Jan 2021 02:55:45 +0000 (UTC)
Subject: Re: [PATCH] use pr_warn_ratelimited() for vq_err()
To:     John Levon <john.levon@nutanix.com>, levon@movementarian.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        mst@redhat.com
References: <20210115173741.2628737-1-john.levon@nutanix.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fe831303-ebcd-9794-fc46-8ffc1701431e@redhat.com>
Date:   Mon, 18 Jan 2021 10:55:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210115173741.2628737-1-john.levon@nutanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/16 上午1:37, John Levon wrote:
> vq_err() is used to report various failure states in vhost code, but by
> default uses pr_debug(), and as a result doesn't record anything unless
> enabled via dynamic debug. We'll change this so we get something recorded
> in the log in these failure cases. Guest VMs (and userspace) can trigger
> some of these messages, so we want to use the pr_warn_ratelimited()
> variant.


It looks to me KVM also use pr_warn_ratelimited().

So

Acked-by: Jason Wang <jasowang@redhat.com>



>
> Signed-off-by: John Levon <john.levon@nutanix.com>
> ---
>   drivers/vhost/vhost.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index b063324c7669..cb4ef78c84ba 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -228,10 +228,10 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
>   void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
>   			  struct vhost_iotlb_map *map);
>   
> -#define vq_err(vq, fmt, ...) do {                                  \
> -		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
> -		if ((vq)->error_ctx)                               \
> -				eventfd_signal((vq)->error_ctx, 1);\
> +#define vq_err(vq, fmt, ...) do {                                \
> +		pr_warn_ratelimited(pr_fmt(fmt), ##__VA_ARGS__); \
> +		if ((vq)->error_ctx)                             \
> +			eventfd_signal((vq)->error_ctx, 1);      \
>   	} while (0)
>   
>   enum {

