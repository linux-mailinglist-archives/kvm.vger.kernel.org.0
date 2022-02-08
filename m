Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE524AD14C
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 06:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbiBHF4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 00:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbiBHF4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 00:56:47 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D74EC0401DC;
        Mon,  7 Feb 2022 21:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644299806; x=1675835806;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/E3+XDZn+fI4PCSgbxMj37rovQtgfKS2C5AACs5xPYs=;
  b=LcXFhytTuK1lXzVQrayUaKmUJ1JT7GIKTrP3IrPSSzSWIU0cD5Lg//fM
   CGGzApENWyGG5nCrQ0ujueLyFxlX/S1S3JlS2wU0TAo6gjG8NnnjdTEf+
   woAuO1dKLxIuDzTgRyi/Y7788cev91GUg3kFmJORtG4EeKuLgZ1eCbUn8
   All7THtn60lNLN1wJ+EMkSTM/2fT8O40EZpEr37DqoDNNI7H976y6YnX0
   IK1XDeTtx/9lTZVi3pYnQr4ezWN1DQt7Kng3er8VeT4C0QlYL7/5n+Pb3
   N92FAiJ9eu3crH7HACbWkYSF1efoU40gz9BGhMvKbvPz3PCky6CATWU1w
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="246468556"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="246468556"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 21:56:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="678001282"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2022 21:56:39 -0800
Message-ID: <608192e0-136a-57fc-cb2c-3ebb42874788@linux.intel.com>
Date:   Tue, 8 Feb 2022 13:55:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v5 02/14] driver core: Add dma_cleanup callback in
 bus_type
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-3-baolu.lu@linux.intel.com>
 <YdQcpHrV7NwUv+qc@infradead.org> <20220104123911.GE2328285@nvidia.com>
 <YdRFyXWay/bdSSem@kroah.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <YdRFyXWay/bdSSem@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Greg,

On 1/4/22 9:04 PM, Greg Kroah-Hartman wrote:
> On Tue, Jan 04, 2022 at 08:39:11AM -0400, Jason Gunthorpe wrote:
>> On Tue, Jan 04, 2022 at 02:08:36AM -0800, Christoph Hellwig wrote:
>>> All these bus callouts still looks horrible and just create tons of
>>> boilerplate code.
>>
>> Yes, Lu - Greg asked questions then didn't respond to their answers
>> meaning he accepts them, you should stick with the v4 version.
> 
> Trying to catch up on emails from the break, that was way down my list
> of things to get back to as it's messy and non-obvious.  I'll revisit it
> again after 5.17-rc1 is out, this is too late for that merge window
> anyway.

In this series we want to add calls into the iommu subsystem during
device driver binding/unbinding, so that the device DMA ownership
conflict (kernel driver vs. user-space) could be detected and avoided
before calling into device driver's .probe().

In this v5 series, we implemented this in the affected buses (amba/
platform/fsl-mc/pci) which are known to support assigning devices to
user space through the vfio framework currently. And more buses are
possible to be affected in the future if they also want to support
device assignment. Christoph commented that this will create boilerplate
code in various bus drivers.

Back to v4 of this series (please refer to below link [1]), we added
this call in the driver core if buses have provided the dma_configure()
callback (please refer to below link [2]).

Which would you prefer, or any other suggestions? We need your guide to
move this series ahead. Please help to suggest.

[1] 
https://lore.kernel.org/linux-iommu/20211217063708.1740334-1-baolu.lu@linux.intel.com/
[2] 
https://lore.kernel.org/linux-iommu/20211217063708.1740334-3-baolu.lu@linux.intel.com/

Best regards,
baolu
