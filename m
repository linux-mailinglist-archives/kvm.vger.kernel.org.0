Return-Path: <kvm+bounces-70356-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6NPuGMrWhGlo5gMAu9opvQ
	(envelope-from <kvm+bounces-70356-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 18:43:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC05F6197
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 18:43:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9906E3077BBC
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 17:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111732FB99A;
	Thu,  5 Feb 2026 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V/Yt67yo"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A042EC55C;
	Thu,  5 Feb 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313190; cv=fail; b=twjMuw4kvC+rV3JKBNealjQNkiMaAnp5EcfFKT/MR8pXM0nCWe3XQUv07jLpZYG2fWpK5iax37DJnfE8Phror4+652D7zkxR9y5c1JoM68CE6wt5sXN6wjAykMRNzRgsf6qJ2fK5wwIiotNNwzipDw9FsBk6S5PnoEtVzGXp+Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313190; c=relaxed/simple;
	bh=8baenHgt0bLg4k0YPTstQypx4f4tk0NQ/WO3baqINlY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bOCwoSVhUzd5JI+LcpfnKTdUTsCkEtsHBSg5x0FtxJ7A+F45tGmo2K8j0fLYI5eVVdNf/7hg3ZyzUou2d1KkZz64jcIFhhL98wxjRsur7t3crx9W6q7sDjnQEml4q5hLwBK00hetLkl6ocgMF4Z5eOESXYsU0PuWLSkq9M+87PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V/Yt67yo; arc=fail smtp.client-ip=40.107.201.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ma2U4liMD1HZSLPqlPAxWtlXtejLkjjA0awhXqSqrODoFmxLc+IJo11SJdDfRc6ZO5Dglri6027MohP5qxXjrTaZb5EdfYX3RNnkBqOWZgWADavMMOqn1JnhYp+Ke83nzq3AI6cbGcVk6JNjiF36yC8S0JorfGPeBTV9Hzl9CtflRQq22ps46IC95k07u82Tz0cwcPBj8xgDh5Rkvc5OIlVmS09loCt+U3wqKMtsIoYCvNNiFQ4JgUwkCEEPl+ghch9oPuzgHlv4qhC8Eh3y87qb/cHTvkXYm8acotLsojlFfZwhmqT+cZsqJdiioTzfmZR76aAgZRV+mIenfp2K/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6Xtmp0T9BVnlPgEQLupjgkUx+J3ZEDcjoeMYME9ZC0=;
 b=rfzi9o45a10cTYATNSyPZvycN7Qi36i+FlxXjyNz5XlOEAUqFGVzgTM+M2ppqn9JUnQoWMhYCgjWzcmDvcFbh9PeBGr2x24Q2BdepB995+A3iW0H9s6g1RsP9+G/MUqFfscgvZGYzDHcDmPKc9uuV9xbOmveA3R0o0ASbG3iX0w3Fp/Z4X16XJMGwX0g/SR3+sZ/dgCUofdxI8dAw4Jt3PaRwYFp972NAfwyVauE12cqE7nTOx6FmucKigfNANzIjMlnGD5l+A5PLQTqIR8kTjH8/Pppfaolz4pdymwS0YTIveE/bjARUGMBicsuY7gAw7mbVPIM91CtysYpN+cFqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6Xtmp0T9BVnlPgEQLupjgkUx+J3ZEDcjoeMYME9ZC0=;
 b=V/Yt67yoV7DUviou15R0q4VXheRTe1uRX8Se4Psj5Nd/pyuB7Z3myEKdhyHmwSMv9bk8NTHaruLgXB7thov1/hslwtibwQC0BvgMneFVIf5ylcbR4QY7iR7yhGKW7L2YBIqu/VDRQmcZ1CMv4ci/I6Drf6MUJ//AtzKSq88YcnE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB999087.namprd12.prod.outlook.com (2603:10b6:510:38f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 17:39:46 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 17:39:46 +0000
Message-ID: <103bc1df-4caf-430a-9c8b-fcee78b3dd1d@amd.com>
Date: Thu, 5 Feb 2026 11:39:09 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: Dave Hansen <dave.hansen@intel.com>, Nikunj A Dadhania <nikunj@amd.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, bp@alien8.de
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, xin@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 x86@kernel.org, jon.grimm@amd.com, stable@vger.kernel.org
References: <20260205051030.1225975-1-nikunj@amd.com>
 <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
 <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0046.namprd13.prod.outlook.com
 (2603:10b6:806:22::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB999087:EE_
X-MS-Office365-Filtering-Correlation-Id: fcebb566-1158-466f-5fd0-08de64dd8de3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFVTUXJzM2pqaTdkaXJoeFJJZDM4TnRobm9aUXhkUmZxYjRUcDE5M3BIWlBh?=
 =?utf-8?B?SW92V01iR1M5anQ4dy9jTnZoMEJGUHBueDd4UHk3MTBTejZESUpDZWdDeTl6?=
 =?utf-8?B?SzRQQ2VrSU5ETjVScDVHWXlyVzc1S1dQT3BINWhHN0cyaEN5RGZJSlpCVGxD?=
 =?utf-8?B?K2NiQ2NpVWhVQTBZZVp4b2VkUW4yaEVnUlY5R2VrVDlCUk1RSW1DVGhqNHl3?=
 =?utf-8?B?aTRzM2piMW00ZGR1czlQYUFvNjNCNmhjZzRqS2FMczJYRWM0QWtETytGbzJn?=
 =?utf-8?B?c2dlbGVDbnViZmg5cFVCeitxS01qSUo3akwwQ0p1SlAySmlhaE9nSWVKUzBq?=
 =?utf-8?B?RE1rWDNMTi9nM1lCcDcvWXEyaHZ4djVjeUZrdVU5UjF2VXdlMHhqTmxpYWlM?=
 =?utf-8?B?anVKMUxObmU4ZTRsb3VPTHA2YXluTkFaYlM0MU1PWHNBTzJWRmlnUzk1Z0JB?=
 =?utf-8?B?OC9SdkR0Yng2NjhnSWM4alJ2SWEwNzRZeXQzSTY1WSt6bHV5NHdvSTZSVzgw?=
 =?utf-8?B?YVNwS0FmaFhSakFQbENtUHNiek1YV05sVWRuMFVYTGVYeWpYeGpieHd6RXYw?=
 =?utf-8?B?VFl5eUd6NkpybnM1V3VIQzFQUlBaYkpNL2t5c2h4elFpcHplckNXVnhHcC9S?=
 =?utf-8?B?VTZ2RmZwOG1OZFBNZktlZ1czUjhQczJEbVR5ZHpRUWVIM3hnOVk1WDdqbXVu?=
 =?utf-8?B?SXZKdlUyN3BLRUlUT21EdEVKRGlnUXJHbm00aTJlNVRXcSszM0RhQ2t5eENh?=
 =?utf-8?B?aHNlV015b2h2dDlYYVltY0FEajlGa2N3UkhlOXNJUms5R0xCK25qTEZ5Vit3?=
 =?utf-8?B?eG1xVUVWQVdtYjE3cWlnRVVKQmJMZTg3QUdnVzdKWXdIeU9reEtJK2FPZkxH?=
 =?utf-8?B?dlJDRHhQbUc5TU9jejVFbEpha2d2NmRYTlgvZzhYb1cvWFNSQ001dG9VQnZj?=
 =?utf-8?B?ckgwVHdXQVJONW56THhKeHNKOTZGcFdxVmtpZWNXblltYjZtSldkV1FXMnR0?=
 =?utf-8?B?TUpmbU1nNzBHb2NpTE81dWtDN2x2TStkRy80L0cwV011Qnk4NHdWVHFXZ0do?=
 =?utf-8?B?ekNwQmU2UFpzNjB3QUpFblRMWWhtMGVnZENwYzdBLzdKcHMzY3RTTGpVNE9V?=
 =?utf-8?B?S0I4Qldzb1IyTkJTTFdvL2hzWkFwdElOKzNhcnBFQ28rRkw0bFNCUFBxSFlX?=
 =?utf-8?B?T0VLbVcwT3lGNHJBWUQ3WDZCdmFvWEhDeGhCNlY4cm5IT0ZTMzMrWEZ0Tnp5?=
 =?utf-8?B?N0tGQXFnNzRMYW1uVHZtS2MrVlp6YWh3czJUU0tiVlVFdXRzQWVJcFBXMWdh?=
 =?utf-8?B?a0JWZmg1dlNHSDJRNXhWQjExazlRcGZYVytRUm16WVFUMmtYUy92MnY3ZkhY?=
 =?utf-8?B?L2RoVjcvQmdOSGV0ZDdVVmpya0Nza0tMYTRqSmVFU0VjMytObURCbGg4OU1n?=
 =?utf-8?B?QzJRNSt0em52V2xudysyVmFJcFVnM01BRGFOYzN0SU9UQWUrSXlKWWY4eEdW?=
 =?utf-8?B?eHFNNG1ReTYydU9TekR5NVR2cVdZZm1ld29NdjNBUVVUMFhRclBnSy9HaXIr?=
 =?utf-8?B?UHZVVGpUbXQxdytOb3M1Y0hPZTBmNE9kYzVENjUzWXJ5cFdsWVd2NzByRzFD?=
 =?utf-8?B?ZnR0Tlo2SENHU1duTlExdGlvV3AxTllZZWxndWRTZXRkSFQ1MXV0RUlQME1l?=
 =?utf-8?B?SmU4TjdjRzMvZC82WEtsTm9pTEpRcUZkbnRjSGVodFNjWW1wR3RrRnRFNEtk?=
 =?utf-8?B?WnRZb0FNQlVLVlYvWTlFaUVDejJRa2JFM3dKU2FvNlorZjg1NStGT0lhSEhZ?=
 =?utf-8?B?Ky9xa0pYNGg2UHBWNW54Y1NRSUZ2cTREYWtWV0JtOW9sL004WjViUHBkY2pm?=
 =?utf-8?B?TGlWWXNOMTR5MmlkZ0g0Z3N0OVU3dFRvSnViWElEdXdBWXpkMWhmMEVEMmw0?=
 =?utf-8?B?RzZEOUkrNnd2cDVQRW9iR0VmT2VwZ3lQem5kKzJUVTBEdHdvRkQxTVlpWndl?=
 =?utf-8?B?ejFCQjNqQ3Z0eFJySFcrNmJwWkdYTEkxZzRYSUx0ZVlNditWZ2ZLdUl4MnV5?=
 =?utf-8?B?WVlOclFpNXpGWnJMdHl5NlhyUkZZSzNyYkZ0YWs0bk4wNW5vNGJqak04YktN?=
 =?utf-8?Q?ufk38FevLy7uA1KhSnaqQKOpI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTNHM3F0TU5CK2F3SXlHRkplY3JrN3pxdnY5RlE4Rit1R3JFUVpMWGJzZkMy?=
 =?utf-8?B?bmI0SytVZ2FFb2hxWWlyRSttV0JyVU83SURnbHV0NjBONG9Ccy9JRU5tRVdn?=
 =?utf-8?B?U0R2M0lTRytuQnVnTmRRVUdHQzBjWjNTYjlBNWtYckF4WlpCUEFMZGtCRy9r?=
 =?utf-8?B?RlpBa0ZNaWJnY05ZanRWekxvUUJoK0YrVlhtUU95cmdYMFRmZkNVL1ZjakJ0?=
 =?utf-8?B?SUpsRUMrR25OL09Xd1RGbVJISVlEUWV6TVh6S0FTck4yQ2lIVkJSR3JjRzVM?=
 =?utf-8?B?US9KNkIrYkk3WGN6R3lXaWE5N25abWVYWFppRktEbVJWYWJuZVpsbFZxK3Nq?=
 =?utf-8?B?NVN6ekVLS0lSRmNtVlFiUzhnaE41UVpnQzZFU0FuQnFIMWNEOEx3c0hseWgx?=
 =?utf-8?B?cUtSVWFJR0pkZWtGZ25ra0FuckdrMmJSejFKU29KOWtRY0g4YnFLcVFPOUNF?=
 =?utf-8?B?WFIveUxpVTlNdnhnU0xjczhVZnBmRjNXTWdoQzNoZ0NaZ3FBTTBsZlNEaFg2?=
 =?utf-8?B?RW1ldmE5SVl2Ukw1NkQ0U2ErZVZWKzQzQXE4VnZnQnRRelFVTlJBQThuckVh?=
 =?utf-8?B?QzhNUHFhaDljdFhzaHJOcU4vOWxTQ3c5KzRDcVVrbDAzZ1VTa2ZBWjlFNjEy?=
 =?utf-8?B?VFo3WnVXL1IvcDk5WDFVcTV5WXU1aHJqbzlZZ2JaandUd0NNc1NqWFZma1NU?=
 =?utf-8?B?VklYbmlFeW9aM1NHaHNDNHFoWVNtSmVHbTBEN1NCZ3VFYWJJQWtNYVRnaDhj?=
 =?utf-8?B?Z1Q4N2pUQXBTczRBVUJlbk5zWjluelNub2dIZmRja09zYTF0dzkzZkV1eTYz?=
 =?utf-8?B?VC9yQ0tRYWptMnoyNnNLZHYxdmNhMitnZ1lBcVh6QmhXbDV3L0kxTFVSYUlq?=
 =?utf-8?B?ei9kb1k0MWpGZjZ1YUcveUdTczU2Rm5uMFFGb2lIQjRxUS80Z3c2d3JtdTNE?=
 =?utf-8?B?elV3bWZqU1ZJZGtvd1hpKzdERldGMENaV0JHelQrdVR6L1ZlbW1LaVIvaE9L?=
 =?utf-8?B?S0g1NWp2OWVieDUvUm5ublZKdXBFMERhcy9aa0tXdkV1a3lsUmVaTUJJTVZv?=
 =?utf-8?B?MW9uTzdxKzc0RmJPNEdiS1BHTXNydUNqSkxxbzQ1L2VoamU0N0ZtdHd5SVVy?=
 =?utf-8?B?RTRUMmd5YzFCbCtNb2tsOVpReHpHWlZ1cVY2bDYyOVk2WjNsRmZiVWVWcWFP?=
 =?utf-8?B?cmxHT3NUTGRWbjl5Z0ZjS0lHUk1GZ3FtRm5kUHE3RXFHMlBwYlBjcFFNQ3FO?=
 =?utf-8?B?UkYxd2ROK1F0TnpVTituY1VnYnVTNHg4ZktJVVFhdldKRXlCS1hDK3lsbVln?=
 =?utf-8?B?YURtQUdWQmxEMHNCcW5qTVFXc1Y5S2dQRmNYVFNOeUhPVms3ZDZYQU5DUTdF?=
 =?utf-8?B?eWtyTFFnbmovYWlGQVhDZURDVWFSQVlEb25YNGdrK2dpd05XWkZSbHVVTWdF?=
 =?utf-8?B?R1dXWjA1ODRHamVrVXgrWW1JRjd6RVJldURwL3NJQTJWQ0ttZVBMbFQrVGRt?=
 =?utf-8?B?L01KWFdWRWNmMGl4TjdlVVhCSHhsVE9OTlF0eE9SekcwbTNXcHA2Z3pHSEJJ?=
 =?utf-8?B?bVNxYXFzb2dHcG56Y3Q0aVdBTjNFT0dNQXY0UFExakZLcnhyQkVHbFM4V3Bk?=
 =?utf-8?B?OXRibXlhMmtpOFVXczFZcjZoQjRVcGVKYmJsa2tYNnZyc3AxRUN2emNpa3o0?=
 =?utf-8?B?NmZmNm0wWi9aODlaVVpZUnpmaURrK3pBVkZRWGF2UUo2SjREMnVVc21XSjUw?=
 =?utf-8?B?RzZlVVNOS01RMG01M292Z1FHSnRVK1FjLzVldGNaY2s3TFdJM1NTVW5OdjA3?=
 =?utf-8?B?d3dmak1MRHhJM21SMGJ6c0hCRVdJa0tkUUxSSGZPWkMyL0M4RzE0elRjNFlI?=
 =?utf-8?B?Q1pGVkEzYytqQkRQRS9CMHA2Uk5oTzJXYXFsMVRna2ExUldqZWh0ZHZySVJP?=
 =?utf-8?B?L3VNMHllb2lHMTFkZ0xmakNPdjc0dkJSL3ROdEtHYlFvdHp5WTcvcTdNcCtw?=
 =?utf-8?B?TE9SWlFGV3FXTnBOV09XbHhrUUJRaTB6b3pJY0lQR0cyR20zMFZ1WjNuWWdm?=
 =?utf-8?B?QzVRUUErZVB5WGNlTlNRcG5xbnc4WEFjUmdBcEM4dFErSWNxS0I0dnAyMGFN?=
 =?utf-8?B?TUJNODBFSDExTmdqZnMxL3Azdk1XYlB2cXRlVkF4akUwaFQzOTRQdEpLREt3?=
 =?utf-8?B?WlBhdVAxQUk1TUtBVFhaV2cxOG15UTlMQjZNYWhSelRKRnFSU1BCa1U5Umtm?=
 =?utf-8?B?YlRZUGcrQWhXc09GYVdpdHRKd25YWXhGSzAzUnExeWs1bDdaNGh0cHV2d2M2?=
 =?utf-8?Q?868PPJh9+8rGzGK3MM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcebb566-1158-466f-5fd0-08de64dd8de3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 17:39:46.6362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ope9WFdT5L1Ds5AdiwQpZ/RyjRBinNTJXj+RlJwf8X7T8q3xFzcTNrfGJm5/QOZyOW655ZOKYlQIYOYXbBB+nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999087
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70356-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CEC05F6197
X-Rspamd-Action: no action

On 2/5/26 11:20, Dave Hansen wrote:
> On 2/5/26 08:10, Dave Hansen wrote:
>> Shouldn't we flip the FRED CR4 bit _last_, once all the MSRs are set up?
>> Why is it backwards in the first place? Why can't it be fixed?
> 
> Ahhh, it was done by CR4 pinning. It's the first thing in C code for
> booting secondaries:
> 
> static void notrace __noendbr start_secondary(void *unused)
> {
>         cr4_init();
> 
> Since FRED is set in 'cr4_pinned_mask', cr4_init() sets the FRED bit far
> before the FRED MSRs are ready. Anyone else doing native_write_cr4()
> will do the same thing. That's obviously not what was intended from the
> pinning code or the FRED init code.
> 
> Shouldn't we fix this properly rather than moving printk()'s around?

I believe that is what this part of the thread decided on:

https://lore.kernel.org/kvm/02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com/T/#m3e44c2c53aca3bcd872de4ce1e50a14500e62e4e

Thanks,
Tom

> 
> One idea is just to turn off all the CR-pinning logic while bringing
> CPUs up. That way, nothing before:
> 
> 	set_cpu_online(smp_processor_id(), true);
> 
> can get tripped up by CR pinning. I've attached a completely untested
> patch to do that.
> 
> The other thing would be to make pinning actually per-cpu:
> 'cr4_pinned_bits' could be per-cpu and we'd just keep it empty until the
> CPU is actually booted and everything is fully set up.
> 
> Either way, this is looking like it'll be a bit more than one patch to
> do properly.


