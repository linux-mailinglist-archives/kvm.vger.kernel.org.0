Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B987AE379
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 03:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjIZBwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 21:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjIZBwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 21:52:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B195410C;
        Mon, 25 Sep 2023 18:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695693150; x=1727229150;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1lzgIf5/5JMxamee7JJyJ354tZveRK0X+4si66acC4k=;
  b=B3hKsVBGGw85GMDmTi/uNqN31ORClqcy6qm5eizceDGQaASkEDRRzS80
   vXaQ8h1+6izlZrC4cHUoqF+WbZkp2782dV/VsfnVHax8ZWgdg5vhcSvMf
   2hdK0iqufnQ8su5fB+TtmJvf/Qi6X4r+QncQ1XRrLjZXCeA5TcVgDolfN
   M1xrxaf/fDfqsgVPJDcb3tQgmigqejGe6B9hxND8Pe327ttk2VlqD8+Gn
   +1xTWdq1SJ9apI7xnNntYsw5NsFZQXXxQifCwfWkXbPqDgo0oS87X4B1E
   wi9iu9CcXwk6obTTQesTGFGt3TnpmR9wmzQnYEnpizvk9D+6/fqRe64L6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="380324777"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="380324777"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 18:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995629793"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="995629793"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 25 Sep 2023 18:52:26 -0700
Message-ID: <b5d52bd4-7cb7-24b5-72d3-b5018306e352@linux.intel.com>
Date:   Tue, 26 Sep 2023 09:49:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 12/12] iommu: Improve iopf_queue_flush_dev()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-13-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E30109C63D06675042758CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276E30109C63D06675042758CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/25/23 3:00 PM, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Thursday, September 14, 2023 4:57 PM
>> @@ -300,6 +299,7 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
>>   /**
>>    * iopf_queue_flush_dev - Ensure that all queued faults have been
>> processed
>>    * @dev: the endpoint whose faults need to be flushed.
>> + * @pasid: the PASID of the endpoint.
>>    *
>>    * The IOMMU driver calls this before releasing a PASID, to ensure that all
>>    * pending faults for this PASID have been handled, and won't hit the
>> address
> 
> the comment should be updated too.

Yes.

     ... pending faults for this PASID have been handled or dropped ...

> 
>> @@ -309,17 +309,53 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
>>    *
>>    * Return: 0 on success and <0 on error.
>>    */
>> -int iopf_queue_flush_dev(struct device *dev)
>> +int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid)
> 
> iopf_queue_flush_dev_pasid()?
> 
>>   {
>>   	struct iommu_fault_param *iopf_param =
>> iopf_get_dev_fault_param(dev);
>> +	const struct iommu_ops *ops = dev_iommu_ops(dev);
>> +	struct iommu_page_response resp;
>> +	struct iopf_fault *iopf, *next;
>> +	int ret = 0;
>>
>>   	if (!iopf_param)
>>   		return -ENODEV;
>>
>>   	flush_workqueue(iopf_param->queue->wq);
>> +
>> +	mutex_lock(&iopf_param->lock);
>> +	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
>> +		if (!(iopf->fault.prm.flags &
>> IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
>> +		    iopf->fault.prm.pasid != pasid)
>> +			break;
>> +
>> +		list_del(&iopf->list);
>> +		kfree(iopf);
>> +	}
>> +
>> +	list_for_each_entry_safe(iopf, next, &iopf_param->faults, list) {
>> +		if (!(iopf->fault.prm.flags &
>> IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
>> +		    iopf->fault.prm.pasid != pasid)
>> +			continue;
>> +
>> +		memset(&resp, 0, sizeof(struct iommu_page_response));
>> +		resp.pasid = iopf->fault.prm.pasid;
>> +		resp.grpid = iopf->fault.prm.grpid;
>> +		resp.code = IOMMU_PAGE_RESP_INVALID;
>> +
>> +		if (iopf->fault.prm.flags &
>> IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
>> +			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
>> +
>> +		ret = ops->page_response(dev, iopf, &resp);
>> +		if (ret)
>> +			break;
>> +
>> +		list_del(&iopf->list);
>> +		kfree(iopf);
>> +	}
>> +	mutex_unlock(&iopf_param->lock);
>>   	iopf_put_dev_fault_param(iopf_param);
>>
>> -	return 0;
>> +	return ret;
>>   }
> 
> Is it more accurate to call this function as iopf_queue_drop_dev_pasid()?
> The added logic essentially implies that the caller doesn't care about
> responses and all the in-fly states are either flushed (request) or
> abandoned (response).
> 
> A normal flush() helper usually means just the flush action. If there is
> a need to wait for responses after flush then we could add a
> flush_dev_pasid_wait_timeout() later when there is a demand...

Fair enough.

As my understanding, "flush" means "handling the pending i/o page faults
immediately and wait until everything is done". Here what the caller
wants is "I have completed using this pasid, discard all the pending
requests by responding an INVALID result so that this PASID could be
reused".

If this holds, how about iopf_queue_discard_dev_pasid()? It matches the
existing iopf_queue_discard_partial().

Best regards,
baolu
