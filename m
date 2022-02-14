Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5C14B52D5
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354954AbiBNOKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:10:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354341AbiBNOKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:10:37 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93DD0AE65;
        Mon, 14 Feb 2022 06:10:29 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FC2F1042;
        Mon, 14 Feb 2022 06:10:29 -0800 (PST)
Received: from [10.57.70.89] (unknown [10.57.70.89])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E40A3F66F;
        Mon, 14 Feb 2022 06:10:24 -0800 (PST)
Message-ID: <1347f0ef-e046-1332-32f0-07347cc2079c@arm.com>
Date:   Mon, 14 Feb 2022 14:10:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
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
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-2-baolu.lu@linux.intel.com>
 <43f2fc07-19ea-53a4-af86-a9192a950c96@arm.com>
 <20220214124518.GU4160@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220214124518.GU4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-02-14 12:45, Jason Gunthorpe wrote:
> On Mon, Feb 14, 2022 at 12:09:36PM +0000, Robin Murphy wrote:
>> On 2022-01-06 02:20, Lu Baolu wrote:
>>> Expose an interface to replace the domain of an iommu group for frameworks
>>> like vfio which claims the ownership of the whole iommu group.
>>
>> But if the underlying point is the new expectation that
>> iommu_{attach,detach}_device() operate on the device's whole group where
>> relevant, why should we invent some special mechanism for VFIO to be
>> needlessly inconsistent?
>>
>> I said before that it's trivial for VFIO to resolve a suitable device if it
>> needs to; by now I've actually written the patch ;)
>>
>> https://gitlab.arm.com/linux-arm/linux-rm/-/commit/9f37d8c17c9b606abc96e1f1001c0b97c8b93ed5
> 
> Er, how does locking work there? What keeps busdev from being
> concurrently unplugged?

Same thing that prevents the bus pointer from suddenly becoming invalid 
in the current code, I guess :)

But yes, holding a group reference alone can't prevent the group itself 
from changing, and the finer points of locking still need working out - 
there's a reason you got a link to a WIP branch in my tree rather than a 
proper patch in your inbox (TBH at the moment that one represents about 
a 5:1 ratio of time spent on the reasoning behind the commit message vs. 
the implementation itself).

> How can iommu_group_get() be safely called on
> this pointer?

VFIO hardly needs to retrieve the iommu_group from a device which it 
derived from the iommu_group it holds in the first place. What matters 
is being able to call *other* device-based IOMMU API interfaces in the 
long term. And once a robust solution for that is in place, it should 
inevitably work for a device-based attach interface too.

> All of the above only works normally inside a probe/remove context
> where the driver core is blocking concurrent unplug and descruction.
> 
> I think I said this last time you brought it up that lifetime was the
> challenge with this idea.

Indeed, but it's a challenge that needs tackling, because the bus-based 
interfaces need to go away. So either we figure it out now and let this 
attach interface rework benefit immediately, or I spend three times as 
long solving it on my own and end up deleting 
iommu_group_replace_domain() in about 6 months' time anyway.

Thanks,
Robin.
