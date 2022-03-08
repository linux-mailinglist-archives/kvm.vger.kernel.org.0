Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6154D2300
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 22:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350182AbiCHVAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 16:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350151AbiCHVAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 16:00:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8E2736E26
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 12:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646773193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbwcvH5HZImhDyPBWErNz15hyXk9Gsgj39tcg6JTjA0=;
        b=QkoN/Cz6BrpvfTqoThaASSerfLqMACOMMwg2kZH9nUbfbnJ0rVGGRY/j5KYPwIKS/uFquu
        haajJtvLIkU3nn57DT26jRm2ecp175ZJYoRd9ftUmIOpbA9N3iuErQZe/tenNlDJIiqPNi
        /nZOLf7xE9etCRL2fpV1qoWY3p+7VNE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-3M6If5URPpi8B7XTcqy6Pg-1; Tue, 08 Mar 2022 15:59:50 -0500
X-MC-Unique: 3M6If5URPpi8B7XTcqy6Pg-1
Received: by mail-io1-f70.google.com with SMTP id e23-20020a6b6917000000b006406b9433d6so301062ioc.14
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 12:59:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zbwcvH5HZImhDyPBWErNz15hyXk9Gsgj39tcg6JTjA0=;
        b=HNQ+0FimjyLy2zSACsHl4vGDc9FVgIpC9n6vfgQx2JgFq5vO/4z1sJt9WWgwrRxHNY
         z2CRUNFE0gVuZ7q3ovhn9hIcJNRj4mXSy2gqat9lKUt8ZtUH9xewZPpf0/Fwgik5pKF9
         HV6iKWA/2IwAAGbYtBWoXQIsVqijszrZGCwww/DZQP/d2KCNuGSqjWEyQFQ8jvQZRKTq
         Gqm/s0YF8cXYfzL8RCPegvjooRZNxwLI94PalrcDfVjStQS3MPtQ0MWyHLDmEUhgNnlx
         9pu4/HU03kZPxe6D42czuZVdXYmO3QjaDk6ZRf2lQ+pnpjaBCGH8ds0kSMBR8n85MM/9
         cd1Q==
X-Gm-Message-State: AOAM530kXgsL0fzYA3QTLNrw9JDX7mM55Y1TLQOi+nRx/8fvXvedJkS2
        1ea9mlyCx0L+/1qGXQKaLlJTi7WWalkiHWReNYCDBnqJrKUF467Q1c4NYJTiCLdejjyhwgGNNS+
        kH+eLEGRxuy+n
X-Received: by 2002:a05:6638:260f:b0:317:d73e:3038 with SMTP id m15-20020a056638260f00b00317d73e3038mr4670178jat.144.1646773189672;
        Tue, 08 Mar 2022 12:59:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycKZmKIjF7Jh4G6O1qKQ0mnkcvkQWF+syeep6LdYM0QAm69gNxnVFOa/5uk03DWJhNaIXmKA==
X-Received: by 2002:a05:6638:260f:b0:317:d73e:3038 with SMTP id m15-20020a056638260f00b00317d73e3038mr4670166jat.144.1646773189425;
        Tue, 08 Mar 2022 12:59:49 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h16-20020a5e8410000000b006463d5a132asm152784ioj.11.2022.03.08.12.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 12:59:49 -0800 (PST)
Date:   Tue, 8 Mar 2022 13:59:48 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     jianchunfu <jianchunfu@cmss.chinamobile.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:vfio: make the logic cleaner with braket
Message-ID: <20220308135948.15ddd34c.alex.williamson@redhat.com>
In-Reply-To: <20220308094946.139059-1-jianchunfu@cmss.chinamobile.com>
References: <20220308094946.139059-1-jianchunfu@cmss.chinamobile.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Mar 2022 17:49:46 +0800
jianchunfu <jianchunfu@cmss.chinamobile.com> wrote:

> Use braket to avoid identifying operators in function
> vfio_iova_dirty_bitmap() and vfio_dma_do_unmap()
> when there are too many field values.

s/braket/bracket/ but we're actually adding parenthesis.

"to avoid identifying operators", to avoid confusing operators?

s/function/functions/ but this only lists two of the three.

How many are too many field values?  Per this patch, apparently one?
These are not particularly confusing or unruly tests imo.  Thanks,

Alex


> Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 9394aa944..199547012 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1251,7 +1251,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  		return -EINVAL;
>  
>  	dma = vfio_find_dma(iommu, iova + size - 1, 0);
> -	if (dma && dma->iova + dma->size != iova + size)
> +	if (dma && (dma->iova + dma->size) != (iova + size))
>  		return -EINVAL;
>  
>  	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> @@ -1363,7 +1363,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			goto unlock;
>  
>  		dma = vfio_find_dma(iommu, iova + size - 1, 0);
> -		if (dma && dma->iova + dma->size != iova + size)
> +		if (dma && (dma->iova + dma->size) != (iova + size))
>  			goto unlock;
>  	}
>  
> @@ -2958,7 +2958,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  			ret = -EINVAL;
>  			goto out_unlock;
>  		}
> -		if (!range.size || range.size & (iommu_pgsize - 1)) {
> +		if (!range.size || (range.size & (iommu_pgsize - 1))) {
>  			ret = -EINVAL;
>  			goto out_unlock;
>  		}

