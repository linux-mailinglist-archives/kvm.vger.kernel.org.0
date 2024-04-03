Return-Path: <kvm+bounces-13421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC062896364
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 06:16:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91E16284DD6
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 04:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EE54AECB;
	Wed,  3 Apr 2024 04:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zenN+hkp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2134.outbound.protection.outlook.com [40.107.244.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2AD4120B;
	Wed,  3 Apr 2024 04:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.134
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712117757; cv=fail; b=SKdIxipHrPThMJ8RtkQ7oeUkswVgAP28JsNcFfA1SSNvWxlCFJw5waCFvPoXekQQEl8nqwuA5H3H1NGjBz2Lr5OMn4qOH4hX+DhXg9s7NyFsi4JlHGDNYYYF/MPNSBwmKtS1vkFMzvDqWPACllRanP/cXJK8pKKYrGiXuscLD1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712117757; c=relaxed/simple;
	bh=+TgMOk3CxuSMk6Zxtw/eqatA/Jd1jOSJ9jS+ZV5NHHQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l3Qz8gWVLCz9JbEfoQbgzvo9Ta5RUXIEEO5z4Et5lX+Lw44tQyUSy9ChA/4RM42a4nUQpecLeQwjPVuGCVXsqdSLygjuhbpQooABkp5i1KnpeDaLWeYfRVNf7o4v1hcpT5gxAW9MrZui7A2XShPhILyuoJvrlRCgX3Nxk835kfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zenN+hkp; arc=fail smtp.client-ip=40.107.244.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPQvPP2vYZK9Ejfn7/GHOS0u3EgIdOrk5BJ0FZ3y6UlO+yVp3t5Dvq15R/k/g6H7IeDOK/yTVIIZ13g4OhkAutl94lu2CAV21liE4NudDKSrKNW+MFmQqYOL3y7dL5koouExWWPBvOP0iXXnj7lF7jCEYctMy8gHHw6aJ03tkv3EoK4kjXXycMBhrC9FE9stT02HGsYl02COFMrNkPqGqSkCNNvULd+dK8cwWbZFBxMC78vkQFsGzRAwEwaoUb6A/2JDtBxgf2vyocLU4RgIwk64J8hfmV7D++c9mfMAOm5cxruxUPg2VnIIozWHIivl+cge9dYetb7TFCPQLk/NVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Pam8D6eYcwSXikOa58Tm3Ev/Xsz1b/4+b/9UjoYGLQ=;
 b=L8ZgYK9J9Sk3vx2FdRWKX2I7FpgpROlnVlOk7ux4IUiX+jPQEQPzzz+uiK6BpcWiMuH1JB/s1S0J08i7BRVECO01xmr68oDcz4Oe/0IxBPcA3fnp7TITvxVWGesmd9ZDho7Zpp58wruQcg/zBI56CO3U4vzxs/qqgdlNPybzufGFmFStKWvUoHsmdEcB5GUx/tHSWhi2ozK5vm2UH1CLIWAc2CHgabqV5FQpM/yceYTpqGteVYwaDjf859ViB9s8ar9Ne3wZ6QxJ2V9hZkJNkA7ve0Qn2/aI2T172qUoOG4KcUXToz3vj9+RkMXKAeH4nRQThk5lHtbGun1AM3aKkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Pam8D6eYcwSXikOa58Tm3Ev/Xsz1b/4+b/9UjoYGLQ=;
 b=zenN+hkpCVhWWZQXikkLnk5QGmbHuyK25JzYtg1f10/Be/ajdo0qC5bkWaSZi5vs6lAk/t/eWNZu1Mrv98f8Ag9kcS+WIutKVkit7yqGwqGSegOondmkv3YSP7/RuSo6v4hQGBRoF3dawfSbGtfzPGed+7NwSlVyJh1jgcqUdHI=
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by SJ2PR12MB8926.namprd12.prod.outlook.com (2603:10b6:a03:53b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 3 Apr
 2024 04:15:52 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::df03:ebca:7c7a:9530]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::df03:ebca:7c7a:9530%7]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 04:15:52 +0000
Message-ID: <29030dd5-ccd8-48cf-a25a-e98966bf57bb@amd.com>
Date: Wed, 3 Apr 2024 09:45:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] x86/sev: Fix SNP host late disable
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
References: <20240327154317.29909-1-bp@alien8.de>
Content-Language: en-US
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <20240327154317.29909-1-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::19) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|SJ2PR12MB8926:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qUYORLZa3d+jVcDSO197YgFR/vRAuSJRKWBC4GAOH3eqwvq9QMkynzOwgoqWv+tx3W962zxGoh3otn9N3pOvfwz8r1wLe888kdQ0MnHFFDz28pZK7uqTdWBwb8EUckHHa8VFYOuAEzojhIxhTDpLzRSLcLuqyY4YamwUgkpgK32Ki6DoQ+a7ubM0eqR/F6xa0NH9eI3rpPrhDkxj+pk9OCqSRrsNP2zFgy5mt+ZUqbM83EqxgRi8q4+if3ESfdN5lA0V0K2+kW5FUCpNhDddTT1aqV7+ynMWri0zu0m+Sabw4+hZmx5YW44cxSYMa0OrMo+StboWLbLhNd2lNczFIn6iJwAx6XIrad8LDAiZckWib3nB35yH71qA6KpqpvnlDNMKXv/aY99WbYfAQPcS/JsVWlAzFWUsKu9z9+NXPv56lz33gbWEpd9ygIhvmXQUjY9JvMkc6EweNNrL4Kmrhz8OOKAy4PpZkOYBsZXxK5aS19suIt2q7RKmXFncVHPAwVEkjsKs2+p4Kj+uqAhpY2GZho9CmsGlRuaVI64h4AC4Lsj7MMb50pM1L20IUkiwb8krP//rqnI0bfmXbMdx2BKWWsIxlB3IOLnp7EXokrspDL+FGYCKYbH7TVCuj0XztH6WD/jyP17PMHYxU+0DYKlz7msdTc4KaNS4Gp9s+7c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yy9qMld0MVF0SU1Fd09WTkllZ2sxTHNOcHdtM3Z5dFV3YnV2WC9aYU4vWkgr?=
 =?utf-8?B?b3VSQ2E0S1FhNVM0NVRrZUtDNzRXaUpwTkRKdDRWdjhVQW9PQW16TFNiSVkx?=
 =?utf-8?B?NWg0ZWJrVGVFR3VmcFFMNVdKK1JXZnhUcEZQQkRTTjZPY0JtQ1hWTUQ3Yjc4?=
 =?utf-8?B?MjRIVmx2eGpRTFBqNmpxMHlScnlVSG9RYVp5UThtMG00QXd6TkpXN3VYc0J4?=
 =?utf-8?B?TjNRNGluZ0Iya0FCbkdyKzBCOG5TbnduYml6V2VsT3JZbFdZRUtGMHlFUXF3?=
 =?utf-8?B?eE45bkUxOEFFbGRQVjNNakZzWTUzdXBJWkpxTjl6Z3BZK1Q3R0NBVGtoeERo?=
 =?utf-8?B?clBOdEJSSHgzOEhWbnNrOC9WMjM1QXVhUDJjVnJMTDhxK0k5cng0dWJIMFBt?=
 =?utf-8?B?dUhtbkVrY0liSUFYM1E0N3pTYjlEOUwzbDRIZFdINFNkREVKVlFhbkF6Vkcy?=
 =?utf-8?B?WSs2ZXk2a3h0RmRKSmFZaWo1cTNqck1GYXpoTVpIcVFoRWxUQjQ4NWF6bnB3?=
 =?utf-8?B?NW1JbXpHUUh1UTdPbVhYV1VhVjhuT09DVlM5Mk9KdFFwWWpqMHZkOWZkcjE4?=
 =?utf-8?B?Q1FmVVdwZllDcFlPZzRQY1RKejNpSlRVc0YvV0lqN2puTWZYUlJUYXhKL0Fi?=
 =?utf-8?B?MkxBZVFHbHlkNEFiT0ZvVHMyOXB2cm5RckcwSWIyR0FoQ09ZcTgwTWZUL2g5?=
 =?utf-8?B?aGJMTHZpS21LdVorZ3BNMDJmRjBTMDJUYWc5cWUrZjZ1c0FMUGVDcWxzcXZR?=
 =?utf-8?B?Ni9zR2FnQThZaWtNY284cFFidFpTdWpnMnErTmlWclhKTkxwblIzcXhlR0lJ?=
 =?utf-8?B?bkFDMmVsMDhlMDJVREZTSWtrdzNNMGtyUkJYSEtBb3M5VTJKQmJzWFg1S0V3?=
 =?utf-8?B?TW4xT0llcWtMMUVaTElObnBYbHNYSjRTRjFPNXdmNDEycERZSGpBQlA2R1lJ?=
 =?utf-8?B?cG40THVrSWVwUUpGVk41UHArVTVmS3AzVm04Lzd0ekFQQ010SjVIc0x0TXhi?=
 =?utf-8?B?Z1ZPV25CaTc4UWMwTGZyc1VLekk3ODZybWZXR2FHZFo3YkRFQi9haWxlVGVX?=
 =?utf-8?B?NnZUT3N1cmtpY2hXbUxRQkMzaStEaDZEQW5MNk83a1J6TmVLM09CWUZwNWYv?=
 =?utf-8?B?d0lhQXlkK2lDU2tBTVNUODhHYmlPdFJ6Vkx4RXZYbVVNUG5CdkRLQUVVMHJP?=
 =?utf-8?B?KzFhTnRVSGhLWldGbFozQjJScmtWSjMzWXVCM09ObEQ0ei9qV3kybTgwc3l5?=
 =?utf-8?B?ZGdrNmFhcVJVMERsQXJFbjFObnIrVmhMTzdnTkJGSnkybU5kRUgyb29YRWxN?=
 =?utf-8?B?WXVmbzE1ZjlzcmJobVA5cDBXclljV0M2cFBDbWFqbkxudjVKYzhqYmRabmds?=
 =?utf-8?B?bVRyR2R4cnhoMFNrL1BHOXNKRkF3c0dhVmNUWTRZRmFiZkZBb2FPQ3ZmZmxQ?=
 =?utf-8?B?VTV0YUFEcmM3SzRhcllXZXdTZTdsUlZMb2dLSmlKQXBPbDlVelRNck5IUjB5?=
 =?utf-8?B?blNISTFpdmh3V2F6TkFBS0h1YXJPc3psL3FPQ3JqdGRkMCtDbGs2ZlBLR1pa?=
 =?utf-8?B?K1FMZFowUHpKMFNTYmpRYmxoZFJkMm41Sk1LQXRsT0ZSeEZRT1licmo4a0hw?=
 =?utf-8?B?Y1V4SWZHZG5oRFZVSXd4V0dZbk5nT21hMjUxZzFlVnJwMzB0aS9PQlBCRUN5?=
 =?utf-8?B?Z2FyaE9YaFU4bVRHcXhrZ2pvZUpubHAvNXRwL1ZSUG9YZ0dyN2tuZ0wyVGRL?=
 =?utf-8?B?eFVtZzNveU9oNDhzdGNjNE9jYm4vdGd0UWlDa1d4VkhGdlJFMmZ1anlHMU1B?=
 =?utf-8?B?alVDa0czRk9jeEs5cUF3ZFpVc2JYS09wTFZ2R0c4bUxvbU1JaldnN1hiUXRP?=
 =?utf-8?B?WFZQb1lNN1VxclpLaGhUYXZ5NzNMa2ZHdGNTVllMend5VWJFTTJobnJaeUo5?=
 =?utf-8?B?c01uWEc1WGJmWG9ZK2VLeVpUbjlEdnY5L2tUU2FsS1pHWjFSQytXQW4xYTJM?=
 =?utf-8?B?WnFHcHhoZ1Fvdk1EVzJPMGdyTDdnOVpWMUoxckhkbkNhcmNwVHRaVC83QnRG?=
 =?utf-8?B?Y05KUUF3ZkFTdE5PMk1XaGlXeUFXTFRQWVBGemd6VXNOSkkvaWlZOGg1WkVy?=
 =?utf-8?Q?UniW3/1T7xTrbANRSsC2iJ23P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a9e25f-7138-483a-520f-08dc5394bfba
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 04:15:52.0071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXV0cYDyKMMNReL3eKGyEniDwAW6vna3mNQRahE1bk623OpiZM00IPSuG758eaXMxnYR47l+iuwSQp6OrH4iKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8926

On 3/27/2024 9:13 PM, Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> Hi,
> 
> the intention to track SNP host status with the CPU feature bit
> X86_FEATURE_SEV_SNP was all fine and dandy but that can't work if stuff
> needs to be disabled late, after alternatives patching - see patch 5.
> 
> Therefore, convert the SNP status tracking to a cc_platform*() bit.
> 
> The first two are long overdue cleanups.
> 
> If no objections, 3-5 should go in now so that 6.9 releases fixed.
> 
> Thx.
> 
> Borislav Petkov (AMD) (5):
>    x86/alternatives: Remove a superfluous newline in _static_cpu_has()
>    x86/alternatives: Catch late X86_FEATURE modifiers
>    x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
>    x86/cc: Add cc_platform_set/_clear() helpers
>    x86/CPU/AMD: Track SNP host status with cc_platform_*()
> 
>   arch/x86/coco/core.c               | 52 ++++++++++++++++++++++++++++++
>   arch/x86/include/asm/cpufeature.h  | 11 ++++---
>   arch/x86/include/asm/sev.h         |  4 +--
>   arch/x86/kernel/cpu/amd.c          | 38 +++++++++++++---------
>   arch/x86/kernel/cpu/cpuid-deps.c   |  3 ++
>   arch/x86/kernel/cpu/mtrr/generic.c |  2 +-
>   arch/x86/kernel/sev.c              | 10 ------
>   arch/x86/kvm/Kconfig               |  1 +
>   arch/x86/kvm/svm/sev.c             |  2 +-
>   arch/x86/virt/svm/sev.c            | 26 ++++++++++-----
>   drivers/crypto/ccp/sev-dev.c       |  2 +-
>   drivers/iommu/amd/init.c           |  4 ++-
>   include/linux/cc_platform.h        | 12 +++++++
>   13 files changed, 124 insertions(+), 43 deletions(-)
> 
Tested this patch. I could boot with snp enabled and iommu=pt mode,kexec 
as well works fine. Thank you.

Tested-by: Srikanth Aithal <sraithal@amd.com>

