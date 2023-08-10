Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A397780ED
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 21:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbjHJTCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 15:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbjHJTCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 15:02:46 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD6226A6
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 12:02:45 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-7653bd3ff2fso102693785a.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 12:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691694165; x=1692298965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ol8o111D6X16s4/vdk4snMP1jvmYUyrjvsKNZNa6i6w=;
        b=j8xQ5etaEWczcx0UpChvNBhWH4pGMmMqfPSDxt8lVA94h4iCSj/YmaLHgsOzPIgTtJ
         Ee00wZmKsoZRTdPbpngP3tdhd7Lzj1EsL3h4a+z/JQh5bZjk/le27wTBDpyMlffdee3q
         1y7utSBEMRegnuHGC1K83jeW7N5jQocQv471zdiA7pNJJafQk/neRBMwPkjM+uzfUkqG
         wUI7nzmUMCP85you7O/gAEwhzYjpUypvAVIppJ17U/qxfotuNv1pQ0XDLhHy1baFJz1P
         xFf/ny3SyCb9bWjFwRiX5zAd3JxZ4WPny/ZCy0SVOSI3C43c0gXWVIaJuQhIhuPpJSif
         zrYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691694165; x=1692298965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ol8o111D6X16s4/vdk4snMP1jvmYUyrjvsKNZNa6i6w=;
        b=fNoajUupLuSA/4QonVCSJ6CqlFxzc65680DUrHVKqshiL82E5t0jNaveX4fO7T77lS
         /2TmG5usUc6Vs6mc64A1dt2Bia34+urbYhrKnAjyyFncdu6i/oF6HLwkARKxxzkSC0z7
         acMPkaY6XbkzrJ7pdBNgYaBP4FiMnDLq1QnkhDx0XDKyvrVxcdX5+/Raj1sqQYTPae5q
         VhtU+UuloIJLg3m4YLNb4QNL+sgKeuERW41Ku0o629g23HmGLeqoqPOsHm1BlDyKPj6f
         n/FOH9JCEZcC37ZmUHJJmjoWRtsJRQf1atsQyPOuIjUSH2VmfKTlAFw4xeCenIjJTanw
         yatw==
X-Gm-Message-State: AOJu0YzD5bTM1aNHbwphkixVKdV+ZYjASBQgKhs/W/Oh239atiaYdkqA
        vLgnABLgMvnYyEGuOlqc+psAYw==
X-Google-Smtp-Source: AGHT+IGGfaalbPDlT+pvMJOgJl26XLZ6gib9ghHzXbB7fd+R8Fp1mS7Fgm+I9bVdGlHSgzCGUXGaAw==
X-Received: by 2002:a05:620a:4412:b0:765:a9d7:2ca2 with SMTP id v18-20020a05620a441200b00765a9d72ca2mr4080265qkp.48.1691694164969;
        Thu, 10 Aug 2023 12:02:44 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id g3-20020ae9e103000000b0076cda271e54sm680981qkm.112.2023.08.10.12.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 12:02:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qUAvj-005Ihx-JK;
        Thu, 10 Aug 2023 16:02:43 -0300
Date:   Thu, 10 Aug 2023 16:02:43 -0300
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
Subject: Re: [PATCH v2 09/12] iommu: Move iopf_handler() to iommu-sva.c
Message-ID: <ZNU0U9XscuB3ILuX@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-10-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727054837.147050-10-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 01:48:34PM +0800, Lu Baolu wrote:
> The iopf_handler() function handles a fault_group for a SVA domain. Move
> it to the right place.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu-sva.h  | 17 +++++++++++++
>  drivers/iommu/io-pgfault.c | 50 +++-----------------------------------
>  drivers/iommu/iommu-sva.c  | 49 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+), 47 deletions(-)
> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> index 05c0fb2acbc4..ab42cfdd7636 100644
> --- a/drivers/iommu/iommu-sva.c
> +++ b/drivers/iommu/iommu-sva.c
> @@ -219,3 +219,52 @@ void mm_pasid_drop(struct mm_struct *mm)

> +static void iopf_handler(struct work_struct *work)
> +{
> +	struct iopf_fault *iopf;
> +	struct iopf_group *group;
> +	struct iommu_domain *domain;
> +	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
> +
> +	group = container_of(work, struct iopf_group, work);
> +	domain = iommu_get_domain_for_dev_pasid(group->dev,
> +				group->last_fault.fault.prm.pasid, 0);
> +	if (!domain || !domain->iopf_handler)
> +		status = IOMMU_PAGE_RESP_INVALID;
> +
> +	list_for_each_entry(iopf, &group->faults, list) {
> +		/*
> +		 * For the moment, errors are sticky: don't handle subsequent
> +		 * faults in the group if there is an error.
> +		 */
> +		if (status == IOMMU_PAGE_RESP_SUCCESS)
> +			status = domain->iopf_handler(&iopf->fault,
> +						      domain->fault_data);
> +	}
> +
> +	iopf_complete_group(group->dev, &group->last_fault, status);
> +	iopf_free_group(group);
> +}

Routing faults to domains is generic code, not SVA code.

SVA starts at domain->iopf_handler

Jason
