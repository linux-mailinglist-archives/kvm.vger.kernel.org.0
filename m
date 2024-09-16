Return-Path: <kvm+bounces-26952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A3CC9799C5
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 03:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 719E2B2282E
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 01:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14D5947A;
	Mon, 16 Sep 2024 01:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hh9rx/gE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E5D4C91;
	Mon, 16 Sep 2024 01:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726449519; cv=fail; b=QQ8kivZ6JpKg9o2HCCyv/27urj+QrZ1B4GovVWbuA4q2B1jjOy6v3JO/yxKs/msZVgyCEAPx6NzBr18OXn4alMiZw/79+syvLC0chI79uIXQcQuqyjlnKwuLF/awfLW027mVcEyCrf4P2nG8YuMN3Nerrt00TZnlb3sCysN37Ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726449519; c=relaxed/simple;
	bh=qC1CS3rLV3UxRyYPejokyQaahM9VFMknTgKNyO7X+AM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vCX5egSrAUMT0AXKVbSly3rLBVXLpHzdRn8VH1fFFT/e9Uhmyzsu8HIkw1TKljVZvWt52VS5rRKrRbIcim045YPyssrd1ndK1jkEx1tLeUkwDJPa0+6MGIoCh1TTqWRF64p4uSikHru3vsNOycYBty3isVSVTw0/5rbVRj91SWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hh9rx/gE; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v8mmo47kMSNLTl99t2/xgNLyEbLzcjDQuVeJAwtg41wkJ+JgZ8tVHcFi7FtOEmRNIIdSa6nGtv27fZ0m8WaZc7j6bYNldrLgc4ugUnGAZlcZ5LkZJB033HTlOeza5OzgGEGUm0heHcGH2c1FlQeBTZ7xnN/uMmszX+0DrovwILamgZTXujzVccccDYnla9DPBUisQL2gWnKajaPwBkT8pgkV+MKXJzX32NK2plm3mvIteNj1NuuyRMyosN72wEU8X1v25fVHYKb3HqluD1BpK+yTiVsqvPxiQwkv4utQmLr/NwmhiLnUvP3nnIB1Tpo/VRrfE56J+oZE/087tM8okg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnNZ/Vi06VnhsDgb9Hl52vBsScNCrw5Ylvnprf9SBTI=;
 b=Z+latvhSZT0EZYTbpFuxX4YLYAvdZzKv/Hg2ysepWYAkN+6J8aGQvHs8jQBFQLZ9t+isHUZLHx73HCwcp6LXY9AEnPBXMXinAdRPeY/GCc5nU0kv2BC6hYB4dw+t4IZWmjnwQAE8gdABhzImJXg3p2+C83RvwZojZ6faZBN8VFRRPYDJNgvC1C371qOUXseOIZumIFSqkUVXtjvvKp3ZtYfsbopHDG/scOR56uoYT8L47sZfGgCS9uRLXRlx+bAn0E/TC09Kq7QEtnIP8giyzCCRQzADG6JNxqRbt/5cp+OyrmtF+Meqd6jUgqQsQ++iwbavGdZlBtOXYk+6nMwN1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnNZ/Vi06VnhsDgb9Hl52vBsScNCrw5Ylvnprf9SBTI=;
 b=Hh9rx/gEX4dzLOJiPD+wqeIz/X8IwFgcnl6RAfHd6DHHwWyrQfpQhiS0EflMat+L5arRtCVnu7/Gf4MPqR5LbEvfvtUn/0nHpjzx+RHz3AA3KmwyaGOhMGRLGCnOkgkvlqoJ03jkN7prQGz//19npt1wXgLJsisoMETJcyX3ymQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM4PR12MB5772.namprd12.prod.outlook.com (2603:10b6:8:63::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.22; Mon, 16 Sep
 2024 01:18:34 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 01:18:33 +0000
Message-ID: <ee88d342-4b02-4af6-9f08-bd2b612fb4f8@amd.com>
Date: Mon, 16 Sep 2024 11:18:23 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 17/21] coco/sev-guest: Implement the guest side of
 things
Content-Language: en-US
To: Zhi Wang <zhiw@nvidia.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-18-aik@amd.com>
 <20240914101939.000006e6.zhiw@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240914101939.000006e6.zhiw@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8PR01CA0017.ausprd01.prod.outlook.com
 (2603:10c6:10:29c::16) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM4PR12MB5772:EE_
X-MS-Office365-Filtering-Correlation-Id: d87bfbbe-b292-42b3-ac13-08dcd5ed7b0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RCs4V2hEQSsrSk0zZ3prK2hhZzNpV0xWUGJ6VmNVL1U1TC9lN2Q2WWprR3M3?=
 =?utf-8?B?c0txME82djc1VjJMWVd2K1dTTm1DNEpaZmI5UitkTktZN21vQ1BmOFFhcldw?=
 =?utf-8?B?Z1VpTXhGaXNHNWJCK2VDMzdaVjd1TFFPSTVtUFpuWGNDN3dpdzcrN0FEcVFr?=
 =?utf-8?B?d0FhYko4ZGZXNTJLcWc0Rnh5cWk3NGJpV3pjbzVxRVJrb2F4TEZjZzhoa295?=
 =?utf-8?B?NS91Z2grZ0hVem1OcSs0Q1BWT0ZpdWdxRVFSamdPTWdBQ1RoZSt4MDlzM3hx?=
 =?utf-8?B?S05pdGdqVno2YllLdnFaZzc2VldhYWhyZXY2WW42MUNJZldRVW5ObDV3LzZI?=
 =?utf-8?B?Mml4aWtQZlA0VlJ5cTNzaHpSRjlrM1V4NlVSY2dSSDJReTVSVFkzeHpLM2Rm?=
 =?utf-8?B?Ris4akJPMW5EZ3lVZUFENVdOekFRMFN3eFVidDBnN3JKSDNZVFE5WXNkQlY4?=
 =?utf-8?B?TndrY2FTQ2VDVlVGSGVsWGVQZ1lLcEVnTXFvbzlodlB3a3Q2MnZLenMrajIx?=
 =?utf-8?B?NXNlWEEwN2pQbDdSeUdWTW1ka1p2VFQ1TDdaQ1gzb1JWYkxGZjdIUGlxaW5G?=
 =?utf-8?B?MFdBcndFbTZsbEFwM1luejZiK29NVmNWTXRrREMxNWs3RjlOMzZzS0VqWUtI?=
 =?utf-8?B?Ym96OWEvdERqUHgwYWRTY2VOZzZnYUtHbmxQVnJ0ZS9ZREo2d0hDZzgzbDQ1?=
 =?utf-8?B?YmJYUW5zWGZEQkpIWUlIaWppNHFaT0UzM0VubE9oVkRLUmVZZnJuQ1lYb2s3?=
 =?utf-8?B?OGQ0Y29EYVp3Vjk5ZkJBdmIxUlhZRXBscjZHQmFpSDhmeUcweCtBaFRncU5R?=
 =?utf-8?B?Q2puUjlLampiblhkL0RwRnJYWGx0S3RLWVJ5R2J5aTBEN1g2SmRjdmxMVmJm?=
 =?utf-8?B?UzRlUTUyRjVveTVqYmF6U2dmWm82WWNhQ1NGWXBKVWJ1aVZnOXAvVzZpK3dz?=
 =?utf-8?B?amhwcVF6WVc3Zy9KMWVOaTB1SnY1Q29lbm44bTUrc0tjTUVKOFFQV1I0bHV3?=
 =?utf-8?B?aEFLZHkyZmRNUTNreUR2R0oxK3ZURGYreVZhTDZBUDZZdU5FNGhPQmtmSnp4?=
 =?utf-8?B?WG90aENSTmNtSmU2SW9xOHF6Q0FMZmZ0dm1MRE8vemNibHlSUmZ1OWU4V2p3?=
 =?utf-8?B?MFNycTV4YVMydlQ1UGMrbkg0ajB4eFR4VlFmTHVCN1M2L1JSS2VLa0UwQ1R2?=
 =?utf-8?B?OEJKVjJBQTc4cUtFYW5MMXhiUXNBZmdaRWNKc3lHU0tvcEpQbVp3RUhxcE5n?=
 =?utf-8?B?VXZBUmR5L25YbE1wQUVoYnVCdk5PNG9ISXAwRFNsVkRmcUdENXNHQ2x6ZDhI?=
 =?utf-8?B?YzlFeTg3Y3FIZkZ6THMvR21ZNWYzS1UyWVZDMk1VcDdIVkY1NmRaeTMyaUpp?=
 =?utf-8?B?bTVnRDdvcTF1L0FGek9YRS9QVnhlYnFyZWJ3NWlFZWkyWGl2SVJnd1V4a0E1?=
 =?utf-8?B?c05CdFdRaXJtai9QYTMxcDZaNzVHQ1hlSVR6aW5MczJaUlJVc1JKZXBFeTBY?=
 =?utf-8?B?aDBVVlNUa2dvQzM3Q0MzcjlPMWdxaGlGYllqV0o1YWhtMlRESWlsbjkxYkNn?=
 =?utf-8?B?R2NGaHhmSEFGbWtPMUZRSVZPUFBMcE9sa2JudVBvWEkyUmpSNm9lV1p3ZWEx?=
 =?utf-8?B?dTJjcmsrN1Z3SHJjVm5lZS9VazRDZEV5a2NyZ0g3ZDduOVp2cVovcU0yMm5V?=
 =?utf-8?B?VGRSZ3NwREpSYUdsWlpjMUE3a3JXa3FRYkJhY2t6cU9teldrMjRCeTVEY3ln?=
 =?utf-8?B?cG1STXg1a21YNGEzVDZqM3N5alRKRzdDOUg2cXRZTjU2YnFRWG51SHd0NVVE?=
 =?utf-8?B?MVFMaXZGMklCUzlJT0UvZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTRuenlSMkwvaUk3VFl1dEVrbmhRR3F2a1dtVmM3MjN4YW1veG9CTEZLZkZF?=
 =?utf-8?B?bVBPbTNjVzhrYVZBcnZxUDlwNkJGMDZuOVp2N2diNGdsSEtlcnZHS0I3anVr?=
 =?utf-8?B?Y2hSamE5TTRwcDNmN2laS01LaVpZY1VUNjZZYmJydGtpaDdOUHdmZldiSWha?=
 =?utf-8?B?S0pHQTBtVXhZNnRKR05EMURzdDYwb0RzOE5ueXhtblhMcHpTWDh6eWlzVzRl?=
 =?utf-8?B?cFl3dzdZQ2lmR0RqVXVaazBkeldmMi83Rjc2Q1lYS2ZiaE1IYUtqQXlwak92?=
 =?utf-8?B?a0dHTDVxVGRrQkllNmdMRWpmNTh1bC9EbEYrNU1mWFdDeXQ0TzAvZVB3d1du?=
 =?utf-8?B?bjVPaVZDYThOaFZ0c2J0a25nZkFqdEtQck95MEF0WDBBTEZvYVllVXNlUSs4?=
 =?utf-8?B?V3FkSmgrTUVhdVlDQ2xmdmZoQnpZSzAvclVvV2s4QldCNlVsckF1U3pvR3R3?=
 =?utf-8?B?b2RCTFd4N2FkZW9BVUhkWFdWNHBBd1diZDBLd3lFQ0k0Y0Z3UTAwVXQ5TnZr?=
 =?utf-8?B?RjRReE1JUzNrWUtMcWVCdXQ5L0Z3ajFqTTlGM2pLdWZMWFRDQkV5bmRyTjhu?=
 =?utf-8?B?aXdNK25qSVRwWlVFVmJuZTNlMmIvTTdHS1prcWlVR3JmNnVjQ2piNWtFNkZ4?=
 =?utf-8?B?VVlPOGttZTdPVmo3YVNEYWxmKzRyRGNTZGNHQmtraWlFY1hTRHlMaFR0OGoz?=
 =?utf-8?B?MC9YcDdZcExOazhOc1dWSzlzempxdEN3Wk84UFE1ZWxkYzlDcHJjZEtQNlNq?=
 =?utf-8?B?UDhocGYzVk9TU0RpNHp0MHprQUNKZVJ4cnR5NU8zS3BMTnF3V0JxR0dOVURm?=
 =?utf-8?B?bGx1Y21LTU0yT3M5d2hSc3A5SWF6UVJQYStRRlVUZHBRYUUxcFNTZzZFYURD?=
 =?utf-8?B?UlU3NWszTllZdTlQWmdoa2R5TEFUNTJUekdmVkZLMUhCWnBLVFVLRGZCSmRl?=
 =?utf-8?B?V2J0ZVR4WmhtRXRWZkVPWnZyaDU2SzRmUXBFN2NzVDZ6VTAvQ3NUcEFzOExW?=
 =?utf-8?B?N3VHRE9GMTloaEdFKzd6TGp4NlN0bm5WaEw4OHRFS0F5YndIam5tRHBxUUFW?=
 =?utf-8?B?Q3NDbjNZUGNzS3pEaUlPanVMcC96MGFLVllleHlnZVNzSnBMQ3d0NTZHajBJ?=
 =?utf-8?B?TExpZ2JLY24wS3VvZkpjaUh2SGpnQlcxdDFKYmFVTDkwMEVzY3dOdDZ1TS81?=
 =?utf-8?B?SzdLbjRKczBvQ0h4Ymltci9XOFpyajgrdzVYRXNLWTFCWVRrcStIVmVCSkxm?=
 =?utf-8?B?ZFR6TzdOSVlUczUrOW5ZZkYzeVFxa1U3VjIvSm5yL1lzdFgyQ0VOTDIzeGJV?=
 =?utf-8?B?b3dGSUV6MTJUQnd3RUZudUlodEk3SmFyaElWOWwrL0RCN3R3cE5XV0xZMGxl?=
 =?utf-8?B?dXNEVm5tT3JoYUJpNlJXbUFFZ2c3NnpBNGw3NnhHWUpZVE9rN2JGcEk1V3la?=
 =?utf-8?B?OUFOQ1doa29vUlNQRG9hUFdkajNFellVNVFsMThtU0VUNitDQndoWnJUY09o?=
 =?utf-8?B?b3g2VHBMQ0RlOXRHQ0JJNDNqTlAvdTFYOEM4bDlOK1pSYk1GWjJWbHJJRWRC?=
 =?utf-8?B?dkRnMVcxTkYwalhmb081eGdpdE9hM1diMTFnVXpqdEZMVlVqRzBnY2RKMDMy?=
 =?utf-8?B?V3A4TnZoWUtyK3ZSMmZBbmo2ZXpMRmJjd0N2MWJMYUF2WElRL2ZycUFRcjZ2?=
 =?utf-8?B?ZmU1eXc4QlpkRmpuMFBLS3M0eGgveEVNQ1NlZTZOZHViOEFJN1FrWkZseE5i?=
 =?utf-8?B?SkdoQWE3TEVHY0srb00yRURyWS9NMVZvMTIvc3ZkM0dWYnJoUXIzV0EvRWcx?=
 =?utf-8?B?ck9tT2NTblM2cGdxSzRIMHFpSFM3OXpTbkNCYXZOaGVjd1d3VUo4Uk1YbUw0?=
 =?utf-8?B?T1FQaHNMWnJLUFRRTUdnbEJKc3FrNWVSa3h4NlFzTnNWUUZxZ3V2bDFCbktE?=
 =?utf-8?B?eHV2dE5xdXpSblprbGorc1VvQW00UVRnY1ZhL1RIZWcxTHoxb0NEZ2VzMGtN?=
 =?utf-8?B?WnlYTW52VWRxTlY5YnNwR0RSV1ljVGNpMVF4RTk3dUg0VTg2eFM1b2J0Z3N5?=
 =?utf-8?B?SW15d0paSko0WGxLNTlZK2tJSDV1eU94V09CL2JvSkFiRkZLU3FqRWI0SGVL?=
 =?utf-8?Q?iajVv/0vFpzWQePX0hA8lIEgL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87bfbbe-b292-42b3-ac13-08dcd5ed7b0f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 01:18:33.2106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jZQIkYrYXq4MFtXBtTNX7GUkfuE6uOd6Az38hfEMDRdAGHflCajg/vkAR0HM3MssHz5WxxC4oPwdvTkDttVZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5772



On 14/9/24 17:19, Zhi Wang wrote:
> On Fri, 23 Aug 2024 23:21:31 +1000
> Alexey Kardashevskiy <aik@amd.com> wrote:
> 
>> Define tsm_ops for the guest and forward the ops calls to the HV via
>> SVM_VMGEXIT_SEV_TIO_GUEST_REQUEST.
>> Do the attestation report examination and enable MMIO.
>>
> 
> It seems in both guest side (this patch) and host side
> (PATCH 7 tsm_report_show()), if the SW wants to reach the latest TDI
> report, they have to call get TDI status verb first.
> 
> As this is about UABI, if this is expected, it would nice that we can
> explicitly document this requirement.

We do need to document the UABI.

> Or we just get the fresh report from the device all the time?

I'd do just that (and it should not really change as long as the TDI 
stays is in LOCKED/RUN) but since you are asking - I suspect there is a 
caveat, is not there? Thanks,


-- 
Alexey


