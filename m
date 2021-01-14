Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9464C2F6D05
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbhANVSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:18:31 -0500
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:28577
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbhANVSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:18:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEEUySfSyr/oOktOuR3dfrinYl5lVvNZng/oR2fI/vC8s1IrUwum/3YUwCMOMhoM21QsRbxOTcYQ8PhaBIJhXANRasdtM3f52AON4ABkPYboZ98Ffg53enUshkmPnV6Xv8rsKuquNs79lp5SyHvFlNyny5TfIAn8qSCWifeYqMGEDoubJPKN/WvoiY2+CoBWFm3OK+sSb7/v185m1qVmP0GXGKrornvq+RGXhjlXnm6SJU+K2AVNDdRMxtddYp5iMS7A6TGlHEyXvJ5d1DZYk0zJL2v13LwCLHNSu4sqaAqricjSZqRvqeU/0Y3LaFtsFGPhI3cYBuev79qMMJBtGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7uYv3mhl3PycKiPi03c0lN4sIV235mUsC4USsWU7jc=;
 b=JSDqpaNZrzxOqOp4U0+G2WH1kev/Kbclk2DW0OdTou3pNu5hKNe0YZR4n3m1MRluoVwFk6txjYau9DWEUsoGdK7YJGk3sC/dCQqmrwMO0gTNoKaADjmJBCa5IweGuzXa7dP5mC7arTyknD0/ioqJyecLC4V12Dxou2HS4zay1nq+oh1+kjQQaRC7Ii4HGaFJtoWL92GHw11eYeZQi+pReFYXcZzO9yZi7irht7xyww/les6EyZFkFq0aDen3Qr5XT4xiSzirqkqcuJwtuHnAN8d5oQlwWlXHXka77fltIVCLxNU9jlM1kGzgSiYppOMeqgMXHQzTreIjCG1n0zeZPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7uYv3mhl3PycKiPi03c0lN4sIV235mUsC4USsWU7jc=;
 b=3tFEHarwSxeDIQUQQgutNN4jlLPm1xo3kwdIG2+QE36Qm/rKVv5WDuP4JJc8tjuiJRzOZtcNIhlULkCIv/ZKo8JDjbTpBeEGhiSkBT58CShzqxTQu7Ze5D83ct4G8fQWKZToPt9qFOMMN5RQmFMXK8FZ01NXv+J+bpf5L7Kxrq0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2768.namprd12.prod.outlook.com (2603:10b6:805:72::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 14 Jan
 2021 21:17:36 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:17:36 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 04/14] x86/cpufeatures: Assign dedicated feature word
 for AMD mem encryption
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-5-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <41a8eb41-eefc-70d7-c91e-18a1b2453dcf@amd.com>
Date:   Thu, 14 Jan 2021 15:17:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-5-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:806:23::28) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR13CA0083.namprd13.prod.outlook.com (2603:10b6:806:23::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.6 via Frontend Transport; Thu, 14 Jan 2021 21:17:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8331bb58-f0f1-4f0b-1c6a-08d8b8d1d0e6
X-MS-TrafficTypeDiagnostic: SN6PR12MB2768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2768A701CD686757999F8B5EE5A80@SN6PR12MB2768.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4d0P3jPWzvd7k0KIRKOAsxx8sRMhz4ZXPUT8aPTGgpfOhWda8cA5VzOJphCtOqye5SWS52BGgl6TEs0KbDAbyDS2jQ7jFDE18cZUuTUvSZ6WlgBqFYggugYOSL3imoJvYukEBkOUPSW3vQvrlQopKssmKMhh9uPgoMeLhj8I0sX53QqGD8EQTIGRohK6oTjQQqQSEuWw8ba/ALL7/2Tvha8z7z+faEHbnMUue6QzS4GdjLTsQJDpyXf/FVCojo/+vnBPLteslQGulRH+NMH3bnWNWkN1BLSAZie35AM7HLCNLZfPRzQ/ya4ORwpebRDhpa6Hk4jL6r94QAeITm0hye/eUhI/1aKGRlvHzCIQXpkaDFgzF/TvCorrz7yaSkLbkndO9rzxtWa5X1/lPcBoA8CwAbFpaXG9kfpFMTrky96mOMq/MYZ/BZEfThqZQSHMpFQggCM2mQyLzYKAaZRy0R870Hfvv30AhYTuf9cSeXI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(2906002)(8936002)(66556008)(6486002)(53546011)(16526019)(186003)(5660300002)(66946007)(52116002)(110136005)(8676002)(6512007)(6506007)(31686004)(956004)(478600001)(2616005)(4326008)(83380400001)(36756003)(7416002)(86362001)(26005)(316002)(44832011)(54906003)(31696002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z0NLUjdQclU2bnZhZUNBOTkxSjJ1OGp5N1hPa05oTkl0SjNmM2RkK1VvUHlo?=
 =?utf-8?B?NDJDck01Ri9yVG9jQ0RXc09EZ0h1Y3ZacmR5NENtSkg5aFJsZVN2QXBiSWZZ?=
 =?utf-8?B?Ny9pdERCdFB4aW13KzF2ZUUwSlQ5cHBabVU1d1BLWlV2TFhma3NSNHNQdFRz?=
 =?utf-8?B?eHZobTBPS3ZReEhyR1BhWTZ2eU5KUkNPNzMwK2tWMk11ZTVMenNwN1dLNVoz?=
 =?utf-8?B?RTlCd2EzbEJXZHlpd3N2ZFdMQ1FPa0hwTElvaXZHeHNoMC9rTzU0MUhWSjgw?=
 =?utf-8?B?bXZ5RGEvaCtsRzBoZFU5LzdXaDJxS0dFY3lEYWRZb1FSV2s1N2F4MkFmdG5C?=
 =?utf-8?B?di8xa1FoSWs4UFBDaENlMDZwdWJHK2o2MTdZNndQV2htRDdqbDl5Tkd6QWhz?=
 =?utf-8?B?YmQvalc4REx3VTV4bjNnMnFFTk8wUXgwbjdPQXQ5RlQ4bm1KRUFLYlFvU1BS?=
 =?utf-8?B?RU5GTGhHL0UxN2ZQTjVMR1o0Tzd5TExrM1lEV2diT3FTL0lZVnBJa2dFeGdI?=
 =?utf-8?B?UVZqWENiTlNtaVl0N3RremNWYlBVSGZKcUxnTktuU3NhTDlXZkVGUENpQmMr?=
 =?utf-8?B?V1dFMHpkNnhUQmhyNXFWcHFma3ZWd21VT1ZqZE1LVTB5TlZCRE02bHNJc0Zh?=
 =?utf-8?B?QWZWRUFrcVpTMVNuL1pmSmk5NkJkQ25vOGlnczQreXNON09FeldPeWVqenUv?=
 =?utf-8?B?VEJ6SlpVUGVvTytpeXVGaFcxaDZGaHJMeWYvcE5DRXhOKzBRZmlzTFpUbWQv?=
 =?utf-8?B?NTlRQVdmZ1dCUDdvaWxxdE1HRGlMUFcyVU54Wm4yVmtXYUkyMmJtY000b1Fz?=
 =?utf-8?B?Um1YNnphS20xTVd0Q3AzaitKeUZ1bzladHRtRU13cTdHakpsbTVLZVBaR0Q5?=
 =?utf-8?B?c2tIbUVpUm1vTDFLWFE4NWV3bll4ck9ZR3lpODVLcGQ3RDdUeERhRkM0SXk0?=
 =?utf-8?B?SWdFUnl1ci80b0Nqdm55SHlhbndFMWcyZXNJcWZRbE5QdSthNnVoL1VWcE5R?=
 =?utf-8?B?djNkaTNKMFcwejBoaXl2Vk41Nm9NN016SUlOVVhydVcwck12Tkh0aUkvdGUy?=
 =?utf-8?B?bXpTV3JGSTU4MXBhODd4ZFRvcmFhMGN3VXJyZmVDVzkvRDY3amk2eW9RUExy?=
 =?utf-8?B?TnhMUGxFeEFIZFFVczlLTHQrTXp2b0RSNkhWdHpGVGl6QnJwOEZoRm9RL2k5?=
 =?utf-8?B?M1hBUG9JdWw1ZDZZOU5VNHlWbmcwRmhYdzlTNGVET0dzMHNVSkt1eVJKbVFQ?=
 =?utf-8?B?dXhPMThUMVprMkJ2R1pyUWhhb200amN4MDJXOVBsY1JKeG1tdVpVb2pIeEtv?=
 =?utf-8?Q?fRntPnbpAs/03btq03fLZniMYG6To3zt/g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:17:36.3953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 8331bb58-f0f1-4f0b-1c6a-08d8b8d1d0e6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNZiKsHmTjgYLoo5rP8o3hIZrQR/XYomvYSm7GyWzcNagBfLa52UM1QPISpNvYHWquVzTkiUnee8YwxUakK6iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2768
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:36 PM, Sean Christopherson wrote:
> Collect the scattered SME/SEV related feature flags into a dedicated
> word.  There are now five recognized features in CPUID.0x8000001F.EAX,
> with at least one more on the horizon (SEV-SNP).  Using a dedicated word
> allows KVM to use its automagic CPUID adjustment logic when reporting
> the set of supported features to userspace.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/cpufeature.h              |  7 +++++--
>  arch/x86/include/asm/cpufeatures.h             | 17 +++++++++++------
>  arch/x86/include/asm/disabled-features.h       |  3 ++-
>  arch/x86/include/asm/required-features.h       |  3 ++-
>  arch/x86/kernel/cpu/common.c                   |  3 +++
>  arch/x86/kernel/cpu/scattered.c                |  5 -----
>  tools/arch/x86/include/asm/disabled-features.h |  3 ++-
>  tools/arch/x86/include/asm/required-features.h |  3 ++-
>  8 files changed, 27 insertions(+), 17 deletions(-)

Thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

>
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 59bf91c57aa8..1728d4ce5730 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -30,6 +30,7 @@ enum cpuid_leafs
>  	CPUID_7_ECX,
>  	CPUID_8000_0007_EBX,
>  	CPUID_7_EDX,
> +	CPUID_8000_001F_EAX,
>  };
>  
>  #ifdef CONFIG_X86_FEATURE_NAMES
> @@ -88,8 +89,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 16, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
> +	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 19, feature_bit) ||	\
>  	   REQUIRED_MASK_CHECK					  ||	\
> -	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
> +	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
>  
>  #define DISABLED_MASK_BIT_SET(feature_bit)				\
>  	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
> @@ -111,8 +113,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 16, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
> +	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 19, feature_bit) ||	\
>  	   DISABLED_MASK_CHECK					  ||	\
> -	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
> +	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
>  
>  #define cpu_has(c, bit)							\
>  	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 9f9e9511f7cd..7c0bb1a20050 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -13,7 +13,7 @@
>  /*
>   * Defines x86 CPU feature bits
>   */
> -#define NCAPINTS			19	   /* N 32-bit words worth of info */
> +#define NCAPINTS			20	   /* N 32-bit words worth of info */
>  #define NBUGINTS			1	   /* N 32-bit bug flags */
>  
>  /*
> @@ -96,7 +96,7 @@
>  #define X86_FEATURE_SYSCALL32		( 3*32+14) /* "" syscall in IA32 userspace */
>  #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
>  #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
> -#define X86_FEATURE_SME_COHERENT	( 3*32+17) /* "" AMD hardware-enforced cache coherency */
> +/* FREE!                                ( 3*32+17) */
>  #define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
>  #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
>  #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
> @@ -201,7 +201,7 @@
>  #define X86_FEATURE_INVPCID_SINGLE	( 7*32+ 7) /* Effectively INVPCID && CR4.PCIDE=1 */
>  #define X86_FEATURE_HW_PSTATE		( 7*32+ 8) /* AMD HW-PState */
>  #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
> -#define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
> +/* FREE!                                ( 7*32+10) */
>  #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
>  #define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
>  #define X86_FEATURE_RETPOLINE_AMD	( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
> @@ -211,7 +211,7 @@
>  #define X86_FEATURE_SSBD		( 7*32+17) /* Speculative Store Bypass Disable */
>  #define X86_FEATURE_MBA			( 7*32+18) /* Memory Bandwidth Allocation */
>  #define X86_FEATURE_RSB_CTXSW		( 7*32+19) /* "" Fill RSB on context switches */
> -#define X86_FEATURE_SEV			( 7*32+20) /* AMD Secure Encrypted Virtualization */
> +/* FREE!                                ( 7*32+20) */
>  #define X86_FEATURE_USE_IBPB		( 7*32+21) /* "" Indirect Branch Prediction Barrier enabled */
>  #define X86_FEATURE_USE_IBRS_FW		( 7*32+22) /* "" Use IBRS during runtime firmware calls */
>  #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* "" Disable Speculative Store Bypass. */
> @@ -236,8 +236,6 @@
>  #define X86_FEATURE_EPT_AD		( 8*32+17) /* Intel Extended Page Table access-dirty bit */
>  #define X86_FEATURE_VMCALL		( 8*32+18) /* "" Hypervisor supports the VMCALL instruction */
>  #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
> -#define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
> -#define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
>  #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
> @@ -383,6 +381,13 @@
>  #define X86_FEATURE_CORE_CAPABILITIES	(18*32+30) /* "" IA32_CORE_CAPABILITIES MSR */
>  #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store Bypass Disable */
>  
> +/* AMD-defined memory encryption features, CPUID level 0x8000001f (EAX), word 19 */
> +#define X86_FEATURE_SME			(19*32+ 0) /* AMD Secure Memory Encryption */
> +#define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
> +#define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
> +#define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
> +
>  /*
>   * BUG word(s)
>   */
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index 5861d34f9771..2216077676c8 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -85,6 +85,7 @@
>  			 DISABLE_ENQCMD)
>  #define DISABLED_MASK17	0
>  #define DISABLED_MASK18	0
> -#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
> +#define DISABLED_MASK19	0
> +#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_DISABLED_FEATURES_H */
> diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
> index 3ff0d48469f2..b2d504f11937 100644
> --- a/arch/x86/include/asm/required-features.h
> +++ b/arch/x86/include/asm/required-features.h
> @@ -101,6 +101,7 @@
>  #define REQUIRED_MASK16	0
>  #define REQUIRED_MASK17	0
>  #define REQUIRED_MASK18	0
> -#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
> +#define REQUIRED_MASK19	0
> +#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_REQUIRED_FEATURES_H */
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 35ad8480c464..9215b91bc044 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -960,6 +960,9 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
>  	if (c->extended_cpuid_level >= 0x8000000a)
>  		c->x86_capability[CPUID_8000_000A_EDX] = cpuid_edx(0x8000000a);
>  
> +	if (c->extended_cpuid_level >= 0x8000001f)
> +		c->x86_capability[CPUID_8000_001F_EAX] = cpuid_eax(0x8000001f);
> +
>  	init_scattered_cpuid_features(c);
>  	init_speculation_control(c);
>  
> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
> index 236924930bf0..972ec3bfa9c0 100644
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -40,11 +40,6 @@ static const struct cpuid_bit cpuid_bits[] = {
>  	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
>  	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
>  	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
> -	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
> -	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
> -	{ X86_FEATURE_SEV_ES,		CPUID_EAX,  3, 0x8000001f, 0 },
> -	{ X86_FEATURE_SME_COHERENT,	CPUID_EAX, 10, 0x8000001f, 0 },
> -	{ X86_FEATURE_VM_PAGE_FLUSH,	CPUID_EAX,  2, 0x8000001f, 0 },
>  	{ 0, 0, 0, 0, 0 }
>  };
>  
> diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
> index 5861d34f9771..2216077676c8 100644
> --- a/tools/arch/x86/include/asm/disabled-features.h
> +++ b/tools/arch/x86/include/asm/disabled-features.h
> @@ -85,6 +85,7 @@
>  			 DISABLE_ENQCMD)
>  #define DISABLED_MASK17	0
>  #define DISABLED_MASK18	0
> -#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
> +#define DISABLED_MASK19	0
> +#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_DISABLED_FEATURES_H */
> diff --git a/tools/arch/x86/include/asm/required-features.h b/tools/arch/x86/include/asm/required-features.h
> index 3ff0d48469f2..b2d504f11937 100644
> --- a/tools/arch/x86/include/asm/required-features.h
> +++ b/tools/arch/x86/include/asm/required-features.h
> @@ -101,6 +101,7 @@
>  #define REQUIRED_MASK16	0
>  #define REQUIRED_MASK17	0
>  #define REQUIRED_MASK18	0
> -#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
> +#define REQUIRED_MASK19	0
> +#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_REQUIRED_FEATURES_H */
