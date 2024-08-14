Return-Path: <kvm+bounces-24143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99741951C18
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE94FB229D7
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADFE1B14E6;
	Wed, 14 Aug 2024 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OQQ+h5mh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7622F1AE031;
	Wed, 14 Aug 2024 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723642984; cv=fail; b=bhNp2tTt/v5fLTXvvl/5FVhXf2+LdLl+AfprQ6d4c5A5VFY9cFRwFpuucoQchpq4cmxG3Gh1SDl9dyI1HxAPUganiJPvL/aIKXygtbd0xanQyNTnxO+IFuz8lmpMOuGIwuARsLA3Z+PPnYBRz7PyYLVsBWFQejGnBJAfNCEJYts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723642984; c=relaxed/simple;
	bh=8GH0dxDs3V4N+6svF0kdZsjkWmczVxnyx1xv8MbooTQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oJrSl7L+BJrAb919jd6R3Ava0/jFzXVdzf8dAQvDdqEAtK3TxYCI1T0oSqKtS8pGWeRAiA5w3411YqkoN8XE7KyTeruZW0lYsGln0V7aAfbfNE4G4b/rgsrk30Oj7G8cpZn6OpvFrxZUfTB0b0TnZiSvWAMSJAnYtTNz6VZ75Lk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OQQ+h5mh; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULjJAl+jmRuaGIcQkAwnFdDMph1i0dWwl6fKXqDjPvgLFaNMq4tNxeOjc5l6Z78kJgzDRvJDiBC+DfG2Rgv1wVuijJ6GWW0F8Gd2B6YQLSWB/7EQBmkIR6MSvG/vFZAHZE8CeHzo2PHrMQ0LW+jVAOhOeuEjVo/P6A4eqWeUmkKbkUgIWDQKwTfpdVWwA96GF8Ut0Aj2bUhQuLK3etD1o8ObTNmWeLnP1ye0JuEZvf7GEMTzbGXOffSMwUX+IbZC6Im0IrpdEIPYTFblyvjynnbJ63I8W5aZkZQEm0WDySTJEkawH4SEJReUOgiybrky26JeEzQEchM9NxhqXJR8kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IM2PcGi0rPpMIZBcww8sixcIljqFmzbtVYsPAtOUO8g=;
 b=scaBLAcE77467g1hDhRrl8i8okzOk3nk46KCLhZalTt18aZ4EyiJB87x3dvuFc4NVjv+UobnhgIsO6ONZWK6glQgjDitIQqM36cXPSuzwCCKXtRVJyMA/83UQNbbG910chMFsFbmcVvvj8abgDCnjajqkKMb4ad/AJFuTJOZt/zuc4A9mrZGsx/LzDvXT84wQzY2x52TgTU2K2c9Wfrmr7d/hDZYQBZhB8xQqwSE+FDLglZJ1RhCNV8lTw0/8pD/g/LYaIkeQOwwR6+CaMOjyNIphSdX4Flb2XqR84onEw166CyNFDGzZkUGzS7QvKPBBEAFEBYjKC4poFsWK4TFhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IM2PcGi0rPpMIZBcww8sixcIljqFmzbtVYsPAtOUO8g=;
 b=OQQ+h5mh5XIHr+o22Edlv0NdLonpqwQ4kk3bNbASERBHbHFge7h8KxmXPRSIY3pq8Njo0rn8gyViUaP9gaOjg9NQtkRGoOaB0ei4YLO5qAtAw3Y1Ilu9Vs0Cj34trsaOTf6hpY3GJavJ/UsqQ/3jGRodlGNy/SqUWItiB2D6oUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB6937.namprd12.prod.outlook.com (2603:10b6:510:1bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.24; Wed, 14 Aug
 2024 13:42:59 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 13:42:59 +0000
Message-ID: <aec84973-c329-4057-3dce-11ef4a973e40@amd.com>
Date: Wed, 14 Aug 2024 08:42:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SEV: uapi: fix typo in SEV_RET_INVALID_CONFIG
Content-Language: en-US
To: Amit Shah <amit@kernel.org>, seanjc@google.com, pbonzini@redhat.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Cc: amit.shah@amd.com, bp@alien8.de, ashish.kalra@amd.com, maz@kernel.org
References: <20240814083113.21622-1-amit@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240814083113.21622-1-amit@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0067.namprd13.prod.outlook.com
 (2603:10b6:806:23::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB6937:EE_
X-MS-Office365-Filtering-Correlation-Id: 970fe82d-5e98-47ca-a928-08dcbc6702db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ek9ldHo5VnI5UVJ6ODVFSlZ3YWpXNlhjamppcDdaTUxmaVBPUFZqSFluOER2?=
 =?utf-8?B?Yzc3THZEcktVbitybWJVVVVTbDBxRnp3bWJVVEpoa3JjQ2tZamxscFplUngw?=
 =?utf-8?B?ZlpKUTZsbktFckNPMUpKclFxeGdIV3R5aXdXMFBzZ0RWT3kvcHRaYy9PN3h0?=
 =?utf-8?B?RlAxMUNMQzBqcnFYNGlXbmRIQ1kxcG5aU0xwZ3FFdktGUHllQW9EOEpVNGhn?=
 =?utf-8?B?WGZtcG9mVGh6ZDlWQWtMQ01BNUVLZjBvZm5DaFUyYk14KzJXZG9yMVJ0d1k5?=
 =?utf-8?B?OGc1U2paYjBhTEJ6VzYvN2JKOGNxTXU2bWNQaXozbTJTNmkrN1FFbmZ3ZnlO?=
 =?utf-8?B?clpTSjh3ZVVlN0d6N1pML2hKMUZpL2x4bUxsMHozYWlQakRjcnlHT1A4QjJP?=
 =?utf-8?B?VU9lc3prTjRZblZObE1MTkxJd2ZCeXg2TWV0SjZINWxaVWJoa2U0R2FoUlpZ?=
 =?utf-8?B?MFpqSy9VWDh4MHFGOHlUTFBnLzBiM0Nhd3FJWXlyRm13bThYUmNTaStROVJI?=
 =?utf-8?B?RHlFd0ZRL1NtTHVoL0gvOE9IVXM0NExIbTRQcTY3UUFWcm9hSEh3bnYxaUVF?=
 =?utf-8?B?amJ6WWN3VzFMN1ZpUG54NkZmN1RWWmhQVzJKamxmWWVwWHpwSWI1MSszZVhL?=
 =?utf-8?B?MUdtWndIa0VvOFUxTVFaQnQzOXhsOEF0a2dybXVuQ1MxRnBzeDQ4U3JrWGxF?=
 =?utf-8?B?eDZPNUtzVVFkNEZ1RWFPM1hoY2pDY2hvdXJYc1BFbWh3Vmg3U1prWkgvbjhZ?=
 =?utf-8?B?K2pqdWV0a2gybFlsSmY5c3RpQ1pJVGQzNGplTmRqRXFJUUNxZGVRQ1MzRGtj?=
 =?utf-8?B?dWlEVGRza012aXNmYm80UmE3cFFDMy9xVi9HcEw1c3B3N3R5OFFXdUp6NC9l?=
 =?utf-8?B?cGtCVnltTERSOEwwc0lVYjJCY3ZPVGJxZUoyTUcxUy9ZeEYrSm9HV1pLeUdr?=
 =?utf-8?B?d0UvUTdGdDBsQmZzN3FsQUR2V3FTYkIxb1kxeXR0dDQ0S25SNnMrbE1ERnVa?=
 =?utf-8?B?VzFxdGovN0ZlcU5nRENUYTE2Rk1wL3dZWXJXaXZMaGVnOVFBN0l0RXFYMnpQ?=
 =?utf-8?B?YjN1WkxtdXg2aDR4dGg1RUlXQnRzSjdyekRjaWE3K0hwMnVaVFBIRTZPcjlW?=
 =?utf-8?B?ak1mUGNxMnNpbkQ4Vkx0TzltZXl2eE9aRlMwaFNoMjZhMDlHWHlZSmRoT1hn?=
 =?utf-8?B?b3JWa0hzRlFvZ0k2K05yamt1aFZCRkNndGh1VkFsdEhTQmdLQ1hhWGFZbWh5?=
 =?utf-8?B?NFBsblgyOS85RkR4c0c1RXJwdXZlQUMxYnc3akx0K1dzZmFFcDI1K2hsUkhK?=
 =?utf-8?B?ekp5OTErZ2l4UW96QTQ0bk1ITStSUHl1K3ozL3pEbjMrQWhDV1JqcnQyT2NH?=
 =?utf-8?B?anEzdm1iVkp4R2gvWFVOQ2lNbXpZTGY1Z1FaTU42bnNFdWRwNkxMNStXWTBu?=
 =?utf-8?B?cVdlY083WVZob0dsYjdBazliZFFIV2U4UmxRaEVSOW9yaHYzRmJVNFVnL3Qx?=
 =?utf-8?B?RCtnNmIwUWpDSEd2MmZicm9ES0Y4ZmszMnNSRGhubzN4R3hIR29Sa1B0OU9j?=
 =?utf-8?B?QVYyWDIxRURMbnFZSUVNYWszSWphNlN6cDQ0T1ZxYysyb2ZSZ3MwZlRDQUsy?=
 =?utf-8?B?UWh1R3JiUGxaY1E4RmR2bmpKRXZSVVVDRDN4ditNNEk5WWdIa21tbEV1UmQ2?=
 =?utf-8?B?Vk9SdGRvNTVKOVlZaEtVQVNwWGIzUGh0V0dDQk85OStscktZMEJOcnRzd0JG?=
 =?utf-8?B?czVMQUFUaGpQWURmWlZTOExUQkYvMDRKYXUvbzVtY3M3akNOR1cwZ015Rlp1?=
 =?utf-8?B?NEptV0UvcjZrQk8xQVo0UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjlVSW5xMnNQUnZnd09tS1BXSjQ1Q2RzZXEwcVIyYnF3THQwU3JKRTV0ZzZN?=
 =?utf-8?B?ZU1Jb2JwWFo1WHRRYnNUUS8xaEZCWjZCTDM0aEpGSnMwQzV3TGsvbkJRcUtC?=
 =?utf-8?B?dktjbDVmZlpkb2tYUmorQnRFZVRNdTZJeUlCT3JwbExZc2phVWs4Q1AwQURX?=
 =?utf-8?B?ZCsxY2dWdlYrenFxQjRFWHIvbEpMRVk5NjhGUklDRVc3WjhxbTNGTkNNV3FZ?=
 =?utf-8?B?MlpncExiQmRaQldsa012OXVkRHBoVzlyVDI3S0VyalJkbVovMC8rQ2NMSHd6?=
 =?utf-8?B?ckdRbUFQUkNmZGZYNUhON2loZnFremlqUDJhV3hXM0xlQWVwblUybUhsejRi?=
 =?utf-8?B?SXBMV1NvZndPZ2FNRVZuc2VZSm83NXQvWmNGMm1jV2JSSkZXdGk3LzQvYjNP?=
 =?utf-8?B?cENzcHovbXlnS3pTQ1VjMldlejgxak0xcjkyRFhNOFZJZmwrbFpIcnpaUVM5?=
 =?utf-8?B?VDFIcU5jUnZYODUxUkptZ2dWVVdTcUhtMi81dThLYmR6dXd2MkJRVnZ4VmVM?=
 =?utf-8?B?Nm5Ca2hKeUlpNGYvMTVwUHMwY2c5WnZGRmNMNGpKZG03NVU4bjlPczBTTzRZ?=
 =?utf-8?B?cStYSHRwRFdUOXp3eTBpVFdzUDJqazRLUHhNL21JZzh4NFlFZXBodWN1dnkw?=
 =?utf-8?B?S2N4V2UzeHRWUGNGSTZ3ejVveTJUYURvNUxpcXY1OVNQQmZzSk9hYjNMMFZJ?=
 =?utf-8?B?cktFZkVLa2dneUR5dGNqK2R3RGxCQTNFTHBLZnQrejJFRXF3dGRDU3dGOWUx?=
 =?utf-8?B?U202UmVVdkFqL1NNYk9PRkZkcjdjd05BSjg1ZUNTRDZ3SnY0Q2ZVeENhY0o3?=
 =?utf-8?B?VCtkaWJ2WFFUd0pRQ1RxSHd4RHBrZm9kWU5rdDJTd1AzZHNtNzJrWjJvRHpC?=
 =?utf-8?B?V0JIK3hZVVd2MDRnSDFSSTlra053Sm1McTIwVnRBamJJRjB1VVNSZHZrZS9a?=
 =?utf-8?B?QVoyQ2dra0ovSDY0RU0vMTRuT2pCQUxHZU9obVJvcGZXSWc0emRkZHlQTk1H?=
 =?utf-8?B?RFhmeGFuWkU1cGVTejhIWVlQcVJsenN1c0hGOVVhcnJaNnJZclROd1pOSmNW?=
 =?utf-8?B?UnJ4cWtoWG41ZG1KR1dLb29kS2pPS1hReWJJenBmcm5BdXJaVlB6NldlVjht?=
 =?utf-8?B?bXBrNUhKUWVHdFpPRFpmS05HR2FzamZQeXRSUDE5QW1pTUFsWlBTWkRZNm9Y?=
 =?utf-8?B?d3RGSW9sZWpQSHJnczJVTXp3Vld2R3VhWHNMR0F0V2tUWnJrNldxWU9RdG9o?=
 =?utf-8?B?M0ErS0hpUVdicEpRN3hrMGFReDk5eWU1NWlZUTBqNzBVZWU5TVJsSE9hNlNM?=
 =?utf-8?B?SEx6S3h6T3Fhck5OUWdZcHhOSkt6QXVRdFVFSUQ1UTZMVkNnbysrdVQrVThV?=
 =?utf-8?B?VzF5aFY1TG9oekd5SzIwcjJEdnlJUDNlbVFyUjlkSlJuL3ZsZDV5WDRzRkxi?=
 =?utf-8?B?Y3dFS0pqWGg5b1d3UTYvZTBxUjlqQlp2d3hkL2JOVVpXSkowTkJCY01IR1NQ?=
 =?utf-8?B?Nkl4QXg2ckVIVXptOWwzT1VyMUp3bjdKeVNhNzBUUFlMd2c2Y0VuSDV2Z3gw?=
 =?utf-8?B?TStSbHdSdUkvLzR2VHhNcS9VM2xpZWdzK1VIV1RmTGdmQUM3blM0VVE0NWdi?=
 =?utf-8?B?c0kvZVQ5WTlleW9XMlN1VWhocU81Wit4dTZIQ1pRUHc0TG1WcERWdmhHaC9a?=
 =?utf-8?B?SlFRT25EdUw2akFwSEFMenFMcVJHejdrcG51S0hKRHZDbDNZYkdBOGs3MHJl?=
 =?utf-8?B?c2tVd0RzVVFmcTRUU2FvSHJiaUgweUhucDJCTStQRXNaNFZnOERGWHRmdm1x?=
 =?utf-8?B?Q2lmek5NQWIySjkrV1dxc0xWUFNHMHNJVU13V1FKRXpEa0Z6bUZzVitURjNo?=
 =?utf-8?B?ZVJLN2hWb0c4RzhJbi9NZjRBQmYrSWpOSHk2OEgraUdRQVNlWGhOQ0pqSCtu?=
 =?utf-8?B?N3l5QVdMNXBiSDVmTGxiWjhZZ0xkRVlKdTh1NFFRMGlMMDA1THNVcGltT1V4?=
 =?utf-8?B?OTZIOEhyNGpsM08yWHZoeitRZTBuZGZMVFFvS3dWTWVNNEJwbE9LRWNTUkpE?=
 =?utf-8?B?b2dTbHBrdFRPQS9ZU29meTl5MUNkNEpqbzMrTHNKK3UzYlFCSUhTSU1uNlFw?=
 =?utf-8?Q?fe6ROdgE8QgtdiNpi9PXOjKPg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970fe82d-5e98-47ca-a928-08dcbc6702db
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 13:42:59.7432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vk+UQMDq1nGkopwWXriG0SNHYqsNa2ZfjmwdUIoRWxBF+SNhfoRR3ZkUL2c2bsIu0VAVxUJhX3I3TFnahgcsbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6937

On 8/14/24 03:31, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> "INVALID" is misspelt in "SEV_RET_INAVLID_CONFIG". Since this is part of
> the UAPI, keep the current definition and add a new one with the fix.
> 
> Fix-suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Amit Shah <amit.shah@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  include/uapi/linux/psp-sev.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 2289b7c76c59..832c15d9155b 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -51,6 +51,7 @@ typedef enum {
>  	SEV_RET_INVALID_PLATFORM_STATE,
>  	SEV_RET_INVALID_GUEST_STATE,
>  	SEV_RET_INAVLID_CONFIG,
> +	SEV_RET_INVALID_CONFIG = SEV_RET_INAVLID_CONFIG,
>  	SEV_RET_INVALID_LEN,
>  	SEV_RET_ALREADY_OWNED,
>  	SEV_RET_INVALID_CERTIFICATE,

