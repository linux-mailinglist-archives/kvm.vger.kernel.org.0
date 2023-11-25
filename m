Return-Path: <kvm+bounces-2452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D9267F8837
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 05:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBC7E281D14
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 04:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D1E20E8;
	Sat, 25 Nov 2023 04:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80131B5;
	Fri, 24 Nov 2023 20:05:23 -0800 (PST)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.56])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ScdT80YHxz1P8mx;
	Sat, 25 Nov 2023 12:01:48 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm000005.china.huawei.com (7.193.23.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 25 Nov 2023 12:05:19 +0800
Subject: Re: [PATCH v7 00/12] iommu: Prepare to deliver page faults to user
 space
To: Baolu Lu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, Will
 Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Jean-Philippe
 Brucker <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>
CC: Yi Liu <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>, <iommu@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <1a029033-3c9e-aeab-06bf-1e7020c2bc7d@huawei.com>
 <7a683525-07ca-4ff1-97bd-0193d07dc857@linux.intel.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <8757f78c-8f4f-a783-6824-0af44b28fd51@huawei.com>
Date: Sat, 25 Nov 2023 12:05:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <7a683525-07ca-4ff1-97bd-0193d07dc857@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected

On 2023/11/24 20:01, Baolu Lu wrote:
> On 2023/11/24 14:30, liulongfang wrote:
>> On 2023/11/15 11:02, Lu Baolu Wrote:
>>> When a user-managed page table is attached to an IOMMU, it is necessary
>>> to deliver IO page faults to user space so that they can be handled
>>> appropriately. One use case for this is nested translation, which is
>>> currently being discussed in the mailing list.
>>>
>>> I have posted a RFC series [1] that describes the implementation of
>>> delivering page faults to user space through IOMMUFD. This series has
>>> received several comments on the IOMMU refactoring, which I am trying to
>>> address in this series.
>>>
>>> The major refactoring includes:
>>>
>>> - [PATCH 01 ~ 04] Move include/uapi/linux/iommu.h to
>>>    include/linux/iommu.h. Remove the unrecoverable fault data definition.
>>> - [PATCH 05 ~ 06] Remove iommu_[un]register_device_fault_handler().
>>> - [PATCH 07 ~ 10] Separate SVA and IOPF. Make IOPF a generic page fault
>>>    handling framework.
>>> - [PATCH 11 ~ 12] Improve iopf framework for iommufd use.
>>>
>>> This is also available at github [2].
>>>
>>> [1] https://lore.kernel.org/linux-iommu/20230530053724.232765-1-baolu.lu@linux.intel.com/
>>> [2] https://github.com/LuBaolu/intel-iommu/commits/preparatory-io-pgfault-delivery-v7
>>>
>>> Change log:
>>> v7:
>>>   - Rebase to v6.7-rc1.
>>>   - Export iopf_group_response() for global use.
>>>   - Release lock when calling iopf handler.
>>>   - The whole series has been verified to work for SVA case on Intel
>>>     platforms by Zhao Yan. Add her Tested-by to affected patches.
>>>
>>> v6: https://lore.kernel.org/linux-iommu/20230928042734.16134-1-baolu.lu@linux.intel.com/
>>>   - [PATCH 09/12] Check IS_ERR() against the iommu domain. [Jingqi/Jason]
>>>   - [PATCH 12/12] Rename the comments and name of iopf_queue_flush_dev(),
>>>     no functionality changes. [Kevin]
>>>   - All patches rebased on the latest iommu/core branch.
>>>
>>> v5: https://lore.kernel.org/linux-iommu/20230914085638.17307-1-baolu.lu@linux.intel.com/
>>>   - Consolidate per-device fault data management. (New patch 11)
>>>   - Improve iopf_queue_flush_dev(). (New patch 12)
>>>
>>> v4: https://lore.kernel.org/linux-iommu/20230825023026.132919-1-baolu.lu@linux.intel.com/
>>>   - Merge iommu_fault_event and iopf_fault. They are duplicate.
>>>   - Move iommu_report_device_fault() and iommu_page_response() to
>>>     io-pgfault.c.
>>>   - Move iommu_sva_domain_alloc() to iommu-sva.c.
>>>   - Add group->domain and use it directly in sva fault handler.
>>>   - Misc code refactoring and refining.
>>>
>>> v3: https://lore.kernel.org/linux-iommu/20230817234047.195194-1-baolu.lu@linux.intel.com/
>>>   - Convert the fault data structures from uAPI to kAPI.
>>>   - Merge iopf_device_param into iommu_fault_param.
>>>   - Add debugging on domain lifetime for iopf.
>>>   - Remove patch "iommu: Change the return value of dev_iommu_get()".
>>>   - Remove patch "iommu: Add helper to set iopf handler for domain".
>>>   - Misc code refactoring and refining.
>>>
>>> v2: https://lore.kernel.org/linux-iommu/20230727054837.147050-1-baolu.lu@linux.intel.com/
>>>   - Remove unrecoverable fault data definition as suggested by Kevin.
>>>   - Drop the per-device fault cookie code considering that doesn't make
>>>     much sense for SVA.
>>>   - Make the IOMMU page fault handling framework generic. So that it can
>>>     available for use cases other than SVA.
>>>
>>> v1: https://lore.kernel.org/linux-iommu/20230711010642.19707-1-baolu.lu@linux.intel.com/
>>>
>>> Lu Baolu (12):
>>>    iommu: Move iommu fault data to linux/iommu.h
>>>    iommu/arm-smmu-v3: Remove unrecoverable faults reporting
>>>    iommu: Remove unrecoverable fault data
>>>    iommu: Cleanup iopf data structure definitions
>>>    iommu: Merge iopf_device_param into iommu_fault_param
>>>    iommu: Remove iommu_[un]register_device_fault_handler()
>>>    iommu: Merge iommu_fault_event and iopf_fault
>>>    iommu: Prepare for separating SVA and IOPF
>>>    iommu: Make iommu_queue_iopf() more generic
>>>    iommu: Separate SVA and IOPF
>>>    iommu: Consolidate per-device fault data management
>>>    iommu: Improve iopf_queue_flush_dev()
>>>
>>>   include/linux/iommu.h                         | 266 +++++++---
>>>   drivers/iommu/intel/iommu.h                   |   2 +-
>>>   drivers/iommu/iommu-sva.h                     |  71 ---
>>>   include/uapi/linux/iommu.h                    | 161 ------
>>>   .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  14 +-
>>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  51 +-
>>>   drivers/iommu/intel/iommu.c                   |  25 +-
>>>   drivers/iommu/intel/svm.c                     |   8 +-
>>>   drivers/iommu/io-pgfault.c                    | 469 ++++++++++++------
>>>   drivers/iommu/iommu-sva.c                     |  66 ++-
>>>   drivers/iommu/iommu.c                         | 232 ---------
>>>   MAINTAINERS                                   |   1 -
>>>   drivers/iommu/Kconfig                         |   4 +
>>>   drivers/iommu/Makefile                        |   3 +-
>>>   drivers/iommu/intel/Kconfig                   |   1 +
>>>   15 files changed, 601 insertions(+), 773 deletions(-)
>>>   delete mode 100644 drivers/iommu/iommu-sva.h
>>>   delete mode 100644 include/uapi/linux/iommu.h
>>>
>>
>> Tested-By: Longfang Liu <liulongfang@huawei.com>
> 
> Thank you for the testing.
> 
>>
>> The Arm SVA mode based on HiSilicon crypto accelerator completed the functional test
>> and performance test of page fault scenarios.
>> 1. The IOMMU page fault processing function is normal.
>> 2. Performance test on 128 core ARM platform. performance is reduced:
>>
>> Threads  Performance
>> 8         -0.77%
>> 16        -1.1%
>> 32        -0.31%
>> 64        -0.49%
>> 128       -0.72%
>> 256       -1.7%
>> 384       -4.94%
>> 512       NA（iopf timeout）
>>
>> Finally, continuing to increase the number of threads will cause iommu's page fault
>> processing to time out(more than 4.2 seconds).
>> This problem occurs both in the before version(kernel6.7-rc1) and
>> in the after modification's version.
> 
> Probably you can check whether commit 6bbd42e2df8f ("mmu_notifiers: call
> invalidate_range() when invalidating TLBs") matters.
> 
> It was discussed in this thread.
> 
> https://lore.kernel.org/linux-iommu/20231117090933.75267-1-baolu.lu@linux.intel.com/
>

Thanks for your reminder. But the reason for the iopf timeout in this test scenario is
different from what is pointed out in your patch.

Our analysis found that the emergence of iopf is related to the numa balance function.
The CMWQ solution for iommu's iopf currently uses a large number of kernel threads.
The page fault processing in the numa balance function will compete with the page fault
processing in iommu to occupy the CPU.
This will lead to a longer page fault processing time and trigger repeated page faults
in the IO task.This will produce an unpredictable and huge amount of page fault events,
eventually causing the entire system to be unable to respond to page fault processing
in a timely manner.

Thanks.
Longfang.
> Best regards,
> baolu
> 
> .
> 

