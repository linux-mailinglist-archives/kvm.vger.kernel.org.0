Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD8F562C03
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 08:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiGAGxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 02:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiGAGx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 02:53:29 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBB143EF3;
        Thu, 30 Jun 2022 23:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656658408; x=1688194408;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lT6Q657TSg/9MG9w0C8hYZ86wxuoFIRctv6pNkUIO7Y=;
  b=Gz9bDxP0Epw1jfCk/mYZiEbSAWhCrsKJJFh9H9x0YXtoGNhof3oBWX6u
   XjbolSmHi5uWx0U6PbacsQuRVVZEBHwf7vEhcLv0EHwZQ9yGPmMYbqjR7
   xhG7PTDHU6llXIO9BMxqg1ZSSj3Jd9MLIoaGepGFURvMxKyf/mtibgn7m
   THf/aZTk1BZ965DyiCGgFD8FIEjhg32OQuyxAng4IGxlc0lUdN4Sq2/K/
   tm4iY8Y3/BDYbwuenBTNme4JpWAbpom5Pg1w38S7MrQoCR9H/l/hZ6gb7
   QpiIpUYOLofM7RE0/VfQRihtV5FfJtiQ9E++etGn34gMxmiuLxttG3ouK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="283303601"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="283303601"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 23:53:28 -0700
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="596134247"
Received: from pchai-mobl.ccr.corp.intel.com (HELO [10.249.171.241]) ([10.249.171.241])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 23:53:15 -0700
Message-ID: <0db46319-30c9-5d78-4467-79246ac454e4@linux.intel.com>
Date:   Fri, 1 Jul 2022 14:53:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, dwmw2@infradead.org, mjrosato@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, thierry.reding@gmail.com,
        vdumpa@nvidia.com, jonathanh@nvidia.com, cohuck@redhat.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        chenxiang66@hisilicon.com, john.garry@huawei.com,
        yangyingliang@huawei.com, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org,
        will@kernel.org, marcan@marcan.st, sven@svenpeter.dev,
        robin.murphy@arm.com, robdclark@gmail.com, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
References: <20220630203635.33200-1-nicolinc@nvidia.com>
 <20220630203635.33200-2-nicolinc@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220630203635.33200-2-nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/7/1 04:36, Nicolin Chen wrote:
> Cases like VFIO wish to attach a device to an existing domain that was
> not allocated specifically from the device. This raises a condition
> where the IOMMU driver can fail the domain attach because the domain and
> device are incompatible with each other.
> 
> This is a soft failure that can be resolved by using a different domain.
> 
> Provide a dedicated errno from the IOMMU driver during attach that the
> reason attached failed is because of domain incompatability. EMEDIUMTYPE
> is chosen because it is never used within the iommu subsystem today and
> evokes a sense that the 'medium' aka the domain is incompatible.
> 
> VFIO can use this to know attach is a soft failure and it should continue
> searching. Otherwise the attach will be a hard failure and VFIO will
> return the code to userspace.
> 
> Update all drivers to return EMEDIUMTYPE in their failure paths that are
> related to domain incompatability. Also remove adjacent error prints for
> these soft failures, to prevent a kernel log spam, since -EMEDIUMTYPE is
> clear enough to indicate an incompatability error.
> 
> Add kdocs describing this behavior.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
