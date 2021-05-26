Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA5D390E56
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 04:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhEZCh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 22:37:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhEZChz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 22:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621996584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IJC3K6l6gJPi4CUzLhheMs0LRbWxiui4b9xku04/3mg=;
        b=FLTML3az9GlmnIZWqYMuqNDvbo0kAbcKdtWA/qQOtP61hXvjCRvJbYxmobEYwQDKmY6umM
        CMe6gi/fjyBY5zthf+zP1YJl0HGmBeB1IAY7/x9edoBsTt7D8QmHGLw7N91wm00e1nbpex
        dp1rdxIvq45sG53RU8N+vKjVcPTav40=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-anuXedlOPSK2Hy0iMnYtxQ-1; Tue, 25 May 2021 22:36:22 -0400
X-MC-Unique: anuXedlOPSK2Hy0iMnYtxQ-1
Received: by mail-pl1-f198.google.com with SMTP id 2-20020a1709020202b02900eecb50c2deso15731113plc.0
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 19:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IJC3K6l6gJPi4CUzLhheMs0LRbWxiui4b9xku04/3mg=;
        b=TUXha6P0oukNWKs7I5Fb4LflIgijS0Jd1lUVQxTPaUzWtEDPr8CH9i9ktq55GgQKsI
         reFE2+XoRgseXklzcNOemVzcNvz9lp5I4N9CN7ZTwVv6ubN+UPkV0joZbZhp04Jpawbr
         6M2WH+5nqkCiq5fIykbJr23csK29qkPwv1qINcYpJ33LzrGBviCgN26NFQoEfRE7Hvrg
         iwu2bhdYXCfpgWQvmUFctVNLecSnOriw2KAJnMGALdPxfYB5Y39uIJc+tQIJAReNTOF6
         sOKOyl9S3mtI18H4VBnG7JGhMdOHRcmdY5EFB4EiW4xxi3dbezuMjyUBdSSvJm/Dgrsc
         s6bg==
X-Gm-Message-State: AOAM533JKmhiuKdOmtM9EulZgILfP7+oZxTlGkEYAvmSplaxXrmC8dwU
        5Wrfgo1mrAZsrj1L+eEpjCIjS0KnafAx3p66Ao2Z5MGEMmoObK1Vkf+a+5JowqkUHz2kLVlKIjq
        r3zQbkBfo5+nI
X-Received: by 2002:a17:902:f281:b029:f0:bdf2:2fe5 with SMTP id k1-20020a170902f281b02900f0bdf22fe5mr32724326plc.68.1621996581541;
        Tue, 25 May 2021 19:36:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylcchXGFUiLMl0CERc9pjyfUvd7s5BV6gdMSkLdsrvpEyh07CtgmlI9vttP0fXdJsLVzRn5Q==
X-Received: by 2002:a17:902:f281:b029:f0:bdf2:2fe5 with SMTP id k1-20020a170902f281b02900f0bdf22fe5mr32724300plc.68.1621996581246;
        Tue, 25 May 2021 19:36:21 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b12sm2984392pjd.22.2021.05.25.19.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 19:36:20 -0700 (PDT)
Subject: Re: [PATCH v7 01/12] iova: Export alloc_iova_fast()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-2-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6ca337fe-2c8c-95c9-672e-0d4f104f66eb@redhat.com>
Date:   Wed, 26 May 2021 10:36:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210517095513.850-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/17 ÏÂÎç5:55, Xie Yongji Ð´µÀ:
> Export alloc_iova_fast() so that some modules can use it
> to improve iova allocation efficiency.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/iommu/iova.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index e6e2fa85271c..317eef64ffef 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -450,6 +450,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
>   
>   	return new_iova->pfn_lo;
>   }
> +EXPORT_SYMBOL_GPL(alloc_iova_fast);
>   
>   /**
>    * free_iova_fast - free iova pfn range into rcache


Interesting, do we need export free_iova_fast() as well?

Thanks


