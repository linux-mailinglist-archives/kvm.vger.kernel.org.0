Return-Path: <kvm+bounces-33863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C003D9F3551
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 17:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD8FD7A22BD
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 16:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E16515278E;
	Mon, 16 Dec 2024 16:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e8ahPtE3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577DA13CA8A;
	Mon, 16 Dec 2024 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734365218; cv=fail; b=jr9WlL22ULMZLoHL47cFgp7bdoP3KnHo6gXwhPfJ3mFL6QP/9r2HcYBaW7/O69d7dQfpD9jAA0ADLJC6DDjBk1d5hffQrQaPmpAIfMSZuoorxHxJqLSI5ltmciiCEUE3lFZ7XpxUMCSQ878B3G+FrrmpGpOtgFHpkwAR9BFXcV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734365218; c=relaxed/simple;
	bh=L6l76hHBDi69tW2rHy+EpRqM6mucN1RqqTJm3gZopVc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rYVs8bBd0jPzyuWNIpyJN+IUL15ACfvpgcJlPwAuYEyahcDwmxXG74BJqmPtDZTzm25jqzyKwRByM6SQTtLOhN2AYH1BV9EhkU2SB/KpVwZH9oAT7YBCNPeRQA0iC/SEF2UcN8VyQBK/T9D3bHqTFGl/iUA/yDy5hOvT64fkbas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e8ahPtE3; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tuuVjKrTKiz07Romiu8Uso6jtsZBpP2L4Kq9yBE/aNk4biTXmq9KTQAcDd28vgsM3YMCDB+MJOWn6W2jgZ5S22JMzGnC1dKrcjgEGbr33Q5p30IuOM3WYFCcyzcWXhrO+whHPLtX7EmmtAQdyAhCAG+rSKNu6qEND5HOThsJAsXNi06YHIjB93gRYuAg77g15zVkQ7VlXC1ZGRmytE/4+2AlU04QWWmsev6k0zKoZELrOq1MecyH4g5/4Gpu31oyCFQ+csKzkNyEdKHHGsZQIfTjV7iGehNWf96+wX6SmwL+NpxBjCb3NGmFr8Ym7qnFCpVcEwAS3+YrsbAW1KApQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wDjhGyZPwyZUqizs0w0NLWkZkXGH9stYhDEjGWCoEg=;
 b=iRIpDOiycVD1NoloT9cJ9TfBXJ6zUaDwxoySX9MCKy3E1hZdknt7pC9I/WO5sIq609WG6cl6adcLeYZFR14tD6EgV2IrFaY+psX8gfP0KjHpVAp07ETP4oyUxYQpLw7ln3FQ+nokrgovkjbatV5nLn2BOlj/7G5s21acFrnzKYObiBX7ihe3IgAM9oht0FJ5DToG41jCE9mPX8IC//0RwqIm2MeRLyCr5jdmPXwJh0zvtKXZyCSgGgU9I8tA8i4TRehvEydoeNkGGACxTGrNpMLa7MS4W1aB1K4eIbzOzYXJyFGpqJZQN0/Zvc8HMx+e8sZBMeB5llzorkF3CWPArg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wDjhGyZPwyZUqizs0w0NLWkZkXGH9stYhDEjGWCoEg=;
 b=e8ahPtE32wML4xyyHGWwo5H/WTw272qAKDuvyBj3rOb+Nnjx2+0iJRvotmpMeJoJ8kVVweTuD3CyFNa8+KDdbtFBdTUoSr9UyIwJBJ50ZYvjE8CD10iaeiXEgkONOMTljMJNSXy9axBMjuoO10fZxtYPaVBRRXrsQJzrpQ0Kl4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4195.namprd12.prod.outlook.com (2603:10b6:a03:200::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Mon, 16 Dec
 2024 16:06:54 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.015; Mon, 16 Dec 2024
 16:06:54 +0000
Message-ID: <bad7406d-4a0b-d871-cc02-3ffb9e9185ba@amd.com>
Date: Mon, 16 Dec 2024 10:06:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v15 03/13] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-4-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241203090045.942078-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0003.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::31) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4195:EE_
X-MS-Office365-Filtering-Correlation-Id: b3ff66d4-1c80-4f28-4d9f-08dd1deba8ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjZwN3N1bG5DN2pRdUdESUtOZkw0R2Y4RVlOVXQ4dXYrYmU4U2ZSSko0dEpC?=
 =?utf-8?B?Wm02WTRoZHJ6STc0b3M0S2toNjlkalhaQnpFeHI3WXlwclFkRXp0WlV5YXI0?=
 =?utf-8?B?a212b1pGNWthSHk5ZERFeVl3dDQyTm9senhKS0htVWIyY0xvNk4zQTFTcDdh?=
 =?utf-8?B?WWNsVFVudXp4V2pkRUxwcjc0a21lalBNUUtZcm9GdVZZVlh6SC80aXByOVlM?=
 =?utf-8?B?RWVQTlNIOFhGcm5zV1lOTkFNdy84L0VRRndna1orSlo3QTF5QzJMUDkzN1RW?=
 =?utf-8?B?dzJ0YVZpRnVTZlUvaFd5MitZbi9GTUFPOG5ZMmlsTFJ0eGM3TmM4bWNPRmx2?=
 =?utf-8?B?RFpVRTVXc29PdmRXQWhXRmJDNFR0b2d6NXJkRWc0YktzUEJnS212SkhxUTBz?=
 =?utf-8?B?VmpZWE1QUk9XNmUrRHNTRlV4YWNTdFhsWGlZYnJaSk5Jajl6dVlqNGcveHQ3?=
 =?utf-8?B?MWRMZ1N3UlQwdVNnK0pibHFoTXUvdzhRUjVWMEhLVFV3OXNVeDk5R2ZzWS8x?=
 =?utf-8?B?S0xnOEF0d0ZONjRUY05XV3NBOFpKVkFOejZ3aUJxaFNtYklhamZkYzJpbEhw?=
 =?utf-8?B?YU11TGdSN3liMW9sNHBJV0Q1cnNvK1RDcTd1SWtqMHZDczRYaVhrSjJOY1Na?=
 =?utf-8?B?bzVLdnhHTmY4c2VuYjg0L0JHTUVVZHJ2bkRpZXRLYktucHM0UXhYaFdNd1Nn?=
 =?utf-8?B?QysybFF2N09nWFE1VUM1UVlzQ1VkWGRSSGpqbWVaZm5GZTQvSDJyM2FHMHhx?=
 =?utf-8?B?M0dRcDVaeDE2ZzVUdzl5RitZYlVOd2dqa0hCUzJ5UlVxTjZZOEc2U29Wblov?=
 =?utf-8?B?ZW9PNTFTdU5FcXdySDVpMmREeWVQUTBvOHhLcHJ5dThHUWVjUWU5bDhOckFh?=
 =?utf-8?B?N25TRVh3TDllV3dhZWd4eHhPN0FwcVI1UGhDN3UxUlUzU3RzTFZYT1pDMVM3?=
 =?utf-8?B?RlhOY0V6MWZtc1ltVHFtWk5JbzFaR2FpMkVQVFg2QjArNXpFUWoxbmI1U3Bl?=
 =?utf-8?B?N2VVa09CR3FMd0lBMVZjTXZudnQ0ejlHaUU0K1pjWElFY3dGUExHWHRiWGR0?=
 =?utf-8?B?RHFFVE9mSHgzQ0ZQZHZWazE2QThkTGljeCtnRkRaVXpEdnhvUFNlNWY5VFJB?=
 =?utf-8?B?aCsxYjQwNW5hTEVBdjE5TUxzVVVaQUVTZDBBZlZzOVVyeFR1T1dWUS9aWTRM?=
 =?utf-8?B?YkhwODQ1OWJhaTR3WVlrU3VxQUErMGRLMjlreThRb1ZsTWtDL2xzVHFlN1F0?=
 =?utf-8?B?OGdTNVB0cUtjdHptdzdXb1BadnFTWnpkY2g2RlhiOUFYQmR6bFNxQVZmMjBv?=
 =?utf-8?B?UjljdEMxMFQ0eHpLVWNKM3F2cEFldjZtQXlNMThpZU4xMUlJV252Z2lUaXZy?=
 =?utf-8?B?RjJoZjR2K3lEMWp5NEllZEVnRUR5SU5LdFFwZUlUSVd0Wml5cFFXNnZwRXRC?=
 =?utf-8?B?M0p6QkJzSjgwMnNGRnFTRHdQN05jaDl6enpzVUJMNjYzZmY1emFMSXVuR2NV?=
 =?utf-8?B?UFZVZ2ZOMSs1VmZ0YXh0akNvMzlaY0FCcEtDOFZQM3dXZ1F5Y3JnRzI0VWVR?=
 =?utf-8?B?bm9yUVdlOFFrTlNxQVo2NjM3UzB5bzRVQjU1NnVTaGlpMGpoeTBwdW9XSElo?=
 =?utf-8?B?ZDExOVlvOUZxNGZ5c0dRZkd5VnJBdEVzZTIwejVWbDVFNWQ1aFhCWHFXcGRt?=
 =?utf-8?B?V3VxSkFaL1QzUzhHc0VIWTdjZzBrSTFhZ1RPb2FRUjQ4eUxkMEowdlR5ZWZU?=
 =?utf-8?B?S2NUZjlabmlNd2VpZEw0SUVvemF1ZytyMGc5QjMxU1RWWGx5dCtWWXFlaU1y?=
 =?utf-8?B?eC9FTkRkYXdKQWJoNldpWW9jZGIyd0FjcDcyOS9qaGpWSDFRWUQzNUhHeUNP?=
 =?utf-8?Q?Fuxa77XBFsN9S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bU1YSWJjcTRuMmo1cHZEdkJ2bDVlSXdzbW1HSERDc3d6YjB5cmx0bUliRzA0?=
 =?utf-8?B?SG5XZEk3dFdrSHNMalNhcjdLK0xMMkV1NXA3UjZ6eW91eWtJVUtxa0VZM1hw?=
 =?utf-8?B?L3FkdGs2Wi9JVFY2SEZEWmhwZ3NaTkhBZGlOLzcrYzllL2JqSXcxN3FQQml6?=
 =?utf-8?B?ZEhGUlBHSWh4c0F4YUVSOFc4TUpuT3c5N1BOajhoUjArc0ZqakFrTTJXMnJE?=
 =?utf-8?B?NTJUZnYxOG9oUjFLMTBHcGhHY1hOYUNKL1BaRVFoMm1TbHpQbmE2R0xTZzdG?=
 =?utf-8?B?emVneVFrSjBJVlkvYnhBUXdlTE9sTmpNUDA3KzMrQ1h2bDJJcGhCa2VWNnNQ?=
 =?utf-8?B?K21TRlNIQXVRbExySGROT2JRUDJrVWw2eG5rZlI0TzJpVUE0UWwzeEVFQk4z?=
 =?utf-8?B?THVQRmdSdXorOWRDUlNWYnpXWWdmUy9FRk5hYnl0VHB1dEIzZmlhL0lYRnBj?=
 =?utf-8?B?T2RTenJRU0M2YjhJQ2VOOU45TUgyc3lEK2NPaEIzL24ySlEvTlRjRlZGNXRt?=
 =?utf-8?B?WmJyb2t0YnlmSERTSzBBTXhjTDl4Nmt1YU9VellkeHFlOG9SOFZrQ2s2S1Za?=
 =?utf-8?B?S0Y5Yk13L1UveGdocytkYWlHdGROTXFvdTNpekJwNUZHMmlsOTQ3Qm1nR3l6?=
 =?utf-8?B?elZzNVFraDVpVzdjS2ltKy84QklEMUgwdG9BL09UOSsxcEtvWnk0YlN6M2RD?=
 =?utf-8?B?dXVFMVhJcUJTc0FtV2w1Q3ducndxNGZSNVN3L05SeHFjWTFuR3hIUkIxMUpu?=
 =?utf-8?B?WWZhUGxiQW1RYXk4K2xRVHBWV1pDNEFxZGM1cm8reTUvcDJiVG10MlBxK1Ey?=
 =?utf-8?B?dmhYaEhQR2ppckRlUmxMZXB6b0hsZnI1V08wQlkyMklGZHZMNXVLc05HcHg5?=
 =?utf-8?B?cjJydDlqNEV1STFnUUhMV2gxRzRacTBwQlE0T0RnY0FUdXUwakcveUpOdXZm?=
 =?utf-8?B?dityVkM3bzBoOU52a0EvRWRqVEpKaldhc2dFTEdiejYzem9qR05zelQ4eERl?=
 =?utf-8?B?dnRUZ1h3UkQydng5ZW1zclc4M1N4eE9NWEJFU1dhcW5hUmxZaDdLWUdzR0k4?=
 =?utf-8?B?VkxCa2l6Y01UN2NtYnpNTTU5ZWNuWlVMZkRaNVEydHRMbUhXYUYrek5VZnR5?=
 =?utf-8?B?djdrbzJXMG16aWZmWThoSnZ2Yy9tdW5hak1uMEhsRzhOeFh2SHVselpZd25a?=
 =?utf-8?B?TTZ2SW9HN2tzbmovWkVyNUYyYVVRSjBRNDF3MlVLZnZuSU9BT3JHQzg5cFIw?=
 =?utf-8?B?em4zRm43Wmt1VE5uTkh3b28zTlhMNFBzamROU2Vxc2JYMGtLaEYzUit1S1p0?=
 =?utf-8?B?aXJCRGJLKy9qVjk1TVpqWDZDeXFaNEhNR3pVYk9xOWRsVzUwV1lXSXEvb1RP?=
 =?utf-8?B?dTNMcnlFci9xRkVVN1lyU0drVUowRmo4Y2REQVJDdS9BWDdmQ1R0ZFdKWWpv?=
 =?utf-8?B?Q2IraFpGQ0tRUkJKQkRVVW1Xd3N4R0FwMUtqc0hMeE93TytTWGgvcFAvaVEz?=
 =?utf-8?B?NVV1dGtVcmYvajJ2VFpTTXp1MW5sN0hVaDFwbzEyR1RZQkFXNC9HdC9HeVg2?=
 =?utf-8?B?UitOS1hOUEFGV0ZwS3ZBUXJVQnMyUnVoQVBveWpHRE4zUUdqaUJMRDM4NlhU?=
 =?utf-8?B?OHN5bUZibCt1MjRhWjZXWHdYbVByckNYRjR2SmUvZHdZbytoRlZhdkhyUzdk?=
 =?utf-8?B?dnJxTGJ5NjZBUUthSkpBUXpZT3JsU0wxSzhwZ3pQR0tBRkI2Nmpscll5TG81?=
 =?utf-8?B?dW1tSlhrL3NPa29xSk1teWg3MUxOOURod1RnYzVWaWpBVDF1d0VKNWdabzNs?=
 =?utf-8?B?cDdhSjBmUldjd2VwcUI3bFdlMHF0dkxDVWFackl6VFNRSFRORjNCYXZvLzRk?=
 =?utf-8?B?NnA1SFBreTU1RytiQkNGeUhhTTJlY3ZSOUNtOEZOVGVacVdvcnE1TTY1U2xI?=
 =?utf-8?B?TWxxcnZPSHg5TTg5WWJJWHBncUk4bWlyLzFiR1FibW1CdjNRdWJzQnMxQXRr?=
 =?utf-8?B?MWdsYVdBWEVFZ0NBR3JoY0lHSTlMc2MvamtlZy9aZ3ROOFppc1BHMkJqdnN5?=
 =?utf-8?B?QzhWVGNqSWQwQ3BWWGR4NVdiUXdMVFdOMGpoRTVOYmRKZTh3eGFtQWMwcTNM?=
 =?utf-8?Q?cJ/Y41Go5wdDL8Dq7fmYwViFz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ff66d4-1c80-4f28-4d9f-08dd1deba8ad
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 16:06:54.2599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmTtf7WZ38sNh3eGWzK8Uv5OLsuwMeEpixXLYPATVEsXjoW9uyBUWfwb4hbw+umWrGQCPrNk1BKfuXXzoRP79g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4195

On 12/3/24 03:00, Nikunj A Dadhania wrote:
> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
> used cannot be altered by the hypervisor once the guest is launched.
> 
> Secure TSC-enabled guests need to query TSC information from the AMD
> Security Processor. This communication channel is encrypted between the AMD
> Security Processor and the guest, with the hypervisor acting merely as a
> conduit to deliver the guest messages to the AMD Security Processor. Each
> message is protected with AEAD (AES-256 GCM).
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Just some minor nits if you have to respin...

> ---
>  arch/x86/include/asm/sev-common.h |   1 +
>  arch/x86/include/asm/sev.h        |  22 ++++++
>  arch/x86/include/asm/svm.h        |   6 +-
>  include/linux/cc_platform.h       |   8 +++
>  arch/x86/coco/core.c              |   3 +
>  arch/x86/coco/sev/core.c          | 116 ++++++++++++++++++++++++++++++
>  arch/x86/mm/mem_encrypt.c         |   2 +
>  7 files changed, 156 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 50f5666938c0..6ef92432a5ce 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -206,6 +206,7 @@ struct snp_psc_desc {
>  #define GHCB_TERM_NO_SVSM		7	/* SVSM is not advertised in the secrets page */
>  #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
>  #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
> +#define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 53f3048f484e..9fd02efef08e 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -146,6 +146,9 @@ enum msg_type {
>  	SNP_MSG_VMRK_REQ,
>  	SNP_MSG_VMRK_RSP,
>  
> +	SNP_MSG_TSC_INFO_REQ = 17,
> +	SNP_MSG_TSC_INFO_RSP,
> +
>  	SNP_MSG_TYPE_MAX
>  };
>  
> @@ -174,6 +177,22 @@ struct snp_guest_msg {
>  	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
>  } __packed;
>  
> +#define SNP_TSC_INFO_REQ_SZ	128
> +#define SNP_TSC_INFO_RESP_SZ	128
> +
> +struct snp_tsc_info_req {
> +	u8 rsvd[SNP_TSC_INFO_REQ_SZ];
> +} __packed;
> +
> +struct snp_tsc_info_resp {
> +	u32 status;
> +	u32 rsvd1;
> +	u64 tsc_scale;
> +	u64 tsc_offset;
> +	u32 tsc_factor;
> +	u8 rsvd2[100];
> +} __packed;
> +
>  struct snp_guest_req {
>  	void *req_buf;
>  	size_t req_sz;
> @@ -473,6 +492,8 @@ void snp_msg_free(struct snp_msg_desc *mdesc);
>  int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  			   struct snp_guest_request_ioctl *rio);
>  
> +void __init snp_secure_tsc_prepare(void);
> +
>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>  
>  #define snp_vmpl 0
> @@ -514,6 +535,7 @@ static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
>  static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
>  static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
> +static inline void __init snp_secure_tsc_prepare(void) { }
>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 2b59b9951c90..92e18798f197 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -417,7 +417,9 @@ struct sev_es_save_area {
>  	u8 reserved_0x298[80];
>  	u32 pkru;
>  	u32 tsc_aux;
> -	u8 reserved_0x2f0[24];
> +	u64 tsc_scale;
> +	u64 tsc_offset;
> +	u8 reserved_0x300[8];
>  	u64 rcx;
>  	u64 rdx;
>  	u64 rbx;
> @@ -564,7 +566,7 @@ static inline void __unused_size_checks(void)
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
> -	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
> +	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index caa4b4430634..cb7103dc124f 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -88,6 +88,14 @@ enum cc_attr {
>  	 * enabled to run SEV-SNP guests.
>  	 */
>  	CC_ATTR_HOST_SEV_SNP,
> +
> +	/**
> +	 * @CC_ATTR_GUEST_SNP_SECURE_TSC: SNP Secure TSC is active.
> +	 *
> +	 * The platform/OS is running as a guest/virtual machine and actively
> +	 * using AMD SEV-SNP Secure TSC feature.
> +	 */
> +	CC_ATTR_GUEST_SNP_SECURE_TSC,

Maybe move this up above the host related attribute so that it is grouped
with the other guest attributes.

>  };
>  
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 0f81f70aca82..5b9a358a3254 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -100,6 +100,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>  	case CC_ATTR_HOST_SEV_SNP:
>  		return cc_flags.host_sev_snp;
>  
> +	case CC_ATTR_GUEST_SNP_SECURE_TSC:
> +		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
> +

Ditto here. Move this up above the host check.

Also, should this be:

	return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&
	       (sev_status & MSR_AMD64_SNP_SECURE_TSC);

?

>  	default:
>  		return false;
>  	}
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index a61898c7f114..39683101b526 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -96,6 +96,14 @@ static u64 sev_hv_features __ro_after_init;
>  /* Secrets page physical address from the CC blob */
>  static u64 secrets_pa __ro_after_init;
>  
> +/*
> + * For Secure TSC guests, the BP fetches TSC_INFO using SNP guest messaging and
> + * initializes snp_tsc_scale and snp_tsc_offset. These values are replicated
> + * across the APs VMSA fields (TSC_SCALE and TSC_OFFSET).
> + */
> +static u64 snp_tsc_scale __ro_after_init;
> +static u64 snp_tsc_offset __ro_after_init;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;
> @@ -1277,6 +1285,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
>  	vmsa->vmpl		= snp_vmpl;
>  	vmsa->sev_features	= sev_status >> 2;
>  
> +	/* Populate AP's TSC scale/offset to get accurate TSC values. */
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
> +		vmsa->tsc_scale = snp_tsc_scale;
> +		vmsa->tsc_offset = snp_tsc_offset;
> +	}
> +
>  	/* Switch the page over to a VMSA page now that it is initialized */
>  	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
>  	if (ret) {
> @@ -3127,3 +3141,105 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
>  }
>  EXPORT_SYMBOL_GPL(snp_send_guest_request);
>  
> +static int __init snp_get_tsc_info(void)
> +{
> +	struct snp_guest_request_ioctl *rio;
> +	struct snp_tsc_info_resp *tsc_resp;
> +	struct snp_tsc_info_req *tsc_req;
> +	struct snp_msg_desc *mdesc;
> +	struct snp_guest_req *req;
> +	unsigned char *buf;
> +	int rc = -ENOMEM;
> +
> +	tsc_req = kzalloc(sizeof(*tsc_req), GFP_KERNEL);
> +	if (!tsc_req)
> +		return rc;
> +
> +	tsc_resp = kzalloc(sizeof(*tsc_resp), GFP_KERNEL);
> +	if (!tsc_resp)
> +		goto e_free_tsc_req;
> +
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		goto e_free_tsc_resp;
> +
> +	rio = kzalloc(sizeof(*rio), GFP_KERNEL);
> +	if (!rio)
> +		goto e_free_req;
> +
> +	/*
> +	 * The intermediate response buffer is used while decrypting the
> +	 * response payload. Make sure that it has enough space to cover
> +	 * the authtag.
> +	 */
> +	buf = kzalloc(SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN, GFP_KERNEL);
> +	if (!buf)
> +		goto e_free_rio;
> +
> +	mdesc = snp_msg_alloc();
> +	if (IS_ERR_OR_NULL(mdesc))
> +		goto e_free_buf;
> +
> +	rc = snp_msg_init(mdesc, snp_vmpl);
> +	if (rc)
> +		goto e_free_mdesc;
> +
> +	req->msg_version = MSG_HDR_VER;
> +	req->msg_type = SNP_MSG_TSC_INFO_REQ;
> +	req->vmpck_id = snp_vmpl;
> +	req->req_buf = tsc_req;
> +	req->req_sz = sizeof(*tsc_req);
> +	req->resp_buf = buf;
> +	req->resp_sz = sizeof(*tsc_resp) + AUTHTAG_LEN;
> +	req->exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +
> +	rc = snp_send_guest_request(mdesc, req, rio);
> +	if (rc)
> +		goto e_request;
> +
> +	memcpy(tsc_resp, buf, sizeof(*tsc_resp));
> +	pr_debug("%s: response status 0x%x scale 0x%llx offset 0x%llx factor 0x%x\n",
> +		 __func__, tsc_resp->status, tsc_resp->tsc_scale, tsc_resp->tsc_offset,
> +		 tsc_resp->tsc_factor);
> +
> +	if (tsc_resp->status == 0) {
> +		snp_tsc_scale = tsc_resp->tsc_scale;
> +		snp_tsc_offset = tsc_resp->tsc_offset;
> +	} else {
> +		pr_err("Failed to get TSC info, response status 0x%x\n", tsc_resp->status);
> +		rc = -EIO;
> +	}
> +
> +e_request:
> +	/* The response buffer contains sensitive data, explicitly clear it. */
> +	memzero_explicit(buf, sizeof(buf));
> +	memzero_explicit(tsc_resp, sizeof(*tsc_resp));
> +e_free_mdesc:
> +	snp_msg_free(mdesc);
> +e_free_buf:
> +	kfree(buf);
> +e_free_rio:
> +	kfree(rio);
> +e_free_req:
> +	kfree(req);
> + e_free_tsc_resp:
> +	kfree(tsc_resp);
> +e_free_tsc_req:
> +	kfree(tsc_req);
> +
> +	return rc;
> +}
> +
> +void __init snp_secure_tsc_prepare(void)
> +{
> +	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) ||
> +	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))

If you make the change above, you only need to check for SNP_SECURE_TSC.

Thanks,
Tom

> +		return;
> +
> +	if (snp_get_tsc_info()) {
> +		pr_alert("Unable to retrieve Secure TSC info from ASP\n");
> +		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC);
> +	}
> +
> +	pr_debug("SecureTSC enabled");
> +}
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 0a120d85d7bb..95bae74fdab2 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -94,6 +94,8 @@ void __init mem_encrypt_init(void)
>  	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>  	swiotlb_update_mem_attributes();
>  
> +	snp_secure_tsc_prepare();
> +
>  	print_mem_encrypt_feature_info();
>  }
>  

