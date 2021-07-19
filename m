Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC03E3CCCAB
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 05:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhGSDdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jul 2021 23:33:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234097AbhGSDdU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 18 Jul 2021 23:33:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626665420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/8AXAqR0AohBpEbwcmGVsNxBi5Kp7RTSu2ilJlIpwRU=;
        b=KwbDYVgiE4QcbZ74wwzoy94+mnY5JGwJ00giQ1JLtZEJl/xtpBckEPenD5SirZ8p7RYu6h
        FrJxbUIZ2SLr8PgIi93b1uNr7lxuy4zPAcH2TtGntKHRucT969gA2miHm3FRba1qFX1LDs
        0GZHDiK9Bx0458HT+MyHwig6ZXP+/v0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-JIxM0PfQO3irriWPuNmS8A-1; Sun, 18 Jul 2021 23:30:19 -0400
X-MC-Unique: JIxM0PfQO3irriWPuNmS8A-1
Received: by mail-pg1-f200.google.com with SMTP id z30-20020a630a5e0000b029022c78a7fc98so13774458pgk.11
        for <kvm@vger.kernel.org>; Sun, 18 Jul 2021 20:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/8AXAqR0AohBpEbwcmGVsNxBi5Kp7RTSu2ilJlIpwRU=;
        b=JtalLo0V/j5TdsP1raEuVgCIT9q2odv/DyhVL0BDBLKbUlWVBV8Va2dziw1t93fgZL
         K4GsBKJRdnMGRQT74wI17Scy3F8N5kNn/QGnt0RRU2n3rd/1T57pNYJqxvxTJEFAJN9O
         zBioB1w4DygYMyZlszEDogIKVC5bCVvj7Qmj9+OeMyTcWh8uFAAS18zn6XgjTcPdrKmZ
         xpPL3eXorVl7UQ9BVOzq7Dye/m06mPMNnl4ewiiW6qh6g0yvPRt0Vh4VTsnOZHdkJuU0
         abm9cvtcen43Ik+8pNZH8BkMogLDmuDppOWVfIkdWFDRHBVRAZdvqdkvBwP7slGe/CmF
         ZYug==
X-Gm-Message-State: AOAM531ddno1Kq0OTiVqeKnaMGFSNLvVVWkRwWV+BqK4fQRZyXXv5GH7
        vZ0wAYcPkVhWmNs554gWx/XEOBiKUFTI23wl/9DgSAiGj1q9VryLjFSPwSIaWk79TJlkjZWBS2W
        JZW9GD1P2dDez
X-Received: by 2002:aa7:8749:0:b029:2f1:3dd0:674 with SMTP id g9-20020aa787490000b02902f13dd00674mr23860560pfo.65.1626665417986;
        Sun, 18 Jul 2021 20:30:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzD4b232b49HdYW9qUVvO5iv20zE2ujVm/gOCoi/jEoPMtqfZc0iUMGhKioUYZZPFxG721zzg==
X-Received: by 2002:aa7:8749:0:b029:2f1:3dd0:674 with SMTP id g9-20020aa787490000b02902f13dd00674mr23860547pfo.65.1626665417809;
        Sun, 18 Jul 2021 20:30:17 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u20sm4356864pjx.31.2021.07.18.20.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 20:30:17 -0700 (PDT)
Subject: Re: [PATCH 1/2] vhost-vdpa: Fix integer overflow in
 vhost_vdpa_process_iotlb_update()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210716102239.96-1-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b6c93e88-0ba2-d07e-2597-e6935ab8de18@redhat.com>
Date:   Mon, 19 Jul 2021 11:30:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716102239.96-1-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/7/16 ÏÂÎç6:22, Xie Yongji Ð´µÀ:
> The "msg->iova + msg->size" addition can have an integer overflow
> if the iotlb message is from a malicious user space application.
> So let's fix it.
>
> Fixes: 1b48dc03e575 ("vhost: vdpa: report iova range")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 210ab35a7ebf..8e3c8790d493 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -615,6 +615,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   	int ret = 0;
>   
>   	if (msg->iova < v->range.first ||
> +	    msg->iova - 1 > U64_MAX - msg->size ||
>   	    msg->iova + msg->size - 1 > v->range.last)
>   		return -EINVAL;
>   

