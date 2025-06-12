Return-Path: <kvm+bounces-49257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 353E9AD6E87
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 13:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE2E1170B92
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 11:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FD8239E99;
	Thu, 12 Jun 2025 11:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D+OBUddR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827291DFF7;
	Thu, 12 Jun 2025 11:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749726249; cv=fail; b=jkrVi8RwxQs/yNNqF21QPjNDl8QSnJp0TBZrH+hMCNNASqG6tJ5bnO4K7DUZJgZ3PZxyJ9l28EWa69sn3Wx4+6UTT8LddjiHI+rTkRrBrSI0pKRBIPX34pw18mXibzGEhp5vTRlPOPKtWdCBE4+wGY1lOLmxlBqX0qkuMp99BY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749726249; c=relaxed/simple;
	bh=LfKBKl3dxErAfnT94z1U5sdNWxmjnVBrk+oxTHCdGeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fgypzljrsb+iYwWSWhvLD5J1N/2dMsMeLzZSXqCizTeJDDB4NXFSbOgwaxbFuYeNvg3+0KlejKfLq5Le+HQsqLAdkaM34Ja64nF8EsIe2xR407bGbDi2y0Q3Gv6agTA80zMlFcZ0efnH5kVUmoUZi9FgNlnYNJ/DzZvbKA5z9Hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D+OBUddR; arc=fail smtp.client-ip=40.107.102.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZKQWFshjO0E47nSrWx5x6QG2LdvZzOndhIg/QuDUv30YPOx30WtLXrknal2zvD4gM3MXHsMft+TDlpHqiaNo98TuRqurcXBn777iPJp58SwtLRFoyfuP+RNAs4iL8/UlymEQWjMCy3J5ViPwmzrc0EMlF9rUagHOW/Sx8ar7mGzmGzBP/sk79Bp7bsZIaXVT8xLguMMoGWO0qOQGvErSImfRLLVdylCQd2X2TATIB0czGlnw4X+cNhIFvtJhuKWeziZLSg171gp4U12VXtZa4bOxbSA5Dbu2JHotlTLs6WYNjHQUsEv6a3l1WYTo3AG2pZVZp+Z3Tw9sLbbWVNppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMHzS6LgiYW9Q7FQD8uqgNEKgwsC/1bJpQ/My1KNqcg=;
 b=C++xyDh1bwPrkRc0MhQBZcxIJ96OjBAricpxOrbu2IofxxERHInjqQqyKAudv8LDCp9tUWOBxVzVhFydqsom1D+eBQfJtQt1QSagOk62Sn1OFBVgCmXe8K6SWdUa848G3AiV/GzRKrJxoZ2ofLFza/ulAf2Xhk3tV9U+BCuDvTci4GZubUxjUOtxIinhCAleOhjUWoKjkCvqThudBA+wRaViOgTHEq0tTbG5II1opwW6xw7Kyn2KryJ9y16L6QCFthV7UZYYH9VnZgf9/vMyWmwkJfn2gMRam+3zhSYfElFMR3y3Mg1/myV8UNttwRvWbg2T9/w8AyFIBgtSHsFdpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMHzS6LgiYW9Q7FQD8uqgNEKgwsC/1bJpQ/My1KNqcg=;
 b=D+OBUddRGKyyQFBZ4tkcSZttBrZx9S7/4FzuyEmiqsHtV68KNf856iGEAce4piTli89/elCEF8XilNUGGi7IzTO7pVi4R8BIigo9x5LauJnJ6+KBFKccDm5h4xB5QA6aAt0+U4BRmHsyv/y33SRX4qHktn1hNb7SuA6tTsjSZCw=
Received: from CH2PR07CA0002.namprd07.prod.outlook.com (2603:10b6:610:20::15)
 by CY8PR12MB7266.namprd12.prod.outlook.com (2603:10b6:930:56::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.39; Thu, 12 Jun
 2025 11:04:03 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:20:cafe::20) by CH2PR07CA0002.outlook.office365.com
 (2603:10b6:610:20::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.22 via Frontend Transport; Thu,
 12 Jun 2025 11:04:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Thu, 12 Jun 2025 11:04:02 +0000
Received: from [10.85.38.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 06:03:59 -0500
Message-ID: <55b5827b-6809-47a9-b5d9-57fa68736e9f@amd.com>
Date: Thu, 12 Jun 2025 16:33:52 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/59] KVM: iommu: Overhaul device posted IRQs support
To: Sean Christopherson <seanjc@google.com>
CC: <baolu.lu@linux.intel.com>, <dmatlack@google.com>, <dwmw2@infradead.org>,
	<francescolavra.fl@gmail.com>, <iommu@lists.linux.dev>,
	<joao.m.martins@oracle.com>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <mlevitsk@redhat.com>, <pbonzini@redhat.com>,
	<vasant.hegde@amd.com>
References: <20250523010004.3240643-1-seanjc@google.com>
 <20250609122050.28499-1-sarunkod@amd.com> <aEbw2zBUQwJZ3D98@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <aEbw2zBUQwJZ3D98@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|CY8PR12MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: b77c1179-bc76-43d7-b359-08dda9a0d749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akFHNElmZEZFY0t5U2ppdU9FQk00eTljZmFHa0YwUmpITU1rM0pRdFN3MFEr?=
 =?utf-8?B?WURDOFZHUHA1NnlTUVRzWXFydmFtR3ZqZ3pSd1AzNnAyaTZCbkl6Zm1iaENt?=
 =?utf-8?B?U1BSRlZoNFI2elZRUkFPVDFmSk91K0g5eFBIRDlQSnFCMlRHcnJLakxoN3NF?=
 =?utf-8?B?OUNXM2FIbXp5bUVtd3V6d1ExR1lnSzVqVUNlSWh2NHpBS3g4Ly94NkVVdTdJ?=
 =?utf-8?B?Y0lybEs3RDRiV0dMeVpRRW01YlJLWDl6UXAwVVBlQWxZY0tSQ2hFNDJ3dHJo?=
 =?utf-8?B?d0hsMHg0NytXRlhCUTk2Z25odG1FOFpQaTVUY21EZnZOejF5aXRiNHd4TStm?=
 =?utf-8?B?cFc4eFNJdjZFWG95dXpNZ1ZqSHBkeVl6OUgvS0YxN1AyZjF6U3dJMHdEUytL?=
 =?utf-8?B?cTMzRk5kWDdaTWkreHBrREpTenQxWGs2cEMrL2NIOVZ0dkd1cnY1d3RLTWhG?=
 =?utf-8?B?dDQxWVBqcndxZS90N1oyelNyNVVreFpYd24wOUwrcGtUVjJCRE40UmZWR1ZH?=
 =?utf-8?B?OWpDWFdHYnU2dkdNMTZuOXQ4R2MyRE5IM2ZaZTViWjNTVmpiMG1yNXBsdGgw?=
 =?utf-8?B?RXBsb2U2M0VlNUc3b3EwVHAyVHA3WU1sY2FRTnZRVk9FQzQ2ZlpmRW5MaU9X?=
 =?utf-8?B?UldvTlFQbTMvdFhvejEyRitaYy93Y2pTUEpqWEl2L01TTVd2dDFrS0NZSmRS?=
 =?utf-8?B?TXNBTWtXK09VOFMySGlXWktzZHhtTGo1TmtRb015aVlueFRMcjBoYUQwSDRm?=
 =?utf-8?B?d3U4SmhRZGxXZzdnczNJT2dxd0ttMUVrbm05bUppU0pFdjJqR3dpZVowVlZT?=
 =?utf-8?B?c1lMZEZHKy9pTTZxUWh2MmtXNkZOWXZtK3B2VlZCTDRSZHZab1lXVXpTQlZI?=
 =?utf-8?B?TlI1VHNXeWtTZHV1QkdyWm5kcGRPUFRlTXBrVHlkMWN6WWdJVSt4YnFTQXNv?=
 =?utf-8?B?N1RvRjRBRFZPMG0yM2gvRjRMdytiaGdubVYvSWJ6TVFXLzA0STFPTm5MMFFS?=
 =?utf-8?B?cFBjSFJCd1pnQ2VqcW5mRVdnQW9DNzQ2TXdWWWFIUktSSnM4YW55cmgzN0Jr?=
 =?utf-8?B?NHVqbmkyeVRVOXl5azdDdlRvSU5Zc3RiMjJMUUd4VzFXSjI4dUVrT3FOTEM0?=
 =?utf-8?B?cFpIdHpGeHp3Zkd1MUlBN1Q1ZlBxQ0xtZjNIM2ZaRGxXbXhRcmJTS2JuVkM3?=
 =?utf-8?B?YUhHZzAwMzB4QmJJREhRNGd4N3lNZmhPazcyTlJDSDZnK05ZY1FGUXlPR0t2?=
 =?utf-8?B?MG1DQ0tYbWRIU094K2F4WHJUc0JSVklwN2VVYTlPZGJTWVJUNm1ieFVvSEdH?=
 =?utf-8?B?aTk3azJQQTVXQnhoS2wyOWJNbzFXUWRDVU4rKy9FaWdYWTI3d2R4WFQ2RTNR?=
 =?utf-8?B?cHQ0UzN6bEdDUHJZaHAyUzZ2cGdYMzFOa2lyVHllbTlsSG41cVdVSjdDR0hh?=
 =?utf-8?B?cWJGeXZuQkszb0hOZEc2T2lGeHdCOTdDajhjVlNubEFlRVpsSU9YSjEybmtE?=
 =?utf-8?B?VXRUNlc1b3RBN2d0RXJjeW5vL1ZSRldEN1lqSEs3TWZVUVNmOWZIS21yeXlU?=
 =?utf-8?B?S2NPQmkxdkQ0S2R6TWliaDBkRWgyRkFEZFBUbmJsY0lGbmNGa2N1RVgvdXlE?=
 =?utf-8?B?c0ovK3gwVmdJbWVJZnBtN2Z0ekMrTDNTNUxtVDN5NUsyZWdES1FNSFREN3o5?=
 =?utf-8?B?MnRMZ0ZHcW9tNEFqRklFLzdJMXBIN1hkcCtoVEZIci8rbTRvUjJIOUFJVzNR?=
 =?utf-8?B?VklmQkp1amtDZVcyYlRKRWlvaU8zSmZjaGxEeG96N2YvOXFUKzdDK1d1cHZa?=
 =?utf-8?B?bWFOVDhoeGw0dDk2MUdQL2dGWVJOU0ZSazdtZ2dIZjdRT09JSE1hejVzK1Zi?=
 =?utf-8?B?c1pmbEsrakVSbkRJeTBGc213UVVIbGNGRlVicnNkRnJsZE1CWHlSdkdpTjBw?=
 =?utf-8?B?bXVLWXU0N3V4KzFBeCszY3djSjk0UTlDWTFuZGF4d0N2SkQ4bFRTTE5JM0xQ?=
 =?utf-8?B?QkY4K2N5U096ekxSOElXU1lHVGtpMGFQZUdCNlM2d0xyZWFYa2lrOUd3SW8r?=
 =?utf-8?Q?KpBb04?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 11:04:02.7708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b77c1179-bc76-43d7-b359-08dda9a0d749
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7266



On 6/9/2025 8:04 PM, Sean Christopherson wrote:
> On Mon, Jun 09, 2025, Sairaj Kodilkar wrote:
>> Hi Sean,
>>
>> Sorry for the delay in testing. All sanity tests are OK. I reran the performance
>> test on the V2 and noticed that V2 has significantly more GALOG entries than V1
>> for all three cases. I also noticed that the Guest Nvme interrupt rate has
>> dropped for the 192 VCPUS.
> 
> Hmm, I don't see any obvious bugs or differences (based on a code diffed between
> v1 and v2).  I'll poke at the GALogIntr behavior just to double check, but my
> guess is that the differences are due to exernal factors, e.g. guest behavior,
> timing, scheduling, etc.
> 
> IOPS are all nearly identical, so I'm not terribly concerned.
>   
>

Yep you are right. I was indeed using different guest kernel to test V2.
Keeping it same, I can produce almost identical results for both V1 and
V2.

Only one case that still stands out is with 32 vCPUS, where posted
interrupt count has increased from 200 to 7000. But IOPS and NVME
interrupt rate is identical hence I am not concerned about it as well.


Thanks
Sairaj

