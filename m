Return-Path: <kvm+bounces-20384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B3C19146EF
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 12:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE4981C2228E
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 10:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D3A136647;
	Mon, 24 Jun 2024 10:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="igu2GpDe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6B63A8C0;
	Mon, 24 Jun 2024 10:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719223441; cv=fail; b=IhSOurzDWKmIJlf/YtJ8HJn4bFfoXs5COySisey6oe5H1oH0mPD7FMlZFoiINr6sjVOzijf8pjYRnDHi31tt/3flANwum8HkTwptaNnVV1qK2ND6Y2o1jCnK6zsxiVryUZq17Yf3iahELqM07K4CBl0q2PudTpr2I16eljyQm/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719223441; c=relaxed/simple;
	bh=bOwihgpc+9l7de8xxXlrzGi865mO3L7XWWf/FXmhK2o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PksUg/ZxyKfbPzv5q//MHq31S8kbK0tb63KNDH9Nl68uunjsWzxefypvcePqigFf/BFazYdkKSKlJzyejfe+RK5yOQll4vjLQdzaEC4an5Gv5yVwx6TcU7Qw1IIvy0elp8LFpwBaKxDaRw0o+YYI6Za4RJoKs+TBZVU8/jY+h2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=igu2GpDe; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPGTXyR/kEzGwvXZL+4bfBnPPIAyikpDpDPL6pKCs9kX9PyUoPptrMCOAH0SD/pt71xKcHo50sdXbH+KkgZquzFSF+bWJwukwtwcRKv6gCRZpV7iF7f52vTFWlVZsyhsdl7q++jsZbCYXEGxYKe9DTxAUsbecruTYO1jd+r/T+elLPM16NTbUUOPMuGzTsDokAuH+EAuXNFxf/UN3VL7FCNgekdhjqpPS/0ceSG2sjnJqoq7+9KzhUccYU2+SXklichuDpF8sTnTw5YeCpFMVC0mCrBk2F4hlsHHRnkIsf0/KQqrnEmzfWwuW7WJFimV7y1Ub8mMMh2IccT+bDCpgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oejQyvo2uZ4MG2Un4eqQONFe4RQeeHtZPv41u00kemI=;
 b=DXKEeA34tZNT2eS2igwHqwHH6EaskbTPoKvB/biT3RQ6KiYe1CAjSA8EowzQ69Y9Ik5vSZNa4Cvm0zIqloiMoCJr6G4JZHvWh0pMXHmxRfY+JaIsZM51TA1CPro09NbhLOHuEFTT064KmvjYL2n6hOjFhp20WSzjSHZcWe1B2NIcQoF3cJqvmGQzIKClO3DtwQ5KCqNezXTCuCEqueWdtweEAPzj2HuMrXQnGoLEt5UihhMvnKXe1slH45Z4xHUW+v7fzISgeVhcCB3SY53p89S7CyMtVMJ3Ds00PCRU+eqFI5vOYAgCTkbNSAK6iq2oPu0jeJqUJZqsueI2vW5nSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oejQyvo2uZ4MG2Un4eqQONFe4RQeeHtZPv41u00kemI=;
 b=igu2GpDehk7zYoSU+mtxQY7ZPinncqj4yMwSUHfcBiC2YVBQoKH2YaNMyNELRel9JjqWSAA7/l2nfdlAYf++mTGzJuo0xwyRI6PTVQrqEogbyK3hI1p12SjN2hKPSz8hvJvm3X9mFy03ONQG6uL7ZuBvjBWMuYzDj0eHnellakc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SA1PR12MB7409.namprd12.prod.outlook.com (2603:10b6:806:29c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Mon, 24 Jun
 2024 10:03:55 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 10:03:55 +0000
Message-ID: <a97feb03-7bd6-2dd0-d22b-ebeda9895dd1@amd.com>
Date: Mon, 24 Jun 2024 15:33:46 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
 <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
 <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>
 <20240624061117.GBZnkOBR5FVW8i6qsG@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240624061117.GBZnkOBR5FVW8i6qsG@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0P287CA0006.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::12) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SA1PR12MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f83e4c-e687-4c34-83ca-08dc9434f526
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXdNYXdLVFRmUlQ2akhsTUF2Z1dDNFphcWNvTmVZYTFoZ1VpQmJWQ21rU0pB?=
 =?utf-8?B?SDEvTktxcDBMREdEL3RSZVNBeCt3R2lpQWcza0dGU3FFTzg2R2lGak5hU2Fz?=
 =?utf-8?B?R0NodkcxV2oyeXVWRVRrV3A3V3ByT0xneGxwZzNsbjY0NU40M1ZCdzV5cWQz?=
 =?utf-8?B?bmpLaXB4YWpUVldDODA4R3V5SWgweVNaOVkwWTNQeTRiWG91T3FwK0g5Y0ow?=
 =?utf-8?B?b0d0NEZQSWlFMktZeWI3dk5yYk1vdnFwSHovcXo0L0ZvcDJOQUdBcnBBVXdm?=
 =?utf-8?B?Z2lNWTJWcGswbTVCWFpVN1U5NlF3NjNrcEUzbSszM09ZdGllTmZwaW95RWFL?=
 =?utf-8?B?Z3FQYm4rTytKS0tMcDN3RitaSGZML3Blai9MUVJpaFpoYWQ3TzRvWXJkNnJ1?=
 =?utf-8?B?dEtTMXAwTW8wSzNXUDZUeTFUbk5FNmhEV0pXYmJKcVN2Q0FoelcwY2IzL1JM?=
 =?utf-8?B?VHdHNGQwUHNPSzJGcUh6TDFnTjFGeE80ZzNVN3VlbWtid1BaVk5pNkZHbGUr?=
 =?utf-8?B?S1E5VklsQVJZWDBXYzV2ZWVzVEN5M09LdTQ4ZVM3Y0g4N1FJa2dyOGZ2c2pr?=
 =?utf-8?B?K3FxNmx1TjVYSkdTcW5nZTNYelhKenNVNzBaU09ieXlUL3JlOXgzWUFmRnM4?=
 =?utf-8?B?dllNU0prL2xZd1JhN1VRazdHakF3MHhMUDJpU3R5WFpFYWtDalBDcFY1bFY2?=
 =?utf-8?B?TCtMVjA4TEZWeElwYUhRYzB5U0labmNETEo4SjNQdlNOT2xvU0V1STBneURW?=
 =?utf-8?B?WFdSaEVlT1djdnZ5cU9YVDRqMXU0WnlsczF1R0FFTHNhbTNhdGRaQVhHTUFE?=
 =?utf-8?B?NVJEczJsK3AyYXVwVTFhRmtlTDc5VVE1bmFYQ0l6eUR5RUpSTE9CM3hubmJZ?=
 =?utf-8?B?WjRzdFU3YlpIaExhZlRTMkIxZW1rZTY1WFJVMFhpb1l6TVlRMldYWExSa2hF?=
 =?utf-8?B?K1YvZWoyU2VaOFM2ZVYzbjQ2WDdabGFWckNUNFZBY2xFWFhqUjR5WG9mSjB5?=
 =?utf-8?B?cWdONk9ycUMxS2tDRHJsSnBNSHo5NGVyT0tlK2tGbWNZN1FoQlEyTUdIb3Jp?=
 =?utf-8?B?Nml6NG5QOHMzRzk5bjVhbERtaHRzNXY2L25NSGkveTJicXdMKzhLKzBtaGhV?=
 =?utf-8?B?Vjd4Y09NYXp1Um5KOHZ6a1BROFpkV1RwSXAyQzJ3SnBuV3ZoQ1JxaE14c0Rz?=
 =?utf-8?B?V3hRbFNzWDRSdlhCQ3ZHUkNyUUtxR1MzU0tQZUpUUEl3TDdnK3dBR2gyd0du?=
 =?utf-8?B?UVFTN0ZsUnZJdDVNMWRGV09TVjdQWHBnQis2ZzlnUG1EMEJ2enRqRWx4Ukx1?=
 =?utf-8?B?M2dDc3V0TmcxYldaRlNpK0VNWHBQTkZoYkZRMXp3MjN1QlVDczMxOXRiWVFX?=
 =?utf-8?B?eFlGT1hvOUhKQ1dyamc0NEpFdmlKMUVnbU43SFV2SEZEQ3h6aW1KNFpRUENI?=
 =?utf-8?B?dGtnb0hkSHpRWURYNHJ0cDZyL0tyNVdJb29rNmROVnpMV2xicFhDOWk4aFpB?=
 =?utf-8?B?UFlQZktOSmo4WUs0WFhxSENUWm9URFNPeE9UL3hOaU5GdTQ4dzF3S2F5ejJn?=
 =?utf-8?B?WEorWW5KelFCZEVSREhRUDg2Vm9zSFViSi9CcENSbStYMWFPTzl4T3JUZlZZ?=
 =?utf-8?B?dUxmeDNQazIySk9wOTUvUWdNeEJoSDlkZnFjbnhzSjZYbUdjZzA3K0o2emx5?=
 =?utf-8?B?bGpFQi9FSVRzVEhxbTNYRG4va21hQVZNUmcyMC9BMlRVM1Y4anAxMktoZnN4?=
 =?utf-8?Q?LE7t9Fie6ilX8IMxAzUmvztKluB6i3tb7vBuABq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjZhTEdmRStwRk5HL1pMZXdXRzY2WXRWWkxkYVpQTTBPcWVaeXJpMlJUMkpB?=
 =?utf-8?B?dm4wRUdjSUxXNUhrREtoS2RLblk2S25xL2d3SWhLQmR2SUlLWUtMUjVTaTkx?=
 =?utf-8?B?WXJwb3YyL0V2aEJvdDUwclNzcmE4SmFUdmljSlIrQ2tYcDNvQ0NlODdIUzJp?=
 =?utf-8?B?dlJUR3ZNV2Z5MHhYajBxeGtpVTRCTWR6RnFZYUVxc1ZXMUVhYVRwNG9KMXI2?=
 =?utf-8?B?dlJpcTAxbHVGRVRrQVAzUktzM2dWM08vaHY1QWZJVmUxMXQwekZHVzZHRE9t?=
 =?utf-8?B?YzZVajRBMHQ5MytIWXJUbHVWejQ2dXdlY2puRDlGWWtGSzRvM09yT3RaVVFk?=
 =?utf-8?B?aVpTdHBvYytaY3BLYkw5aGkrRUNmOTV0NGZlWnpqNUlPVFJQVUdORlhBOHhu?=
 =?utf-8?B?ZERHMXZTejlmTmoxNGhVSGJtR2hlNTJmbExXd0VBTTV2SkJFYXlxaTM1dUR5?=
 =?utf-8?B?cVAraUc2U0VFM0hkNzdsTnBRSkpweFEwd2xuUEFGWWxCOHoreThjYThOS2Jp?=
 =?utf-8?B?cGtoeFUxaE9SRm9DR1E4SGtBL3NmbG1xdlQ4RFpiRERpSS9rVm02Skx5SktL?=
 =?utf-8?B?NmhacDNzd0c4eUFrRWxXclBzOFMwZmQ2WDM0TkgyNWlDc0lvbzJJdTNtUEFE?=
 =?utf-8?B?cDlkZS94TFg3dDZBMUpRM1RPTkEvczQ1cmw4czZmTDNSNDZET0p2d0VLcW5I?=
 =?utf-8?B?MlN2NjBTbGhMYVdSc3hKT24rRWJBaFNHbjFPbnNyQ1Z3MGdMMUQ2RUVnYkxo?=
 =?utf-8?B?MnNRbmV1WC96Q2V1RlFzUHdBOVdKSkIzeU1obS93YzRqWENsclpVMCsvTnhy?=
 =?utf-8?B?a29FOFBhejVadUViV2Fad3dWSnRPa2JFSGxQYVlWV0c5NmZmSmNBS1FDOXZz?=
 =?utf-8?B?bGtLRHJNWDhQQXZwUmVlWllydFVtcEpFUWY2RVFWWjloN0tnaHNVcEIwZ2Q5?=
 =?utf-8?B?VWZFTThKUkg0dzMvRU1GNjdxdE4ySmhsNFJxWnhKQkljQ1MxbGpIZ1phOFN2?=
 =?utf-8?B?djBPOUlnN01OSEpuNnljS1ZVOG5XR0tyUDFpcWE5KzVGODJPQ3h3cGZjTmxh?=
 =?utf-8?B?K1hpSW9Qb3Zuejh0bHJUWkFyMXFleXdrZXFCMjhBWU5mdUFGa0pRcXBMamRU?=
 =?utf-8?B?L1g0ZFN3YlJOMjNZaHVLQ2hIY2FQRGFOeTV4UXVHb05wY1d6LzQramJKL3JV?=
 =?utf-8?B?Sk5rZEJLRmRhOVB5WkQ1VG9OZ1Iwa1dUb21XenpFRWlhZUtvelJ6bWlFeC9R?=
 =?utf-8?B?bGFQTVc1Wll2VjZCb2Zob3dVYWFRVmwxT3J0anJIREZCZTVVMDVFckdHcll6?=
 =?utf-8?B?dExHa3duTUhVWVQ4NzNpQWtocEcxaWp2czl4SHRacFhFL1RLb0cySGplVGli?=
 =?utf-8?B?dHNDV1dlbERvaytqZG5xKzJ5RzA0MlMyRWJhNThJZ0JOVTNVSmtBRHMyclJi?=
 =?utf-8?B?bVRPdk80d3ZvMmYrenJCcXcvYXBZY2hZclI1czREc0FjN1lwQnVSNTFwOHNF?=
 =?utf-8?B?R2FTYTlKN3piSUE0VTRHMzlpMklsQTZoUVRwUVNyWHh5MEdDNzEza0wwTzNQ?=
 =?utf-8?B?by90RmhkS1lMd2N3MFZPMTVGYm8vc3k0blBCMzZWblNZd2JHNEJyTy9BZHE4?=
 =?utf-8?B?a24xWjBjcUFMWWFMUVQzMERYSFpzai9ObUtubEYzRnJadE9vME1VRFVLSGZN?=
 =?utf-8?B?QldkSmdXM2IzNnpiR0Z1MG5tTG1lN05UMDloTHlkWitvTzhkVEVqOWNScVZr?=
 =?utf-8?B?cHh4a0NCZ2lMbDRWcDBDNnU3a3Q1L3A0bFVndXFqa0RlSXdDMEZ0U05XU2o3?=
 =?utf-8?B?eHE0YUJQTVEwQjdLZXpNd0hPanpGYzUzY2tuWWtxZlZDTGJReS9IMGFKVTdN?=
 =?utf-8?B?S3NPYlRXK2JRS0FPR0lWaWJjQjMvbHdYRHJUS2loK1k4RkJRRkwrdEZZanRz?=
 =?utf-8?B?OGwyQWdlZ2w3U0JDcGxsZWlrVzVQUzhPU1l2UmhaM0l1U0IranJMdXlMY0pn?=
 =?utf-8?B?VU0rLzZXYU1qQ3l4eGRhckdLZGkvai9VcWJrbjV3dERkN01DY0N0WjcwbUlK?=
 =?utf-8?B?cXVKSTZTQXhpNUQvZk5SOHdjendvd3J6M3VHMHVvUFR0OU16M2dEeWNjMnQy?=
 =?utf-8?Q?zB5MsySffI+C+2imxD9xPlXMM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f83e4c-e687-4c34-83ca-08dc9434f526
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 10:03:55.5398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fq9zcOIqu/HkAotZUuqFnoIu0xFJUgVI0H45s9f1TV/32ldHL0bYOkVmJ8qN/ZrDRd0rkNks8qAEdhd3j5Y5Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7409



On 6/24/2024 11:41 AM, Borislav Petkov wrote:
> On Sun, Jun 23, 2024 at 09:46:09PM +0530, Nikunj A. Dadhania wrote:
>> Yes, payload was earlier fixed at 4000 bytes, without considering the size
>> of snp_guest_msg.
> 
> Sorry, you'd need to try explaining this again. Who wasn't considering the
> size of snp_guest_msg?

Sorry, I meant snp_guest_msg_hdr here.

snp_guest_msg includes header and payload. There is an implicit assumption 
that the snp_guest_msg_hdr will always be 96 bytes, and with that assumption 
the payload array size is set to 4000 bytes magic number. 


> AFAICT, the code currently does sizeof(struct snp_guest_msg) which contains
> both the header *and* the payload.
> 
> What could help is if you structure your commit message this way:

How about the below commit message:

-----------------------------------------------------------------------
Currently, snp_guest_msg includes a message header (96 bytes) and a
payload (4000 bytes). There is an implicit assumption here that the SNP
message header will always be 96 bytes, and with that assumption the
payload array size has been set to 4000 bytes magic number. If any new
member is added to the SNP message header, the SNP guest message will
span more than a page.

Instead of using magic number '4000' for the payload array in the
snp_guest_msg structure, use a variable length array for payload. Allocate 
snp_guest_msg of constant size (SNP_GUEST_MSG_SIZE=4096). This will ensure
that message size won't grow beyond the page size even if the message header
size increases. Also, add SNP_GUEST_MSG_PAYLOAD_SIZE for checking buffer
over runs.

While at it, rename the local guest message variables for clarity.
-----------------------------------------------------------------------

Regards
Nikunj

