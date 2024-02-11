Return-Path: <kvm+bounces-8512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E0B850818
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 09:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCE57283AD7
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 08:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D737045972;
	Sun, 11 Feb 2024 08:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lTotGaI0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01B144C7C;
	Sun, 11 Feb 2024 08:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707639462; cv=fail; b=fV3grmXfhL0R2I9wGBffXj2G9xJnQKTgVCbZAQ0RPtGtU2I7YRUDRuJhGxfZEGO9bqxA+fVms4OxVH6ZpEq4MUv7IXToHUaITsdcvorLh3E94n+OUrU67+wTbQHnOwoscfEEwJSCluSOjtXb5XRGSuUUdMbuvwzPep+AASbDosI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707639462; c=relaxed/simple;
	bh=dezd1FmlnH4ayRMOATtfgz/B6M2AUoCsSOfBP4mal+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jzEG62oHmBAbMqIiF+rR1M0sk3lEZXhy0LWgQG7CLuTB3KjVrJ01+6RgJuTR8wdlVnn+/MkQKnPjOPtlJ9VlJyuW0h3A4HtCOMdOHSbgkHp50uS749zsaiwo+9WhFxQtpOPZkJSrgaH1SlM2U9vC0/g4kdNLbZPBGkjGtSbTCU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lTotGaI0; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+PuFOb+LhcjS/DQVL/NA66IFbCI3cmebUjDaDjuHDx+5BS+5HOyBK1EbSJ1nrCX+qrAlTI9jnEFbYG/0KG00QNiy3m2hrbYTP8IIDOFfuIx44gv93bk1G0JHrtmqaglZLuJM4UEERcS0tyP7R9EvJ+816ilELLYQ5S8o88YsS6IiT2QnVgy1JyR9Hc8OlPYVpnaqX7nRCtelPNNZS2r5au6synN/D0q40oiTBrxmAeNleMU1UBjUOkoDp1t5Jzwuja2dfZHsHUgfuTIwle/9ePUheFjp3rwvzIf32AOCCvtSYY/3dgnO7vfR3tFLHOI18xBi98mXOSWMslfY8w2Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eto3X42Ai6Jq6vtJg5MH1Re5YFDcVHMEutmCcRxaiUs=;
 b=bT7ozs/YTXd+/DnUTX0r4eUxPj4l7Hld9m4THB/arli6ancHvqznZssZjMsBvo0keFr5lizihlbyH1OUrgjBIec+Rn2bMLpoRLHAH4uFrBbSntpgfeXSZMj5NIIjN8yXOG8kuXTK1v2kR0GKa1W7O+gs1Ixku8Z2e+12E+9mfU2dIiAJvKnKA0J1Ee/DPXy56twkvibaa+AlyUR8WKqzFiTxYQSNG4XwF0KlLDtG6j4cpvdAfv6riThGQEJrHElodZ5IM+TV0ZMset2n82Y+o5QYVQayjb8Dwx4s9u7Zzo2QQkxmU1wrCwSM7I23AiHVJm7hiz0TqPNNYyIp1KRkiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eto3X42Ai6Jq6vtJg5MH1Re5YFDcVHMEutmCcRxaiUs=;
 b=lTotGaI0Uy8ZTXhZfddiHw60l9knuSkOuFsjm9PWNtXb84JORfKUF/QPZxKlzG/nX9atpWTkkBuTYxMTnIGdVMFAo1jCZeyqRI22CSHlXZ9shKnOEhqzcGEfZQyCM/uzmR1CPlN/UyoMkjfICnIoc+sQQ3BKp9YeJkOC4JPODfNxxj+7SDGgorVlTp15pfQnM7NiLpH4RktsEmD+/SmAG9by01Yw5vsHM0Cmmae/0qad3E/YHE4aNXHCTtJb0i5BcVaQxFNKWaQB2vI1N4gyaDjom7Kdgpe4GPCIZzCLUJBlDpzMylUko27yhfVhg259W4hWKdkeJkD27ga6dzS4FA==
Received: from SJ0PR13CA0151.namprd13.prod.outlook.com (2603:10b6:a03:2c7::6)
 by MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.18; Sun, 11 Feb
 2024 08:17:36 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::e6) by SJ0PR13CA0151.outlook.office365.com
 (2603:10b6:a03:2c7::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17 via Frontend
 Transport; Sun, 11 Feb 2024 08:17:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7249.19 via Frontend Transport; Sun, 11 Feb 2024 08:17:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 11 Feb
 2024 00:17:20 -0800
Received: from [172.27.50.144] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Sun, 11 Feb
 2024 00:17:17 -0800
Message-ID: <e740d9ec-6783-4777-b984-98262566974c@nvidia.com>
Date: Sun, 11 Feb 2024 10:17:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, "Zeng, Xin" <xin.zeng@intel.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240209121045.GP10476@nvidia.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20240209121045.GP10476@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|MN2PR12MB4206:EE_
X-MS-Office365-Filtering-Correlation-Id: a79c3b4c-8d59-4e95-0acb-08dc2ad9e77b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eO+tl5dlXdylZzBez6FyLP7L4UbxeH5zduwyQMGipH9ARIlhX5MA5ciODsy5dzsdXb+FlXrs5P7fJEjskn9CL/mvHjBxiUZgxbEVQfnLL8kmkZVVSX99DUdU4mObtfG0OtQg/RKvYEOWDWK1E4ZLzSZ+eNb9otWkWa1qVZOms8eXk1nEF2r9zb9vamiBrjf/FPAcwKyPbCmj9d1czTiQV1f0TK4JBoivP7OrCMCFuJsvc2Tteo1uOgFm8iV5E0gL+bRcDnCnzUp1Wrb6xDoaLvsYm8e0VgkWPQ18PVike5xaLj7MNetOhkCicQ/9Ii6ZHRXWLRXHF5Cqg2hoyI4BX3hLwDUUn4dWjXzdcmpx4fd5M8vJ5ocMPcv7UATeprUYA8H5/vQocz0FfE8nBpxcqWsDK/4sMIdl1+VIhK366BjPgQk5smORFKhFsDoEFLEk0oML3ty4WnPUTGYKiWKw2aZnuqQaOgT6JudkgLqrfze4uDLK7XUXqP3cuMoFpdvYEaRqJggTX06OO0EEMBiFk9EIHSgDpczuu1oHvE+6GNv1vvBaaMEgnJ1PiA2gBKtIh7fmI+n0QT3e64BeEXrIFTZZk4mV8GdYZC09tYuU3m0=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230273577357003)(230922051799003)(82310400011)(451199024)(1800799012)(186009)(64100799003)(36840700001)(40470700004)(46966006)(2906002)(36756003)(54906003)(53546011)(316002)(82740400003)(16576012)(6666004)(110136005)(426003)(336012)(478600001)(26005)(2616005)(41300700001)(16526019)(70586007)(83380400001)(8936002)(8676002)(4326008)(86362001)(70206006)(5660300002)(31696002)(7636003)(356005)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2024 08:17:35.8388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a79c3b4c-8d59-4e95-0acb-08dc2ad9e77b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4206

On 09/02/2024 14:10, Jason Gunthorpe wrote:
> On Fri, Feb 09, 2024 at 08:23:32AM +0000, Zeng, Xin wrote:
>> Thanks for your comments, Jason.
>> On Tuesday, February 6, 2024 8:55 PM, Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>> +
>>>> +	ops = mdev->ops;
>>>> +	if (!ops || !ops->init || !ops->cleanup ||
>>>> +	    !ops->open || !ops->close ||
>>>> +	    !ops->save_state || !ops->load_state ||
>>>> +	    !ops->suspend || !ops->resume) {
>>>> +		ret = -EIO;
>>>> +		dev_err(&parent->dev, "Incomplete device migration ops
>>> structure!");
>>>> +		goto err_destroy;
>>>> +	}
>>>
>>> Why are there ops pointers here? I would expect this should just be
>>> direct function calls to the PF QAT driver.
>>
>> I indeed had a version where the direct function calls are Implemented in
>> QAT driver, while when I look at the functions, most of them
>> only translate the interface to the ops pointer. That's why I put
>> ops pointers directly into vfio variant driver.
> 
> But why is there an ops indirection at all? Are there more than one
> ops?
> 
>>>> +static void qat_vf_pci_aer_reset_done(struct pci_dev *pdev)
>>>> +{
>>>> +	struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
>>>> +
>>>> +	if (!qat_vdev->core_device.vdev.mig_ops)
>>>> +		return;
>>>> +
>>>> +	/*
>>>> +	 * As the higher VFIO layers are holding locks across reset and using
>>>> +	 * those same locks with the mm_lock we need to prevent ABBA
>>> deadlock
>>>> +	 * with the state_mutex and mm_lock.
>>>> +	 * In case the state_mutex was taken already we defer the cleanup work
>>>> +	 * to the unlock flow of the other running context.
>>>> +	 */
>>>> +	spin_lock(&qat_vdev->reset_lock);
>>>> +	qat_vdev->deferred_reset = true;
>>>> +	if (!mutex_trylock(&qat_vdev->state_mutex)) {
>>>> +		spin_unlock(&qat_vdev->reset_lock);
>>>> +		return;
>>>> +	}
>>>> +	spin_unlock(&qat_vdev->reset_lock);
>>>> +	qat_vf_state_mutex_unlock(qat_vdev);
>>>> +}
>>>
>>> Do you really need this? I thought this ugly thing was going to be a
>>> uniquely mlx5 thing..
>>
>> I think that's still required to make the migration state synchronized
>> if the VF is reset by other VFIO emulation paths. Is it the case?
>> BTW, this implementation is not only in mlx5 driver, but also in other
>> Vfio pci variant drivers such as hisilicon acc driver and pds
>> driver.
> 
> It had to specifically do with the mm lock interaction that, I
> thought, was going to be unique to the mlx driver. Otherwise you could
> just directly hold the state_mutex here.
> 
> Yishai do you remember the exact trace for the mmlock entanglement?
> 

I found in my in-box (from more than 2.5 years ago) the below [1] 
lockdep WARNING when the state_mutex was used directly.

Once we moved to the 'deferred_reset' mode it solved that.

[1]
[  +1.063822] ======================================================
[  +0.000732] WARNING: possible circular locking dependency detected
[  +0.000747] 5.15.0-rc3 #236 Not tainted
[  +0.000556] ------------------------------------------------------
[  +0.000714] qemu-system-x86/7731 is trying to acquire lock:
[  +0.000659] ffff888126c64b78 (&vdev->vma_lock){+.+.}-{3:3}, at: 
vfio_pci_mmap_fault+0x35/0x140 [vfio_pci_core]
[  +0.001127]
               but task is already holding lock:
[  +0.000803] ffff888105f4c5d8 (&mm->mmap_lock#2){++++}-{3:3}, at: 
vaddr_get_pfns+0x64/0x240 [vfio_iommu_type1]
[  +0.001119]
               which lock already depends on the new lock.

[  +0.001086]
               the existing dependency chain (in reverse order) is:
[  +0.000910]
               -> #3 (&mm->mmap_lock#2){++++}-{3:3}:
[  +0.000844]        __might_fault+0x56/0x80
[  +0.000572]        _copy_to_user+0x1e/0x80
[  +0.000556]        mlx5vf_pci_mig_rw.cold+0xa1/0x24f [mlx5_vfio_pci]
[  +0.000732]        vfs_read+0xa8/0x1c0
[  +0.000547]        __x64_sys_pread64+0x8c/0xc0
[  +0.000580]        do_syscall_64+0x3d/0x90
[  +0.000566]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  +0.000682]
               -> #2 (&mvdev->state_mutex){+.+.}-{3:3}:
[  +0.000899]        __mutex_lock+0x80/0x9d0
[  +0.000566]        mlx5vf_reset_done+0x2c/0x40 [mlx5_vfio_pci]
[  +0.000697]        vfio_pci_core_ioctl+0x585/0x1020 [vfio_pci_core]
[  +0.000721]        __x64_sys_ioctl+0x436/0x9a0
[  +0.000588]        do_syscall_64+0x3d/0x90
[  +0.000584]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  +0.000674]
               -> #1 (&vdev->memory_lock){+.+.}-{3:3}:
[  +0.000843]        down_write+0x38/0x70
[  +0.000544]        vfio_pci_zap_and_down_write_memory_lock+0x1c/0x30 
[vfio_pci_core]
[  +0.003705]        vfio_basic_config_write+0x1e7/0x280 [vfio_pci_core]
[  +0.000744]        vfio_pci_config_rw+0x1b7/0x3af [vfio_pci_core]
[  +0.000716]        vfs_write+0xe6/0x390
[  +0.000539]        __x64_sys_pwrite64+0x8c/0xc0
[  +0.000603]        do_syscall_64+0x3d/0x90
[  +0.000572]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  +0.000661]
               -> #0 (&vdev->vma_lock){+.+.}-{3:3}:
[  +0.000828]        __lock_acquire+0x1244/0x2280
[  +0.000596]        lock_acquire+0xc2/0x2c0
[  +0.000556]        __mutex_lock+0x80/0x9d0
[  +0.000580]        vfio_pci_mmap_fault+0x35/0x140 [vfio_pci_core]
[  +0.000709]        __do_fault+0x32/0xa0
[  +0.000556]        __handle_mm_fault+0xbe8/0x1450
[  +0.000606]        handle_mm_fault+0x6c/0x140
[  +0.000624]        fixup_user_fault+0x6b/0x100
[  +0.000600]        vaddr_get_pfns+0x108/0x240 [vfio_iommu_type1]
[  +0.000726]        vfio_pin_pages_remote+0x326/0x460 [vfio_iommu_type1]
[  +0.000736]        vfio_iommu_type1_ioctl+0x43b/0x15a0 [vfio_iommu_type1]
[  +0.000752]        __x64_sys_ioctl+0x436/0x9a0
[  +0.000588]        do_syscall_64+0x3d/0x90
[  +0.000571]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[  +0.000677]
               other info that might help us debug this:

[  +0.001073] Chain exists of:
                 &vdev->vma_lock --> &mvdev->state_mutex --> 
&mm->mmap_lock#2

[  +0.001285]  Possible unsafe locking scenario:

[  +0.000808]        CPU0                    CPU1
[  +0.000599]        ----                    ----
[  +0.000593]   lock(&mm->mmap_lock#2);
[  +0.000530]                                lock(&mvdev->state_mutex);
[  +0.000725]                                lock(&mm->mmap_lock#2);
[  +0.000712]   lock(&vdev->vma_lock);
[  +0.000532]
                *** DEADLOCK ***

[  +0.000922] 2 locks held by qemu-system-x86/7731:
[  +0.000597]  #0: ffff88810c9bec88 (&iommu->lock#2){+.+.}-{3:3}, at: 
vfio_iommu_type1_ioctl+0x189/0x15a0 [vfio_iommu_type1]
[  +0.001177]  #1: ffff888105f4c5d8 (&mm->mmap_lock#2){++++}-{3:3}, at: 
vaddr_get_pfns+0x64/0x240 [vfio_iommu_type1]
[  +0.001153]
               stack backtrace:
[  +0.000689] CPU: 1 PID: 7731 Comm: qemu-system-x86 Not tainted 
5.15.0-rc3 #236
[  +0.000932] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  +0.001192] Call Trace:
[  +0.000454]  dump_stack_lvl+0x45/0x59
[  +0.000527]  check_noncircular+0xf2/0x110
[  +0.000557]  __lock_acquire+0x1244/0x2280
[  +0.002462]  lock_acquire+0xc2/0x2c0
[  +0.000534]  ? vfio_pci_mmap_fault+0x35/0x140 [vfio_pci_core]
[  +0.000684]  ? lock_is_held_type+0x98/0x110
[  +0.000565]  __mutex_lock+0x80/0x9d0
[  +0.000542]  ? vfio_pci_mmap_fault+0x35/0x140 [vfio_pci_core]
[  +0.000676]  ? vfio_pci_mmap_fault+0x35/0x140 [vfio_pci_core]
[  +0.000681]  ? mark_held_locks+0x49/0x70
[  +0.000551]  ? lock_is_held_type+0x98/0x110
[  +0.000575]  vfio_pci_mmap_fault+0x35/0x140 [vfio_pci_core]
[  +0.000679]  __do_fault+0x32/0xa0
[  +0.000700]  __handle_mm_fault+0xbe8/0x1450
[  +0.000571]  handle_mm_fault+0x6c/0x140
[  +0.000564]  fixup_user_fault+0x6b/0x100
[  +0.000556]  vaddr_get_pfns+0x108/0x240 [vfio_iommu_type1]
[  +0.000666]  ? lock_is_held_type+0x98/0x110
[  +0.000572]  vfio_pin_pages_remote+0x326/0x460 [vfio_iommu_type1]
[  +0.000710]  vfio_iommu_type1_ioctl+0x43b/0x15a0 [vfio_iommu_type1]
[  +0.001050]  ? find_held_lock+0x2b/0x80
[  +0.000561]  ? lock_release+0xc2/0x2a0
[  +0.000537]  ? __fget_files+0xdc/0x1d0
[  +0.000541]  __x64_sys_ioctl+0x436/0x9a0
[  +0.000556]  ? lockdep_hardirqs_on_prepare+0xd4/0x170
[  +0.000641]  do_syscall_64+0x3d/0x90
[  +0.000529]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  +0.000670] RIP: 0033:0x7f54255bb45b
[  +0.000541] Code: 0f 1e fa 48 8b 05 2d aa 2c 00 64 c7 00 26 00 00 00 
48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fd a9 2c 00 f7 d8 64 89 01 48
[  +0.001843] RSP: 002b:00007f5415ca3d38 EFLAGS: 00000206 ORIG_RAX: 
0000000000000010
[  +0.000929] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007f54255bb45b
[  +0.000781] RDX: 00007f5415ca3d70 RSI: 0000000000003b71 RDI: 
0000000000000012
[  +0.000775] RBP: 00007f5415ca3da0 R08: 0000000000000000 R09: 
0000000000000000
[  +0.000777] R10: 00000000fe002000 R11: 0000000000000206 R12: 
0000000000000004
[  +0.000775] R13: 0000000000000000 R14: 00000000fe000000 R15: 
00007f5415ca47c0

Yishai


