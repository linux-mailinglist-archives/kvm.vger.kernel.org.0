Return-Path: <kvm+bounces-4141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B004280E3BE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:22:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B71D282D85
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 05:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEC513FFE;
	Tue, 12 Dec 2023 05:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmUCJP2i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028CECE;
	Mon, 11 Dec 2023 21:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702358551; x=1733894551;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vBcOqMVGmk5DzvYxiQ5N9EnkBoAt4mO+G28rTQngrAU=;
  b=XmUCJP2iv9Ngmz8X2E2XQZLgQciHI0bnlMmJGRcU2zxPmiZmVJu3NNFD
   BBKyd3GiwSv8rdma3ALo8ALpXi1XcVjm3Yp+sg0ZU8D2FrRJzQIU5ObVF
   HbrrWMD+/n8MsYg6KDJFCSQ4R6IL9KryrjC4G62duUV0zgfIbnNZjZn6M
   7hYekLuhwsOI6OoaBEJuV/WKjmpMXIdyoe4OcKpoRUUXwXXX07Z+j4RF6
   Xi/VyHTCzGpfwprMrWqsxlMIrgyZguFhED/No/wBDGspCoxB7TsmN/m/K
   IPvPwgmJ0Ltmt5ojjp9YAfHhChml5/8yp+f8OX1BwARRtkvcQhF8T7lV1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="480952860"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="480952860"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 21:22:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="773388115"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="773388115"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga002.jf.intel.com with ESMTP; 11 Dec 2023 21:22:26 -0800
Message-ID: <416b6639-8904-4b31-973c-d5522e2731d8@linux.intel.com>
Date: Tue, 12 Dec 2023 13:17:47 +0800
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
Content-Transfer-Encoding: 8bit

On 12/11/23 11:24 PM, Jason Gunthorpe wrote:
> Also iopf_queue_remove_device() is messed up - it returns an error
> code but nothing ever does anything with it 🙁 Remove functions like
> this should never fail.

Yes, agreed.

> 
> Removal should be like I explained earlier:
>   - Disable new PRI reception

This could be done by

	rcu_assign_pointer(param->fault_param, NULL);

?

>   - Ack all outstanding PRQ to the device

All outstanding page requests are responded with
IOMMU_PAGE_RESP_INVALID, indicating that device should not attempt any
retry.

>   - Disable PRI on the device
>   - Tear down the iopf infrastructure
> 
> So under this model if the iopf_queue_remove_device() has been called
> it should be sort of a 'disassociate' action where fault_param is
> still floating out there but iommu_page_response() does nothing.

Yes. All pending requests have been auto-responded.

> IOW pass the refcount from the iommu_report_device_fault() down into
> the fault handler, into the work and then into iommu_page_response()
> which will ultimately put it back.

Yes.

Best regards,
baolu

