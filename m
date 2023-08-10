Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81FE778026
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 20:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbjHJSWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 14:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbjHJSWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 14:22:20 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37ED271E
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 11:22:18 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-63fba828747so7207686d6.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 11:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691691738; x=1692296538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kcjxdJ9WmHxKNY6KosOB3TxKaZ6LfXZdDC4NFaJO6to=;
        b=BdW7UNRg9AT5/2egP81zRCWOkcMVXDUf1IoXVs7kpDi/lU81fRnympXyKF6K9B9cyK
         6WONDV4Q2c9S5P3f3uZL7pDa7/Q2FaJUlBMm2qWjgMdAbsBhFKKAc1YN12dpmy6iSYwA
         lITo7ZQfY77GJMyCh2VpHTHr3XCat9iB87Fvck0pK44glJm/A6tjCYggASebe6HJXUUv
         rlM4ZcRpnXmAM8T5Z/U2++n7YHKDm6qnqG83zFbHP1j0Fvi1RaYqNylfYUk5qAf5EHgj
         8Fj2MPAUyhE1e/0U2eG49MOoO1uX8fovF0M71I51V4rr87rgHR/0s8kdVhlPbcKll0ej
         jKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691691738; x=1692296538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcjxdJ9WmHxKNY6KosOB3TxKaZ6LfXZdDC4NFaJO6to=;
        b=F0C3eUrgWMHdyfuYvyeipZwcEGIpUIk/zxf3HNDi7TjVaRH4XHcBl9pjGLUetwFP8X
         LnM+O8jbqtuhxvx4HmdSu526Ud+TLWFxcVaOP4K+p8Wwm3Z/+WHTY7tw9iQjY4yd1ZB6
         2M4EpyzOkBZF0+1jCChpsQaXSBrXD6wLFhxhvJr8+YSLezt7DkSs4da4SSoo/tcH6cse
         iZZQNG/frLzBNVhvh4gN2Z2jQsL+x64pmAWYhSNmILQVpq/Xg0Ghs2k/AwtnsxpCY7XO
         DgOV1Jw+CVGfEJy7i1zHQRQQBoJevYHYYbbFEZrNXLgBnqeFt7gBiOT/A0aS89NRLTL4
         Vvhg==
X-Gm-Message-State: AOJu0YznRfJ98Q+rQThHrzY40OK8BYkRM2rHE5ZrPja5746WG/bu3Dzk
        Fr0+wDAxm5d7T4d0CGd6zLjBvQ==
X-Google-Smtp-Source: AGHT+IHj7SJ/OqzVLjOSuCJ7oMR36+mlM3SPJmZN9QqQiO3KgmWZpdToIz8CpVW8DosUmgWCzhtI6Q==
X-Received: by 2002:a0c:c986:0:b0:63c:ed11:7bf0 with SMTP id b6-20020a0cc986000000b0063ced117bf0mr2923351qvk.6.1691691738065;
        Thu, 10 Aug 2023 11:22:18 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id r27-20020a0cb29b000000b0063cdcd5699csm665282qve.118.2023.08.10.11.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 11:22:16 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qUAIa-005HuO-83;
        Thu, 10 Aug 2023 15:22:16 -0300
Date:   Thu, 10 Aug 2023 15:22:16 -0300
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
Subject: Re: [PATCH v2 04/12] iommu: Replace device fault handler with
 iommu_queue_iopf()
Message-ID: <ZNUq2IcvjEkwQewc@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727054837.147050-5-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 01:48:29PM +0800, Lu Baolu wrote:
> The individual iommu drivers report iommu faults by calling
> iommu_report_device_fault(), where a pre-registered device fault handler
> is called to route the fault to another fault handler installed on the
> corresponding iommu domain.
> 
> The pre-registered device fault handler is static and won't be dynamic
> as the fault handler is eventually per iommu domain. Replace calling
> device fault handler with iommu_queue_iopf().
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 4352a149a935..00309f66153b 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1381,7 +1381,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
>  		mutex_unlock(&fparam->lock);
>  	}
>  
> -	ret = fparam->handler(&evt->fault, fparam->data);
> +	ret = iommu_queue_iopf(&evt->fault, dev);
>  	if (ret && evt_pending) {
>  		mutex_lock(&fparam->lock);
>  		list_del(&evt_pending->list);

I don't get it, why not remove fparam->handler/data entirely in this
patch? There is no user once you do this change?

Jason
