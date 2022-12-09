Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0696480E2
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 11:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLIKY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 05:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiLIKY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 05:24:26 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48D7661770;
        Fri,  9 Dec 2022 02:24:25 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E4B423A;
        Fri,  9 Dec 2022 02:24:31 -0800 (PST)
Received: from [10.57.87.116] (unknown [10.57.87.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B5CA3F73B;
        Fri,  9 Dec 2022 02:24:16 -0800 (PST)
Message-ID: <a8eb848f-3755-6f64-43d8-3f3dc9926979@arm.com>
Date:   Fri, 9 Dec 2022 10:24:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH iommufd 2/9] vfio/type1: Check that every device supports
 IOMMU_CAP_INTR_REMAP
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <2-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <20221208144825.33823739.alex.williamson@redhat.com>
 <Y5KE/ikRGKnuaFAQ@nvidia.com>
Content-Language: en-GB
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <Y5KE/ikRGKnuaFAQ@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-12-09 00:44, Jason Gunthorpe wrote:
> On Thu, Dec 08, 2022 at 02:48:25PM -0700, Alex Williamson wrote:
>> On Thu,  8 Dec 2022 16:26:29 -0400
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> iommu_group_for_each_dev() exits the loop at the first callback that
>>> returns 1 - thus returning 1 fails to check the rest of the devices in the
>>> group.
>>>
>>> msi_remap (aka secure MSI) requires that all the devices in the group
>>> support it, not just any one. This is only a theoretical problem as no
>>> current drivers will have different secure MSI properties within a group.
>>
>> Which is exactly how Robin justified the behavior in the referenced
>> commit:
>>
>>    As with domains, any capability must in practice be consistent for
>>    devices in a given group - and after all it's still the same
>>    capability which was expected to be consistent across an entire bus!
>>    - so there's no need for any complicated validation.
>>
>> That suggests to me that it's intentional that we break if any device
>> supports the capability and therefore this isn't so much a "Fixes:", as
>> it is a refactoring expressly to support msi_device_has_secure_msi(),
>> which cannot make these sort of assumptions as a non-group API.  Thanks,
> 
> Sure, lets drop the fixes and your analysis seems correct

Yup, Alex is spot on - the fact is that all the IOMMU drivers supporting 
this cap have always returned global values, and continue to do so right 
up until we remove it later, so there's really no benefit in pretending 
otherwise. I'd say just fold this into patch #3 to keep it even simpler.

Thanks,
Robin.
