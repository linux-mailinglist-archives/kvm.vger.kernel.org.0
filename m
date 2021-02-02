Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9574930B7EE
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 07:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhBBGku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 01:40:50 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11669 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhBBGks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 01:40:48 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DVFWK6sbBzlFB2;
        Tue,  2 Feb 2021 14:38:21 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Feb 2021 14:39:54 +0800
Subject: Re: [PATCH v13 03/15] iommu/arm-smmu-v3: Maintain a SID->device
 structure
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-4-eric.auger@redhat.com>
 <a5cc1635-b69b-50a6-404a-5bf667296669@huawei.com> <YBgbESEyReLV124Z@myrica>
CC:     <eric.auger.pro@gmail.com>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
        <joro@8bytes.org>, <maz@kernel.org>, <robin.murphy@arm.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@linux.intel.com>,
        <nicoleotsuka@gmail.com>, <vivek.gautam@arm.com>,
        <yi.l.liu@intel.com>, <zhangfei.gao@linaro.org>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <e579b8d7-1e8e-965f-965c-00efdf604eef@huawei.com>
Date:   Tue, 2 Feb 2021 14:39:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YBgbESEyReLV124Z@myrica>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On 2021/2/1 23:15, Jean-Philippe Brucker wrote:
> On Mon, Feb 01, 2021 at 08:26:41PM +0800, Keqian Zhu wrote:
>>> +static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>>> +				  struct arm_smmu_master *master)
>>> +{
>>> +	int i;
>>> +	int ret = 0;
>>> +	struct arm_smmu_stream *new_stream, *cur_stream;
>>> +	struct rb_node **new_node, *parent_node = NULL;
>>> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
>>> +
>>> +	master->streams = kcalloc(fwspec->num_ids,
>>> +				  sizeof(struct arm_smmu_stream), GFP_KERNEL);
>>> +	if (!master->streams)
>>> +		return -ENOMEM;
>>> +	master->num_streams = fwspec->num_ids;
>> This is not roll-backed when fail.
> 
> No need, the caller frees master
OK.

> 
>>> +
>>> +	mutex_lock(&smmu->streams_mutex);
>>> +	for (i = 0; i < fwspec->num_ids && !ret; i++) {
>> Check ret at here, makes it hard to decide the start index of rollback.
>>
>> If we fail at here, then start index is (i-2).
>> If we fail in the loop, then start index is (i-1).
>>
> [...]
>>> +	if (ret) {
>>> +		for (; i > 0; i--)
>> should be (i >= 0)?
>> And the start index seems not correct.
> 
> Indeed, this whole bit is wrong. I'll fix it while resending the IOPF
> series.
> 
> Thanks,
> Jean
OK, I am glad it helps.

Thanks,
Keqian
