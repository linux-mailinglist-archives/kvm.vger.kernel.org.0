Return-Path: <kvm+bounces-31077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E619C014B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:40:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5D921C21614
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9341E1C34;
	Thu,  7 Nov 2024 09:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C3sg+5o2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E55126C01
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972411; cv=fail; b=KN9IzT7vyeKWg07jp3GzlMwZ0mBz2PV267EEDgqMo+KzeRQRxGSqcvROPqf5DwOobXBChSj4asdceexyBbsiKzG5UcHFCeZJXB8f+PXuYuA49o931vFVZHlh8uHkS6esS9DIomBkZKO1BbwvQut3Vz7M81o2SlSdaJMp6jfIk0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972411; c=relaxed/simple;
	bh=HxobhjuVf3J4Tg34O2gkg39DvnzQMoiPRE7ho6AYirc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EUmVYdiXAuxXz/mjgFmuMguZvCAvg+5vBa6JJYqmr3kh1Y8GB4KGjbArKOmPxnawDejbiuxuNKSCnsZ637ONrHmkaojsLDrtergU4zv5z7sLIQ/NPyuDeZybSP/L109mcHBub6CzeOW2VncTAzO55U5qwuUELf5RE3IrTZpUGEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C3sg+5o2; arc=fail smtp.client-ip=40.107.95.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xIVIA741NiIf2oFRXLQNeiyBAnVRqzmiASy5tDZdIA2BwZDtrV9i2AKmi+v/8RN+5qLBBFzQvZ/NO03r/RFcYuU4csAvYSjNqb0rXRtIKZBzueFNHSLtxEctQIkM3CqjvZd43yPe2+8V/5UFB7v77qXOkKPDZVcRM4IKjOdWVqdwGVL+Yo0G4gvbRPy4WgKeWNCJWaIfL2POK8hFHzv38bpS+sxlaAw3VU4kl2Fd96zsSaCOKztxwcUcYfnHkksbznso15h9dcqsGZ3edjKKstkDaNwN+x39PYgRUsgjSAMnFKYWPEN9WlVsqDea7mtUPOQ3XqEPn+YpVPRD0Q6mSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HisloP9eTLIIR7J0SDkwd7gQaCznTT5wwDDYxwuukeA=;
 b=x+I0dwaZV18oWVNobiDuGxOAiJHtfqCj4I6j4VGKNzN8zPlYm73R58XXjwt5CfaHTgGO9ClsCr5xGGrpes/UfqxYCGxGCz7ZU0S5EFe6GDl3J3s2wfOdbyKF8bSRO1SniHSMA8dTaDm9he6zPL8FGxHByVXkbfpY02/LoxgitG1g3QSllRViMYzJBpaf1MYqtb3c69BezDz9NXyp0CkjeAdfW9laVxg/rbaL5QCMymuE8ESmSLZTLvYTZFh4oFMbuzygS/2LJ8dyVD2E9THT6KDVLpyCXuhTUO3SSCkSuZ7deq09oMZShPDedZoHtyUbcbH3+z3elI/Pj1+z8UBxag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HisloP9eTLIIR7J0SDkwd7gQaCznTT5wwDDYxwuukeA=;
 b=C3sg+5o2w8abSWXPc4EaECAGmIs6XsU6MgzK0XO/f6CZoo63hxdFhfyb68cB3fR8P0Tt8934RvQBu3+09FIZxBQsz/DUF04TxVtCxmC2mIWvPpgq09Da4J2kQio1UTtWDf3o3sWgJFLAjpqPRQxzzyjOSvXqRE/l9Sl927sSvhptVmqHSMzQmYtnSOD9bMfFULTb8RxHJhHabVdKGUxR3xd7nYRrZ+ncJjLdUU3xX7j3C+hQpu9NRVy00t9YqxuMFQbc898pKXrcsMJMDqrVagWt83+P8Fs4LN8pcnORtL+yXuGimIT8ioc3JOlHeZ8G6/yw4XIAsKEWEoPtsUCnfw==
Received: from DM6PR03CA0061.namprd03.prod.outlook.com (2603:10b6:5:100::38)
 by SJ0PR12MB6806.namprd12.prod.outlook.com (2603:10b6:a03:478::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 09:40:04 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:5:100:cafe::48) by DM6PR03CA0061.outlook.office365.com
 (2603:10b6:5:100::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Thu, 7 Nov 2024 09:40:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 09:40:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 01:39:48 -0800
Received: from [172.27.60.49] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 01:39:43 -0800
Message-ID: <863fe573-3ab2-428a-91fd-aea32d280935@nvidia.com>
Date: Thu, 7 Nov 2024 11:39:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 5/7] vfio/virtio: Add support for the basic live
 migration functionality
To: Alex Williamson <alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
 <20241104102131.184193-6-yishaih@nvidia.com>
 <20241105154746.60e06e75.alex.williamson@redhat.com>
 <eebad7d5-d7c2-4910-872c-c362c246aa78@nvidia.com>
 <20241106143341.1b23936c.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241106143341.1b23936c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|SJ0PR12MB6806:EE_
X-MS-Office365-Filtering-Correlation-Id: 60e73cc6-be3f-4fa5-0435-08dcff102890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUtqQ2hlWUtsVkxVWlZFMzJjdlNsbGloSDMxZTM2UFI2WWw2M1AwL0NkOWJo?=
 =?utf-8?B?bDIxTXlHLyszNlptV1doNHIrc0l4aVA5YmIvVk12Q0JkMHFRRm16K2w0dEkx?=
 =?utf-8?B?U2p6WHlrZDg1a1BhTkQ4RVhZQmE0cG5TTkg2WkhrM0FOM1E0dUpxL2lwRXRO?=
 =?utf-8?B?Ti8walJMdkNZdHF4YWtQK1hYK0hzb29aT0JIbVhQZ1lzc3IzcDNlTTNIYlUx?=
 =?utf-8?B?SXVGaXBhaUVVYXB0Zk41UWt3K255cUt1WVBHbWtjYmJlanIyMS9yY2pMS2RE?=
 =?utf-8?B?TkVXNmlIekQzb00vVUo5R2dRSyt0SHpKeXpGVGRBazRJdGtlQStUODlYL21F?=
 =?utf-8?B?YXNTekJUUElvdEc0S0NKWklpY1VBbjIzSnJST01SOG10TWs5UmdZcmFYSTV2?=
 =?utf-8?B?TEdjM3dKSnNHV015b0VSNzZ0eEwvWUQ1QmZqT0hyRlVvYmlaZStwR2hZYzRv?=
 =?utf-8?B?Tnd4U1lJV3RrcTJsZUFveVM2Rm4wVjhvWCtGZENUQ0FXcjJMNXhNWXRrRnZ6?=
 =?utf-8?B?eVd4MjQ2YnZubkthZk1mNDlNc1hqbjhvVkFncUhSN01QdGxucGVNWkdsb2li?=
 =?utf-8?B?cEU0QnN3NkVvajBmUllQM1RIQmF0blZEWjJ4UjVIa1ZLNlFRNC95aEJTbzQy?=
 =?utf-8?B?NDErTGZKZGtMQjdOcFM3K1NYRm5FV1c4aXJDYy9Qdk9QakRqTEVCRVFUVGFF?=
 =?utf-8?B?VlcxRWVsdWZGd0x4UXpRQytKVWMwbGhGNTJheHYyNnV3bEt6cy9qTUNLam4x?=
 =?utf-8?B?ejhKaXlubUpxVXNrRTF4WU5NMlhHT0ZTSXhkN2VvWjJDVWJXeU42U0JSeTly?=
 =?utf-8?B?WnJXdGtIeDB6N3EwK2JZWWpMSTRWY0x4dTdGWGdTM2FSdWRDYUhCb3BqU1lj?=
 =?utf-8?B?QytvQ0p6dzYrMjBEL1hZdEhCUm1QT0dzR0hYalFVay9uSmVDazhYb3FGaFNq?=
 =?utf-8?B?Ly9KUmpmZENuSVhtNXc1N3lNKytwUWhEVkVFZHVFUVJtWkwxZGltMzFybFNF?=
 =?utf-8?B?dnYwSVpjaWxEMzFZR1FRUmhqRDhrenM1WVJmVmRMT2xGTzlOVmVVei9wazhy?=
 =?utf-8?B?bXF2QlZTeS92RkR1cjhtdHZnM0hsUk83aE93ay9ySlZaNmhudmR1RFAxT25a?=
 =?utf-8?B?RHA3R1F3eUU3YVBwbUh0c1BzZkVGUTIvZ1NPYUtVTGhOYlRrMjZMU1RudGdI?=
 =?utf-8?B?OENJcDVmZ21RRW1qODRLcm9KTTY0V09EZ3lkb0t1WnVOV0IxY3pMRm1mQUpo?=
 =?utf-8?B?U0Z4QUFoNWptS1lzU1F6d0c3QWw3SlVlbTAzeHV4OVZqYURid0gyMVh1bkNa?=
 =?utf-8?B?K3oxZU1DMDlEM2ZmWHE5VnIrRysxVElGbmROUlhhK3FCbmVmaGo2T2ZndnRU?=
 =?utf-8?B?YnoyRkhTZk0yTERkbUxOUEE4M0VTRVMwYzRHQ0s3L3FDWlZpQmUzVy9zckhY?=
 =?utf-8?B?US9aNlhELzZma1VyZUxkQnR6UENIUURiTzNYemJpODlOa2JYK0p6VWlDR2VY?=
 =?utf-8?B?dmliWmtlOTNFTnZJQUo0eEh3ZG9XM2ZscmRnRERJSVp3Z1grbnJKU2o1b0Qw?=
 =?utf-8?B?ZWpmR1NIZmFlcGQ2dVE4cnBVMVRmeXkybUtvd2M3WjRKNGVISi8vR0Q1YW10?=
 =?utf-8?B?SHpEWEY1dWpoVlZJNUloVXY1Z1h5RUVOZ3Y3dlhrd0psL0UyZ3ZFWmJZcSty?=
 =?utf-8?B?WUVkUjlNZzU0MVpRRUx6K1JQb3cvUkptNGdoVDhXY28ycjloV3J2T2N3eGR2?=
 =?utf-8?B?K1JTU1RNbEZ2VElRYU1ORjg4eWNHZUpuOStweVNVS2FqMmxRdnJ0ZUVUVjQz?=
 =?utf-8?B?NDRsWS93TWZkbEZkUzFQN1FXamgzczNBMkZSU2hmVmJIMFZ0RlJSbGVWUm5a?=
 =?utf-8?B?ZDZTUHdZbmNaRXYvelhxenIvTXd5bW5DRVBvcjhlT3QvVEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 09:40:04.3291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e73cc6-be3f-4fa5-0435-08dcff102890
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6806

On 06/11/2024 23:33, Alex Williamson wrote:
> On Wed, 6 Nov 2024 12:21:03 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> On 06/11/2024 0:47, Alex Williamson wrote:
>>> On Mon, 4 Nov 2024 12:21:29 +0200
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
>>>> index b5d3a8c5bbc9..e2cdf2d48200 100644
>>>> --- a/drivers/vfio/pci/virtio/main.c
>>>> +++ b/drivers/vfio/pci/virtio/main.c
>>> ...
>>>> @@ -485,16 +478,66 @@ static bool virtiovf_bar0_exists(struct pci_dev *pdev)
>>>>    	return res->flags;
>>>>    }
>>>>    
>>>> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
>>>> +			struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	struct pci_dev *pdev;
>>>> +	bool sup_legacy_io;
>>>> +	bool sup_lm;
>>>> +	int ret;
>>>> +
>>>> +	ret = vfio_pci_core_init_dev(core_vdev);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	pdev = virtvdev->core_device.pdev;
>>>> +	sup_legacy_io = virtio_pci_admin_has_legacy_io(pdev) &&
>>>> +				!virtiovf_bar0_exists(pdev);
>>>> +	sup_lm = virtio_pci_admin_has_dev_parts(pdev);
>>>> +
>>>> +	/*
>>>> +	 * If the device is not capable to this driver functionality, fallback
>>>> +	 * to the default vfio-pci ops
>>>> +	 */
>>>> +	if (!sup_legacy_io && !sup_lm) {
>>>> +		core_vdev->ops = &virtiovf_vfio_pci_ops;
>>>> +		return 0;
>>>> +	}
>>>> +
>>>> +	if (sup_legacy_io) {
>>>> +		ret = virtiovf_read_notify_info(virtvdev);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +
>>>> +		virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
>>>> +					virtiovf_get_device_config_size(pdev->device);
>>>> +		BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
>>>> +		virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
>>>> +						     GFP_KERNEL);
>>>> +		if (!virtvdev->bar0_virtual_buf)
>>>> +			return -ENOMEM;
>>>> +		mutex_init(&virtvdev->bar_mutex);
>>>> +	}
>>>> +
>>>> +	if (sup_lm)
>>>> +		virtiovf_set_migratable(virtvdev);
>>>> +
>>>> +	if (sup_lm && !sup_legacy_io)
>>>> +		core_vdev->ops = &virtiovf_vfio_pci_lm_ops;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>    static int virtiovf_pci_probe(struct pci_dev *pdev,
>>>>    			      const struct pci_device_id *id)
>>>>    {
>>>> -	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
>>>>    	struct virtiovf_pci_core_device *virtvdev;
>>>> +	const struct vfio_device_ops *ops;
>>>>    	int ret;
>>>>    
>>>> -	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
>>>> -	    !virtiovf_bar0_exists(pdev))
>>>> -		ops = &virtiovf_vfio_pci_tran_ops;
>>>> +	ops = (pdev->is_virtfn) ? &virtiovf_vfio_pci_tran_lm_ops :
>>>> +				  &virtiovf_vfio_pci_ops;
>>>
>>> I can't figure out why we moved the more thorough ops setup to the
>>> .init() callback of the ops themselves.  Clearly we can do the legacy
>>> IO and BAR0 test here and the dev parts test uses the same mechanisms
>>> as the legacy IO test, so it seems we could know sup_legacy_io and
>>> sup_lm here.  I think we can even do virtiovf_set_migratable() here
>>> after virtvdev is allocated below.
>>>    
>>
>> Setting the 'ops' as part of the probe() seems actually doable,
>> including calling virtiovf_set_migratable() following the virtiodev
>> allocation below.
>>
>> The main issue with that approach will be the init part of the legacy IO
>> (i.e. virtiovf_init_legacy_io()) as part of virtiovf_pci_init_device().
>>
>> Assuming that we don't want to repeat calling
>> virtiovf_support_legacy_io() as part of virtiovf_pci_init_device() to
>> know whether legacy IO is supported, we can consider calling
>> virtiovf_init_legacy_io() as part of the probe() as well, which IMO
>> doesn't look clean as it's actually seems to match the init flow.
>>
>> Alternatively, we can consider checking inside
>> virtiovf_pci_init_device() whether the 'ops' actually equals the 'tran'
>> ones and then call it.
>>
>> Something like the below.
>>
>> static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
>> {
>> 	...
>>
>> #ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
>> 	if (core_vdev->ops == &virtiovf_vfio_pci_tran_lm_ops)
>> 		return virtiovf_init_legacy_io(virtvdev);
>> #endif
>>
>> 	return 0;
>> }
>>
>> Do you prefer the above approach rather than current V1 code which has a
>>    single check as part of virtiovf_init_legacy_io() ?
> 
> If ops is properly configured and set-migratable is done in probe,
> then doesn't only the legacy ops .init callback need to init the legacy
> setup?  The non-legacy, migration ops structure would just use
> vfio_pci_core_init_dev.

Correct, this seems as a clean solution, will use it as part of V2.

> 
>>
>>> I think the API to vfio core also suggests we shouldn't be modifying the
>>> ops pointer after the core device is allocated.
>>
>> Any pointer for that ?
>> Do we actually see a problem with replacing the 'ops' as part of the
>> init flow ?
> 
> What makes it that way to me is that it's an argument to and set by the
> object constructor.  The ops callbacks should be considered live once
> set.  It's probably safe to do as you've done here because the
> constructor calls the init callback directly, so we don't have any
> races.  However as Jason agreed, it's generally a pattern to avoid and I
> think we can rather easily do so here.  Thanks,
> 

Yes, makes sense.

Thanks,
Yishai

