Return-Path: <kvm+bounces-54586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9DBB24A73
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 15:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BE0A1BC4F3E
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 13:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A8522E11AE;
	Wed, 13 Aug 2025 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MYzVq7w2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FE82E5B00
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755091120; cv=fail; b=NBlD7GjwxMkxUbkJrSha/15VLmyUdrZwOc+xGGirufIiVZgQZMd0l3lUxxgykxEKXExAThVBVJ80CqQtzEDmPUFGkbz8og0ErIyKYycU6vqJHPkWgtQrA4JfZE3sa5/6yq+2fg3yP4xCw9kedQ67i2j0qxHhZMaDSRdKhLGg2xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755091120; c=relaxed/simple;
	bh=jXvGzfzWFoG7sqQ7nMI0OumkeXgfbwqQ2QyHx5OYN7o=;
	h=Message-ID:Date:From:To:Cc:Subject:Content-Type:MIME-Version; b=mQ/zb+jQ8emH9+fV6XXUyX2tSutvkFBeqQ8Ti2JLF4n5b9lWXjvxr9scBVBrCBrYeTjR9YbFCRAMrhK4VDdR0Tx6Nx7m1wEkHqCGmWtBnjH3bG2b2DB2VqDBXK8GWzEepXCnEec+2pYVC9MhDccDQrymZCHbdt7P1PlWgHhbQVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MYzVq7w2; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JKY08orSq+0E3IaU9iWQ9vgBNtQyDuxRsOgOGoMPCjRaBzNK3mslW5w2Ju1eAD3W+srgtn4E/OZ/kapnBjVkRSiV19qVL4zMkZcWfrzeMP/BglKRheTgsaNj5+ctd+XyIc6wEbM/AK6BfCjVxYVsFowBucsdfS3KDmmqEPxfBLql3lw0Fjv5aj0h+o4ZkthB6kilIlZ35ztv8l/YxkeQZNvYpFYteHa6dHkn+nLf/p2GCZf01Q+ctdd9IHEXaqjV0kEmDvvVu9nWP3Be+oMxoKNDKRhm9AboH0WxJTtzAfwe4ig69jzpjE71KAUfxk7jnjP2CF3Y7iOM1N/aEtQULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXvGzfzWFoG7sqQ7nMI0OumkeXgfbwqQ2QyHx5OYN7o=;
 b=DwA5BgP1P0IgR2OytVskeUjNNrbEvjkxgalAY2o7uk+R5UvBfsx0LyozzCkcS+r9y0/2lsnRlr6piO6SPbgoPMXmV+XIl0QhILj1USJU8UarAQdTD4fd9R5p61Kqp4WhKPFyc7DHEK50M3+7mJErA6Ur6oHRm67b4/RkLvfv+wZ+U7O79zkjJXQnOs6wz1+o4nE4t5A0BxmIhU9NuI0ZuiRE8iCXnjn0JCcbDGNgFdFFETLyxnSlPeAkHIBKHPfSjcMFjJiD3HQJ2iKajiyhXPepIr0KlNdNtfHN4wO+qyz1HFA2dbKqs/4YLkAfMdz/Qj3QOkOfGgnOwAE92UeNGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXvGzfzWFoG7sqQ7nMI0OumkeXgfbwqQ2QyHx5OYN7o=;
 b=MYzVq7w2DoO+skuuHXciQDJCWlIznkxolXA1OoMe1GyfwiaaaylSsxzuW6iYCZdSBeWFnxCjZmDIdyvajT4P/GjQFOkpP0gy6hetSr68E9lD1+KlcNzlI6FC+NH6NYexJvb+D2oixnSX7rKkZh6A/e5NtyZe7PSVi92vScBJ58M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM6PR12MB4452.namprd12.prod.outlook.com (2603:10b6:5:2a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 13:18:33 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.9009.017; Wed, 13 Aug 2025
 13:18:33 +0000
Message-ID: <1a054b30-6c3c-8e58-e2e6-c83cb18cb0ee@amd.com>
Date: Wed, 13 Aug 2025 08:18:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc: Michael Roth <michael.roth@amd.com>
Subject: SNP guest policy support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0059.namprd13.prod.outlook.com
 (2603:10b6:806:22::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM6PR12MB4452:EE_
X-MS-Office365-Filtering-Correlation-Id: d4097818-ac5b-44c7-c9e0-08ddda6be71d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3FFSW5CYWRPc2g2bHlDRkdaUjg5Ky9maXkrYnR5SmF2UDVlTy9WMUd4aU15?=
 =?utf-8?B?anNIRDF1ZEZ0QXQ1cng5QVM0Uk5RMlgxa1MrclZ3anB2cU90dEtMbXA5bExa?=
 =?utf-8?B?UlUyS21uS2VSMWx4Qyt0TnZkVkppVC9tMm8wMkFFWXV6cnR3bTIzUVYreFU2?=
 =?utf-8?B?TnlvNEt0cnc3S0E0NXY0a1EweTdjcUJONmdtaGFRTnhtNTduRDRabjBybG9j?=
 =?utf-8?B?bjlFbUJjdTBiTXFSV29XbGhwSUNYRm9RRDhKMXphYVVYZ0x0bWdwejNJWGZT?=
 =?utf-8?B?SVp2a0Y4TDZRbzZvMkxXU3pYSEdOVjdpeU9sTU9LNm9ZMXZnWUc4SWNNUXc2?=
 =?utf-8?B?QmMxSzJZOSt1OEt0blQ2VEZQc2tqOXVndTBhMFJLTjJmWXJacDRlZHlyYSty?=
 =?utf-8?B?R1dPdlE5UHBjRGJsKzJucDVpdFFKanBIcXBpRU1uNjByeVp0ZnkxMmkyYkFm?=
 =?utf-8?B?Y1Ardzd0TWkweTRWWGgydUJmWXkxVDRZb2UwaUo3WHlDV2pDUUJDNGNEY1NS?=
 =?utf-8?B?OFlnVXRoTkNESFlDNDRTbTc0WnV0ZTlvenQyK29zTzM3cEFTUmVzV3FrL3lF?=
 =?utf-8?B?bjZ1U3ZvTzROWktjMnFUd2NsWm9TRkJYMjdrNWVJYysrYndrRWJaWkRXUnpv?=
 =?utf-8?B?L2xyQ01VNWt5NGtQajRQV3NneUJjRFlmZ2tWbzlQRFpVUnhyN05NWWtwL05Z?=
 =?utf-8?B?a1k4ZlR0a3AzUC9oY1FrSDlYRDdZREhYcmNCQkx0UjNTUkJYSkg2VGhqWjl0?=
 =?utf-8?B?Qk9LcFpGUGZhZVVYa0RPMGtCelQxaTlZUW9udDlFSTlTOEVjdVFJdjBHVURk?=
 =?utf-8?B?TUk3NytSQ0NhM3lOYnAxTXZuV3UwbjU3V2JDVEN0RlZLaGxNNDBHNkxoa0dr?=
 =?utf-8?B?Y0txbVpQbU1NeERlVGQ0dnB0MlpmQThaZHQ4M09CNlhPeVM4UTdOTStkSnh1?=
 =?utf-8?B?aDVMM3ZlcTBUL3R3Q0tCdmdML1owanpObHM0U3d6aTdrdFFLQnAxaEtUTTRP?=
 =?utf-8?B?SG5KVlpDRWJ5MDM1ZWg0U3JQYVF5Z09WbGpiemVqZC9ZNGc0NDlvZTZNdlJI?=
 =?utf-8?B?b0ZUNmxjNGkxTjhZMThGQjhBWEZoOTE3Z0xISktFVkJzNlAzYjdWL0w5VGY1?=
 =?utf-8?B?QTZCeHFCN0VJS1VROHp6YTdFdnpwYXExeXpzT3dybzZaOG5xM05CQTNZN3Bk?=
 =?utf-8?B?ZmJROUxyZmU0Uk1IL3h6cUl6bkVQanFZeFgwVnpUdmQ0Tk5RNUcrRE1WWWRU?=
 =?utf-8?B?Qk5lZFpiNGxsQWJPTlk4WXZaOWhER3VLZi9CQjJlTmp1TW5QT2daampadTlw?=
 =?utf-8?B?VW9idll6SG8waHc5ZmdTdDA4eWlVa3AxSmFNSjBMV0F0WHlNVFdBSFJkVWVC?=
 =?utf-8?B?L2tWS0xYdTVsaEQzcFA2V24xV2VnQ1pLVlNoN1NEY2M1eWI1aFZ2ck1xbFN0?=
 =?utf-8?B?M2xnTVlmWUNpM0V1OGRSUlhOS0d4WkQvc29OcmtseFIvSGdWeFpDem8yUjlS?=
 =?utf-8?B?eXFSVW0vMVRCQVZ6ckpZLy9RQ0xEYlR3QmtlakQrK1BkaWpSUzBlWER1MEVm?=
 =?utf-8?B?VWdxaGVJbUxXaDFUbXZpL3FlVmlhOCtERzRBVFBNWldlQjVZcFBhZHQ2cmR2?=
 =?utf-8?B?aUFBSGo0SXpIb3QwbUZmcTJabm1GWUdxK2pDdFVVRkNvYkxIM1QrUGxWMU1Z?=
 =?utf-8?B?d2xBY1pPdTVpbElvdlU3Uk14eUZGYlM2VFQ5bEM2MWZaUmRKK1JoTVhlZlR2?=
 =?utf-8?B?Y2Z0ZnFVN3hyY3lRQXRHNHNURE5XRWZBbWFRNTRqdHpmWWpPMWU2aE9aMG0v?=
 =?utf-8?B?YkIyMXU4WmVnRXhpcklVS2pFTHEvM1h4SXlsSGNGbWovUkl0bU0vR0h4eWxE?=
 =?utf-8?B?bTZiaEhMN3hmdFlXRk9PczhnZVpWeHB5ZlAxN0pvS3I5YXR0MDNNalFtTVQ5?=
 =?utf-8?Q?G+jRSP7bAjU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZThVa3NJenNEM2FISWpGclNMcVR2K29WZ1JQZjZyd05Vcm1GUjl4RU4rUm1q?=
 =?utf-8?B?d1RRdVdDcWlONXpIa3dDY0VoZkdLN2U2YnJLSlZJcnc5UEZxNWFBcE5XcjJr?=
 =?utf-8?B?d1V1Q0tJRGd4ZzZPU0ZpNVoza1FSbTYwbGhMTW5VNlJCamlBVlFNR1k3eTNq?=
 =?utf-8?B?YnpjT2hWU2xMcDhWSWJZbUpBbERmOHp6c1lnS3JtL1pKUGJWWXltbkRVUkQ3?=
 =?utf-8?B?cHI1V2hRbFZJWWFoNnNrWjRsOEJFSFBrYnViQnJJRTFDbStVN2gyT0NqRm5z?=
 =?utf-8?B?UVpsVVhKZVJGcUJKMWZ4SDVzWk9EODBsWXk4VCsxNTNpNnFFeVBDa29HMVlp?=
 =?utf-8?B?cmQ0REZFbVgwSnAzT3RTaFluSTZRTGZnaTFhTGtqU245cXNZQVRqM3Y3VWNr?=
 =?utf-8?B?cnRLRUVHU1VocTY2SEVaVVEwYytoZUF1ZTlNSHVzcjdOV3Nocm8xRkN3TW0v?=
 =?utf-8?B?bG0wdFFIejFKcUREa3dLcWFPV1hBcmtHNDIzZE9PYU0zU2MvNTBoaG5pR1FT?=
 =?utf-8?B?bWp4NVpOdzFNWE1vcUQyYWJaN0FnMUhVOFZjQTk1R1JteGZnMTZVbGJMYXll?=
 =?utf-8?B?dlpQd2g5ODJlM0xLSFlPbi9JSjhudU1ON0N4NmkwNm1sUEdnalpCTXdvVUk5?=
 =?utf-8?B?em5KeXBYdmtyZWIwTU4vc1ptQUpWS2NrbnhIWlRJbUhNdXRUL01GKzREL2pP?=
 =?utf-8?B?UlRJN21Bck9aNFZkcHdGQW9vTlhGQStrZm15Tnk0WXp5YUNoM1ZsNnloeFN2?=
 =?utf-8?B?V0sxQ3hjZklaVzZ0TXR4WG9lODlzcGdEWlhHMkdWaWpVMXNqaTdDUnNWNEZ3?=
 =?utf-8?B?MkVYZTVpL3d5REFGNUZkalpvSklVYVhGMzlJUU1IbU42eUswSGR1SHhtZEoy?=
 =?utf-8?B?UHpPSkdyaHlCYW5TZVJ4anJ2eEVqS0Y5a3lMODhHYW5JMS9rdXQra08rOHph?=
 =?utf-8?B?UjEyenRqRDU2Ry9GYmZudHhhZnRTM2RocXlaTTcycjFoYTl1N1lER0toYmJt?=
 =?utf-8?B?Yi9wTjk4T2NMc0dKb0tWUzhyUUlMUE52V3A4YzBNeXpxcFRxd0RpM0RBUzRw?=
 =?utf-8?B?NUFsTHFHWnFDV2E3WkM1amxZblAxR1pxY05WWGRyL09ZUEl0eHJRd2lmYllD?=
 =?utf-8?B?VlFPSVpJeVVOelVJbXZtS3U2c25uZ3YxUStwN1VNM1hXNUs0MEd2WHpRbVUz?=
 =?utf-8?B?c2VQNGpJN29lLzNsdzNOcHRtTHQ3cG9IYmFiYzR2RU9La3ZVSXdIbjhWdFI2?=
 =?utf-8?B?MCt4WEtuYmwxaGxpcWJWazFJeVlnR1RJSHQ1aHRnbUNKUW9icGNTKzlac1hh?=
 =?utf-8?B?UmV2dW0yWDBuSEhWVnNzQkM0ZTFORVBRd1czTVEwWGk5WFN3TG9JR2tSTVp1?=
 =?utf-8?B?dHd0NXU1VkdYWW1oUTdQNVdsZlRjRUJlREk4V1pleGxGc3NtTmZkbEVuSjg1?=
 =?utf-8?B?elgwREl0aWVSRm44TGhhZlhBTHZHaDh1TlhObnljM2xTbm5VNm96dWJTbWdm?=
 =?utf-8?B?U0Rtekx6cEhMdFlraU0xMUZubUZyZlNnMUtKNkZXRTUvZ1VsOGFMNElEcGxs?=
 =?utf-8?B?bW04WDJGbTIrZzhiZVhhOFV3eTM2QTNvSlltRVRuNnhxbEZkaW96ZStrRGxv?=
 =?utf-8?B?cUJ5ZGlQRllVaDc5Z3crS1M0T0k1Q1lVQnVqTnhZbnc3SllrODIrcU51NlJL?=
 =?utf-8?B?c0Jqc1ZRV2c1SU1DU0lYeVpwYzFQZjVqZkZYUzJ6dmdKU1d0TGJhaldjR3Av?=
 =?utf-8?B?bjY0VG5SVHd0OW1seExBQ1VBKzM4MVdCak9XRG1xMVh2Nm1QaG4vZW91ZGJn?=
 =?utf-8?B?N0oxZmJidGh2WFdxbHlybTdMM3dOdytaa1p1V3pCd0ZSY2J3MWlnUUg1MERU?=
 =?utf-8?B?ZTNDS1dGOHpqSFJvdnd1TUo2bWRlSXJDMG1tRW9OTWtGWDJRY2lvNGpRT0wr?=
 =?utf-8?B?bGNQOVdhdFBRQ21ONHlYc1hJbm5jVUVUcWx6MGIrcVVtL290SXRTcGRiNzZW?=
 =?utf-8?B?aVdkWWl0Yk1MTVdXZFg2QmVFTXBsRDArQnFSZkx6a1Q0WnNXNU1CMjIrblNX?=
 =?utf-8?B?MTcxaythRjNkME1jUnBGR2xrdGRGTnJ0cHFjdHJhVTcydVRqY2tKODd0dzli?=
 =?utf-8?Q?JVn5u3YNUkvNPfYUJRWA1Agnx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4097818-ac5b-44c7-c9e0-08ddda6be71d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 13:18:33.3138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: md6fBPOMHUd0X6jGUkNdA42ry8myJb6Ci3Wg8xWnkiYbTq/dOoOuuyCQQsNfbHO9pv9ffHq9r43pSgMcrdOGgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4452

Paolo/Sean,

I'm looking to expand the supported set of policy bits that the VMM can
supply on an SNP guest launch (e.g. requiring ciphertext hiding, etc.).

Right now we have the SNP_POLICY_MASK_VALID bitmask that is used to
check for KVM supported policy bits. From the previous patches I
submitted to add the SMT and SINGLE_SOCKET policy bit support, there was
some thought of possibly providing supported policy bits to userspace.

Should we just update the mask as we add support for new policy bits? Or
should we do something similar to the sev_supported_vmsa_features
support and add a KVM_X86_SEV_POLICY_SUPPORT attribute to the
KVM_X86_GRP_SEV? Or...?

Thoughts?

Thanks,
Tom

