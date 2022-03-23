Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6804D4E58F2
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 20:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbiCWTMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 15:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiCWTMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 15:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7087E606C9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648062644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hMSz6R8MljxH5tNM923iQc7Lkarfhq9MPHr06b3TmaI=;
        b=UIgzG7lk1qtjm84hfE7EoMgs6eelfBcA3N2vS8YWjvqHun95RRmd5Wg5RkxDMY7CcjKa/m
        nY+kEMvjuUYMk0Ese/fm4tPpSWhbkwfRFVMO+E3jXY3Cy362dL1aZAX3hdECV8vCcT0uPL
        iarNc9E4hRD1fZuynGl27o3HBuPuG5M=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-ct4Z-ReEM8-qediKhBUcUQ-1; Wed, 23 Mar 2022 15:10:43 -0400
X-MC-Unique: ct4Z-ReEM8-qediKhBUcUQ-1
Received: by mail-ot1-f72.google.com with SMTP id g2-20020a9d6b02000000b005b26d8c50a5so1446430otp.9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 12:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hMSz6R8MljxH5tNM923iQc7Lkarfhq9MPHr06b3TmaI=;
        b=SAtNqUdUUzX/8MkBAMqNgLwxVn/QYvzPCrBjznKQExoElci+jainVWUxOTG3o3GweP
         VNosLjo4wQmrBIKObKCMaOJ1wux30+YDoL4Oo+HhUeSadAqEAxNsSUe+FE5dzq2hdv1d
         PA162fKxXF8s9qP5AFmjD0amxNEZi6AIR5YjRrSeO4JeqYTgnNV66nVxQCSFdmACb1Zz
         E9xlVoXSnRFa83gkMauxKWDjJ3sxAsDSnQiR4V5p5KddTIq9gAOoa7GZ9ojnTfxxaxGc
         HYOkCMuPFLzcEP8FuSQb3jOu5EFleHjzP6cDPOrNYgucfYC3GA64eXOfCbEd04fV/lze
         XDPQ==
X-Gm-Message-State: AOAM533dvBfNT7CTgFOrZCwbMV3SD9CiPugoGJl86UaU03gUB1dF5ik0
        ZgDE0olbMwtIgUppz7w0U8Ox22Otgt/u4ydXmgq/EGywZh7JmJem6xEhgv/YKimV0kx597NxMRR
        RKPLcKlszPaW3
X-Received: by 2002:aca:220c:0:b0:2d9:eb5e:f4d0 with SMTP id b12-20020aca220c000000b002d9eb5ef4d0mr5440144oic.232.1648062642070;
        Wed, 23 Mar 2022 12:10:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTy7pF0/xnQnJ15xFLURJLPj9g6wz5WiKdNGKM06ryRsQgJ9LxrLcXzTDlwF53gvwtUDHQ9g==
X-Received: by 2002:aca:220c:0:b0:2d9:eb5e:f4d0 with SMTP id b12-20020aca220c000000b002d9eb5ef4d0mr5440120oic.232.1648062641909;
        Wed, 23 Mar 2022 12:10:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d9-20020a9d51c9000000b005b2466cd7b3sm352588oth.36.2022.03.23.12.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 12:10:41 -0700 (PDT)
Date:   Wed, 23 Mar 2022 13:10:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220323131038.3b5cb95b.alex.williamson@redhat.com>
In-Reply-To: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Mar 2022 14:27:33 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> +static int conv_iommu_prot(u32 map_flags)
> +{
> +	int iommu_prot;
> +
> +	/*
> +	 * We provide no manual cache coherency ioctls to userspace and most
> +	 * architectures make the CPU ops for cache flushing privileged.
> +	 * Therefore we require the underlying IOMMU to support CPU coherent
> +	 * operation.
> +	 */
> +	iommu_prot = IOMMU_CACHE;

Where is this requirement enforced?  AIUI we'd need to test
IOMMU_CAP_CACHE_COHERENCY somewhere since functions like
intel_iommu_map() simply drop the flag when not supported by HW.

This also seems like an issue relative to vfio compatibility that I
don't see mentioned in that patch.  Thanks,

Alex

> +	if (map_flags & IOMMU_IOAS_MAP_WRITEABLE)
> +		iommu_prot |= IOMMU_WRITE;
> +	if (map_flags & IOMMU_IOAS_MAP_READABLE)
> +		iommu_prot |= IOMMU_READ;
> +	return iommu_prot;
> +}


