Return-Path: <kvm+bounces-17576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BDB48C80DB
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 08:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DCD3B21920
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 06:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72DD14003;
	Fri, 17 May 2024 06:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sj4np+7k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1924125C7;
	Fri, 17 May 2024 06:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715926725; cv=fail; b=HOfIT1V9bykQKM1LHJB28vVKNsLDZpGTcQRZS5bLcovYwft4rDYQQFN19r9aBbRg+thNKNnfXaL0B2MZALh03BN/LoQ2sdYL3JrBYMkx8arHAOoLHpnD79ZJ6RKHx/dvxFEWQ2gA1ID5LjftqsNk5EtsHPzK6UTTTcUtUhPLkGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715926725; c=relaxed/simple;
	bh=+YZfgFPNhyZUgTDM5VFkviAKayEZg9huJneYREbIpkc=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZNdJkIJtK6qsTUkNxNiv+qwmVK/alLScX9moFYkjlhEjsvf3xbKIPlnT7UHgZS1mGcB8/DTOGDI048OOqgcod3A7z9qKmR0yn0tc3Vn8yT7KEmvu0jnkFT5zDV/4E66hfyh+S3/jwhMFSwERpGe3uJGs0oYOWFdKdoaCq55emGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sj4np+7k; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jz04VBXuLX7L4V+/AMjzncuTYwSSced61Z7yTpVKOGE92jCS1IRQ6Mv0IH5mODnF0uRK2A1EkMqkYkg8t8zEXoXO9gs9ZgqJFnEh95oIfyyACIJJzKEcRtrdT/v7w2C929LHJ3PWMMxf3bulxw5spavgdvlHLgx0ipZghvLbijnwcPkMRYlawkFvHFNHwO+96WzY8Jb+kX1WM4ln8WdyLIcQ9MyVE9rx+VpGa7+u+sur6ffwBeNISAZIbXVM9xgh/tFgPac5OBc12JWQKNwYk5/3zepy3Jm4LG8hMUzawWm326X4muHlB4zZhVzTpUfJvlPClhsOfP5dytII1nYIrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9265+oHSJ5RID2bpAHeomSgX64K3DM56mz2TGHqOgM=;
 b=elh1R2p9N6yxeA/Vm4xCv66LdaSGVt6Geihv08nm2i8F6tVTp3jNQhMld2ge48V9n0p6LmG1Sm6fjIA7eYszA1ABbR31cSsakIw0CgVwV8DVWreEx5t7NRzRDh/SVqrlgjw6CV0v/SkRCYuoTd6bswp5AmPtQIkLB76SvjoxySkDyUqKO9rhik4y2gCBdFjjEgp9stagPj47hR7nUBoiFeXuDWKoi9Q7iBH9L5P1+HhpNTVBTvVa+7KADO1aembEk3KjQA1n3iF1lSXRnmfzQQ8irrMiBk2oxoboCQ2l6/hzQAC82QYlhO9kuVXiaS+jtT054JhgtjUKOtqJE0n5TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9265+oHSJ5RID2bpAHeomSgX64K3DM56mz2TGHqOgM=;
 b=Sj4np+7kP344Y5SQ095ZMpxe7nwe15BBV4bnjimB45/QQYM9hTDGvaT9rhqF0iic2wiUMlsl6by3FcYJlDmYik0AFvINA3F3Htqn7WyhRw5xFl18oC4oq6GWNSe05v88gSdFyI3xk4FguNmrk/BYDEHiENMlTb8hX8NHasXZJDU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by PH0PR12MB8050.namprd12.prod.outlook.com (2603:10b6:510:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Fri, 17 May
 2024 06:18:40 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7544.052; Fri, 17 May 2024
 06:18:40 +0000
Message-ID: <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com>
Date: Fri, 17 May 2024 11:48:27 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240416050338.517-1-ravi.bangoria@amd.com>
 <ZjQnFO9Pf4OLZdLU@google.com> <9252b68e-2b6a-6173-2e13-20154903097d@amd.com>
 <Zjp8AIorXJ-TEZP0@google.com>
Content-Language: en-US
In-Reply-To: <Zjp8AIorXJ-TEZP0@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0151.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::14) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|PH0PR12MB8050:EE_
X-MS-Office365-Filtering-Correlation-Id: 40d1a22b-31ec-47e8-067d-08dc763931bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTBTYmZxZWozUG9sMStYSzREK2t3ZlI4YklMUjgrNVdWRDZocTRmTnFTakRV?=
 =?utf-8?B?d3ZDNFQxVGlmckI0MWE5ak1FdWZldTBZSE9RYlc5Q0d4L1VyMFd5ZEM3MmM4?=
 =?utf-8?B?cVY1QXE2Z0VBY21XbTVPTEp3YTZXbG5tVlA5RnpzRUNaaUtsR0FIUXNuRGJR?=
 =?utf-8?B?ckZXNGhxVVpkWVZOQkVXZ210NmlybUV0TUR6OGdLdkNrTHQ3VkZ2YlY2U1d3?=
 =?utf-8?B?S2dDS0lPS29SeDdXQ2NaempHNDlTSWxoWnNUSlA5dC90L0JlTHA1Sk1Nb3Na?=
 =?utf-8?B?MVc4OW9mSHdJNTFQN0VaNUtrKzhIMTFoWGZnM0xvaEI5OFdBd2JhWlZjUmpU?=
 =?utf-8?B?UStUUkpSQk56UkJSSXVCc2hTQUJDRWYyUVVDYXNFd1V6RHE2ZWYzM2VCOW03?=
 =?utf-8?B?bld3ZWJoSlVKZ2VPelNua2x5aXdPQ0dyOVNzSDE0T1VCRnVLbG5WY2pvRXl5?=
 =?utf-8?B?VVBxT3hPdTdud3RYa1M2WWl2MEpXOEQ4ajRjczg5NnNHQWI3NXdDSU9YTVJM?=
 =?utf-8?B?MWJ0bmdJS2FRbEtUQ0hQMHhxZ1pwZXlYWmdhYUlIb1ByL1c3WlBac2RscUdm?=
 =?utf-8?B?L3krdngxRVVKRFd5b2VRRnNZbWlwZnpWaXZzVnY1MiszcjVGalJCVGZzaG01?=
 =?utf-8?B?WWZYL0c1Z0FiT1FrOWhUY1hpOHBvMUFJdFFXL0ZZb1pVOWFoVDk1UnZnTFlY?=
 =?utf-8?B?UXM3WStRVTNFalNJTk90MlNCb2VGNTluWk50NHRqTHBHR00xcmNFZHRsZ1dO?=
 =?utf-8?B?OFp4cnEzYUFLMnBnTkJVUVIxb2RpNHovZGRVTEZXRnpaVktMMXloNW1SWTlo?=
 =?utf-8?B?M3U5TndZR0pmYmQ3bVo0WFp2WkcxOTd4eGJ2eEZ4L0RwbmdsSVZ6THJCTGo0?=
 =?utf-8?B?THBqaTRja2FPY3k4N1EvVmxWQUJWbWhPNDkzYklxT3A5ajVEYzJobUxad1pD?=
 =?utf-8?B?K2xQZkltdlFmU0NaMkVtWTFMUjRMaFZZNVVjVmpTVThNUTBXNW5ENzdlODl6?=
 =?utf-8?B?TlZwdHRzZ294Y3FWTDBEVWRsbEs0RUgrVSt2Q0pIYkZ2cE5idE5vUzljbi9x?=
 =?utf-8?B?TGQzUGk3cHVNckw1RTN6RkovK21DYmxpWWJtQ3o5cmVMSGRqZFZYTXRhaVpu?=
 =?utf-8?B?dDdIVUFYNG9oRTkzNFRkNHJBcXRPQnNtck5qWUxkeWJFaGNxNXM0eEJKZXFF?=
 =?utf-8?B?aGxqb2tPaStmcEQ4dFNBaUlGb1hmcmlnZGgzY2pqcU1VUytBZXlzMCt3Umhz?=
 =?utf-8?B?VXU4L09NSXhXVVdhY1Y2dUVIdnBjOUc5Vm9mUE1JeU1neVZCU0NNMktXbDNU?=
 =?utf-8?B?T0F6aGpEbGV0TkVxcytBLzVSNG9Sb2JYRVVpOHgwWmdaSTJQV2VYbk0xRXlz?=
 =?utf-8?B?a2hPWGJXc3lxU1laUlJMQUo4UmkydVZyVkpicVRLZmpPei9iQUZaaGtXbjlU?=
 =?utf-8?B?U0JhMzZReHNHWm1Da2t3ZzBFcjNNM3NSWDhybkYvNCtCaVZqWWNFWmdUS0l5?=
 =?utf-8?B?elZOcmtPTHJGTHVkSUdrbFQ0T0pVTlVBaEU0M1dlNTdmcXVHMVpQa0d3dWY2?=
 =?utf-8?B?cnhsb0lTUy9NNStObTNjVmNJY1AydlJGNGJMZlZ3NlZuRkdnWWk4OE5xNTJw?=
 =?utf-8?B?M05XdVJNUU81TzlpR1BCVWtLd2FQRUlTM3B2ejVpYWxxNUxMdnZ6dGorWHdY?=
 =?utf-8?B?dDBpK2lwOUgvbHNlZUFhMTkrM2piaHBTMStsR3BselZHeVQwUmt1MkVBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MExPbDEyR2VwaDZxc0tMYmt1WW9PTUVsaWdoQ3hZc29semR0ZTlucTlCWktD?=
 =?utf-8?B?bStnTmVIRjJGU3ZQbTRNSjdBR3NQYzl2TUVEN0FHT0VWK3FZSlZvRXdMRC9F?=
 =?utf-8?B?WVo5d3hsVnR1dGd4Q0k1MG1SeHhOUjBGdFdiQUdEUlZRRmxML3J4QlkrWnkv?=
 =?utf-8?B?S0hpUTRGYThLVk9lNkREc21GMDNUdGIwZEYvUys5SVR5Q013akhmVnQyYk1Z?=
 =?utf-8?B?RVVtSUVSQkNOdVdOekN5eS9ON3NYbWV3Y0F5RjJ0bGlEMEpNRWJ0cmhmT0VE?=
 =?utf-8?B?UERNSkowQTk5U29Qb0RFYmk4eDhwdDRZSSt4d2JjTzlQbTdpb2NMRVZaazNF?=
 =?utf-8?B?MXBWSnU1NHVuTkFtRGJNaVE1MDg5aytKdlJYNkN3dWlBeDFhenNrUkFVbE12?=
 =?utf-8?B?aDExUVh2bjFnZmo1VUg5OWN1Z0hyVG5zVVovUktjMG1mQ2xtUm5pbmxCcmkx?=
 =?utf-8?B?TzVtWE1TK1k4QkEwL2w1bmd6aXNtUlBZUWJRK1d1ZGNPeVcxZk5vMHdUOEls?=
 =?utf-8?B?cTdRYk1QVnZldkQrRmEvU1lCYjk3MjdJNkhqZngyV2lvSXdrbEh6QjcySTZJ?=
 =?utf-8?B?RklEeDVWMVJhNzFPaHZCSmxQOFZpTkFzZkN3ZTVyRlNtSGdKTmhidm1XQkZ0?=
 =?utf-8?B?MEVUR1hpcVJycy9ZMzB2VkpJZWU1QjI3OWhyUU11cVRJS09SV0picm9MSWhR?=
 =?utf-8?B?ZW52eEdOck9jZHhTY0cwd0dvUUhMOGZJb01td3hQSkZaN3FGTjlBRkk0c043?=
 =?utf-8?B?N2JRejR6SlRVYWNxY2ZHZzJjYUFPMUFLUHgyaXlZYmwzT0xVcldpMzZHdWV0?=
 =?utf-8?B?K2dSSDVJMGRqTjZvcGxWenZ4WW44ZDFNZ3ZSNXVjVUEzajhDNjYwZk5iZHFm?=
 =?utf-8?B?cEFTWkt2T3lxTXNxYWhETUJzZUJSZ3RESHh1ZzQzc0tpY3l6eDdZUStiYmFh?=
 =?utf-8?B?WmZESEd2R0RZYnlsTEh4dTlRNmd4VVJUSVh6TGM3cENUcVl5QWd4akZvanhm?=
 =?utf-8?B?Tjk3Y3R3T0I0elpUVW9ZWVlZTXptUUFOaTRsazFkUjNYYUxMQmpqRFUzdml6?=
 =?utf-8?B?cVc3U3UzV0lZaVNGM085TDRCUEJlanJWaFNOR2lvZThCcnY1Yk5rMDdtYXly?=
 =?utf-8?B?eklpVkpXcy8vUnZsNlAwcUs3aDkwaVFFK2tsU0lQbnJvNEpIRTMvcHBMZEk3?=
 =?utf-8?B?NUI0bWg3bVRacy9ORnpSeC9LV0VJT2JTVmdWZWhKMVdBL1E3Vk1idktOQytR?=
 =?utf-8?B?Q0pnc21mUktmSVFFZ2xySUtoNENLTHBDeVJVN3JLYlNGSlg1UzNlZ2hYN3Vv?=
 =?utf-8?B?OEEyaXV6YWZ4cDhtTXVzbEFDSThFUGJZaEQwK05sRWd1Y1VUWW1HdjR4cEtX?=
 =?utf-8?B?UkZzcWpGQ2hTQzhZY1NWbStpeDFraHlYU3ArREN4UFIwR3UvYzRyYlZIVXFU?=
 =?utf-8?B?NXpmRnoxVVVsWXc1Y1Z6N0FQQ2UwL0ptaUxiZlhybis3TXk1SytuQVNMQlF5?=
 =?utf-8?B?TitNSGpTOFZDa2xtczRqclRHUEdBRGNQRW5LVW9KQi9SU2pUMmJBRHpjQmxV?=
 =?utf-8?B?OGFQZy91czZKcm05WVNFWW9pUVdvK2QzczF2UlNBckt3ejlZQW9sRDR4d3pq?=
 =?utf-8?B?MWdaQ0NBQXJXK0w4RUlKYjNCMlFZYmNmeDdEUWZHRWpaVmk4WGhTa21HUHRl?=
 =?utf-8?B?cnlQa0R5Zjg4ZXphZVZKd1pUb0VuY3RDWkl1SHo4cVNnTzd0ek9PaXY1Z296?=
 =?utf-8?B?NWxJajRmRDgweVdNMW1LOFY1cnlld2N5U1hyZUs3aHBzMHlTYVNoSi9Fa1NW?=
 =?utf-8?B?blg1ZDlKaVRkZVNrYS8zRGs4MGhBMW83Y1BUdnZYQ04xaVl1SzhsNkR3L0pY?=
 =?utf-8?B?OHZKMDhQRThhUk1LMUhSOFVpRDFzNThOT0tDdmdoQTl1TTkrZE9Db3ZvZERR?=
 =?utf-8?B?b1BybG5neTR2b3RVUUFJYmtQZ0Z1RXI4UnkrZjYwQmpqYkR6TUg3QU9ueURE?=
 =?utf-8?B?VnFnZG5oVlM1WlN3R3pteUY0WFJrcUdKM3JXSlcvVTZwZHJQalNrVjRlT1dr?=
 =?utf-8?B?MHpyN2M4eUMvTDJYdnRSSjdsOEM2cC9kbXJrbFNlTFZSa2FXUEU4ODNxRWR2?=
 =?utf-8?Q?pmmuQHu/0eeZACPFlTuS7WlOn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d1a22b-31ec-47e8-067d-08dc763931bd
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 06:18:40.3094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tw/2sKr2rvZAjTUFQI6AVS/yY7ySdZK5h2mSqcNJ6yFU8O4KHl5FJ4hECPP9wZVIgIji8CpFDZuP6s6LpyE3+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8050

Hi Sean,

Apologies for the delay in reply.

On 08-May-24 12:37 AM, Sean Christopherson wrote:
> On Mon, May 06, 2024, Ravi Bangoria wrote:
>> On 03-May-24 5:21 AM, Sean Christopherson wrote:
>>> On Tue, Apr 16, 2024, Ravi Bangoria wrote:
>>>> Currently, LBR Virtualization is dynamically enabled and disabled for
>>>> a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
>>>> avoiding unnecessary save/restore of LBR MSRs when nobody is using it
>>>> in the guest. However, SEV-ES guest mandates LBR Virtualization to be
>>>> _always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
>>>> guest, in fact it results into fatal error:
>>>>
>>>> SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1
>>>>
>>>>   [guest ~]# wrmsr 0x1d9 0x4
>>>>   KVM: entry failed, hardware error 0xffffffff
>>>>   EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
>>>>   ...
>>>>
>>>> Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.
>>>
>>> Uh, what?  I mean, sure, it works, maybe, I dunno.  But there's a _massive_
>>> disconnect between the first paragraph and this statement.
>>>
>>> Oh, good gravy, it "works" because SEV already forces LBR virtualization.
>>>
>>> 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
>>>
>>> (a) the changelog needs to call that out.
>>
>> Sorry, I should have called that out explicitly.
>>
>>>  (b) KVM needs to disallow SEV-ES if
>>> LBR virtualization is disabled by the admin, i.e. if lbrv=false.
>>
>> That's what I initially thought. But since KVM currently allows booting SEV-ES
>> guests even when lbrv=0 (by silently ignoring lbrv value), erroring out would
>> be a behavior change.
> 
> IMO, that's totally fine.  There are no hard guarantees regarding module params,

Sure. I will prepare a patch to remove lbrv module parameter.

>>> Alternatively, I would be a-ok simply deleting lbrv, e.g. to avoid yet more
>>> printks about why SEV-ES couldn't be enabled.
>>>
>>> Hmm, I'd probably be more than ok.  Because AMD (thankfully, blessedly) uses CPUID
>>> bits for SVM features, the admin can disable LBRV via clear_cpuid (or whatever it's
>>> called now).  And there are hardly any checks on the feature, so it's not like
>>> having a boolean saves anything.  AMD is clearly committed to making sure LBRV
>>> works, so the odds of KVM really getting much value out of a module param is low.
>>
>> Currently, lbrv is not enabled by default with model specific -cpu profiles in
>> qemu. So I guess this is not backward compatible?
> 
> I am talking about LBRV being disabled in the _host_ kernel, not guest CPUID.
> QEMU enabling LBRV only affects nested SVM, which is out of scope for SEV-ES.

Got it.

>>> And then when you delete lbrv, please add a WARN_ON_ONCE() sanity check in
>>> sev_hardware_setup() (if SEV-ES is supported), because like the DECODEASSISTS
>>> and FLUSHBYASID requirements, it's not super obvious that LBRV is a hard
>>> requirement for SEV-ES (that's an understatment; I'm curious how some decided
>>> that LBR virtualization is where the line go drawn for "yeah, _this_ is mandatory").
>>
>> I'm not sure. Some ES internal dependency.
>>
>> In any case, the patch simply fixes 'missed clearing MSR Interception' for
>> SEV-ES guests. So, would it be okay to apply this patch as is and do lbrv
>> cleanup as a followup series?
> 
> No.
> 
> (a) the lbrv module param mess needs to be sorted out.
> (b) this is not a complete fix.
> (c) I'm not convinced it's the right way to fix this, at all.
> (d) there's a big gaping hole in KVM's handling of MSRs that are passed through
>     to SEV-ES guests.
> (e) it's not clear to me that KVM needs to dynamically toggle LBRV for _any_ guest.
> (f) I don't like that sev_es_init_vmcb() mucks with the LBRV intercepts without
>     using svm_enable_lbrv().
> 
> Unless I'm missing something, KVM allows userspace to get/set MSRs for SEV-ES
> guests, even after the VMSA is encrypted.  E.g. a naive userspace could attempt
> to migrate MSR_IA32_DEBUGCTLMSR and end up unintentionally disabling LBRV on the
> target.  The proper fix for VMSA being encrypted is to likely to disallow
> KVM_{G,S}ET_MSR on MSRs that are contexted switched via the VMSA.
> 
> But that doesn't address the issue where KVM will disable LBRV if userspace
> sets MSR_IA32_DEBUGCTLMSR before the VMSA is encrypted.  The easiest fix for
> that is to have svm_disable_lbrv() do nothing for SEV-ES guests, but I'm not
> convinced that's the best fix.

Agreed, 1) KVM_GET/SET_MSR for SEV-ES guest after VMSA encrypted and 2) the
window between setting LBRV to VMSA encryption, both are valid issues. I've
prepared a draft patch, attached at the end, can you please review.

> AFAICT, host perf doesn't use the relevant MSRs, and even if host perf did use
> the MSRs, IIUC there is no "stack", and #VMEXIT retains the guest values for
> non-SEV-ES guests.  I.e. functionally, running with and without LBRV would be
> largely equivalent as far as perf is concerned.  The guest could scribble an MSR
> with garbage, but overall, host perf wouldn't be meaningfully affected by LBRV.

FWIW, AMD has multiple versions of LBRs with virt support:
  - Legacy LBR (1 deep, No freeze support on PMI)
  - LBR Stack (16 deep, Has freeze support on PMI).

Both are independent and perf uses only LBR Stack.

> So unless I'm missing something, the only reason to ever disable LBRV would be
> for performance reasons.  Indeed the original commits more or less says as much:
> 
>   commit 24e09cbf480a72f9c952af4ca77b159503dca44b
>   Author:     Joerg Roedel <joerg.roedel@amd.com>
>   AuthorDate: Wed Feb 13 18:58:47 2008 +0100
> 
>     KVM: SVM: enable LBR virtualization
>     
>     This patch implements the Last Branch Record Virtualization (LBRV) feature of
>     the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
>     be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
>     there is no increased world switch overhead when the guest doesn't use these
>     MSRs.
> 
> but what it _doesn't_ say is what the world switch overhead is when LBRV is
> enabled.  If the overhead is small, e.g. 20 cycles?, then I see no reason to
> keep the dynamically toggling.
> 
> And if we ditch the dynamic toggling, then this patch is unnecessary to fix the
> LBRV issue.  It _is_ necessary to actually let the guest use the LBRs, but that's
> a wildly different changelog and justification.

The overhead might be less for legacy LBR. But upcoming hw also supports
LBR Stack Virtualization[1]. LBR Stack has total 34 MSRs (two control and
16*2 stack). Also, Legacy and Stack LBR virtualization both are controlled
through the same VMCB bit. So I think I still need to keep the dynamic
toggling for LBR Stack virtualization.

[1] AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
    2023, Vol 2, 15.23 Last Branch Record Virtualization

> And if we _don't_ ditch the dynamic toggling, then sev_es_init_vmcb() should be
> using svm_enable_lbrv(), not open coding the exact same thing.

Agreed. The patch below covers this change.

---

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 759581bb2128..7e549ca0a4e9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -666,6 +666,14 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	  return ret;
 
 	vcpu->arch.guest_state_protected = true;
+
+	/*
+	 * SEV-ES guest mandates LBR Virtualization to be _always_ ON. Enable
+	 * it after setting guest_state_protected because KVM_SET_MSRS allows
+	 * dynamic toggeling of LBRV (for performance reason) on write access
+	 * to MSR_IA32_DEBUGCTLMSR when guest_state_protected is not set.
+	 */
+	svm_enable_lbrv(vcpu);
 	return 0;
 }
 
@@ -3034,7 +3042,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
-	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
 
 	/*
 	 * An SEV-ES guest requires a VMSA area that is a separate from the
@@ -3086,10 +3093,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Clear intercepts on selected MSRs */
 	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9aaf83c8d57d..4a8bd32dfa96 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -99,6 +99,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
 	{ .index = MSR_IA32_PRED_CMD,			.always = false },
 	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
+	{ .index = MSR_IA32_DEBUGCTLMSR,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
@@ -990,7 +991,7 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
 }
 
-static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
+void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -1000,6 +1001,9 @@ static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
 
+	if (sev_es_guest(vcpu->kvm))
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
+
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
 	if (is_guest_mode(vcpu))
 		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
@@ -1009,6 +1013,8 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
+
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
@@ -2821,10 +2827,24 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 	return 0;
 }
 
+static bool
+sev_es_prevent_msr_access(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	return sev_es_guest(vcpu->kvm) &&
+	       vcpu->arch.guest_state_protected &&
+	       svm_msrpm_offset(msr_info->index) != MSR_INVALID &&
+	       !msr_write_intercepted(vcpu, msr_info->index);
+}
+
 static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (sev_es_prevent_msr_access(vcpu, msr_info)) {
+		msr_info->data = 0;
+		return 0;
+	}
+
 	switch (msr_info->index) {
 	case MSR_AMD64_TSC_RATIO:
 		if (!msr_info->host_initiated &&
@@ -2975,6 +2995,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 	u32 ecx = msr->index;
 	u64 data = msr->data;
+
+	if (sev_es_prevent_msr_access(vcpu, msr))
+		return 0;
+
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 33878efdebc8..7b2c55dd8242 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	47
+#define MAX_DIRECT_ACCESS_MSRS	48
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
@@ -543,6 +543,7 @@ u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
 void svm_vcpu_free_msrpm(u32 *msrpm);
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
+void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
 
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);

---

This is just a draft patch. I'll add logic to bail out SEV-ES guest creation
when LBRV is not supported by host, remove lbrv module parameter etc.

Thanks,
Ravi

