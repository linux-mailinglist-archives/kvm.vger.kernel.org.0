Return-Path: <kvm+bounces-20401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90866914DCF
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 15:00:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2A751C21EFC
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 13:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 710E613D524;
	Mon, 24 Jun 2024 13:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M1BSCwot"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C664DA04;
	Mon, 24 Jun 2024 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719234046; cv=fail; b=odSSOBsSNH9yqS37cXUd17XCx5IR/Pamvc97ROWOgK3uo4i05dkL9PJbL0KN+YDmSKuUo9F13j5pRbRrtOrDvK8K0ktFV1uQ9ibOUVA/0uGj9Tt7AayjiSUhGSU5ulgB6bfekH7U/NwfST0YxwMTR0w81kQAO0RjQEnifr7FdOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719234046; c=relaxed/simple;
	bh=VUUJINQ0U5PEaEwU3dTP42Gnkpa9RmoAUMqPACcW/gQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZppKgnbb60FneHhWjVG9NLQbQ1DfMaaUr5nnVJrNbJh4yzkW0nugEZkzyyFxdcJu1W7pXaQilkPh+MrUfX94a8S7nq8LZM18Szzc90DYy/hQledqGY8r3NAaaciFAID4eOOWwrXouBTNBwk9B/Cs64vyZinVk7E4hLdxuK5PeiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M1BSCwot; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4LBnG55sZpyVaFBBj72b/SmRIDMGE+xElqFVuTy4T00FCcE3a3RIfubFT5f1Ju9sgKjyWH8RnH8BgOWCKppx43L0mZKsoXmXRD8YXVRh7UpRRocURjnb9kVk1vHSL2hq1EQLBpqb8ozAMdVeSla8lvC+F2PPNM22kS5kbTesCaGILYCNebGjSeQQOLeMjNSMlJaImGW15ObLKqFT2dld0tpRZ48kCDsgiCbUjm3tnMRFuHMQWsm/ZzX41G5JcOh9x5iVKXi9rrpQ7RHHKdvq5UYLBXXM+Ae2uTPJoDUVJVligkMaBbAe2JDmG+HSohiRCMQ3Ot95dJDGORh5WIUYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dCkN7WZX4PE814h+oRidpoM8nmCqPXpU8QwdMT8XQeM=;
 b=Tz9gWyEdPYlDv2mwhZdfqSL7fvWLddWUdqa25l3IaNoqjkdkF16oJRYpNlcK+QcHp8/dMjS5/L35buX3tmfEjzIg9qBrBcfqgasFvqwy6YH2kQbYONBXfy92T8M0AP4DPVtPMcm6iM/HWQHPdANbTfX453rcxiCtWhIRM+vPJLCArsIcPEBFFj4Tik3FqxUYoeNd68itfE618QJ8TvgF1Dqm3RSaumHRGQJLbgrrvOc/sFGQ26dg1vdfiwZCewTmM9z0ZlgU5xfg1QmBmMbKZY3OyboBReIZ6NrpAQbH5w0QKNAO/wR8riFPagWn9+8NdjnwaaIME37TfYkMvErT3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dCkN7WZX4PE814h+oRidpoM8nmCqPXpU8QwdMT8XQeM=;
 b=M1BSCwotWMaXnfv2yZK1sUTrOSUJ7ZoTjGMpqzIDuMB0aYxbNcXA+TXrRIgie3vvOob9rF3UPPry0yzdqLp/x6915o27FMAShxHby9NAdf3A4y3PX5huH8OoViQfj3JV/BPUmj3V+RElhcCRVW7aiBrN0RM1FAnXohX5I9S79dY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MN0PR12MB6248.namprd12.prod.outlook.com (2603:10b6:208:3c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Mon, 24 Jun
 2024 13:00:41 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 13:00:41 +0000
Message-ID: <fe74fd23-5a5f-9539-ba1e-fb22f4fa5fc1@amd.com>
Date: Mon, 24 Jun 2024 08:00:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
Content-Language: en-US
To: "Nikunj A. Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
 <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
 <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0164.namprd13.prod.outlook.com
 (2603:10b6:806:28::19) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MN0PR12MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: 90a6508a-c55e-4e59-3e77-08dc944da6d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEJhbUxUb0VrVEZWaEF3cGRlUHpmSmc4VjdicWh2RldKUFNxT09FTFU1WUZG?=
 =?utf-8?B?c1B3dFJRQ0ZDSXRoYmRCbFZoRjdvajIrdUEyaVVOZXZDdXU4Rm1SWG9aV0VL?=
 =?utf-8?B?SFdROWREbkZnMWJaT3pwdzRVRTFXOUJTcTA3dDNZZUVuN3ZxWHV5Y3NiR0Nn?=
 =?utf-8?B?V045MXpxUVY5N093NkpCM3VrVit4U3JCVTcvQjJ4WklBVGJQMkRlTVg3Qms3?=
 =?utf-8?B?NWFMNTRKUmhpNEE4ZW5rUjNnYzkya2dzUktNV0JzNllNaUNYSVh5dk5tVVpp?=
 =?utf-8?B?L0lyYXl2dzU0aUNwNkZwRU5LWHFTd0JLc29ER2VGNTV1TUZWaVFNOTdiZFV3?=
 =?utf-8?B?c0pOVzE5TlNxWjdSaXB5bDFYNlV3VzgyTVZXd2h4Ukx6RWhVMk1ET2laa05w?=
 =?utf-8?B?NTRDMVgveElDTmxNOTBpRTd0c3NBWC9hdUpJS0czTVFseUVZam9pZGNBYlVB?=
 =?utf-8?B?RDlRK1RTbzUvbFlVYU4ycjM5NjhRRVoyZWVaZThFZVpyTnFlZXh4TjE3Qk5J?=
 =?utf-8?B?VjZvNEJBS1hGaWNmWnpoUTQ5aVN6blRGWE5yTDVzSHRTMm1BbzlDZUJzaXhO?=
 =?utf-8?B?NTZmNGhpMjdGdnNTUVczak9OR2d1YXBaeFRib2NyaGVEaG1pYXB2aDgrUFhB?=
 =?utf-8?B?TlhyQzNXa2dyR2tTVkxaMSttZWRISExHRWtqVGxSV09NYzV4MTYyQVJCRnZM?=
 =?utf-8?B?b2VybnJmNllXWDlYS1UyVlNBaU9Nb2xkUm85ZkdpWVd0ZzdmMHpKekxPeEtE?=
 =?utf-8?B?Ti9udWdUTWZQMXNRYmQ3V1FKdVVjcDdRdDBwOTZJc01hS00yRFFNaW1YZWtG?=
 =?utf-8?B?Wnp6V2d0TFAyS3QyNUszSHl1VjgvS3NBWHpXc3hoaEhiTVVOSC9aQXg4S05x?=
 =?utf-8?B?bEJyVXVZbXVaSVlqZ25QRlFHd0k1cGsvdXdDUm5BUUd4ZVkwVjFmT1AyZ2NH?=
 =?utf-8?B?V1g2ckkrOUpqZnJGNTVocVU4OWNJUWJSSW5ZWGlzNTVQMWNDUlVWeWJOUVpr?=
 =?utf-8?B?UWNvenlOYUxsdTR1ZUJHKzFIb2dlUmprd3hSWDBvZExSQmNCcW55ZWw4clJW?=
 =?utf-8?B?cjFBdTNDbEl4NjZjTW5BeUU0WlNPSDFiQkQyeGVvY2Q1Y1F6SHF3cUVieWwv?=
 =?utf-8?B?NW1xWGFEV0t0VVdnM1dkYm1KcUJ0d0JjRys4aWdtdkN1Z0FSdm5BbGtTSUtv?=
 =?utf-8?B?ck9NblRZaEs3TXpGc0VnWE40TkgwbTQrRWxqZHA4T2NFTktRWDFpL3VkVita?=
 =?utf-8?B?SUpIZGVHdWF4dUx3TTV5ejNOT3BRNzMrTGt1TE5ITC9HU29LT3NtK1AyalV1?=
 =?utf-8?B?WXBLMGduaDhmWHRHS3R2Uk45NWtwOGtEcG15SmNzUm1UVlBzZmpmVytSTjJB?=
 =?utf-8?B?dXVuRFV1Ymg2OHg2QjlaNVFxaDZJaTU2TExRektIb3RXSVNybFRCb1VvWEV4?=
 =?utf-8?B?Z0loM0VyclZOWUJlQjNvK1JDUVFWdkhiSFlVc2FuUFF1a3loVDRtUmZBUTM0?=
 =?utf-8?B?bk5Fa2F3Rk5nMzArMUVHd3dEcmxZYVBtaWhTWGNFWnBHQy9jYUVGK3B5Y2Qz?=
 =?utf-8?B?dm9CMkJKbndBWXBaVjVqcUJCSHhuWERXSDg0MHVlajJLczB3T3VhN2hPVldE?=
 =?utf-8?B?MW5jODF2SDlzbE8wclZpNzJNWm9OWStMS01qdjltaTBYK0ZDUVkxay95RWNW?=
 =?utf-8?B?UjZUUThGMVpURDJZNTdQakZ0eGpOZm1mcFZzeDRyM3Q1YW1XUUZmSFlxNHBz?=
 =?utf-8?Q?qIb4rTs70ipLnuvnIQi9D0aI6Dd1J5ztB8D3aQQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXpHc3VBdExCUUR6SHVDcC9nUGxtSTRKYURLNnFLSDFaZml6b2VlejRNVlpY?=
 =?utf-8?B?YVJHWVgxYmNQZWZCY1ZpTEpGWG5vQlBNR21tcy90b1JQV21VTXpLU0VuWGZF?=
 =?utf-8?B?RFUwbTlZUzVNQ0VPTDNqTUthenJRaURxRnMzSGptQWErT1BSWnlTSjlhaTYx?=
 =?utf-8?B?Y2hTbzJUYlgzM3ovRURFTXRIbEo5R2JYYitzTVdrZUdSWlY2UTVqRjBxSUVq?=
 =?utf-8?B?MDV3aW5iUFJZbllwZUVtQ09VQnNXbWdua1hXcmxXL1o2eVplYzVSWVJnRkcx?=
 =?utf-8?B?MXVRM0FxNHZuUEVyNVNNNnhiektyTVVUeDUxLzA4V21nZ0oyWHI4NGE4YWgr?=
 =?utf-8?B?UUZueGowSGIwZVB6bUQwTjdOdlFaSEk2TzQ2Z0Z5NndUU1JQME9jOEM0Znkz?=
 =?utf-8?B?Y3FrTUFDYnFzZjBvM05ZVitjOEd4ck9Pc2MybTB1VHZFaWZFQktZdWJldkNY?=
 =?utf-8?B?MDB2WE5jZnZ0ZENpTmoyaHJBK3hDbkRET1FmeEJtNC8wNm5JZjdtR2hRYXZ4?=
 =?utf-8?B?bGFNOEp3cUlieW1GdlJaSDZZRVdIYzBtRUZYQmpLRi8yQ05kUW5BVjlaeFNz?=
 =?utf-8?B?bENReTNEWWM2UjVuK3JtRTgvYXlsY2x0dGZWemg5OW9CWnAzRnhOUkRPeVRB?=
 =?utf-8?B?Y2NGelpGdHE2SXZqR3B3Q0dBVk5QYlpoTXgrNUpQOWVla2F0dmg0YlcrNld6?=
 =?utf-8?B?anhQU3cwRDNzR0I1R3RVTFdQeE8xcmhtbnZUaW9NbnVMMUhnVGk5TGoxdlZ4?=
 =?utf-8?B?d0RLTkUyYXh6YTQ2S2FWdTB5Wk9TUFp0SHFhNHltWkpSN2ZmUTRPbDlDM3Nz?=
 =?utf-8?B?NEFEaU5ySXpDYTdVVFg4M1RXdkE4L0djTFhLZVl6SUdFY3ZuUStNaTN3ME1q?=
 =?utf-8?B?MlkrdUVYbnVqWnVoVURQQVJpdTNnU2ZXY1NSbFlqTFFrQUVKRzV3M2ZYWXJ0?=
 =?utf-8?B?QXZoZnp3R2VLdG52TWcyRnRXRHQxSjJaNzRBNmc2M2YvSnI0WWtoTkQyMCtO?=
 =?utf-8?B?SnZIUVQxOVFKSUdKbFFNK1BDbjF0OUhOWnlxSkdHVUp4OFljOVl1bk5JOUhX?=
 =?utf-8?B?QXNEcTh0a1NYYzBIMWMvYlhiVkFpL0tSOHRlVVltQW5HQzBHelpqaE1QYkM4?=
 =?utf-8?B?a3d2OGorbkN6bXRVb0RCSm9VdFlhMTRkelVGWi9tYWJnTCtsSmtQeHpBVm5R?=
 =?utf-8?B?N3B0RlZxTVFsdHRiZkY5M0w0TE5KUGJ1STh1NkZDdGV1TlB0TUFNSi9CSDZD?=
 =?utf-8?B?WE9oQ0o1b3dyVFozcFlKTTREam1sRGJDOG92WHdNUXkvRTVwYlRDc1d4NVdV?=
 =?utf-8?B?YXFNS0FTTU10NXB6MmhVSi9NenJ1U1RhUGlBR2xSdmxrck5UdmNxamxSbjJI?=
 =?utf-8?B?VnFPc0NaYVk5RVUxeWpnKytrK0pTNmRZb1ZxOWNGNXVzRkJhNCs5QkFhU0Ry?=
 =?utf-8?B?RU1wdmwwNWN0cGZzbGgwY3dFd0J1Y2FGTmsxWFUxS1JaM1hnS3JIN0JPdkZt?=
 =?utf-8?B?TDFIQVYvNWp1ci9JVVMwSG95S0o3L3I1WGc0VW0zRG5NWi81VXBWS1N2U2or?=
 =?utf-8?B?WTdSSWgxZ2xtazRPdWVyME5vZU03KzRoWlprTVV5QlBEcWM2QVlxbXM3aVBz?=
 =?utf-8?B?SGdKL1cxQ1JMM0NJSVlIMTcwL0FaWUdTRmcvamRYTWFscGFCVXBRUFc3YStJ?=
 =?utf-8?B?MUdvdCs1WG55OVNsci9EVzV2RVA0c3dta3FHMk5qUkFtQkNHcUxOTHpqYVVR?=
 =?utf-8?B?ZkF0SXg1N1AzRWdmemgrQlFrQ2tEQ2o5bjVTQXpzSmNlL21OQk5JWWFrNldN?=
 =?utf-8?B?NkxXVDFRM2pQTHB6b1dLcllUWWhFMzQvMkdreUNwRkMzNi9aMGk5Q05xUE5F?=
 =?utf-8?B?QklwY2J1NlhRK05vWVRQUzUycFpuZ2hKdTRhajE3ZkQ0ZUEzSkxad0lNcjN2?=
 =?utf-8?B?YW9rSGlxZUlvVTA2Y1JHcHNhRmpSZHY4ODlVVlZITGw5SGlmSXdoeUZpWm1O?=
 =?utf-8?B?ZmYxTDhLdFBNYmJ6RGIzUENBd1NEb21VQTNLR0pNSVhieUpYdWtLMTZzZlZD?=
 =?utf-8?B?d2pTSDJsN05KUnh3aEZVdGlDNGlNcmEyL0k5QldGMzBmc1JMSUl3MFRzYXJV?=
 =?utf-8?Q?JcI1xTpd0gX5nQIzaYfBlJz7q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a6508a-c55e-4e59-3e77-08dc944da6d2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 13:00:41.6183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IwN03ZlqDopRS1bQeK85y2D2ItGcHMUsj4gEtE1IXdzraa/3p12VyxOtp6ITif0I0A0/boYVjdeMK8XRi/Daw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6248

On 6/23/24 11:16, Nikunj A. Dadhania wrote:
> On 6/21/2024 10:24 PM, Borislav Petkov wrote:
>> On Fri, May 31, 2024 at 10:00:17AM +0530, Nikunj A Dadhania wrote:
>>> Currently, guest message is PAGE_SIZE bytes and payload is hard-coded to
>>> 4000 bytes, assuming snp_guest_msg_hdr structure as 96 bytes.
>>>
>>> Remove the structure size assumption and hard-coding of payload size and
>>> instead use variable length array.
>>
>> I don't understand here what hard-coding is being removed?
>>
>> It is simply done differently:
>>
>> from
>>
>>> -     snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
>>
>> to
>>
>>> +     snp_dev->request = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);
>>
>> Maybe I'm missing the point here but do you mean by removing the hard-coding
>> this:
>>
>> +#define SNP_GUEST_MSG_SIZE 4096
>> +#define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))
>>
>> where the msg payload size will get computed at build time and you won't have
>> to do that 4000 in the struct definition:
>>
>> 	u8 payload[4000];
>>
>> ?
> 
> Yes, payload was earlier fixed at 4000 bytes, without considering the size of snp_guest_msg.

An alternative to the #defines would be something like:

struct snp_guest_msg {
	struct snp_guest_msg_hdr hdr;
	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
 } __packed;

Not sure it matters, but does reduce the changes while ensuring the
payload plus header doesn't exceed a page.

Thanks,
Tom

> 
> Regards
> Nikunj

