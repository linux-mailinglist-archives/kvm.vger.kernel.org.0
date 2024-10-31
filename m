Return-Path: <kvm+bounces-30163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AFE9B77CE
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:46:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 215521F233EC
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26993197A81;
	Thu, 31 Oct 2024 09:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U3M6WM4w"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58DB14B092;
	Thu, 31 Oct 2024 09:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730368000; cv=fail; b=AoS+AoANnrOX8zR7ffSPEqhRGUJr9lmIJynYcSDUMrxIxROEvoqpP3SFdLC/d3M6yKCHYvliFmwKRJj440XyAYTGeQO+Ht6wITdTPzUTbMRZyNpncAAX2xtV4/5+osE2uF28Psbq1t251ERmUWPz3vht7nSj3hS0U0/rp/dwJz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730368000; c=relaxed/simple;
	bh=X9f4zp5/EzzUVSSeCvcyKX8PAKk2QfzFtlBUqXEq/Wg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KSEjoLamAA8uFDlvBM1JlK1OTwfbe1DCPa5Uke1UXKWQLpno9GHZI4TyA1pprh5zO0le7DL/doxdwO1VQZjOW/MzOIMInvLWiJZbG32Jzvp0fv4aD+bEvWxx/Wgbvdu352sCpcnseJt7Xm7VH8qkKlHP72sysqUgm1ofQtKMaO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U3M6WM4w; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYly4d4D5t+xXJ9PFeCnq3FfQB/Ddx+RAnTO/P07zRjj0hSorLoYRm6+XzRobiZW3s9a/b1FQehnRbSV8a91WsFvl0A3/QFPv5Fj+4z5BP5lGpVKI4mB0z+6nd1NLfcA5Nbr/cbG7TWUmmS+RZASik7acG9q4Ux1Z0LpkSw3NjDBp8YJX2wCTLTkYarOFZHZjicOFJU5ejRbuK9nTLkUmAQxUAM/zYk5zJcP71tedgmUs9/DfXdXF6VqhXYTE8h5hfUuGxka1BGQdTLCBwfSlG5LxvRYCG5Vn4EizywUiMVVM6DwvPUOxLQqe+2FkkmutGejtzMe2V0BKm/B6CvQ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9X7lddVfzX8W+m9ZAnIzLt9shx/Jl2UpvlkzMf265Bg=;
 b=wwUdqs2DB9FMaVXcCtHD9IodWzMMZmsP4yA0EBkMyOPXU6hyc/l+grvVzjo2mt3OPu+4gTTYo1lYfF+0EbTDU6GOc1y21RkXt84ld2LQATaTsjEFCQFcbS9DF6roC0DbCliuDVgEmJYth4RpuEN+Jj5fHzmzHadeLwQQXzyZtTsN/4RFUSMH5HWUiZEsyBaeO3H2M47IJaIl5hlkvv0BAqj4n3V2Q/tQ6CtaLvIk9Uy11n6zdj+PW4VyfR2alnowaF9AHy4MQdSkH1RPjpdNJ0qR116WBbKUr9KkhSRftAkaaQ2K44lhR4g2ZMPozmrsnsvxZ3emYWAJ+Bpsa5W5gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9X7lddVfzX8W+m9ZAnIzLt9shx/Jl2UpvlkzMf265Bg=;
 b=U3M6WM4wGTvYMUBcC1hzPYmiG0Covf20zuWhrnTiIBLV2yczIFcB5fGEz7lrPVUjpVjERP52HLkZz2Lwkze/w3KBIZ6yxInCoLvGoPy5gEe+5mfw6U4/CiZ+NTa31MYkH/eg2VCiz2aINRAkYLUdjoloCUAXI5HYJzfTHyodraM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CH3PR12MB8935.namprd12.prod.outlook.com (2603:10b6:610:169::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.28; Thu, 31 Oct
 2024 09:46:35 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a544:caf8:b505:5db6]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a544:caf8:b505:5db6%4]) with mapi id 15.20.8114.015; Thu, 31 Oct 2024
 09:46:35 +0000
Message-ID: <682cefa6-9a74-4b8b-97e2-38a1c58c6e72@amd.com>
Date: Thu, 31 Oct 2024 16:46:32 +0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Increase X2AVIC limit to 4096 vcpus
Content-Language: en-US
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, rkrcmar@redhat.com,
 jon.grimm@amd.com, santosh.shukla@amd.com
References: <20241008171156.11972-1-suravee.suthikulpanit@amd.com>
From: "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20241008171156.11972-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:4:195::18) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|CH3PR12MB8935:EE_
X-MS-Office365-Filtering-Correlation-Id: 46eb099f-702c-4ad9-1857-08dcf990e84c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qk1ORlYrYUYyQytGMlM0bGVYcS8zZDNNQ2o3R3Y0NkI4bC9KY3lnUXp5eFJ2?=
 =?utf-8?B?RkVGcmtOOU1DVjMxVUY0THV3dml1NzlaTWdnTEIvNXlnNFNpTTRlLzY4YVNL?=
 =?utf-8?B?V1B5TnBxUVdUc2gxREdxZVl1RHZ1UEtxNUxzQjUvN3pUNnFQS1Y2NEFtcmtV?=
 =?utf-8?B?OWZITk96MTBSWno4RlNmMkpVMzVXVkpHSWdsR3VYSkQ1ZS9PT2J2RnN2RmJG?=
 =?utf-8?B?N1ZkQkVqRURTcUcxczFpN013Z0UxbmZaZVZhZmRRV1RJZ0JOdmtWcXJOTGZL?=
 =?utf-8?B?MFN2L2lYRElNZkZEZUI1RDFSN0RYcCtQREVWTTA4UHExYW9ybHY4MWpzaUtC?=
 =?utf-8?B?aVdnMUhkRlIrcHZZdk42Ly8wVTZmVUFXYVlheHoxbURsUmlGYXRmUnNyN3ps?=
 =?utf-8?B?UVp6R0pkcFBmUXVYeHV6R042NGY0ajUxZFo2M21LeFBoMU43OU5BeU5BMDRO?=
 =?utf-8?B?dHJuRHlkakRmVit2MklYalNvNTl1ZE5zS3YvdUkvZzh5Tkxsc29XdnFJYnlp?=
 =?utf-8?B?Wno5MnU3WUtibFd1WW1lc2RwVk0wRU1ZbFpxbnpaUTg3Tnc0MFJjdGtsd2NO?=
 =?utf-8?B?czdwTGU2ODE0OGIwSXduWVJYZlR0Y0k3Nm04eUE2UlE2K1BSaFFiWXZvdk1L?=
 =?utf-8?B?ZG1SbVdtWVRDQlBrZ0lpcE1zNHNOS0E4c3U0RFlybzVSeXZydnNwdGpvTUho?=
 =?utf-8?B?b2VhTXdEeVZiQnpSdEFrTjEzNFJnOUxLaE5aeFAyUnVnSjE3aTZ3dUlOaTNM?=
 =?utf-8?B?RC84aHV1NFBYN0sveGJEV2paMWMvM3oyeU1va0pueENVR0t1KzdrOWoxUFZq?=
 =?utf-8?B?YVBMZ2ZiakdnOUtBclpybGFiQks5MWZsZ0o0WEcrUGJlK201Tys1K2U5RUlD?=
 =?utf-8?B?UjFDU0tTMmpsV2phYnI3eitVZS9GR0ZZbkZRaERQcXRsRWFhcWU4NHhxeEd6?=
 =?utf-8?B?SmlzY01uaUx2MS9oL3BJd09NRzhrOHdEeW9ocCtIZTllUnVBeU91QW1HZ1Ft?=
 =?utf-8?B?UWxEYnFEcnRQT2EzOXJLMUJpdGpFYUp4ZSs1M2tZeDBoSkt6bE0wa3VVV3U0?=
 =?utf-8?B?MmlSRWtkaFlEdUxVTmdRY0w1YTJKckNDd1pQem9lQk9GNXhuaVZrRHE3SzZ4?=
 =?utf-8?B?MHdDVTJvK3lNRkhnNjZFZmpFRXVMZFhkbjYrWG1lekloQkY4YkVmY3RrVjJT?=
 =?utf-8?B?MDVMZWlDd2NwMUNXc0ppakM4a3VUcVN2WDI5b2RhdlVhZUdXMkVHMVBWaFNE?=
 =?utf-8?B?cVRrZ1VyencxREZvelRCbjRicjRuNzNkaU41ck5LdkZLQnVOVC9zMW52Z0l1?=
 =?utf-8?B?amZKeGFhRFVIY0R4KzRlTFRITWNsOENsaEVoM1JZV0xkY3ZHaVhSQ0dIRnpJ?=
 =?utf-8?B?cU0wNnVlZXB5ejQ4K3Y4ZDE3eTlhSEptZlJ1STZSTFRqUjNoQllYNVhtZ05o?=
 =?utf-8?B?bFkrU0dnVmlIOGsvT2VkRTdqZTZncUswNEVNMnZDNTF0WkJHRnpBaVl2ZTZk?=
 =?utf-8?B?c2s2WEQ1WDUrY3o3UUFGbGtoNVc4U0lUWUoreHFIZXh1QXdzaUdjallpblpF?=
 =?utf-8?B?Y3dlWEdiYk9pdHVSNFdXSjRwUEZ0MFR0ajExdEhnZ2w2U3huRXplZjIvRWNt?=
 =?utf-8?B?enFsd3g1WlkyNGNrZWN2SEt4ZkU4WlFEbzdpYklhajlaODVmMVV1ZVI4anJx?=
 =?utf-8?B?QUN0QllzaDRGYTNqdS9MeC9rM0hrd3V3STBLYlZFOWFlRE44ZHVYcVcyQUJH?=
 =?utf-8?Q?s5Ygm9QsoqdRtji7ng=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGRhR0ppU0lGZzQwUk9BbmNyTU1aTTVGVnMwTFFGd1dTTXAvbDE1dGdYeG13?=
 =?utf-8?B?WG9ybmdpL3dtK3ljSG5ha0tuUzFNRUVRMlp2L3BmMDN6TENKRTlGQnV4aUdn?=
 =?utf-8?B?YXE0ZDF2K1UydzZDMEhGcVJBek5OcFB3a2kvN1BFMmRsVjR5YURBUmtlNkNC?=
 =?utf-8?B?cHZyMzhieUFFUmc0Z0p6RG55SjdFT1R5T3pzaURyQmttemJnL0N4VkdLVG9Y?=
 =?utf-8?B?M2NFdzJaUWNPZUh1bUdWQkdvODRuQUFPWVUzNC9uSk1kU0ppbk9ubTZwVU1l?=
 =?utf-8?B?MVVRaHZJZFpWL1hRcEdlVmZzb01XR0ZJMVVsYy9uanJJaHVJWDFPRlhtSlE2?=
 =?utf-8?B?aUtQVWpuTFdBZlIxYjJ0ZnZnYjIyZTV3VHh2SC9tblJyaXpYaHNtakxwcy9s?=
 =?utf-8?B?bFVXMlRVN3lCYnZNQnBCQWlzRkpsY1BuNjB0L3p0K2lSV0oyUGdRaXEzZ2RW?=
 =?utf-8?B?QWlpSEN2WmNrQkxGNVVlemlFajVFYUtFeUF1SjdYaENBZGdaTFpva2J1ZEJa?=
 =?utf-8?B?ckpIZU5XRFRqWkYzMXRvd1BVNGlkSllicWNhZWFLb0VkcGxRRVJ2dzRMK1A4?=
 =?utf-8?B?aWdhS2pQa0YyYWx5c1owbVN1YkhhenQwSGlzMzN5endnamJQY0FwYmgyMnM4?=
 =?utf-8?B?UFgwZGFsdzFYRjNsSTZIdklKa09ScU9GQ0sraE1ROWFwUkVGaHcydEZxMDFn?=
 =?utf-8?B?ZnlEMDBZa3gzRVMzd25USHZZYUdpRE02NFpuRnh4cXBObXhWVFJ1ZFR6cVE1?=
 =?utf-8?B?RitQTndxeHFnRVBCUWdIVURDNjMrT2J1dWhMM09xcGoxeEVOdk02ZndRcUx0?=
 =?utf-8?B?WkZ5KzRzazg0NktMZEhUejZRMVdDcytIb2dKODBXZmpTZy9BMHhXWm1JaHZ2?=
 =?utf-8?B?VlhpY1BOUG9UenVONkx0UzA4aE9pU2M1MWdEUGIwdGhVdlhPMkZDbmJXSTB0?=
 =?utf-8?B?YXZqTE9YSERhS3Z6S2JDWDAvM1VGVmZKbU84Wk5zVjc2Ujg3Wk9FNXgyVTJF?=
 =?utf-8?B?M291TFg5cWNDS0lWdGwrNGdoYjkySmtia2gvUUpIZzFTanNHSkFlVXJXaHNZ?=
 =?utf-8?B?SzZGaFdad01lMTdwUk1Qcy8wRTRqWkRreEpndEpoTGZURXRGNXdSZmY4Tzd6?=
 =?utf-8?B?WDcrOVE1MjVFOFNRanR4RDRKY1BsS0Z4RXNjS2cyRmNVWWhobmdqQUNIeGhL?=
 =?utf-8?B?dmxpdFdkak0xME51VlhqUmxITGwwajVHeWRHUWFCL3A5Y1lOakVqdFJaTy9T?=
 =?utf-8?B?WkRtV3pEOVBuRjRlc2lZVmZQSHVuK1gzWkIvUkRYdTN6ZUw2dHVPamtoSkJz?=
 =?utf-8?B?THZjNkxxQnM5cGl4S0N4L1ZTdnBpVk9vcFdQY1ZWVkE4NXlSWThlajFoU1Rq?=
 =?utf-8?B?enUyZWM4czJKcTFXSGV2Rkh6U3ltR2RlTXk4K0hTalh3dFhtZHUyWm13OGVa?=
 =?utf-8?B?TlVFQ3JUL0UzbHp4SDV6akhnbklyWHRkc1lkRUFsUWJMY2IrUXE2ZUtBQTF4?=
 =?utf-8?B?a2o2NG1NN1BnNGJSUFpaUjlaejExcU4vSi92Vmo2c0hURVBUQitzdFZwVy9p?=
 =?utf-8?B?ZmVqNlFXSmZEck5PVFZNRXlIQ2tNNEJQR1dFVC85WHVwekNtZWh0bXBQVmJt?=
 =?utf-8?B?VXZwQ1hTQ1ArcGZ5clorMmYzS2dCWGNxY0RwY0ZSMmZsZXNmaFFwZUMxcjJr?=
 =?utf-8?B?U1R1dG1aVHU5Zzg5eTJ3MXVBbk9Qd0lwU3U4VW1KVDNUZytMclE0VVRMdFBj?=
 =?utf-8?B?U2R2SndZemFINFQzTzhZdUFtb1ptZXFYV0FwNWE0MHFZM05vSzlNY2tQYU12?=
 =?utf-8?B?SGlZTXpyYWY0OE9tZ21YU3FrakZBV1o0WHhpdUhLdkdnOCtCbFdidWJKM3Q1?=
 =?utf-8?B?YlU4N1lyWExKY09xVjQxVm5Pc0pzYm1peWpyNmtxa2d0T1FaYXE0QXJKbExs?=
 =?utf-8?B?NDFMZnhVcjV3eGwvNkFnWFdZNzRud2xIMXdwcGhOVFgzbGhDWDNxd2NpSUV2?=
 =?utf-8?B?U0FidUFHRHYwOTRKZ3hPVit0ZVRYcjM5UlRDQnd6U2xvZStDMzJXbGpFOExa?=
 =?utf-8?B?VzJrRVBZTm1JVSs3UGt1OGhMR3BhU2pieEYwM1NlVTMwUHowcmZRTGpoNzE1?=
 =?utf-8?Q?JkB5RIPAmt1NZEdVLtkkmx0tQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46eb099f-702c-4ad9-1857-08dcf990e84c
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 09:46:35.1288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WDTv0NfF+xj5Kkjb2sdE7ifwLT6/oiN6QY6Kxq6/jBBR16d1/JGV2QdR1UTsJs3LYnNqvVl1O5NbvXCwR6GuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8935

Hi All,

Any concerns for this patch?

Thanks,
Suravee

On 10/9/2024 12:11 AM, Suravee Suthikulpanit wrote:
> Newer AMD platforms enhance x2AVIC feature to support up to 4096 vcpus.
> This capatility is detected via CPUID_Fn8000000A_ECX[x2AVIC_EXT].
> 
> Modify the SVM driver to check the capability. If detected, extend bitmask
> for guest max physical APIC ID to 0xFFF, increase maximum vcpu index to
> 4095, and increase the size of the Phyical APIC ID table from 4K to 32K in
> order to accommodate up to 4096 entries.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>   arch/x86/include/asm/svm.h |  4 ++++
>   arch/x86/kvm/svm/avic.c    | 42 ++++++++++++++++++++++++++------------
>   2 files changed, 33 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 2b59b9951c90..2e9728cec242 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -268,6 +268,7 @@ enum avic_ipi_failure_cause {
>   };
>   
>   #define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
> +#define AVIC_PHYSICAL_MAX_INDEX_4K_MASK	GENMASK_ULL(11, 0)
>   
>   /*
>    * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
> @@ -277,11 +278,14 @@ enum avic_ipi_failure_cause {
>   
>   /*
>    * For x2AVIC, the max index allowed for physical APIC ID table is 0x1ff (511).
> + * For extended x2AVIC, the max index allowed for physical APIC ID table is 0xfff (4095).
>    */
>   #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
> +#define X2AVIC_MAX_PHYSICAL_ID_4K	0xFFFUL
>   
>   static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
>   static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
> +static_assert((X2AVIC_MAX_PHYSICAL_ID_4K & AVIC_PHYSICAL_MAX_INDEX_4K_MASK) == X2AVIC_MAX_PHYSICAL_ID_4K);
>   
>   #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>   
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4b74ea91f4e6..fe09e35dad42 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -38,9 +38,9 @@
>    * size of the GATag is defined by hardware (32 bits), but is an opaque value
>    * as far as hardware is concerned.
>    */
> -#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
> +#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_4K_MASK
>   
> -#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
> +#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_4K_MASK)
>   #define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
>   
>   #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
> @@ -73,6 +73,9 @@ static u32 next_vm_id = 0;
>   static bool next_vm_id_wrapped = 0;
>   static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
>   bool x2avic_enabled;
> +static bool x2avic_4k_vcpu_supported;
> +static u64 x2avic_max_physical_id;
> +static u64 avic_physical_max_index_mask;
>   
>   /*
>    * This is a wrapper of struct amd_iommu_ir_data.
> @@ -87,7 +90,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>   	struct vmcb *vmcb = svm->vmcb01.ptr;
>   
>   	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
> -	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
> +	vmcb->control.avic_physical_id &= ~avic_physical_max_index_mask;
>   
>   	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
>   
> @@ -100,7 +103,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>   	 */
>   	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
>   		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> -		vmcb->control.avic_physical_id |= X2AVIC_MAX_PHYSICAL_ID;
> +		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
>   		/* Disabling MSR intercept for x2APIC registers */
>   		svm_set_x2apic_msr_interception(svm, false);
>   	} else {
> @@ -122,7 +125,7 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
>   	struct vmcb *vmcb = svm->vmcb01.ptr;
>   
>   	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
> -	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
> +	vmcb->control.avic_physical_id &= ~avic_physical_max_index_mask;
>   
>   	/*
>   	 * If running nested and the guest uses its own MSR bitmap, there
> @@ -197,13 +200,15 @@ int avic_vm_init(struct kvm *kvm)
>   	struct kvm_svm *k2;
>   	struct page *p_page;
>   	struct page *l_page;
> -	u32 vm_id;
> +	u32 vm_id, entries;
>   
>   	if (!enable_apicv)
>   		return 0;
>   
> -	/* Allocating physical APIC ID table (4KB) */
> -	p_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	/* Allocating physical APIC ID table */
> +	entries = x2avic_max_physical_id + 1;
> +	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
> +			     get_order(sizeof(u64) * entries));
>   	if (!p_page)
>   		goto free_avic;
>   
> @@ -266,7 +271,7 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>   	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
>   
>   	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
> -	    (index > X2AVIC_MAX_PHYSICAL_ID))
> +	    (index > x2avic_max_physical_id))
>   		return NULL;
>   
>   	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
> @@ -281,7 +286,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
>   	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
> -	    (id > X2AVIC_MAX_PHYSICAL_ID))
> +	    (id > x2avic_max_physical_id))
>   		return -EINVAL;
>   
>   	if (!vcpu->arch.apic->regs)
> @@ -493,7 +498,7 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>   	u32 icrh = svm->vmcb->control.exit_info_1 >> 32;
>   	u32 icrl = svm->vmcb->control.exit_info_1;
>   	u32 id = svm->vmcb->control.exit_info_2 >> 32;
> -	u32 index = svm->vmcb->control.exit_info_2 & 0x1FF;
> +	u32 index = svm->vmcb->control.exit_info_2 & avic_physical_max_index_mask;
>   	struct kvm_lapic *apic = vcpu->arch.apic;
>   
>   	trace_kvm_avic_incomplete_ipi(vcpu->vcpu_id, icrh, icrl, id, index);
> @@ -1212,8 +1217,19 @@ bool avic_hardware_setup(void)
>   
>   	/* AVIC is a prerequisite for x2AVIC. */
>   	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
> -	if (x2avic_enabled)
> -		pr_info("x2AVIC enabled\n");
> +	if (x2avic_enabled) {
> +		x2avic_4k_vcpu_supported = !!(cpuid_ecx(0x8000000a) & 0x40);
> +		if (x2avic_4k_vcpu_supported) {
> +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID_4K;
> +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_4K_MASK;
> +		} else {
> +			x2avic_max_physical_id = X2AVIC_MAX_PHYSICAL_ID;
> +			avic_physical_max_index_mask = AVIC_PHYSICAL_MAX_INDEX_MASK;
> +		}
> +
> +		pr_info("x2AVIC enabled%s\n",
> +			x2avic_4k_vcpu_supported ? " (w/ 4K-vcpu)" : "");
> +	}
>   
>   	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>   

