Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8EB782F26
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 19:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbjHURLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 13:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjHURLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 13:11:25 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2FCEC
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:11:23 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-76dafe9574bso17645885a.1
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1692637882; x=1693242682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DZQ59N6at0zbBieDZtWXJGjAejF7XYSgNeSZUJ/Ek3E=;
        b=bubdLBZKqa22OI94f2vUw7HIQe/Y1oDy1YGiTPGnDEt0ni7Wg3SYPyx9VnV4TQl4mC
         5u1Isb3wLJvyvzaNiPRKBwB/rjlmKWaP2jDgo34bOYjZFArDuZKTgHSio/FMXF0NFcg6
         oFJQtbcxtZiS/uXRI4mkdubJdvc8ZSagJ8p7cAzMsEfD2O4+Us96+ou6Yk9H1B7JGsHT
         M0rc0OJedwzh0O5dJ0NV9n/dp4hzlb7Igc0DeWWbZQcePuRlLPhXiR7VAws0hxlfmWfT
         0EUpJXDi2oje6rv6/RU7tpijdtWYqM4NZn5XjK1JxftkgC+5h5La27n7qTjvkhZ6gdjr
         +WhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692637882; x=1693242682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZQ59N6at0zbBieDZtWXJGjAejF7XYSgNeSZUJ/Ek3E=;
        b=HpFrrLMfkzf0lpLW+17CEzzxCDhCCqmceqgIkK5BTg7bhaVg7sMihNmT8ocVrN8f3N
         485MzFsLOM81y1KksWyjuF6asp3CoDhjESI+hUNd06dhdgFaWSZygl7yTLS0PHBYzVOc
         dxbl48q94DjWpmVv1JBsS+r031dG9Ce4MLR7AgtjFkz1yVvXTNJHzMiN12lZolzqz6dC
         erPRstqX1RhtOeI1qgV+RwNEJtnmCVWS+0ks+/uhPG5mPDt4s7VZPXwKqd0L3joi6OQD
         vYa2us2znxasOUglWUhHEI0yJCziFXV3Vos8H+QHdiIH/Iyl4R3YEtPHjYvDFM02OHCo
         gD7g==
X-Gm-Message-State: AOJu0YzsTNNdbmtWoacpRJGA7h1q52sV6fk8T7vxe5Ldk4gXYAM7dQEN
        cn98lz9FvRa/Zaq298dkDuDIMg==
X-Google-Smtp-Source: AGHT+IH+ma5zsrikDgBqZbfg/lBTwpLwrxV8rmHy0wDGJg7fciff2u7AqewHPoadTAmit1jAmacP2Q==
X-Received: by 2002:a05:620a:1026:b0:76c:c90d:2eef with SMTP id a6-20020a05620a102600b0076cc90d2eefmr8357328qkk.42.1692637882428;
        Mon, 21 Aug 2023 10:11:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id c8-20020a05620a134800b0076dae4753efsm274426qkl.14.2023.08.21.10.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 10:11:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qY8Qz-00DvG9-DQ;
        Mon, 21 Aug 2023 14:11:21 -0300
Date:   Mon, 21 Aug 2023 14:11:21 -0300
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
Subject: Re: [PATCH v3 09/11] iommu: Make iommu_queue_iopf() more generic
Message-ID: <ZOOauSJpcE2YgIzG@ziepe.ca>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
 <20230817234047.195194-10-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817234047.195194-10-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 07:40:45AM +0800, Lu Baolu wrote:
> This completely separates the IO page fault handling framework from the
> SVA implementation. Previously, the SVA implementation was tightly coupled
> with the IO page fault handling framework. This makes SVA a "customer" of
> the IO page fault handling framework by converting domain's page fault
> handler to handle a group of faults and calling it directly from
> iommu_queue_iopf().
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h      |  5 +++--
>  drivers/iommu/iommu-sva.h  |  8 --------
>  drivers/iommu/io-pgfault.c | 16 +++++++++++++---
>  drivers/iommu/iommu-sva.c  | 14 ++++----------
>  drivers/iommu/iommu.c      |  4 ++--
>  5 files changed, 22 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index ff292eea9d31..cf1cb0bb46af 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -41,6 +41,7 @@ struct iommu_sva;
>  struct iommu_fault_event;
>  struct iommu_dma_cookie;
>  struct iopf_queue;
> +struct iopf_group;
>  
>  #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
>  #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> @@ -175,8 +176,7 @@ struct iommu_domain {
>  	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
>  	struct iommu_domain_geometry geometry;
>  	struct iommu_dma_cookie *iova_cookie;
> -	enum iommu_page_response_code (*iopf_handler)(struct iommu_fault *fault,
> -						      void *data);
> +	int (*iopf_handler)(struct iopf_group *group);
>  	void *fault_data;
>  	union {
>  		struct {
> @@ -526,6 +526,7 @@ struct iopf_group {
>  	struct list_head		faults;
>  	struct work_struct		work;
>  	struct device			*dev;
> +	void				*data;
>  };
>  
>  int iommu_device_register(struct iommu_device *iommu,
> diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
> index 510a7df23fba..cf41e88fac17 100644
> --- a/drivers/iommu/iommu-sva.h
> +++ b/drivers/iommu/iommu-sva.h
> @@ -22,8 +22,6 @@ int iopf_queue_flush_dev(struct device *dev);
>  struct iopf_queue *iopf_queue_alloc(const char *name);
>  void iopf_queue_free(struct iopf_queue *queue);
>  int iopf_queue_discard_partial(struct iopf_queue *queue);
> -enum iommu_page_response_code
> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
>  void iopf_free_group(struct iopf_group *group);
>  int iopf_queue_work(struct iopf_group *group, work_func_t func);
>  int iommu_sva_handle_iopf_group(struct iopf_group *group);
> @@ -65,12 +63,6 @@ static inline int iopf_queue_discard_partial(struct iopf_queue *queue)
>  	return -ENODEV;
>  }
>  
> -static inline enum iommu_page_response_code
> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
> -{
> -	return IOMMU_PAGE_RESP_INVALID;
> -}
> -
>  static inline void iopf_free_group(struct iopf_group *group)
>  {
>  }
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index 00c2e447b740..a61c2aabd1b8 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -11,8 +11,6 @@
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
>  
> -#include "iommu-sva.h"
> -
>  /**
>   * struct iopf_queue - IO Page Fault queue
>   * @wq: the fault workqueue
> @@ -93,6 +91,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>  {
>  	int ret;
>  	struct iopf_group *group;
> +	struct iommu_domain *domain;
>  	struct iopf_fault *iopf, *next;
>  	struct iommu_fault_param *iopf_param;
>  	struct dev_iommu *param = dev->iommu;
> @@ -124,6 +123,16 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>  		return 0;
>  	}
>  
> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
> +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
> +	else
> +		domain = iommu_get_domain_for_dev(dev);
> +
> +	if (!domain || !domain->iopf_handler) {
> +		ret = -ENODEV;
> +		goto cleanup_partial;
> +	}
> +
>  	group = kzalloc(sizeof(*group), GFP_KERNEL);
>  	if (!group) {
>  		/*
> @@ -137,6 +146,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>  
>  	group->dev = dev;
>  	group->last_fault.fault = *fault;
> +	group->data = domain->fault_data;
>  	INIT_LIST_HEAD(&group->faults);
>  	list_add(&group->last_fault.list, &group->faults);
>  
> @@ -147,7 +157,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>  			list_move(&iopf->list, &group->faults);
>  	}
>  
> -	ret = iommu_sva_handle_iopf_group(group);
> +	ret = domain->iopf_handler(group);
>  	if (ret)
>  		iopf_free_group(group);
>  
> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> index df8734b6ec00..2811f34947ab 100644
> --- a/drivers/iommu/iommu-sva.c
> +++ b/drivers/iommu/iommu-sva.c
> @@ -148,13 +148,14 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
>  /*
>   * I/O page fault handler for SVA
>   */
> -enum iommu_page_response_code
> +static enum iommu_page_response_code
>  iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
>  {
>  	vm_fault_t ret;
>  	struct vm_area_struct *vma;
> -	struct mm_struct *mm = data;
>  	unsigned int access_flags = 0;
> +	struct iommu_domain *domain = data;
> +	struct mm_struct *mm = domain->mm;
>  	unsigned int fault_flags = FAULT_FLAG_REMOTE;
>  	struct iommu_fault_page_request *prm = &fault->prm;
>  	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
> @@ -231,23 +232,16 @@ static void iommu_sva_iopf_handler(struct work_struct *work)
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
>  	iommu_sva_complete_iopf(group->dev, &group->last_fault, status);
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index b280b9f4d8b4..9b622088c741 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3395,8 +3395,8 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
>  	domain->type = IOMMU_DOMAIN_SVA;
>  	mmgrab(mm);
>  	domain->mm = mm;
> -	domain->iopf_handler = iommu_sva_handle_iopf;
> -	domain->fault_data = mm;
> +	domain->iopf_handler = iommu_sva_handle_iopf_group;
> +	domain->fault_data = domain;

Why fault_data? The domain handling the fault should be passed
through naturally without relying on fault_data.

eg make 

  iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)

into
  iommu_sva_handle_iopf(struct iommu_fault *fault, struct iommu_domain *domain)

And delete domain->fault_data until we have some use for it.

The core code should be keeping track of the iommu_domain lifetime.

Jason
