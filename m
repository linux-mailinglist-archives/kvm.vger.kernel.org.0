Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE263778100
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 21:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbjHJTHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 15:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbjHJTHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 15:07:21 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0953D2696
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 12:07:20 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-7656652da3cso93729785a.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 12:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691694439; x=1692299239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=osZx9MFsTjA+0nKdtnzmcExs253v22D1JcCvOo2WUgU=;
        b=CrGiYGDgYC79bexKd3l7JPFKAwwigsGds4ZjU66r3w/rWcMQZMvcVpU6Jc3M9glE5b
         a6eGeyNZkBhnV20mRtRQ4O8ps+dn3sV/cw7K8As1cdTOhuC5cgbnliCtuPSrsZ5k/QYC
         Cru+gTxewyFKQQhU0DY5lm4pLtrEnCqnWeWnoSvZFTQhbA/1oHnxChPsSmlSxwn7Ewut
         Awnh5OiPRtt3hGM0viOKJ66zQhSOioUKxdE6l5VpwQSpdRXVn8gy2XU4OyRKMv4c6mqo
         2id6eHaLk9ye4giWjZ3+2FkJdVtQ9yEJU/GKg/TA3Hs+0eSubTT57MlIblich7TnvqrY
         zfwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691694439; x=1692299239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osZx9MFsTjA+0nKdtnzmcExs253v22D1JcCvOo2WUgU=;
        b=blHVl7fsuYmFBEBtDiZMoaP6LLyJCdfBbrQyKgMMVYJftspUopbC53V+EKVm53FqPv
         jKt85csA7mUSVj+cGmS7RmUrq86xQUi5VBh9vYvDor9RF0UxJtZsRJpiqneBL34Y49NW
         LwEO12MdwWau7eDSlJzcmiipfPrBF5r3t/VySTgyE8cRRdkwE/PLnejLImJ1K0SjxvI6
         5S6P7Byd3AwMvUsH5wG4cahAXgISqISofSC6C0Xtog+pfdwgzTX2YCZIoc/lbIuMQaOV
         iv/mLa/Nu3dStQYkRC+uAItm906yaQsi3MZLdOSBUjQHlLTYoONbXAW0bGdxgN4dv7dX
         WLaw==
X-Gm-Message-State: AOJu0Yzso53SQCB1yeRW5ZfTT4yXIDHPfZb970eI4wjxYFjCuwl7kN28
        0pRvl7DsjjUgGLTW8OLcyrXuOA==
X-Google-Smtp-Source: AGHT+IEKGHFO3EguY5BB8XGUUBMQPX/yKmTUE725d4gkFS+xRmFBWLNA7932D5/kxJlwZwe37YGYdA==
X-Received: by 2002:a05:620a:f14:b0:76c:d958:d549 with SMTP id v20-20020a05620a0f1400b0076cd958d549mr3452297qkl.11.1691694439152;
        Thu, 10 Aug 2023 12:07:19 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id p17-20020a0cf551000000b00635eeb8a4fcsm684434qvm.114.2023.08.10.12.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 12:07:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qUB09-005IkR-PB;
        Thu, 10 Aug 2023 16:07:17 -0300
Date:   Thu, 10 Aug 2023 16:07:17 -0300
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
Subject: Re: [PATCH v2 10/12] iommu: Make iommu_queue_iopf() more generic
Message-ID: <ZNU1Zev6j92IJRjn@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-11-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727054837.147050-11-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 01:48:35PM +0800, Lu Baolu wrote:
> @@ -137,6 +136,16 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>  		return 0;
>  	}
>  
> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
> +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
> +	else
> +		domain = iommu_get_domain_for_dev(dev);

How does the lifetime work for this? What prevents UAF on domain?

> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> index ab42cfdd7636..668f4c2bcf65 100644
> --- a/drivers/iommu/iommu-sva.c
> +++ b/drivers/iommu/iommu-sva.c
> @@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
>  /*
>   * I/O page fault handler for SVA
>   */
> -enum iommu_page_response_code
> +static enum iommu_page_response_code
>  iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
>  {
>  	vm_fault_t ret;
> @@ -241,23 +241,16 @@ static void iopf_handler(struct work_struct *work)
>  {
>  	struct iopf_fault *iopf;
>  	struct iopf_group *group;
> -	struct iommu_domain *domain;
>  	enum iommu_page_response_code status = IOMMU_PAGE_RESP_SUCCESS;
>  
>  	group = container_of(work, struct iopf_group, work);
> -	domain = iommu_get_domain_for_dev_pasid(group->dev,
> -				group->last_fault.fault.prm.pasid, 0);
> -	if (!domain || !domain->iopf_handler)
> -		status = IOMMU_PAGE_RESP_INVALID;
> -
>  	list_for_each_entry(iopf, &group->faults, list) {
>  		/*
>  		 * For the moment, errors are sticky: don't handle subsequent
>  		 * faults in the group if there is an error.
>  		 */
>  		if (status == IOMMU_PAGE_RESP_SUCCESS)
> -			status = domain->iopf_handler(&iopf->fault,
> -						      domain->fault_data);
> +			status = iommu_sva_handle_iopf(&iopf->fault, group->data);
>  	}
>  
>  	iopf_complete_group(group->dev, &group->last_fault, status);
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 157a28a49473..535a36e3edc9 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3330,7 +3330,7 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
>  	domain->type = IOMMU_DOMAIN_SVA;
>  	mmgrab(mm);
>  	domain->mm = mm;
> -	domain->iopf_handler = iommu_sva_handle_iopf;
> +	domain->iopf_handler = iommu_sva_handle_iopf_group;
>  	domain->fault_data = mm;

This also has lifetime problems on the mm.

The domain should flow into the iommu_sva_handle_iopf() instead of the
void *data.

The SVA code can then just use domain->mm directly.

We need to document/figure out some how to ensure that the faults are
all done processing before a fault enabled domain can be freed.

This patch would be better ordered before the prior patch.

Jason
