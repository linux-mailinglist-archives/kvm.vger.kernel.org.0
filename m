Return-Path: <kvm+bounces-52830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C8696B0997A
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C0677A3682
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1563919F11F;
	Fri, 18 Jul 2025 01:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5Wq/eCLP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D20118A6AE;
	Fri, 18 Jul 2025 01:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752803920; cv=fail; b=VAjEZ8AJdc16qt5UcpwnufRnEsIgHwUPOxTz21xF4DC2KmAK8Lyx1Ju4nmQ5dPO9uIJ0fnGoWJ99H8fsi7diot97e6j+lX+kFH3GSqLfmPi0OI53Xbg6KoXYgGINLcOP8vGdXoMgi+ycdJUIPS99wOYTYAIAgMyoVTr+FRuPm0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752803920; c=relaxed/simple;
	bh=JIpPzjoEPpsb9WuExlsU8a6GXGW7bZl4idvOB8g0Nsw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gch/PKy8PC8JdV10bCN+FHrfc1mLZVgU0kuCPzcCSMU71+dO5qrC1o+W+tMhu3zB0NxLNsCfQrB4vwcGXN+DVXqNfqcY9azjIACv4t/xZ1UFP8neZ7iXuYOD6LrKIRlXRw51E2iuBwuWIvMobzYFtz0v9vP/4Duoa1unR0nOCfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5Wq/eCLP; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZCTZk1EmdJdvpLtXQyG2SwVKjnfAerXthmkOUl3LFFA/mvsF0f0AIwGYYbtxQG+FhREEagvsI/oTA6H1MHdPbMcs84thxRvH5tEXKsH86xhXJ+8CxMI+on7ocAhzNYSTsOv5cy5QOV2U1LfdO4+1I7jmlcK7xEZHkbbILvhQbSXRS6ZedFLvDbYqydX513dRP9+HtNaVjKAFIYEB05pRfSmZfdmPEvnXVTC2+qhx4w8VwPafB5l+6Lh/PqnzYCHOCNnDDU50FvMAhBpfcw9TB86m9W3FtPP+LgM1iJJIO9EYOiO24SZnICONPVz7QKy8TQdGsLee2oomxUWTqEtzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8ZtcbePW62bb49rt1Ee0rG6f6+hp58oI2EFbiQzLq0=;
 b=whedsON1PKNnf9/vHe6jEtpWjIb02ZRscVXI9f0bnunDoYBpnEa+WlifPbyfr+sBHfh8iUQtNxgln1BBhDfL8I0Jjj+113YsdSFvaW806MwatgAPAcI2VThIRqyernZ26UzUdkUNj5gyM75e8/TjX7TaOwRMi6AB7bfmA2AQ7V20emlLm+KImZANBCLDHPvKKeDtuT1hQMRjFJipnVG8hPuFLUp6BtHLTWQSn951SBuEKepFI89/C/DYRXcOMe8Sjn+IcGsnmFn8QJ0o7/cjnTzkb37QjltnCQBkM3wisjkQEC/W6Ts/NwgJtH8WWwsDiWFBn2AtKtFRY7/M3ko3PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8ZtcbePW62bb49rt1Ee0rG6f6+hp58oI2EFbiQzLq0=;
 b=5Wq/eCLPqZNZItc9D5jUIMuw9cUtMPSRvFCO/64SoythUEjVH3s+mRATuD1gcR5vdmzI8TDBQCdxpuX5hZZVij3nH6Lz7TblVB7FUhc7rakKBX+bOmaXNSFZ2lKMjQxIl+MeKPc6Vb0SQsPGb+a6upskY9lM7b+QyjenDx2tTJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH0PR12MB7929.namprd12.prod.outlook.com (2603:10b6:510:284::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Fri, 18 Jul
 2025 01:58:36 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%7]) with mapi id 15.20.8922.037; Fri, 18 Jul 2025
 01:58:34 +0000
Message-ID: <d004a5c9-fbd9-4298-89ab-292524ae3ad6@amd.com>
Date: Fri, 18 Jul 2025 11:58:22 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH] PCI: Add quirk to always map ivshmem as write-back
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bjorn Helgaas <bhelgaas@google.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Kai-Heng Feng <kai.heng.feng@canonical.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Santosh Shukla <santosh.shukla@amd.com>,
 "Nikunj A. Dadhania" <nikunj@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20250612082233.3008318-1-aik@amd.com>
 <52f0d07a-b1a0-432c-8f6f-8c9bf59c1843@amd.com>
 <930fc54c-a88c-49b3-a1a7-6ad9228d84ac@amd.com>
 <opdpelyb26bzp723lyxljjb2dmxgunkcjlvpkxgbrxaxhoycv6@eigu7etse3g7>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <opdpelyb26bzp723lyxljjb2dmxgunkcjlvpkxgbrxaxhoycv6@eigu7etse3g7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::14) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH0PR12MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: 54a63ba4-6e7e-43ef-8777-08ddc59e9a59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THVhVjB5dEZMZWF4UHA4eGNwQjM0L3ZxUnE5K3REeGg3M21hNFNvd1lCNW9p?=
 =?utf-8?B?bUg1RVVxRXVEeXhUd2dZUG5xNE9WaDlDMHdURmppZXBzczZFRFp4QVh5cFhU?=
 =?utf-8?B?aUlrb0hXaGpuREZXeEoyUWhNalVsYmdONmJuaEdUZExMMDc1aGU5bGhOM3lI?=
 =?utf-8?B?ZGYyTEF5RTZkaThzTXR0U1IrM2lNL2JTaFRPSENvby9OODU1NTZReU1ETzd4?=
 =?utf-8?B?cVdKYzlXK2o4RVRPMkFIVEI1V0FkQjlVT0hsekdCREdmYXZVMDM0cXpydkxv?=
 =?utf-8?B?bC84dDlkOWdycGV3VVZYcXBuM3l6bDFQZStsbnJJNHdlTmYyWk1wemp3bmlP?=
 =?utf-8?B?Vzc4aXpVaGVKKzFGbmhIdzREU2U4L3UvT2ZBMklmQ29FbFpza0VYVlNqUG5D?=
 =?utf-8?B?YWtkU3RYeE1JQXlRcFFwbVNnNHE5MEVIais3ZDdIY0pPRWZHY3IySGFsTDM4?=
 =?utf-8?B?ek5jcWJjSXE4MlJmTUtDQ1VVKzUxL2c0NnBQem95VS9rVk1EWkFGcCtDeWc3?=
 =?utf-8?B?Znhrd3gxZ2hjSjFFZXl4N0crbEVaWTh5M3pONHZzRFBYYTBqM0owZDRhTHY0?=
 =?utf-8?B?bGEzQnpCdWlia1gxSE1kZ1RZMFlyMmxWb3J0MzdxOFJ1Z0ZPR1ZjVm4zN1E1?=
 =?utf-8?B?eHU4d1l5RU9jTTBjNUZjWSsxczMwdWRFNi90SEdMTzRwOWZRTmVEQW8wY092?=
 =?utf-8?B?S0htZEtmWG9ZaGNuOE05cDd4RmdYRGJiSDBEakllQTB2M1MreExJQU5Dank5?=
 =?utf-8?B?RmRVeGRmZHVZSmJXMGluVXlGRlAxWGpXN2krQmVwdTdXdU15VERtZFc3cTJB?=
 =?utf-8?B?VHlJRlpBTlhvejZ6UXY2ZlVqSzFwRmVCUmRLbGpmN2JQb0VUOGpJZGY4WTE4?=
 =?utf-8?B?bU5TR1ZZQjY3cUZWMTI0b0Rnb3drNk5NUDBEK3hYKzROUlE4Tk1uQmtvcG9N?=
 =?utf-8?B?Y1NSWjgycW1NSkNQcjJ2TC9ML3ltOGhVOWhHN09PU2FPbTl0ZDBUT2dDTGFh?=
 =?utf-8?B?b0t1bHNJSFNucHo3bVBnWGtWMG1zbUtrRTVUMUZFM09Yb2xXVitQOXlvcUdR?=
 =?utf-8?B?cjF3NVZJMmlvN01QTlBWSVVsZ0E4U3YwVFVCSStXa0M2aUhmbEVTZHF1M0w5?=
 =?utf-8?B?WDgyQnZTRzdyRXRLSnhKMkM1MGRCNEg0aEtqdXVlVGpWaEx0djR3VllGc1lU?=
 =?utf-8?B?SGp5OGl6MVZyZTgzWlVpc2NmQlRJajE3SmxjWGtaQWhVSjJ1WjVWN09KQThE?=
 =?utf-8?B?TW9pRmplRC8xc2NuUUI4U2lKclZaeFZBdUFKd3Myb3hpTVpramxjQWhxbit5?=
 =?utf-8?B?YThEb3UyQzRSNWtlYjFxZ1o1VzVXbjVTdGRKR0RDOFA0NHd6Zk5xSzRvaVZy?=
 =?utf-8?B?QWZSbXVnWTNHUEVTUlV5eFcxRElSVVZ3OTJ3QkZxdHFhMm15enRBUElzUDZ6?=
 =?utf-8?B?cTFzTUdhMGlKV1RyNU1zMmRSOGNPOURpNkRBVCtNdHZBWkFPSUtrbG5kK0Ex?=
 =?utf-8?B?S25KeTBYVGZSZG9uZ3NZSG40TUN2Q0srVUFGRGRPeUJjbnROOU1keG5iei9y?=
 =?utf-8?B?MXlJeW8zLzFiYXFuYVM3Umdjc3htVGJGTWlXMTEvdEN1OXZyQXJWdTYxZ2Ft?=
 =?utf-8?B?c0dVdlE5S1VkQjJKUkFXbVllbFZObU5jekxYYzBZcFYzSU5jOW5pZTR4ZkRr?=
 =?utf-8?B?UVVGL2R0RHROOEltNE5lajI4UmFKdldyTVo5cjVaa21oZGt1RVFGdXlZemFJ?=
 =?utf-8?B?Z0xINmJ5ZUt6NGxncThzQXBYOGg5NEJIeWdJeWRmVmxMMVZ5K3VEdEJzb1hy?=
 =?utf-8?B?Yk82Vk9ML1R5RzhLK2MwaS9MQzlFeGJxZTdyeEZlNGYvZ05Vak5KT2VhWU45?=
 =?utf-8?B?b2RkRVJDOUZZU3owWjViNDdpbWJJSDZzSmUxUDFLY2VrdE01M3FOS0l3N3VD?=
 =?utf-8?Q?QomqaJASkV8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tk1tMXArQ3VLSUR4YncyUlp2RXJBK2kzbUhCNlBsM1ZIZGFHV3JSWEVkSUNr?=
 =?utf-8?B?THZ2dS9odGJPVmRLdnl4VDgvWDIzYVJmQ3FpMFBuYzllclBNOU14MzRyNGFH?=
 =?utf-8?B?RkdkWERCY25IWGxiT3d0NENZRWhXRG5tRmdCV25NUzdrbXRJQ2J6MjF1bjdy?=
 =?utf-8?B?TFBmWHhWQjZhN0VJQUQ0N3dXMUs2WTV4S3oxTmlhb1RWTTNYWHByNCtSRFdy?=
 =?utf-8?B?Q3BjSU5ZZ0ZqekkzbG5tMVJWOU5xaVZacVdMcUhManEwamtNZUZjOS9kVXRy?=
 =?utf-8?B?MURsc21sWlU1N1ZaeTRXVnVGQ2xKWmVLWnFoNzRMQXhoMDNMaTVFMXdmeGhp?=
 =?utf-8?B?SjFKanRKcWJINGVJbmVsMk1FcWo5SGQyUTlsSmt4NE56dzREb1d0ZklNd1Nu?=
 =?utf-8?B?UTFPOE9ZSFJYRVcyRmtkV3hyeHJZK21tK1k0R2tiL3M1QlFqb1FwL20vcUtn?=
 =?utf-8?B?eGE1Y0g4aGI0bTNCVzFoZ0RWSHFhRDU2Y0tYa3VhaFQ2ZjhUWVZxRUxDWmw1?=
 =?utf-8?B?VDFxSUZIbW4wcWx4dmJubXpDcEhyQkJCWUdJemdBWmNCaHMrQnhZZ25SMHVQ?=
 =?utf-8?B?SUdLRnpaNjJRbkhBNFFsQUtleTZVNEIwdXlZNnFzR05tUS9ka0prWUxvVExq?=
 =?utf-8?B?UGJ6b1RCek5pdlVOdEFrS3ROREpFQVIwaWhoa3BmVThYaDZUR3VvK2RJUk9q?=
 =?utf-8?B?bHBCdmlHNDhlVFZQS0UzbXBvbW5tdlZ2cjBVU3hMSHlDM3FqS1RtR3lrcGRE?=
 =?utf-8?B?V2JPN3FXMXRkWnNVMzBISFQ4RTU5NEkyK0lmS1cvek1pallmbU5KL3l2RGpQ?=
 =?utf-8?B?R0lXeTVlbDlNbUdkQnlyUjJERjRVL0RzaDBnOFdKQXVQUFpiRWFJNFowN28y?=
 =?utf-8?B?RTRwakFrZlhCekxkQUxwUU90SUZQOXVEaE5sZE0wMEdIZmdjYVF5MUNxdHJ3?=
 =?utf-8?B?WDlhK2NIK1E4ZUdnRzZsQkNBWmxwQmJXaGw0UGhaVWhDSkcvazlTYW4vMXE1?=
 =?utf-8?B?bkZ2cWpQS0pqa1pWRmh6WkJjajJYRzhtUDkxMFNHbHZzSHJJaW83VWRGdGla?=
 =?utf-8?B?Z0lRSTRaY2JZS1VVYis3VkcrY3pxb00zMmNXRTE1WUcwRGdtK2R0VWt1blZH?=
 =?utf-8?B?cldESFZSNXV0VERaNUcwaEdjNUUyTThDUEs0Zkord1FLVlptWmV1c085engy?=
 =?utf-8?B?cmVGeVdVRHhUd2h1N21mWGhQeUtTb1BlODRVblRBZW5nazRDZG1jd1hSdVgw?=
 =?utf-8?B?MnU4VG1oQkNVL3N2cHhvbUdZeVNRQ28vMW5FdnIvZWpXMC9NbDZNQ3U2K1VP?=
 =?utf-8?B?RTVKNG5wQkdOUURVQ1g4akpyUWpEaHpkbXlpRzNmSng1TXArQTNVTFJnblJi?=
 =?utf-8?B?THhjNDJEdk1jR2FaL0VxWDdVR3RyUTJneUtmL2pkSkNoY1RJMHdFSmJ6RFF0?=
 =?utf-8?B?VWw5cXh3Z2VQWEJBNDVwdXdxUmN6bWgveW13SFMxeG0xcVN3L2FnMEFkdlJj?=
 =?utf-8?B?eG1FeWV2MldwTDNLdEV4Zy8zUURMU1FRV0xEQTVHZFhwK2xFMW1wNDZYYjJy?=
 =?utf-8?B?c0xPQ2U2Rm9vcHFqaStwNCt1dEU2MFJQaFEwM1J4Q01hNFU0TG9FYWllUm1R?=
 =?utf-8?B?RC9zQzNhbGYwV3NGR2xVU3pOR3cwZUZQMWdFNWxXRkJxMDU2NWFBay9LZ3kz?=
 =?utf-8?B?UU1QZ3NBd011VUxDeXhMMUExODBQZnpSZ0JDdTJjRjJsZVlIMWZaK0xBeE5y?=
 =?utf-8?B?eVdhUExCNUdrVGphTjZsMExqMjAySC9aNElyb1NjVk9jd3JUQ2hzN3lkUDBJ?=
 =?utf-8?B?b0xGV3NnNFgxWVlRS0ZuWjgzeEFrajhLYU80c3czVUhkNDJheTNVakc2bTQ2?=
 =?utf-8?B?QjR0ZkwrdkF1YVIyd0pkRFlDdFBwNGNZeXpBaTBJOWtiNUQ4SkE2VythUURl?=
 =?utf-8?B?eE1LYUNqeW5sYVlHeHp1UG1YSHc2L3lGNzVpZzY0d25QT1U2aHJRcVdqa0R5?=
 =?utf-8?B?SjRsREkyanVwM1ZZOTZ3dGFWbTZlR21tcngrbWZGYWRvckcrM1piVEZtWUhj?=
 =?utf-8?B?a0VBQ3REaWlOL3J2K2xMYyt4M0lxR2hucHFTOXlrNy90alM1ZU03ZkpKWWF1?=
 =?utf-8?Q?CpEkFH3ZoRUpjeodKPXaBQj2u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a63ba4-6e7e-43ef-8777-08ddc59e9a59
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 01:58:34.5606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3Mpy53OLGS3OrF4YqAhqKSxVA+uQefk3B+eToqYWvFuqOwTJcczcLU41Q9kVJneHbmJQutXkTCBPUDhItnmPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7929



On 26/6/25 02:28, Manivannan Sadhasivam wrote:
> On Tue, Jun 24, 2025 at 11:42:47AM +1000, Alexey Kardashevskiy wrote:
>> Ping? Thanks,
>>
>>
>> On 12/6/25 18:27, Alexey Kardashevskiy wrote:
>>> Wrong email for Nikunj :) And I missed the KVM ml. Sorry for the noise.
>>>
>>>
>>> On 12/6/25 18:22, Alexey Kardashevskiy wrote:
>>>> QEMU Inter-VM Shared Memory (ivshmem) is designed to share a memory
>>>> region between guest and host. The host creates a file, passes it to QEMU
>>>> which it presents to the guest via PCI BAR#2. The guest userspace
>>>> can map /sys/bus/pci/devices/0000:01:02.3/resource2(_wc) to use the region
>>>> without having the guest driver for the device at all.
>>>>
>>>> The problem with this, since it is a PCI resource, the PCI sysfs
>>>> reasonably enforces:
>>>> - no caching when mapped via "resourceN" (PTE::PCD on x86) or
>>>> - write-through when mapped via "resourceN_wc" (PTE::PWT on x86).
>>>>
>>>> As the result, the host writes are seen by the guest immediately
>>>> (as the region is just a mapped file) but it takes quite some time for
>>>> the host to see non-cached guest writes.
>>>>
>>>> Add a quirk to always map ivshmem's BAR2 as cacheable (==write-back) as
>>>> ivshmem is backed by RAM anyway.
>>>> (Re)use already defined but not used IORESOURCE_CACHEABLE flag.
>>>>
> 
> It just makes me nervous to change the sematics of the sysfs attribute, even if
> the user knows what it is expecting.

On 1) Intel 2) without VFIO, the user already gets this semantic. Which seems... alright?

> Now the "resourceN_wc" essentially becomes
> "resourceN_wb", which goes against the rule of sysfs I'm afraid.

What is this rule?

> 
>>>> This does not affect other ways of mapping a PCI BAR, a driver can use
>>>> memremap() for this functionality.
>>>>
>>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>>> ---
>>>>
>>>> What is this IORESOURCE_CACHEABLE for actually?
>>>>
>>>> Anyway, the alternatives are:
>>>>
>>>> 1. add a new node in sysfs - "resourceN_wb" - for mapping as writeback
>>>> but this requires changing existing (and likely old) userspace tools;
>>>>
> 
> I guess this would the cleanest approach. The old tools can continue to suffer
> from the performance issue and the new tools can work more faster.

Well yes but the only possible user of this is going to be ivshmem as every other cache coherent thing has a driver which can pick any sort of caching policy, and nobody will ever want a slow ivshmem because there will be no added benefit. I can send a patch if we get consensus on this though. Thanks,


-- 
Alexey


