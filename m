Return-Path: <kvm+bounces-34702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA9EA04964
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:41:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 515DC3A3A3F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601CC1F37BE;
	Tue,  7 Jan 2025 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iCfqTyZB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6A2190052;
	Tue,  7 Jan 2025 18:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275262; cv=fail; b=icHqNm8q+zJDJE5Z3IuGgs3jRmgcd967X3pgHjO4DqeMPjYH2cvgAhn2JdFKrldYg7+/9+FR2UElrA6JfUiAUpVv17FfNsCGfaIZrEHtvWeTlYoO7llmV/Tcoszp5PseRxFRI8ef894jwAER32296MwHwstIy7J6ugBSZpZJY7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275262; c=relaxed/simple;
	bh=iUiGpTreYfjNvXXRZFpN9b34/x+Ddv4+qcKkmaJbGl0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QWNWJGsFSw+r+rpsfK5j46CrNpXqG5DSwnotgC0P0bWFE12/0iZGNuP6gP3MxzrD6UmwmM4gQQS6aFBYEnMW3T+IySse3n1r0MKu4KD/AeVpg8VLiDhMCPE+JUYoYqisVwVeBgpB9rZQj9jJukpb0An6HWjBkB+nK/OgFkyyeBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iCfqTyZB; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8jFkRq5vp9xqECmFVWbd5K9RV7L6NZ3FlxeNAdgkSkpX7VOLPVwktj4HbgqRHKhvqoXVTjBGSTuD+HbfOk/AXDZ4F9oFzE2HbW0C4oyN6Vqo+M9dO3A+9ocKOMkLeCij6rNEZXN0YWVkqH7XAFVCmbY6cdc4qRxCvZl3BPi1Qkb7FXKjz/Qc9oF/95NS+yjHlxWBujhsRhkjOHONKsQrxaeeyaxIgAYtrQHRii4ZjN8mPe+ppdcsQSvXGJhlLBZMmC/H0PT1C9TdO/RZZS+zGJb3bieXyT6EPCDxjyGpEy3cb04KDbs1NNmbx0Yuqyqowpm7p3UyFwALamO76POZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZImwH+O7xwPv4fRy8w75Bp0R69ohK4mNSqLFlF+8uYE=;
 b=rHnHqH3EqKzhLhybHcnJvFruCRgqzjZ9zXl3RZGNHcbHFW6542L7c7Dep0AFuBcc/mji5xAlwkxiDkVE0Mnuo1T3kvkpDC7bCtjI9QXNb2uviIvOUtH5Gn6M2c/maTBXDONs3Uoie9/7cIhEkldRdvQ5Y2QPDv1PWD8iwJFBw0hOWiOFS6Ik1F/FP6C2Nryrm2agIU/NxHMJ4cLju/i07egD5pwTZoRx1jj6Vnl5drt2aT4kiPluLq2yVx/CgoGFP4eRhujb4KEUDb2Dc66mS5pIi8gHJQjeTK7cA0aWU6uYoRh5VLu3JdseHh2oW2yS+MaAX6KptFFjVbPDl6x/WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZImwH+O7xwPv4fRy8w75Bp0R69ohK4mNSqLFlF+8uYE=;
 b=iCfqTyZBoob223jbdCilcFaLnhHxORyYWTR94kxvrpAPNnv1qzURydAlExHpCZyS2WWGerhPPZMrGQxj5Mz8NKreZnvjRua8VOcyxW1HJmOUiUVYzP2r/sxx/kbaeUwTQxZNEl9xYSq0aaIODU96BLbfpfdfokKIdFBUxJwVvSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CYYPR12MB8964.namprd12.prod.outlook.com (2603:10b6:930:bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 18:40:57 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8335.010; Tue, 7 Jan 2025
 18:40:57 +0000
Message-ID: <c5be0341-7d87-8a18-6d17-ee2b0e1bc976@amd.com>
Date: Tue, 7 Jan 2025 12:40:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v16 02/13] virt: sev-guest: Replace GFP_KERNEL_ACCOUNT
 with GFP_KERNEL
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org
Cc: kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-3-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250106124633.1418972-3-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CYYPR12MB8964:EE_
X-MS-Office365-Filtering-Correlation-Id: 66c628e3-9806-464c-5092-08dd2f4ad2e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TXJzVW0rS3NCbDlNZ3hieWNZUW1DOFgvVEFtTFZ3dTZKcTg5UlNQd01TYWtn?=
 =?utf-8?B?d3hyRGxQbDN0eTV5ZTF6MXA1MmcxdkhjUG45dWZsTWNvSyt6cHQwNHR5VEJa?=
 =?utf-8?B?SFQ1WDJrd2VnTlF1b0V4VVJpaVh5RDQwdHFIZmhlY1dlS3hJUXVHMkxzWXdZ?=
 =?utf-8?B?a0pmZFIxVmRNRTVUVkVmM3pYeWVQSGkvc2daUUxSYlhndEl4dVA0ZEpzYlJB?=
 =?utf-8?B?aERKR1RzSllRQ2hoWmQ0Uk1rcnYweDF3YWw1M0xWU0hzOGVON0RXSUVva2px?=
 =?utf-8?B?SHpoSXVkRFlPdExBRGprR0N2VTB1MktHYzZUcXY5KzlnUlFQRVU2MC94c3Nl?=
 =?utf-8?B?Q1NMVVk4SEEvdm13SHBacWs3SEM2emhKZHovWEJmR3NqTzZtN1VpdjA4TktJ?=
 =?utf-8?B?YkZ5alMzbERyVWZSU2o0RzA3VW5USDVTeVRTSXdoM0oxTzh1MGljVWwxZE91?=
 =?utf-8?B?ak5MV0xRdytpM1QxRHc1dGRsL1MvMUZQYU1qY0ZuTHhsN1NINDlrUnFTRW9Q?=
 =?utf-8?B?ZnZtR0UrWUpsZlhWdURtSnhCTnNOQ2MzcmxnRGVseUxMajgyL084ekNxa0RW?=
 =?utf-8?B?Ni9yNDNhcERJNmErZm9NTjdNMjBiUUxUTXFtczU1bmFaL3F1SndMVlIrMTdG?=
 =?utf-8?B?MTVUV2Z5Q0JoQWQyS09NMTdHSmZ6aUlBSm5kRktjVVpxNjk5cUtMNWh3Qkxm?=
 =?utf-8?B?eHlFMC9Pc2czYlIyc1h6ODVCYkxQNkVidnd6TW5TakZYcURzRzhibzAwUDJN?=
 =?utf-8?B?WXJodHNEODFxSEp2SG5KQnp2WStienYySmk2VlZQOE45VDYzZ3BQU0wwbFJl?=
 =?utf-8?B?K01VaFdkUlJWR3NEa0Q5dGo1QjluN0VkaStUdG96Ky92MmxySHZLM1ZQbGRO?=
 =?utf-8?B?U1d1UC9CbDF2bWZhSVVveVFmMWVpMTAwVTJTamhzY0c5SHZqWUpIMzkvMk05?=
 =?utf-8?B?YkNEOTliSFQrS05FcUhuOWx0bzNmQncvWGs4eG52WEI4MWxwcUcxeGtYZFFX?=
 =?utf-8?B?M2JjSVI5Vkpzemc5N0wvVWJ2bjRybVpwTGgvbHlGbGdkdEpWZ3BwOXhnSS9t?=
 =?utf-8?B?T0FTNGxvQ0F3bWxjSkhDdHZkY1ZGb3VDUzlRTUpPZmNyMGltMDJxbDJnTWw2?=
 =?utf-8?B?clU2NjlkZy9JdURFRE94R2xGOWMxWFovemQrc3lrNUxZZm11Z3Y4MjVySzBJ?=
 =?utf-8?B?b1BuTDZTQnhkcTVuM2ZNYk9TQ0VCU09sU1N4MlJRMVh0dVkwSG1nWlpSN3Z5?=
 =?utf-8?B?dG03azZBMjhTWDJZSGxTNW1NRk43YUJvODRFRU9XUUJvdkNheCtVb1FJaFha?=
 =?utf-8?B?SW1UWFF5bUQ5TGZybFBzQ3ZSb2x3NGhXaWlNU0R2ZEVJVDZKWTNwa0drNVkv?=
 =?utf-8?B?YjdsYVFBS2ZveGdZOGJxeDBJdEcwT0dVQmlwbURiaUErUlFBNURheUVEUzhT?=
 =?utf-8?B?V0FuWXE3V2NaK2V3bDcvR2tKc1JzeDlpZHdXT2ttR2xxWjYrTExHYkQzNXFQ?=
 =?utf-8?B?Rk84WklGL2ExUHZtNEVGTmJsR0dsVnhMdi9sOUx1dEhlVWhhK2RtSmY2ZVVJ?=
 =?utf-8?B?eFNUYS84TWNndUk3ZEQ0T2VSN2xHWGF0SDRNeFI0ZGZaVFo0WEVpbUt1eThm?=
 =?utf-8?B?OHg2L3pZL2gvUU8zaXdOS2lnSTB0KytLTDBXQjdpc2RTR1NPOHM5cFR3dmJG?=
 =?utf-8?B?ZmhtQklxTlhUMjlrSDBrK1lrY0hXVDZ5RFBZMFpHQWFDVU90MThiZG1SaXpQ?=
 =?utf-8?B?NDR4d0J1ZWJEUW40bHpMY0tkWnU5RWh3cG1pcno3UDlLMDVpMVpFSFNxUmN2?=
 =?utf-8?B?bEJjZG9BV2lodEhKRk02Wmh2czVDcHIwN1lIajZYMGJCc1hUMEZQdnVHSEdm?=
 =?utf-8?Q?foHIChEA5ssCo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1ZiL2p1Z2ZqRENDVUtMYVo3cUEvRG1MOU5vRGJIVVFZaFRxVGtLQ2xQQnBU?=
 =?utf-8?B?SjZDelV0M05VSmNoQWZWM1RyRW82Z2xBWCtjUS92SkdKMTRzODZ2ZFFkN01L?=
 =?utf-8?B?bWZLeTAwNHZLdHQ5cHdwR1FVNUJzRWhlTnp5N2Z3Yjc0UDBIa1JHdVkwZklY?=
 =?utf-8?B?S1RidE95Q3Q4amNXVXpKbU8rOVlYWVQ0OVFtWEZRbkNvV25Za2RSZmZvK3RR?=
 =?utf-8?B?WUpqYkk5S0FhSTIzYnpiNXlqRWZ2bnp6dlZjcmErV01PK2xOQ0dBdkVvV1d3?=
 =?utf-8?B?bkRpRW9veXczQzZGNjBCc3F0UzBsbXhSa0o0dHlFUTFkcVlkNzhzVUttTnhx?=
 =?utf-8?B?aEFkVkdSREJDSHFwR3haay81UnRSVFJlR2FGZEhwTEtBOHNRenB1ZlQyMGFy?=
 =?utf-8?B?S0xMckF1VmtvVjVBS1VJNmtjcEc3Q2pzWjh5ZWVKVU4yNFFWZnRqbkR5dEM0?=
 =?utf-8?B?SkIrdFVzR2dQbGhieEpubzJDU0VQS052T0VkZWhjbysxdnppYVJ4NzArK01l?=
 =?utf-8?B?MzFPdFBlbHgyL2kzMFJocUsxLzhIYUphbU9INGZHM0pJQkk5M0h4UnF2Rm10?=
 =?utf-8?B?UVZDYXVLaU1DR1pxaU9wZFl3N2prbjJ0K0dXMHdpNVRVMTdvSFJENEs2dDV6?=
 =?utf-8?B?ZGxjMUxaTnRWek5pWmlTNGYvZWxNcFhWZTdYN3dXUU5hdDhpa1hJTW44WmIw?=
 =?utf-8?B?dHhpUG43Y21ldjF1cFZoVXB5WkxjczhUQnNlKzFDMTZLWUtDVkV3ZjMxR0RF?=
 =?utf-8?B?alM2QjgrTHM2dk4wSWFjZnpGeDJuS3pwSnhEU3FMTWpKUjVUUCs5T1hHOSs2?=
 =?utf-8?B?N2JMM2g0YkFuN3UzZitzdm9YM00zQmF4alZMTUJXaGROY3YrRE1SaGJQTVdu?=
 =?utf-8?B?bHNFT3h6VFJYQlE4QnFiRStSbFNJZXlQaFdzeVgzZzJIVXFLYzBSWHQyQzZr?=
 =?utf-8?B?aTFsTG9vdjRSd2J6UWRWbjNKM25KOUNDN3A0MUthVU1reTI4QzlvbFJRZWFh?=
 =?utf-8?B?RkM2RUxiQ1J5SVZlS2FiZ3R5ck1NQ3d3Q1BqNjJKM0h2M2ZNTlJ4MGQxWkhP?=
 =?utf-8?B?QjhOY2kyY01RSmlFV2Mwc1hXTmFaSjg2ZVVVaXpncVVGUkUzQ0F1Vk5hWHl0?=
 =?utf-8?B?NXc0TThzWWlGNXd3ZnEzTGdSTXB1LzA1NCttR0RUN001K3UyN3RVUTd0bkpT?=
 =?utf-8?B?ZFdidHhqckNoRENpYlpCK1hrY0hIZVNUUGxiUXpHL3BlRkM4YlpoZ3hyRDZU?=
 =?utf-8?B?QmEzYUxNNVZ5VDZ3K2tDejNUYTJkTXBnRVZVcENpcEJUc3pYOEd6bzhQaXV2?=
 =?utf-8?B?Q0hyZnN2OG9DK0ZtczFrNElzbmEwU3UrWk9admtCeXhuUWQ5M0VmZ3UrRjhD?=
 =?utf-8?B?cnBBYjhxRk9tcUw5ZmczWUNpcnE2WmpLbDR4aEY0R0pUWldsWmZsSDZtaGdh?=
 =?utf-8?B?cVZMN1FIaGhUWWxMM2lMYkRnSXkzLzFOb2lPdTAvNm43TlEwR3BMNGxxUXRq?=
 =?utf-8?B?cHkrRmtRdTJoSWR4bkVGU2x2UkNIeGZKNFIwL1A0Y1o3NkRkMVU3ZXdqWUFx?=
 =?utf-8?B?VlcxYnI5b1l6NFZqRVdScWpINERsTTNGYTVkV1E5ejdiYkxVM1o0ZW1MMW1R?=
 =?utf-8?B?dGVDVW4zOW0wejFreVdEY0d2WXVFMFlnSEtUS3BUdzFEVzdrRERLN1hWK0dm?=
 =?utf-8?B?bGJkKzRoNGFrR1pJVFpCN2xQclBSZnFwblZLRUtzYnhsRkZmWlhOUXNVeUNS?=
 =?utf-8?B?UHNXNnQxZmkrbTB3RU1wSHRlNHF6QUpaM3htZ2tkbjMzUEdXZlhpbWNJdFU0?=
 =?utf-8?B?NkQvT1dtZDZOcE51dUxrc3BvdGgwT1hOZlRseFp6dDlKaGl2aXU2aHJHZmsy?=
 =?utf-8?B?VU1ZK2wwZDhSbHQrejFlMXJtdzBIb2NRVHVmMDhuRjdyMU5RLzZmUU5zU1Fr?=
 =?utf-8?B?cUJQQmRjV0lhbkJiajh0T3pIOGdwSE1EVzdOVGdCa0dNemJWOVNqQjdEcWl0?=
 =?utf-8?B?MTQ0bEQ3cWV3OW1oSnpkYTI5MzJSNm8vVG00cThpOXBaQ2U1bFNmSHdZdmdt?=
 =?utf-8?B?andRSHZ4Z1A2YjNGWXcxL2hWZHIyOUZxejNFOEJjZ0YrcFRXTVh3TjVqNXg5?=
 =?utf-8?Q?ANxDqw6xW9ZwgBQjLYgGU9bFV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c628e3-9806-464c-5092-08dd2f4ad2e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 18:40:57.0064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whEWhPQ7O5ENcxS2FuRVi/0EJlbjd+zNZfNhaM7QsbTGBkPJ8dqTJrPe+4iz0pJaGi0kGZQc6cCK8ZwTNhcQ2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8964

On 1/6/25 06:46, Nikunj A Dadhania wrote:
> Replace GFP_KERNEL_ACCOUNT with GFP_KERNEL in the sev-guest driver code.
> GFP_KERNEL_ACCOUNT is typically used for accounting untrusted userspace
> allocations. After auditing the sev-guest code, the following changes are
> necessary:
> 
>   * snp_init_crypto(): Use GFP_KERNEL as this is a trusted device probe
>     path.
> 
> Retain GFP_KERNEL_ACCOUNT in the following cases for robustness and
> specific path requirements:
> 
>   * alloc_shared_pages(): Although all allocations are limited, retain
>     GFP_KERNEL_ACCOUNT for future robustness.
> 
>   * get_report() and get_ext_report(): These functions are on the unlocked
>     ioctl path and should continue using GFP_KERNEL_ACCOUNT.
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 62328d0b2cb6..250ce92d816b 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -141,7 +141,7 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
>  {
>  	struct aesgcm_ctx *ctx;
>  
> -	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>  	if (!ctx)
>  		return NULL;
>  

