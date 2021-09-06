Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1512140161C
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 07:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhIFF5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 01:57:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239048AbhIFF5J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 01:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630907765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vovMbtPf5r3ofbG1k9TCSMxb7U8AijKtdOS/02BCPEA=;
        b=c/WB3cGs0VdQSYISTv5WAem0B6nQzF2kI1JZw2qhGii5AmF4PG9P199CHVQyZd24cfDaky
        vx6g2DLPMZccEg8BaEpULyEiOrl5Utx6XS+wmnHi7YOubtX06nxWKZAHpyETd3YRRzIMXk
        Gg8uNKUTlgfZq1ptk+mkYktRn3pI6YA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-E_wGKxHRN4Oe0JTh9P7gfQ-1; Mon, 06 Sep 2021 01:56:03 -0400
X-MC-Unique: E_wGKxHRN4Oe0JTh9P7gfQ-1
Received: by mail-wr1-f71.google.com with SMTP id m16-20020a056000181000b0015964e4ae48so847124wrh.14
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 22:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vovMbtPf5r3ofbG1k9TCSMxb7U8AijKtdOS/02BCPEA=;
        b=Y75bnkmmZQ+nKv4eMzWWg/yPe/qvMSTbVbmObGiMQmCzNajh9Pui+o6ZFaQAnzmdOA
         fjDV+Z0ldCkMQsVJ+eAuiH258D7F1CnzvoUdhVwQfVdIXqB/9QcTdPa9R2daINq/T7Nt
         7WSCM1/UpG4efO8gaQ4QE6x+IcjAeUg6cfqgt0zsiV7GSojrUho8dWNHWS1lujcEospl
         /l7nsnsWsh+cAjnpKuUQygkSEwo0JkBTlbgPtxCl6D+hFXmTtiPeoqwTxL30jqLSNliW
         2bJWoyVLhD24jPcHAtaRQTFR+fvIgT9gzUQxlx9HrO/n6SKVCbgS5xGfC2fAyQJSVXQ0
         e79A==
X-Gm-Message-State: AOAM531h+3zQDjZGxB4ix9rBLMOU1TTu0Tk4GvXKBxKfiVpv366/UlA3
        +yputtZTt4tdsxvr/KKReoMtwVEfHO2rhAZMszTfNKPvT7kck9vQOGgcgkacGFbziiE6T3J6fw8
        d/JWb2HqCUMhX
X-Received: by 2002:a1c:a50c:: with SMTP id o12mr9495400wme.4.1630907762420;
        Sun, 05 Sep 2021 22:56:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSohV4waNTUQh5Sb39O42c9OGim/c0J+8EbtpG04qEdzlJ16UAGsVC7V6aTmAbRvcBXz/LFQ==
X-Received: by 2002:a1c:a50c:: with SMTP id o12mr9495363wme.4.1630907762186;
        Sun, 05 Sep 2021 22:56:02 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id a133sm6174326wme.5.2021.09.05.22.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 22:56:01 -0700 (PDT)
Date:   Mon, 6 Sep 2021 01:55:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 05/13] vdpa: Add reset callback in vdpa_config_ops
Message-ID: <20210906015524-mutt-send-email-mst@kernel.org>
References: <20210831103634.33-1-xieyongji@bytedance.com>
 <20210831103634.33-6-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831103634.33-6-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 31, 2021 at 06:36:26PM +0800, Xie Yongji wrote:
> This adds a new callback to support device specific reset
> behavior. The vdpa bus driver will call the reset function
> instead of setting status to zero during resetting.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


This does gloss over a significant change though:


> ---
> @@ -348,12 +352,12 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
>  	return vdev->dma_dev;
>  }
>  
> -static inline void vdpa_reset(struct vdpa_device *vdev)
> +static inline int vdpa_reset(struct vdpa_device *vdev)
>  {
>  	const struct vdpa_config_ops *ops = vdev->config;
>  
>  	vdev->features_valid = false;
> -	ops->set_status(vdev, 0);
> +	return ops->reset(vdev);
>  }
>  
>  static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)


Unfortunately this breaks virtio_vdpa:


static void virtio_vdpa_reset(struct virtio_device *vdev)
{
        struct vdpa_device *vdpa = vd_get_vdpa(vdev);

        vdpa_reset(vdpa);
}


and there's no easy way to fix this, kernel can't recover
from a reset failure e.g. during driver unbind.

Find a way to disable virtio_vdpa for now?


> -- 
> 2.11.0

