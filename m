Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BE433F4A0
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 16:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhCQPwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 11:52:31 -0400
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:47713
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232502AbhCQPwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 11:52:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uyio6Eo7xT08AhPiLyEM9Vw+3DTgY54dlmqs+2Dhwh0Vf+FOHNIwCARMr8FXQU2y3+6jHdV4JYyLcUW02yDnbdCbVtqBSsDweLJJehgHXD3LMVNwxsvjSnVrGHgKJjRmbeLPFX80vVMx98cmYSkrpzPKcxM34jR/LTIPENRbsPL1Mhm54+WTy7FC0DqG2ABZRVR18jyv/tcb3eCfc5IUXe4IzKwDXTtUqTyOAsAwzbyvfgpuULwWm1h370+WoauQW/kqUTr7kM8CdpHrD25FiAL3zPm+kH0QONch2YIjTcb2VFPAkxsURxkoKknR0Ylp0+1tTQAP4Z/Um26U4KBwbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x53OR9LnBNYtY1DspfC/r26U7bjLDVkP2d+v8qHCQYA=;
 b=EFI6i5c3aMRU9WO5y7kyLLMcyXupvjDBR0+o1W8t7oNMZIUKdLpDMFIEdkjS41iCBwiVToMGulcIATNOwpWP2NpuAwq2BLtvhlSJri+nXlhpjl1AqPTttg1T81aUHUNqu6kjfUrG10f1pfdlO6qse666mhEkTr2IXdcC+LgKIuSjWnF886el0b8ZEpB6W5NdJy28OH/XYoZmUHIYD7vCd9rVTkcMuyT52SiP5xsgMhD0GF5eJW2agBKgY7FxK6w8LwBP3TGlY3JuZ2pcAoFB5EVTDUpQmbSEZ6H5kPLs08i3l/Gtn+UOAobW51CdVXoZZdyHOTSUD28JVKZdtpE2VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x53OR9LnBNYtY1DspfC/r26U7bjLDVkP2d+v8qHCQYA=;
 b=S4oeODKT2zEkepNvztIyO8JfTs3Errhhd7u4qIMFSlCjLZTcfPtexqbldMiLMr4de8iUcoT6seNRFftIpZv/LMJ5aE80dzanFPNdmVMLCUbKiLeC2guKHJxaEM34EYv2pckQXt5teKVbWvzMcZY89cFGLB8tY/BbHim+76IC1iQ=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4530.namprd12.prod.outlook.com (2603:10b6:5:2aa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Wed, 17 Mar 2021 15:04:23 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 15:04:23 +0000
Subject: Re: [PATCH v3 2/8] x86/sev: Do not require Hypervisor CPUID bit for
 SEV guests
To:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20210312123824.306-1-joro@8bytes.org>
 <20210312123824.306-3-joro@8bytes.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <85d933fb-3839-79b6-a151-0c8f9ae44230@amd.com>
Date:   Wed, 17 Mar 2021 10:04:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210312123824.306-3-joro@8bytes.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0115.namprd04.prod.outlook.com
 (2603:10b6:806:122::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0115.namprd04.prod.outlook.com (2603:10b6:806:122::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 15:04:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e186b93b-791c-4ab1-66bc-08d8e955f2c7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4530:
X-Microsoft-Antispam-PRVS: <DM6PR12MB453035DDB897179A3FA417BEEC6A9@DM6PR12MB4530.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fue1nDq8GZ2ZjodtEhTSpd+WtIcuCpsX1uC9K0kB4R0ubjv+9X9/A8ipipVJ0yWdACXVyNnVJZHtJ9AFbppA5HjCpNT2wuupQ71HwNV7p3goeUR7XgRpNL5SXzlKhcxgzwiLa2iD+NTSFkTCHZI8GEjG0vw5RrT1ciq9d1aAX7/oy9hIc3xzSwMAXgkf6N5YqBoa5G1zlPdcqWnuPkEQWspYnC/CeQd+IfkkI7SJ7l7/gDB6HlQ07VaPA5id31gEVTG/r1pmDN+xhSpc4kQGBPK52Wvsv9nmQ3kFlDPA9e/H6Og4gS8bS1kqGEQ2EDx+uTpvGEIfMza/2ISyX5VKu7ilz00SDfnBrcSXJzJwzgRwh7Z/0u/I73nIDth05s+wanhB2Modr3v8HDYAHdLEf1Z1q4T36NcW16Dik7NdnRBqUpaEAz9bCWF8JItGuHyqSko//HtqGuxa/6XAjy+orwaOOO62Qcjkuzu8rmrj3v9u6udNMO8IZNMJBzevoK3SlTUiHGa7m49WXSElSQHXuUzwRaEEawDUjc+5r//xHVf4ye6q+9srPeHrv27U86SQDgYSOTJB1t7HnpMHWwKgXK+7OKPx/MO7w/WiYYO4SA21qlcZRzN1vOxl63r6fkWhcgsfr+BSTrBT+FcQ79tvEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(8936002)(4326008)(8676002)(26005)(186003)(16526019)(7416002)(6512007)(5660300002)(66556008)(2906002)(66946007)(53546011)(36756003)(66476007)(6506007)(31696002)(478600001)(6486002)(86362001)(31686004)(2616005)(956004)(316002)(54906003)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UWxDNWx6cHVTTHBpZ2F2KzJucXk4VVY4eWRJRkU5RTZ1a1VjM3VlekF1emZi?=
 =?utf-8?B?ZExrOXl1bGhPcThoWjFyVzdvWVJ2TmlreitYNTVwUFVGaW9qc3BBaDFSUlpy?=
 =?utf-8?B?RTlpSUxpM0dsZW96THhPMXkzMXhqZm8wWjV2VGdRVlZkcGNTNnU5OHgxcml4?=
 =?utf-8?B?WHlQN0I0VmdFQWUyNVBKVWUzUjRnNUNTTklJQVNiK0c1N251YlZ6TUpRTXds?=
 =?utf-8?B?VGlDR2RiMjFOZ2xFZXlNaFZGSWtkMjZsVmdMSm15OU1ZRHl0dG43eFZtck91?=
 =?utf-8?B?Qi9zbHYxaGk3QUcwQ1VGUzFQaEV1Sll5eUEwWXhqb3M3MXJ0Zk9uN0pFRzVV?=
 =?utf-8?B?UlF1VWFGcG1KVkNnaW1lSk13QXNXcTFCcnVMdGJpVWZwV3d0SVFvQlFERjd5?=
 =?utf-8?B?SGY4cGpTZkhZQzhUTUxkbHVyQ21xbmxWdkU2ZXBLNFBwWStZMUR1cEdHRS82?=
 =?utf-8?B?NlJSYUNmZGhack1XR0EvMEhNelhKS29NTXhOU1dwNW13TGthblMvc2ZFM3R0?=
 =?utf-8?B?U1FmNmFNTm8zR3MxV1RFeVV6cjNvTytpSnpFajRmcXJyZzhCU3pSd1pSSGY1?=
 =?utf-8?B?M2hVcDBxeC9RcnpzeDZ1MU1uNmJMRUFDZFhTMmZ4ZEI0VThOTnZOL0hiUmd6?=
 =?utf-8?B?bnVQVFpzVUV2OUprNHA0eGUzMnRyUmVPSEM1Y2EyN2hWbUUzbHJGUEpybm9S?=
 =?utf-8?B?UDZGU0g5a1pLM09uRkdxTjlhenVMbWVIWEdKUzhnY085eWtqMmxuNDFzenFR?=
 =?utf-8?B?ZlNjQkw5WjZ1SkJUdVFEK2VZaDVyZE1LRTNVbTRmKzlsTkZTeEZ4RkVIZUhQ?=
 =?utf-8?B?Z21DaDFGUWNPeTZmOWtIQjJQdVFyQVVMUGYrWGo1RDFNVVpENHliWkxuUVlU?=
 =?utf-8?B?dzdkdTVWdCtkYWxmVWcxVGFCR3RSMlVXVlpYb3N5WXZjZ0J3cXBIYmlSbXAv?=
 =?utf-8?B?VjNUNEErTVA5R3hGR1pHcDBSaS9YVUE5cDN3Z1ROOFJRclVDY3RJV1dmcExZ?=
 =?utf-8?B?UWp4blErcDRxRm9majBGWkgzOHZzOWJIM09KNGMwbGMwM3lqN3lHNWhqOG9o?=
 =?utf-8?B?U25GM1BxWXJCUkRnUXYrNHIwRUZhRVVoSUhhVlowS1E2WXpXWWhNMTU0V1Zr?=
 =?utf-8?B?OVVDUmNSTlIzazNBaVdaT1hUV2R6NlVjcFhocy9DN09ucEJnaVFHRDFYVjQz?=
 =?utf-8?B?a05JbHVxVGFhWVBRMGlZODBVRE8vYmg3dEdVTkZncVE5NVRHQTlNWnUyQTlJ?=
 =?utf-8?B?Y1d1Wm5BQ0p4ck1OSzJBd1R1Z1hTNExLWFRIbThER21RWkFKRnZSaHo4WDYy?=
 =?utf-8?B?WW4vZlM3eTJOT2NnSGI5WFp5ZFJsd1ZGZklaL0c0TzNqcU1aOWFnWmh0WWg5?=
 =?utf-8?B?NzEwNXF4Nm5wVjF4cDNEQXRZY2M4eUtFVzRSWWJ0VnN0VHRucHdDVXB4dktj?=
 =?utf-8?B?NHJDeFFIY3ZyYVJFSSt6VE5wTTNnQi9WTFdLNk8yS3VLTk1rQU5aVXNoekpk?=
 =?utf-8?B?UTd3UWh2MXluTmVCZFdha3pvUVNQbUFka0U2aUJYQnFIb3VsVFpzaG5rVWVH?=
 =?utf-8?B?QjcvVkNtK3liNnZIWU9UZitZL1dENXhHditDWjYyMndraHJkYnBwdnpyUjNP?=
 =?utf-8?B?RUM3SkR6VUVWWlc1TGtFbkxVWWlEbjh6eXF4OFRvOG5vWis0VzhpYzlGRmZw?=
 =?utf-8?B?VWhBT2dXTkl1ajZ1TGpiaThIY2JiMXNxc3JUQVFaSzhIMmxUWHdvc2FNaFhT?=
 =?utf-8?Q?3t639H3rGBDyrV2F3wTnHQgBKrHu0kkPFZqUNW/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e186b93b-791c-4ab1-66bc-08d8e955f2c7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 15:04:23.0230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEU8lfO+an6YHivfDFT2u/d/QUSzMw6MKvQxssj0TNFP49cFhVf+Zi4dEJsBpcUwtN+gIemV7fMlXuwBB0knSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4530
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/12/21 6:38 AM, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> A malicious hypervisor could disable the CPUID intercept for an SEV or
> SEV-ES guest and trick it into the no-SEV boot path, where it could
> potentially reveal secrets. This is not an issue for SEV-SNP guests,
> as the CPUID intercept can't be disabled for those.
> 
> Remove the Hypervisor CPUID bit check from the SEV detection code to
> protect against this kind of attack and add a Hypervisor bit equals
> zero check to the SME detection path to prevent non-SEV guests from
> trying to enable SME.
> 
> This handles the following cases:
> 
> 	1) SEV(-ES) guest where CPUID intercept is disabled. The guest
> 	   will still see leaf 0x8000001f and the SEV bit. It can
> 	   retrieve the C-bit and boot normally.
> 
> 	2) Non-SEV guests with intercepted CPUID will check SEV_STATUS
> 	   MSR and find it 0 and will try to enable SME. This will
> 	   fail when the guest finds MSR_K8_SYSCFG to be zero, as it
> 	   is emulated by KVM. But we can't rely on that, as there
> 	   might be other hypervisors which return this MSR with bit
> 	   23 set. The Hypervisor bit check will prevent that the
> 	   guest tries to enable SME in this case.
> 
> 	3) Non-SEV guests on SEV capable hosts with CPUID intercept
> 	   disabled (by a malicious hypervisor) will try to boot into
> 	   the SME path. This will fail, but it is also not considered
> 	   a problem because non-encrypted guests have no protection
> 	   against the hypervisor anyway.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/boot/compressed/mem_encrypt.S |  6 -----
>  arch/x86/kernel/sev-es-shared.c        |  6 +----
>  arch/x86/mm/mem_encrypt_identity.c     | 35 ++++++++++++++------------
>  3 files changed, 20 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
> index aa561795efd1..a6dea4e8a082 100644
> --- a/arch/x86/boot/compressed/mem_encrypt.S
> +++ b/arch/x86/boot/compressed/mem_encrypt.S
> @@ -23,12 +23,6 @@ SYM_FUNC_START(get_sev_encryption_bit)
>  	push	%ecx
>  	push	%edx
>  
> -	/* Check if running under a hypervisor */
> -	movl	$1, %eax
> -	cpuid
> -	bt	$31, %ecx		/* Check the hypervisor bit */
> -	jnc	.Lno_sev
> -
>  	movl	$0x80000000, %eax	/* CPUID to check the highest leaf */
>  	cpuid
>  	cmpl	$0x8000001f, %eax	/* See if 0x8000001f is available */
> diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
> index cdc04d091242..387b71669818 100644
> --- a/arch/x86/kernel/sev-es-shared.c
> +++ b/arch/x86/kernel/sev-es-shared.c
> @@ -186,7 +186,6 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
>  	 * make it accessible to the hypervisor.
>  	 *
>  	 * In particular, check for:
> -	 *	- Hypervisor CPUID bit
>  	 *	- Availability of CPUID leaf 0x8000001f
>  	 *	- SEV CPUID bit.
>  	 *
> @@ -194,10 +193,7 @@ void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
>  	 * can't be checked here.
>  	 */
>  
> -	if ((fn == 1 && !(regs->cx & BIT(31))))
> -		/* Hypervisor bit */
> -		goto fail;
> -	else if (fn == 0x80000000 && (regs->ax < 0x8000001f))
> +	if (fn == 0x80000000 && (regs->ax < 0x8000001f))
>  		/* SEV leaf check */
>  		goto fail;
>  	else if ((fn == 0x8000001f && !(regs->ax & BIT(1))))
> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
> index 6c5eb6f3f14f..a19374d26101 100644
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -503,14 +503,10 @@ void __init sme_enable(struct boot_params *bp)
>  
>  #define AMD_SME_BIT	BIT(0)
>  #define AMD_SEV_BIT	BIT(1)
> -	/*
> -	 * Set the feature mask (SME or SEV) based on whether we are
> -	 * running under a hypervisor.
> -	 */
> -	eax = 1;
> -	ecx = 0;
> -	native_cpuid(&eax, &ebx, &ecx, &edx);
> -	feature_mask = (ecx & BIT(31)) ? AMD_SEV_BIT : AMD_SME_BIT;
> +
> +	/* Check the SEV MSR whether SEV or SME is enabled */
> +	sev_status   = __rdmsr(MSR_AMD64_SEV);
> +	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
>  
>  	/*
>  	 * Check for the SME/SEV feature:
> @@ -530,19 +526,26 @@ void __init sme_enable(struct boot_params *bp)
>  
>  	/* Check if memory encryption is enabled */
>  	if (feature_mask == AMD_SME_BIT) {
> +		/*
> +		 * No SME if Hypervisor bit is set. This check is here to
> +		 * prevent a guest from trying to enable SME. For running as a
> +		 * KVM guest the MSR_K8_SYSCFG will be sufficient, but there
> +		 * might be other hypervisors which emulate that MSR as non-zero
> +		 * or even pass it through to the guest.
> +		 * A malicious hypervisor can still trick a guest into this
> +		 * path, but there is no way to protect against that.
> +		 */
> +		eax = 1;
> +		ecx = 0;
> +		native_cpuid(&eax, &ebx, &ecx, &edx);
> +		if (ecx & BIT(31))
> +			return;
> +
>  		/* For SME, check the SYSCFG MSR */
>  		msr = __rdmsr(MSR_K8_SYSCFG);
>  		if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
>  			return;
>  	} else {
> -		/* For SEV, check the SEV MSR */
> -		msr = __rdmsr(MSR_AMD64_SEV);
> -		if (!(msr & MSR_AMD64_SEV_ENABLED))
> -			return;
> -
> -		/* Save SEV_STATUS to avoid reading MSR again */
> -		sev_status = msr;
> -
>  		/* SEV state cannot be controlled by a command line option */
>  		sme_me_mask = me_mask;
>  		sev_enabled = true;
> 
