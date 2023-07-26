Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34D3763DBD
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjGZRei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 13:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjGZReg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 13:34:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC662689
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 10:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690392833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=595aIFAqz7KLDifNzOOpVRZNEJ01+8bEI4rnP/3L4To=;
        b=EU90qie4Le5etddl8YKKIWKXHgzm41z8Z6eXELYjyMBArLmqSSfzLHflWXoGXMf35fZKZN
        mD82zkAp3D/HziR3954TJwsErPkplaoq2tbalvFEWdyMdCU0z1ds/nGbHIHX8jR6QpoNrn
        TO6ey8OVVycEb8LZvIjkoExlo3G3teo=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-hgAJSfyZOIyRfhcn-5DjRw-1; Wed, 26 Jul 2023 13:33:51 -0400
X-MC-Unique: hgAJSfyZOIyRfhcn-5DjRw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7867b689079so1378439f.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 10:33:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690392831; x=1690997631;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=595aIFAqz7KLDifNzOOpVRZNEJ01+8bEI4rnP/3L4To=;
        b=UZv/tjpNQQQuPNuDa46a4cpNOMnKBc7kwl5o9kuPRvKwUz/JfJjj1J27XZ+kdcqde0
         H0hztu1K3VGXOmAe3ZtK0lkFbB4WOtdxhhS2cT46aUOWT5Af5BE9KUjYHkKzdcCgDwci
         hZiGBTIMqx8CjrSLsJ646C8SIQ8uiVyiCAOe00rvOXxdW/xgX9a8ostt0R7mPeVPEOAa
         7HPAY2Oe2CJlZKZEM2B7ndGP5lCsKDUH/wdD8bvVYVnV5VyLt/WOLY7jL+3SIxR/3Igm
         ogoax363kT3Lfwkm44cRZ3p3Y0INz4ORAWyVg9nwPPsBtEoje8gbj7oNRrjs2zh+fiGQ
         rgHQ==
X-Gm-Message-State: ABy/qLZ55GG6D59OUbz5Tg/+1ACjq2Vu4YQBuZ3hcdscKQIgcYB3H3Wm
        k9f4/FlUexW9npifeaj/QUDdOX+kVGbKLeOVZNiHfvHaEqO01fXhMSxA7P5FvzWVzdleWCx0FOZ
        FxcNYo9z4EFuH
X-Received: by 2002:a5e:8713:0:b0:786:98bd:66d4 with SMTP id y19-20020a5e8713000000b0078698bd66d4mr2821722ioj.15.1690392831042;
        Wed, 26 Jul 2023 10:33:51 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFSNSK8ezzU7UY6kqRAWp8eJAgdkkstqtMf1gdt1dZfcxLAkXL1XnER7kAc9CqUzcaWir7uvw==
X-Received: by 2002:a5e:8713:0:b0:786:98bd:66d4 with SMTP id y19-20020a5e8713000000b0078698bd66d4mr2821704ioj.15.1690392830818;
        Wed, 26 Jul 2023 10:33:50 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f23-20020a6be817000000b0078b9d1653a8sm3815595ioh.42.2023.07.26.10.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 10:33:50 -0700 (PDT)
Date:   Wed, 26 Jul 2023 11:33:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     <jgg@nvidia.com>, <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
        <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <shuah@kernel.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <farman@linux.ibm.com>
Subject: Re: [PATCH v8 1/4] vfio: Do not allow !ops->dma_unmap in
 vfio_pin/unpin_pages()
Message-ID: <20230726113349.3dc1382c.alex.williamson@redhat.com>
In-Reply-To: <064227abb779063c328fd79afc7c74dabdf2489e.1690226015.git.nicolinc@nvidia.com>
References: <cover.1690226015.git.nicolinc@nvidia.com>
        <064227abb779063c328fd79afc7c74dabdf2489e.1690226015.git.nicolinc@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jul 2023 12:47:04 -0700
Nicolin Chen <nicolinc@nvidia.com> wrote:

> A driver that doesn't implement ops->dma_unmap shouldn't be allowed to do
> vfio_pin/unpin_pages(), though it can use vfio_dma_rw() to access an iova
> range. Deny !ops->dma_unmap cases in vfio_pin/unpin_pages().
> 
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 4 ++++
>  1 file changed, 4 insertions(+)

I assume these go through iommufd.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 902f06e52c48..0da8ed81a97d 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1483,6 +1483,8 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
>  	/* group->container cannot change while a vfio device is open */
>  	if (!pages || !npage || WARN_ON(!vfio_assert_device_open(device)))
>  		return -EINVAL;
> +	if (!device->ops->dma_unmap)
> +		return -EINVAL;
>  	if (vfio_device_has_container(device))
>  		return vfio_device_container_pin_pages(device, iova,
>  						       npage, prot, pages);
> @@ -1520,6 +1522,8 @@ void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
>  {
>  	if (WARN_ON(!vfio_assert_device_open(device)))
>  		return;
> +	if (WARN_ON(!device->ops->dma_unmap))
> +		return;
>  
>  	if (vfio_device_has_container(device)) {
>  		vfio_device_container_unpin_pages(device, iova, npage);

