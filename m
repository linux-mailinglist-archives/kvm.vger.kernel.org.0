Return-Path: <kvm+bounces-27824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CB798E4BC
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 23:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E9B328529C
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 21:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27EE21731E;
	Wed,  2 Oct 2024 21:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DwEBHCq3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2050.outbound.protection.outlook.com [40.107.95.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A9E196C9C;
	Wed,  2 Oct 2024 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727903887; cv=fail; b=lXCuIDRD/GSnbRka0zc00eIHK5WnM+RQO28WObtTXg1EnYS1jy97xpD9a14h6CF+aEv3RylxB5K4RIk8B1LR6+qBsSVbo0AcoR9fssBoEW4HAmpM+8O68gqk+mG5QnNqOjCNFKcKH6NRmITB+mp3p98BPiXNq3YtRv7ATiV3FNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727903887; c=relaxed/simple;
	bh=SrIFIeAiIx4cd0wZSw1dctIRuK25B8GviODAIDZB6/U=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=j0IlrOxwUUz9RoCSa4at1eTl0TyRFReAkZmrsXKIrDU0zMcXXYj4dBYwBwQ61WfgNWh4f45A69B63IZqAADIvqtym9K7qRVVITKn7pfNAuJFwyf4BREgM+Eiew0wxyxMtgIo/Cu9ZFHukbqvTXa5JDv6p1R6DpIbiTilqPmI4Us=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DwEBHCq3; arc=fail smtp.client-ip=40.107.95.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gDEHl/6dW8a9lOY6jC24SworQfaeVTzy9Quj4fzrSVUfi/4YcpbzHpTQ6Z5b+xDf5YGrmqWF9MOXA2Li8iSbfsfoKWBngBcCOMC5byY//Iaw+sS1c4Abchj4bFT5V/pWIzgqlMjhAYJWRPEcLMrtzugC5aTafiQLz0yihsOc83v2VHRKndjjuemXCafAAq6Hes4ICofp9tgQZNhc2+SqP2EVBVh9bOrLaFEBhKYwNKw//LfHpy7MczZOZjjqMMD1BkxWtdm/nC8LPpYR+ULZUA0IQIkwz6A/5zCsEFwTfzFWrwXjfYOYtwu0GBPUvVwFrD1rJ0IOEbPRmb3hoqTq7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGODypvgvDR5/FMvbEoaq1K8e9hJRrrzr9Nz8HIRS3A=;
 b=d6jUAeBfvJ9867MmOwAcoF9QduXIJuupygv35coJ4i+sxJrnFnRymQbah0Y56N91mKf0Wzc5O86Sc20Ct+GNAxhJ8rmvKBoCT7gp/zRP/btejPjIX6mAiZ2YjEUDX1iAJWRWt192ON26imhWc1FGL6enId9sRKYIPMiOkPxpXO8E3G0mDUvOd7qtPWnegcCiSewuQK/hTkClKzqsagWxFt5sMf4jjkTBwQOEdhL+MmgeoyfFjLvqAiqSH6Sddw012h5MfDe6okAr/eWNnWFjbyvIas3OLL/MtuXOnpQNtQJ6S382HRInBO+mpqOFizHzGFCtWo9/hSjqWqZYAmwIDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGODypvgvDR5/FMvbEoaq1K8e9hJRrrzr9Nz8HIRS3A=;
 b=DwEBHCq3NHK9hervwqDGWoMPUA3taVpnmtnB3Ogm2vICuEpiW+LBRKraQ4GpKCSYRPv8pDw+DQpVRAbENbU25VNEIW7hdvdEIcC5GujrgrcV0PrybWvIhXOE8kTzZAQsruLpPNmoNhico7ouzZrXqoJT3K1cId5DpiMQDbqZhWg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB7670.namprd12.prod.outlook.com (2603:10b6:8:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 21:18:02 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 21:18:02 +0000
Message-ID: <3b2e58da-33da-1b40-2599-e7992e1674c7@amd.com>
Date: Wed, 2 Oct 2024 16:18:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <0f225b9d547694cc473ec14d90d1a821845534c3.1726602374.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/3] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
In-Reply-To: <0f225b9d547694cc473ec14d90d1a821845534c3.1726602374.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0002.namprd21.prod.outlook.com
 (2603:10b6:805:106::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB7670:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f1f1422-72f1-4dd3-8534-08dce327b2f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVlvdUlFV0tLalBPU1JMYUpOTWJieFdQKzYxbHRrT3JvTTFxZHE5Tkk5d1RT?=
 =?utf-8?B?WlJyZmhGRCtUOHJkR01ZU3JvWU52QzM3L0lIbCs1aDRrOGtLQmFCV01zNW00?=
 =?utf-8?B?NDZoUkhsWTNoMW82Nm9mNjA2U2c0cDNBNHdDN2VET1FJZjZ3OGdNMHNhYjNq?=
 =?utf-8?B?dndlc2Z1WjY1RGFkajlnYTRqYjJHQU1jV2JzWFpQTUIyL2xWaTR6OWk5V1FD?=
 =?utf-8?B?V2d0aVNwbUVjK3VId21XWGdMTXRnSjVSOTdSbloyQXNZa3c3am9aRGV0WE9i?=
 =?utf-8?B?VjVTYTdDWXBVT1hObzk5cUszZVprYnVNVkVwQkNUZFk2a2ZSVHBDb3JBTURK?=
 =?utf-8?B?STNKOXUzcEZsR0RzQVZpYWFkS1Q4Tms2QTdSY1VVWDBuaUd5eHVrQ2ZkVkU1?=
 =?utf-8?B?YjlJeDV4Ym53MDMvZ0pORTVvcTJEZjhSdXNzbmNFR3FXTjI4NkRaR3p2eENr?=
 =?utf-8?B?d043aFFWU0RlMVZPSnlBVVEwTXk2ck1melJpbDJxOG1YL3BhWDhDL1l1bDlL?=
 =?utf-8?B?VkUzL2JhZzZDUTdhRWJQNlpUN0c0TERtOFVUc3dGdis0eU9teTErR3IrWG5k?=
 =?utf-8?B?SHNwc0tJb0IyVW9LSTlHeVBzREw2bGo3b1hOdVd3T21ySXNtUkFZMU5HUGpN?=
 =?utf-8?B?M1J5THRCTC9FWnNZVXRndmordW9XcXdTVlZabDR5Qk16aStFd3k3RG1SeUF3?=
 =?utf-8?B?U1Z4UnFlNkc5dXArR2s3S1gwanRnSUJoZTg3QmNLRTkwNDlldElQd2ViSm1z?=
 =?utf-8?B?R2ZFdGdyNWVaZXhYK1N0TnFXU25nTHJCZWNrVHVvZVV5bjc0RTd4QzlUQlB2?=
 =?utf-8?B?YUxtN2ExaVpwWlJ1UWtEUXN3V3RoRlRyMnJ4ektZRExLMjBHdEtzeGlYVENN?=
 =?utf-8?B?dkk1RU1vcWhta25EMVUrYm5ELzVhQm02NVcrS0FyeXcvcG9YKzJwbEdhaHJo?=
 =?utf-8?B?OVd3UmZDNlhNY1F3SW5Vb1c4Y1dObjU0T2ZoSXJuMFgzNTFkcVdvSERlRnpP?=
 =?utf-8?B?Q0k2SVh0STE3RkJyUXlUMWxsWEg2bElaT1RHcldjL0hVWnJ0ZVhLbndRWlhi?=
 =?utf-8?B?bGNVclE5NnQ5SmQ1RWk3RE1qejVVWGpxMnVKNGlubzZramZLQmxLc3IyaWtE?=
 =?utf-8?B?UjdUZHNvS3VmMTZYUW1MdGdGUG5vLzBqeGRrcURnSWU0T1pSd0J3ZGNVeHgv?=
 =?utf-8?B?dlZCMGY1VUJYWSt6cmk4WUdyYVJkbm5CMUZuNnp0cU5GN2kwNFJweUhVMUVK?=
 =?utf-8?B?aE8vUE9SS1EyZFVDaVJZdGUwYUIvMjI3Y2xOc000MUdEVWQwbzlHYmNQblk3?=
 =?utf-8?B?VXA5QXVHZk1mUXJUdHZWTUlLTXdUc0MreEE5aVZtcjBhcUwwTnFrWjZXc0FO?=
 =?utf-8?B?eUZpdUZLbTFVdmtKbG9ZaDRWZ1JPSUFHQ25waHJNWEc1d212SHNwTFh2d3Z6?=
 =?utf-8?B?M2NoS0xraVhTRVlNcVBsSjBpcE40T1VRL3RjZERwaU0rSXdwR2t3VDVYdFZQ?=
 =?utf-8?B?cnJxY3RpcXoyYlBZLzUzVUlPK2NUQkZreG5VMm1kbGlhbGxmVmZZR05wVGYy?=
 =?utf-8?B?Q01zSzIxbWpHcFc3c2l1NjJRZWZFYmFFakxVcGtnWjhhUnVZeHlScEVDUkxo?=
 =?utf-8?B?alpKNkRWRXc1QnV0ZkpVT08zSzhqSDFackg0OW82QlUyUnFEaG9wU0ptTVVG?=
 =?utf-8?B?QkNrRFRkN1BtenQ2VUZCdk0zNjdsekhobHJyTkhScElBcU0zMnBKR3ZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wk9oMEhjOHY0UWV4VU1mZjMzU2d3d3MxV1JUQ1BQV0NKYUtyVjU0NGZNZ0Zj?=
 =?utf-8?B?VkFjRmsrb3Fza214TlJQMG1aaUh6Q2pwU1ZKY256alFTQnpoRmFXM28rUXRa?=
 =?utf-8?B?dFgwTE5IZkw0VzZ5SVo4OW1KcjRBYUNveklBakl4emtLYjFOT3M0MHhhd0pK?=
 =?utf-8?B?ZEhPaDQzVThMZE9BcGFiaDJRNUFDdXU4NHlabHhaeUFJSDVINGpLVDlORXNq?=
 =?utf-8?B?bEJPaTZXZUN3Z1NSc0I4Q1E5RkhPczNsYUpWQzRMMFZiNWZ5TE9HeGtPdWVB?=
 =?utf-8?B?SVBHdXRuVnlCb1FrRWp1OHRwYjBqdkZOL3dzSmxtZkFpcTl2RjY3SG9GRlIw?=
 =?utf-8?B?UFZVN3ppMTBTdUllcy9oV2V5YWdMYU04bFFnWVVNbFVXZXZJSk5UdTIwSndV?=
 =?utf-8?B?cExhcHArTWczWkVweTlKcTBFOCtTc3F1QnhDYXhxMDI1T1luellUSFVhRkdB?=
 =?utf-8?B?bFFRaTBYaTNGVGpjOHZ1WHlpWUViZEVGWlFodzBVVXFwMDl1VDhpVmlmS2tI?=
 =?utf-8?B?Nklra3cyY3NvYUdMUUR4cDFwNytKbmxUaHc4UU93Yms4UnFaZkk3bkhBbHIv?=
 =?utf-8?B?ZkZQY3N5c0l4QUIyYlFEMUo3MEd0R2RheDBTblY2cWo2cFM2T2dZT2ZLS09s?=
 =?utf-8?B?WStmTVoxSGRVWVVKanVpUXRVb3FUZGpINzJMdm5NbXE4bzlmQU12blRmdTBN?=
 =?utf-8?B?VHRVSnRpZEt2My8yMi95eFpMdkIzRGo1K0hZcnNZQXUzSTJSeVZzZmVCUFdo?=
 =?utf-8?B?ZjViV3VlVmRIZmdKcDk4OWFsWVd1ekg2akptNTZndVk3YjVUQ1VDalAvZDI0?=
 =?utf-8?B?MHVOS28vM3FOMjhRbGpwd21sTGpuYm15OXpvVkJjcnQ0dVMyc2krM0hwSE9V?=
 =?utf-8?B?RC9yWlNuYzZIbEMyNDBWUDhFQ0tYTFFaRzJacG1rMGRHZk5jNXBBV2ZoZnlI?=
 =?utf-8?B?WGdWVFFUWWJTVVBuNGEvTnZKUTRsWngrY3JQdFVSelFXS3QyU2dsTWdRVDFQ?=
 =?utf-8?B?T01EY29KRzMxZms1d090cmpJc3BaTlZiYjJlNjhWeFg1cTU5Qkc2QlFINXRK?=
 =?utf-8?B?OWpUNkE4VzJQZGNPL0x2OU1Kekx3dUV4QzQydXBpQ2RXT29BRXdFem1YeEpS?=
 =?utf-8?B?akFFbFo0czNRcU5HVDZ0YjRBTHVIcUYwaTBwU0lhL25MYXBsK25qSDMzTlNr?=
 =?utf-8?B?aDZGWkVQd1FQVmJwT3lNNGF1NmcyeHZadXRjRWtoOU8ybkhzZC9DUDh2c1pC?=
 =?utf-8?B?bWhTU1kySUplS0hHK1dzYW9LdCtmNTduQWVDK21QVG5jUElGcG1FT2ZybFZI?=
 =?utf-8?B?d1VPZ1FZTWxSZ01IK28vRnBVaGZjTEFWYjhVQW5xcmJaM3Njcks2aFJSZ1Ax?=
 =?utf-8?B?M3d1cmllSzNPaG9aLzA1QitsNDBpaW5wSXBSem5LcktBMjhEUzVFd0lPR2da?=
 =?utf-8?B?NEFTQU5tc1VIRTN2QS9Ja2xsS1ppMzJTMFgxREhGMDE1K2I0ZnF2Yi8wZWdv?=
 =?utf-8?B?dVRydE1GWUIwaDNSeFl3bFZWZ0pQeU9nWFpFcm1Qa01Lb0lmZ3NZTEg4QUVn?=
 =?utf-8?B?a2NoR0pqcDlORkxsdWtWVGhlb1NkckgzMlUrWS9FaUF6MDdCV0dYelg4eXNk?=
 =?utf-8?B?SmRFRTdWR3BvZURMZGxyS0loYS85Rks5eGw2MVZLcWU4Sm1uOGFkZzhCSjJo?=
 =?utf-8?B?R1VpOXoyMkVUdjl2RlJtbjFuZzEyUGlISDYyOElWVWc5NDhCcEhscWpWTWVI?=
 =?utf-8?B?ZmpoNVpWa2M0ZFNIQ1hRSlFFakNrSTcvWEthR0Nxd2dlVDRSTi9JeXRFcVg4?=
 =?utf-8?B?clQ2YjBUTmg1bG0vYjBFS2ZtM043WVpEeGgxd2orOVlqLzUzTFNHbXYxV3pS?=
 =?utf-8?B?Wm5jL0pJbzNkK3hJemRQcjlzai96bE5oR09Pak5YbFBJZEVoUXg3WXhyNXpE?=
 =?utf-8?B?bUpwblRvK2F4N0N2Z1hFeFRBTHB2TTV0c0RqZ1QxSi9oTXYxSUFxNWkxWDBv?=
 =?utf-8?B?YlQrVWw3ckRhSTNDVFp3TTdJdGVEOWhVSGVzQloyVjlDdnh1WEJObUluVTNu?=
 =?utf-8?B?dkxZWWZQSllPZVI0emdpM1grYkVnaG1ES2xibnZ4cWM5aFd2Ui92TkhaUS9h?=
 =?utf-8?Q?zfDTH7hXfVnb5fBBzzwPg1ZBW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1f1422-72f1-4dd3-8534-08dce327b2f1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 21:18:02.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QiGvdBdr1TmVLO/pCFocT5BD0NzH1UzKwJ+IbWLf3eSe7aFlvU62Nu1bLF/Qgwzlc0AjmxlDj6FepzmyB7i0lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7670

On 9/17/24 15:16, Ashish Kalra wrote:
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
> index af018afd9cd7..564daf748293 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct snp_feature_info);
>  	default:				return 0;
>  	}
>  
> @@ -1063,6 +1064,50 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
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

This comment is a little confusing relative to the "if" check that is
performed. Add some more detail about what this check is for.

But... would this ever need to be called after SNP_INIT? Would we want
to call this again after, say, a DOWNLOAD_FIRMWARE command?

Thanks,
Tom

> +	 */
> +	if (sev->snp_initialized)
> +		return;
> +
> +	buf.address = __psp_pa(&sev->snp_plat_status);
> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &error);
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
> +		snp_feat_info.length = sizeof(snp_feat_info);
> +		snp_feat_info.ecx_in = 0;
> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
> +
> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, &error);
> +		if (!rc)
> +			sev->feat_info = *feat_info;
> +		kfree(feat_info);
> +	}
> +}
> +
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>  	struct sev_data_range_list *range_list = arg;
> @@ -2415,6 +2460,8 @@ void sev_pci_init(void)
>  			 api_major, api_minor, build,
>  			 sev->api_major, sev->api_minor, sev->build);
>  
> +	snp_get_platform_data();
> +
>  	/* Initialize the platform */
>  	args.probe = true;
>  	rc = sev_platform_init(&args);
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
> index 903ddfea8585..6068a89839e1 100644
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

