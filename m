Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981757D1456
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 18:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377862AbjJTQpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 12:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjJTQpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 12:45:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A59A18F
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697820252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EGRtOMrcguwZFtQK68EQnYTqBttYt8T41Jv7u8kxHIs=;
        b=IrlavBaKDHrFR3LlQgyuhf6diuqbSmYp9M3tH8NF8HGeBTtqF7GAvtXTm7Oi5WnDI7Cbkk
        h7Nk1Qw4AY1HDWxSgsjP7sUTppH/Fd90aobJbgiuraC3D+OXJm23uIgAnm5zLNmWvJiboL
        EO6vZyvJt0xt+hhwqnmEXnD7LKhs4dg=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-Tofo0-abNHCXOYww5KRvGQ-1; Fri, 20 Oct 2023 12:44:11 -0400
X-MC-Unique: Tofo0-abNHCXOYww5KRvGQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7872be95468so97786839f.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 09:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697820250; x=1698425050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EGRtOMrcguwZFtQK68EQnYTqBttYt8T41Jv7u8kxHIs=;
        b=K620NTrZYaGntbX53AerxOvI2RVammS5GTPBI+hd/1xuqNCwMzICszDc7sDsT03hkT
         rSTpAh/kGYHKFYxJDimLb2iTHvKTcX30bUHBsjfz2Zh0SMwWp6KDhoh9aKpZYzM6ASGz
         082kk03lZxCruIpKGDml98z5CBGcLnwiIGh4X9Ilz3CmO7/V+J+nUxHcIE7oZIMElzQu
         Sfe0rvjdPWQj0rj3mAhA8oZOKTeKeMtITVdg0zsXgv66Xx/pI8uYVke//096hcuwPwPJ
         4Krf+kGzIINr6UW4rU2ySqtlh2TYc4HhPEwZzH1PrCG5UB5JF/nyK7ogxGKf/KB3EDfx
         Ysng==
X-Gm-Message-State: AOJu0YzrWamxxukM/4FKh3oimxE0t6Gyc72uZYu70Ajkm/chDh/YOKqu
        c2c20IsymWkndfjuTG99N7adZvbVFVt7B6NPQpb5xQtGNcBrtpu93WBfQxNe4NWaodIbTF2RI4V
        JWovGqhFxaQhi
X-Received: by 2002:a05:6602:3405:b0:79a:b667:4e97 with SMTP id n5-20020a056602340500b0079ab6674e97mr2975136ioz.0.1697820250395;
        Fri, 20 Oct 2023 09:44:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7EVepwv2ae2b+EulXgXwHsovEWceHeRYNuKVZfp5FhVoMxmR9dt/gddHEwoMeQaabxNY4XQ==
X-Received: by 2002:a05:6602:3405:b0:79a:b667:4e97 with SMTP id n5-20020a056602340500b0079ab6674e97mr2975115ioz.0.1697820250118;
        Fri, 20 Oct 2023 09:44:10 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id cg4-20020a056602254400b007a66df53f71sm654798iob.38.2023.10.20.09.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 09:44:09 -0700 (PDT)
Date:   Fri, 20 Oct 2023 10:44:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 01/18] vfio/iova_bitmap: Export more API symbols
Message-ID: <20231020104408.48d4e09f.alex.williamson@redhat.com>
In-Reply-To: <20231018202715.69734-2-joao.m.martins@oracle.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
        <20231018202715.69734-2-joao.m.martins@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Oct 2023 21:26:58 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:

> In preparation to move iova_bitmap into iommufd, export the rest of API
> symbols that will be used in what could be used by modules, namely:
> 
> 	iova_bitmap_alloc
> 	iova_bitmap_free
> 	iova_bitmap_for_each
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/vfio/iova_bitmap.c | 3 +++
>  1 file changed, 3 insertions(+)


Reviewed-by: Alex Williamson <alex.williamson@redhat.com>


> 
> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
> index 0848f920efb7..f54b56388e00 100644
> --- a/drivers/vfio/iova_bitmap.c
> +++ b/drivers/vfio/iova_bitmap.c
> @@ -268,6 +268,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
>  	iova_bitmap_free(bitmap);
>  	return ERR_PTR(rc);
>  }
> +EXPORT_SYMBOL_GPL(iova_bitmap_alloc);
>  
>  /**
>   * iova_bitmap_free() - Frees an IOVA bitmap object
> @@ -289,6 +290,7 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
>  
>  	kfree(bitmap);
>  }
> +EXPORT_SYMBOL_GPL(iova_bitmap_free);
>  
>  /*
>   * Returns the remaining bitmap indexes from mapped_total_index to process for
> @@ -387,6 +389,7 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(iova_bitmap_for_each);
>  
>  /**
>   * iova_bitmap_set() - Records an IOVA range in bitmap

