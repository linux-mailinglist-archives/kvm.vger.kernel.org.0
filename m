Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8844FA7BD
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 14:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbiDIMqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 08:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbiDIMql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 08:46:41 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5573623C0F8
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 05:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649508274; x=1681044274;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vN9BGDE0AtbpKR0FrUbydLNQHt8DeQ0BMm7aU1jDmgg=;
  b=WyuXiuugaVHCSFIIfvlLk1463AKmYIk2xFypq86xjZiOleXGMnmW7Nc5
   eT4gcQsd+00DLOQ6otfGkouZKQrctBgeupskP/mALISscIZQOQyTuquGM
   kUWUSeyWoBjNcrCjKIqg3i7HT7k6ItRhgS+CU+wuUs/DOE417UKy2PR5n
   Jc4FODWBzwbbusrjmbAGWxsZcds3+wb9Yzxw6NRHTFWC4bUlhDuStwiI2
   3OZM1JyVV+yU40lwLZ6dQ+ZqVUSHceYX1y9ZG04GtHlQhdQPsrQyJXlld
   f+DMYLhovQudhKx2U/Z2h05+qTydpyXjmkM8QfSW12kiAwGgZ6CYkKzhp
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="260643200"
X-IronPort-AV: E=Sophos;i="5.90,247,1643702400"; 
   d="scan'208";a="260643200"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2022 05:44:34 -0700
X-IronPort-AV: E=Sophos;i="5.90,247,1643702400"; 
   d="scan'208";a="698637454"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.214.211]) ([10.254.214.211])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2022 05:44:31 -0700
Message-ID: <5511a33b-573d-d605-4fbc-67f8e578aec5@linux.intel.com>
Date:   Sat, 9 Apr 2022 20:44:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 1/4] iommu: Introduce the domain op
 enforce_cache_coherency()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <1-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB5276FBFE9D5BC5039BA571A58CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276FBFE9D5BC5039BA571A58CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/8 16:05, Tian, Kevin wrote:
>> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
>> index 2f9891cb3d0014..1f930c0c225d94 100644
>> --- a/include/linux/intel-iommu.h
>> +++ b/include/linux/intel-iommu.h
>> @@ -540,6 +540,7 @@ struct dmar_domain {
>>   	u8 has_iotlb_device: 1;
>>   	u8 iommu_coherency: 1;		/* indicate coherency of
>> iommu access */
>>   	u8 iommu_snooping: 1;		/* indicate snooping control
>> feature */
>> +	u8 enforce_no_snoop : 1;        /* Create IOPTEs with snoop control */
> it reads like no_snoop is the result of the enforcement... Probably
> force_snooping better matches the intention here.

+1

Other changes in iommu/vt-d looks good to me.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
