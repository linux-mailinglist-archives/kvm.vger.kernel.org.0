Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468FB7765CD
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 18:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjHIQ6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 12:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjHIQ6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 12:58:49 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD71BFE
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 09:58:49 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-63cf6b21035so233496d6.1
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691600328; x=1692205128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HYvyJLDPrx2pbzTjvftAVXIWA5LXwkiJ68ZPpMJp9sA=;
        b=ADqOJEhJB5q7TFPPh8MLq5oUZWbf5kq4KKBzedrKNRgCzh5a1whEy0zixzonzB1YxD
         9idJ9oDA3CGM7hMgUJlAKtVZFPKY5ThQGthZyTl+3ECHiieU1rHMuUinyAfGcWPCdmXX
         0VYqOr+w5cONXa4KMZMkkulJFsnncraYN0l0EwvHeWq84wKVhaHlPzg19WiyQ8jhwIIu
         HIq12WQ3hkutNBJBtzaGWlqTYtjelyX8NGIDQETcnX2bUazQ0GX84TB/0JQ4oy/coMtF
         bXXk33Dxn0dGdoVJYNv87dm749tvQ1DIks7G7xn8/Yrc/DsOyC37l4D/TTgtktSqzKAt
         UtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691600328; x=1692205128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYvyJLDPrx2pbzTjvftAVXIWA5LXwkiJ68ZPpMJp9sA=;
        b=bPnaTncBCN6dVj/1xUJILEdqrLsowaS7olSpgMrefB2sOMrvxR4RAFUWKrF86lWKed
         J4w906QDPyMNwKwN2hvmYAI30o0uTgEvPDCzDKph6ndXYIDAZYXgxDou/MN660P1SFcP
         6J/V81dUtvzBcl1aAF4n9m+yz6bgah1eYiXHCFAuVpnSsy10G+o4UkiCiFUVUJ6XQbrJ
         yIsuyrBgR+nsLgoDKc2+vqUs7fzPvVsaQo2GYESI3xfo6YEId0OjrXsfjvFoVoSy6j8S
         HNTAfd5tiSn2HqrMcq0jfSkh3HolWSP0Q133Dzg8nlloLxCBW4vc0+JtKK9OszXtorCX
         FIyQ==
X-Gm-Message-State: AOJu0Yw+OxKiwYSlaDk8X5ptKwxDCZlGV/6dISqCoad3rjn48vk6t514
        bW6uGz2sz6HMonKTH3d9UNjUcA==
X-Google-Smtp-Source: AGHT+IHVIfN85HRjXllkbUGZm2l8arf6nI8q6Wv6Tjmlg7p7n1UpDUcHrjw0ddv9zc3q6VKAhmbWnw==
X-Received: by 2002:a0c:fc0b:0:b0:63c:f84e:9f5e with SMTP id z11-20020a0cfc0b000000b0063cf84e9f5emr2938797qvo.19.1691600328579;
        Wed, 09 Aug 2023 09:58:48 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id p14-20020a0ccb8e000000b0063d245c00b5sm4576710qvk.0.2023.08.09.09.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 09:58:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qTmWE-00550r-Oz;
        Wed, 09 Aug 2023 13:58:46 -0300
Date:   Wed, 9 Aug 2023 13:58:46 -0300
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
Subject: Re: [PATCH v2 05/12] iommu: Change the return value of
 dev_iommu_get()
Message-ID: <ZNPFxtlN/STZAMEY@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-6-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727054837.147050-6-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 01:48:30PM +0800, Lu Baolu wrote:
> Make dev_iommu_get() return 0 for success and error numbers for failure.
> This will make the code neat and readable. No functionality changes.
> 
> Reviewed-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 00309f66153b..4ba3bb692993 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -290,20 +290,20 @@ void iommu_device_unregister(struct iommu_device *iommu)
>  }
>  EXPORT_SYMBOL_GPL(iommu_device_unregister);

It could probably use a nicer name too?

iommu_alloc_dev_iommu() ?

Also with Joerg's current tree we can add a device_lock_assert() to
this function, from what I can tell.

Jason
