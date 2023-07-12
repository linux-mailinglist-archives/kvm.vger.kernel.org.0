Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631AF74FD74
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 05:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjGLDJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 23:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjGLDJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 23:09:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC141739;
        Tue, 11 Jul 2023 20:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689131377; x=1720667377;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EqeRPqMBCcZNqe+1FF45GoQNtxIV6ORKDRV/drrKLWg=;
  b=iR9VlQRGGAwT5jlDylEOLg81ms1QnISmq8EHklyWGtBLLOY9bs7Y8P4B
   PYPCoyo3VKUFy1tLsNo8/pINTm9d9LTa5cIHKfdOHE4x6pfTmXkG/GdAQ
   B88THjqCxRWJqZozPta2u8Ldy1fBQ0DPBwhz5Yrs+3Krezgq8GkBNn7bY
   nouuxWduE/OjsGH/5ZiKJnMZ0IhX5ZUrdZkcu3S79L0W6nTq8wpg1LRDt
   gje3bBGyXknbXpBs5Jk7lpXPFN7bu01Cleh4pShQTuUbxQ6aMwFOmD7E/
   Ax357GGxyWgzR8+R8n3YO0UOMeF+pznVwnFPCZ2JRZZdzDr9ge4Es3F7f
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="395583651"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="395583651"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:09:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="724708414"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="724708414"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.60]) ([10.252.187.60])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:09:27 -0700
Message-ID: <ba68a3e3-da28-969e-2ef2-86fd1706dad4@linux.intel.com>
Date:   Wed, 12 Jul 2023 11:09:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] iommu: Use fault cookie to store iopf_param
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-10-baolu.lu@linux.intel.com>
 <BN9PR11MB5276454AD26C2BDC12CAEDE78C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276454AD26C2BDC12CAEDE78C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On 2023/7/11 14:26, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, July 11, 2023 9:07 AM
>>
>> Remove the static iopf_param pointer from struct iommu_fault_param to
>> save memory.
> 
> why is there memory saving? you replace a single pointer with a xarray now...

iopf_param is duplicate with the fault cookie. So replace it with the
fault cookie to remove duplication and save memory.

> 
>> @@ -303,16 +303,27 @@ int iopf_queue_add_device(struct iopf_queue
>> *queue, struct device *dev)
>>
>>   	mutex_lock(&queue->lock);
>>   	mutex_lock(&param->lock);
>> -	if (!param->iopf_param) {
>> -		list_add(&iopf_param->queue_list, &queue->devices);
>> -		param->iopf_param = iopf_param;
>> -		ret = 0;
>> +	curr = iommu_set_device_fault_cookie(dev, 0, iopf_param);
>> +	if (IS_ERR(curr)) {
>> +		ret = PTR_ERR(curr);
>> +		goto err_free;
>>   	}
> 
> So although the new xarray is called a per-pasid storage, here only
> slot#0 is used for sva which includes a list containing partial req's
> for many pasid's. It doesn't sound clean...

Just to make it generic so that IOMMUFD can also use it. IOMMUFD will
use it to store the per-{device, pasid} object id (and possibly other
data) so that it can be quickly retrieved in the critical fault
delivering patch.

Best regards,
baolu
