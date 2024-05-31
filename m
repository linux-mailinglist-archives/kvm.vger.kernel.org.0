Return-Path: <kvm+bounces-18467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4367C8D5939
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BAB3EB244ED
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9670D57CA2;
	Fri, 31 May 2024 04:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vyetbFSD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2051.outbound.protection.outlook.com [40.107.100.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EDE77117;
	Fri, 31 May 2024 04:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717128422; cv=fail; b=aUfkRmLtheHCHKg8k+Nqa74LUyHMebgVb5NXbKPvKqQHkKk6rDf/IYAX/lu7w7UqgV7ae/fFB05QmgER9/NuA0sYxhXHzPeo1J3eioJbGZWvyeydVNivVEPKmoTfsPq9nfGWSuCzlICnDsjD2WGV/IuzEMR4yiArYafVvtroUdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717128422; c=relaxed/simple;
	bh=GHUG2+gQ24HTlLJuigYVMMCmmEKhPEzcGO2ilCc6I1s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UfkheWQTpk4AJsWvuh+G7dTI8BNy2F9vnEUCMEk5bY0uhwJBiaosKx7DOGf9uZm9JgG9x1Kc46kJS3sazot8W4O3S4cgABkempBvUER/G+1wCSh6/IF1Duq8K2j2Crsqxk+f+P/LKjzQb2o0JPfyA3Ib04ILo8OsnxiGsr/F8rE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vyetbFSD; arc=fail smtp.client-ip=40.107.100.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQ8xBPHSfWrNu+6/w6XyV2D7yl7n8UDbdSkaEQ8WBBCA8z4kntBxpJWXrmwV0Ngdnf7c1vzmPOS+PeutxdCt5aQG3hFlrXABLiiDMmzzHC58Jbz6yno5OdkmGyrTwYu/HFc27mNT72nODtYhbxT+S9lfKyPPwju83MHxfMDtR2Jn2vd8qH9GxC2wN21su3CmnknVGW4knH16+l9t+CEcmewQqPAB0SsP9mWbw6gisJr8N7Gtw6EvBSR8uCOSbZLuAGjIG7sBgIXMoxW54rElCJJ1oYx7NRue/kAC3TwZTiJYHUQSQmtaAGD6yOrIHOhhlGjWMEowHfjwbssFIR2efA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jV/D4vbqymBIs5rXLnuDt1jr3kERDRGJ6ch026eSNk=;
 b=oDN6wWAc0hxfhhacztZfF2jQl8bA6pzAVr249WLAi3bKRYsix2lBMQ7y3Mk3ZwvQsF4HvqxHGaFeQQMEAZade39cyGmsM+laagP3EQeStZVXBgf+f3DpzoSy06M7xakMaUJ0B/y4oAEDEyojelmRLi+aPEm11HJ/BgfH81Bp6s1HQuYChbD7Swx94jyFugTIwADnFFtfxOEd5BvUIr3rwBSnDOYx258fce7KG8esMvzKmLillN8Nio/xw9TPdkO2VkkPlKwBVt2fDcB3FD5nW2dWns//lDvqeCftAWE/JkdLht9WkvPH+3qXPrW/CPvx4WBJI52rOI3JrvkDG9M82w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jV/D4vbqymBIs5rXLnuDt1jr3kERDRGJ6ch026eSNk=;
 b=vyetbFSDtTzalNlXv5+KBlLdurDC1c6u+J7FmCK7usszyKBj3p/OZgtLizjzWJ6vQnbo240Tpy3zMw82WAuyMnttSOeXfawxuaW1YdhrXVUs5jFitrDQ7mCpTp6nZ6uenI0xHZ5Wgf42lKXcnSqCCjeGupg5izyKFtW0xrdpd4E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by MN0PR12MB6030.namprd12.prod.outlook.com (2603:10b6:208:3ce::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 04:06:56 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7633.018; Fri, 31 May 2024
 04:06:56 +0000
Message-ID: <8601e84c-f920-4948-bb8a-e0951c6c13c5@amd.com>
Date: Fri, 31 May 2024 09:36:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] KVM: SEV-ES: Fix LBRV code
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, nikunj.dadhania@amd.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, pankaj.gupta@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ravi.bangoria@amd.com
References: <20240523121828.808-1-ravi.bangoria@amd.com>
 <20240523121828.808-4-ravi.bangoria@amd.com>
 <562819b0-2c8a-1344-6090-01f8cdca107e@amd.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <562819b0-2c8a-1344-6090-01f8cdca107e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0024.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::13) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|MN0PR12MB6030:EE_
X-MS-Office365-Filtering-Correlation-Id: 392d2ed7-c515-43af-0d1b-08dc81271c7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWp4M0I5Z1lTWlpWQVkyMS96bDIyamVZQmlFbjE4VklZbzRvOXpCWE1tUm5r?=
 =?utf-8?B?MnZjNkQ4M09Dbm5XNkdXaWJOSTdxZDA0bDdjbHJqMU9ML296LytxSGdQUGda?=
 =?utf-8?B?MXE1Y1FjN3JQd2szQXp2bFl0UzkyWXFjQkRmeHdkSXAvaUg0MkxnM2xpOUJS?=
 =?utf-8?B?YjBRdzgxdTNuczVJd0tjMGVhd3Q0U0JBZGpwaW1JaEZEd1NOcU55cFZ4UnM2?=
 =?utf-8?B?eU5kdUI4eTl3cXROSEdxK2ZsanNBZEg0eVFtK280Q1lLcFNzNkt1Wjg5Tksv?=
 =?utf-8?B?TVRvTTZzV3hIdWlzYU0xaTVQNlY1ZGplWGZ1ckR6Zm9XSHZVazVBQXJkZ2hL?=
 =?utf-8?B?emdJbm40dDc1Rmh3QldOcXdvM0IxMmhzYytRbHpGYXhkWm5rUlhVU0FOOUoy?=
 =?utf-8?B?dlY2cDkrendwNE5RUGszRk1MQWRDNXJ0RlJrdktsU2ZMZ2tXZzk1cXg0Qjh5?=
 =?utf-8?B?NEt2a2ZwQXMrSlV4RlAzRkdvZ05hMEJ1YWplc0R3UUg0YmxjTll1ZUk4eTV6?=
 =?utf-8?B?ZHV4bml6VHljNFZtTC9CbXhMT0RLZUxOeE5wTlMvaFkzWFVNZHNzTFRkQnhH?=
 =?utf-8?B?TFpGZXdyOThjQ3hYNUFoV080eUF5U2VUbWFvc3hIR1B1M2NMZW5PRWZTZXpr?=
 =?utf-8?B?TGFWakszYzFoYlhBeEsxYUFUM2VLdW56TGZiUklLdUNobjhqQlduS3k1ZmZ6?=
 =?utf-8?B?VFo1a3hMamJjNFNPdlgyU1lqMVVmamc1enRBN0hkQ2RrdHB6ZlZZYkQzeVcy?=
 =?utf-8?B?a0JUUG80YzgxTENZUWJld3lsNjZ2ZXljdU5HSHc4czFNTXFqRThuUFA1OXZB?=
 =?utf-8?B?c3B5TGllZWEvMlV0YzFpQVpEWGhaeDRNRHVMdUVPWUlSV2FYNnhnMThSZm9q?=
 =?utf-8?B?aVo5bDRZZUxHeEpTT216SUNkbjRVc0oreHI1TStxakNCNW5YVU1Ya1VVY3Ur?=
 =?utf-8?B?a1oxZERaRlRiNkUrQWxkVlBOZEJ0T25Mc2h2bDBjeUZ1TTVtV1VFZzh4OUxY?=
 =?utf-8?B?NmhjeCs0Z1hIVzZmUXBBZ0RJMHJKVVhrZkx6Snd3QW9qOHVNREZoOTR5dytR?=
 =?utf-8?B?bnFncTdOWWFZSXU0T2xKWjRraEdrcXFzSDYwN1RQS0gwL2ExZFh1WE9SK3Zm?=
 =?utf-8?B?dUxHUTc2MVZNWVFVME1ZcnhwM1dMaEJTVS9WZURZWFVyQjh5WFh0MTBhMk83?=
 =?utf-8?B?TWx2UEI4QS9XMjY1UnlRcmJwK1VWWUVoSUpYSXR1aHozZkc3eERMLzJVbDVQ?=
 =?utf-8?B?N3ppNnVER2xRbkEwN2NtUkk1SStuK0p6akgvMDJELy9HaEVhWHNzV1pzRnJu?=
 =?utf-8?B?a2tXKzE3RGVGNU02RjFpOHcrWHQ5aGlyaUZMZTR5eFRPSnJ2MndyVXUrN0tn?=
 =?utf-8?B?eU4yWDBPcGVhcGQyeVFJSXhIQ1RkSWdVUkJLMWR2R2xjdml5akJJdGNOVkFs?=
 =?utf-8?B?amxsZmJaYkhWVkQ5K2lJdjVvL3kwVHZmMlpoMnlDcm5xZXoySkVLQWRGaGhH?=
 =?utf-8?B?aVk1eFZodkFYYWgxSTVZTEFzTjFQelExOCtrQmFlOXppV1l5UjBibkNpNWtx?=
 =?utf-8?B?WngvY3UzemcvVTYxeUNlQ1RraFpmcWxqRGRsdnlEcGZ1NWZxS1djdFUxMTBY?=
 =?utf-8?Q?8+MELE2cvTQhu7FvYTqozlTGFf9tKMwXypnBs3H1JHfU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmxpYmw2ZmtNVGEwZmcrRGJKZnM3OFVkV3RPZHJ4KzYwb0k5Y2M0MGpZQ01i?=
 =?utf-8?B?U1V2dUx3eTNXTDlyUVpuRlNubFlrZmJuVUcrMFNzNlc1OUZtdVNPU1I5TWwv?=
 =?utf-8?B?dWJoN2J5SlpTanB1bU9sVmZtL3J6dEp5V0x2UFhiSkFyRHd4azNDS0hRbVdh?=
 =?utf-8?B?ZURsNElvQzZaSUhLY0ZxeDl5QUFCUmVodzNEamh5YzZyMWhnTFlTVWRpRWRN?=
 =?utf-8?B?OGhvTCtHQng1N3V1d2NWTDZ0eVkyV1JzYm5nQUMvSlFxdlJRMmYvUXpkMWs0?=
 =?utf-8?B?aWc0cTdQTCtmbXdBOTRkRE02L1FwWCtGdWlGWTg5YkRqcWw1SXd6MnorVFRm?=
 =?utf-8?B?djI3aksyWEpTdEpVemkzR1E0Z1FIUFVjWXl3anVHS3p6N21KWWVZdE1qSFZS?=
 =?utf-8?B?d1BDNjlmaDh0NG42V1RtSjhNZjYrK2UwZ3IyTlZQNnJjMmNGbDlEUWlzQ1Vl?=
 =?utf-8?B?VXp4YnExeDBpVkh6Syt1SHJpNCtDTlg5UGgxMnhOVHNXallkUG9FQlNaYzRR?=
 =?utf-8?B?L3Rid3JUMERmNnUzRkYvbWtQcDdqWGtjTFdid2hNMFRKV3lwTnN5dkFaU2hs?=
 =?utf-8?B?Zy83bzhnVzhtcE1RSURKZ0lNLzJZSUlEVWpHbDZkRWZPQkE2T2J4dUFsQi9a?=
 =?utf-8?B?eUE5ZGQ4WTl6b2l2bjB6Q3FjUW00M2hpdlpFSTBNR1ZWYWJTWXhsQnNmWElX?=
 =?utf-8?B?bzRZWUpDWGZya2JTaU1jb2xScjRvb2J3VXZZdmQ2WUYyelVRQlZoWU5VRkUw?=
 =?utf-8?B?MU9mNklqM2FoY3VpSnV6dHFhL0RQQzY1WVVOZk4vS2tNR0xBcjcrQW1Fb2hq?=
 =?utf-8?B?algvcEhUMjRBUUQ3NFZGclFoQTFqN2Nib1ozOERtV0IwaFJoSWFSOVNFVFVG?=
 =?utf-8?B?ekdVeDhYbXg1L2JTeU1ZYzQxTnpYMlNGWTQ0TGRjRWdqcDQ0NGp5MDlMeFZ0?=
 =?utf-8?B?blB0MzlKUDlhakluSXZ5c1J4RUJyQk50QUtmSW1GekpjdXFvelRDVXlDTGE4?=
 =?utf-8?B?L2dTY1lkZXBkY0JvT0JCbmw0WVAzVFExMitEdnY0aXlVbysyWVltK3Zpa3pU?=
 =?utf-8?B?MUpwbE1UVm1qM0lSeDI5V3loOURjb2ExanhYYzd5Ym14TGVjNzI3dXB0N295?=
 =?utf-8?B?eFNjZDVhVTdydXhydFBvRFh3T1BCNllSQWRqRlNtVHF2TjdmZWowLytMVGVG?=
 =?utf-8?B?M1VBU25NYXh1QmlQK09qSGpPUldzcTJsazNUdUJFdEZCNVZKcEZYVWYvYUNm?=
 =?utf-8?B?SjNYUndmaHF3dlBINmJFMmgxcGlmTjRXTG1GejdWbkxPWGFVdmxuVEhzM3lJ?=
 =?utf-8?B?R25pZTlCU0VFLzlnV0dzTVFGNmoyeUtVcWNWSHhLZnUzT2xGTWhlbzhKSjRB?=
 =?utf-8?B?eDlvTXgwcE50RUZGeHNFMXp4ZThBUERGclcxZm9QclRPVy9FdHRFbUxIOC94?=
 =?utf-8?B?QmxzK2xiZWxTQ3dVUmRIMnQrVW52U1NJZ3UyeGFQbHRLaU9VaUVNanEvM3Zq?=
 =?utf-8?B?Sno0UVh4TWZTVFZMbG5jejRNc2w0ZFhOSDlRakVJT0ZYa2hNUVZ1ZFhFZzZq?=
 =?utf-8?B?VG9DcmZYanR3OTZlYkR3UEJIT0VCVDVQdnZDek9neDFPUmFMY1U5S2IrUkg4?=
 =?utf-8?B?RElFdEtwOExHQ2RBMncyWHFacG55VFA5Tm9UYWdZWlVMakVOeFFNWEhnUmFG?=
 =?utf-8?B?ODVzVy9QcUpvUkdJQlZXTFN1SDJ0UGdCSk1QSEg3ZVllOG5QbSttR1I2NitG?=
 =?utf-8?B?cmgwOVRkNGpzaHpMS0hRZENKaE1CQyszbzNNcFc0eVhmTVFWcGlBc0k1RGdm?=
 =?utf-8?B?enlITSsxNG9nRksxd0QzQkhjTVhpYUROQTJUTll1TUlEcWk1ZG8wZDQybTFp?=
 =?utf-8?B?dFdQUk81Ulp0b2lPdDFBd0xpRklac3F3UjJUcWxGYk5WakVyMmZGVUYyNmgv?=
 =?utf-8?B?dlZGeWhnMG9XNWIzMlFDRmRTS3N1bkphcjRnWkZtOGVhL0I4WmluTDdPSjNm?=
 =?utf-8?B?QzlJQlFhV1EwdThBenZVZFJoVWpVYjBGZmtWZXh6SmhrRURxZVBKUndMQXNJ?=
 =?utf-8?B?NzVWQVpEdEk5SHlhcUJ0U1VBL1U2aXdIeHd4ZCt0VVpibERjQmQ4TXE4L1Zs?=
 =?utf-8?Q?sY3iJ4xw5GOMjDu8CmAO6rcaP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 392d2ed7-c515-43af-0d1b-08dc81271c7f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:06:56.5679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGDilw5QvHa4j9w3JCIn0WKDQAmolSa+Sdh+aQeCboUnzT3xnnj1EWn8R+J9y8znfxjiNV+4TSoxaY3tofZbZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6030

On 5/30/2024 7:33 PM, Tom Lendacky wrote:
> On 5/23/24 07:18, Ravi Bangoria wrote:
>> As documented in APM[1], LBR Virtualization must be enabled for SEV-ES
>> guests. Although KVM currently enforces LBRV for SEV-ES guests, there
>> are multiple issues with it:
>>
>> o MSR_IA32_DEBUGCTLMSR is still intercepted. Since MSR_IA32_DEBUGCTLMSR
>>    interception is used to dynamically toggle LBRV for performance reasons,
>>    this can be fatal for SEV-ES guests. For ex SEV-ES guest on Zen3:
>>
>>    [guest ~]# wrmsr 0x1d9 0x4
>>    KVM: entry failed, hardware error 0xffffffff
>>    EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
>>
>>    Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
>>    No additional save/restore logic is required since MSR_IA32_DEBUGCTLMSR
>>    is of swap type A.
>>
>> o KVM will disable LBRV if userspace sets MSR_IA32_DEBUGCTLMSR before the
>>    VMSA is encrypted. Fix this by moving LBRV enablement code post VMSA
>>    encryption.
>>
>> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>>       2023, Vol 2, 15.35.2 Enabling SEV-ES.
>>       https://bugzilla.kernel.org/attachment.cgi?id=304653
>>
>> Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> 
> Should this have a Fixes: tag, too?

Yeah, will add
Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")

Thanks,
Ravi

