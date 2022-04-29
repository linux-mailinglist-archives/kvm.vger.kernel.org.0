Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB265147F6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358254AbiD2LWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 07:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358244AbiD2LWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 07:22:36 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FFCC8567A
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 04:19:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08D281063;
        Fri, 29 Apr 2022 04:19:17 -0700 (PDT)
Received: from [10.57.80.98] (unknown [10.57.80.98])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA3103F73B;
        Fri, 29 Apr 2022 04:19:13 -0700 (PDT)
Message-ID: <a0331f20-9cf4-708e-a30d-6198dadd1b23@arm.com>
Date:   Fri, 29 Apr 2022 12:19:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Content-Language: en-GB
To:     Joao Martins <joao.m.martins@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
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

On 2022-04-29 12:05, Joao Martins wrote:
> On 4/29/22 09:28, Tian, Kevin wrote:
>>> From: Joao Martins <joao.m.martins@oracle.com>
>>> Sent: Friday, April 29, 2022 5:09 AM
>>>
>>> Similar to .read_and_clear_dirty() use the page table
>>> walker helper functions and set DBM|RDONLY bit, thus
>>> switching the IOPTE to writeable-clean.
>>
>> this should not be one-off if the operation needs to be
>> applied to IOPTE. Say a map request comes right after
>> set_dirty_tracking() is called. If it's agreed to remove
>> the range op then smmu driver should record the tracking
>> status internally and then apply the modifier to all the new
>> mappings automatically before dirty tracking is disabled.
>> Otherwise the same logic needs to be kept in iommufd to
>> call set_dirty_tracking_range() explicitly for every new
>> iopt_area created within the tracking window.
> 
> Gah, I totally missed that by mistake. New mappings aren't
> carrying over the "DBM is set". This needs a new io-pgtable
> quirk added post dirty-tracking toggling.
> 
> I can adjust, but I am at odds on including this in a future
> iteration given that I can't really test any of this stuff.
> Might drop the driver until I have hardware/emulation I can
> use (or maybe others can take over this). It was included
> for revising the iommu core ops and whether iommufd was
> affected by it.
> 
> I'll delete the range op, and let smmu v3 driver walk its
> own IO pgtables.

TBH I'd be inclined to just enable DBM unconditionally in 
arm_smmu_domain_finalise() if the SMMU supports it. Trying to toggle it 
dynamically (especially on a live domain) seems more trouble that it's 
worth.

Robin.
