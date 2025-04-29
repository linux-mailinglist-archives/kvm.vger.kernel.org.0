Return-Path: <kvm+bounces-44820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87502AA1970
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 20:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 776101BC8206
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 18:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9B9253B77;
	Tue, 29 Apr 2025 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gwI2xczi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D032459C5;
	Tue, 29 Apr 2025 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950211; cv=fail; b=ZasWZercVWuAzopAruKPWw6DDJ2pkGjjIKl91TIseMd1Rz1UNrOz3a0yFfT8g43NLFoRXndhNjydSftB1vTJO3fXrXnggzK6J50dvlYYb8FfVkHMZBERQ82PB+nvnu4I78XUENoqtGf16N34eXdO55CVFAzJ1/Mu//uowC9huxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950211; c=relaxed/simple;
	bh=GI8suaShKOQo3eBGqYjMhu4sHaAuyxUyLT1xR62KT0U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TQ8RXsd89DSLW42S+NYOs+7/8RUXPpMCHql7LIJdLGlbIA6j1Sc2EE3dRnNGmIQWmT2l/pl3UjfTEA4052bkeJ4MF+LWF3RgZUEXmR+R2ed7fs0sabBbahNZ0EHJmtKBNxaNi+NQ+AtEJ27XTfC8LsPSv6wBkPUsaK9A87EnOz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gwI2xczi; arc=fail smtp.client-ip=40.107.212.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xTOQjNZV+C92YTk2B0f6iBmemr5HqOj1D0vTeMHXJhJY9Jw0jz+Yo3KWHS+UB3lvzooxG8sO2czYRLDPIF/JqhuePBeATtFTZRMqpEXhVsz9sO4r9APSKYNN3SvEbmBeIb9dDbJFRPvCu+d3pt1yRMONr23vIY18de0rcNSQTfpBlIdwm4KNsXIAHdyjCUMDF3wp9X7UdKqbbExWV5eVmD8Y5f4VU9GSgAeWCJNT/z0hW0w2zfz7TJugvMOhRfAa1whKXxL1t57pHks67TnRB4GJthpR5IOrfBegTf1aCR75i+cgM5UJQVFVG1e3aoHyJW0TLuc6ZDeEcRnqAles/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUwDsCaUtv4dbsX0p39q52NSBt1H5t1zCFn8Dt6XYdA=;
 b=QkqlgZL8wKJOook4Rn9KCleiZG5jkto5JchAsEz/PWsAA1SEorpShE8B0+OR6ksVqCmlPow7ivBKTdPFbptAtxxCYjKZf6jaKKKGkHC2wyjjD1N9+VOWuVCBgDb+kM2ZIYK7e8Rh28S9XnkLL83MarRNnky5p6ftaF3b/miNI5g094BhfXdZvo8pNVTkY76iyUwhyZHoaos1GPpv0Wl48vwEx7usJQQpatnAV0eZuPDsJQejUQmMg2HDgrOsYa4Xj6sBxX2FdZjwo7cqMcClT7dClwDzzOQqb6U6Q3syDNv0KFcWADhaaoyxtHlxSqtc6G58LDSBMOaJO7BXde8Yjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUwDsCaUtv4dbsX0p39q52NSBt1H5t1zCFn8Dt6XYdA=;
 b=gwI2xcziIyBhJQ2YboZPZgRnZhSDEWHIjn5R0Jw0kK2OBkDOUQzVs/SSEe2m5CWW29DaYz3R15938WFT9+UpC3/Y4mxQx9rfpO84AlRc4WrRqS8B0/3DARrBs3XxGdsrj4TPjN4fzl8legYxQNx1NgezISgnIcAHgDfxa5Gl28g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CYYPR12MB8890.namprd12.prod.outlook.com (2603:10b6:930:c7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.19; Tue, 29 Apr 2025 18:10:05 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%6]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 18:10:05 +0000
Message-ID: <62ae9c91-b62e-4bf9-8cf2-e68ddd0a1487@amd.com>
Date: Tue, 29 Apr 2025 23:39:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/20] KVM: x86: Move find_highest_vector() to a common
 header
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
 nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
 Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
 hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
 <20250429061004.205839-2-Neeraj.Upadhyay@amd.com>
 <aBDlVF4qXeUltuju@google.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <aBDlVF4qXeUltuju@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0235.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::13) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CYYPR12MB8890:EE_
X-MS-Office365-Filtering-Correlation-Id: 0795bf26-c538-4dac-5f40-08dd87491121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZHROaWRvNmtabkNkYjNOWkErdlZwSkVkK0NxTi9uMkhOc3l5UlFZU2N6N2U2?=
 =?utf-8?B?dFZmQXRDTldTcEdBZWxHd3V0b2ZuUGN4ZW9ETGw4Y2hKd2FiYjJNT3FBeUpw?=
 =?utf-8?B?QUp5UnZCc25OclVNZFNod2o3Ti9FckFJeVZ5a2dTMG4rVEsyRG94SEpiNVFl?=
 =?utf-8?B?eGJhV3dhWWJzK0hPSmxGVkJHYWJUWVZqRnVEOWwwaVN5eVRIQkh5WFd5YzBD?=
 =?utf-8?B?bWxFSGtXNFEwSkNwd3UwbUJkRHFvaHM5bGJWUm1JcTFrS1VPMGRYMHhDS1VY?=
 =?utf-8?B?SXVLSDBvdnB4ZVBrTUNCeHR5UTV1MXc2ZGJjVjR3QkloTEJOUXIyYTFhYk5K?=
 =?utf-8?B?aDZCNkgwaHoyVnJnc2dKdUN0SDBvdEZRMGJOVFdFV3oxSDJOc004WUNQS29w?=
 =?utf-8?B?ZXdJOXh4VFdQdzhCbXJiWXovanNtVDhNbk1hajJHQ0Nuc3pQVldKdlVVbjVy?=
 =?utf-8?B?SXNEeUlJRS9mczFoQ3kyN0NMSEJNc1Q0aW0zVVcyRnRCN3ZUcndTYlZRaWx1?=
 =?utf-8?B?L1lzSklsUzRyUmhTZzdVQUx2QVozMHZ6YnB2TlRna1psUjdrUWRkaWt5QlZ4?=
 =?utf-8?B?dzJTRUg0TXJMNU9jZDVMYzNpTFNLS3M0TGNnUkVKUmlOdEZJK1hVUmZyQU42?=
 =?utf-8?B?NXBqVkIvUjJNSjZOb1JqMXFqamRLRGFnVWdyeEdmbVVTOEpaNExlRTc3aG5T?=
 =?utf-8?B?eVl2Y0RCSzhqR1ZvZjc0ekVVZ2tQUm5qcHRyUXdIb2JISm1VcFBqVzVlNytR?=
 =?utf-8?B?RHE3TmNYaEZyWStqZi85MU9VNXIyV01EVGNkcTJ4SC9QYVVNZU9yb0U4Ty85?=
 =?utf-8?B?MFZqaVh3TFN1c3pNMUErL2lWazQ2N2F2UDdXVVNlL1AxMnRnRUlqVWhFMVVL?=
 =?utf-8?B?SFVxNXpPSnFtQTVhcW5oRWQyNitrNk1OZmFDeUU0Q1ltaVJiRTdsSmdPWVh6?=
 =?utf-8?B?dGdCenlmQk4vaVR2RzUxZm1qclJQR1FVK0p3djgvWmdweEhsaFhnN0IzZ0xj?=
 =?utf-8?B?WE9lOTlDaHMvU2VpR256eUphTWlQTVZTM1VBQzYrdHM4aVppT0ZSbXgvWHhK?=
 =?utf-8?B?QWdtSDZHVGZtaUhRN0hsdjRBU2lEMUNYZGNCazVNbEp2ajRFWFlQcUV5THZr?=
 =?utf-8?B?UFc4UlRSNE53dVRmV3pGQVZCV2szSWZKeGdMNWFma3YxTkRPbS90ZHJobm4y?=
 =?utf-8?B?SkdvU1k2aGtlRlQ0L3pXemZzb25uVExsS1pWZUtoTy9iekpoZUZXTk5Cem5T?=
 =?utf-8?B?QlIzT1hNUk80NHJUYWVLbkRmUFltVE9PWDI1NzNCMWlRVmhDNWtUOUVONVRN?=
 =?utf-8?B?L3R0RzBaSVJsTEkyak1qNGFUSjFvQUtDNm1pNHZja2FMcVhtRU8wajQzWmNp?=
 =?utf-8?B?Rm55UVhYaEpZN2h3YUhEV0F4NUNxWnh6SjVjSzhUeWFkdElIbG5FQ3I4dGVE?=
 =?utf-8?B?M3lialpuMGNYRWFJWno2SVUxaFFLRnorTW8vSyt0REZVV0VobUZiejRoZjkr?=
 =?utf-8?B?WVdYMnh2UnhVOU55QlhBaFh2MWI4MzhyS0NPUmhVT0lWcFR4VUdhbXZhWE50?=
 =?utf-8?B?eEN4ZVp5ejJKWjk0SWVNME9UQ2Jjam5EclpLYnN0QlRiZHJLcUJtbFE3NVN2?=
 =?utf-8?B?SktjNGI2MnI5N1pwSjl5VStZVFlkNElGOXhyb3A4d2JJWEl1OUpUUU8rbTVQ?=
 =?utf-8?B?YUJwRnY1eHppcUJ1WnM5ZDVTZVVKTzE1NkxTWUp2QlJjV1gxQStnV1JKRHJI?=
 =?utf-8?B?Q1BwTFR3c3EzTnoyTEVBTnhOcVdrVDBlWnovUUVmYnBHL01iNjNYS0lROG9W?=
 =?utf-8?B?OUlYZjRLOFFyTENPOENqc0c0b3dIR0FBd3g0bWRvMlYxZDVzQ3M0UE8yQUoy?=
 =?utf-8?B?RlNaSTg4bVp0ajZGTU9yNDE1K1dlOXhoOHZHdkdXWGFWck1SL1pyaE0xcHFS?=
 =?utf-8?Q?19sNhpcBEdY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTc2R3JaQTFZL2djVGpCWlBUb2lvV3drMjc3enllNjZNenVMOXRwYVZ0d2VL?=
 =?utf-8?B?cEdIeTczWEVKdzZUamFMK1dkZTg1WUxFL3FZOTJpOWU4aGMwNGpxamdYd3Jr?=
 =?utf-8?B?VW0xOXhLNnNNSW9weG10MjBWeGJJSVpEdGo1RFAxeDZrRmZEei85a2k4aVh2?=
 =?utf-8?B?SjFHbkdwUDA3N3FxSWF0UDhIMWdWU1FtaDY0aFB5SDR1SGtpcmVIaHFTbzV3?=
 =?utf-8?B?ZU1STlhSQWtLVGJ2SFBUeFJXejJpOStYSDJDa1REdzYvaVhJNVltcXl2Q2x5?=
 =?utf-8?B?bFZEQkRpOHl6Sk1yNWFtWVRza29sMlBaN3VrNWFPT24zMmpRRXNnOUZKNGNX?=
 =?utf-8?B?blFLTFZ4VktJQW12SFNJeTN0bFZQV2x3NVp0TEI5bzZHZXduWVdRcndhbFl0?=
 =?utf-8?B?VTNLa05QVmRlbHRTcVI1K2txTUhpdE80MWREd0crYUVMZnFoVTgzMEVDZVVM?=
 =?utf-8?B?M2s3alN4Nmp6cE1vY0ZFSzd6U1ZFKzljS2RlWFE2RE9aN3JwazlKdjBsaXlW?=
 =?utf-8?B?SSsvSDUyaC9hdjhGeXozNXBkNHJkYS9KdW1EUGRyQnFMNGpoZ2I5QS90Z2xl?=
 =?utf-8?B?Qklod1Ryb0p1SEhOVHRya1lpcnBiNFNlTUFRd3JqSVdzNHFobVBDOHljNFNO?=
 =?utf-8?B?emY0T3dPV05GdTJPbkNrZFBwSVhCcWxBUVY3WXFqMk5qQVhPa1ZvVEw3YUZ2?=
 =?utf-8?B?NFhzRnZ2dm1YUWJKUW1TWnRldVJBRjcvREhWeUtteHlJUStCRjFzWG1JSFA3?=
 =?utf-8?B?bFJLUE5KMmlRY3BEUTgvRkt6cjFGdEJMRkJDN3hiMGhneFA1V3o0WEd1NW9G?=
 =?utf-8?B?VjlXVkZwNkxrNFJvQ1o3RG5YZDNYSFJiSnFNT2lMa1hkdTVEeEhuV2hjcmxt?=
 =?utf-8?B?Rzl0R3NTZ1NpM012bVVxSHVIbW1Cbnh5YThmUk9keWd0S1lhMVZXWDlnV0dC?=
 =?utf-8?B?RUNjMmg4eGVmL1dNVHBSQ1I4Skt0UkUrMzVWS0dkeDNsOXFyZlUzVmN5YTZV?=
 =?utf-8?B?K2Z1QWEzbkh5Tk44N2tkdEsvczIzUitLbEovNFFXY3g4emdIcjJtT21tYWRq?=
 =?utf-8?B?QUlTYkdvRGJ3YXF0QTNrWjJodW1KZlZObWVvYjB0SkRHMGQzWUFVaEZ1VTZD?=
 =?utf-8?B?cWRuTWV0VDUzSlJxUG1jRG8xc2UwbnRLNjgya0pyWUhQTG1qaHhRUGZydnMr?=
 =?utf-8?B?d2I0K0pJVGhDU1hhdXd1UVNLdnkvclcyN1ltd0FxUU5ydm05YnpZK21XN1NK?=
 =?utf-8?B?Z2VzbmhDZnc1a3kzNzVvYncvRUdZRUwzTHlDdWtRRGdOSVNjNkxFZ3poZ3Ay?=
 =?utf-8?B?RXI0MDJPTVc3SkJkQ1BvWWllUnRhMjI5SFZSdjBGVytjSmYvTlRwRUs2YTVz?=
 =?utf-8?B?VVN2SnAvTHZFRHpjUWhmdVBRbDFveFV6WUxETkhNQkoyNXl5eTFSNWhjKzll?=
 =?utf-8?B?UjFhdTlRaXlYUnliWGtoemdHRzcvazdYaW10VXYvZU5rYVdaY1hDT3FzVTB2?=
 =?utf-8?B?d1FEUU8velNBZ1o0UVI2UmpQUXpkOWdtc1BtVDIzSE5OeklHOUYxeUo4WnpY?=
 =?utf-8?B?bFMzMkVMQzJDeGZuVmEzVzE3M1RpemhvbkRoVDRRUHlDbVk4dHpLOStvM2Rm?=
 =?utf-8?B?TDAySExKVFNHZndPREM3K3JBVGZXanlFWkVHNjlwWGdjM3VhM1JEc3JwWjRh?=
 =?utf-8?B?dTRST2c5Wkc3M1J1TUdJVGN6L0gxZlRmV2d3NkdJSnV1anNzbzByT0Y2T0pO?=
 =?utf-8?B?Y241K3cxNUtzaGJ4dG5ub0FpLzBFR3BvSlVmcjNybEZkTlpLNHZGZHIzWWxR?=
 =?utf-8?B?cFRyemMydk5rNDBDZFlWbnZHdXBSRkN6a283a2tiVW9ZTDFLYkdZa3B6d2lh?=
 =?utf-8?B?Q29FM2VKTVVtNkZkMGpuYVdjSklhb1lqeDF1anl4SVVabk9NWmY5enFzWVNz?=
 =?utf-8?B?L2hoNGpWQ3IxYStqb0Z1MlVsa1BZTWdCV2cydkd4SkU1RmNsUERoVG9TTDJw?=
 =?utf-8?B?M0lkSjBDZjNDRWdDWC95aGxLL1YxY05ZUU1QMk9MSWVXNmQxRkxCd2xBOU9l?=
 =?utf-8?B?ZHhjUVRDcEh6NUdKZU5GSXc3TVB3VG91c2c1NWg2bnVjWk9paTVEYTZzemVp?=
 =?utf-8?Q?+omm2NM8oa6GgFIs9/ahBSU88?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0795bf26-c538-4dac-5f40-08dd87491121
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 18:10:05.1592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pMHqFIRM2VpZKaVJRVGo17R6XIZLVau6roN6Yo9kFj3THcaGUYNw35N0D4sV7yv41dyTQ48U6UrRwZ2pUz1Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8890



On 4/29/2025 8:12 PM, Sean Christopherson wrote:
...

>> +
>> +static inline int apic_find_highest_vector(void *bitmap)
>> +{
>> +	unsigned int regno;
>> +	unsigned int vec;
>> +	u32 *reg;
>> +
>> +	/*
>> +	 * The registers in the bitmap are 32-bit wide and 16-byte
>> +	 * aligned. State of a vector is stored in a single bit.
>> +	 */
>> +	for (regno = MAX_APIC_VECTOR / APIC_VECTORS_PER_REG - 1; regno >= 0; regno--) {
>> +		vec = regno * APIC_VECTORS_PER_REG;
>> +		reg = bitmap + regno * 16;
>> +		if (*reg)
>> +			return __fls(*reg) + vec;
>> +	}
> 
> NAK.  The changelog says nothing about rewriting the logic, and I have zero desire

My bad. I missed updating the changelog with the information about logic update.

> to review or test this for correctness.  If someone has requested that the logic be
> cleaned up, then do that as a separate patch (or patches) on top, with a changelog
> that justifies the change, because to my eyes this isn't an improvement.
>

Ok. I will keep the original logic in apic_find_highest_vector() in next version of
this patch.
 
> I suspect the rewrite is in part due to REG_POS() being a KVM helper that's poorly
> named for a global macro.  lapic_vector_set_in_irr() already has open coded
> versions of REG_POS() and VEC_POS(), just dedup those.
>  
> *sigh*
> 
> And you created your own versions of those in get_reg_bitmap() and get_vec_bit().
> 
> Please slot the below in.  And if there is any more code in this series that is
> duplicating existing functionality, try to figure out a clean way to share code
> instead of open coding yet another version.
> 

Ok sure. I will take your patch and reuse the APIC regs manipulation functions
between KVM and SAVIC in next version. Thanks for sharing the patch!


- Neeraj



