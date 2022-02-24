Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F404C2349
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 06:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiBXFS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 00:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiBXFS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 00:18:56 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD8250B16;
        Wed, 23 Feb 2022 21:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645679907; x=1677215907;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=egRbENubkOkUmSuijD6lu7Tlla0i2tXbS3AogDwESqU=;
  b=kmC9AkRDQTA/fcqA1jb+31YcFvpDgLqyJyGDoif+U/otcj+UNz7Qs9Go
   uWGNgb6fMIHV5768XvJusYCAufBWfOmKMJMayOloHJpdXxezXNLPOKw3J
   xfRFlJtaQbymf5KoK2Zux6EOveU/2HPmHgNBGbU3q0x7c0koRnXqvB38/
   s1SDuR8jks/0miOLHF2+rMSI0PSMCguTCc5yz7Z4hW21VbWmE1HdF7Mt6
   Y1GOjoS3dvt9WFj35Jt/bmsw5evAJHhyhx7gHun6UxHj/X4Gf/kHmqGtV
   XxKObAbCZiEV+EfcW0/k+82/7CgjJgaAzM9IuKonTSE1YiOhuA/+j+RcO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="251887518"
X-IronPort-AV: E=Sophos;i="5.88,393,1635231600"; 
   d="scan'208";a="251887518"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 21:18:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,393,1635231600"; 
   d="scan'208";a="684158911"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2022 21:18:20 -0800
Message-ID: <dd944ab4-cf25-fa41-0170-875e5c5fd0e8@linux.intel.com>
Date:   Thu, 24 Feb 2022 13:16:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v6 01/11] iommu: Add dma ownership management interfaces
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-2-baolu.lu@linux.intel.com>
 <f830c268-daca-8e8f-a429-0c80496a7273@arm.com>
 <20220223180244.GA390403@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220223180244.GA390403@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin and Jason,

On 2/24/22 2:02 AM, Jason Gunthorpe wrote:
> On Wed, Feb 23, 2022 at 06:00:06PM +0000, Robin Murphy wrote:
> 
>> ...and equivalently just set owner_cnt directly to 0 here. I don't see a
>> realistic use-case for any driver to claim the same group more than once,
>> and allowing it in the API just feels like opening up various potential
>> corners for things to get out of sync.
> I am Ok if we toss it out to get this merged, as there is no in-kernel
> user right now.

So we don't need the owner pointer in the API anymore, right? As we will
only allow the claiming interface to be called only once, this token is
unnecessary.

Best regards,
baolu
