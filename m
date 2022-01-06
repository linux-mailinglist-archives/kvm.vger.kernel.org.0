Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345FD485F63
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 04:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiAFDvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 22:51:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:4821 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbiAFDvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 22:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641441112; x=1672977112;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=duW+vQR4sMirxxEYotvqV0oLcyExanZmvqlVTiuxZFs=;
  b=PFwmvSA1h1XkJNZBw4lhZRt9RWSn16C6hfAiYDvNtBk5zv5MWP8JQQ/M
   ZiX2/eqMnD0hlfMfgAeRB4pLQr+djodWbUAdp9TiAJoOcl2rldGAIkisf
   oI+qnfuPy48AbIidQcBEY5TVBu8bHep78YjF5GQor9D6LUjMD1otpL/lS
   Jl1nowowk0R0Eb1FmwkJODeJuNCryil3ImvX0WCmQ0wz9V06s4tjonTbh
   redNq8L+6JbOoyY0huIfCxatZ8aVK+bnu2d8c333POWJjpC/p3ca9EFhS
   MpXF56/tNDy+2R+frer/nVsEM44Zeffk7TL7eJg52Yr/0T7lxtN9NQFWG
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222580241"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="222580241"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 19:51:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526815760"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 19:51:45 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v5 01/14] iommu: Add dma ownership management interfaces
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20220104164100.GA101735@bhelgaas>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <bcb77054-f4ac-cd34-d79c-eba7cb54e042@linux.intel.com>
Date:   Thu, 6 Jan 2022 11:51:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104164100.GA101735@bhelgaas>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 12:41 AM, Bjorn Helgaas wrote:
>>>   struct group_device {
>>> @@ -289,7 +291,12 @@ int iommu_probe_device(struct device *dev)
>>>   	mutex_lock(&group->mutex);
>>>   	iommu_alloc_default_domain(group, dev);
>>>   
>>> -	if (group->default_domain) {
>>> +	/*
>>> +	 * If device joined an existing group which has been claimed
>>> +	 * for none kernel DMA purpose, avoid attaching the default
>>> +	 * domain.
> AOL: another "none kernel DMA purpose" that doesn't read well.  Is
> this supposed to be "non-kernel"?  What does "claimed for non-kernel
> DMA purpose" mean?  What interface does that?
> 

It's hard to read. I will rephrase it like this:

/*
  * If device joined an existing group which has been claimed, don't
  * attach the default domain.
  */

Best regards,
baolu
