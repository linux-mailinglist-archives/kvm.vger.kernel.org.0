Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCF17765D0
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 18:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjHIQ7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 12:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjHIQ7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 12:59:01 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EFDDF
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 09:59:00 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-409ae93bbd0so53522541cf.0
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 09:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691600340; x=1692205140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ePlScrnrPWgYIwkxSFrLYux3pUaMlgw2BLgxuxovAOE=;
        b=APERFP272SNMr7Kw8WPTlRK9wuiXOkBrHzhp907/GMoSm1zJmJ+zVc0XLVRCb8Hp5r
         oDYmxkKqYtZVSaIVIOtFE8VD1XC6MrZw4rfutzfDAHGRGeDMsGfRyibOsQLu5Rk3UHlO
         8lp6MfIpcQmkREuqswrbOVMsGLhvnGvzz29P1qExW+y2ueTRPgaAhTSRaNCxFru7S0FE
         9nZb2LXh0h2eh3FY44jue9GibBj6BFa+VkJ2cx8b5BBxpWlFPQ8pUnLsjIevV1yBkdog
         OWYKNHhj9XxsnUKtHE8dtD1Hqvh2qpnfMa/G6nAldcNk8JowFS35OsPbNtUuyW5ZZ7nQ
         ouRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691600340; x=1692205140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePlScrnrPWgYIwkxSFrLYux3pUaMlgw2BLgxuxovAOE=;
        b=JlxClT7vDP3DbmZtfNFaz56OOe8Lm5MoxQs2v/ynbCRbgZm12jawd0UAXNDnQKLpei
         Y/G7a0Bkc2B7XyV6GCpDfEFzoCeGbdNdeSroGe3PL6Ah32hONKkFXqJeTdpcQLjiz8+0
         g+bq3GBnhSW0UlZKCCvtdk/+rol9N0VUDf2WFRvROa/xCIs2H9LZtmzurTBqNq1cbyDj
         no2aGU6XJ6rzOzI2ZAzHmnDrhM7bUmFxbjboiF3otbXTJqEjxPwU3p7wCkj1VY+ehjZu
         gT9DgfLc0K3zBBkWBvFo849MMY8emaz0knkqFfzNn/Ii6AsPgKkAj+R3ceJdoy3ahLWE
         nBVw==
X-Gm-Message-State: AOJu0Yx82kD5LNH72TFdfp4B+gbfgMVDBlOul0tUwSjhYhUJxx+8ujwE
        40+ZVB3rmPeMBG08axsSFdoXlUbfpiBahGhVgqk=
X-Google-Smtp-Source: AGHT+IE6HAHRe9rLHLimsKF4h4cWp3x4JMrWEIQz7rmXWl2on/DzudkcyWasVh7uCL4uXrL1ZUciAw==
X-Received: by 2002:a05:622a:2d2:b0:40f:d1df:fa10 with SMTP id a18-20020a05622a02d200b0040fd1dffa10mr4859881qtx.31.1691600339792;
        Wed, 09 Aug 2023 09:58:59 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id w26-20020a05622a191a00b0040ff2a9ca0asm4154988qtc.67.2023.08.09.09.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 09:58:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qTmWQ-005518-EA;
        Wed, 09 Aug 2023 13:58:58 -0300
Date:   Wed, 9 Aug 2023 13:58:58 -0300
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
Subject: Re: [PATCH v2 01/12] iommu: Move iommu fault data to linux/iommu.h
Message-ID: <ZNPF0rLiMruBeGpD@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727054837.147050-2-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 01:48:26PM +0800, Lu Baolu wrote:
> The iommu fault data is currently defined in uapi/linux/iommu.h, but is
> only used inside the iommu subsystem. Move it to linux/iommu.h, where it
> will be more accessible to kernel drivers.
> 
> With this done, uapi/linux/iommu.h becomes empty and can be removed from
> the tree.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h      | 152 +++++++++++++++++++++++++++++++++-
>  include/uapi/linux/iommu.h | 161 -------------------------------------
>  MAINTAINERS                |   1 -
>  3 files changed, 151 insertions(+), 163 deletions(-)
>  delete mode 100644 include/uapi/linux/iommu.h

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
