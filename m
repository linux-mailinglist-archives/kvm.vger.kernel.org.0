Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF97515466
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 21:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbiD2TZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 15:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238707AbiD2TYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 15:24:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 689093A5CF
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 12:20:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00F7B1063;
        Fri, 29 Apr 2022 12:20:54 -0700 (PDT)
Received: from [10.57.80.98] (unknown [10.57.80.98])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 226FC3F73B;
        Fri, 29 Apr 2022 12:20:50 -0700 (PDT)
Message-ID: <cab0cf66-5e9c-346e-6eb5-ea1f996fbab3@arm.com>
Date:   Fri, 29 Apr 2022 20:20:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Content-Language: en-GB
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
 <a0331f20-9cf4-708e-a30d-6198dadd1b23@arm.com>
 <e1c92dad-c672-51c6-5acc-1a50218347ff@oracle.com>
 <20220429122352.GU8364@nvidia.com>
 <bed35e91-3b47-f312-4555-428bb8a7bd89@oracle.com>
 <20220429161134.GB8364@nvidia.com>
 <e238dd28-2449-ec1e-ee32-08446c4383a9@oracle.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <e238dd28-2449-ec1e-ee32-08446c4383a9@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-04-29 17:40, Joao Martins wrote:
> On 4/29/22 17:11, Jason Gunthorpe wrote:
>> On Fri, Apr 29, 2022 at 03:45:23PM +0100, Joao Martins wrote:
>>> On 4/29/22 13:23, Jason Gunthorpe wrote:
>>>> On Fri, Apr 29, 2022 at 01:06:06PM +0100, Joao Martins wrote:
>>>>
>>>>>> TBH I'd be inclined to just enable DBM unconditionally in
>>>>>> arm_smmu_domain_finalise() if the SMMU supports it. Trying to toggle it
>>>>>> dynamically (especially on a live domain) seems more trouble that it's
>>>>>> worth.
>>>>>
>>>>> Hmmm, but then it would strip userland/VMM from any sort of control (contrary
>>>>> to what we can do on the CPU/KVM side). e.g. the first time you do
>>>>> GET_DIRTY_IOVA it would return all dirtied IOVAs since the beginning
>>>>> of guest time, as opposed to those only after you enabled dirty-tracking.
>>>>
>>>> It just means that on SMMU the start tracking op clears all the dirty
>>>> bits.
>>>>
>>> Hmm, OK. But aren't really picking a poison here? On ARM it's the difference
>>> from switching the setting the DBM bit and put the IOPTE as writeable-clean (which
>>> is clearing another bit) versus read-and-clear-when-dirty-track-start which means
>>> we need to re-walk the pagetables to clear one bit.
>>
>> Yes, I don't think a iopte walk is avoidable?
>>
> Correct -- exactly why I am still more learning towards enable DBM bit only at start
> versus enabling DBM at domain-creation while clearing dirty at start.

I'd say it's largely down to whether you want the bother of 
communicating a dynamic behaviour change into io-pgtable. The big 
advantage of having it just use DBM all the time is that you don't have 
to do that, and the "start tracking" operation is then nothing more than 
a normal "read and clear" operation but ignoring the read result.

At this point I'd much rather opt for simplicity, and leave the fancier 
stuff to revisit later if and when somebody does demonstrate a 
significant overhead from using DBM when not strictly needed.

Thanks,
Robin.
