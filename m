Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3981374FCF1
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 04:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjGLCHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 22:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjGLCHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 22:07:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B06A171C;
        Tue, 11 Jul 2023 19:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689127653; x=1720663653;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1AER/hg4m6eo8bpLKQWJXN55oUrvESYpTdy5+jXJsMI=;
  b=ST7UctAihefb1hJ4VsZnf/Mam0+CAlDAOonk/ZEFnCRLhgcOLKXalE7N
   Ak5rXdfeYxS2zF18mAGWGqi23inDMafH1pSwdP/BJdpIUxWo8EW88+ukn
   voxIQyj36E5JMPoTHgvATKVi7KYbsHRrXK699uNHz2w92ApSpgI3rC2UT
   sft33Yp0WRIm39WDsEOjxpHj7XHdap3+nIWCC7DoPs/4A8qvht42bMxKM
   8JCTYN0p8ioPMrYUyWHWvDYw1vz1mf9s3pvYt/2j78BKWPq2dAFjHtTBp
   kgiceyPa7VQfmtwk0BXW2vAiRiLl329wmBJj95pvu+/90TjJrzdLlwGLe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="363644174"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="363644174"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:07:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="721324056"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="721324056"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.60]) ([10.252.187.60])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:07:26 -0700
Message-ID: <38c31fb0-1068-4855-c896-27d6a2bca747@linux.intel.com>
Date:   Wed, 12 Jul 2023 10:07:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] iommu: Move iommu fault data to linux/iommu.h
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276859ED6825C0A496C9C5E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276859ED6825C0A496C9C5E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/11 14:05, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, July 11, 2023 9:07 AM
>> +
>> +enum iommu_fault_reason {
>> +	IOMMU_FAULT_REASON_UNKNOWN = 0,
>> +
>> +	/* Could not access the PASID table (fetch caused external abort) */
>> +	IOMMU_FAULT_REASON_PASID_FETCH,
>> +
>> +	/* PASID entry is invalid or has configuration errors */
>> +	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
>> +
>> +	/*
>> +	 * PASID is out of range (e.g. exceeds the maximum PASID
>> +	 * supported by the IOMMU) or disabled.
>> +	 */
>> +	IOMMU_FAULT_REASON_PASID_INVALID,
>> +
>> +	/*
>> +	 * An external abort occurred fetching (or updating) a translation
>> +	 * table descriptor
>> +	 */
>> +	IOMMU_FAULT_REASON_WALK_EABT,
>> +
>> +	/*
>> +	 * Could not access the page table entry (Bad address),
>> +	 * actual translation fault
>> +	 */
>> +	IOMMU_FAULT_REASON_PTE_FETCH,
>> +
>> +	/* Protection flag check failed */
>> +	IOMMU_FAULT_REASON_PERMISSION,
>> +
>> +	/* access flag check failed */
>> +	IOMMU_FAULT_REASON_ACCESS,
>> +
>> +	/* Output address of a translation stage caused Address Size fault */
>> +	IOMMU_FAULT_REASON_OOR_ADDRESS,
>> +};
>> +
>> +/**
>> + * struct iommu_fault_unrecoverable - Unrecoverable fault data
>> + * @reason: reason of the fault, from &enum iommu_fault_reason
>> + * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
>> + * @pasid: Process Address Space ID
>> + * @perm: requested permission access using by the incoming transaction
>> + *        (IOMMU_FAULT_PERM_* values)
>> + * @addr: offending page address
>> + * @fetch_addr: address that caused a fetch abort, if any
>> + */
>> +struct iommu_fault_unrecoverable {
>> +	__u32	reason;
>> +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
>> +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
>> +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
>> +	__u32	flags;
>> +	__u32	pasid;
>> +	__u32	perm;
>> +	__u64	addr;
>> +	__u64	fetch_addr;
>> +};
> 
> Currently there is no handler for unrecoverable faults.
> 
> Both Intel/ARM register iommu_queue_iopf() as the device fault handler.
> It returns -EOPNOTSUPP for unrecoverable faults.
> 
> In your series the common iommu_handle_io_pgfault() also only works
> for PRQ.
> 
> It kinds of suggest above definitions are dead code, though arm-smmu-v3
> does attempt to set them.
> 
> Probably it's right time to remove them.
> 
> In the future even if there might be a need of forwarding unrecoverable
> faults to the user via iommufd, fault reasons reported by the physical
> IOMMU doesn't make any sense to the guest. Presumably the vIOMMU
> should walk guest configurations to set a fault reason which makes sense
> from guest p.o.v.

I am fine to remove unrecoverable faults data. But it was added by Jean,
so I'd like to know his opinion on this.

Best regards,
baolu

