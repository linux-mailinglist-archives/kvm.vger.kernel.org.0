Return-Path: <kvm+bounces-43565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D124A91BB4
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B564619E0BA5
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9102417F2;
	Thu, 17 Apr 2025 12:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M1yovo+t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA321E1E1D;
	Thu, 17 Apr 2025 12:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744891994; cv=fail; b=PZkGe+UFgYFQkSIwze3MUe+5ZnSG0c/WqGQGPbOaMyjpz1A4C0KxsLqe8JIkCQ3+X8YA0RH5HSEWWMBlCzE4ADavwIxJdhTxwWW2zrZeMpvL8yLp9c2KuEH7/kZHhu4HsIWIwkNkGfNd8lGbtQNntFNP5yp6jffz2qk3mAs7Lfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744891994; c=relaxed/simple;
	bh=lQHq6c7ih5iYz60H6rat5TzoCtt7mB8Gs3zhZNSwA/Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LFJ9VVfqdvFZn/cTO0WeK4rov9ZeH44mci/0WptARm534L+wS4x9XF6tD+7bPiAD+rsw4sL8agPygmvmj0zx/srNQg5iiTLItDMnpNEhE4RmZcP/6HD1S71VsocV32Mo/wCFo4K4sVcUjI18YuFxmDZQmKv4LxHXjlVb6utlzvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M1yovo+t; arc=fail smtp.client-ip=40.107.95.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7ZA0Gyts5kICZyy19l9W9zAN3puaUnLhEj8o/DZ/W9RvF2RFYmRgtXzVnefarALWHnpWTTXaZ6ZEScyRMWryFc8BTTk2msKl0n8nGZV0XRRgrrGbZ/zb2D1y8ES6dqVt3+77DRnPWHARe+RI+Wn0EGRelle5S85VeVkek5jVgQ6lAR/RdWAjvIeLejlboal0eVIr3SMhA0YN3QG+u96WiOgKQeverYHrvHwyO5ttGL8zXx2tPZe5OHOngd0GIZC0VbgffTIlpvybRYax35QAMQw4kWXyXekqjM+rFo/JvN2umaI77GRTTCLxiogjvWd/+fHbhJxk9RoEU6VN2Z95A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FUgxtZWRfsOgvZPCIqa0OUDcf0CeZqsaSEz2WzO/g8=;
 b=u7cE6ia6qSxMQmXnuIdvzI2pfIANYN8YVjaqcDrHLZThjRX1XkiHPn1Waygt6CWmNz+1+9KPOSKom4zulJITSQEauFVx7HW+i9xasqzG7zagmCNYi4ZZZVvFpneN/CLX1KQmG9Wi2SsI3BgzHCGzWxQX1ZvXXtYqsuUG7jKjeKMd6qcVKlgwwZulHKcm53lJqI5heGqx7HhnutDBmHoDbMbcGJ51jIKIbHXzcd6Ym1ADrL4XhNP/qUAUAcckqzQml07vLpfxy4CjfwqCoDRKPO1d+WRJBhHTEdZcysDJl01eWthGesTWyZMTCi0SOWDta+lzpr+PVgY7J9CT8oj2Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FUgxtZWRfsOgvZPCIqa0OUDcf0CeZqsaSEz2WzO/g8=;
 b=M1yovo+td72ihBwyhmnDPUoigDevyWlTsyYJEeHPwc4paCQRz90UIss3n2DGi+OlA9lOIjTLkhrVKwbFk0S4dGUzixP452MgqZjibCE4+RJwDjoxxNGYhM5DrEb30SEQWxZepZGh5+lBLT55OICmAYhC2vApgZzvqKpWljNTHX8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DM6PR12MB4419.namprd12.prod.outlook.com (2603:10b6:5:2aa::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.35; Thu, 17 Apr 2025 12:13:10 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%6]) with mapi id 15.20.8655.024; Thu, 17 Apr 2025
 12:13:09 +0000
Message-ID: <f93d3f20-6070-4ffd-bfbb-cd813bb03479@amd.com>
Date: Thu, 17 Apr 2025 17:42:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/18] x86/apic: Add update_vector callback for Secure
 AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
 <20250417091708.215826-7-Neeraj.Upadhyay@amd.com> <877c3jrrfc.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <877c3jrrfc.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::28) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DM6PR12MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: 46842966-fe8c-44d6-9de8-08dd7da9378e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1ZFbHRNTUFDOC8xOFNWN2xmSGhjM0JWMEc2WExnT3BJQ1FGZUNyRFdraGRs?=
 =?utf-8?B?MHQ2VVFUcVl2c3I4eGV4OGhxSy9Uekhod0V1NmxXTzVUbXV0R293KzVpdEV5?=
 =?utf-8?B?czVsL3VNNTZYVkhkTVVzWERBR1Q3eUVWdndJUG5iUzUzVDdvRmZaY3pFYWxn?=
 =?utf-8?B?Y2J0b0Q4R3JxcHNPd0hEQ0RlSVdTekFwb2JCZzlGR2szbzRPMW1EZVVQZFlQ?=
 =?utf-8?B?cmx1c2hGcVNEUUZmK2xrZ3huUmJxRTJRWGZEQkJjT1A5azkyZkpLOFRjVzRo?=
 =?utf-8?B?UmZiL1poV0JKNyt3MTQweWZHWlFsV2xjWWg1YkxwdHNReHRDa3cya1ZiRi93?=
 =?utf-8?B?Yi8zYmFlSGRqeXpER0ZXclFyVUN6UzZxVWFPOG9oT2N0VGlKd2Z4T1RjMUs1?=
 =?utf-8?B?N2ZJNWZEN1dLNDZPbGs5V2gwMGl6WSt0TU9rZlBqejlIT2FrVlJxM2dqUVZD?=
 =?utf-8?B?TS9KZ0hqMWl5RE1LQ0VILzlKNURlbzhEdEVnaFlHRzZ5em9DZCtIUVhobW5R?=
 =?utf-8?B?OENndWx1OHN4OGpsdHVqclpqVEVtdllCdzBnbmQycnZaQ0tDbGRSU1JuZy9r?=
 =?utf-8?B?OWJ3TkMyMzBZTkszYXk4UGFPTFowS2tZMUZkaUhJTmlOSk5PVGZWNWh0RmxV?=
 =?utf-8?B?SHJqVE83Qzl4TzRUdDAwWFF6aVRWVFZhZkZtOWtaNlBtQURJZCthSW1FTVJU?=
 =?utf-8?B?c2RTZXM1d2swR2xUZWFYUDBTMHc0YUJjZ0dGL2MyNDZ5R1ZBUVVMZHN3M0R1?=
 =?utf-8?B?TUtyZzRXbUdyYmttcDl4N0NJQXA0Q2U3NjcrQ2VCekJ1YU9tZ3dlbjhRWnIr?=
 =?utf-8?B?MElRbGtyNWtCS3I0dTZHMCtGOU8vMGdjZGR4ZWtxaE1SZ1ZwbEs4bkF6TUVF?=
 =?utf-8?B?ZzJGVWNMSkprYmFOc3N0Q2R5Nzc2WjVISTdRNXRWS1ZiVVozbnYyT1V4RzRD?=
 =?utf-8?B?VlowS0pwRzlCOTBlalFMMTV1bGhNUEZrYW51dzQxLy9yaDM3ZkRINVdLK3pY?=
 =?utf-8?B?M1FpZXpJRXRwUXE3Sy9iaW5HdFFBUDZublMzMDRjQ3plZEFUbE42aVpIOFVN?=
 =?utf-8?B?T2NkSm9CdFNkVlkrT2pBZ0FrOGwyS3ZSSFNKbmE3T0RBZjRWMVhjZ1JpaXRk?=
 =?utf-8?B?NzNQbWdpdTJ2RGxhRWw0bmx4SitDY2kwTDN5VWUrS3VYc0FDcjVLZjJUeitZ?=
 =?utf-8?B?Ulplc24vbTlPSUhxMmhiSUIyT0xTdjZzN3ZzaFBDblhQd3JUVGlXQVlzYlI3?=
 =?utf-8?B?MGFvanVrTnhaWlZoNDNob3k0alFGRmFtRHNWL3cxUFI1YnBma1BXa25aUUtJ?=
 =?utf-8?B?TWV1QXJUZzk1WkNoTUZoSEtlb3NsdDVHbklQNUk2VXhjdS90UTAxV0l1elB1?=
 =?utf-8?B?UVRlSU5lQ1dyNi82WTdTZlAvT3daTFFFbXNzak1YdXBlamQ4M0ZQM3BWelN2?=
 =?utf-8?B?TWtLM1hEbTRRRlBvbnExemRCb0ppSXNiNXdIRjdQMVFYZ0xLMDVETzRBaExG?=
 =?utf-8?B?TEFaK0NMV0prQ3ZPTTBwdnlucENOTndUSFEzQWc1WnNnZFB2SzJKOEl4WDdq?=
 =?utf-8?B?RnM5T3BsVytCc2ZwSDlhS1BFU1NTTFN3MXNvQ0pkZGc0SElNci9jNFFiVnRt?=
 =?utf-8?B?bmd3OWc1UHltdEFWTXJINFNoU1JsaU50cG83RFFBeHJicDZaMUx6ekRaeDRU?=
 =?utf-8?B?ZTdveEhwVEJWZ0tIcnlnSzdvN3E3SGFLQml5cXBobHZFTXc1QkQyTmdaSXBD?=
 =?utf-8?B?TDZIeVo4clRKQjFpZjdoWkxOQ1luSnBZTFBEdW9aTGwzZ3o1bWR5TE54QldI?=
 =?utf-8?B?RzJmN2NJWWRReDNGdGpOLzM0bURSdFV6YVpUdFl0NnRacnZJUWRsRHcwdGd2?=
 =?utf-8?B?d21WMnZwamdsSkZaRm9yZmQ4M24vemN0dW9iNTVWQjVCWmRJSHYrZmRNV1VN?=
 =?utf-8?Q?EkUkhp5XNN0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2V4UStmUG5JVERFRnFNUzgzZ0x6cXZ1SWRGWkdqcFFIRG1KUVVqQ29FbVdZ?=
 =?utf-8?B?M0tFUnFLdmR6RUJZUlNaUW9YY040U3NtYlVLdDVhMkZQc2djVXJMVVIrT3Er?=
 =?utf-8?B?S0JzczVwN3diTy93TDJnM0oxRVdnQUJvVXdtVjRPNkxseHRYRTBkL2N1anlu?=
 =?utf-8?B?R0dTcnVtTDZuTFgzUHhJNG5DeCtyeGl3NjkrZXhBZWx4cmE4bVZRbTVDb2hp?=
 =?utf-8?B?cHpmL0E2Lyt0RkJkNStYTUt5WGNMbjRPVFcxZUYzNEllTy9NTjZ1aFhkVkFQ?=
 =?utf-8?B?amc2eTcxeVZobjhvSldpU0o5RW1ITUlERXpWMmxvTnRFanVnZVF1Uy9zUzFR?=
 =?utf-8?B?MDBPVDBic2tOQUMzbTc4MFJSNjluYmwxWXFlTzB1SFNsYUdJTHJ2bCtYWWF2?=
 =?utf-8?B?ZjJSZXdJRUhhK2o0aDVvUmZUeEJ4cUp6a1lpU05zUUxYTXNaRno1WVB1ZTYr?=
 =?utf-8?B?SUdYZjdrRkVUN3lQSzNKOFJIcEhmRW9YMXVpVjQ4c3hYckl4bHlLUnhScWhi?=
 =?utf-8?B?VHdKSGFScVJVVlpZRzBQZlFKZGRVM1dKY3FPeDFPSWUrNWNZR1dFZGxBSFU2?=
 =?utf-8?B?SCttOVl5dG5PazloYk0xN2lDRXdKbjk5T3B0YUl3R2oxUVpPRHVuendUZ3BZ?=
 =?utf-8?B?RnJTOG9QUUYveVJqUDVZTFJTMG1YcmJpVTZ3dk9BTmJQYkduaWUvcnMvb2w3?=
 =?utf-8?B?eHhLTEpHSkdiOE1ZbUVJUE41bzhsK3hFMG9QdzBNcmx1c0dxVWlndnJVN1dj?=
 =?utf-8?B?MTJreXZFVTc5ZDkwU3hwcUZrR3NGUDJEeTRiWmtrUHNUbEhIZU1nYWU1TzhR?=
 =?utf-8?B?VkFNcWp0bFBVL0dhMWhubzFPRS8zV0pmU29iWXlOTWlXT1I3YlgxcDdYcDI1?=
 =?utf-8?B?OTZxN0dacGp4a29pR1Q0cEJRMlR1S0ZwN3RvT0J6OWlJM0RuSGRONGlmcjIw?=
 =?utf-8?B?TEVSazFlME0zWUVVZ0dCTjh0NU41K0tIMEtDV29QNkc3bDI5dEJsUzgybWZG?=
 =?utf-8?B?VUU4KzUwTW5sWTdMSUUzVmM3R3hBemJzU1JHaU5rekdUb2Zub0FHcGR6ZFo4?=
 =?utf-8?B?Tmk3NmlWQm1vY2lZUVM2NDRBNEhBME81VmJNUEpaRHdYOUZLTTMvL2psazl4?=
 =?utf-8?B?Rzd3NTVPYzVXQlFJcXlIR3JLQ3Zod2ZmbG1NYnlXQ1o0RlpCR0lHQVRDdFIz?=
 =?utf-8?B?cWRLTUpIR2ZDcDUrbmhuV1V2RG1lcm81bGlzVHFibjlQdjFrM3ZMUnViak5s?=
 =?utf-8?B?amJjSzJVQ1hzK0hwdWU0TExkVVhYWWl5amN5cDNjOFJ6azdwWFdlL01FQjF4?=
 =?utf-8?B?dWl3bTlRUFJjV0c1eUNmSnVmZVErTlVMd0t3cXpBTmNaMjdPeHlOQTJEWVk1?=
 =?utf-8?B?L0I3RjVVcmtxY2pBYjBScDFJODRNajcxUGt3ZXVoVWJ3dDBkVGtad2RONXBG?=
 =?utf-8?B?c1A0SzhuQmpWS214SndyNGV6SU14OEpscUNzREwxbnV0a1VjZHVHVWlpb1dE?=
 =?utf-8?B?TWNhWWJ5WUpGRk5ZSUxuMDJyajI2K1VEV05rL3AzL3JPWWJQcTZ6T21nT2l2?=
 =?utf-8?B?QkV0MVB3YkRwRklkdmZHWVdFSTRKNEgyUlByVmhaUnY4TXJ1dnNFZ3M5eWlD?=
 =?utf-8?B?TGNjUnFLc3BibW5jRWduMVJZd3E0bG91clgrdDlDNWwzMUQxRGdmeVpMSWFz?=
 =?utf-8?B?MEpFWmRUeUZzWTU4cG9qdGdRajEyZGs0aTQvMGt2UGVGVVpKK3BOVXB4ZlE1?=
 =?utf-8?B?Rm9wclR6cSt3aThHcEwyZzdCMTk3UHUzdmZUVmdkSnpYV3RJUUl4SVo2OVdh?=
 =?utf-8?B?ZGZRUm1HdnVwU2t6MEJnVFNGbko0bVNxVVhyU2hGZFlEeGhkUXQ1bEt3VDBm?=
 =?utf-8?B?K2VwMVFQZk10TFZtQkhiTEhob0JrMWlZNjJWY0k4ZUgyektTRDN0Wld5Sml1?=
 =?utf-8?B?emJlSmNTSUVXcEVETUovYWRQR0ZXRWg3R292cU85Qllxelc4eC9KSmYvWkN5?=
 =?utf-8?B?ZFFiNlJoS3UxcW5QVmU2MWJkQTIvVmsveW1xL0IxWFFHMkRWVDN6UDREbVJG?=
 =?utf-8?B?amtMYmMyMzNCVE5uL29qOU01YU8wT1hJYWhzSVEwdUlYUkFTVklYbDNSandk?=
 =?utf-8?Q?Y1fVzN7RVdbmmJUVzyPxJVgZ0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46842966-fe8c-44d6-9de8-08dd7da9378e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 12:13:09.4752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hl+Q+r3jO6f6epCTuVHLEy+N4ECltuvfqGvhx/1xdx48G3SizzD/uDSsqObsXIuOypXrdDwqX+wp9+6Au1WKwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4419



On 4/17/2025 4:22 PM, Thomas Gleixner wrote:
> On Thu, Apr 17 2025 at 14:46, Neeraj Upadhyay wrote:
>> +
>> +static inline void update_vector(unsigned int cpu, unsigned int offset,
>> +				 unsigned int vector, bool set)
>> +{
>> +	unsigned long *reg = get_reg_bitmap(cpu, offset);
>> +	unsigned int bit = get_vec_bit(vector);
>> +
>> +	if (set)
>> +		set_bit(bit, reg);
>> +	else
>> +		clear_bit(bit, reg);
>> +}
>   
>> +static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
>> +{
>> +	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
> 
> This indirection is required because otherwise the code is too simple to
> follow?
> 

update_vector() is used by send_ipi_dest() in Patch 7. From your comment
on v3 https://lore.kernel.org/lkml/87y0whv57k.ffs@tglx/ , what I understood
was that you wanted update_vector() to be defined in the patch where that code
is added (i.e. this patch) and not at a later patch. Is that not correct
understanding?


- Neeraj



