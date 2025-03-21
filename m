Return-Path: <kvm+bounces-41681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90700A6BFC4
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F7827A88F9
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C9B22A1FA;
	Fri, 21 Mar 2025 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xbR7U0FA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB6A1D86F2;
	Fri, 21 Mar 2025 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574013; cv=fail; b=Yhrs84WKkOeLrskLO+N/YI1lR5wRaeIz306DDZIdvCXTQtRVFo710uul+4fZAVsLwLpUAfcoiW+nUnJPmjTzAAjfNxw6N3ouJxO0ryZSlR1NoTxCxn4B1Tjs1XZVBMCENRaAS4ZFEG5oVkBuQVIyyAB6Z4tfD8VzHIKrtJjv7k8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574013; c=relaxed/simple;
	bh=fJWuEtJIg0BK2bqm4w7kgo7hVwX/+5q5tDYLOye9Yg0=;
	h=Message-ID:Date:To:Cc:From:Subject:Content-Type:MIME-Version; b=XsFP9RsDGdos2ft+RbTTENe9FPx7tbWftEWdZVy/lZ3t0RIFeAOitrQk7cYAIHfIRYmWhY9xWUBZQRXnjLJobvpyo7L4/GZ4OcpO5j9sRcCWQzTtLwOTlq0ielBr6kNO3ZCTKl25PGvmOBbJYFodn+o8X4o4g06yhBIfy0aZr64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xbR7U0FA; arc=fail smtp.client-ip=40.107.236.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PYRBG4+j6vITHinU83qNkOQADypwfR6c6bgQbyNrMtIV1XujCu5ZAAi1fAesBUGhK+kjwjTorSA2TNT/ojw500Jy43wLdXYGca+swqZQYWu4WL1qyYocmQ4RoOWWUkPMXqhEE0kGUaNDmDeycGX40U/pjj3eS5cdT5ZPiJsSWQJIhUYP5A+Rt/gPN4HjcJlyOU/RxZ3BTpqKhXl+oi9eV/UdAoPZGkqUnXc1z6Jdimr7bjAaRK7nSpgURBXnSAdYAru2qpYoW0AWKoyv9vWjrRbhXif9fUCP1jrP/NEqZYmTCxBDDX+yTEsZUzMdEymHSApFQOLKGYexxw4ThfdhdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcmY8irwnosMxhikf4i92BLT3LfEkROFwMACCwDUZI8=;
 b=dInYabNLTzv6m1w+/ZSE0dU9nLVmDc/DWf2M38FZcL38dJGQ/NUeOZSG/KOH3cpqGAbHT4Cr9GTAE45GK80acmgFjle5I6d8ShslbEa+WUaVxloNkLRLgdoYjhmNb4lw8qhGchBpyc2xyxJbxXWlfE7o95fwl58BHLyWepvTClLVMw8eY4hrjmrSTIR++2RISxJAuoecc97wquGuG1ZBzs4Px8gfrGI9pVTx/s2dsEvE6+2s805ZeSExq+2HnYZCrG/MbbH1S8bMwO1LL49ED8NPVDQ5qiX6pU11xhANjrh28BqEIpWGNYoKyeSjoK0A2U2ZT2+0oA/iCyVqOiLG0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcmY8irwnosMxhikf4i92BLT3LfEkROFwMACCwDUZI8=;
 b=xbR7U0FADWIUM3qTQHb6vXTuRb8Wd0NdJ9QBu7vIJdHvVK/HZ4WfCEYz/3Is0mUzDsBVhhZA1gjyHgG/JHEWozHpnbuUEbQY6foCb6SKUR4bkTKX8zbnWn0ANOTMehx0xio7cMHhgNFXVASwogX8Y2hVgVLvOWlrSj/b/X7fFhI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB6900.namprd12.prod.outlook.com (2603:10b6:303:20e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.35; Fri, 21 Mar
 2025 16:20:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 16:20:07 +0000
Message-ID: <67705551-7911-cabc-e839-8a3d5ddc29b5@amd.com>
Date: Fri, 21 Mar 2025 11:20:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:806:23::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB6900:EE_
X-MS-Office365-Filtering-Correlation-Id: 21963849-4f39-4fdc-642e-08dd68943e63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDlLcDFhTE1BdkZHMVNTNVkxMkhIeVhBN2hteC9rcUJjSXU0aGZ0d3lycHFK?=
 =?utf-8?B?ZkVGM2RzeFZXbjJ1RnhGL3pyaEtORUkzQktHNDlTRC9FUkVLZWJ1bHFzalJZ?=
 =?utf-8?B?K0tQWDd4TEc0UnFSMHoyY0VIVUp4ZjdqM3BUZ0p2TUIya21Mb3p2RU92VUF2?=
 =?utf-8?B?SlF6UE9NRC9qYlBlTFlZSjIralptdDhPSkMxZVFGaGJ1WW01cmEraUo1OTNB?=
 =?utf-8?B?TDhVSG5tZytPdEppSnJkM0RqdnV3Ylo5RHkvYTl6RjBnTTErMmRRUEd2aWZV?=
 =?utf-8?B?ZW52VXhKb1RqVjRiUXd1OXZkZlZ0MWZ3ck5pY2V6bTZ6T0U2SGdML2F4Qzd5?=
 =?utf-8?B?MXljT281NTc0TG5GWUhlZC9pNnpEcjVFL3lPSzlheXJBN21qL3gvZ2lTS3Vs?=
 =?utf-8?B?UjdGZVAvc0R1azducVkxUThnVFNEaWFHQklXWEQ2T1htNkt5M1RIWERGS2xW?=
 =?utf-8?B?cVBHN1MwTmZrRllLbGJPdVhUTFJUbkFZN1F2OHZUeWRHZTBQaFFDL1FxNVY1?=
 =?utf-8?B?QWNqaE5kb1VMdHJrb1p5N0xZdUZkUHY4djdsQndNK1crV2hIa255OHpKRE1T?=
 =?utf-8?B?VWRwRHU5bjlDWGw3anFrdW9GNWxhYTNNeXNvYjRIK0lrRVJhVEdBdE1rd1Jh?=
 =?utf-8?B?dVZtOVFlVllZZzYySmhZZDZqTU9MK2V2N2ZkU0Y3eGozazhCZ0wrZ25LM1Y5?=
 =?utf-8?B?alRjWTdCcGFYMW00NXhHL3RaU3prbXpEVVpoSXVtSVBLUWJkSmFQWndFejBP?=
 =?utf-8?B?ZXBMNXBYQnZUOExkYkRvT3RHQzZZN1JMUE9JZlRnTTdnUDhDWDBuTm1ZZlVS?=
 =?utf-8?B?cEVmM21EOTF2VkV0K0RmWXdYemRueVQvUEp2ZTJYNW5nT2xyUEVrVnJKMldX?=
 =?utf-8?B?SHEza21BcmVXcmQzWmZEbjdoblMxYXZxNGsyb2VESnV1c0NoVHFNUW00VmdL?=
 =?utf-8?B?eHhDazJpQ2pNaCtZcmc3ejFJWFVwZnRZS3ZhMnNrWE5TWVRFNjc3a1Y0L3FL?=
 =?utf-8?B?QWxUWFFYSGkvQjRmUzZqWWV5UXVkRTZhdjJKVUhkVWY0MmxaRDNTdUc3emxo?=
 =?utf-8?B?RXNoa2NER3RJaUR6Z1RnUkNtSVJPZ0N2c3BqV201d1VzL1BZTTlURGhLbnh2?=
 =?utf-8?B?NXk0YkVqcUNRdEJBcWRuK2dFWG5TYisvRzZnSk5mYVhtZUQ1QkF2N0NmNVBY?=
 =?utf-8?B?OWYzNHZPZExSM0liZVpvMk5JRWVXT2NaQVpUKy9qTUcxMWpsQmtsSzVWSkFP?=
 =?utf-8?B?YkhIaUwvb0xYV2FLWVFodi8rM0VtRHRTZC9DM2xGSG9kK21jb0hJdExhalp0?=
 =?utf-8?B?NVF3MDFQNXBmN2dFcXc4QXJvSGduTjlRaUovNyt4ZmVmRDliY1pzbHFSSEVs?=
 =?utf-8?B?VWxaay92K1NubGZKQXhweldIekhXRVp0Qnd2ejZuSG9QNWRnMkFwSE5rdnRS?=
 =?utf-8?B?QXpVcWhTTWdEcnN2SkliODZ2d3I4Mmd3ZFQ1alFhaU1YT3Ywbm1haWs0aWxI?=
 =?utf-8?B?OUVnbjRrdFExR0h1RFhrUUc2anBsbEZLMUhLUjdOVmRQaTBDdFFRcFAzcWQ2?=
 =?utf-8?B?Z3cwZ0hjVVBPa1FwZ3JuQTlWT1A5c1UzM1BtNmZYN20vcnNoWC9laWFlZzFv?=
 =?utf-8?B?eXZBaW9GMkQvVmNwSFlZVzcrekJPOGdOZmhLdExQVmpGOU9lT0lEbkF4Mjh1?=
 =?utf-8?B?Q0ZFVk56YVR3SVU3U1FnUVZlSU15VW5ZRjlGVTdaMno0dWpuNHpvYUgyZXYv?=
 =?utf-8?B?VlVuak95b1NUN01MUll2TEgveGNGZEFXQU5vclAxOVNxY1FWVUd0TkxVd2Qz?=
 =?utf-8?B?TVAyNE5LNDgzaTZremNnV2Vidi9iS0dVbUhIWitLV2hQMDhRdFRJQ3lhaVFk?=
 =?utf-8?Q?9JnBVdGt/xtXU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEdob05MRjNSOTdYMnNoK0VSYXpjd1dCaFhyUUYrbXgrb2p5NVV2QlMwNTND?=
 =?utf-8?B?a0RWOFVSMmQ2WHJ0MitjQm5CeWhJUVoyK1d2RUtuWGNGckJXT0g0amRya2xU?=
 =?utf-8?B?K3lWdVUxK0JsaXZCUHlPeFpvQzk1QTNwSTlJakpyeHc3a2E2TWhJdzBodktF?=
 =?utf-8?B?Q0xvME9NNE9kU2tCTzZrcUsyWlA3eENDWEg3cDBubllBZ2JHWEN1MkFJOUNj?=
 =?utf-8?B?RjdYRmZJeFBXUnlaYnlMcjdodyt4U2FJbTZWVU4wdVJwOWVORmovKzRGajBr?=
 =?utf-8?B?cFNOTS91cU1BaEJoUmxxdUxzdG9Fejc2ME44aXM3S0U1ZkZ2NFJRTTJNRkF2?=
 =?utf-8?B?QXI0V2VZYnplSll2SXBIbnJsUjJoMWZsRVljUlpJQTJSbmZJdTR3OWh0dkxP?=
 =?utf-8?B?amtrWk9nREpuS0RWVVpsU2hzM1B6bmJBbjlrVWd1a1FucFdaN1p2QUdHa0ZC?=
 =?utf-8?B?S2JoZVQ1anBYcW85UHo4TjhXczFibTJYM2VKK3NJc3B4bE03MDIvQjZhR3Zi?=
 =?utf-8?B?K2RhRGxiRVQ2TmhUaEZvOUk1WnhYNDRCMFVwQnAzNGR1T1VFZnY4U252dVR6?=
 =?utf-8?B?WDlqeExCWXhTTmdzb1RDTGVNTnN6TndNR2U2bFN4Z3dadnJ6dHlVWUhMYVVJ?=
 =?utf-8?B?U3dFdVZCK2ZpZGUxbDIycEQ1K0VpeUxQOFR4bFY4eDBMV0Z5ZkVNSExvM2gx?=
 =?utf-8?B?c092MGlHb0tiQ1dxeUJNRGVIa3QzdDgwOXNMdkRUMGd6TUFCSHdkZVFod3d6?=
 =?utf-8?B?NGZsaHVFejdpUEc1TXRqcTltZkJJOFhqdjVyWGg0STUrYzdYRXZBV002cGNo?=
 =?utf-8?B?aVNqOGwyNmJnM2U2ZmdHZHVxc1ZkcTdNN0JRdy90VkJVWjV0TEFYTUNXT2J3?=
 =?utf-8?B?bXhXUGtkTXB6d0phOUpGaVpqK2xDS2RrN0RmTkduVWg2VUNlWWR2MmJRM2g3?=
 =?utf-8?B?SXRveENYd0tLU1RjNjZEV2lGQ0FkUkxwZzhQbGZ5VER4dGw0MnZjWlNZSUxL?=
 =?utf-8?B?b1BVNGtyc3lrcnZLRytMOXVmQW9YR21VSm1KUk92Wmx5djRjbzZjcHNNdExK?=
 =?utf-8?B?Tmt6d2dGR0tNWW1HU2pjUklpU1RMNkJoNFh4QitYQTFadFpvNi9BOERTaE5p?=
 =?utf-8?B?N3VyTHNXT1BXcWxiY3VoUkU4ZUxnNVFGL2dVUi9YdStKR1VLaEtzR2d6L212?=
 =?utf-8?B?Rnh1VGNCREVMcUl3aG02eEp0eWhVaTZLclhxWG9vbm9wTXg4N1pmdzcrSXIv?=
 =?utf-8?B?ZzZMUHFmYnB3dUpLZSt1V2hlS2dXeVVJU2IxQ2VPeVk0ZmRNaDZSZms1TEtE?=
 =?utf-8?B?UEtkRVIzWWVrck5xVThEMFFFQzZ0SmVxSU9JVjVCaGV3ZnRjbGx0bnMvT0JE?=
 =?utf-8?B?RGtjWitLWFJjNmMrdFhXZW1ZRWhSdnRhV25NdENvUXNLa21nem5OU2syNEFG?=
 =?utf-8?B?VkFJaDMzc1hWR0lKTndDZmNURExwSm5meXZWemNvVjBScTVxcEFicVhIR3hn?=
 =?utf-8?B?TGFvd2NhRXptdHd1YWZ3MGxqalRJQzI3RTdTRUpBVFpCZGVibGM1R044d1VF?=
 =?utf-8?B?RGVraWNvMzJqTENQOG12Y0NLdmkvNk8wTEJnbXdDNkszeVowZHJORzRZaTBR?=
 =?utf-8?B?OTNKa1JuM1RtQkxyUE5Gd0JDZ2pvUjhtTkZLMnVFMEhxUGRwNGRxQ3VsTEZk?=
 =?utf-8?B?U0dIejFVeXpDVm9vVXJrYUdLdy9qMXN1dlIra0ZwaXZ4Q2FiNTU4ZE5SaDhs?=
 =?utf-8?B?N3V1bmJEdWRTeFJyaXI2ZFdLZ2VScm1obkdKK2J4aW42WFRPRDBsNS9LTFNp?=
 =?utf-8?B?c3QzNVRua2hMdGR3MHF3UEg5N1R2Z25sVzBmUURHeDNaZ01EdjNkYzZvaHlx?=
 =?utf-8?B?VVNTc2dFd2hwVTFrSHVCT0Fjb0R6MjlWVGlzcEtwblkwU3dJdTJMOHN2V3RV?=
 =?utf-8?B?UHZ2MUlSL0RBRUN5dlk3eWxNTHJDUllZMHVNdXdhbFNiVWZwVGZSdGdLRVU0?=
 =?utf-8?B?K0tnYXN4M0tqaUp3MFlMRnRaSFJOZEs5ZVJuczR4QVlEQTNZdllTZlVPRlBP?=
 =?utf-8?B?bFN6WHR0WGFMTWd0b2NUZFRVZkdMYjNPM2pNVkpuRTJlYis3TnJmMEkzUXBW?=
 =?utf-8?Q?psob/ThwzRu0odUNM+SAAVl6w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21963849-4f39-4fdc-642e-08dd68943e63
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 16:20:07.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZPspdr7zG0P2BED4cVc9HRGnMDk5iakt25oHGjyO1FbTIRRe4456vW/GsUkj8kUiV6RkB8S0+PC7/PpEdYTjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6900

On 3/18/25 08:47, Tom Lendacky wrote:
> On 3/18/25 07:43, Tom Lendacky wrote:
>> On 3/17/25 12:36, Tom Lendacky wrote:
>>> On 3/17/25 12:28, Sean Christopherson wrote:
>>>> On Mon, Mar 17, 2025, Tom Lendacky wrote:
>>>>> On 3/17/25 12:20, Tom Lendacky wrote:
>>>>>> An AP destroy request for a target vCPU is typically followed by an
>>>>>> RMPADJUST to remove the VMSA attribute from the page currently being
>>>>>> used as the VMSA for the target vCPU. This can result in a vCPU that
>>>>>> is about to VMRUN to exit with #VMEXIT_INVALID.
>>>>>>
>>>>>> This usually does not happen as APs are typically sitting in HLT when
>>>>>> being destroyed and therefore the vCPU thread is not running at the time.
>>>>>> However, if HLT is allowed inside the VM, then the vCPU could be about to
>>>>>> VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
>>>>>> a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
>>>>>> guest to crash. An RMPADJUST against an in-use (already running) VMSA
>>>>>> results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
>>>>>> attribute cannot be changed until the VMRUN for target vCPU exits. The
>>>>>> Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
>>>>>> HLT inside the guest.
>>>>>>
>>>>>> Use kvm_test_request() to ensure that the target vCPU sees the AP destroy
>>>>>> request before returning to the initiating vCPU.
>>>>>>
>>>>>> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
>>>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

>>>>
>>>> Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
>>>> to be annotated with KVM_REQUEST_WAIT.
>>>
>>> Ok, nice. I wasn't sure if KVM_REQUEST_WAIT would be appropriate here.
>>> This is much simpler. Let me test it out and resend if everything goes ok.
>>
>> So that doesn't work. I can still get an occasional #VMEXIT_INVALID. Let
>> me try to track down what is happening with this approach...
> 
> Looks like I need to use kvm_make_vcpus_request_mask() instead of just a
> plain kvm_make_request() followed by a kvm_vcpu_kick().
> 
> Let me try that and see how this works.

This appears to be working ok. The kvm_make_vcpus_request_mask() function
would need to be EXPORT_SYMBOL_GPL, though, any objections to that?

I could also simplify this a bit by creating a new function that takes a
target vCPU and then calls kvm_make_vcpus_request_mask() from there.
Thoughts?

This is what the patch currently looks like:


diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ae3aa50c7e..51aa63591b0a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -123,7 +123,8 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
+	KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6e3f5042d9ce..0c45cc0c0571 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4038,8 +4038,13 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 out:
 	if (kick) {
-		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
-		kvm_vcpu_kick(target_vcpu);
+		DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+
+		bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
+		bitmap_set(vcpu_bitmap, target_vcpu->vcpu_idx, 1);
+		kvm_make_vcpus_request_mask(vcpu->kvm,
+					    KVM_REQ_UPDATE_PROTECTED_GUEST_STATE,
+					    vcpu_bitmap);
 	}
 
 	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba0327e2d0d3..08c135f3d31f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -268,6 +268,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 
 	return called;
 }
+EXPORT_SYMBOL_GPL(kvm_make_vcpus_request_mask);
 
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {


Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> Thanks,
>> Tom
>>
>>>
>>> Thanks,
>>> Tom
>>>
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index 04e6c5604bc3..67abfe97c600 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -124,7 +124,8 @@
>>>>         KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>>>  #define KVM_REQ_HV_TLB_FLUSH \
>>>>         KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>>> -#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE   KVM_ARCH_REQ(34)
>>>> +#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
>>>> +       KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
>>>>  
>>>>  #define CR0_RESERVED_BITS                                               \
>>>>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
>>>>
>>>>

