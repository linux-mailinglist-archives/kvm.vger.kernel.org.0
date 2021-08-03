Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC5C3DE7F6
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhHCIJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:09:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234357AbhHCIJu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627978179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/r6zvhdFIL6U9mMpelz1ZP/rGx2CiqZiJxW3s2xgLY=;
        b=Kch07tzAiTGiHK/y+HBThbvmijNeCUd1hQrJnzojnFaCmD95/cYHkaJtzfpL05EE0iuiEh
        Nz2PQZu5snhWtRECVi4jpffJBKhmkPacwMXr/18EmTmRLTFvIquROOxTfcgp3zoAJpfqrk
        wPmSP3u0VxYEMOY6CmLWYBNseSe1QUM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-VlH_C06YOTOZuBmI3RbZVA-1; Tue, 03 Aug 2021 04:09:37 -0400
X-MC-Unique: VlH_C06YOTOZuBmI3RbZVA-1
Received: by mail-pl1-f200.google.com with SMTP id z1-20020a1709030181b029012c775d35e1so12797898plg.20
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 01:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=d/r6zvhdFIL6U9mMpelz1ZP/rGx2CiqZiJxW3s2xgLY=;
        b=k4alML3T9F1TAPnGRJqGilL2PrBLtJ3iBHyiUm9CqXuSayecUuau0+RSIC7JgZql3u
         DKnFo+xjGvXooEpwrFoJzJMWPMLQcZMYc7O6w5jbsTUj52iKrF3xN8qbPGaK0/c6/fs3
         S5r65xlr+GKMWZfCVfI2xeIqSsy9PLLjWA7xxdTGU6bvv3uMqHwqCmuTPP/5cWvzJP38
         Ph7j+SdBCBONXG2xIrmzcXiC4uuBcavv+B9v7LQXWHWwlKhkj+aXFSKzpmLfFi8AO4Uu
         zGQDnIqSLiZvzeMYWy9GHuNnDNkVwiLsvJV0SOcHOEvDb6Q/I1K+EXikEfU25OENn4gX
         g3fg==
X-Gm-Message-State: AOAM5301odOdRKkuDEX8MG50ymtC5eHFjpptzGY0imb1QNE1sa0/zShM
        kmV923ax1t2lpNDQsJAYEIJTcY0BCoo91kPMDky4ybId70xvAWSUzLUkh5NAsBSnFg2sHEiw8r6
        mrWwivAXcALsh
X-Received: by 2002:aa7:8e51:0:b029:332:920f:1430 with SMTP id d17-20020aa78e510000b0290332920f1430mr21300577pfr.1.1627978176642;
        Tue, 03 Aug 2021 01:09:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7eB41SimgYU81rcElaZj+nONhqTjmXUgDQCX8JCwgqwPPspHzUgCCQ+CXUVfMnpfJwz3SQw==
X-Received: by 2002:aa7:8e51:0:b029:332:920f:1430 with SMTP id d17-20020aa78e510000b0290332920f1430mr21300550pfr.1.1627978176387;
        Tue, 03 Aug 2021 01:09:36 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j10sm15534492pfd.200.2021.08.03.01.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 01:09:35 -0700 (PDT)
Subject: Re: [PATCH v10 10/17] virtio: Handle device reset failure in
 register_virtio_device()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-11-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6bb6c689-e6dd-cfa2-094b-a0ca4258aded@redhat.com>
Date:   Tue, 3 Aug 2021 16:09:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729073503.187-11-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/7/29 ÏÂÎç3:34, Xie Yongji Ð´µÀ:
> The device reset may fail in virtio-vdpa case now, so add checks to
> its return value and fail the register_virtio_device().


So the reset() would be called by the driver during remove as well, or 
is it sufficient to deal only with the reset during probe?

Thanks


>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/virtio/virtio.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index a15beb6b593b..8df75425fb43 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device *dev)
>   
>   	/* We always start by resetting the device, in case a previous
>   	 * driver messed it up.  This also tests that code path a little. */
> -	dev->config->reset(dev);
> +	err = dev->config->reset(dev);
> +	if (err)
> +		goto err_reset;
>   
>   	/* Acknowledge that we've seen the device. */
>   	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> @@ -362,10 +364,13 @@ int register_virtio_device(struct virtio_device *dev)
>   	 */
>   	err = device_add(&dev->dev);
>   	if (err)
> -		ida_simple_remove(&virtio_index_ida, dev->index);
> -out:
> -	if (err)
> -		virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
> +		goto err_add;
> +
> +	return 0;
> +err_add:
> +	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
> +err_reset:
> +	ida_simple_remove(&virtio_index_ida, dev->index);
>   	return err;
>   }
>   EXPORT_SYMBOL_GPL(register_virtio_device);

