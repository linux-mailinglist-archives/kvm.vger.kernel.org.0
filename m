Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A89374FD85
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 05:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjGLDN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 23:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjGLDNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 23:13:19 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68F193;
        Tue, 11 Jul 2023 20:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689131597; x=1720667597;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rS7yhv7p+ymForwhUax28XnYNPqA/QaWercDDj/Ioks=;
  b=NMssl0hD2jYm1Gh5gbcRvo3G7+z5ZNnUqMffBG56XrJBBFlCfC+CUjnw
   TQ5FM7cKyJiOuMBnaGUSQ3CT8K1EctBJOiTHeGI5bAp81BGpEi52GeMzF
   CXH+TAG+xIpq2PqvgY6tTF+bh2bZ8Rz07Hrw2IrUcIOlCXk3jB4FiN5e2
   NT16nEkxfUM1bRJqs256pGQlyD89eXUxXYm32vnQ1Ya4Ph5jgdidY1P35
   GbeJK2tsKPqU9Axx4ek0e69SQKYHlUaA5+7mkLRHl1PcOqMP3FBY+dknZ
   L7ARmtpMbQey6xmv1MPC0PPQUtwAxPyAmYEXvseD7zq4hQ4+rWLjGvIdO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="395584217"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="395584217"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:13:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="724708910"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="724708910"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.60]) ([10.252.187.60])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:13:12 -0700
Message-ID: <e26db44c-ec72-085d-13ee-597237ba2134@linux.intel.com>
Date:   Wed, 12 Jul 2023 11:13:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] iommu: Use fault cookie to store iopf_param
Content-Language: en-US
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-10-baolu.lu@linux.intel.com>
 <20230711150249.62917dad@jacob-builder>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230711150249.62917dad@jacob-builder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/12 6:02, Jacob Pan wrote:
> On Tue, 11 Jul 2023 09:06:42 +0800, Lu Baolu<baolu.lu@linux.intel.com>
> wrote:
> 
>> Remove the static iopf_param pointer from struct iommu_fault_param to
>> save memory.
>>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h      |  2 --
>>   drivers/iommu/io-pgfault.c | 47 +++++++++++++++++++++++---------------
>>   2 files changed, 29 insertions(+), 20 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index ffd6fe1317f4..5fe37a7c5a55 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -551,7 +551,6 @@ struct iommu_fault_param {
>>    * struct dev_iommu - Collection of per-device IOMMU data
>>    *
>>    * @fault_param: IOMMU detected device fault reporting data
>> - * @iopf_param:	 I/O Page Fault queue and data
>>    * @fwspec:	 IOMMU fwspec data
>>    * @iommu_dev:	 IOMMU device this device is linked to
>>    * @priv:	 IOMMU Driver private data
>> @@ -564,7 +563,6 @@ struct iommu_fault_param {
>>   struct dev_iommu {
>>   	struct mutex lock;
>>   	struct iommu_fault_param	*fault_param;
>> -	struct iopf_device_param	*iopf_param;
>>   	struct iommu_fwspec		*fwspec;
>>   	struct iommu_device		*iommu_dev;
>>   	void				*priv;
>> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
>> index 1749e0869f2e..6a3a4e08e67e 100644
>> --- a/drivers/iommu/io-pgfault.c
>> +++ b/drivers/iommu/io-pgfault.c
>> @@ -158,7 +158,7 @@ int iommu_queue_iopf(struct iommu_fault *fault,
>> struct device *dev)
>>   	 * As long as we're holding param->lock, the queue can't be
>> unlinked
>>   	 * from the device and therefore cannot disappear.
>>   	 */
>> -	iopf_param = param->iopf_param;
>> +	iopf_param = iommu_get_device_fault_cookie(dev, 0);
> I am not sure I understand how does it know the cookie type is iopf_param
> for PASID 0?
> 
> Between IOPF and IOMMUFD use of the cookie, cookie types are different,
> right?
> 

The fault cookie is managed by the code that delivers or handles the
faults. The sva and IOMMUFD paths are exclusive.

Best regards,
baolu
