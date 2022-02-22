Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9604A4BF1DC
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 07:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiBVF6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 00:58:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiBVF6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 00:58:02 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484D98E192;
        Mon, 21 Feb 2022 21:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645509458; x=1677045458;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7bEcFXv/PBrDnpJkRJDcOGeL+LDolQ6d+dndBSOh350=;
  b=K6lG22bBANh7vO+MZkeL9DQEOQvHvzY1CHN2nxl1iL8SuCJtiJ6zS+x7
   loZmz4zG9cGn03doJDazMIVlrOcmZFhb56+/5a7SoPTFbQGnNAuO0AZwA
   ujpE2bT/mlMYD54qlaYAlqAYeuQzo5DiI/b3XQxQkSbGnVeO0+FYLI1aB
   FZTxv6EB0jn9LUda5nxGa232om7at/Jxh7Re0KMR7zhHvAW2hXUmZGHsh
   rg6sbToORhbJQZqKrTzYjCbViaV9WitlJeC/JJAeuvhRan9dnr8mcRzWe
   IF8ny2bF+fqCBnqVs94g+e+UEain4na0fxZJTa8kdDp//TPlxdPIz5hNy
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="250432165"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="250432165"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 20:50:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="683385469"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 21 Feb 2022 20:50:06 -0800
Message-ID: <c212094a-399e-1038-99e0-7a08d0da2a61@linux.intel.com>
Date:   Tue, 22 Feb 2022 12:48:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-3-baolu.lu@linux.intel.com>
 <YhCdEmC2lYStmUSL@infradead.org>
 <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
 <20220221234837.GA10061@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220221234837.GA10061@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 7:48 AM, Jason Gunthorpe wrote:
>> since we should only care about ownership at probe, hotplug, and other
>> places well outside critical fast-paths, I'm not sure we really need to keep
>> track of that anyway - it can always be recalculated by walking the
>> group->devices list,
> It has to be locked against concurrent probe, and there isn't
> currently any locking scheme that can support this. The owner_cnt is
> effectively a new lock for this purpose. It is the same issue we
> talked about with that VFIO patch you showed me.
> 
> So, using the group->device_list would require adding something else
> somewhere - which I think should happen when someone has
> justification for another use of whatever that something else is.

This series was originated from the similar idea by adding some fields
in driver structure and intercepting it in iommu core. We stopped doing
that due to the lack of lock mechanism between iommu and driver core.
It then evolved into what it is today.

Best regards,
baolu
