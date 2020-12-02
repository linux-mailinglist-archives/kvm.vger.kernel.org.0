Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F052CBDA3
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 14:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgLBNAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 08:00:53 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8495 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgLBNAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 08:00:53 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CmJw55c63zhlpC;
        Wed,  2 Dec 2020 20:59:49 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Wed, 2 Dec 2020 21:00:01 +0800
To:     Auger Eric <eric.auger@redhat.com>
CC:     <alex.williamson@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <jean-philippe@linaro.org>,
        <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <maz@kernel.org>, <robin.murphy@arm.com>, <vivek.gautam@arm.com>,
        <will@kernel.org>, <zhangfei.gao@linaro.org>,
        <xieyingtai@huawei.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
From:   Wang Xingang <wangxingang5@huawei.com>
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Message-ID: <8cf8fa21-41e3-f3f9-81e4-90f0bfc26fc0@huawei.com>
Date:   Wed, 2 Dec 2020 20:59:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for your reply. We are testing vSVA, and will let you know if
other problems are found.

On 2020/12/1 21:58, Auger Eric wrote:
> Hi Xingang,
> 
> On 12/1/20 2:33 PM, Xingang Wang wrote:
>> Hi Eric
>>
>> On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
>>> @@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>>> 	 * insertion to guarantee those are observed before the TLBI. Do be
>>> 	 * careful, 007.
>>> 	 */
>>> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>>> +	if (ext_asid >= 0) { /* guest stage 1 invalidation */
>>> +		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
>>> +		cmd.tlbi.asid	= ext_asid;
>>> +		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
>>> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>>
>> Found a problem here, the cmd for guest stage 1 invalidation is built,
>> but it is not delivered to smmu.
>>
> 
> Thank you for the report. I will fix that soon. With that fixed, have
> you been able to run vSVA on top of the series. Do you need other stuff
> to be fixed at SMMU level? As I am going to respin soon, please let me
> know what is the best branch to rebase to alleviate your integration.
> 
> Best Regards
> 
> Eric
> 
> .
> 
