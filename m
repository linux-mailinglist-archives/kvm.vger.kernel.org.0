Return-Path: <kvm+bounces-36463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C3DDA1AF0B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 04:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB5811887177
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 03:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 379531D5CD7;
	Fri, 24 Jan 2025 03:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Rnx3XfdR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD901D61A7
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 03:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737689274; cv=fail; b=hFM9ueKlP2CarxIWDV3ke4F9Rz6VGHj8czYCSfmlPj74ZTKbJwCBW/pgFWa+ubzaDp3jE1PCwCOqVwmXvJGmPJyO+0J/p//N7JOfbWZpWR9By2Yk5W8SDzKKe5S9jqCYTtBk4sKP1x/QRubX0GhsjRGx0g8H8Y9ldZyLZ7IeQm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737689274; c=relaxed/simple;
	bh=l7EzfhPFJlZnNSzpXLAmwrrq9Iwb5NdgoIr4lIwQzYo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AsMcKbWn1CjNzbE7JEHxwUyb/Pdx0api2/3w9NbE2epVnZpbMPbSxj7QAvBhuiCZ4P0W2XuVigqKD8e7jfbhH1sXS0uukE9aT3eAJlE+tp9qRFe/pdT5wI6ayaiUCCpaqNu76FCrbanu2urRfQs397ac6AANfTIRheB1rYRw9eE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Rnx3XfdR; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sKwBCCahxZ4BbQt6gmE9pV9E3uPuNGLw5IrWcVdStF1LAbgRHKs4Sk4L0EGZAL2knbOYIBcVbIr0eAGwtVGBD9+24xJukiBHA7aNphjtZs2dhGSsXQbX7igzy86rhZVZZmci1aZ9YJGXSZNF4u1JbaY7dmdlgBz4u5Ydheu8ZdWg5Lt7uWx+lXo+sdcac6pg+Iw2Dh+hbLTjWV8a1qBovZsZbIa0KQzU4Baiq+4Co20w/siFHWTOPthy8WGbbod/mrvbEkPkncYb3l17+TJK6RxmntyEw3f1Wlx32jBgcid7VbZBFVdMC+FVJRq5gVIJRUi3J1Rn0zJYrnQ54DOkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UCccYjr+H0dFc+LaQPmsBxGBpv22HuN5cd8rVFb80aI=;
 b=nBzoVi5vg7ib6zOuQ1ncSsNyA9zc789r5XQygvKkk5d4oPp6mtLDvkANtONy1FoT68+Lz6BNqatNiq+1q3K7Cgqgz/7TdoGILNiAm/j6Jy1on9qxe1EZTV2zqpgSAfcV9nSKaCXTMRWiYLtQ/En9kGAaTEEGv7NRFI05J6vR4Sjh4FPZtxGNsswfZzCRYXyGqSJVs0g1ZBNT7saYR011x9KdPyskTJ9VvdjZNhRjSoVBpG/BuTJsaRLucxaeGnyMwfmOEKJJxaNmCTL9Z1PdSnI9lCFfbzD0sCCU9+4o9Xl8jnth+8GXHVVjna8xBL4PS952bbTvxlq8/L+1ZUXpjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCccYjr+H0dFc+LaQPmsBxGBpv22HuN5cd8rVFb80aI=;
 b=Rnx3XfdRpTFoM3bq9/OlWXXYRJerRtbaPrlWIuuF1OSDov7s9nLRpv4N8U/i0I6WHmFdgucjCS+bu+J9Ml54q+nnD7bAS2NIVRKU/qzIkBk/1pxLW7XBxMZTNv01m/psPBFM44V06dFh4bp52t39r+cSXfmeEFRdrdi93jkh9O4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM3PR12MB9391.namprd12.prod.outlook.com (2603:10b6:0:3d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.18; Fri, 24 Jan
 2025 03:27:47 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8356.020; Fri, 24 Jan 2025
 03:27:47 +0000
Message-ID: <5746187a-331a-4e8f-a7ab-9273fcc64e9b@amd.com>
Date: Fri, 24 Jan 2025 14:27:40 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-6-chenyi.qiang@intel.com>
 <2582a187-fa16-427b-a925-2ac564848a69@amd.com>
 <5c999e10-772b-4ece-9eed-4d082712b570@intel.com>
 <09b82b7f-7dec-4dd9-bfc0-707f4af23161@amd.com>
 <13b85368-46e8-4b82-b517-01ecc87af00e@intel.com>
 <59bd0e82-f269-4567-8f75-a32c9c997ca9@redhat.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <59bd0e82-f269-4567-8f75-a32c9c997ca9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWPR01CA0132.ausprd01.prod.outlook.com
 (2603:10c6:220:1d3::18) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM3PR12MB9391:EE_
X-MS-Office365-Filtering-Correlation-Id: 643396b5-ed10-4d8d-99ba-08dd3c2712c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVNGY0RLVVF1QmxZSVlEWVhya01aSnluQnZRVTBPZldZWFljZGsvMmJMSzVO?=
 =?utf-8?B?enRRVG5ESnc4Q1pjU1h5Q0lmT2N5SDRvWEN5L2V6VUJOcUJkaWdTeGRMdERs?=
 =?utf-8?B?OG4wOFpwS3k0VVhmbzFINjVtdFpXWXJZNnd4c3MvZ2VQV0hYSDJhcHVNcEdU?=
 =?utf-8?B?NWFISFEwNm9UeVRTbEM2U3VCakljaThSVk1QZElwY3dOYlJSd0FTSXQ4YmhR?=
 =?utf-8?B?cHk2WkR2Vml3VC92Q3k4OW9QRDd4WFN6MGlmeGZQeFM2YVlLRnhxYjEyRW04?=
 =?utf-8?B?ZFlYRWVRQ1lKdDE5WWVvT2dzbU1SN3pnUS9pYWZpREZXeDk5SUR5NEtDWTIy?=
 =?utf-8?B?V2dTQnFHOEFJZEZiRFNRUmZpSEZGcVY1S0JrTlVTRlp3WnJ3ekNmYzZqdklB?=
 =?utf-8?B?YVB5UzlXMzFsNmhwN0VqS2duQ2RQMTVDS3ZON0FWak5BVVhtWm14MndxcmlM?=
 =?utf-8?B?bER1c3ZBUmMwOXIrbmRYQzJjMEhhQnUzc09rK3J6UFg4WTVyWGZvU2R5c1NO?=
 =?utf-8?B?bVpDeGF1VDlIaWxkMms4VFpXY3ZXaldZRitGaHlEdU1qZUxXVFVKT2ZaZ21H?=
 =?utf-8?B?dWQ3cGNUcVZFWndtNGJ1VHdiNGlsTTlWNStTTzBLVTJjSmJFN201RE4zUmY2?=
 =?utf-8?B?TlhiSHA4MDNwZXI0cmhkeGFpWEdXTkRwbFY3dHNndFp4ZnhLcXZHNWdPQ1Fm?=
 =?utf-8?B?WWZhMDJScnc3SHpWVEpPaWFQMEs0bWJCTVQ2dlhURGpoRUR3clFyaW0wSWhQ?=
 =?utf-8?B?cnpoUHhPdUI4L252QWhJd0c1ZzBic1dwWUdOOXh0MnFQTTlCNkdjUmFPL1FG?=
 =?utf-8?B?eHhDWFJiVEdZWmMvbE5lVmVTZ1RkSzB0eklKcHltZndabzM5bnNtMlRzOWFX?=
 =?utf-8?B?TjRkNXBOMlVRdVFkT2ZxVjZmWDZqWnFQTkYrZWNnZG9Pc3pKVWtTNU9MWUdC?=
 =?utf-8?B?RUlna3B6Nmdabk53TDBPVzhpbkMvYTlxeXU1Y285bm5ab3VJWE5JeVNqdVdk?=
 =?utf-8?B?UjRBZ09wcVVJeWNOYkh0MkpVZ1NjS2xaL04zL3d4MHNTbm8xUmZ4aVRVN1g0?=
 =?utf-8?B?d0l4UjBhN3YyaFR4RDRma3dQTFJQZ2JxbWtyRGdqUUNJcC9jUTlaLytQS0Jz?=
 =?utf-8?B?V2pDK0krcTlsb3krQ3BIakpCRDJjR29iaFc5UytiUHg3SWhZMkdQZjhJQ0ta?=
 =?utf-8?B?MDRkamx0aUllU2loWmhMdkNnRE5WdExNclFDSlpBb1k3bXIrR3dVSytiK0tY?=
 =?utf-8?B?dGltSTEwK24zMzN4cG5yOWFoVXBPVGVQV0VKNWZ1aE5ad2doZ2NPMmtMTXVJ?=
 =?utf-8?B?QTFEcUZFa05RcUVxWEJBbFYxYWkvZ0VQRDlxdXc0c28vL2xneitaUHFDbW8w?=
 =?utf-8?B?MXlTbXByb2p6djl3WTRjTkt6dFBTMXBpMzFqK0JwWlFNQ29YV1B1THZRc2xl?=
 =?utf-8?B?dU5keXJ2U1VHRG43bm1rRFFiYThnNFg3bVZEcjlXMGVDUG1OQ01qUnBjeWxt?=
 =?utf-8?B?RE5vNk5USW1ZVEVrQ210eGZSNzArMDU1OWFuLzhUWENNaG9zbmZxM0Zzbmlh?=
 =?utf-8?B?ZmgxMW1mWEh3RG9UZFdlYTBWWUsraDlaTWpDd1RMb3ZhZEw5U05qd1V3QlZh?=
 =?utf-8?B?Uk0wNUx6ZU14aHA1ck43d1gxMDNNLzhoOHIrb3lndWYxQ3VtTkgrcThTbFdB?=
 =?utf-8?B?K2NRQ0VUem5FMXBYNGFYK0gyVURrTjdJR1RhK3NBQmxEaTAzd0x6NUNwQit5?=
 =?utf-8?B?WUN2Uy9Tb0ZWaUlnZThDOU9ZT3B0ZGpORnFHY0h2MmF3WHJiNTY3ZzBZYTRB?=
 =?utf-8?B?UFlpc1VNKzgrV1pJNFdxcHM1L24wOU5xVHNKV1BMMUVqT0tMcWlWM1FiQzRi?=
 =?utf-8?Q?Up5QFIFvk+Nbc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWpud3cxVDJNS1F4VVdRZlFNZVZBTFFDV2h0VGZuUjdjMFV5dlNjSUFUdXJn?=
 =?utf-8?B?M2M5UEdpd0s4M1JNUWRkR052ZE10S09uaHJDMFdVTyszcCtWbW1HWHN6VFU1?=
 =?utf-8?B?TFR6S2VGaXllZjdoY3U2ajA4cVBGdDJKbHVqZFpVY3p0cTlpWFM2RDlCbys1?=
 =?utf-8?B?MnJFazZXSFNjTXYzdkdXWmQvY0lYcW5xZ3BXQ2toRktGQUtlOHFDcUFVZXVi?=
 =?utf-8?B?R0pyVU1hbFpTQ0RmcEE1NjNSMnNMVzUrd0R4RUN0T2dvYnEralhoTUhRN3Y3?=
 =?utf-8?B?NWdudVQxZ0VUNFRaVkNOZWtSN25xbks5Q1lOdmxibW5Ccm9kVVl5dlNJYyt4?=
 =?utf-8?B?RHUyL3BHTUdvbkprQm5XUkxLUWlzWlZzcEFWaDMxZHBTWWxJeVRheDNxelFk?=
 =?utf-8?B?eVNrdm1Lb0s1eEh4WkpYSE9ta3AwYWthMTNTOWE0TDA4aXFVemZJTFlibFJt?=
 =?utf-8?B?MjR1TU45VkEyUWtaeXE4RzQ5U0IydE9sV2xoVWlpYi9XWHhYMnJlb25kMzdO?=
 =?utf-8?B?WEl4YUV0K1Y3QTJDSlVwV3ozV1pic0NvQmxVVWFKWTFmUzZoNGlYQWtlV2x2?=
 =?utf-8?B?VlNvWlNBRGhGRFVxMUVNYzYySzFvWVFYRmMvdTNqQURkWnhzRG9oaEZXdnEz?=
 =?utf-8?B?WlA1dUxTbU5OaHFBTk9mVE1yWW80WE1EV0JRbzdPSmxsSjRKRUdIVWNQMEFm?=
 =?utf-8?B?cGRjSzJUSmQ2MjFSd3UxTUIvSUJPM3NsYXpkMjlSU1ZLcWRGU3ppU1RNZGZO?=
 =?utf-8?B?dkMzcldGZVh5Yy9mZmk2NDB2eXFTb3lwTSthUEM5aENMcUFDNW1zT25sWE54?=
 =?utf-8?B?cjRwMzhRd29UWkVFT1RKVUNIS0tKY2x6ZkhYc1A2YTNLSDZOSVJVbEFBZ0Zi?=
 =?utf-8?B?amdCNloxeVdreFJDaFFOTGlubnpLREtHd09WekswVXB4ZDdFY2hTbERlbkZp?=
 =?utf-8?B?RWpobkxoVS9UdDVNTTU3MkhFb1dmcWJsTTV2U0V2UmVzeVEybTBqZEpDSHI5?=
 =?utf-8?B?b0JYODhPUEhQRlhiS0xHZjZOOHZ5c2c1TWxZUzc3QmQrRHF0Y1lCWm1HQzdC?=
 =?utf-8?B?YkI5N25lWnFmRWw1bzN3N3R3OUlNM21VSWg1cDcxaldYaDJRZHgwNkFTaVU5?=
 =?utf-8?B?bDJZVnNBWnoybmVpTXFsdy9aVFZDZEZqb3VxZVBWb0RyNUhVM3NQSm8zUWdh?=
 =?utf-8?B?ZDhkTkErQzFPc09zaGorVVdNeVlYYW96VXZyN1I3NGp4U1kzS3VYa04ycCtX?=
 =?utf-8?B?eUpPZzhoQ2tRNXYvbEljVUZCYit3L0IrdDR2c1JoSVpaNjZkbmxidVBRQzI4?=
 =?utf-8?B?dVNZcTd5UjR2dVhyUlZ4ZEhncTlXRytWNzdSam1uSTQrYW1KNlR0WDdBS083?=
 =?utf-8?B?Rk1SNTlNbEVlTGZ5dmJ4QWVhUFFmT2Y0SDhPSEp4eWhZa2dvNHF3cUtEZy9r?=
 =?utf-8?B?VHFNVDQrU2ppK09jem5oL1QrSFg5U2RBaDFrTXhyWEoyckQxV0dvNnJFTlMv?=
 =?utf-8?B?YTRESm02Yjd4NmcyNFlPQ2ZIMHF1c2RkYzRPQmhST1llYklGMXp0NXhNT1dS?=
 =?utf-8?B?eGpzWUYzamhDQWxLSURPbFRHZnpvTHcwR09LNnJGM1dJc1djTGN3azFnYlRv?=
 =?utf-8?B?YkdQbUNJSndNcGRzajllM1R2TXFzdjVoSHVVYVV4TmV0S2FaQnUrSE16WGFz?=
 =?utf-8?B?MnV1OGZmMDBtQ1NnT0g4bk9mcHdQa2h4MFlNcEZJYXFvazhjaTd1MkFPeFNS?=
 =?utf-8?B?VzZWK2NyL2FVVFZUWm9mNDhmTVMyMy9IRXJVMjdtQS9lc1ZOTzlrd3JVMko0?=
 =?utf-8?B?WnRtNjVXVmFiOEpXbHhRMzI3Yk11ZVNpMW96VXpOK1NFYTN0R0MyT2FkQ1B1?=
 =?utf-8?B?UXcyMEcySDR2Q3dlVUxjV0pNUXZjTHVWSkZhT1E2M21ya2dSdmV3SjNBOEps?=
 =?utf-8?B?RDA0aHJFRE9sdTdFNHBrRS9QdG14ODZOV2R4Smk3VWhCYS9WcFlYY3pNNkc1?=
 =?utf-8?B?VE4va0ROQjNJa2tZOXB6WWh4UStDZDQzQkszMGtJaWlPTnl5MnlpT0tqUTNj?=
 =?utf-8?B?WEpmaUhUaVFkWS96dW92WXJ5UitQc3VDdkt0TG8yQW1RdXlqWUdnNHBWR0x0?=
 =?utf-8?Q?DOF2GhkydNnnyT93lutiezvMa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 643396b5-ed10-4d8d-99ba-08dd3c2712c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 03:27:47.4425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uilkKFQmeCV2XgvcH8J7QssZZPR1WDYimuzXJY+t8Lou1kVGPTSXqPP6urkDG7J+xH7N02eQGSTLflSoIQnXmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9391



On 21/1/25 00:06, David Hildenbrand wrote:
> On 10.01.25 06:13, Chenyi Qiang wrote:
>>
>>
>> On 1/9/2025 5:32 PM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 9/1/25 16:34, Chenyi Qiang wrote:
>>>>
>>>>
>>>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>> Introduce the realize()/unrealize() callbacks to initialize/
>>>>>> uninitialize
>>>>>> the new guest_memfd_manager object and register/unregister it in the
>>>>>> target MemoryRegion.
>>>>>>
>>>>>> Guest_memfd was initially set to shared until the commit bd3bcf6962
>>>>>> ("kvm/memory: Make memory type private by default if it has guest 
>>>>>> memfd
>>>>>> backend"). To align with this change, the default state in
>>>>>> guest_memfd_manager is set to private. (The bitmap is cleared to 0).
>>>>>> Additionally, setting the default to private can also reduce the
>>>>>> overhead of mapping shared pages into IOMMU by VFIO during the bootup
>>>>>> stage.
>>>>>>
>>>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>>>> ---
>>>>>>     include/sysemu/guest-memfd-manager.h | 27 +++++++++++++++++++++++
>>>>>> ++++
>>>>>>     system/guest-memfd-manager.c         | 28 +++++++++++++++++++++++
>>>>>> ++++-
>>>>>>     system/physmem.c                     |  7 +++++++
>>>>>>     3 files changed, 61 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>>>>>> guest-memfd-manager.h
>>>>>> index 9dc4e0346d..d1e7f698e8 100644
>>>>>> --- a/include/sysemu/guest-memfd-manager.h
>>>>>> +++ b/include/sysemu/guest-memfd-manager.h
>>>>>> @@ -42,6 +42,8 @@ struct GuestMemfdManager {
>>>>>>     struct GuestMemfdManagerClass {
>>>>>>         ObjectClass parent_class;
>>>>>>     +    void (*realize)(GuestMemfdManager *gmm, MemoryRegion *mr,
>>>>>> uint64_t region_size);
>>>>>> +    void (*unrealize)(GuestMemfdManager *gmm);
>>>>>>         int (*state_change)(GuestMemfdManager *gmm, uint64_t offset,
>>>>>> uint64_t size,
>>>>>>                             bool shared_to_private);
>>>>>>     };
>>>>>> @@ -61,4 +63,29 @@ static inline int
>>>>>> guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint6
>>>>>>         return 0;
>>>>>>     }
>>>>>>     +static inline void guest_memfd_manager_realize(GuestMemfdManager
>>>>>> *gmm,
>>>>>> +                                              MemoryRegion *mr,
>>>>>> uint64_t region_size)
>>>>>> +{
>>>>>> +    GuestMemfdManagerClass *klass;
>>>>>> +
>>>>>> +    g_assert(gmm);
>>>>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>>>>> +
>>>>>> +    if (klass->realize) {
>>>>>> +        klass->realize(gmm, mr, region_size);
>>>>>
>>>>> Ditch realize() hook and call guest_memfd_manager_realizefn() 
>>>>> directly?
>>>>> Not clear why these new hooks are needed.
>>>>
>>>>>
>>>>>> +    }
>>>>>> +}
>>>>>> +
>>>>>> +static inline void guest_memfd_manager_unrealize(GuestMemfdManager
>>>>>> *gmm)
>>>>>> +{
>>>>>> +    GuestMemfdManagerClass *klass;
>>>>>> +
>>>>>> +    g_assert(gmm);
>>>>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>>>>> +
>>>>>> +    if (klass->unrealize) {
>>>>>> +        klass->unrealize(gmm);
>>>>>> +    }
>>>>>> +}
>>>>>
>>>>> guest_memfd_manager_unrealizefn()?
>>>>
>>>> Agree. Adding these wrappers seem unnecessary.
>>>>
>>>>>
>>>>>
>>>>>> +
>>>>>>     #endif
>>>>>> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-
>>>>>> manager.c
>>>>>> index 6601df5f3f..b6a32f0bfb 100644
>>>>>> --- a/system/guest-memfd-manager.c
>>>>>> +++ b/system/guest-memfd-manager.c
>>>>>> @@ -366,6 +366,31 @@ static int
>>>>>> guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
>>>>>>         return ret;
>>>>>>     }
>>>>>>     +static void guest_memfd_manager_realizefn(GuestMemfdManager 
>>>>>> *gmm,
>>>>>> MemoryRegion *mr,
>>>>>> +                                          uint64_t region_size)
>>>>>> +{
>>>>>> +    uint64_t bitmap_size;
>>>>>> +
>>>>>> +    gmm->block_size = qemu_real_host_page_size();
>>>>>> +    bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm-
>>>>>>> block_size;
>>>>>
>>>>> imho unaligned region_size should be an assert.
>>>>
>>>> There's no guarantee the region_size of the MemoryRegion is PAGE_SIZE
>>>> aligned. So the ROUND_UP() is more appropriate.
>>>
>>> It is all about DMA so the smallest you can map is PAGE_SIZE so even if
>>> you round up here, it is likely going to fail to DMA-map later anyway
>>> (or not?).
>>
>> Checked the handling of VFIO, if the size is less than PAGE_SIZE, it
>> will just return and won't do DMA-map.
>>
>> Here is a different thing. It tries to calculate the bitmap_size. The
>> bitmap is used to track the private/shared status of the page. So if the
>> size is less than PAGE_SIZE, we still use the one bit to track this
>> small-size range.
>>
>>>
>>>
>>>>>> +
>>>>>> +    gmm->mr = mr;
>>>>>> +    gmm->bitmap_size = bitmap_size;
>>>>>> +    gmm->bitmap = bitmap_new(bitmap_size);
>>>>>> +
>>>>>> +    memory_region_set_ram_discard_manager(gmm->mr,
>>>>>> RAM_DISCARD_MANAGER(gmm));
>>>>>> +}
>>>>>
>>>>> This belongs to 2/7.
>>>>>
>>>>>> +
>>>>>> +static void guest_memfd_manager_unrealizefn(GuestMemfdManager *gmm)
>>>>>> +{
>>>>>> +    memory_region_set_ram_discard_manager(gmm->mr, NULL);
>>>>>> +
>>>>>> +    g_free(gmm->bitmap);
>>>>>> +    gmm->bitmap = NULL;
>>>>>> +    gmm->bitmap_size = 0;
>>>>>> +    gmm->mr = NULL;
>>>>>
>>>>> @gmm is being destroyed here, why bother zeroing?
>>>>
>>>> OK, will remove it.
>>>>
>>>>>
>>>>>> +}
>>>>>> +
>>>>>
>>>>> This function belongs to 2/7.
>>>>
>>>> Will move both realizefn() and unrealizefn().
>>>
>>> Yes.
>>>
>>>
>>>>>
>>>>>>     static void guest_memfd_manager_init(Object *obj)
>>>>>>     {
>>>>>>         GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>>>>> @@ -375,7 +400,6 @@ static void guest_memfd_manager_init(Object *obj)
>>>>>>       static void guest_memfd_manager_finalize(Object *obj)
>>>>>>     {
>>>>>> -    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>>>>     }
>>>>>>       static void guest_memfd_manager_class_init(ObjectClass *oc, 
>>>>>> void
>>>>>> *data)
>>>>>> @@ -384,6 +408,8 @@ static void
>>>>>> guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>>>>>>         RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>>>>           gmmc->state_change = guest_memfd_state_change;
>>>>>> +    gmmc->realize = guest_memfd_manager_realizefn;
>>>>>> +    gmmc->unrealize = guest_memfd_manager_unrealizefn;
>>>>>>           rdmc->get_min_granularity =
>>>>>> guest_memfd_rdm_get_min_granularity;
>>>>>>         rdmc->register_listener = guest_memfd_rdm_register_listener;
>>>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>>>> index dc1db3a384..532182a6dd 100644
>>>>>> --- a/system/physmem.c
>>>>>> +++ b/system/physmem.c
>>>>>> @@ -53,6 +53,7 @@
>>>>>>     #include "sysemu/hostmem.h"
>>>>>>     #include "sysemu/hw_accel.h"
>>>>>>     #include "sysemu/xen-mapcache.h"
>>>>>> +#include "sysemu/guest-memfd-manager.h"
>>>>>>     #include "trace.h"
>>>>>>       #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
>>>>>> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block,
>>>>>> Error **errp)
>>>>>>                 qemu_mutex_unlock_ramlist();
>>>>>>                 goto out_free;
>>>>>>             }
>>>>>> +
>>>>>> +        GuestMemfdManager *gmm =
>>>>>> GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
>>>>>> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block-
>>>>>>> mr->size);
>>>>>
>>>>> Wow. Quite invasive.
>>>>
>>>> Yeah... It creates a manager object no matter whether the user wants to
>>>> us    e shared passthru or not. We assume some fields like 
>>>> private/shared
>>>> bitmap may also be helpful in other scenario for future usage, and 
>>>> if no
>>>> passthru device, the listener would just return, so it is acceptable.
>>>
>>> Explain these other scenarios in the commit log please as otherwise
>>> making this an interface of HostMemoryBackendMemfd looks way cleaner.
>>> Thanks,
>>
>> Thanks for the suggestion. Until now, I think making this an interface
>> of HostMemoryBackend is cleaner. The potential future usage for
>> non-HostMemoryBackend guest_memfd-backed memory region I can think of is
>> the the TEE I/O for iommufd P2P support? when it tries to initialize RAM
>> device memory region with the attribute of shared/private. But I think
>> it would be a long term story and we are not sure what it will be like
>> in future.
> 
> As raised in #2, I'm don't think this belongs into HostMemoryBackend. It 
> kind-of belongs to the RAMBlock, but we could have another object 
> (similar to virtio-mem currently managing a single 
> HostMemoryBackend->RAMBlock) that takes care of that for multiple memory 
> backends.

The vBIOS thingy confused me and then I confused others :) There are 2 
things:
1) an interface or new subclass of HostMemoryBackendClass which we need 
to advertise and implement ability to discard pages;
2) RamDiscardManagerClass which is MR/Ramblock and does not really 
belong to HostMemoryBackend (as it is in what was posted ages ago).

I suggest Chenyi post a new version using the current approach with the 
comments and commitlogs fixed. Makes sense? Thanks,


-- 
Alexey


