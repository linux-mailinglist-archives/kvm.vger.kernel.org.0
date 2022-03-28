Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0E44EA2BB
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 00:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiC1WOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 18:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiC1WOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 18:14:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72A851637CE
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 15:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648505393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhA4dUFlPR118hhpX2PsAoIqQjvFZQbvAcfxVPt1G38=;
        b=dQ5CF9oCCZOW4boWSKJtPLRjTT4nqwNy3G+aIuV56EHcXRX1J5J45OCdfrLuBVgmRwZ0Oy
        YrhOXhVkA6RwgITMiYrSrW0/N0EwEVLIcubx55gG+xKF5PuAW0Dgl5puETVq8BRkJYFErU
        PXbJOS7EWx0dXxU4HC//mwLmtH0Qlio=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-K0UfL6znNxSrPXrX7obzFA-1; Mon, 28 Mar 2022 17:26:54 -0400
X-MC-Unique: K0UfL6znNxSrPXrX7obzFA-1
Received: by mail-il1-f198.google.com with SMTP id x6-20020a923006000000b002bea39c3974so8512835ile.12
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 14:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AhA4dUFlPR118hhpX2PsAoIqQjvFZQbvAcfxVPt1G38=;
        b=atB8aP+f3e3zP+zfo9uk/vgvRt9UOflu34Dn72QImRvvadTGT2rrk6JtNB3RiZLbZe
         y0t+4gKTHIoyk/zPr6dMPpOmuwNDkZYXEYUm7zpDtDuUg3m+Mck5R1ZtGeoDUnVyBq24
         UTSPeDWga4rBlvGkZ9JhYtRN+Sb+GZrRVd4XbBE+PDp0FvtohknQkDjcby3qij5tgrCA
         jzfJQXLvnhgGc1pDVDsU4tskCnA6eZT5rKrdaFFUFQ+lTL08W7MwAE61pwaqMcztR4A4
         slY9q5ZQ0PhFuKZAPOoLRbYJaYrqU8akXDLUYql4VJ+zWOUfy20QAltYVSY9uhgJttxX
         2bTA==
X-Gm-Message-State: AOAM531QfhkdtOa4yjJTlX53NeK1rBMoEnaDw+XqoSusEzjWYpnMMwwL
        X/jxDR59rsdmZFQDe4uulqGlj82j+mSQnM9/FrWBl1vuAcFnAcithk9b5iFmg5sjhHIBGzHfJcv
        8SMyxdk+VKSee
X-Received: by 2002:a05:6638:1490:b0:323:6863:fd0f with SMTP id j16-20020a056638149000b003236863fd0fmr3955826jak.20.1648502813601;
        Mon, 28 Mar 2022 14:26:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypxL5wkwODjtfYMS8ID4x491eGOOpE6QbjSXOKlH5MMMTvT9ty6p3YM6m6FKhe9EFHLEL44w==
X-Received: by 2002:a05:6638:1490:b0:323:6863:fd0f with SMTP id j16-20020a056638149000b003236863fd0fmr3955814jak.20.1648502813325;
        Mon, 28 Mar 2022 14:26:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f8-20020a056e02168800b002c654e0f592sm7880621ila.58.2022.03.28.14.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 14:26:52 -0700 (PDT)
Date:   Mon, 28 Mar 2022 15:26:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220328152651.4882d8e9.alex.williamson@redhat.com>
In-Reply-To: <20220328194749.GA1746678@nvidia.com>
References: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <20220323131038.3b5cb95b.alex.williamson@redhat.com>
        <20220323193439.GS11336@nvidia.com>
        <20220323140446.097fd8cc.alex.williamson@redhat.com>
        <20220323203418.GT11336@nvidia.com>
        <20220323225438.GA1228113@nvidia.com>
        <BN9PR11MB5276EB80AFCC3003955A46248C199@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220324134622.GB1184709@nvidia.com>
        <20220328111723.24fa5118.alex.williamson@redhat.com>
        <20220328185753.GA1716663@nvidia.com>
        <20220328194749.GA1746678@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Mar 2022 16:47:49 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Mar 28, 2022 at 03:57:53PM -0300, Jason Gunthorpe wrote:
> 
> > So, currently AMD and Intel have exactly the same HW feature with a
> > different kAPI..  
> 
> I fixed it like below and made the ordering changes Kevin pointed
> to. Will send next week after the merge window:
> 
> 527e438a974a06 iommu: Delete IOMMU_CAP_CACHE_COHERENCY
> 5cbc8603ffdf20 vfio: Move the Intel no-snoop control off of IOMMU_CACHE
> ebc961f93d1af3 iommu: Introduce the domain op enforce_cache_coherency()
> 79c52a2bb1e60b vfio: Require that devices support DMA cache coherence
> 02168f961b6a75 iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with dev_is_dma_coherent()
> 
> '79c can be avoided, we'd just drive IOMMU_CACHE off of
> dev_is_dma_coherent() - but if we do that I'd like to properly
> document the arch/iommu/platform/kvm combination that is using this..

We can try to enforce dev_is_dma_coherent(), as you note it's not going
to affect any x86 users.  arm64 is the only obviously relevant arch that
defines ARCH_HAS_SYNC_DMA_FOR_{DEVICE,CPU} but the device.dma_coherent
setting comes from ACPI/OF firmware, so someone from ARM land will need
to shout if this is an issue.  I think we'd need to back off and go
with documentation if a broken use case shows up.  Thanks,

Alex

 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 3c0ac3c34a7f9a..f144eb9fea8e31 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2269,6 +2269,12 @@ static int amd_iommu_def_domain_type(struct device *dev)
>  	return 0;
>  }
>  
> +static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
> +{
> +	/* IOMMU_PTE_FC is always set */
> +	return true;
> +}
> +
>  const struct iommu_ops amd_iommu_ops = {
>  	.capable = amd_iommu_capable,
>  	.domain_alloc = amd_iommu_domain_alloc,
> @@ -2291,6 +2297,7 @@ const struct iommu_ops amd_iommu_ops = {
>  		.flush_iotlb_all = amd_iommu_flush_iotlb_all,
>  		.iotlb_sync	= amd_iommu_iotlb_sync,
>  		.free		= amd_iommu_domain_free,
> +		.enforce_cache_coherency = amd_iommu_enforce_cache_coherency,
>  	}
>  };
> 
> Thanks,
> Jason
> 

