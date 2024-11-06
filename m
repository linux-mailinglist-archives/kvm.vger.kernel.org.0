Return-Path: <kvm+bounces-30887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6089BE27C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A161A1C22E4E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0046E1D95A1;
	Wed,  6 Nov 2024 09:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Oc4UVyw4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EAF142E86
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885256; cv=fail; b=r+Q+7SmmgDuAiBLt9f1vZUOxbj7YjHgiL9kWZmhBOeLVJnjEjgDXJdbOHPlYSIOBk3HuiTLxAoNm/reBYwZccrT+h2fL1BhdYhytJ2oYSZgvC7HLctwSIhxo30EvNB0cTCw1uJzhoDmiyal6e4BmSZyKJCSgMYTfhplbcSMowfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885256; c=relaxed/simple;
	bh=Hcd5ErRLX0/QDTw1mwC3FBnJ4UpElPlHK3kV05DjowU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aIdKtb0/Bo6pHzrOmgWRl3RITOiF9FbOf32PUDw1Q6fl4MMhGTw5joCUGm9yofppMKOBRRELcw7JrVhGEjXciTVyG6Vcc2/vNXXgH5EFgThAGw6xamuMR+/570ciS+WqVgasekFvthfIO3vTyj1EffKMUHm1w+jKx1a/ZS+0XV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Oc4UVyw4; arc=fail smtp.client-ip=40.107.93.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IpHbicMyhyd19nbzo/eS2QBopVX5gUfVjZlr+UdX9dAFS1livkdJjkZ51G9WXOe3tBeZM6DdTcrQWwFqGClms39EfD6qfwT/CRxaoe06HtOD6yQgSQMUadd1NCc268lcHwx4r1sxTPjdGpYqDIbKn7jmDtY2h8vr6KQrYwbR0kyidh9WVap8J+HFkF9hiuWEHIZjD3C6fJeoO4p/IGggFXP5yUKHt5rRPoA9408/WiHHov+wbt0y+ioqGJ1vayTPQyWwLe7dZqWD7AWCg5/RR7ZL8XEthzr6TxSP01j4LIRPTucA7jOrMMmV2h5SGJYyNzT4yhuPidfalSysfEehDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FGR2BjAiuxoFTeyJ5rZ4poTRi1vybjxL3Q9p5AT+CQ=;
 b=JybCS9UgHicMZm2RGloETt3XY4UNvrQnBcULxkES2kHk80ErLYVsB/GJXhJd6chxBc9OVBsfTrVa9jgGslj8crC9SAVYXiiNoGn2jRJuEFJ4Kgm1D0Vi9mzunqetm2iltQC6AXTyjAUo2/mS+NMNXmtAXL0lQLxOIhsfRVtryAeTOzdM0L142OJkgYXkRM7DTEMZPglewzQpUFMwmgJG7DYOdjLMgU4v0hYQGiYnfSuS+Z2ogtM/BXfJ8nI1+mNTJX8Kbu7EX43Zjtf4qVsZUzbXQH2mnha0y9zi6BC3AzH8N1u3+UKtLqb2g16BQ2tN+P1T6gWr+Wgo942xUGHRGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FGR2BjAiuxoFTeyJ5rZ4poTRi1vybjxL3Q9p5AT+CQ=;
 b=Oc4UVyw4ZyaoTGmNofZEkKfVvN1DNbjIGpVqYzZtx72e5jKyc3uIfjhgHbfbBGT4iX3qtNaPf8WT1zKAPnZxMOX6kVClP1OpWTJmn0qeZQEV/EfxJnTeC2a27sl2dcsF16NX2L5P9HZUjdOHwrLKOnxU9GOD9IylO2N8qylq3l4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH8PR12MB7109.namprd12.prod.outlook.com (2603:10b6:510:22f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 09:27:32 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:27:31 +0000
Message-ID: <11bf7ad8-b40a-4e2d-bb1b-92829dfefbcf@amd.com>
Date: Wed, 6 Nov 2024 14:57:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] iommu/amd: Make the blocked domain support PASID
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, will@kernel.org
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-7-yi.l.liu@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20241104132033.14027-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0086.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::26) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH8PR12MB7109:EE_
X-MS-Office365-Filtering-Correlation-Id: ba0fd4fc-337c-4607-0ce0-08dcfe453d50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTF1VGhTSDEvOVBidWJrREVrZlRscHdTR1JQSjRlSkM5bzJwUUtCanNpZkdu?=
 =?utf-8?B?VGN0MnpwRUJTQ0Q3YlRTcnZEaENkRnlKdjBWb3UwNVhnTjZVRG1QckhLd2Fz?=
 =?utf-8?B?eHJuQS9VS3FYTWZKNTNoc2ZWQTBURG9lOHNJZUVJaXVDenROdE9RS1pYMDNR?=
 =?utf-8?B?UXR0bUVIaWloakQ2dVJydGRVcUJkOTRONVF3QTIxbVhHZlFUcHRKaDh5dWwz?=
 =?utf-8?B?Q1VaZjhvR0o4V2h0WEtqM1dUK3g5Vytzc2ZJVzFEd2ZwdEhxTC9sUHFUSHdP?=
 =?utf-8?B?Njhla0pyQXVTSVlMempCcmorTWZ4blhJSU0xc3MxTWJUcjlFNHJ1b0l0d0VR?=
 =?utf-8?B?dG1scXU2cE5Vd24xc1JROUtNb0xBaHNaRTdhckRrZktYNkxVZDRUZ1NHMXo0?=
 =?utf-8?B?a0NlcWQwbTJuVitZOXlHaG53RVhRVG5MYU8yMmhtSVpwaWdoQzlNZWwwSHls?=
 =?utf-8?B?aGJkQVM4aDluZVVDL1ZjS0t1U1BiSHFCQjdDeUhCdThmbzFXYzZSL05EQVJr?=
 =?utf-8?B?aGdoWnltRlZiQTdzblJ2Rm5jODBDWHlqQUgrMFBxZUFtMWZya0tnZ0Y4Qkxq?=
 =?utf-8?B?N0llWnRkWWdIVUVOR2VOUlJEWnZORFR6YW1rc2Z5QkdBNVhmSXIxRHdPYXdt?=
 =?utf-8?B?NW9uMFNoSUtXWHN3MmdqektSMS9VWjZhaXBGU1l6TlQySE1ZbGFvN3pjcEN0?=
 =?utf-8?B?OTJpT2tURDFVWXNBQm84eVVwRCtpRVlHNnluaTNDUmFSTkYrbE1ucnBmMEkz?=
 =?utf-8?B?STlqY2tLSWRnL1FIaVkzOUtjZ0p4MHNlc3dwZkt6ZnE5U3UrWHZaN1JTak56?=
 =?utf-8?B?YlpQVkpGb0RrRU1iclJLamgvQTNRdU50K1EvSVR4SGhmZHBhYk5jZkR3MS9I?=
 =?utf-8?B?eS9sK1BJT0FCcjhUS0tLSmw3U0ZjVzllVHE5MU5sWlBIVjVNakxvRk5VMnpE?=
 =?utf-8?B?bG5UWWZzTVBaaXpQTFVEUkp1UjNLa0xEamZWclRJYmsvTHZKU1VuWU43Zzl5?=
 =?utf-8?B?UEpXcElhdHp5cjhtOURoMG5oSUtjL0hqRmpjY0RzWWhlTVZGS0VqZW9mUEdK?=
 =?utf-8?B?RXpkazJmQVFyS3VlQk1TekJWd01Hd1JRUjYwWjRjZUI1RVRZdnZ5aHFUNkZu?=
 =?utf-8?B?MGZDcGtIRVgxTlF4L3lEa1NNRFFyWWppMCtNOXdUUUlmUjFMM2ZXaEthS1Bv?=
 =?utf-8?B?UkNBZyt5ZzB0MlcvU3Q5S01qdkM5TlRDaUV3MXdKWk1FQ2EzbTNMQmZIaXRi?=
 =?utf-8?B?ZmVkSWtwRW10TkMva0F2d1l1R2NFQzlWUXY1WERLdE1CRXdZVWxkMEVSVU1y?=
 =?utf-8?B?THFkMnRQZlZiOEh4eTZLUVhnSTM2N3RVbW5aVUg4NUU3Sm1QWndlV2NQd3RM?=
 =?utf-8?B?dXFHeFM0SWhLVjFCRkIwZk1KalpEMHozOGFxbjgwdnlmc2lydDBhOVlPSjNW?=
 =?utf-8?B?MUE3L2VNTmN3bjZEeG9XTWhHeDlueHhvaG1rMWZmQVB6MVFpcWduQzRBZ1Iw?=
 =?utf-8?B?YTQvc3lGdm1iRVkzRlQxSEdBOWZxbFdiTWs4N01BdFBwSk13cEN1YjlmSnlM?=
 =?utf-8?B?Z2RMYkcvL0tOcDRyR3ByWHRCTVliVGM1MVFNUEFKMmtZc0QrMnVabjc1MVVl?=
 =?utf-8?B?cXFTUVBYcWpKR1U0UU4rbTMxRFV4NEdDaVdCbjJtbEluOFQra2NjR3BEcEFi?=
 =?utf-8?B?WlZySGE3N29zVUJsVkVJVXdZdS80cFpnaFFwcUxPNTN4UE9OR0FqSVVaUFM2?=
 =?utf-8?Q?c8bOCtQh+qk+Ya+0h8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFhEQVg5TUgxcmxOVlE3TllISVlWTzJuMlk2cEpkQ01FUFNCbzJPMjhYdUNu?=
 =?utf-8?B?NExjOW9tQWxNdGxwS201RzhteXdXTFZOQXhnc1RIQTFGby9UTERYWHFYcVE3?=
 =?utf-8?B?TzIybWs3QVFTbDRvTzdxQVYxN0JuRko3OHNoK1RNZ1RWN1Jmc0FUZXdsUDZq?=
 =?utf-8?B?cmczMFl0cDNCWlFId1RvMjEwcmV0QmxSaUNCQXFiNzYrdDhmMk5jckRsQ0Y2?=
 =?utf-8?B?ZU9RQjVmVXpoNlhVakc5c2lEMWNkSmYxMkt2MnYwSERTQnBHSTFpaHlSUHhM?=
 =?utf-8?B?cnNOb05aK0N6aStMMll0aHZSNFNYZnFORHBKN1hMWVFqZmtGQW4rUkJac1FV?=
 =?utf-8?B?Y01td1Q3bDJGM1JKT2orRHUrMitlNFR1R29NKzBUcHVoZ3N5YWwxQVFaV3Fa?=
 =?utf-8?B?K0dFZEZKbWxQNjFrVG1yQXFkT1VMU01ubk9RdVdXS2wzRHU5am9qUW1McVVy?=
 =?utf-8?B?cS9YbE9FQXA2ZWVhN0xZU3lOOEV5b1B6NEU0VEw2SlE4NnI2dC9rTmpDck1i?=
 =?utf-8?B?WG1IZDBXVlR1c2dVaGZ0N0pOTU9raE13RWpqK3ZoOFdFeWEwOEpjbHU0UWYr?=
 =?utf-8?B?dFdia1owT0czbGFIaHdMd0IyR2lGTnY0MVVpK3BFdyt3YTIvZ1NaZ3RUV3dH?=
 =?utf-8?B?dXpuQU9reWJKSDgzTUtDK3dhckIrZzVmSXNlSEpXZGhSUFhRUkhBczhjMlBv?=
 =?utf-8?B?WjlUbHUyM0d3cjY0YjY2d0xlTlhhKzNINHR6NElINzJXaVFFT1dSNWg3OXN1?=
 =?utf-8?B?aWFxOE9nWnIvbURHK0tuMW93RVhxeS9TV2twcEVQVEZnYXRIbzlMUCtsL3NW?=
 =?utf-8?B?VWh0aEQ0aUcwTnN2WEhtUFlLSTh4YXcybGVoV0R4UEpCUDlaMFJlYzVjMHEr?=
 =?utf-8?B?WHowQy9Menc4WDVZbERuRXArU3RXdVFaYWtmWnNUV1hJRjNkR1BXM2k3YzdZ?=
 =?utf-8?B?U2x1eXlDTkd2WlFGSFVqdWVRZ3dLaU14UVQ3R2YvMDBZejkzUXVqRjh0WEtG?=
 =?utf-8?B?MmJ4dWZCYUpYeVRqZ1BjS3E1WE5XTnJyR29pRC9aSm9xT0JSUUVpTll4UGQy?=
 =?utf-8?B?d29aMDcyOU96QjllUTBzV1dkajh0NGdnZlBCTmR4YTR4aERQK0VPZzNsSTZS?=
 =?utf-8?B?ZElQZ3ZJSHdVcTZCS3UxTllVdFA2UFc0K1FON2lEb1B2aUp3ZnZaZGZ2MVdS?=
 =?utf-8?B?cUpQWTlOVm1nR3ExOGEyamczOFc3WXU3SzNaRFRRdkc0eHZQMmcySFZ4eWhl?=
 =?utf-8?B?MEkxUTNoRWpZd3BrQnlXbVFteGZyOW1PUW9qMUppY002dlBJL3RPMkgwblJi?=
 =?utf-8?B?ZmdVaWFaNDhoWlZUWnUyQXhTYmhsWVJ4cFlYd3FmRktoN2lHSHVzL2xSeHJu?=
 =?utf-8?B?RGRueU00T3BPYy9NOFhTOHN0b0cxTWlUZ3Znanp2eEc2dFc0bzlKUjk3YWFz?=
 =?utf-8?B?QWVTSURsazRwTGRWbCtEZFJpWWwzc083eEpIcVFFSzNHN0gvdjIzOUs3eWhQ?=
 =?utf-8?B?UlNWeXk4UWE0aG9KanYvL1o3emkvR1VVaG5VaE9taG9aNXRibzlEUnk3ZHht?=
 =?utf-8?B?MVhmVm5uejdvTUtsSUc2Q1JWTC9hOTdXQlY3dVBhV2gzYytRUnRVUHVsU3F6?=
 =?utf-8?B?bm9qaXE1T2hxUkwwNVlQeHhkdmVGUHlFNXUxVU8zZDBPSUc3TzIrRXA2ZUU1?=
 =?utf-8?B?K0JqTEhHWFdSbG9Bd3pqMklyVWVjd0gvVmVQYk0yN0dRdHAwOVhHZEdCdGtD?=
 =?utf-8?B?RC85eWNESlJDSi84ek9rNFU3encydk84K285VkVoRVoxN0NFQ3lkQkExSm12?=
 =?utf-8?B?Y1A4WnNTSjdMZ3RHUmRNSjNJTkNQeHdxdVR6UHZnYm9QbENXNUpoMWRnR1g4?=
 =?utf-8?B?VVJaSCtaZ1NGZVd0V1hVS3JrZExjWGorbVh6VHlwdlVaWVBUWWh0MGFtVWJ0?=
 =?utf-8?B?b3lVWDFtdTFBN3QzL2cvakJ5NENJYmVGTTMxWkZrQTF0M0VKcy81MW5sbzg3?=
 =?utf-8?B?MEJENGpWR0g5TEc5cVAyZ3FaYll0cnBtaHN4TDJENVRFNnhtYk5iZzlhalY2?=
 =?utf-8?B?bm4vWjErRHQ2K0tsSFVTWDc2a3RETkhVajNYSGMwV1FtakZ0Vm5ndndickpF?=
 =?utf-8?Q?VeYucXFHHrJKjdvDUOhZ+OWx2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0fd4fc-337c-4607-0ce0-08dcfe453d50
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:27:31.8154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1wOsfuPDOSYNjaeX3GE1Ofp8EZgXxk+nvMu6/c0j9NihW0ayOD2ETNJFJmoNCtWyKxi9iIkPR1W5pbZDtqV3bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7109



On 11/4/2024 6:50 PM, Yi Liu wrote:
> The blocked domain can be extended to park PASID of a device to be the
> DMA blocking state. By this the remove_dev_pasid() op is dropped.
> 
> Remove PASID from old domain and device GCR3 table. No need to attach
> PASID to the blocked domain as clearing PASID from GCR3 table will make
> sure all DMAs for that PASID are blocked.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


