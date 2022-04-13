Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865BB4FF5CD
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 13:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiDMLkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 07:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiDMLkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 07:40:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9CA5677F
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 04:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649849860; x=1681385860;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/ag9oz6OrTFhgh1L3jctSIOPjT1GAUan2yOt1VeoaJc=;
  b=T853EL1MbOrHzuGVP209YQlAcAUkiiMxKnnEiWkQC5HJbBtUWEedWYzE
   guAzX80yacTtODX4zoPnDSa6eUYhuP4mLaTu0H7qNKf1owW1eUENyxvFA
   0jmpDyyJeLBZEVkDTu/tiOb1m/Wli2LaXzoSkqGMD2nkTvhbHaUyLB4qk
   GGyR8kLAO2LI67FUo1cvHHoIQVJDLZHMOdDGRsCvC0bOyVmIVqWr7Jt2b
   TZ+0ZNK+pL2zgFv4g/Z3iL26slqudtCNqFaN3j7TDs2tV3zIr6Rz9UsvM
   jCX5k2cLpRJaFEj9wK29CBoj2Cb/EBkBFSnhscCOZLuyDAk4UMn7StWVS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="244528480"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="244528480"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 04:37:39 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="573232232"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.215.67]) ([10.254.215.67])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 04:37:36 -0700
Message-ID: <de2c7dff-0591-aab0-79cb-9858b978c3fa@linux.intel.com>
Date:   Wed, 13 Apr 2022 19:37:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Cc:     baolu.lu@linux.intel.com,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of
 IOMMU_CACHE
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <2-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB5276796235136C1E6C50A5AF8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <8df77a0f-55ee-bbc3-8ada-ab109d9323eb@linux.intel.com>
 <BN9PR11MB5276FD53286C0181B4987C958CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a3b9d7f0-b7b9-ffdf-90c3-b216e1e19b35@linux.intel.com>
 <20220412132059.GG2120790@nvidia.com>
 <BN9PR11MB527667C637E3CFDDB611697E8CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB527667C637E3CFDDB611697E8CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/13 7:04, Tian, Kevin wrote:
>> From: Jason Gunthorpe<jgg@nvidia.com>
>> Sent: Tuesday, April 12, 2022 9:21 PM
>>
>> On Tue, Apr 12, 2022 at 09:13:27PM +0800, Lu Baolu wrote:
>>
>>>>>> btw as discussed in last version it is not necessarily to recalculate
>>>>>> snoop control globally with this new approach. Will follow up to
>>>>>> clean it up after this series is merged.
>>>>> Agreed. But it also requires the enforce_cache_coherency() to be called
>>>>> only after domain being attached to a device just as VFIO is doing.
>>>> that actually makes sense, right? w/o device attached it's pointless to
>>>> call that interface on a domain...
>>> Agreed. Return -EOPNOTSUPP or -EINVAL to tell the caller that this
>>> operation is invalid before any device attachment.
>> That is backwards. enforce_cache_coherency() succeeds on an empty
>> domain and attach of an incompatible device must fail.
> seems it's just a matter of the default policy on an empty domain. No
> matter we by default allow enforce_cache_coherency succeed or not
> the compatibility check against the default policy must be done anyway
> when attaching a device.
> 
> given most IOMMUs supports force-snooping, allowing it succeed by
> default certainly makes more sense.

Make sense. I will come up with the patches after this series is merged.

Best regards,
baolu
