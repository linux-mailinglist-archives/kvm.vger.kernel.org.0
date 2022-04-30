Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846FB515A8D
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 07:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbiD3FPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Apr 2022 01:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbiD3FPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Apr 2022 01:15:32 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741BFCFE69
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 22:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651295531; x=1682831531;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PFNU2NL6HfP9hCxoyhIj2wN4qSRTLERQuZemWbYd7+U=;
  b=Zfn+NyS9UkSIxnlge3K9HNWJ2BaiXhzkWkaS1MC1Sr8sG4J1qEUv3O/G
   PPJNcqjoHSzsC+l5Ds+lvULPdBa+0rlhNxT6nyXElItizEygu3fAnYn44
   m4duFhhN98vzpkXbXkc2yyKsV44ASet6HAQRVsF7IR6P4il5koraoG2em
   /6QwKJupGGR4xg5crOni667PgwCRTXM/8XbdSLAq4Ax6NFQS2cnw6h0IH
   zMos27u07WLJmUrBg0wo7UgRLM4nJyN3s9tMqpDv1og+PNyQVEKYUBXGe
   /IfFHUA5XWB2vamqV7cfegpCEqaIdeSvWuq0WL/42SdnMbHegLYgNrNVl
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="266385613"
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="266385613"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 22:12:10 -0700
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="582603000"
Received: from aliu1-mobl.ccr.corp.intel.com (HELO [10.255.30.71]) ([10.255.30.71])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 22:12:06 -0700
Message-ID: <42b4cd96-dda3-9d00-a684-121129aa1af6@linux.intel.com>
Date:   Sat, 30 Apr 2022 13:12:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 04/19] iommu: Add an unmap API that returns dirtied
 IOPTEs
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-5-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220428210933.3583-5-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/29 05:09, Joao Martins wrote:
> Today, the dirty state is lost and the page wouldn't be migrated to
> destination potentially leading the guest into error.
> 
> Add an unmap API that reads the dirty bit and sets it in the
> user passed bitmap. This unmap iommu API tackles a potentially
> racy update to the dirty bit *when* doing DMA on a iova that is
> being unmapped at the same time.
> 
> The new unmap_read_dirty/unmap_pages_read_dirty does not replace
> the unmap pages, but rather only when explicit called with an dirty
> bitmap data passed in.
> 
> It could be said that the guest is buggy and rather than a special unmap
> path tackling the theoretical race ... it would suffice fetching the
> dirty bits (with GET_DIRTY_IOVA), and then unmap the IOVA.

I am not sure whether this API could solve the race.

size_t iommu_unmap(struct iommu_domain *domain,
                    unsigned long iova, size_t size)
{
         struct iommu_iotlb_gather iotlb_gather;
         size_t ret;

         iommu_iotlb_gather_init(&iotlb_gather);
         ret = __iommu_unmap(domain, iova, size, &iotlb_gather);
         iommu_iotlb_sync(domain, &iotlb_gather);

         return ret;
}

The PTEs are cleared before iotlb invalidation. What if a DMA write
happens after PTE clearing and before the iotlb invalidation with the
PTE happening to be cached?

Best regards,
baolu
