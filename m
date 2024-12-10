Return-Path: <kvm+bounces-33425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 348379EB34F
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:29:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D4F9162089
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4760B1B3941;
	Tue, 10 Dec 2024 14:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ba3gaUCx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE1D1AA1CC;
	Tue, 10 Dec 2024 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733840981; cv=fail; b=bGj/SwZCeptSOxjC9OUhX6iDn1cQzf8Q0F4DAGQ+kdwGCzF3wdZnCx2xWOrPhgrSozLtr+meAEw8voG4eF3SwEq05wOlMx4no5rq0ga91KNwzLFHi/EZh7a92+5BcHzL98D/vspiF9Ci1xsT7AKL2tZjdTHir24hVDqO3uB1fHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733840981; c=relaxed/simple;
	bh=5AZPtw40EwMEI5TQRBxTsKih0ZIMKfSIemxCN5Q14wE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=WCLMsGStdX+yRS4HFnSD8LcxdnC6+Ei0IZRhYWSVT6ZgckTNEsL7sAPpI83JkOSTk1UaQa0JmuwM9C+ZAaWsXuatuKYVPMZ0ZQYaoS0qh0AdWRtkumXgG+pd4Hlv/Ct/U2m5BrAUnHs9JImG+B6BvPR/Pv75MsEW0C9Ze07tKQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ba3gaUCx; arc=fail smtp.client-ip=40.107.236.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y40ZHPX5kkU8PQs4AlWaEK+LFfkaABIjKHbAKglAYS0y/UmhQBSWdE7jkhJpBdRCfPj6cq3mDsdiFXSNngXtuVb4z62NC+qsKfa6jCdPlFxL3uzuJWRtJcloLW2VW5wDNmZgPcjcgWGZ3SJ+gYWgSAVbUNFxJXK1OmI9XDC8SdxYG9we1hV/E6+TyET6N7R6Wo1P9aHb5mdmVj2W9rYLjDf1C8zSDXDsuwZX2WSy0+DZMqNA7MffVQjCSvMnVpo3ErFJHGeYweR0Bd7gSAjtUgCyvrnvu29ZItwW+kEHzj7aJW6rs6/VGGg1hTg+YPEFxudETvQWQtLRtYBOL01rfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOQWR8aYtV90Uk5O47DeDG+5AeR1DZnPGjylQEKl4c4=;
 b=yA8AbQspln0KHKuf9/Hw6Ddl+tdEKGqnwWjnSJoeY43299LtNS49cH4DLeEdpsyY2B7ft1MIvYg1xIpOHuKevtpmPs9jjTP55v0yF0WqyKVynn4MCDe7R93Cr9pX++UzH0Y8m0MxEvcMVYoOXsFAPcIWNNuQhc7PTPoZUXu+EaWTq+hVk8eKqkw1cCAkXIbh+hBWhVMmB+tl3D6hW8PIMOYem8KBDMBjUrGl2OxlwR/icHKZc7snOHcUkNE7WQk/JvzzlyFdm3Ykyz/cbPfUTnKfmfswk5DBIexSV1Rk3qTPrDRzbWCgqz0iuo69LQDEBYpAVsx3n0nd7JvyvdbLzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOQWR8aYtV90Uk5O47DeDG+5AeR1DZnPGjylQEKl4c4=;
 b=ba3gaUCxSRGzbsO3XDp6wabLXk5r/S4rAHNfoi8Z6Xa+IUFLFQN16MiFOLOOjnD1LOKnMclutOMKkFlHv0fpLjq20Gj28RwOo60Q4moS0eCL/Rn4w09NFOMiIrDqGAURlPNCB11e+E2fNPYyF3u96krvQoohA/DhIyWhyAm3f6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM6PR12MB4339.namprd12.prod.outlook.com (2603:10b6:5:2af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 10 Dec
 2024 14:29:35 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8230.010; Tue, 10 Dec 2024
 14:29:33 +0000
Message-ID: <15e82ca3-9166-cdb4-7d66-e1c6600919d7@amd.com>
Date: Tue, 10 Dec 2024 08:29:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: "Nikunj A. Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
 <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
In-Reply-To: <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:806:22::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM6PR12MB4339:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a8e04e0-dc5f-4cdd-71f4-08dd192710ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGJ1aW5XU0poWmxrNndoRUdNMFU1dGx1T2RYeXg0UUNzTlFXVGFScThURm1p?=
 =?utf-8?B?Sko2anJvZmJNN0I3bFZwTC9yT2gxTUZrRXRYem5MTGtsamlQMEE3TS9tVzd3?=
 =?utf-8?B?aUl5cm1HeVkva1hUS3FTc1NuS2VuRXZkRitOajF6OWhBQ1Q5RmFjc212TVcz?=
 =?utf-8?B?NnQrN1psaFA5SkxuS1dRK084QWZIWUlXbUhKeUlFQ29zUTVlcFBaeGkvd3FG?=
 =?utf-8?B?d2J2MEhzdjVHRkRWdmZ1YzNrVzIxdDlKM3FNeVZBODFvZU1qSEt6R3liVG15?=
 =?utf-8?B?cXExZjZRM2JISGV1UW9YMGhmRGIwRUFpSjUySDh2MVM1TitsYlNIN3hZOExk?=
 =?utf-8?B?QlNvNnZsQTVDVHVGMnNUWjdpbFpzQnJNYjdqZEw0ODl4SUJuSUFDb2czSUx4?=
 =?utf-8?B?dGtqK3JHdnJRQ0REa01kMk03ZStTTUl3alRkcTY2b3BPWWhoVXhRcjVXb2Ny?=
 =?utf-8?B?OGtvTEkydW9wTUhwM3hKdHg5VUZzbE8vQXBaRTVkWnY1TkxEcVZMVlFSNmw1?=
 =?utf-8?B?d0Z0alZWMWVuRkJFdVEySmNNRHkxU2NZZDFFWStJMURJSy92Y0ZHL2lzZHlK?=
 =?utf-8?B?bWF4eFMwWnNGK3BjZDY2enZFQVF0UUNScjFFVXRvZ1dlLzN4dVJ2RzBYUmFY?=
 =?utf-8?B?OXQzVlpVSXM0TkFXb1p5cEZYczZRckxSbXVsWnA3UCtIWThKSEI3dGo4RHhp?=
 =?utf-8?B?bndndUdYSEN0LzRFYlFKRTdVejhYalFUVmdlWHBQaldYaWxPMTNvd3RMOXJi?=
 =?utf-8?B?SkphNjJjUlJFaUErVjl1WWN3aDdaWTBLTUVMYWZXWkFrRHdkOStEb0ZTUjNq?=
 =?utf-8?B?WDFUclV6YzA2NlJ3YitjakJKd3UvTnVpWThpT3RQbG5FWVVxaDhIeTE0MnIv?=
 =?utf-8?B?bGZaanBiQjRnWENKSzdQM0VUUzFKcnA0T3ZGbDFpOHRPenJITHB1b3M3c2M1?=
 =?utf-8?B?YmQ3TzdjcjI3Ni9CcjRWYlY3Y3krNzhHVGZsYk9teXJXNGFFa2I4Vzgwa0Yx?=
 =?utf-8?B?TGJlR0FLK2oyZ3k2eWIvTU1mQVdCaUVRckQ2Y1dza3dZNnRKVVh5UnIzVFJj?=
 =?utf-8?B?VE9GaDVZcWt1WDlrTkxQb3FzdXNIdEsraGd0NzFNOGMyT1NCSlE4Mkd6TWNZ?=
 =?utf-8?B?V3kwd1ZpNGZ3azM5c2VoVlZpRUVtbWxhU2xibG1Fc0NSZHFkSTJRSmQ1bU8y?=
 =?utf-8?B?QUpzSkhUSWxOc1ZHbzVYdm1BMWE2eUI5dExxV0NEZVJrYXF6eUJQclNJS3dL?=
 =?utf-8?B?b0grQ05UNkNIRnFXOGk1SUVDNmM0WHRDL1NVbkwxaXhYcSt2ZHhHSWdudERs?=
 =?utf-8?B?SWRTb05Tb0pDVTM5cUdPOVlGcW9GbGdodFJyUlFMSHBWZ21iNUQ0Q1hDSHRy?=
 =?utf-8?B?aFpJS0owUkpLcmZUbFdLSGY1UmxZSFlySitvY1FQYzExQUJ1YWd4ZGhVaGti?=
 =?utf-8?B?VE9XYnE0Vzd6eTFOSHJLelJKRXJFQzB1aDluQW90c2FDVWRZVCtuMnk1L3lo?=
 =?utf-8?B?bENteXhvTzY3d0FnQUtiT3FUZkJiUVlBSzRYWS90dmsySUFaem9iaEZ1MkNR?=
 =?utf-8?B?TnRsUEZHWkJaYnVCeUlkc2dyZG5Pc0R4Z0VkZVh5M1puanFSREtlbEtGS2tW?=
 =?utf-8?B?WTU1dWNyOWNLNEhMOVNiWDVITU1NVXpuS2ZuWmZLNFZtS0tlbnhiUGkxVDda?=
 =?utf-8?B?RnhwVlhpMVBXZlpjVFlKamlDRGFXTC96dXB2UXN2WGs2RHVpS2ZONWRmdjVP?=
 =?utf-8?B?UmNCczJNWFFkT3U4WEJMWU5XL0J5UjI4azBQR3ljRWFFRjk3bGkwNmdIMTFp?=
 =?utf-8?B?UzByN3NnUUxmeUxKMjdJdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y004ZDQ2RHd6KzJjOEFzZXR3Nkc4eSt0bVM1ZVBVT1ZmZVNJQXkyTWp1OEtx?=
 =?utf-8?B?YU5XOCtwY3ZBdDc1OUpOT0FLV0ErUTN2ZHdvT2VoNHZkZVkrbUVWSHlxMEhq?=
 =?utf-8?B?K29zMVQ4TlAwdnRvSzJiRGEra2VYTW5iVkt2WkppS2pGNVM4L28rMWNqOTZm?=
 =?utf-8?B?S0REVXJKNVVKLzY0TjA5Z0xHaDV5bStHM1FHK210NG9JS3YyVWVseHo1VUF1?=
 =?utf-8?B?YUJtU1R3bDMveFFWNVMzbFVLZy9VZGs0TEwva1BmUlhSY0RialNlRUJ6d1Jq?=
 =?utf-8?B?bGxWajRmWW04ZzE3MmR5Q1pFWWxrMk14enVETjhTT2xBb3NBamVXN3dxeHoy?=
 =?utf-8?B?Y05zU0FQZVJKYlhSemZHUUVtVEUxTW42OUpicHRkcjMwMXhWSTJiYk1VeTRU?=
 =?utf-8?B?UlA2T1JKTDVXdjFYTjJrQXVkTTRFbkF0SDhVMURzTVdoVGdMWTRnaWJIUko4?=
 =?utf-8?B?b3Y4Smx4RVdOVFlOeC9uMHdpTWt4SjgvLzNMdkxGOXZwTVVzT1dWTEhZVElw?=
 =?utf-8?B?d21jM1F0b09hUjRXZG9GWTY1aURYakVWL2lwM21iOGRXRzYyeGMwTXdFbWIy?=
 =?utf-8?B?dUVrVk14SzUzczZFd0ZwZllKd3NoTGFlWDZrMlhhZ0pyeS91QjYzSUNCRjhp?=
 =?utf-8?B?YkZUeDZkdjVVUEFIVUFMVXVsSkl3R2hRN0UrSUVJTXR2dCt2OFFzaTJtVnd1?=
 =?utf-8?B?NGNsZDg0OElaeUJiVjVxcjlGR2h3WEltckJ4S0dvbG9FNVl3bGtrYWI4UEN5?=
 =?utf-8?B?ZnpIcVUwZ24rdE95Y0llc2FrWk5xSk5zZDluZzNranZnRVd6YnN1aFJ5Rm1C?=
 =?utf-8?B?OTVXR3hVU0d4WUpLY3RiZ1VNZmkrRnVWMUc4R3JpVWZqKzAwMC94VUF0R1h4?=
 =?utf-8?B?TGxXMVhYN2pZYS8xUzRIMjB1ejJhQlNIdVNEdktVZEJnUGgxK000V2lYM3cr?=
 =?utf-8?B?WWU2NkZiNVY4TGp2YllEOFd4dFlPb2JYMlhCcDBXTXVnTUtDZ0tCMU5CQjFj?=
 =?utf-8?B?cUdBVnJqeEJEbm9FbmNGOE1ITGdvMUlLS0FFVnU1eWprQkh0U3FiSEFrc0N2?=
 =?utf-8?B?SEtSLzFjUlhjSFo5M1o0Z2xTaVV2cjlFT0h5cmlJL0Z0ZmthNXZNQ21oT1p2?=
 =?utf-8?B?VTN3LzY5RXJIanplb3lFK0NrUlFtdmdlczJyRElmaTZYT3AvUnJxQ0FaS3FX?=
 =?utf-8?B?SXFYSVBKYmU3eitLa2VBZWQzMVBuSmx1Vk1Ma2s5TkwvQm53WHhtV0NEZFRB?=
 =?utf-8?B?N25MVHBsUzhPK3VZS0UvbTR1WjE4K2FrK2RyN1JBdDJXd3o0ZWxvUmRFMHdI?=
 =?utf-8?B?cHl4VkU0anl5cHBBWG9hZVllanVLczVybWswOUFZZ2k1a0ljVGZFeWxDOGxv?=
 =?utf-8?B?a3Rybzl5VlkyenhodXVuMXZVYzAydElvL0ZzMkpWTkJ5VVBuZXJwaGJZOXFp?=
 =?utf-8?B?ektOZEplb1ZJNURkcFN3ekRSRDhEUEVCSTcyUFFCWlZFTjFrRU5XbEFEMmQ1?=
 =?utf-8?B?TVgxWDdjLzkxSkM1WUpkOFZpam5HVjRWM25pRWE0UW1YaUpuemlYN3U1Mkl5?=
 =?utf-8?B?cDB0U25XbFVaYU91c0hrWlRaUkM0eWVYRlhQVEFwYzRlNms5cjJIMjMrWFBm?=
 =?utf-8?B?N0JwM2g0UDdRcEp3QzhpMHVBbnNrdm5iOU1YdDlyL3pPNkRLRk9XeE83bTZG?=
 =?utf-8?B?Q084TDM3ZkZ1SGVyUEYwTUg2dEpTRXU2aWxZSVZtdmJ3ZEFFN1RaOXNnMnRY?=
 =?utf-8?B?T21Idzc2SzgvM0lkb2FlZm5ENTVxYlRrSXpFZkxDZkdCQ1kxQkZCb0RDRjM1?=
 =?utf-8?B?N09QdzhOa2lPZEM1N082Qi82U1VCTWJ3dDRLR1Qzc29WRXlSR2ZadHpzM2VV?=
 =?utf-8?B?UjltVXBEdjFDcnVVNkFGVWw1Syt2VW90aVhCcTBSamorNlFzR2RGTzEvNlEy?=
 =?utf-8?B?NEZRd25oa05qb1RuM2Jwdkx3RC9KTGJ5Mk4wWkEzRHd6L25rK0pjeFcrVnkz?=
 =?utf-8?B?eXRId3pHMTcwNUZXajhlZVU3MW54N1pUTG5LWWpseGtvN1ltRG5CWGZQdFEw?=
 =?utf-8?B?TFJFTmpDM2pmTUlMRjlVWHdTM0t2bTBzNWQvclVabStGQTR0SFFGMUcvbHN6?=
 =?utf-8?Q?is8IDBOGJdVEL60syGG6C8Snk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8e04e0-dc5f-4cdd-71f4-08dd192710ae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 14:29:33.2492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ALefTZECxNpwoPjY4/Kl1za65MDlWkPkBTWXc9jfHQUvDH95ao3SkIOLtVMGA/uWoc3D/BmwbALqSD+868Ydeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4339

On 12/9/24 23:02, Nikunj A. Dadhania wrote:
> On 12/9/2024 9:27 PM, Borislav Petkov wrote:
>> On Tue, Dec 03, 2024 at 02:30:36PM +0530, Nikunj A Dadhania wrote:
>>> Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
>>> the subsequent TSC value reads are undefined.
>>
>> What does that mean exactly?
> 
> That is the warning from the APM: 15.36.18 Secure TSC
> 
> "Guests that run with Secure TSC enabled are not expected to perform writes to
> the TSC MSR (10h). If such a write occurs, subsequent TSC values read are
> undefined."
> 
> What I make out of it is: if a write is performed to the TSC MSR, subsequent
> reads of TSC is not reliable/trusted.
> 
> That was the reason to ignore such writes in the #VC handler.
> 
>>
>> I'd prefer if we issued a WARN_ONCE() there on the write to catch any
>> offenders.
> 
> Do you also want to terminate the offending guest?
> 
> ES_UNSUPPORTED return will do that.
> 
>>
>> *NO ONE* should be writing the TSC MSR but that's a different story.
>>
>> IOW, something like this ontop of yours?
>>
>> ---
>>
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index c22cb2ea4b99..050170eb28e6 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -1443,9 +1443,15 @@ static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
>>  {
>>  	u64 tsc;
>>  
>> -	if (write)
>> -		return ES_OK;
>> +	if (!(sev_status & MSR_AMD64_SNP_SECURE_TSC))
>> +		goto read_tsc;
> 
> This is changing the behavior for SEV-ES and SNP guests(non SECURE_TSC), TSC MSR
> reads are converted to RDTSC. This is a good optimization. But just wanted to
> bring up the subtle impact.

Right, I think it should still flow through the GHCB MSR request for
non-Secure TSC guests.

> 
>> +
>> +	if (write) {
>> +		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
>> +		return ES_UNSUPPORTED;
> 
> Sure, we can add a WARN_ONCE().

You'll want to test this... IIRC, I'm not sure if a WARN_ONCE() will be
properly printed when issued within the #VC handler (since it will
generate a nested #VC).

Thanks,
Tom

> 
>> +	}
>>  
>> +read_tsc:
>>  	tsc = rdtsc_ordered();
>>  	regs->ax = lower_32_bits(tsc);
>>  	regs->dx = upper_32_bits(tsc);
>> @@ -1462,11 +1468,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  	/* Is it a WRMSR? */
>>  	write = ctxt->insn.opcode.bytes[1] == 0x30;
>>  
>> -	if (regs->cx == MSR_SVSM_CAA)
>> +	switch(regs->cx) {
> 
> Yes, I was thinking about a switch, as there will be more such instances when we
> enable newer features.
> 
>> +	case MSR_SVSM_CAA:
>>  		return __vc_handle_msr_caa(regs, write);
>> -
>> -	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
>> +	case MSR_IA32_TSC:
>>  		return __vc_handle_msr_tsc(regs, write);
>> +	default:
>> +		break;
>> +	}
>>  
>>  	ghcb_set_rcx(ghcb, regs->cx);
>>  	if (write) {
>>
> 
> Regards,
> Nikunj

