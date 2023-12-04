Return-Path: <kvm+bounces-3286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA02C802A9A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 04:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B8C1B208A0
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 03:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916D64680;
	Mon,  4 Dec 2023 03:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="acvkaiZM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D211B6;
	Sun,  3 Dec 2023 19:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701661870; x=1733197870;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x6EE+AhGPhDn7GdBQS0cdPrBG4VIAC2IhVhjOkZ66cc=;
  b=acvkaiZMPhA22jq7pPg1G9w+4PbXE1Upx0BwrcT6jHHBNEe6VYk6luU8
   R+ps/zUJ2V7ylfRlZn3Tjc/RzawdnNvGOK+X1W4nf61R0fVKE0yGBvcAM
   9AJDF4nElkkcBFFemb3kqo124c9x2hCTsyCq8N6duHNVSkRF4HCTT/Th7
   dXrFWcPcJFUcEREL0SHUjEgPsBRqSG1B8y+1Uxq1QUS8LQTu12rkWYXcA
   u3xC65hPmDnD7HL/OQcPHbjBzEiimEp9xmFnHM070CPcTBpRJekx3sXr8
   Z2sgjKAEEvn8JjYsinuhPd2kUefWIXRqx+5tMo7+EBAM43h8+DJWBX2Gk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="397566700"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="397566700"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2023 19:51:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10913"; a="836447404"
X-IronPort-AV: E=Sophos;i="6.04,248,1695711600"; 
   d="scan'208";a="836447404"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga008.fm.intel.com with ESMTP; 03 Dec 2023 19:51:05 -0800
Message-ID: <93a57e63-352c-407c-ac3f-4b91c11d925d@linux.intel.com>
Date: Mon, 4 Dec 2023 11:46:30 +0800
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
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231201203536.GG1489931@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/2/23 4:35 AM, Jason Gunthorpe wrote:
> I'm looking at this code after these patches are applied and it still
> seems quite bonkers to me 🙁
> 
> Why do we allocate two copies of the memory on all fault paths?
> 
> Why do we have fault->type still that only has one value?
> 
> What is serializing iommu_get_domain_for_dev_pasid() in the fault
> path? It looks sort of like the plan is to use iopf_param->lock and
> ensure domain removal grabs that lock at least after the xarray is
> changed - but does that actually happen?
> 
> I would suggest, broadly, a flow for iommu_report_device_fault() sort
> of:
> 
> 1) Allocate memory for the evt. Every path except errors needs this,
>     so just do it
> 2) iopf_get_dev_fault_param() should not have locks in it! This is
>     fast path now. Use a refcount, atomic compare exchange to allocate,
>     and RCU free.
> 3) Everything runs under the fault_param->lock
> 4) Check if !IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE, set it aside and then
>     exit! This logic is really tortured and confusing
> 5) Allocate memory and assemble the group
> 6) Obtain the domain for this group and incr a per-domain counter that a
>     fault is pending on that domain
> 7) Put the*group*  into the WQ. Put the*group*  on a list in fault_param
>     instead of the individual faults
> 8) Don't linear search a linked list in iommu_page_response()! Pass
>     the group in that we got from the WQ that we*know*  is still
>     active. Ack that passed group.
> 
> When freeing a domain wait for the per-domain counter to go to
> zero. This ensures that the WQ is flushed out and all the outside
> domain references are gone.
> 
> When wanting to turn off PRI make sure a non-PRI domain is
> attached to everything. Fence against the HW's event queue. No new
> iommu_report_device_fault() is possible.
> 
> Lock the fault_param->lock and go through every pending group and
> respond it. Mark the group memory as invalid so iommu_page_response()
> NOP's it. Unlock, fence the HW against queued responses, and turn off
> PRI.
> 
> An*optimization*  would be to lightly flush the domain when changing
> the translation. Lock the fault_param->lock and look for groups in the
> list with old_domain.  Do the same as for PRI-off: respond to the
> group, mark it as NOP. The WQ may still be chewing on something so the
> domain free still has to check and wait.

Very appreciated for all the ideas. I looked through the items and felt
that all these are good optimizations.

I am wondering whether we can take patch 1/12 ~ 10/12 of this series as
a first step, a refactoring effort to support delivering iopf to
userspace? I will follow up with one or multiple series to add the
optimizations.

Does this work for you? Or, you want to take any of above as the
requirement for iommufd use case?

Best regards,
baolu

