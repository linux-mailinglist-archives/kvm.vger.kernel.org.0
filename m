Return-Path: <kvm+bounces-24684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CAB5959427
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 07:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87CF5B228EE
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 05:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E89A16D9A7;
	Wed, 21 Aug 2024 05:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4iKRilWk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECDA16B39E;
	Wed, 21 Aug 2024 05:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724218619; cv=fail; b=APjy7XIa9Q9YMIGTmnGfTbIRKL8fNiglKAY1o2t+EFuVkBgrakI7lLiQ6fYY+9JNMvcWBOtSK0FOU1AEOJo2rxQ7YL/6rJz2VcWE47CH3Qgbf0ttcs/+vno9m8/Pjy+ai/Pf5WhGS77kdPHRg9B62GrgvLD297NZEndbXal5iIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724218619; c=relaxed/simple;
	bh=CLCOHLzqo7dhP8qpFq3XpFCb7L6MrqGFey01Wk+zmWY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xub0JMAZ+553MoOdQFWAFw3tDXbi8KyktNWVeKW2rORKbQOQH2X6v0bokflbFxRB/AbjZhc25Nw07x+lq8HU008phgIwgUUNz3feE/Eb8AKokxtaiHcceGWj8L3ySD6fGrCpae0xe/0wuqD2dE/Ovi3QN/K5aUhDOa+XZXb9u28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4iKRilWk; arc=fail smtp.client-ip=40.107.223.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZY3/JiIYqRAFPdPiV+xTXNJD67M1ooUWbKLzf9Bf91i5frvsYDx68VeJHKeQS4HbcyxoesZ4lJxfjYEespoFqj+M+qbUMHEjE64/v9MlorgqRtzFRZWjRhrj6kk9avhmKf0JvyZ+9db1luNpQFI8/lDnlxIIDoMRZmVODOXIQIqhPo7kyXik3OVpRL3IgSeX8y/DaUuKKIZgeFfPdWipT2y6C6dSz3jLNDI3HjCHQtLRv7wwLQwW6/Q5Aj9g9ZGlJjavFtNVGal7jBnnlOp1DfrYtbJtouFb7t4ry3GSBsWI3TyXOBgmG0YDq/qprxyBamdPCvIgp6737vr2tUV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3C0Xryq1ylhJ7/NbNF4VUkS1jd2owcDjLI5qFqEo63g=;
 b=XnD/62hwLWoXQOrh8IhyEMr4n3T/ND8f1RHS1EIRKuQ2LjNTuzhVatwrvKELU+lbH9CgXrPH9S++HLCaaVdqKwFt5Zj2Fz1YBceYHIeA6gu3RhraAXtvaTZDtMZWxsiJmwMawp4ZBTrHz10Fd8DoJjgEZQsYwhWpiTAOJlPjRnOgcKpHVfOBhWXIYTBL7Nqy823aGsxN9qsBJopEOPND8oLnnfDcMImvS15+bugs44y3aoFHgECcfPXA2yG5el6xPpNY6zR8+WPS2JnsF1crMjsEH7aPDeHEhFVgU+dGNpHQv5wOqylPrrHQctdChJXPQh1LC+Bw8GVNnru21lZhvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3C0Xryq1ylhJ7/NbNF4VUkS1jd2owcDjLI5qFqEo63g=;
 b=4iKRilWkml4nxYHwBVKY9oUAriv/ogo17KXQSrqoA7ZcyfPEiDIqrrcycIadpddsSMIPpcPh+I++XHsPaBM98vhvgalJabHgehbUZxMMmCS6NtqzAGM6yw9juoxqgkpGqKKEYA0ONw3z9SVDKuik6VfuLlT/A0OCtrV8lgn8ibM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Wed, 21 Aug
 2024 05:36:55 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 05:36:54 +0000
Message-ID: <372d5a95-bce5-4c5c-8c74-6b4cc5ab6943@amd.com>
Date: Wed, 21 Aug 2024 11:06:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 jmattson@google.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk,
 peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com,
 arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn,
 nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 ananth.narayan@amd.com, sandipan.das@amd.com, manali.shukla@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
 <20240808062937.1149-5-ravi.bangoria@amd.com> <Zr_rIrJpWmuipInQ@google.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <Zr_rIrJpWmuipInQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0037.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::17) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|CY8PR12MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: 984f84e0-dbed-408d-afb7-08dcc1a3440e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUdSSXhXSzIxV1dpN0NwR252S2t0dU9QSGVsMDRSYk5vOHlqNmdFeXQwTFNJ?=
 =?utf-8?B?dUU2MHhaeEpMTHZKMkErV0hLcURSZFRjOTZCWE5tUnBxQTlYTVc5U1hJZmZv?=
 =?utf-8?B?Y1FYTVR0VTVQdndrM2RtYjhPdXk1UWtaVDh2KytvNThvTzE5aVl5aEhBMlJt?=
 =?utf-8?B?SEpZaGcxaG9rNEdIY0RESEFsaDRaMk81M1lYdW5IVzFsbmhweWQ1NzltZVJU?=
 =?utf-8?B?QlRRdm5naDBVNGhZMk5JWHJtY3A4bmlLOUI0VWRKZnNoZi80a1A4alpUN0sx?=
 =?utf-8?B?VHdGelpZQnZUbStPdnRlcEtzdDk1TmlzdXJsbVY5RlBMUmhXR0d1U2JGd2h6?=
 =?utf-8?B?QWw2OGppUHRMelVVeGZqVWZ4WGlmZzdvYkxzL21ORTc1WGNZd25lTUQ0ZVN1?=
 =?utf-8?B?bW05S3BLNmJZc3FybVQ1MkJLNis4ckdNMnBzRVh4WkV3TmZnbmE5TkNRUDJL?=
 =?utf-8?B?QWJJZmJLM3lLZEVoK1VnK2JTdllFMjIyTm1iSnFrNDBiWjZkSmhOYURNQk1o?=
 =?utf-8?B?VHpLSjJMai94M2ZvYjZMck1UcWpnWjh0aDRjU0Z2a0pNMVY1cSs2YVEwdFd4?=
 =?utf-8?B?ams2a25iS1Y1M0NnSnBpbERRamR1V0dRYm5GY1pXME03Q01Fem5QQ2NkbGh0?=
 =?utf-8?B?VHNkVHY4N2VudGVKT21WNEJON3NlYWNKRlhFT25BdWJBbW50OU5sWlBhRWs0?=
 =?utf-8?B?VFVSSWYyM3hCYnI5K3pPTHFKMUlzVFI2YmZxWGRHajI1RTV0WWo0Z05waEdC?=
 =?utf-8?B?M1cvZjlla3dQNWwrQ2xjeWxTWmxXMVhwbWRrSTFGK3duRHpac3RhK0t6U0FK?=
 =?utf-8?B?NmFuRGt3K3VLWlV1MGNFSUQ1ZXdrRlBUSDV0R1pCc1ZuemIxTDB3V0V4TDd4?=
 =?utf-8?B?ckYrOTR3WHRDdWNEY0tYNlo2d0xZVVF0ejFxa1dieHBXbVZIYVdiYnVBT2pv?=
 =?utf-8?B?TUVISGZOQytJK0NJMTFhZ1RIeDZiUTloaHk2L3BoczF2MFlTOTdsS2c4Qmpv?=
 =?utf-8?B?d0RLTC91UC85QXM0Y0t6aFkxZ0MxRHpFRldGMlM1R0pEU2FTZkVPQ25GNEIw?=
 =?utf-8?B?cFFuYXoyTDNBQlR0TXduL0tkL2M2aGxqc3ExWHBGZk9YWklYM3N2YUViNWk0?=
 =?utf-8?B?WkN0RzBuV0RicXBBWE5UeEFSdkJtMnBEMlNWK0JXNjBaeE11YUg0YVdIN0JT?=
 =?utf-8?B?NTZ0UDNycW5zSlpNT3krcThGUk5OZXNpWG1TMFZRQ1IrZ25ENndwanI2S1hn?=
 =?utf-8?B?dkxDWGxRcHEzYzlsRkpNbDY2OVBxTC8vQkVUN0N6RTZBYks1eTRTVHQ3eFRS?=
 =?utf-8?B?OUdrK2dubmdHN1RWcmJKSzlJRGZ0M01peURJb2V0VTFKL2tZTlFpYVU4aWt3?=
 =?utf-8?B?Ukg0RnI5Rmpwb1VxdVpkSzkvSE1CUm5qT2dWMU1nYXhVRXBVYmVDVmtNUGxx?=
 =?utf-8?B?Z1d3QlVIVHVDMUxhZE9UM2N4UjRSd3pSTGRkOEQxNmdBaXNPcWgxbzM3M2pJ?=
 =?utf-8?B?RnVhdUg0OWNnVkdaZGR3WDhjV0M4MGJ3bkJKamI5RFFoc3VkWEtjRERFNm5u?=
 =?utf-8?B?TkNNSDVUN0Y0UjJJemZCb001bXp5OUFjbDJKczZTekx4ck9OTHEzYVNSUmZ0?=
 =?utf-8?B?c3VZVVN4eWllYVNGeWRqbVZlQlpXUlEveGNlMExJQk5HdzFrcE5YM3JOSzhI?=
 =?utf-8?B?ZW5PYXFuOGY0bDFDN3hLYUpDZ0tMUmYrZnpYeHN4bkIwWUVZcmVxRGpicEI2?=
 =?utf-8?Q?r/ivD9ib75WfuVHHjI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUlqQllGU1ZTWEYwZHhLZENFMXZ4WUVGa3JwUStyU05BaUFpSlBxZUtNSW9v?=
 =?utf-8?B?MitQNFJ5UTlJQ0VONVJsaEQyV0lvM3puTlBuSXptY3AzQ0dwTkRpRXVkWXVr?=
 =?utf-8?B?SzZ5OG15NWZhdEJRelBQc2NJZ0d1SXMxazRScSszUXdDWlZQNmdnVXM2MnZB?=
 =?utf-8?B?YlVJaEsvNmV0Sno1Z3RvWEZEU1pSbGZuUTA0NElNOWVKejk0ZndpbnQ3ZFJr?=
 =?utf-8?B?bVlYOGZIeXNnemJtMFUzZW9tVlllSFdZUW91Nmc1RUNLQkJFQWtwV1paZTJw?=
 =?utf-8?B?L2p6YUllMllucGRKQjFtVXRsMVZsaDN1WWpmVEZjcWRvajFvSUsxcG5MMnM2?=
 =?utf-8?B?UmJmZ3N1SlNSeXF6d3RqWk5aQmw5VktmbG1hZldRNkNma0RwY2NVYlFldXhN?=
 =?utf-8?B?SjNiQW51dUp5Y1NaQUs5YW1UWFFsdjNGSFBhckRpbnZUVFplMnNjdC9SWmx6?=
 =?utf-8?B?dWlyaUZIL0swNGRDZnAwRTNnM0V5eHppZEZXN0JPMHhyM0U4MkRFWkJSd0xI?=
 =?utf-8?B?aitFNjZDU1RzK0tSdW96SW53MXdmb3NlaXduREl3T3E4eVdMREdQamIxNFJI?=
 =?utf-8?B?M1NseHVEZEk0TCtzSjVYbnhsallrcGJrQThScWdHZVRnVUhhdGRLWWc1ckMv?=
 =?utf-8?B?ZGNIOHkyN3N3TWNENEgxR3JnMUI0T09XYk8xOXpUd21CcVhTbE9KTkJlRFJS?=
 =?utf-8?B?U3J6QmNobTJnWlVYQWU1MFY1RE9qYkpOVC9WZHE4VDRRcnlYY0NsZ3RudjVE?=
 =?utf-8?B?cGcwT0cyZ3BLRmlDTVVFamhKNE9PWmtpOWRWUXJwMW53Y2xmeVpWSDJML3RR?=
 =?utf-8?B?NkloaEROenNIZE1lbkEraVo5VDhzb0YzU3RSRnlYcXFHRWlWR2xYOFNRUHlo?=
 =?utf-8?B?MEwvNVFBcTR1MGM5TlR5azRydk1VY0pvdHltS1pzTmtwTXJsbXhhT2hkSHNS?=
 =?utf-8?B?NDh6WHpEQjV3T2xOU0ljY2hTbWtSMWJxa0xYdHNVNitpcUpWeFFCazFHQUFE?=
 =?utf-8?B?K0VNem11b3JZcVJ6dmU1ekRnZGoxdTdhL3BlSEwxWk9hOE1HYmN2OHNNTk9a?=
 =?utf-8?B?Nmo3b05zWmRDaFIxOEhFMHJqaTNHRCtYbHVmaVExYlNZaTI1cnF3c3gwbzc2?=
 =?utf-8?B?L0R4c3d4Wmp0dVhMOGFnYkxraWFCdnZDbWZMbEZFZlJWWDVWaWdEL3Vnb1Nv?=
 =?utf-8?B?cERQZi9EV29Cc21qbzNqVEh6U0xLK1NxK2JxVC9IaExjRndMcHkvZzRaWUFB?=
 =?utf-8?B?cHduUEZjOUxrM3lWNHJ1d1dHVVBKUVVROUdMS2hTTDEveURLTjdkOEJUdGl3?=
 =?utf-8?B?VVU4OEF2anNLaEFvTzhDeE1iQ2J5NDF2U3RDVXF4ZmcvSTd3V2c4eUpvVjlH?=
 =?utf-8?B?dTBOL1hMUW5IaDI5d3lWdmVjV092MHhhNWlReFd5V0dJRm16MGYzZUE0QWdn?=
 =?utf-8?B?SlU5RzhaUW96eW12S2FCK2lMV3dZVmtNck9IYVg5T2JMbWE3ODlZNzZ4NSsv?=
 =?utf-8?B?dXRPbHA1RktGQWdOYnhic1V4VFFxQnMxV21YZ0ROc0ZJOVk5RitpOFlqTWIx?=
 =?utf-8?B?VUJpQWFnSmZ6bWhSZ3o1czkzK3ZWUkV5V1dtTTBDd0hEVFpaeGdwS3NGbHZW?=
 =?utf-8?B?TW9uMmh0K1YyNDIzNHZ3YVZVTEFvNlRyQXQyT0NMaXo3MHAwT3ZnMzhVM3hQ?=
 =?utf-8?B?R2NpMVV2QmxIVHpJZXlsOXd5T1liSjlnOTBBbGlEV2M1MTdJN3p6M04yMHJX?=
 =?utf-8?B?QjNrV3FwalVjNy9ZeE5wVFRZcTAzaGZRMkVyaStGV05sZW1JdnY5RVZFT00x?=
 =?utf-8?B?SHRhdEtqbWYySWNnbVRUOTZFNS9ZT0dEMWk4eERxOFR5YTlHOFJGWURMZGZ0?=
 =?utf-8?B?QlV5UCtOcnBya01FemZSQjRicDVBa3I3anp2R0RiY0ZEOFE1NmVTWHhuZlpR?=
 =?utf-8?B?bU53Nm81cXNGandlV0V5N1FpT1FELzgvQ1RUQk13OHR6N2lNRTR5SkdFRndi?=
 =?utf-8?B?RE55ZXlsa3dzMk1MNFA2b2IrdU5jZHpURU5lbVVNVmR0MnJ0eStIbWpwYzBE?=
 =?utf-8?B?eXJhUzdZY1hvWFNiMnFBeGhTZW5IVnRLcG9HWmU2d1E0OTdYOHdBdjhzY0hq?=
 =?utf-8?Q?a/uX5jqG1Du9PEAxMJwfDc5o4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 984f84e0-dbed-408d-afb7-08dcc1a3440e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 05:36:54.9119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgQ9bD54TrIPsKcrP4y1MfsTwYce6vr4O3/P2sBTERf+4P/58KYH2+d9W1hVAWBxNFBgVzw17RZ6Du4cv/CrjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8300

>> @@ -3158,6 +3159,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>  		if (data & DEBUGCTL_RESERVED_BITS)
> 
> Not your code, but why does DEBUGCTL_RESERVED_BITS = ~0x3f!?!?  That means the
> introduction of the below check, which is architecturally correct, has the
> potential to break guests.  *sigh*
> 
> I doubt it will cause a problem, but it's something to look out for.
This dates back to 2008: https://git.kernel.org/torvalds/c/24e09cbf480a7

The legacy definition[1] of DEBUGCTL MSR is:

  5:2   PB: performance monitor pin control. Read-write. Reset: 0h.
        This field does not control any hardware.
  1     BTF. Read-write. Reset: 0. 1=Enable branch single step.
  0     LBR. Read-write. Reset: 0. 1=Enable last branch record.

[1]: https://bugzilla.kernel.org/attachment.cgi?id=287389

Thanks,
Ravi

