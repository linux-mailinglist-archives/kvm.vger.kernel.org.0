Return-Path: <kvm+bounces-72000-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMU7DYdVoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-72000-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5701A7513
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D420230309AF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D073B8BB0;
	Thu, 26 Feb 2026 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PqEftyQg"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D3515746E;
	Thu, 26 Feb 2026 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772115313; cv=fail; b=OkTb9gip6vpKaiZsrNBxYTfk8ZAJAiI24c2ZA5JtniifQtEE2AoZRywNNbqxela9IQM+3YMlgYMy58tMQcV0fGQULeWF9mmzXDkYawTxynI9Gd7BwjYt5U+ofBb6TuUe7KKZjvynhuXOF+eQL2S88aPwQR2iCxO1r8xiCnaFEao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772115313; c=relaxed/simple;
	bh=mx69h7cqIPtw8MMEJm7yPaxLWjBhgMrZgEXxEuDo764=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pTR76rPRZinF2marRoyf92RK/yuIqLOcQvmAOvZm+PisNQ7VjyAd/CJhCXUrHyO9JuJnDF8UgWq25T2gHnetwJSkxiQC0XWv9JMeiWr9I58XLbOPDZq339DfVAdUcd730iE2x1ZWcn6yYUccow7/3ndSq6Xx6ZUpsadQIJVD8pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PqEftyQg; arc=fail smtp.client-ip=40.107.200.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szzu0m3X59/KcpKQgxMGFytzuP9oBogtvg5kueUBoil2YRhmmi5/4hJBdyq4tDh88Zo094lAk72k9dOcL6BMmcaw7GIqBBRJsbfftEEzlY5jy7eRpIimCEWGpR7JWIGzQM4RDDMcgYmtvpgP3QTMuHBUf/6rwQqRtG/8cqYvcjKi1a6OHHjKFk/a6fK5ILEls51ZuKjDCsgHYRrt55z79NdIi2VBjz3aS+PGWQz5LHLlcHa2zCSSLhduFu4YY4tNVEPklLbxOxLbVqmyWHI9qZKi50YdpjW+a0svdtzM/A0ugFgezoO0LPmsAad+AGIF/XW+awzes8GisN4GVJXK/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0XnDESdDqG5iYlSKKB+eFj1fVH8oJgvz/rbk6RG/vg=;
 b=W1iXszFknS4j3sYmW7nugsoOai2T0jZdRbHvau8QDjCD86ReiWkse4g5bhD8UVGY00fQPws8LMEcrdCQpRO4sScsVxSNrl1uGoCdvHqbvOi6fMctoe9YX0XvEv24qn9nXkh9p1YrLAQmWm7Y5OzkPdJIkbHgp/9eKNIMXamn7+q++TLnz4Uxj70/J28LtWcpMFvPjqmtg/BaXh6GstbzkxRH+33zapJIFYUwykJ8AdAvz25REwlpiu3NheK8kXBFcIkm+UD+UcE9lE5+W6ifggC2e2lHkjZWHkKOCAtbymvJrOUncDcBiLoUZTc6OvopruZzzgUgOGEL8CZfIphuxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0XnDESdDqG5iYlSKKB+eFj1fVH8oJgvz/rbk6RG/vg=;
 b=PqEftyQghfkWf9ueA7yvfhq4prRWUkz/4A94v0NMATvo/U6cSY/vlBFt0EvEQAfFlz51BmikDre0DNsSZvHqtgDpgFi64w2L4OHPmWokNh1wisQcrqwOIzYJQ7nt+5KvejVOJHXaq4bK3D1hHIAZZCNUrLNpfDGgxxc1NHb0RVU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4100.namprd12.prod.outlook.com (2603:10b6:a03:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Thu, 26 Feb
 2026 14:15:07 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 14:15:07 +0000
Message-ID: <c92d46a3-48a9-48ba-bc65-4eb0df290dcd@amd.com>
Date: Thu, 26 Feb 2026 08:14:59 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/fred: Fix early boot failures on SEV-ES/SNP
 guests
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, bp@alien8.de
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, xin@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 x86@kernel.org, sohil.mehta@intel.com, jon.grimm@amd.com
References: <20260226092349.803491-1-nikunj@amd.com>
 <20260226092349.803491-3-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260226092349.803491-3-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0027.namprd11.prod.outlook.com
 (2603:10b6:806:d3::32) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4100:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d882cf8-833a-40d9-939b-08de75417155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	oJhwEBK0eb8RK8jBwL7u8c42ZxuIQosoqtNG9Fuxrq+46xxJP6G36IPGpKwdRrFPDz2btXn7ohuICxt9VpUIZbqd1UXx3/LeAgX2b/7s7aa5nNhlKisG98qQyU35uL5U/kQNccemSLwbAcRQtx0x7IEILt8JRFSZLmmAo8h6A1P9X8jipbnAHmhu5dk9ls1YxVIq3GartmMwjJqK+1ndpARRPSYEfDaDxCF5q+MXkUbDezfaEHylzcbj660o4J0+ckszxeqAwGGoyRe99YnofcNhTpNDqAxrXvOs9JYP80axaOXnBwqN1wAOZ1DWj8adk7sopkSj3peDuTCotEDs6pwJGh2vL62ZqlfdzoxqFdW3chfIHb/fKdr0W1/oANXE6Nw4VfxcFTHezreiBNp8QLhUNpMrHLmgNxdNmnLNTq4cP2XuE2WMJ7TVhTiegcPr4ojGBF13bpAsMgiF6pqv744bHxs08iohuUg1uO6ocql70hduKvvIQQ8Bn5DSY+yzL7W76pSKI/Lq0ms2MQd98jgvNwmHGO4vsP4yeO0vq69UBmG20CJU7isA9gEoJ4PBAKnehlVT8qnbQcRMsC8hAfYa4OWQhZZ5EEuTmRQjTWHNrQehqEnFdoOAEe5dVjrZxvO0n5SFLUA7QbnNCyN6AtTI3PC093uvoRebrfPtF6JkDsB7wQ1r9UIwWMzwo5FXKb0LFyG/GdWAgdM8XK8pAbGeswZxgnR72iM/ARshFDQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzdTMnAzVmJOWjk3a2c2eDk0UWc2Z3dFMC9YQkt0endKR2hIUGhDRFpUMGRu?=
 =?utf-8?B?QnZDd0k0cHZjdURCa09WSXU0Ui9LRWUwN1VFWHR1RjFkcEZYSDkrU0RwNVhh?=
 =?utf-8?B?Y1owYnBSVmREbi9MMXJPV280MkJpWXh6L3lsZC9wcjVpeUxQMEZYQUFEZnQv?=
 =?utf-8?B?VkpGMGhZQlgvN0dUYkk5VlcrOVVzU0dMVnFoYk5uY2tPTlJBT0w3NWFOS0Q1?=
 =?utf-8?B?UjBnaXYvWTdIaENKRlhmZEdVa25nNGtqTnJoZk14N1hOdzlIUjVrdzYvODFR?=
 =?utf-8?B?TXFFZ2tMK3poQmt0UUZIS3ljWVU2WEcwT1pINFF4cFhyVitRZytkR3hndlZs?=
 =?utf-8?B?ODg5SU13Z1Erd2VobzZlYTc1YnRMREpBTm9zcGE2Q0VoOHNja0hxNHovVUlS?=
 =?utf-8?B?UXY3UFlORi9YbnBVcjNlWFVsTXhqSXpDVm9wdG0xa1hRRnNUSVp3djB2WEMy?=
 =?utf-8?B?YnltZGY5SHI1MTVEVUc0ZG92TEpOdzZuL0lmbjJyTHpiZ1Nya0YzV05rWm90?=
 =?utf-8?B?alMrcXBLa0JGYUxYMGNzTlMxbEJsQVU5Z2VXeWwwck1NdmxkaUZ3aHJjUXRh?=
 =?utf-8?B?Nlc1SCtCU0VsNUNJLzVUM1hNbnpVeFpFVVNWTHBoanhrSG41aU5mb1BLQzQz?=
 =?utf-8?B?bHZUdk1JRnQ1bklIMkpaZ0pPV2dDL25hZk1PVzNxdXJXVkJhN1BHY0xPZEh1?=
 =?utf-8?B?cjQ5alNmdG1qc28yQWQyclhRM0dJOFR6ZmFNbC9nNldNTlpUK1VOZ1RKaXk1?=
 =?utf-8?B?SWFIZU8wMldJYmgweGtFdzd1T3BNbzRsWldGbEZSUFlOUW5tRTBFbEdxV29W?=
 =?utf-8?B?akg4U2QvNk1RSUxoVWFSOTZKNm45U2Q3MU54eTRkczZsQUYwUTB2MGEvNE45?=
 =?utf-8?B?cE1kWnNqeHNvaDNva09UQVVEc1pnRXNpeHV5eTBmaGVBMTNyb2tnV0kreThi?=
 =?utf-8?B?RVFIczl2WGs2OE9uWmF5ZFhsK3Z4bVZWOFFySmxRQ0Y3eFM0V3d5dnRXZTJz?=
 =?utf-8?B?bm5xa3VjYXExaWxFVitmMm1RMjh5OGU4S3hSNkoxZS9KQmFFbmFTSzRNbS85?=
 =?utf-8?B?ZzJzRVh6UEQrVkNEYUtKRmVuQlpYMGFnOVd1TUhmaVhSM2tsUHVQY29lVzVJ?=
 =?utf-8?B?QXQvTUJjam5kU1M5Z2Y5dlhTQUZmRHlndnIyaXJjbzdsek9LQXpvNGNqRkFo?=
 =?utf-8?B?M2wrSVNTQ3ZTRk1Pd1ZrRk1tTmdZYkJoQmVBUitaVW9ROXZBTUVzY1VZZ1Nk?=
 =?utf-8?B?amxQZ2ZTWFZlZzd2dWVjZFNac0lnZlI1WDJjeDc4MFNLT0Fqem8xR2gyb0dy?=
 =?utf-8?B?RlJHTkFhbWthTy8yZExtVWVjaFBpN1FmRzdJU1ZRSktYK3pwYmw0ek4reWV3?=
 =?utf-8?B?d3d2ZnlMbmdYcllISHFyaUFkMnRHeCtmODVIcVhJZ3lLaXkzQ3g0WlRCTVZO?=
 =?utf-8?B?UjVHMk5PR2N4bi83enhselg5VWYzcndXNWVBSVhCU1RybEhoanIrVnYzUU5I?=
 =?utf-8?B?eTBnSEJpL3NrT0NIZ3lyK2djbW5XWGdQMW8wNnhpUk1qak45a2ZKZDUwejhE?=
 =?utf-8?B?VkVlSDREbVY2TGY5WDhkOHRRZVo5N212My9VbEQ5OFpDekVHZm1vZHdSdDM5?=
 =?utf-8?B?bVZHT0ZiNS9jMVdlZEVNRjZSNllORG9Yamw3cmxsekFOSmVQSWIzdXM0bWpF?=
 =?utf-8?B?cGNUaWR0NkdpaTA5QmlCVkx5cTllbkJzbUpCNVVmbDVrUnNXRlVYdzIycTUr?=
 =?utf-8?B?cXJvcHpJMzY4Y1Y2K01Dck5zZFh2djF3VERXRjhEckxDVkN5S0RMNDVWK1I1?=
 =?utf-8?B?eGgrRWhrOTRzdmlYMUt3OVNEUE5JVmhHK0NaeVhSRDdOdDlYdEZrVm9aM0lY?=
 =?utf-8?B?T2FEWlljV0VGZTl1bmVjcWpPOHpWZlRNNXdzRUZ2c1V1L1YrSXgzUG5xajgx?=
 =?utf-8?B?YnNCSmh6MVd0ZnhPeUV1aURCOFVBUndLemtabVRmUDhIZzVYL2tKdi9qZWJ5?=
 =?utf-8?B?QXk5ajdYZVFvYXZ5K1ovajNieENsdHBTS285UnB2cVJ5b2JqWG9KYThHMXZV?=
 =?utf-8?B?T1Q5aTRpQVR3dTM5anUrYkd2TnNtMXE3QTVJYklLQUJwczVFa0JoYXI1NTFM?=
 =?utf-8?B?Z05CMkRyOWIyQytZQnNqVUtrYWh6bGx4K0ZtVEtzdnRjMUhIQ296VXl3NHM5?=
 =?utf-8?B?aytnL29SZUVPaWxCSEpYQTR0bkxZcmFvMnhYWHBUQVlmdSsvUWMvYWRyZjY3?=
 =?utf-8?B?bmoxMllLc1ZkNnlOVUVURVYrK0JiemgyQmM0dVpFd3owZnB6b2NYcEw2NUgr?=
 =?utf-8?B?bVRqbjliaDkzWWlNMk9SeUd3eElPN3o4N0tyZVQwLzB0Z2JzaW8wZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d882cf8-833a-40d9-939b-08de75417155
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 14:15:06.9389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HnxhA6bRCYgf0EehsUrtnY3NAgKHKBtgXgw2WSf3RSg6zdyn1ilfRjDao/991HKQvyXml08uRgY5SqdweE12w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4100
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72000-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email]
X-Rspamd-Queue-Id: 8E5701A7513
X-Rspamd-Action: no action

On 2/26/26 03:23, Nikunj A Dadhania wrote:
> FRED-enabled SEV-ES and SNP guests fail to boot due to the following issues
> in the early boot sequence:
> 
> * FRED does not have a #VC exception handler in the dispatch logic
> 
> * Early FRED #VC exceptions attempt to use uninitialized per-CPU GHCBs
>   instead of boot_ghcb
> 
> Add X86_TRAP_VC case to fred_hwexc() with a new exc_vmm_communication()
> function that provides the unified entry point FRED requires, dispatching
> to existing user/kernel handlers based on privilege level. The function is
> already declared via DECLARE_IDTENTRY_VC().
> 
> Fix early GHCB access by falling back to boot_ghcb in
> __sev_{get,put}_ghcb() when per-CPU GHCBs are not yet initialized.
> 
> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
> Cc: stable@vger.kernel.org # 6.9+
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Looking at the code, I think there are a couple of call sights that can
be simplified now. Can you verify that? Then as a follow-on patch,
replace the checks in arch/x86/coco/sev/core.c to just call
__sev_{get,put}_ghcb() now (svsm_perform_call_protocol() and
__set_pages_state())?

Thanks,
Tom

> ---
>  arch/x86/coco/sev/noinstr.c |  6 ++++++
>  arch/x86/entry/entry_fred.c | 14 ++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/noinstr.c b/arch/x86/coco/sev/noinstr.c
> index 9d94aca4a698..5afd663a1c21 100644
> --- a/arch/x86/coco/sev/noinstr.c
> +++ b/arch/x86/coco/sev/noinstr.c
> @@ -121,6 +121,9 @@ noinstr struct ghcb *__sev_get_ghcb(struct ghcb_state *state)
>  
>  	WARN_ON(!irqs_disabled());
>  
> +	if (!sev_cfg.ghcbs_initialized)
> +		return boot_ghcb;
> +
>  	data = this_cpu_read(runtime_data);
>  	ghcb = &data->ghcb_page;
>  
> @@ -164,6 +167,9 @@ noinstr void __sev_put_ghcb(struct ghcb_state *state)
>  
>  	WARN_ON(!irqs_disabled());
>  
> +	if (!sev_cfg.ghcbs_initialized)
> +		return;
> +
>  	data = this_cpu_read(runtime_data);
>  	ghcb = &data->ghcb_page;
>  
> diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
> index 88c757ac8ccd..fbe2d10dd737 100644
> --- a/arch/x86/entry/entry_fred.c
> +++ b/arch/x86/entry/entry_fred.c
> @@ -177,6 +177,16 @@ static noinstr void fred_extint(struct pt_regs *regs)
>  	}
>  }
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +noinstr void exc_vmm_communication(struct pt_regs *regs, unsigned long error_code)
> +{
> +	if (user_mode(regs))
> +		return user_exc_vmm_communication(regs, error_code);
> +	else
> +		return kernel_exc_vmm_communication(regs, error_code);
> +}
> +#endif
> +
>  static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
>  {
>  	/* Optimize for #PF. That's the only exception which matters performance wise */
> @@ -207,6 +217,10 @@ static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
>  #ifdef CONFIG_X86_CET
>  	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
>  #endif
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	case X86_TRAP_VC: return exc_vmm_communication(regs, error_code);
> +#endif
> +
>  	default: return fred_bad_type(regs, error_code);
>  	}
>  


