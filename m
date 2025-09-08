Return-Path: <kvm+bounces-57020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7C3B49BB8
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 23:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FF523B2BB9
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 21:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66BDE2DCF41;
	Mon,  8 Sep 2025 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="woR3wgAv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA561FECCD;
	Mon,  8 Sep 2025 21:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757366317; cv=fail; b=uxteRZupvqUFbZejSz3cMhle1GEcJ1sAF8m6N+rkbVNuoaOjNfZ6/PqraK4K+zcQsg8xL8aIAvo0KRAa+xfrhngW4E0k8qfXjxrD/9OYTIlPZBQ9AUTI/Vd1jRSguh7+pJnuBcJMFmbJXwfxUixym4DeoEf7aKJ8XbPB2LM9om4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757366317; c=relaxed/simple;
	bh=Tr9TEt48nRTYTuX+opuSwioQZh5f58JnryupBMIomPw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BSqOI0uiGiFJxRqevmZa8PTTarvTgmu582cPBgVv0ZHNvjar9RKTReE4CQ6mcXMm7qa3iuzBFJoljzk/600Kxkef556eA6E82peizHWIZY7EUtK7xepbqfDYjXDgvOVdMDfnm9lii1S8pmcfFesh3b1OJao12OoQOxlzOWGjp1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=woR3wgAv; arc=fail smtp.client-ip=40.107.102.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9XekhyTBYFFSaR5lx9InMzUaINDujz3TERB8CqnXJzSc9vWAtJgbUN/CYMC2FcOMeJ3ltw3GcSJ8u2PpqLhw0UK5mHJRz2wYRzIYb1cHkrbrn7bdyZ8c48xOD7CnB+KJkoKnTW9qx8wn8rpDvo6mxznZ7wQaXnfymnf2nxteBhDfMWk2tjpCQ0X3SeGHQ4Xr56ROC0sYzfZwWg/tTy1RZT5DiNTqlL897kvphslmjaPo33MTeu/n43DY85e4E9mJKVG5lTJBi+W+2cmCuoRI29Az/1GuTdV7hkH4DpopGXzbqYRiMo8zwiw9boShNfMmT3+A9ZIrbOcyNDHf/HLOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmeZBXqOQYvcQcFPJjX+VSayV4tMXazWM5HpDidHFOI=;
 b=BAqcRzgsUcO1cu5TcUXAn3doDeAJsOPAJ7K9iRbpov/2uySI0nCEhRFAiioL+3U8gyoI43rG0vHO5KMsisv4sP41Votm99iLZ+kz1bi6dIVgDqmN++pie9J2UaR8HY+3ZHE3ays1tno5ZcX7zMUXibyu5SVdqToYmcfivavKbnu5eCvY+j6mASc7/TcHNwKHmk0+ORI8jfCMgRRg6DZxndpjoJcW7fUP2sDJO6MisXfumgvTntyv6JjUYtq4uSnX11PTjZRm7FBYOg0I+qCHVgTDPFt5cdWk3Fr4AxKudNZ6SX+6HZPg4OutDpvFbQB7tQequhKouV2yr2sF/3tltQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmeZBXqOQYvcQcFPJjX+VSayV4tMXazWM5HpDidHFOI=;
 b=woR3wgAv4HVs4edZAzWmcdzDov3i6hGQgSIDdZrb+cPea/miJkIzn5jRIgVkAn5ZNAJmdctTziCkCUZvkiBzZ2lB9uN24t9yhe0XS39cxh/vgpxWg8LnNbvZQ8wLsaI/zK3SSoN7EOP6my6uZIDnebZT6WvNMDTY+EwLFyBohb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6658.namprd12.prod.outlook.com (2603:10b6:510:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 21:18:31 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 21:18:30 +0000
Message-ID: <3c96491c-dceb-2a6d-9c7c-b5faf663a184@amd.com>
Date: Mon, 8 Sep 2025 16:18:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 3/3] crypto: ccp - Add AMD Seamless Firmware Servicing
 (SFS) driver
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 herbert@gondor.apana.org.au
Cc: nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
 john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1755727173.git.ashish.kalra@amd.com>
 <5228c35436be214bd51dd8f141afad311606972f.1755727173.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <5228c35436be214bd51dd8f141afad311606972f.1755727173.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6658:EE_
X-MS-Office365-Filtering-Correlation-Id: df57395e-f063-4719-5e29-08ddef1d4270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTZoVC9va1JQWVBrN210NFF4M1NqOGp0WCs1UStVQU95d2V0cFJHeUp1R0dM?=
 =?utf-8?B?aE9jTXI5Nk5IbUxXT3EraXhkNnVBMDMzSUl2L2lwOCs2NjRPeWVEQnJGVTZx?=
 =?utf-8?B?VTh6OEg2emNDTWFEdVpuYVhOcklndGhmZEdPVE9MRVkzVURnUzZIei9FcUUz?=
 =?utf-8?B?VWZ3OEJaUytXb1k3OUl1OWN3a3gyL2tvYTdPY0x5T2huRGxvamZtWTByemRl?=
 =?utf-8?B?MkpzTE1xTDRENUNXeHRURVo3RG1pc3hvajZ1czh0eno4NldlM1dOOG95bzI4?=
 =?utf-8?B?elRrZWl5VUVrSDVKUzcxVVBtL2ZIZ016MiszRmM0amEwQnhoTHZsVU5aZTBO?=
 =?utf-8?B?N3ZPTzRaNitENWwzV2JxVkJvMnIvRUswaXNuWHVzZDZIdmZXUWR4WkFXeWxm?=
 =?utf-8?B?eHdvS0pFd2s4aGZ5bTM5bWxwMkJiSkRwVm5SSjhkVTF5Y2l1eVVrdUtMa1RV?=
 =?utf-8?B?V2FPVjdyL3Zkdk5mME84MDhibm1NTE5oWWZBNnE0K3QvT2ZMc001NVRtaGZ4?=
 =?utf-8?B?OGRYaVh5Sm1vVTZwK0VIY1pHUEFjc2Jqd1VrVzRWZ2NZeDBTdkJUdm80aFk2?=
 =?utf-8?B?elluSGJGVVBsaGJDcG0vNUpFUHN5Ty9KTDVYclF6eUNIVTYrdHRtNTJXcGRU?=
 =?utf-8?B?VTJ1blNaeWlOZ3ZVZUFwdTNkc212cDlsWnhBOU94YThHWVNLSEVJK0RmbG56?=
 =?utf-8?B?emN4RXBuYkhDK3pIZGpKRG04clJWcXg3ZG9QU3pYeDZERlZkUUYrK2FJZWlj?=
 =?utf-8?B?WFU0SVYxRUsvUSs5cldES2R4all3Z1lTdDhGdm1maFFLYlhkVWVJNHFmT2Vm?=
 =?utf-8?B?QlZheU0vSGswd3kzNW9uVWxtYnNVZlRhMkx1aUxrVTYxNjR2SHZIOXkrVjFP?=
 =?utf-8?B?VEYyejZaSVZWMldSQjhNZk9xa216c3VZUFR5Y0h6Zzd2NWhTT0czOWJvL29D?=
 =?utf-8?B?MlVhUlUxbFRjSVdXOVJiZFdCWE0zdTBjd3pEVWM0VXc4YkRtanRpZGI1dk1j?=
 =?utf-8?B?bDlsMFAxdGZGVFBmT3ZabS84UE1OWGU2NjdZSjhmZDBEYkUvY0hDL3VMaTJo?=
 =?utf-8?B?SUxRaXI0RTFlTC9DWHRWdTJuajJXVjJYNXdPWHc1SllFYXpqcHBGcUpvb1Ju?=
 =?utf-8?B?QkFqdS9YTlU4Vld2dksrazJmUTlMNEhZYnJ1R3RUVlhGbThtWnJIclhxN1ls?=
 =?utf-8?B?YmY4NTBtbWZzRERubGx3MDVmVlZrRnM0MHZaN2lYUFJVS2M3anlEVjYvc2dI?=
 =?utf-8?B?aFZETldpamJpWk5jd3p6OGkxRmpKSStXaFJyTENPazgzaytIWVR6dFdCK1BV?=
 =?utf-8?B?R1VLNGVNZ0FZSVl4anFmanp6amdwWmdYdzBVMjFlMWFVYmIycGhEUUdRUG4v?=
 =?utf-8?B?V3BzREpNQUlseldqcWsyWEdDYU8wYy90ZU9QVjFsZzhyVzFsVHgyU3RaOHRJ?=
 =?utf-8?B?b0Mva2V3K0lhSERCbnBYOXh3TDhNVzE0MEFtZy80b2ZpdW9hVDU3ZU8xaGxQ?=
 =?utf-8?B?TW1JalZ3WnFjZ003MHVpVVQ2MmR4SVR2NzZLWStyR2FzakQ1NHhzN1NQY0xB?=
 =?utf-8?B?eDdWRTFWRHFJbG9Rb2FRZ0xzWXh0b2U2S01sUzhHZVBjK2FTRVh4KzJKYm9t?=
 =?utf-8?B?Qy9IS1VXWjJId3NrdFllWkFSR0hZQVlqMzhWdjBIc3JYc0lvUTFiUEVzR0ln?=
 =?utf-8?B?ODJBc2Y0dWFrZDVwWkFHVldheW1NYWhhOEtRMi9IRGh4QXZKUkxLL0E3aUNy?=
 =?utf-8?B?U2NBSStCN1FTcVdpUUxWMVI0ZGI1VjZ3QVdTNzhEd0pEejdWMXp0NU1NVXE4?=
 =?utf-8?B?KzJHWHVkWktiN2UreFVHUmNRdFZKTVZ4UC9NYWF5SGM5M2M5Ums4Q3p3cEpE?=
 =?utf-8?B?MkkwUE9NazdnYTZiRjd6YXFLVjNybTJvdnY3eFJFRTFIZmJsQmJvUEJldTJx?=
 =?utf-8?B?cDVUbkVEMzlvOUlvOVFlOE9DN0JGQkVQdWN0RWxncHdrMUlIWTZzdGV5Ukkx?=
 =?utf-8?B?M2FkcDZ1bWV3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXU1Z2NoRjdCOWxLTE01MW5hSmVmbFNZR2F1cWMvMWlHTW94aU9pSkRjdCth?=
 =?utf-8?B?b2c5dDdHOXphcmFEa25tYVFSU2R5RjJhQVlJR1dmK3QvZ0l2QldkUDZiM1JU?=
 =?utf-8?B?VHhQc3k1dEQxYWIyU1p1bzRpSndseERHSytwSHJXSmxZWnFVOHVGSENiSllE?=
 =?utf-8?B?aTV4K2RiTGVkZDFJVVRwYWJJaHlsN1VsazY3R3VZWTkyYlduQ1pRK1pTWEI2?=
 =?utf-8?B?aVhENTBLaXYyVXk1K243VDR5cmlwSnFUS21Db25ncGVqRHZTTHNjeFR6Mlc0?=
 =?utf-8?B?ODIwNnpMYUVxVytVQmtQVE5GVDMxdjl3MCt0WExmUitmMkxoUXFRVUxpbWpQ?=
 =?utf-8?B?V3JSYjNXNkJlekY2cTNjWE9FZUFEMnlQK1liSGE3UFRWRGR6SlgwaXlyZHdx?=
 =?utf-8?B?cHViaWg5cmtSSHlyaVlOK2p2Sm9pbHBnbXhXM1N1Z1J5UUJJVEVMb2JZWU9C?=
 =?utf-8?B?K0hKNENXelRzcXlndG9lL1JPNTVaU3hjdlVlUHJlaENIcFhUeDlIb2xaRFF1?=
 =?utf-8?B?UXhPUXkrd2V1Rm1KZVdEOHY2ZUNnTWF4dlNsblhSRE90ZktmZHFFelNxYURL?=
 =?utf-8?B?aVl1UHFaOHhHMFJRZXJFVEV5eGhWZlN6OWw3b3FSbENsTndmR04yZkJQb3Fu?=
 =?utf-8?B?MDhqWWliaWRiK0VISmpxaHM2Q3gvcHp0ZHlqajFUYnVIS09ER3Z1QTgwTzZn?=
 =?utf-8?B?ODEvV2tpcmF3eDluTzVJb2xJUEx0S0tOQldJL09VZ1Awd3JMVmdYN09ZbzM2?=
 =?utf-8?B?RjNSMlkreWNZQWtZejlpU3ZXM25STkh1QjM1MXNsaHQ5WUI5M05zcmxtQy9U?=
 =?utf-8?B?ZzVwUWJTNzl3eW9qRHpzME4yaDFlajJEWWFiTWRhUUFLTTU3QlFDWDFjaW93?=
 =?utf-8?B?bUNRRGxvR1hUdG9XT3hqOU9RaUdoeS90OXR3YjJ0L2RHeVVVS3VMVlNtRlZt?=
 =?utf-8?B?OHljYUJuMTlRYUowdWNhWVp0eGJzMVk0QWk5ME8rcFM5eUNuclRzNmRpdnV0?=
 =?utf-8?B?WlpheVYxZlk1VzEzRlJZdXZiZWJyOFhDNjVrRzBFeHhKUDdYQkszY0daNHBN?=
 =?utf-8?B?dWVVRDNHTGhZQ3JpVE5uSm9qZ3VyeHBiOUhydTVvWms0S0JaYkcrY3J4UGJn?=
 =?utf-8?B?TlJFYXFhNWcwcy9wU0hBUDVFT1dpeENEaE00T1AvOTIwRzl3YkhsRm1MVkVa?=
 =?utf-8?B?TE5taE1JLyt4UnpwZk9sa2dCWkgzTnRDcG55YUNlK2tQOCtsdzlYL1VNeHdm?=
 =?utf-8?B?NXlVTmJGenJER2xpMGdyb3hwZTJkZGhNaWVEVmUyRjZsT1RBcXlNeGJCNFRB?=
 =?utf-8?B?RmVhazAvUDJaU1Vva1pJWEM5RnJvQmhkY05xR1ZkWFVLMkpmSkFEMmdOa2lR?=
 =?utf-8?B?V1NWZnNibitVTDd0Z2JpajVsS1lIbGlSaWxLUzVmM1NISFdBU09mby93c3da?=
 =?utf-8?B?bUR5cXlIT0J1RmJKVU11V1g3WHQ5K3Y1SHVJOFdJUkJSazdoTGJzWTFsUWxB?=
 =?utf-8?B?RkdYTVBRWXozNmZYYnpXV0lVS1VYSHgra1VleldpMWhJcWRCWW9oUjU5MlZJ?=
 =?utf-8?B?WG5JcWJleitQRlh4UjhYR29NYnBvZlZyeTI3ejRHMXl4RWd2UWpXZkhyL1lq?=
 =?utf-8?B?Q0tzUXdxSklpODlIZ3pkYlVlUmllT096QVZ3dlpqWmp2Sy9kNEZjYXhVOXJK?=
 =?utf-8?B?OFdmQktySzN4S2JpblM0cmFiZ1p5cytyTU04K2haL0Q5Ty91RWJyd01rdEM0?=
 =?utf-8?B?L3VHVVlXQWhuQk5QZ1RWbXlhazhoaUFPRzlubXIvaTR1SFd2eTdidk1hZWZU?=
 =?utf-8?B?eEZ6N0hIUGc5OXJzc2hTbW1QTkRzYzViUTdKVUp1YmFlUU9UTWFkY1lnYVhD?=
 =?utf-8?B?bjBLUjc5UzF0TlVGUURwdGNxMFplYnN4MGsvRmkwcXR3QjRxOTBySE0rKzdz?=
 =?utf-8?B?ZEFXbHhER3A2L1lDVmYvMTNTd3N0RUFqK0dxWnNzVUJhaHg2Yzg1MDhlZDd4?=
 =?utf-8?B?dStRcS9Va3N0QlA3UnNhT2JUdVBaZTN2cURwQUI0OGZqUW5MYlIxU3g2VVI3?=
 =?utf-8?B?YnBZN3kvRlVzWWRnUnhsQUQrTlhFK1BpNXpBUUZrcVN2eDc0bmVZMjhFRmpL?=
 =?utf-8?Q?rPMIN263JtjT0jBrIoiurTcgC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df57395e-f063-4719-5e29-08ddef1d4270
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 21:18:30.6258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URNvVeP2KuRPPFRms6sYVAT9nRKN0BWDcMt5Zpfo+WT7Nc0zpR5He99Dvfj2yeUCTHjknFBEWgZlagDpiQ3mfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6658

On 8/20/25 17:19, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> AMD Seamless Firmware Servicing (SFS) is a secure method to allow
> non-persistent updates to running firmware and settings without
> requiring BIOS reflash and/or system reset.
> 
> SFS does not address anything that runs on the x86 processors and
> it can be used to update ASP firmware, modules, register settings
> and update firmware for other microprocessors like TMPM, etc.
> 
> SFS driver support adds ioctl support to communicate the SFS
> commands to the ASP/PSP by using the TEE mailbox interface.
> 
> The Seamless Firmware Servicing (SFS) driver is added as a
> PSP sub-device.
> 
> For detailed information, please look at the SFS specifications:
> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/Makefile         |   3 +-
>  drivers/crypto/ccp/psp-dev.c        |  20 ++
>  drivers/crypto/ccp/psp-dev.h        |   8 +-
>  drivers/crypto/ccp/sfs.c            | 302 ++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sfs.h            |  47 +++++
>  include/linux/psp-platform-access.h |   2 +
>  include/uapi/linux/psp-sfs.h        |  87 ++++++++
>  7 files changed, 467 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/crypto/ccp/sfs.c
>  create mode 100644 drivers/crypto/ccp/sfs.h
>  create mode 100644 include/uapi/linux/psp-sfs.h
> 

> +
> +	/*
> +	 * SFS command buffer must be mapped as non-cacheable.
> +	 */
> +	ret = set_memory_uc((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
> +	if (ret) {
> +		dev_dbg(dev, "Set memory uc failed\n");
> +		goto cleanup_cmd_buf;
> +	}

You should restore the memory attribute before freeing it in
sfs_dev_destroy() and below in the cleanup.

Thanks,
Tom

> +
> +	dev_dbg(dev, "Command buffer 0x%px marked uncacheable\n", sfs_dev->command_buf);
> +
> +	psp->sfs_data = sfs_dev;
> +	sfs_dev->dev = dev;
> +	sfs_dev->psp = psp;
> +
> +	ret = sfs_misc_init(sfs_dev);
> +	if (ret)
> +		goto cleanup_cmd_buf;
> +
> +	dev_notice(sfs_dev->dev, "SFS support is available\n");
> +
> +	return 0;
> +
> +cleanup_cmd_buf:
> +	snp_free_hv_fixed_pages(page);
> +
> +cleanup_dev:
> +	psp->sfs_data = NULL;
> +	devm_kfree(dev, sfs_dev);
> +
> +	return ret;
> +}

