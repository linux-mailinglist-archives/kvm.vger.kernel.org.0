Return-Path: <kvm+bounces-40682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DD6A59A2C
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 632A3166D2F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7700222CBF5;
	Mon, 10 Mar 2025 15:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TgQe9U6d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD062206BE
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741621184; cv=fail; b=OkUBP2S4EZVactRuO8A9YpyvgXqAWdE0NjP9jBNfyHbmmrRz86WBJ3ro5iKo+SMtfznNpUHjOYAn7PKcLylDBipDo06U6mbi78tGsc1gsGjRRa/wG0Jy3mr+FR5x9eQClXNFVELGVDXedq4ZoEIvIst7aCFLwgbNvU8LyurQ1u4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741621184; c=relaxed/simple;
	bh=2Z9KpynK+9Tv6ljLykm6CiDWVSSr6aayKcjIcFDvbzE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U3cDyAIhEMyzucf0tn6GtpD5uiVL+WyMAZWlYPZ2W7sqLIaIBy8QEVjPQrekeWaUsweGVf28cGp0mIjNhwI6UbLbkYmNqWeEOIch4yW80NDulNe6ZGOfE9MFikj92SX8ikzMx52jX2/pclNrz9BWwmFl2oJsgKpTDMpKmOnixtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TgQe9U6d; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXewamWNM51F9x8VqPqdhPUFGPr4AX++scSmY4j6uBJFNT1dNn+NJtai8w+mUVP41UPjOdpdCNa/3NxcV3XcKCRMt/058zWqzB+blVx4wEaTK4YUF+a9BgIJqiOFpFKzxlan3ePv/VE30XuOIPtkKVdsgpEzbIrhY87yJKWQP/9Dsi4lMBvuBpEe4d7qm+sgZJr1TPSdSUKTAdJFPAznBS9HKOpi+6XDVEckM9vFS8UPRbKyrj94MLknf+uf4ll1xHv6XZauLwleWIs/uIiCd2fuQ1xieuGq04LBOtTPg4Z49jUANKTY1CoKxWXO9Du47DexKf13j/shhawiwDJitQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3T1ZQ0icmiEy55jUhGyKDK/7+omC8AH6ncXUBrWuZC8=;
 b=XZXZThCtteHbZKZ55r1T3hkEDxlPquW/9TRlpERPP2tF80T0jQHGcKdlvi0S/EveSBxL/rmq1SXchb9YrIMYAkrXIXXOYxlJ/zAzwlk3oOFXyodY3jv9qQeiUBUa0kI0yPOldbDf4cVmwB/KjDnxukrVaoeOveIHw4IvfRMKl20W39Y3328bxhVuiB/lj027C5G9fmaxdXdoIuegISf1utGd5L9N2kQmWcuNwQr1KZUx784GTwH2DlE8Tk2XDyS1oLiub4gMKCgEBuBeU/+3mtWTu7AcGiSDYSwH5A/TMTvnz4zGzBs7jSIWJ3Mh6hZROnP1UQef0n0X4Bo2C6ucPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3T1ZQ0icmiEy55jUhGyKDK/7+omC8AH6ncXUBrWuZC8=;
 b=TgQe9U6dV3e9Ikh35l3u+4uuyd5f/DsIyEmvxTWqmZ+0//UevoMsz8X/JmBICYbclEOL/lv9y6gxYVV9nSK5ApRXOqKdQhHIeSzVNkP7YKq/1LVBZz3rveIf4xwTc+sSkB7EF8rKo7U+jRRFDJby5VJYsTKZXxIDgc7n8YBdWK0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by MW4PR12MB7119.namprd12.prod.outlook.com (2603:10b6:303:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 15:39:37 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 15:39:37 +0000
Message-ID: <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
Date: Mon, 10 Mar 2025 10:39:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-4-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250310064522.14100-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::21) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|MW4PR12MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: abfe6be9-6972-4de7-4864-08dd5fe9c3af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0tPSE1pK0lxdi9sRnFnVjRxS3pOVEkwZHVmT0JqTlFmQUM4YlVJbHpzL1Jy?=
 =?utf-8?B?aG1YOWtVWmVUMGp6S3g4L0k2U280WVNjZENTdHZZVnUyUC9RMUVsbzk2Tmg0?=
 =?utf-8?B?Rno4dnVSRisveEJtWWJ3aC9nK3FQVVNlQndWd1NFWk12Rk5qK0JqOFFoWmxP?=
 =?utf-8?B?cTR3bXQwVXVsMFlsQW83VmRONk9sb2JZWkl2Tit4Z3laNStTNlE5WmVGa0NR?=
 =?utf-8?B?QklOamdyOWY0a0xyNkJkaSt0NFE0eWtobG8vV1E0aUp0Z3NPRTA1VnRFWHVU?=
 =?utf-8?B?TWpKOXgxQmxsdWhpUVBtRmd6K2FZM3ZDSXlrcWtzUVFWeS85aVNNWm9MR1di?=
 =?utf-8?B?TGpDRDRQSzl2UW9WYWlSMlFrRkhxdHdpTzl5ZXFMc2hIOEJVMkYzOVpEVFRY?=
 =?utf-8?B?dDdRSElhRnNjNFVNd1BPWlQ4SjZ4UjJpZ1ZpQTBWZmtTVnRvbG9tV1BuQXls?=
 =?utf-8?B?dnhvRkJWSm8zQ2QvNnNabWxhSkFRa1RSeTBieFh0eUVOV25GK1RWYnBNYlU5?=
 =?utf-8?B?ZFRxbG1xZWN3Zm5GaE5EQlVKUUJUS29TUFVUOW5XUnNocFdZYjhoZVc4azEy?=
 =?utf-8?B?S1FoYXVzekxCSnVmYjZqYlljVHlaeWN0K2E1RmFveGw5K0lwOXdWRFF1RFVq?=
 =?utf-8?B?NTBPYnA3SUsvZUwrZ0VnTDhGWmN5VUd6SnVZWTN4RDlMQy9nWlR5RDE4T0dj?=
 =?utf-8?B?YUNyZUtuR3M0MU1DelFDWmh0QXVRZXBQTlNZbE41L2tjcEY0cDV4MTZ4VFho?=
 =?utf-8?B?TStMaXhYM0pYRGVQdW9hNGx4MzAvK3VuMlNwZDYxSW5hdERQTGl6K3crWkMw?=
 =?utf-8?B?UnJidEdIaUxuQXlXU08vcldqM2czck9HZWZoNVhsb2kwT3FGNFpndEp3WFRV?=
 =?utf-8?B?TUNSQVFWNjVwTURSVldCc0k3OXJOZUZHRXFmeURPc2JXK1VqY1pGbzdnY3lJ?=
 =?utf-8?B?cnJGRkEyd3laWmhwUyt0WTlVNkowT2ZxVzZpV1NhUm92elNFdDE3eW8vQ25l?=
 =?utf-8?B?Zm4yWTVoTUFEQkhwb3pDMGJWWXpJc21Yc0JGWDVtTUNXMTRweXZKeG44L1Zm?=
 =?utf-8?B?VTQveHBseDRtbzFJNERFNVovRFp4NnRZaW5ucjdDWm43Q3ZHa2UyY3dZRDZT?=
 =?utf-8?B?Zm1rdXQrNFJQWEhFV2RkV1hyOXY3TXdkSklncWlocStnR2V4d0tvclZjMzFO?=
 =?utf-8?B?Vy9ISUQ2Qk5iaG9LSkQxZ1ZuUlh6d3BzUkNaL3paNElRZXdzZnpMYm5UNys4?=
 =?utf-8?B?YlhuMUpNVnN0b0E1em9kRTlpb3FjRjgyOXRmYWlCNkNBV20zUUFJQS9LYVVG?=
 =?utf-8?B?QTM4ZDNmbm13NUR1M0NOaUI0NlhXV0g1QVBxQTBXbm9EUEpuZ1A0aWFycUlX?=
 =?utf-8?B?L2xlcW01UW9JTTQ4OVJyTTNsaVNVemVrbjZVTXgxaStyM3NDcUIyZFcrOFN0?=
 =?utf-8?B?WGVUU3IvM2M3S0N3TUk1K3NLc0pySmczeDRDMGVSZG80RVJuQml3VkdYSmhU?=
 =?utf-8?B?bjdaN2lzS3R1VVN2VjhWLzEvbFJ3U0tKNlhuSWJ0aDFBdGVVTGxPdmpHMWhk?=
 =?utf-8?B?UGJJME1sTDlEWlIvYWZ1VE5ZaGpVNTJxd0xiSFdaRUMrNHFJM1ZPaGRnb3ds?=
 =?utf-8?B?aitubWFkVjh4Ty9EUkIvN09XWDNXOFhmT1FKZkpudDArcDl4bmFmR1NuQW9O?=
 =?utf-8?B?dTVVQ2w0TWY4TU5JK3kzRXBXWjNELzNiOG9lVEtDRW5FamtZcEV2ZkpZMzEw?=
 =?utf-8?B?NHp3K2gvUTVyRWNUZk9iUUdFdUlkelNLTFdibnBrWkFvWEdxYTBWTzdmc04r?=
 =?utf-8?B?UjhaekpsWCtSajUraFAva2M5d2k1TFlhdWVRY2NCTHZpU0F3NjVYbVRLY0hM?=
 =?utf-8?Q?y1DYeoGsOFoP5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFBSaVBLc3FLbytXL08ybEY1V0l5WWdmVWNRam5PL3pCbHFsTHRCMEJqSEIz?=
 =?utf-8?B?N05pV09nZjd1aFhmcE1JaFFxTjdhWTFUVXJEa3ZmT2RPTDZ0T3N6NnNaWmFG?=
 =?utf-8?B?TEhxejhoMVNUc1ZnVjNuRVBiSWx2TkRLSTBBRSt1bWdxcnp2MEpNT3Ixa1pE?=
 =?utf-8?B?ZWkzVlNRVURrb0JpeHR1c2FoeG9XK0ZMQ3JtOHNyNFhmcmdGbW10VkVBSi9B?=
 =?utf-8?B?ODFINTJVUEF6YzN3ZGUxWVUvckJGS01kdmk4RnU4SDRINkRRQ3cvTnQzUGNp?=
 =?utf-8?B?N0JjaUdvTXpNaS9HWXlZWFZNYWloQUJQMysvUUtRbHkrVC9IbWUrdlRHMkx0?=
 =?utf-8?B?b3Z1NEUzSmE5Qmo1OHdpVUQzZUpWQnJncHNyMnY4RmpXbUxUdkFpMHhmaVRJ?=
 =?utf-8?B?R1RoMWtQZ0hEUDBFTmVsbUFDSkpnNnVwc011NzhvU1YwZ1laeFdzMVFFT01u?=
 =?utf-8?B?OGFqQTBYTTd4a01NWHZVdVlrMGlvT1RoQko1eWxqREJxanJ2UkEvdWhSaENS?=
 =?utf-8?B?SjFaUWxQQzJpcWFTM3kvU0dCODdUZzdId2VGUXRqdGhDVnJ0RGRMR0VEN2d4?=
 =?utf-8?B?dEVEb0psb1ZSa29UWE9wK3FwUlIxRkFwODhwci85L092YkxuNmtqRWkwVUxD?=
 =?utf-8?B?eUFCYW1RM2k2WXc1Y0hBTUtmb3ArWi85aWtmQUdWcW9DME9CUm4zVWdrZGNm?=
 =?utf-8?B?a1FWOTA1QTAvS2hwZ2NRTG1ybFNzZE5GeHNnMlRoU25IN1YvM1pHbnJFajE0?=
 =?utf-8?B?R1A2UTdKVEdGajJIM3NxQTcvM0x3NHJEWXMzZVR4NWdhdks0RWVoTTNrdUMr?=
 =?utf-8?B?Nm5ESFdndDlxMSt2Uk5ucVQrVUxlM01YQTFKaHR6cjFGRHRZYlE0dFhDRkFQ?=
 =?utf-8?B?Vklwa3hlSDU5anB1dTZSODllWnhzOW04cy93MmcwTER0cmVIZUFpS2ZydTEv?=
 =?utf-8?B?eDdEV2xxUFBVUEVtc1ltUG5mek9WWGh0My92YVErMzI5WFEzdGtjNGNhMElM?=
 =?utf-8?B?NERkWE5KWTI4cWFneUE0MjJmM3RsUUVib2hxTXpEODNnM2tjZ1FrcVcwZUtm?=
 =?utf-8?B?RWFmV3YrZU90TVQ5V3hmdFN6RWdIS0dnZHhKcCttTXMvMHhhanV2RVlBY0Fa?=
 =?utf-8?B?Y3p1NVFXVXEybjhyL3lHTHVsbW9QY1VJeW01RTdoS1plQzlxaS9WWHdPV2h5?=
 =?utf-8?B?K3FGeVFDVlVGTkRYRjI1SmVRNVJiQWRSLzkxZHVxNDVXZzdxcEo1NFdrenNP?=
 =?utf-8?B?bHZ4QTMrYjNMaUJrV0FVem9kTmxKM3l0OWxBZHpLVG1vVnNtUStrZUVuVUFk?=
 =?utf-8?B?Mms5MFlJN0N0ZmdRTjBMUjVNK284MlE1WUJydWFXRnI0VllOcExjTHArVnFy?=
 =?utf-8?B?aUF0dUxqdFFlVHpGcFBDbkZFUmo5QXNsemF0RGRrdUxaMVhTYmREWGJLZ3po?=
 =?utf-8?B?QWlwQm5JdjVKdmd3NmJITnBxeitlNzZQUXBuSHYwL09WUjB1bGpscDluQkV6?=
 =?utf-8?B?Tmd5dUdlR1dOd2FOU1BxTFNJcFlEUUUvcUZaM2NXMjhvaEtYOE9KYkdldUM4?=
 =?utf-8?B?NjMrVzArNlpUMGZwMTBBalFmL2JyVWZRUXg0OVgwSHJqQVZ5T2RQdjFYTzNJ?=
 =?utf-8?B?RDVGZ3BTWHR4MzdkZmNuYlpGYjNoRHlwODgzQlptczhkb3lsLy9GdnBNczJN?=
 =?utf-8?B?dnZYV3hMeFhpY2FyNmJZR0VRL0JONEhqcjBVY1U2eWJYRDc0SDErVlNNSEtv?=
 =?utf-8?B?a1NNZkhrbmYzTnk2U2pyNDJqaCswb04vMHlUUTMySVZCTlorSlM2bDZ6YlZn?=
 =?utf-8?B?MTdVZUFHamV2N3Zaa1pRWXpDSTVNdGd6azduaEkvV2xHTi9lbDNZZlkxc016?=
 =?utf-8?B?dS8xWjVkSDVFSDZCNTM1T1lhNmJDTGNQUmVQcWQ5ZjJMdWRoeFBmMVpzK0Nw?=
 =?utf-8?B?cklMZEZhbXJDV1g1RHFyU2Jxbm1zTmd4RDNiVGZZNHg3bm1YMEJrOVd6OG9s?=
 =?utf-8?B?Rm96aGhEdzV2QnRySVV6clMwcm43U3ZkVFBzNEdyL1hEZVBnc1VCY3VQOVNE?=
 =?utf-8?B?NGx1bnNIZ3RRYU1zMDFQZUtqcXJSZ0d6Q2NDb1FRK0Z2L3dGWHh5M0NLUWNp?=
 =?utf-8?Q?kyCtzoxzjU2GzMnTC9LilciwQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abfe6be9-6972-4de7-4864-08dd5fe9c3af
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 15:39:37.3543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skJevOJER5kDVTry1cBB558ko43gInL22yLaJg6wRUXcDaKy6+YSFyQACcPPjlOstQ1IScu/I5qFz9lhUgei2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7119

On 3/10/25 01:45, Nikunj A Dadhania wrote:
> From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> 
> Add support for Secure TSC, allowing userspace to configure the Secure TSC
> feature for SNP guests. Use the SNP specification's desired TSC frequency
> parameter during the SNP_LAUNCH_START command to set the mean TSC
> frequency in KHz for Secure TSC enabled guests. If the frequency is not
> specified by the VMM, default to tsc_khz.
> 
> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  3 ++-
>  arch/x86/kvm/svm/sev.c          | 19 +++++++++++++++++++
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 460306b35a4b..075af0dcee25 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -839,7 +839,8 @@ struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
>  	__u16 flags;
> -	__u8 pad0[6];
> +	__u8 pad0[2];
> +	__u32 desired_tsc_khz;
>  	__u64 pad1[4];
>  };
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 50263b473f95..b61d6bd75b37 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
> +
> +	if (snp_secure_tsc_enabled(kvm)) {
> +		u32 user_tsc_khz = params.desired_tsc_khz;
> +
> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
> +		if (!user_tsc_khz)
> +			user_tsc_khz = tsc_khz;
> +
> +		start.desired_tsc_khz = user_tsc_khz;

Do we need to perform any sanity checking against this value?

Thanks,
Tom

> +
> +		/* Set the arch default TSC for the VM*/
> +		kvm->arch.default_tsc_khz = user_tsc_khz;
> +	}
> +
>  	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>  	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>  	if (rc) {
> @@ -2927,6 +2941,8 @@ void __init sev_set_cpu_caps(void)
>  	if (sev_snp_enabled) {
>  		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
>  		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
> +
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_SNP_SECURE_TSC);
>  	}
>  }
>  
> @@ -3059,6 +3075,9 @@ void __init sev_hardware_setup(void)
>  	sev_supported_vmsa_features = 0;
>  	if (sev_es_debug_swap_enabled)
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
> +
> +	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
>  }
>  
>  void sev_hardware_unsetup(void)

