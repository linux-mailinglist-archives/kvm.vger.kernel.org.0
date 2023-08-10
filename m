Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D407780E6
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbjHJS7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 14:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbjHJS7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 14:59:12 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE1B26A6
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 11:59:10 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-7672303c831so90994085a.2
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691693950; x=1692298750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Zq0l3xZQiEDwcrtH7vACzt2kdLllz4ciH/cpuUOM4s=;
        b=JErK18ADkD1dTNzsRq+SbbDprsUFNPoAzYx9s7K3M7nQd4oYJ8BsxhMmdmA1bSkIfv
         GX/X6fvYVS2EirYupvLRfaflRZ8AlzSSf7IxxSnx/Sxqj1fNZVITtmtwr1lmFaYqDjCo
         2WnIMuS+4K7fNeZl565GjLMYfTsFMeBCZO23OEILH6+zwY5YgwK9GDpmJt3RsZJyWYNE
         ueFugH93WIMVJkZ6McBqGcXVwCwHrp7/koFcUsoqa7C+IUMeCG6fYZ/uzqi4RfCZ38uA
         PT4aRO8JFn+voySym+TaRdDPTw3tMDhJaXKMVIrulLNZFGEA9f0h0j2fJpWdJNtAu/yz
         OOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691693950; x=1692298750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Zq0l3xZQiEDwcrtH7vACzt2kdLllz4ciH/cpuUOM4s=;
        b=l46bzJ4CAKzDpPw/6flPonOQITdsyFVCaZB3TXtED1XPbC+IhK1r9/shG4Ci9qd16z
         Y4WehjvU06xD8daGFXXcg1bIy4IMg75xZGUH3q6P6SWOWzKrUjApN/GeiJvw71J/Iotv
         hoovHaTUwUo4mHVUN3qBdokCSSZC0OgMuV4Hq2cOtov6++/uJupQ8f0+cDib/hfWE7HM
         qwYGaGoni2rljsUhfIX0XR+8okzuTMvBDdZJM/Rf2LusBvi8yPdrIPkQYA3dm0kXcwd6
         o5jyhZb/lL0ALGj6BAj9CQkZE0hRTB++6JjxA6vG6xv+jNhhy5sh2fSv8TdZ7UiCIe2x
         yJLA==
X-Gm-Message-State: AOJu0YwF+lNDazLFX4prPwA9kicBhi8z4u/XaN9Fj08HBrMZRoW0RkaB
        6wFH1SOPIckqsYavI0uvp2CNKzcxoUdplJVPICQ=
X-Google-Smtp-Source: AGHT+IFKkMDEkgSctGof3sz+jJvzI+ZC32d6umGv4kDgoGWJhf/GlnIZ8OsWb+JmdP2TnPFsZEEmxQ==
X-Received: by 2002:a05:620a:3191:b0:765:3e03:10db with SMTP id bi17-20020a05620a319100b007653e0310dbmr3454229qkb.48.1691693950008;
        Thu, 10 Aug 2023 11:59:10 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id j10-20020a0cf50a000000b006300ff90e71sm679584qvm.122.2023.08.10.11.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 11:59:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qUAsG-005IgH-N2;
        Thu, 10 Aug 2023 15:59:08 -0300
Date:   Thu, 10 Aug 2023 15:59:08 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/12] iommu: Remove
 iommu_[un]register_device_fault_handler()
Message-ID: <ZNUzfFDyT6/VZgfW@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-8-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727054837.147050-8-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 01:48:32PM +0800, Lu Baolu wrote:
> The pair of interfaces are not used anywhere in the tree. Remove it to
> avoid dead code.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h      | 23 ---------
>  drivers/iommu/iommu-sva.h  |  4 +-
>  drivers/iommu/io-pgfault.c |  6 +--
>  drivers/iommu/iommu.c      | 96 --------------------------------------
>  4 files changed, 4 insertions(+), 125 deletions(-)

Some of these hunks should be moved earlier, but

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Happy to see it go

Jason
