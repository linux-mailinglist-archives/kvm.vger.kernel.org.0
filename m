Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D2B62E600
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbiKQUfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbiKQUfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:35:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC966BDE4
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668717261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cH+tR/l4MtjSzktKik+h9drJE/wrrm6KxuS/+dP54OY=;
        b=KmBhNxqzMD4u1/NOxwPPxMTV4nU5U0VvYNgqkdN6U8FXJ6k2oekF3sP98sBvjWZ509NCiN
        iw3kdZSRYiiXANPPqo7gS1gUvMZKbCuNWVfdOzliQbw/g5tFrOb89bsfQewoeYVSy7GfLi
        qtzKLWr5az2mAS7ImYDqy8h8HRKdEQA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-FaFBJ_yrMPqYSkLWlips8A-1; Thu, 17 Nov 2022 15:34:19 -0500
X-MC-Unique: FaFBJ_yrMPqYSkLWlips8A-1
Received: by mail-il1-f198.google.com with SMTP id o10-20020a056e02102a00b003006328df7bso1970641ilj.17
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:34:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cH+tR/l4MtjSzktKik+h9drJE/wrrm6KxuS/+dP54OY=;
        b=syA7YZVqlAbSg6YDdHgWGGrPidfGxlhXwTpr2ThWXrbAmn0EGGiWHHS7nu2113JjiH
         LVWCjlT5MokFTJ0fcO3j4GJ3Qd3XWy9el5P38JC1hOCUCid8N6HJmOL7lQDnZwnC3Xer
         85kDEy/cmLMceBKewEFz74wG8zmgcR75wJHb0GIHoUlnpPtWKA3lxNuzBYnZez1pYVsa
         4lhPrZP4pCxdBr039LmVWg66SWITnlnVfcgQxMF0wl6Wa3HgJws1AZ64xRRRhJItndfy
         5zmLRvNyU+QAkEVk3JLArtJrDogN9x/PsL0u0oczjLJV9Wo0V5pyGjvedfIXcpo/JCH8
         rW+Q==
X-Gm-Message-State: ANoB5pnu9KwW0rr+KjhUTZ2eLG0emWmV6dd2G5GWqk9Qi58I4354DOQI
        06/IPFQHkId02191gPzT9XPs6iLSgvJKB12VABIG7JT/G+rT6sYuaWFK18X1Hr3SL7LUjVVZvUW
        QGUSMmhiztpeV
X-Received: by 2002:a02:8564:0:b0:375:9838:239f with SMTP id g91-20020a028564000000b003759838239fmr1834966jai.179.1668717259161;
        Thu, 17 Nov 2022 12:34:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Gj+BKbD1z1Klidd+VZfds9vh8EuvZErWZiTw30+0S0wcgkkYsrrLh5nVAkxGU6FbJpjOsRA==
X-Received: by 2002:a02:8564:0:b0:375:9838:239f with SMTP id g91-20020a028564000000b003759838239fmr1834957jai.179.1668717258956;
        Thu, 17 Nov 2022 12:34:18 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e98-20020a02866b000000b00346a98b0a76sm547512jai.77.2022.11.17.12.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:34:18 -0800 (PST)
Date:   Thu, 17 Nov 2022 13:34:17 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 11/11] iommufd: Allow iommufd to supply
 /dev/vfio/vfio
Message-ID: <20221117133417.2636e23a.alex.williamson@redhat.com>
In-Reply-To: <11-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
        <11-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Nov 2022 17:05:36 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> If the VFIO container is compiled out, give a kconfig option for iommufd
> to provide the miscdev node with the same name and permissions as vfio
> uses.
> 
> The compatibility node supports the same ioctls as VFIO and automatically
> enables the VFIO compatible pinned page accounting mode.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yu He <yu.he@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/Kconfig | 12 ++++++++++++
>  drivers/iommu/iommufd/main.c  | 36 +++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> index 399a2edeaef6de..f387f803dc6f7f 100644
> --- a/drivers/iommu/iommufd/Kconfig
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -12,6 +12,18 @@ config IOMMUFD
>  	  If you don't know what to do here, say N.
>  
>  if IOMMUFD
> +config IOMMUFD_VFIO_CONTAINER
> +	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> +	depends on VFIO && !VFIO_CONTAINER
> +	default VFIO && !VFIO_CONTAINER
> +	help
> +	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
> +	  IOMMUFD providing compatibility emulation to give the same ioctls.
> +	  It provides an option to build a kernel with legacy VFIO components
> +	  removed.
> +
> +	  Unless testing IOMMUFD say N here.
> +

"Unless testing..." alone is a bit more subtle that I thought we were
discussing.  I was expecting something more like:

  IOMMUFD VFIO container emulation is known to lack certain features of
  the native VFIO container, such as no-IOMMU support, peer-to-peer DMA
  mapping, PPC IOMMU support, as well as other potentially undiscovered
  gaps.  This option is currently intended for the purpose of testing
  IOMMUFD with unmodified userspace supporting VFIO and making use of
  the Type1 VFIO IOMMU backend.  General purpose enabling of this
  option is currently discouraged.

  Unless testing IOMMUFD, say N here.

Thanks,
Alex

