Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5453F77240B
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 14:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjHGMap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 08:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjHGMai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 08:30:38 -0400
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C36891710;
        Mon,  7 Aug 2023 05:30:19 -0700 (PDT)
Received: from 8bytes.org (pd9fe94eb.dip0.t-ipconnect.de [217.254.148.235])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 1DBD22802C2;
        Mon,  7 Aug 2023 14:30:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1691411417;
        bh=c90Yi4nQt040JDhF9erB1oWX7zPJ6lrzrHSn0+kunok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bGIxBTZgxFw6JJa7RMXuE/I8Zw+NcgF5f//wxdTV+F4R6BdunMII8DMX4IBYnewgA
         IQNhOmd6zSLBr8yJYTQxVikb99dHEmAWD5JXXbeT5BTwb8ViI5oCTUaxJdrZc5mC6n
         835qdE16OyAroZ7ZDnp1ieSyd0j+8tFbCXzwmOJU/BoFiKoHVeJdqvdnnjwiDRxA4H
         qww2h/wbxnLnO7TpUzR/lNbpD0LF9O5ogmkwVT8v8vXkBMEJDjluYgy5pnUZzarHX4
         6XumXbhqwKnUAvu6okwC8RLvstvLhwgjle0MzX2FoHyLREySBaJG/bMvOe2lZlLtYb
         CmwPWzeuPpTSA==
Date:   Mon, 7 Aug 2023 14:30:15 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Message-ID: <ZNDj1-Od0iXFhgce@8bytes.org>
References: <20230724060352.113458-1-baolu.lu@linux.intel.com>
 <20230724060352.113458-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724060352.113458-2-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Baolu,

On Mon, Jul 24, 2023 at 02:03:51PM +0800, Lu Baolu wrote:
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
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: Joerg Roedel <jroedel@suse.de>

Feel free to include that in your next round of VT-d updates you send my
way.
