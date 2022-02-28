Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CC54C6085
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 02:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiB1BBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 20:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiB1BBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 20:01:19 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2665419B;
        Sun, 27 Feb 2022 17:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646010041; x=1677546041;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5ATRL4rQ1IyZjNEW/fMNHknvLJWziKwt7KwEQHMNLqg=;
  b=Pb29J0F0u4X1f7W9oXBVQ/4hk/fHzPDW4K9w8ZJ7iN/z1wFlbkiNDLsf
   M+AIsO24VEngASbwKnX1XjsB8t8Ak9iAVR338sAWt4HsyR5wignG1LK0b
   9mg97WiRpZ+a5q429t73nXOUDAr0ZO+jNyYdPO5opi30pcSdMAbCUhHBm
   CNMH0JTNpl0f/9m4QzI4Pgn8gDh5O0x/zPgxf5owXrpaSifOPlBRoMPce
   KUOa6gsC8nxjLTDGssM1ZuX+duinmHF975nR0oeRdXjjWKwzLCW06YZAe
   IB3f0LnjkGo0YIHbfdaambiF6sA+0JnObTD9QOyKrumX0cunhokEIXuRB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="252700834"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="252700834"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 17:00:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="534251537"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 27 Feb 2022 17:00:30 -0800
Message-ID: <f78b3bce-513a-a14c-d12e-1a328d5ddc87@linux.intel.com>
Date:   Mon, 28 Feb 2022 08:58:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220218005521.172832-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 8:55 AM, Lu Baolu wrote:
> v6:
>    - Refine comments and commit mesages.
>    - Rename iommu_group_set_dma_owner() to iommu_group_claim_dma_owner().
>    - Rename iommu_device_use/unuse_kernel_dma() to
>      iommu_device_use/unuse_default_domain().
>    - Remove unnecessary EXPORT_SYMBOL_GPL.
>    - Change flag name from no_kernel_api_dma to driver_managed_dma.
>    - Merge 4 "Add driver dma ownership management" patches into single
>      one.

Thanks you very much for review and comments. A new version (v7) has
been posted.

https://lore.kernel.org/linux-iommu/20220228005056.599595-1-baolu.lu@linux.intel.com/

If I missed anything there, please let me know.

Best regards,
baolu
