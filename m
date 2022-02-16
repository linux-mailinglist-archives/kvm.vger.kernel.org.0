Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7B34B80BE
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 07:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiBPGeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 01:34:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiBPGeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 01:34:02 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869611F3F17;
        Tue, 15 Feb 2022 22:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644993222; x=1676529222;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xhIOhZqbmXasqsL4PSTwgu2wa99Ybi4SJBWDqbME8bE=;
  b=I1wTLM0qxsO/BxklghI8gVX5h6l3XbgRtsJ0N/wMlsTdCjHA/PFa4Z2m
   39gMta86brLFdK4h01VjVAyY2hhtMjL8/0yqD6TnrtVA3ZyauaQRYv8Up
   tt8TQaYYHH4rexpLXVd7bsEp8DtuLBi482DTFmuUCWvk9B36vQ7qiaBgc
   RWWCMih41HO2wzR6VXL2mSrBmVsMi2ufcgxLrx424iDT18tRuVgrKTo+1
   jQYddPyZtEtt+kdIWiJbN/H6wO93Rwud2p8/q8fdDh5SAJQdV/yXfRBOh
   32ItmAyZO2uY4xBeP+p6yAAB48tDY4lmdsOgXlyA07BjV+VhKkMVTwDtb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="249366366"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="249366366"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 22:29:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="681371490"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 15 Feb 2022 22:29:29 -0800
Message-ID: <69f26767-66d6-12df-1754-45ee1932d513@linux.intel.com>
Date:   Wed, 16 Feb 2022 14:28:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     baolu.lu@linux.intel.com, Stuart Yoder <stuyoder@gmail.com>,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <Ygo/eCRFnraY01WA@8bytes.org> <20220214130313.GV4160@nvidia.com>
 <Ygppub+Wjq6mQEAX@8bytes.org> <08e90a61-8491-acf1-ab0f-f93f97366d24@arm.com>
 <20220214154626.GF4160@nvidia.com> <YgtrJVI9wGMFdPWk@8bytes.org>
 <20220215134744.GO4160@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <20220215134744.GO4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/15/22 9:47 PM, Jason Gunthorpe via iommu wrote:
> On Tue, Feb 15, 2022 at 09:58:13AM +0100, Joerg Roedel wrote:
>> On Mon, Feb 14, 2022 at 11:46:26AM -0400, Jason Gunthorpe wrote:
>>> On Mon, Feb 14, 2022 at 03:18:31PM +0000, Robin Murphy wrote:
>>>
>>>> Arguably, iommu_attach_device() could be renamed something like
>>>> iommu_attach_group_for_dev(), since that's effectively the semantic that all
>>>> the existing API users want anyway (even VFIO at the high level - the group
>>>> is the means for the user to assign their GPU/NIC/whatever device to their
>>>> process, not the end in itself). That's just a lot more churn.
>>>
>>> Right
>>
>> Okay, good point. I can live with an iommu_attach_group_for_dev()
>> interface, it is still better than making iommu_attach_device() silently
>> operate on whole groups.
> 
> I think this is what Lu's series currently does, it just doesn't do
> the rename churn as Robin noted. Lu, why not add a note like Robin
> explained to the kdoc so it is clear this api impacts the whole group?

I feel that the debate here is not about API name, but how should
iommu_attach/detach_device() be implemented and used.

It seems everyone agrees that for device assignment (where the I/O
address is owned by the user-space application), the iommu_group-based
APIs should always be used. Otherwise, the isolation and protection are
not guaranteed.

For kernel DMA (where the I/O address space is owned by the kernel
drivers), the device driver oriented interface should meet below
expectations:

  - the concept of iommu_group should be transparent to the device
    drivers;
  - but internally, iommu core only allows a single domain to attach to
    a group.

If the device driver uses default domain, the above expectations are
naturally met. But when the driver wants to attach its own domain, the
problem arises.

This series tries to use the DMA ownership mechanism to solve this. The
devices drivers explicitly declare that

  - I know that the device I am driving shares the iommu_group with
    others;
  - Other device drivers with the same awareness can only be bound to the
    devices in the shared group;
  - We can sync with each other so that only a shared domain could be
    attached to the devices in the group.

Another proposal (as suggested by Joerg) is to introduce the concept of
"sub-group". An iommu group could have one or multiple sub-groups with
non-aliased devices sitting in different sub-groups and use different
domains.

Above are what I get so far. If there's any misunderstanding, please
help to correct.

Best regards,
baolu
