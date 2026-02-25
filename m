Return-Path: <kvm+bounces-71888-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sNhEBXpcn2lRagQAu9opvQ
	(envelope-from <kvm+bounces-71888-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:32:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8365E19D485
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6097C30E66C5
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C2030F80C;
	Wed, 25 Feb 2026 20:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b="QCuU5+Xg"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020072.outbound.protection.outlook.com [52.101.193.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8613A24DCF6;
	Wed, 25 Feb 2026 20:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772051436; cv=fail; b=p95jmtrpdSACrhLePyQ811gr4Oh3OtqS6LgMX6FTsZC7P5oQXy2oUdrM0+EqNgW748YBHpJ4+EsfIbyiBjuavMr1uxFTf+qeYRF9CqxGF4TK6/AzB6EgNPaY3LPUECSfZKPf+pcHXDE5HfAHwlr+5ZNo5rQuurxteupWn3Nc9YQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772051436; c=relaxed/simple;
	bh=6+bcrAR3Sy85VgyEN3AvEHsIB1wlghG0N3YGhOYfmXU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UlP28QxZNIuFutKq0lN069P7cqQrfzcWZB19SUfy5ACLDo4n8/+haLNdiZZBtzkvv2FMy+iAu70a5FLRHqsQFpICPC+q+vxjPfc6AKl/ZkGAyJoI44u+GcggoxtQ1GkTqSXzXXMqYRGoUUOr9PGpOizxCjmRBCyti81p9TX6BiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com; spf=pass smtp.mailfrom=fortanix.com; dkim=pass (1024-bit key) header.d=fortanix.com header.i=@fortanix.com header.b=QCuU5+Xg; arc=fail smtp.client-ip=52.101.193.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fortanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fortanix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XuoPFfLyreigcCW29XrEItBpKts/Abxf8/KRll4R77fCw5VjgL5YCqkx02e+FkqRTzjqybb8X6qPDw8PIrS4N/wjMDINvEQobDDRc3A+kNZJeO2rCyscWbXAMh1+7tlXlC8s3AnDQl1gPlawvbJHC3e6E7YhrLQSx1ny64EiVXlgtQixtIqUQuV1HbeaEhtElmVbVpxOkhHE7hmViiyAEjzcd/3+JCHyTpbfkJK994D8XvmzNPSoiruz3xhfqTPRIhafxv/Oyybnywtgb6bAUe8lJEcyJ9Mn+39JrLzx35nfS57ZtSMHL1cyrvHPFsu7HWGOJN1nTV6/S8w54Bns2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHDUses87qTmRwH+6re4KoxMWuVFjF4rqFuqWb9z0nc=;
 b=us5ekFnDwSlhKTCy6Nv4mJBUpHAQtKBFLiSOF0DbjnAXH9LcVdK3Z1THFmeIWPHDbFSeXTM26SKHeArKVbn8nVWmfS6RVrEjOKVcKVxQqss3mPniP4Kduoec418Vf2x+jD4LX0g2Iw21n7FmStfq/eLXB1kWo+MSRFOtO7GqcKKeRDvEkKDIUdrpGO9+bnTTh0hxQPQ2/89YkZkvMcmfTHiYU6EtNYin4RKV8jMtY2CnjDp/7ca+WdLXbrjFVqpX3pYlpYMYWjrDp11IstGjncpNPptDAXbmJ3AkKJEXQh0/J3jU0VfIwVZiQjL35/a6IrQ7HwaAp4Zs8GhEmV9ntg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHDUses87qTmRwH+6re4KoxMWuVFjF4rqFuqWb9z0nc=;
 b=QCuU5+XgnXaAx02lba90epUS5Y99b0/GE739AI1/aB/+LF1kxl+PAtven0o8nqzccTg0q3k92QoyKsVyJUVrHXgkA65aWZbY6e+AJYR5R9MnXEewgBL+paxHFHF6I3pPYksulpOM6AmLcGV/4Q4bT4xc/BqaXdz63AeKFqrKFgI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by CY8PR11MB7172.namprd11.prod.outlook.com (2603:10b6:930:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 20:30:28 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::64f2:5af6:ec99:cb80%4]) with mapi id 15.20.9654.007; Wed, 25 Feb 2026
 20:30:28 +0000
Message-ID: <64a01647-2f99-44a8-a183-702d6eb6fd81@fortanix.com>
Date: Wed, 25 Feb 2026 12:30:55 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
References: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
 <aZ9V_O5SGGKa-Vdn@google.com>
 <928a31e1-bb6f-44d4-b1de-654d6968fd55@fortanix.com>
 <aZ9Zs0laC2p5W-OL@google.com>
Content-Language: en-US
From: Jethro Beekman <jethro@fortanix.com>
In-Reply-To: <aZ9Zs0laC2p5W-OL@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0109.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::24) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:EE_|CY8PR11MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: 69a427af-2579-458b-95e4-08de74acb6ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	vgCWVpNwaBJPT3JLQe1Zfxq1i+6nVgFRJ2ubXajM1JkNLs07otrkdVVCNW5hn1yD2UHPEG78KUhv/r5F66nIdTWPEPpvboWvlsp3LAGdc3JxfmKeR3CwcVeCpnTnsexEmmePivbmu/jl1vPfD5cSMQOYoyK/9N/x2GeUC9O1LnTlor16ciFUx6r21pjuhtfTD1xXcwHI3bEYcspyo5KMiXU9+wWmF1bRpft567/x15OsTM/v3EQ/DIKPXj2Gz/CJPPpa84FfPOL7YXTQ7zt802zld0FJkRroMNGBUnVN05wpLM7BDzusamYybMu9qhZ7cKYv/I8cd5Yai6VcTYbFvLinH5csNZxoFInAipbz4pU0JiVQHJF+1EEZ3MGaFu9OFBZNglRDXJQovrMP822wESAnA6gx25wAKQ3X9H/C9YujQVTHQvbiZQytX05XYVf+ZkscDQ+PnIng7aun/+7/Fqwxty+3uxDVR7oRd78mpHDxMLh2NDdCSdLoYAkEq1+J5U8V8H3/YrGyUYgyM9MI7/F2X5F1Qn6d+HnovhZ1qceEnn1d0kRPzeRjf05KnO8xgJC8Qmb9xXn95Sjwe2AoKbamnvIuA/bXq2HEWq+poNYQ3OHKjyRccjhuuLoEVMjbviA46WU2R3zbFpCxF67idx8PzM/u66I9SXHM7igUNmf0WiEsdhnUR9Hw//Ch4zeCh2knAzsyidwERyVlmzG+g6G/WpWmruqNV5+0xytHjCw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlJXb1B0VERhc0lMV3h0MFc4T2g1b2FkSytMckE1bDhmTlZFQmdHL2JUdStu?=
 =?utf-8?B?Y1FoYm91b1pSd0V2UU4yS0xDVUVFamFEeW54ZUlLbFcxeTMyamNTL1dVaVRG?=
 =?utf-8?B?a3hKN3Iyc0MyNmhaMkFtT3h6NUFONXNvSXVSRDRrNUIyMTV1YVpEcDZ2S3Q5?=
 =?utf-8?B?WGpjU0ZRNTQ3VEpTYUJBMit4TE81bG1yMnFRMVRWdHRsNEVGa3EybVc0OUYy?=
 =?utf-8?B?TWZySlVnM1hKUFpvaWVXL1JQK3pKVHNZdmkvRG5ibWJWUTM0NytRaUVEYzd2?=
 =?utf-8?B?bTlTYXAwZ09BMVQvSXJzZnE0SllWUTBjQXlTL0VqN25nVmx4QTg1UkJyRDJK?=
 =?utf-8?B?cm1uQkhjRHJWK1dyaXBvY01EZmszblpjVkxLNXZQTEVGNmlJSXFZbGthNFpE?=
 =?utf-8?B?RWpyMHZYNmdXOWZ4bXFGNkQ4ZXFieDRNeTl0YWZDUlJvNEo2NnFlcGVKZXRB?=
 =?utf-8?B?K2x2dmtMZlVla1FOUlFOTE5uS0JBd0ROLzlodnhTcVQ3dmVDNm9oTGY3M05i?=
 =?utf-8?B?SmFtQmxobFpOZW1pVkVKTFRVSFgxT29lZnhSTkdvanFaTHh2b3pQRzM2WE0y?=
 =?utf-8?B?VjVNelNrQ25xTXBhKyt4bEJvS3NEam1KYnBUVDQxZmVuNGp2d1BkMGdtekZD?=
 =?utf-8?B?ZVFFVUpGOWpFTHFPWmtVTVpsd0hPYUVMMGtiWDc4amh5RmR3RVZZY2JST1Fl?=
 =?utf-8?B?blhnVGJ6TUp1Q1kwWlNlQlZhc0dLTWhsMytUbmcvK045ZlVkWXcwRGFjVzZ0?=
 =?utf-8?B?OEtjRFJObk5uSVZyam82QnNTVkRWbGkzMllONUM3QVlSbjBaNnY1R3NIRWZl?=
 =?utf-8?B?M21LRGNKMExUcTBIRjdsQXlQTU1peTBZaDE4Y3kzcWVIRVEyNm5Eck5BbGo0?=
 =?utf-8?B?a2w5U2M3Q1M3YlhZcndzM3pwWks2Q09DN2J1MUpXbXFrZTdsYUpkaGhTRDJk?=
 =?utf-8?B?UGhnUGUrUlV6cWpZRkF2YWZML3B6eGdBRSswQTBieWF2WU42OG9iYm9Fa00v?=
 =?utf-8?B?RGEvc0c2NnpHUWVHMGNoL3F3SU9jNjI4QldFcVk0QzNyYmxsdDMxTHZ5TDdq?=
 =?utf-8?B?VTVzbjZTTk5aMVBTdFBsOVVzTGU1U0VPd042L3Vtd3FFa1o3end0K1pnMExG?=
 =?utf-8?B?UDZWbU1UTGhtMUlrZytzT0tGVzRWR3NSNElDbmdBYXZrNkg3b2MweDVmNFBw?=
 =?utf-8?B?ZjljWHlvb0tMR0h6R0t4c0NvMGo2VENpR3g1R2NVWktFTDAyM0tPeHhVOHU2?=
 =?utf-8?B?WmZDLzJ2MklLN0RzdWg3d0JlMXBQR3JTTmpvQUpsaS81bEQzL3IwYXR2NzJR?=
 =?utf-8?B?UUp3ODQwc3Bjd3RZR1ZwVlNFWXNZRjRiM05Cdm0xS2tLV1NWbGVTcm5CMUVF?=
 =?utf-8?B?K0VXcFVYdmJOOWM2NzVSSElhZHFtRDZ5aERYUEV2Mi9pb2dzd1dLUlp6d0l0?=
 =?utf-8?B?U3ZUVUVhZVN3dTZ1SnNsYmphNElDbHF5eHVvMXZIWEJvZ2tEZENCbWdwbGdF?=
 =?utf-8?B?ZGdSTGFLaDQxclpRQUQwdkUxUG1EOTJiZWt3ZjhZcUlRbUZlUWZoMDFrZmtl?=
 =?utf-8?B?UTVKcGJwTUwxSXE2MWVuRm9lbVEyVGNRSHVScHR4cHdUMVRNNjR0bDl2ZGxH?=
 =?utf-8?B?c3ZoL3kraVFIOTBCZjh5L0NteFgzV1RsanowQUFiVkJOaEJxMWtSVXVmS3J2?=
 =?utf-8?B?R2drQnVnQU1Lb3hJNjRQM0tQZ3JkRE82MncrVHlTRHByelpvcitTTUdEbGtG?=
 =?utf-8?B?VWNsYlpiVVhYMXNDR2tlazRFc2d5U0NWaWYvOCt6VkNrVlhCNWFTaTAwbXB2?=
 =?utf-8?B?RFdabGNZcSs1Wml4QkR1dEhCMkRsOWNCUGVCWnp1SnF3M3p6K2ZQTHowSTNG?=
 =?utf-8?B?a3luT05ZMzkwMUJWRnUxeXRMbnJoS0s0YTF5VEI1bkZsQzZXRVB0enI0RWl1?=
 =?utf-8?B?UHo1MzlvVHR2K1lJOTJrbStraHBTUGpOTGUzTFhWSUhwTlByaUMzKzg5bTB0?=
 =?utf-8?B?eEJTbEJya3JXZ3pZY1FFczkyYnc0a29mWU5lZXhybVJyLzVWb2pKWXM1c3hw?=
 =?utf-8?B?YW4rbkRCS0xJSlZJY3grcm11bzNjZmF6YXpDcGd0WHVmNkY0K2ZVbm9iSm1P?=
 =?utf-8?B?WXNIMFdPaldXdGMxdEFMeVNweUxwYjFQaFBsYmRTSi9Xc1FLTlVybGNwSnhj?=
 =?utf-8?B?c3RoMWxiaFNiUHlNeWlJL1djckNCT3ZpSUljaHNrYk9qamZiREdma2crZm10?=
 =?utf-8?B?TzNVSlFhRjY4ZEhFbFhLRmNHcEVSMkJmSFN6ODd3MjIweHExa2NyYTZwL2Nv?=
 =?utf-8?B?a1gwb09Pd1NRNUdDZTBmMlNPbndlcUZ0V1lBakg2eTVQL2NTeGRMRVA4WVRO?=
 =?utf-8?Q?0FVCfrVzRz9AY0es=3D?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a427af-2579-458b-95e4-08de74acb6ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 20:30:28.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MloYzs1u5Nw+1cyo9we4fvm81DHOmqop6Aulzv+SrB2WskLjraKwm//dCzlDCcKo4ugsDIwBJoXV9zb2Al/jXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7172
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[fortanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[fortanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71888-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[fortanix.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jethro@fortanix.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,fortanix.com:mid,fortanix.com:dkim]
X-Rspamd-Queue-Id: 8365E19D485
X-Rspamd-Action: no action

On 2026-02-25 12:21, Sean Christopherson wrote:
> On Wed, Feb 25, 2026, Jethro Beekman wrote:
>> On 2026-02-25 12:05, Sean Christopherson wrote:
>>> On Mon, Jan 19, 2026, Jethro Beekman wrote:
>>>> Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH results in a
>>>> kernel page fault due to RMP violation. Track SNP launch state and exit early.
>>>
>>> What exactly trips the RMP #PF?  A backtrace would be especially helpful for
>>> posterity.
>>
>> Here's a backtrace for calling ioctl(KVM_SEV_SNP_LAUNCH_FINISH) twice. Note this is with a modified version of QEMU.
> 
>> RIP: 0010:sev_es_sync_vmsa+0x54/0x4c0 [kvm_amd]
>>  snp_launch_update_vmsa+0x19d/0x290 [kvm_amd]
>>  snp_launch_finish+0xb6/0x380 [kvm_amd]
>>  sev_mem_enc_ioctl+0x14e/0x720 [kvm_amd]
>>  kvm_arch_vm_ioctl+0x837/0xcf0 [kvm]
> 
> Ah, it's the VMSA that's being accessed.  Can't we just do?
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 723f4452302a..1e40ae592c93 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -882,6 +882,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>         u8 *d;
>         int i;
>  
> +       if (vcpu->arch.guest_state_protected)
> +               return -EINVAL;
> +
>         /* Check some debug related fields before encrypting the VMSA */
>         if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
>                 return -EINVAL;

I tried relying on guest_state_protected instead of creating new state but I don't think it's sufficient. In particular, your proposal may fix snp_launch_finish() but I don't believe this addresses the issues in snp_launch_update() and sev_vcpu_create().

-- 
Jethro Beekman | CTO | Fortanix

