Return-Path: <kvm+bounces-15603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 508738ADCDC
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 06:35:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA0C9B220A4
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 04:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CB61DFF5;
	Tue, 23 Apr 2024 04:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fhAAEJZS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67D94C8F;
	Tue, 23 Apr 2024 04:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713846897; cv=fail; b=FzZ4VGKqB65/serVqkXPA3pB/g+5lrXZuVLNHVt/JYnfBTuIVD2Pmy1WmVght/N6pS4CUX4iQkBc6qrgKw7LAu93MWZ1zI8zOArdAJ5C/cTWoi7fGSvQ9QJ65CQdww42dkocdCrSyxFYc3uB8Ebwv2z+eHy7rY/kbxAqjAY3wHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713846897; c=relaxed/simple;
	bh=yu60C/07ZosUdKf9tjHalF/1qyXr+XgIUGAM9RdVJ54=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UO0fyldaDCztHEwlF3+Fm5tl0qSnVpLLEpV6/bAXpzk0p4qdljVtxuWmMaP0njEf1iasXFH+km8b4UhY7GPqX/gdwgPT0y4hkbZr+dM5gDXMVUff82tCU+u6RNI2QRo1CLjy4XYeSh4CTbaLxYDthII4E93kEScpMpoTnUOdFYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fhAAEJZS; arc=fail smtp.client-ip=40.107.96.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYrjHpU8BxsZXgu2zTxJ4x+mYpAhFDfTx8I41+xobAGDknHYLBry0P5KrBqQrRvgEhOe058qT3/0gzgDF+7I944BSLY8cSJHBVZmsnfbiLaJrFKo2vmiYum4G1ENgHCVpex3MZ/cBuzHq+6b3Aam9K7dVqcV7YxOIkwt3vUcPYagVMoM2pH+E0Tqz5ubLbmeSAEB/WnE7Q70zvpH4zB5HqQXcqJuwf8C+MNnPuNDNUprgNMk3T/pgSRJGRMdnuBnRICpvOn2xrsbSqV84HEWO84m72DjogA/QbovV3p8CddTOCYkrg65qnqplqpck6IuIfvIq9SLC3c/uo7VRsLXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qi3w3ekyYv3IMStY/jHnj5aFndfdAnLiYcfzOJd4KtM=;
 b=O0Z4LBzwzM8ZvYjFzfH5L5wGfwXg51kNHCyMwTm9kM0Drnhrs2pRhc5XYqAWRP2lQ8Fa8T3kyTVZDhaqiZo42/NfLsGXXePt3fg2hazYpV6NJGl5V2tL2LqLHUCIgC6mpnn4zpeLDB4FkI1F8Io5q+U0sD7QjjDZJ4NnmpcasTQbGlBojII+C+16kAVyAxJqpNn4P1UPRAbE9BJkRPo2RGVtDKVoCAZgpHsR1KOqlJWu0dUjBurNzE4Dk/PngygF5DZHhgnjrAQwyGb9+hGSSA/nLUY6OXl2Z9GUhh7iCx1epEiFGj04GRMczhvsDez1ARKLJ1ajTKSEaI8OKGjXWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qi3w3ekyYv3IMStY/jHnj5aFndfdAnLiYcfzOJd4KtM=;
 b=fhAAEJZSe6i/RK49j2eYKs3FZkDLsjh4jxL+BL5VbPWNEV6fj0riqB2Kc6lBUzXdGbNkFz1fDws9GPH3skgajBY9zC2TQcKV3tyG6ocEI0oPgnetVFQoLf+mzrFrkRyK01WpVzCzvmivSS2eCl2O3Y/J6u2Kp0OpKTwD7uHcW14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA0PR12MB8929.namprd12.prod.outlook.com (2603:10b6:208:484::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.44; Tue, 23 Apr 2024 04:34:53 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 04:34:53 +0000
Message-ID: <64f7924e-1782-43e5-b21c-6e8efd74f318@amd.com>
Date: Tue, 23 Apr 2024 10:04:42 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 08/16] x86/mm: Add generic guest initialization hook
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-9-nikunj@amd.com>
 <20240422132058.GBZiZkOqU0zFviMzoC@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240422132058.GBZiZkOqU0zFviMzoC@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0155.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA0PR12MB8929:EE_
X-MS-Office365-Filtering-Correlation-Id: d757106b-21e2-4956-6dfe-08dc634eb85a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RDZ6dzRXQ1dDREFhaXRWdU9tTFZrMExEM01Fd3RyaWpHclk5aGNTSUd4MTF2?=
 =?utf-8?B?NDdyK3NZVWVkVW5pOUVBOFlCY3RGSFUxQjIyTk1SV05qOE5yY2lxNWMvdUZE?=
 =?utf-8?B?YU5oQnBIem1CT2MzZVZyRFB0TUpIaTZZaWtWejR3Wjk5eHluZ1FkMU1VVmFC?=
 =?utf-8?B?RXJ5TDJ5M2dsL2w2dW1UbXV6SVF2c1E1MnFwcEh3T0ZKMU83S2NQZFc2MFNp?=
 =?utf-8?B?Wi9RdDhkNllybTJJU2lCbnBLcGh4eFFaZEtJbVE0SlRjNXRxNlZsUUdUUWdQ?=
 =?utf-8?B?c2ZZeGRYK202M0xmMURSY0c3MDZHK3ozeHZCOHc5UnNWcGVTM0lNS2ZkVmZZ?=
 =?utf-8?B?RXVNdkR2a0k1MTFDcjA3SHlNdG1HR29hcmtXaTIvdjhjSy8xVWp1RXd2VndL?=
 =?utf-8?B?cFkwS2ZoMnNzZTdMVGZjUnBqOEFHZ1RrakdTMGtzSXdTUHIrNlU3Vk80UEw3?=
 =?utf-8?B?UkpoSWRVUTJQeTFDWXNMWWE2bFN2RmdsU3FEeG5MV3BleXlmbFZka3FBSm1S?=
 =?utf-8?B?WEZJMGwwelhXREYrd3VadjVuUzBrZkpOVllrRkJUQjAzanlzV0hJa3k2andi?=
 =?utf-8?B?bkx4dXlXWGlOVGFLUmFZZUV5NlJZZDNWWTVLZmU0SllDQkJoZU5BdS9kL2FH?=
 =?utf-8?B?VG43NmFtY2ZoWVV2UGx2UEw4TDVKcXdmNjR1bzVPZUt4S1kzbmY3eHNwc1Jr?=
 =?utf-8?B?QWZPMi8xbFZVTmZXbnJ2V1lzZ1M5eVJlT0xEWHZWWFFaOWJIdnF2RkhYKzlk?=
 =?utf-8?B?YkVBSGQ4b1MrcDJjSVFpT3NtWk9lQXJlY0FvcU5COEVYVnErWnF4VFpReVZU?=
 =?utf-8?B?NnFFa05HdWVNWjI4WnFwTVM5Zm1kRWE1MWFSZXAwYnhGMFFtbzRHN2dwZ3lw?=
 =?utf-8?B?QkMvL2NWdnRrUUNab21Qc1BZMnVjbjJzUDh5eVdwbm9QMG1lWlBtS3JmeCsr?=
 =?utf-8?B?RUkzOWNVMUNvVHhyTlA5N2pyNm56all4VUdlL2UvR0h6VlVDSkh6dDBaZE1E?=
 =?utf-8?B?eVUvTEY4RzExWStiU3RMK3hsWFhYUUVabUlxbEpjZHJJM2pDWEREeU9UZ2NM?=
 =?utf-8?B?dlhFRnBMbjE2NTdJMEpzSE5IUEhtUU1iVnVYV1NiSlZ0Uk9YUjl3NW9pekh4?=
 =?utf-8?B?OFgzd2xEV2RMUWl5a210Tm1KRzIzOEZrSjJVMjUvM0toYXBydUloMDV2TzBx?=
 =?utf-8?B?NXRWTldUMm5EVGVaSHJsRzJ4OTR0eXBRSTZmbStEZ2NxQ0I0Uk1wbkdQUFFM?=
 =?utf-8?B?VU9CeS9KMWp0TU9FWi90QVp2SEorenZrYnVHZFk5YkFOQmovN3lFU0xycFBj?=
 =?utf-8?B?dVFQUG9PRnpya0svdk9jRThFRmhJR0FlY1VlV1VtcWFuUTdKZWhzeGVQK1Ex?=
 =?utf-8?B?VE1GNDdYb3ZSRFkyU1JYTGkxWkh6Qk9FV2F3SHk3OElIVjczNVFOWWlPM0FT?=
 =?utf-8?B?dDAwam9Vb1czNWsyV1V6d0dBVFBnUFlCclc2NWl0STVRS29iNG0vWEtyZ2o3?=
 =?utf-8?B?Ynh2M0loVllyQXl6dHZFMVRoWE96ZW5CWnhZOW9lY0UrOEJBdVdLZ1BHcSto?=
 =?utf-8?B?UnZBRUlXZlRQelJydnFGQkppVkdNWTZuaHNidmZwbHBTb25DcVN3VlowNjI4?=
 =?utf-8?B?MHozdE5LUGlOSEFUZC9rMFlxQ2Z2bWZwY0dZYy91dVZNOUt6Tks3UC84dkZ0?=
 =?utf-8?B?aTlIVWpMTEdrSys3aVdaT05HeEdIRFBoL09JdG1jd1B4OVRleW0ySWN3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDYyMm8xeW1iR0tTUmd2M1dlQnhLbVVjQnBLMXp3eDdyTlhvRG9HVlFsMmxw?=
 =?utf-8?B?cnRWUUlUMmRQV05ybjF0dURtcmNENGVUdU1DeTRIVzVUZDZYUDFtRFZlK0Jv?=
 =?utf-8?B?YWU0eXg0RzBVL0ZjVkZINldRUk1hTU9IdStkZGxCVUJkYlFRdjZ0ZjFuWjN0?=
 =?utf-8?B?MnJQQnJMNHlJdDlRcVpobWMydHhSalJwTHJWNWJQd3hXcjVzbkhoSFV0Ym5Y?=
 =?utf-8?B?MVVWeTd3WWhDc1lPaFBrN2NRQkJBTVFLbENmREdwUEdGcmJmYzNZaTYvZlhp?=
 =?utf-8?B?cFZsS0k0aW9HbEFkaVpyTjZJRWdDSkNZSnEyTXNUMExXbjZoTVRGN3k0Z3RJ?=
 =?utf-8?B?KzFCYlZybVBRdjFNQXlkaTBEL294NFlESVVlRXFad1RhODQ2ZEp3Z3FZcDBq?=
 =?utf-8?B?aXYzcnZUWXExOTAvRXBxQWo0UlFYdEN4cy9OSVRQY1kvWW1SU3ZUN0hhZE1v?=
 =?utf-8?B?aGk1aUJmRGZtWE0zbW8xcnZBVXRadjcwaWs0Y3ZabzEyOUUwc2tsK1Q4UkFS?=
 =?utf-8?B?bTVORThaTklBbGxIYXl5MUFjUGtSNVNIUlp5M1VMRUtLcW1rRWVKK0h1TGI3?=
 =?utf-8?B?RjIydkRFa1ZtSXl4dC90TlE0L2gzQWJqUjJUMzZIRWloK0dxTGZJTFBES0dz?=
 =?utf-8?B?Nm9pRkpDUkFMam94OGUxVHp3ekZzYzMwM2hQZTE1T3BhS1BjbUN0T2dMWksv?=
 =?utf-8?B?SFd6WER0OVVZUUlOQUdLRjR6Q2hxbVl5Z3dtUzEvak55TVBsK202MnZCNjhu?=
 =?utf-8?B?eE94Qlp5RGxkWEMrc3dJWjF0clYwQkxhS09uODNSdElWdytYQ0ZINHRETWV6?=
 =?utf-8?B?c0VRNjdvRzhKd05uTFhLcW9JWlRONUdaMFZqdjRnZHdJWVZqOTVlTWVJQ0tj?=
 =?utf-8?B?dkVUUVJqMWtBNW16WGhTV0hOMGhmNGRlbmtrQXUyYmgwckY4SllaUlp6LzN1?=
 =?utf-8?B?bCsxcmpsU2N6blVvbW5Ldlc4dXBjbVBPWStDM2FKcFI0dkxZS0ZQMDMyZjFj?=
 =?utf-8?B?RU5mMUdnazFoNk9xSXd1eUlGd3ZOR2dTOWFXaW1BcENseEVSVFdOWU5pbkc1?=
 =?utf-8?B?YzRMSjcvcmRXNHdaVU94amtGdC9BU3RGYWJkRVFKS2pYTHVoYXFlcEFxRkRP?=
 =?utf-8?B?WXJwZENralcvZXNQZDFUZXNIVnJJRXduZ25VbUJPYjRQb21peVNEYkFvTm8z?=
 =?utf-8?B?OXFjSHo1Nnhqd3NSek50d0Z4eW5hc2g1cjhpMlRpMDVLWkFQK3RQblAvVmxo?=
 =?utf-8?B?akJFVEVRWnVZeWw2WkEzVHd4RlE5V1pYaWtqODlZZDdyOHBSTTV2Z1NaZ2hv?=
 =?utf-8?B?YmNPbXZzZU1Sby9lb3lFQUszWjlWeVpweFN0bU9QRHRVS0cwcVdWbm9ITDZH?=
 =?utf-8?B?RGhQTXFsSVZ3TXNyYllkL0VyMDJ4S3NjYUdLdDVkb0JqNnJ1NU54eUFCZkJM?=
 =?utf-8?B?dWdDWDl4a1ViRzVWTkI1OHRPM0hoOTJqd0t6UFBEVFVGTFJvT055UStIcG5k?=
 =?utf-8?B?NXNLU3FhbGxzRjhheGU3alVhK2hoaG5ETlh2U054OFhuUDI3dDd4cnh5L0o1?=
 =?utf-8?B?NzlwN25BbTNrL1BOUGpsL0JzMHZKWTlGdDBXZWhQNmlGelFCUVNaRjBJc2ho?=
 =?utf-8?B?Vnc0NUMwU1kwdkVhMURicVNJbU5BOXRLSjJxYWN5ejM4NEtMcDVEdGYxeVFi?=
 =?utf-8?B?MkdCNTBkbkgxTkxRcGFmZ285ZS9qdFRwSDJBcXZta0g5WDZYWHcxbkNZWWVH?=
 =?utf-8?B?dStPaXloM1FWUVp4cXJ0eFNMMzVVbnhKZ09qZUpRNzJ2ejBIWWNxVE80ZFlj?=
 =?utf-8?B?UnBma3ZpZ3RiWTZRc2JDRFAyeTlaeExETTRjdHZoUTNoME0wZDhvWTNUZHVr?=
 =?utf-8?B?ck5HbkVQYU16NDRBdTZ6VGVMb0owV1crTGhFbTVBRnJHaURSNE5XR1A3UXYx?=
 =?utf-8?B?d3JHWDFaczVpampTZDE1V002V280b1FlNHJEc09KblhjUmoyN1I3b05CQm1O?=
 =?utf-8?B?VWlSRSthTzEwNVZKSUJWNGdGVS9LUzJldHVkdUpJcmhOS25tZGZETytsazZa?=
 =?utf-8?B?SFh4OXRqYVVQV0V2UDU5ZzMvYWM3OWdNU0RnN2tGU1ZhdDZkZjRZekp1cHFv?=
 =?utf-8?Q?/wJTZSOO9OiDKZv3DUXmwEyLF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d757106b-21e2-4956-6dfe-08dc634eb85a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 04:34:53.4648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BuR+zHg1NPanGsL/my3H3PxCik1kjXjYKMQh55raKsDsBUduEZNs8Zb5DElmAAPazkU1lAPo6H3Hbeb1thKeNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8929

On 4/22/2024 6:50 PM, Borislav Petkov wrote:
> On Thu, Feb 15, 2024 at 05:01:20PM +0530, Nikunj A Dadhania wrote:
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index d035bce3a2b0..68aa06852466 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -89,6 +89,8 @@ void __init mem_encrypt_init(void)
>>  	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>>  	swiotlb_update_mem_attributes();
>>  
>> +	x86_platform.guest.enc_init();
>> +
>>  	print_mem_encrypt_feature_info();
> 
> Why all this hoopla if all you need is to call it once in mem_encrypt.c?

This was added thinking in mind that any SNP/TDX init can happen in this hook.

> IOW, you can simply call snp_secure_tsc_prepare() there, no?

Yes, that is very simple, will drop this change.

> Those function pointers are to be used in generic code in order to hide
> all the platform-specific hackery but mem_encrypt.c is not really
> generic code, I'd say...
> 

Sure.

Regards
Nikunj

