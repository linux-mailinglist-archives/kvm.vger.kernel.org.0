Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDFE75D518
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 21:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjGUTfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 15:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjGUTfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 15:35:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBBAE53
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:35:39 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1bb1baf55f5so17169295ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1689968139; x=1690572939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzRV4jT/UtNnsNIK2YvG3L4X5UH72+69TP4OaQhmPt4=;
        b=JfMGnrE+g4/SdXqp/ILAdh8OXvsFjfzKETJHY+EhlewfKhrwUZ7RoTSzKYzg/yardc
         q8Kxwh36Uh0alOQRzLpTJiv+muY/pM/0QMO13VqRNd6mSkBAuzE8Y6Vf1Vo8IF8VaYFm
         ZM5I8a2BhNFvQNAEAJURcgSp2m2m3PC2Yx+Rwz8AdVzrHJ2A+N9Y24PPf8Vh2DLA9J7a
         ys5PbTXsComhwHn7A1jDs56BwRrB4QZzXdF2e88pkpT0JViBziznq2TDlyxDGepnE2RY
         LEfZFIh6ZBKtXl8gzi+XeNAIQCBJA3i3bAy6V+Bidl2HemJcbdaJ9FaBpp3xBvsdlW4l
         zL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689968139; x=1690572939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzRV4jT/UtNnsNIK2YvG3L4X5UH72+69TP4OaQhmPt4=;
        b=ai+NxPFUVRxIMQ/Y37BDXGNBl7yWtfhrz3s1Vgae6RnswdpL7r38WA5hcL3v64P1wq
         zs105kQ7BLYX1RZv3tyzRfmtGEyiiH8WHfxleHPRWU2I0pLN2gDp5N8WTLEGEkpURQTw
         hKk4g65bs9e7/kYfZpwNfXN95HAMMmga6Kxzj304nPkSE9l3IwnNEMIEOlBYfNi3hcKj
         PgB704DIx13O1DfGyMEkCdtVQpiOgHmZrXOKWpjAqd9yU+6YviMtKirpqNPALVFmcT+E
         28fpnyLYeYGROiTq0mS+x5lieeoRGOkOYdb/zcdypLINytlgWaKXexpNgdUpx7zC88rz
         4YoA==
X-Gm-Message-State: ABy/qLZUECPtfvEntP2hqwyPzlPqLAxBdIXIjcHHvyRsmLU9LvMroK9u
        AJW3n7gPdssjJEGgh9OlD1hOrw==
X-Google-Smtp-Source: APBJJlErhC+VIXfffdNPDZMSDd2lEyokEWsGZ4siE0VrJXPYSeMfFCGzQlYHv6H7Qp1LgMkojZxgOQ==
X-Received: by 2002:a17:903:120f:b0:1b8:4b87:20dc with SMTP id l15-20020a170903120f00b001b84b8720dcmr2955939plh.37.1689968139289;
        Fri, 21 Jul 2023 12:35:39 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id p15-20020a170902e74f00b0019ee045a2b3sm3836250plf.308.2023.07.21.12.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 12:35:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qMvub-003IJe-Bf;
        Fri, 21 Jul 2023 16:35:37 -0300
Date:   Fri, 21 Jul 2023 16:35:37 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Message-ID: <ZLreCUIJoo1TfmVz@ziepe.ca>
References: <20230713043248.41315-1-baolu.lu@linux.intel.com>
 <20230713043248.41315-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713043248.41315-2-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 12:32:47PM +0800, Lu Baolu wrote:
> The IOMMU_RESV_DIRECT flag indicates that a memory region must be mapped
> 1:1 at all times. This means that the region must always be accessible to
> the device, even if the device is attached to a blocking domain. This is
> equal to saying that IOMMU_RESV_DIRECT flag prevents devices from being
> attached to blocking domains.
> 
> This also implies that devices that implement RESV_DIRECT regions will be
> prevented from being assigned to user space since taking the DMA ownership
> immediately switches to a blocking domain.
> 
> The rule of preventing devices with the IOMMU_RESV_DIRECT regions from
> being assigned to user space has existed in the Intel IOMMU driver for
> a long time. Now, this rule is being lifted up to a general core rule,
> as other architectures like AMD and ARM also have RMRR-like reserved
> regions. This has been discussed in the community mailing list and refer
> to below link for more details.
> 
> Other places using unmanaged domains for kernel DMA must follow the
> iommu_get_resv_regions() and setup IOMMU_RESV_DIRECT - we do not restrict
> them in the core code.
> 
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/linux-iommu/BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h |  2 ++
>  drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++----------
>  2 files changed, 29 insertions(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
