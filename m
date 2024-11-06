Return-Path: <kvm+bounces-30910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE52A9BE427
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFC3BB23FEF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0367D1DDC34;
	Wed,  6 Nov 2024 10:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="arnkT7Yr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F611DDC0F
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 10:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730888491; cv=fail; b=JUechXsdIDeNDQYE4gcZT06eznqcBLZF7aQ+gQhXWuvDLwhopK1uWwjCBV6Xpyx7wyMNlIy+rtVhSAT5IacvbpSGm87wHzcCPn9iuYzg/6lv0PGCuyPxt7ChkltbNz1aojkmsjpQAdN/fRlePZoxWZS3C+vsuc/tH5AdaxlT0Y0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730888491; c=relaxed/simple;
	bh=gUsPIO5jQaIEgyIYepSFWd18aN80GE5GiRH2T+wOdeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=i0d1/ejtMHyRgvtAK30zXa0w0y0iesy2mPlY2fgTwGft2hLd/hOr6OkMVNGw8i9ZZvECjyn5/bPtXPXJFH53nWhOfm5ofIvZjVj84kwiH2J3JdH0YM+6qt/ls9vior356jim9LAhO2WOTHMjv7wXzsKg2AqhlkqyAr0r6JXfOWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=arnkT7Yr; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LylHJ3e7XeP9UhpMCDHGABCohwcF2jFy0VVRcP6BffM3i+grnnGnJNwjHV2LrJtfN39XBQoEg51uqrgXhAEuHDNJl0u+4TDlqHWBxIAg7nHQvWqByn4kl8gdSzn5PWuEbLIV2rx0ssqXH+afS57sLHRP1CeDNHrVdgDoFy1cydvWxfBTh/EWLX8g8Fdi514997HIkdnyHquKMWXwn3sUxMT3LOAonMH24FWwHG/ead819HLQu9OVf0tcB94POcdoq8OnDYPanQIllStCwxBzCUVNr5pKT0yuetI/E36dOK3BM5OPNImjF5jh5XlGLcVIqa6AyTzRsD2w3pwq9U+TCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVRf5EpOxYDHAaIx9marpZUHLXAuuWKNebBfPC4ldtM=;
 b=KfPe//0zVLiWsk3Yf8/Hm/4urlTmrGUmlFjUGSvyFAKlw13OcCmqKZi1Op+pM70Ewnfg+1FCzH5Zq0c6gqWXhzTzHA3eCJgEu/0Gdrmi7xhFA09E/bU0ZOqTtjc4GiCYz6XrPa//6GPY9Jl2OKVw/2uXYTxeFs2ZBNvj6VG8yNveT03LGYyFkxVy2IuRgEo3FgNctvvFLYjbLhkJXf5a8p+Cdnzt6YGFJ4i1yBlqYa0CyxpZ8mH0xEjOSkuW3y9jNJMqXAq+BKI7C1OBLFKoRlQqdBbMra8OIQRnO13AdZPOQxBPoDq4zJx5JORju14iZFictuR8bldzmoJtPVyMOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVRf5EpOxYDHAaIx9marpZUHLXAuuWKNebBfPC4ldtM=;
 b=arnkT7YrOFuHRh4OCrGEszIQzO9dzurJoqI75qgpvUR1pTaBlqCktyhgkua5k80IRodYiNROp7lBC/qsCL7jS/FyvILmHOQKRJ1DGkmc1fyiC7VPREYesDScZyAqfHD3w5kpYpAKVLPm2RbC8jFygaAtNh/B1oBb8tEqhwsakdj1mbe/qMLhaaVMWyJJYCSHq+8Ac37VYQtQKPk2FD8MiaaDQZrqvhR1Uty0Z6vxF7xPR0xcopUp27v1vkJxbXAunwfUbp3Id3CTNHBJzTAXuh2kDDX0GgHUEsnUcr3GfAR9QkH6wQi6Npgh/EduFXBRah02bOv0XH+CP86tYEbXwg==
Received: from BN1PR10CA0002.namprd10.prod.outlook.com (2603:10b6:408:e0::7)
 by DM4PR12MB5841.namprd12.prod.outlook.com (2603:10b6:8:64::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 10:21:26 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:408:e0:cafe::d7) by BN1PR10CA0002.outlook.office365.com
 (2603:10b6:408:e0::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Wed, 6 Nov 2024 10:21:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.0 via Frontend Transport; Wed, 6 Nov 2024 10:21:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 6 Nov 2024
 02:21:11 -0800
Received: from [172.27.60.49] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 6 Nov 2024
 02:21:06 -0800
Message-ID: <eebad7d5-d7c2-4910-872c-c362c246aa78@nvidia.com>
Date: Wed, 6 Nov 2024 12:21:03 +0200
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
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241105154746.60e06e75.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|DM4PR12MB5841:EE_
X-MS-Office365-Filtering-Correlation-Id: fd7c7617-6881-4c93-825e-08dcfe4cc550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnA4UVY0RWhNYVJHck9nWDgrMUVXVlNrdHpUUjlUejkwNDRFdFFYVjVrRStu?=
 =?utf-8?B?QXplZFlQOWxlVUZIN3BLZEduUy9wNW02TEJ5bGdiZUo2cklGb2VwUVp6QlJn?=
 =?utf-8?B?OXNVaThid1FWQkM5K3BnQThJWFVPNjI4bDdtYXkzRGx4QnRKbzRzRlRXMTdM?=
 =?utf-8?B?VW5kQmhKNnZvZWsxb3YzRzZJSnFjY28zdzl0KytKNTZTRTM2QmdBOXBETlpZ?=
 =?utf-8?B?QWtVUzJYTGJiT0I5MlNrNDNXS1BHS09abU9pa2Jhb1pmVUdhZi95TllNaENG?=
 =?utf-8?B?N0RaTXdWVEM2RFlzdFpFUWRhVzVUalhLSWpNakFLQmwzdTFEYjRsWDUvSHdY?=
 =?utf-8?B?MW1zQ3owYUROaU5ZbXNSSzRYUHRIdHhNODFhU3BJRFI4Y2gvSk1nWDRkTVdj?=
 =?utf-8?B?RTMreFpUUjlYanlaakZ4TjkrNzltTlVBOG0rSjMwRDF0THE0MnNmYVVKUnE1?=
 =?utf-8?B?WGhNRkUwbFFiOThxaitPTzZGOEVTeG1KYkZWYTZDV09WbVVNUFl4VWJaWFB5?=
 =?utf-8?B?RmxrVERYUFRHNllXUTExRUtWNGFOcWZ1aTRxcEExNllxV2t2ZTdSem43VWRG?=
 =?utf-8?B?MzdyLzh1eVJETFE5U1UyVEdCZHpLdEh5b0pRVHRwWFpsOGRaQ05TVkhOUXRM?=
 =?utf-8?B?KzQ1dGlYRXg0eVB2SW90MlpSeGp3K1padC9sdVlPMk1iUkVXS3lCNk1xNmY5?=
 =?utf-8?B?a2ZqVmkwT1VxNysrYzJPdjJ3ZjRMaE1sWVVzenIyNjFLd2k4M2dHOXBzTnAz?=
 =?utf-8?B?NmFXMjRFRjVvZlFxbjVZMHhSZU9oTGlXOTNBMi8yWGJ2VWRuakZ3Y2c0L21P?=
 =?utf-8?B?NXJlbHNkTExpakxrcnZnY01PODVtZ0YxckYwMzZmUGRUbTBrd3pxdEVvTWRr?=
 =?utf-8?B?TmlxTVlKcmJ0dUFWcHpncTFuZE1kUGZQdStRQjNiY2JWM3N0YitsN29YSU00?=
 =?utf-8?B?RnZ3cnNNdDY4N1UzUmljUDJacGhNa1pKMHRhSVdhSExWcnR2Rm93QWE0WVYx?=
 =?utf-8?B?SHJsVXZ4NjNQTUtJMVpYQk9RdjlxZTZzQTVTaVZHMXField6a3ZhalJOdFlX?=
 =?utf-8?B?WEtRd2I1ck1wY2U0Uis5OFJsZHVXbVFxNi9lZ0ZKS1pCcjQwVmpHR0VvVDVp?=
 =?utf-8?B?SnlYVTM4NVVBakY4S0d6dFlPVzlhajNZNUN3bkZTSHlTWWpNT0pNZHRBZnE1?=
 =?utf-8?B?cnQ1Z2ZZSVJxQ09LUXhOUTV6RXFJK1RCZ3VXU1RRZmcveC94Ly9CV0tmdlFq?=
 =?utf-8?B?WWJLMEhHeU05V0FJVlYzbnRQTFRoc09BYmZybUFRaDBCM1NRMGh3Um9TemZW?=
 =?utf-8?B?a0htMGVVbThOSXpzU3R3L3Z2enVsa0IyU0t4ajBRcm5MRFNZUjY3RFJ6UVdT?=
 =?utf-8?B?eGJmK29UV2wxenFTaDJYdlpkcitBMGRMUklKYUc1L2ZQeEd3YWRWT3JEek0w?=
 =?utf-8?B?OU5wL0xOREorYXNDbnNwaFhwQ3RZNEJxWmRabXJQaDMrNzhmcG5NbndvYUht?=
 =?utf-8?B?cmtnRkFQNmpWd05yd3M3Qmo1K2h0QkpSem81RFYyQjFZKy9ZRmN6QkpBQjgv?=
 =?utf-8?B?WEhOUVd3bHlFUE1kQitCRmFseG85Tlh5dlQ4ajI3U1RmZ1pSMDcrZ0VvZnhG?=
 =?utf-8?B?V3lISWR4UUczWWZ3U2ozN1ZjMXdiaDJBS2lTRnZtbXFmQzE5YkNJeWpBTDBx?=
 =?utf-8?B?Ymc0a0lGSW1mZnlCekc1bnAvd1NsMDFvQjUza3pIU1JJeThCSDl6aW9VME1J?=
 =?utf-8?B?djMrbDNrWHI4MHVoRHBXTTF2VmZaLzk0VW0zeWx3TW1WVk1PZk5JcXMwQWRm?=
 =?utf-8?B?R1Zsb2N4dzZ2MjEwWVpuK1BkYm16dmtZb1Nka2xhUHMvU3hicytvdW9kOWY5?=
 =?utf-8?B?RkZmalY3eDA0bnBRV1VqSVV3R2NjRUtqRG1QcTNyNE50OXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 10:21:25.9093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd7c7617-6881-4c93-825e-08dcfe4cc550
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5841

On 06/11/2024 0:47, Alex Williamson wrote:
> On Mon, 4 Nov 2024 12:21:29 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
>> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
>> index b5d3a8c5bbc9..e2cdf2d48200 100644
>> --- a/drivers/vfio/pci/virtio/main.c
>> +++ b/drivers/vfio/pci/virtio/main.c
> ...
>> @@ -485,16 +478,66 @@ static bool virtiovf_bar0_exists(struct pci_dev *pdev)
>>   	return res->flags;
>>   }
>>   
>> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(core_vdev,
>> +			struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev;
>> +	bool sup_legacy_io;
>> +	bool sup_lm;
>> +	int ret;
>> +
>> +	ret = vfio_pci_core_init_dev(core_vdev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	pdev = virtvdev->core_device.pdev;
>> +	sup_legacy_io = virtio_pci_admin_has_legacy_io(pdev) &&
>> +				!virtiovf_bar0_exists(pdev);
>> +	sup_lm = virtio_pci_admin_has_dev_parts(pdev);
>> +
>> +	/*
>> +	 * If the device is not capable to this driver functionality, fallback
>> +	 * to the default vfio-pci ops
>> +	 */
>> +	if (!sup_legacy_io && !sup_lm) {
>> +		core_vdev->ops = &virtiovf_vfio_pci_ops;
>> +		return 0;
>> +	}
>> +
>> +	if (sup_legacy_io) {
>> +		ret = virtiovf_read_notify_info(virtvdev);
>> +		if (ret)
>> +			return ret;
>> +
>> +		virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
>> +					virtiovf_get_device_config_size(pdev->device);
>> +		BUILD_BUG_ON(!is_power_of_2(virtvdev->bar0_virtual_buf_size));
>> +		virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
>> +						     GFP_KERNEL);
>> +		if (!virtvdev->bar0_virtual_buf)
>> +			return -ENOMEM;
>> +		mutex_init(&virtvdev->bar_mutex);
>> +	}
>> +
>> +	if (sup_lm)
>> +		virtiovf_set_migratable(virtvdev);
>> +
>> +	if (sup_lm && !sup_legacy_io)
>> +		core_vdev->ops = &virtiovf_vfio_pci_lm_ops;
>> +
>> +	return 0;
>> +}
>> +
>>   static int virtiovf_pci_probe(struct pci_dev *pdev,
>>   			      const struct pci_device_id *id)
>>   {
>> -	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
>>   	struct virtiovf_pci_core_device *virtvdev;
>> +	const struct vfio_device_ops *ops;
>>   	int ret;
>>   
>> -	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
>> -	    !virtiovf_bar0_exists(pdev))
>> -		ops = &virtiovf_vfio_pci_tran_ops;
>> +	ops = (pdev->is_virtfn) ? &virtiovf_vfio_pci_tran_lm_ops :
>> +				  &virtiovf_vfio_pci_ops;
> 
> I can't figure out why we moved the more thorough ops setup to the
> .init() callback of the ops themselves.  Clearly we can do the legacy
> IO and BAR0 test here and the dev parts test uses the same mechanisms
> as the legacy IO test, so it seems we could know sup_legacy_io and
> sup_lm here.  I think we can even do virtiovf_set_migratable() here
> after virtvdev is allocated below.
> 

Setting the 'ops' as part of the probe() seems actually doable, 
including calling virtiovf_set_migratable() following the virtiodev 
allocation below.

The main issue with that approach will be the init part of the legacy IO 
(i.e. virtiovf_init_legacy_io()) as part of virtiovf_pci_init_device().

Assuming that we don't want to repeat calling 
virtiovf_support_legacy_io() as part of virtiovf_pci_init_device() to 
know whether legacy IO is supported, we can consider calling 
virtiovf_init_legacy_io() as part of the probe() as well, which IMO 
doesn't look clean as it's actually seems to match the init flow.

Alternatively, we can consider checking inside 
virtiovf_pci_init_device() whether the 'ops' actually equals the 'tran' 
ones and then call it.

Something like the below.

static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
{
	...

#ifdef CONFIG_VIRTIO_PCI_ADMIN_LEGACY
	if (core_vdev->ops == &virtiovf_vfio_pci_tran_lm_ops)
		return virtiovf_init_legacy_io(virtvdev);
#endif

	return 0;
}

Do you prefer the above approach rather than current V1 code which has a 
  single check as part of virtiovf_init_legacy_io() ?

> I think the API to vfio core also suggests we shouldn't be modifying the
> ops pointer after the core device is allocated.

Any pointer for that ?
Do we actually see a problem with replacing the 'ops' as part of the 
init flow ?

> 
>>   
>>   	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
>>   				     &pdev->dev, ops);
>> @@ -532,6 +575,7 @@ static void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
>>   	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
>>   
>>   	virtvdev->pci_cmd = 0;
>> +	virtiovf_migration_reset_done(pdev);
>>   }
>>   
>>   static const struct pci_error_handlers virtiovf_err_handlers = {
>> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
>> new file mode 100644
>> index 000000000000..2a9614c2ef07
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/migrate.c
> ...
>> +static int virtiovf_pci_get_data_size(struct vfio_device *vdev,
>> +				      unsigned long *stop_copy_length)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	bool obj_id_exists;
>> +	u32 res_size;
>> +	u32 obj_id;
>> +	int ret;
>> +
>> +	mutex_lock(&virtvdev->state_mutex);
>> +	obj_id_exists = virtvdev->saving_migf && virtvdev->saving_migf->has_obj_id;
>> +	if (!obj_id_exists) {
>> +		ret = virtiovf_pci_alloc_obj_id(virtvdev,
>> +						VIRTIO_RESOURCE_OBJ_DEV_PARTS_TYPE_GET,
>> +						&obj_id);
>> +		if (ret)
>> +			goto end;
>> +	} else {
>> +		obj_id = virtvdev->saving_migf->obj_id;
>> +	}
>> +
>> +	ret = virtio_pci_admin_dev_parts_metadata_get(virtvdev->core_device.pdev,
>> +				VIRTIO_RESOURCE_OBJ_DEV_PARTS, obj_id,
>> +				VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE,
>> +				&res_size);
>> +	if (!ret)
>> +		*stop_copy_length = res_size;
>> +
>> +	/* We can't leave this obj_id alive if didn't exist before, otherwise, it might
>> +	 * stay alive, even without an active migration flow (e.g. migration was cancelled)
>> +	 */
> 
> Nit, multi-line comment style.

Sure, will change.

Thanks,
Yishai


