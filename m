Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD823120BD
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 02:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhBGBnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Feb 2021 20:43:43 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12139 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhBGBnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Feb 2021 20:43:42 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DYBhf58fzz164j9;
        Sun,  7 Feb 2021 09:41:38 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 09:42:50 +0800
Subject: Re: [RFC PATCH 01/11] iommu/arm-smmu-v3: Add feature detection for
 HTTU
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-2-zhukeqian1@huawei.com>
 <f8be5718-d4d9-0565-eaf0-b5a128897d15@arm.com>
 <df1b8fb2-b853-e797-0072-9dbdffc4ff67@huawei.com> <YB0VErwkA0ivRXTd@myrica>
CC:     Robin Murphy <robin.murphy@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        "Will Deacon" <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>, <jiangkunkun@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Cornelia Huck <cohuck@redhat.com>, <lushenming@huawei.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        James Morse <james.morse@arm.com>,
        <wanghaibin.wang@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <a07eee49-e997-8e7a-f510-64d23b9c9b98@huawei.com>
Date:   Sun, 7 Feb 2021 09:42:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YB0VErwkA0ivRXTd@myrica>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On 2021/2/5 17:51, Jean-Philippe Brucker wrote:
> Hi Keqian,
> 
> On Fri, Feb 05, 2021 at 05:13:50PM +0800, Keqian Zhu wrote:
>>> We need to accommodate the firmware override as well if we need this to be meaningful. Jean-Philippe is already carrying a suitable patch in the SVA stack[1].
>> Robin, Thanks for pointing it out.
>>
>> Jean, I see that the IORT HTTU flag overrides the hardware register info unconditionally. I have some concern about it:
>>
>> If the override flag has HTTU but hardware doesn't support it, then driver will use this feature but receive access fault or permission fault from SMMU unexpectedly.
>> 1) If IOPF is not supported, then kernel can not work normally.
>> 2) If IOPF is supported, kernel will perform useless actions, such as HTTU based dma dirty tracking (this series).
>>
>> As the IORT spec doesn't give an explicit explanation for HTTU override, can we comprehend it as a mask for HTTU related hardware register?
> 
> To me "Overrides the value of SMMU_IDR0.HTTU" is clear enough: disregard
> the value of SMMU_IDR0.HTTU and use the one specified by IORT instead. And
> that's both ways, since there is no validity mask for the IORT value: if
> there is an IORT table, always ignore SMMU_IDR0.HTTU.
> 
> That's how the SMMU driver implements the COHACC bit, which has the same
> wording in IORT. So I think we should implement HTTU the same way.
OK, and Robin said that the latest IORT spec literally states it.

> 
> One complication is that there is no equivalent override for device tree.
> I think it can be added later if necessary, because unlike IORT it can be
> tri state (property not present, overriden positive, overridden negative).
Yeah, that would be more flexible. ;-)

> 
> Thanks,
> Jean
> 
> .
> 
Thanks,
Keqian
