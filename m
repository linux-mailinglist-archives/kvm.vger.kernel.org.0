Return-Path: <kvm+bounces-24852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8324295BF88
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 22:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A55EF1C22AB9
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 20:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021941D0DEC;
	Thu, 22 Aug 2024 20:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q+R/Poz9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACAF1CF2BA;
	Thu, 22 Aug 2024 20:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724358560; cv=fail; b=JaSgzY4M3QHlInDI6cO4N9S/4tzpSqegL3O56M8S2CBCRn5SHdxRRqkpU706+2/sYvZC8ujX5HN7YJdbN7oAIxmVc4Qev8ZP46mc4xRB9+pGdxPbrFusDEIkDR3vfKPs0ESGfygIwnbUx5ql7+1kXJKFKgbj7/YD9Gb8smjYb00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724358560; c=relaxed/simple;
	bh=H3LL8qZzmfncy05LbVz9e+9kMngQX65T5l7L+KKzDq8=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=Ki9NEMcaMSV0/giER5umcaDS005GtmbNA1akVrO++9l2A4stdAzOY3QWQsAwQxQmDL4qunLaP0/nfG6Yqh9Qnt6lzuoUJhS3hyIoTI76Pm30suPXehyr9IVVHowm7TTh0EQAXMv42K9CquOaBUQRBa6cTfverypwXtPNDSLX1Gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q+R/Poz9; arc=fail smtp.client-ip=40.107.244.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wGCLthtExcvzmHyv0E7kdJdEvi5KyvOCk8POMHi1N/dq3w6hAMnS2vQtQ4qECaj0VccSkHWulJ/al7mVXvpuGOm5PrgcXUlJuHbE1RIkYV8C/3xcTwLGvzwtXd1OaE6YLcwViZrmhyFsrOI3aAPBpmfWDkgXo5r3Y77X5FEZr4L9PVaZSAigkY1huVkdP52RyBP0m0EBCnvh97e4DIht8zYgtJQvLacxUHzLr6LYByGPxdWebwOmiMW93+d2byuSGilJEPgXKECZjsZWZvbIYxAF7ngH0Pm/IlmvDW5UjM1iCuIczXAQIi8iKZiygXkF0tcCnunkBHY74iPxkaXwHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKywJifSEjykeWhvHvauwDShtu8EhhPhEf2jiVGVo/M=;
 b=uLsQVztkGyz5iJ6pfWVRwaOLYI/lUpDH9WQ7KENZEeqrAvSEgtPMxFzQ+N6/DPAjgsE69LgzgSZ6jTboTROeyx9dpCtfvzaUW/XKPYfvXHvUsrYo4ea/kJm6fnfy9PdKSSZQDskRM624OFKrYoVHNZidJ4CSYvp/ai712D/EMAaG+cR1rkXJ88v0ONMp4IGWiK0q6ggCGMIBK9Rg9j9UhTW1a4ZKpGXYGkU7WPuuAz7GfZFIlGVq1ntVE/l6icMkdT/ESGAFQS3uA7XOmuKuURGH9ABRdoZab8y9FS4ZknI+FmFIFQBdi3q/7R3dYDVd1/A21pzAoZFhsk+f/Erzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKywJifSEjykeWhvHvauwDShtu8EhhPhEf2jiVGVo/M=;
 b=Q+R/Poz9hdVaqHJCPq4aWU6FknxQ80B4Orp4fUEvIIjrdCQ15V6gj7MVUZdlMo/QxE0JbENYMLsNr+fM0xLC0jxWx+Ti7LkahWB+2ybl+BGwoV1y6RR0Tt39kgIOeK3Edyif5gkAey7oTmqWwHIMK+ulNU6j7s0gDkW6a2KJ8wk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB6553.namprd12.prod.outlook.com (2603:10b6:208:3a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Thu, 22 Aug
 2024 20:29:13 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 20:29:13 +0000
Message-ID: <cc9b9df6-583a-d185-0c32-6d26d0717548@amd.com>
Date: Thu, 22 Aug 2024 15:29:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20240719235107.3023592-1-seanjc@google.com>
 <20240719235107.3023592-4-seanjc@google.com> <ZseG8eQKADDBbat7@google.com>
 <2f712d90-a22c-42f0-54cc-797706953d2d@amd.com> <ZseUelAyEXQEoxG_@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 03/10] KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for
 AMD (x2AVIC)
In-Reply-To: <ZseUelAyEXQEoxG_@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0058.namprd05.prod.outlook.com
 (2603:10b6:803:41::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB6553:EE_
X-MS-Office365-Filtering-Correlation-Id: 93846b77-240f-47af-fa4f-08dcc2e91640
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEdwN3Y3SUxEQVRqZkZGYnd0M2tmNXBNWGlMR1FDNm1hbnBTclpnQlFGUFpC?=
 =?utf-8?B?b1V2VmhWblFMODJXUWpPWldadGRSTm14bTR1ZkUrV2hqS2FsYUJsTCtvS0dl?=
 =?utf-8?B?UzlBeE9sVlpRUjNtSnVrSk1oNlFOTmFzSTRRZXBJclBKVlV0TTgvZURmZ0FG?=
 =?utf-8?B?UkJCeHpCc0Frd1FaekVHelUrL0NIUDF1RnNaYWxaeEVvSVNmekZ6eWNkb1dN?=
 =?utf-8?B?bWtrOS9uNTZ0SzM4UWNpQlRKTnA1SmhtNndNT1JiencxWTZNZFZJQjVHRS9t?=
 =?utf-8?B?SVlSWlVaQWxHOWxNWmQ0MjdQRnJSUHRjaC9tNUZ6bERLbUo3cVpqUk5ydVRX?=
 =?utf-8?B?SHh2R1ZxVkhPUXJsdy9XTmFsQS9YYnF0ZHBtQytyRm1YMlkrazVMeEx6eG1W?=
 =?utf-8?B?RG9qNWpXM1owNlZPNzk1Q3JEaWFFeTNzUFJ0ZVRxZWY0OFkySldmajRUbHc5?=
 =?utf-8?B?RlU3RTRQYkxJSHpEKzluR29tTGNWNEE4QWtQRnhFcFBsUWNqMlJOVDBsZTM3?=
 =?utf-8?B?WWxwRjhlK3ByTzFXei9zTXBUb0pkWU9SZEdac1dQQlVnUkJESUU2bDFWUGtS?=
 =?utf-8?B?bVI2cmZpb3kvVFdzYUprOHdPZTBOVzBWdWhBMWVxZEZZZVNVT25jeWcwcEpT?=
 =?utf-8?B?R3MvWW5VQ0NqdjFlcmY4Y1ZEWWZCVGtFQ1BsTEJCRUxUMU92YnVxb0RhVHVG?=
 =?utf-8?B?S1VZUlM1aEUvbE9XNmdZZW9HMTRlVlA2eHBPQjBtRVF6M21wbmVtcVVGUURX?=
 =?utf-8?B?VTAvNzM3dUNvZi9IY1VCQS9wUEV2WmR3NGdCYy80RE5XQzhtNFlPelRWNnJJ?=
 =?utf-8?B?dWRma0pFS3g3UzR1clV0N21xejE0cEJHbW1iZ09hTFVUcXRlZld2L0Nub3k5?=
 =?utf-8?B?SnJxWDc3RVVCaGJOZzkxbHJSNzQ2QlVCMXYrSTh2SHZqUCtIOXhiZWNUUkM3?=
 =?utf-8?B?RG0zNGRGTy9tSFNxVDBSVFY1clgvaWhjdi8rOXJYcGJzVDUrQlR6K3k2QUJw?=
 =?utf-8?B?bXNDZjV5VVEyaHZCZkVHRkw5NnNMZ1paWlVybVUraGsyN3YwTlp2bE9LNDIz?=
 =?utf-8?B?QU03M3V4K3Q5c1daQmdCaEdNcTVicDVZTWtrY1lWbkxxcWhRRnZLa0pTVzZI?=
 =?utf-8?B?Sms1ckVjRjgwMUoyRnp2RVJ2a0JQR21sYk4zMmtKUWtXbkV4cGUyU1JDSUFD?=
 =?utf-8?B?VzZkQ1Y2V2pxKzRsblhsQlYzSVFaZ1Z0M3drSytmeElzL1MzQzdZV2pXd3U1?=
 =?utf-8?B?c0VkTVBNbFNZK3o2bHVMOHFySWpINitFaGNQUkZTL3FnblQ0OW5CNXU0cE8z?=
 =?utf-8?B?RXhpdllaQ0kvODIvUHY4WjUzYlF3NUliYmRNdU0zTWYySEZsV05nNUdUUWNS?=
 =?utf-8?B?L3BacDJlRzVtTXJEMThnZUdPSUpXRE9ydE5ZTmJnRnErUWRjaytWbFY3VDBK?=
 =?utf-8?B?ZTBQdFQvVXpTWXpTeStWOThFbVdKenZib0xyQTNlLzNQdFFkbDNnbjQya2lZ?=
 =?utf-8?B?UUcvaHpZTWNtdGVvRVo0dWF2c3pKdFVvVkVzTGVId2JpWmdKbUZtK1l2YVBm?=
 =?utf-8?B?NW1uRkRidk5YWEtwN3F1MHIzcGszcVNaYUdSTU5VWnJScEdIazZHODVFbUg5?=
 =?utf-8?B?b1dVbHVXOFZEWEJ6UE92VkpZMVpGcUNudFR1ZWNGVXlhT1o0eDVXU1UvYUYr?=
 =?utf-8?B?aDR4NmtwNHpvQjJVSjQ3MXZMWnBER3Bmb2FCWGNGdHNlOHYrc2VqdmM0Q1Jh?=
 =?utf-8?B?a2Fodm1ZSnB4SEpJa2paWUNZNXhZTldoVEVZK2VKWGhQZWhoa1ZVVTQwaDYy?=
 =?utf-8?B?ZWJxd1JxVFJITjZhMGJhUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHU4MTBIUGJxay9RaVBGNmVKQUNsVXQxRENoOCt4MFd0N2R5KzdEaUlXV1ZM?=
 =?utf-8?B?REpWbmxZc1p6NndFM0xNYTBwd2Z2YTBKcCtPZnB1dittT3Ava3JHUnNUZEVM?=
 =?utf-8?B?U3I4SU52eDN6alhGeCs4a2JjcXNCclVIU1ZXVWd2cmFwTmZoN3ovbXhRSHZ0?=
 =?utf-8?B?a1M1OUtub2c4R0grOGNmOE5qbzdDREduT3lOMEdDNUtiVDJxcjltaWZWdXhL?=
 =?utf-8?B?RitBVEttbzcvQ1ltNEhYVmJhMHBXd3UvOW9lM001UzRod1o3dDkvYkpsUjBt?=
 =?utf-8?B?Um43aU5wV2QxY1NhQWlUdlJCeitqcEpVTUtxWnFLOU5DL0tzMnZLby9uakMy?=
 =?utf-8?B?QW5RdVVHVEZRRVBtL1NBbU84R2ppSnZvV1BqczQwdGRIWk93Z2g3TDAvYWo3?=
 =?utf-8?B?aVN3QmVvSTFkL25VZ3F6UER3ZEk1KzRLdUpJeGRYQWp2TVN1OTRxNURlL0xx?=
 =?utf-8?B?d2dkTGRzVWp5U3Jxd2o0NUh0eC9BMkVCQUh6bjgzRnh2RDhmV3EydXZwelRP?=
 =?utf-8?B?cjRkWk1hc1hKNER4bXlpSlF1RXlreW9PNVE4aHdKT3lWOVZNaUs4VTdocUhQ?=
 =?utf-8?B?MFVoY1gzUjhvS3FXazRKOHlHbVNGbmlHQzhqWFByeWtXaFFNaEl1WXcwSnhG?=
 =?utf-8?B?WGl4b3pFalY3dlhObFhSTzk0YjQvUjBSMlZYTzNwT1JEWEV5azY2dWh5bm40?=
 =?utf-8?B?eC9PU2U0MXpWRlpnc0pGM2VudHZBYm5EYjF6Q0EzR014ZlIvZGVTQWNaT3B4?=
 =?utf-8?B?YWhKOTEyKzlUZ3pncGlUd3Jjb25aeEp4MGdlWUd4SHJPNW1obU16VzUyQkFN?=
 =?utf-8?B?UFVGRjlGcDhzc2h6N3AyeHdHckowNFdoZWVKelZDNHZTTTAzczIzYmttSDBl?=
 =?utf-8?B?S1hpMUhxdmRNZ2tIaWUrc24wdm1kcnZnTFE5R1pVbWRLMk42THRDdUcvM21r?=
 =?utf-8?B?TXI2cGNOaTNEUGNMSU5RM0ZXZHFpbUJJL1BXbWxWUlRvWW5UMzBnY1ZGUW5L?=
 =?utf-8?B?MXdndFdmZ3FaL2JscjJmaGdWTW5iUHB6azRVdThFV25XMnVTUHBhRk9TMis4?=
 =?utf-8?B?Z1hhNjRXb081UW1CWUVCeE4xN3Q4b3JFSkVnbkhERnBGY3h3WUp2SjBzSFhZ?=
 =?utf-8?B?TE0zem95YVJnVzlPUUEwS1RXVUpPYjhOMVJ1dWoybDlEb3JGSSt3Z0IyME96?=
 =?utf-8?B?S1NJeG5vMXhZWGdKSjJJSXhTOGkzb1k2YVpTc0lxUnEwbFpDZktWUWR0Szd1?=
 =?utf-8?B?aTRFalRRM2lQRThSTXFQL05IY0dQUUVtVkxCSjNzUWZoNjlwM0lwRk5GTjRN?=
 =?utf-8?B?TUR2cFpKWG5PWmJ2RlkyREVKS0crRElnOUEyUnZYbVhNakNYS0NLWDY2WGRD?=
 =?utf-8?B?QWxGKzJUNC9qTHllcFZ1NFV3cmo1S3lnUlBpT1c4cTBuY29BRGozdFlJaitq?=
 =?utf-8?B?RlRDRVc2bnFJc3VGZlBHNk53dU9kU1hyMUc3cmdjS0lZYkVpeTR0RE1lZEdT?=
 =?utf-8?B?bVhhQVltaWc4ZzZZcVRnenZTdFk5c0laaGc3b1FENVZhd21zOFJZd3lnVVdD?=
 =?utf-8?B?em9PeEcxZkQ2ZnFoZllrdy90RG9YcGRadktHNktnQ05ib2x2TGxyVHRGcStj?=
 =?utf-8?B?VSs1ZjlWSWQ2eDZva05YNy9YTFplZlJ2WEt4dnVIYXRBV2hvKzRyWmYzdVhI?=
 =?utf-8?B?UGR5T3hxNXNJSGNXWDlDMlBrVUhEd3JFWUxlWnJBcCt5dVNBUi8wTnZ1U1di?=
 =?utf-8?B?VkFUdWQxeDg4KzluWXM3TUt4ZVhDNVZQOXQ4VEMrUHltaFppdUFzRENWaDMv?=
 =?utf-8?B?YkNnemNIUlR6aHJpZ2dtWkRETkVxU0N5MkNNRmFFREF1RmxhcnNyMUNVd2xF?=
 =?utf-8?B?aHFZUS9zUUorSEdUbmU4cG5Jd0FmZUdQR2RJZmp5UkFQN3h6eFpxbWFweXY2?=
 =?utf-8?B?VkxOb0JJQ2JvdTVUenNmc2RhVnBSemJ6ejZSQmFsbWhjU2Rmb08vODNybFpC?=
 =?utf-8?B?THJsbVNYbitsMW5GZkJCb1RJeTZybGhaTXFmdTZrZHk0STY3Y3NkWm5jUGtw?=
 =?utf-8?B?c2k5eVNxRGtaRUIzeDlTcCt0a3pSVEw5S0xBdTdXc0tjQnFWam53MWlFRzNp?=
 =?utf-8?Q?0v0+5Ky33JeuXW9gyA6DivJ0n?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93846b77-240f-47af-fa4f-08dcc2e91640
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 20:29:13.7581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMqJTgp0PA9U6ToZuFPb/1HUOQt95yUDz74dHmqSbIoC1a25A2QSMnHBPqh+PLHxgJMYx6+l0NKx8BGOplOWaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6553

On 8/22/24 14:41, Sean Christopherson wrote:
> On Thu, Aug 22, 2024, Tom Lendacky wrote:
>> On 8/22/24 13:44, Sean Christopherson wrote:
>>> +Tom
>>>
>>> Can someone from AMD confirm that this is indeed the behavior, and that for AMD
>>> CPUs, it's the architectural behavior?
>>
>> In section "16.11 Accessing x2APIC Register" of APM Vol 2, there is this
>> statement:
>>
>> "For 64-bit x2APIC registers, the high-order bits (bits 63:32) are
>> mapped to EDX[31:0]"
>>
>> and in section "16.11.1 x2APIC Register Address Space" of APM Vol 2,
>> there is this statement:
>>
>> "The two 32-bit Interrupt Command Registers in APIC mode (MMIO offsets
>> 300h and 310h) are merged into a single 64-bit x2APIC register at MSR
>> address 830h."
>>
>> So I believe this isn't necessary. @Suravee, agree?
>>
>> Are you seeing a bug related to this?
> 
> Yep.  With APICv and x2APIC enabled, Intel CPUs use a single 64-bit value at
> offset 300h for the backing storage.  This is what KVM currently implements,
> e.g. when pulling state out of the vAPIC page for migration, and when emulating
> a RDMSR(ICR).
> 
> With AVIC and x2APIC (a.k.a. x2AVIC enabled), Genoa uses the legacy MMIO offsets
> for storage, at least AFAICT.  I.e. the single MSR at 830h is split into separate
> 32-bit values at 300h and 310h on WRMSR, and then reconstituted on RDMSR.
> 
> The APM doesn't actually clarify the layout of the backing storage, i.e. doesn't
> explicitly say that the full 64-bit value is stored at 300h.  IIRC, Intel's SDM

Ah, for x2AVIC, yes, you have to do two writes to the backing page. One
at offset 0x300 and one at offset 0x310 (confirmed with the hardware
team). The order shouldn't matter since the guest vCPU isn't running
when you're writing the values, but you should do the IRC High write
first, followed by the ICR Low.

Thanks,
Tom

> doesn't say that either, i.e. KVM's behavior is fully based on throwing noodles
> and seeing what sticks.
> 
> FWIW, AMD's behavior actually makes sense, at it provides a consistent layout
> when switching between xAPIC and x2APIC.  Intel's does too, from the perspective
> of being able to emit single loads/stores.

