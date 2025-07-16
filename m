Return-Path: <kvm+bounces-52605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE37B07220
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B6711899FA8
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5352F0059;
	Wed, 16 Jul 2025 09:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vB39Rkcx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3FF2EF64C;
	Wed, 16 Jul 2025 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752659206; cv=fail; b=deWkuKRHZb1g920dkH7L3Ooqi2Ws9R77kbAoRTnux3/zb1Ha2JvkBNK4xfuaoJXgg0og7KNYMXM5tgV50WP0cOMRWhQOPjX7Gpgg7Mv1X6PdN+nCqZoXu5XmsngA19GbbF1ppixhmk+R6alf9uXTt+1KHKERtmi6ZD5bno2bt+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752659206; c=relaxed/simple;
	bh=DUUMGcP8tHF244OgKncK6eCJmKLKQyItxJ2OhCgolyA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rsn+T1l5jM6ZJ8BbE5yxmBppjY9hS4gMV8v5oDPILJBcwxKICYp5Y+cb3Iq9N7LVtFKknkTDvnwdRsfucFTY7rAIeZalTr99+TZWB59cS0qcg2Um05h/OFYwLJi8xdjh8AodpVbOBKceX+85EWpK97itklzSipl//5/TfoXJoec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vB39Rkcx; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U89Bn9B0EqejSGDkJIUglr34RZ/d737Jffu9h/7PQ96YmsXa5bGL2pcJWj3VLcmMe69A2UuRABwzgfIh0xoa57/30JnD5o84Qx4SU6WjRCKGKweQR4b2IZs0dyd7TivsHDnXRoRwqbLfbHA/NqqqnNXwB+23VOp+tsdetIxQ05GpzKBSOYrzVbLE3aBn6NC7RvA42Vo4EuAa0GOuzmCwW9QL61YNjUgvRjqNZMqOvfdA30CCG2Na6RSVWDkArjNE+QCotLVtGHkm61QidJrQBNaVMaLa1BGGjE5U/yxHTMaCiYycIJkiougJ0G9mPDpmJC7hHshHKX8WvYs+fOb7LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbrYLpHnX3WNUjZlnzkkhqrZbNvy24fvuDRqDOUnEw4=;
 b=fPTrbjPfd8pkNNW50uBiDOxnZWiHxYm+JHYUtzfpX5lBPG7uZyzSMSrfF1GnBlv3HwFSKRdooQvQ8QJHfquFtkbsYoQfDdW/UhTY0y9pvC0PmrDYGA+AXDl1/TVGkOGKxoLIPw/fPPnaRdHAQQ1Fda+G80s188sRfG+zzUg+n/ygPxgYu4/nsttTJcrb3xkG8N/oZ6P0HbWFOgwmCoYhecUsmlor3maybDrRaqgXACTq74Zdx0vAgWByuzrmiz9PPBBi17Rz4hZkAnlaURHovoX7kr0ZykNzR+UzzEb3emGgqVRtX2dxfoTRGsXA0dQ878km0koYngFhdUZqa29Ktw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbrYLpHnX3WNUjZlnzkkhqrZbNvy24fvuDRqDOUnEw4=;
 b=vB39RkcxOVuBsV5fcvPGGemvnTDpxNNV4aDXjYf65t+p1+oqNGml3mSK8mwIPnj6jzvSZtZlWKlBaPIZ3MYaFyohhYeLjl+Zd/MhWFValZ/nOb+8TINtQtdvtB7qzDE/G9SsAzmQoq8zxD44heFPkSo+YPsv5tELplpziLHLWaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS4PR12MB9564.namprd12.prod.outlook.com (2603:10b6:8:27e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.36; Wed, 16 Jul 2025 09:46:42 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.035; Wed, 16 Jul 2025
 09:46:42 +0000
Message-ID: <529c8436-1aeb-41bc-94bd-8b0f128e6222@amd.com>
Date: Wed, 16 Jul 2025 15:16:27 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] iommu/amd: Fix host kdump support for SNP
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <ce33833e743a6018efe19aa2d0e555eba41dcb96.1752605725.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <ce33833e743a6018efe19aa2d0e555eba41dcb96.1752605725.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0107.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:276::10) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS4PR12MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c3faf0d-054b-4cd8-a75d-08ddc44dab50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFZoY0Z2TDJkYmYyV2I1WXFRSFExSDMyaUZTdG50dy9JVHJGNVdiUFJGeU9C?=
 =?utf-8?B?NlJieWY4M1ZoNkJtT1VsMjBrTmtndXF6cEs5eXFMRmZmVHZHTzNCQVU0OUgr?=
 =?utf-8?B?K2xVMHRpaytMakFFd05qOFVRUjluRC9qaFVTVjNTTGFsNjZaT1pUM2pVRGEz?=
 =?utf-8?B?QVoxNllrSW0vZldlRTRqWW5wNlBENnBGKzNVUEhtR3JBeC9tVU1uZTQ3aTFF?=
 =?utf-8?B?SWZSRXp5RThuejhPMGdpZUJ1VW4xdC9jdXhaU21IME5HN2QrNmRtN09QYnln?=
 =?utf-8?B?VndSOFVtN3hkYjRCS2FrQjVSTTNrZHA5RjhmV3RzeEdDUXRlRWhtZThjZkl6?=
 =?utf-8?B?NUJ0b1BISTd1ZTNJbWVOTkNQUTIzRFA4bWJYc21oOSt1SDFjRXNxRExFN0hC?=
 =?utf-8?B?cTNyZE12WWErWUpMYjkxalh3UWtQU0dXaGU4aXh4SFlqTG5RL01tYlpDVkZG?=
 =?utf-8?B?QmFnUGZvOGRIOXJRWTc5VUJGTkdyMktpUS84RUdOMmcvRHQxOUtJVi9PL3JF?=
 =?utf-8?B?eWYydjZDT0taZ1JPNUdER3diMGh4a3RnOG5LMkVHRXA1Qll3RFpnZGhSNktB?=
 =?utf-8?B?Vk83eHlnRXkxNEk1bzR4alEyZklqUkRvS29QczdzbkdGNEhSSFZSSnltZzVk?=
 =?utf-8?B?UU15TUxHSEhXRExTamd2ZnhtbmRwN3h3K1RvNWFRREFOR0ZzeS8xZWMvYlYx?=
 =?utf-8?B?WlZ0MmhaVjdjY1NJY2xETkZLd0V0a1NBVmc4SjVVeU9MTFM0b0Z5cDlTSmJr?=
 =?utf-8?B?SGc4OVhZNXVFNnFiV0RWUHhwbSttZ3BvZEIvSlJQYzI0VTJESzd5aXBIcE5F?=
 =?utf-8?B?c0RmaFhVN3BvTVFqL1F2L2RqUVlzcmR0Rnh1Z2lETGpCajVxTEpNV2ZZa2M3?=
 =?utf-8?B?dVFVTUp1bEtlWDdrSzRQQkh6TDVXbUt5RXlSNWpxNVNXd2owRHA2Y2dTdkJY?=
 =?utf-8?B?YWxXdG84aDBFRk5HRXRxOWllTVpHd0xsckxmelB6Y1Jxd2ZGSmpReUhZNWRa?=
 =?utf-8?B?cHpnN005UXNCYUE3QmdWV2U4WDd6di8wVmg2bHZscGtSSWIyRUZiMXQ5UXNG?=
 =?utf-8?B?M05ZRTkraHJXd2pSWTl1VXpGTWw2ZVNaZERvRkxDdHdwMUJVT3ZLallPUUg2?=
 =?utf-8?B?eVF1UGxOdllIWjhlV3NDY1cvMjZSbERiY2dJbzdnUm9ucVlhRjEzRDMvWmxP?=
 =?utf-8?B?dTlzKzhZMlVYMnVkR3VFTkpWRHE5WWh5d3FnNHd6SngwajJtaVdQWmZKVE0y?=
 =?utf-8?B?MVVZK2loU09GODZGQ1Z0emgwdU44bTRUNE5CalpjZmtmblQvTlQ2YkpyU3FC?=
 =?utf-8?B?bFNPZ25nUVV0YTJmNGh1OG0vVjFMS2tIRGlGK0FiSEtYNXhDS0JGMnNMc2tv?=
 =?utf-8?B?LzFYbjllaFVGY2Z6ZGVaZUIyKzdBaTRzV1ozdGEwVllrSUJKWGhDV2VDVzV3?=
 =?utf-8?B?VmZHMjRUVEpYMTYxdy9QQnVCOTRUa09raFZkZmphZEZCQmlEWTJBcTFoaUJy?=
 =?utf-8?B?TkV6T0gxL0JTUWZPWnlnc1B1cVRmMW14ZzZpM1NKeThHbVZvQVVGQ3RZaTJj?=
 =?utf-8?B?aURhMGxtaUZsck9SdUhZeU00bDZTSy9PTHI5OE5tMkIwMlpFa0xsTCtkeFE4?=
 =?utf-8?B?V2p2ZnpQblhwODVmd0F3UEYyVDY5WkdFZEVXL1ZIV25wc0RVRy8zTTcyQ1pR?=
 =?utf-8?B?MGJLUWxXL3FvZ0t5bGNFZFpJcm1jOW1JQWFYUG1EOWs2dXVXMDErRkJ0Qnhx?=
 =?utf-8?B?eXR2bHU1WFI5enFNZE9jUXdjUjR0Q1dUbnlXdzAvSCtScnkvMlU3b091Z0dO?=
 =?utf-8?B?bEZZNjJmamNVeDlSVnFaSjNIc2kxbTZ1WkxYUkN5dm4zeEtQcWNpQjI1QzRO?=
 =?utf-8?B?WFF5K0pYQWFzSFkwa1VrRDdzMncxQ08xTEo1N1dEREY0LzhGZjBZcW9UcWFS?=
 =?utf-8?Q?LJ97zZtNcSw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVZTaVlhWXNGdEtxaVpVVDJFWDVRUks5MitIVVgyQU94NnlKUXZCY0ZBOUNk?=
 =?utf-8?B?KzlmRjZyeERpdkh3U0JJWVJibTVyK1oxQTRkdTNVZXZXNVVkc2o0M3RXeWwy?=
 =?utf-8?B?VnEvcEROSWNVTS9RMzJNREo0OUpCNTJndWR1bFdCcW10RVBVN0x3UEM0ZTBy?=
 =?utf-8?B?RDg1UWxBaHh1ZGJpM1VGVFdrT2orSCtEY0hxcEltTXp2QWc2azFGTUMwYVdM?=
 =?utf-8?B?blRHaEJZcGJXWlZ4bHUxU0pHeUJsbUd5aGI5c1hsMEppT2hKZ2ZJSTZ6bmpj?=
 =?utf-8?B?SHk0ZjU2bk9LSXdkQjBXWm5GcXNJeSt4ZjlnZm9Qd3R6ZmNROWJ6ZkRBRkMr?=
 =?utf-8?B?a0RRbjhwVDdYbldqYjBwOVl1MHBZU2ltMDVOZ3N6K0FROEtxVUx1bmNPY2Rj?=
 =?utf-8?B?bTduTWo0UDRiMG5mbmVPVWxMNWtLZVFqdU8xdlRiL0VuU29PV25zY3FDTzli?=
 =?utf-8?B?dG5xNHdDSmwrWjVTMjVLMEFjWEhJVXRFRHVKZjZPei9XYU93eFhGZzhGcHZK?=
 =?utf-8?B?VG5iLzBSMms0SCt1YjR1T0x5V1pqbkl3bTlSNlF4VVMrd1RaalZ3alpHME8x?=
 =?utf-8?B?UTQyRGFZUFlRbHN1OEIwVlY5dVU3RXpwQTB5VnZOUDhxVzZmWmFVbVZXb0Ur?=
 =?utf-8?B?cTdEeUI5N091NTAzV1hiNXRDUCtPdHN6eXYvZjdvYWNWVEowQTBRdksxTHhQ?=
 =?utf-8?B?TksvNGlQb0E5RUF1TzFoNXk5bGZzdXRxU0FYYW5iUzlnN2FPcmx5Ulp4VVZZ?=
 =?utf-8?B?TjhIREQzOUdZNXRvMDEwcU5lTEVLSUlOcVRhV3RabGJqVmtDdGdwZUR5NThv?=
 =?utf-8?B?MmZJRUNHSlVFbGpPV1pEOE1FZXRyRVdjVG5HZlhBMXhpdE5POEhHZTBJTjJy?=
 =?utf-8?B?eWRVZ00rNmY4TzVrdW96YVRKLzAzdE9vUk44bUw3ai8xU3ZBeTJBbHE1UkQy?=
 =?utf-8?B?NDRvb29HVTNLaDQwK3FyM0NzcU42NktvdjRKdkJINHl5Z05PbHZoaUdFSks3?=
 =?utf-8?B?ODNsVEZzc0t0R3Rta1VTK1NoclVGRnBjQ1ZYcjNQdWdwQ1JPaEV0M3d1bk1v?=
 =?utf-8?B?bUdrMysxZnZGWThQbXhaaWRHRWFwVDBRdnRscTYwaTJYZ3BTQjJZSlVUaDZX?=
 =?utf-8?B?WVNUNmJHNW5kQ2FPcmZxbkJ2NFY1Y1JrQ2Z0NmdGQm1pN0JLTVhkRzlVUjRz?=
 =?utf-8?B?c3VYNE5hSnFOTktWTC85WkZnOVVISEpKQUxBYloybnN2ZTRMcTlwdjBBQTAv?=
 =?utf-8?B?MWg3TTlsdjBaU0IyQXVteFNsRkVrSEF0UjhGV2FvU3F1VDRqZXZrQWc3SS8y?=
 =?utf-8?B?SzVpWHBwSzdkdU9mR1Q0MEdveWhVQmgzbWpnL0tRS3V0b0lTVUZYampsN2ZZ?=
 =?utf-8?B?TkN4aDNYSlRhK3FqWGUwZ2dmMTA0akdRVWxxZFMzdDdqN1hMUmZ3bU0wK0sv?=
 =?utf-8?B?cytCT3RCTGhwWVcrVlduNThuZjFaM2FhanZsMVBIRzFaYmN1LzB0SVFlbFdH?=
 =?utf-8?B?d1hUNlpHYXAwYmxHd3dsYlhSZDFHTndUOGVpVmkrdlRWaVdvWkh6Uks4b0RE?=
 =?utf-8?B?ck8wd3VLUG5UeWQ4NVV4Q2VzKzJMaHF2SWFMYlREQkhjMlNmYlpQTjhCZ1ho?=
 =?utf-8?B?UHU5OUxGK2FJaU1ObG44WmVVd2g1UTUrekc5T3BvdEEzL0FLYnpyRnNYcVpx?=
 =?utf-8?B?NldpRjNJS1p5U3dvMGlyMVJqUTlFNVViOERmVmpGTzVCa3N0VmdObTRqOEcz?=
 =?utf-8?B?Y1Q3Yml6Tmx2OU92Z3NueGRKMjBCeGdrcTZ5SE1paU9aNzJURW4zQmJINXlI?=
 =?utf-8?B?VHJSK2ZFVFYxdnk1Znc2SDBVcVJnZjd4b2dHek8xV09zMmpObGNnNkpHODlj?=
 =?utf-8?B?MWVEVXR6TVdYKzdxMFFoa3pPTG9oOStGU1BYbzlPVVVCRzFFajFFdHhkUG15?=
 =?utf-8?B?QmJzaDNEa0NuMFNEdlJmb3NNZWc5VFJjdTdoZ1dGNlBrdGxyWWJRaEJVK0xy?=
 =?utf-8?B?aklHUmFqY2lMdEY4eXBCaGpIU0VZMUZteEtrNEZ6Y0pUdTNkSDFNSEx2aEdu?=
 =?utf-8?B?SCtvWFltSm5sekFiaXl3RDcwYXVvb21LaWUxc0FiUlJKR2oydnFON0dyamFx?=
 =?utf-8?Q?iggt+kCPr+DDicSevYi866yFo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3faf0d-054b-4cd8-a75d-08ddc44dab50
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 09:46:42.5919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzaXDTQ6rfnQTz54vbozly6BVcfmTpk4d9UhOUdI1RCntZ4+4LfRIqpCX0/bLpz6oi58rq0mD8567oGkCUqqlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9564



On 7/16/2025 12:57 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When a crash is triggered the kernel attempts to shut down SEV-SNP
> using the SNP_SHUTDOWN_EX command. If active SNP VMs are present,
> SNP_SHUTDOWN_EX fails as firmware checks all encryption-capable ASIDs
> to ensure none are in use and that a DF_FLUSH is not required. If a
> DF_FLUSH is required, the firmware returns DFFLUSH_REQUIRED, causing
> SNP_SHUTDOWN_EX to fail.
> 
> This casues the kdump kernel to boot with IOMMU SNP enforcement still
> enabled and IOMMU completion wait buffers (CWBs), command buffers,
> device tables and event buffer registers remain locked and exclusive
> to the previous kernel. Attempts to allocate and use new buffers in
> the kdump kernel fail, as the hardware ignores writes to the locked
> MMIO registers (per AMD IOMMU spec Section 2.12.2.1).
> 
> As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
> remapping which is required for proper operation.
> 
> This results in repeated "Completion-Wait loop timed out" errors and a
> second kernel panic: "Kernel panic - not syncing: timer doesn't work
> through Interrupt-remapped IO-APIC"
> 
> The following MMIO registers are locked and ignore writes after failed
> SNP shutdown:
> Device Table Base Address Register
> Command Buffer Base Address Register
> Event Buffer Base Address Register
> Completion Store Base Register/Exclusion Base Register
> Completion Store Limit Register/Exclusion Range Limit Register
> 

May be you can rephrase the description as first patch covered some of these
details.

> Instead of allocating new buffers, re-use the previous kernel’s pages
> for completion wait buffers, command buffers, event buffers and device
> tables and operate with the already enabled SNP configuration and
> existing data structures.
> 
> This approach is now used for kdump boot regardless of whether SNP is
> enabled during kdump.
> 
> The fix enables successful crashkernel/kdump operation on SNP hosts
> even when SNP_SHUTDOWN_EX fails.
> 
> Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")

I am not sure why you have marked only this patch as Fixes? Also it won't fix
the kdump if someone just backports only this patch right?

-Vasant



