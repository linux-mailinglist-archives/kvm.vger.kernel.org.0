Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833C53F68D1
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 20:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhHXSJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:09:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhHXSJ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 14:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629828521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wf/taVlZFNs0ougRCLlTYVmNw738QSiSdoCHx8OR6ig=;
        b=OaBhncK3OkMt0iQW1wbKSWlrzuyIK4RzdLEEyCOnADDe3fZMcr0Znmr9gTeNX+qdzHGCUD
        isQ96y/EyQfvQgIIc+2/XmjMkJbJWtKDq2aOr9nuZzoqSKk49+kZzeBnujzedBG7NszFI5
        g8HQ9CwLSe2ibjWvIjh7UEILuTWngCM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-gpQQTyukOY6T2iMz7GAj_Q-1; Tue, 24 Aug 2021 14:08:39 -0400
X-MC-Unique: gpQQTyukOY6T2iMz7GAj_Q-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so4366071wmj.8
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 11:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wf/taVlZFNs0ougRCLlTYVmNw738QSiSdoCHx8OR6ig=;
        b=NATyfKOVNH7kE0cRXFrkRgQEj9ZlN0tEfVIPb6+L7LkCBTNs2DlpNo3h0BEDWruBQz
         cXvn2ovyNe0nu4SLhctrgSOdwrgZZTTvwxy9OlCnGTkOcEu70AjiQKEhOKVQbCZhu+cc
         tNUmlUkc1dK/tXzbgy/lK6C9C4Js+Ka8Ia0VrxrFXDClCzBfxgIujJYMPz8U+WTEkgdQ
         g2msJ1FN72k6v/36cZ6MwbNJB3vRzRtj+lN5/YfPhR3cYZ0b8DtD3A5Nn75zjROFLYY5
         5fvyeAkM1UVbCitmwKBL1ZdVyGQNpc4HqCSfkSnBzEJMSO5+KOBaMz+2fCz4r0b1ZM93
         IBEA==
X-Gm-Message-State: AOAM533gl5SScOdZ7mLk9qEG3IfFPcQDQ5MP4G12Yp7Nbszrjl5Pc81O
        AEqR1nXDHXXNPxyaMzE35JP0GpN5Fd/HI7bwaXqPk7cErMVoU4zfeIl1Gy1gTWORqr7eqIqpCyJ
        gIOpwNvWlda6P
X-Received: by 2002:adf:f541:: with SMTP id j1mr20290138wrp.180.1629828518662;
        Tue, 24 Aug 2021 11:08:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfDkwHQb1CTI5AdZfg7DL+P9GYpcylznvSa7+7v+ifINTac25O0lU3KK9ol/wm7Mi5FZusQw==
X-Received: by 2002:adf:f541:: with SMTP id j1mr20290112wrp.180.1629828518469;
        Tue, 24 Aug 2021 11:08:38 -0700 (PDT)
Received: from redhat.com ([212.116.168.114])
        by smtp.gmail.com with ESMTPSA id l187sm327519wml.39.2021.08.24.11.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 11:08:37 -0700 (PDT)
Date:   Tue, 24 Aug 2021 14:08:33 -0400
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
        songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v11 01/12] iova: Export alloc_iova_fast() and
 free_iova_fast()
Message-ID: <20210824140758-mutt-send-email-mst@kernel.org>
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-2-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818120642.165-2-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 08:06:31PM +0800, Xie Yongji wrote:
> Export alloc_iova_fast() and free_iova_fast() so that
> some modules can make use of the per-CPU cache to get
> rid of rbtree spinlock in alloc_iova() and free_iova()
> during IOVA allocation.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


This needs ack from iommu maintainers. Guys?

> ---
>  drivers/iommu/iova.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index b6cf5f16123b..3941ed6bb99b 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -521,6 +521,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>  
>  	return new_iova->pfn_lo;
>  }
> +EXPORT_SYMBOL_GPL(alloc_iova_fast);
>  
>  /**
>   * free_iova_fast - free iova pfn range into rcache
> @@ -538,6 +539,7 @@ free_iova_fast(struct iova_domain *iovad, unsigned long pfn, unsigned long size)
>  
>  	free_iova(iovad, pfn);
>  }
> +EXPORT_SYMBOL_GPL(free_iova_fast);
>  
>  #define fq_ring_for_each(i, fq) \
>  	for ((i) = (fq)->head; (i) != (fq)->tail; (i) = ((i) + 1) % IOVA_FQ_SIZE)
> -- 
> 2.11.0

