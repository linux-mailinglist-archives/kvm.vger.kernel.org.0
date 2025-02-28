Return-Path: <kvm+bounces-39766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7133A4A456
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 21:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A08A1898D54
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 20:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E1A1C54BE;
	Fri, 28 Feb 2025 20:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EyngRttM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CD623F388;
	Fri, 28 Feb 2025 20:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740775139; cv=fail; b=YpZBNBPrFzB+TUut5xYIiNONb1o6fnApM5ybF7nqv/dUVS4mU3Os7Dg0jzZlyvPtck0W6A1ryv7h9tGEBdjaFWMJg8mcX3G3KAhSGhiJ7q/fy1zdQrivqWlumS+UneDHPlWrG0PShNLuyGYJ2gMx7/YAP6siJYXFerXuWFs8Pjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740775139; c=relaxed/simple;
	bh=6REfuxT0iaEJv3tWpiKDY6GPY8urm1lIGIi8GDsmKzI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O1HOxpXXIQIUVoShJzx2092h+0wHqpQwW6WHsew645cQ9lsY5OZsDAXm+tscXoS25/p2fCB5vd+vVh36n2tdmM0l8hTkMUCs1WtsXT/bKgkSBIE31mgqW3t+CrD0q96QGhumYuHFOepx2Fvt0qMksWT4vngcyOPNG55x7f3krLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EyngRttM; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YTTktAPddLrJq5mIxqBn8xlwyKVHOZ1VOn7JiC60rND/VCID8prn+xWN+SFtdwf2zh3GrY8Yga2hhVZTLYhKZWXemKIvSfXvAOcBgYeRJOZuoBl6Ns0LRYY4YyUqRJcjXcni7hPXMNA91mzgbjLty4IglqsSYKrzV8DA7yGxeAhB62T15DnkD6vHPdzUZn22YxRcLPMRQa3x07MI0o4D1xrnaqKZsOPWc5zeCrEwELtqLFQ4muN9neW8e53FpRV5ZSqWLhUF1dkKcRcwu2B7WWISPe3HeW81xJMqmSIq4K7i015x3fS166GIxy9Z2KubXEEXMz5+scaOViwuT843Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJYS2jTh/QKnZeqnxysRSo8A2ueRmeB89ZLBZh7ZTp8=;
 b=vQDxiExU49BUVvgrFk9RnRe9dH+qxJ1WdW+erQD1b1SuexK4JwYhst0SLZdwoqU2Sz+JMqKPj7z2Flf4uXlvFplbX9KTmZsvUs6SJXiTrWwxPqYyk8hXSiDnr+lRI2oJTtl3dZDQG/PqAj838I5BBazO7GzSgYHTzzBZRxME0iUAY55TPEfJMsrYfOUqxQ3/at4QEmzUJHoiCNcH8exkdPPn4BorSG9Fz0VWxxIcHBKR18VEOfpVhSs6vcWYeT97heMuWH/Dpaq5BpleUvofW7PtgP8t1pvFxgHMbGsBVEF4Cy+oH79e1T0kX67XXqcYqo/qmoalS89NWPQujyzEaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJYS2jTh/QKnZeqnxysRSo8A2ueRmeB89ZLBZh7ZTp8=;
 b=EyngRttMbTB2RgnJyR64TMaCBZgPr6FLyiBb7qTTbZVbrSphE/tIP9EI7BBK4QWRQCuZSao65e18wEvzXLLerIjVi99WBMJtof2pS4Y7/xUCmll+6NpNzGmmJtpIZIuAjGdAqMC3miyHuRFNmUrRoDhnUte08x0HimE9A+Bxu88=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW4PR12MB5603.namprd12.prod.outlook.com (2603:10b6:303:16a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Fri, 28 Feb
 2025 20:38:51 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8489.018; Fri, 28 Feb 2025
 20:38:51 +0000
Message-ID: <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
Date: Fri, 28 Feb 2025 14:38:46 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z8IBHuSc3apsxePN@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0110.namprd11.prod.outlook.com
 (2603:10b6:806:d1::25) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW4PR12MB5603:EE_
X-MS-Office365-Filtering-Correlation-Id: 989b7fa7-cc8e-4c23-50f5-08dd5837e910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tk1pcFJFQmlCL3FXM0NkNjhSNmlwN2haMFlQeUoybzdaMlJoS3V6amk5dkEv?=
 =?utf-8?B?Q3dUNThBc2hXTCtESFFtUGJ6b3RvK1N1SjNWdTl2NGN5MWtydTM0MVh3b21o?=
 =?utf-8?B?VmcwU2hzVHFRZ09sMDRGQVdtK2hFa3U4YllOOGFtWGJGT0dseVBCekl3TDJH?=
 =?utf-8?B?dkxJTnhkQm1uSFE3ZC9qbDVPZTBSaUtMK2phOE9kWnI5UVJhMW1BM29DYnl1?=
 =?utf-8?B?aWF3clBWd0h5OGNJWXh1Z2JXQnlTd3IwUXJDdXhiNk96WkxKZEdtWUFlSURq?=
 =?utf-8?B?UUFibXJOSXRYcW1XTEZiZjBoQ2xUV1BOS2Rxenp3WTFxVExaaENvbEhsOGdL?=
 =?utf-8?B?aFpydXVoL1dtQ0tQL2dmSFRNQUMwMVZkQ3BFbTArQVMrcWFiMzlHdm1id3Zq?=
 =?utf-8?B?azlnUDgzeS9GRHMzam9ETGVuTmE1dW92VWhJVW5HRjVTdWVDNW9BOHh6ZVNC?=
 =?utf-8?B?emFPbXRGVGg0Vko1eGNNRndoOGJ5R2ZKaFpCcG5IRDM2NFAvYXBqRkFyVTVy?=
 =?utf-8?B?bXcycUE4aXFrVW9UY0RqTFZ1Z09YdS82cTlBU0V4bmlXSHYwRlFvTlRMUFZL?=
 =?utf-8?B?djViVDcrbXlFQVEvbkRsUk0zODRsYU5HbEJOeHdtUEV5NUxTSk5mcUtFUGJu?=
 =?utf-8?B?ZVRQbUE5RG83U0RHR1BCWkRmcHBVQUhZemlBblVrRjlIYnpHcFJBcWxLa25z?=
 =?utf-8?B?aWo5NUdJWmZKVTZFUTE4aHM5TXBYb3IyVzNyTE5jbkhGbG1VTUdCOXFwZXJB?=
 =?utf-8?B?QXNvUVNaNDVhOG4vb280cVlrUVNHT0lTdzQzT3c2cE9lM2NTYU5qcEpVSS84?=
 =?utf-8?B?SVRjSVFvUnFnU3Z3UEJMSGsxbXFDVE5RYlFKbThyVDFmNFhPb2o1ZjVvQk1i?=
 =?utf-8?B?UjBBNkgzckVUY0w1cXNLc1FKQ3pCOGx3V3FYV1VHYkRERGZ5NjZNOEMrMVhU?=
 =?utf-8?B?UURqOGwzYWg4RHhEMVZHVnN3VTZOMjVUdXl2UWpaRmRHK3l2TkZ5K0ZnOXpM?=
 =?utf-8?B?T1RoZnlrbjVaSWxEbVMwaVB3U3lFSkFQbE1JL1B5U1pBaHlXRUI4TklnSWZB?=
 =?utf-8?B?T2pwTGREbThrS0xJOFc4aFMrTlRmVUZtZW1MOWVEZjIvZTNYa1UyMFUzd3Ew?=
 =?utf-8?B?bndDcDlBM003dUhpUGdSWDJNY21CaXJsaHdubkEwVTFHdXVDNEtTL05za1pG?=
 =?utf-8?B?R3lNUzVXMGFJTUlBenB5NkRXWkQxdzFGWWNidzRxb285SGNscGVpZ0V5T1gy?=
 =?utf-8?B?c0E4UTZGdGhBV0h1L1I4SFVvVEZ2ZG5KZ01jMjV1UTNQeGxod0pPZ2xwN25p?=
 =?utf-8?B?b0tKazNZeXFxV2szcXhBVlJtMXVobHRXdmdqYUFzWDRwRTV2V0xxNFZJM2t3?=
 =?utf-8?B?YnIzZnA3RlNBUzQ5U2dOWGV6c25ycU1VMHdWRFYwd2xVeEdXbG4xUUZiM3BD?=
 =?utf-8?B?bWZuaG52UlB3MUhQMkpqYkVIbkJTeUtnMzF3TklEOWdlS3BxVUxEMld5Wk5k?=
 =?utf-8?B?bG9JQldDdERPby9yaHpkYllGSmlkekE2L3d6ZDZrYnJ4S2U4a1RmSlNXZ3Zq?=
 =?utf-8?B?L0Y3WUw3ZTIrUS9qcGVKL0M1d1MwTERmd29PYk1lMkdCUDlFVXlMVzdzbnEy?=
 =?utf-8?B?VU52dUlMS1dLSWdXYWRic25qNEoyRVdsQzFuM1NueGNTYkVxemozNVc5d2lO?=
 =?utf-8?B?YmZtbVlUeDBqZXo5QS85RVNLaDlsbW5lVUdQTGRrbDVJUUc5VjNPSzFPd3ZU?=
 =?utf-8?B?OUZFSzIvZU5WbzkzbnlNcEJVdm1HZzAvdWtZNU9sTXBRQlhlMEJFL1d3QTNL?=
 =?utf-8?B?WmNZYndZNVlLWWNwNXZEdzZVWkxYNUtyUng4ZXpFemFYR3hzVnVnWXZVRmk0?=
 =?utf-8?Q?IHahl5wmQyOBP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEhnZ1ZtS2V2Y0llS3NySFZCK3FoaFgxVGUvUjk2bDgxbEloNGt4aDI2MGZF?=
 =?utf-8?B?ZStuZXZpbEl5TVNZdG0zY0Q2SVFHR3lTQVpMMG04NkJwbmRBV1hpRDdxVFVE?=
 =?utf-8?B?STFIdkNFYVRrSy9nN3NoOWdMUnVwTER6a2l5WUJEcUpPUjdyaFVZVSs0SWpT?=
 =?utf-8?B?K1lxV3BwREk0WDhUa0QvaWhsK3dLWkdxdlVwN2Q3UEtEYlU5YnBzdE9mMkF1?=
 =?utf-8?B?ejlxMGhFZmRoRWdLbiswcGdidlZ1ejNubUU3bHZRMWNTMzZjaVcvVVd1YUZD?=
 =?utf-8?B?anpQbG00NmNpY3o0aTVjbUxEbzh4N2JpNDFwb1lGYnVpU01VdG5CdXMyNktT?=
 =?utf-8?B?WUNJb2ZweUNVY01hYk51Wkt6aXVnMGkwVG5QQU1SOUh4c200RWJBbStDSUhm?=
 =?utf-8?B?aWl3UGNIdG16djc2dFB1LzE3blBvZWFtNkx4ZzVuT2w5bjVVWkkyU1V6Y2tZ?=
 =?utf-8?B?SmUxaVh2TWZnRVFoc1QrZEZVV0lXWmJhcVlXWEd5eSs2L0txd3ZzNUYwQlFT?=
 =?utf-8?B?ai9WdUNCSjR6SGtDMlJOTGpZRVZJVFF6a0NjSXBsQkJteW05Vy9nQmlrc1Rs?=
 =?utf-8?B?Vi9Gcm5GNk03bHo5WUtkS0ZISTB0YWpoQlRLZUlBUGUvanBmZmJjY1RZNkIy?=
 =?utf-8?B?M09QbGluelhhaWJtZElGckJ1MitseTBSN0owa3hIY2UrYlFUNWdHU0l6UzVh?=
 =?utf-8?B?V2k3ZEc3RmphZVpHNWpvRWl4L2pUOXIyUXRiZlM1OHpCL2txYi9sZ050QVJ1?=
 =?utf-8?B?OVB2WHlDVk5LUStaNjAwZTZxVThneWlvdTRja2R1Rm9qb3pvSGF2bXd5aVNN?=
 =?utf-8?B?WlRCVUVSZEMyUUNUSHh3UmNZS2ZFRFZLU2UzVzQybkoxanpuNGw4NTNlelJY?=
 =?utf-8?B?MjBSdzhES0I2U3dsVTRQbGQ1S2dFcW85bzZXdlpxQVFBWS9iQWVmMlVQMncz?=
 =?utf-8?B?aENQWXRvaEwvWTRKVUtYaEhtdW81dy95amNTQ1VBNkdsY0JJRzIrendLLytm?=
 =?utf-8?B?Y0tMd3lUbmE5ZXkrSkV5Rituc2d0NDhWa01hVW5BMkJtMkpCRUNFL1FIdXhm?=
 =?utf-8?B?VlZGaTh3MnhiMGR0NnIzK09xRHUxb2ZnSlhrNjVsSllSeVV1dmFuNkxmM2tR?=
 =?utf-8?B?cDZzQkk1UzdIc2ZGRTN2VktPMVBTby9Jd0hkWlAvV240dGVKSGlLMzZ6WGpr?=
 =?utf-8?B?UE1qYkQvQXNaTU9NT045UnJJUWJNVEs2WWIwdmp4cU9pZG5Jalg1M2taWFZq?=
 =?utf-8?B?bW1ENlB1aXVhL2QwTktocG04MlJqNy92eGN3cFlTNkFsbDh4RUo4ZXBodTNE?=
 =?utf-8?B?bGtQcEpXeVpZTkRRWlZkL0w5VkF3R1YzYjcrZnVKd3Y4b0xXVkF1aEp0TUVz?=
 =?utf-8?B?Z2RZTjBRWDFTOG9Pak5EQnJSS3NJdkhmRUQ1MFlpU3lYYlIrMGRNZEtxRnM1?=
 =?utf-8?B?WmM1SXc1bk5pRGtqTzFWeTY0TUdUR2laS1BoTUVjYVpNL1A1T3NpVm9UbXFm?=
 =?utf-8?B?TkZaaXdsVHZycStIalE3NmJkanB1S1RMN3BEc0VLaVk5MGQ1S25FTmpBRDhI?=
 =?utf-8?B?bE15VENkZHNidjhZakhBL1FXU1g1L2pvUzgxcG9XVUsxeUxLMXVEVHVaOHdh?=
 =?utf-8?B?OStydVFOamNDOC84ZEpCQjhPSzhiVWkydW52UWUzKzRobldDUHVTbVRFVGg1?=
 =?utf-8?B?WjhBZWhvRGJzb2dKemMwWExjZm8vS3lndm8za0ZOQkhzem0rUUlCMFRRSVVj?=
 =?utf-8?B?ZHZETzBPQm84N2hHY3ljcVk4WmFHQlkzcmZyd2xneXhTVE5ITWs4MndLZDNT?=
 =?utf-8?B?eXFIWHJRdTN6dUE5dmdHV0g2VkRCRWkwdGlnVWxMWXllRTJhVVhkc1huZk1R?=
 =?utf-8?B?enNmZGtyQ3RNZzRDM2k4SzQ2QWF3WXdnU1BQSkZLSUJNS09WR2UyR0RKeUN1?=
 =?utf-8?B?eERESVBHUmt2N3lUNlhBcnJaK3JZSFV0T3plL3dIK2MyMXhiOWd2Uk9sR1Uz?=
 =?utf-8?B?cERiVXR2cTJxYTRtVFdUSmhSbFZTV3cyc2t4VHRHZ2xIbmliaTdKOHNnckFU?=
 =?utf-8?B?SXVTUElkdFFvNmdMbHVaaTFWOFM1Tjdmd1ptK3pJQVJ2QzdzQUUwcWRFR3J3?=
 =?utf-8?Q?jbu/PFfiLaiPCbd228uVJyMUh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 989b7fa7-cc8e-4c23-50f5-08dd5837e910
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 20:38:51.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRmXRg1+8X3nHDyHbPBcAhSXBcuB+57AGNx7tVS7rFsJ+NJTu5Z7ulIWLjJalMn98iCUlRlQnfWzYwU0Djl7Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5603

Hello Sean,

On 2/28/2025 12:31 PM, Sean Christopherson wrote:
> On Tue, Feb 25, 2025, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Move platform initialization of SEV/SNP from CCP driver probe time to
>> KVM module load time so that KVM can do SEV/SNP platform initialization
>> explicitly if it actually wants to use SEV/SNP functionality.
>>
>> Add support for KVM to explicitly call into the CCP driver at load time
>> to initialize SEV/SNP. If required, this behavior can be altered with KVM
>> module parameters to not do SEV/SNP platform initialization at module load
>> time. Additionally, a corresponding SEV/SNP platform shutdown is invoked
>> during KVM module unload time.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 74525651770a..0bc6c0486071 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2933,6 +2933,7 @@ void __init sev_set_cpu_caps(void)
>>  void __init sev_hardware_setup(void)
>>  {
>>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>> +	struct sev_platform_init_args init_args = {0};
>>  	bool sev_snp_supported = false;
>>  	bool sev_es_supported = false;
>>  	bool sev_supported = false;
>> @@ -3059,6 +3060,17 @@ void __init sev_hardware_setup(void)
>>  	sev_supported_vmsa_features = 0;
>>  	if (sev_es_debug_swap_enabled)
>>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>> +
>> +	if (!sev_enabled)
>> +		return;
>> +
>> +	/*
>> +	 * Always perform SEV initialization at setup time to avoid
>> +	 * complications when performing SEV initialization later
>> +	 * (such as suspending active guests, etc.).
> 
> This is misleading and wildly incomplete.  *SEV* doesn't have complications, *SNP*
> has complications.  And looking through sev_platform_init(), all of this code
> is buggy.
> 
> The sev_platform_init() return code is completely disconnected from SNP setup.
> It can return errors even if SNP setup succeeds, and can return success even if
> SNP setup fails.
> 
> I also think it makes sense to require SNP to be initialized during KVM setup.

There are a few important considerations here: 

This is true that we require SNP to be initialized during KVM setup 
and also as mentioned earlier we need SNP to be initialized (SNP_INIT_EX
should be done) for SEV INIT to succeed if SNP host support is enabled.

So we essentially have to do SNP_INIT(_EX) for launching SEV/SEV-ES VMs when
SNP host support is enabled. In other words, if SNP_INIT(_EX) is not issued or 
fails then SEV/SEV-ES VMs can't be launched once SNP host support (SYSCFG.SNPEn) 
is enabled as SEV INIT will fail in such a situation.

And the other consideration is that runtime setup of especially SEV-ES VMs will not
work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
KVM setup time.

This is because qemu has a check for SEV INIT to have been done (via SEV platform
status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 

So effectively, __sev_guest_init() does not get invoked in case of launching 
SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
sev_hardware_setup().

In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.

For this reason, we decided to do sev_platform_init() to do both SNP and SEV/SEV-ES
initialization (SEV INIT) as part of sev_hardware_setup() and then do an implicit
SEV shutdown prior to SNP_DOWNLOAD_FIRMWARE_EX command followed by (implicit) SEV INIT
after the DLFW_EX command to facilitate SEV firmware hotloading.

Thanks,
Ashish

> I don't see anything in __sev_snp_init_locked() that suggests SNP initialization
> can magically succeed at runtime if it failed at boot.  To keep things sane and
> simple, I think KVM should reject module load if SNP is requested, setup fails,
> and kvm-amd.ko is a module.  If kvm-amd.ko is built-in and SNP fails, just disable
> SNP support.  I.e. when possible, let userspace decide what to do, but don't bring
> down all of KVM just because SNP setup failed.
> 
> The attached patches are compile-tested (mostly), can you please test them and
> slot them in?
> 
>> +	 */
>> +	init_args.probe = true;
>> +	sev_platform_init(&init_args);
>>  }
>>  
>>  void sev_hardware_unsetup(void)
>> @@ -3074,6 +3086,9 @@ void sev_hardware_unsetup(void)
>>  
>>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
>> +
>> +	/* Do SEV and SNP Shutdown */
> 
> Meh, just omit this comment.  
> 
>> +	sev_platform_shutdown();
>>  }
>>  
>>  int sev_cpu_init(struct svm_cpu_data *sd)
>> -- 
>> 2.34.1
>>


