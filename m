Return-Path: <kvm+bounces-48146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 534A8AC9E45
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 11:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0687D1893A78
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 09:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96F11A8F97;
	Sun,  1 Jun 2025 09:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b+5lsavf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEA4134CF
	for <kvm@vger.kernel.org>; Sun,  1 Jun 2025 09:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748771911; cv=fail; b=bZMffzTzOXcuPWtfCZGmDHoVHp2jHHAMBL1ZExlMLxJncRbGQK9q6WtZPOJyzRvkMeop2ZeUjVN6TRdaK8Dw/472NtN4L1vF5EEdgZxDQg3G7D2wBBQXIRJu0YEKcHchuzrXRJhdcmtgo8SCFq9DKoV6oGTDlwoG2J/LBo9nCJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748771911; c=relaxed/simple;
	bh=gmcOxPWpi5lMovF4HJ43Y6pZWBC2kIuUzt9peADSdHY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pOw1hWzVXBRldsWU6Z51oNVtgVTlYERxLH/3lm4QMN9kIw3Kl0svpy/Fa4pUU58cCMIfCoomBHNDOlKGcj7NMlVYev5yiavap7sciKmC8yg1UlyWIuYycxqkxB+VlB3U/CRstOVktm0I8JtzJnwSpegUqhnjfkdANpHeQ1Ikb/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b+5lsavf; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=toNB3yPlRQSpviODk+6W3UUx54GHn2jJSPmm/mJCpb8zG730hmdqKDkMofRy6mTzsKWV4NqKUmPuAxoR1L8AZWrhFX+TgwRTCQoDy45al7hmmMknxgBsRGxDHbnv/ix8HwdHL40HjHUASRiv5+ZwXp0MNWRq77TcaFRdgHRnVzsVmZLb3X5zLPEMBukjmUITSBU46nCi/AThN/adhV0AI72l8nUG1Cwuz5kXdYQCUJfzMnREhivMvur+az6uGg9VoJfR0u6sQoxG5YNFvbmRzzDlhRnYuRbeWfgSpZpZVLHXKRr3DXQrqa5PXZzzMJETkpd1KGB2HOg3Td9FYcbmiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HybrS7x466UF1QgTE8P/gIWAabN2PWTpGRvr+VgFGM=;
 b=dHHLTGHSFojTeU/3x4tFOhXXW/UelZx+87q0j9/xO47CKtlhMdibc+mmVqQNz/XvqwrQ0Tb0/7Q889OTqXl68L66APzhjmTSJJtRbgdU5Xyut/3SHnnsv1QX3TXMVpuRwumxyNTArS7I4odnfa/KsJ0s1C0mlMbMrII4Bpe57fkHsgJ462XuPK4Z4/+gqIJNr5VHt/a3FOQA8uWIpvK7oWm3MKcc3cILhJrOxK1Jh/S2TlhyEGFGtJL8Av4TvNqCR1eswZGA6DvN+fztcuXKsh6eEgoPjrcuAhp9bt2Ky01aAhPk843saE8UdbVahuVHSKkdw55PDQDrVftFYNdoZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HybrS7x466UF1QgTE8P/gIWAabN2PWTpGRvr+VgFGM=;
 b=b+5lsavfV7YIXB23/EpfdVPhXlSOg25Pyyg8QjtbcBvDJzQD8p+BET1z1cK6OGubV9CgUfRshB4kzwcJfFy1/BGQfY/4XjBA1GNBb5ebSnOHRq2YRN029HUW4yKewy6YMA7Ld1i2HRYXqjUg9utec4QEqKzRAqNN/9y8XqATmc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SA5PPF06C91DA0C.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Sun, 1 Jun
 2025 09:58:23 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8769.031; Sun, 1 Jun 2025
 09:58:16 +0000
Message-ID: <4105d9ad-176e-423a-9b4f-8308205fe204@amd.com>
Date: Sun, 1 Jun 2025 11:58:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250530083256.105186-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0427.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::31) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SA5PPF06C91DA0C:EE_
X-MS-Office365-Filtering-Correlation-Id: 2517b3ea-041d-4836-3d82-08dda0f2d447
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUN0SzFHN05ZRmFkUzk0R3dQcUNVb3RyZGpLNmVaYlRxbGhvNGhlZ3JsejJu?=
 =?utf-8?B?Nm5ZOElvRGNFa0tEU2lpTzNybFBiVlQrUWhDMnZBblVIQUZKYmhQTjhKQUN0?=
 =?utf-8?B?d2N6Tk1aMDgzamxlb3RkVlFmbWQxU3Q5UzBKNXdoK0drbml1cEJ2eDJGeVR6?=
 =?utf-8?B?S1RkcUhBQ2pNdkZiaGZld1JKSHoxTjRMdkkwTUhjQ0pCd1Y5NWFTSlBybWFR?=
 =?utf-8?B?Y1Zid2RLaEZSaFBYQTg1QmJRSW92cXUzL3lxOTJSQ29YNUVRVkJYVWVwUGIy?=
 =?utf-8?B?NGJrYUNOanhnN2ZxMjVwVHdWamVkY2gvNVB4QXJWRnhLOHhNRUFGeDRsWTB3?=
 =?utf-8?B?QkNBTUZYZG1Pb3pRK013dzhYWGVLYnhQa0gxQzFKVVNybWdEQVphcUI5bHFT?=
 =?utf-8?B?SUVhWG9WQjFpQ1lHalgzaXJzOXNXSUxXcDdoNTg4ZC93VDA5dy9MQWI5M3A4?=
 =?utf-8?B?S3ZiTGp1aitnS2ZmVVE4MjRmWHpJbXhuaU1wdHlnMzc0aVBaMXZkZDlmQ2hG?=
 =?utf-8?B?SDFObElMYlRHWkpmSzRMU3FTTlV0NnBGK0tUOFd3dllRZ016THU4YXAvQncv?=
 =?utf-8?B?dVZtNHlEVVQvWXBac3laOWx5WnQ2K09ReE42Q1lhV21BZGkyZFpGUmJmbXQr?=
 =?utf-8?B?Z3Rvd2VpNmNBeWhzU3luQnF6L0JqWnNPYUFWYmNmN1dCVTVuNVhtb3B0Mkl2?=
 =?utf-8?B?bHMydEhOTXhiVEY5YVJ6VlUycUgwSDZlWm9qSUFTajRaSHoxVmxzYVJlbDl4?=
 =?utf-8?B?REZ0cDM4SWpBcU9lRmh6Q0ZCWjR3Q1lxeThBb1NPeXlXYjBhbXZYdTA5UHE5?=
 =?utf-8?B?dFVxbzg3OXd0VjV3ekZ2YzVYNkZjRG40QzZZZ1IwMnZYQ1dzTVdYYllJRW5S?=
 =?utf-8?B?dTBLSkxLZGcrK3FSZlhwb01ZS3FHVTBQQ1NzWDN5LytrcC9SQkI5YUU1V25j?=
 =?utf-8?B?WGxRSzIrT1JUV0FrQWFFWGRoVXdoWi9NYTM5NERET3ZqWGVyVUVXRVlzUzB6?=
 =?utf-8?B?RWh0T2gwcG85M2ZCcUM0cEErTXRRbmVUenI3M3Q3R1ZzMEh2VVhzL1BIUnVB?=
 =?utf-8?B?UlZXdXBxMXlFODNWdDhZZVlHWG9Lelp2TXJ0bWw1cWZFZjRkYjFLMTdIZTVK?=
 =?utf-8?B?dFhoSjNIYTMrUGdldWxyQ0RnOHptcWNNN3dzY0dVbVdsbG91QmxnQTdkaEd1?=
 =?utf-8?B?bVBKT3hUTE80ak5SVCtmNUpFSkhlY2FUNnRHaktuMVhPQmRzaEhTZmV0QTZP?=
 =?utf-8?B?RVhwRGViOFRRMGp2UndIdkNEZUNvWXpPMmdFcUtBL1RDTnZobXJxL0wxOEJl?=
 =?utf-8?B?V1QwOWtKemtHZUZoK2QxcXZ0bEpnaHlSMnNqZ1NRYVBlSWtXTHdFNXZBeWht?=
 =?utf-8?B?TVozVXpDOUQ0ZVEvd2xWYUFVdTF4YklpTGlCaFNSNENnS2FXUm9BYTQvQ3hS?=
 =?utf-8?B?NmpiWVdJYVZHNVAwZ3B0c1Nid2sra2pqbnAzYlcxQ3lCSEEwOTlrd0JIREVM?=
 =?utf-8?B?aHFHT2VGYXBrV1BTRXc3YzhhSU1YdXdwTk5RZHo2NVBaQzJrNzc5NGllL1Jo?=
 =?utf-8?B?M2tid2tlTVo1T2xOS3hrYTd1VCsvMFZZT1QxeTBNYzhvWFdyL05DRWcxSUo0?=
 =?utf-8?B?dlBXZTB3Z2pnc084djNWdzdYcDlPRmNaN056OURJWmoxaGVESDlEYmxHc0hl?=
 =?utf-8?B?bm5pcDFFSjhQYlc5LzZlK0pINTRRbGNlTjd6OEk1OHFSbDJhM2ErNmZYWXRp?=
 =?utf-8?B?VW5xbnFXN2dENDBCSThjZTJuR1E4bGhwdC9ZQ0NCTzI3di9UajhIS01IMkxD?=
 =?utf-8?B?ZXB4Z21uY2hrNlhDYS9jaHVCTlRaTGRyUDB3cVF2TENMODE2VTZTZDdGdFVM?=
 =?utf-8?B?ZkJFRTJrbGFkcWtZM3B2b0JLUi85czdBNW5mMTMvcnlOZ3hOdFQyb1djSk9F?=
 =?utf-8?Q?H9mte8HJT9Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3lOT3o4ZEFDMjBOZm1ua2hKTEs0RndQdGJWU3huclNuU1ArM05JMkpwQ0VV?=
 =?utf-8?B?TjJVWGtqSW1HQ1JxNzRlRVN2WWpoNEh0WVAxZVZSY0pWcS9aVW00M3d0cnFV?=
 =?utf-8?B?c0s0amxPYURRY1pYT3U1MWNjWUhRbHBQRU1qMVdRdHE2cjJNY1ptR0tsTW1E?=
 =?utf-8?B?OUQ0aFNiRWZUZncwQXB3U0xGOXR1SzVuSHdBbXc4YUVTOC9rUzZBT2I5YUVG?=
 =?utf-8?B?cUdqcW5tTkVmMys3QWVpZnZYTmo1dHFJc0FVSXFnSVNHWjQ1c1FmdTQ4WkVU?=
 =?utf-8?B?WmtyQlJvZWlvL3hTYytpbTJlMDczeHJSZytuN1ViWmo4US9TTmZRM2owbHZz?=
 =?utf-8?B?WDR0SElENXBWaVpjdytKOUNsaHR3Z2tjcjlGQVVvUXhqaVVnbHlVWVhENUJ6?=
 =?utf-8?B?Ykhub1ZrVnVjWkVGMHJOQlZyZm84blE1VlgzZHZKbjhDZFE3YXpQcTR2cnJa?=
 =?utf-8?B?aHBwMWtRckk2aHFpVWdVNmx2eFVaZjFmVS93Q2ZDbTJRUWo1OExGZlZiNUZZ?=
 =?utf-8?B?aWxxZTFtaUtrZVM4cDNBbUo3aXBGcnY1YVQ2WGRTbDl2K3lMd1RneEIxOUlz?=
 =?utf-8?B?TTdkVjFxbWpybXhwTTAxRmxJVEdzazBwZFhTREtVcXhGSlZzSzgwcFhnMnRj?=
 =?utf-8?B?Qk0yS256ajhkSFAyRkUrVEtoeEx4SUxFdFpLRG5ySzkxVmtDbTQ5RUs4LytV?=
 =?utf-8?B?OVQ1aDM4MDlTR3pNekF1UGRZTU9Ia2M0SXZXR1M3cmlqTW1aRUtqNmNVY01E?=
 =?utf-8?B?d1VHeUN6RjNzcFFIWStOWVFNeW1SbHZudEJpSmg4UEJWcWUyR0U5aXZpZFEx?=
 =?utf-8?B?Ulpib01oWDdXeU80M0xDVlJyTmQzMk91K05zVml4elFHUFg3czVXcGVhQmR5?=
 =?utf-8?B?UlRqbjFnQzUzTWorb01vOStGVkhSK2YvRHVRaVFqdlFzVlU5UTBQUCt3NCs4?=
 =?utf-8?B?dnJFaDNIQ1hkaUgyY1hPdkFzY3UwcjhtREFvN3Eyb1cwRmZUUDNuQmpkS3lq?=
 =?utf-8?B?czljNHVGS2FnWGltay8yUFQ4VXdGeks5bytjZFExRTdZdDFISDBhMGo0c095?=
 =?utf-8?B?bUhJVHBubCsrOXRyNEpiM3hsTEZwcnU5MEMxT0JEUTR1dUZkQjRMaFM1b1Vh?=
 =?utf-8?B?QmlYUjZQN05hYzByNVE5Z2NVRU93NVVoRVhJcGlrbVkxV2h5Q1U5R2dVaXRo?=
 =?utf-8?B?YkE2Nktnb2p6WFBrZkI4RXRjdndxc2w0dDBqZ1hROC9SejVhSCtOeVZSZWM3?=
 =?utf-8?B?cmlLTVpuRGZYNzZMRWVCdUh1Nm4vd0JkRGc3N1ViU2FLbjYvZlRoVWdlM2RS?=
 =?utf-8?B?bEdCT29TWm43eE1uSVBaWmtzRDZRQWNhM2FaK1VyWkhwSUpoMXVMMDhmbmJn?=
 =?utf-8?B?UFhvbjNCRW96d2xQZHVTWmdmcVBTaTN1a01oUFUrenlWdWUwVzArL1hYekFI?=
 =?utf-8?B?V3h1emEwRG8zSXZORjBjRE41cUdmbVIxMWR5TW85eTdzVVN1QXZKVTVKajd5?=
 =?utf-8?B?TzVNbVZMbkVKMmVxajZDNmxrdER0bnltZUFqQXJWeEp4cFVKRVM3OXNmRVIz?=
 =?utf-8?B?KzU4YXJWUEd1Tlo5a0p3K09BTjRkSDR3MEdPNS9EMDYxdWlTVVF1WG9pcFRu?=
 =?utf-8?B?VHNVQXhzNXNNME5UZXovcEZTQk5iSFpqTmprYmgybVJhMlgrQmNkelk2S241?=
 =?utf-8?B?UFNJZyt3SlRHYXJyZ2FrSHlLRmVITTNDRTNjeVhxWUFoTmpoci9wWk0xSWRM?=
 =?utf-8?B?WEV6anFqUnUydllINHBrN3lSM2pOWkljd2ppWWR4NGcvZ0k1S3N3cnBFVUpx?=
 =?utf-8?B?ZjlZSFNMV2thZDBtRjFzd1ZGV0tZTkZncDZMaldrUjZOS3IxbmZhRmRTUVVV?=
 =?utf-8?B?SExOak1TN0UzMXVaemtkZTBveVdhZ3VYeFJuVTZ1OEhGdkdpT3pwcUV0QlEx?=
 =?utf-8?B?akNvZUNRR1VxaUNORGJmWTI2NVRRV28xY0l1SDlBMWF5MzRBcUVyNmxWN2V4?=
 =?utf-8?B?REc3VDkzMTFsdVhQeHV0cW9MNUkyMEtNZVh0NlBhSGtSWXBGbFRIU2tVbmpT?=
 =?utf-8?B?R3JvN3NmNitwY2NUZERFcmNGNkdlWDFvNHdRdGhNa2pUSzkxTmM4bS9OeWV4?=
 =?utf-8?Q?vX70A/7oE0lM1AkZVy5YBCJCF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2517b3ea-041d-4836-3d82-08dda0f2d447
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2025 09:58:16.2357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2EAKAsjhVfZi96L2fFJS26+3IDuBbhmkqXcyKf2jYirUekvILIgYMiJ+As6cBaWrzHjKkNIUJCTZn4thh2x6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF06C91DA0C

On 5/30/2025 10:32 AM, Chenyi Qiang wrote:
> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> discard") highlighted that subsystems like VFIO may disable RAM block
> discard. However, guest_memfd relies on discard operations for page
> conversion between private and shared memory, potentially leading to
> the stale IOMMU mapping issue when assigning hardware devices to
> confidential VMs via shared memory. To address this and allow shared
> device assignement, it is crucial to ensure the VFIO system refreshes
> its IOMMU mappings.
> 
> RamDiscardManager is an existing interface (used by virtio-mem) to
> adjust VFIO mappings in relation to VM page assignment. Effectively page
> conversion is similar to hot-removing a page in one mode and adding it
> back in the other. Therefore, similar actions are required for page
> conversion events. Introduce the RamDiscardManager to guest_memfd to
> facilitate this process.
> 
> Since guest_memfd is not an object, it cannot directly implement the
> RamDiscardManager interface. Implementing it in HostMemoryBackend is
> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
> have a memory backend while others do not. Notably, virtual BIOS
> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
> backend.
> 
> To manage RAMBlocks with guest_memfd, define a new object named
> RamBlockAttributes to implement the RamDiscardManager interface. This
> object can store the guest_memfd information such as bitmap for shared
> memory and the registered listeners for event notification. In the
> context of RamDiscardManager, shared state is analogous to populated, and
> private state is signified as discarded. To notify the conversion events,
> a new state_change() helper is exported for the users to notify the
> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
> shared mapping.
> 
> Note that the memory state is tracked at the host page size granularity,
> as the minimum conversion size can be one page per request and VFIO
> expects the DMA mapping for a specific iova to be mapped and unmapped
> with the same granularity. Confidential VMs may perform partial
> conversions, such as conversions on small regions within larger ones.
> To prevent such invalid cases and until DMA mapping cut operation
> support is available, all operations are performed with 4K granularity.
> 
> In addition, memory conversion failures cause QEMU to quit instead of
> resuming the guest or retrying the operation at present. It would be
> future work to add more error handling or rollback mechanisms once
> conversion failures are allowed. For example, in-place conversion of
> guest_memfd could retry the unmap operation during the conversion from
> shared to private. For now, keep the complex error handling out of the
> picture as it is not required.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v6:
>      - Change the object type name from RamBlockAttribute to
>        RamBlockAttributes. (David)
>      - Save the associated RAMBlock instead MemoryRegion in
>        RamBlockAttributes. (David)
>      - Squash the state_change() helper introduction in this commit as
>        well as the mixture conversion case handling. (David)
>      - Change the block_size type from int to size_t and some cleanup in
>        validation check. (Alexey)
>      - Add a tracepoint to track the state changes. (Alexey)
> 
> Changes in v5:
>      - Revert to use RamDiscardManager interface instead of introducing
>        new hierarchy of class to manage private/shared state, and keep
>        using the new name of RamBlockAttribute compared with the
>        MemoryAttributeManager in v3.
>      - Use *simple* version of object_define and object_declare since the
>        state_change() function is changed as an exported function instead
>        of a virtual function in later patch.
>      - Move the introduction of RamBlockAttribute field to this patch and
>        rename it to ram_shared. (Alexey)
>      - call the exit() when register/unregister failed. (Zhao)
>      - Add the ram-block-attribute.c to Memory API related part in
>        MAINTAINERS.
> 
> Changes in v4:
>      - Change the name from memory-attribute-manager to
>        ram-block-attribute.
>      - Implement the newly-introduced PrivateSharedManager instead of
>        RamDiscardManager and change related commit message.
>      - Define the new object in ramblock.h instead of adding a new file.
> ---
>   MAINTAINERS                   |   1 +
>   include/system/ramblock.h     |  21 ++
>   system/meson.build            |   1 +
>   system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>   system/trace-events           |   3 +
>   5 files changed, 506 insertions(+)
>   create mode 100644 system/ram-block-attributes.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dacd6d004..8ec39aa7f8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3149,6 +3149,7 @@ F: system/memory.c
>   F: system/memory_mapping.c
>   F: system/physmem.c
>   F: system/memory-internal.h
> +F: system/ram-block-attributes.c
>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>   
>   Memory devices
> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
> index d8a116ba99..1bab9e2dac 100644
> --- a/include/system/ramblock.h
> +++ b/include/system/ramblock.h
> @@ -22,6 +22,10 @@
>   #include "exec/cpu-common.h"
>   #include "qemu/rcu.h"
>   #include "exec/ramlist.h"
> +#include "system/hostmem.h"
> +
> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>   
>   struct RAMBlock {
>       struct rcu_head rcu;
> @@ -91,4 +95,21 @@ struct RAMBlock {
>       ram_addr_t postcopy_length;
>   };
>   
> +struct RamBlockAttributes {
> +    Object parent;
> +
> +    RAMBlock *ram_block;
> +
> +    /* 1-setting of the bitmap represents ram is populated (shared) */
> +    unsigned bitmap_size;
> +    unsigned long *bitmap;
> +
> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
> +};
> +
> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
> +void ram_block_attributes_destroy(RamBlockAttributes *attr);
> +int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
> +                                      uint64_t size, bool to_discard);
> +
>   #endif
> diff --git a/system/meson.build b/system/meson.build
> index c2f0082766..2747dbde80 100644
> --- a/system/meson.build
> +++ b/system/meson.build
> @@ -17,6 +17,7 @@ libsystem_ss.add(files(
>     'dma-helpers.c',
>     'globals.c',
>     'ioport.c',
> +  'ram-block-attributes.c',
>     'memory_mapping.c',
>     'memory.c',
>     'physmem.c',
> diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
> new file mode 100644
> index 0000000000..514252413f
> --- /dev/null
> +++ b/system/ram-block-attributes.c
> @@ -0,0 +1,480 @@
> +/*
> + * QEMU ram block attributes
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "system/ramblock.h"
> +#include "trace.h"
> +
> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
> +                                          ram_block_attributes,
> +                                          RAM_BLOCK_ATTRIBUTES,
> +                                          OBJECT,
> +                                          { TYPE_RAM_DISCARD_MANAGER },
> +                                          { })
> +
> +static size_t
> +ram_block_attributes_get_block_size(const RamBlockAttributes *attr)
> +{
> +    /*
> +     * Because page conversion could be manipulated in the size of at least 4K
> +     * or 4K aligned, Use the host page size as the granularity to track the
> +     * memory attribute.
> +     */
> +    g_assert(attr && attr->ram_block);
> +    g_assert(attr->ram_block->page_size == qemu_real_host_page_size());
> +    return attr->ram_block->page_size;
> +}
> +
> +
> +static bool
> +ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
> +                                      const MemoryRegionSection *section)
> +{
> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    const uint64_t first_bit = section->offset_within_region / block_size;
> +    const uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
> +    unsigned long first_discarded_bit;
> +
> +    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
> +                                           first_bit);
> +    return first_discarded_bit > last_bit;
> +}
> +
> +typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
> +                                               void *arg);
> +
> +static int
> +ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
> +                                        void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    return rdl->notify_populate(rdl, section);
> +}
> +
> +static int
> +ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
> +                                       void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    rdl->notify_discard(rdl, section);
> +    return 0;
> +}
> +
> +static int
> +ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
> +                                                MemoryRegionSection *section,
> +                                                void *arg,
> +                                                ram_block_attributes_section_cb cb)
> +{
> +    unsigned long first_bit, last_bit;
> +    uint64_t offset, size;
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    int ret = 0;
> +
> +    first_bit = section->offset_within_region / block_size;
> +    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
> +                              first_bit);
> +
> +    while (first_bit < attr->bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_bit * block_size;
> +        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
> +                                      first_bit + 1) - 1;
> +        size = (last_bit - first_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s",
> +                         __func__, strerror(-ret));
> +            break;
> +        }
> +
> +        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
> +                                  last_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static int
> +ram_block_attributes_for_each_discarded_section(const RamBlockAttributes *attr,
> +                                                MemoryRegionSection *section,
> +                                                void *arg,
> +                                                ram_block_attributes_section_cb cb)
> +{
> +    unsigned long first_bit, last_bit;
> +    uint64_t offset, size;
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    int ret = 0;
> +
> +    first_bit = section->offset_within_region / block_size;
> +    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
> +                                   first_bit);
> +
> +    while (first_bit < attr->bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_bit * block_size;
> +        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
> +                                 first_bit + 1) - 1;
> +        size = (last_bit - first_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s",
> +                         __func__, strerror(-ret));
> +            break;
> +        }
> +
> +        first_bit = find_next_zero_bit(attr->bitmap,
> +                                       attr->bitmap_size,
> +                                       last_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static uint64_t
> +ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager *rdm,
> +                                             const MemoryRegion *mr)
> +{
> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +
> +    g_assert(mr == attr->ram_block->mr);
> +    return ram_block_attributes_get_block_size(attr);
> +}
> +
> +static void
> +ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
> +                                           RamDiscardListener *rdl,
> +                                           MemoryRegionSection *section)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    int ret;
> +
> +    g_assert(section->mr == attr->ram_block->mr);
> +    rdl->section = memory_region_section_new_copy(section);
> +
> +    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
> +
> +    ret = ram_block_attributes_for_each_populated_section(attr, section, rdl,
> +                                    ram_block_attributes_notify_populate_cb);
> +    if (ret) {
> +        error_report("%s: Failed to register RAM discard listener: %s",
> +                     __func__, strerror(-ret));
> +        exit(1);
> +    }
> +}
> +
> +static void
> +ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
> +                                             RamDiscardListener *rdl)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    int ret;
> +
> +    g_assert(rdl->section);
> +    g_assert(rdl->section->mr == attr->ram_block->mr);
> +
> +    if (rdl->double_discard_supported) {
> +        rdl->notify_discard(rdl, rdl->section);
> +    } else {
> +        ret = ram_block_attributes_for_each_populated_section(attr,
> +                rdl->section, rdl, ram_block_attributes_notify_discard_cb);
> +        if (ret) {
> +            error_report("%s: Failed to unregister RAM discard listener: %s",
> +                         __func__, strerror(-ret));
> +            exit(1);
> +        }
> +    }
> +
> +    memory_region_section_free_copy(rdl->section);
> +    rdl->section = NULL;
> +    QLIST_REMOVE(rdl, next);
> +}
> +
> +typedef struct RamBlockAttributesReplayData {
> +    ReplayRamDiscardState fn;
> +    void *opaque;
> +} RamBlockAttributesReplayData;
> +
> +static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection *section,
> +                                              void *arg)
> +{
> +    RamBlockAttributesReplayData *data = arg;
> +
> +    return data->fn(section, data->opaque);
> +}
> +
> +static int
> +ram_block_attributes_rdm_replay_populated(const RamDiscardManager *rdm,
> +                                          MemoryRegionSection *section,
> +                                          ReplayRamDiscardState replay_fn,
> +                                          void *opaque)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == attr->ram_block->mr);
> +    return ram_block_attributes_for_each_populated_section(attr, section, &data,
> +                                            ram_block_attributes_rdm_replay_cb);
> +}
> +
> +static int
> +ram_block_attributes_rdm_replay_discarded(const RamDiscardManager *rdm,
> +                                          MemoryRegionSection *section,
> +                                          ReplayRamDiscardState replay_fn,
> +                                          void *opaque)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == attr->ram_block->mr);
> +    return ram_block_attributes_for_each_discarded_section(attr, section, &data,
> +                                            ram_block_attributes_rdm_replay_cb);
> +}
> +
> +static bool
> +ram_block_attributes_is_valid_range(RamBlockAttributes *attr, uint64_t offset,
> +                                    uint64_t size)
> +{
> +    MemoryRegion *mr = attr->ram_block->mr;
> +
> +    g_assert(mr);
> +
> +    uint64_t region_size = memory_region_size(mr);
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +
> +    if (!QEMU_IS_ALIGNED(offset, block_size) ||
> +        !QEMU_IS_ALIGNED(size, block_size)) {
> +        return false;
> +    }
> +    if (offset + size <= offset) {
> +        return false;
> +    }
> +    if (offset + size > region_size) {
> +        return false;
> +    }
> +    return true;
> +}
> +
> +static void ram_block_attributes_notify_discard(RamBlockAttributes *attr,
> +                                                uint64_t offset,
> +                                                uint64_t size)
> +{
> +    RamDiscardListener *rdl;
> +
> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +        rdl->notify_discard(rdl, &tmp);
> +    }
> +}
> +
> +static int
> +ram_block_attributes_notify_populate(RamBlockAttributes *attr,
> +                                     uint64_t offset, uint64_t size)
> +{
> +    RamDiscardListener *rdl;
> +    int ret = 0;
> +
> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +        ret = rdl->notify_populate(rdl, &tmp);
> +        if (ret) {
> +            break;
> +        }
> +    }
> +
> +    return ret;
> +}
> +
> +static bool ram_block_attributes_is_range_populated(RamBlockAttributes *attr,
> +                                                    uint64_t offset,
> +                                                    uint64_t size)
> +{
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
> +    unsigned long found_bit;
> +
> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
> +                                   first_bit);
> +    return found_bit > last_bit;
> +}
> +
> +static bool
> +ram_block_attributes_is_range_discarded(RamBlockAttributes *attr,
> +                                        uint64_t offset, uint64_t size)
> +{
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
> +    unsigned long found_bit;
> +
> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
> +    return found_bit > last_bit;
> +}
> +
> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
> +                                      uint64_t offset, uint64_t size,
> +                                      bool to_discard)
> +{
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long nbits = size / block_size;
> +    bool is_range_discarded, is_range_populated;
> +    const uint64_t end = offset + size;
> +    unsigned long bit;
> +    uint64_t cur;
> +    int ret = 0;
> +
> +    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
> +                     __func__, offset, size);
> +        return -EINVAL;
> +    }
> +
> +    is_range_discarded = ram_block_attributes_is_range_discarded(attr, offset,
> +                                                                 size);
> +    is_range_populated = ram_block_attributes_is_range_populated(attr, offset,
> +                                                                 size);
> +
> +    trace_ram_block_attributes_state_change(offset, size,
> +                                            is_range_discarded ? "discarded" :
> +                                            is_range_populated ? "populated" :
> +                                            "mixture",
> +                                            to_discard ? "discarded" :
> +                                            "populated");
> +    if (to_discard) {
> +        if (is_range_discarded) {
> +            /* Already private */
> +        } else if (is_range_populated) {
> +            /* Completely shared */
> +            bitmap_clear(attr->bitmap, first_bit, nbits);
> +            ram_block_attributes_notify_discard(attr, offset, size);

In this patch series we are only maintaining the bitmap for Ram 
discard/populate state not for regular guest_memfd private/shared?

> +        } else {
> +            /* Unexpected mixture: process individual blocks */
> +            for (cur = offset; cur < end; cur += block_size) {
> +                bit = cur / block_size;
> +                if (!test_bit(bit, attr->bitmap)) {
> +                    continue;
> +                }
> +                clear_bit(bit, attr->bitmap);
> +                ram_block_attributes_notify_discard(attr, cur, block_size);
> +            }
> +        }
> +    } else {
> +        if (is_range_populated) {
> +            /* Already shared */
> +        } else if (is_range_discarded) {
> +            /* Complete private */
> +            bitmap_set(attr->bitmap, first_bit, nbits);
> +            ret = ram_block_attributes_notify_populate(attr, offset, size);
> +        } else {
> +            /* Unexpected mixture: process individual blocks */
> +            for (cur = offset; cur < end; cur += block_size) {
> +                bit = cur / block_size;
> +                if (test_bit(bit, attr->bitmap)) {
> +                    continue;
> +                }
> +                set_bit(bit, attr->bitmap);
> +                ret = ram_block_attributes_notify_populate(attr, cur,
> +                                                           block_size);
> +                if (ret) {
> +                    break;
> +                }
> +            }
> +        }
> +    }
> +
> +    return ret;
> +}
> +
> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block)
> +{
> +    uint64_t bitmap_size;
> +    const int block_size  = qemu_real_host_page_size();
> +    RamBlockAttributes *attr;
> +    int ret;
> +    MemoryRegion *mr = ram_block->mr;
> +
> +    attr = RAM_BLOCK_ATTRIBUTES(object_new(TYPE_RAM_BLOCK_ATTRIBUTES));
> +
> +    attr->ram_block = ram_block;
> +    ret = memory_region_set_ram_discard_manager(mr, RAM_DISCARD_MANAGER(attr));
> +    if (ret) {
> +        object_unref(OBJECT(attr));
> +        return NULL;
> +    }
> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
> +    attr->bitmap_size = bitmap_size;
> +    attr->bitmap = bitmap_new(bitmap_size);
> +
> +    return attr;
> +}
> +
> +void ram_block_attributes_destroy(RamBlockAttributes *attr)
> +{
> +    if (!attr) {
> +        return;
> +    }
> +
> +    g_free(attr->bitmap);
> +    memory_region_set_ram_discard_manager(attr->ram_block->mr, NULL);
> +    object_unref(OBJECT(attr));
> +}
> +
> +static void ram_block_attributes_init(Object *obj)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(obj);
> +
> +    QLIST_INIT(&attr->rdl_list);
> +}
> +
> +static void ram_block_attributes_finalize(Object *obj)
> +{
> +}
> +
> +static void ram_block_attributes_class_init(ObjectClass *klass,
> +                                            const void *data)
> +{
> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
> +
> +    rdmc->get_min_granularity = ram_block_attributes_rdm_get_min_granularity;
> +    rdmc->register_listener = ram_block_attributes_rdm_register_listener;
> +    rdmc->unregister_listener = ram_block_attributes_rdm_unregister_listener;
> +    rdmc->is_populated = ram_block_attributes_rdm_is_populated;
> +    rdmc->replay_populated = ram_block_attributes_rdm_replay_populated;
> +    rdmc->replay_discarded = ram_block_attributes_rdm_replay_discarded;
> +}
> diff --git a/system/trace-events b/system/trace-events
> index be12ebfb41..82856e44f2 100644
> --- a/system/trace-events
> +++ b/system/trace-events
> @@ -52,3 +52,6 @@ dirtylimit_state_finalize(void)
>   dirtylimit_throttle_pct(int cpu_index, uint64_t pct, int64_t time_us) "CPU[%d] throttle percent: %" PRIu64 ", throttle adjust time %"PRIi64 " us"
>   dirtylimit_set_vcpu(int cpu_index, uint64_t quota) "CPU[%d] set dirty page rate limit %"PRIu64
>   dirtylimit_vcpu_execute(int cpu_index, int64_t sleep_time_us) "CPU[%d] sleep %"PRIi64 " us"
> +
> +# ram-block-attributes.c
> +ram_block_attributes_state_change(uint64_t offset, uint64_t size, const char *from, const char *to) "offset 0x%"PRIx64" size 0x%"PRIx64" from '%s' to '%s'"


