Return-Path: <kvm+bounces-72773-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCJxKB3fqGmjyAAAu9opvQ
	(envelope-from <kvm+bounces-72773-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:40:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C532209F41
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A07A3025264
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 01:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527FA242925;
	Thu,  5 Mar 2026 01:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ROG0DZ65"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F2013AA2D;
	Thu,  5 Mar 2026 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772674837; cv=fail; b=oZMDQPhoSXNy3Q6ZiVrys2KIckEq1v8792S+1xXtrFFbPoxNn5x9WNgVOyJBChu5u6EBMT1zI/IJq5LnWMztUJM5jaXC86rVwJeJynvcthiJXg0UcPDLWhwQ+EQF82r0TFYpH1LJvfh0DMzHCif1fZSNTyZnCG/wbTZwgVyNYz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772674837; c=relaxed/simple;
	bh=w2KCMNM3b+cIEmmPyXLxCMB98lk1pbGED7onrFYBMjo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j/V1dsMFmfgvQMfJIdnqnMfuIAsvnZMnLx9O3oTDm+VwUD0E8gJ1uSfhpPfrzrujFFA7nODu0cLbXtLdeqWEilbR+AQnpiCIE07ZxfTtGWIqMefmDgZ3QROC4crv6x7v2kDk1xK1uzHcN/t6uw1IIbJLxuZ8s+8x3tBlHffosCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ROG0DZ65; arc=fail smtp.client-ip=40.93.196.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F2ZFkAmda6INwt0KWDuhu/+FuOlpsGJKvAiqRS5ddXirLrnIYZmbmfEprgaqdYeZwPXXXRNF5AcTKjHWikA0UmB7VP7/JZDSW75UrhfEs0L/RREf2xdvNiNRpnH9kGKkMSmF4lJ50Up2LjTmC993eE4Je8MGqWlZ2KMcUIJwQBQpKnVxpBM//KKLtleny2cdzi/XrKWjH5igziF6NG/Bbf8AqSfiuRHHQyGO4YT7S70/Ulsqrv+ChqiYeEhazE4oy6agQjv5oJkrrQEj5AB2Zt/i6w1LHIcx1awuF7a41sqrLll539Zwnxi88ttgGqA1yt0zcFiR7QFYbxp4mCy06g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05Wu8OHCOCjDRFOgPMSRsh2a5dG9MSzmcR/xIXkcVEU=;
 b=Vw/XxW0xF0v/0hKi8tEDKIx5E8bX5ItYBHbwLNx/YN2hHMMwQ1Lk0uxGwLa+28DupuKQueuD9sQa9+NIDbOkcZkwliLfj7XZTQoyNTKdFMDE9eMWLHlCE+Tw8Ig4wTHlFobSHZHTt02Gw+pL+dvHSV0Yj/gJMmPBiRMPL+l/MPZSh3xPhOxssE5asORPILlbUjttbTi9hs8JSYepLGHQkWmeHD9temyZ1z3NT6gZUlITyN1lmhIZuvWn1Ro9jG+kb3i8KIW5DEEf1e2IzJD2EzqKFNyj5XGxmsGasbyJYTd7UdOzlYywF+/kfHL1728rkpLs2YU30B7xc3zMhAJ5jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05Wu8OHCOCjDRFOgPMSRsh2a5dG9MSzmcR/xIXkcVEU=;
 b=ROG0DZ65iV//oOaOaI7Fi1QOKujUgyC8vztO0IXfKgb7WgHYhkQvzpMGQuOQKpofbxu2u/kjufTCFLWhoJTNScFxgi3fp4Pa24bEdzM9UFCovan9368ew2BoAlgCyRo8zFtP/xynEmcsOYA+8xlE99WmaPl84appTvHFze1dtrs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB7969.namprd12.prod.outlook.com (2603:10b6:8:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 01:40:29 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9678.016; Thu, 5 Mar 2026
 01:40:29 +0000
Message-ID: <0fbb94ad-bfcf-4fbe-bf40-d79051d67ad8@amd.com>
Date: Wed, 4 Mar 2026 19:40:25 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
To: Dave Hansen <dave.hansen@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com,
 Michael.Roth@amd.com, KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
 Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
 <aahH4XARlftClMrQ@google.com>
 <7ab8d3af-b4f5-481c-ab2e-059ddd7e718e@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <7ab8d3af-b4f5-481c-ab2e-059ddd7e718e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::14) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB7969:EE_
X-MS-Office365-Filtering-Correlation-Id: 54fe225f-bdd9-40cb-d444-08de7a582eaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	MtkeI+NkGSxNp/raHTdovwauQjm6/Xg69A/OjPts2jXEjav2m61NpagqwNj9Kqcoi9ge91YvUxjRleTX/h+p+BI9UIV0Fab6Z8ATBjeEsqwx+Pl2JWBn2s7NAt3HiNd99y22DlLI0tR+fWNdokhTW0415bl7PHdq2dAjoh8AUAyfg7qZp6bWB8uQyWhlvxnalBQbVN3pte/4zIuGTWL7v8FPi+vwTqBsviYPJGW0PImH0pkjd1QHVhWajNwKtOG3wdbUwYn+US/vhSGYqujXZXRrW+cg9u0mgWPziJge72+7etD0ItgG5V8VIq3FflL374tygMVVdQDD6Om0iZlBpSo6ljEaXXF3EZmFFM0eAjrGYDlVfZcjChavSBSnW4yIh6umj6qIGGTjI0dH0GVCXI3UELCKDxyzuO6aXr5AzAEDcx51kfolYBJzkcLhbqpAUJxVcKaK99qOrVhfC7X933Suhjw+hgbzxKZRvxc9AXxZBdYErCq9H0UgJ51Eais7ckWLxt/c2ORKG1qKwh7M5EuCHy0u51fN0sHDg1Q+/tiqPU4uq9DopRmsxcV3pNvl2GMuDgrp8tjiyNbYaBIr35cAOirOsS7ssg4+7ETrC+Jkdu1IHnqWy22TqjdGFaSRehhs8lpahU3bZSgV/ay7r9kfD5KrJrnJejuZwjYMl3CfzOYTKZ0R2I0gV9E+iE0vIE1EVMSVrTl/R7Mj111u3WB3X8LpkSBUj13QRrM423o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VmZIdzlnUTlFT2VVclRhd0U4aVF5QnpseVBld2R1R2ZmdEN1b04vTzJWTW1a?=
 =?utf-8?B?cTVRMm5zR0dXbTNZZlQreFFIcHd3aHZKUXdsYWlKZmVwblB6eDhabFZnNUpE?=
 =?utf-8?B?VzdGZUtKQUVkbHNHR1oyb3dJWEtaYk82ck0xekdLWTZFTnd0Yk9zdElqL09M?=
 =?utf-8?B?NC92eG9YV0pYdkdLTlM3b1haWU1BN24rOUIxRmp6c0VqK3lPd0dWYkVQa3d5?=
 =?utf-8?B?cXpVWjVMbC9MUUtoVzBSTVhtSytLKzJXWFAvT3ZzVjk1c2o5WUl3VDJyWkJw?=
 =?utf-8?B?QllBNVRuWEN1b3NWR01YSmpVR294WjgwcDBLUWFac0pZZ0lKZVl1aEd2QlRL?=
 =?utf-8?B?MXpMSWRib2puRGR1R0E0S0ZHSC85djJwZmNadVIybWl3T2VyMHJJaEQzNysr?=
 =?utf-8?B?SGpsNktvSzUrclVJY0pnNFA0TDVncXRVcXdOZTZ5NE9iSm95S0tTUXFLazhU?=
 =?utf-8?B?cWVoMiswUEh0OHBhMTh2aGFCdVpwcElweERXU2ZkNzZSTCtyVmxSRVBkUWpq?=
 =?utf-8?B?ZlNzdXVydnVaWFdkMlJvRVY2bkxXMWFmeXpjSWFVcnNMN2lNUGg2bUtqbjZO?=
 =?utf-8?B?NkdZZmNRb3U4Y1JqZCt3SDBEQk9sUC9Oc0swV29YMlQyZVp0cGsvbmJZd0Jz?=
 =?utf-8?B?dUdGemNXU29hSytNN25oR2k0Wk4vOWo3cUt6a3V2NmZhblo0TzFnb2trR0dQ?=
 =?utf-8?B?c0NKQUpkcFFucUxubjlpeUxDNmlRL3RJM1M5UWF2c3hFdEY2TytWNmJUQW9F?=
 =?utf-8?B?ckd4dlpVVjR5ZXMxQ1BaMDNOL2VaMEtXY3FlM1pLUEJQQ0pmM3NPQVlObnYz?=
 =?utf-8?B?RkR5NTBqYmFBcmNtZkprWUxUMXY0V2J0RGF4aEtyakNjLzdkQ2ZBNWxIeUdx?=
 =?utf-8?B?d0x4V01qaDRXRTRMMnpVTGl5eXUyVEcvWWo2dTBLOUxCVTZ5MXY1alNZSjJl?=
 =?utf-8?B?N2VOMGI4alV2OW9uaGF4YUZhYmhmUmlIK0pZSWNFK0hTeWhqK21xcEhhRUZW?=
 =?utf-8?B?MzlGbHptMyswV3FPcUh5S1dsL3h4ZzM2c1BYVDEzSjdmZ1FHa1ZiYUR5ZmhD?=
 =?utf-8?B?WElpQjRZVG45M0ViMXNBZzYwQVl3SDg5MHErQlAyWVVhSWVneks4akdyeXpx?=
 =?utf-8?B?TWtCVHRSTTVvb3dmSkNtRWszYVZ2a3k1SzQ4SitkMTR5TGk2Z3pxbTBmbVhx?=
 =?utf-8?B?V1ZveWZsVmxITUhMczRBT3ZYRmt0aHhHL2I4cW5pMXp4QU4wRzhnVDhXT211?=
 =?utf-8?B?Y2pVVHRFT0lXN3JoeWhROUcrNnljajhiYTVyRUdvVXl2L2UvMXVtRGl0VlhM?=
 =?utf-8?B?MWlZQVB4YnpVYWhIRVJSL0ZHdi8yRlVSNXFXdWpPdkpBR20xSUtEcFZIWDVr?=
 =?utf-8?B?eTNxRVFqTWl2bW0wS2U1UnlWVWJFUkljOGpHQisrS1Y2WHhqQ01pbmpOQTE1?=
 =?utf-8?B?bGNreVN2bUQ0VzRubTRRY0REN1ltOXMzNjBBZXJtVm1PanZiTit5c0FoKzRN?=
 =?utf-8?B?L1RMQ1ZsbWo1Zlhtanpwc1VnbXdnTWFJc0xUclhJZnd1TzhCZlpmQm9UY010?=
 =?utf-8?B?cEY4ZjNrVGduSGRxSTFLR3ZWY0dHU3gzN1I0UVJIeWFPa0VwZzFGblhBUEN3?=
 =?utf-8?B?bitaSkZpQVFNMStTdmt0UnlWcnBXeS9BOFJMM0xxc1lKTDdqZVJKOGdLOW1K?=
 =?utf-8?B?VzIxOWJtZjQyWXVqcndENENWdzhDdXRhRTkvYkpkSU9xOXJFSXREQ2F0OVJl?=
 =?utf-8?B?S3VSQStsQ1dydnZmck5udnRrSndiYXB3aDdZRTgrYnNQV0diQmd4WFgxSGpD?=
 =?utf-8?B?TTE3M0h1RjhDWHVDdWFteHhhajIzQThVdU5mYk54VjM5cm00ZndjYjhnS003?=
 =?utf-8?B?SDFPSVN0ZFRBMDlnUEVaTUhMenQ3Ykt0TmUydERnNDVReHBYeTMvVHlZcStU?=
 =?utf-8?B?Y0lmeFZiRjJGMXhZTUxZdWVKTmlSa2pMSTk0cnpXUlRLV05WZmdyRXlIWHFx?=
 =?utf-8?B?Ylo3NC92eWdVUU5kM1FYdDdrc3BvWHo0Vy80bkx6MDJnQ3pyVi8zNUZwY0F2?=
 =?utf-8?B?aUtQWmZybS90Uk9qZXpPV0I2akhoZzdGYkpOZ1Vqc2lqeTl0THYwbFpsaS8y?=
 =?utf-8?B?d3NaTDhObkIxa2c0R1FGSC9XZnJPMHFvVUdhN3hSWHBUejR0Wk9tdUFqMVhE?=
 =?utf-8?B?di9CZlN5cndtN3A5RG1jVDBVd1h3WXYvTTgrMjZYTDNWRnNSOTkyYjRidkZG?=
 =?utf-8?B?a09jb0IyY2FXMHVpbThtUndLNTd2aXd0djFNK1dMVDArWEYwcVp1YTNqNXhG?=
 =?utf-8?Q?rheK+Q1/AmN4o0SV/w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fe225f-bdd9-40cb-d444-08de7a582eaa
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 01:40:29.4302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyrKYHZbbFiisfFtUHv40AFrTHRA3r50eJRGlgaqyvmx8aTn7EUBtQsa3YFrzot71Y5Ys5cf+pwzan47P3km1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7969
X-Rspamd-Queue-Id: 4C532209F41
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72773-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,amd.com:dkim,amd.com:mid]
X-Rspamd-Action: no action

Hello Dave and Sean,

On 3/4/2026 9:25 AM, Dave Hansen wrote:
> On 3/4/26 07:01, Sean Christopherson wrote:
>> I don't see any performance data in either posted version.  Bluntly, this series
>> isn't going anywhere without data to guide us.  E.g. comments like this from v1
>>
>>  : And there is a cost associated with re-enabling the optimizations for all
>>  : system RAM (even though it runs as a background kernel thread executing RMPOPT
>>  : on different 1GB regions in parallel and with inline cond_resched()'s),
>>  : we don't want to run this periodically.
>>
>> suggest there is meaningful cost associated with the scan.
> 
> Well the RMP is 0.4% of the size of system memory, and I assume that you
> need to scan the whole table. There are surely shortcuts for 2M pages,
> but with 4k, that's ~8.5GB of RMP table for 2TB of memory. That's an
> awful lot of memory traffic for each CPU.

The RMPOPT instruction is optimized for 2M pages, so it checks that
all 512 2MB entries in that 1GB region are not assigned, i.e., for each
2MB RMP in the 1GB region containing the specified address it checks if
they are not assigned.
  
> 
> It'll be annoying to keep a refcount per 1GB of paddr space.
> 
> One other way to do it would be to loosely mirror the RMPOPT bitmap and
> keep our own bitmap of 1GB regions that _need_ RMPOPT run on them. Any
> private=>shared conversion sets a bit in the bitmap and schedules some
> work out in the future.
> 
> It could also be less granular than that. Instead of any private=>shared
> conversion, the RMPOPT scan could be triggered on VM destruction which
> is much more likely to result in RMPOPT doing anything useful.

Yes, it will need to be more granular than scheduling RMPOPT work for any
private->shared conversion. 

And that's what we are doing in v2 patch series, RMPOPT scan getting 
triggered on VM destruction.

> 
> BTW, I assume that the RMPOPT disable machinery is driven from the
> INVLPGB-like TLB invalidations that are a part of the SNP
> shared=>private conversions. It's a darn shame that RMPOPT wasn't
> broadcast in the same way. It would save the poor OS a lot of work. The
> RMPOPT table is per-cpu of course, but I'm not sure what keeps *a* CPU
> from broadcasting its success finding an SNP-free physical region to
> other CPUs.

The hardware does this broadcast for the RMPUPDATE instruction, 
a broadcast will be sent in the RMPUPDATE instruction to clear matching entries
in other RMPOPT tables.  This broadcast will be sent to all CPUs.

For the RMPOPT instruction itself, there is no such broadcast, but RMPOPT 
instruction needs to be executed on only one thread per core, the 
per-CPU RMPOPT table of the other sibling thread will be programmed while
executing the same instruction.

That's the reason, why we had this optimization to executing RMPOPT instruction
on only the primary thread as part of the v1 patch series and i believe we should
include this optimization as part of future series.

> 
> tl;dr: I agree with you. The cost of these scans is going to be
> annoying, and it's going to need OS help to optimize it.

Here is some performance data:

Raw CPU cycles for a single RMPOPT instruction, func=0 :

RMPOPT during snp_rmptable_init() while booting: 

....
[   12.098580] SEV-SNP: RMPOPT max. CPU cycles 501460
[   12.103839] SEV-SNP: RMPOPT min. CPU cycles 60
[   12.108799] SEV-SNP: RMPOPT average cycles 139790


RMPOPT during SNP_INIT_EX, at CCP module load at boot: 

[   40.206619] SEV-SNP: RMPOPT max. CPU cycles 248083620
[   40.206629] SEV-SNP: RMPOPT min. CPU cycles 60
[   40.206629] SEV-SNP: RMPOPT average cycles 249820

RMPOPT after SNP guest shutdown:
...
[  298.746893] SEV-SNP: RMPOPT max. CPU cycles 248083620
[  298.746898] SEV-SNP: RMPOPT min. CPU cycles 60
[  298.746900] SEV-SNP: RMPOPT average cycles 127859


I believe the min. CPU cycles is the case where RMPOPT fails early. 


Raw CPU cycles for one complete iteration of executing RMPOPT (func=0) on all CPUs for the whole RAM: 

This is for this complete loop with cond_resched() removed.

      while (!kthread_should_stop()) {
                phys_addr_t pa;

                pr_info("RMP optimizations enabled on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
                        pa_start, pa_end);

                start = rdtsc_ordered();
                /*
                 * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
                 * memory does not contain any SNP guest memory.
                 */
                for (pa = pa_start; pa < pa_end; pa += PUD_SIZE) {
                        /* Bit zero passes the function to the RMPOPT instruction. */
                        on_each_cpu_mask(cpu_online_mask, rmpopt,
                                         (void *)(pa | RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS),
                                         true);

                        
                }
                end = rdtsc_ordered();

                pr_info("RMPOPT cycles taken for physical address range 0x%016llx - 0x%016llx on all cpus %llu cycles\n",
                                pa_start, pa_end, end - start);

                set_current_state(TASK_INTERRUPTIBLE);
                schedule();
        }


RMPOPT during snp_rmptable_init() while booting: 

...
[   12.114047] SEV-SNP: RMPOPT cycles taken for physical address range 0x0000000000000000 - 0x0000010380000000 on all cpus 1499496600 cycles

RMPOPT during SNP_INIT_EX:
...
[   40.206630] SEV-SNP: RMPOPT cycles taken for physical address range 0x0000000000000000 - 0x0000010380000000 on all cpus 686519180 cycles

RMPOPT after SNP guest shutdown:
...
[  298.746900] SEV-SNP: RMPOPT cycles taken for physical address range 0x0000000000000000 - 0x0000010380000000 on all cpus 369059160 cycles

Thanks,
Ashish

