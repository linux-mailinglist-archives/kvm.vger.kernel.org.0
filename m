Return-Path: <kvm+bounces-4142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6081D80E3CD
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:28:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ABB2B21A42
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 05:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CE514A8B;
	Tue, 12 Dec 2023 05:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gEBhMSHc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9790A2;
	Mon, 11 Dec 2023 21:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702358891; x=1733894891;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LCn4/xvODPorX9mTjeGLTue7GovKBlpADEjiJxDVln0=;
  b=gEBhMSHcFEskrkVLKBhzyoQ267f3votmpnQDy6DEj2U23I1T2Fv6LJ/A
   Cj0COUBJxY6RujJ4NZIQGo9lGpsJXdzm3EeMAU5XSiWJfHfqgSnMtdZWL
   843Y3GJZJ0kP8xsi74ijF8WoVoo+bCwH6Auh9LjjAbh7cgcApk78Zm11W
   FmcHShbZbIEK006s3BxcdCekX0CACl0O5yjK3mnmZBSTBnKydZvtqlxwd
   nDsvE07lnTllTUQLhU8UxilOS/3O6GA+UIK8TYtQIvDy424Fe0yljPJOF
   H6J+UBp3pkvHtsx5o4Xh33V446krrGWyKOhSKOgrIec4i2UL9ZNZV7NHf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="393626925"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="393626925"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 21:28:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="807612687"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="807612687"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga001.jf.intel.com with ESMTP; 11 Dec 2023 21:28:07 -0800
Message-ID: <d95e9104-e518-4aa5-8dd8-b6b7fd2294b6@linux.intel.com>
Date: Tue, 12 Dec 2023 13:23:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 12/12] iommu: Use refcount for fault data access
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
 <20231207064308.313316-13-baolu.lu@linux.intel.com>
 <20231211152456.GB1489931@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231211152456.GB1489931@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:24 PM, Jason Gunthorpe wrote:
>> @@ -282,22 +313,15 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
>>    */
>>   int iopf_queue_flush_dev(struct device *dev)
>>   {
>> -	int ret = 0;
>> -	struct iommu_fault_param *iopf_param;
>> -	struct dev_iommu *param = dev->iommu;
>> +	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(dev);
>>   
>> -	if (!param)
>> +	if (!iopf_param)
>>   		return -ENODEV;
> And this also seems unnecessary, it is a bug to call this after
> iopf_queue_remove_device() right? Just

Yes. They both are called from the iommu driver. The iommu driver should
guarantee this.

> rcu_derefernce(param->fault_param, true) and WARN_ON NULL.

Okay, sure.

Best regards,
baolu

