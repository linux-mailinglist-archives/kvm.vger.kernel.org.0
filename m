Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D484F99DA
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 17:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237786AbiDHPuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 11:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237788AbiDHPuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 11:50:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6AC210F8
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 08:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649432891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z2gRxBOdknfQRB1cfkYgPAkXYqIEl2oL9VEfdnAyBSA=;
        b=Wk3FXkw0TfA5Wt6zlgVb6YMRwhvURhVH2bv6VL9KsTmOMIkeYzyzh6S4xQlno8e+Rv7J1z
        5EjJYGCn4vpl/8fw0dtyvlAsIU10TQrjf3rmdIS8c1CMBVkvlnJki/tD43eRmjd9K1xerH
        +8xd/q7Dq1u139qKLwPkyuzR2fzSBH0=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-B1YU4V3MNr2MUJfoHr9rvw-1; Fri, 08 Apr 2022 11:48:10 -0400
X-MC-Unique: B1YU4V3MNr2MUJfoHr9rvw-1
Received: by mail-io1-f72.google.com with SMTP id f11-20020a056602070b00b00645d08010fcso5970759iox.15
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 08:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Z2gRxBOdknfQRB1cfkYgPAkXYqIEl2oL9VEfdnAyBSA=;
        b=oqOCYpTIL5IlauwdvXpnt5i1WXyx/1/xuNL/BKD2CDz3a3yIl70X9Mt4RNohn1aeWW
         dq80xijKzqeWpa24mLVC3uWm5lwkqQYVFLrWveTiL4/eey4iNpc/Vg802syqK62Ici2q
         jBByvbdAYgqAIXLACf2unXZ/N724cn+xI5HdUTUMbJY9DbKfITwk8mwGMF8wUEbohrqg
         8S9aZFjdmdkw4sLZIsAOC5Ko23t/c8exe97Ar+UEUCpVHM30uoqk2LQjQG3zOy4cOIDu
         hoq5Ke3n5WbJcG8q3GZaSBlnmX0vIPMjHE8a42WpTi+1nY9UYxfTmPiiV8H1gkmSdfcq
         ucrw==
X-Gm-Message-State: AOAM5328GqhKd4v+BFIrj96dhJZPa8kMQfSS9A0QHtS7J5SmoSmAHyXs
        gt5smtIH83IsCGcF6FevXN3aoCVWdg+ZTPl72oCW1RW/CKbjMeXlOYi6KcZApP/2BkgfAY4JuU3
        j4YK8H73kpf5t
X-Received: by 2002:a5d:83d2:0:b0:64c:fbd3:e792 with SMTP id u18-20020a5d83d2000000b0064cfbd3e792mr8822804ior.59.1649432889329;
        Fri, 08 Apr 2022 08:48:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSsMMZZYBKun0PwziD43XZEzOU56NhBOAs7fTRTG7WAh5PRmK8HA5dCAy3y2jLRWrDmaoiZg==
X-Received: by 2002:a5d:83d2:0:b0:64c:fbd3:e792 with SMTP id u18-20020a5d83d2000000b0064cfbd3e792mr8822794ior.59.1649432889160;
        Fri, 08 Apr 2022 08:48:09 -0700 (PDT)
Received: from redhat.com ([98.55.18.59])
        by smtp.gmail.com with ESMTPSA id i12-20020a92c94c000000b002ca56c2cf67sm7104166ilq.28.2022.04.08.08.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 08:48:08 -0700 (PDT)
Date:   Fri, 8 Apr 2022 09:48:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 4/4] vfio: Require that devices support DMA cache
 coherence
Message-ID: <20220408094807.53f178c5.alex.williamson@redhat.com>
In-Reply-To: <4-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
        <4-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  7 Apr 2022 12:23:47 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> IOMMU_CACHE means that normal DMAs do not require any additional coherency
> mechanism and is the basic uAPI that VFIO exposes to userspace. For
> instance VFIO applications like DPDK will not work if additional coherency
> operations are required.
> 
> Therefore check IOMMU_CAP_CACHE_COHERENCY like vdpa & usnic do before
> allowing an IOMMU backed VFIO device to be created.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index a4555014bd1e72..9edad767cfdad3 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -815,6 +815,13 @@ static int __vfio_register_dev(struct vfio_device *device,
>  
>  int vfio_register_group_dev(struct vfio_device *device)
>  {
> +	/*
> +	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> +	 * restore cache coherency.
> +	 */
> +	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> +		return -EINVAL;
> +
>  	return __vfio_register_dev(device,
>  		vfio_group_find_or_alloc(device->dev));
>  }

Acked-by: Alex Williamson <alex.williamson@redhat.com>

