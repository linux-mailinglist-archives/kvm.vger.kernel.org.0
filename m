Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B31C7894A1
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 10:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjHZIEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Aug 2023 04:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjHZID6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Aug 2023 04:03:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244F810EF;
        Sat, 26 Aug 2023 01:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693037036; x=1724573036;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4WuaqgVS84ILp+nQYZ24EIA/OW8M4Tg/kexsQpfKmwQ=;
  b=fZ02nuhqNT6Q7966UoMZFAYWZLtVE0RdMFlzvZ6Sww6Sox5+NwrJg17J
   qy08vJcupCJ3MacL3gtDCYntDEJnxIRmV0WCPKQTTafXvWr2u9UM2pcG5
   QEiKPjt+j2MnBRkFzBuRh2/OisBbT0mfaRJrWH+9jmwviZDREpGrwrzwV
   ASrz+oYEVTF61u2taBXgug22qR+DwgvXut/dgt7eyV+udc2b7zkFripmM
   FtX/O8asCmPwSvsRTDtzVTYv3qZ+qLvgZjs6HGBUI9jkIU2JbFGvt2dZ+
   cGPZHQr/LVBcmx1VBTtEGCRUgLFrgyGMaC0HOmxXRZeA/GPukZ6rkRotO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="355190948"
X-IronPort-AV: E=Sophos;i="6.02,203,1688454000"; 
   d="scan'208";a="355190948"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2023 01:03:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="767153317"
X-IronPort-AV: E=Sophos;i="6.02,203,1688454000"; 
   d="scan'208";a="767153317"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga008.jf.intel.com with ESMTP; 26 Aug 2023 01:03:52 -0700
Message-ID: <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
Date:   Sat, 26 Aug 2023 16:01:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 4:17 PM, Tian, Kevin wrote:
>> +
>>   /**
>>    * iopf_queue_flush_dev - Ensure that all queued faults have been
>> processed
>>    * @dev: the endpoint whose faults need to be flushed.
> Presumably we also need a flush callback per domain given now
> the use of workqueue is optional then flush_workqueue() might
> not be sufficient.
> 

The iopf_queue_flush_dev() function flushes all pending faults from the
IOMMU queue for a specific device. It has no means to flush fault queues
out of iommu core.

The iopf_queue_flush_dev() function is typically called when a domain is
detaching from a PASID. Hence it's necessary to flush the pending faults
from top to bottom. For example, iommufd should flush pending faults in
its fault queues after detaching the domain from the pasid.

The fault_param->lock mutex is sufficient to avoid the race condition if
the workqueue is not used. However, if the workqueue is used, then it is
possible for a workqueue thread to be in the middle of delivering a
fault while the fault queue is being flushed.

Best regards,
baolu
