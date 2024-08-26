Return-Path: <kvm+bounces-25060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F375C95F623
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 18:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73BF51F23D13
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 16:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B63194AE8;
	Mon, 26 Aug 2024 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h2wJ4GtR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BA79450;
	Mon, 26 Aug 2024 16:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724688640; cv=fail; b=Y+8APaDYqVgiAakqNSz8Z+xSkuf6YeEnqVFHMKt8YdkZxBchZFnORSRK4D30iAq+/XH4xrDP3KthGvE6JtKfEcdt0x7Wk4A84bheA5vZyHMljEUrgvcp55jHaBezT0RTcOMI5PiYymNqN4j/sv/f6fuoUrPcVB6suMM8WGwkOUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724688640; c=relaxed/simple;
	bh=NnXS/UCA2G5Q8FhW7LpdFBei5M7ygHgnpskrMkDEZcA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VoJmr0dS1/26EtESes73LYfOyYrZxj6+/s1620QFGWRLh/u/D1VP7itLYOAvPkDIs2IsebdZrLmxtGA8yhp2OkxO2cSyB778x0L5hNGR6QzG4W38pCOaRcIRRor1ZPUjYsC0ruyA64vzuRYrUbvkGEefoYQQoeZDYN39OKz6Ras=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h2wJ4GtR; arc=fail smtp.client-ip=40.107.100.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vhz6yPl4uo0mhR7AqXWCLYotmXhJ2hCgeCyWd74qzQeB//9dndpRnHcERjeYi8GNRpCJZ2eGzjJ3+yADhXM7CL6i+D/33KwblG+cuu4B7VDCuQ5T4eruEgwYh79MBk/ymuSYv8U8yfZQQFL7PT17OFxj8uJ/F7bfA5TOPFwvQikG9B4iquQUfFHvmMsJQez+mQco69138cyecKT3OQk8tWoTald31LH9NNFBi1NojQDQtb4Z6qiEfT0l1S1zrVELdKcqu+bkASmEJ1lrzXjvIlXGXQWaIAJhbc51P/blSKmBNUua6nGWK3vUEeDXaehermrk0FX+28Vv9ua3DEAtSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDIyvRscSFeLQLe2XpQFxDCUeX0Nei+yEQ1G91SLt3Y=;
 b=ZXYoyaMlQ3Ew0VZ3ZEYK3alaeCaUtjKkbBnSr+hcdzM/O3ieyUvpdiEihc0jzWPCh/c0iMbGIfHSwhmifu6DtYQ9mcaXSRxSw2pXawRUZdBwe0+6XJA7AdCww1NvlC0dNsGoPQ4Y0xPq5jH81mNycncYO4ougjvpVka4432TlZn6Y21PxtVWzEfqGsHufB9XNw4BTV2m8/bfLLwyyY0xvIsCHlwst4Kgd2pW42X+rzmsRze7WrynvPzyiOTQ4EWNXrM3nhHzqMvY2Qqv16c4o1dyMg8OrTzKt33T1htrDrOBSegQK1ALfO27aSjZVOioAWL6tKKWRc6v3CKCnK4Vdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDIyvRscSFeLQLe2XpQFxDCUeX0Nei+yEQ1G91SLt3Y=;
 b=h2wJ4GtRw2LJy9ls2Jko5eThncXzh0Eiu9NIFmg7xFGYFoZ3DIWk22UvTkClAwpNa5AuRAioAcEflsDoZcbA6gnc6qv+4dXQy/iTPfQhLDXJEzyHKV0jSQ8zozlHQY+iTrLtZ8ZHw15M3v/vLqjbubMfJPOV0Aw3Bj8zLTEDp9tTPEok7d+VfrHLAhQ3//xA9rnmOEmrxqIZ7O709zJu4H0uS9rjg8YbSn8aVgdHi5xLM3xaeIgeTj92X0azbeNaQOEDuVTMZIBASWa62r3XARr2IsIVy5cVJGjEELbP+rGdS75Jq11BvWaUWytxbEsy9M4+EobZfYh7nn7AM0ut8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by SA1PR12MB8968.namprd12.prod.outlook.com (2603:10b6:806:388::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Mon, 26 Aug
 2024 16:10:35 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%5]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 16:10:35 +0000
Message-ID: <24dbecec-d114-4150-87df-33dfbacaec54@nvidia.com>
Date: Mon, 26 Aug 2024 18:10:30 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Andrew Lunn <andrew@lunn.ch>
Cc: Carlos Bilbao <cbilbao@digitalocean.com>, mst@redhat.com,
 jasowang@redhat.com, virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 eperezma@redhat.com, sashal@kernel.org, yuehaibing@huawei.com,
 steven.sistare@oracle.com
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>
 <fd8ad1d9-81a0-4155-abf5-627ef08afa9e@lunn.ch>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <fd8ad1d9-81a0-4155-abf5-627ef08afa9e@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::18) To CY8PR12MB8297.namprd12.prod.outlook.com
 (2603:10b6:930:79::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8297:EE_|SA1PR12MB8968:EE_
X-MS-Office365-Filtering-Correlation-Id: cf8b3a57-fdb7-41cd-48fd-08dcc5e99df1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1BLemRvU2dWOFJJalVwbzR1cGlSaXZsdUlpWkNKV2V4d0daaEF5alIxZGJl?=
 =?utf-8?B?YnhIN2MwSUUxMVlNOVBXZS9hNnRwUzhxaXBNQlBSSGdDclE3K24xSkFMVnV1?=
 =?utf-8?B?S09BQ1JQNUg0a1dqbVFVUG10cXJFRzlZVFBwdmtDUkVnNTVic3RLR1p1UDkx?=
 =?utf-8?B?d25BVUNrQ1diRjMweHNuQ1JTWTN5UXM2MXp0djB1SWRjS3ZrRmpOMkxSZFFO?=
 =?utf-8?B?REVWdUtjb2VzY1BmcXNsQml3YkpzTFhKdFNldHROQ3IyOWdjNVIwRFZzNDg1?=
 =?utf-8?B?R1J4ck1EMy94NWxodzFjT2hYNy9LdkRYQVNnZm9FL0FCY0R3UWxja1pOMGtT?=
 =?utf-8?B?aU5ZU1lYZXJqeDQzd1NDMUhqNW5VOGNBNUp2ejY5OG1YbDZlNmZnOWIxT3Q2?=
 =?utf-8?B?bjhZWTQzS0psVm4xUkRjb3RRREQyLzhDQzZCWkdvemN1cXhZMGVFOTh6bUtQ?=
 =?utf-8?B?dGl4dVdvcFB2S0NkcEFUbi9xT3hIM3BlVTY4M0FzYmUzcmhETFoycUZBQmx1?=
 =?utf-8?B?UVpNVnRuemh1dkM2eXhwL2lwQ0pwTUxWUG1GcDlWdlh4OEswaHQwZWJoaitN?=
 =?utf-8?B?M3V0ckh6QWdCTTVVQnphUlFOMis4Q1V3N3Q0dDJ5UENCaytpOG5VM2ZyODRM?=
 =?utf-8?B?am9NRWhya25QSFQwUXRjVDM1QTVkOEg1RTVkWE80VVh1WTBXQm1JWjlDcE5r?=
 =?utf-8?B?cEhza254ZlQrL3BhMWh4V3pZZkZCZExFajFrdm15LzJvRTh0UXpDMXFpWVd0?=
 =?utf-8?B?L094M2dTT05JMXNnam5vTU5LcUVITEFIYkZVdk8zVGNtaU4yeno1WnMvb0tM?=
 =?utf-8?B?dTZnTGdhU0czcXNDb2VNa2NsTGdZaVpldlVFcUw5dUtmbTkrZ2c2VmhJS2J3?=
 =?utf-8?B?YVhOK01aajBldUFoenMyRWw2SHRPR2tVWmtSaEZraDhhSU9halZETXZ5bThQ?=
 =?utf-8?B?RGRIVmlwaU8rZHhzOE50RERXcGwxUzdUME9MWDV5Qi8zdTExQUdtTkVkSFVF?=
 =?utf-8?B?QjNjNUhUKzZ4ems2QkIvdzR5c0RlSkoyWlpuV2VkclJxQVg1aGFIZnY1emda?=
 =?utf-8?B?RExhbkZIK3dkMWZSTkJ1UGN6RU5Ya0x6K1hpUW9MbGdidGpQRDBhcFZDQjQv?=
 =?utf-8?B?dHhVRFFoNGtoejdUV1JHMzFENHBBWEtmc2wyTmErTDB4VERxNzN2KytCNmZR?=
 =?utf-8?B?UDdsWm5TeXN6VnIvZE5CY1dnNlpnUjRWWnBFdVFNVXk1Z2ZERGhoMDk4QXl5?=
 =?utf-8?B?WTRnd2JNZk50ZW01MGw5SXRxVWRPUzFveFRnYVN0VXY4MXUzRWIwQWJ3dDNy?=
 =?utf-8?B?Q1ZhUlZyRWdGaFhwbFVDaS92VmRENlI3TmVxOGtVT0Jrcy9kSUtQYTZSRHVq?=
 =?utf-8?B?VlB4MnpDdGFQYjJWUHdtVGROTzRvREI4WjN4Vkw5YURUZWZObjhTTE9YK3Uz?=
 =?utf-8?B?UHJhRjZhOHBwemZ0YU9RYTNTNk5qWlNST282YnlQVm1zNGo1VEUvWm9JbXEv?=
 =?utf-8?B?RUZyYWk2cUJycWtNQ0gyb3pkVWU4NklQVVlNVUV2M05KNDQveFlrMExqeFNP?=
 =?utf-8?B?QUNwYi9SVGRqUHhFRVFvTzRhd2MxaGJSYjVZbE5VMFNWa2hxeE9hUmYzdXJx?=
 =?utf-8?B?YS9ubGJzSkZvalYyM24vbHd2eml3Uzc4bGdkRmIvYzZOTC9NSlJqMXVVOWNm?=
 =?utf-8?B?Y3BWd1IyT2J2OXJWME1zbENkZ3RyR2JPMUpjenFLWGRMeVRHaTJhSmFMSndE?=
 =?utf-8?B?ZDN4SUIzRVFZVUlWZkJQMHJhVVpVVjlmQTJiY2Qva21xUzZ0clAzZzNJaURN?=
 =?utf-8?B?RTdMT0FEcnZXNkt0RUNEUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUJSRE1ZdXpDWkphY1RXaVdYWUl6MjFIRkhvdWpoT09MdDFFZ3E3WU5PdWZ2?=
 =?utf-8?B?ZzUybVh2K1ZDa01QUENVRkhUTVFiRFZQY1ZYcitMNDdaZW50L3doZ0pXMThZ?=
 =?utf-8?B?Z0Vsc1JtdnM4N3QwQW1WV3FJdmxWSVpTQnRGdFJaRXNEdDUyS1RKWkFLdjNJ?=
 =?utf-8?B?MDYxTVRBNE11aGJHSmUwOHY5QlNtQUYyNnRZS1ZvL0N2SzBoVGZWVXgyRnNt?=
 =?utf-8?B?WmVBUnRkcWUwOXZ0Z0szN2ZKREtQVUJod1daSzQ0RjRraXRNQUphYU9XYmVV?=
 =?utf-8?B?QjNoZ2dZZ1FxMjR1U0NOaE1qODBlcU9VM2JEN2ZtNzlzclNyYk1nTHlPQUdB?=
 =?utf-8?B?TGtSL2hTaUsrTFpxcE9jbU5ia0RscHJYMWhzRkMzR0ZkdkMzbWhmZi82SW1m?=
 =?utf-8?B?dUZFTkNHQVpuYTlTRTRvaEl2bUN6UlNhU1d2T01zVDd5ajErWU9uNFRVQmFX?=
 =?utf-8?B?QlVBRlFoL1JvK01Mc3JpOVRiSTV2WWtSN2hZdFY5b1loL3NYYWFCcE0wU2or?=
 =?utf-8?B?MmVnaGdSYXhIcnBZVUtIN1JQWldEQytrQ29qRWVpMjR6QTlIbHFWZzBzbWRE?=
 =?utf-8?B?cHgvQlJ3VzJINDF5RjdTOUExL2ZKemVDcTBPQ3RjUW9WeHFaL3ZlM1QzN0hl?=
 =?utf-8?B?RUYrOVBVMnZSVXRESmdDWG8vdCt6dmNqQXZTak43M1J5VXJpcklmb0Ywb0wx?=
 =?utf-8?B?NEIrZklnODhqZ0dDVWYvSjdHU3NxckZNUGRCTlI4a1JLVlRuQmFGSXZEdU92?=
 =?utf-8?B?ekdLdi96Z1hTWFBMMHZTNVBVNGpNek5mYkl1bmxjQ0h0cTZzc0IzazI2R2NZ?=
 =?utf-8?B?WGZNV2cvMldPK2VaQWVPdklTZEREWjhkU215Q0twcDY3RVd4NXF1MU5jWlQx?=
 =?utf-8?B?ZmF5N0FMSXQ4a1FXRUxpVzdHTy95QkJXYUhIeVFDMUpPUzI2RVN0V0hlempX?=
 =?utf-8?B?TEc5dEcvdDF6UlNVTVZtQVBWWTQ4M3pab1FSUTZIbDJIenFpZDFET1N5UXdr?=
 =?utf-8?B?Z0dRRjhCL1pEUVg5Z0tnNUdQZEh4NUZ4RmtFS3RZaDdYbmw1elVsYU9LeE1v?=
 =?utf-8?B?Rkd3U0NJeE1NRFlKUzl2WjY0YVBubjcrWFgxNXljNzc4MmRMc2hmWmc1K3FO?=
 =?utf-8?B?U29hTEpIYlN4OGtiajJQNnpFL0poV0hSSUZQRFRmTWxibnNFS0p6cytDaTRD?=
 =?utf-8?B?MmtKQnZuUkxtaWg3L3FqaGNFS2JrTmVTc2JNOVZzQ2xhQjNZRjVQRzJJWW9X?=
 =?utf-8?B?YlhYdW1POEp4WUFDbjh4cGJUNDZDSVZzelhjZGE2cXh3Zkl0Y1A0dlZaSDVV?=
 =?utf-8?B?dFV1aHF1dTIzZm1oZ0dJamJNQ0p4MjVPUEw1TmVNSFRNMC94TU85b2pwMW42?=
 =?utf-8?B?YmpYRmtNeFJRS09FYzVOUkZlREprdVRjTmZuK0IrUGZkVXJwbUFnSTVtMkw5?=
 =?utf-8?B?U0VZT01LMWNyenV1L21HOUVQamV0Q1ZTTGJBd0JhTW11RVB5QThkTm5QSzlQ?=
 =?utf-8?B?NEhpTXV6MlFQMDkvN0RmTDdnL0t2c2FOTU1ib0dGOVNhRXpLWlB1OHNOMTBj?=
 =?utf-8?B?S2xXYngyVHZiMUkyNDF1QWI3dmZmU0VUU3JLbXdiV2FnWTdmVnY5bjlYNjJU?=
 =?utf-8?B?SVdraVZyaC9NN2RVS0RRcjRjY05ua2JHK25COGcwYjAzQXA5aW95MTlYQXZE?=
 =?utf-8?B?VlVwL0llMkRtZmYrZHQ2RGlGM291QXA0T1B1UVFHYW5zbG5pelhBWVRpQXRB?=
 =?utf-8?B?YzBROS9LQUJPSmhRaWxjVHc3Sk5rOFdUVXpqZkdjNlVlRUFvUVJLV3ViaUx2?=
 =?utf-8?B?NEFHM01vN1pJTmNnWDlSUTREZlByWkJXaXZKSFRRWTFsVG05bGRCVXJFczFR?=
 =?utf-8?B?bFBudTBlKzIzSmNFNnRVYmJRYkF5TytQZHpGOFE4akwxM1VqYy9ISTE1a3Ns?=
 =?utf-8?B?aVlVb25yNHJuWENGSUVRMGZZT3ExZFQ4SEMxQ3NuR2wzaWRic3pER1Q2ZGpF?=
 =?utf-8?B?dis5enFGYmwzK0puc0cwT1ZnTXlWQ1JLNjViRFlMR2NwMWJhdmt0NklBTTRm?=
 =?utf-8?B?Y0dvcVhHME1DN01ucDNyZ3U5SFBQYU5lNEtaTGhMSWRZRU9oWlEwa0ZTVFYw?=
 =?utf-8?Q?a5vrfqkGyk7gSLifdOHwCYGbs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8b3a57-fdb7-41cd-48fd-08dcc5e99df1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2024 16:10:34.9897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0a377c6j04nYueSflMGjWLU0tvpxJLiQ4trZ28Hu2vAEy21twr2etx44mCwKlSCcq4BJB6dZoC4vakUXVIDqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8968


On 26.08.24 16:24, Andrew Lunn wrote:
> On Mon, Aug 26, 2024 at 11:06:09AM +0200, Dragos Tatulea wrote:
>>
>>
>> On 23.08.24 18:54, Carlos Bilbao wrote:
>>> Hello,
>>>
>>> I'm debugging my vDPA setup, and when using ioctl to retrieve the
>>> configuration, I noticed that it's running in half duplex mode:
>>>
>>> Configuration data (24 bytes):
>>>   MAC address: (Mac address)
>>>   Status: 0x0001
>>>   Max virtqueue pairs: 8
>>>   MTU: 1500
>>>   Speed: 0 Mb
>>>   Duplex: Half Duplex
>>>   RSS max key size: 0
>>>   RSS max indirection table length: 0
>>>   Supported hash types: 0x00000000
>>>
>>> I believe this might be contributing to the underperformance of vDPA.
>> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEED_DUPLEX
>> feature which reports speed and duplex. You can check the state on the
>> PF.
> 
> Then it should probably report DUPLEX_UNKNOWN.
> 
> The speed of 0 also suggests SPEED_UNKNOWN is not being returned. So
> this just looks buggy in general.
>
The virtio spec doesn't mention what those values should be when
VIRTIO_NET_F_SPEED_DUPLEX is not supported.

Jason, should vdpa_dev_net_config_fill() initialize the speed/duplex
fields to SPEED/DUPLEX_UNKNOWN instead of 0?

Thanks,
Dragos

