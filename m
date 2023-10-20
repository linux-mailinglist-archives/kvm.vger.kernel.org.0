Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF3B7D0B42
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 11:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376621AbjJTJQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 05:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376634AbjJTJQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 05:16:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FEBD68
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 02:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697793356; x=1729329356;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4+a2ILPohMQTXxfbC3HF+IYd8bX72UjjME/Xtoh+uo8=;
  b=Pfa3Z5vNn4H3nKxkVzHivy3JT+MUCNUKvNtbqLCDholxTxv23u7Sa3xn
   aq4HQumgA1+BW9yDijRphhxZsPEXcbXAk5qJsR2sjOyMi2EATzUNAM/Nn
   T7Ccau7jtsW94onku8OZibNGSWHZ3+JJYUICmMDWXy4AXIrZFVSF6WqqI
   HvrBv0WHMg5k5GpncUg/8XhKv2mT6mmiUhPM+pNMBuQKCakb6/X3YRYLP
   IvWiyThnL0E7/HVg6nmYNNLjjB6evWGC+cQ+sFsyU/xNX68NiaPkiX0tE
   ew4Y5Laf1Cp7MOtWu/k9exjBw1xHjTkUF6RV69+qX/KOGm3jgo89Dc1YN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="452941053"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="452941053"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 02:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="786726195"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="786726195"
Received: from lingxu-mobl.ccr.corp.intel.com (HELO [10.254.211.102]) ([10.254.211.102])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 02:15:35 -0700
Message-ID: <001ad25b-f7c2-4a7f-8266-8a7c104c9975@linux.intel.com>
Date:   Fri, 20 Oct 2023 17:15:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-13-joao.m.martins@oracle.com>
 <BN9PR11MB527658ABE413A50034647D9A8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB527658ABE413A50034647D9A8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/20 15:53, Tian, Kevin wrote:
>> From: Joao Martins<joao.m.martins@oracle.com>
>> Sent: Thursday, October 19, 2023 4:27 AM
>>
>> +
>> +	if (!IS_ERR(domain) && enforce_dirty) {
>> +		if (to_dmar_domain(domain)->use_first_level) {
>> +			iommu_domain_free(domain);
>> +			return ERR_PTR(-EOPNOTSUPP);
>> +		}
>> +		domain->dirty_ops = &intel_dirty_ops;
>> +	}
> I don't understand why we should check use_first_level here. It's
> a dead condition as alloc_user() only uses 2nd level. Later when
> nested is introduced then we explicitly disallow enforce_dirty
> on a nested user domain.

This is to restrict dirty tracking to the second level page table
*explicitly*. If we have a need to enable dirty tracking on the first
level in the future, we can remove this check.

Best regards,
baolu
