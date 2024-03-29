Return-Path: <kvm+bounces-13097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7161F892123
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 17:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E255DB35EC0
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 15:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0792D548E8;
	Fri, 29 Mar 2024 14:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Reqi5eJF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2112.outbound.protection.outlook.com [40.107.100.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528022EAE9;
	Fri, 29 Mar 2024 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711723377; cv=fail; b=TJKYv5AeiDkEY747dWyTN4gr6bX+Fp63DTcaLT/A4MfQHpVSvJIonzkAJ0Kgd8K/CVK/zYNF6A0EopcPpOUaXL5QpESVqA1kCynzNiMqF5bF580xKcSQBeZTBvKgDQUYHvTLv/kDYzhgAMD1kBxLTvFAMOxkJtzAZMHSPJkaNe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711723377; c=relaxed/simple;
	bh=HkKcUyK8G1CE6K9f6L1KlymPYQLQNVo2UshuUoDk9f8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WFVADaZ5GNJYHPEzaCxJ0ZjwAWlTJJfJLODyGYnubLtL21NxooGO/TGMicDh542yDIUv5trtYkHtUmWzodv1AkjPmQ2tjWWnvo+AbxIsRZjQ6V5sIdd1l5WLzTf7+egkhGArp5eSlPRuvUad1lbzyyMqnu8HHUBhTRpyxifoBD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Reqi5eJF; arc=fail smtp.client-ip=40.107.100.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIthOkvhVnwlexJ9jau8ecjZx4Ye0i6o0K1WBrVXcM6MZcvL9h1lUDYQ+wEbjSxtarN8lD5CzdX3EZwGawH/4HiURAseYyyFAGToyzcOfHCNBDBf0Gja2JS/3YeMST5Rzlh6IlotVYSPDgjhB0bP23K3DXK9odVyi0AXUecoALKxNqgmteWqEw8OSgEkSx/qEHDAeuZDrVD0lBIdTh6R5pPTuglbib1+8SbdVd+ixMEPy/UHloEWOauLlefTqbYQ609gQfoedpAjB7XBazadV13fRmB12h2gis5BUp+jiWj9YNhACiWn4Pj69b2j1Dby0ATSvm0ukBXmyPUPPGeCjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2AVw32XdJZBKDv2fgwwJu+JlG/1ARshs0VrrTzQPwY=;
 b=f7NpoanQkWAAPFgRSg7E6sB3iDoX3zEQ/dZ156MzL01jh5LwDUvuHETlzDKGF/QNvO+BtpIW9TQQuYjXv2V3cyQaoyQ4QcfuA61yIjhbaXwvhZzWqzCycUtGXRB6HmXDcpNuFmSy0pzRdDrQypSsi7P/LeJBIT89U5qf6788qZ3ZXumKk5Si/yl7unKlpm8kFpq+lCeu9EWN3iQJh3K27k/u3mxV5lSSYFKjiQHN91uvJkrFWCUT8Q9LaHE5p9kPpENQ+cdDgMFWEHV9SMuKt01isaM/u5rWAiP8MELD+d0ERsysKGVRPGGBjTLRshQ0jziqbpd6uyWaXdweqiwJNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2AVw32XdJZBKDv2fgwwJu+JlG/1ARshs0VrrTzQPwY=;
 b=Reqi5eJFZL5HRK1XPPruoVTl52yKvVS0z8gFkSK0iQZ5VUgPQ/js+hYokn/1/fKCQA9QkxSmn9pSu7JVr5f1R5VooZkOZ0SEIeH4JP8jUQxzW74jq7yq5R1GmRev/Zg+Mad9q1bheXWoXvYEJowAZUwpXoOvG1rnuikkyZLPz9M=
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CH3PR12MB8281.namprd12.prod.outlook.com (2603:10b6:610:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 14:42:52 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 14:42:52 +0000
Message-ID: <256a0447-d7a4-5983-34f9-ffaba51035b0@amd.com>
Date: Fri, 29 Mar 2024 09:42:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 3/5] x86/kvm/Kconfig: Have KVM_AMD_SEV select
 ARCH_HAS_CC_PLATFORM
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Michael Roth <michael.roth@amd.com>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-4-bp@alien8.de>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240327154317.29909-4-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0111.namprd12.prod.outlook.com
 (2603:10b6:802:21::46) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CH3PR12MB8281:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zcBlbw8AJRmeX3qKb1s96BXKZCT5j8IKKnfWcAmJ1u2ajn0po8XOnR6o/gu3kDSyHzHLsG72kAx4DE3bA7sTVWmczutL8SYiIC3jIk3nMOjX1Yu6/bQVHAknhkTmPyJQvLsQPK6/8fo2ooKr76IR+H1Hr9HN0Fca63N0ryYWmjmRtZWLmV46S8JhYsermJTZg5iscMGOzI8b19obcCiEk2aqqHEbWqEOa4FCPW/XV994dEnvmeeQTCxcoTbLN+zjfKjdVte/Jv+j8gtbsl5fgc+mTpWZBPJvPXwk98LiJuDCoxDKOIeFAAYyVzu2D637Wn2P/4G62vpnSCjlx/CrT1ko2in/NzjCXTmAV01eAlWUIMjuIl7Wv2s/ZgOEXQTrL6nGeBVLFcIzo3f4Uq1Hshnl/DnuWUv69bfZOWui7N3scqLecOUjxF7Tqsvf/bWmVEQYwCQOZsGEkIDg9a0Gf4Kn8mwm1ll94qplaRYU0idcRaklCmnDKSrxtQtnt9Nwr8raH0UgQeMJEfyqel2UREDSX/R1SPrTzcgF4GhX2DwZpdGOAXbkY4gFo0X8KbcgSV4L6dfeOFk2BseaQBMIHMlVFmhBIDpQdDrxPDDPUPtw3uhI6YSV09c7WY6PoOXDnWZIT2WWgCzO+3QEr0XON4IGPFy9RCmZ3GgjSjK220Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWV0Z1o4a2dLVmtMMG04Ni9xaVVHTXg1dnZBYUtNbjFIV3dQRXlRdit4UmM1?=
 =?utf-8?B?VzI0aTRSZ2FIL05XRW5rMm9qR1F1UW04aURIK0NlbEdvK1pmcTEzUG91UTVM?=
 =?utf-8?B?RWZLZTh3bHRaYS82c0JLSWZUcDkzSGwrL1crOVlpQUh2WmtJT0VEKzNvT0k1?=
 =?utf-8?B?SldoNkVVQ3ZpQXY1UWllR1hmR1UxMWsyVnJQS3FKTzhCWVpOTzl3bU44Z0c3?=
 =?utf-8?B?RmJHcG1aV1NhUENOTmpZUEp0WVV6d0JhVmpmeFAvYmVVMXJWRldnY0pabE4y?=
 =?utf-8?B?aW1DVk5LM2FOQWIyZ1ZMYmdndC9pWUVHMENkYTZiL1ozc0NmWTJwVkdOcmpp?=
 =?utf-8?B?VEFHOHhJc1RXZWNNVDZiY2p1bVVtY3hYMVpHRE5NNTVLdFdoK01ZdGZXY3BZ?=
 =?utf-8?B?eGF2SGFNODZHcWJEcFBYaWI4WXQ4a0JYcUFQSitZNkRjYm1scE9FaHA1WGls?=
 =?utf-8?B?NklVL2RjMCszQXRPd1hXMDlLU24xSmRiMUJETWxVRnI5QnNDQ0tIR2JPeGFH?=
 =?utf-8?B?V1VMUDE5WTNSQjZSMnpxYzNkLzZ2RFZLVEJKMkpQdGJoOUphb0NSa1pvQUl2?=
 =?utf-8?B?SEpkbU5temJxNUtPcXFxR1Rxd2x0MWlya29BdjlLemZOMTJSc1BQd2VVa0Z2?=
 =?utf-8?B?dWNta3QvdzhXd3NFTHhxb1J6bFZzcklHUGJPL3ZudHp3Qkk1SStsMDVOK2Mr?=
 =?utf-8?B?eGlEalErKy9CeG9CaWcwaWFraTUyUWEybzJ3dWdmSjNvZHBJaTM1ZjRMbkhX?=
 =?utf-8?B?dTNhM2IwZldMN3FTMXloTmY1SFlqaGtvSGtYM0lsU04rYjZSYmNkamIrNlRi?=
 =?utf-8?B?QVZjRVBEY0hxbG1hS3pGYWtaVk9pQ2dYdmhXc0xLOVJnMTdjK1hKSkQ2RXFa?=
 =?utf-8?B?NEVmYnpoWmVEd3c0ODBETmNyTVlCOURoUDhjWTBUN2ZEQUkwamxHMlp2SXJB?=
 =?utf-8?B?elNWMnNURHFrMXAzV1I3ME1LWjFIWGxRaE56QnlReUpQRVd5NFF0Q0N3VnpF?=
 =?utf-8?B?cTUrb2w1MEptYVV3RHFWSEk0SEZGU1RwaFpoRjh2eGgvZi9RNnRiSmNWN3No?=
 =?utf-8?B?OUtDdGdtNE9mWlJlSVI3R2hVTXp3a2wyY3BoOWRSeXpDcXgzTXpQMUdEcHpG?=
 =?utf-8?B?b0JNbG9mZW50azRGdHJsdjZaaE1qVWQ5QlpMT2tvTGtIQzlaL2JOTE9iQ3FD?=
 =?utf-8?B?T1dZYVg4Y0JEc25NNGNxS3NFMWd6dmZlY2NEbVhoczdwU3lhbHM3eDFJTmdL?=
 =?utf-8?B?R0hyengvQndGNXp3SFRFcCt1NXBKUk9iNzlxbzJzM2pqcUVjODJ0MERScVMv?=
 =?utf-8?B?cXA0MlFZMm9iT2Q0cjlHeTlOb0lKRzVEMFJQNDdkQ0ZYcEV1VTYxN3JqVEZ4?=
 =?utf-8?B?VkdiNXpZTXg0a2plMlB3c1RSTVVnNExwNUxlUUtnU3M4Z2M0NHZlMjQrYnV0?=
 =?utf-8?B?TGFOUmx2dTFxeU1VNjROT25jZ0l2R0VtN3UzaDJxSjh4SUdVeTNkQmRPU2Qx?=
 =?utf-8?B?d0w0WEF1WCtCMDdPcWhLUng3RDJMTWgzNGlvWXc4N3JDQ3hQUjBzc0tBVmFz?=
 =?utf-8?B?S2ZLcFkyYVcyYWVacnA2WkowbDIraXpHWmloWW1pVU1aby9CTktWWkdtTUcv?=
 =?utf-8?B?TjJHTEhWaU1kQmlRV0ZlbU9yVjhjNkIxVnBPZ21Ma0UzZXIxTE9uMy9sY1kv?=
 =?utf-8?B?c1dDQXVvYTRpcmdGa0MxYnBBckJ4RU14MW4rTlJIRU5UYkIvYnV3bWNjVndK?=
 =?utf-8?B?YURRcTkrYlpFdm5kNnl2WE84WmR0RU9FdHhsSk8rWkxxckVHcTRZV3ZIWXdU?=
 =?utf-8?B?K3RDMko5dEY3ZlZEL0tJQ2tjY0laRUI0blNaN2IrcUZ1TkRCVXNmUEs5UzEx?=
 =?utf-8?B?RVhJVmM1THhkZlAvdEg5T28zU05ScjBRL0FxWE9NYzd5bkNQTm13eGxDSHFs?=
 =?utf-8?B?elZPZk1OYzhvZnJuRERiTHVpU1BOa2hWOHVPTUdHT2RDWThSbjNXMzI4NlYw?=
 =?utf-8?B?RUpQWncrclo5dktDS2NXOGR0TmNnUWVEUS84aGNVWnZuaklQOG9SWkNwcW4x?=
 =?utf-8?B?c1kwUzBwdzIxWWpKb0NzU0p0Q21CTHg0c2pQTzY1SUltdjY0Z29zbWh6cnYy?=
 =?utf-8?Q?cbIFocGv2rxiF5US8YMgmsD0r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5078b3df-db70-4bf6-eb06-08dc4ffe8332
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 14:42:52.2910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICvT/WQkfKu3+H14xYhchjIlKf6Ja5tounxJRj9XHYkDlUH543U0TBp9h0hfg8MYLJcKYQjylCCKdpd1i7T9nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8281

On 3/27/24 10:43, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> The functionality to load SEV-SNP guests by the host will soon rely on
> cc_platform* helpers because the cpu_feature* API with the early
> patching is insufficient when SNP support needs to be disabled late.
> 
> Therefore, pull that functionality in.
> 
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 

