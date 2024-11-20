Return-Path: <kvm+bounces-32223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6C99D44A0
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 00:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 566CFB22703
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 23:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506921C4A35;
	Wed, 20 Nov 2024 23:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xI4C4ZN2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A03F13BAF1;
	Wed, 20 Nov 2024 23:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732146234; cv=fail; b=rr0+qjtdXaSEyqFKhLpkGjeqAXk2QbON+Obd3hXXnPiYBGtj1gQPU1cp6xK/y0WK7kilkf/NMWHUIAy1B808ksMXSrogKzHZfR/mFY4T/c01FPu8kBl03JmCVyBhcU5Txn8YZ8Uw3Gdjwhm1uU6drkWYDni/SJuSg8G0oYnuZRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732146234; c=relaxed/simple;
	bh=H07HzoSg7fJ+55eB1EhlH/H/mw4faiVEaROSj+PCTIA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LiewG8NvQUGKe43mbwsyTl8DA/AkqdChlQGIBsbz++2KI5Ujdpe7s0I5Uu9OlvpClPRoEVzdbeeRjDsk5DXXb4Muc/DF6HVysU8kydspdtQPK8RbcXKTgdS/59XKu3QCVCZHe4Hl8QgoyrkvN5y+IahsIMEKzqLeRev06NIlMHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xI4C4ZN2; arc=fail smtp.client-ip=40.107.101.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gfh1DdCUqNqmWf48ZVNwFIb5RIOlOPsQV5ZkHzN93fQkJtKc36Mjt5dbMMzxefUUJIQPEjCV30kbAiCx8xuXtUwQYQ08R59b46pj7Q5r5i81Cs3uiRtGq2cv6UOGlN0eqPtOyu6aINSyy40GL5B7+bvd/BmfukhrWYY1SIQVB03PSp432lTeHtt+mrIavTPKdljaiQgig/YCWFAFVy9BOmmEXVB6Zv0u7jhtPJe2W3FndobY9YfOvB6hYW3ndfDot9MeyNIRjDSvF31JHsFw0MNJXebrTk/a/dEeLFe/mFL5KxogV/qEzpKMhyvwsTUKP9SZ13EwV1CrL7cFThgaOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOI4I4OIKvW0ArJADvrf9gB+E2RVjUYab4H+gsPlKNI=;
 b=E1/qmpVLCZqC5dv5Tp5xAbtOhdBVLoos3JDfNKe4mH31iVZf1Kzkcrby5IRthfc/3ZnTVyK9LFaZpJygX2sbjwfBuliTkSWYmm2qQZb1bduVb622h/wSbLQ81BMB/IFZMNU73Y3UuHxTzJ2WConU7RmCC0zz9gVAjgWIJ5HvidUvLXi7/vc3ZdXbtydrfvBlcDCXj9gU4dXRzRvvMaKkh7mfCyuNaaX+4AAJtbG5CjsT7J7BOr2fgICi57lUAPrS3sFRjavFF/h2ZhMZIVou4GcPf0uItg18trE8SuoSvil0alu+9RAkcGGddFTGP+qGkolfXVTiIdDUEBlZGbwYfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOI4I4OIKvW0ArJADvrf9gB+E2RVjUYab4H+gsPlKNI=;
 b=xI4C4ZN2v5b4UfCkhMgCQLrqX/CB1Bkk/EwczWlxx56uL3nffOyhTK8NJFecZg0sSIzQnFvef1zuIxChqJ6aygUQwYI5492GQENlW2XOf7zye+KEMO332UYK+DS4ZovhS5hyU7Bd+KwudIz7IZrvPvhrwpWtcw7yuwX4SHKeykM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB6185.namprd12.prod.outlook.com (2603:10b6:208:3e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.21; Wed, 20 Nov
 2024 23:43:49 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%4]) with mapi id 15.20.8158.023; Wed, 20 Nov 2024
 23:43:49 +0000
Message-ID: <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
Date: Wed, 20 Nov 2024 17:43:38 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com,
 davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
 <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com> <ZwlMojz-z0gBxJfQ@google.com>
 <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com> <Zz5aZlDbKBr6oTMY@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Zz5aZlDbKBr6oTMY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0171.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB6185:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f721bf3-32d7-415a-7688-08dd09bd2e84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkZKdnpqWXlnYlRxdDVBSUF5ZG8rY1lEaXpnNDlTOHZxMEFrNzVIcHNoVytx?=
 =?utf-8?B?THpaM3doNDZJRVlkekxLQXl0Nk01ZWZKZ1BNVGVZY2VVWmV5U2ovUUNMcEx2?=
 =?utf-8?B?UGFmRDhZamVMT3Fnb1VzelM0T2ZKYld0ZVdQbFBUS3ZhdGo0d3M0SnZnNlJ2?=
 =?utf-8?B?TXdXRVdGaXlhQTdtRXdFMDVXanl0RVVvMHR5ZThHVkNBWTZTRGNHMWlJeFJX?=
 =?utf-8?B?SnhWeDR0N0o2Q3UweFc0UjRzOWgxeHExYUZqSngzUjI5N3JWclFTMlI0bHNO?=
 =?utf-8?B?NTVzamUvRitwNDNCVjBkYW01NENWYlR4cDJ4c3NVNlVzQWdZZGJLNEhDRmdU?=
 =?utf-8?B?T2hITXc3dW9YaXFpNHZlUDBiWjVVV2FpVDRkRlUzenpBQkVRK1Q4bFRqQ0Vj?=
 =?utf-8?B?bS93Qk5pV0dJQ2dBSkcwTGJMbkpUeTAwOUxRdExoRjNRQ2xZSWw1L0R0bWph?=
 =?utf-8?B?ZnRFNjJ5R042aHpIczJ1dVRMSFZLcVZMeUNnb0RWZnNRNnpNY0pZZVhGNWpm?=
 =?utf-8?B?Y08vYmQyamVjRmJiQk9MT1lobmNWeitCemZDb20zbkZHNFJQak52ZUkzWWZR?=
 =?utf-8?B?UnNUZjU4MEMvSXk5VTJkYVpkY1I4c1VPUlhLK2daNWpoRmRzVHIyQXdVMklR?=
 =?utf-8?B?NkJlWGpYRHB0dVBOSjk4Y2pzWDZ6RkJ0WnVWeVI0YmQyWEJSYjZpWTBGb1dP?=
 =?utf-8?B?Nk1Za01pV1o1Q3phV3VLbnorQ2phL00vVWpjWkMxYmcwQmtQY0Zwb3A2VE9r?=
 =?utf-8?B?WlZocjFTbDJUTE1yS25DREU1UjZOMlliT2psbjF0UmpYWGRMYXFBN29Lbmxn?=
 =?utf-8?B?M2FiK3BaSFJXRldlZk8wc29OWkphUG02cFRScnd5WmZGYVFRZWlQWEVrdTdT?=
 =?utf-8?B?YzlsWkZKUFJzVmJDTWhGOUdzTHBrNXM2cXZTMDFEczhwTkVvYTZPbWw0V0FP?=
 =?utf-8?B?ZjNqbmllS3gzMWg5OXV5SElOZ1QwRkN1MU9ZSHl3bjR2blVtN1FqTHpvVks0?=
 =?utf-8?B?OWx4RjJ6UTNIeEF0M0UzTFdvRTVZVkFpbU5EcTRxMlFrck83SnY0cWs5WU1D?=
 =?utf-8?B?OWt3dEc1eDRUN015bTNnWERIcnhsQ0ZSbzhQbnJ6MWJ1c2xNYTNlR0pMM1Vk?=
 =?utf-8?B?ZDJpZ2cxeXcweXBYYURNcW16NGg3ekxRRDJoUjkxSDJ0azZqSlgrSENhNHVM?=
 =?utf-8?B?M1JMcDc3MW5BSzRYdjZlVG9NUXc3WW1vSGw2UDdvSUF0OE1BZ29FbTRSZkY4?=
 =?utf-8?B?TThadjlYbmhZYWlNWFBvV1NHNnhiOVVkUnViTU15eFF4T2ZMdVJvTW5zaWRt?=
 =?utf-8?B?c0gydkpOY1QwcDFzekxBdTVySWk2ZXRCZjlsNE9NclNVK3Q5U2ZQcWs4OWZH?=
 =?utf-8?B?Si8rYnZMQlhpa05rcmsyeVpVa25vTEVzem9YQ0dnY3FGQVlYMHNzclB3Mnhu?=
 =?utf-8?B?bmUyQ0JTUEVrWHhST2NMZkJhb1prZHp2d3hMcEhWa2g0L2l6WEo0Q0ZhTEht?=
 =?utf-8?B?MnFpN0JkOGRXME5IdzFueXdHM0t3ZEU2dW1FUmZsSzhjd0pKc0E3N3krd09t?=
 =?utf-8?B?NHA0R0NjS0FiK3d3dHViaDRJUFdIY0pqaE42MXVGeWYyWFFCMnlxektHNWhV?=
 =?utf-8?B?UXhrWmNWT0Fram5sMklqNU1rZ3p4TkFMWFp4L2xERUlPVTYyLytlaytPMVBJ?=
 =?utf-8?B?UHd0Y1lXMTJuaFRwdWkwSjlkcFpnYy93bjg3b3NScTlqV2p3d1hzeGttMUQv?=
 =?utf-8?Q?jdnIXN8lqfwItf8Wf8g9Iklz7lSYP/V7Pe838F3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFFkeWkxdHBuZm0rKzZHRFp2SGZQZno0WFhUTXZxekp1K0ZsQ3VNMTlkQVNT?=
 =?utf-8?B?aUprT2pPZ1M5TnBQK2VqMW9qa0l6YWhrTmhFWFdEVnc1OU9QRHp0VldQN3l0?=
 =?utf-8?B?NnNiNEZyNy9mMzlqTUZuOWp2eXBGbCs4dDJlTVEwaTE1T1krMERNSFRhZU03?=
 =?utf-8?B?WE5BaXZXMnpoTUlVZ01nb1hRTFZyL2hVQ2Irc0tZbm1LZklqeDMwVXQvMTZC?=
 =?utf-8?B?ZWZtUFZhVVhoQ3pRZDQ2dVdjNXBLeXpaL0ttekU2K213RFFNTnZFYThVc0FK?=
 =?utf-8?B?Nmk2STQ4M3cvNGZIWGtTQzJBc2J6QjUxOVhMQ1pQT0pTTDhKbFlVZThXRjdG?=
 =?utf-8?B?bFNKSktGbWhndVNiUDJxb1dtNjVPbUQ3blNjRjBxNzMzNmxMeGZaaFRmT2VM?=
 =?utf-8?B?em1sNEtVbnNNQlQ2ZVVZMHpaMkU2S1lXOUpsNEdlUGpPbVZSRE9nL1Z1aktR?=
 =?utf-8?B?amJEeFhUOHdyQzNDV0Z2MFc1ZG9JUGEzem9LNzJFK3NBNU5samt1T1RaN1lv?=
 =?utf-8?B?Mjc0aGVoSTJKRVNWaXF1WGtGUEY0RzBwVVJqREJXRkg3WU5OampjczczamZN?=
 =?utf-8?B?V0ZlN3R3aUpDejFuTjBvUWF4dTVBVHk2bS9qdWw1YTZRd1NJYW9udFNCeUFr?=
 =?utf-8?B?eFBuZEdjMmQ2eGIwU3UvK1VKc0krNkNWRXl5dUZZSnU1NlNKNTRSMUVwbXpx?=
 =?utf-8?B?MDhQTUdYNGVMbVNJWW5EVytNeWFGdFJOdVIzeUlRTFY4SU54SHlYY3pBOVM4?=
 =?utf-8?B?VWc0QUdTb0hTLzVOcWpUak1weXNxSWlnMnNkcmlMSWs4VTNkNFdCSnE2L3l5?=
 =?utf-8?B?bDg5S09mWE9rOGNONUVkbTVXclFoVkF0RG5rK0JIQi9MdmhDZXN1bENwUERC?=
 =?utf-8?B?a0RLeE1sbE5TaFRCbnB5cjhyeDVsNGE5aDl0VVdwNnNyTTZiRmVsSkR2aWYx?=
 =?utf-8?B?N1ZBZjR3c2FNSy93SHZsdmd1dyt6bXV4WFcrcDVmdkY4WDFNa1JkOWJqNmhs?=
 =?utf-8?B?K25MVUxBcEM5Y09DR0ZNSnpCcHltTU9TZzFoRWpMQWpjQTVablpCL05WdHlM?=
 =?utf-8?B?azc5S3o5NXlxcWQzcmNBVzRIMjFDaW9KenkydVk0b2tqZTdwbkhPL2djY0J2?=
 =?utf-8?B?WElia0F6MUlScVRIVGFZeWgwVjZMK2RHUUFhejhHVE9aM0Eza2Q5TUl1Nlpy?=
 =?utf-8?B?TzhMbUhYUUh3VFo1QjhJNlJTdHVxeXNSRzNnais2MkcyS2xicThKVnoxeFc3?=
 =?utf-8?B?alY5NWdkcFhrSk5IY1d4dTBqT0RKTVhRRXNzYnBCTk42M0tCRTh4dVJWWWdU?=
 =?utf-8?B?d3UyQlZoTDIxNUFNN2xQcHdqUXg1Qk5pSnRlZHFiY1BZYTN0ZCt3dGx2a2U2?=
 =?utf-8?B?U2NVMmlEdmoyckxXTFlFQXlGK0NQazNXK0w5MHZucWZkNkx0Snl0bEhXZjF3?=
 =?utf-8?B?YVd3VFlNSnJWWTdIMUtNK3A3b2ZtUDRtMUtFVURuS1lpbFhxMnJDMW0vZXB6?=
 =?utf-8?B?Qk9iRHBLSUIzNzVrZ2Z5VWl0VFlNYVJ1Uks3cnIydFp2L2RuWnF0MTNreFda?=
 =?utf-8?B?dm4xWnFIK0YrSGNXS2VQMHBla0dESUUzL3A5bHJydy9KL3RlMVY1RXN1U0lw?=
 =?utf-8?B?Nzh2MUxxN2JDQTlCSmtjdWlqVFhpaGVKNjlGQUFtZkpzbW9TVnpaL3N0aEZC?=
 =?utf-8?B?VmJQU1lZMUkvV2ZpWlB6Zk5QbEVnWmVJQXpFcHdBQUhFT0tYSTVmRTVpSitl?=
 =?utf-8?B?Z2JuMmp2OEhJZDVUNm9zQjJ0MEp1K2ROV3YxY2ZFSzJSNEp3UThlUktSNW1n?=
 =?utf-8?B?MFJ6SHhBeTNQekZGaDMvZTNTWkRoTDh1NDFleWNZNHNnem9DczgzNStkeFR0?=
 =?utf-8?B?QkNZZTMwN0RoNWVzbm9ZRkxNQlhaSVBUMlRXZDhLajMvWGpBUkdUYXJHeVdZ?=
 =?utf-8?B?TmhqbWI2Q0pma2xmTWI2cm4vVlZIYjBhMTBqQmZZZlJZc0luSm54T2JJVCsz?=
 =?utf-8?B?OVRYTXFYNXhXS21NZ2tvSlJGOWxZL2l5V1ljT2ZWZzA5dnhFaEFUSjJRbHFm?=
 =?utf-8?B?N1pSQUFUOUNhOFp0K3lHbk1zdHZXS3laTmV3dGk1TWYraG90VHFkYWNVT05a?=
 =?utf-8?Q?fMa+L361gkSZok+1pcFjvxNz/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f721bf3-32d7-415a-7688-08dd09bd2e84
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 23:43:49.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akNOoghaKjTuWxWB7esTaj3bUKVGzNCH/BRFrd51+JF1i8Tchj3O0G+4n5s20DHL6UK8d3N+FfZRbAVet/wpQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6185


On 11/20/2024 3:53 PM, Sean Christopherson wrote:
> On Tue, Nov 19, 2024, Ashish Kalra wrote:
>> On 10/11/2024 11:04 AM, Sean Christopherson wrote:
>>> On Wed, Oct 02, 2024, Ashish Kalra wrote:
>>>> Yes, but there is going to be a separate set of patches to move all ASID
>>>> handling code to CCP module.
>>>>
>>>> This refactoring won't be part of the SNP ciphertext hiding support patches.
>>>
>>> It should, because that's not a "refactoring", that's a change of roles and
>>> responsibilities.  And this series does the same; even worse, this series leaves
>>> things in a half-baked state, where the CCP and KVM have a weird shared ownership
>>> of ASID management.
>>
>> Sorry for the delayed reply to your response, the SNP DOWNLOAD_FIRMWARE_EX
>> patches got posted in the meanwhile and that had additional considerations of
>> moving SNP GCTX pages stuff into the PSP driver from KVM and that again got
>> into this discussion about splitting ASID management across KVM and PSP
>> driver and as you pointed out on those patches that there is zero reason that
>> the PSP driver needs to care about ASIDs. 
>>
>> Well, CipherText Hiding (CTH) support is one reason where the PSP driver gets
>> involved with ASIDs as CTH feature has to be enabled as part of SNP_INIT_EX
>> and once CTH feature is enabled, the SEV-ES ASID space is split across
>> SEV-SNP and SEV-ES VMs. 
> 
> Right, but that's just a case where KVM needs to react to the setup done by the
> PSP, correct?  E.g. it's similar to SEV-ES being enabled/disabled in firmware,
> only that "firmware" happens to be a kernel driver.

Yes that is true.

> 
>> With reference to SNP GCTX pages, we are looking at some possibilities to
>> push the requirement to update SNP GCTX pages to SNP firmware and remove that
>> requirement from the kernel/KVM side.
> 
> Heh, that'd work too.
> 
>> Considering that, I will still like to keep ASID management in KVM, there are
>> issues with locking, for example, sev_deactivate_lock is used to protect SNP
>> ASID allocations (or actually for protecting ASID reuse/lazy-allocation
>> requiring WBINVD/DF_FLUSH) and guarding this DF_FLUSH from VM destruction
>> (DEACTIVATE). Moving ASID management stuff into PSP driver will then add
>> complexity of adding this synchronization between different kernel modules or
>> handling locking in two different kernel modules, to guard ASID allocation in
>> PSP driver with VM destruction in KVM module.
>>
>> There is also this sev_vmcbs[] array indexed by ASID (part of svm_cpu_data)
>> which gets referenced during the ASID free code path in KVM. It just makes it
>> simpler to keep ASID management stuff in KVM. 
>>
>> So probably we can add an API interface exported by the PSP driver something
>> like is_sev_ciphertext_hiding_enabled() or sev_override_max_snp_asid()
> 
> What about adding a cc_attr_flags entry?

Yes, that is a possibility i will look into. 

But, along with an additional cc_attr_flags entry, max_snp_asid (which is a PSP driver module parameter) also needs to be propagated to KVM, 
that's what i was considering passing as parameter to the above API interface.

Thanks,
Ashish

