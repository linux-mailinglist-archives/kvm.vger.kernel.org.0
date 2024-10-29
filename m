Return-Path: <kvm+bounces-29937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D1A9B46BA
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 11:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74AF91F23F53
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 10:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B404E204947;
	Tue, 29 Oct 2024 10:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lvIMVgsj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6507204034;
	Tue, 29 Oct 2024 10:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730197482; cv=fail; b=K19Gr4pUaBFiHhRX5OeNC3ZP3uiDf68mqv05OHexcGqzHF/wniQrLqPw7jPmQs0l8qYWbUcpyQ+2njvadJmMF/9IzicCJRLLbKPYghdKFNy3HnAurdAvWGIcAoIcD/LdTd8Alps/l1I1NexNywvxN50syJehq5MdmNcIPkhb2i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730197482; c=relaxed/simple;
	bh=fdID30wx+yIHPZiI9eQ8K/hD/xeTArWulX918mNBYsM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nLlD73dnSL2fiXr1EeDJBKUribJzEnyIabS2PwmQ60tzwYF+63Z3QJo6eiYLZAm8CeTXoSevVqEVGW6IXa4q+uN9ZRyrM+3ljTCUWJop1Mfgr0+p6yGMHDQVtI6S+IBDmQBzh5AV165g1/csD0kD9fryTEKzvUVJWlWCCnxc4YE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lvIMVgsj; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kyVsuyWv7bTwgxM96313/YT988BmJCtzTf9t7MXkzjHXiMbr8+rD2nmI1h42c1t0vODfRbnRUepvr7hfAdmEBGNbn/QN6Q9cczRqzcK2pwmTCa4auv6pVKoOJGjm3Tv/PsqiBQQ/pVH4JXUcXNVV5DAnlkt7De9aWr5KPi7IFt4Yan3+GfyWc4MeqzThQBGce3BjZVRa0srqb0Ir6xQWrC2xtYmoiV9dtHJixrQhyI/CfIPh6YPceQxi0HZZFqd5FlNpIoYpWT5fJSy2c1EgjSavg4+MB03ueszxurxqPS/BLEDF5hkp+mZiXSanFQYS3bwqMj7PVjhx9nJ3lEDq1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ohUAzQJsrV2V8GALZhUldx/8R23r1KB0teHYeXlMHrY=;
 b=M6w3CkvS7FG+1ne7WyveR/F2WcTpUmaKMF/LQAEELikluBMSiMAWwUTQ70xUNg95Ttl6/IqjiFnNLqtv7NZKamp/vprhmuvmJp3tnrrxqNZpmmfEypYpWcSFVyKY6W/zyBPsssCqQcq0IWTaeCS5JxjlWAQndSkMK3EfU8psB+iAIUlcrWEhMD7PmAIgmU3KB2k9Ej+93ayt1Ndl0azAgN3osKc9O05OX/0+2KZ8mBnPEUDQN0fIyYhUZwNXBmY2waMJyIkLZHAF5JTpEDtIGaoUVOebvORbBcvYbidg+3DTWdYE7t3elRDaO1/XXXwECLxueMWX9SCxpMFkI0KnVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohUAzQJsrV2V8GALZhUldx/8R23r1KB0teHYeXlMHrY=;
 b=lvIMVgsj7zle4bSLBGCfdElgLGbo6HshVASnr/VqXUUgj7BxJvj6HaBREclTlm9MJNjcG29VqR9t5WFJiLyIlyNpchKdJI7+iBw6GyD9Y4mpyWRMsspXe/p2T7GzvSgwyzCZ56oDbmdu7xwx6ZTkmWKgx+D/R++oHjsGQOtMhtA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SA0PR12MB7076.namprd12.prod.outlook.com (2603:10b6:806:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 10:24:36 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8093.018; Tue, 29 Oct 2024
 10:24:36 +0000
Message-ID: <708594f6-78d3-4877-9a1e-b37c55ad0d39@amd.com>
Date: Tue, 29 Oct 2024 15:54:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
To: Borislav Petkov <bp@alien8.de>, "Kirill A. Shutemov"
 <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
 <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
 <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>
 <20241029094711.GAZyCvH-ZMHskXAwuv@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241029094711.GAZyCvH-ZMHskXAwuv@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0223.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::16) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SA0PR12MB7076:EE_
X-MS-Office365-Filtering-Correlation-Id: 33142e62-f117-4a1e-860f-08dcf803e373
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0NnLzZzaCtOVnJzV2poKzE4amxMV0pxNHdZdUEyNFc0QmRpK3JWUmovYldo?=
 =?utf-8?B?VEZLdk5aMFlSdW9sRHlTUzJYL0RpMzUrWDE5Ym1OQzZjZWQvcTk4UlFteGJJ?=
 =?utf-8?B?a3V3SGU2NnpoYlJuVTh2aEVQSFUzVWhoRmtHaGdPSENvZmovUDBYdnljaENU?=
 =?utf-8?B?VFB1YnZLRVVaTzNDbGM3RGp1V25ZT3RaZXdYRGlpSHplZ0VpYmFUbHhqb3Ay?=
 =?utf-8?B?dDBtMTd6Tnp3RFAwR3M5dzRWcUhMMnEwcTVqRk5vNWR1Zk1zdEFwL0JLUUdK?=
 =?utf-8?B?b09ld2lVa2xGSE82OFMyYU5BdzhnaG5mcy9abS9rc0hVUW9qZHplT3VOVlh4?=
 =?utf-8?B?aTcvZ3B2K1ovV0hSYS9nV0E1cEllSTcxaFRndStyYkVJL0JLMGUxbXQ0djFJ?=
 =?utf-8?B?RkREaDlWaWE3ZDQ0cEo1L2NEL2VwWUtWRHRjSjc1YVYvNmZmZFBKdVc2NTlK?=
 =?utf-8?B?WUdMeUgwMDE1WVVKdS9iQzhSYk5IcGY2dXJPQzFib0JOZVlsMFVWRlI5SlFE?=
 =?utf-8?B?RUlqbzUvWGhzUmkzNkt1VnE5VEtqUVJxcWIyaDZIVUVBMFUzSVhnTXp2SzY5?=
 =?utf-8?B?NnYrVjIwMTB3YUVCSksxc0NiTW9nM1loUWtUVEFNREdzUkx0aTl4YWF2M2Vw?=
 =?utf-8?B?VlV4Q09NYWFkT0R0SkNIRG9tTUY3VkRDV2xUZTQ4aThyMDF1dVdXVmYzOGt1?=
 =?utf-8?B?M1RRQWlsWUVxd1dZZVpXaThKZWNlT3J1R0pPYWRJSGpaZUZnL2ZHZE9yZ3Bl?=
 =?utf-8?B?b0RRZnNuSDBNcytKZzJSV2ttaVBCSDhmdHh3Y1RCK0Q4bGRyalNMSnhpSVBn?=
 =?utf-8?B?YWdjR2t1aW1BdlZ3MlhMSU1PTXhWSzlEUzBFS3R3Smxxc2Yzd0M0RVd1d1VE?=
 =?utf-8?B?R28wanVpcjFvb3RkV1hObFF2dHZ5YWhYUVNXTnRXZEoxeHVaR25ZK1k0cy8v?=
 =?utf-8?B?dnF0bG0vd3k3UDQwazlyOWpJVnNzTXNKWG9pZmY4by9jeDhNazRNZWoxdy9K?=
 =?utf-8?B?czhMemY0YmpEaDZuUmpod1JrbEVDUlpxTDZZaWVCRytLV0pFZnhheGxZMmt5?=
 =?utf-8?B?YlJvd1RsZm9IeG5LZTBJNnJyUWp6TWJkd2xkNnpSaG40NjFkSnIxemNmQU9o?=
 =?utf-8?B?RXRHY21pVDNTT2ppYjQ3SytKNTFZb2M2OEhjdlN2WlVna1NzejNXbnhrUmtK?=
 =?utf-8?B?OFBBT2xUZXdTVFR2NGg5b2ZZQ3E1c092QzVtSzhHaXgyS080bWk1M2RWQ3Zh?=
 =?utf-8?B?NmdZWG1PSnc3dzdnQTU1T1d2cnR2enUyYVdmYVZBdEg1aEpGRFJIMThwMWFO?=
 =?utf-8?B?RmhBdGREUy94MS9GLzVYcmt2MEJoYjRQNkpqY0lSTnRZeFNCRmI2dmJRdVlQ?=
 =?utf-8?B?d00vQVBudEtNYnB5ZmRMakJKZTNaMS9CejBJOWlVUCt5cDBUZmNwMWVZbDlI?=
 =?utf-8?B?MExvU3F3dDhxK1BYaTdGSUtFTHRTMkQ5aHo0Qkd2dnZGdWt0akpKSmV0Nlo2?=
 =?utf-8?B?WVdGemlOTGZxazZ2TE85Zkc3MFhaeWttcnFZVGFKTGg2VnlENW5SNTZvVGJl?=
 =?utf-8?B?YlY4ZytkalcrOUQ5K2ZUbG9VWUZtaTVFOUdVbzRIUGMzTDB0R0J0U1ZRcVFW?=
 =?utf-8?B?d2d1RUREUUd1NVFFMHZRRGNLTTA0R2lKMGc5L1JaUFAzZURBbllxcVp3dDZs?=
 =?utf-8?B?T2Zpb2dZaVJZVzJET1duRXg2TjVuQ0ovU3NqTkdXZ0QyMjBTUU1LM2pwR2l2?=
 =?utf-8?Q?RdgdrLy7Q7yUT339kjnA14SankJZJYqBw6Dc1TX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2VOamV6bjA0eDJiZnlzTE5yVS9sUXl1NXB5NjJRSnZsbk5XT1Jsek1Ydnpt?=
 =?utf-8?B?QWFqL3RmUUdTL2RjcW55M0N4MlcwNklMb3pWRldMQnNVYXJVOUZaRHU3VkNV?=
 =?utf-8?B?clR4dzFpMVZPbWliblhKa3ZiK1M0UDBXemFIZkx4dWtOdG5rc0hPcGlrS0tX?=
 =?utf-8?B?ZmRwVitldm5vRU1VTWJBM0ZEdy9oM0xuQ0x0ckhWVmF0d2NQYllTNWZrMnpK?=
 =?utf-8?B?WUxIY04zbWExSmEwUGNYUHkxMnArbW93aWIyUko2T3RaZG9SN01SM1lubjRu?=
 =?utf-8?B?T2h0ampGUXE4aVJkTTJxSmMwTFlUcWJDampTK3Z2RnhQeCtPcCt2VXVwak00?=
 =?utf-8?B?ZHRBc2YyL1prejkrMzM4YTh5em5DUTFxL3RaZkg5emE3NDh5SUYwb2c1RFFD?=
 =?utf-8?B?N0NadVIwZE9RRkZDSzJ0WC9iNFNCdVl4N1E3VFdvRG80Wld6TjRHbDB1d1RG?=
 =?utf-8?B?dE95TzFpNTJyd0cxaWtXL3FQd21aaHhnM29qVFBoSHJaNTdKdUdwQUtCU1dR?=
 =?utf-8?B?WHkzMVVNQ1VCaWNsVm5Fa2tUMkhlemFRb1ZaMy9CSjA1Y1d3cnUxOGE2R1U4?=
 =?utf-8?B?VlFjMytPcy92QmY2YjgyZVpoeE43a1FKd1FveW84cEVES0UyRy8zN1BvVjZ4?=
 =?utf-8?B?cTV1aXI2TjZsbEdqYW5CT05qOFNsdlNXZ1hRb0NyRGZmZ3gwKzlHM3VtRnda?=
 =?utf-8?B?bHJ3bnV6STliQkUxbmZ2eXNDaEorTDVLYUtzb3Bmb3QvZnhIQnJDN3NVTytk?=
 =?utf-8?B?Wjk3UlBLMjk1UW5Yam94MFdvUitXZVVkT3FFM1l3V3g1RktXOUFJcmt1R0xC?=
 =?utf-8?B?Uzd3NnBOWUVWSlVscnRZazNMRnVuajNnODh1MVhjeHNHTkpxdlpiUXJ3STNj?=
 =?utf-8?B?cE00SFVNOEwyc1U0a3ovaks1SWJlcXpra1RrSW0rVmRLNmd3aTV4d0RGc0JW?=
 =?utf-8?B?TjdmOEJVOHpRVm1aMHZrN3QrM0JLTDJ4T3ZpYVI5N3l5WTE3eUpoZjVLUXgr?=
 =?utf-8?B?RXVxdzFiYysybzY3ckQ1dGxpckowbmYrSnI4eTdyUVdBcHRYNmlCWWtsTVdP?=
 =?utf-8?B?QkI4dDdXZkk3ZEQ1WmpYUHpEdXN1a2oxdVBBSGxJWi9Uc0k3M2pHRXFvV1p0?=
 =?utf-8?B?YXl5Y3R4MDdXZm9KelMvZndCQWxDa0FIWFVXdE80TTFNNmNsbVlwa3lCVmQw?=
 =?utf-8?B?SW9uRXpwSll3NDg5WXRpMS9aVEpJbTNSUkVuVk9EN0NmMU9taUJPU1FEOW5Q?=
 =?utf-8?B?YUxxTDY0MjNKQXAwY2lHQjVleE4wQU5Oc3A4UDVuZkhUaFp1eHVpMTNOUEJi?=
 =?utf-8?B?QnYrUGlFYVpiYk9BSGlWVU45OXlNekxwOElMdnpyek1zaTdpOTZMbUYrK0tN?=
 =?utf-8?B?Yi8rTW1MTUZObUVYV2dpV003L2JiUGd2S2JQV3VLWGdRcnpsNkZPeE5CcUgv?=
 =?utf-8?B?blZmT1VZdXYwOTVzbWN4NXpmS2k0aVkvNDVDQVphV1UzV0VlczZ6OVRwY2pQ?=
 =?utf-8?B?U0tMNCtFc3Q2NUZZWkdwOWtjME5mLzJjanNpeG5WTnF2dytZbkxsS3JpNVpq?=
 =?utf-8?B?Nkk4UDVGZ0FOeVdzOUJWWGJjRTZqWlJic2tlUzNadXVkcEJPMXgzb1pENWw4?=
 =?utf-8?B?b2hSS0ZqT3RGazRRVnhKUU9JS2tiWlkrU2N0RGtvWCtqWjgwM0xVZVRYaVhO?=
 =?utf-8?B?dVVFRkEwNm9CS0doWUU1OFQzMmkrWTU5VGpBZzRRYzdYOTl5UThHLzJyZitt?=
 =?utf-8?B?SEQvdmJXbkJEbTN2eWtLN3F0cjJucjk4M1AzMHV5RmZQdnpRWjVTMm0yK2th?=
 =?utf-8?B?L0phc1lub0p5STdiMGNwZlFud2lLcG9wd1h6RGZLVmRvQktSUW9ndHBHZXJz?=
 =?utf-8?B?SmR6eXVaQnN6WU5CdVZtOU0xZTMxUFhrOEtXSDZDTzBrNEVBc3ZxWjhXaVE1?=
 =?utf-8?B?WGJQcHliMkFXUk93L0U3RG9SK050dWFEOUVVc1BkM3pRZStxYjFXNXFHWTdT?=
 =?utf-8?B?Y0c5WTRmZEVRN3JXSUFwNEJZQ2dyZGZEdFBhK3R0OURQQTh3MmNwbXBrRmpB?=
 =?utf-8?B?U2Z6NXE4cU51eGZVK1MxN2htQTRKbVBVYlljNWJPR21HaUU0VDlrMDhTeFNo?=
 =?utf-8?Q?hB7ywIHjEnCUraVZv1eaqtL2B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33142e62-f117-4a1e-860f-08dcf803e373
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 10:24:36.7633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jnYNgF+RXmZSJ5YUVIE+Pds1bAqKemWLuSYfjY2UMNx2R55HgSoyl7nEuOMvRBVx4hXGvNlY17vG74gC4Cuhdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7076



On 10/29/2024 3:17 PM, Borislav Petkov wrote:
> On Fri, Oct 18, 2024 at 10:54:21AM +0300, Kirill A. Shutemov wrote:
>> I think it has to be addressed before it got merged. Or we will get a
>> regression.
> 
> ... or temporarily disable kexec when SAVIC is present.
> 

Thanks! I plan to do something like below patch for the next version.
Verified Secure AVIC guest kexec with this.



- Neeraj

-----------------------------------------------------------------------

From 80a4901644fa8a9ed2c6f690fbba4b8a6176b215 Mon Sep 17 00:00:00 2001
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Date: Tue, 29 Oct 2024 15:38:21 +0530
Subject: [RFC 15/14] x86/apic: Add kexec support for Secure AVIC

Add a ->teardown callback to disable Secure AVIC before
rebooting into the new kernel. This ensures that the new
kernel does not access the old APIC backing page which was
allocated by the previous kernel. This can happen if there
are any APIC accesses done during guest boot before Secure
AVIC driver probe is done by the new kernel (as Secure AVIC
remained enabled in control msr).

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---

This is dependent on SNP guest supports patches [1]


[1] https://lore.kernel.org/lkml/cover.1722520012.git.ashish.kalra@amd.com/

 arch/x86/include/asm/apic.h         | 1 +
 arch/x86/kernel/apic/apic.c         | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 7 +++++++
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 2d5400372470..ec332afd0277 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -303,6 +303,7 @@ struct apic {
        /* Probe, setup and smpboot functions */
        int     (*probe)(void);
        void    (*setup)(void);
+       void    (*teardown)(void);
        int     (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);

        void    (*init_apic_ldr)(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index aeda74bf15e6..08156ac4ec6c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1163,6 +1163,9 @@ void disable_local_APIC(void)
        if (!apic_accessible())
                return;

+       if (apic->teardown)
+               apic->teardown();
+
        apic_soft_disable();

 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index a3f0ddc6b5b6..bb7a28f9646a 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -391,6 +391,12 @@ static void init_backing_page(void *backing_page)
        set_reg(backing_page, APIC_ID, apic_id);
 }

+static void x2apic_savic_teardown(void)
+{
+       /* Disable Secure AVIC */
+       native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, 0, 0);
+}
+
 static void x2apic_savic_setup(void)
 {
        void *backing_page;
@@ -447,6 +453,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
        .probe                          = x2apic_savic_probe,
        .acpi_madt_oem_check            = x2apic_savic_acpi_madt_oem_check,
        .setup                          = x2apic_savic_setup,
+       .teardown                       = x2apic_savic_teardown,

        .dest_mode_logical              = false,

--


