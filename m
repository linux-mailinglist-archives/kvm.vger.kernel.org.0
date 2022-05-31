Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B5A539071
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 14:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344140AbiEaMQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 08:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243140AbiEaMP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 08:15:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21647986FF
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 05:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653999359; x=1685535359;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hNAiQ7gwO4WzGADus3ttqXuH+fpzFCczEESmD6y6uic=;
  b=ERV5t2msuyG6jDDmy1t0MkONKb2OiC96N3gZ3fGgK1MQVQhqT+oqvM4T
   RNJhxcL6E5xmkkHwELDTa9+4xWe3zDb/06AxSDjb1WDON69DfUK1V5fQa
   7nRDyoq/SK1Ug8HN7szj+u2gl+hQq+AjikDaQELDSIxWzgbltr7bYuqE6
   Q4+scTAT1cYAyKFnDILWTiR8+XrH8Mwj2UOO4MjOo9Gbix4tVo1eeb8fG
   n03b/2iLQW3KuPAi6S98JPxt+SLx1VmYzSZ6G+pmphhEAZEzDxhxqX719
   H4DL8jHELPepv8NQ6JBjZNDn4hmziC+gsF/VowD1dlX3shZB4zh/zMWgx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="335894840"
X-IronPort-AV: E=Sophos;i="5.91,265,1647327600"; 
   d="scan'208";a="335894840"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 05:15:58 -0700
X-IronPort-AV: E=Sophos;i="5.91,265,1647327600"; 
   d="scan'208";a="706548125"
Received: from xingzhen-mobl.ccr.corp.intel.com (HELO [10.249.170.74]) ([10.249.170.74])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 05:15:54 -0700
Message-ID: <2532cb21-5fc9-57b9-82f6-69a7577ffe4a@linux.intel.com>
Date:   Tue, 31 May 2022 20:15:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH RFC 09/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        iommu@lists.linux-foundation.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-10-joao.m.martins@oracle.com>
 <efd6a8ac-413c-f39e-e566-bb317ed77ac4@amd.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <efd6a8ac-413c-f39e-e566-bb317ed77ac4@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suravee ,

On 2022/5/31 19:34, Suravee Suthikulpanit wrote:
> On 4/29/22 4:09 AM, Joao Martins wrote:
>> .....
>> +static int amd_iommu_set_dirty_tracking(struct iommu_domain *domain,
>> +                    bool enable)
>> +{
>> +    struct protection_domain *pdomain = to_pdomain(domain);
>> +    struct iommu_dev_data *dev_data;
>> +    bool dom_flush = false;
>> +
>> +    if (!amd_iommu_had_support)
>> +        return -EOPNOTSUPP;
>> +
>> +    list_for_each_entry(dev_data, &pdomain->dev_list, list) {
> 
> Since we iterate through device list for the domain, we would need to
> call spin_lock_irqsave(&pdomain->lock, flags) here.

Not related, just out of curiosity. Does it really need to disable the
interrupt while holding this lock? Any case this list would be traversed
in any interrupt context? Perhaps I missed anything?

Best regards,
baolu
