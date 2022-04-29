Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EE3515927
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 01:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbiD2XzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 19:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239881AbiD2XzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 19:55:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00DF2B1BC
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 16:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651276307; x=1682812307;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9sesrm2gYifuyn6d/cuWZ/1m6KGJBn/VDXU17Jgc6ws=;
  b=YwEYo1YdD3UmYrwm5wWJimyYC/WZcO0BfeNVOAZbvPJw4Xke+lyViWNA
   in4Y97U0FOlBLpfpAv90CppFguE+Ys00tv05qgdb80+V+VPDVnKn2yLbs
   rnzPM90fcMtu3KjrwmnjHA/pYZRNlRDbmC0nYEINFOtHI2o9edSq1JsrJ
   l/w8+fxHCyjELBPkdYLFTRBFemRTcxDYJF9+kaC4lte6izrJ9IzxcQ8t7
   1uS59fIoXidz8Mdc1VrVny60/E7rum+McmeRmLGS7PBA/15JuasCFxQ/W
   ephHIJg7axYv8itsQuOMwaliAZDm59RimQlKujTHK4DvAWwOWmC9geO6d
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="291976189"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="291976189"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 16:51:47 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="582480232"
Received: from aliu1-mobl.ccr.corp.intel.com (HELO [10.255.30.71]) ([10.255.30.71])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 16:51:43 -0700
Message-ID: <0e2b2a3f-1fbd-ff81-d846-eb7091de53e8@linux.intel.com>
Date:   Sat, 30 Apr 2022 07:51:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 02/19] iommufd: Dirty tracking for io_pagetable
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-3-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220428210933.3583-3-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/29 05:09, Joao Martins wrote:
> +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
> +			    struct iommu_domain *domain, bool enable)
> +{
> +	struct iommu_domain *dom;
> +	unsigned long index;
> +	int ret = -EOPNOTSUPP;
> +
> +	down_write(&iopt->iova_rwsem);
> +	if (!domain) {
> +		down_write(&iopt->domains_rwsem);
> +		xa_for_each(&iopt->domains, index, dom) {
> +			ret = iommu_set_dirty_tracking(dom, iopt, enable);
> +			if (ret < 0)
> +				break;

Do you need to roll back to the original state before return failure?
Partial domains have already had dirty bit tracking enabled.

> +		}
> +		up_write(&iopt->domains_rwsem);
> +	} else {
> +		ret = iommu_set_dirty_tracking(domain, iopt, enable);
> +	}
> +
> +	up_write(&iopt->iova_rwsem);
> +	return ret;
> +}

Best regards,
baolu
