Return-Path: <kvm+bounces-52525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 096D8B0648D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 18:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EB4B3BFC97
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61CE527A444;
	Tue, 15 Jul 2025 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mUDq4npa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FED19F464;
	Tue, 15 Jul 2025 16:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752597895; cv=fail; b=rk4UoNHLOgqXO3dMjF/IUxUMY47JPw1BFMsyL12LXBZEuGEDNVWVpi2yed2mK1gSnyvYs7kH1VyOIdZedk9Rld0kmXPnhehaAJ5hs5dKFMLn9BUiCvF+ENvjC6BlXiMrC1cWY+OWhQGWWQ8lBC5ktUkQ2BrcepBum2YGQDlVrbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752597895; c=relaxed/simple;
	bh=VhIezLp36CPWJLV/QNgHf7q65zWEEy87K3MzyuLm1EY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U9pLKShcZ9h8vflYttznnZprAoHPifsJh6OunzmxrfK5+/IgEp0l154QanY+UrHMvuaN3yxhzbzgxorGrwGs3L+tVGwkrqsUD3MCZ/hcuhXm/yUVt3pSkM8/gfYZnRQ7IwJLd9gxpiS4XjSYqqoo24MullTsfpSK9lm7YW7qaBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mUDq4npa; arc=fail smtp.client-ip=40.107.96.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IGG/NvvIhSqkYL8/8/23NG5bynMBHxcUVyvnjH+o4i5uoncWGFJunDsrPJrkmniIJ+/sgT9nstkOg21e4dg6x+Y0gHkfqhFntz7hIz6NhMOqgGUfZTvelXIWF2dL1f6gGiLIRCZlYaKBIQrCcY5iZOMM5TnRLgfUkBDede6niY54E1jgKLECMs2GwWmkJ4K9P/m4VuXy0ddhlbZ3BNz5LDB/E/FLDSEUst9B2niwI8qfDGlyLqusG0b1Vw9VfgWhwMkTndMUSRwEx6zeXpEbz5HhJcutkRDkOeXM5fMZRX/jfBmZE6RMaua2oIQS8RKeOKCvFX8ooG2aWIzeffwBsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4Y3bn7/em9EvyHhcNdSwtrw2Pbe2sI6sMNwAFwsBZQ=;
 b=DRfzm5BrRsmHa/w6WNNM5BsxUq3HWsJaxxNgm+zRyfju99pyJGo8tNChdQ2dmbedu5NmE6NZPqvwLvlGzenAvpDgZB3Cn70j2f+VKhEkApTCnz8xSO90AtLt8gFyxjVMXgpfDFOfhml79F04DMXWykE67dEFfGzWVol+MiFAFp/4TOUE5qTyO4KkWHxQJuJNRybfm4C1TiDebJOF+Ja3QF+z6iJc5EbI+AcVPfDhBep64CYsepr3iWUYanl8URfsmEzbQWwiETCMKMwXXNBkjjEfbQmmoTmwUeOv/8sduW59PPLN2yuZtVPolpy0eEObDC2N/J8Wmkv2VHzxEorajA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4Y3bn7/em9EvyHhcNdSwtrw2Pbe2sI6sMNwAFwsBZQ=;
 b=mUDq4npalTqP0351EMtPM3EG2T7Nq2yyfsXhNkV6gqligHeJUCwxfEAk7sNKY5yDShjynGUmsP9BQ610kk83Hnn0VR5VCZ4aTHYx7Ap38bGUCYohu5k1ue2+Qwy9MrQXQ2X7uLoHKetjYSy5VpctF2qjeNPfrf4O87QpLt+Q6TQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PPFC855560D7.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Tue, 15 Jul
 2025 16:44:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Tue, 15 Jul 2025
 16:44:51 +0000
Message-ID: <c39af745-35b4-6201-be05-80b19636381b@amd.com>
Date: Tue, 15 Jul 2025 11:44:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752531191.git.ashish.kalra@amd.com>
 <1b60078dabee495d789fee68b01e8433b4791c69.1752531191.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <1b60078dabee495d789fee68b01e8433b4791c69.1752531191.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PPFC855560D7:EE_
X-MS-Office365-Filtering-Correlation-Id: fba1fdca-f619-4787-182a-08ddc3beeb0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFM1YjVDampzMzJxUGhiNHJwT3AzWVpFTUxuYnhpcmVKZVhCN1hMRElJbkpZ?=
 =?utf-8?B?eVNJQjU0UHFGWVo4T2FPWEpqcXM5QTd6Um1qemhqbUVUYXJuRGtxWVJYODND?=
 =?utf-8?B?Y0xpc01hY1Z0VFUwdEtzVXZyampoZ0tiVkEwVTFZUVJLdWcwYXJiKzIvV3pR?=
 =?utf-8?B?UDlXR2VSdVRoYUt2cEdHZHpCckl3NllSdDlYcVRHRWJORHBpR2lnTzdKV2Ju?=
 =?utf-8?B?aW9WdnA0Y29PTDg3ejg1R09MVmF2N21oTUg2NGRuNW5JTlRkUHRtZG9Qckl4?=
 =?utf-8?B?bW5ITXA3Smp1SUoyWXd1SCsvVHppTHAreXg2dklkWS8rOFhMZGlOYzlhbk5U?=
 =?utf-8?B?TWFLZFJ2NVo0K2xsNjZvUU5oa2J3NkZvNjdCZUVieGxmTElCLy96UkNOVFdM?=
 =?utf-8?B?VVBJelFRRzk1VHd5ZjZMRXlKcFdFTG9DUjQvTDhUd05Kelk1MFFuQjlneHht?=
 =?utf-8?B?S1VycHZmcHozaWJ6b1NuWjlPVTYwTGMxNFdILzN0OWdmR1dHZzVQOC9xY2dT?=
 =?utf-8?B?dXlkdkdlY0p1SVdTakFaMWFaUFlzYVR2czVkOUFFVmZzTTdiaW1vV3BRK0Iw?=
 =?utf-8?B?SzhlYWdOZG03cHVLS2djWjdxblhoOEIxZjVLcDdCNjlUMXpGaWllVFdzT21I?=
 =?utf-8?B?amhFcXp6SDh3cU5Jd3IxdnlXMGM3N05WTHBPc1BQVDMrV1VqQ3NCOVI5cmJ1?=
 =?utf-8?B?UEJSL2pZZFRQYUN3V1R4V3F6ZnZ1ajFZNWJVdGNQdXNVVTBvWk5pZXR4QmRW?=
 =?utf-8?B?WGs4SWJvckpnTnFycmpiR0JUbk5IOGdMTk1iSjhLSUhJRmt0aGR6QXJxYjhT?=
 =?utf-8?B?VHlPU1FzSzFOOHByWkFjNVR2NExWSTR0ZWRDYUI1cDV0NGM1NGh3TkoyNVha?=
 =?utf-8?B?NzFxV2ZMUnlOdXV4bnpEeG82R0k1djUvWFF3MXlWTDMvYUw1dUZGbExxbFJs?=
 =?utf-8?B?MFg1SDRSVVpDWTlVQTNvcDFqSHlNMnI4WHU5cEUycGY0RnJENVo1T0pkMVZ6?=
 =?utf-8?B?WEFOVUNrWFhhazZqWm14QnlDUVdVb0lUUWpRRXhDUzI4T3JOaCtGQ0hnL0ZO?=
 =?utf-8?B?aWFlYmhMYnQ4VkYrdHh4anFNbFN3RlpjZG0yV1VBUkhKa1dqN0tvOS9DTnBt?=
 =?utf-8?B?RkhhU0o1dWhVditDVTFjQTFmOVU2ZkZmc0dPQjluSXUzT29qSGE0aUpneCtG?=
 =?utf-8?B?emowQTBwbVhZMUl1MGlrcCtFbm5yQ1QzZnR0OWZSbCswV3Q0N1hpc2dXK0VU?=
 =?utf-8?B?L0NVYjk3d1JJYTB1cnJkS01OZnFaNHhQblBadFJuNEw4Y1FUKzVGZExWcmZP?=
 =?utf-8?B?NDFSUVJpalNVd1Njb2hEaVBoTVA1ZDF3WStaand0RDNvM1dlUVFVRzhtVUM5?=
 =?utf-8?B?QVJTdVBFUXlrcmdMcDJaakFJS29CYm1XUDI2QXVFZkhnTFhEYU9id2cvRWpS?=
 =?utf-8?B?YW9XcmZVcjBQczQxM0VCRjA1MVRmbno0clZrZytheWR0cFFSWk9SZ2ZaNk5l?=
 =?utf-8?B?eFdVN0xpczJhbnZXemlJODhGR05pNnpmU2RYejJxL0c0ZGdWc2hkekRpeVBj?=
 =?utf-8?B?RXdJUmk5ZlpXMXRIVmpVcHhHMEU1VWpheFhKek94MDFYRmgyRm9IYm5rS1dX?=
 =?utf-8?B?WEdHZ3dqM2RNUjl3ZzBHaTVzdjdZQzE5NzJMaDZLa1EydXBwYlRXM09zTjBw?=
 =?utf-8?B?NFdYWU9BdERuQWJrdzZpcERlOUs2ZENYV3RTZFUwbGR6YWxZYXozbkwwWjVP?=
 =?utf-8?B?ZWhLdGN3UFIxc2lwcU4rWnhVL2lxdWxXN1NKbDhJZ2J3R2huTFlkblJTd1RF?=
 =?utf-8?B?MncxU1EzQitKUWZqdEZKeVQ4TCtIV0M3M2RjRW5keUNlcWFuOWJDb0VROVZH?=
 =?utf-8?B?bUNMUEk4R0tTdU02WUFpTklHdWxYdnl2S3MveE11RVlCTU13dWlqa0d5a3FO?=
 =?utf-8?B?WUFEVFYzQnErbktqOElRU2QwYVBaSXNZNzhQbklMOWg0YXRpaHc4UTFyWkVD?=
 =?utf-8?B?OERrUHhFcEhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGNiUlRaWk85WGJhb3hKbjdHZzVSQ2xUUVZxR2F4TGI5aFcxTlBMTGVJQWdh?=
 =?utf-8?B?bUF3NzNXT092UmRzakErVmxPVTVpVSt3OUg2L0E4SzlIR1ZlR0MwK2dlZmdS?=
 =?utf-8?B?MHFoYmM3QXJSSG5naXJPMTRpSm8xeld0bVU4SHg3VWxBOTVpeEpHYWR2Y1Bh?=
 =?utf-8?B?T1NPOVd1NkFlNkN5cUs1SFU4Qmt1UnNIRk1LdG55T09CVURFNklEMGRKM3FF?=
 =?utf-8?B?V1JNN1BMbzRJbXVxclNJbFlncENjS0xEOHhrVFhSaWlQbitMNkNteEkrenF4?=
 =?utf-8?B?a2w4aExpclkwOU9HbzVNb3FyWHhUei9MR0NQbEZWMHlIek8wUUlwOXhyaDM4?=
 =?utf-8?B?VUFicWllaTVwMTBZNmdvaytMMmFFK0IzU282eFp4UVFKdmMxc3p2emhoNFlC?=
 =?utf-8?B?M3JVTFZHOFhLUkN0VFA2d2EzMHhOdGp2cHAzUkplZzZuZnp6ZWJUKzlEYnVx?=
 =?utf-8?B?ejl3WGdBN2ZUQlU1WjJkS0FOVEJpZzZZRU5KYzVLblhIMldBeTQwR2lCQUt3?=
 =?utf-8?B?T3UrZWdqUWlUc0NRTWtIV25KSURoY0RvNERMWXduQ2Y0akRtV2dHeDhDMHlL?=
 =?utf-8?B?bDRHcTJRQ0ZpWTIreFdSMzQxN2tDakxqaklDY1BJMmo0OEVpa1RYZGVnOThk?=
 =?utf-8?B?SURzREF0TEtoT3RxL1dUVnBza1FXaS8wcFlvcWNMZUt6R09nbUN6NjJtRHVk?=
 =?utf-8?B?ek1NcE05blRjTFZTTlgvKzJwMlI2eXhlK0dEdWY0ck53dmllYmJJYzNnREhk?=
 =?utf-8?B?ZFArV1BjMUlrOERISzc0dW1aaGppTTQ0N3ZIYTdnYzJCK3FzVURZR2YwQTAz?=
 =?utf-8?B?b3lLTUpnWEpyVDNLUGk4ZGFLUlIxU2lYbjBoSDd0M3V1bHVrVXBBUTBidCsy?=
 =?utf-8?B?Q3FRU2pvVzB3RGltcmdJbmJaUHo2b1hHbGV2VllkSXNRRjJzOS9kOFRoSWIz?=
 =?utf-8?B?TWZIckJ2cHU1QkQ2bVZNZjNXMWRqMGgwT056VGN0V2srckJkUUpsL2Y1UEQw?=
 =?utf-8?B?ZUpTYkNPUldHLzQ0VHlsUm8zbk1zcSsyRlBaWGNuTG9YbUFwa1VWRG81UnhN?=
 =?utf-8?B?NUN4M3g4Z2JBRjZva0trZi9uemJFa3dybDVXcFd1WFFtNGROOEtqYWdlL2U5?=
 =?utf-8?B?b0hrbUM5RllHK1dBUEM5OUplZkpSa3JGS21ycUtTR2k4dFlmbGRhdzFHMExH?=
 =?utf-8?B?NlpEenBMd0xzR1JFOWw5U1JZTzR1Sk9tc1Z2UTBmRmFhWWhSNGNURkFHSzJM?=
 =?utf-8?B?VFgxdjdvbEJWMTVkeVU2Um0ybm9sZjBGK2ZvZ2h2ODBpQVhRRFpJRlFmZ2Z5?=
 =?utf-8?B?NGxsaUxqVHhFM0lhTEZZNnQzN3dMbmtRekFEZ0FxRmFOS0dNTzQ5aVRHWlky?=
 =?utf-8?B?VW9jVUZkMzJIRTM0cUk5QUxxNStsdVEwZXR6R0VnYmxJRVZUaTJXSVkwYnYr?=
 =?utf-8?B?bHlibHlBazdNQkJwS0JMREo3VER3REtzM1YvNjdkQkVUZkNSY2FnTnQwZTZG?=
 =?utf-8?B?UmNvVVczcDd0Qk5tdnN6U1B0OHVQSWlpcnlyMHhHVzFPbzJSTTJkckorY3Fs?=
 =?utf-8?B?S2k3RHhsdi9oMWNwaTZiMHR5aEIyeTFZaDZCR0tHWmcyQlVMVEYvTXY4eHlV?=
 =?utf-8?B?QkFvTTlPQU42WVQyM1dOdHc3VzJyaWVVS3Nza2tyTUlmN2M1Z280bWdpY3dE?=
 =?utf-8?B?NnI5ZUk4b1RCektBUHcwUEFMemdCZWE2TkdGeDVoK096VWl2cE1KNEpkcTZj?=
 =?utf-8?B?T3dMV0o5QXhreFJGdTgvZzk3ZGY0UkxqR1hOVlRNZWtDNzU2MjM4Y1B0MitU?=
 =?utf-8?B?NVpkRUg1TDhZd1o1MjA5ZnhpcU9VR01mZVp6aDV3ZkR0VnMzNmxCNDBLOTY0?=
 =?utf-8?B?YjV3UUR6c3NJTTcyZWtGT2Y4TG1sUTBtLzZNT256bTB4cHNQZWpGMWhBdnly?=
 =?utf-8?B?THZwZXVvRms3S1hlYzE4ckxKYWg3WVdxSzEzNVdBaWt0NUVaZUFvWjc4NmdR?=
 =?utf-8?B?dVIxdy9WM3lDQjREQ0prSmxzOXBHYmxhU2xsRkVxRHAvMkQvN3M2K3lQd3lk?=
 =?utf-8?B?SVltOFp3ci9tZlRIUld2QzBFVnV2RmhXVm9kWTJxdTB6NWZGaTFldmFTM0RO?=
 =?utf-8?Q?IIIurRX2ZtRYrMCS48y0IZ4jB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba1fdca-f619-4787-182a-08ddc3beeb0c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 16:44:51.2919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5EDv6slyCOSCrpIZgyvFm+nexcJWdwUQNnrHVaZjgonJ7FEzThArWuqwlzoOlpFJQqwARg6KTCLAbC6Z7C4hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFC855560D7

On 7/14/25 17:41, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> The SEV ASID space is split into SEV and SEV-ES/SEV-SNP ASID ranges.
> Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
> into separate ASID ranges for SEV-ES and SEV-SNP guests.
> 
> Add new module parameter to the KVM module to enable ciphertext hiding
> support and a user configurable system-wide maximum SNP ASID value. If
> the module parameter value is "max" then the complete SEV-ES/SEV-SNP
> ASID space is allocated to SEV-SNP guests.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Just a minor comment below in case you need to submit another version.

> ---
>  .../admin-guide/kernel-parameters.txt         | 18 ++++++
>  arch/x86/kvm/svm/sev.c                        | 61 ++++++++++++++++++-
>  2 files changed, 78 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6305257de698..de086bfd7e27 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2942,6 +2942,24 @@
>  			(enabled). Disable by KVM if hardware lacks support
>  			for NPT.
>  
> +	kvm-amd.ciphertext_hiding_asids=
> +			[KVM,AMD] Ciphertext hiding prevents host accesses from reading
> +			the ciphertext of SNP guest private memory. Instead of reading
> +			ciphertext, the host will see constant default values (0xff).
> +			The SEV ASID space is split into SEV and joint SEV-ES and SEV-SNP
> +			ASID space. Ciphertext hiding further partitions the joint
> +			SEV-ES/SEV-SNP ASID space into separate SEV-ES and SEV-SNP ASID
> +			ranges with the SEV-SNP ASID range starting at 1. For SEV-ES/
> +			SEV-SNP guests the maximum ASID available is MIN_SEV_ASID - 1
> +			where MIN_SEV_ASID value is discovered by CPUID Fn8000_001F[EDX].
> +
> +			Format: { <unsigned int> | "max" }
> +			A non-zero value enables SEV-SNP ciphertext hiding feature and sets
> +			the ASID range available for SEV-SNP guests.
> +			A Value of "max" assigns all ASIDs available in the joint SEV-ES
> +			and SEV-SNP ASID range to SNP guests, effectively disabling
> +			SEV-ES.
> +
>  	kvm-arm.mode=
>  			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
>  			operation.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 77f7c103134e..b795ec988025 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,6 +59,11 @@ static bool sev_es_debug_swap_enabled = true;
>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>  static u64 sev_supported_vmsa_features;
>  
> +static char ciphertext_hiding_asids[16];
> +module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
> +		    sizeof(ciphertext_hiding_asids), 0444);
> +MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for SEV-SNP guests and specify the number of ASIDs to use ('max' to utilize all available SEV-SNP ASIDs");
> +
>  #define AP_RESET_HOLD_NONE		0
>  #define AP_RESET_HOLD_NAE_EVENT		1
>  #define AP_RESET_HOLD_MSR_PROTO		2
> @@ -201,6 +206,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>  	/*
>  	 * The min ASID can end up larger than the max if basic SEV support is
>  	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> +	 * Similarly for SEV-ES guests the min ASID can end up larger than the
> +	 * max when ciphertext hiding is enabled, effectively disabling SEV-ES
> +	 * support.
>  	 */
>  	if (min_asid > max_asid)
>  		return -ENOTTY;
> @@ -2258,6 +2266,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  				ret = -EFAULT;
>  				goto err;
>  			}
> +
>  			kunmap_local(vaddr);
>  		}
>  
> @@ -2938,10 +2947,48 @@ static bool is_sev_snp_initialized(void)
>  	return initialized;
>  }
>  
> +static bool check_and_enable_sev_snp_ciphertext_hiding(void)
> +{
> +	unsigned int ciphertext_hiding_asid_nr = 0;
> +
> +	if (!sev_is_snp_ciphertext_hiding_supported()) {
> +		pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");
> +		return false;
> +	}
> +
> +	if (isdigit(ciphertext_hiding_asids[0])) {
> +		if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
> +			goto invalid_parameter;
> +
> +		/* Do sanity check on user-defined ciphertext_hiding_asids */
> +		if (ciphertext_hiding_asid_nr >= min_sev_asid) {
> +			pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
> +				ciphertext_hiding_asid_nr, min_sev_asid);
> +			return false;
> +		}
> +	} else if (!strcmp(ciphertext_hiding_asids, "max")) {
> +		ciphertext_hiding_asid_nr = min_sev_asid - 1;
> +	}
> +
> +	if (ciphertext_hiding_asid_nr) {
> +		max_snp_asid = ciphertext_hiding_asid_nr;
> +		min_sev_es_asid = max_snp_asid + 1;
> +		pr_info("SEV-SNP ciphertext hiding enabled\n");
> +
> +		return true;
> +	}
> +
> +invalid_parameter:
> +	pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> +		ciphertext_hiding_asids);
> +	return false;
> +}
> +
>  void __init sev_hardware_setup(void)
>  {
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>  	struct sev_platform_init_args init_args = {0};
> +	bool snp_ciphertext_hiding_enabled = false;
>  	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
> @@ -3039,6 +3086,14 @@ void __init sev_hardware_setup(void)
>  	min_sev_es_asid = min_snp_asid = 1;
>  	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
>  
> +	/*
> +	 * The ciphertext hiding feature partitions the joint SEV-ES/SEV-SNP
> +	 * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
> +	 * the SEV-SNP ASID starting at 1.
> +	 */
> +	if (ciphertext_hiding_asids[0])
> +		snp_ciphertext_hiding_enabled = check_and_enable_sev_snp_ciphertext_hiding();

This check could be in check_and_enable_sev_snp_ciphertext_hiding().
That would eliminate having to initialize snp_ciphertext_hiding_enabled
to false and keep all the logic related to the parameter in a single
function.

Thanks,
Tom

> +
>  	sev_es_asid_count = min_sev_asid - 1;
>  	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>  	sev_es_supported = true;
> @@ -3047,6 +3102,8 @@ void __init sev_hardware_setup(void)
>  out:
>  	if (sev_enabled) {
>  		init_args.probe = true;
> +		if (snp_ciphertext_hiding_enabled)
> +			init_args.max_snp_asid = max_snp_asid;
>  		if (sev_platform_init(&init_args))
>  			sev_supported = sev_es_supported = sev_snp_supported = false;
>  		else if (sev_snp_supported)
> @@ -3061,7 +3118,9 @@ void __init sev_hardware_setup(void)
>  			min_sev_asid, max_sev_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> -			str_enabled_disabled(sev_es_supported),
> +			sev_es_supported ? min_sev_es_asid <= max_sev_es_asid ? "enabled" :
> +										"unusable" :
> +										"disabled",
>  			min_sev_es_asid, max_sev_es_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",

