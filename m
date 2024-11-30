Return-Path: <kvm+bounces-32785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FB89DF341
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 22:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E415928107D
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 21:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA021AB508;
	Sat, 30 Nov 2024 21:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jkBTBrwN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDA9130E27;
	Sat, 30 Nov 2024 21:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733000542; cv=fail; b=iax43pfMdyJNYJHWv9K3p+smMPSf71Iu8G0E3uXadtGiupNNcHtB39CX0E3yGe+fJiJMTnUE7U3sWykZzVQZBHdvLe1AljoWdBGVlv/8uqzGprR4Rr4KnjcbivElJVFnSQqaeMoLitoXqc15yQAt6X6C4+AMnXa3OzODhH/mAMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733000542; c=relaxed/simple;
	bh=ntb0QGydQfU11jSzuyOsRg8/RK2DIACaQNZQ76OGwDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Qxa8cftj745JkIHmFJiCh2ndcq6qDV0WULgOIiVBb/s1Mhvg8wPA+BYtcs4pjiUkSWQ/OhQ8/eK0wmNmAJArZ/nkMl3KUP33DGS+QSOf3L59ZUtLXU2xgUq4RFwFrwBmQQx198oepktbRZpi1AYEn9vjxdlS/n8BuRIuIG+7suE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jkBTBrwN; arc=fail smtp.client-ip=40.107.94.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MNb1lWS8B/25Zl4VaSSHoo/6vJMZOQwGFnyDt+Gp/PwyQ/WxNZ1p9iu8mbsyiGU/O/h6u1JOkJ3n1vsO4SoRISOo14zo/JF+kW4yYmVrvsUbX8q9Fe3/WZ5k+CH+B4Dy9nYj7VdheawiA0KHgCizg3yUKzHj/mXwBDgVECNbFxb4GdjIE20c//HmW2D3reS1gYh2nWJtic90RIUg+sdJO3rly/K1zx5r162gXpahpVTrLZi3N5fsEfJWpphuPQo0+NGC6TDF2rFA9rH4Wu7jEyLNaRyWi5j5LzsCx4Pyc91ZAKjg176pSOnMLwRBAsDqKB6FxrW0QUxeLlPcwhC68w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/5p5ibaS/CXKkG2Q3RHA5iLkBdF0jzoHRm0QfD1bao=;
 b=teLYMq/wXo1xj8ffXZzYpjI1jjL02h1CJ1utIAlYIfsA+AkYPchXu5BRfeDgkXeCwM+aBq9GhH4pchwQRBbGk9pHGUxeUuDRn/ww1KR6er7v2dRa2i6/T2kNBZIlmtw8wL19/xBQPXTE83XEKwTAlOduBDRuvaxgYh+t7UMNdPQqEUQc3apaP6pFZa4dp1nnJYOXGpGRmARurOTdZftqkr+5Odxc1dpmXke4nMvFif+hJq59TN0PoCx+rCYqk2QAWZYN7YbQIXEFYLfVdiWMs5g3L102EkpcHzAGzdqhOqlct1ZsiEub55CEHKAl3AHrlgDvwT7vQukcVC1PhanVbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/5p5ibaS/CXKkG2Q3RHA5iLkBdF0jzoHRm0QfD1bao=;
 b=jkBTBrwNynhQamDLnAMTY1D3MnANnKomLeh5/sVe2hEG47thQkWKt5X+F+VPNxpnsynoqcPyyrwk+fZU31R4yR740AEary6N9R6m7plG3A4YJAwzPYm2CvJ2y7Fmp1oCEr3lYiT4BQLZWWbnVNiop02eSDwR0VN6/l1ksrMI7DM=
Received: from BN9P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::27)
 by MW6PR12MB8836.namprd12.prod.outlook.com (2603:10b6:303:241::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.16; Sat, 30 Nov
 2024 21:02:16 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:13e:cafe::3a) by BN9P220CA0022.outlook.office365.com
 (2603:10b6:408:13e::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.15 via Frontend Transport; Sat,
 30 Nov 2024 21:02:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Sat, 30 Nov 2024 21:02:15 +0000
Received: from [10.23.197.56] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sat, 30 Nov
 2024 15:02:14 -0600
Message-ID: <5068baf4-7065-47c7-b339-b211b8fa80ed@amd.com>
Date: Sat, 30 Nov 2024 13:02:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] KVM: SVM: Inject MCEs when restricted injection is
 active
To: kernel test robot <lkp@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Tom Lendacky" <thomas.lendacky@amd.com>, Neeraj Upadhyay
	<neeraj.upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, Michael Roth
	<michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>
References: <20241127225539.5567-6-huibo.wang@amd.com>
 <202411282157.6f84J7Wh-lkp@intel.com>
Content-Language: en-US
From: "Melody (Huibo) Wang" <huibo.wang@amd.com>
In-Reply-To: <202411282157.6f84J7Wh-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|MW6PR12MB8836:EE_
X-MS-Office365-Filtering-Correlation-Id: 210ddc77-6890-466e-d19c-08dd118244cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTZUL3pkVWxDNU9rRmVEOGFQRm03L2NqQmhXOGY2aHVqNUxCdjVUK2xaUGtN?=
 =?utf-8?B?UzZCUjhGNWRCaUt6dHFBSTl4WXpQL1dLUzZjKzNJNUcydXQ3U01sV0hLdkh0?=
 =?utf-8?B?WDZXTU55U3lESm1IN09vUFFZdTl6YVdwN1VEdVlwWGhLY0Q1ZjkwazAvNG16?=
 =?utf-8?B?MEwvRzUvZXNtQVpGbnNFRU01Z1NVRG9vdXpLbzB1amlZZGZVMTZKMUVVRVBM?=
 =?utf-8?B?aXprSjdDTHJSOHBuSmc2NjJlT0x5THlhQUh3SnVVY0Q2QUxnSTJEWkExVUdk?=
 =?utf-8?B?d1dPelNJdFBSTUVIaEE3MmFHb21EcGFPbHB3ajl0U1I1S3lSSFNqUGwwZVpN?=
 =?utf-8?B?UGRpOWdabkFTQUhIQXdTMjgvM2tXalViU1daczM3aW93YXpadWtzTFFrelVn?=
 =?utf-8?B?NExWbTBVbW1ERk5rYUhvWG9oWGp0ckZMeVJidDVWZ25tOGE5WXVHRzVNVE9O?=
 =?utf-8?B?dExYU1RHWFh0a2Z6TEdFQzB3bVNXYVZmOVFCMXVUM2g5TEtCZWw0MVVOTENS?=
 =?utf-8?B?R1dvZzRrc3V0TG11L1NvOVFJZnRjK2FGa0tSSW12WGVOdjBaZm04bFRDYTZU?=
 =?utf-8?B?NHFmSEw5U0lEUmxLQlFVT0pBWXUxbjJKYmFnWlZhdHZmTkpobWxEQlhiTjB5?=
 =?utf-8?B?Ui9PTE81S3l1UDNsYmg4Z3loZGJUSnpWWW1IbjR1Umx2T213NXd3VjFib0h0?=
 =?utf-8?B?MlNqQk9sL293RTRETzdyVkNmQ3p5QStOVFd1cE5wUkZUbWwwOFMvL2FEV3Iw?=
 =?utf-8?B?YXAwT0FNQjdJbGoyYjZURC9FeFlGcTN0dHVZUlZhZVRZZGxob2NHVEw3YmRT?=
 =?utf-8?B?YjMwZ1o2U2VzQVlMZkt4K24zdUZnMEV4bmtuS0d6Q0o1bmxTdVhNSEk3SVUz?=
 =?utf-8?B?WU4vSm5SNHlVTFNITkNoZlFMM0M1bjVoUEFYb2d5TXdhT0d2YkE5OE5xOEh1?=
 =?utf-8?B?bnFFOHpRWDladnAzVWdVR1ZRdUV4NjljN1AwQjBtRkNaYWRpU1pnYVVuVnIr?=
 =?utf-8?B?ZUthTDNqK2VlaXh2TGVNbnFEaFRPRlY3UmZOdWpUVHZqcHVIY1lTM09qQlBW?=
 =?utf-8?B?MUJsM3RaS2dLZzFSNUJWRGd3aUVSLysvR3V6bUNPcnViRXMvdUNiTklEVnRz?=
 =?utf-8?B?RWN6WEI1OHlKeURLTkNzMXNYNmhLS3I5Ly9vQ3hBSUQ3bXQxYXFRcW5BUDdy?=
 =?utf-8?B?ZGN3S2ZMb3dKKzUzTEs1bi9ORTVqN3VIK29IWjJhOXI1blZyU2ZZSUtveGtx?=
 =?utf-8?B?TFNKcXArMlpOckQ4ZldRR1MzdVNiMDd0N1QrRWN2ME1UWnhnQUhDRmdjTjVY?=
 =?utf-8?B?V3pmZHBCUEp5OThCbGV1cE9HcFBNLytYMlFtL0U1RHpaZ2FUSG1rbFBzZTFV?=
 =?utf-8?B?Kyt3ak80ajVjQ3Rjd0gwV2t2WVRZOEkxQWpXNWgwRFFUTzl0cDdpVnl2YkZo?=
 =?utf-8?B?WVBKOUdPdnIrZDJvN1JXL2JqbUplRHZJQzBrTHdKcy84azlWa0NXWUNQRllW?=
 =?utf-8?B?b2s5NDAwcTlCckRnWCtMNGViN0pwbW9oV1poaE50WjBORVdKRkdhY3B2SWdN?=
 =?utf-8?B?emJVekVVQ2ZEeWFIWkNaa29jMnJtTk5LeVlXMnpUd1d1UTZkVVgrblNubWxx?=
 =?utf-8?B?NFU3RGM4TUdhUThqWVBBYnluVHpXZzhNMkw3RExwSjFhenRCQzRrcTYxZDNT?=
 =?utf-8?B?TGpCdkF4TjkzWTgvU1ZmVk9PWEFabjY4SlNUQ2lyWURXOGpPMGliK0p2WXpY?=
 =?utf-8?B?MnNoVStod2dSUkVwTEVIaXl5eElKQUk2eXB3VzlvYm5UTzEvYzB0MCtrWWdL?=
 =?utf-8?B?Q3FNVzdZOUVOdVpFQXZNelFEK1BxQ1UvTHZPQVFxNkYwYWZPcHNIS3Mwa1dR?=
 =?utf-8?B?cFR4aG5nOWwrMTVQSmVIOGp3Y2F6RlE4SDZndHR4VlFZcUZZOWtlbXRLZDA2?=
 =?utf-8?Q?PNaT8srD4TlmhIigj6jw0Cb/OBE+7i93?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2024 21:02:15.3547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 210ddc77-6890-466e-d19c-08dd118244cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8836

Hi,

On 11/28/2024 5:41 AM, kernel test robot wrote:
> Hi Melody,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on kvm/queue]
> [also build test WARNING on mst-vhost/linux-next tip/x86/core linus/master v6.12 next-20241128]
> [cannot apply to kvm/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
The base of my tree is 

4d911c7abee5 ("Merge tag 'kvm-riscv-6.13-2' of https://github.com/kvm-riscv/linux into HEAD")

which is the current kvm/next branch. 

Thanks,
Melody

