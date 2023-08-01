Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BD476AB35
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 10:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjHAIk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 04:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjHAIkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 04:40:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C1A10EB;
        Tue,  1 Aug 2023 01:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690879222; x=1722415222;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=REn/Is4TBVpWaD5oECbSAASATiSAsFC/V8UYQ7o8W6k=;
  b=XBA79slGsmwlcUUOV09EDNhRW6UgGPRXxQF6hq8vu2P2rYUMxv4yrrV3
   1PfrQTWXqWssBZYuPCcKOK1TUxnHPnfvy+2gxb4FWNEUdFTIFOrXPAUX+
   C0F4KtlM5pDsWV1/Wooa4PZ7lZK/UBwq/8FXy+KE73MXF573HZKdPZgQD
   DF5g+VhewxwDbezOvDWT5G/WrmJU6DpjwTZqagLpSRYiI24/3nFWho4m9
   jbTtbn9tNRGzl43wmndNgorRaiyCHe/Y3QiG5phyQtxuOp1iCgtxba/0S
   0KW63GXzN3+pSLHoiTjrl1W2/w82tLoQLJL8HcHc5lO7vnKuPuPBh650U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="366708774"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="366708774"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 01:40:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="842637504"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="842637504"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.213.15]) ([10.254.213.15])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 01:40:18 -0700
Message-ID: <b67d6f3f-95f0-0421-49ff-471032de0963@linux.intel.com>
Date:   Tue, 1 Aug 2023 16:40:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu: Move pasid array from group to device
Content-Language: en-US
To:     "tina.zhang" <tina.zhang@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <20230801063125.34995-3-baolu.lu@linux.intel.com>
 <1254d61b-1f4e-2ef3-c3dc-95180f26f08c@intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <1254d61b-1f4e-2ef3-c3dc-95180f26f08c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/1 16:07, tina.zhang wrote:
> Hi Baolu,

Hi Tina,

> Although this patch moves the domain reference pointer from a per-group
> structure to a per-device structure, the domain life-cycle is still
> expected to be managed per-group (i.e., iommu_domain_free() is called in
> iommu_group_release()). Is this what we expect?

The lifecycle of an iommu domain is independent of the lifecycle of the
iommu group that it is attached to. The system domains, such as the
default domain and the blocking domain, are allocated and managed by the
iommu core. These domains are freed when the group is freed.

However, any device driver can allocate its own iommu domains. The
device driver can set/remove the domain to/from the RID or PASID of the
device.

Best regards,
baolu
