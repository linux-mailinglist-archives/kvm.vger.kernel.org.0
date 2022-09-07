Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEE75B0679
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 16:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiIGOZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 10:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiIGOZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 10:25:11 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E3EB2600;
        Wed,  7 Sep 2022 07:24:23 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCDD91042;
        Wed,  7 Sep 2022 07:23:32 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B9E63F71A;
        Wed,  7 Sep 2022 07:23:15 -0700 (PDT)
Message-ID: <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
Date:   Wed, 7 Sep 2022 15:23:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Content-Language: en-GB
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
        alex.williamson@redhat.com, suravee.suthikulpanit@amd.com,
        marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io,
        robdclark@gmail.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        yangyingliang@huawei.com, jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com> <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <Yxig+zfA2Pr4vk6K@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-07 14:47, Jason Gunthorpe wrote:
> On Wed, Sep 07, 2022 at 02:41:54PM +0200, Joerg Roedel wrote:
>> On Mon, Aug 15, 2022 at 11:14:33AM -0700, Nicolin Chen wrote:
>>> Provide a dedicated errno from the IOMMU driver during attach that the
>>> reason attached failed is because of domain incompatability. EMEDIUMTYPE
>>> is chosen because it is never used within the iommu subsystem today and
>>> evokes a sense that the 'medium' aka the domain is incompatible.
>>
>> I am not a fan of re-using EMEDIUMTYPE or any other special value. What
>> is needed here in EINVAL, but with a way to tell the caller which of the
>> function parameters is actually invalid.
> 
> Using errnos to indicate the nature of failure is a well established
> unix practice, it is why we have hundreds of error codes and don't
> just return -EINVAL for everything.
> 
> What don't you like about it?
> 
> Would you be happier if we wrote it like
> 
>   #define IOMMU_EINCOMPATIBLE_DEVICE xx
> 
> Which tells "which of the function parameters is actually invalid" ?

FWIW, we're now very close to being able to validate dev->iommu against 
where the domain came from in core code, and so short-circuit 
->attach_dev entirely if they don't match. At that point -EINVAL at the 
driver callback level could be assumed to refer to the domain argument, 
while anything else could be taken as something going unexpectedly wrong 
when the attach may otherwise have worked. I've forgotten if we actually 
had a valid case anywhere for "this is my device but even if you retry 
with a different domain it's still never going to work", but I think we 
wouldn't actually need that anyway - it should be clear enough to a 
caller that if attaching to an existing domain fails, then allocating a 
fresh domain and attaching also fails, that's the point to give up.

Robin.
