Return-Path: <kvm+bounces-39274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A543A45DD6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 12:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BC6A188D0C6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 11:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C04C21B19F;
	Wed, 26 Feb 2025 11:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TS9kIRUU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA76D214A67
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 11:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570706; cv=fail; b=PK3urdIQTQkxueeEBfzwmx6QjIcxuUn500yODl5+FcmCQ39vFjDuf314EzwWwK2H1o2xhDuNfwmmyGwxeiyIzfVRyi5pH9ZYRYBGFITTITZRo1D5DGkIRaZ5nmpKW0P7/RPUeIlj601dF3GaEvfiK3o04uWlyVJCfP5jtc6htgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570706; c=relaxed/simple;
	bh=bYrzj3PhNVTT1ts7GFiByE/er9i4mgxEl6qXcoIXaU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KPFyAoZZCopvH4Lx48/RgWkrZJtV7RbFcgYgt0SSa4b272Y10hcX6ci499Y+niM7QRSBGlMkJ5rNNqK++tFRHGUNq0XEAXsgVh0LyZHaGxkjZ+tJSt98RFYfy6py8OHWC9Jx8d4MSvb6AxFNVge+kyWS+QbTGEmQww+T3NEKFzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TS9kIRUU; arc=fail smtp.client-ip=40.107.220.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qgruiUL5waO+8ktkLnWjoThojY0X6BlgMCt1dsDRn+dOIPQ7S/bcbSFgV2t7KDyrofdehxndMwywpDGa6aPQHP+4TPiPXp3ej2pqRA3j3qZDcn06gcLijqIA59bN1eO8CBQ8+CsetbGFS7XvuX0Ulj/RvgbL8JVCqVNewGwALX3iRkxKEIwg6CtIL8XIrIaEZI7ohgeESUKUyOiQDm7xvBz65Do/SVsXsqO6nuBPPHAO7RmvChP+7KYqfCrVHHIS74HUM00qVV1+86uW3AEFwet/7mhP4C0fBokOmemOXHrbIdHSljabT6jd1nNMsYKdG/gU74i33EH6lKK7P5vtWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqOW5AWxrRHH/nmPtM/fNTf7qoyu0lfLSomPjZFRJoQ=;
 b=xvmYtXRKBhslEVhApxaXdr8iuM1wkt0bt4ECrFjaSVAkdfmg1G3VCgqOZTaz0J9dEQKts9/UzjaehSWj54CzJUmIKakvPHccWxuVnZgXCDpp/maErTDPkQ7loS3cfvUGm/6DgSlnck6OMkGxM2P2AvD6kz44NJa61TOd42BP6Ny1zMP4I2j4tdgmOS/TIMM65Q+ya9gr2833p1bMILVZQ/laWoeYdJ5QlvFl6DAPB3+jl55YK8M+7EBp4qiyQWSyBcSifAsWcusEsl13Jzm1x0/K6d3sKCuW3k4+iusGPY/2ZHsmCwXh7DajsF9eS+WadY+4uqXKLi/hhq1yUeabJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqOW5AWxrRHH/nmPtM/fNTf7qoyu0lfLSomPjZFRJoQ=;
 b=TS9kIRUUYjwyC4tCZxLfQyuMvn+DOYC6kZKf+1NrKk6W9OZg3VLcJx0B7vHE8kYgQuoRsgIs9iYw87qVg3MgSdwy4lFSumltPZyTbEKGr6hqQXTEwBFerOss820iWD3SPLMK3djMvXJiC7MywJSeosSGPqt+ED1ePmjtS9hmt+tU4hvvyj5ow0EGE96hNzPRKULr4zvTlIpLA5JMrwSjpk892T9z88jtqiRRB1f5XWAmVafZPa9IHnI1C0H/9x+WYf2VJdOQvv8SQS+Y/qpOXycPdI8CAuYn5P8rMQ/pLboPo8Jy9fyoHY7Zk1mAxDGaVQuCxqJFTsYbZ9AVnG3Z2Q==
Received: from SA9PR11CA0028.namprd11.prod.outlook.com (2603:10b6:806:6e::33)
 by PH0PR12MB7959.namprd12.prod.outlook.com (2603:10b6:510:282::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Wed, 26 Feb
 2025 11:51:41 +0000
Received: from SA2PEPF00003AE5.namprd02.prod.outlook.com
 (2603:10b6:806:6e:cafe::2a) by SA9PR11CA0028.outlook.office365.com
 (2603:10b6:806:6e::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.18 via Frontend Transport; Wed,
 26 Feb 2025 11:51:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00003AE5.mail.protection.outlook.com (10.167.248.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 11:51:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Feb
 2025 03:51:24 -0800
Received: from [172.27.48.158] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 26 Feb
 2025 03:51:19 -0800
Message-ID: <8adbe43a-49f8-470c-be67-d343853b17f5@nvidia.com>
Date: Wed, 26 Feb 2025 13:51:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio] vfio/virtio: Enable support for virtio-block live
 migration
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>
CC: "jasowang@redhat.com" <jasowang@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "israelr@nvidia.com" <israelr@nvidia.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "maorg@nvidia.com"
	<maorg@nvidia.com>
References: <20250224121830.229905-1-yishaih@nvidia.com>
 <BN9PR11MB527605EBEB4D6E35994EB8068CC22@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB527605EBEB4D6E35994EB8068CC22@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE5:EE_|PH0PR12MB7959:EE_
X-MS-Office365-Filtering-Correlation-Id: b4c16081-2afe-4e5a-1a86-08dd565bef61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODNhb0JuU2plL01XUUx4UG96NlNyd09YdFJ0VDlybjNJNEM3N0QwS2xLc3JV?=
 =?utf-8?B?VTJ5bEkwaWNvKzhVdlZIeFIweVM5Q1VJWmRQcUZHTHczQk1EM3BMcWFmWTk0?=
 =?utf-8?B?cWtQVFVBMGRSSmd3cys2V1JHaWozOStMU1hnWkM1VDdiTExSWS80UW1hR0FM?=
 =?utf-8?B?QVBuZVh3KzhiblVWY25RclNEbHFRTys4UFRUVnE4Rk51b3JKbkJzczhlYjZG?=
 =?utf-8?B?U1JnMUxlelcvZ2pMS0o4M3pDRDMyeEIzUlJ1RnQ4SzVFK1UyampyOEFWaFMv?=
 =?utf-8?B?NUlwT1dJU1lIL0JNU2VCdW4wNksyaVIrR0FvMEkzbVNSNnp5Q3BoMDZDR0lr?=
 =?utf-8?B?KzQxenJ0UWJMamxROVI1d1R5RC9xa2lLV0syRWRkL1oraE56eEIwMnJKakdl?=
 =?utf-8?B?RTBNMkdkYTQ5UjZwNXhOUEtycnFYQklrWUgyb0JZU3BuY09Pb3dnRVlqZ042?=
 =?utf-8?B?UVJQK2RwSjFQSnYyZnlCSVBMeHhEZjRoNTMvSG5aTFBsMldXdVlpTXp5Snpu?=
 =?utf-8?B?UHVmTEdSQTkwY2V0SVBsb0lmQ0MyVFFONnp4RUJVRTNCUTJYN3FLYTRBS0Mv?=
 =?utf-8?B?RnNrbG0xZW9TaU1KOWYwL0ZrRStzRlVHVjdEaFd1dGNiNGtndVdXYVhEZlJl?=
 =?utf-8?B?bmsvVUFvTElyQVNZS2JQUFArMHl1enVpRk1pR3NTRGtLR3R3Nm1EWVRpbHgv?=
 =?utf-8?B?R084RjJ3MnNrYlg2aXZKRE5vekt2b2E0NjhxbndUcmN4dUJGdnJxQlROcHFH?=
 =?utf-8?B?UEt5c0hhZDhTb3F0S2tRYmlDakhQK0FMRXdXVVF4U0s2RFRLYVJsSCs0UFlT?=
 =?utf-8?B?QTRaU3N3WERCOXJoQUtDR2ExMWkzdWhTY3FBZ05GTVkxSkpIMnJvZWRwYzQ2?=
 =?utf-8?B?OFo2RVh3aE9uTjdIOUltSVFBaVRlVGZUd0RGMHN5WEtETGlucEdWN21nSGJx?=
 =?utf-8?B?VFV5ekVzWUtackIrOHVGRzFEQzJ0NWFLYXJ0dlBreUtRQzN3a2dJMXVwZlgr?=
 =?utf-8?B?Wm40OWllSE1xa1o1eVJOWXU2eUNYcHFJZXZRYzF1RWpNLzdJc1FkTHQ4L0hJ?=
 =?utf-8?B?Sm9RZzNyaWxldXZhclo4RkZFVGJRanNIU0NNdHNLM2JuNXVYd1krWkNjMlA5?=
 =?utf-8?B?d0h5ZjIwZFMrNTIzc2pTZ3JYa09NbHZwTzVDdzZHSHY1Q2t4ZktnY3I0ckJn?=
 =?utf-8?B?VUlwY2dWQmVRUEg5dHF0NUJlanU2OXVzajNWMFNuUE03ZWhKSkFndTQzZXV5?=
 =?utf-8?B?cnNPU0VqeWF1M3M0bTRVVHkwQlA1eGppbW9kVXJZU2Fyb3k3TnpxV1JSZ1pI?=
 =?utf-8?B?cExRemxpTjBPWC9QV3F6QUgvK2RZeFI3MUJ1c3dBSFFpRnkrYVdTemJTNk1r?=
 =?utf-8?B?U2lKMW1KSVp1L0JVYVI1TDh4OG9NdGRjalhOc0NkQ3FrYnJDTG5hdkU1ZnhE?=
 =?utf-8?B?VE1RSHRjeVJEaktFTm9yOEN6YVRtT2VoYXNqV3lNWGh6RzhuL2Z6ZThNNXN0?=
 =?utf-8?B?anlCUlJSbmxGYjRJZ3N2MnhEaVVET0owa21qYkxLNnFhR2JBUTl1SXBUSm9N?=
 =?utf-8?B?bGdXL0ZGQjNDWnJvQ3pKSlZ0MCszUnREMTExeEhuVGdDS2NZY0RSNVcyYkdx?=
 =?utf-8?B?dlFKcTV1dEZhZCtEb0J2dTRqaTczZVZYZHB4TkZpZXZReFJZUzVNYW5JZDJD?=
 =?utf-8?B?TXZEQlV4WEF2Zy9OeVhLSVcxWTRyaldnSEIxbkU3S2x0UnVBTURmOFF4Ylg5?=
 =?utf-8?B?bjFNYVUvb1lya3kzNVNYbmMrNUhScys5UmlOM1A0Rmg2dGVWeEZDbkxxSEpx?=
 =?utf-8?B?alVsaEIvazZkd0lwWHAzTjBDSGpJRDdPbCtiSFpOS1E0U3JiY1h3UDJocWIw?=
 =?utf-8?B?REtmT0l3UUI2ZGJwdkVTdDh3QlhicnFlNEw1ZlpWVmtYQWFkd1RoVWlLYmdS?=
 =?utf-8?B?eHFRYW9JYzFOUnV0M0hDT2hhTnJVMDhMRXBvYWJEajBiWllBcTFGaXRqSkg2?=
 =?utf-8?Q?sTLt4++I0M5OjL9JTZTNR8QEfNDSHg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 11:51:41.3047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c16081-2afe-4e5a-1a86-08dd565bef61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7959

On 26/02/2025 10:06, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Monday, February 24, 2025 8:19 PM
>>
>>   config VIRTIO_VFIO_PCI
>> -	tristate "VFIO support for VIRTIO NET PCI VF devices"
>> +	tristate "VFIO support for VIRTIO NET,BLOCK PCI VF devices"
>>   	depends on VIRTIO_PCI
>>   	select VFIO_PCI_CORE
>>   	help
>> -	  This provides migration support for VIRTIO NET PCI VF devices
>> -	  using the VFIO framework. Migration support requires the
>> +	  This provides migration support for VIRTIO NET,BLOCK PCI VF
>> +	  devices using the VFIO framework. Migration support requires the
>>   	  SR-IOV PF device to support specific VIRTIO extensions,
>>   	  otherwise this driver provides no additional functionality
>>   	  beyond vfio-pci.
> 
> Probably just describe it as "VFIO support for VIRTIO PCI VF devices"?
> Anyway one needs to check out the specific id table in the driver for
> which devices are supported. and the config option is called as
> VIRTIO_VFIO_PCI

I'm OK with that as well, both can work.

Alex,
Any preference here ?

> 
>>   MODULE_DESCRIPTION(
>> -	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
>> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET,BLOCK
>> devices");
> 
> Same here.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks for your RB.

Yishai

