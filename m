Return-Path: <kvm+bounces-33905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E2F19F43AC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 07:27:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0B0816C3CB
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 06:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8509D15F330;
	Tue, 17 Dec 2024 06:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TATwovkE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B928BF8;
	Tue, 17 Dec 2024 06:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734416845; cv=fail; b=n3BdVpU/9ni3fpYeH6hMchGSja9syu2NVWhD/w6ixTJvdNkGGddgYny+ooYgRTS3kddzg8cGLE1+gHyb2W9qhXrK6Q0KEcMp0UfOiKg6Tb6uUAJFPVnTMbeU+11FjuE5kwvRGubBqNoLln1DAYQo6vsbI5k090xDlcd/nJWRFag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734416845; c=relaxed/simple;
	bh=7deBrLHembMeX8J3ZR1wOQJ3qAtCZ1G7WdjWfXqQOzg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pElaGg/LHJbZXsj/ozQdOJChdpIKynSuxrl//+IHjw+Lp4T40bG1bJr7o9cDIyrQjtu+pOAPlZKaORH/50bJRuYVEnPYw7ACx+88jwDLs3YYvaB2D6Oss2IWF/3T6q3rkwEJOn7YlFiXoTwxgcCAHNtHP56eh+ijysKUDu9qGBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TATwovkE; arc=fail smtp.client-ip=40.107.95.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrZvQatPEiuP4SdPkSexNBjEJQlRRje3SLdSdjRux2wo0te45O7tIubeVs63ojLRcU9Jig/afyWxPH9hVH3otBofuJV6t9uLFaIrPFH5VGk9HzpFr8L4h2oPOGvfDRb77UXRZZpBTKJxAO+6oxegofU8SgvU1wjIycEblpx8/etC4AKlX1Lgs0XwK6odWllmkTXfKn5OxYZzJaN/Gaa89DKBT+AEH5NvgAppuiZsd9VEir2ETeSzuhyVaLrmK5VVr0vm30Qf5j4tS9ZAn+ubbFIRRt6ifEk0SreuyBydFpP0xaF/K0Q8IzEFTCMhtTmtaxoBFT9UVP6BzW8tz3oyDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfQl1K9/gFzsIqs5PHJF9MZ8su3EEwPoJmCTaNpsNUk=;
 b=J1L/XdFEiO8sxU/0ws85MHGxNGmSYVgsx6ytT/j35ElJV7t2HfxoRd+tq16697QSdK/ZF2LeqAOeEQg0L6CMqr7urtctNs/omCSVQt7DgdYHFhJzXr8Xpuu3Rao6UUlpScvT955U0180nTuqXdknh5FUp2pYZVrLaLW7f5gWONYUfaEZx1tx5c5Rs6BwhSXCDbfPEKiQgeP8L8jjuioDG4Tjv/e/9SplcWrbKhECOmIvUPmPZwdRA+CEEwsqyepPssNyddUhXsNZOXjIuQHeu47at2SKhCB5tzJ4fa9fXWeznxs0utGca/GcPvQD1Mvwf7/rRvSK/ablMj8PwQrQpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfQl1K9/gFzsIqs5PHJF9MZ8su3EEwPoJmCTaNpsNUk=;
 b=TATwovkEGKRG6ILcz0h3PSJajQpjBg4XM7UgV8dOeTkhOtPUgtLTo8AOmvsLGTlOHxOkITbVdrVp/s89Yf4NZQKNiahWi4nVaOPYAloKlBf8jYBTa+s/Rxi80gipkqhvxFzT6t75lpPe6zQX7tDHESE4ArKxFjWFwPT2tdCEDv4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB8122.namprd12.prod.outlook.com (2603:10b6:510:2b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 06:27:21 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 06:27:21 +0000
Message-ID: <04ce52ca-4123-42e5-924c-1c0c47a7f268@amd.com>
Date: Tue, 17 Dec 2024 11:57:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
 <4dc0f6d9-764d-69de-6a4f-ae0f9a4ca7a8@amd.com>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <4dc0f6d9-764d-69de-6a4f-ae0f9a4ca7a8@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0217.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::15) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB8122:EE_
X-MS-Office365-Filtering-Correlation-Id: c37cc2c7-cf16-4128-f7e1-08dd1e63dcb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1B0Y2kzcXpzWkUyeHhST2F6ejNhdThwSWNDYXczNlowcVhpcG5nZy8zT0xY?=
 =?utf-8?B?dERVamYzSnRxdzY1aWpjYmx6K3RCd0d0d3Y4dVM0c0RqQW8vNW01dnNVa1V0?=
 =?utf-8?B?ajFxRWkwUDJEREVuVGlFS1lvY0RDUVVBenNkV3BZKzh2SWxjWkZBQ2pReTQw?=
 =?utf-8?B?NTIxV3lZbjFjeEVXcDlkWjhYcXIzbGx2eWZxd0R6UVYvdytkcWxtS256VkN6?=
 =?utf-8?B?ZEVMYnBRWE1oNWVuZHM2alAwYzlBd3pHWmE2ejlOQmRjdmdYTTEvNnk4OXJ5?=
 =?utf-8?B?N1ZoOUNtenZSRGRaeW1aQUpxYWtlSWJtcGtZYk9zc0dicUFTQjhUR2RpNmps?=
 =?utf-8?B?c1h5cSt0SVZCRUVqVklLdFRTSnE4RHlndzE3MmVxK2Q1T2xHMzRUNDBsb00r?=
 =?utf-8?B?alpRdE9rVW1lT3diMUJmUkhreW42YnlUV2JWYncwK0FTSzlYbWkzeTlZK0xN?=
 =?utf-8?B?WjBydWYwc2I5NGFXWTFubGNTcmdicmF1U0dxeTIyVHBFYVA5MnlVWXpvZ3lr?=
 =?utf-8?B?TEhqdGtnWG9TeGwrTUhiZ2RXS01Pb2p5c0krRFR0U2EvNlRtcXBDTTdzeDdE?=
 =?utf-8?B?R2EyY252TldvWjdwUWQ0NVdTKzZCbHpoai9JTUpVUldzV08yVU9GVUg5VEJH?=
 =?utf-8?B?WFNIVEE1Qm1LUFhKaldlM2lobXZCVzdXUmhOZUFHUG9kNm90WWZzRDVXeUEr?=
 =?utf-8?B?c2VUQVBDTlJQTkw4SWNTUm1NN242U0haWjJXS0lOVlVJYUxlcUdwOEtXNmJO?=
 =?utf-8?B?ciswQUVFK2p5eUdSenlHK3R6QldKZFRLSVV4U1ZnVFloc3JneXNhU3k0YU9r?=
 =?utf-8?B?bHVnSWl0ZjJYaHZSSXo5ZDNpTnpZY0R3YU03RHdieEovbzM5NCt5NnErOUlh?=
 =?utf-8?B?eVpUZ0dPdHNKbk5lcHoyQWs1U25VRU1ZQzd4Y3RDTUUwTUNybEhoYWVzMDBF?=
 =?utf-8?B?UWNqOHpJZ1lrbUc3K2tKSHoxdXVNYk1MVmM0eHlxLzhiRXpqdEtRVGRPb2tP?=
 =?utf-8?B?bmtSM25kWEx6bUUvYWJCVTBtZXp3elg3OElDaVZVQlhma2tRVmxRclUrQ24v?=
 =?utf-8?B?cFF6SFhYSWNmTEVBNVJHWlc3amxKaENxc2pXU1dHQWkzQ2FVa3l3S2dKQnpm?=
 =?utf-8?B?TSsrVzJpR3VUWjcrMEtuV0F1dGJNYUZveVVxdDM3cUF4Z0ZhbzcxeGV4cmgx?=
 =?utf-8?B?ajgzN0hFVnhoRlI4Rk1tT3I5emFtTi9QVWJmb2dHZnJVdVFVTWQrdGc5Rzc5?=
 =?utf-8?B?aVhRM2hXeHE4YzZ2ZUQ0VlhFOUQyNkwvSkU1Zys3QWhmd3hQZnJvS1VTTWRS?=
 =?utf-8?B?T2hXaHNlTUNmWnRyQVA4cndja05sSHNleDJwc0YyNlNJSE05RnNBUGE4bXR3?=
 =?utf-8?B?ZU1peTJNVUloNmJPRyttVlJBVkVpOHZzb1Q5SUZpdk54bFpkVHNqdHMyVXg1?=
 =?utf-8?B?QW5uQ0xLWkowNG5uOGdHbG1Halhqc1o0aWtJaVlCb2hBdGRKK3QyU1Z6VVg0?=
 =?utf-8?B?QzBNRFJGOVV1MjNQNDhjUmJRTWNDSVJkdXhVdmRtbUNUWC95d2VMMFZGcEFE?=
 =?utf-8?B?dzBOWHFTRTgyS3JhREJEeDZDbC9UZDFKd3pjOGQzc05tUkdQdVVIK3hzRHZ4?=
 =?utf-8?B?cXpCZVM3d1BTV1gzOFNlVEI3TEJtQTA0R2xDZjN5SWtkVFprWkZEaFk3Rmx6?=
 =?utf-8?B?d0hSVzlUSHpZczNidEJYWlhkZ1Vvai8yY05LaEJuOStMQ25vNmF5Z3JqN2tY?=
 =?utf-8?B?T2NrT1dxbUp2MzhleWVPRTF6NHd0cEpaYXFXbkFDWlpEOVhBK1FZRXI2Ykp0?=
 =?utf-8?B?QWNBQnEyYkpFZkFXWmJ2WmVYcTNpMmJ2Uk9KNmk3aXZmREZUdHRSMnp6OE9i?=
 =?utf-8?Q?/2/wF8z9WRTx2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlQ5SHZ5T1BpRlFub2lJSm05UFJiWlZJQ2duNENVVGxiNUEvdXhHaDMwRVZ2?=
 =?utf-8?B?N1QvckZRYmwwaGc4c0ZTV2NtNE4rQ3VCaXA1MW9TdURqdk0wMUVmOTl0RU16?=
 =?utf-8?B?NXVKUDIzY0xzYThQNU8vdUJRWktDTUVLcWt5ZVd6TUk5b21hMVVSd21wYkFX?=
 =?utf-8?B?ZGlkWm4vN0xqK3ZLL3hqUjQrRnF5ZzVWSVFDYm5lMkJSWnlkYXdvNVFrV3ll?=
 =?utf-8?B?YnZDdFI4Qy9kWXlMK2MxRmhhMWlHL3pXSUlET2QzQkN1bnRqYnZVYzhEaG5v?=
 =?utf-8?B?YTFuQXlxZlQzdFJYcFM4K01VZXdNQzJzZTJBSEZzUnI4QkllN3pxb0Zhd0xp?=
 =?utf-8?B?UEgvZjVWVnQzR1k2cUdXN0tHUU8xNkJyZzUxdDY1RkZzRElJRW4rYWRyQStT?=
 =?utf-8?B?Y3RPM0F5YU8vZzM0RGJQam9tU0V5STVNUDRSS2J1cjB4dFhQQjE5UjR2RXJF?=
 =?utf-8?B?WTRxaDZGb0tHaGUyaWFwdk9HODY0ZktLZXhEek95M0ZuSC9laTZKWWRqSm5S?=
 =?utf-8?B?Z2hySUl1eFpadXhVWTB5VDl4aUpydjczTS9tdFRJTlhOZXM5U3R4NU52Q1Qx?=
 =?utf-8?B?R3R1WDVxaWF5RzRXazBobWUwRkNWblZYeGhuT3lCUHRMSTlXUHUvSEhCdWhX?=
 =?utf-8?B?UWJETktiRDJFdFlFdkRMNm1SV250WFRLOXo5REliU0NyV1htNUtiK21maGh4?=
 =?utf-8?B?bGR5WXpKVnBodjBJY3BHM3lsc0FUWm1XNDd4YkwxQkQvemh6Rkw2UVlnZWEw?=
 =?utf-8?B?KzRaNWVtZ00yZktYck13Q2g3Q3JDc0dpN0pUb2hIMm8xSUVTMktpM1MxRWxH?=
 =?utf-8?B?cDh6SVlvdVpVNlo3S3hZTDFzallsd1pjbStkdzBSK0IvZGc3dlMySXRyWXla?=
 =?utf-8?B?eEgvMmZ4MkRLZmJkTk44MlZpdHZDQWlsRUR4MkZLb2JSUEpsd1dCNE1sVmpN?=
 =?utf-8?B?SC94YTNPb1JuWk80VCtPTTZOcWRNSkh3MUlwbjhXVXM0aVVocXNraSthUURV?=
 =?utf-8?B?VWp4Z1k3S3Z2bG9rZCtQSXBGS2wvWjNvbVVvMGhpRm53NnFwbWZITkdFWHVT?=
 =?utf-8?B?cGcxNUs1bVVDaHNKbTVHVVdZK3pPL1BvVkVzZGhtcEJCbWZNTTJkd1BDMnpG?=
 =?utf-8?B?Sk1UV3lyUlhRRGtmZHc3c3UrRnNxSkhDTE4yN1c2Rjk3dUYySUVHZzZGRXNm?=
 =?utf-8?B?STlHcURQMXBaQzFoSFdhclVjaC8rMGNyRzZicW84cFNHUmpMQlBBM0tsNzd1?=
 =?utf-8?B?b3lDK3MzWWN3eVkvb3hZZ0s2SW1FRlNlaVBGc080VERGNURLZmVCanNrWU9U?=
 =?utf-8?B?bVlVc1Z4Zk51bEZkU0pKcFEwQytnZEtoZ2NPWjVUVEJXc3YyTWtiM0RUWVEx?=
 =?utf-8?B?MS92bTlndDhMWkxhUjZEc0J2SzdCMm9KSCtXWlVZcVJJaTVwTDM0dVc4cEMx?=
 =?utf-8?B?WjcxT0xicE5yVys0cUllVDI5Y3l5VXNVaUZoMFhYakQ5N1J4TGlCTHlNZzdX?=
 =?utf-8?B?Z2wwNkpzNEtDNmErRnlJK1ZVektLZGQreUJlZ3hSekk5NURJc3daQmpYeGVq?=
 =?utf-8?B?b3dtSjFBcTdjTHYwcVhnNTJKMWhPTldzallKQ2tOVTdTN2xTTjkzeTR0YU1T?=
 =?utf-8?B?VVZ3ejBhdmpSUlhIaXNCazRNTW5hZDAwMzlQZDlyV2FxN1NLY3VoSmhyVzRr?=
 =?utf-8?B?SlR4SUd2OE9FNnVjK2lndkI4c2FZQ2RBVGhrdW9WVVlLdkRHMGhmbDVvK0pq?=
 =?utf-8?B?SHd5d2p1WGtaVTR4dk55d3JJZFh3QzhFRGZWc0lKWTNBa1BsV3k1NHVxeHlw?=
 =?utf-8?B?dEljand1UUNnOXBLRi8vaUpERlovUlo2L1lHd1l6SlAwL1ZzeE5BL1R4dUhk?=
 =?utf-8?B?NXc2ejVqQzM4K295elZmN1U2U3JKd1NCN0JnUG5ldHowdERKLzZydEliMCtt?=
 =?utf-8?B?ajV0N1lVNjFPcGVuSmlOMmNQd3ZHWTZFL09vb2hTaGg5N3AycC81SGRoS0RH?=
 =?utf-8?B?alQ4Z0VseUkwclBaTnpjcDR3SGhIUWpZVUVyZ0JDRzFHYm1UR0lGOXQ5RW1W?=
 =?utf-8?B?MTJrRlRqSUNyQSs1aHBERVA3cHE3SVgzZjNvcW5hbExFL0ZYY0hBUC9RaEkx?=
 =?utf-8?Q?0g5su+rRPB6cCq/GzYhnAziqm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c37cc2c7-cf16-4128-f7e1-08dd1e63dcb4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 06:27:21.3559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZK1OXmOR+MyaL7fLviZ3IS8BFJLH7eqR35OH3XDgm+HZsZHXmDa5Ft9C3/mX9f1pg2KsNF4+AQadcBqSAy+Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8122

On 12/16/2024 10:01 PM, Tom Lendacky wrote:
> On 12/3/24 03:00, Nikunj A Dadhania wrote:
>> Calibrating the TSC frequency using the kvmclock is not correct for
>> SecureTSC enabled guests. Use the platform provided TSC frequency via the
>> GUEST_TSC_FREQ MSR (C001_0134h).
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/include/asm/sev.h |  2 ++
>>  arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>>  arch/x86/kernel/tsc.c      |  5 +++++
>>  3 files changed, 23 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 9fd02efef08e..c4dca06b3b01 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -493,6 +493,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
>>  			   struct snp_guest_request_ioctl *rio);
>>  
>>  void __init snp_secure_tsc_prepare(void);
>> +void __init snp_secure_tsc_init(void);
>>  
>>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>>  
>> @@ -536,6 +537,7 @@ static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
>>  static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>>  					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
>>  static inline void __init snp_secure_tsc_prepare(void) { }
>> +static inline void __init snp_secure_tsc_init(void) { }
>>  
>>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>>  
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 59c5e716fdd1..1bc668883058 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -3279,3 +3279,19 @@ void __init snp_secure_tsc_prepare(void)
>>  
>>  	pr_debug("SecureTSC enabled");
>>  }
>> +
>> +static unsigned long securetsc_get_tsc_khz(void)
>> +{
>> +	unsigned long long tsc_freq_mhz;
>> +
>> +	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>> +	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
> 
> This should never change, right? Can this be put in snp_secure_tsc_init()
> and just return a saved value that is already in khz form? No reason to
> perform the MSR access and multiplication every time.

This happens a couple of times during the boot, so I think this does not
have much overhead. Something like below ?

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index c7870294a957..69b65c4c850c 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -103,6 +103,7 @@ static u64 secrets_pa __ro_after_init;
  */
 static u64 snp_tsc_scale __ro_after_init;
 static u64 snp_tsc_offset __ro_after_init;
+static u64 snp_tsc_freq_khz __ro_after_init;
 
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
@@ -3282,16 +3283,18 @@ void __init snp_secure_tsc_prepare(void)
 
 static unsigned long securetsc_get_tsc_khz(void)
 {
-	unsigned long long tsc_freq_mhz;
-
 	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
-	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
 
-	return (unsigned long)(tsc_freq_mhz * 1000);
+	return snp_tsc_freq_khz;
 }
 
 void __init snp_secure_tsc_init(void)
 {
+	unsigned long long tsc_freq_mhz;
+
+	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
+	snp_tsc_freq_khz = (unsigned long)(tsc_freq_mhz * 1000);
+
 	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
 	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
 }


---

Regards
Nikunj

