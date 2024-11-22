Return-Path: <kvm+bounces-32383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F849D6442
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 19:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7CA328319D
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 18:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F1E1DF983;
	Fri, 22 Nov 2024 18:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sNbtDrqP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2080.outbound.protection.outlook.com [40.107.95.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E750ABA20;
	Fri, 22 Nov 2024 18:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732300837; cv=fail; b=axbffp1HMycw8IIEK3EXFmdiOZfLf1LEPoa1bNs9uVYaCc9RA8pKcV2qAxFuLMiPJAjUWECfxwEFO2CemQOrgc5zl1lpfOYXMDH0hzCZrgndBCvQMUjh/sZ21oAA3am5nFkUwKgj9+hQ1zyq/HDsbwjDlssnDsDDft8jUz9drlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732300837; c=relaxed/simple;
	bh=Tr+CCSmbSqt39nK5rtHG0dund7861QT5vv9sPNTfT/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I63I/pJAo6yN9UHH2VvSFPqd+zfVoQnpT8ZhhS4cOCHQWWOvy/IH07mgGpH5DuSbW3lhObh6DzU/hn5oxXG8AnypaUQj3JdbFy6Kymz/oT+jNbZUPsnYzPKtvhUrJS9GKTR4tpWG6SlgcUS4vUUBUBPFMOoJkIi/Lxan1ewOAUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sNbtDrqP; arc=fail smtp.client-ip=40.107.95.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MqLmWZBgBGgBMByyPTCkhSqOiA4MIWYckEd/QFCmn7gqVPrQQXoAh7lAE3n4J7X5n3l+QGH8Rk63GwFqyikKwg2XmBGbqFXPP7/rSdt6hpUmd6S4MSh3O0ffFnDMUfWW/gTGuhytUjPlpo6JJOIsZXEV3PlBsAEw8QPVeaU4OAaI3WJjHsgwCphW44S7nO+bo+AI06+AtLGKhuGAIFtfZhIbKBCJnPHyqsFHRCl9gJLd6z+ValySw8IgVhH5wWFAa2dkEjmhTz2xjUCqaG9O5X5ViW3H71jdG4t/lwYuvVCTSk3IbK8tA/GYTrhmEQj1S20no5fW5hEFDj9Z4FBgXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1BGl6427cV86134UyNYcTzcSEbZdRiWhYqwy6CFjUA=;
 b=oQH8dqQL6pReEt9MR9YYR7Nsv26bxVYHcLRjya+ww20gHQ7Bzh09H2v72UuY6JcQllG+kg/FHlUHPY6DEcg4P9xeXezNg87P6AtIM7Ms2Z7Yf1Qe2iVSqbGmwj1wi+IlakUKPJPfOE1Gu2BTmyJJe1ExAbKZlz8WjOV1ee1QLUSeRMIeA9fN3Nb0fIHSvVrAISiblQaK/Y5VEoO91kiPF6Cdcx72RtqALQM1NzEHnsKtGRDTE7GEEOpkNnfAeZHizjwIB33uRLj0nV67g1cOmslirtKQggKbt3xVCxvj4pj0tdJ5pKkr+oGhsbSehDZ7FOTtFgP0EesU39Tz3T6/Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1BGl6427cV86134UyNYcTzcSEbZdRiWhYqwy6CFjUA=;
 b=sNbtDrqPfCaawrdP7rZs5vowAMGz/bhj7cX9nqilAece6N+nd2FjIdpTTwCcVj7inTos2SqJLuPxDoTPue5V2F8LzUPmt8Fe1ZUIqPgMdA34tMkIjejdM+RmTXrIU+mkIQDHsOnt0Btnw+7sHFbFQ0O7c84sGRYs07zebiA4Gik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9)
 by MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Fri, 22 Nov
 2024 18:40:33 +0000
Received: from PH7PR12MB5688.namprd12.prod.outlook.com
 ([fe80::b26b:9164:45e2:22d5]) by PH7PR12MB5688.namprd12.prod.outlook.com
 ([fe80::b26b:9164:45e2:22d5%4]) with mapi id 15.20.8158.019; Fri, 22 Nov 2024
 18:40:33 +0000
Message-ID: <589ccb59-ae79-49db-8017-f6d28d7f6982@amd.com>
Date: Fri, 22 Nov 2024 12:40:08 -0600
User-Agent: Mozilla Thunderbird
Reply-To: michael.day@amd.com
Subject: Re: [PATCH 1/4] KVM: guest_memfd: add generic post_populate callback
To: Nikita Kalyazin <kalyazin@amazon.com>, pbonzini@redhat.com,
 corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: jthoughton@google.com, brijesh.singh@amd.com, michael.roth@amd.com,
 graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
 nsaenz@amazon.es, xmarcalx@amazon.com
References: <20241024095429.54052-1-kalyazin@amazon.com>
 <20241024095429.54052-2-kalyazin@amazon.com>
From: Mike Day <michael.day@amd.com>
Content-Language: en-US
In-Reply-To: <20241024095429.54052-2-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0110.namprd04.prod.outlook.com
 (2603:10b6:806:122::25) To PH7PR12MB5688.namprd12.prod.outlook.com
 (2603:10b6:510:130::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5688:EE_|MW4PR12MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 67f8c548-4e04-4cd4-3589-08dd0b25258a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmgrNVg2aWF3N21ZYjhkZWdjOTZHM3d5UHZodkZ3cXV6MnlWdXBSOVVYRzhQ?=
 =?utf-8?B?QVh4VlhWaUJiMndpelpJcTVpc2ZmcG83UHBDZ1o3VDZVYzRVUi83NUdsYmxI?=
 =?utf-8?B?RkU0bHVoRlY0RCtPYVV3RndlOC9TYWxER2gxUEtSNkRSNGMzZWc3NnYwVFlH?=
 =?utf-8?B?bzA1Q3BuK3BvWW04ZnJLRGdzTkpLWTRVSUJMaFRGekJHQTlSWVYxMUtRREw2?=
 =?utf-8?B?bjcwVmhEWkZoWnV5emZ4M3JwSU9Kc29yeWliQ21SZkp2N0ttQW9CRFFGdURm?=
 =?utf-8?B?SnRaWkV1M2NlcGR5cEV5N1R6bTFzSjhNVnRLdGk3NlFKT2wxRTJMY3BqWTJw?=
 =?utf-8?B?OXdUbHArWjNYeFFqM0tlZUNDQWh6VUFDbk5JQkE3Zi9UUExoR09HNWE5ZDg4?=
 =?utf-8?B?eTBXT0JVTjR2VkZYR2c4alp5ZENEK2lHOXZXK285REJzMEZNSWZsb1hJVnpH?=
 =?utf-8?B?b0xPL2tsY21UMEhpa3lJVDJ1ZHZ0bEorOVY5R1I0UnZDWTFsWGdnWGR3Qm1z?=
 =?utf-8?B?UjQ4SWdLNldhYmJURXViL0R4d1VCbkJwOTBEUy9sWDFYa0g4bS95ZHA2dU1Z?=
 =?utf-8?B?MEFaVUlaM0hLbXE3ZmZrc2pEOG5lU1pGTnZKVytidzMwZ2JXckNDZW1VYU9h?=
 =?utf-8?B?eFdPVnVpakNYay96Y09RbDFKR2MxeTkvaWpQMWkwdHk2NU5ZVWV0d1RlOEN5?=
 =?utf-8?B?UWdDSlpjRndaSjE2TnNYRWNyV0xTRGR0QkczdDVWV1FvTWNtMjhzdVQwOTlE?=
 =?utf-8?B?cnZ1YkhFd1dwM3ZrSTM2WDJxYTQ4eFh5VlhOY1BEZE0rNGpIQzc3Q1pPSzB1?=
 =?utf-8?B?elRMcGkrd1kydjBidkJHMVZGNzZIK0FCc3RlMGhYOG9UbUV3RnRoRXlabGhp?=
 =?utf-8?B?aVhRTnAvSTM4bzVOOU5Kb01iU1dRZ2VvdDA3Skh1MHhBakpMVE5maUpPaXFU?=
 =?utf-8?B?QmN3cENCeVBVUWpkWFJmcSt4bDNTQ0cwZjIyb0pYK2FQZXl1NERiWkM3YVE4?=
 =?utf-8?B?SmlpK1pZcTNTMUZBMjQ1bkRxT1hSOFBtaGpweXM0RHVib2FSUHpPMjZkVElY?=
 =?utf-8?B?cXJFSWp6eUlVSjVWRVNlNC9lcXRoUlJic094czRWVG9WTXVKcXNzMVFQWFkv?=
 =?utf-8?B?RGVGV3FVUDBGWVZPYjFCOWZ1MmtWUVVTVVI3N1hWd21RTmdPUEN6ZzBDY2Zl?=
 =?utf-8?B?aUNBT3pSazFMS3BWMG1MSVRvNExIOFlMM0l5d2hpdWFXOG9WK2kyTk1JZnlO?=
 =?utf-8?B?S2Jkdzl0WjVzZWU4WEVLQUVCb1NVdVZsOHFZNlZndGtNcU5GY1hVYWtxbEFH?=
 =?utf-8?B?UGxsZld6d3ZsTFViaks2bWc3N1lRVXdWVjVqZno1NlJEU0hFNElKWmx2SUpl?=
 =?utf-8?B?b211R0o2K1dYRHRIdUkxeUpLcGV3SjJ2M256aXRqU2Uyb3pNYkIvQVFWanl0?=
 =?utf-8?B?U0c3Z3QvN1lLN2F6aFowb2pXOVN4cnFOK0Q1bWFaQjVYdTVsSExwU294RU5X?=
 =?utf-8?B?VjhGelowdC9GaWRPYTBXYlNZMk9PRE55QlBDM09DUlJ2MlZielN5NVV4dkM2?=
 =?utf-8?B?MjFTQVlsbmI5R0xnL1FZWEMxYjVRR1psZ1NvQTJIQVB5emhiYVZ5VzBlVkdV?=
 =?utf-8?B?T282TXRySnl3SmRXNmovSzh2N3RGV1dXUEdKbVJFU29LMG4ycmxZeSs0Rm9q?=
 =?utf-8?B?LzMwTmVsK1p6NVdRUkc4YVFRRS8wZU1udnVYaS9BUjBOSGhTbGdFZzI1ZVpE?=
 =?utf-8?Q?wo6797DKoMfiTYveEKRDIwsl5TXw5Xw4GPZP5MN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5688.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0V2ZnBHektmQUxrSEZGZHMwN1BnelF6cTVHZVpQd3lQQ0VTakhaM3IzYk5s?=
 =?utf-8?B?d0E2eFZ2WjVyTmlsNVV2djU2a2ZuUVpGK3gzSjJWaWtKUnV1aUxTSXgzRExp?=
 =?utf-8?B?L24wSVB1WjROYlY0K1J6RFl1VHkyWEtGUnlKTDFnZ3pBTDBPV3QxVkVsK2ZS?=
 =?utf-8?B?OUJQZms1SnprWVorMGV4cS9OTHRCbk9VdVE2Y1JJbk92eUVmK21NMnQ0RDZK?=
 =?utf-8?B?TTUrYStOZmRxaWhaUG5OQ3c1bDZseWZvOFNiTVZTa0IyR0ppOVZET0lQSEow?=
 =?utf-8?B?ZzYyclBxcHpwNi9PY0cwQ1lraXhGQk5HK1hWQ1BuNnJTT2Y1c0RvZmRtbU5S?=
 =?utf-8?B?aEZRZm1nYlMzU2ZiSXR4TndTVVJZSFNUOENXR2RMUDFLbUZBR21IeGxwazcz?=
 =?utf-8?B?c3BPSWYyZjI2MHF1KzN1UTF1dzF1SnQ1dDNLZEhaamtMM1Z3ZzU3SDJEYld6?=
 =?utf-8?B?aGZXYlZyeXZPOEM4dkdaMm1CeUNWY1diS2tGOUNWOTVRRitmU3lHVWlLcVNU?=
 =?utf-8?B?bUlsOWU0cDB3eWd4SmdIU0x6WDAwQVd3NWhKc2dORVFPSGtIQXM1UmlHYzhq?=
 =?utf-8?B?R2x5aE5SaTFZMElJckRCeHVhamZidndzZlVLZHR0YlBNN1llS3duQW8wclh2?=
 =?utf-8?B?R3lpQUlkczFleS9KVEt2dWt4OUs2UllEbXdYT1FVWTJKQlU1aG0zbnVLSmY2?=
 =?utf-8?B?VW1KR0ROc1Q1ZFV1akNuNzFMZTJzR3hPL1luak8yenFxUjRhK1d5SzNkVWtH?=
 =?utf-8?B?SXFRVGR0ZUIwVy9uRXFjR0xobFQ5K2dWcnN2NlhwMWFzZjQxLzd0UUZpRjF6?=
 =?utf-8?B?WFVyRTg1UUFZdk5wZjg0a2JjdjR2eGJnNVNjcXZiaHo4eXk4ekFucFEwKzNH?=
 =?utf-8?B?RGs3OExLVlpmV2NPT1h4Kzczb2FqMUdyTCttRUh0SGNIUmtxa2pRUGMvdzh4?=
 =?utf-8?B?OUNmRW1JZlVKTklPZkMwNFNIOTRzK3lUTmVaSkhtaDdGU3VXNVdxTHZ6Wm1l?=
 =?utf-8?B?Z1FndXg4MlhpVGZFNHpGZkhsLzB5ZWc0Q3hMbkxhaXpISUtqNmt1RUlEZmZB?=
 =?utf-8?B?K2E2YU9oZ0NIUHhzQzhURnF0ZVJVV3V2M29ldkx2YWxBSDMrQThvMlFsUEMy?=
 =?utf-8?B?ODhsV09Ca09EMGhGczhzRDl6NXpweXdqN1BncXZ4eFlaeEgwcVRTWFdxSFJ5?=
 =?utf-8?B?ZFB3NTZjUldhZXRSdk41T1Rmd1VXSTZaajl6cWdoQklvNUlKaWR4aGFsQWFU?=
 =?utf-8?B?Y1RsWnI1SitLamEzQnNWL0EzUk1oYW9tcG5UMUQrYnZ4cUp0dy9tVy9LUmhO?=
 =?utf-8?B?ZnhsdHVtL1htUjB5OENna09UcjJKb2ZaTlFqS3JxNkovSTF1OGd2MmtSNGNs?=
 =?utf-8?B?OWg0U3hXVUFkVEhHa0VsZVBuUG1SaWovMzVoc2RJQXdqdkE1bnFkN1RHS1ND?=
 =?utf-8?B?TktoRE1HV3F3NStHcytuT0EzZ1lwNXJKLzd6S20wNmRSNytOVlBOYUM1SjM1?=
 =?utf-8?B?UC9SZ3R3eURnM1M5NS9SWXNESUZscHh4S3BmQU02alpZN1VXa2RHV0hsUEt0?=
 =?utf-8?B?Y2RxUWNPZFQrR3VEMDlMa3NiVWNqM2M3dGkvbm1jYzFkdHNnRFgrQW8vQVFQ?=
 =?utf-8?B?U1lKeGpMaE93em1URnVQVTlqdHR1bzEyTzVnNWJKQW0xbkUySFl6VUN6ZU5N?=
 =?utf-8?B?MkN2M094akpRZHJaUkhWZy91RWRlM3NLdkl6dnNkVlRQa1hHT0NwdGhvR2Uv?=
 =?utf-8?B?RWMwUjhyVEUwRUgvOGVDREF0UDFYV2NHKzdGWWk1RTVvaEtzaXN3N0s0eWY4?=
 =?utf-8?B?ZWhHUGlYblZXdDFqaXpTUlhJQ0o0ODdNVkViMngvNVY0S0tVbmQ5cmEycFJj?=
 =?utf-8?B?M09hNm5sZ3ErM28yR2dmbjZFWVZjaEppNlNDVGc1UTRXWThMdGY5NVRFbEdx?=
 =?utf-8?B?NXR2NUk3YTE1M2w3U2JCdlp5ejBXOUprUndVdnM3QTNVMkJuejhQY1p6M2pl?=
 =?utf-8?B?bDcyN0NNRmI2UlpKU0xqTE15dWNsdDNLWmxMdVNkaXJ5WGdYcTIralNoQzFj?=
 =?utf-8?B?QUxaR1VoT1NGMFZveVMzV0tEVnpkRW5ERWhuT1Q4bzdjWWtBZlJSNEN4M0RV?=
 =?utf-8?Q?bkE3J/9onys07HCKd0y3RlOWW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f8c548-4e04-4cd4-3589-08dd0b25258a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5688.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 18:40:32.9415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HU6ggxJ1JL03CWCn6AKL/EpC4WQS7kutGcwk6wrL8JSRzmEJ/ECE8f+K4NcrEAPaQFPR9EmJcTHwmE6dKBzJ6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7213



On 10/24/24 04:54, Nikita Kalyazin wrote:
> This adds a generic implementation of the `post_populate` callback for
> the `kvm_gmem_populate`.  The only thing it does is populates the pages
> with data provided by userspace if the user pointer is not NULL,
> otherwise it clears the pages.
> This is supposed to be used by KVM_X86_SW_PROTECTED_VM VMs.
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>   virt/kvm/guest_memfd.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 8f079a61a56d..954312fac462 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -620,6 +620,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>   
>   #ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM

KVM_AMD_SEV can select KVM_GENERIC_PRIVATE_MEM, so to guarantee this is only for
software protection it might be good to use:

#if defined CONFIG_KVM_GENERIC_PRIVATE_MEM && !defined CONFIG_KVM_AMD_SEV

That could end up too verbose so there should probably be some more concise mechanism
to guarantee this generic callback isn't used for a hardware-protected guest.

Mike

> +static int kvm_gmem_post_populate_generic(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> +				  void __user *src, int order, void *opaque)
> +{
> +	int ret = 0, i;
> +	int npages = (1 << order);
> +	gfn_t gfn;
> +
> +	if (src) {
> +		void *vaddr = kmap_local_pfn(pfn);
> +
> +		ret = copy_from_user(vaddr, src, npages * PAGE_SIZE);
> +		if (ret)
> +			ret = -EINVAL;
> +		kunmap_local(vaddr);
> +	} else
> +		for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++)
> +			clear_highpage(pfn_to_page(pfn + i));
> +
> +	return ret;
> +}
> +
>   long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>   		       kvm_gmem_populate_cb post_populate, void *opaque)
>   {

