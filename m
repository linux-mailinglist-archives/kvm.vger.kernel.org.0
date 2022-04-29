Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7064E51493D
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359132AbiD2MaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 08:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359128AbiD2MaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 08:30:10 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CF09C8BF5
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 05:26:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CB3A1063;
        Fri, 29 Apr 2022 05:26:49 -0700 (PDT)
Received: from [10.57.80.98] (unknown [10.57.80.98])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CD6E3F73B;
        Fri, 29 Apr 2022 05:26:45 -0700 (PDT)
Message-ID: <27dc8d16-5e10-ae13-d91f-bc7826d34af1@arm.com>
Date:   Fri, 29 Apr 2022 13:26:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH RFC 13/19] iommu/arm-smmu-v3: Add feature detection for
 BBML
Content-Language: en-GB
To:     Joao Martins <joao.m.martins@oracle.com>
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
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kunkun Jiang <jiangkunkun@huawei.com>,
        iommu@lists.linux-foundation.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-14-joao.m.martins@oracle.com>
 <8e897628-61fa-b3fb-b609-44eeda11b45e@arm.com>
 <fdb44064-c4ab-9bd1-f984-e3772b539c13@oracle.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <fdb44064-c4ab-9bd1-f984-e3772b539c13@oracle.com>
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

On 2022-04-29 12:54, Joao Martins wrote:
> On 4/29/22 12:11, Robin Murphy wrote:
>> On 2022-04-28 22:09, Joao Martins wrote:
>>> From: Kunkun Jiang <jiangkunkun@huawei.com>
>>>
>>> This detects BBML feature and if SMMU supports it, transfer BBMLx
>>> quirk to io-pgtable.
>>>
>>> BBML1 requires still marking PTE nT prior to performing a
>>> translation table update, while BBML2 requires neither break-before-make
>>> nor PTE nT bit being set. For dirty tracking it needs to clear
>>> the dirty bit so checking BBML2 tells us the prerequisite. See SMMUv3.2
>>> manual, section "3.21.1.3 When SMMU_IDR3.BBML == 2 (Level 2)" and
>>> "3.21.1.2 When SMMU_IDR3.BBML == 1 (Level 1)"
>>
>> You can drop this, and the dependencies on BBML elsewhere, until you get
>> round to the future large-page-splitting work, since that's the only
>> thing this represents. Not much point having the feature flags without
>> an actual implementation, or any users.
>>
> OK.
> 
> My thinking was that the BBML2 meant *also* that we don't need that break-before-make
> thingie upon switching translation table entries. It seems that from what you
> say, BBML2 then just refers to this but only on the context of switching between
> hugepages/normal pages (?), not in general on all bits of the PTE (which we woud .. upon
> switching from writeable-dirty to writeable-clean with DBM-set).

Yes, BBML is purely about swapping between a block (hugepage) entry and 
a table representing the exact equivalent mapping.

A break-before-make procedure isn't required when just changing 
permissions, and AFAICS it doesn't apply to changing the DBM bit either, 
but as mentioned I think we could probably just not do that anyway.

Robin.
