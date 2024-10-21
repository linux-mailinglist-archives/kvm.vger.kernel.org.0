Return-Path: <kvm+bounces-29297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F3D9A6D7A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 17:00:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29BC21C229BB
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 15:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 639491FAC2B;
	Mon, 21 Oct 2024 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nqTINwDv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6634F1F9A9C;
	Mon, 21 Oct 2024 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729522807; cv=fail; b=ZTN93r4CqNHP2HQ9vQ9UMAnmM/jSiRLeaJiuvbfMW5ULRPNGS7uQ+DbxzUgX5OqJoCXAIV2pr7P8LWnI42YJEWlYt2a9vRkiHyRhsKAULyJfWqMjKDtr6TEGCxfip1tEJw5QNre2uAS4h/t3jT/IFmNSlwypmT9jpFiMG+w4H4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729522807; c=relaxed/simple;
	bh=jp0gerrIbOjNVN4KlAngsfUh/hpexQISCur6/cHb88c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jk5HlbjYWqNzPnpOfx+GTT65zaJ8vP/Z9jdvthbBHQS87fG1jIZmB7guuK3gTST8bhd0EyHzu1wCnAbNqkVKuhAmvS5SNWJUtiYXYvW0tw4iK0wdlCjrRkRTr2xK8oEaiB/uP4qSGzIH4wJZg3DQN0lIUEXoM27G5VlZcDRcV1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nqTINwDv; arc=fail smtp.client-ip=40.107.102.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yb42ckrwJLR+JUiTjZk/nPaEoID8bxVQLbigrv45xzEPBxEYbxILqV4AOQnASH0CxV57Bk7APqGVUngj7BrPk7WAkudfvwasZZkFI/rkGgXkT9Jl4tBKcP6auDSYR+em4CmPv9fy3FcfKkOtfD2GU9KMM/0o8rW6nFvoKwlPcVZIaBmI/yPfkfE3WpAUuacxZpxzHrRfEO5aTtzVhXNt6HuX20Rto/uQsg/CYejATvwcSyUhSnnndXQzHg24ZR0F5Hy6+0YIn34ejhc5hurQUhtCqmseFKVGSpbHuyXIrCvW5yghizYkLQg0ssWugf3WPxY2lvyqWE7eMIqkFMbR3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4UYKd/ij+dl+wgWUYiHy7GaYM37AFkmDEK1dgTzwdU=;
 b=sRs+iGsbpn9g20sGqmVrWpcfFFc7kUeiDL17w3K+glN3PQqPaNaz3KwqScQtkE53HmnCn1+WR9xK787j6tK1Q42czIMe7HQUdl21/X/b+HL79lP8hg//d2waSjTk4a8hkiC9AtOkCodX3dq27GijPqscw25tuh/Zv66M5kAVaGJrUsChyYaATL5lyWeQpsmHrAFhqadjzlb9UcCXKbC4gx5cniGDq9TJkkVDTx5Mv/sOohwuChRh6ydahwiVmx8dVjRlTDmsprCOxH92iLB+O8/pGkfgzihC/VQM96usyCr0JS2l7VRlwGrmIGs8Gkz+714dekWM5Qi5p0mvZcZcpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4UYKd/ij+dl+wgWUYiHy7GaYM37AFkmDEK1dgTzwdU=;
 b=nqTINwDvZ8MN+7PbE1wuP7Gu+BUvdjX8WSw9XiLWNqSDp58TxmhrwJlU/Iow9PhZgZ0re57VM1yE/GqFNoGS7fCJD1TtGOL/j4aEKWBGf9BOvii7ALG8apxdt2aPQptwcwxiegyPJtKdTN0HZR0Dxd3yoSO8XwUhyr8DIaUZBzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8787.namprd12.prod.outlook.com (2603:10b6:8:14e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 15:00:02 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 15:00:02 +0000
Message-ID: <4e43f173-6a89-c1ee-5f1c-2f7e23ebcbad@amd.com>
Date: Mon, 21 Oct 2024 10:00:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v13 12/13] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-13-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241021055156.2342564-13-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0198.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8787:EE_
X-MS-Office365-Filtering-Correlation-Id: f528b3db-9bcf-4a03-0719-08dcf1e10a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QldXaVVuOCtsNXNXbWp3QW1oWUlUVlZ6NjNkT2k5a2h1L1dNYXc2ZTJUMU1R?=
 =?utf-8?B?cFFaRmwrU0tuRlkya3FjSEUrKzlLNVFHY2E0V0hMYlNwR3RVQ1VaZGJ2UDNM?=
 =?utf-8?B?UVFVTGVaTXk1U0xCMEJzQWc0N1RIRFRQeXJWY3laeTRxMlV1ZVI5aFA1TW1j?=
 =?utf-8?B?M3NOOTJtb3NSRlNyTG8vUkY5RUFRMVJSNittSTRMbGQ4L3B1WGdTSG1JZlZo?=
 =?utf-8?B?TFdXTzJrd2ZsSng5dG9iRjRmQVdlcUVhaU5hTk5xN0RBQkg1RWtwZXk3MUQy?=
 =?utf-8?B?MTJuNC9ueTRJUFUvLzR4b3dwUSt2bG0ramFHcDJhYWYxNmgwa3hIaFlGc0hO?=
 =?utf-8?B?cjVFam1KRnZkSS9XcHlWeXNlZFhGaHU5UmtJQXpVSGNWaitkc1prc3kzbmFa?=
 =?utf-8?B?S2REWXZLY1AvTFN1Vk5HSVpnblJQczdFZ1hPM1RubGV3YUFTREk3S0RDZi9o?=
 =?utf-8?B?ZEZScnpCSnhncTZWS3FLZTVjNFk4dUN1bjZiV3QwYzlZYlVndEZHc252Qjh2?=
 =?utf-8?B?NEtlam1kUFlrbDNMd1F1ZENkaFJlcTVZWVdBWXBoUVZMTnJ3NlZYbXFxZlVN?=
 =?utf-8?B?bkk0dGV2KzNHWm1XNEVSMzY4dUVQQit3VmxDZW1HSEJ0dmxOOTNKUVlxTFRH?=
 =?utf-8?B?UThlRUgvZGVNaUtMWk1GUGRzOVp1SU9CcjgvWTZvWVJWL3I0anJvdzIwZ2gy?=
 =?utf-8?B?dVVWaVF3VHV5TEc2SmxqMVllYXh1bTM3R3gzN3hGL0V1ZGZ0YXRRckdZd2Jk?=
 =?utf-8?B?WFAzZHVpNGtzYTI4WnpxSUFCY0dGeTdkcGxvSHY2RGEwNjRGNUsvcmhIZ1Ur?=
 =?utf-8?B?YmZMcVNBM2hzQjJzc0NyVFVaWHRtbmlxUVUwNU1MWHE5MmVEd0NOUURZVXlw?=
 =?utf-8?B?em9ReDVBOVhOQXpqejJGU095eEtjTVZROTMxRUZPT1BvdGk2RDN5MzlFVjV3?=
 =?utf-8?B?RkJ3Z24yUy9PQjJjNHR2WFBkZ3hrbDd4TXJ2SG5kYTFPT1c0ZG8rZVlablV0?=
 =?utf-8?B?bVovYjNsZDFsaTZXQ3k4bEI5Nk1VSTJ3L3psc2k2b1lFZWtYYml3MmdJUXJB?=
 =?utf-8?B?N2IxajU3aTRQOUZRSFMramdQZUwxdlZueUlFV1YydmxqTy9kck5UV0pNUmIy?=
 =?utf-8?B?L21RNXZuUkdRblFhaDNXa3g0dEp1YkI5d1o5bm1haS9iYVJIclJwb3FWMk5M?=
 =?utf-8?B?eGxDK3hHdWtKTzd3Q0kvd0ttSEV2V2RpM01xNjdPNFBvWThFL2tYWi9uRFpZ?=
 =?utf-8?B?Zk4vb1h3eFNieURUUEVkMFRaSnNRTk1malAvZ3YrTnFYamdGdFkyRStlc21r?=
 =?utf-8?B?Wk5xb2ZFdFhxTjZVWjhwaDNweDJaeFZPRVQvMzNjT3ZlL2hwclh6N3dxcjBu?=
 =?utf-8?B?S3IrOTBmb3VTWnhNL1lOUE9MZHRMTm9YYXBwV2l2ZlFvek5VaHczTVQ2UFJm?=
 =?utf-8?B?a0tqRlN3YVNkS2puZUhlMkcrUC8xeGhBcHEwQjBqSHU1RDM5a3h0azFrcm9p?=
 =?utf-8?B?VEp6OWYvU1hZUm9BR3ZCUzl2ZGNhT0ZLM2E4Zmk2Wis0K2tRRkVnRmdpbHpS?=
 =?utf-8?B?b2oyMHZKZ25FeUZlZXpXYzJyc25TVlNaVXAvOTNkT01rM1dMaUtQQ3c5Z0Mw?=
 =?utf-8?B?MGxVMEFyTjcyK004V25hMk43NCszN1loWmFPczhiVmRoNDVWeTFHTnpjbVRS?=
 =?utf-8?B?a1hiaG1ucm5mdE0wNjRkNkhwVWJwTkg0eTZpZ3dRMmJ4cDJyUHgrZG1LWCtO?=
 =?utf-8?Q?P47b2OS29/dxGlnvNSF6TOZd8wL+pvJ9z7kIGR0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d215R0s3YmM5bHV5ODJpQ0M4UHQ4V0JhTVhZYVFsSkIrbkNNaEJGUUc0QXhT?=
 =?utf-8?B?VVBoVzI0KzB2MzFuTitQcDJLTDZTYUtkRkgzekhVeUNwYVhjTkxybHRKcld1?=
 =?utf-8?B?UTI3ODRvZFlYeXZoaWlhZzVxT0J2bGJFTUNUamZwODc5UXZpWEhoaVkxNnBO?=
 =?utf-8?B?dXJPYS94eHlMTEpTY0x3cFFpWTVTR0QwL1Uwb1F3dWtqVEpuQjVyb21oWTBv?=
 =?utf-8?B?T3lvbi80RHlPWjFqdUNXQkMyZ0NLaElxbGx1MmxrZk91S1RRVlJicjFMbC9o?=
 =?utf-8?B?OHUxOTUrRnpGUjVtZFFjV1ZpV1h6WFMwS3dYRWN5NnQ1TVN0RENLQlVwWTI4?=
 =?utf-8?B?OWlSZWhlUHAyazErc2M0OGpEVUpqL2hleXFLdHJJbTNrd1RSZnpndTI5cEln?=
 =?utf-8?B?SFdzNlNLQ3hVQ2hJTGVrY2FkU0htVFRUSU9HeUc5VEJOeUtRMVlMZHYzL2wv?=
 =?utf-8?B?Vkpqa3RqQVJOc3IrSW5pdTJvKzJaU2src2J0U210WWgwSTVKMDUzSi9FU2hS?=
 =?utf-8?B?T0RLOEFUNHl1Qkp1RkFRdDVWYXRUdzdxaTk5NUdSOS9ab2JyL01XYWg3STR0?=
 =?utf-8?B?OGViSEQ0bjdFSWFVSTJrQ0NDTXcvTUk3UDFvT0R4NWF2TTJwdnpzU1d0VmYv?=
 =?utf-8?B?NE5iR1JHcEVPZ3h3czNrelJjdUlSbkowTGhNQTVGREFyU1lPOWd5Z0IrU3ZH?=
 =?utf-8?B?YVREY2tjdlBlN09iSEdoaW8wZVdKbVg3cVdzcGY4Z1RnMTF4UTUwdXpGNmVz?=
 =?utf-8?B?V0M5Wmg4cWFKdjJGeFg3RjBGc2JHNEVzSlNmeElJUk9QSDJDVGxUTzlJYzVW?=
 =?utf-8?B?Tzc0b1FEV0duWUVxZlpwNGR5a3lGbGZ0eHZNazl3dEE2SVV6Q0Z4OG5mMkoy?=
 =?utf-8?B?NVBhd1dBWTNpMnlOTVpEN0JYTytFRlVvMXo4QzN6b2hZMGNBYXN4S1FlVzJZ?=
 =?utf-8?B?L1lJZStKejA2V1YwdFk5dE5HTWQ5RGdNQ1hXZElGdVVOaVg2aTZvcHZ1bEt1?=
 =?utf-8?B?ZnRSdkVDd09RV0JWNGJtcDFkV1VWTEpVQmZwZWJKUEladGFtcXVZVktGZ0Ju?=
 =?utf-8?B?M1JCeDJiTitBajFCWW5nUVRFMnN2TVhqMjZObmFpTVdCSDZ2dUI3aGRXdkVC?=
 =?utf-8?B?UjZhOEUvNStybnlRa09YL1JIbm1ScFJCdlJ6ZW9vME5HNjJBd29ZbTd4aFZm?=
 =?utf-8?B?QnZxMU1RZEU4c3gwckUxZmMveTNwN3oxWGprQXljaXRUcGtQZHR6Y05ZVnFy?=
 =?utf-8?B?S3BsY3ljcGZDY2dpaWR6ZnZnTHZRdkN3dVYyYnFnaU5tOGlacXJwMWlmWnRy?=
 =?utf-8?B?cVNXMEdxSENzQlVZOTRjZHExUXh6a1lYNExCM2RMQThsaVFEWGxJYkw1Y1Zw?=
 =?utf-8?B?a2s1M0FrZ1FjajZwTGtvRFVGeHV2MytqYmpSOXVRenZINFN0aXMrdWlUbmlU?=
 =?utf-8?B?TXdOTTZRQUZReUwwY0NmQ2p5L2dEM0NzTFhhbVpsQk4rdjNRWHhMY2Q2YUJx?=
 =?utf-8?B?bnZzZVo5Y2hoM2N4bFRVZ0tudXV3LzlidEdzNEM4VFRPSjdma2JsZklXdGpI?=
 =?utf-8?B?MEtoUitKRzNweDhqMGlDVmgxNXp3dHJBMnNqSm9GRXlCaXErZDk4RWthRmhw?=
 =?utf-8?B?RkxoMm52T3BKUzF6MGY5RTlZQXVEY0ZUQjZTWjhRUEpqS3lOb1RyUHEvV3Rr?=
 =?utf-8?B?WGoyRTM3SVVqYlY1Y0Q2UzJTK3NpbmN1dzEySXJadXlEU1RYamFYcm1pSmNZ?=
 =?utf-8?B?WDhZbldkaDNCZXV6Zm1oc2gxNDYxSTdQUFlMRjFIU2VkNjUwTzJJenpyeW1N?=
 =?utf-8?B?MWpDOTRGdS9GR2EzK2JRL0FRaXFoVG9rdWVnZVZ3Nm9SazBkNmNHUldiNkYz?=
 =?utf-8?B?M2dTMFF6cmJUcVFLV2VyMFp2S05VUFRFTE5ERkFoMVNuN0FBVEZKV0swZTVY?=
 =?utf-8?B?dE5TSU9CcTJWU3dDSzhIZWR0MElnTlNTZ1pEbmF0aFNjRWdUWVp6VnlLcDV1?=
 =?utf-8?B?MGtaZEEzdVF1NHZnTDVRL3JLblVsVkJkRWNPWmdvbDdrY1YwL1BWanlZMDBo?=
 =?utf-8?B?NXJUSjJmYlhjdGNJWHRha3VOdEVJY0NyQzVjM3VjNEIvNUlVSUYzVUEyUjVU?=
 =?utf-8?Q?GzPjmZ0inIHTSjm0ovuDupBhK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f528b3db-9bcf-4a03-0719-08dcf1e10a6b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 15:00:02.6030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8v6QHP1+OfgaMziXrEOr4iTDEnN5LBWaILuZUAYgWADXyFLQLnbBzJFvCn7j9BVdeSngy7z7FosSVgfS+4FMdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8787

On 10/21/24 00:51, Nikunj A Dadhania wrote:
> SecureTSC enabled guests should use TSC as the only clock source, terminate
> the guest with appropriate code when clock source switches to hypervisor
> controlled kvmclock.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h | 1 +
>  arch/x86/include/asm/sev.h        | 2 ++
>  arch/x86/coco/sev/shared.c        | 3 +--
>  arch/x86/kernel/kvmclock.c        | 9 +++++++++
>  4 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 6ef92432a5ce..ad0743800b0e 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -207,6 +207,7 @@ struct snp_psc_desc {
>  #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
>  #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
>  #define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
> +#define GHCB_TERM_SECURE_TSC_KVMCLOCK	11	/* KVM clock selected instead of Secure TSC */
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 34f7b9fc363b..783dc57f73c3 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -537,6 +537,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>  
>  void __init snp_secure_tsc_prepare(void);
>  void __init securetsc_init(void);
> +void __noreturn sev_es_terminate(unsigned int set, unsigned int reason);
>  
>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>  
> @@ -586,6 +587,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
>  
>  static inline void __init snp_secure_tsc_prepare(void) { }
>  static inline void __init securetsc_init(void) { }
> +static inline void sev_es_terminate(unsigned int set, unsigned int reason) { }
>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
> index c2a9e2ada659..d202790e1385 100644
> --- a/arch/x86/coco/sev/shared.c
> +++ b/arch/x86/coco/sev/shared.c
> @@ -117,8 +117,7 @@ static bool __init sev_es_check_cpu_features(void)
>  	return true;
>  }
>  
> -static void __head __noreturn
> -sev_es_terminate(unsigned int set, unsigned int reason)
> +void __head __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
>  {
>  	u64 val = GHCB_MSR_TERM_REQ;
>  
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5b2c15214a6b..b135044f3c7b 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -21,6 +21,7 @@
>  #include <asm/hypervisor.h>
>  #include <asm/x86_init.h>
>  #include <asm/kvmclock.h>
> +#include <asm/sev.h>
>  
>  static int kvmclock __initdata = 1;
>  static int kvmclock_vsyscall __initdata = 1;
> @@ -150,6 +151,14 @@ bool kvm_check_and_clear_guest_paused(void)
>  
>  static int kvm_cs_enable(struct clocksource *cs)
>  {
> +	/*
> +	 * For a guest with SecureTSC enabled, the TSC should be the only clock
> +	 * source. Abort the guest when kvmclock is selected as the clock
> +	 * source.
> +	 */
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))

if (WARN_ON(cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)))

so that the guest sees something as well?

Thanks,
Tom

> +		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC_KVMCLOCK);
> +
>  	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
>  	return 0;
>  }

