Return-Path: <kvm+bounces-44018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 783CFA99AA2
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 23:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8C677AB1B8
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 21:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF4A20299B;
	Wed, 23 Apr 2025 21:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JPmiDAAB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B771F2BAB;
	Wed, 23 Apr 2025 21:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745443327; cv=fail; b=S+1oOJrEYvdNIidLRWD9ngORiHZKya8hDBg/L7Iv9Q8RGM/MyeV8gsJIi0XwXLCn0YiWAgX3+ytnE4vKsD5o0H+sf0ZM2jCrk8bfdVNfH98vSY5VfHmCxqNZpDlCmaGRsZfhXzZVtbrgY9I6f2KK5Cv1o3PHs0v0OU7kpr6q6FQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745443327; c=relaxed/simple;
	bh=P8OloVRt7EGPiDCHDNd0firIevcWRtEkEDaniZT+yjk=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=uegHJuBvhrNJWMgEcJG3/Oon2k0Qk2syZffKHGqL3xcjtpz3T3Fez5GwhF8rtjQ2332klPk1xBJ4tvThw7wGNp7UmkSLilyGbr26Q8UGFp1D0vKpBAD/o0H61z23kekoEWBRthkY6+I6007/nzUOFsIf3UPOWhJlF1G0CztikpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JPmiDAAB; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eI1+PA9OB+6s5P7pEgy9tyhp0mJH3iCzeAjbus9DxkK3zegfACwFgOF5oecX3dHaTl/Gf+sFpr8ox8piezx5iS22zYmpS2HPZ+Me/rHkfcsO0UZ+5nnXocucwGcnAE+LtjLQMfrJQUa4X6oO0X7N2XLr+Vq84Px9/KD5QWz8hrUPFrqAn4KDrpKFM2IZGwocziThekac7p3fO/OeNr/50BQaqKJ10Vm15KxrOucQZEO+/aWHG5tOFC9U5qTeWWn9AejzNO+loidT2AHp1yqxD00GFTuFjv0iqzr3Dl/Kvxxw6mxTyOH9IHhsnWkwNZwVFh9RhCQBVBb9fBvrg1Au5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNrQ74cfDCEegDX8TDJuhfyck+pEgZYZIEJih8Fko8k=;
 b=L7+OSvN6rYomHnOKUh2AV9wpyYzyKocPag5Cvx4Zqr7V21POChen/xEsO20k1U4SzDYo0cdTmgF/cPUESHIxf2Pt/WN/lUakpEvIGwzE7A10ytg9Sb2jSD5RGKMuVmEALgGR18b9PRKJgVUO7pjNCc7NWCt+SUCgaQDN4QsCrjz9P4P9KAh6QsEdgfQa7qaAryRGFLA/8CaGBNB9vfjPSD6DNcw8DBaVV+UNVgHB+50YHrxDE1R60km/fuy8YUdy3luvnQtqehU3IHVOxNDQPIWgOzfxPuIj8uBpr/uq4NCekkSZJrkrJWSASmAV0uZeOo2+XLbVFDfB+5CQYEkFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNrQ74cfDCEegDX8TDJuhfyck+pEgZYZIEJih8Fko8k=;
 b=JPmiDAABEhbdq5K8E+Su2MZDobnBkpVyDoGgu8nHO4USW4M1Dkx3lJDh4QBfAChZe9syeQjycL+tpkyrL2MDFMYpbJaEdZYZjiRJ5L5TSC/JfSn1iyvYudg7ysJQTVXWSw/aJMaDcbi3i/b9W567iSNswglDEJyds+lsA7360cs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4308.namprd12.prod.outlook.com (2603:10b6:a03:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Wed, 23 Apr
 2025 21:22:01 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8678.023; Wed, 23 Apr 2025
 21:22:01 +0000
Message-ID: <d598415b-0854-46a2-5262-7e204033c31c@amd.com>
Date: Wed, 23 Apr 2025 16:21:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1745279916.git.ashish.kalra@amd.com>
 <0ec035a24116dce7c8b2a36a29cf5eed96e0eb52.1745279916.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 2/4] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
In-Reply-To: <0ec035a24116dce7c8b2a36a29cf5eed96e0eb52.1745279916.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:806:6e::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4308:EE_
X-MS-Office365-Filtering-Correlation-Id: eebf84cc-5dbe-4da9-04dc-08dd82ace2f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHR6RVJhbHJ5V3Q2NzNRcHdNWVlXVUsreEhCd1JUcEhaQlRsMUdMa3J3Tnk1?=
 =?utf-8?B?UFFhQTV2S0gvSDFKUlUrTit0R29Hakhld01MeSs4RFdoNDc4SGtoY2hPVnRv?=
 =?utf-8?B?L080a0JXVjFHU0N0T0ZFRVN4WXYzRHVzYk92ZUEvMzVwRUVFa2J6cURESWtO?=
 =?utf-8?B?Slp1RXZwZGRJS1JDNjJBcXVKS3VoODM4UkZOb3A2RTRhejBtVVM1K1UwS01W?=
 =?utf-8?B?QnhuU1hxRThoU2dPS2lhdmxUTTBxQUJuOGNvTVYvSXZ2eHhFUWZYTS9ydmVl?=
 =?utf-8?B?dzhRNTFZcGhaN3djNVBOZkQyU2R4OVRVcFdrM0FDb0hwQ1Qydzk5ZEVIWUw3?=
 =?utf-8?B?Zys1dDBPa0s5alZiWUlOc3BXSzhsYU0zWXQ0NWI0UHJpeHVHZ0ZyTjh0azAy?=
 =?utf-8?B?dldrWnVCMTZtRmN0bDlXM1JqcXZTbWx2bG9BMUd2WmZxVGVUMmpBamM1TFds?=
 =?utf-8?B?TmVtRlR1MUNIWmhzazRkU0tUUEtxaGRCOFBHMHVha0hCb0dkOTA2eVczYzh4?=
 =?utf-8?B?cm5vMnlRUkloR2VQTVhmaSsxNTBqRzBnb2hzd2c4U3VqdWxjSlBVd0REZUFn?=
 =?utf-8?B?cXhWSjJzTEV3RW5QS1BkUXNIMzR6aXEwbUdKV0lFRVpGcGw2aVQzbDJlNWF3?=
 =?utf-8?B?NGtCaCtDSmFDR3ZFMlhJZDVHMVgxUnR1WkVnVExUSEFKUVZENG0vTkx5dS9G?=
 =?utf-8?B?MjNyMUx5U2JocjRYeC90ek1VYS9oUTRyN2pQdFB3aEprZWIvUURDWGZUK05U?=
 =?utf-8?B?TkJ5VlRONitMTkdCN2JzaTRHRzA1dFRYakZTajFTTVBTMDhsVk0yTkVkdVJi?=
 =?utf-8?B?L0xvNXFDcHdKcXhQd2dsaDY5YytwNVNJWEwveDI0NGVRcTJvWkZVc1ByU3gz?=
 =?utf-8?B?S1pZWFRiQjRjdzVoaEd5RThJL0J1a1FybUJJTk9Sd1JPaW0wbkJjRXN1VmFK?=
 =?utf-8?B?UVQ4OFBQOEJNTnltZWRjMy9rRmlZYk82aFBxOG54ZlR0OGI3VWwxWG1CMW9X?=
 =?utf-8?B?Ny9SV0VaL2FoSkFGYjB5Y0t1dk1UMXcyQUxEMHFpRVhjb3pVcXJLWDNrTVBt?=
 =?utf-8?B?WWdUZGhENXFOTG40U2VBWnRGemQxZkhxdGEwR1QrQXFyOHkyODJ0T3lFK21r?=
 =?utf-8?B?c1p4enRWdk9KNjQrUExZUGtWNERMeURnQTVPK2Nsc1BIK2xMdlV5dkZKWFBQ?=
 =?utf-8?B?bjhFTjBudVdvTVNBNmdteGxWaEU2WkloVXBSeGZLbGNhcXRPcFNIUkNXNWgr?=
 =?utf-8?B?VU5KTTBFci85aUp1VDNONitURno5YkNlL1FXQ0tGeTlVRzdpL0haYjVhTWw5?=
 =?utf-8?B?UHRGelpJTXc5bjkzbkI0Ny9YSDl1THc1eDN2a3RQc2Z5dGFJYkxwRkVHbjRm?=
 =?utf-8?B?NDRCblpZS2pXMGgzWEVuNHZ1YkxlNkIzSEZpYVpJMUo5WUtZL3RHcHl0d0Vl?=
 =?utf-8?B?Y29Vam9CbGE3MitUcE1ZaVh6UlhEV29ReGhaRU5scUxsVStGU2ZOYW96QXdm?=
 =?utf-8?B?Zll6OXI3NEtjQXdhaGlFNFBDdVE3WmZIZVZ4cGtaSnVxTGJKeC9id1lCcVpv?=
 =?utf-8?B?YnM3cVVrc1JuRmNHeWlzZmpUWndFWE5MVjFZNnB2TElOMWpWb09KMDVQSEhF?=
 =?utf-8?B?NkN2dk5MelVtK2QwS09EV1JheDV1clRSUWNSblpVbTJZMXFVUDhxQkhEMGp0?=
 =?utf-8?B?MlhXMFBvZTh5cFJkdUlldUg2Njd2SkUzTjRBQ0dJOHQzbmd2V2d6Nkdjejh1?=
 =?utf-8?B?MXpHVW1rUVR1Y2NmZkZ0dTgxV2RyRzRrdGhUS0ZteXh4WVZHZmRxVVhyVEp3?=
 =?utf-8?B?QitMZzJiTVdXOFhUZzhGSHdRakFXTzFTYWJYYzhpUysxYzFUSHZJWkkzSkdn?=
 =?utf-8?B?L0JTMnBuLytJNGl1VmhuVmRTN1lPU2Y1T0dRRHNONVFhOUZtRlVyYkxNY3RJ?=
 =?utf-8?Q?oosaICDBtpA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXEzYy9SaG5EM3ZLUE43d1A4Wm9idjkzK3prZFVOcktUcUlDY1YvNWRpc1ZH?=
 =?utf-8?B?bzNOWXlMcjVsbjNXa2xDU0ZLOWdTYnpUVmgxSDhQTFZzc0xCclNPN1VlV0Ir?=
 =?utf-8?B?WmRBUDE1VTZYK1Q1L3ZEUTJTRGV2dk9FMGIzQzZROFNTazVSMWRhTDhnUmI1?=
 =?utf-8?B?eXppV1UrWkpMNXlFZ3MrcVJ5MzBRRkNyVElLWTI1WmMwT1hHYnZOZlUyOFF5?=
 =?utf-8?B?TDhqL0Z1eUV2Z3Y2YTZranRTam9tWVV2NXByaU5SS2FGTHdBTTZvSFRMOElZ?=
 =?utf-8?B?RXg5OERKNWNEWGszenVpWENiMmNZMytoVE1VSXl3eHdGNVp1WWlDa3JUVHM0?=
 =?utf-8?B?bjJpbURmZGNidWpBZlZWN3o2UVVNUEVJYmtKazNkdGU3TEVEWms0d1ZDVS9l?=
 =?utf-8?B?NzVWRWxaQUV0bXF5cFBlNUs4UGVXTE9FZnRNTktNVjRicnFxNlJBZ1FYK2c3?=
 =?utf-8?B?OUZRMnBKMGNEZkJwYnYrNmdlRngwbDh3Q0F6RGQvaTMvNWJ6TWhUTWxEZzhY?=
 =?utf-8?B?MC90ekpxYjhyQ2RwVkUrSWk0MmhmeCtaMnFoVXY3MjF1eWEvNkRndmI1UVRT?=
 =?utf-8?B?VldiLzFnb3Jkckw1WWR0QndvMGtKSzNyY3VyTFFzZFJEWS9SVXJ3Z3ZsbnEx?=
 =?utf-8?B?R2VxUjNuWThheExnRUQxaEhiY09SYUxvcXd3UURZTUpKeE9FbXJ5bTBEWHcy?=
 =?utf-8?B?Q0NyR1F1aVdHcCtJRWJjbTZsbGJCY05MVTA4UzB3eHdZKzhzVFdzTFBEZkp0?=
 =?utf-8?B?U2JKRDgrU0ZGZk43Wm82VU9XK3Z4VEVHSzFpUnQydlJ6NU1OWU5venBRYnhL?=
 =?utf-8?B?NERhZWxjeXhVOEQ0TThibkRJeTlReG9tblJmSUJuTG5GMk9xN2FrWnRCN1Z4?=
 =?utf-8?B?ckViRmZNdjN1YnVtdzNnbVBVVS9DbXpDcGpZUktyTU1rYTYvRVMxWEU0b2ta?=
 =?utf-8?B?bFRQL2l5TTRHSzhvaDJjUFpCY0ZnSDd4VGpWWjc1bmpxTU8yYzVyTUtRMlh0?=
 =?utf-8?B?ajBGNEpSaHM1NHpsRVZUSGE1OU9ibmZvNkRoV3o5bnNjeDhHWEdRamMzQUJ0?=
 =?utf-8?B?NVE0c0g0ck9ST1dtczlZQ3psMU9aTFM2V1I2eXZKazh5Zi9RS3ZoYm51emsv?=
 =?utf-8?B?M3Z6czFGbFF2NFdFaU1wc3pMWVI3dEJyMVVGZkJIbHhLNzdwRnJ6SzdHRzlV?=
 =?utf-8?B?UlJqNkpjam5VQWw5ejNieGtQcFpWRzRyRHQxRFBiVUptMWdqalg3bzE2YXF3?=
 =?utf-8?B?ejUyOWFpZWNkNVY3WnRKbEQ5Yk9iZldLaGhtVmphUFR2Z1MrS3gzRGZvNzZP?=
 =?utf-8?B?UlFOTURacThWSmF2eCs3R041NWQwWjNIc3hkcEZXdmJTVWF0VC9lMDc5K0lT?=
 =?utf-8?B?UTBOamRXVkhyNTB6V1EvbzNrQnc5bUl3a1h3anhobm5kVE5TRlFIeU5wWmM2?=
 =?utf-8?B?QkRHOXJIQjJaUVlDdjQzbEpRTXJwM2xnbkpzQlNrWkJRWkF1Sm90UStGWFUv?=
 =?utf-8?B?QjQrQWRqZEdMS0lmVE9oUEE4Vmt0UWdnTGFHcnlESkFESGc2d29IemUrbmJW?=
 =?utf-8?B?RnI3WXVCOXFFNis0blVWMTh4M1ZpOXQyVWFHZEQ3b0JyMURkZVlHU2pvWmJG?=
 =?utf-8?B?bHRPeHRKRW1YM0htK3ZPbkdIcXZaZUJvZU1yWkUxWDJQQmJCYVkzR3VqZUtn?=
 =?utf-8?B?ZlduQ3QwZi9vMTBBMzlZYVFtcUNqcFJIajRJRjNXeVFCS2JTMms1SmQrUG1a?=
 =?utf-8?B?OTlqd3VQZmV5MHo5WTFTT1plb2FVSDhSQ3B1RFR6MXZLeU1GOGFlWVlaWW9q?=
 =?utf-8?B?Sm9RbmhOR2VPbXpZalRoMUp4TmxvdTBzbFFzUExpN0lsS3pqVkZ0RkFnL3Qw?=
 =?utf-8?B?cytxMHdES2djdzJOaU15bGcwemdQd0FVbFgzbTR6WTkybk4rek5aNG55TmZH?=
 =?utf-8?B?YUI5cjFQU3JpMW9FNEI1WEs4NUNUSmRvUEtLdDMxa2dlalIzdGtmU2pLVmRX?=
 =?utf-8?B?V051VFZNUlFrUi9Xa2dOU05acFpNclpoM2tqYTdnZTlLRzUxclBsZXlselpv?=
 =?utf-8?B?VUo0SjVsTkI4UkxocnBIYWNhWUtHR3o1bVFRYTRNZmNaWXYyNjlicHdmMXlo?=
 =?utf-8?Q?2w4nJkzeNIORNbT3raDmdbZmg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebf84cc-5dbe-4da9-04dc-08dd82ace2f6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 21:22:01.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwpMnNhoA1a7mGvU7UPOAzcqfOIpujqk5tpzmqMIFOrlz5KgpEEFAkJw+rgFIBFRs9byPsFnukMB3zGns6jg2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4308

On 4/21/25 19:24, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The FEATURE_INFO command provides host and guests a programmatic means
> to learn about the supported features of the currently loaded firmware.
> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
> Instead of using the CPUID instruction to retrieve Fn8000_0024,
> software can use FEATURE_INFO.
> 
> Host/Hypervisor would use the FEATURE_INFO command, while guests would
> actually issue the CPUID instruction.

You probably want to word this better in combination with the next
paragraph. The actual CPUID leaf doesn't exist. The hypervisor must
populate the entry in the CPUID page during LAUNCH_UPDATE in order for
the CPUID instruction in the guest to return a value.

> 
> The hypervisor can provide Fn8000_0024 values to the guest via the CPUID
> page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
> the hypervisor can filter Fn8000_0024. The firmware will examine
> Fn8000_0024 and apply its CPUID policy.
> 
> During CCP module initialization, after firmware update, the SNP
> platform status and feature information from CPUID 0x8000_0024,
> sub-function 0, are cached in the sev_device structure.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |  3 +++
>  include/linux/psp-sev.h      | 29 ++++++++++++++++++++++
>  3 files changed, 79 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b08db412f752..f4f8a8905115 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -232,6 +232,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct snp_feature_info);
>  	default:				return 0;
>  	}
>  
> @@ -1072,6 +1073,50 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +static void snp_get_platform_data(void)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_data_snp_feature_info snp_feat_info;
> +	struct snp_feature_info *feat_info;
> +	struct sev_data_snp_addr buf;
> +	int error = 0, rc;
> +
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +		return;
> +
> +	/*
> +	 * The output buffer must be firmware page if SEV-SNP is
> +	 * initialized.
> +	 */
> +	if (sev->snp_initialized)
> +		return;
> +
> +	buf.address = __psp_pa(&sev->snp_plat_status);
> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &error);

See comment below...

> +
> +	/*
> +	 * Do feature discovery of the currently loaded firmware,
> +	 * and cache feature information from CPUID 0x8000_0024,
> +	 * sub-function 0.
> +	 */
> +	if (!rc && sev->snp_plat_status.feature_info) {
> +		/*
> +		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
> +		 * command to handle any alignment and page boundary check
> +		 * requirements.
> +		 */
> +		feat_info = kzalloc(sizeof(*feat_info), GFP_KERNEL);

Need to check for NULL.

> +		snp_feat_info.length = sizeof(snp_feat_info);
> +		snp_feat_info.ecx_in = 0;
> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
> +
> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, &error);
> +		if (!rc)
> +			sev->feat_info = *feat_info;

Should probably issue a message if the command fails.

> +		kfree(feat_info);
> +	}
> +}
> +
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>  	struct sev_data_range_list *range_list = arg;
> @@ -2543,6 +2588,8 @@ void sev_pci_init(void)
>  			 api_major, api_minor, build,
>  			 sev->api_major, sev->api_minor, sev->build);
>  
> +	snp_get_platform_data();

We should switch from using SEV platform status to SNP platform status
(when SNP is available) at the beginning of sev_pci_init() and cache the
results. Then you won't have to issue another platform status command in
snp_get_platform_data().

Thanks,
Tom

> +
>  	return;
>  
>  err:
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a..1c1a51e52d2b 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -57,6 +57,9 @@ struct sev_device {
>  	bool cmd_buf_backup_active;
>  
>  	bool snp_initialized;
> +
> +	struct sev_user_data_snp_status snp_plat_status;
> +	struct snp_feature_info feat_info;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 0b3a36bdaa90..0149d4a6aceb 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -107,6 +107,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>  
>  	SEV_CMD_MAX,
>  };
> @@ -812,6 +813,34 @@ struct sev_data_snp_commit {
>  	u32 len;
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
> + *
> + * @length: len of the command buffer read by the PSP
> + * @ecx_in: subfunction index
> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
> + */
> +struct sev_data_snp_feature_info {
> +	u32 length;
> +	u32 ecx_in;
> +	u64 feature_info_paddr;
> +} __packed;
> +
> +/**
> + * struct feature_info - FEATURE_INFO structure
> + *
> + * @eax: output of SNP_FEATURE_INFO command
> + * @ebx: output of SNP_FEATURE_INFO command
> + * @ecx: output of SNP_FEATURE_INFO command
> + * #edx: output of SNP_FEATURE_INFO command
> + */
> +struct snp_feature_info {
> +	u32 eax;
> +	u32 ebx;
> +	u32 ecx;
> +	u32 edx;
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**

