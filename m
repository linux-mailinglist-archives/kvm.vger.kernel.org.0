Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CB35679FE
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 00:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiGEWL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 18:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiGEWLz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 18:11:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA2CB1AF23
        for <kvm@vger.kernel.org>; Tue,  5 Jul 2022 15:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657059114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jYyfEpMl2flPhUf3Li8rQ5r7GnlV0FLMH9rI8PrXUHQ=;
        b=RL3HlWOx6AbB0jFURWtHjpekobKqXUGzFTkG++MjIjRuCn81mXTRRIvQYNhqJKqYKQhNvs
        KeeGUooigiGGCFTki7kpAfgqfxfyHnN9PVIkVyi6swlG0FgX5tUiASGbfZVkI6Ivi3vPcB
        p7u0VsJMY1XHP8BETweQqZWyCNriQeA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-y7R0GMGkP3OwVxjLdfy4HQ-1; Tue, 05 Jul 2022 18:11:51 -0400
X-MC-Unique: y7R0GMGkP3OwVxjLdfy4HQ-1
Received: by mail-io1-f70.google.com with SMTP id o11-20020a6bcf0b000000b0067328c4275bso7236196ioa.8
        for <kvm@vger.kernel.org>; Tue, 05 Jul 2022 15:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jYyfEpMl2flPhUf3Li8rQ5r7GnlV0FLMH9rI8PrXUHQ=;
        b=q+MKUPl22n6y6Ftv8LfQO7wuRxcCTaH6wxezUFB5xodG2ycUwaH8L+t5NCvEulsZkb
         ZzNRRVr1xM+PIBwFHKzbA4ZDYZJqNBN6zTYJpf96v7yONYFY0hvoNvFJQVFnkgYgHPnA
         Q79pdJiwLvhEM1rSvWSPgaEcGFY9t6QzkwOisvsUxNEoANqWo3BHqDNJBKPMe6i6eFT7
         2pSvDic+pQB06jrinyliVq71qdHB8PfiAgIg9We0u9fMMFd6cplhBakJCILWOTcsy1cm
         ncmJeHMYBhWst1JiPdGbnIlC6/EzYVR3UDiutFQ2oOfT5Mqqx6jpcizUeMpLpmld9zMy
         rhWw==
X-Gm-Message-State: AJIora9uZ3YwFp75jlyto7xoFnNskYbnErRmqHdUiOQdVrdRFfrm1EcY
        oE+QOzk5EamXx8h2fR5WlNpMZfJotL/++VN18AP0ULR2pbkPX8fvL6dcINqwd2HDXy8NvolAF8E
        GnVyxfb/C3Jtp
X-Received: by 2002:a05:6e02:1bc4:b0:2da:7a81:1c9a with SMTP id x4-20020a056e021bc400b002da7a811c9amr20475554ilv.213.1657059110542;
        Tue, 05 Jul 2022 15:11:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uCNmkG9O9eUN3J+OH6cibOk89Z+NOpAvCWEqz0KWSYa+qNOANpSc60UJF1c83o9dG7F2GSTg==
X-Received: by 2002:a05:6e02:1bc4:b0:2da:7a81:1c9a with SMTP id x4-20020a056e021bc400b002da7a811c9amr20475543ilv.213.1657059110318;
        Tue, 05 Jul 2022 15:11:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q18-20020a02cf12000000b0033c829dd5b8sm13190527jar.161.2022.07.05.15.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 15:11:49 -0700 (PDT)
Date:   Tue, 5 Jul 2022 16:11:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [PATCH rc] vfio: Move IOMMU_CAP_CACHE_COHERENCY test to after
 we know we have a group
Message-ID: <20220705161149.5cfc5f34.alex.williamson@redhat.com>
In-Reply-To: <0-v1-e8934b490f36+f4-vfio_cap_fix_jgg@nvidia.com>
References: <0-v1-e8934b490f36+f4-vfio_cap_fix_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  4 Jul 2022 22:10:50 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The test isn't going to work if a group doesn't exist. Normally this isn't
> a problem since VFIO isn't going to create a device if there is no group,
> but the special CONFIG_VFIO_NOIOMMU behavior allows bypassing this
> prevention. The new cap test effectively forces a group and breaks this
> config option.
> 
> Move the cap test to vfio_group_find_or_alloc() which is the earliest time
> we know we have a group available and thus are not running in noiommu mode.
> 
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
> Reported-by "chenxiang (M)" <chenxiang66@hisilicon.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)

Fixed-up Reported-by, added Tested-by, and pushed to vfio for-linus
branch for v5.19.  Thanks,

Alex

> 
> This should fixe the issue with dpdk on noiommu, but I've left PPC out.
> 
> I think the right way to fix PPC is to provide the iommu_ops for the devices
> groups it is creating. They don't have to be fully functional - eg they don't
> have to to create domains, but if the ops exist they can correctly respond to
> iommu_capable() and we don't need special code here to work around PPC being
> weird.
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index e43b9496464bbf..cbb693359502d9 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -552,6 +552,16 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  	if (!iommu_group)
>  		return ERR_PTR(-EINVAL);
>  
> +	/*
> +	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> +	 * restore cache coherency. It has to be checked here because it is only
> +	 * valid for cases where we are using iommu groups.
> +	 */
> +	if (!iommu_capable(dev->bus, IOMMU_CAP_CACHE_COHERENCY)) {
> +		iommu_group_put(iommu_group);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	group = vfio_group_get_from_iommu(iommu_group);
>  	if (!group)
>  		group = vfio_create_group(iommu_group, VFIO_IOMMU);
> @@ -604,13 +614,6 @@ static int __vfio_register_dev(struct vfio_device *device,
>  
>  int vfio_register_group_dev(struct vfio_device *device)
>  {
> -	/*
> -	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> -	 * restore cache coherency.
> -	 */
> -	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> -		return -EINVAL;
> -
>  	return __vfio_register_dev(device,
>  		vfio_group_find_or_alloc(device->dev));
>  }
> 
> base-commit: e2475f7b57209e3c67bf856e1ce07d60d410fb40

