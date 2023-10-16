Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE1B7CA8C1
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjJPNBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbjJPNBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:01:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30AEAD
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 06:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697461302; x=1728997302;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Cek2Mj9VL4t6yJnSLD+Iis5IEBjCCUrO/gTh8DBNYb0=;
  b=SKjmAfAyxpUJF2/4GItHjFJI9Lh0jjRx+EKu1wowvPEd3aClkKgL9xFB
   9r5muELq/28oqH+dllfkJehK2580ksf9hGo3Jg0Y7J3eHu7lbX3vPRr01
   +OsuFf2MK2Aq50SO9gtr4cwYdSCoqj0oe0lwrligSODF4m1QcKBbm/uYM
   wL2wkilTVovngAbQTkAlB+ckU4Ea59BZSUXE7LckzRmtvM2VHX771ZpDr
   OtOIQOF0CRGZHC+V81hM6hnxMOIJrFb6mOcDQ6znviLvFfFxeYI43OiSI
   rOTrTK9xVmmiWy2GEo2trwLnOrsjhhS8C7xqcOcUcTZ0k+vc1sg6ELWja
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="382739338"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="382739338"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 06:01:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="732294054"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="732294054"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.171.91]) ([10.249.171.91])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 06:01:37 -0700
Message-ID: <3e30e72a-c1c6-55a6-8e52-6a6250d2d8de@linux.intel.com>
Date:   Mon, 16 Oct 2023 21:01:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Cc:     baolu.lu@linux.intel.com, Joao Martins <joao.m.martins@oracle.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
 <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
 <20231016114210.GM3952@nvidia.com>
 <037d2917-51a2-acae-dc06-65940a054880@linux.intel.com>
 <20231016125941.GT3952@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231016125941.GT3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/16 20:59, Jason Gunthorpe wrote:
> On Mon, Oct 16, 2023 at 08:58:42PM +0800, Baolu Lu wrote:
>> On 2023/10/16 19:42, Jason Gunthorpe wrote:
>>> On Mon, Oct 16, 2023 at 11:57:34AM +0100, Joao Martins wrote:
>>>
>>>> True. But to be honest, I thought we weren't quite there yet in PASID support
>>>> from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the wrong
>>>> impression? From the code below, it clearly looks the driver does.
>>> I think we should plan that this series will go before the PASID
>>> series
>> I know that PASID support in IOMMUFD is not yet available, but the VT-d
>> driver already supports attaching a domain to a PASID, as required by
>> the idxd driver for kernel DMA with PASID. Therefore, from the driver's
>> perspective, dirty tracking should also be enabled for PASIDs.
> As long as the driver refuses to attach a dirty track enabled domain
> to PASID it would be fine for now.

Yes. This works.

Best regards,
baolu
