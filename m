Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDB870971D
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 14:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjESMNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 08:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjESMNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 08:13:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CFE18C
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 05:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684498393; x=1716034393;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oE6bARp4hKw3cRBqUJZEMxSRLzfZZiTuupE4Ov1vvl0=;
  b=Q+5n2fIx8ZwzUJaiiDkvqHwkeELZZ+1hbq4pxMZr+zeCai5KJ98qeBcp
   tbK4Cx4uGsIYjsSS9mHeEhsg4CM0pg94NgStcjRDjnpyRgbHaD8M6TXkK
   2urigBMmsKiV2QzUi++HIfHxCQq/qouTMoRRq2pYrwi1bCcEhKWa49gNM
   Yk7uBL4AGapeGSiKAzgHsnIHUmlfHPppwHFPQioshHtpRFd0ne6YUWptd
   b1BA3JRqxzasNtKNUukwgX2MsKaIm3Tm8wQZxOc5R3mdoQX4raofBnFDx
   vJvB/1orYFvPblY8QLxOYviwlYHRTdgGA9iw1fOKkRzdadgTeKf2D9sxJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="351197499"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="351197499"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 05:13:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="949093773"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="949093773"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.160]) ([10.254.210.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 05:13:05 -0700
Message-ID: <4581681d-748e-1e1b-2b9c-b4a57e3a4b33@linux.intel.com>
Date:   Fri, 19 May 2023 20:13:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <ZGdgNblpO4rE+IF4@nvidia.com>
 <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
 <ZGdipWrnZNI/C7mF@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZGdipWrnZNI/C7mF@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/5/19 19:51, Jason Gunthorpe wrote:
> On Fri, May 19, 2023 at 12:47:24PM +0100, Joao Martins wrote:
> 
>> In practice it is done as soon after the domain is created but I understand what
>> you mean that both should be together; I have this implemented like that as my
>> first take as a domain_alloc passed flags, but I was a little undecided because
>> we are adding another domain_alloc() op for the user-managed pagetable and after
>> having another one we would end up with 3 ways of creating iommu domain -- but
>> maybe that's not an issue
> It should ride on the same user domain alloc op as some generic flags,
> there is no immediate use case to enable dirty tracking for
> non-iommufd page tables

This is better than the current solution.

Best regards,
baolu
