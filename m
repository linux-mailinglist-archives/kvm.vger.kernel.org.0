Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D1347746A
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 15:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237947AbhLPOZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 09:25:00 -0500
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:2465
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237924AbhLPOY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 09:24:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxbTwyVCnUSc5Fd9qMRTKSVgGRzUST+trcqIv9B0zKJ/HD+sx5DvP0WjU4gJYLAfs3gKsZ9hp6SI3bE08+7DfpqCz0xD/649majgpO2gcWNUVwV170XD4M+MpHcCtu7hnfTCSic8jf2QQPEMLlIt2il8TC2+8wBMmdF4oFlc0tepxTI/RFtpxYVXRtRooONgd6BWPuo17gYTIbNNMSfcGX2/EwFX8UvCKnuJC1wFVBEL9u2Nc393VkksrpfwvqA4uTSJ4lZ36nE5JOFQd2UsurwCJuG3bmNO3mHbjPvnwIHf9PpXQy+ChG1cJBtaoHPKAEbMO0lUwOm5v8kEYWj6+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbILIOtl8rAbMMlNr7Y7Z8tdqjyPGGMbxQoyuG2p9Q0=;
 b=PEa9Yvfnw6p2r8EILcWu1A67g2f08DOWxTAVuBTTO3MNlRteTt2OFHch8OrkIxZ+pjOc4tYHGe5C2KyLrsTuNxqmJE7YtKGSZDxT7jcOnaHNex8eubVi3gQ77uiaXWpSVrFGgSv8poWF7dxgs+R9LGRAHYh3g602zJs2Bo7oegGeq7AjmlHUjrw9xRQYE1O6xP0jWrbO129ukND8Rl3pPbF0wM8IACNQvbgy4/BRlG/MtBr+eQDcCC4TlfnyNWtvOrK9JADE+ykIBnrSpAPpXShhDcXtRVhJfTSB/z4Dvrpw2knZfJK7l6YWBvpdzoCg24j7iXBEEak3n0laCAPRQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbILIOtl8rAbMMlNr7Y7Z8tdqjyPGGMbxQoyuG2p9Q0=;
 b=dm+siUha7HDvKhznOLqNfg1bpbMdPcjCtzoh8bTg5tS649oE1Fq0tQVqn1sgFt40MGb4JkCePdKF2gzryXXbt55aCdNs6/s0BBJisoBDxl07ilKZXWHBqRvziCEOkmGDVpfXwRaS7imczWFcrFPIATWZR+J+Y9wWZJjho4Lr09Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 14:24:55 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Thu, 16 Dec 2021
 14:24:55 +0000
Subject: Re: [PATCH v3 6/9] x86/smpboot: Support parallel startup of secondary
 CPUs
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Joerg Roedel <joro@8bytes.org>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <20211215145633.5238-7-dwmw2@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d10f529e-b1ee-6220-c6fc-80435f0061ee@amd.com>
Date:   Thu, 16 Dec 2021 08:24:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211215145633.5238-7-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:208:fc::39) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR02CA0026.namprd02.prod.outlook.com (2603:10b6:208:fc::39) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 16 Dec 2021 14:24:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e668578-ca0b-4a3f-4faf-08d9c09fd4b1
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55499C7ABB4E2B6062C2C432EC779@DM6PR12MB5549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44aF2COBOHxiC3QnRqor/6XhKFtzZZvtT+uy40M9cfxCWSji1636+vOdIp/k1JucUVnrTL23t7da3fedvvWS0uNZfTSbpabx0kae7XNRJb4Ge1S8WY7lgFl2cNyYQvuwj087zWuQA0UBF0qQqKFX7tI0T1v22hhvekzqMG/Kzxel1m9gAnx2xT2UCa6hHvDtdyVrPe3tKG+opMuwkuharDMLEuhzS8YyenzRJXhIoxvcZ2LWPRanFZKyrNK/wJUd5DiSCEckuma5/KdZb91kp/5YzquY0EKuME5yc55yXiXXfTlqIGCxVwzo15Jgvlttm9cEkzGDchA24HRg3huJxRjnUo4bmFqyz/N7Vukkmuqo0yZgTUQ1lfCQ8A5dJx5oeUjp2bZNFvnZmv/AOpgzt61zGj6fulkR4wK/rQ3yLImeuU/IWmdo3uGfBb51WmUGek1qTGBu3fN2VBkNORKwAR5rO9AXGWBRkOKUHKe/3BpHOGyhDzirUrVqUh4af0vD5/LpnIuwGAc+wO7ZDysMLlYs4yTTpxP8NcLRDKL9FonqOUWnz4oV2El+/4vfz9HpQd4y2Xo5b8+nWoAw8RyFMb5YSsnTmTs7BgdIDFjx/4cBYWbJ8it3av8FLlQdX11AwD4+CgWUgoAThnWh+RrIhCSHDHzb1dnnFxjncxerpBoqgaJIWL5QZbEp42yzknRf2FVyy1GnZaUrrb10AOoVghjgRRU3gu/gbHrIe6uEwMe7gx4iJHWQd5UDm589+e0J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(4326008)(53546011)(54906003)(110136005)(5660300002)(16576012)(316002)(8676002)(83380400001)(2906002)(26005)(66556008)(66476007)(7416002)(956004)(8936002)(31686004)(66946007)(2616005)(186003)(31696002)(86362001)(6486002)(36756003)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2tWbVk3Z0tzRjdLWGJ1UVNLNjkxdEpoc2lpRm1VRDNxS2VwYkdrK3grci93?=
 =?utf-8?B?SjRhZUlLT3ltVHhvWjMrb3FFdDkwVkFYTmNVMlM5SVE0SkY0dkpaMEpQSmVV?=
 =?utf-8?B?WVZCaDhWcGg3ZnZiUVRZM2JaMzhwWGY0cENETnpuQ1k3Wm5BOVQxd0FPV1pW?=
 =?utf-8?B?eTQvSG4xQlJYNmZRUVZHaVg1cUZUdHcrYmp1cjczTnlDdmJGUUM0L3pyaHRx?=
 =?utf-8?B?UklTT2xQd1NZSExWTFB3OTVEUUlEbjFlcHRoMkVicEFnUFJVa1J1VUY2ZmYx?=
 =?utf-8?B?ZFpyYkQ2a3FHaXBlR0JpM2lIdjc1ZWZubmx1V1BiR0JxdVhma0tTbDdWcHkv?=
 =?utf-8?B?V3RuYzE1NDdOMHhQSXBlZVdiZVJBVWtSNlA0Mkw4YWRhUDZNZWNwOHEwUzk3?=
 =?utf-8?B?QUx6emhYU1dOMGdWWnFQM3BJUFlCSk1JK1pDSVF0ZWtYZE9sOUxLQ2JYT3dv?=
 =?utf-8?B?UDU3WWl5YnBKTVRvR2Q2WVQrOWV2WlQ3VTFpczBHRVNlVHRLNTJTZDk0RjRY?=
 =?utf-8?B?czRxY1U1OTFJODBreWM1TjY2cElvcmxZdS80N0NVOFFVc01CdmQrZCtueXlh?=
 =?utf-8?B?cW5IWm1GVFc3SkczT1pKNnl4MUE4QkpYYlptam95UXUvek5vRllXZzZaSjZH?=
 =?utf-8?B?RUFzQU85NmFMdzVFdFl1WlZkWVRhbjg4UVMrdDZkZVJzdkFONDVhZmlzT3N3?=
 =?utf-8?B?L3J4N0JsaUtvZ0pmMW5ySFRFUjNObG95MkZnaUVtdExVMUovbllOTTdPYzVo?=
 =?utf-8?B?N2VsRDFWbDRoVWo0dGQvUEJOcFFVbGtJa0NtZG1IRWFJaWdpOGw1MktKclZq?=
 =?utf-8?B?dzdJeDh4bHVRYUZJOEJXaXlEM01CTlFQa1U3K1JYZnNRWmRmY0Q2S0owNkhx?=
 =?utf-8?B?NmVYdElmWVV2WDJkd3h1dGcyN3U0aFpmZnQ1ZG9sRUhTODJHbVNXODUzbzVu?=
 =?utf-8?B?R3VDVGorTmQxTjdlUDhiUC85anZEVnlUMEFOanlTMjRYZWovSUI2MDk0anRD?=
 =?utf-8?B?SnZPdGs0c0lhK1AxY3NyeUtlNnMwbFd3RUxOWFVKdEFpTTBBSFgybExTcjBV?=
 =?utf-8?B?VTg1dk9wNDFXYWNLeUZNalNVM0dZVnVkMjh4VFlyQzJkT0NKZ3p5MngwZlBy?=
 =?utf-8?B?NkRNbW9kcHFWUGJwSXZzMC9TNHFZQTNQMmRESHpaK2FNMlQvSW9LVUdsOWFt?=
 =?utf-8?B?ZjRmakZJeTIva0hRTUNWM0YzcHBvY3FlblNXL1NBaEt6RWY4YWo0cWFwQzFy?=
 =?utf-8?B?eFJ1OVI4VnVsak9LRC9VbC9mNStZcE9qdThObnZ0eHV1Ymgwd2hMUUdRSGtO?=
 =?utf-8?B?OGV3K0Z6S3FldGd6V1JSZEdqZGVEd1lrNHovaWhaL0lGa3daMnR3WnB6Ui9u?=
 =?utf-8?B?MmkrS1pkTk5mWHM5ZGFmY0Q0cXc2WGpXVFM4UHhjN3RUZ2ZMWGVZa1p2Z2ha?=
 =?utf-8?B?Z3lZS2hWTktZK2k2YTJqenRZSGgwVi96V0YrczI1bEN1a3l6WndzVjRXVFFE?=
 =?utf-8?B?OHc3SjcwM1FEQ21UeUkrejlpLzFadU1La2R2STZNbjg0K0gwR25iYkEwWlg1?=
 =?utf-8?B?RjJjeHdYSVFta1pxeS9OazZVZEFRZElac3NueEVLMVNpRVFEMjdyUnFubCti?=
 =?utf-8?B?c3NpWHBML0JoMk0xYzUzNFRha0g2UXBNbHhWbXJZNEZLdXJTWmlOaFY1Skhl?=
 =?utf-8?B?V0dSYmRSOThkNjJ0M1RHcWhsZ0U5ZWpYTU1CQ1RHWDNYRG5GSE1HWHlUckJ4?=
 =?utf-8?B?VFpVUGNIaTFKU0o0bElKV0Z5MFhJaGkydXRveFlDQmVqZjRYakxScWNNbzhJ?=
 =?utf-8?B?czFFS2ZMa3p4bEdTTUFuazEvV3JXTlZyaFBKVjFjT28xY0pSQU1lamN1S0Z1?=
 =?utf-8?B?ZHBDQzdQMWluUTdxSHBBZUtxczl6RVRXdUpQMGJNVTNiZEQvdmtaUDdVejZs?=
 =?utf-8?B?UDJSTWllQ0taMC8wbGZTUS80ZFJpWEhHRlpKVW5KT1RtN0IvWEJtRkVwWVpi?=
 =?utf-8?B?LzJUUnB4ckY3TFI3dG1LeU9kZi83d1htek5mR3QzdUl3RWJsRzEvb21zaS9U?=
 =?utf-8?B?YS9tSEdleFBIczQ5YThmbktTRVp0OWFQcG1ReE5uVkNTQitZWHVJRkFJb21s?=
 =?utf-8?B?bURnc3dFLzh6bDJubG0zWGtPeHRBNUd2WFRkaFRlRW9lSGdHSjVlV0tOMTdj?=
 =?utf-8?Q?h7Qb2l/e0KQ+70uzgn3GIzE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e668578-ca0b-4a3f-4faf-08d9c09fd4b1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 14:24:55.1812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q337HZPvDuH1QUs8UsFLwCMnrM9fGzOhh65kHZp7strEULzioN98ID+nNb5z8LlG+qbWQeiIt6MQLnSb+aW8rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5549
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 8:56 AM, David Woodhouse wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
...
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index d8b3ebd2bb85..0249212e23d2 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -25,6 +25,7 @@
>   #include <asm/export.h>
>   #include <asm/nospec-branch.h>
>   #include <asm/fixmap.h>
> +#include <asm/smp.h>
>   
>   /*
>    * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
> @@ -176,6 +177,64 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   1:
>   	UNWIND_HINT_EMPTY
>   
> +	/*
> +	 * Is this the boot CPU coming up? If so everything is available
> +	 * in initial_gs, initial_stack and early_gdt_descr.
> +	 */
> +	movl	smpboot_control(%rip), %eax
> +	testl	%eax, %eax
> +	jz	.Lsetup_cpu
> +
> +	/*
> +	 * Secondary CPUs find out the offsets via the APIC ID. For parallel
> +	 * boot the APIC ID is retrieved from CPUID, otherwise it's encoded
> +	 * in smpboot_control:
> +	 * Bit 0-15	APICID if STARTUP_USE_CPUID_0B is not set
> +	 * Bit 16 	Secondary boot flag
> +	 * Bit 17	Parallel boot flag
> +	 */
> +	testl	$STARTUP_USE_CPUID_0B, %eax
> +	jz	.Lsetup_AP
> +
> +	mov	$0x0B, %eax
> +	xorl	%ecx, %ecx
> +	cpuid

This will break an SEV-ES guest because CPUID will generate a #VC and a 
#VC handler has not been established yet.

I guess for now, you can probably just not enable parallel startup for 
SEV-ES guests.

Thanks,
Tom


> +	mov	%edx, %eax
> +
> +.Lsetup_AP:
> +	/* EAX contains the APICID of the current CPU */
> +	andl	$0xFFFF, %eax
> +	xorl	%ecx, %ecx
> +	leaq	cpuid_to_apicid(%rip), %rbx
> +
> +.Lfind_cpunr:
> +	cmpl	(%rbx), %eax
> +	jz	.Linit_cpu_data
> +	addq	$4, %rbx
> +	addq	$8, %rcx
> +	jmp	.Lfind_cpunr
> +
> +.Linit_cpu_data:
> +	/* Get the per cpu offset */
> +	leaq	__per_cpu_offset(%rip), %rbx
> +	addq	%rcx, %rbx
> +	movq	(%rbx), %rbx
> +	/* Save it for GS BASE setup */
> +	movq	%rbx, initial_gs(%rip)
> +
> +	/* Calculate the GDT address */
> +	movq	$gdt_page, %rcx
> +	addq	%rbx, %rcx
> +	movq	%rcx, early_gdt_descr_base(%rip)
> +
> +	/* Find the idle task stack */
> +	movq	$idle_threads, %rcx
> +	addq	%rbx, %rcx
> +	movq	(%rcx), %rcx
> +	movq	TASK_threadsp(%rcx), %rcx
> +	movq	%rcx, initial_stack(%rip)
> +
> +.Lsetup_cpu:
>   	/*
>   	 * We must switch to a new descriptor in kernel space for the GDT
>   	 * because soon the kernel won't have access anymore to the userspace
> @@ -216,6 +275,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
>   	 */
>   	movq initial_stack(%rip), %rsp
>   
> +	/* Drop the realmode protection. For the boot CPU the pointer is NULL! */
> +	movq	trampoline_lock(%rip), %rax
> +	testq	%rax, %rax
> +	jz	.Lsetup_idt
> +	lock
> +	btrl	$0, (%rax)
> +
> +.Lsetup_idt:
>   	/* Setup and Load IDT */
>   	pushq	%rsi
>   	call	early_setup_idt
> @@ -347,6 +414,7 @@ SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
>    * reliably detect the end of the stack.
>    */
>   SYM_DATA(initial_stack, .quad init_thread_union + THREAD_SIZE - FRAME_SIZE)
> +SYM_DATA(trampoline_lock, .quad 0);
>   	__FINITDATA
>   
>   	__INIT
> @@ -572,6 +640,9 @@ SYM_DATA_END(level1_fixmap_pgt)
>   SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
>   SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
>   
> +	.align 16
> +SYM_DATA(smpboot_control,		.long 0)
> +
>   	.align 16
>   /* This must match the first entry in level2_kernel_pgt */
>   SYM_DATA(phys_base, .quad 0x0)
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 7a763b84b6e5..1e38d44c3603 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1104,9 +1104,19 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
>   	unsigned long boot_error = 0;
>   
>   	idle->thread.sp = (unsigned long)task_pt_regs(idle);
> -	early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
>   	initial_code = (unsigned long)start_secondary;
> -	initial_stack  = idle->thread.sp;
> +
> +	if (IS_ENABLED(CONFIG_X86_32)) {
> +		early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
> +		initial_stack  = idle->thread.sp;
> +	} else if (boot_cpu_data.cpuid_level < 0x0B) {
> +		/* Anything with X2APIC should have CPUID leaf 0x0B */
> +		if (WARN_ON_ONCE(x2apic_mode) && apicid > 0xffff)
> +			return -EIO;
> +		smpboot_control = apicid | STARTUP_USE_APICID;
> +	} else {
> +		smpboot_control = STARTUP_USE_CPUID_0B;
> +	}
>   
>   	/* Enable the espfix hack for this CPU */
>   	init_espfix_ap(cpu);
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index 4a3da7592b99..7dc2e817bd02 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -127,6 +127,9 @@ static void __init setup_real_mode(void)
>   
>   	trampoline_header->flags = 0;
>   
> +	trampoline_lock = &trampoline_header->lock;
> +	*trampoline_lock = 0;
> +
>   	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
>   	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
>   	trampoline_pgd[511] = init_top_pgt[511].pgd;
> diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
> index cc8391f86cdb..12a540904e80 100644
> --- a/arch/x86/realmode/rm/trampoline_64.S
> +++ b/arch/x86/realmode/rm/trampoline_64.S
> @@ -49,6 +49,19 @@ SYM_CODE_START(trampoline_start)
>   	mov	%ax, %es
>   	mov	%ax, %ss
>   
> +	/*
> +	 * Make sure only one CPU fiddles with the realmode stack
> +	 */
> +.Llock_rm:
> +	btl	$0, tr_lock
> +	jnc	2f
> +	pause
> +	jmp	.Llock_rm
> +2:
> +	lock
> +	btsl	$0, tr_lock
> +	jc	.Llock_rm
> +
>   	# Setup stack
>   	movl	$rm_stack_end, %esp
>   
> @@ -192,6 +205,7 @@ SYM_DATA_START(trampoline_header)
>   	SYM_DATA(tr_efer,		.space 8)
>   	SYM_DATA(tr_cr4,		.space 4)
>   	SYM_DATA(tr_flags,		.space 4)
> +	SYM_DATA(tr_lock,		.space 4)
>   SYM_DATA_END(trampoline_header)
>   
>   #include "trampoline_common.S"
> diff --git a/kernel/smpboot.c b/kernel/smpboot.c
> index f6bc0bc8a2aa..934e64ff4eed 100644
> --- a/kernel/smpboot.c
> +++ b/kernel/smpboot.c
> @@ -25,7 +25,7 @@
>    * For the hotplug case we keep the task structs around and reuse
>    * them.
>    */
> -static DEFINE_PER_CPU(struct task_struct *, idle_threads);
> +DEFINE_PER_CPU(struct task_struct *, idle_threads);
>   
>   struct task_struct *idle_thread_get(unsigned int cpu)
>   {
> 
