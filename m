Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45885FAAA0
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 04:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJKCaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 22:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiJKCaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 22:30:52 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6953581683
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 19:30:49 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MmfpT3JKHzwPTm;
        Tue, 11 Oct 2022 10:28:17 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 10:30:47 +0800
Subject: Re: [PATCH] [PATCH] Revert 'vfio: Delete container_q'
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <1665222631-202970-1-git-send-email-chenxiang66@hisilicon.com>
 <Y0RkLBiZc6RWl3pB@nvidia.com>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <baolu.lu@linux.intel.com>,
        <kevin.tian@intel.com>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <935149c4-984e-837b-1c6c-c3e98dcae51b@hisilicon.com>
Date:   Tue, 11 Oct 2022 10:30:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <Y0RkLBiZc6RWl3pB@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,


在 2022/10/11 2:27, Jason Gunthorpe 写道:
> On Sat, Oct 08, 2022 at 05:50:31PM +0800, chenxiang wrote:
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> We find a issue on ARM64 platform with HNS3 VF SRIOV enabled (VFIO
>> passthrough in qemu):
>> kill the qemu thread, then echo 0 > sriov_numvfs to disable sriov
>> immediately, sometimes we will see following warnings:
> I suspect this is fixed in vfio-next now, in a different way. Please check

Can you point out which patches fix it?
I need to merge back those patches to our version, then have a test.

>
>> After removing container_q, arm_smmu_release_dev() caused by disabling
>> sriov may occur before arm_smmuv3_attach_dev() called by echo 0 > sriov_numvfs,
>> and arm_smmu_attach_dev() may refer to freed iommu_fwspec, so it causes
>> above warnings.
> Which is the same effective issue s390 hit already.
>
> It is interesting that container_q was solving this, that seems to be
> a inadverent side effect nobody noticed.
>
> Jason
> .
>

