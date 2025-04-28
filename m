Return-Path: <kvm+bounces-44575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5509A9F2CD
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BDC93A935C
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 13:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBEF26AA89;
	Mon, 28 Apr 2025 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Yyc4v3lK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5833126158D;
	Mon, 28 Apr 2025 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745848500; cv=fail; b=u77RSW73clX2s/aIi3Mx6pe29dQbnY9iNAKqbcseUxNcCYxcKqPCmOIw9WjoGyNY5rp3CNaVN5ihkZt7BTiF4VT0PuUXhz+VxAm2eLPtt4kSPgosLyI/X+aG8YvV3iYW+GIMEbXeaRhB4ldWH1Zq9R1fB8Sfeejro5mym+q9C0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745848500; c=relaxed/simple;
	bh=RdxqCTq2plqynh6U3tdRjM16g6Vpr3VOxfhLT7m4sfQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fQ+/Lm3kI9Jh5shyDpJa/LnGuEfBVypxEdQiWK0WI91tLrZ2g60xiZCO1aXtU7bybnJvFm0bA3X7qB6dhzXq53qmPkRb5C4g6FSxZ3bzd/srrjRQu1llGaO9205/M2CcTOvp4uDKNAjx6CfN2IgvGmOTVcCiJZleu6Y7nHOp4Iw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Yyc4v3lK; arc=fail smtp.client-ip=40.107.236.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KJhYAhnGDdGDg8N9IKUAkUsraRj96FlhIz7oqm+8bC+Tc/d+zPrUJRyfnSq6RGABiTsbS75BajIazwOPP+XQEcGzNUfgGCveTWbSJgMe0AX5hQg6N5egkl3Y6p9sfeHdgOl8oZBO6hy5NbF3/JllVN6dn/jqgdmbVcK+0pPeBM2tDrxn3wEarv2ioWXvfAAID0bLodcdER9ObFpQ1CfvR8IzZWHDO4vKc3FPOkSgWdt5C1SYgGX44so+gQF55CDSWq9C+hme+tal08BCM8ei4mPaV4S0HsY1Q21IsqP/7zSMA/JtHFFh6w1YkRPYB37fy+7vJA5We39q/JoNHo62tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ueHCRFX0jP3bpz7Ri/uMZKuqUVtF7a2LkaEXeqVk7M=;
 b=Dgz862hso8b4/RgHo9bfsIJOjCTQra5a91f9TVETxwvq6FfrlcHyjY3TY59Fa2hG8loUH+LI8IHgADFvXX6TOJ4CyLXYpOXbsi8SKCh3Do37ChEvEHRK8exFUYUXiS05LVVhFU1HuqOZZ9WLW1ftbaVEepqYoS6aVz2/0xyrLJfz08rEp4xdbykSQc6fQRdh8UV3w85601urMNSGbZnEe3nyRvCPGAL7G4ssPZ3GDkADVvqZ8/50ZIGaZs5D3VMLB2yBIMPEmsH1j3yOScZ8/CsJBbvnNuskbJbo6uwGRMlIY7MVtbFfP1yX8EAPnbL8peGOGmTenxcdq7TVSMvc4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ueHCRFX0jP3bpz7Ri/uMZKuqUVtF7a2LkaEXeqVk7M=;
 b=Yyc4v3lKt1BI0ddYGuo4oImbgrdPMajW4POVcIn18sdAjGxjG0ge3nVQZX2zFlr0BSwXSREeEdU2jEaaDopzkvtcCyEPbJDr3KWWfXUXrJdiGe6U1XhQ+KrpFxJBH0PopSrb1v+YKyy3WJVFXsDfskV5oMcR4sA2/06BPc339HM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM4PR12MB6086.namprd12.prod.outlook.com (2603:10b6:8:b2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Mon, 28 Apr
 2025 13:54:55 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%7]) with mapi id 15.20.8678.033; Mon, 28 Apr 2025
 13:54:55 +0000
Message-ID: <1f056b35-d455-4e65-8063-db66ab764a08@amd.com>
Date: Mon, 28 Apr 2025 08:54:51 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH] x86/cpufeatures: Define X86_FEATURE_PREFETCHI (AMD)
To: Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 pbonzini@redhat.com
Cc: x86@kernel.org, hpa@zytor.com, daniel.sneddon@linux.intel.com,
 jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
 thomas.lendacky@amd.com, perry.yuan@amd.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <ee1c08fc400bb574a2b8f2c6a0bd9def10a29d35.1744130533.git.babu.moger@amd.com>
 <174562166515.1002335.4837189500291274188.b4-ty@google.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <174562166515.1002335.4837189500291274188.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0097.namprd13.prod.outlook.com
 (2603:10b6:806:24::12) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM4PR12MB6086:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f80d3a5-7f82-4456-70ac-08dd865c4156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wm5ZQmQ3RnF6TXM0WHFyU3NhMDBjN0dWSFBiODk0OFFrZEFGZVJTMHBQeFp6?=
 =?utf-8?B?M0tCRWJBVW9kK2poMWRjY3hldGY0Rjd1TEEzZFRGRXZxckNvdEQ4WnBic09z?=
 =?utf-8?B?RllSK2ZSUUdGb3RJeGxUZFoya3JFckpNbTFUMExGd2tCcTQ0SXgvcE50RkhM?=
 =?utf-8?B?NStvRnZROWxtU254TEJvSHhCTFVYT1llRkU1dFlHTVZjV2l4YnpHbmN2cGRv?=
 =?utf-8?B?QVJPUEtuTXQzTENzOWhhWXp6aGlOVVBuRzU0aVVtcVhwYXBxUDhIR000ZUF6?=
 =?utf-8?B?alg5UnNxcFJQMHFLaWRWSW1tT2lGbC8zVS84aE9RcTJjaWRJMXMxN0hHdE91?=
 =?utf-8?B?Yko2eStXT1dlZUJ0Zm1EOGxTelVVWUdjQU10dWR4M2hFUTB1UkEvd1dINllD?=
 =?utf-8?B?SWEyM3F4M003MThUTXR0MXZXOXYwUDJzU2Z4c0ZnaVRIY09XSnRqZVBpQVFN?=
 =?utf-8?B?ZGNLTjFtcW8wTzduelhqZmlXc2pLckJtWWp1dEtjMDF2enhvcG04ejZNSm91?=
 =?utf-8?B?YjJWNXNFeFBnVUpLbkM3WUxyZGlYK3EvUUR6ZU4yczEybnZTZTN3bEwyUzhS?=
 =?utf-8?B?RE0wdU1DUjlCaHZjeXNXUzdyNWdKRHAzTmNPb1NscXVyT0dRbEtLdy9LWGs4?=
 =?utf-8?B?dFBWQ3NLaVRmdVlCUTRPRVNoMmtvVnJkZEd4dEw2S2NQeVoxTkJ5Z0FWOGtn?=
 =?utf-8?B?NkluWEhwWWxXVjBhTXIwWCtGaWJxQ0NpMFVxZVlqK2h5TnZuUUdPRE5ETUZ6?=
 =?utf-8?B?T3VwQmMweHdUQUVvN2NFTXZnbW9mWWYxODZ2VytEb2I3UGFnQ0xsc2JUNzFO?=
 =?utf-8?B?bTFHajcyMExOUWcrUHBPOTFwWVc5NU1OcGR5M0I0Wis4akkyODNmWFpCTWdN?=
 =?utf-8?B?ckVEaHJyeHJDbjBCeVRyd21KVFFCdUwvQWxucUhzNXRMUlZNb3V0bHIrUXlM?=
 =?utf-8?B?L0VWYWlBeDhqTjAvTWI4THNta0lmOHZMOUJFVWQ0ZUNLcEJjdko4bXdkZW85?=
 =?utf-8?B?OTBSTENSUXV0OThuU21PUFg4dXNDanQzVUNuVG9FQ2FzV2U5eXBZUFFLTzNm?=
 =?utf-8?B?TW1ud0MyS2x0VUhnNXpxVFNGbFdEeWtEdWIxWGpjaGFNdytaeTR1NDF3VHVC?=
 =?utf-8?B?dXFQRnRmcXU5M3U3NWcwL2FSZDYvOUwrMVJnVEpjTm5xVUdCZGVTSnpQc3c0?=
 =?utf-8?B?bkZqaFNzWDExNW1GZFpSWTlZZElmV1ZRVHY3ZTRGcTNyMWhYK1E1L05OdmFq?=
 =?utf-8?B?K3pTMFBSbExQVXIrQ2FZbHEvdXlKWXk0eDhIQ1M5RUZpVDdTR2ZJSmhkZE90?=
 =?utf-8?B?ZEZrRmdzS3NyYkk2NDg2S1BpN0pOeURFd0VIRXg3aDhHUFp4OVlYYjFabHlJ?=
 =?utf-8?B?THpSMGZ1VzByRGIwY2RkTGkvY1hCWWZSS2RXeHhqa1JJR0xZQzZsYzB6ZDJR?=
 =?utf-8?B?RDlEZUxWSWxXZmJVNDN3U2VJc1plS1ZtakxHNmwxeFFmSGVaaVBZRENxVVNr?=
 =?utf-8?B?eG5Sd1YzYUgxbTRjR1NtbU9RWHJZaVdLN2hPQWxxMyt3elJKT0wyaWRDOTZC?=
 =?utf-8?B?ZEUvMjd2elRJWjRzSDZ3em5GVW5Ub0xsRGI5RkVpMkJQZVA2QkxFREdpdGc3?=
 =?utf-8?B?ak1Bbm93Y3RTQWo4OCs3Qm40ekM2WkF6c1FiV0c0b1hHTGRzaEE5UjI5d1pl?=
 =?utf-8?B?NEQvSFVCRGpmenZnSHpucFN2bmQvK3hGM2ZNVVRKR2RScG83SWUrUnBza283?=
 =?utf-8?B?RlZ1aUZRbk9yNW50cVFZUXQyd1lEOEVvZTlKcEhuZ2NOUmUxRDlFZWxma2xz?=
 =?utf-8?B?NGhYTHBNeEZIdlBndzdCNm1TakJMVG02TDgwU2M5UzRzYXc0bFVkTk5vOHp5?=
 =?utf-8?B?M2N3NzdyblppbVVvN0hCRVJwV0NWdlhSMDM3K1ZnVFRsdUtDSzRjSkY3WGJM?=
 =?utf-8?Q?z10WJoXPX3Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bW1CSmtkNnFjV1BvdTlTcksyanJpbFFzWjNYOGtuNXNUVnE0MEZ6VldqTHlY?=
 =?utf-8?B?QUQ5QVd6UUVJZkYwSS9BNThxM1lvZ3Q4U1JFdllKVWJBc2tZTnBTUUFuRjBD?=
 =?utf-8?B?UUFLREVTellNV1pQVU50dTNUMnFHTFQ3dTlqY3pPajdrUXd2NTgzd2JVNHhn?=
 =?utf-8?B?dzAzai9yWWNoNkRJNStDNkdNZStiMUFSMTFIOFlNdkkybFZqSmRNMi9zaXVo?=
 =?utf-8?B?MmFKWDlxcFA3YlFMUkN0L2pmYU1OVnJkUFo3N1l6dlpPSXJQaW1YTEsrMHBS?=
 =?utf-8?B?MTZtc3YxRVJTU2xVZ05Fc0JLeUlrM0Z6eWFSR3NLd01ScHJNcmpSUWttWE9B?=
 =?utf-8?B?VGtad1U5QlhFbWJoUzc3Z2xHYVMyMHVYd0R4bGNHWDJqdkhsM3B5N0NvOGUw?=
 =?utf-8?B?WStZaXo0ckZYK0dXRlBxdUw3WW5VZWlKeVFUVFMyaGdRc09ZT1ZtemppcTgr?=
 =?utf-8?B?S0tzeXFKWkVMcVNmZm9NcEpIbXovemZ4a0tFSE9Lc2FWYWJoNitLVXkvSGZ4?=
 =?utf-8?B?TEdCRURuUkk2MHBuSklUQmRoMTNqZGZsRHVoUGFPd1NEcWdtRHBLeHVLRW15?=
 =?utf-8?B?Z0l4bmJlczlqQUxLeHo0djRzQnkxZi9TdnpIMkFYVTYzVFk5WFozakpEbFBM?=
 =?utf-8?B?MDFBVEFFSzFoeis5NTF3OE9CTGIyZTZsL21KcGh6WTBXeUN6WTU3NFhDcU14?=
 =?utf-8?B?RHRGbmJ0MEx2QVdJdDJPRERkSFBTaHV5L0hmZFI2bk4yWDJYRnYvdVhSZERY?=
 =?utf-8?B?WlI3dkVLd3hEanVtb2Z4QXRwV0JLbU5NQi9aS01iRmNXNHdkNm9IV1FscStK?=
 =?utf-8?B?RWVMUDJERlRqWXhyUGZYbTZqV0VlK1BWUVNCZ0VOdjlFN05OVEhlc2xsTC82?=
 =?utf-8?B?dyszcXp2Y1BJRTQ2NHZzTXkvK0ZmOFlIMUwvQldTdE5VOTF1ZUszSWVWdjlx?=
 =?utf-8?B?V3FPbm9FUGZtUHU4QXJCZjBTaGZ3TDl5dStQME9CUTM5SzV1MnJsSlNQRko2?=
 =?utf-8?B?VWVUaGJVT3VpMWFOTWxnUUVBUHNraXB4a2wyeENlUndiRkg0RzJuT01XUUVO?=
 =?utf-8?B?VFNvcG9UNTRvUUZKbHpwWEU2QzRIbjFLMHFKbG5HUE1ZMUFlM3Z0S1FQeTJj?=
 =?utf-8?B?azJWM09nZzg1VWRvMEdsVklwa1hPeThQM05LRWlVYXE4eGpVY2dQMmVla0FQ?=
 =?utf-8?B?aXJzdEd3Y0JNci9TbzJSeTJuT0N5bVJGMkVnWjdzVWZyeUsvODJkdVM3aXdE?=
 =?utf-8?B?My91RTJhZGVuWGc2UjBuQWVVZERlTm9LUXM1b0VVaFZkZnNlazFxeStqdSs3?=
 =?utf-8?B?cnhUb216eTNmUCtNdnZsNXU2UWgrclV0NlpkVU9qbWhLQkFXbUZGTU9ENXNq?=
 =?utf-8?B?ZDA5TEFmbVpCRzd0WVY2dE9OeWNyUVViRGdQc0NPaXlINngrempHU1VHMDJv?=
 =?utf-8?B?dUF5QldXbFJZMUxhZW9iS3hTSGRrbk9jVU0yeE5na2JuMXZPOGQyNGxuTUcv?=
 =?utf-8?B?cUROMCtRUEJiaWZJaGIxa0hELzc3WTJ6bFdXWXo4d0VQWkFpT3NzWE5VQlZO?=
 =?utf-8?B?Y1lNTlc5a3FiTWtJSHlBVmZTMENJcUR1TVMxL0ZNc0JkR2JVK1B6Mi9DYTIx?=
 =?utf-8?B?Y2hZclVnc1U4akttT3AvYzdqc3c0VUd4em9sZGg2aTdCT0NBbE1keUZmM3VJ?=
 =?utf-8?B?TGNrR0N3NUkwWGdtNXl5K1hDVFA0ajlOdkkvc2JJaUVSQnFObW40TGZrODRh?=
 =?utf-8?B?YkZqZTJLOWUwQWVBdjZ6bEVmaUV6QVpYeXlhZ3N5ZDByMU1qZjBVVDk3M04y?=
 =?utf-8?B?YzRxKzlLUUZ5ZTBVWm91clYrZzRvYlRvaXNSN2duTVpEekRDZ3pQTXpjVUdo?=
 =?utf-8?B?WER4Ym1nclhXa0Yrb1Uzb1Mvcm5SZkRuRmUvSmRzSGphZjUzazNSOEd5T1FF?=
 =?utf-8?B?TFlWUmR4anlyOWd1Y0ZBNGVibGNqNlNiZVB6ZUFoaDFLeWxHMWp1bG9sdzlv?=
 =?utf-8?B?WURwNVZXbFdNb0JIYXJDb29jVEIxV2pWMEk5YXoxTDRaN1JKSVdDT0NlRnBn?=
 =?utf-8?B?elZETDkvWm1lb1NLZ2FOOGRCT1FiWDNCQWNZWWV6VzFYbW9Tc285YWUyYjBv?=
 =?utf-8?Q?dkOs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f80d3a5-7f82-4456-70ac-08dd865c4156
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 13:54:54.9883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GiWuGzzgaYrSjOOnf3mk9qgU1dHhu+pDTRdglz0qHmRqrzCsyccPEt6IVh0U7adQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6086



On 4/25/25 18:23, Sean Christopherson wrote:
> On Tue, 08 Apr 2025 17:57:09 -0500, Babu Moger wrote:
>> The latest AMD platform has introduced a new instruction called PREFETCHI.
>> This instruction loads a cache line from a specified memory address into
>> the indicated data or instruction cache level, based on locality reference
>> hints.
>>
>> Feature bit definition:
>> CPUID_Fn80000021_EAX [bit 20] - Indicates support for IC prefetch.
>>
>> [...]
> 
> Applied to kvm-x86 misc, with a rewritten shortlog and changelog to make it super
> clear this is KVM enabling.

Sean, Thank you.
Babu Moger

